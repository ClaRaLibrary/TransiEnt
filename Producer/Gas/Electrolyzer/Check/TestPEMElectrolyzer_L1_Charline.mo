within TransiEnt.Producer.Gas.Electrolyzer.Check;
model TestPEMElectrolyzer_L1_Charline
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
  import TransiEnt;
  import SI = Modelica.SIunits;

protected
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
  parameter SI.Temperature T_out=288.15 "Temperature of the produced hydrogen";
  parameter SI.Efficiency eta_n=0.75 "Nominal efficiency of the electrolyzer";
  parameter SI.Pressure p_out=50e5 "Pressure of the produced hydrogen";

  Modelica.Blocks.Sources.Ramp rampPower(
    height=P_el_max - P_el_min,
    offset=P_el_min,
    duration=30,
    startTime=10) annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L1 electrolyzer100PowerIn(
    eta_n=eta_n,
    T_out=T_out,
    P_el_n=P_el_n,
    P_el_max=P_el_max,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer100) annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency ElectricGrid100PowerIn annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-70,60})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink100PowerIn(p_const=p_out) annotation (Placement(transformation(extent={{42,50},{22,70}})));
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel1, redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3)
                                                                                                annotation (Placement(transformation(extent={{70,80},{90,100}})));
  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L1 electrolyzer200PowerIn(
    eta_n=eta_n,
    T_out=T_out,
    P_el_n=P_el_n,
    P_el_max=P_el_max,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200) annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency ElectricGrid200PowerIn annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-70,20})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink200PowerIn(p_const=p_out) annotation (Placement(transformation(extent={{42,10},{22,30}})));
  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L1 electrolyzer100MFlowIn(
    eta_n=eta_n,
    T_out=T_out,
    P_el_n=P_el_n,
    P_el_max=P_el_max,
    whichInput=2,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer100) annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency ElectricGrid100MFlowIn annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-70,-40})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink100MFlowIn(p_const=p_out) annotation (Placement(transformation(extent={{42,-50},{22,-30}})));
  Modelica.Blocks.Sources.Ramp ramp100MFlow(
    duration=30,
    startTime=10,
    height=0.007042109,
    offset=0.000341591)
                       annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L1 electrolyzer200MFlowIn(
    eta_n=eta_n,
    T_out=T_out,
    P_el_n=P_el_n,
    P_el_max=P_el_max,
    whichInput=2,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200) annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency ElectricGrid200MFlowIn annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-70,-100})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink200MFlowIn(p_const=p_out) annotation (Placement(transformation(extent={{42,-110},{22,-90}})));
  Modelica.Blocks.Sources.Ramp ramp200MFlow(
    duration=30,
    startTime=10,
    height=0.0073267744,
    offset=7.18756e-5) annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  inner TransiEnt.ModelStatistics                                         modelStatistics annotation (Placement(transformation(extent={{80,80},{100,100}})));
  TransiEnt.Components.Sensors.RealGas.EnthalpyFlowSensor enthalpyFlowSensor100PowerIn annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  TransiEnt.Components.Sensors.RealGas.EnthalpyFlowSensor enthalpyFlowSensor200PowerIn annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  TransiEnt.Components.Sensors.RealGas.EnthalpyFlowSensor enthalpyFlowSensor100MFlowIn annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  TransiEnt.Components.Sensors.RealGas.EnthalpyFlowSensor enthalpyFlowSensor200MFlowIn annotation (Placement(transformation(extent={{-10,-100},{10,-80}})));
equation
  connect(ElectricGrid100PowerIn.epp, electrolyzer100PowerIn.epp) annotation (Line(
      points={{-59.9,60.1},{-40,60.1},{-40,60}},
      color={0,135,135},
      thickness=0.5));
  connect(ElectricGrid200PowerIn.epp, electrolyzer200PowerIn.epp) annotation (Line(
      points={{-59.9,20.1},{-40,20.1},{-40,20}},
      color={0,135,135},
      thickness=0.5));
  connect(rampPower.y, electrolyzer100PowerIn.P_el_set) annotation (Line(points={{-59,90},{-50,90},{-50,72},{-34,72}},    color={0,0,127}));
  connect(rampPower.y, electrolyzer200PowerIn.P_el_set) annotation (Line(points={{-59,90},{-50,90},{-50,32},{-34,32}},    color={0,0,127}));
  connect(ElectricGrid100MFlowIn.epp,electrolyzer100MFlowIn. epp) annotation (Line(
      points={{-59.9,-39.9},{-40,-39.9},{-40,-40}},
      color={0,135,135},
      thickness=0.5));
  connect(ElectricGrid200MFlowIn.epp, electrolyzer200MFlowIn.epp) annotation (Line(
      points={{-59.9,-99.9},{-40,-99.9},{-40,-100}},
      color={0,135,135},
      thickness=0.5));
  connect(ramp100MFlow.y, electrolyzer100MFlowIn.m_flow_H2_set) annotation (Line(points={{-59,-10},{-50,-10},{-50,-28},{-26,-28}}, color={0,0,127}));
  connect(ramp200MFlow.y, electrolyzer200MFlowIn.m_flow_H2_set) annotation (Line(points={{-59,-70},{-50,-70},{-50,-88},{-26,-88}}, color={0,0,127}));
  connect(electrolyzer100PowerIn.gasPortOut, enthalpyFlowSensor100PowerIn.gasPortIn) annotation (Line(
      points={{-20,60},{-10,60}},
      color={255,255,0},
      thickness=1.5));
  connect(enthalpyFlowSensor100PowerIn.gasPortOut, sink100PowerIn.gasPort) annotation (Line(
      points={{10,60},{16,60},{22,60}},
      color={255,255,0},
      thickness=1.5));
  connect(electrolyzer100MFlowIn.gasPortOut, enthalpyFlowSensor100MFlowIn.gasPortIn) annotation (Line(
      points={{-20,-40},{-10,-40}},
      color={255,255,0},
      thickness=1.5));
  connect(enthalpyFlowSensor100MFlowIn.gasPortOut, sink100MFlowIn.gasPort) annotation (Line(
      points={{10,-40},{16,-40},{22,-40}},
      color={255,255,0},
      thickness=1.5));
  connect(electrolyzer200MFlowIn.gasPortOut, enthalpyFlowSensor200MFlowIn.gasPortIn) annotation (Line(
      points={{-20,-100},{-15,-100},{-10,-100}},
      color={255,255,0},
      thickness=1.5));
  connect(enthalpyFlowSensor200MFlowIn.gasPortOut, sink200MFlowIn.gasPort) annotation (Line(
      points={{10,-100},{16,-100},{22,-100}},
      color={255,255,0},
      thickness=1.5));
  connect(electrolyzer200PowerIn.gasPortOut, enthalpyFlowSensor200PowerIn.gasPortIn) annotation (Line(
      points={{-20,20},{-15,20},{-10,20}},
      color={255,255,0},
      thickness=1.5));
  connect(enthalpyFlowSensor200PowerIn.gasPortOut, sink200PowerIn.gasPort) annotation (Line(
      points={{10,20},{16,20},{22,20}},
      color={255,255,0},
      thickness=1.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,100}})),
                                                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,100}}),
                                                                                                                      graphics={Text(
          extent={{50,42},{94,36}},
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
no costs considered")}),
    experiment(StopTime=50),
    __Dymola_experimentSetupOutput,
    __Dymola_Commands(executeCall=TransiEnt.Components.Convertor.Power2Gas.Check.TestPEMElectrolyzer_L1_Charline.plotResult() "Plot example results"));
end TestPEMElectrolyzer_L1_Charline;
