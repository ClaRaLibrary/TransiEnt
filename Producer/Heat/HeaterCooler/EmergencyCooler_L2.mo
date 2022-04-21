within TransiEnt.Producer.Heat.HeaterCooler;
model EmergencyCooler_L2 "Emergency cooler, e.g. if return temperature to an aperature is too high."



//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-BSD-clause.           //
// Copyright 2021, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE, ResiliEntEE, IntegraNet and IntegraNet II are research projects  //
// supported by the German Federal Ministry of Economics and Energy               //
// (FKZ 03ET4003, 03ET4048, 0324027 and 03EI1008).                                //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Fraunhofer Institute for Environmental, Safety, and Energy Technology UMSICHT, //
// Gas- und Wärme-Institut Essen						  //
// and                                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//





  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

import TransiEnt;
extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

parameter TILMedia.VLEFluidTypes.BaseVLEFluid Medium = simCenter.fluid1 "Medium in the component";
parameter SI.Temperature T_max=340 "Turn on threshold";
parameter SI.Temperature T_off=330 "Cooler turn off threshold";
parameter SI.Temperature T_stor_max=368.15 "Maximum storage temperature";
parameter SI.MassFlowRate m_flow_nom=simCenter.m_flow_nom;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

Boolean switch;
Boolean switch_stor;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn fpReturnIn(Medium=Medium) annotation (Placement(transformation(extent={{110,-90},{90,-70}}), iconTransformation(extent={{-110,72},{-90,92}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut fpReturnOut(Medium=Medium) annotation (Placement(transformation(extent={{-90,-90},{-110,-70}}), iconTransformation(extent={{90,70},{110,90}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn fpSupplyIn annotation (Placement(transformation(extent={{-110,30},{-90,50}}), iconTransformation(extent={{90,-90},{110,-70}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut fpSupplyOut(Medium=Medium) annotation (Placement(transformation(extent={{90,30},{110,50}}), iconTransformation(extent={{-110,-88},{-90,-68}})));
  TransiEnt.Basics.Interfaces.General.TemperatureIn T_stor_in "Input for temperature stored in cooler" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100}), iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={0,-78})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  ClaRa.Components.HeatExchangers.IdealShell_L2 returnHeatExchanger(
    medium=Medium,
    p_start=simCenter.p_nom[1],
    h_start=50*4200,
    p_nom=simCenter.p_nom[1],
    z_in=1,
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2,
    m_flow_nom=m_flow_nom) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={0,-80})));

  TransiEnt.Components.Sensors.TemperatureSensor temperatureReturnIn annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={80,-50})));
Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow returnCooler(Q_flow(
        start=0))
  annotation (Placement(transformation(
      extent={{10,10},{-10,-10}},
      rotation=90,
      origin={0,-30})));

  TransiEnt.Components.Sensors.TemperatureSensor temperatureSupplyIn annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-84,68})));
Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow supplyCooler(Q_flow(
        start=0))
  annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={0,14})));

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
ClaRa.Components.HeatExchangers.IdealShell_L2 returnHeatExchanger1(
    medium=Medium,
    h_start=50*4200,
    p_nom=simCenter.p_nom[1],
    m_flow_nom=m_flow_nom,
    p_start=simCenter.p_nom[2])
  annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=180,
      origin={0,40})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  //Hysteresis
  switch=  temperatureReturnIn.T_celsius > T_max or pre(switch) and temperatureReturnIn.T_celsius >= T_off;
  switch_stor = T_stor_in > T_stor_max or pre(switch_stor) and T_stor_in >= simCenter.heatingCurve.T_supply;

  if switch_stor then
    //We don't want any Q_flow
    returnCooler.Q_flow=fpReturnIn.m_flow*4200*(T_max-temperatureReturnIn.T_celsius);
    supplyCooler.Q_flow=fpReturnIn.m_flow*4200*(T_max-temperatureSupplyIn.T_celsius);
  elseif switch then
    returnCooler.Q_flow=fpReturnIn.m_flow*4200*(T_max-temperatureReturnIn.T_celsius);
    supplyCooler.Q_flow=0;
  else
    returnCooler.Q_flow=0;
    supplyCooler.Q_flow=0;
  end if;

