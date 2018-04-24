within TransiEnt.Components.Gas.Compressor.Check;
model TestValveAndCompressor
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
  extends TransiEnt.Basics.Icons.Checkmodel;

  TransiEnt.Storage.Gas.UndergroundGasStorageHeatTransfer_L2 storage(storage(V_geo=1000, p_gas_start=15000000)) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,68})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source annotation (Placement(transformation(extent={{-80,58},{-60,78}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink(variable_p=true)                   annotation (Placement(transformation(extent={{50,58},{30,78}})));
  inner TransiEnt.SimCenter simCenter(redeclare Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3)           annotation (Placement(transformation(extent={{-102,100},{-82,120}})));
  Modelica.Blocks.Sources.Sine sine_m_flowDesired(freqHz=1/3600, offset=1) annotation (Placement(transformation(extent={{-40,88},{-20,108}})));
  Modelica.Blocks.Sources.Ramp ramp_sink_pressure(
    offset=100e5,
    duration=1800,
    startTime=3600,
    height=90e5)    annotation (Placement(transformation(extent={{80,64},{60,84}})));
  TransiEnt.Components.Gas.Compressor.ValveAndCompressor_mflow valveAndCompressor_mflow(redeclare model Compressor = CompressorRealGasIsentropicEff_L1_simple,
    volumeSplit=0.1,
    volumeJunction=0.1,
    initOptionSplit=210)                                                                                                                                       annotation (Placement(transformation(rotation=0, extent={{-20,48},{20,88}})));
  TransiEnt.Storage.Gas.UndergroundGasStorageHeatTransfer_L2 storage1(storage(V_geo=1000, p_gas_start=15000000)) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-6})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source1 annotation (Placement(transformation(extent={{-80,-16},{-60,4}})));
  Boundaries.Gas.BoundaryRealGas_Txim_flow                 sink1(variable_m_flow=true)             annotation (Placement(transformation(extent={{50,-16},{30,4}})));
  Modelica.Blocks.Sources.Sine sine_dp_desired(freqHz=1/3600, amplitude=50e5,
    offset=40e5)                                                              annotation (Placement(transformation(extent={{-40,14},{-20,34}})));
  Modelica.Blocks.Sources.Ramp ramp_sink_mflow(
    duration=1800,
    startTime=3600,
    height=-0.9,
    offset=1) annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  ValveAndCompressor_dp valveAndCompressor_dp(redeclare model Compressor = CompressorRealGasIsentropicEff_L1_simple,
    volumeSplit=0.1,
    volumeJunction=0.1,
    h_startSplit=-180e3,
    h_startJunction=-180e3)                                                                                          annotation (Placement(transformation(rotation=0, extent={{-20,-26},{20,14}})));
  inner ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-82,100},{-62,120}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source2(variable_m_flow=true, medium=simCenter.gasModel3)
                                                                        annotation (Placement(transformation(extent={{-60,-96},{-40,-76}})));
  Boundaries.Gas.BoundaryRealGas_pTxi                      sink2(medium=simCenter.gasModel3, p_const=3500000)
                                                                                                   annotation (Placement(transformation(extent={{60,-96},{40,-76}})));
  Modelica.Blocks.Sources.Sine sine_dp_desired1(
                                               freqHz=1/3600, amplitude=35e5) annotation (Placement(transformation(extent={{-40,-66},{-20,-46}})));
  Modelica.Blocks.Sources.Ramp ramp_sink_mflow1(
    duration=1800,
    startTime=3600,
    height=0.9,
    offset=-1)
              annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  ValveAndCompressor_dp valveAndCompressor_dp1(
    redeclare model Compressor = CompressorRealGasIsothermal_L1_simple,
    medium=simCenter.gasModel3,
    p_startJunction=3500000,
    volumeSplit=0.01,
    volumeJunction=0.01,
    p_startSplit=3500000,
    h_startSplit=130000,
    h_startJunction=130000)                                                                                          annotation (Placement(transformation(rotation=0, extent={{-20,-106},{20,-66}})));
equation
  connect(storage.gasPortIn, source.gasPort) annotation (Line(
      points={{-44.9,68},{-44.9,68},{-60,68}},
      color={255,255,0},
      thickness=1.5));
  connect(valveAndCompressor_mflow.gasPortOut, sink.gasPort) annotation (Line(
      points={{20,68},{20,68},{30,68}},
      color={255,255,0},
      thickness=1.5));
  connect(sine_m_flowDesired.y, valveAndCompressor_mflow.m_flowDesired) annotation (Line(points={{-19,98},{-19,98},{0,98},{0,88}}, color={0,0,127}));
  connect(ramp_sink_pressure.y, sink.p) annotation (Line(points={{59,74},{58,74},{58,74},{56,74},{56,74},{52,74}},
                                                                                 color={0,0,127}));
  connect(storage.gasPortOut, valveAndCompressor_mflow.gasPortIn) annotation (Line(
      points={{-33.7,68},{-26.85,68},{-20,68}},
      color={255,255,0},
      thickness=1.5));
  connect(storage1.gasPortIn, source1.gasPort) annotation (Line(
      points={{-44.9,-6},{-44.9,-6},{-60,-6}},
      color={255,255,0},
      thickness=1.5));
  connect(valveAndCompressor_dp.gasPortOut, sink1.gasPort) annotation (Line(
      points={{20,-6},{20,-6},{30,-6}},
      color={255,255,0},
      thickness=1.5));
  connect(storage1.gasPortOut, valveAndCompressor_dp.gasPortIn) annotation (Line(
      points={{-33.7,-6},{-26.85,-6},{-20,-6}},
      color={255,255,0},
      thickness=1.5));
  connect(sine_dp_desired.y, valveAndCompressor_dp.dp_desired) annotation (Line(points={{-19,24},{0,24},{0,14}},    color={0,0,127}));
  connect(sink1.m_flow, ramp_sink_mflow.y) annotation (Line(points={{52,0},{59,0}},              color={0,0,127}));
  connect(valveAndCompressor_dp1.gasPortOut, sink2.gasPort) annotation (Line(
      points={{20,-86},{20,-86},{40,-86}},
      color={255,255,0},
      thickness=1.5));
  connect(sine_dp_desired1.y, valveAndCompressor_dp1.dp_desired) annotation (Line(points={{-19,-56},{0,-56},{0,-66}}, color={0,0,127}));
  connect(source2.gasPort, valveAndCompressor_dp1.gasPortIn) annotation (Line(
      points={{-40,-86},{-40,-86},{-20,-86}},
      color={255,255,0},
      thickness=1.5));
  connect(source2.m_flow, ramp_sink_mflow1.y) annotation (Line(points={{-62,-80},{-69,-80}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{120,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,120}})),
    experiment(StopTime=7200),
          Documentation(info="<html>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Feb 10 2017<br> </p>
</html>"));
end TestValveAndCompressor;
