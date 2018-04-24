within TransiEnt.Grid.Gas;
model GasGridHamburg "High pressure gas grid of Hamburg"
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
  import TransiEnt;
  extends TransiEnt.Basics.Icons.HPGasGridHamburg;

  // _____________________________________________
  //
  //             Outer Models
  // _____________________________________________
  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  outer TransiEnt.Grid.Gas.StatCycleGasGridHamburg Init;
  outer TransiEnt.Grid.Gas.StatCycleGasGridHamburg Nom;
  outer TransiEnt.Basics.Records.PipeParameter ringPipes(
    N_pipes=12,
    m_flow_nom={15.30774663,15.30774663,15.30774663,7.480851372,4.642372591,15.43961893,31.38857892,16.18618504,0.648491321,21.06612849,0,46.82819785},
    Delta_p_nom(displayUnit="Pa") = {51073.13122,37320.21958,37320.21958,65318.84345,15753.31034,240262.342,422986.3228,420328.1906,761.4519462,740174.5742,0,793880.8938},
    length={2353.4,9989.1,10203.5,11846.6,7285.6,10878.7,4420.5,11961.1,10915.2,13932.2,28366.9,16710},
    diameter(displayUnit="mm") = {0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.5}) annotation (Placement(transformation(extent={{-280,-160},{-260,-140}})));

  // _____________________________________________
  //
  //             Parameter
  // _____________________________________________
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium in the grid";

  //Pipe discritization and balance equation
  parameter Real Nper10km=5 "Number of discrete volumes in 10 km pipe length";
  parameter Integer massBalance=1 "Mass balance and species balance fomulation" annotation(Dialog(group="Fundamental Definitions"),choices(choice=1 "ClaRa formulation", choice=2 "TransiEnt formulation 1a", choice=3 "TransiEnt formulation 1b"));
  replaceable model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseVLE_L4 "|Pipes|Pressure loss model" annotation (choicesAllMatching);

  //FeedInControl
  parameter Real phi_H2max=simCenter.phi_H2max "|FeedIn|Volumetric H2 feed-in limit" annotation(Evaluate=false);
  parameter Modelica.SIunits.Volume V_mixNG=1 "|FeedIn|Volume of NG junction" annotation (Evaluate=false);

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
  Modelica.SIunits.Velocity[2] w_pipe_Tor={pipe_Tornesch.summary.outline.w_inlet, pipe_Tornesch.summary.outline.w_outlet};
  Modelica.SIunits.Velocity[2] w_pipe_Lev={pipe_Leversen.summary.outline.w_inlet, pipe_Leversen.summary.outline.w_outlet};
  Modelica.SIunits.Velocity[2] w_Ringline={Ringline.summary.outline.w_inlet, Ringline.summary.outline.w_outlet};
  Modelica.SIunits.Velocity[2] w_Ringline1={Ringline1.summary.outline.w_inlet, Ringline1.summary.outline.w_outlet};
  Modelica.SIunits.Velocity[2] w_Ringline2={Ringline2.summary.outline.w_inlet, Ringline2.summary.outline.w_outlet};
  Modelica.SIunits.Velocity[2] w_Ringline3={Ringline3.summary.outline.w_inlet, Ringline3.summary.outline.w_outlet};
  Modelica.SIunits.Velocity[2] w_Ringline4={Ringline4.summary.outline.w_inlet, Ringline4.summary.outline.w_outlet};
  Modelica.SIunits.Velocity[2] w_Ringline5={Ringline5.summary.outline.w_inlet, Ringline5.summary.outline.w_outlet};
  Modelica.SIunits.Velocity[2] w_Ringline6={Ringline6.summary.outline.w_inlet, Ringline6.summary.outline.w_outlet};
  Modelica.SIunits.Velocity[2] w_Ringline7={Ringline7.summary.outline.w_inlet, Ringline7.summary.outline.w_outlet};
  Modelica.SIunits.Velocity[2] w_Ringline8={Ringline8.summary.outline.w_inlet, Ringline8.summary.outline.w_outlet};

  // _____________________________________________
  //
  //             Instances of other classes
  // _____________________________________________
