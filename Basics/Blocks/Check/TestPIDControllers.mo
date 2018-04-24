within TransiEnt.Basics.Blocks.Check;
model TestPIDControllers
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

  Modelica.Blocks.Continuous.LimPID PID(
    k=gain.k,
    yMax=ymax.k,
    Ti = Ti.k,
    controllerType=Modelica.Blocks.Types.SimpleController.P)
          annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Modelica.Blocks.Sources.Step step(
    offset=22,
    startTime=50,
    height=-5)
    annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C=
        100)
    annotation (Placement(transformation(extent={{72,10},{92,30}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
    prescribedHeatFlow
    annotation (Placement(transformation(extent={{32,-10},{52,10}})));
  Modelica.Thermal.HeatTransfer.Celsius.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{52,-32},{32,-12}})));
  ClaRa.Components.Utilities.Blocks.LimPID PID1(
    y_max=ymax.k,
    k=gain.k,
    Tau_i=Ti.k,
    controllerType=Modelica.Blocks.Types.SimpleController.P)
                annotation (Placement(transformation(extent={{-8,-74},{12,-54}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor1(
                                                                       C=
        100)
    annotation (Placement(transformation(extent={{72,-54},{92,-34}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
    prescribedHeatFlow1
    annotation (Placement(transformation(extent={{32,-74},{52,-54}})));
  Modelica.Thermal.HeatTransfer.Celsius.TemperatureSensor temperatureSensor1
    annotation (Placement(transformation(extent={{54,-94},{34,-74}})));
  TransiEnt.Basics.Blocks.SmoothLimPID PID2(
    k=gain.k,
    yMax=ymax.k,
    Ti=Ti.k,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    thres=smoothReg.k) annotation (Placement(transformation(extent={{-8,52},{12,72}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor2(
                                                                       C=
        100)
    annotation (Placement(transformation(extent={{72,72},{92,92}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
    prescribedHeatFlow2
    annotation (Placement(transformation(extent={{32,52},{52,72}})));
  Modelica.Thermal.HeatTransfer.Celsius.TemperatureSensor temperatureSensor2
    annotation (Placement(transformation(extent={{52,30},{32,50}})));
  Modelica.Blocks.Sources.Constant gain(k=10) annotation (Placement(transformation(extent={{-98,74},{-78,94}})));
  Modelica.Blocks.Sources.Constant Ti(k=0.5) annotation (Placement(transformation(extent={{-98,44},{-78,64}})));
  Modelica.Blocks.Sources.Constant ymax(k=10) annotation (Placement(transformation(extent={{-72,74},{-52,94}})));
  Modelica.Blocks.Sources.Constant Td(k=0.1) annotation (Placement(transformation(extent={{-72,44},{-52,64}})));
  Modelica.Blocks.Sources.Constant smoothReg(k=0.5) annotation (Placement(transformation(extent={{-100,14},{-80,34}})));
equation
  connect(step.y, PID.u_s) annotation (Line(
      points={{-45,0},{-10,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID.y, prescribedHeatFlow.Q_flow) annotation (Line(
      points={{13,0},{32,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port, heatCapacitor.port) annotation (Line(
      points={{52,0},{82,0},{82,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor.port, temperatureSensor.port) annotation (Line(
      points={{82,10},{82,-22},{52,-22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temperatureSensor.T, PID.u_m) annotation (Line(
      points={{32,-22},{2,-22},{2,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step.y, PID1.u_s) annotation (Line(points={{-45,0},{-38,0},{-38,-64},{-10,-64}}, color={0,0,127}));
  connect(prescribedHeatFlow1.port, heatCapacitor1.port) annotation (Line(
      points={{52,-64},{82,-64},{82,-54}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor1.port, temperatureSensor1.port) annotation (Line(
      points={{82,-54},{82,-84},{54,-84}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PID1.y, prescribedHeatFlow1.Q_flow) annotation (Line(points={{13,-64},{13,-64},{32,-64}}, color={0,0,127}));
  connect(temperatureSensor1.T, PID1.u_m) annotation (Line(points={{34,-84},{2.1,-84},{2.1,-76}}, color={0,0,127}));
  connect(step.y, PID2.u_s) annotation (Line(points={{-45,0},{-38,0},{-38,12},{-38,62},{-10,62}}, color={0,0,127}));
  connect(prescribedHeatFlow2.port, heatCapacitor2.port) annotation (Line(
      points={{52,62},{82,62},{82,72}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor2.port, temperatureSensor2.port) annotation (Line(
      points={{82,72},{82,40},{52,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PID2.y, prescribedHeatFlow2.Q_flow) annotation (Line(points={{13,62},{22,62},{32,62}}, color={0,0,127}));
  connect(temperatureSensor2.T, PID2.u_m) annotation (Line(points={{32,40},{32,40},{2,40},{2,50}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
    experiment(StopTime=300, Interval=1),
    __Dymola_experimentSetupOutput);
end TestPIDControllers;
