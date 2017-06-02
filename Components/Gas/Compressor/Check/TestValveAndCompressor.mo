within TransiEnt.Components.Gas.Compressor.Check;
model TestValveAndCompressor
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

  TransiEnt.Storage.Gas.UndergroundGasStorageHeatTransfer_L2 storage(storage(V_geo=1000, p_gas_start=15000000)) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,40})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink(variable_p=true, p_const=10000000) annotation (Placement(transformation(extent={{50,30},{30,50}})));
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel1) annotation (Placement(transformation(extent={{-90,-100},{-70,-80}})));
  Modelica.Blocks.Sources.Sine sine_m_flowDesired(freqHz=1/3600, offset=1) annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Modelica.Blocks.Sources.Ramp ramp_sink_pressure(
    offset=100e5,
    height=-90e5,
    duration=1800,
    startTime=3600) annotation (Placement(transformation(extent={{80,36},{60,56}})));
  TransiEnt.Components.Gas.Compressor.ValveAndCompressor_mflow valveAndCompressor_mflow(redeclare model Compressor = CompressorRealGasIsentropicEff_L1_simple) annotation (Placement(transformation(rotation=0, extent={{-20,20},{20,60}})));
  TransiEnt.Storage.Gas.UndergroundGasStorageHeatTransfer_L2 storage1(storage(V_geo=1000, p_gas_start=15000000)) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-60})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source1 annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Boundaries.Gas.BoundaryRealGas_Txim_flow                 sink1(variable_m_flow=true)             annotation (Placement(transformation(extent={{50,-70},{30,-50}})));
  Modelica.Blocks.Sources.Sine sine_dp_desired(freqHz=1/3600, amplitude=50e5) annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Modelica.Blocks.Sources.Ramp ramp_sink_mflow(
    duration=1800,
    startTime=3600,
    height=-0.9,
    offset=1) annotation (Placement(transformation(extent={{80,-64},{60,-44}})));
  ValveAndCompressor_dp valveAndCompressor_dp(redeclare model Compressor = CompressorRealGasIsentropicEff_L1_simple) annotation (Placement(transformation(rotation=0, extent={{-20,-80},{20,-40}})));
equation
  connect(storage.gasPortIn, source.gasPort) annotation (Line(
      points={{-44.9,40},{-44.9,40},{-60,40}},
      color={255,255,0},
      thickness=1.5));
  connect(valveAndCompressor_mflow.gasPortOut, sink.gasPort) annotation (Line(
      points={{20,40},{20,40},{30,40}},
      color={255,255,0},
      thickness=1.5));
  connect(sine_m_flowDesired.y, valveAndCompressor_mflow.m_flowDesired) annotation (Line(points={{-19,80},{-19,80},{0,80},{0,60}}, color={0,0,127}));
  connect(ramp_sink_pressure.y, sink.p) annotation (Line(points={{59,46},{52,46}},
                                                                                 color={0,0,127}));
  connect(storage.gasPortOut, valveAndCompressor_mflow.gasPortIn) annotation (Line(
      points={{-33.7,40},{-26.85,40},{-20,40}},
      color={255,255,0},
      thickness=1.5));
  connect(storage1.gasPortIn, source1.gasPort) annotation (Line(
      points={{-44.9,-60},{-44.9,-60},{-60,-60}},
      color={255,255,0},
      thickness=1.5));
  connect(valveAndCompressor_dp.gasPortOut, sink1.gasPort) annotation (Line(
      points={{20,-60},{20,-60},{30,-60}},
      color={255,255,0},
      thickness=1.5));
  connect(storage1.gasPortOut, valveAndCompressor_dp.gasPortIn) annotation (Line(
      points={{-33.7,-60},{-26.85,-60},{-20,-60}},
      color={255,255,0},
      thickness=1.5));
  connect(sine_dp_desired.y, valveAndCompressor_dp.dp_desired) annotation (Line(points={{-19,-20},{0,-20},{0,-40}}, color={0,0,127}));
  connect(sink1.m_flow, ramp_sink_mflow.y) annotation (Line(points={{52,-54},{59,-54},{59,-54}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{120,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=7200),
          Documentation(info="<html>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Feb 10 2017<br> </p>
</html>"));
end TestValveAndCompressor;
