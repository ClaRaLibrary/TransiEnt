within TransiEnt.Components.Gas.Engines.Check;
model Test_Engine_idealGas

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-BSD-clause.           //
// Copyright 2021, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE, ResiliEntEE, IntegraNet and IntegraNet II are research projects  //
// supported by the German Federal Ministry of Economics and Energy               //
// (FKZ 03ET4003, 03ET4048, 0324027 and 03EI1008).                                //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Fraunhofer Institute for Environmental, Safety, and Energy Technology UMSICHT, //
// Gas- und Wärme-Institut Essen						  //
// and                                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//



  extends Basics.Icons.Checkmodel;
  Engine_idealGas engine(
    Specification=Producer.Combined.SmallScaleCHP.Specifications.Dachs_HKA_G_5_5kW(),
    redeclare model MechanicModel = Mechanics.DynamicEngineMechanics,
    redeclare model HeatFlowModel = HeatFlow.DynamicHeatFlow_simple) annotation (Placement(transformation(extent={{-24,-26},{28,26}})));
  Electrical.Machines.ActivePowerGenerator activePowerGenerator annotation (Placement(transformation(extent={{46,-30},{66,-10}})));
  Boundaries.Electrical.ActivePower.Frequency ElectricGrid annotation (Placement(transformation(extent={{74,-30},{94,-10}})));
  Boundaries.Gas.BoundaryIdealGas_pTxi sink(gasModel=simCenter.exhaustGasModel) annotation (Placement(transformation(extent={{-60,26},{-40,46}})));
  Boundaries.Gas.BoundaryIdealGas_pTxi gasSource(
    gasModel=simCenter.gasModel2,
    variable_xi=true) annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Boundaries.Gas.RealGasCompositionByWtFractions_stepVariation            gasCompositionByWtFractions_stepVariation(
    period=900,
    xiNumber=7,
    stepsize=0.011687,
    xi_in(start=simCenter.gasModel2.xi_default))
                   annotation (Placement(transformation(extent={{-94,1},{-76,19}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow waterSource(T_const=273.15 + 65,
    m_flow_const=1,
    variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-32,-84})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi waterSink(p_const=simCenter.p_nom[2]) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={60,-84})));
  inner SimCenter           simCenter(
    redeclare TransiEnt.Basics.Media.Gases.Gas_VDIWA_NG7_H2_var gasModel2,
    redeclare TransiEnt.Basics.Tables.HeatGrid.HeatingCurves.HeatingCurveEONHanse heatingCurve,
    ambientConditions(redeclare TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_Fuhlsbuettel_3600s_2012 temperature))
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner ModelStatistics           modelStatistics
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  Modelica.Blocks.Sources.Sine sine(
    f=2/86400,
    amplitude=0,
    offset=5.5e3) annotation (Placement(transformation(extent={{-94,-28},{-74,-8}})));
  Modelica.Blocks.Sources.BooleanPulse booleanStep(startTime=3600, period=8*3600)
                                                                  annotation (Placement(transformation(extent={{-94,-60},{-74,-40}})));

  Sensors.TemperatureSensor temperatureWaterIn(unitOption=2)
                                                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-8,-64})));
  Sensors.TemperatureSensor temperatureWaterOut(unitOption=2)
                                                annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={38,-64})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=8*3600,
    startTime=3600,
    height=0.05,
    offset=0.07)    annotation (Placement(transformation(extent={{-70,-88},{-50,-68}})));
  Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem dummyExcitationSystem annotation (Placement(transformation(extent={{68,-2},{48,18}})));
equation
  connect(engine.mpp, activePowerGenerator.mpp) annotation (Line(points={{28,-20.02},{36,-20.02},{36,-20},{46,-20}},       color={95,95,95}));
  connect(activePowerGenerator.epp, ElectricGrid.epp) annotation (Line(
      points={{66.1,-20.1},{70,-20.1},{70,-20},{74,-20}},
      color={0,135,135},
      thickness=0.5));
  connect(gasCompositionByWtFractions_stepVariation.xi, gasSource.xi) annotation (Line(points={{-76,10},{-66,10},{-66,4},{-62,4}}, color={0,0,127}));
  connect(gasSource.gasPort, engine.gasPortIn) annotation (Line(
      points={{-40,10},{-24,10},{-24,10.4}},
      color={255,213,170},
      thickness=1.5));
  connect(sink.gasPort, engine.gasPortOut) annotation (Line(
      points={{-40,36},{-34,36},{-34,23.4},{-24,23.4}},
      color={255,213,170},
      thickness=1.5));
  connect(waterSource.steam_a, engine.waterPortIn) annotation (Line(
      points={{-22,-84},{-22,-84},{4.6,-84},{4.6,-26}},
      color={0,131,169},
      thickness=0.5));
  connect(engine.waterPortOut, waterSink.steam_a) annotation (Line(
      points={{25.4,-26},{25.4,-84},{50,-84}},
      color={175,0,0},
      thickness=0.5));
  connect(booleanStep.y, engine.switch) annotation (Line(points={{-73,-50},{-42,-50},{-42,-13},{-23.48,-13}}, color={255,0,255}));
  connect(sine.y, engine.P_el_set) annotation (Line(points={{-73,-18},{-52,-18},{-52,-8},{-32,-8},{-32,0},{-23.48,0}}, color={0,0,127}));
  connect(temperatureWaterIn.port, waterSource.steam_a) annotation (Line(
      points={{-8,-74},{-8,-74},{-8,-84},{-22,-84}},
      color={0,131,169},
      thickness=0.5));
  connect(engine.waterPortOut, temperatureWaterOut.port) annotation (Line(
      points={{25.4,-26},{25.4,-84},{38,-84},{38,-74}},
      color={175,0,0},
      thickness=0.5));
  connect(waterSource.m_flow, ramp.y) annotation (Line(points={{-44,-78},{-49,-78}}, color={0,0,127}));
  connect(dummyExcitationSystem.y, activePowerGenerator.E_input) annotation (Line(points={{47.4,8},{40,8},{40,-10.1},{55.7,-10.1}}, color={0,0,127}));
  connect(dummyExcitationSystem.epp1, activePowerGenerator.epp) annotation (Line(
      points={{68,8},{68,-6},{68,-20.1},{66.1,-20.1}},
      color={0,135,135},
      thickness=0.5));
  annotation (
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
<p>Test environment for the Engine_idealGas model</p>
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
end Test_Engine_idealGas;
