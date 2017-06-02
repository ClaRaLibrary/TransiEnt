within TransiEnt.Producer.Combined.LargeScaleCHP.Check;
model TestDetailedCHP
  extends TransiEnt.Basics.Icons.Checkmodel;

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

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  inner SimCenter           simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

 inner ModelStatistics           modelStatistics
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));

  Modelica.Blocks.Sources.Constant       P_set(k=-100e6)
                                                        annotation (Placement(
        transformation(
        extent={{-8,-7.5},{8,7.5}},
        rotation=0,
        origin={-61,51.5})));
  Modelica.Blocks.Sources.Constant       Q_flow_set(k=-100e6)
                                                            annotation (
      Placement(transformation(
        extent={{-7,-7.5},{7,7.5}},
        rotation=0,
        origin={-35,51.5})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi pressureSink_pT3(
    m_flow_nom=577.967,
    p_const(displayUnit="bar") = 2000000,
    T_const(displayUnit="degC") = 384.624) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={58,10})));
  DetailedCHP detailedCHP(typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.BlackCoal, redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.HardCoal) annotation (Placement(transformation(extent={{-116,-50},{60,58}})));
  Components.Boundaries.Electrical.Frequency electricGrid(useInputConnector=false) annotation (Placement(transformation(extent={{50,42},{70,62}})));

  ClaRa.Visualisation.Quadruple quadruple annotation (Placement(transformation(extent={{48,26},{68,36}})));
  ClaRa.Visualisation.Quadruple quadruple2
                                          annotation (Placement(transformation(extent={{56,-12},{76,-2}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi pressure_Sink_ph(
    m_flow_nom=577.967,
    Delta_p=0,
    p_const(displayUnit="bar") = 450000,
    T_const(displayUnit="degC") = 325.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={64,-26})));
  Components.Visualization.InfoBoxLargeCHP infoBoxLargeCHP annotation (Placement(transformation(extent={{30,-43},{48,-17}})));
equation
  connect(Q_flow_set.y, detailedCHP.Q_flow_set) annotation (Line(
      points={{-27.3,51.5},{0,51.5},{0,31.4909},{0.6,31.4909}},
      color={0,0,127}));
  connect(detailedCHP.epp, electricGrid.epp) annotation (Line(
      points={{14.7778,17.7455},{37.75,17.7455},{37.75,51.9},{49.9,51.9}},
      color={0,135,135},
      thickness=0.5));
  connect(pressureSink_pT3.eye, quadruple.eye) annotation (Line(
      points={{48,18},{48,20},{48,24},{48,31}},
      color={190,190,190}));
  connect(detailedCHP.outlet, pressureSink_pT3.steam_a) annotation (Line(
      points={{16.4889,2.52727},{41.6,2.52727},{41.6,10},{48,10}},
      color={175,0,0},
      thickness=0.5));
  connect(pressure_Sink_ph.eye, quadruple2.eye) annotation (Line(points={{54,-18},{54,-18},{54,-8},{52,-8},{52,-6},{56,-6},{56,-7}},
                                                                                                               color={190,190,190}));
  connect(detailedCHP.eye, infoBoxLargeCHP.eye) annotation (Line(points={{18.4444,-18.0909},{22,-18.0909},{22,-28},{26,-28},{26,-27.8727},{30.9,-27.8727}},
                                                                                          color={28,108,200}));
  connect(P_set.y, detailedCHP.P_set) annotation (Line(points={{-52.2,51.5},{-46,51.5},{-46,31.4909},{-23.3556,31.4909}},    color={0,0,127}));
  connect(pressure_Sink_ph.steam_a, detailedCHP.inlet) annotation (Line(
      points={{54,-26},{44,-26},{44,-4.34545},{16.4889,-4.34545}},
      color={0,131,169},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                                         Bitmap(extent={{-82,-100},{-4,-44}}, fileName="modelica://TransiEnt/Images/PQ_WW1.PNG")}), experiment(StopTime=86400, Interval=900));
end TestDetailedCHP;
