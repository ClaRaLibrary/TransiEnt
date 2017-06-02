within TransiEnt.Basics.Blocks.Check;
model TestSlewRateLimiterStep
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
  Modelica.Blocks.Sources.Step ramp(
    startTime=5,
    height=0.5,
    offset=0.5)
    annotation (Placement(transformation(extent={{-94,6},{-66,34}})));
  Modelica.Blocks.Sources.Constant
                               ramp1(k=0)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Nonlinear.Limiter P_max_star_limiter(uMax=1, uMin=0.2)
    "Upper limit is nominal power"
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  TransiEnt.Basics.Blocks.VariableSlewRateLimiter slewRateLimiter(
    Td=0.01,
    useThresh=true,
    thres=1e-9,
    maxGrad_const=0.5/4) annotation (Placement(transformation(extent={{-4,-10},{-24,10}})));
equation
  connect(ramp.y, P_max_star_limiter.u) annotation (Line(points={{-64.6,20},{72,20},{72,0},{62,0}}, color={0,0,127}));
  connect(slewRateLimiter.u, P_max_star_limiter.y) annotation (Line(points={{-2,0},{39,0}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          experiment(StopTime=15),
    __Dymola_experimentSetupOutput);
end TestSlewRateLimiterStep;
