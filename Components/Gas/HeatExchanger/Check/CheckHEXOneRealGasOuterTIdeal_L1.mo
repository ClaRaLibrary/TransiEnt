within TransiEnt.Components.Gas.HeatExchanger.Check;
model CheckHEXOneRealGasOuterTIdeal_L1

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
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
  HEXOneRealGasOuterTIdeal_L1 hEXOneRealGasOuterTIdeal_L1_varT_onlyHeat(hEXMode="HeatingAndCooling", use_T_fluidOutConst=false) annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi annotation (Placement(transformation(extent={{40,40},{20,60}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow(variable_T=true, m_flow_const=-1) annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,80})));
  Modelica.Blocks.Sources.Cosine cosine(
    amplitude=20,
    freqHz=1,
    offset=293.15) annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=5,
    freqHz=1.5,
    offset=293.15) annotation (Placement(transformation(extent={{80,80},{60,100}})));
  HEXOneRealGasOuterTIdeal_L1 hEXOneRealGasOuterTIdeal_L1_varT_onlyHeat1(hEXMode="HeatingOnly", use_T_fluidOutConst=false) annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi1 annotation (Placement(transformation(extent={{40,-20},{20,0}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow1(variable_T=true, m_flow_const=-1) annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T=293.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,20})));
  HEXOneRealGasOuterTIdeal_L1 hEXOneRealGasOuterTIdeal_L1_varT_onlyHeat2(hEXMode="CoolingOnly", use_T_fluidOutConst=false) annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi2 annotation (Placement(transformation(extent={{40,-80},{20,-60}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow2(variable_T=true, m_flow_const=-1) annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature2(T=293.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-40})));
equation
  connect(boundary_Txim_flow.gasPort, hEXOneRealGasOuterTIdeal_L1_varT_onlyHeat.gasPortIn) annotation (Line(
      points={{-20,50},{-10,50}},
      color={255,255,0},
      thickness=1.5));
  connect(boundary_pTxi.gasPort, hEXOneRealGasOuterTIdeal_L1_varT_onlyHeat.gasPortOut) annotation (Line(
      points={{20,50},{10,50}},
      color={255,255,0},
      thickness=1.5));
  connect(fixedTemperature.port, hEXOneRealGasOuterTIdeal_L1_varT_onlyHeat.heat) annotation (Line(points={{0,70},{0,60}}, color={191,0,0}));
  connect(cosine.y, boundary_Txim_flow.T) annotation (Line(points={{-59,50},{-42,50}}, color={0,0,127}));
  connect(hEXOneRealGasOuterTIdeal_L1_varT_onlyHeat.T_fluidOutVar_set, sine.y) annotation (Line(points={{10,54},{18,54},{18,90},{59,90}}, color={0,0,127}));
  connect(boundary_Txim_flow1.gasPort, hEXOneRealGasOuterTIdeal_L1_varT_onlyHeat1.gasPortIn) annotation (Line(
      points={{-20,-10},{-10,-10}},
      color={255,255,0},
      thickness=1.5));
  connect(boundary_pTxi1.gasPort, hEXOneRealGasOuterTIdeal_L1_varT_onlyHeat1.gasPortOut) annotation (Line(
      points={{20,-10},{10,-10}},
      color={255,255,0},
      thickness=1.5));
  connect(fixedTemperature1.port, hEXOneRealGasOuterTIdeal_L1_varT_onlyHeat1.heat) annotation (Line(points={{0,10},{0,0}}, color={191,0,0}));
  connect(cosine.y, boundary_Txim_flow1.T) annotation (Line(points={{-59,50},{-50,50},{-50,-10},{-42,-10}}, color={0,0,127}));
  connect(hEXOneRealGasOuterTIdeal_L1_varT_onlyHeat1.T_fluidOutVar_set, sine.y) annotation (Line(points={{10,-6},{18,-6},{18,90},{59,90}}, color={0,0,127}));
  connect(boundary_Txim_flow2.gasPort, hEXOneRealGasOuterTIdeal_L1_varT_onlyHeat2.gasPortIn) annotation (Line(
      points={{-20,-70},{-10,-70}},
      color={255,255,0},
      thickness=1.5));
  connect(boundary_pTxi2.gasPort, hEXOneRealGasOuterTIdeal_L1_varT_onlyHeat2.gasPortOut) annotation (Line(
      points={{20,-70},{10,-70}},
      color={255,255,0},
      thickness=1.5));
  connect(fixedTemperature2.port, hEXOneRealGasOuterTIdeal_L1_varT_onlyHeat2.heat) annotation (Line(points={{0,-50},{0,-60}}, color={191,0,0}));
  connect(cosine.y, boundary_Txim_flow2.T) annotation (Line(points={{-59,50},{-50,50},{-50,-70},{-42,-70}}, color={0,0,127}));
  connect(hEXOneRealGasOuterTIdeal_L1_varT_onlyHeat2.T_fluidOutVar_set, sine.y) annotation (Line(points={{10,-66},{18,-66},{18,90},{59,90}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end CheckHEXOneRealGasOuterTIdeal_L1;
