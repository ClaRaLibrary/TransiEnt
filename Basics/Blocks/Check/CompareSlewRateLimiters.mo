within TransiEnt.Basics.Blocks.Check;
model CompareSlewRateLimiters
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
  extends TransiEnt.Basics.Icons.Checkmodel;
  TransiEnt.Basics.Blocks.DiscreteTimeSlewRateLimiter SlewRateLimiter(
    samplePeriod=60,
    startTime=0,
    Rising=1/3600,
    Falling=-1/1800,
    Max=1,
    Min=0) annotation (Placement(transformation(extent={{12,-42},{44,-10}})));
  Modelica.Blocks.Sources.TimeTable Testdata(table=[0,0; 3600,1; 5400,0; 7200,1; 9000,1; 12600,0; 12600,1; 16200,1; 16200,0; 18000,0; 18000,1.2; 22320,1.2; 22320,-0.1; 26000,-0.1]) annotation (Placement(transformation(extent={{-60,-44},{-24,-8}})));
  ClaRa.Components.Utilities.Blocks.VariableGradientLimiter SlewRateLimiterClaRa(
    constantLimits=true,
    maxGrad_const=1/3600,
    minGrad_const=-1/1800) annotation (Placement(transformation(extent={{44,-88},{70,-62}})));
  Modelica.Blocks.Nonlinear.Limiter         variableLimiter(uMax=1, uMin=0)
                                                            annotation (Placement(transformation(extent={{-6,-88},{20,-62}})));
equation
  connect(Testdata.y, SlewRateLimiter.u) annotation (Line(points={{-22.2,-26},{-16,-26},{8.8,-26}}, color={0,0,127}));
  connect(Testdata.y, variableLimiter.u) annotation (Line(points={{-22.2,-26},{-18,-26},{-18,-75},{-8.6,-75}}, color={0,0,127}));
  connect(variableLimiter.y, SlewRateLimiterClaRa.u) annotation (Line(points={{21.3,-75},{31.65,-75},{41.4,-75}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=26000,
      Interval=30,
      Tolerance=1e-006),
    __Dymola_experimentSetupOutput,
    Diagram(graphics={Text(
          extent={{-48,74},{50,26}},
          lineColor={0,0,0},
          textString="Look at:
Testdata.y
SlewRateLimiter.y
SlewRateLimiter.Max
SlewRateLimiter.Min

")}));
end CompareSlewRateLimiters;
