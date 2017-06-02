within TransiEnt.Producer.Heat.Power2Heat;
model ElectricBoiler "Electric Boiler with constant efficiency, spatial resolution can be chosen to be 0d or 1d"
  import TransiEnt;

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  outer ModelStatistics modelStatistics;
  // _____________________________________________
  //
  //                Parameters
  // _____________________________________________

  final parameter Modelica.SIunits.Power P_el_n = Q_flow_n/eta "Nominal electric power";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_n = 100e3 "Nominal thermal power";
  parameter Modelica.SIunits.Efficiency eta=0.95;
  replaceable model ProducerCosts =
      TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.P2H
    constrainedby TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PartialPowerPlantCostSpecs                                                                                             annotation (Dialog(group="Statistics"), __Dymola_choicesAllMatching=true);

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium= simCenter.fluid1 "Medium to be used"
                         annotation(choicesAllMatching, Dialog(group="Fluid Definition"));

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(extent={{-10,88},{10,108}}), iconTransformation(extent={{-10,-110},{10,-90}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn inlet(Medium=medium) annotation (Placement(transformation(extent={{92,-50},{112,-30}}), iconTransformation(extent={{-108,-10},{-88,10}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut outlet(Medium=medium) annotation (Placement(transformation(extent={{90,40},{110,60}}), iconTransformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput Q_flow_set "Setpoint for thermal heat"
    annotation (Placement(transformation(extent={{-114,-10},{-94,10}}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,100})));

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

public
  replaceable TransiEnt.Components.Boundaries.Heat.Heatflow_L1 heatFlowBoundary(p_drop=p_drop) constrainedby TransiEnt.Components.Boundaries.Heat.Base.PartialHeatBoundary annotation (choicesAllMatching=true, Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={36,7})));

  TransiEnt.Components.Boundaries.Electrical.Power powerBoundary annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-18,30})));
  Modelica.Blocks.Math.Gain efficiency(k=-1/eta)
    annotation (Placement(transformation(extent={{-36,54},{-18,72}})));
  Modelica.Blocks.Math.Gain sign(k=-1)
    annotation (Placement(transformation(extent={{-20,-9},{-2,9}})));
  parameter SI.Pressure p_drop=heatFlowBoundary.simCenter.p_n[2] -
      heatFlowBoundary.simCenter.p_n[1];
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_hex_coolant_in(medium=medium) annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=180,
        origin={47,-31})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_hex_coolant_out(medium=medium) annotation (Placement(transformation(extent={{53,39},{39,53}})));
  Modelica.Blocks.Nonlinear.Limiter Q_flow_set_limit(uMax=0, uMin=-Q_flow_n)
                                                     annotation (Placement(transformation(extent={{-72,-10},{-52,10}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.HeatingPlantCost collectCosts_HeatProducer(
    redeclare model HeatingPlantCostModel = ProducerCosts,
    Q_flow_fuel_is=0,
    m_flow_CDE_is=0,
    Q_flow_n=Q_flow_n,
    Q_flow_is=Q_flow_is) annotation (Placement(transformation(extent={{10,-100},{30,-80}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional) annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Modelica.SIunits.HeatFlowRate Q_flow_is = sign.y;
equation

  collectHeatingPower.heatFlowCollector.Q_flow = -Q_flow_is;

  // _____________________________________________
  //
  //                Connect Equations
  // _____________________________________________

  connect(modelStatistics.heatFlowCollector[TransiEnt.Basics.Types.TypeOfResource.Conventional],collectHeatingPower.heatFlowCollector);
  connect(modelStatistics.costsCollector, collectCosts_HeatProducer.costsCollector);

  connect(inlet, heatFlowBoundary.fluidPortIn) annotation (Line(
      points={{102,-40},{70,-40},{70,-0.4},{45.8,-0.4}},
      color={175,0,0}));
  connect(heatFlowBoundary.fluidPortOut, outlet) annotation (Line(
      points={{45.8,15.6},{58,15.6},{58,15},{70,15},{70,50},{100,50}},
      color={175,0,0}));
  connect(powerBoundary.epp, epp) annotation (Line(
      points={{-7.9,29.9},{0,29.9},{0,98}},
      color={0,0,0}));
  connect(efficiency.y, powerBoundary.P_el_set) annotation (Line(
      points={{-17.1,63},{-12,63},{-12,42}},
      color={0,0,127}));
  connect(sign.y, heatFlowBoundary.Q_flow_prescribed) annotation (Line(
      points={{-1.1,0},{12.45,0},{12.45,8.88178e-016},{26.8,8.88178e-016}},
      color={0,0,127}));
  connect(heatFlowBoundary.fluidPortOut, temperatureSensor_hex_coolant_out.port)
    annotation (Line(
      points={{45.8,15.6},{45.8,38.3},{46,38.3},{46,39}},
      color={175,0,0},
      thickness=0.5));
  connect(heatFlowBoundary.fluidPortIn, temperatureSensor_hex_coolant_in.port)
    annotation (Line(
      points={{45.8,-0.4},{45.8,-24},{47,-24}},
      color={175,0,0},
      thickness=0.5));
  connect(Q_flow_set, Q_flow_set_limit.u) annotation (Line(points={{-104,0},{-74,0}}, color={0,0,127}));
  connect(Q_flow_set_limit.y, sign.u) annotation (Line(points={{-51,0},{-21.8,0}}, color={0,0,127}));
  connect(Q_flow_set_limit.y, efficiency.u) annotation (Line(points={{-51,0},{-44,0},{-44,42},{-44,63},{-37.8,63}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Ellipse(
          extent={{-42,-50},{40,-92}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{-42,52},{40,-74}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Ellipse(
          extent={{-42,74},{40,32}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Line(
          points={{0,-48},{0,-102}},
          color={0,134,134},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{0,0},{20,-8},{-18,-22},{18,-36},{0,-40},{0,-50}},
          thickness=0.5,
          smooth=Smooth.None,
          color={0,134,134})}),   Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model of an electrode boiler using TransiEnt interfaces and TransiEnt.Statistics. Heat transfer is ideal, thermal losses are modeled using a constant efficiency.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarsk for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end ElectricBoiler;