protected
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi pipe_Leversen(
    showExpertSummary=true,
    initOption=208,
    medium=medium,
    h_start=ones(pipe_Leversen.N_cv)*Init.pipe_Leversen.h_in,
    m_flow_start=ones(pipe_Leversen.N_cv + 1)*Init.pipe_Leversen.m_flow,
    xi_start=Init.pipe_Leversen.xi_in,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    p_start=if pipe_Leversen.N_cv < 2 then Init.pipe_Leversen.p_in*ones(pipe_Leversen.N_cv) else linspace(
        Init.pipe_Leversen.p_in,
        Init.pipe_Leversen.p_out,
        pipe_Leversen.N_cv),
    N_cv=if integer(Nper10km*pipe_Leversen.length/10000) < 1 then 1 else integer(Nper10km*pipe_Leversen.length/10000),
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss,
    xi_nom=Nom.pipe_Leversen.xi_in,
    length(displayUnit="m") = ringPipes.length[1],
    diameter_i=ringPipes.diameter[1],
    N_tubes=ringPipes.N_ducts[1],
    h_nom=ones(pipe_Leversen.N_cv)*Nom.pipe_Leversen.h_in,
    m_flow_nom=Nom.m_flow_nom_Leversen,
    Delta_p_nom=Nom.Delta_p_nom_Leversen,
    p_nom=if pipe_Leversen.N_cv < 2 then Nom.pipe_Leversen.p_in*ones(pipe_Leversen.N_cv) else linspace(
        Nom.pipe_Leversen.p_in,
        Nom.pipe_Leversen.p_out,
        pipe_Leversen.N_cv))              annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=90,
        origin={-128,-243})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi pipe_Tornesch(
    showExpertSummary=true,
    medium=medium,
    h_start=ones(pipe_Tornesch.N_cv)*Init.pipe_Tornesch.h_in,
    m_flow_start=ones(pipe_Tornesch.N_cv + 1)*Init.pipe_Tornesch.m_flow,
    xi_start=Init.pipe_Tornesch.xi_in,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    p_start=if pipe_Tornesch.N_cv < 2 then Init.pipe_Tornesch.p_in*ones(pipe_Tornesch.N_cv) else linspace(
        Init.pipe_Tornesch.p_in,
        Init.pipe_Tornesch.p_out,
        pipe_Tornesch.N_cv),
    N_cv=if integer(Nper10km*pipe_Tornesch.length/10000) < 1 then 1 else integer(Nper10km*pipe_Tornesch.length/10000),
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss,
    h_nom=ones(pipe_Tornesch.N_cv)*Nom.pipe_Tornesch.h_in,
    m_flow_nom=Nom.m_flow_nom_Tornesch,
    Delta_p_nom=Nom.Delta_p_nom_Tornesch,
    xi_nom=Nom.pipe_Tornesch.xi_in,
    length(displayUnit="m") = ringPipes.length[12],
    diameter_i=ringPipes.diameter[12],
    N_tubes=ringPipes.N_ducts[12],
    p_nom=if pipe_Tornesch.N_cv < 2 then Nom.pipe_Tornesch.p_in*ones(pipe_Tornesch.N_cv) else linspace(
        Nom.pipe_Tornesch.p_in,
        Nom.pipe_Tornesch.p_out,
        pipe_Tornesch.N_cv))       annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=0,
        origin={-222,265})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi Ringline(
    showExpertSummary=true,
    medium=medium,
    h_start=ones(Ringline.N_cv)*Init.Ringline.h_in,
    m_flow_start=ones(Ringline.N_cv + 1)*Init.Ringline.m_flow,
    xi_start=Init.Ringline.xi_in,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    p_start=if Ringline.N_cv < 2 then Init.Ringline.p_in*ones(Ringline.N_cv) else linspace(
        Init.Ringline.p_in,
        Init.Ringline.p_out,
        Ringline.N_cv),
    N_cv=if integer(Nper10km*Ringline.length/10000) < 1 then 1 else integer(Nper10km*Ringline.length/10000),
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss,
    xi_nom=Nom.Ringline.xi_in,
    length(displayUnit="m") = ringPipes.length[2],
    diameter_i=ringPipes.diameter[2],
    N_tubes=ringPipes.N_ducts[2],
    h_nom=ones(Ringline.N_cv)*Nom.Ringline.h_in,
    m_flow_nom=Nom.m_flow_nom_Ringline,
    Delta_p_nom=Nom.Delta_p_nom_Ringline,
    p_nom=if Ringline.N_cv < 2 then Nom.Ringline.p_in*ones(Ringline.N_cv) else linspace(
        Nom.Ringline.p_in,
        Nom.Ringline.p_out,
        Ringline.N_cv))                   annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=90,
        origin={-192,-197})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi Ringline1(
    showExpertSummary=true,
    medium=medium,
    h_start=ones(Ringline1.N_cv)*Init.Ringline1.h_in,
    m_flow_start=ones(Ringline1.N_cv + 1)*Init.Ringline1.m_flow,
    xi_start=Init.Ringline1.xi_in,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    p_start=if Ringline1.N_cv < 2 then Init.Ringline1.p_in*ones(Ringline1.N_cv) else linspace(
        Init.Ringline1.p_in,
        Init.Ringline1.p_out,
        Ringline1.N_cv),
    N_cv=if integer(Nper10km*Ringline1.length/10000) < 1 then 1 else integer(Nper10km*Ringline1.length/10000),
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss,
    xi_nom=Nom.Ringline1.xi_in,
    length(displayUnit="m") = ringPipes.length[3],
    diameter_i=ringPipes.diameter[3],
    N_tubes=ringPipes.N_ducts[3],
    h_nom=ones(Ringline1.N_cv)*Nom.Ringline1.h_in,
    m_flow_nom=Nom.m_flow_nom_Ringline1,
    Delta_p_nom=Nom.Delta_p_nom_Ringline1,
    p_nom=if Ringline1.N_cv < 2 then Nom.Ringline1.p_in*ones(Ringline1.N_cv) else linspace(
        Nom.Ringline1.p_in,
        Nom.Ringline1.p_out,
        Ringline1.N_cv))                   annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={-98,-197})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi Ringline2(
    showExpertSummary=true,
    medium=medium,
    h_start=ones(Ringline2.N_cv)*Init.Ringline2.h_in,
    m_flow_start=ones(Ringline2.N_cv + 1)*Init.Ringline2.m_flow,
    xi_start=Init.Ringline2.xi_in,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    p_start=if Ringline2.N_cv < 2 then Init.Ringline2.p_in*ones(Ringline2.N_cv) else linspace(
        Init.Ringline2.p_in,
        Init.Ringline2.p_out,
        Ringline2.N_cv),
    N_cv=if integer(Nper10km*Ringline2.length/10000) < 1 then 1 else integer(Nper10km*Ringline2.length/10000),
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss,
    xi_nom=Nom.Ringline2.xi_in,
    length(displayUnit="m") = ringPipes.length[4],
    diameter_i=ringPipes.diameter[4],
    N_tubes=ringPipes.N_ducts[4],
    h_nom=ones(Ringline2.N_cv)*Nom.Ringline2.h_in,
    m_flow_nom=Nom.m_flow_nom_Ringline2,
    Delta_p_nom=Nom.Delta_p_nom_Ringline2,
    p_nom=if Ringline2.N_cv < 2 then Nom.Ringline2.p_in*ones(Ringline2.N_cv) else linspace(
        Nom.Ringline2.p_in,
        Nom.Ringline2.p_out,
        Ringline2.N_cv))                   annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=90,
        origin={-194,-79})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi Ringline3(
    showExpertSummary=true,
    medium=medium,
    h_start=ones(Ringline3.N_cv)*Init.Ringline3.h_in,
    m_flow_start=ones(Ringline3.N_cv + 1)*Init.Ringline3.m_flow,
    xi_start=Init.Ringline3.xi_in,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    p_start=if Ringline3.N_cv < 2 then Init.Ringline3.p_in*ones(Ringline3.N_cv) else linspace(
        Init.Ringline3.p_in,
        Init.Ringline3.p_out,
        Ringline3.N_cv),
    N_cv=if integer(Nper10km*Ringline3.length/10000) < 1 then 1 else integer(Nper10km*Ringline3.length/10000),
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss,
    xi_nom=Nom.Ringline3.xi_in,
    length(displayUnit="m") = ringPipes.length[5],
    diameter_i=ringPipes.diameter[5],
    N_tubes=ringPipes.N_ducts[5],
    h_nom=ones(Ringline3.N_cv)*Nom.Ringline3.h_in,
    m_flow_nom=Nom.m_flow_nom_Ringline3,
    Delta_p_nom=Nom.Delta_p_nom_Ringline3,
    p_nom=if Ringline3.N_cv < 2 then Nom.Ringline3.p_in*ones(Ringline3.N_cv) else linspace(
        Nom.Ringline3.p_in,
        Nom.Ringline3.p_out,
        Ringline3.N_cv))                   annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=270,
        origin={-192,31})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi Ringline4(
    showExpertSummary=true,
    medium=medium,
    h_start=ones(Ringline4.N_cv)*Init.Ringline4.h_in,
    m_flow_start=ones(Ringline4.N_cv + 1)*Init.Ringline4.m_flow,
    xi_start=Init.Ringline4.xi_in,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    p_start=if Ringline4.N_cv < 2 then Init.Ringline4.p_in*ones(Ringline4.N_cv) else linspace(
        Init.Ringline4.p_in,
        Init.Ringline4.p_out,
        Ringline4.N_cv),
    N_cv=if integer(Nper10km*Ringline4.length/10000) < 1 then 1 else integer(Nper10km*Ringline4.length/10000),
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss,
    xi_nom=Nom.Ringline4.xi_in,
    length(displayUnit="m") = ringPipes.length[6],
    diameter_i=ringPipes.diameter[6],
    N_tubes=ringPipes.N_ducts[6],
    h_nom=ones(Ringline4.N_cv)*Nom.Ringline4.h_in,
    m_flow_nom=Nom.m_flow_nom_Ringline4,
    Delta_p_nom=Nom.Delta_p_nom_Ringline4,
    p_nom=if Ringline4.N_cv < 2 then Nom.Ringline4.p_in*ones(Ringline4.N_cv) else linspace(
        Nom.Ringline4.p_in,
        Nom.Ringline4.p_out,
        Ringline4.N_cv))                   annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=270,
        origin={-192,149})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi Ringline5(
    showExpertSummary=true,
    medium=medium,
    h_start=ones(Ringline5.N_cv)*Init.Ringline5.h_in,
    m_flow_start=ones(Ringline5.N_cv + 1)*Init.Ringline5.m_flow,
    xi_start=Init.Ringline5.xi_in,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    p_start=if Ringline5.N_cv < 2 then Init.Ringline5.p_in*ones(Ringline5.N_cv) else linspace(
        Init.Ringline5.p_in,
        Init.Ringline5.p_out,
        Ringline5.N_cv),
    N_cv=if integer(Nper10km*Ringline5.length/10000) < 1 then 1 else integer(Nper10km*Ringline5.length/10000),
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss,
    xi_nom=Nom.Ringline5.xi_in,
    length(displayUnit="m") = ringPipes.length[7],
    diameter_i=ringPipes.diameter[7],
    N_tubes=ringPipes.N_ducts[7],
    h_nom=ones(Ringline5.N_cv)*Nom.Ringline5.h_in,
    m_flow_nom=Nom.m_flow_nom_Ringline5,
    Delta_p_nom=Nom.Delta_p_nom_Ringline5,
    p_nom=if Ringline5.N_cv < 2 then Nom.Ringline5.p_in*ones(Ringline5.N_cv) else linspace(
        Nom.Ringline5.p_in,
        Nom.Ringline5.p_out,
        Ringline5.N_cv))                   annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=0,
        origin={-82,265})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi Ringline6(
    showExpertSummary=true,
    medium=medium,
    h_start=ones(Ringline6.N_cv)*Init.Ringline6.h_in,
    m_flow_start=ones(Ringline6.N_cv + 1)*Init.Ringline6.m_flow,
    xi_start=Init.Ringline6.xi_in,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    p_start=if Ringline6.N_cv < 2 then Init.Ringline6.p_in*ones(Ringline6.N_cv) else linspace(
        Init.Ringline6.p_in,
        Init.Ringline6.p_out,
        Ringline6.N_cv),
    N_cv=if integer(Nper10km*Ringline6.length/10000) < 1 then 1 else integer(Nper10km*Ringline6.length/10000),
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss,
    xi_nom=Nom.Ringline6.xi_in,
    length(displayUnit="m") = ringPipes.length[8],
    diameter_i=ringPipes.diameter[8],
    N_tubes=ringPipes.N_ducts[8],
    h_nom=ones(Ringline6.N_cv)*Nom.Ringline6.h_in,
    m_flow_nom=Nom.m_flow_nom_Ringline6,
    Delta_p_nom=Nom.Delta_p_nom_Ringline6,
    p_nom=if Ringline6.N_cv < 2 then Nom.Ringline6.p_in*ones(Ringline6.N_cv) else linspace(
        Nom.Ringline6.p_in,
        Nom.Ringline6.p_out,
        Ringline6.N_cv))                   annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=0,
        origin={100,265})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi Ringline7(
    showExpertSummary=true,
    medium=medium,
    h_start=ones(Ringline7.N_cv)*Init.Ringline7.h_in,
    m_flow_start=ones(Ringline7.N_cv + 1)*Init.Ringline7.m_flow,
    xi_start=Init.Ringline7.xi_in,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    p_start=if Ringline7.N_cv < 2 then Init.Ringline7.p_in*ones(Ringline7.N_cv) else linspace(
        Init.Ringline7.p_in,
        Init.Ringline7.p_out,
        Ringline7.N_cv),
    N_cv=if integer(Nper10km*Ringline7.length/10000) < 1 then 1 else integer(Nper10km*Ringline7.length/10000),
    massBalance=massBalance,
    xi_nom=Nom.Ringline7.xi_in,
    length(displayUnit="m") = ringPipes.length[9],
    diameter_i=ringPipes.diameter[9],
    N_tubes=ringPipes.N_ducts[9],
    h_nom=ones(Ringline7.N_cv)*Nom.Ringline7.h_in,
    m_flow_nom=Nom.m_flow_nom_Ringline7,
    Delta_p_nom=Nom.Delta_p_nom_Ringline7,
    redeclare model PressureLoss = PressureLoss,
    p_nom=if Ringline7.N_cv < 2 then Nom.Ringline7.p_in*ones(Ringline7.N_cv) else linspace(
        Nom.Ringline7.p_in,
        Nom.Ringline7.p_out,
        Ringline7.N_cv))                         annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={162,49})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi Ringline8(
    showExpertSummary=true,
    medium=medium,
    h_start=ones(Ringline8.N_cv)*Init.Ringline8.h_in,
    m_flow_start=ones(Ringline8.N_cv + 1)*Init.Ringline8.m_flow,
    xi_start=Init.Ringline8.xi_in,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    p_start=if Ringline8.N_cv < 2 then Init.Ringline8.p_in*ones(Ringline8.N_cv) else linspace(
        Init.Ringline8.p_in,
        Init.Ringline8.p_out,
        Ringline8.N_cv),
    N_cv=if integer(Nper10km*Ringline8.length/10000) < 1 then 1 else integer(Nper10km*Ringline8.length/10000),
    xi_nom=Nom.Ringline8.xi_in,
    length(displayUnit="m") = ringPipes.length[10],
    diameter_i=ringPipes.diameter[10],
    N_tubes=ringPipes.N_ducts[10],
    massBalance=massBalance,
    h_nom=ones(Ringline8.N_cv)*Nom.Ringline8.h_in,
    m_flow_nom=Nom.m_flow_nom_Ringline8,
    Delta_p_nom=Nom.Delta_p_nom_Ringline8,
    redeclare model PressureLoss = PressureLoss,
    p_nom=if Ringline8.N_cv < 2 then Nom.Ringline8.p_in*ones(Ringline8.N_cv) else linspace(
        Nom.Ringline8.p_in,
        Nom.Ringline8.p_out,
        Ringline8.N_cv))                         annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={162,-95})));

  // _____________________________________________
  //
  //             Interfaces
  // _____________________________________________
