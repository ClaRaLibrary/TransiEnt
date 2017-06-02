within TransiEnt.Grid.Electrical.SecondaryControl.Check;
model TestScheduleActivation
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

extends TransiEnt.Basics.Icons.Checkmodel;

  Activation.ScheduleActivation scheduleActivation(
    nout=2,
    P_max={1,1},
    P_grad_max_star={60,60},
    P_respond=1e6,
    Td=900) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TransiEnt.Basics.Blocks.Sources.RealVectorExpression P_sec_pos(nout=2, y_set={0.8,0.2}) annotation (Placement(transformation(extent={{-34,14},{-14,34}})));
  TransiEnt.Basics.Blocks.Sources.RealVectorExpression P_sec_pos1(nout=2, y_set={0,1}) annotation (Placement(transformation(extent={{-16,36},{4,56}})));
  Modelica.Blocks.Sources.Sine                 P_sec_pos2(amplitude=10e6, freqHz=1/86400)                               annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
equation
  connect(P_sec_pos.y, scheduleActivation.P_R_pos) annotation (Line(points={{-13,24},{-4,24},{-4,12}}, color={0,0,127}));
  connect(P_sec_pos1.y, scheduleActivation.P_R_neg) annotation (Line(points={{5,46},{16,46},{16,22},{4,22},{4,12}}, color={0,0,127}));
  connect(P_sec_pos2.y, scheduleActivation.u) annotation (Line(points={{-45,0},{-28.5,0},{-12,0}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=86400, Interval=900));
end TestScheduleActivation;
