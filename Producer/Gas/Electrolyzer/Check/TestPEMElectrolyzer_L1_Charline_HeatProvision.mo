within TransiEnt.Producer.Gas.Electrolyzer.Check;
model TestPEMElectrolyzer_L1_Charline_HeatProvision "Tester for an PEM electrolyzer"

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
  import TransiEnt;
  import      Modelica.Units.SI;

//protected
  function plotResult

  constant String resultFileName = "TestPEMElectrolyzer_L1_Charline.mat";

  output String resultFile;

  algorithm
    clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
    resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
    removePlots(false);
    createPlot(id=1, position={0, 0, 1563, 735}, x="electrolyzer100PowerIn.P_el", y={"electrolyzer100PowerIn.eta", "electrolyzer200PowerIn.eta"}, range={50000.0, 1500000.0, 0.1, 1.0}, grid=true, filename=resultFile, colors={{28,108,200}, {238,46,47}});
    createPlot(id=1, position={0, 0, 1563, 365}, x="electrolyzer100MFlowIn.P_el", y={"electrolyzer100MFlowIn.eta", "electrolyzer200MFlowIn.eta"}, range={50000.0, 1500000.0, 0.1, 1.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}});
  end plotResult;

public
  parameter SI.Power P_el_n=1e6 "Nominal electrical power of the electrolyzer";
  parameter SI.Power P_el_min=0.05*P_el_n "Minimal electrical power of the electrolyzer";
  parameter SI.Power P_el_max=1.0*P_el_n "Maximal electrical power of the electrolyzer";
  parameter SI.Temperature T_out=273.15+70 "Temperature of the produced hydrogen";
  parameter SI.Efficiency eta_n=0.75 "Nominal efficiency of the electrolyzer";
  parameter SI.Pressure p_out=50e5 "Pressure of the produced hydrogen";

  Modelica.Blocks.Sources.Ramp rampPower(
    height=P_el_max - P_el_min,
    offset=P_el_min,
    duration=30,
    startTime=10) annotation (Placement(transformation(extent={{-166,196},{-146,216}})));
  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L1 electrolyzer100PowerIn(
    eta_n=eta_n,
    T_out=T_out,
    P_el_n=P_el_n,
    P_el_max=P_el_max,
    usePowerPort=true,
    useHeatPort=true,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer100) annotation (Placement(transformation(extent={{-126,166},{-106,186}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid100PowerIn annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-158,178})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink100PowerIn(p_const=p_out) annotation (Placement(transformation(extent={{-44,166},{-64,186}})));
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel1, redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3)
                                                                                                annotation (Placement(transformation(extent={{158,198},{178,218}})));
  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L1 electrolyzer200PowerIn(
    eta_n=eta_n,
    T_out=T_out,
    P_el_n=P_el_n,
    P_el_max=P_el_max,
    usePowerPort=true,
    useFluidCoolantPort=true,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200) annotation (Placement(transformation(extent={{-124,108},{-104,128}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid200PowerIn annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-154,118})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink200PowerIn(p_const=p_out) annotation (Placement(transformation(extent={{-42,108},{-62,128}})));
  inner TransiEnt.ModelStatistics                                         modelStatistics annotation (Placement(transformation(extent={{164,198},{184,218}})));
  TransiEnt.Components.Sensors.RealGas.EnthalpyFlowSensor enthalpyFlowSensor100PowerIn annotation (Placement(transformation(extent={{-96,176},{-76,196}})));
  TransiEnt.Components.Sensors.RealGas.EnthalpyFlowSensor enthalpyFlowSensor200PowerIn annotation (Placement(transformation(extent={{-94,118},{-74,138}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15) annotation (Placement(transformation(extent={{-130,152},{-122,160}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=20 + 273.15)  annotation (Placement(transformation(
        extent={{-4.5,-4.5},{4.5,4.5}},
        rotation=90,
        origin={-104.5,84.5})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink1(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{-5,-4},{5,4}},
        rotation=90,
        origin={-96,91})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_out(unitOption=2) annotation (Placement(transformation(extent={{-92,108},{-82,120}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_in(unitOption=2) annotation (Placement(transformation(extent={{-120,92},{-110,102}})));
  Modelica.Blocks.Sources.Ramp rampPower1(
    height=P_el_max - P_el_min,
    offset=P_el_min,
    duration=30,
    startTime=10) annotation (Placement(transformation(extent={{-164,136},{-152,148}})));
  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L1 electrolyzer200PowerIn1(
    externalMassFlowControl=true,
    eta_n=eta_n,
    T_out=T_out,
    P_el_n=P_el_n,
    P_el_max=P_el_max,
    usePowerPort=true,
    useFluidCoolantPort=true,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200) annotation (Placement(transformation(extent={{-124,-32},{-104,-12}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid200PowerIn1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-154,-22})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink200PowerIn1(p_const=p_out)
                                                                                         annotation (Placement(transformation(extent={{-42,-32},{-62,-12}})));
  TransiEnt.Components.Sensors.RealGas.EnthalpyFlowSensor enthalpyFlowSensor200PowerIn1
                                                                                       annotation (Placement(transformation(extent={{-94,-22},{-74,-2}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow
                                                       sink2(
    medium=simCenter.fluid1,
    m_flow_const=1,
    T_const=20 + 273.15)  annotation (Placement(transformation(
        extent={{-4.5,-4.5},{4.5,4.5}},
        rotation=90,
        origin={-104.5,-55.5})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink3(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{-5,-4},{5,4}},
        rotation=90,
        origin={-96,-49})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_out1(unitOption=2)
                                                                              annotation (Placement(transformation(extent={{-92,-32},{-82,-20}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_in1(unitOption=2)
                                                                             annotation (Placement(transformation(extent={{-120,-48},{-110,-38}})));
  Modelica.Blocks.Sources.Ramp rampPower2(
    height=P_el_max - P_el_min,
    offset=P_el_min,
    duration=30,
    startTime=10) annotation (Placement(transformation(extent={{-174,-18},{-162,-6}})));
  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L1 electrolyzer200PowerIn2(
    externalMassFlowControl=true,
    useVariableCoolantOutputTemperature=true,
    eta_n=eta_n,
    T_out=T_out,
    P_el_n=P_el_n,
    P_el_max=P_el_max,
    usePowerPort=true,
    useFluidCoolantPort=true,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200) annotation (Placement(transformation(extent={{-130,-96},{-110,-76}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid200PowerIn2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-160,-86})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink200PowerIn2(p_const=p_out)
                                                                                         annotation (Placement(transformation(extent={{-48,-96},{-68,-76}})));
  TransiEnt.Components.Sensors.RealGas.EnthalpyFlowSensor enthalpyFlowSensor200PowerIn2
                                                                                       annotation (Placement(transformation(extent={{-100,-86},{-88,-74}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow
                                                       sink4(
    medium=simCenter.fluid1,
    m_flow_const=1,
    T_const=20 + 273.15)  annotation (Placement(transformation(
        extent={{-4.5,-4.5},{4.5,4.5}},
        rotation=90,
        origin={-110.5,-119.5})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink5(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{-5,-4},{5,4}},
        rotation=90,
        origin={-102,-113})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_out2(unitOption=2)
                                                                              annotation (Placement(transformation(extent={{-98,-100},{-88,-88}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_in2(unitOption=2)
                                                                             annotation (Placement(transformation(extent={{-126,-112},{-116,-102}})));
  Modelica.Blocks.Sources.Ramp rampPower3(
    height=P_el_max - P_el_min,
    offset=P_el_min,
    duration=30,
    startTime=10) annotation (Placement(transformation(extent={{-170,-68},{-158,-56}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=273.15 + 25) annotation (Placement(transformation(extent={{-66,-74},{-86,-54}})));
  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L1 electrolyzer200PowerIn3(
    externalMassFlowControl=true,
    T_out_coolant_target=23 + 273.15,
    eta_n=eta_n,
    T_out=T_out,
    P_el_n=P_el_n,
    P_el_max=P_el_max,
    usePowerPort=true,
    useFluidCoolantPort=true,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200) annotation (Placement(transformation(extent={{-130,-168},{-110,-148}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid200PowerIn3 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-160,-158})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink200PowerIn3(p_const=p_out)
                                                                                         annotation (Placement(transformation(extent={{-48,-168},{-68,-148}})));
  TransiEnt.Components.Sensors.RealGas.EnthalpyFlowSensor enthalpyFlowSensor200PowerIn3
                                                                                       annotation (Placement(transformation(extent={{-100,-158},{-88,-146}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow
                                                       sink6(
    medium=simCenter.fluid1,
    m_flow_const=1,
    T_const=20 + 273.15)  annotation (Placement(transformation(
        extent={{-4.5,-4.5},{4.5,4.5}},
        rotation=90,
        origin={-110.5,-191.5})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink7(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{-5,-4},{5,4}},
        rotation=90,
        origin={-102,-185})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_out3(unitOption=2)
                                                                              annotation (Placement(transformation(extent={{-98,-172},{-88,-160}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_in3(unitOption=2)
                                                                             annotation (Placement(transformation(extent={{-126,-184},{-116,-174}})));
  Modelica.Blocks.Sources.Ramp rampPower4(
    height=P_el_max - P_el_min,
    offset=P_el_min,
    duration=30,
    startTime=10) annotation (Placement(transformation(extent={{-170,-140},{-158,-128}})));
  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L1 electrolyzer200PowerIn4(
    useVariableCoolantOutputTemperature=true,
    eta_n=eta_n,
    T_out=T_out,
    P_el_n=P_el_n,
    P_el_max=P_el_max,
    usePowerPort=true,
    useFluidCoolantPort=true,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200) annotation (Placement(transformation(extent={{-128,38},{-108,58}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid200PowerIn4 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-158,48})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink200PowerIn4(p_const=p_out)
                                                                                         annotation (Placement(transformation(extent={{-46,38},{-66,58}})));
  TransiEnt.Components.Sensors.RealGas.EnthalpyFlowSensor enthalpyFlowSensor200PowerIn4
                                                                                       annotation (Placement(transformation(extent={{-98,48},{-78,68}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink8(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=20 + 273.15)  annotation (Placement(transformation(
        extent={{-4.5,-4.5},{4.5,4.5}},
        rotation=90,
        origin={-108.5,14.5})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink9(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{-5,-4},{5,4}},
        rotation=90,
        origin={-100,21})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_out4(unitOption=2)
                                                                              annotation (Placement(transformation(extent={{-96,38},{-86,50}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_in4(unitOption=2)
                                                                             annotation (Placement(transformation(extent={{-124,22},{-114,32}})));
  Modelica.Blocks.Sources.Ramp rampPower5(
    height=P_el_max - P_el_min,
    offset=P_el_min,
    duration=30,
    startTime=10) annotation (Placement(transformation(extent={{-168,66},{-156,78}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=273.15 + 25) annotation (Placement(transformation(extent={{-44,64},{-64,84}})));
equation
  connect(ElectricGrid100PowerIn.epp, electrolyzer100PowerIn.epp) annotation (Line(
      points={{-148,178},{-136,178},{-136,176},{-126,176}},
      color={0,135,135},
      thickness=0.5));
  connect(ElectricGrid200PowerIn.epp, electrolyzer200PowerIn.epp) annotation (Line(
      points={{-144,118},{-124,118}},
      color={0,135,135},
      thickness=0.5));
  connect(rampPower.y, electrolyzer100PowerIn.P_el_set) annotation (Line(points={{-145,206},{-136,206},{-136,188},{-120,188}},
                                                                                                                          color={0,0,127}));
  connect(electrolyzer100PowerIn.gasPortOut, enthalpyFlowSensor100PowerIn.gasPortIn) annotation (Line(
      points={{-106,176},{-96,176}},
      color={255,255,0},
      thickness=1.5));
  connect(enthalpyFlowSensor100PowerIn.gasPortOut, sink100PowerIn.gasPort) annotation (Line(
      points={{-76,176},{-64,176}},
      color={255,255,0},
      thickness=1.5));
  connect(electrolyzer200PowerIn.gasPortOut, enthalpyFlowSensor200PowerIn.gasPortIn) annotation (Line(
      points={{-104,118},{-94,118}},
      color={255,255,0},
      thickness=1.5));
  connect(enthalpyFlowSensor200PowerIn.gasPortOut, sink200PowerIn.gasPort) annotation (Line(
      points={{-74,118},{-62,118}},
      color={255,255,0},
      thickness=1.5));
  connect(electrolyzer100PowerIn.heat, fixedTemperature.port) annotation (Line(points={{-106,169.4},{-106,156},{-122,156}},  color={191,0,0}));
  connect(electrolyzer200PowerIn.fluidPortIn, sink.steam_a) annotation (Line(
      points={{-104,109},{-104,89},{-104.5,89}},
      color={175,0,0},
      thickness=0.5));
  connect(sink1.steam_a, electrolyzer200PowerIn.fluidPortOut) annotation (Line(
      points={{-96,96},{-96,114},{-104,114}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(electrolyzer200PowerIn.fluidPortOut, temperatureSensor_out.port) annotation (Line(
      points={{-104,114},{-96,114},{-96,108},{-87,108}},
      color={175,0,0},
      thickness=0.5));
  connect(electrolyzer200PowerIn.fluidPortIn, temperatureSensor_in.port) annotation (Line(
      points={{-104,109},{-104,92},{-115,92}},
      color={175,0,0},
      thickness=0.5));
  connect(rampPower1.y, electrolyzer200PowerIn.P_el_set) annotation (Line(points={{-151.4,142},{-118,142},{-118,130}}, color={0,0,127}));
  connect(ElectricGrid200PowerIn1.epp, electrolyzer200PowerIn1.epp) annotation (Line(
      points={{-144,-22},{-124,-22}},
      color={0,135,135},
      thickness=0.5));
  connect(electrolyzer200PowerIn1.gasPortOut, enthalpyFlowSensor200PowerIn1.gasPortIn) annotation (Line(
      points={{-104,-22},{-94,-22}},
      color={255,255,0},
      thickness=1.5));
  connect(enthalpyFlowSensor200PowerIn1.gasPortOut, sink200PowerIn1.gasPort) annotation (Line(
      points={{-74,-22},{-62,-22}},
      color={255,255,0},
      thickness=1.5));
  connect(electrolyzer200PowerIn1.fluidPortIn, sink2.steam_a) annotation (Line(
      points={{-104,-31},{-104,-51},{-104.5,-51}},
      color={175,0,0},
      thickness=0.5));
  connect(sink3.steam_a, electrolyzer200PowerIn1.fluidPortOut) annotation (Line(
      points={{-96,-44},{-96,-26},{-104,-26}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(electrolyzer200PowerIn1.fluidPortOut, temperatureSensor_out1.port) annotation (Line(
      points={{-104,-26},{-96,-26},{-96,-32},{-87,-32}},
      color={175,0,0},
      thickness=0.5));
  connect(electrolyzer200PowerIn1.fluidPortIn, temperatureSensor_in1.port) annotation (Line(
      points={{-104,-31},{-104,-48},{-115,-48}},
      color={175,0,0},
      thickness=0.5));
  connect(rampPower2.y, electrolyzer200PowerIn1.P_el_set) annotation (Line(points={{-161.4,-12},{-118,-12},{-118,-10}}, color={0,0,127}));
  connect(ElectricGrid200PowerIn2.epp, electrolyzer200PowerIn2.epp) annotation (Line(
      points={{-150,-86},{-130,-86}},
      color={0,135,135},
      thickness=0.5));
  connect(electrolyzer200PowerIn2.gasPortOut, enthalpyFlowSensor200PowerIn2.gasPortIn) annotation (Line(
      points={{-110,-86},{-100,-86}},
      color={255,255,0},
      thickness=1.5));
  connect(enthalpyFlowSensor200PowerIn2.gasPortOut, sink200PowerIn2.gasPort) annotation (Line(
      points={{-88,-86},{-68,-86}},
      color={255,255,0},
      thickness=1.5));
  connect(electrolyzer200PowerIn2.fluidPortIn, sink4.steam_a) annotation (Line(
      points={{-110,-95},{-110,-115},{-110.5,-115}},
      color={175,0,0},
      thickness=0.5));
  connect(sink5.steam_a, electrolyzer200PowerIn2.fluidPortOut) annotation (Line(
      points={{-102,-108},{-102,-90},{-110,-90}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(electrolyzer200PowerIn2.fluidPortOut, temperatureSensor_out2.port) annotation (Line(
      points={{-110,-90},{-102,-90},{-102,-100},{-93,-100}},
      color={175,0,0},
      thickness=0.5));
  connect(electrolyzer200PowerIn2.fluidPortIn, temperatureSensor_in2.port) annotation (Line(
      points={{-110,-95},{-110,-112},{-121,-112}},
      color={175,0,0},
      thickness=0.5));
  connect(rampPower3.y, electrolyzer200PowerIn2.P_el_set) annotation (Line(points={{-157.4,-62},{-124,-62},{-124,-74}}, color={0,0,127}));
  connect(electrolyzer200PowerIn2.T_set_coolant_out, realExpression.y) annotation (Line(points={{-108,-79},{-102,-79},{-102,-64},{-87,-64}}, color={0,0,127}));
  connect(ElectricGrid200PowerIn3.epp, electrolyzer200PowerIn3.epp) annotation (Line(
      points={{-150,-158},{-130,-158}},
      color={0,135,135},
      thickness=0.5));
  connect(electrolyzer200PowerIn3.gasPortOut, enthalpyFlowSensor200PowerIn3.gasPortIn) annotation (Line(
      points={{-110,-158},{-100,-158}},
      color={255,255,0},
      thickness=1.5));
  connect(enthalpyFlowSensor200PowerIn3.gasPortOut, sink200PowerIn3.gasPort) annotation (Line(
      points={{-88,-158},{-68,-158}},
      color={255,255,0},
      thickness=1.5));
  connect(electrolyzer200PowerIn3.fluidPortIn, sink6.steam_a) annotation (Line(
      points={{-110,-167},{-110,-187},{-110.5,-187}},
      color={175,0,0},
      thickness=0.5));
  connect(sink7.steam_a, electrolyzer200PowerIn3.fluidPortOut) annotation (Line(
      points={{-102,-180},{-102,-162},{-110,-162}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(electrolyzer200PowerIn3.fluidPortOut, temperatureSensor_out3.port) annotation (Line(
      points={{-110,-162},{-102,-162},{-102,-172},{-93,-172}},
      color={175,0,0},
      thickness=0.5));
  connect(electrolyzer200PowerIn3.fluidPortIn, temperatureSensor_in3.port) annotation (Line(
      points={{-110,-167},{-110,-184},{-121,-184}},
      color={175,0,0},
      thickness=0.5));
  connect(rampPower4.y, electrolyzer200PowerIn3.P_el_set) annotation (Line(points={{-157.4,-134},{-124,-134},{-124,-146}}, color={0,0,127}));
  connect(ElectricGrid200PowerIn4.epp, electrolyzer200PowerIn4.epp) annotation (Line(
      points={{-148,48},{-128,48}},
      color={0,135,135},
      thickness=0.5));
  connect(electrolyzer200PowerIn4.gasPortOut, enthalpyFlowSensor200PowerIn4.gasPortIn) annotation (Line(
      points={{-108,48},{-98,48}},
      color={255,255,0},
      thickness=1.5));
  connect(enthalpyFlowSensor200PowerIn4.gasPortOut, sink200PowerIn4.gasPort) annotation (Line(
      points={{-78,48},{-66,48}},
      color={255,255,0},
      thickness=1.5));
  connect(electrolyzer200PowerIn4.fluidPortIn, sink8.steam_a) annotation (Line(
      points={{-108,39},{-108,19},{-108.5,19}},
      color={175,0,0},
      thickness=0.5));
  connect(sink9.steam_a, electrolyzer200PowerIn4.fluidPortOut) annotation (Line(
      points={{-100,26},{-100,44},{-108,44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(electrolyzer200PowerIn4.fluidPortOut, temperatureSensor_out4.port) annotation (Line(
      points={{-108,44},{-100,44},{-100,38},{-91,38}},
      color={175,0,0},
      thickness=0.5));
  connect(electrolyzer200PowerIn4.fluidPortIn, temperatureSensor_in4.port) annotation (Line(
      points={{-108,39},{-108,22},{-119,22}},
      color={175,0,0},
      thickness=0.5));
  connect(rampPower5.y, electrolyzer200PowerIn4.P_el_set) annotation (Line(points={{-155.4,72},{-122,72},{-122,60}}, color={0,0,127}));
  connect(electrolyzer200PowerIn4.T_set_coolant_out, realExpression1.y) annotation (Line(points={{-106,55},{-86,55},{-86,74},{-65,74}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false, extent={{-180,-240},{180,240}})),
                                                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-240},{180,240}}),
                                                                                                                      graphics={Text(
          extent={{78,192},{122,186}},
          lineColor={0,140,72},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="P_el_n=1 MW
P_el_min=0.05 MW
P_el_max=1 MW
eta_n=0.75
T_out=15 C
p_out=50 bar
no costs considered"),                                                                                                          Text(
          extent={{-32,226},{46,-52}},
          lineColor={0,140,72},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=11,
          textString="heatPort



Mass Flow defined by 
electrolyzer to meet 
target output temperature
 of 68 °C



Mass Flow defined by 
electrolyzer to meet 
target output temperature
 of 25 °C (defined by input)


"),                                                                                                                             Text(
          extent={{-36,-14},{86,-34}},
          lineColor={0,140,72},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=11,
          textString="Mass flow defined by boundary"),                                                                          Text(
          extent={{-34,-80},{72,-100}},
          lineColor={0,140,72},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=11,
          textString="Mass flow defined by boundary
Heat flow limited by 
maximum ouput temperature via input"),                                                                                          Text(
          extent={{-36,-150},{70,-170}},
          lineColor={0,140,72},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          fontSize=11,
          textString="Mass flow defined by boundary
Heat flow limited by 
maximum ouput temperature via parameter")}),
    experiment(StopTime=50),
    __Dymola_experimentSetupOutput,
    __Dymola_Commands(executeCall=TransiEnt.Components.Convertor.Power2Gas.Check.TestPEMElectrolyzer_L1_Charline.plotResult() "Plot example results"),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for PEMElectrolyzer_L1</p>
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
end TestPEMElectrolyzer_L1_Charline_HeatProvision;
