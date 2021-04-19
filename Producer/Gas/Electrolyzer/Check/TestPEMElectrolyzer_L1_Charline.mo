within TransiEnt.Producer.Gas.Electrolyzer.Check;
model TestPEMElectrolyzer_L1_Charline "Tester for an PEM electrolyzer"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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
  import TransiEnt;
  import SI = Modelica.SIunits;

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
    startTime=10) annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L1 electrolyzer100PowerIn(
    eta_n=eta_n,
    T_out=T_out,
    P_el_n=P_el_n,
    P_el_max=P_el_max,
    usePowerPort=true,
    useHeatPort=true,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer100) annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid100PowerIn annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-70,60})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink100PowerIn(p_const=p_out) annotation (Placement(transformation(extent={{42,50},{22,70}})));
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2 gasModel1, redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2 gasModel3)
                                                                                                annotation (Placement(transformation(extent={{70,80},{90,100}})));
  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L1 electrolyzer200PowerIn(
    externalMassFlowControl=true,
    eta_n=eta_n,
    T_out=T_out,
    P_el_n=P_el_n,
    P_el_max=P_el_max,
    usePowerPort=true,
    useFluidCoolantPort=true,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200) annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid200PowerIn annotation (Placement(transformation(
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
    usePowerPort=true,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer100) annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid100MFlowIn annotation (Placement(transformation(
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
    usePowerPort=true,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200) annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid200MFlowIn annotation (Placement(transformation(
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
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15) annotation (Placement(transformation(extent={{-112,32},{-92,52}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow
                                                       sink(
    medium=simCenter.fluid1,
    m_flow_const=10,
    T_const=20 + 273.15)  annotation (Placement(transformation(
        extent={{-6,-5},{6,5}},
        rotation=180,
        origin={6,-7})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink1(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={5,5})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_out(unitOption=2) annotation (Placement(transformation(extent={{-16,10},{-6,22}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_in(unitOption=2) annotation (Placement(transformation(extent={{-54,10},{-44,20}})));
equation
  connect(ElectricGrid100PowerIn.epp, electrolyzer100PowerIn.epp) annotation (Line(
      points={{-60,60},{-40,60},{-40,60}},
      color={0,135,135},
      thickness=0.5));
  connect(ElectricGrid200PowerIn.epp, electrolyzer200PowerIn.epp) annotation (Line(
      points={{-60,20},{-40,20},{-40,20}},
      color={0,135,135},
      thickness=0.5));
  connect(rampPower.y, electrolyzer100PowerIn.P_el_set) annotation (Line(points={{-59,90},{-50,90},{-50,72},{-34,72}},    color={0,0,127}));
  connect(rampPower.y, electrolyzer200PowerIn.P_el_set) annotation (Line(points={{-59,90},{-50,90},{-50,32},{-34,32}},    color={0,0,127}));
  connect(ElectricGrid100MFlowIn.epp,electrolyzer100MFlowIn. epp) annotation (Line(
      points={{-60,-40},{-40,-40},{-40,-40}},
      color={0,135,135},
      thickness=0.5));
  connect(ElectricGrid200MFlowIn.epp, electrolyzer200MFlowIn.epp) annotation (Line(
      points={{-60,-100},{-40,-100},{-40,-100}},
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
  connect(electrolyzer100PowerIn.heat, fixedTemperature.port) annotation (Line(points={{-20,53.4},{-62,53.4},{-62,42},{-92,42}},
                                                                                                                             color={191,0,0}));
  connect(electrolyzer200PowerIn.fluidPortIn, sink.steam_a) annotation (Line(
      points={{-20,11},{-20,-7},{-8.88178e-16,-7}},
      color={175,0,0},
      thickness=0.5));
  connect(sink1.steam_a, electrolyzer200PowerIn.fluidPortOut) annotation (Line(
      points={{-8.88178e-16,5},{-16,5},{-16,16},{-20,16}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(electrolyzer200PowerIn.fluidPortOut, temperatureSensor_out.port) annotation (Line(
      points={{-20,16},{-16,16},{-16,10},{-11,10}},
      color={175,0,0},
      thickness=0.5));
  connect(electrolyzer200PowerIn.fluidPortIn, temperatureSensor_in.port) annotation (Line(
      points={{-20,11},{-34,11},{-34,10},{-49,10}},
      color={175,0,0},
      thickness=0.5));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,100}})),
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
end TestPEMElectrolyzer_L1_Charline;
