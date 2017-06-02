within TransiEnt.Basics.Adapters.Check;
model TestRealGasAdapters
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

  parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_SG_var realGas_ng7_sg "Real NG7_SG gas model";
  parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_SG_O2_var realGas_ng7_sg_o2 "Real NG7_SG_O2 gas model";
  parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG6_var realGas_sg6 "Real SG6 gas model";
  parameter TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG6_var idealGas_sg6 "Ideal SG6 gas model";
  parameter TILMedia.VLEFluidTypes.TILMedia_SplineWater water "VLE water model";

  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink annotation (Placement(transformation(extent={{88,90},{68,110}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source(medium=simCenter.gasModel3, m_flow_const=-1) annotation (Placement(transformation(extent={{-88,90},{-68,110}})));
  Gas.RealH2_to_RealNG h2toNG annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  inner TransiEnt.SimCenter simCenter(
    redeclare Media.Gases.VLE_VDIWA_H2_SRK                  gasModel3,
    redeclare Media.Gases.VLE_VDIWA_NG7_H2_var                  gasModel1,
    p_eff_2=1500000)                                                                                       annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensorBefore(medium=simCenter.gasModel3, compositionDefinedBy=1) annotation (Placement(transformation(extent={{-62,100},{-42,120}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor temperatureSensorBefore(medium=simCenter.gasModel3) annotation (Placement(transformation(extent={{-36,100},{-16,120}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensorAfter(compositionDefinedBy=1) annotation (Placement(transformation(extent={{16,100},{36,120}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor temperatureSensorAfter annotation (Placement(transformation(extent={{42,100},{62,120}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink1(medium=realGas_ng7_sg) annotation (Placement(transformation(extent={{88,60},{68,80}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow     source1(
    medium=water,
    m_flow_const=1,
    T_const(displayUnit="degC") = simCenter.T_ground)                                                                annotation (Placement(transformation(extent={{-88,60},{-68,80}})));
  Gas.RealH2O_to_RealNG7_SG h2toNG1(medium_water=water, medium_ng7_sg=realGas_ng7_sg)
                                    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensorBefore1(medium=water)
                                                                   annotation (Placement(transformation(extent={{-36,70},{-16,90}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensorAfter1(compositionDefinedBy=1, medium=realGas_ng7_sg) annotation (Placement(transformation(extent={{16,70},{36,90}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor temperatureSensorAfter1(medium=realGas_ng7_sg) annotation (Placement(transformation(extent={{42,70},{62,90}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink2(medium=realGas_sg6) annotation (Placement(transformation(extent={{88,30},{68,50}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source2(
    m_flow_const=-1,
    medium=realGas_ng7_sg,
    xi_const={0.7,0,0,0,0.1,0.1,0.05,0.02}) annotation (Placement(transformation(extent={{-88,30},{-68,50}})));
  Gas.RealNG7_SG_to_RealSG6
                       h2toNG2(medium_ng7_sg=realGas_ng7_sg, medium_sg6=realGas_sg6)
                              annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensorBefore2(compositionDefinedBy=1, medium=realGas_ng7_sg) annotation (Placement(transformation(extent={{-62,40},{-42,60}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor temperatureSensorBefore2(medium=realGas_ng7_sg) annotation (Placement(transformation(extent={{-36,40},{-16,60}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensorAfter2(compositionDefinedBy=1, medium=realGas_sg6) annotation (Placement(transformation(extent={{16,40},{36,60}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor temperatureSensorAfter2(medium=realGas_sg6) annotation (Placement(transformation(extent={{42,40},{62,60}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink3(medium=realGas_ng7_sg) annotation (Placement(transformation(extent={{88,0},{68,20}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source3(m_flow_const=-1) annotation (Placement(transformation(extent={{-88,0},{-68,20}})));
  Gas.RealNG7_to_RealNG7_SG
                       h2toNG3(medium_ng7_sg=realGas_ng7_sg)
                              annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensorBefore3(compositionDefinedBy=1) annotation (Placement(transformation(extent={{-62,10},{-42,30}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor temperatureSensorBefore3 annotation (Placement(transformation(extent={{-36,10},{-16,30}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensorAfter3(compositionDefinedBy=1, medium=realGas_ng7_sg) annotation (Placement(transformation(extent={{16,10},{36,30}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor temperatureSensorAfter3(medium=realGas_ng7_sg) annotation (Placement(transformation(extent={{42,10},{62,30}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink4(medium=realGas_ng7_sg_o2) annotation (Placement(transformation(extent={{88,-30},{68,-10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source4(m_flow_const=-1) annotation (Placement(transformation(extent={{-88,-30},{-68,-10}})));
  Gas.RealNG7_to_RealNG7_SG_O2
                       h2toNG4(medium_ng7=simCenter.gasModel1, medium_ng7_sg_o2=realGas_ng7_sg_o2)
                              annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensorBefore4(compositionDefinedBy=1) annotation (Placement(transformation(extent={{-62,-20},{-42,0}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor temperatureSensorBefore4 annotation (Placement(transformation(extent={{-36,-20},{-16,0}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensorAfter4(compositionDefinedBy=1, medium=realGas_ng7_sg_o2) annotation (Placement(transformation(extent={{16,-20},{36,0}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor temperatureSensorAfter4(medium=realGas_ng7_sg_o2) annotation (Placement(transformation(extent={{42,-20},{62,0}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink5(medium=realGas_ng7_sg) annotation (Placement(transformation(extent={{88,-60},{68,-40}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source5(m_flow_const=-1, medium=realGas_sg6) annotation (Placement(transformation(extent={{-88,-60},{-68,-40}})));
  Gas.RealSG6_to_RealNG7_SG
                       h2toNG5(medium_ng7_sg=realGas_ng7_sg, medium_sg6=realGas_sg6)
                              annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensorBefore5(compositionDefinedBy=1, medium=realGas_sg6) annotation (Placement(transformation(extent={{-62,-50},{-42,-30}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor temperatureSensorBefore5(medium=realGas_sg6) annotation (Placement(transformation(extent={{-36,-50},{-16,-30}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensorAfter5(compositionDefinedBy=1, medium=realGas_ng7_sg) annotation (Placement(transformation(extent={{16,-50},{36,-30}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor temperatureSensorAfter5(medium=realGas_ng7_sg) annotation (Placement(transformation(extent={{42,-50},{62,-30}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink6(medium=realGas_ng7_sg_o2) annotation (Placement(transformation(extent={{88,-90},{68,-70}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source6(m_flow_const=-1, medium=realGas_sg6) annotation (Placement(transformation(extent={{-88,-90},{-68,-70}})));
  Gas.RealSG6_to_RealNG7_SG_O2
                       h2toNG6(medium_sg6=realGas_sg6, medium_ng7_sg_o2=realGas_ng7_sg_o2)
                              annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensorBefore6(compositionDefinedBy=1, medium=realGas_sg6) annotation (Placement(transformation(extent={{-62,-80},{-42,-60}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor temperatureSensorBefore6(medium=realGas_sg6) annotation (Placement(transformation(extent={{-36,-80},{-16,-60}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensorAfter6(compositionDefinedBy=1, medium=realGas_ng7_sg_o2) annotation (Placement(transformation(extent={{16,-80},{36,-60}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor temperatureSensorAfter6(medium=realGas_ng7_sg_o2) annotation (Placement(transformation(extent={{42,-80},{62,-60}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink7 annotation (Placement(transformation(extent={{102,-120},{82,-100}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source7(m_flow_const=-1, medium=simCenter.gasModel1) annotation (Placement(transformation(extent={{-102,-120},{-82,-100}})));
  Gas.Real_to_Ideal    h2toNG7(real=simCenter.gasModel1, ideal=simCenter.gasModel2)
                              annotation (Placement(transformation(extent={{-24,-120},{-4,-100}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensorBefore7(compositionDefinedBy=1, medium=simCenter.gasModel1) annotation (Placement(transformation(extent={{-76,-110},{-56,-90}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor temperatureSensorBefore7(medium=simCenter.gasModel1) annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensorAfter7(compositionDefinedBy=1) annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor temperatureSensorAfter7 annotation (Placement(transformation(extent={{56,-110},{76,-90}})));
  Gas.Ideal_to_Real ideal_to_Real(real=simCenter.gasModel1, ideal=simCenter.gasModel2)
                                  annotation (Placement(transformation(extent={{4,-120},{24,-100}})));
equation
  connect(source.gasPort, compositionSensorBefore.gasPortIn) annotation (Line(
      points={{-68,100},{-62,100}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensorBefore.gasPortOut, temperatureSensorBefore.gasPortIn) annotation (Line(
      points={{-42,100},{-36,100}},
      color={255,255,0},
      thickness=1.5));
  connect(temperatureSensorBefore.gasPortOut, h2toNG.gasPortIn) annotation (Line(
      points={{-16,100},{-10,100}},
      color={255,255,0},
      thickness=1.5));
  connect(h2toNG.gasPortOut, compositionSensorAfter.gasPortIn) annotation (Line(
      points={{10,100},{16,100}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensorAfter.gasPortOut, temperatureSensorAfter.gasPortIn) annotation (Line(
      points={{36,100},{42,100}},
      color={255,255,0},
      thickness=1.5));
  connect(temperatureSensorAfter.gasPortOut, sink.gasPort) annotation (Line(
      points={{62,100},{68,100}},
      color={255,255,0},
      thickness=1.5));
  connect(h2toNG1.gasPortOut, compositionSensorAfter1.gasPortIn) annotation (Line(
      points={{10,70},{16,70}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensorAfter1.gasPortOut, temperatureSensorAfter1.gasPortIn) annotation (Line(
      points={{36,70},{42,70}},
      color={255,255,0},
      thickness=1.5));
  connect(temperatureSensorAfter1.gasPortOut, sink1.gasPort) annotation (Line(
      points={{62,70},{68,70}},
      color={255,255,0},
      thickness=1.5));
  connect(h2toNG1.waterPortIn, temperatureSensorBefore1.port) annotation (Line(
      points={{-10,70},{-18,70},{-26,70}},
      color={175,0,0},
      thickness=0.5));
  connect(h2toNG1.waterPortIn, source1.steam_a) annotation (Line(
      points={{-10,70},{-68,70}},
      color={175,0,0},
      thickness=0.5));
  connect(compositionSensorAfter2.gasPortOut, temperatureSensorAfter2.gasPortIn) annotation (Line(
      points={{36,40},{39,40},{42,40}},
      color={255,255,0},
      thickness=1.5));
  connect(temperatureSensorAfter2.gasPortOut, sink2.gasPort) annotation (Line(
      points={{62,40},{65,40},{68,40}},
      color={255,255,0},
      thickness=1.5));
  connect(h2toNG2.gasPortOut, compositionSensorAfter2.gasPortIn) annotation (Line(
      points={{10,40},{13,40},{16,40}},
      color={255,255,0},
      thickness=1.5));
  connect(temperatureSensorBefore2.gasPortOut, h2toNG2.gasPortIn) annotation (Line(
      points={{-16,40},{-13,40},{-10,40}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensorBefore2.gasPortOut, temperatureSensorBefore2.gasPortIn) annotation (Line(
      points={{-42,40},{-39,40},{-36,40}},
      color={255,255,0},
      thickness=1.5));
  connect(source2.gasPort, compositionSensorBefore2.gasPortIn) annotation (Line(
      points={{-68,40},{-66,40},{-62,40}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensorAfter3.gasPortOut, temperatureSensorAfter3.gasPortIn) annotation (Line(
      points={{36,10},{39,10},{42,10}},
      color={255,255,0},
      thickness=1.5));
  connect(temperatureSensorAfter3.gasPortOut, sink3.gasPort) annotation (Line(
      points={{62,10},{65,10},{68,10}},
      color={255,255,0},
      thickness=1.5));
  connect(h2toNG3.gasPortOut, compositionSensorAfter3.gasPortIn) annotation (Line(
      points={{10,10},{13,10},{16,10}},
      color={255,255,0},
      thickness=1.5));
  connect(temperatureSensorBefore3.gasPortOut, h2toNG3.gasPortIn) annotation (Line(
      points={{-16,10},{-13,10},{-10,10}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensorBefore3.gasPortOut, temperatureSensorBefore3.gasPortIn) annotation (Line(
      points={{-42,10},{-39,10},{-36,10}},
      color={255,255,0},
      thickness=1.5));
  connect(source3.gasPort, compositionSensorBefore3.gasPortIn) annotation (Line(
      points={{-68,10},{-66,10},{-62,10}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensorAfter4.gasPortOut, temperatureSensorAfter4.gasPortIn) annotation (Line(
      points={{36,-20},{39,-20},{42,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(temperatureSensorAfter4.gasPortOut, sink4.gasPort) annotation (Line(
      points={{62,-20},{65,-20},{68,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(h2toNG4.gasPortOut, compositionSensorAfter4.gasPortIn) annotation (Line(
      points={{10,-20},{13,-20},{16,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(temperatureSensorBefore4.gasPortOut, h2toNG4.gasPortIn) annotation (Line(
      points={{-16,-20},{-13,-20},{-10,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensorBefore4.gasPortOut, temperatureSensorBefore4.gasPortIn) annotation (Line(
      points={{-42,-20},{-39,-20},{-36,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(source4.gasPort, compositionSensorBefore4.gasPortIn) annotation (Line(
      points={{-68,-20},{-66,-20},{-62,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensorAfter5.gasPortOut, temperatureSensorAfter5.gasPortIn) annotation (Line(
      points={{36,-50},{39,-50},{42,-50}},
      color={255,255,0},
      thickness=1.5));
  connect(temperatureSensorAfter5.gasPortOut, sink5.gasPort) annotation (Line(
      points={{62,-50},{65,-50},{68,-50}},
      color={255,255,0},
      thickness=1.5));
  connect(h2toNG5.gasPortOut, compositionSensorAfter5.gasPortIn) annotation (Line(
      points={{10,-50},{13,-50},{16,-50}},
      color={255,255,0},
      thickness=1.5));
  connect(temperatureSensorBefore5.gasPortOut, h2toNG5.gasPortIn) annotation (Line(
      points={{-16,-50},{-13,-50},{-10,-50}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensorBefore5.gasPortOut, temperatureSensorBefore5.gasPortIn) annotation (Line(
      points={{-42,-50},{-39,-50},{-36,-50}},
      color={255,255,0},
      thickness=1.5));
  connect(source5.gasPort, compositionSensorBefore5.gasPortIn) annotation (Line(
      points={{-68,-50},{-66,-50},{-62,-50}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensorAfter6.gasPortOut, temperatureSensorAfter6.gasPortIn) annotation (Line(
      points={{36,-80},{39,-80},{42,-80}},
      color={255,255,0},
      thickness=1.5));
  connect(temperatureSensorAfter6.gasPortOut, sink6.gasPort) annotation (Line(
      points={{62,-80},{65,-80},{68,-80}},
      color={255,255,0},
      thickness=1.5));
  connect(h2toNG6.gasPortOut, compositionSensorAfter6.gasPortIn) annotation (Line(
      points={{10,-80},{13,-80},{16,-80}},
      color={255,255,0},
      thickness=1.5));
  connect(temperatureSensorBefore6.gasPortOut, h2toNG6.gasPortIn) annotation (Line(
      points={{-16,-80},{-13,-80},{-10,-80}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensorBefore6.gasPortOut, temperatureSensorBefore6.gasPortIn) annotation (Line(
      points={{-42,-80},{-39,-80},{-36,-80}},
      color={255,255,0},
      thickness=1.5));
  connect(source6.gasPort, compositionSensorBefore6.gasPortIn) annotation (Line(
      points={{-68,-80},{-66,-80},{-62,-80}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensorAfter7.gasPortOut, temperatureSensorAfter7.gasPortIn) annotation (Line(
      points={{50,-110},{53,-110},{56,-110}},
      color={255,255,0},
      thickness=1.5));
  connect(temperatureSensorAfter7.gasPortOut, sink7.gasPort) annotation (Line(
      points={{76,-110},{79,-110},{82,-110}},
      color={255,255,0},
      thickness=1.5));
  connect(temperatureSensorBefore7.gasPortOut, h2toNG7.gasPortIn) annotation (Line(
      points={{-30,-110},{-30,-110},{-24,-110}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensorBefore7.gasPortOut, temperatureSensorBefore7.gasPortIn) annotation (Line(
      points={{-56,-110},{-56,-110},{-50,-110}},
      color={255,255,0},
      thickness=1.5));
  connect(source7.gasPort, compositionSensorBefore7.gasPortIn) annotation (Line(
      points={{-82,-110},{-82,-110},{-76,-110}},
      color={255,255,0},
      thickness=1.5));
  connect(h2toNG7.gasPortOut, ideal_to_Real.gasPortIn) annotation (Line(
      points={{-4,-110},{0,-110},{4,-110}},
      color={255,213,170},
      thickness=1.25));
  connect(ideal_to_Real.gasPortOut, compositionSensorAfter7.gasPortIn) annotation (Line(
      points={{24,-110},{30,-110}},
      color={255,255,0},
      thickness=1.5));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
    experiment(StopTime=10),
    __Dymola_experimentSetupOutput,
          Documentation(info="<html>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Mon Apr 24 2017<br> </p>
</html>"));
end TestRealGasAdapters;