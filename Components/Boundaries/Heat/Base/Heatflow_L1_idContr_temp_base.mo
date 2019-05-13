within TransiEnt.Components.Boundaries.Heat.Base;
partial model Heatflow_L1_idContr_temp_base "Base class for heat flow boundaries with ideal control to get a given outlet temperature"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE and ResiliEntEE are research projects supported by the German     //
// Federal Ministry of Economics and Energy (FKZ 03ET4003 and 03ET4048).          //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Institute of Electrical Power Systems and Automation                           //
// (Hamburg University of Technology)                                             //
// and is supported by                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Model;
  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.fluid1 "Medium to be used" annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter Boolean use_varTemp=false "true if variable temperature input should be used" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.Temperature T_out_set_const=46 + 273.15 "Constant outlet set temperature" annotation(Dialog(group="Fundamental Definitions",enable=not use_varTemp));

  parameter TransiEnt.Basics.Types.TypeOfResource typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Consumer "Select the kind of resource" annotation (Dialog(group="Statistics"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn fluidPortIn(Medium=medium) annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut fluidPortOut(Medium=medium) annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
  TransiEnt.Basics.Interfaces.General.TemperatureIn T_out_set(value=T_out_set_in) if use_varTemp "Setpoint value of the output temperature" annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100}), iconTransformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TILMedia.VLEFluid_pT fluidOut(
    vleFluidType=medium,
    p=fluidPortOut.p,
    T=T_out_set_in) annotation (Placement(transformation(extent={{30,-80},{50,-60}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=typeOfResource)                                 annotation (Placement(transformation(extent={{60,-100},{80,-80}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.Temperature T_out_set_in;
  SI.HeatFlowRate Q_flow;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  if not use_varTemp then
    T_out_set_in=T_out_set_const;
  end if;

  fluidPortIn.m_flow+fluidPortOut.m_flow=0;
  fluidPortIn.h_outflow=inStream(fluidPortOut.h_outflow);
  fluidPortOut.h_outflow=fluidOut.h;

  collectHeatingPower.heatFlowCollector.Q_flow=Q_flow;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(modelStatistics.heatFlowCollector[TransiEnt.Basics.Types.TypeOfResource.Consumer],collectHeatingPower.heatFlowCollector);

   annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{-40,14},{-40,58},{40,58},{40,-100}},
          color={175,0,0},
          thickness=0.5),          Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{0,-40},{80,40}},
          startAngle=0,
          endAngle=360),
        Polygon(
          points={{-10,2},{-10,-6},{-2,-2},{-10,2}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={42,14},
          rotation=270),
        Rectangle(
          extent={{-8,1},{8,-1}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={40,32},
          rotation=270),
        Rectangle(
          extent={{-8,1},{8,-1}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={8,0},
          rotation=360),
        Polygon(
          points={{-10,2},{-10,-6},{-2,-2},{-10,2}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={26,2},
          rotation=360),
        Polygon(
          points={{-10,2},{-10,-6},{-2,-2},{-10,2}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={38,-14},
          rotation=90),
        Rectangle(
          extent={{-8,1},{8,-1}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={40,-32},
          rotation=270),
        Polygon(
          points={{-10,2},{-10,-6},{-2,-2},{-10,2}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={54,-2},
          rotation=180),
        Rectangle(
          extent={{-8,1},{8,-1}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={72,0},
          rotation=360),
        Line(points={{-152,84}}, color={28,108,200}),
        Line(
          points={{-40,-100},{-40,-18}},
          color={175,0,0},
          thickness=0.5)}),                                       Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is a base&nbsp;class&nbsp;for&nbsp;heat&nbsp;flow&nbsp;boundaries&nbsp;with&nbsp;ideal&nbsp;control&nbsp;to&nbsp;get&nbsp;a&nbsp;given&nbsp;outlet&nbsp;temperature. It can be chosen if the outlet set temperature is constant or given by an input.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>There is no volume considered.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>This model is only valid for ideal controls, i.e. ideally tuned controls with no control errors.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>T_out_set: set point for outlet temperature</p>
<p>waterPortIn: inlet for fluid</p>
<p>waterPortOut: outlet for fluid</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Nov 2018</p>
</html>"));
end Heatflow_L1_idContr_temp_base;
