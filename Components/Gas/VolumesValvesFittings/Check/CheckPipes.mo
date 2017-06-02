within TransiEnt.Components.Gas.VolumesValvesFittings.Check;
model CheckPipes
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

  import TILMedia;
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow boundaryVLE_hxim_flow(h_const=800e3, m_flow_const=-20) annotation (Placement(transformation(extent={{-76,40},{-56,60}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi boundaryVLE_phxi(p_const=16e5, h_const=800e5) annotation (Placement(transformation(extent={{78,40},{58,60}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow boundaryVLE_hxim_flow1(h_const=800e3, m_flow_const=-20) annotation (Placement(transformation(extent={{-76,0},{-56,20}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi boundaryVLE_phxi1(p_const=16e5, h_const=800e5) annotation (Placement(transformation(extent={{78,0},{58,20}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L2_Simple pipeFlow_L2_Simple(
    m_flow_nom=10,
    Delta_p_nom=1e5,
    frictionAtInlet=false,
    frictionAtOutlet=true) annotation (Placement(transformation(extent={{-14,45},{14,55}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple pipeFlow_L4_Simple(
    m_flow_nom=10,
    Delta_p_nom=1e5,
    frictionAtInlet=false,
    frictionAtOutlet=true) annotation (Placement(transformation(extent={{-14,5},{14,15}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-10,80},{10,100}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi source_pTxi(p_const=1450000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={66,-24})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi pipe_NG_L2(
    diameter_i=0.366,
    Delta_p_nom(displayUnit="bar") = 534880,
    length=30650,
    m_flow_nom=88.949/3,
    N_tubes=1,
    m_flow_start=ones(pipe_NG_L2.N_cv + 1)*88.949/3,
    frictionAtInlet=false,
    frictionAtOutlet=true,
    p_nom=ones(pipe_NG_L2.N_cv)*17e5,
    h_nom=ones(pipe_NG_L2.N_cv)*(-1849),
    h_start=ones(pipe_NG_L2.N_cv)*(-1849),
    p_start=ones(pipe_NG_L2.N_cv)*17e5) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=0,
        origin={0,-24})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sink_mFlow(variable_m_flow=false, m_flow_const=-88.949/2/3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-64,-24})));
  PipeFlow_L4_Simple_varXi                                                             pipe_NG_L4(
    diameter_i=0.366,
    Delta_p_nom(displayUnit="bar") = 534880,
    p_start={16e5,14.858e5,12.716e5},
    N_cv=3,
    length=30650,
    m_flow_nom=88.949/3,
    N_tubes=1,
    m_flow_start=ones(pipe_NG_L4.N_cv + 1)*88.949/3,
    frictionAtOutlet=true,
    p_nom=ones(pipe_NG_L4.N_cv)*17e5,
    h_nom=ones(pipe_NG_L4.N_cv)*(-1849),
    h_start=ones(pipe_NG_L4.N_cv)*(-1849))
                           annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=0,
        origin={0,-54})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sink_mFlow1(variable_m_flow=false, m_flow_const=-88.949/2/3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-64,-54})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi source_pTxi1(p_const=1450000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={66,-54})));
  PipeFlow_L4_Simple_constXi                                                   pipe_NG_L2_const(
    diameter_i=0.366,
    Delta_p_nom(displayUnit="bar") = 534880,
    length=30650,
    N_tubes=3,
    p_nom=ones(pipe_NG_L2_const.N_cv)*16e5,
    h_nom=ones(pipe_NG_L2_const.N_cv)*78570,
    m_flow_nom=88.949/3,
    frictionAtOutlet=true,
    frictionAtInlet=false,
    h_start=ones(pipe_NG_L2_const.N_cv)*(-1849),
    p_start=ones(pipe_NG_L2_const.N_cv)*17e5)
                           annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=0,
        origin={0,-84})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sink_mFlow2(variable_m_flow=false, m_flow_const=-88.949/2/3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-64,-84})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi source_pTxi2(p_const=1450000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={66,-84})));
  inner ModelStatistics                                                   modelStatisticsDetailed annotation (Placement(transformation(extent={{0,80},{20,100}})));
equation
  connect(boundaryVLE_hxim_flow.steam_a, pipeFlow_L2_Simple.inlet) annotation (Line(
      points={{-56,50},{-14,50}},
      color={0,131,169},
      thickness=0.5));
  connect(pipeFlow_L2_Simple.outlet, boundaryVLE_phxi.steam_a) annotation (Line(
      points={{14,50},{14,50},{58,50}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundaryVLE_hxim_flow1.steam_a, pipeFlow_L4_Simple.inlet) annotation (Line(
      points={{-56,10},{-14,10}},
      color={0,131,169},
      thickness=0.5));
  connect(pipeFlow_L4_Simple.outlet, boundaryVLE_phxi1.steam_a) annotation (Line(
      points={{14,10},{14,10},{58,10}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pipe_NG_L2.gasPortOut, source_pTxi.gasPort) annotation (Line(
      points={{14,-24},{14,-24},{56,-24}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe_NG_L2.gasPortIn, sink_mFlow.gasPort) annotation (Line(
      points={{-14,-24},{-54,-24}},
      color={255,255,0},
      thickness=1.5));
  connect(sink_mFlow1.gasPort, pipe_NG_L4.gasPortIn) annotation (Line(
      points={{-54,-54},{-14,-54}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe_NG_L4.gasPortOut, source_pTxi1.gasPort) annotation (Line(
      points={{14,-54},{36,-54},{56,-54}},
      color={255,255,0},
      thickness=1.5));
  connect(sink_mFlow2.gasPort, pipe_NG_L2_const.gasPortIn) annotation (Line(
      points={{-54,-84},{-34,-84},{-14,-84}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe_NG_L2_const.gasPortOut, source_pTxi2.gasPort) annotation (Line(
      points={{14,-84},{35,-84},{56,-84}},
      color={255,255,0},
      thickness=1.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})));
end CheckPipes;
