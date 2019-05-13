within TransiEnt.Producer.Gas.Electrolyzer.Controller;
model TotalFeedInController "Controller to control the electrolyzer system for feeding into a natural gas grid"

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

  import TransiEnt;
  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.ActivePower P_el_n=1e6 "Nominal power of the electrolyzer" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.ActivePower P_el_min=0.02*P_el_n "Maximum power of the electrolyzer" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.ActivePower P_el_max=3*P_el_n "Maximum power of the electrolyzer" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.ActivePower P_el_overload=1.5*P_el_n "Power at which the overload region of the electrolyzer begins" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.ActivePower P_el_cooldown=P_el_n "Power below which cooldown starts" annotation(Dialog(group="Fundamental Definitions"));
  parameter Modelica.SIunits.Efficiency eta_n(
    min=0,
    max=1)=0.75 "Nominal efficiency coefficient (min = 0, max = 1)" annotation(Dialog(group="Fundamental Definitions"));

  parameter Modelica.SIunits.Efficiency eta_scale(
    min=0,
    max=1)=0 "Sets a with increasing input power linear degrading efficiency coefficient (min = 0, max = 1)"
                                                                                                    annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.Time t_overload=5*3600 "Maximum time in seconds that the electrolyzer can work in overload" annotation(Dialog(group="Fundamental Definitions"));
  parameter Real coolingToHeatingRatio=2 "Ratio of how much faster the electrolyzer cools down than it heats up" annotation(Dialog(group="Fundamental Definitions"));
  parameter Integer startState=1 "Initial state of the electrolyzer (1: ready to overheat, 2: working in overload, 3: cooling down)" annotation(Dialog(group="Fundamental Definitions"));

  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.P "Type of controller for feed-in control" annotation (Dialog(tab="General", group="Controller"));
  parameter Real k=1 "Gain for feed-in control" annotation (Dialog(tab="General", group="Controller"));
  parameter Real Ti=0.1 "Integrator time constant for feed-in control" annotation (Dialog(tab="General", group="Controller"));
  parameter Real Td=0.1 "Derivative time constant for feed-in control" annotation (Dialog(tab="General", group="Controller"));
  parameter Boolean useMassFlowControl=true "choose if output of FeedInStation is limited by m_flow_feedIn" annotation (Dialog(tab="General"));


  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_set "Set power"    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100}),  iconTransformation(extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,88})));
  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow_ely "Hydrogen mass flow out of the electrolyser" annotation (Placement(transformation(extent={{112,-60},{72,-20}}), iconTransformation(extent={{112,-60},{72,-20}})));
  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow_feedIn "Maximum mass flow that can be fed into the natural gas system" annotation (Placement(transformation(extent={{112,20},{72,60}}), iconTransformation(extent={{112,20},{72,60}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_el_ely "Controlled power of the electrolyser" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-110})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Producer.Gas.Electrolyzer.Controller.OverloadController controlElyOverload(
    P_el_n=P_el_n,
    P_el_overload=P_el_overload,
    t_overload=t_overload,
    coolingToHeatingRatio=coolingToHeatingRatio,
    P_el_cooldown=P_el_cooldown,
    state(start=startState))
                           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-54})));
  TransiEnt.Producer.Gas.Electrolyzer.Controller.FeedInController controlElyMaximumFeedIn(
    P_el_n=P_el_n,
    P_el_max=P_el_max,
    P_el_min=P_el_min,
    k=k,
    controllerType=controllerType,
    Ti=Ti,
    Td=Td,
    eta_n=eta_n,
    eta_scale=eta_scale,
    useMassFlowControl=useMassFlowControl,
    redeclare model Charline = Charline) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,0})));
  replaceable model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200        constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.PartialElectrolyzerEfficiencyCharline        "Calculate the efficiency" annotation (__Dymola_choicesAllMatching=true);

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(controlElyMaximumFeedIn.P_el_feedIn, controlElyOverload.P_el_set) annotation (Line(points={{0,-11},{0,-43}}, color={0,0,127}));
  connect(controlElyOverload.P_el_ely, P_el_ely) annotation (Line(points={{-1.77636e-015,-64.8},{-1.77636e-015,-88},{0,-88},{0,-110}}, color={0,0,127}));
  connect(P_el_set, controlElyMaximumFeedIn.P_el_set) annotation (Line(points={{0,100},{0,56},{0,11},{1.9984e-015,11}}, color={0,0,127}));
  if useMassFlowControl then
  connect(m_flow_feedIn, controlElyMaximumFeedIn.m_flow_feedIn) annotation (Line(points={{92,40},{92,40},{60,40},{60,3},{11,3}}, color={0,0,127}));
  connect(m_flow_ely, controlElyMaximumFeedIn.m_flow_H2) annotation (Line(points={{92,-40},{60,-40},{60,-3},{11,-3}}, color={0,0,127}));
  end if;
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This is a controller to control the electric power of the electrolyzer for a system without storage. it combines the FeedInController and OverloadController. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>see sub models </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>see sub models </p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>P_el_set: input for the set value for the electric power </p>
<p>P_el_ely: output for the limited electric power for the electrolyzer </p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) in April 2016<br> </p>
</html>"));
end TotalFeedInController;
