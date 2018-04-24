within TransiEnt.Basics.Blocks.Check;
model TestVariousSlewRateLimiter
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
    annotation (Placement(transformation(extent={{-10,-14},{18,14}})));
  VariableSlewRateLimiter slewRateLimiter(maxGrad_const=0.1, Td=0.001,
    y_start=1)                                                         annotation (Placement(transformation(extent={{38,51},{76,89}})));
  ClaRa.Components.Utilities.Blocks.VariableGradientLimiter
    variableGradientLimiter(
    constantLimits=true,
    maxGrad_const=0.1,
    minGrad_const=-variableGradientLimiter.maxGrad_const)
    annotation (Placement(transformation(extent={{48,-66},{68,-46}})));
  Modelica.Blocks.Nonlinear.SlewRateLimiter slewRateLimiter1(Rising=0.1)
    annotation (Placement(transformation(extent={{48,-10},{68,10}})));
equation
  connect(ramp.y, ramp2.u1) annotation (Line(
      points={{-54.6,0},{-38,0},{-38,8.4},{-12.8,8.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, ramp2.u2) annotation (Line(
      points={{-54.6,-56},{-40,-56},{-40,-8.4},{-12.8,-8.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp2.y, slewRateLimiter.u) annotation (Line(
      points={{19.4,0},{26,0},{26,70},{34.2,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(slewRateLimiter1.u, slewRateLimiter.u) annotation (Line(points={{46,0},
          {36,0},{26,0},{26,70},{34.2,70}}, color={0,0,127}));
  connect(variableGradientLimiter.u, slewRateLimiter.u) annotation (Line(points=
         {{46,-56},{26,-56},{26,70},{34.2,70}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           experiment(StopTime=15));
end TestVariousSlewRateLimiter;
