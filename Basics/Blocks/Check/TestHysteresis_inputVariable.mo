within TransiEnt.Basics.Blocks.Check;
model TestHysteresis_inputVariable


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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




    extends TransiEnt.Basics.Icons.Checkmodel;

  Hysteresis_inputVariable hysteresis_inputVariable annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Sine sine(f=0.1) annotation (Placement(transformation(extent={{-84,-10},{-64,10}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    height=0.9,
    duration=100,
    offset=0,
    startTime=10) annotation (Placement(transformation(extent={{-74,30},{-54,50}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=-0.5) annotation (Placement(transformation(extent={{-74,-48},{-54,-28}})));
equation
  connect(sine.y, hysteresis_inputVariable.u) annotation (Line(points={{-63,0},{-11,0}}, color={0,0,127}));
  connect(ramp1.y, hysteresis_inputVariable.uHigh) annotation (Line(points={{-53,40},{-16,40},{-16,8},{-10.6,8}}, color={0,0,127}));
  connect(realExpression.y, hysteresis_inputVariable.uLow) annotation (Line(points={{-53,-38},{-24,-38},{-24,-8},{-11,-8}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=150,
      Interval=0.05,
      __Dymola_Algorithm="Dassl"));
end TestHysteresis_inputVariable;
