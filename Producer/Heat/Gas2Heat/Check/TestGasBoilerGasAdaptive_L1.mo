within TransiEnt.Producer.Heat.Gas2Heat.Check;
model TestGasBoilerGasAdaptive_L1
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
  extends Basics.Icons.Checkmodel;
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={38,0})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source(
    variable_m_flow=false,
    m_flow_const=100,
    T_const=60 + 273) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-32,0})));
  GasBoilerCompositionAdaptive gasBoilerGasAdaptive annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-50e6,
    offset=-100e6,
    duration=0.6,
    startTime=0.2)
    annotation (Placement(transformation(extent={{-64,20},{-44,40}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi gasSource(variable_xi=true) annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  inner ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
  Modelica.Blocks.Sources.Constant
                               ramp1(k=-100e6)
    annotation (Placement(transformation(extent={{-64,48},{-44,68}})));
  Components.Boundaries.Gas.RealGasCompositionByWtFractions_stepVariation composition_linearVariation(stepsize=0.1, period=0.2) annotation (Placement(transformation(extent={{-56,-66},{-36,-46}})));
equation
  connect(composition_linearVariation.xi, gasSource.xi) annotation (Line(points={{-36,-56},{-22,-56}}, color={0,0,127}));
  connect(gasBoilerGasAdaptive.outlet, sink.steam_a) annotation (Line(
      points={{10,0},{10,0},{28,0}},
      color={175,0,0},
      thickness=0.5));
  connect(gasBoilerGasAdaptive.inlet, source.steam_a) annotation (Line(
      points={{-9.8,0},{-9.8,0},{-18,0},{-22,0}},
      color={175,0,0},
      thickness=0.5));
  connect(gasSource.gasPort, gasBoilerGasAdaptive.gasIn) annotation (Line(
      points={{0,-50},{0,-10},{0.2,-10}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp1.y, gasBoilerGasAdaptive.Q_flow_set) annotation (Line(points={{-43,58},{0,58},{0,10}},            color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end TestGasBoilerGasAdaptive_L1;
