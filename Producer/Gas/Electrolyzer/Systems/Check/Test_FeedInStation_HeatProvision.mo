within TransiEnt.Producer.Gas.Electrolyzer.Systems.Check;
model Test_FeedInStation_HeatProvision "Model for testing a feed in station without a storage"


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
  import TransiEnt;
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi(p_const=2500000, m_flow_nom=0) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-48,38})));
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3, redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_SRK_var gasModel1)
                                                                                                  annotation (Placement(transformation(extent={{70,40},{90,60}})));
  TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_woStorage feedInStation(
    usePowerPort=true,
    eta_n=0.75,
    P_el_n=1e6,
    P_el_min=1e5,
    k=1e10,
    m_flow_start=0.001,
    t_overload=900,
    startState=1,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer100,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    P_el_max=3*feedInStation.P_el_n,
    P_el_overload=1.5*feedInStation.P_el_n,
    p_out=5000000,
    useFluidCoolantPort=true)
                   annotation (Placement(transformation(extent={{-58,54},{-38,74}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-90,64})));
  Modelica.Blocks.Sources.Ramp rampP1(
    duration=1000,
    startTime=2200,
    height=-4e6,
    offset=4e6)                                 annotation (Placement(transformation(extent={{-100,82},{-80,102}})));
  Modelica.Blocks.Sources.Ramp rampM1(
    height=+0.01,
    offset=0,
    startTime=100,
    duration=1500)                              annotation (Placement(transformation(extent={{10,66},{-10,86}})));
  inner TransiEnt.ModelStatistics                                         modelStatistics annotation (Placement(transformation(extent={{80,40},{100,60}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi1(p_const=2500000, m_flow_nom=0)
                                                                                                               annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-48,-32})));
  TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_woStorage feedInStation1(
    usePowerPort=true,
    eta_n=0.75,
    P_el_n=1e6,
    P_el_min=1e5,
    k=1e10,
    m_flow_start=0.001,
    t_overload=900,
    startState=1,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer100,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    P_el_max=3*feedInStation.P_el_n,
    P_el_overload=1.5*feedInStation.P_el_n,
    p_out=5000000,
    useFluidCoolantPort=true,
    useVariableCoolantOutputTemperature=true)
                   annotation (Placement(transformation(extent={{-58,-20},{-38,0}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-90,-10})));
  Modelica.Blocks.Sources.Ramp rampP2(
    duration=1000,
    startTime=2200,
    height=-4e6,
    offset=4e6)                                 annotation (Placement(transformation(extent={{-100,8},{-80,28}})));
  Modelica.Blocks.Sources.Ramp rampM2(
    height=+0.01,
    offset=0,
    startTime=100,
    duration=1500)                              annotation (Placement(transformation(extent={{14,6},{-6,26}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi2(p_const=2500000, m_flow_nom=0)
                                                                                                               annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-48,-100})));
  TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_woStorage feedInStation2(
    usePowerPort=true,
    eta_n=0.75,
    P_el_n=1e6,
    P_el_min=1e5,
    k=1e10,
    m_flow_start=0.001,
    t_overload=900,
    startState=1,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer100,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    P_el_max=3*feedInStation.P_el_n,
    P_el_overload=1.5*feedInStation.P_el_n,
    p_out=5000000,
    useFluidCoolantPort=true,
    externalMassFlowControl=true)
                   annotation (Placement(transformation(extent={{-58,-84},{-38,-64}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-90,-74})));
  Modelica.Blocks.Sources.Ramp rampP3(
    duration=1000,
    startTime=2200,
    height=-4e6,
    offset=4e6)                                 annotation (Placement(transformation(extent={{-100,-56},{-80,-36}})));
  Modelica.Blocks.Sources.Ramp rampM3(
    height=+0.01,
    offset=0,
    startTime=100,
    duration=1500)                              annotation (Placement(transformation(extent={{10,-72},{-10,-52}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=20 + 273.15)  annotation (Placement(transformation(
        extent={{-4.5,-4.5},{4.5,4.5}},
        rotation=90,
        origin={-16.5,26.5})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink1(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{-5,-4},{5,4}},
        rotation=90,
        origin={-8,33})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_out(unitOption=2) annotation (Placement(transformation(extent={{-4,38},{6,50}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_in(unitOption=2) annotation (Placement(transformation(extent={{-32,34},{-22,44}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink2(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=20 + 273.15)  annotation (Placement(transformation(
        extent={{-4.5,-4.5},{4.5,4.5}},
        rotation=90,
        origin={-20.5,-39.5})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink3(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{-5,-4},{5,4}},
        rotation=90,
        origin={-12,-33})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_out1(unitOption=2)
                                                                              annotation (Placement(transformation(extent={{-8,-28},{2,-16}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_in1(unitOption=2)
                                                                             annotation (Placement(transformation(extent={{-36,-32},{-26,-22}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow
                                                       sink4(
    medium=simCenter.fluid1,
    m_flow_const=1,
    T_const=20 + 273.15)  annotation (Placement(transformation(
        extent={{-4.5,-4.5},{4.5,4.5}},
        rotation=90,
        origin={-24.5,-103.5})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink5(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{-5,-4},{5,4}},
        rotation=90,
        origin={-16,-97})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_out2(unitOption=2)
                                                                              annotation (Placement(transformation(extent={{-12,-92},{-2,-80}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_in2(unitOption=2)
                                                                             annotation (Placement(transformation(extent={{-40,-96},{-30,-86}})));
  Modelica.Blocks.Sources.Ramp rampM4(
    height=50,
    offset=0,
    startTime=300,
    duration=273.15 + 100)                      annotation (Placement(transformation(extent={{20,-18},{0,2}})));
equation
  connect(feedInStation.epp, ElectricGrid.epp) annotation (Line(
      points={{-58,64},{-80,64}},
      color={0,135,135},
      thickness=0.5));
  connect(feedInStation.gasPortOut, boundaryRealGas_pTxi.gasPort) annotation (Line(
      points={{-48.5,53.9},{-48.5,49.95},{-48,49.95},{-48,48}},
      color={255,255,0},
      thickness=1.5));
  connect(rampP1.y, feedInStation.P_el_set) annotation (Line(points={{-79,92},{-48,92},{-48,74.4}},  color={0,0,127}));
  connect(rampM1.y, feedInStation.m_flow_feedIn) annotation (Line(points={{-11,76},{-34,76},{-34,72},{-38,72}},             color={0,0,127}));

  // _____________________________________________
  //
  //             Private functions
  // _____________________________________________
protected
  function plotResult

  constant String resultFileName = "Check_FeedInStation_woStorage.mat";

  output String resultFile;

  algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots(false);

  createPlot(id=1, position={0, 0, 1234, 646}, y={"feedInStation.P_el_set", "feedInStation.epp.P", "feedInStation.P_el_max","feedInStation.P_el_overload"}, range={0.0, 3600.0, -1000000.0, 5000000.0}, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}, {0,0,0}});
  createPlot(id=1, position={0, 0, 1234, 212}, y={"feedInStation.m_flow_feedIn", "feedInStation.h2toNG.gasPortIn.m_flow"}, range={0.0, 3600.0, -0.005, 0.015}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}});
  createPlot(id=1, position={0, 0, 1234, 212}, y={"feedInStation.electrolyzer.eta"}, range={0.0, 3600.0, 0.6000000000000001, 1.0}, grid=true, subPlot=3, colors={{28,108,200}});

  resultFile := "Successfully plotted results for file: " + resultFile;

  end plotResult;

equation
  connect(feedInStation1.epp, ElectricGrid1.epp) annotation (Line(
      points={{-58,-10},{-80,-10}},
      color={0,135,135},
      thickness=0.5));
  connect(feedInStation1.gasPortOut, boundaryRealGas_pTxi1.gasPort) annotation (Line(
      points={{-48.5,-20.1},{-48.5,-24.05},{-48,-24.05},{-48,-22}},
      color={255,255,0},
      thickness=1.5));
  connect(rampP2.y, feedInStation1.P_el_set) annotation (Line(points={{-79,18},{-48,18},{-48,0.4}}, color={0,0,127}));
  connect(rampM2.y, feedInStation1.m_flow_feedIn) annotation (Line(points={{-7,16},{-34,16},{-34,-2},{-38,-2}}, color={0,0,127}));
  connect(feedInStation2.epp, ElectricGrid2.epp) annotation (Line(
      points={{-58,-74},{-80,-74}},
      color={0,135,135},
      thickness=0.5));
  connect(feedInStation2.gasPortOut, boundaryRealGas_pTxi2.gasPort) annotation (Line(
      points={{-48.5,-84.1},{-48.5,-88.05},{-48,-88.05},{-48,-90}},
      color={255,255,0},
      thickness=1.5));
  connect(rampP3.y, feedInStation2.P_el_set) annotation (Line(points={{-79,-46},{-48,-46},{-48,-63.6}}, color={0,0,127}));
  connect(rampM3.y, feedInStation2.m_flow_feedIn) annotation (Line(points={{-11,-62},{-34,-62},{-34,-66},{-38,-66}}, color={0,0,127}));
  connect(sink.steam_a, feedInStation.fluidPortIn) annotation (Line(
      points={{-16.5,31},{-16.5,55},{-38,55}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(feedInStation.fluidPortOut, sink1.steam_a) annotation (Line(
      points={{-38,60},{-8,60},{-8,38}},
      color={175,0,0},
      thickness=0.5));
  connect(temperatureSensor_in.port, sink.steam_a) annotation (Line(
      points={{-27,34},{-22,34},{-22,31},{-16.5,31}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(temperatureSensor_out.port, sink1.steam_a) annotation (Line(
      points={{1,38},{-8,38}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(temperatureSensor_in1.port, sink2.steam_a) annotation (Line(
      points={{-31,-32},{-26,-32},{-26,-35},{-20.5,-35}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(temperatureSensor_out1.port, sink3.steam_a) annotation (Line(
      points={{-3,-28},{-12,-28}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(temperatureSensor_in2.port, sink4.steam_a) annotation (Line(
      points={{-35,-96},{-30,-96},{-30,-99},{-24.5,-99}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(temperatureSensor_out2.port, sink5.steam_a) annotation (Line(
      points={{-7,-92},{-16,-92}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(feedInStation2.fluidPortIn, sink4.steam_a) annotation (Line(
      points={{-38,-83},{-32,-83},{-32,-84},{-24.5,-84},{-24.5,-99}},
      color={175,0,0},
      thickness=0.5));
  connect(feedInStation2.fluidPortOut, sink5.steam_a) annotation (Line(
      points={{-38,-78},{-16,-78},{-16,-92}},
      color={175,0,0},
      thickness=0.5));
  connect(feedInStation1.fluidPortIn, sink2.steam_a) annotation (Line(
      points={{-38,-19},{-32,-19},{-32,-20},{-20.5,-20},{-20.5,-35}},
      color={175,0,0},
      thickness=0.5));
  connect(feedInStation1.fluidPortOut, sink3.steam_a) annotation (Line(
      points={{-38,-14},{-12,-14},{-12,-28}},
      color={175,0,0},
      thickness=0.5));
  connect(feedInStation1.T_set_coolant_out, rampM4.y) annotation (Line(points={{-37.2,-6.4},{-9.6,-6.4},{-9.6,-8},{-1,-8}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=3600, __Dymola_NumberOfIntervals=10000),
    __Dymola_experimentSetupOutput,
    __Dymola_Commands(executeCall=TransiEnt.Storage.PtG.Check.Check_FeedInStation_woStorage.plotResult() "Plot example results"),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for FeedInStation_woStorage</p>
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
end Test_FeedInStation_HeatProvision;
