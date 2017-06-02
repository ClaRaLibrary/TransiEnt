within TransiEnt.Producer.Combined.SmallScaleCHP.Check;
model Test_CHP_ice

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

  extends Basics.Icons.Checkmodel;
  CHP_ice CHP(
    redeclare function EfficiencyFunction = Basics.Functions.efficiency_linear,
    redeclare function AllocationMethod = Components.Statistics.Functions.CO2Allocation.AllocationMethod_Efficiencies,
    redeclare model Motorblock = Components.Gas.Engines.Engine_idealGas,
    NCV_const=0,
    redeclare Specifications.CHP_630kW Specification)
              annotation (Placement(transformation(extent={{-28,-42},{28,14}})));
  Components.Boundaries.Electrical.Frequency ElectricGrid annotation (Placement(transformation(extent={{54,-70},{76,-48}})));
  Components.Boundaries.Gas.BoundaryIdealGas_pTxi sink(gasModel=simCenter.exhaustGasModel) annotation (Placement(transformation(extent={{-88,34},{-68,54}})));
  inner ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-110,60},{-90,80}})));
  inner SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1) annotation (Placement(transformation(extent={{-110,80},{-90,100}})));
  Controller.ControllerHeatLed controllerHeatLed(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=100,
    Ti=10,
    useGridTemperatures=false,
    Specification=Specifications.CHP_630kW(),
    T_turnOff=368.15)
           annotation (Placement(transformation(extent={{-66,-40},{-46,-20}})));
  Components.Boundaries.Gas.BoundaryIdealGas_pTxi gasSource(gasModel=simCenter.gasModel2, variable_xi=true) annotation (Placement(transformation(extent={{-86,-12},{-66,8}})));
  Components.Boundaries.Gas.RealGasCompositionByWtFractions_stepVariation gasCompositionByWtFractions_stepVariation(
    xi_start=simCenter.gasModel2.xi_default,
    xiNumber=7,
    stepsize=0.011687,
    period=1800) annotation (Placement(transformation(extent={{-114,-11},{-96,7}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow waterSource(
    m_flow_const=1,
    variable_m_flow=true,
    T_const=273.15 + 55)  annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={70,-22})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi waterSink(p_const=
        simCenter.p_n[2]) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,13})));
  Components.Sensors.TemperatureSensor temperatureWaterIn(unitOption=2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,-8})));
  Components.Sensors.TemperatureSensor temperatureWaterOut(unitOption=2) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={50,32})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=8*3600,
    startTime=3600,
    height=5,
    offset=5)       annotation (Placement(transformation(extent={{110,-26},{90,-6}})));
  Components.Sensors.IdealGas.GasMassflowSensor fuelGasMassflowSensor(xiNumber=7) annotation (Placement(transformation(extent={{-60,-2},{-40,18}})));
  Components.Sensors.IdealGas.GasMassflowSensor exhaustGasMassflowSensor(xiNumber=2, medium=simCenter.exhaustGasModel) annotation (Placement(transformation(extent={{-42,44},{-62,64}})));
equation
  connect(CHP.epp, ElectricGrid.epp) annotation (Line(
      points={{28,-25.2},{28,-25.2},{28,-26},{44,-26},{44,-59.11},{53.89,-59.11}},
      color={0,135,135},
      thickness=0.5));
  connect(controllerHeatLed.controlBus, CHP.controlBus) annotation (Line(points={{-46,-26},{-46,-26},{-38,-26},{-38,-8.4},{-28,-8.4}},   color={255,0,0}));
  connect(gasCompositionByWtFractions_stepVariation.xi, gasSource.xi) annotation (Line(points={{-96,-2},{-92,-2},{-92,-8},{-88,-8}}, color={0,0,127}));
  connect(temperatureWaterIn.port,waterSource. steam_a) annotation (Line(
      points={{50,-18},{50,-18},{50,-22},{60,-22}},
      color={0,131,169},
      thickness=0.5));
  connect(waterSource.m_flow, ramp.y) annotation (Line(points={{82,-16},{82,-16},{89,-16}}, color={0,0,127}));
  connect(CHP.waterPortOut, waterSink.steam_a) annotation (Line(
      points={{28,12.6},{44,12.6},{44,13},{60,13}},
      color={175,0,0},
      thickness=0.5));
  connect(CHP.waterPortOut, temperatureWaterOut.port) annotation (Line(
      points={{28,12.6},{50,12.6},{50,22}},
      color={175,0,0},
      thickness=0.5));
  connect(waterSource.steam_a, CHP.waterPortIn) annotation (Line(
      points={{60,-22},{48,-22},{34,-22},{34,5.32},{28,5.32}},
      color={0,131,169},
      thickness=0.5));
  connect(gasSource.gasPort, fuelGasMassflowSensor.inlet) annotation (Line(
      points={{-66,-2},{-66,-2},{-60,-2}},
      color={255,213,170},
      thickness=1.25));
  connect(fuelGasMassflowSensor.outlet, CHP.gasPortIn) annotation (Line(
      points={{-40,-2},{-28.28,-2},{-28.28,-1.96}},
      color={255,213,170},
      thickness=1.25));
  connect(sink.gasPort, exhaustGasMassflowSensor.outlet) annotation (Line(
      points={{-68,44},{-68,44},{-62,44}},
      color={255,213,170},
      thickness=1.25));
  connect(exhaustGasMassflowSensor.inlet, CHP.gasPortOut) annotation (Line(
      points={{-42,44},{-36,44},{-36,8.4},{-28,8.4}},
      color={255,213,170},
      thickness=1.25));
  annotation (
    Diagram(coordinateSystem(extent={{-120,-100},{120,100}})),
    Icon(coordinateSystem(extent={{-120,-100},{120,100}})),
    experiment(
      StopTime=86400,
      Interval=900,
      Tolerance=1e-006),
    __Dymola_experimentSetupOutput(inputs=false, events=false),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end Test_CHP_ice;
