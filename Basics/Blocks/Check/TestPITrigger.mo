within TransiEnt.Basics.Blocks.Check;
model TestPITrigger
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
  Modelica.Blocks.Sources.TimeTable Testdata(table=[0,0; 3600,1; 5400,0; 7200,1; 9000,1; 12600,0; 12600,1; 16200,1; 16200,0; 18000,0; 18000,1.2; 22320,1.2; 22320,-0.1; 26000,-0.1], offset=-0.5)
                                                                                                    annotation (Placement(transformation(extent={{-84,-44},{-48,-8}})));
  LimPIDReset PID(controllerType=Modelica.Blocks.Types.SimpleController.PI, Ti=900) annotation (Placement(transformation(extent={{-2,-42},{30,-10}})));
  Modelica.Blocks.Continuous.FirstOrder plant(T=900) annotation (Placement(transformation(extent={{70,-36},{90,-16}})));
  Modelica.Blocks.Logical.ZeroCrossing zeroCrossing annotation (Placement(transformation(extent={{46,42},{26,62}})));
  Modelica.Blocks.Sources.BooleanConstant alwaysOn(k=true) annotation (Placement(transformation(extent={{50,24},{40,34}})));
  Modelica.Blocks.Discrete.TriggeredSampler triggeredSampler annotation (Placement(transformation(extent={{-46,48},{-66,68}})));
equation
  connect(Testdata.y, PID.u_s) annotation (Line(points={{-46.2,-26},{-46.2,-26},{-5.2,-26}}, color={0,0,127}));
  connect(PID.y, plant.u) annotation (Line(points={{31.6,-26},{68,-26}}, color={0,0,127}));
  connect(plant.y, PID.u_m) annotation (Line(points={{91,-26},{104,-26},{104,-80},{14,-80},{14,-45.2}}, color={0,0,127}));
  connect(alwaysOn.y, zeroCrossing.enable) annotation (Line(points={{39.5,29},{36,29},{36,40}}, color={255,0,255}));
  connect(zeroCrossing.y, PID.trigger) annotation (Line(points={{25,52},{13.68,52},{13.68,-9.04}}, color={255,0,255}));
  connect(Testdata.y, zeroCrossing.u) annotation (Line(points={{-46.2,-26},{-24,-26},{-24,72},{62,72},{62,52},{48,52}}, color={0,0,127}));
  connect(zeroCrossing.y, triggeredSampler.trigger) annotation (Line(points={{25,52},{0,52},{0,24},{-56,24},{-56,46.2}}, color={255,0,255}));
  connect(Testdata.y, triggeredSampler.u) annotation (Line(points={{-46.2,-26},{-32,-26},{-32,58},{-44,58}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=26000,
      Interval=30,
      Tolerance=1e-006),
    __Dymola_experimentSetupOutput);
end TestPITrigger;
