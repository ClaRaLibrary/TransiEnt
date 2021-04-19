within TransiEnt.Producer.Heat.Power2Heat;
model ElectricBoiler_L1_idContrQFlow_temp "Model for electric boilers with ideal heat flow rate control to get a given outlet temperature"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
// Copyright 2020, Hamburg University of Technology.                              //
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

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.fluid1 "Medium to be used" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter Boolean use_varTemp=false "true if variable temperature input should be used" annotation (Dialog(group="Fundamental Definitions"));
  parameter SI.Temperature T_out_set_const=46 + 273.15 "Constant outlet set temperature" annotation (Dialog(group="Fundamental Definitions", enable=not use_varTemp));

  parameter SI.HeatFlowRate Q_flow_n=3.5e3 "Nominal heat flow rate" annotation (Dialog(group="Technical Specifications"));
  parameter Real eta=0.99 "Efficiency" annotation (Dialog(group="Technical Specifications"));

  parameter TransiEnt.Basics.Types.TypeOfResource typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Consumer "Select the kind of resource" annotation (Dialog(group="Statistics"));
  parameter Boolean usePowerPort=true "True if power port shall be used" annotation (Dialog(group="Fundamental Definitions"));

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
  TransiEnt.Basics.Interfaces.General.TemperatureIn T_out_set(value=T_out_set_in) if use_varTemp "Setpoint value of the output temperature" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT fluidOut(
    vleFluidType=medium,
    p=fluidPortOut.p,
    T=T_out_set_in) annotation (Placement(transformation(extent={{30,-80},{50,-60}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=typeOfResource) annotation (Placement(transformation(extent={{60,-100},{80,-80}})));

  replaceable model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.Empty constrainedby TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PartialPowerPlantCostSpecs annotation (Dialog(group="Statistics"), __Dymola_choicesAllMatching=true);

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.HeatingPlantCost collectCosts_HeatProducer(
    redeclare model HeatingPlantCostModel = ProducerCosts,
    Q_flow_fuel_is=0,
    m_flow_CDE_is=0,
    Q_flow_n=Q_flow_n,
    Q_flow_is=Q_flow,
    consumes_H_flow=false,
    produces_m_flow_CDE=false) annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Consumer) annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=P_el) annotation (Placement(transformation(extent={{-72,52},{-52,72}})));
  replaceable TransiEnt.Components.Boundaries.Electrical.ActivePower.Power powerBoundary if
                                                                                usePowerPort constrainedby TransiEnt.Components.Boundaries.Electrical.ActivePower.Power "Choice of power boundary model. The power boundary model must match the power port." annotation (
    choices(choice(redeclare TransiEnt.Components.Boundaries.Electrical.ActivePower.Power powerBoundary "PowerBoundary for ActivePowerPort"), choice(redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=1) "Power Boundary for ComplexPowerPort")),
    Dialog(group="Replaceable Components"),
    Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-28,40})));
  replaceable Basics.Interfaces.Electrical.ActivePowerPort epp if            usePowerPort constrainedby Basics.Interfaces.Electrical.ActivePowerPort "Choice of power port" annotation (
    choicesAllMatching=true,
    Dialog(group="Replaceable Components"),
    Placement(transformation(extent={{-110,-10},{-90,10}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.Temperature T_out_set_in;
  SI.HeatFlowRate Q_flow;
  SI.Power P_el "Consumed electric power";

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________


equation
  if not use_varTemp then
    T_out_set_in = T_out_set_const;
  end if;

  fluidPortIn.m_flow + fluidPortOut.m_flow = 0;
  fluidPortIn.h_outflow = inStream(fluidPortOut.h_outflow);

  fluidPortOut.h_outflow = if inStream(fluidPortIn.h_outflow) < fluidOut.h then fluidOut.h else inStream(fluidPortIn.h_outflow);

  fluidPortIn.p = fluidPortOut.p;

  Q_flow = fluidPortOut.m_flow*(fluidPortOut.h_outflow - inStream(fluidPortIn.h_outflow));
  P_el = -Q_flow/eta;

  collectHeatingPower.heatFlowCollector.Q_flow = Q_flow;
  collectElectricPower.powerCollector.P = P_el;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(modelStatistics.costsCollector, collectCosts_HeatProducer.costsCollector);
  connect(modelStatistics.heatFlowCollector[TransiEnt.Basics.Types.TypeOfResource.Consumer], collectHeatingPower.heatFlowCollector);
  connect(modelStatistics.powerCollector[collectElectricPower.typeOfResource], collectElectricPower.powerCollector);
  if usePowerPort then
  connect(powerBoundary.epp, epp) annotation (Line(
      points={{-38,40},{-60,40},{-60,0},{-100,0}},
      color={0,135,135},
      thickness=0.5));
  connect(realExpression.y, powerBoundary.P_el_set) annotation (Line(points={{-51,62},{-34,62},{-34,52}}, color={0,0,127}));
  end if;
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is an electric boiler which calculates the heat flow rate to get a given outlet temperature. It can be chosen if the outlet set temperature is constant or given by an input.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The efficiency is constant.</p>
<p>The heat flow rate is calculated based on the given mass flow rate at the ports and a given constant outlet temperature. There is no volume considered.</p>
<p>There are no pressure losses included.</p>
<p>The model calculates any heat flow rate that is necessary to reach the given temperature but no positive values (no cooling possible!).</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>This model is only valid for ideal controls, i.e. ideally tuned controls with no control errors.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>T_out_set: set point for outlet temperature</p>
<p>fluidPortIn: inlet for fluid</p>
<p>fluidPortOut: outlet for fluid</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>The model is only working properly in design flow direction. Reverse flow is not supported!</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Dec 2018</p>
<p>Model modified by Jan Westphal (j.westphal@tuhh.de), Jul 2019  (added power port)</p>
</html>"), Icon(graphics={
        Line(
          points={{-40,14},{-40,58},{40,58},{40,-100}},
          color={175,0,0},
          thickness=0.5),
        Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{0,-40},{80,40}},
          startAngle=0,
          endAngle=360),
        Ellipse(
          extent={{28,-14},{52,-24}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{28,19},{52,-19}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Line(
          points={{40,-4},{44,-6},{36,-10},{44,-14},{40,-16},{40,-24}},
          thickness=0.5,
          smooth=Smooth.None,
          color={0,134,134}),
        Ellipse(
          extent={{28,24},{52,14}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Line(
          points={{-40,-100},{-40,-18}},
          color={175,0,0},
          thickness=0.5),
        Line(
          points={{-40,-18},{-40,14}},
          color={175,0,0},
          thickness=0.5)}));
end ElectricBoiler_L1_idContrQFlow_temp;
