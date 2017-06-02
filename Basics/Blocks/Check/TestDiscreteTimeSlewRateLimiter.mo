within TransiEnt.Basics.Blocks.Check;
model TestDiscreteTimeSlewRateLimiter
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
  DiscreteTimeSlewRateLimiter SlewRateLimiter(
    samplePeriod=60,
    startTime=0,
    Rising=1/3600,
    Falling=-1/1800,
    Max=1,
    Min=0) annotation (Placement(transformation(extent={{12,-42},{44,-10}})));
  Modelica.Blocks.Sources.TimeTable Testdata(table=[0,0; 3600,1; 5400,0; 7200,1; 9000,1; 12600,0; 12600,1; 16200,1; 16200,0; 18000,0; 18000,1.2; 22320,1.2; 22320,-0.1; 26000,-0.1]) annotation (Placement(transformation(extent={{-60,-44},{-24,-8}})));
equation
  connect(Testdata.y, SlewRateLimiter.u) annotation (Line(points={{-22.2,-26},{-16,-26},{8.8,-26}}, color={0,0,127}));
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
end TestDiscreteTimeSlewRateLimiter;
