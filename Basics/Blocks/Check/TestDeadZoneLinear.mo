within TransiEnt.Basics.Blocks.Check;
model TestDeadZoneLinear
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
  Modelica.Blocks.Sources.Ramp FrequencyDrop(
    height=-0.8,
    offset=0,
    duration=1,
    startTime=1) annotation (Placement(transformation(extent={{-94,6},{-66,34}})));
  DeadZoneLinear deadZoneLinear(
    uMax=0.2,
    uMin=-0.2,
    deadZoneAtInit=true) annotation (Placement(transformation(extent={{-22,4},{8,34}})));
equation
  connect(FrequencyDrop.y, deadZoneLinear.u) annotation (Line(points={{-64.6,20},{-25,20},{-25,19}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          experiment(StopTime=5),
    __Dymola_experimentSetupOutput);
end TestDeadZoneLinear;
