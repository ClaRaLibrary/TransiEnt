within TransiEnt.Basics.Blocks.Check;
model TestTimers

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
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
  extends TransiEnt.Basics.Icons.Checkmodel;

  TransiEnt.Basics.Blocks.TimerResetWhenTrue timerResetOnly annotation (Placement(transformation(extent={{-30,0},{-10,20}})));
  Modelica.Blocks.Logical.Timer timer annotation (Placement(transformation(extent={{-30,40},{-10,60}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(period=1) annotation (Placement(transformation(extent={{-76,0},{-56,20}})));
  TransiEnt.Basics.Blocks.TimerConstWhenFalse timerConstWhenFalse annotation (Placement(transformation(extent={{-30,-40},{-10,-20}})));
equation
  connect(booleanPulse.y, timerResetOnly.u) annotation (Line(points={{-55,10},{-32,10}},                   color={255,0,255}));
  connect(booleanPulse.y, timer.u) annotation (Line(points={{-55,10},{-44,10},{-44,50},{-32,50}},   color={255,0,255}));
  connect(timerConstWhenFalse.u, booleanPulse.y) annotation (Line(points={{-32,-30},{-44,-30},{-44,10},{-55,10}}, color={255,0,255}));
  annotation (experiment(
      StopTime=10,
      Interval=0.1,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end TestTimers;