//Power is substracted from cogenerated Energy
  collectHeatingPower.heatFlowCollector.Q_flow=returnCooler.Q_flow+supplyCooler.Q_flow;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(collectHeatingPower.heatFlowCollector,modelStatistics.heatFlowCollector[3]);

  connect(temperatureReturnIn.port, fpReturnIn)
                                               annotation (Line(
      points={{80,-60},{100,-60},{100,-80}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(returnHeatExchanger.heat, returnCooler.port)         annotation (Line(
      points={{0,-70},{0,-40},{-6.66134e-016,-40}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(fpReturnOut, fpReturnOut)
                                annotation (Line(
      points={{-100,-80},{-100,-80}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(returnHeatExchanger.inlet, fpReturnIn)
                                     annotation (Line(
      points={{10,-80},{100,-80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(returnHeatExchanger.outlet, fpReturnOut)
                                       annotation (Line(
      points={{-10,-80},{-100,-80}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(fpReturnIn, fpReturnIn) annotation (Line(
      points={{100,-80},{100,-80}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(temperatureSupplyIn.port, fpSupplyIn)
                                               annotation (Line(
      points={{-84,58},{-100,58},{-100,40}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(fpSupplyOut, fpSupplyOut)
                                annotation (Line(
      points={{100,40},{100,40}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(fpSupplyIn, returnHeatExchanger1.inlet) annotation (Line(
      points={{-100,40},{-10,40}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(fpSupplyOut, returnHeatExchanger1.outlet) annotation (Line(
      points={{100,40},{10,40}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(returnHeatExchanger1.heat, supplyCooler.port) annotation (Line(
      points={{-1.22125e-015,30},{0,30},{0,24},{5.55112e-016,24}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
      Line(
        origin={-53.5,13.667},
        points={{-2.5,-91.6667},{17.5,-71.6667},{-22.5,-51.6667},{17.5,-31.6667},
            {-22.5,-11.667},{17.5,8.3333},{-2.5,28.3333},{-2.5,48.3333}},
        smooth=Smooth.Bezier),
      Polygon(
        origin={-56,50.333},
        fillPattern=FillPattern.Solid,
        points={{0.0,21.667},{-10.0,-8.333},{10.0,-8.333}}),
      Line(
        origin={-3.5,13.667},
        points={{-2.5,-91.6667},{17.5,-71.6667},{-22.5,-51.6667},{17.5,-31.6667},
            {-22.5,-11.667},{17.5,8.3333},{-2.5,28.3333},{-2.5,48.3333}},
        smooth=Smooth.Bezier),
      Polygon(
        origin={-6,50.333},
        fillPattern=FillPattern.Solid,
        points={{0.0,21.667},{-10.0,-8.333},{10.0,-8.333}}),
      Line(
        origin={46.5,13.667},
        points={{-2.5,-91.6667},{17.5,-71.6667},{-22.5,-51.6667},{17.5,-31.6667},
            {-22.5,-11.667},{17.5,8.3333},{-2.5,28.3333},{-2.5,48.3333}},
        smooth=Smooth.Bezier),
      Polygon(
        origin={44,50.333},
        fillPattern=FillPattern.Solid,
        points={{0.0,21.667},{-10.0,-8.333},{10.0,-8.333}})}),
        Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Emergency cooler, e.g. if return temperature to an aperature is too high.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>L2 (defined in the CodingConventions)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>TransiEnt.Basics.Interfaces.Thermal.FluidPortIn: fpReturnIn</p>
<p>TransiEnt.Basics.Interfaces.Thermal.FluidPortOut: fpReturnOut</p>
<p>TransiEnt.Basics.Interfaces.Thermal.FluidPortIn: fpSupplyIn</p>
<p>TransiEnt.Basics.Interfaces.Thermal.FluidPortOut: fpSupplyOut</p>
<p>TransiEnt.Basics.Interfaces.General.TemperatureIn: T_stor_in (input for the temperature stored in cooler)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Arne Koeppen (arne.koeppen@tuhh.de), Jun 2013</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Aug 2013</p>
</html>"));
end EmergencyCooler_L2;
