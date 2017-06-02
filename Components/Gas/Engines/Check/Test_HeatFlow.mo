within TransiEnt.Components.Gas.Engines.Check;
model Test_HeatFlow
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
  inner parameter TransiEnt.Producer.Combined.SmallScaleCHP.Specifications.Dachs_HKA_G_5_5kW Specification;
  TransiEnt.Components.Gas.Engines.HeatFlow.StaticHeatFlow staticHeatFlow annotation (Placement(transformation(extent={{-28,-30},{28,14}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow waterSource(T_const=273.15 + 65, m_flow_const=1,
    variable_m_flow=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={74,-24})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi waterSink(p_const=
        simCenter.p_n[2]) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={74,8})));
  Sensors.TemperatureSensor temperatureWaterIn(unitOption=2)
                                                annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={52,-38})));
  Sensors.TemperatureSensor temperatureWaterOut(unitOption=2)
                                                annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={52,28})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=2/86400,
    amplitude=0,
    offset=5.5e3)
                annotation (Placement(transformation(extent={{-74,-8},{-54,12}})));
  Modelica.Blocks.Sources.BooleanPulse booleanStep(startTime=3600, period=8*3600,
    width=100)                                                    annotation (Placement(transformation(extent={{-74,-40},{-54,-20}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=8*3600,
    startTime=3600,
    height=0.05,
    offset=0.07)    annotation (Placement(transformation(extent={{66,-64},{86,-44}})));
  Mechanics.StaticEngineMechanics staticEngineMechanics annotation (Placement(transformation(extent={{-20,42},{18,76}})));
  Electrical.Machines.ActivePowerGenerator activePowerGenerator annotation (Placement(transformation(extent={{28,50},{48,70}})));
  Boundaries.Electrical.Frequency ElectricGrid annotation (Placement(transformation(extent={{56,50},{76,70}})));
equation
  connect(temperatureWaterIn.port,waterSource. steam_a) annotation (Line(
      points={{52,-28},{52,-24},{64,-24}},
      color={0,131,169},
      thickness=0.5));
  connect(staticHeatFlow.P_el_set, sine.y) annotation (Line(points={{-28,0.25},{-40,0.25},{-40,2},{-53,2}},
                                                                                      color={0,0,127}));
  connect(staticHeatFlow.waterPortOut, waterSink.steam_a) annotation (Line(
      points={{28,8.5},{42,8},{64,8}},
      color={175,0,0},
      thickness=0.5));
  connect(staticHeatFlow.waterPortOut, temperatureWaterOut.port) annotation (Line(
      points={{28,8.5},{52,8.5},{52,18}},
      color={175,0,0},
      thickness=0.5));
  connect(waterSource.steam_a, staticHeatFlow.waterPortIn) annotation (Line(
      points={{64,-24},{64,-24.5},{28,-24.5}},
      color={0,131,169},
      thickness=0.5));
  connect(booleanStep.y, staticHeatFlow.switch) annotation (Line(points={{-53,-30},{-40,-30},{-40,-13.5},{-28,-13.5}},
                                                                                                                 color={255,0,255}));
  connect(ramp.y, waterSource.m_flow) annotation (Line(points={{87,-54},{96,-54},{96,-18},{86,-18}}, color={0,0,127}));
  connect(staticHeatFlow.TemperaturesOut, staticEngineMechanics.TemperaturesIn) annotation (Line(points={{10.6667,14},{6,14},{6,26.15},{6.03,26.15},{6.03,42.17}}, color={0,0,127}));
  connect(staticEngineMechanics.efficienciesOut, staticHeatFlow.efficiencies) annotation (Line(points={{-8.79,41.83},{-8.79,18.925},{-11.4667,18.925},{-11.4667,14}}, color={0,0,127}));
  connect(booleanStep.y, staticEngineMechanics.switch) annotation (Line(points={{-53,-30},{-44,-30},{-40,-30},{-40,50.5},{-19.62,50.5}}, color={255,0,255}));
  connect(sine.y, staticEngineMechanics.P_el_set) annotation (Line(points={{-53,2},{-48,2},{-48,59},{-19.62,59}}, color={0,0,127}));
  connect(activePowerGenerator.epp,ElectricGrid. epp) annotation (Line(
      points={{48.1,59.9},{55.9,59.9}},
      color={0,135,135},
      thickness=0.5));
  connect(staticEngineMechanics.mpp, activePowerGenerator.mpp) annotation (Line(points={{18.19,58.915},{23.095,58.915},{23.095,59.5},{27.5,59.5}}, color={95,95,95}));
end Test_HeatFlow;