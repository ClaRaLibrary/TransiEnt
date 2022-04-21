within TransiEnt.Components.Gas.Compressor.Check;
model TestCompressors "Model for testing compressors"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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





  extends TransiEnt.Basics.Icons.Checkmodel;

  inner TransiEnt.SimCenter simCenter(redeclare Basics.Media.Gases.VLE_VDIWA_NG7_H2_SRK_var gasModel1)   annotation (Placement(transformation(extent={{-90,-100},{-70,-80}})));
  CompressorRealGasIsentropicEff_L1_simple                                     compressorRealGasIsentropicEff_L1_simple(
    presetVariableType="m_flow",
    useMechPowerPort=true,
    P_el_n(displayUnit="MW") = 10000000,
    redeclare model CostSpecsGeneral = Statistics.ConfigurationData.GeneralCostSpecs.IonicCompressor,
    m_flowInput=true,
    Cspec_demAndRev_el(displayUnit="EUR/MWh") = 2.7777777777778e-08)
    annotation (Placement(transformation(extent={{-10,60},{10,40}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi source1(p_const=5000000, T_const=293.15) annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink1(p_const=17500000) annotation (Placement(transformation(extent={{60,40},{40,60}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi source2(p_const=5000000, T_const=293.15) annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink2(p_const=17500000) annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  CompressorRealGasIsothermal_L1_simple                                     compressorRealGasIsothermal_L1_simple(
    presetVariableType="m_flow",
    P_el_n(displayUnit="MW") = 10000000,
    redeclare model CostSpecsGeneral = Statistics.ConfigurationData.GeneralCostSpecs.IonicCompressor,
    m_flowInput=true,
    Cspec_demAndRev_el(displayUnit="EUR/MWh") = 2.7777777777778e-08)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  inner ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-70,-100},{-50,-80}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=0.5,
    duration=500,
    offset=0.5,
    startTime=250) annotation (Placement(transformation(extent={{-86,14},{-66,34}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink3(variable_p=true) annotation (Placement(transformation(extent={{60,-70},{40,-50}})));
  CompressorRealGasIsothermal_L1_simple                                     compressorRealGasIsothermal_L1_simple1(
    presetVariableType="dp",
    use_Delta_p_input=true,
    P_el_n(displayUnit="MW") = 10000000,
    redeclare model CostSpecsGeneral = Statistics.ConfigurationData.GeneralCostSpecs.IonicCompressor,
    m_flowInput=false,
    Cspec_demAndRev_el(displayUnit="EUR/MWh") = 2.7777777777778e-8)
    annotation (Placement(transformation(extent={{-12,-70},{8,-50}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=500,
    startTime=250,
    height=50e5,
    offset=100e5) annotation (Placement(transformation(extent={{94,-64},{74,-44}})));
  Controller.ControllerCompressor_dp controllerCompressor_dp annotation (Placement(transformation(extent={{-18,-38},{2,-18}})));
  Sensors.RealGas.PressureSensor pressureSensor annotation (Placement(transformation(extent={{14,-60},{34,-40}})));
  Boundaries.Gas.BoundaryRealGas_Txim_flow source3(m_flow_const=1) annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Electrical.Machines.MotorComplex motorComplex(eta=0.97) annotation (Placement(transformation(extent={{6,66},{26,86}})));
  Boundaries.Electrical.ComplexPower.SlackBoundary slackBoundary annotation (Placement(transformation(extent={{36,66},{56,86}})));
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
  connect(ramp1.y, sink3.p) annotation (Line(points={{73,-54},{68,-54},{62,-54}}, color={0,0,127}));
  connect(compressorRealGasIsothermal_L1_simple1.gasPortOut, pressureSensor.gasPortIn) annotation (Line(
      points={{8,-60},{14,-60}},
      color={255,255,0},
      thickness=1.5));
  connect(pressureSensor.gasPortOut, sink3.gasPort) annotation (Line(
      points={{34,-60},{40,-60}},
      color={255,255,0},
      thickness=1.5));
  connect(pressureSensor.p, controllerCompressor_dp.p_afterCompIn) annotation (Line(points={{35,-50},{36,-50},{36,-28},{2,-28}},          color={0,0,127}));
  connect(compressorRealGasIsothermal_L1_simple1.gasPortIn, source3.gasPort) annotation (Line(
      points={{-12,-60},{-40,-60}},
      color={255,255,0},
      thickness=1.5));
  connect(controllerCompressor_dp.Delta_p, compressorRealGasIsothermal_L1_simple1.dp_in) annotation (Line(points={{-8,-39},{-8,-46},{6,-46},{6,-49}}, color={0,0,127}));
  connect(motorComplex.mpp, compressorRealGasIsentropicEff_L1_simple.mpp) annotation (Line(points={{6,76},{0,76},{0,60}}, color={95,95,95}));
  connect(motorComplex.epp, slackBoundary.epp) annotation (Line(
      points={{26.1,75.9},{32.05,75.9},{32.05,76},{36,76}},
      color={28,108,200},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for compressors</p>
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
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016</p>
</html>"),
    experiment(StopTime=1000));
end TestCompressors;
