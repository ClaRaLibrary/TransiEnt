within TransiEnt.Producer.Gas.MethanatorSystem.Controller;
model MassFlowFeedInSystemController
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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

  extends TransiEnt.Basics.Icons.Controller;
Modelica.Blocks.Interfaces.RealInput P_el_set annotation (Placement(transformation(
      extent={{-20,-20},{20,20}},
      rotation=0,
      origin={-120,0})));
Modelica.Blocks.Interfaces.RealInput m_flow_feed annotation (Placement(transformation(
      extent={{-20,-20},{20,20}},
      rotation=270,
      origin={-60,120})));
Modelica.Blocks.Interfaces.RealOutput P_el_ely annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=180,
      origin={110,0})));
Modelica.Blocks.Interfaces.RealOutput m_flow_feed_ely annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=180,
      origin={110,80})));
Modelica.Blocks.Interfaces.RealInput m_flow_feed_CH4_is annotation (Placement(transformation(
      extent={{-20,-20},{20,20}},
      rotation=270,
      origin={60,120})));
Modelica.Blocks.Continuous.LimPID PID(
  yMax=1,
  k=10,
  Td=10,
  yMin=-1)                            annotation (Placement(transformation(extent={{-20,80},{0,100}})));

    parameter SI.ActivePower P_el_max "|Electrolyzer|Maximum power of electrolyzer";
    parameter SI.Efficiency eta_n_ely(min=0,max=1) "|Electrolyzer|Nominal Efficiency";
  //  parameter Boolean Storage==true;
   // parameter Real Storage_min=if Storage==true then feedInStation.storage.

Modelica.Blocks.Math.Division division annotation (Placement(transformation(extent={{-20,52},{0,72}})));
Modelica.Blocks.Sources.RealExpression realExpression(y=1.9910175) annotation (Placement(transformation(extent={{-60,46},{-40,66}})));
Modelica.Blocks.Math.Add add annotation (Placement(transformation(extent={{68,58},{88,78}})));
equation
connect(P_el_set, P_el_ely) annotation (Line(points={{-120,0},{110,0},{110,0}}, color={0,0,127}));
connect(PID.u_m, m_flow_feed_CH4_is) annotation (Line(points={{-10,78},{-10,78},{60,78},{60,96},{60,120}},       color={0,0,127}));
connect(division.u2, realExpression.y) annotation (Line(points={{-22,56},{-30,56},{-39,56}}, color={0,0,127}));
connect(division.u1, m_flow_feed) annotation (Line(points={{-22,68},{-60,68},{-60,120}}, color={0,0,127}));
connect(division.y, add.u2) annotation (Line(points={{1,62},{28,62},{66,62}}, color={0,0,127}));
connect(PID.u_s, m_flow_feed) annotation (Line(points={{-22,90},{-60,90},{-60,120}}, color={0,0,127}));
connect(add.y, m_flow_feed_ely) annotation (Line(points={{89,68},{94,68},{94,80},{110,80}}, color={0,0,127}));
connect(add.u1, PID.y) annotation (Line(points={{66,74},{40,74},{12,74},{12,90},{1,90}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end MassFlowFeedInSystemController;
