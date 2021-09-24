within TransiEnt.Producer.Heat.Gas2Heat.Check;
model HeatPumpGasCharlineTest

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



  extends TransiEnt.Basics.Icons.Checkmodel;
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=308.15) annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-48,22})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=1500,
    f=1/86400,
    offset=2000) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-90,50})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(extent={{-74,46},{-66,54}})));
  Modelica.Blocks.Sources.Sine sine2(
    f=1/86400,
    amplitude=15,
    phase=1.5707963267949,
    offset=-5 + 273.15) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-70,80})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T=308.15)
                                                                                    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=270,
        origin={60,22})));
  Modelica.Blocks.Sources.Sine sine1(
    amplitude=1500,
    f=1/86400,
    offset=2000) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={20,50})));
  Modelica.Blocks.Sources.Sine sine3(
    f=1/86400,
    amplitude=15,
    phase=1.5707963267949,
    offset=-5 + 273.15) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={40,80})));
  Modelica.Blocks.Sources.Sine sine4(
    amplitude=1500,
    f=1/86400,
    offset=2000) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-90,-50})));
  HeatPumpGasCharline heatPump2(use_T_source_input_K=true, COP_n=4) annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Blocks.Math.Gain gain1(k=-1)
                                       annotation (Placement(transformation(extent={{-74,-54},{-66,-46}})));
  Modelica.Blocks.Sources.Sine sine5(
    f=1/86400,
    amplitude=15,
    phase=1.5707963267949,
    offset=-5 + 273.15) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-70,-20})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_Txim_flow boundaryVLE_Txim_flow(variable_m_flow=false, boundaryConditions(m_flow_const=-1)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,-80})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_pTxi boundaryVLE_pTxi(boundaryConditions(p_const(displayUnit="bar") = 100000)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-80})));
  Modelica.Blocks.Sources.Sine sine6(
    amplitude=1500,
    f=1/86400,
    offset=2000) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={20,-50})));
  HeatPumpGasCharline heatPump3(
    use_T_source_input_K=true,
    COP_n=4,
    use_Q_flow_input=false) annotation (Placement(transformation(extent={{50,-60},{70,-40}})));
  Modelica.Blocks.Sources.Sine sine7(
    f=1/86400,
    amplitude=15,
    phase=1.5707963267949,
    offset=-5 + 273.15) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={40,-20})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_Txim_flow boundaryVLE_Txim_flow1(variable_m_flow=false, boundaryConditions(m_flow_const=-1)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,-80})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_pTxi boundaryVLE_pTxi1(boundaryConditions(p_const(displayUnit="bar") = 100000)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-80})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi annotation (Placement(transformation(extent={{-8,36},{-28,56}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi1 annotation (Placement(transformation(extent={{-10,-64},{-30,-44}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi2 annotation (Placement(transformation(extent={{100,36},{80,56}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi3 annotation (Placement(transformation(extent={{100,-64},{80,-44}})));
  HeatPumpGasCharline heatPump(use_T_source_input_K=true, useFluidPorts=false) annotation (Placement(transformation(extent={{-58,40},{-38,60}})));
  HeatPumpGasCharline heatPump1(use_T_source_input_K=true, useFluidPorts=false) annotation (Placement(transformation(extent={{50,40},{70,60}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-20,80},{0,100}})));
equation
  connect(gain.y, heatPump.Q_flow_set) annotation (Line(points={{-65.6,50},{-58,50}}, color={0,0,127}));
  connect(sine.y, gain.u) annotation (Line(points={{-79,50},{-74.8,50}},
                                                                       color={0,0,127}));
  connect(heatPump1.heat, fixedTemperature1.port) annotation (Line(points={{60,40},{60,32}}, color={191,0,0}));
  connect(gain1.y, heatPump2.Q_flow_set) annotation (Line(points={{-65.6,-50},{-60,-50}}, color={0,0,127}));
  connect(sine4.y, gain1.u) annotation (Line(points={{-79,-50},{-74.8,-50}}, color={0,0,127}));
  connect(sine5.y, heatPump2.T_source_input_K) annotation (Line(points={{-59,-20},{-50,-20},{-50,-40}}, color={0,0,127}));
  connect(boundaryVLE_pTxi.fluidPortIn, heatPump2.waterPortOut) annotation (Line(
      points={{-30,-70},{-30,-60},{-46,-60}},
      color={175,0,0},
      thickness=0.5));
  connect(boundaryVLE_Txim_flow.fluidPortOut, heatPump2.waterPortIn) annotation (Line(
      points={{-70,-70},{-70,-60},{-54,-60}},
      color={175,0,0},
      thickness=0.5));
  connect(sine7.y, heatPump3.T_source_input_K) annotation (Line(points={{51,-20},{60,-20},{60,-40}}, color={0,0,127}));
  connect(boundaryVLE_pTxi1.fluidPortIn, heatPump3.waterPortOut) annotation (Line(
      points={{80,-70},{80,-60},{64,-60}},
      color={175,0,0},
      thickness=0.5));
  connect(boundaryVLE_Txim_flow1.fluidPortOut, heatPump3.waterPortIn) annotation (Line(
      points={{40,-70},{40,-60},{56,-60}},
      color={175,0,0},
      thickness=0.5));
  connect(sine6.y, heatPump3.H_flow_set) annotation (Line(points={{31,-50},{50,-50}}, color={0,0,127}));
  connect(heatPump.gasPortIn, boundary_pTxi.gasPort) annotation (Line(
      points={{-38,46},{-28,46}},
      color={255,255,0},
      thickness=1.5));
  connect(heatPump2.gasPortIn, boundary_pTxi1.gasPort) annotation (Line(
      points={{-40,-54},{-34,-54},{-34,-54},{-30,-54}},
      color={255,255,0},
      thickness=1.5));
  connect(heatPump1.gasPortIn, boundary_pTxi2.gasPort) annotation (Line(
      points={{70,46},{80,46}},
      color={255,255,0},
      thickness=1.5));
  connect(heatPump3.gasPortIn, boundary_pTxi3.gasPort) annotation (Line(
      points={{70,-54},{80,-54}},
      color={255,255,0},
      thickness=1.5));
  connect(gain.y, heatPump.Q_flow_set) annotation (Line(points={{-65.6,50},{-58,50}}, color={0,0,127}));
  connect(fixedTemperature.port, heatPump.heat) annotation (Line(points={{-48,32},{-48,40}}, color={191,0,0}));
  connect(boundary_pTxi.gasPort, heatPump.gasPortIn) annotation (Line(
      points={{-28,46},{-38,46}},
      color={255,255,0},
      thickness=1.5));
  connect(sine2.y, heatPump.T_source_input_K) annotation (Line(points={{-59,80},{-48,80},{-48,60}}, color={0,0,127}));
  connect(fixedTemperature1.port, heatPump1.heat) annotation (Line(points={{60,32},{60,40}}, color={191,0,0}));
  connect(sine1.y, heatPump1.Q_flow_set) annotation (Line(points={{31,50},{50,50}}, color={0,0,127}));
  connect(sine3.y, heatPump1.T_source_input_K) annotation (Line(points={{51,80},{60,80},{60,60}}, color={0,0,127}));
  annotation (
    Icon(graphics,
         coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=432000, Interval=900),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for HeatPumpGasCharline</p>
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
end HeatPumpGasCharlineTest;