public
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn offTakeHarburg(Medium=medium) annotation (Placement(transformation(extent={{-134,-156},{-114,-136}}), iconTransformation(extent={{-126,-142},{-114,-130}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn offTakeAltona(Medium=medium) annotation (Placement(transformation(extent={{-170,-12},{-150,8}}), iconTransformation(extent={{-162,-4},{-150,8}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn offTakeEimsbuettel(Medium=medium) annotation (Placement(transformation(extent={{-144,56},{-124,76}}), iconTransformation(extent={{-128,68},{-116,80}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn offTakeNord(Medium=medium) annotation (Placement(transformation(extent={{-6,188},{14,208}}), iconTransformation(extent={{2,196},{14,208}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn offTakeWandsbek(Medium=medium) annotation (Placement(transformation(extent={{98,90},{118,110}}), iconTransformation(extent={{106,98},{118,110}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn offTakeMitte(Medium=medium) annotation (Placement(transformation(extent={{80,-62},{100,-42}}), iconTransformation(extent={{90,-48},{102,-36}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn offTakeBergedorf(Medium=medium) annotation (Placement(transformation(extent={{130,-168},{150,-148}}), iconTransformation(extent={{140,-154},{152,-142}})));

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn GTSLev(Medium=medium) annotation (Placement(transformation(extent={{-158,-286},{-138,-266}}), iconTransformation(extent={{-158,-286},{-138,-266}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn GTSTor(Medium=medium) annotation (Placement(transformation(extent={{-294,254},{-274,274}}), iconTransformation(extent={{-294,254},{-274,274}})));
equation

  connect(Ringline4.gasPortIn, Ringline5.gasPortIn) annotation (Line(
      points={{-192,163},{-192,265},{-96,265}},
      color={255,255,0},
      thickness=1.5,
      smooth=Smooth.None));
  connect(Ringline5.gasPortOut, Ringline6.gasPortIn) annotation (Line(
      points={{-68,265},{86,265}},
      color={255,255,0},
      thickness=1.5,
      smooth=Smooth.None));
  connect(Ringline6.gasPortOut, Ringline7.gasPortOut) annotation (Line(
      points={{114,265},{162,265},{162,63}},
      color={255,255,0},
      thickness=1.5,
      smooth=Smooth.None));
  connect(Ringline8.gasPortOut, Ringline7.gasPortIn) annotation (Line(
      points={{162,-81},{162,35}},
      color={255,255,0},
      thickness=1.5,
      smooth=Smooth.None));
  connect(Ringline.gasPortOut, Ringline2.gasPortIn) annotation (Line(
      points={{-192,-183},{-192,-93},{-194,-93}},
      color={255,255,0},
      thickness=1.5));
  connect(Ringline2.gasPortOut, Ringline3.gasPortOut) annotation (Line(
      points={{-194,-65},{-194,-8},{-192,-8},{-192,17}},
      color={255,255,0},
      thickness=1.5));
  connect(offTakeHarburg, Ringline.gasPortOut) annotation (Line(
      points={{-124,-146},{-124,-168},{-192,-168},{-192,-183}},
      color={255,255,0},
      thickness=1.5));
  connect(offTakeAltona, offTakeAltona) annotation (Line(
      points={{-160,-2},{-192,-2},{-192,2},{-192,-2},{-160,-2}},
      color={255,255,0},
      thickness=1.5));
  connect(offTakeAltona, Ringline3.gasPortOut) annotation (Line(
      points={{-160,-2},{-192,-2},{-192,17}},
      color={255,255,0},
      thickness=1.5));
  connect(offTakeNord, Ringline6.gasPortIn) annotation (Line(
      points={{4,198},{4,265},{86,265}},
      color={255,255,0},
      thickness=1.5));
  connect(offTakeWandsbek, Ringline7.gasPortOut) annotation (Line(
      points={{108,100},{162,100},{162,63}},
      color={255,255,0},
      thickness=1.5));
  connect(offTakeMitte, Ringline7.gasPortIn) annotation (Line(
      points={{90,-52},{162,-52},{162,35}},
      color={255,255,0},
      thickness=1.5));
  connect(offTakeBergedorf, Ringline8.gasPortIn) annotation (Line(
      points={{140,-158},{162,-158},{162,-109}},
      color={255,255,0},
      thickness=1.5));
  connect(Ringline4.gasPortOut, Ringline3.gasPortIn) annotation (Line(
      points={{-192,135},{-192,66},{-192,45}},
      color={255,255,0},
      thickness=1.5));
  connect(offTakeEimsbuettel, Ringline3.gasPortIn) annotation (Line(
      points={{-134,66},{-192,66},{-192,45}},
      color={255,255,0},
      thickness=1.5));
  connect(Ringline.gasPortIn, pipe_Leversen.gasPortOut) annotation (Line(
      points={{-192,-211},{-192,-222},{-128,-222},{-128,-229}},
      color={255,255,0},
      thickness=1.5));
  connect(Ringline1.gasPortIn, pipe_Leversen.gasPortOut) annotation (Line(
      points={{-98,-211},{-98,-222},{-128,-222},{-128,-229}},
      color={255,255,0},
      thickness=1.5));
  connect(Ringline1.gasPortOut, Ringline.gasPortOut) annotation (Line(
      points={{-98,-183},{-98,-168},{-192,-168},{-192,-183}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe_Leversen.gasPortIn, GTSLev) annotation (Line(
      points={{-128,-257},{-128,-276},{-148,-276}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe_Tornesch.gasPortIn, GTSTor) annotation (Line(
      points={{-236,265},{-240,265},{-240,264},{-284,264}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe_Tornesch.gasPortOut, Ringline5.gasPortIn) annotation (Line(
      points={{-208,265},{-200,265},{-200,266},{-190,266},{-96,265}},
      color={255,255,0},
      thickness=1.5));
  annotation (Diagram(coordinateSystem(extent={{-340,-340},{340,340}}, preserveAspectRatio=false,
        initialScale=0.1)),                                              Icon(coordinateSystem(extent={{-340,-340},{340,340}},
        preserveAspectRatio=false,
        initialScale=0.1),                                                                                                      graphics={
        Line(
          points={{178,-110}},
          color={0,0,127},
          pattern=LinePattern.Dash,
          arrow={Arrow.Filled,Arrow.Filled})}),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Open-loop high pressure gas ring grid of Hamburg.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
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
<p>Created by Tom Lindemann (tom.lindemann@tuhh.de), Mar 2016</p>
<p>Edited and revised by Lisa Andresen (andresen@tuhh.de), Jun 2016</p>
</html>"));
end GasGridHamburg;
