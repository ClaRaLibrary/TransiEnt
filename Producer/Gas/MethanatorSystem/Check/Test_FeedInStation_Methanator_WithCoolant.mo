within TransiEnt.Producer.Gas.MethanatorSystem.Check;
model Test_FeedInStation_Methanator_WithCoolant "Model for testing the Methanator FeedInStation"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
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
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3, redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_SRK_var gasModel1)
                                                                                                  annotation (Placement(transformation(extent={{82,98},{102,118}})));
  inner TransiEnt.ModelStatistics                                         modelStatistics annotation (Placement(transformation(extent={{102,98},{122,118}})));
  FeedInStation_Methanation feedInSystem_Methanation6(
    scalingOfReactor=1,
    useFluidCoolantPort=true,
    m_flow_n_Methane=10,
    hydrogenFraction_fixed=0.05,
    T_out_coolant_target=273.15 + 100)                                                                             annotation (Placement(transformation(extent={{-64,26},{-44,46}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi           boundaryRealGas_pTxi9
                                                                                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-54,10})));
  Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid6 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-96,36})));
  Modelica.Blocks.Sources.RealExpression realExpression15(y=0.7e9)
                                                                 annotation (Placement(transformation(extent={{-106,44},{-86,64}})));
  Modelica.Blocks.Sources.RealExpression realExpression16(y=10)
                                                               annotation (Placement(transformation(extent={{0,38},{-20,58}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=20 + 273.15)  annotation (Placement(transformation(
        extent={{-8,-6},{8,6}},
        rotation=180,
        origin={-16,8})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink1(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{-7,-6},{7,6}},
        rotation=180,
        origin={-17,22})));
  FeedInStation_Methanation feedInSystem_Methanation7(
    scalingOfReactor=1,
    useFluidCoolantPort=false,
    useHeatPort=true,
    m_flow_n_Methane=10,
    hydrogenFraction_fixed=0.05) annotation (Placement(transformation(extent={{-62,86},{-42,106}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi           boundaryRealGas_pTxi10
                                                                                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-52,70})));
  Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid7 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-94,96})));
  Modelica.Blocks.Sources.RealExpression realExpression18(y=0.7e9)
                                                                 annotation (Placement(transformation(extent={{-106,104},{-86,124}})));
  Modelica.Blocks.Sources.RealExpression realExpression19(y=10)
                                                               annotation (Placement(transformation(extent={{0,100},{-20,120}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=873.15) annotation (Placement(transformation(extent={{-10,74},{-22,86}})));
  FeedInStation_Methanation feedInSystem_Methanation1(
    scalingOfReactor=1,
    useFluidCoolantPort=true,
    m_flow_n_Methane=10,
    hydrogenFraction_fixed=0.05,
    T_out_coolant_target=68 + 273.15,
    chooseHeatSources=2)                                                                                           annotation (Placement(transformation(extent={{-64,-94},{-44,-74}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi           boundaryRealGas_pTxi1
                                                                                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-54,-110})));
  Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-96,-84})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=0.7e9)
                                                                 annotation (Placement(transformation(extent={{-106,-76},{-86,-56}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=10) annotation (Placement(transformation(extent={{0,-82},{-20,-62}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink2(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=20 + 273.15)  annotation (Placement(transformation(
        extent={{-8,-6},{8,6}},
        rotation=180,
        origin={-16,-112})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink3(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{-7,-6},{7,6}},
        rotation=180,
        origin={-17,-98})));
  FeedInStation_Methanation feedInSystem_Methanation2(
    scalingOfReactor=1,
    useFluidCoolantPort=true,
    m_flow_n_Methane=10,
    hydrogenFraction_fixed=0.05,
    T_out_coolant_target=273.15 + 100,
    chooseHeatSources=3)                                                                                           annotation (Placement(transformation(extent={{-62,-34},{-42,-14}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi           boundaryRealGas_pTxi2
                                                                                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-52,-50})));
  Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-94,-24})));
  Modelica.Blocks.Sources.RealExpression realExpression4(y=0.7e9)
                                                                 annotation (Placement(transformation(extent={{-104,-16},{-84,4}})));
  Modelica.Blocks.Sources.RealExpression realExpression5(y=10) annotation (Placement(transformation(extent={{2,-22},{-18,-2}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink4(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=20 + 273.15)  annotation (Placement(transformation(
        extent={{-8,-6},{8,6}},
        rotation=180,
        origin={-14,-52})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink5(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{-7,-6},{7,6}},
        rotation=180,
        origin={-15,-38})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_out4(unitOption=2)
                                                                              annotation (Placement(transformation(extent={{-44,46},{-34,58}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_out1(unitOption=2)
                                                                              annotation (Placement(transformation(extent={{-44,-14},{-34,-2}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_out2(unitOption=2)
                                                                              annotation (Placement(transformation(extent={{-44,-72},{-34,-60}})));
  ClaRa.Components.Sensors.SensorVLE_L1_m_flow sensorVLE_L1_m_flow annotation (Placement(transformation(extent={{-38,32},{-28,44}})));
  ClaRa.Components.Sensors.SensorVLE_L1_m_flow sensorVLE_L1_m_flow1 annotation (Placement(transformation(extent={{-36,-28},{-26,-16}})));
  ClaRa.Components.Sensors.SensorVLE_L1_m_flow sensorVLE_L1_m_flow2 annotation (Placement(transformation(extent={{-40,-88},{-30,-76}})));
  FeedInStation_Methanation feedInSystem_Methanation3(
    scalingOfReactor=1,
    useFluidCoolantPort=true,
    m_flow_n_Methane=10,
    hydrogenFraction_fixed=0.05,
    T_out_coolant_target=300 + 273.15,
    externalMassFlowControl=true,
    chooseHeatSources=3)                                                                                           annotation (Placement(transformation(extent={{-66,-156},{-46,-136}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi           boundaryRealGas_pTxi3
                                                                                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-56,-172})));
  Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid3 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-98,-146})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y=0.7e9)
                                                                 annotation (Placement(transformation(extent={{-108,-138},{-88,-118}})));
  Modelica.Blocks.Sources.RealExpression realExpression6(y=10) annotation (Placement(transformation(extent={{-2,-144},{-22,-124}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow
                                                       sink6(
    medium=simCenter.fluid1,
    m_flow_const=0.5,
    T_const=20 + 273.15)  annotation (Placement(transformation(
        extent={{-8,-6},{8,6}},
        rotation=180,
        origin={-18,-174})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink7(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{-7,-6},{7,6}},
        rotation=180,
        origin={-19,-160})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_out3(unitOption=2)
                                                                              annotation (Placement(transformation(extent={{-46,-134},{-36,-122}})));
  ClaRa.Components.Sensors.SensorVLE_L1_m_flow sensorVLE_L1_m_flow3 annotation (Placement(transformation(extent={{-42,-150},{-32,-138}})));
equation
  connect(boundaryRealGas_pTxi9.gasPort,feedInSystem_Methanation6. gasPortOut) annotation (Line(
      points={{-54,20},{-54,25.9},{-54.5,25.9}},
      color={255,255,0},
      thickness=1.5));
  connect(ElectricGrid6.epp,feedInSystem_Methanation6. epp) annotation (Line(
      points={{-86,36},{-64,36}},
      color={0,135,135},
      thickness=0.5));
  connect(realExpression15.y, feedInSystem_Methanation6.P_el_set) annotation (Line(points={{-85,54},{-54,54},{-54,46.4}},
                                                                                                                       color={0,0,127}));
  connect(feedInSystem_Methanation6.m_flow_feedIn,realExpression16. y) annotation (Line(points={{-44,44},{-34,44},{-34,48},{-21,48}},     color={0,0,127}));
  connect(feedInSystem_Methanation6.fluidPortIn, sink.steam_a) annotation (Line(
      points={{-44,27},{-30,27},{-30,8},{-24,8}},
      color={175,0,0},
      thickness=0.5));
  connect(boundaryRealGas_pTxi10.gasPort, feedInSystem_Methanation7.gasPortOut) annotation (Line(
      points={{-52,80},{-52,85.9},{-52.5,85.9}},
      color={255,255,0},
      thickness=1.5));
  connect(ElectricGrid7.epp,feedInSystem_Methanation7. epp) annotation (Line(
      points={{-84,96},{-62,96}},
      color={0,135,135},
      thickness=0.5));
  connect(realExpression18.y, feedInSystem_Methanation7.P_el_set) annotation (Line(points={{-85,114},{-52,114},{-52,106.4}}, color={0,0,127}));
  connect(feedInSystem_Methanation7.m_flow_feedIn,realExpression19. y) annotation (Line(points={{-42,104},{-32,104},{-32,110},{-21,110}}, color={0,0,127}));
  connect(feedInSystem_Methanation7.heat, fixedTemperature.port) annotation (Line(points={{-42,89.4},{-36,89.4},{-36,90},{-28,90},{-28,80},{-22,80}},
                                                                                                                                                    color={191,0,0}));
  connect(boundaryRealGas_pTxi1.gasPort,feedInSystem_Methanation1. gasPortOut) annotation (Line(
      points={{-54,-100},{-54,-94.1},{-54.5,-94.1}},
      color={255,255,0},
      thickness=1.5));
  connect(ElectricGrid1.epp,feedInSystem_Methanation1. epp) annotation (Line(
      points={{-86,-84},{-64,-84}},
      color={0,135,135},
      thickness=0.5));
  connect(realExpression1.y, feedInSystem_Methanation1.P_el_set) annotation (Line(points={{-85,-66},{-54,-66},{-54,-73.6}}, color={0,0,127}));
  connect(feedInSystem_Methanation1.m_flow_feedIn, realExpression2.y) annotation (Line(points={{-44,-76},{-34,-76},{-34,-72},{-21,-72}}, color={0,0,127}));
  connect(feedInSystem_Methanation1.fluidPortIn, sink2.steam_a) annotation (Line(
      points={{-44,-93},{-30,-93},{-30,-112},{-24,-112}},
      color={175,0,0},
      thickness=0.5));
  connect(boundaryRealGas_pTxi2.gasPort,feedInSystem_Methanation2. gasPortOut) annotation (Line(
      points={{-52,-40},{-52,-34.1},{-52.5,-34.1}},
      color={255,255,0},
      thickness=1.5));
  connect(ElectricGrid2.epp,feedInSystem_Methanation2. epp) annotation (Line(
      points={{-84,-24},{-62,-24}},
      color={0,135,135},
      thickness=0.5));
  connect(realExpression4.y, feedInSystem_Methanation2.P_el_set) annotation (Line(points={{-83,-6},{-52,-6},{-52,-13.6}}, color={0,0,127}));
  connect(feedInSystem_Methanation2.m_flow_feedIn, realExpression5.y) annotation (Line(points={{-42,-16},{-32,-16},{-32,-12},{-19,-12}}, color={0,0,127}));
  connect(feedInSystem_Methanation2.fluidPortIn, sink4.steam_a) annotation (Line(
      points={{-42,-33},{-28,-33},{-28,-52},{-22,-52}},
      color={175,0,0},
      thickness=0.5));
  connect(feedInSystem_Methanation6.fluidPortOut, temperatureSensor_out4.port) annotation (Line(
      points={{-44,32},{-42,32},{-42,46},{-39,46}},
      color={175,0,0},
      thickness=0.5));
  connect(feedInSystem_Methanation2.fluidPortOut, temperatureSensor_out1.port) annotation (Line(
      points={{-42,-28},{-40,-28},{-40,-14},{-39,-14}},
      color={175,0,0},
      thickness=0.5));
  connect(feedInSystem_Methanation1.fluidPortOut, temperatureSensor_out2.port) annotation (Line(
      points={{-44,-88},{-42,-88},{-42,-72},{-39,-72}},
      color={175,0,0},
      thickness=0.5));
  connect(feedInSystem_Methanation6.fluidPortOut, sensorVLE_L1_m_flow.inlet) annotation (Line(
      points={{-44,32},{-38,32}},
      color={175,0,0},
      thickness=0.5));
  connect(sensorVLE_L1_m_flow.outlet, sink1.steam_a) annotation (Line(
      points={{-28,32},{-28,22},{-24,22}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(feedInSystem_Methanation2.fluidPortOut, sensorVLE_L1_m_flow1.inlet) annotation (Line(
      points={{-42,-28},{-36,-28}},
      color={175,0,0},
      thickness=0.5));
  connect(sensorVLE_L1_m_flow1.outlet, sink5.steam_a) annotation (Line(
      points={{-26,-28},{-26,-38},{-22,-38}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(feedInSystem_Methanation1.fluidPortOut, sensorVLE_L1_m_flow2.inlet) annotation (Line(
      points={{-44,-88},{-40,-88}},
      color={175,0,0},
      thickness=0.5));
  connect(sensorVLE_L1_m_flow2.outlet, sink3.steam_a) annotation (Line(
      points={{-30,-88},{-28,-88},{-28,-98},{-24,-98}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundaryRealGas_pTxi3.gasPort,feedInSystem_Methanation3. gasPortOut) annotation (Line(
      points={{-56,-162},{-56,-156.1},{-56.5,-156.1}},
      color={255,255,0},
      thickness=1.5));
  connect(ElectricGrid3.epp,feedInSystem_Methanation3. epp) annotation (Line(
      points={{-88,-146},{-66,-146}},
      color={0,135,135},
      thickness=0.5));
  connect(realExpression3.y,feedInSystem_Methanation3. P_el_set) annotation (Line(points={{-87,-128},{-56,-128},{-56,-135.6}},
                                                                                                                            color={0,0,127}));
  connect(feedInSystem_Methanation3.m_flow_feedIn,realExpression6. y) annotation (Line(points={{-46,-138},{-36,-138},{-36,-134},{-23,-134}},
                                                                                                                                         color={0,0,127}));
  connect(feedInSystem_Methanation3.fluidPortIn,sink6. steam_a) annotation (Line(
      points={{-46,-155},{-32,-155},{-32,-174},{-26,-174}},
      color={175,0,0},
      thickness=0.5));
  connect(feedInSystem_Methanation3.fluidPortOut,temperatureSensor_out3. port) annotation (Line(
      points={{-46,-150},{-44,-150},{-44,-134},{-41,-134}},
      color={175,0,0},
      thickness=0.5));
  connect(feedInSystem_Methanation3.fluidPortOut,sensorVLE_L1_m_flow3. inlet) annotation (Line(
      points={{-46,-150},{-42,-150}},
      color={175,0,0},
      thickness=0.5));
  connect(sensorVLE_L1_m_flow3.outlet,sink7. steam_a) annotation (Line(
      points={{-32,-150},{-30,-150},{-30,-160},{-26,-160}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false, extent={{-120,-200},{120,120}})),
                                                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-200},{120,120}}), graphics={
                                                                                                                                Text(
          extent={{12,100},{68,94}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="heat port"),                                                                                              Text(
          extent={{14,36},{76,24}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="fluid port + heat from methanation"),                                                                     Text(
          extent={{14,-16},{76,-28}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="fluid port + heat from electrolyzer"),                                                                    Text(
          extent={{16,-68},{116,-92}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="fluid port + heat from methanation and electrolyzer"),                                                    Text(
          extent={{10,-146},{110,-170}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="fluid port + heat from methanation and electrolyzer + mass flow defined by boundary")}),
    experiment(StopTime=360000, Interval=600),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the Methanator FeedInStation</p>
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
</html>"),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=true,
      OutputFlatModelica=true));
end Test_FeedInStation_Methanator_WithCoolant;
