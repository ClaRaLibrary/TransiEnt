within TransiEnt.Components.Gas.Compressor.Check;
model TestCompressors
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

  extends TransiEnt.Basics.Icons.Checkmodel;

  inner TransiEnt.SimCenter simCenter(redeclare Basics.Media.Gases.VLE_VDIWA_NG7_H2_SRK_var gasModel1)   annotation (Placement(transformation(extent={{-90,-100},{-70,-80}})));
  CompressorRealGasIsentropicEff_L1_simple                                     compressorRealGasIsentropicEff_L1_simple(
    presetVariableType="m_flow",
    P_el_n(displayUnit="MW") = 10000000,
    redeclare model CostSpecsGeneral = Statistics.ConfigurationData.GeneralCostSpecs.IonicCompressor,
    m_flowInput=true)
    annotation (Placement(transformation(extent={{-10,60},{10,40}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi source1(p_const=5000000, T_const=293.15) annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink1(p_const=17500000) annotation (Placement(transformation(extent={{60,40},{40,60}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi source2(p_const=5000000, T_const=293.15) annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink2(p_const=17500000) annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  CompressorRealGasIsothermal_L1_simple                                     compressorRealGasIsothermal_L1_simple(
    presetVariableType="m_flow",
    P_el_n(displayUnit="MW") = 10000000,
    redeclare model CostSpecsGeneral = Statistics.ConfigurationData.GeneralCostSpecs.IonicCompressor,
    m_flowInput=true)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  inner ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-70,-100},{-50,-80}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=0.5,
    duration=500,
    offset=0.5,
    startTime=250) annotation (Placement(transformation(extent={{-86,14},{-66,34}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi source3(p_const=5000000, T_const=293.15) annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink3(variable_p=true) annotation (Placement(transformation(extent={{60,-70},{40,-50}})));
  CompressorRealGasIsothermal_L1_simple                                     compressorRealGasIsothermal_L1_simple1(
    presetVariableType="m_flow",
    P_el_n(displayUnit="MW") = 10000000,
    redeclare model CostSpecsGeneral = Statistics.ConfigurationData.GeneralCostSpecs.IonicCompressor,
    m_flowInput=true)
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=500,
    startTime=250,
    height=50e5,
    offset=100e5) annotation (Placement(transformation(extent={{94,-64},{74,-44}})));
  Controller.ControllerCompressor_dp controllerCompressor_dp annotation (Placement(transformation(extent={{-18,-40},{2,-20}})));
  Sensors.RealGas.PressureSensor pressureSensor annotation (Placement(transformation(extent={{14,-60},{34,-40}})));
equation
  connect(source1.gasPort, compressorRealGasIsentropicEff_L1_simple.gasPortIn) annotation (Line(
      points={{-40,50},{-40,50},{-10,50}},
      color={255,255,0},
      thickness=1.5));
  connect(compressorRealGasIsentropicEff_L1_simple.gasPortOut, sink1.gasPort) annotation (Line(
      points={{10,50},{10,50},{40,50}},
      color={255,255,0},
      thickness=1.5));
  connect(compressorRealGasIsothermal_L1_simple.gasPortOut, sink2.gasPort) annotation (Line(
      points={{10,0},{40,0}},
      color={255,255,0},
      thickness=1.5));
  connect(compressorRealGasIsothermal_L1_simple.gasPortIn, source2.gasPort) annotation (Line(
      points={{-10,0},{-40,0}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp.y, compressorRealGasIsentropicEff_L1_simple.m_flow_in) annotation (Line(points={{-65,24},{-8,24},{-8,39}}, color={0,0,127}));
  connect(compressorRealGasIsothermal_L1_simple.m_flow_in, ramp.y) annotation (Line(points={{-8,11},{-8,24},{-65,24}}, color={0,0,127}));
  connect(source3.gasPort, compressorRealGasIsothermal_L1_simple1.gasPortIn) annotation (Line(
      points={{-40,-60},{-25,-60},{-10,-60}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp1.y, sink3.p) annotation (Line(points={{73,-54},{68,-54},{62,-54}}, color={0,0,127}));
  connect(controllerCompressor_dp.Delta_p, compressorRealGasIsothermal_L1_simple1.m_flow_in) annotation (Line(points={{-8,-41},{-8,-49}}, color={0,0,127}));
  connect(compressorRealGasIsothermal_L1_simple1.gasPortOut, pressureSensor.gasPortIn) annotation (Line(
      points={{10,-60},{14,-60}},
      color={255,255,0},
      thickness=1.5));
  connect(pressureSensor.gasPortOut, sink3.gasPort) annotation (Line(
      points={{34,-60},{40,-60}},
      color={255,255,0},
      thickness=1.5));
  connect(pressureSensor.p, controllerCompressor_dp.p_afterCompIn) annotation (Line(points={{35,-50},{36,-50},{36,-46},{36,-30},{2,-30}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
          Documentation(info="<html>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016<br> </p>
</html>"),
    experiment(StopTime=1000));
end TestCompressors;
