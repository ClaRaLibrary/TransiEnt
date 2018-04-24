within TransiEnt.Producer.Combined.LargeScaleCHP.Check;
model TestDetailedCHP
  extends TransiEnt.Basics.Icons.Checkmodel;

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

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

 inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-60,80},{-40,100}})));

  TransiEnt.Producer.Combined.LargeScaleCHP.DetailedCHP detailedCHP(typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.BlackCoal, redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.HardCoal) annotation (Placement(transformation(extent={{-116,-50},{60,58}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency electricGrid(useInputConnector=false) annotation (Placement(transformation(extent={{50,42},{70,62}})));

  TransiEnt.Components.Visualization.InfoBoxLargeCHP infoBoxLargeCHP annotation (Placement(transformation(extent={{-10,-86},{38,-46}})));
  TransiEnt.Components.Sensors.TemperatureSensor
                                       T_out_sensor annotation (Placement(transformation(extent={{36,32},{16,52}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi pressure_Sink_ph(
    Delta_p=0,
    p_const(displayUnit="bar") = 450000,
    T_const(displayUnit="degC") = 325.15,
    m_flow_nom=600)                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={60,-14})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow boundaryVLE_Txim_flow(m_flow_const=-300, T_const(displayUnit="degC") = 318.15) annotation (Placement(transformation(extent={{112,-4},{92,16}})));
  Modelica.Blocks.Sources.Ramp ramp3(
    offset=-60e6,
    duration=2e4,
    startTime=5e4,
    height=-120e6) annotation (Placement(transformation(extent={{-80,42},{-64,58}})));
  TransiEnt.Components.Visualization.PQDiagram_Display pQDiagram_Display annotation (Placement(transformation(extent={{46,-88},{96,-40}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    startTime=2e4,
    height=60e6,
    offset=-140e6,
    duration=2e4) annotation (Placement(transformation(extent={{-80,16},{-64,32}})));
equation
  connect(detailedCHP.epp, electricGrid.epp) annotation (Line(
      points={{14.7778,17.7455},{37.75,17.7455},{37.75,51.9},{49.9,51.9}},
      color={0,135,135},
      thickness=0.5));
  connect(detailedCHP.eye, infoBoxLargeCHP.eye) annotation (Line(points={{18.4444,-18.0909},{24,-18.0909},{24,-38},{-14,-38},{-14,-42},{-14,-62.7273},{-7.6,-62.7273},{-7.6,-62.7273}},
                                                                                          color={28,108,200}));
  connect(detailedCHP.outlet, T_out_sensor.port) annotation (Line(
      points={{16.4889,2.52727},{20,2.52727},{20,32},{26,32}},
      color={175,0,0},
      thickness=0.5));
  connect(detailedCHP.inlet, pressure_Sink_ph.steam_a) annotation (Line(
      points={{16.4889,-4.34545},{34,-4.34545},{34,-14},{50,-14}},
      color={175,0,0},
      thickness=0.5));
  connect(detailedCHP.outlet, boundaryVLE_Txim_flow.steam_a) annotation (Line(
      points={{16.4889,2.52727},{55.2445,2.52727},{55.2445,6},{92,6}},
      color={175,0,0},
      thickness=0.5));
  connect(ramp3.y, detailedCHP.Q_flow_set) annotation (Line(points={{-63.2,50},{-60,50},{-60,40},{0.6,40},{0.6,31.4909}}, color={0,0,127}));
  connect(detailedCHP.eye, pQDiagram_Display.eyeIn) annotation (Line(points={{18.4444,-18.0909},{36,-18.0909},{36,-64},{39,-64}},    color={28,108,200}));
  connect(ramp1.y, detailedCHP.P_set) annotation (Line(points={{-63.2,24},{-52,24},{-52,31.4909},{-23.3556,31.4909}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                                         Bitmap(extent={{-98,-96},{-20,-42}}, fileName="modelica://TransiEnt/Images/PQ_WW1.PNG")}), experiment(
      StopTime=86400,
      Interval=900,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(equidistant=false, events=false),
    __Dymola_experimentFlags(
      Advanced(
        EvaluateAlsoTop=true,
        GenerateVariableDependencies=false,
        OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end TestDetailedCHP;
