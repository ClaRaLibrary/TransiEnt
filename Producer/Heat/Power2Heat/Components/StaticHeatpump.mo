within TransiEnt.Producer.Heat.Power2Heat.Components;
model StaticHeatpump "Heatpump model with on off controller and no dynamic"

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

  extends Base.PartialHeatPump_heatport;

public
  Modelica.Blocks.Logical.Hysteresis Controller(uLow=-Delta_T_db/2, uHigh=+Delta_T_db/2)
                                                                                     annotation (Placement(transformation(extent={{-36,-7},{-22,7}})));
  Modelica.Blocks.Math.BooleanToReal P_el_HP(realFalse=0, realTrue=P_el_n) annotation (Placement(transformation(extent={{-6,-8},{10,8}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(Controller.y, P_el_HP.u) annotation (Line(points={{-21.3,8.88178e-016},{-7.6,8.88178e-016},{-7.6,0}},
                                                                                          color={255,0,255}));
  connect(Q_flow.y,heatFlowBoundary. Q_flow) annotation (Line(points={{59,0},{59,0},{72,0}},   color={0,0,127}));
  connect(feedback.y,Controller. u) annotation (Line(points={{-63,0},{-56,0},{-56,8.88178e-016},{-37.4,8.88178e-016}},
                                                                               color={0,0,127}));
  connect(P_el_HP.y,Q_flow. u2) annotation (Line(points={{10.8,0},{10.8,0},{34,0},{34,-6},{36,-6}},
                                                                           color={0,0,127}));
  annotation(defaultComponentName="Heatpump");
end StaticHeatpump;
