within TransiEnt.Components.Visualization.Check;
model TestStatisticsVisualizationTable
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
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  StatisticsVisualizationTable statisticsVisualizationTable(decimalSpaces=1) annotation (Placement(transformation(extent={{2,60},{100,100}})));
  inner ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
  Modelica.Blocks.Sources.RealExpression P_min(y=-Plant.pQDiagram.P_min)
                                                        annotation (Placement(
        transformation(
        extent={{-11,-9.5},{11,9.5}},
        rotation=0,
        origin={-49,25.5})));
  Boundaries.Electrical.Frequency                      Grid(useInputConnector=false) annotation (Placement(transformation(extent={{24,46},{36,58}})));
  Producer.Combined.LargeScaleCHP.CHP Plant(
    typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.BlackCoal,
    typeOfCO2AllocationMethod=2,
    h_nom=547e3,
    eta_th_const=0.696296,
    p_nom=20e5,
    m_flow_nom=750,
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.HardCoal,
    P_el_init=0,
    Q_flow_init=0,
    Q_flow_SG_init=0,
    t_startup=7200,
    PQCharacteristics=Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_WT(),
    T_feed_init=363.15) annotation (Placement(transformation(extent={{-36,-22},{10,22}})));
  Modelica.Blocks.Sources.Ramp Q_flow_set(
    height=-290e6,
    duration=86400,
    offset=0,
    startTime=0) annotation (Placement(transformation(
        extent={{-11,-9.5},{11,9.5}},
        rotation=0,
        origin={-19,47.5})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source(T_const(displayUnit="degC") = 338.15, m_flow_const=1000) annotation (Placement(transformation(
        extent={{-7,-9},{7,9}},
        rotation=180,
        origin={35,-10})));
  ClaRa.Visualisation.Quadruple quadruple annotation (Placement(transformation(extent={{46,1},{82,22}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    m_flow_nom=577.967,
    Delta_p=0,
    p_const(displayUnit="bar") = 1600000,
    T_const(displayUnit="degC")) annotation (Placement(transformation(
        extent={{-7,-8},{7,8}},
        rotation=180,
        origin={31,34})));
  PQDiagram_Display PQDiagram(PQCharacteristics=TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_WT()) annotation (Placement(transformation(extent={{66,-34},{96,-6}})));
  InfoBoxLargeCHP                          infoBoxLargeCHP annotation (Placement(transformation(extent={{26,-51},{44,-29}})));
equation

  connect(Plant.epp,Grid. epp) annotation (Line(
      points={{8.85,6.6},{10,6.6},{10,51.94},{23.94,51.94}},
      color={0,135,135},
      thickness=0.5));
  connect(Plant.P_set,P_min. y) annotation (Line(points={{-27.03,16.8667},{-27.03,25.5},{-36.9,25.5}},
                                                                                           color={0,0,127}));
  connect(Q_flow_set.y,Plant. Q_flow_set) annotation (Line(points={{-6.9,47.5},{-4,47.5},{-4,16.8667},{-4.49,16.8667}},   color={0,0,127}));
  connect(Plant.outlet,sink. steam_a) annotation (Line(
      points={{10.46,-4.76667},{14,-4.76667},{14,34},{24,34}},
      color={175,0,0},
      thickness=0.5));
  connect(source.steam_a,Plant. inlet) annotation (Line(
      points={{28,-10},{22,-10},{22,-9.9},{10.46,-9.9}},
      color={0,131,169},
      thickness=0.5));
  connect(source.eye,quadruple. eye) annotation (Line(points={{28,-2.8},{28,-2.8},{28,-10},{28,11.5},{46,11.5}},
                                                                                                             color={190,190,190}));
  connect(Plant.eye,PQDiagram. eyeIn) annotation (Line(points={{12.3,-20.1667},{20,-20.1667},{20,-20},{61.8,-20}}, color={28,108,200}));
  connect(Plant.eye,infoBoxLargeCHP. eye) annotation (Line(points={{12.3,-20.1667},{20,-20.1667},{20,-38},{24,-38},{24,-38.2},{26.9,-38.2}}, color={28,108,200}));
  annotation (experiment(StopTime=3.1536e+007, Interval=900),  __Dymola_experimentSetupOutput);
end TestStatisticsVisualizationTable;