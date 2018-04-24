within TransiEnt.Components.Gas.Combustion.Check;
model TestControllerBurner
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

  parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_SG_O2_var vle_ng7_sg_o2;

  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundaryRealGas_Txim_flow1(
    variable_m_flow=true,
    variable_T=true,
    variable_xi=true,
    medium=vle_ng7_sg_o2) annotation (Placement(transformation(extent={{-114,-20},{-94,0}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi1(variable_p=true, medium=vle_ng7_sg_o2) annotation (Placement(transformation(extent={{62,-20},{42,0}})));
  Sensors.RealGas.CompositionSensor massComp_BeforeJunction(medium=vle_ng7_sg_o2, compositionDefinedBy=1) annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=1000,
    height=-0.5,
    startTime=2000,
    offset=-1.5)  annotation (Placement(transformation(extent={{-164,18},{-144,38}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=1000,
    height=50,
    offset=273.15,
    startTime=4000)
                   annotation (Placement(transformation(extent={{-144,-8},{-124,12}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    duration=1000,
    height=4e5,
    offset=1e5,
    startTime=8000)
                   annotation (Placement(transformation(extent={{92,-14},{72,6}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(table=[0,0.60,0.00,0.00,0.00,0.20,0.20,0,0,0.0; 6000,0.60,0.00,0.00,0.00,0.20,0.20,0,0,0.0; 7000,0.30,0.20,0.10,0.05,0.00,0.00,0.10,0.20,0.0; 100000,0.30,0.20,0.10,0.05,0.00,0.00,0.10,0.20,0.0])
                                                                                            annotation (Placement(transformation(extent={{-144,-38},{-124,-18}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundaryRealGas_Txim_flow2(
    variable_m_flow=true,
    medium=vle_ng7_sg_o2,
    T_const=873.15,
    xi_const={0,0,0,0,0.767,0,0,0,0.233}) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-26,16})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 realGasJunction_L2(
    medium=vle_ng7_sg_o2,
    p_start=1e5,
    volume=0.01,
    xi_start={0.0487717,0,0,0,0.720911,0.0162572,0,0,0.21406},
    h_start=583949) annotation (Placement(transformation(extent={{-36,0},{-16,-20}})));
  Sensors.RealGas.MassFlowSensor vleMassflowSensor(medium=vle_ng7_sg_o2) annotation (Placement(transformation(extent={{-62,-10},{-42,10}})));
  TransiEnt.Components.Gas.Combustion.Controller.ControllerAirForBurner controllerAirForBurner annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,32})));
  TransiEnt.Components.Gas.Combustion.Burner_L1 burner(Delta_p=10000) annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow=-5e7) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,20})));
  Sensors.RealGas.TemperatureSensor temperatureTwoPortSensor(medium=vle_ng7_sg_o2) annotation (Placement(transformation(extent={{16,-10},{36,10}})));

  Modelica.SIunits.MassFraction lambdaCheck = if noEvent(burner.summary.gasPortIn.xi[9]-burner.summary.gasPortOut.xi[9]<1e-15) then 1 else burner.summary.gasPortIn.xi[9]/(burner.summary.gasPortIn.xi[9]-burner.summary.gasPortOut.xi[9]);
  Controller.ControllerFuelForBurner controllerFuelForBurner(
    k=1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    initOption=503,
    T_flueGasDes=573.15,
    y_start=1.51493)                                                               annotation (Placement(transformation(extent={{-154,64},{-134,84}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=time < 1500) annotation (Placement(transformation(extent={{-164,36},{-144,56}})));
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(extent={{-136,40},{-124,52}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=270,
        origin={-144,56})));
equation
  connect(ramp1.y,boundaryRealGas_Txim_flow1. T) annotation (Line(points={{-123,2},{-123,2},{-122,2},{-122,-10},{-116,-10}},
                                                                                            color={0,0,127}));
  connect(ramp2.y,boundaryRealGas_pTxi1. p) annotation (Line(points={{71,-4},{64,-4}},
                                                                                     color={0,0,127}));
  connect(combiTimeTable.y,boundaryRealGas_Txim_flow1. xi) annotation (Line(points={{-123,-28},{-120,-28},{-120,-16},{-116,-16}},
                                                                                            color={0,0,127}));
  connect(realGasJunction_L2.gasPort2, boundaryRealGas_Txim_flow2.gasPort) annotation (Line(
      points={{-26,0},{-26,6}},
      color={255,255,0},
      thickness=0.75));
  connect(controllerAirForBurner.m_flow_air_source, boundaryRealGas_Txim_flow2.m_flow) annotation (Line(points={{-40,32},{-32,32},{-32,28}},
                                                                                            color={0,0,127}));
  connect(controllerAirForBurner.m_flow_fuel, vleMassflowSensor.m_flow) annotation (Line(points={{-60,28},{-64,28},{-64,12},{-41,12},{-41,0}}, color={0,0,127}));
  connect(boundaryRealGas_Txim_flow1.gasPort, massComp_BeforeJunction.gasPortIn)
    annotation (Line(
      points={{-94,-10},{-88,-10}},
      color={255,255,0},
      thickness=1.5));
  connect(temperatureTwoPortSensor.gasPortOut, boundaryRealGas_pTxi1.gasPort)
    annotation (Line(
      points={{36,-10},{39,-10},{42,-10}},
      color={255,255,0},
      thickness=1.5));
  connect(controllerAirForBurner.massComposition, massComp_BeforeJunction.fraction)
    annotation (Line(points={{-60,36},{-67,36},{-67,0}}, color={0,0,127}));
  connect(massComp_BeforeJunction.gasPortOut, vleMassflowSensor.gasPortIn)
    annotation (Line(
      points={{-68,-10},{-65,-10},{-62,-10}},
      color={255,255,0},
      thickness=1.5));
  connect(vleMassflowSensor.gasPortOut, realGasJunction_L2.gasPort1) annotation (Line(
      points={{-42,-10},{-39,-10},{-36,-10}},
      color={255,255,0},
      thickness=1.5));
  connect(fixedHeatFlow.port, burner.heat)
    annotation (Line(points={{-1.77636e-015,10},{-1.77636e-015,4},{-1.77636e-015,-0.2},{0,-0.2}},
                                                           color={191,0,0}));
  connect(controllerFuelForBurner.T_flueGas, temperatureTwoPortSensor.T) annotation (Line(points={{-134,74},{37,74},{37,0}}, color={0,0,127}));
  connect(booleanExpression.y, switch1.u2) annotation (Line(points={{-143,46},{-137.2,46}}, color={255,0,255}));
  connect(ramp.y, switch1.u3) annotation (Line(points={{-143,28},{-140,28},{-140,41.2},{-137.2,41.2}}, color={0,0,127}));
  connect(switch1.y, boundaryRealGas_Txim_flow1.m_flow) annotation (Line(points={{-123.4,46},{-120,46},{-120,-4},{-116,-4}}, color={0,0,127}));
  connect(switch1.u1, gain.y) annotation (Line(points={{-137.2,50.8},{-144,50.8},{-144,51.6}}, color={0,0,127}));
  connect(gain.u, controllerFuelForBurner.m_flow_fuel) annotation (Line(points={{-144,60.8},{-144,60.8},{-144,64}}, color={0,0,127}));
  connect(realGasJunction_L2.gasPort3, burner.gasPortIn) annotation (Line(
      points={{-16,-10},{-10,-10}},
      color={255,255,0},
      thickness=1.5));
  connect(burner.gasPortOut, temperatureTwoPortSensor.gasPortIn) annotation (Line(
      points={{10,-10},{10,-10},{16,-10}},
      color={255,255,0},
      thickness=1.5));
  annotation (
    Diagram(coordinateSystem(extent={{-160,-60},{140,100}}, preserveAspectRatio=false), graphics={           Text(
          extent={{-58,96},{58,78}},
          lineColor={0,140,72},
          textString="0-2000 s ControllerFuelForBurner controls m_flow
2000-3000 s mass flow from 1.5 to 2 kg/s
4000-5000 s temperature from 0 to 50 C
6000-7000 s composition changes
8000-9000 s pressure at output from 1 to 5 bar
manually change lambda"),        Text(
          extent={{-14,66},{14,56}},
          lineColor={0,140,72},
          textString="check molar ratio")}),
    Icon(coordinateSystem(extent={{-160,-60},{140,100}})),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput,
          Documentation(info="<html>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016<br> </p>
</html>"));
end TestControllerBurner;
