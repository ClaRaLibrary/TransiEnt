within TransiEnt.Producer.Heat.Check;
model TestGasBoilers_L1
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
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={40,-1})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source(
    variable_m_flow=false,
    m_flow_const=100,
    T_const=60 + 273) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-74,-1})));
  GasBoilerCompositionAdaptive gasBoilerGasAdaptive annotation (Placement(transformation(extent={{-46,-24},{-4,20}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-50e6,
    offset=-100e6,
    duration=0.6,
    startTime=0.2)
    annotation (Placement(transformation(extent={{-90,14},{-70,34}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi gasSourceAdaptive(variable_xi=true) annotation (Placement(transformation(extent={{-44,-56},{-24,-36}})));
  inner ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
  Modelica.Blocks.Sources.Constant
                               ramp1(k=-100e6)
    annotation (Placement(transformation(extent={{-90,42},{-70,62}})));
  Components.Boundaries.Gas.RealGasCompositionByWtFractions_stepVariation composition_linearVariation(stepsize=0.1, period=0.2) annotation (Placement(transformation(extent={{-84,-80},{-64,-60}})));
  SimpleGasboilerGasport gasBoiler annotation (Placement(transformation(extent={{-12,28},{30,72}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source1(
    variable_m_flow=false,
    m_flow_const=100,
    T_const=60 + 273) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-38,50})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink1(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={54,50})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi gasSource(variable_xi=true) annotation (Placement(transformation(extent={{-12,-74},{8,-54}})));
equation
  connect(composition_linearVariation.xi, gasSourceAdaptive.xi) annotation (Line(points={{-64,-70},{-54,-70},{-54,-52},{-46,-52}}, color={0,0,127}));
  connect(gasBoilerGasAdaptive.outlet, sink.steam_a) annotation (Line(
      points={{-4,-2},{-4,-1},{30,-1}},
      color={175,0,0},
      thickness=0.5));
  connect(gasBoilerGasAdaptive.inlet, source.steam_a) annotation (Line(
      points={{-45.58,-2},{-45.58,-1},{-64,-1}},
      color={175,0,0},
      thickness=0.5));
  connect(gasSourceAdaptive.gasPort, gasBoilerGasAdaptive.gasIn) annotation (Line(
      points={{-24,-46},{-24,-24},{-24.58,-24}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp1.y, gasBoilerGasAdaptive.Q_flow_set) annotation (Line(points={{-69,52},{-54,52},{-54,20},{-25,20}}, color={0,0,127}));
  connect(ramp1.y, gasBoiler.Q_flow_set) annotation (Line(points={{-69,52},{-54,52},{-54,72},{9,72}},   color={0,0,127}));
  connect(gasBoiler.outlet, sink1.steam_a) annotation (Line(
      points={{30,50},{30,50},{44,50}},
      color={175,0,0},
      thickness=0.5));
  connect(gasBoiler.inlet, source1.steam_a) annotation (Line(
      points={{-11.58,50},{-28,50}},
      color={175,0,0},
      thickness=0.5));
  connect(gasSource.gasPort, gasBoiler.gasIn) annotation (Line(
      points={{8,-64},{9.42,-64},{9.42,28}},
      color={255,255,0},
      thickness=1.5));
  connect(composition_linearVariation.xi, gasSource.xi) annotation (Line(points={{-64,-70},{-52,-70},{-14,-70}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end TestGasBoilers_L1;
