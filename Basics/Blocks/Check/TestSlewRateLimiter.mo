within TransiEnt.Basics.Blocks.Check;
model TestSlewRateLimiter
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
  extends Icons.Checkmodel;
  Modelica.Blocks.Sources.Ramp ramp(
    height=-1,
    duration=5,
    offset=1,
    startTime=5)
    annotation (Placement(transformation(extent={{-84,-14},{-56,14}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    height=1,
    duration=2.5,
    offset=0,
    startTime=12.5)
    annotation (Placement(transformation(extent={{-84,-70},{-56,-42}})));
  Modelica.Blocks.Math.Add ramp2
    annotation (Placement(transformation(extent={{-22,-14},{6,14}})));
  VariableSlewRateLimiter slewRateLimiter(maxGrad_const=0.1, Td=0.001) annotation (Placement(transformation(extent={{26,-19},{64,19}})));
equation
  connect(ramp.y, ramp2.u1) annotation (Line(
      points={{-54.6,0},{-38,0},{-38,8.4},{-24.8,8.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, ramp2.u2) annotation (Line(
      points={{-54.6,-56},{-40,-56},{-40,-8.4},{-24.8,-8.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp2.y, slewRateLimiter.u) annotation (Line(
      points={{7.4,0},{22.2,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), experiment(StopTime=15));
end TestSlewRateLimiter;
