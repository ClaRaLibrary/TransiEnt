within TransiEnt.Producer.Combined.SmallScaleCHP.Check;
model Test_CHP_ice
  import TransiEnt;

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

  extends Basics.Icons.Checkmodel;
  TransiEnt.Producer.Combined.SmallScaleCHP.CHP_ice CHP(
    TypeOfEnergyCarrierElectricity=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.NaturalGas,
    redeclare function AllocationMethod = TransiEnt.Components.Statistics.Functions.CO2Allocation.AllocationMethod_Efficiencies,
    redeclare model Motorblock = Components.Gas.Engines.Engine_idealGas (redeclare model MechanicModel = TransiEnt.Components.Gas.Engines.Mechanics.StaticEngineMechanics),
    NCV_const=0)                                                    annotation (Placement(transformation(extent={{-28,-40},{28,16}})));
    //redeclare function EfficiencyFunction = Basics.Functions.efficiency_linear,
  Components.Boundaries.Electrical.Frequency ElectricGrid annotation (Placement(transformation(extent={{54,-70},{76,-48}})));
  Components.Boundaries.Gas.BoundaryIdealGas_pTxi sink(gasModel=simCenter.exhaustGasModel) annotation (Placement(transformation(extent={{-88,34},{-68,54}})));
  inner ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-110,60},{-90,80}})));
  inner SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1) annotation (Placement(transformation(extent={{-110,80},{-90,100}})));
  Controller.ControllerHeatLed controllerHeatLed(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=100,
    Ti=10,
    useGridTemperatures=false,
    Specification=CHP.Specification,
    T_turnOff=368.15)
           annotation (Placement(transformation(extent={{-64,-40},{-44,-20}})));
  Components.Boundaries.Gas.BoundaryIdealGas_pTxi gasSource(gasModel=simCenter.gasModel2, variable_xi=true) annotation (Placement(transformation(extent={{-86,-12},{-66,8}})));
  Components.Boundaries.Gas.RealGasCompositionByWtFractions_stepVariation gasCompositionByWtFractions_stepVariation(
    xi(
    start =  simCenter.gasModel2.xi_default),
    xiNumber=7,
    stepsize=0.011687,
    period=1800) annotation (Placement(transformation(extent={{-114,-11},{-96,7}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow waterSource(
    variable_T=true,
    m_flow_const=1,
    variable_m_flow=true,
    T_const=273.15 + 55)  annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={70,-22})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi waterSink(p_const=simCenter.p_nom[2]) annotation (Placement(transformation(
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
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=8*3600,
    startTime=3600,
    height=55,
    offset=273 + 45)
                    annotation (Placement(transformation(extent={{112,-60},{92,-40}})));
equation
  connect(CHP.epp, ElectricGrid.epp) annotation (Line(
      points={{28,-23.2},{28,-26},{44,-26},{44,-59},{54,-59}},
      color={0,135,135},
      thickness=0.5));
  connect(controllerHeatLed.controlBus, CHP.controlBus) annotation (Line(points={{-44,-26},{-38,-26},{-38,-6.4},{-28,-6.4}},             color={255,0,0}));
  connect(gasCompositionByWtFractions_stepVariation.xi, gasSource.xi) annotation (Line(points={{-96,-2},{-92,-2},{-92,-8},{-88,-8}}, color={0,0,127}));
  connect(temperatureWaterIn.port,waterSource. steam_a) annotation (Line(
      points={{50,-18},{50,-18},{50,-22},{60,-22}},
      color={0,131,169},
      thickness=0.5));
  connect(waterSource.m_flow, ramp.y) annotation (Line(points={{82,-16},{82,-16},{89,-16}}, color={0,0,127}));
  connect(CHP.waterPortOut, waterSink.steam_a) annotation (Line(
      points={{28,14.6},{44,14.6},{44,13},{60,13}},
      color={175,0,0},
      thickness=0.5));
  connect(CHP.waterPortOut, temperatureWaterOut.port) annotation (Line(
      points={{28,14.6},{50,14.6},{50,22}},
      color={175,0,0},
      thickness=0.5));
  connect(waterSource.steam_a, CHP.waterPortIn) annotation (Line(
      points={{60,-22},{34,-22},{34,7.32},{28,7.32}},
      color={0,131,169},
      thickness=0.5));
  connect(gasSource.gasPort, fuelGasMassflowSensor.inlet) annotation (Line(
      points={{-66,-2},{-66,-2},{-60,-2}},
      color={255,213,170},
      thickness=1.25));
  connect(fuelGasMassflowSensor.outlet, CHP.gasPortIn) annotation (Line(
      points={{-40,-2},{-28.28,-2},{-28.28,0.04}},
      color={255,213,170},
      thickness=1.25));
  connect(sink.gasPort, exhaustGasMassflowSensor.outlet) annotation (Line(
      points={{-68,44},{-68,44},{-62,44}},
      color={255,213,170},
      thickness=1.25));
  connect(exhaustGasMassflowSensor.inlet, CHP.gasPortOut) annotation (Line(
      points={{-42,44},{-36,44},{-36,10.4},{-28,10.4}},
      color={255,213,170},
      thickness=1.25));
  connect(waterSource.T, ramp1.y) annotation (Line(points={{82,-22},{84,-22},{84,-50},{91,-50}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent={{-120,-100},{120,100}})),
    Icon(graphics,
         coordinateSystem(extent={{-120,-100},{120,100}})),
    experiment(
      StopTime=86400,
      Interval=900,
      Tolerance=1e-006),
    __Dymola_experimentSetupOutput(inputs=false, events=false),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for chp plants<b><span style=\"color: #008000;\"> </span></b>with internal combustion engines</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
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
</html>"));
end Test_CHP_ice;
