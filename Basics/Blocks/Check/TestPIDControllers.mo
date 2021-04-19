within TransiEnt.Basics.Blocks.Check;
model TestPIDControllers "Model for testing the PIDControllers model"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
// Copyright 2020, Hamburg University of Technology.                              //
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
    controllerType=Modelica.Blocks.Types.SimpleController.PI)
          annotation (Placement(transformation(extent={{-8,-26},{12,-6}})));
  Modelica.Blocks.Sources.Step step(
    offset=22,
    startTime=50,
    height=-5)
    annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C=
        100)
    annotation (Placement(transformation(extent={{72,-6},{92,14}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
    prescribedHeatFlow
    annotation (Placement(transformation(extent={{32,-26},{52,-6}})));
  Modelica.Thermal.HeatTransfer.Celsius.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(extent={{52,-48},{32,-28}})));
  ClaRa.Components.Utilities.Blocks.LimPID PID1(
    y_max=ymax.k,
    k=gain.k,
    Tau_i=Ti.k,
    controllerType=Modelica.Blocks.Types.SimpleController.PI)
                annotation (Placement(transformation(extent={{-8,-80},{12,-60}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor1(
                                                                       C=
        100)
    annotation (Placement(transformation(extent={{72,-60},{92,-40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
    prescribedHeatFlow1
    annotation (Placement(transformation(extent={{32,-80},{52,-60}})));
  Modelica.Thermal.HeatTransfer.Celsius.TemperatureSensor temperatureSensor1
    annotation (Placement(transformation(extent={{54,-100},{34,-80}})));
  TransiEnt.Basics.Blocks.SmoothLimPID PID2(
    k=gain.k,
    yMax=ymax.k,
    Ti=Ti.k,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    thres=smoothReg.k) annotation (Placement(transformation(extent={{-8,28},{12,48}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor2(
                                                                       C=
        100)
    annotation (Placement(transformation(extent={{72,48},{92,68}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
    prescribedHeatFlow2
    annotation (Placement(transformation(extent={{32,28},{52,48}})));
  Modelica.Thermal.HeatTransfer.Celsius.TemperatureSensor temperatureSensor2
    annotation (Placement(transformation(extent={{52,6},{32,26}})));
  Modelica.Blocks.Sources.Constant gain(k=10) annotation (Placement(transformation(extent={{-98,74},{-78,94}})));
  Modelica.Blocks.Sources.Constant Ti(k=0.5) annotation (Placement(transformation(extent={{-98,44},{-78,64}})));
  Modelica.Blocks.Sources.Constant ymax(k=10) annotation (Placement(transformation(extent={{-72,74},{-52,94}})));
  Modelica.Blocks.Sources.Constant Td(k=0.1) annotation (Placement(transformation(extent={{-72,44},{-52,64}})));
  Modelica.Blocks.Sources.Constant smoothReg(k=0.5) annotation (Placement(transformation(extent={{-100,14},{-80,34}})));
  TransiEnt.Basics.Blocks.LimPID PID3(
    k=gain.k,
    y_max=ymax.k,
    Tau_i=Ti.k,
    controllerType=Modelica.Blocks.Types.SimpleController.PI) annotation (Placement(transformation(extent={{-8,82},{12,102}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor3(C=100)
    annotation (Placement(transformation(extent={{72,102},{92,122}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
    prescribedHeatFlow3
    annotation (Placement(transformation(extent={{32,82},{52,102}})));
  Modelica.Thermal.HeatTransfer.Celsius.TemperatureSensor temperatureSensor3
    annotation (Placement(transformation(extent={{52,60},{32,80}})));
equation
  connect(step.y, PID.u_s) annotation (Line(
      points={{-45,0},{-28,0},{-28,-16},{-10,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID.y, prescribedHeatFlow.Q_flow) annotation (Line(
      points={{13,-16},{32,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port, heatCapacitor.port) annotation (Line(
      points={{52,-16},{82,-16},{82,-6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor.port, temperatureSensor.port) annotation (Line(
      points={{82,-6},{82,-38},{52,-38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temperatureSensor.T, PID.u_m) annotation (Line(
      points={{32,-38},{2,-38},{2,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step.y, PID1.u_s) annotation (Line(points={{-45,0},{-38,0},{-38,-70},{-10,-70}}, color={0,0,127}));
  connect(prescribedHeatFlow1.port, heatCapacitor1.port) annotation (Line(
      points={{52,-70},{82,-70},{82,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor1.port, temperatureSensor1.port) annotation (Line(
      points={{82,-60},{82,-90},{54,-90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PID1.y, prescribedHeatFlow1.Q_flow) annotation (Line(points={{13,-70},{32,-70}},          color={0,0,127}));
  connect(temperatureSensor1.T, PID1.u_m) annotation (Line(points={{34,-90},{2.1,-90},{2.1,-82}}, color={0,0,127}));
  connect(step.y, PID2.u_s) annotation (Line(points={{-45,0},{-38,0},{-38,38},{-10,38}},          color={0,0,127}));
  connect(prescribedHeatFlow2.port, heatCapacitor2.port) annotation (Line(
      points={{52,38},{82,38},{82,48}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor2.port, temperatureSensor2.port) annotation (Line(
      points={{82,48},{82,16},{52,16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PID2.y, prescribedHeatFlow2.Q_flow) annotation (Line(points={{13,38},{32,38}},         color={0,0,127}));
  connect(temperatureSensor2.T, PID2.u_m) annotation (Line(points={{32,16},{2,16},{2,26}},         color={0,0,127}));
  connect(step.y,PID3. u_s) annotation (Line(points={{-45,0},{-38,0},{-38,92},{-10,92}},          color={0,0,127}));
  connect(prescribedHeatFlow3.port,heatCapacitor3. port) annotation (Line(
      points={{52,92},{82,92},{82,102}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor3.port,temperatureSensor3. port) annotation (Line(
      points={{82,102},{82,70},{52,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PID3.y,prescribedHeatFlow3. Q_flow) annotation (Line(points={{13,92},{32,92}},         color={0,0,127}));
  connect(temperatureSensor3.T,PID3. u_m) annotation (Line(points={{32,70},{2.1,70},{2.1,80}},     color={0,0,127}));
  annotation (
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,120}})),
    experiment(StopTime=300, Interval=1),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for PIDControllers</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Added new LimPIDTransiEnt, Carsten Bode (c.bode@tuhh.de), Nov 2018</p>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,120}})));
end TestPIDControllers;
