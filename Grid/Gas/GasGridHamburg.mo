within TransiEnt.Grid.Gas;
model GasGridHamburg "High pressure gas grid of Hamburg"


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




  import TransiEnt;
  extends TransiEnt.Basics.Icons.HPGasGridHamburg;

  // _____________________________________________
  //
  //             Outer Models
  // _____________________________________________
  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

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
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium in the grid" annotation (Dialog(group="Fundamental Definitions"));

  //Pipe discritization and balance equation
  parameter Real Nper10km=5 "Number of discrete volumes in 10 km pipe length" annotation (Dialog(group="Fundamental Definitions"));
  parameter SI.Volume volume_junction=10 "Volume of each junction" annotation (Dialog(group="Fundamental Definitions"));

  parameter Integer massBalance=1 "Mass balance and species balance fomulation" annotation (Dialog(group="Fundamental Definitions"), choices(
      choice=1 "ClaRa formulation",
      choice=2 "TransiEnt formulation 1a",
      choice=3 "TransiEnt formulation 1b",
      choice=4 "Quasi-Stationary"));
  parameter Boolean constantComposition=simCenter.useConstCompInGasComp "true if composition of gas in the pipe is constant" annotation (Dialog(group="Fundamental Definitions"));
  parameter Integer variableCompositionEntries[:]=simCenter.variableCompositionEntriesGasPipes "Entries of medium vector which are supposed to be completely variable" annotation (Dialog(group="Fundamental Definitions"));

  replaceable model PressureLoss = TransiEnt.Components.Gas.VolumesValvesFittings.Base.PhysicalPL_L4           constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseVLE_L4 "Pressure loss model" annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  parameter SI.Temperature T_ground=simCenter.T_ground "Temperature of the surrounding ground" annotation (Dialog(group="Fundamental Definitions"));

  parameter Integer initOption=simCenter.initOptionGasPipes "Type of initialization" annotation (Dialog(group="Initialization"));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
  Modelica.Units.SI.Velocity[2] w_pipe_Tor={pipe_Tornesch.pipe.summary.outline.w_inlet,pipe_Tornesch.pipe.summary.outline.w_outlet};
  Modelica.Units.SI.Velocity[2] w_pipe_Lev={pipe_Leversen.pipe.summary.outline.w_inlet,pipe_Leversen.pipe.summary.outline.w_outlet};
  Modelica.Units.SI.Velocity[2] w_Ringline={Ringline.pipe.summary.outline.w_inlet,Ringline.pipe.summary.outline.w_outlet};
  Modelica.Units.SI.Velocity[2] w_Ringline1={Ringline1.pipe.summary.outline.w_inlet,Ringline1.pipe.summary.outline.w_outlet};
  Modelica.Units.SI.Velocity[2] w_Ringline2={Ringline2.pipe.summary.outline.w_inlet,Ringline2.pipe.summary.outline.w_outlet};
  Modelica.Units.SI.Velocity[2] w_Ringline3={Ringline3.pipe.summary.outline.w_inlet,Ringline3.pipe.summary.outline.w_outlet};
  Modelica.Units.SI.Velocity[2] w_Ringline4={Ringline4.pipe.summary.outline.w_inlet,Ringline4.pipe.summary.outline.w_outlet};
  Modelica.Units.SI.Velocity[2] w_Ringline5={Ringline5.pipe.summary.outline.w_inlet,Ringline5.pipe.summary.outline.w_outlet};
  Modelica.Units.SI.Velocity[2] w_Ringline6={Ringline6.pipe.summary.outline.w_inlet,Ringline6.pipe.summary.outline.w_outlet};
  Modelica.Units.SI.Velocity[2] w_Ringline7={Ringline7.pipe.summary.outline.w_inlet,Ringline7.pipe.summary.outline.w_outlet};
  Modelica.Units.SI.Velocity[2] w_Ringline8={Ringline8.pipe.summary.outline.w_inlet,Ringline8.pipe.summary.outline.w_outlet};

  // _____________________________________________
  //
  //             Instances of other classes
  // _____________________________________________

  TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple_isoth pipe_Leversen(
    final constantComposition=constantComposition,
    final variableCompositionEntries=variableCompositionEntries,
    final T_ground=T_ground,
    final initOption=initOption,
    showExpertSummary=true,
    medium=medium,
    frictionAtOutlet=true,
    frictionAtInlet=false,
    N_cv=if integer(Nper10km*pipe_Leversen.length/10000) < 1 then 1 else integer(Nper10km*pipe_Leversen.length/10000),
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss,
    xi_nom=medium.xi_default,
    length(displayUnit="m") = ringPipes.length[1],
    diameter_i=ringPipes.diameter[1],
    N_tubes=ringPipes.N_ducts[1]) annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=90,
        origin={-128,-255})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple_isoth pipe_Tornesch(
    final constantComposition=constantComposition,
    final variableCompositionEntries=variableCompositionEntries,
    final T_ground=T_ground,
    final initOption=initOption,
    showExpertSummary=true,
    medium=medium,
    frictionAtOutlet=true,
    frictionAtInlet=false,
    N_cv=if integer(Nper10km*pipe_Tornesch.length/10000) < 1 then 1 else integer(Nper10km*pipe_Tornesch.length/10000),
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss,
    xi_nom=medium.xi_default,
    length(displayUnit="m") = ringPipes.length[12],
    diameter_i=ringPipes.diameter[12],
    N_tubes=ringPipes.N_ducts[12]) annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=0,
        origin={-230,264})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple_isoth Ringline(
    final constantComposition=constantComposition,
    final variableCompositionEntries=variableCompositionEntries,
    final T_ground=T_ground,
    final initOption=initOption,
    showExpertSummary=true,
    medium=medium,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    N_cv=if integer(Nper10km*Ringline.length/10000) < 1 then 1 else integer(Nper10km*Ringline.length/10000),
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss,
    xi_nom=medium.xi_default,
    length(displayUnit="m") = ringPipes.length[2],
    diameter_i=ringPipes.diameter[2],
    N_tubes=ringPipes.N_ducts[2]) annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=90,
        origin={-194,-197})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple_isoth Ringline1(
    final constantComposition=constantComposition,
    final variableCompositionEntries=variableCompositionEntries,
    final T_ground=T_ground,
    final initOption=initOption,
    showExpertSummary=true,
    medium=medium,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    N_cv=if integer(Nper10km*Ringline1.length/10000) < 1 then 1 else integer(Nper10km*Ringline1.length/10000),
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss,
    xi_nom=medium.xi_default,
    length(displayUnit="m") = ringPipes.length[3],
    diameter_i=ringPipes.diameter[3],
    N_tubes=ringPipes.N_ducts[3]) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={-98,-197})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple_isoth Ringline2(
    final constantComposition=constantComposition,
    final variableCompositionEntries=variableCompositionEntries,
    final T_ground=T_ground,
    final initOption=initOption,
    showExpertSummary=true,
    medium=medium,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    N_cv=if integer(Nper10km*Ringline2.length/10000) < 1 then 1 else integer(Nper10km*Ringline2.length/10000),
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss,
    xi_nom=medium.xi_default,
    length(displayUnit="m") = ringPipes.length[4],
    diameter_i=ringPipes.diameter[4],
    N_tubes=ringPipes.N_ducts[4]) annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=90,
        origin={-194,-79})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple_isoth Ringline3(
    final constantComposition=constantComposition,
    final variableCompositionEntries=variableCompositionEntries,
    final T_ground=T_ground,
    final initOption=initOption,
    showExpertSummary=true,
    medium=medium,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    N_cv=if integer(Nper10km*Ringline3.length/10000) < 1 then 1 else integer(Nper10km*Ringline3.length/10000),
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss,
    xi_nom=medium.xi_default,
    length(displayUnit="m") = ringPipes.length[5],
    diameter_i=ringPipes.diameter[5],
    N_tubes=ringPipes.N_ducts[5]) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=270,
        origin={-194,31})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple_isoth Ringline4(
    final constantComposition=constantComposition,
    final variableCompositionEntries=variableCompositionEntries,
    final T_ground=T_ground,
    final initOption=initOption,
    showExpertSummary=true,
    medium=medium,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    N_cv=if integer(Nper10km*Ringline4.length/10000) < 1 then 1 else integer(Nper10km*Ringline4.length/10000),
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss,
    xi_nom=medium.xi_default,
    length(displayUnit="m") = ringPipes.length[6],
    diameter_i=ringPipes.diameter[6],
    N_tubes=ringPipes.N_ducts[6]) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=270,
        origin={-194,149})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple_isoth Ringline5(
    final constantComposition=constantComposition,
    final variableCompositionEntries=variableCompositionEntries,
    final T_ground=T_ground,
    final initOption=initOption,
    showExpertSummary=true,
    medium=medium,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    N_cv=if integer(Nper10km*Ringline5.length/10000) < 1 then 1 else integer(Nper10km*Ringline5.length/10000),
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss,
    xi_nom=medium.xi_default,
    length(displayUnit="m") = ringPipes.length[7],
    diameter_i=ringPipes.diameter[7],
    N_tubes=ringPipes.N_ducts[7]) annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=0,
        origin={-82,264})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple_isoth Ringline6(
    final constantComposition=constantComposition,
    final variableCompositionEntries=variableCompositionEntries,
    final T_ground=T_ground,
    final initOption=initOption,
    showExpertSummary=true,
    medium=medium,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    N_cv=if integer(Nper10km*Ringline6.length/10000) < 1 then 1 else integer(Nper10km*Ringline6.length/10000),
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss,
    xi_nom=medium.xi_default,
    length(displayUnit="m") = ringPipes.length[8],
    diameter_i=ringPipes.diameter[8],
    N_tubes=ringPipes.N_ducts[8]) annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=0,
        origin={100,264})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple_isoth Ringline7(
    final constantComposition=constantComposition,
    final variableCompositionEntries=variableCompositionEntries,
    final T_ground=T_ground,
    final initOption=initOption,
    showExpertSummary=true,
    medium=medium,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    N_cv=if integer(Nper10km*Ringline7.length/10000) < 1 then 1 else integer(Nper10km*Ringline7.length/10000),
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss,
    xi_nom=medium.xi_default,
    length(displayUnit="m") = ringPipes.length[9],
    diameter_i=ringPipes.diameter[9],
    N_tubes=ringPipes.N_ducts[9]) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={162,49})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple_isoth Ringline8(
    final constantComposition=constantComposition,
    final variableCompositionEntries=variableCompositionEntries,
    final T_ground=T_ground,
    final initOption=initOption,
    showExpertSummary=true,
    medium=medium,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    N_cv=if integer(Nper10km*Ringline8.length/10000) < 1 then 1 else integer(Nper10km*Ringline8.length/10000),
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss,
    xi_nom=medium.xi_default,
    length(displayUnit="m") = ringPipes.length[10],
    diameter_i=ringPipes.diameter[10],
    N_tubes=ringPipes.N_ducts[10]) annotation (Placement(transformation(
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
  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2_isoth junction_Leversen(
    medium=medium,
    T_ground=T_ground,
    final volume=volume_junction,
    constantComposition=constantComposition,
    variableCompositionEntries=variableCompositionEntries,
    massBalance=massBalance,
    initOption=initOption) annotation (Placement(transformation(extent={{-138,-232},{-118,-212}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2_nPorts_isoth junction_Ringline1(
    medium=medium,
    T_ground=T_ground,
    n_ports=4,
    volume=volume_junction,
    constantComposition=constantComposition,
    variableCompositionEntries=variableCompositionEntries,
    massBalance=massBalance,
    initOption=initOption) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-194,-168})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2_isoth junction_Ringline2(
    medium=medium,
    T_ground=T_ground,
    final volume=volume_junction,
    constantComposition=constantComposition,
    variableCompositionEntries=variableCompositionEntries,
    massBalance=massBalance,
    initOption=initOption) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-194,-2})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2_isoth junction_Ringline3(
    medium=medium,
    T_ground=T_ground,
    final volume=volume_junction,
    constantComposition=constantComposition,
    variableCompositionEntries=variableCompositionEntries,
    massBalance=massBalance,
    initOption=initOption) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-194,66})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2_isoth junction_Ringline4(
    medium=medium,
    T_ground=T_ground,
    final volume=volume_junction,
    constantComposition=constantComposition,
    variableCompositionEntries=variableCompositionEntries,
    massBalance=massBalance,
    initOption=initOption) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-194,264})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2_isoth junction_Ringline5(
    medium=medium,
    T_ground=T_ground,
    final volume=volume_junction,
    constantComposition=constantComposition,
    variableCompositionEntries=variableCompositionEntries,
    massBalance=massBalance,
    initOption=initOption) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={4,264})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2_isoth junction_Ringline6(
    medium=medium,
    T_ground=T_ground,
    final volume=volume_junction,
    constantComposition=constantComposition,
    variableCompositionEntries=variableCompositionEntries,
    massBalance=massBalance,
    initOption=initOption) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={162,100})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2_isoth junction_Ringline7(
    medium=medium,
    T_ground=T_ground,
    final volume=volume_junction,
    constantComposition=constantComposition,
    variableCompositionEntries=variableCompositionEntries,
    massBalance=massBalance,
    initOption=initOption) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={162,-52})));
equation

  connect(offTakeBergedorf, Ringline8.gasPortIn) annotation (Line(
      points={{140,-158},{162,-158},{162,-109}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe_Leversen.gasPortIn, GTSLev) annotation (Line(
      points={{-128,-269},{-128,-276},{-148,-276}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Leversen.gasPort2, pipe_Leversen.gasPortOut) annotation (Line(
      points={{-128,-232},{-128,-241}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Leversen.gasPort3, Ringline1.gasPortIn) annotation (Line(
      points={{-118,-222},{-98,-222},{-98,-211}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Leversen.gasPort1, Ringline.gasPortIn) annotation (Line(
      points={{-138,-222},{-194,-222},{-194,-211}},
      color={255,255,0},
      thickness=1.5));
  connect(Ringline.gasPortOut, junction_Ringline1.gasPort[1]) annotation (Line(
      points={{-194,-183},{-194,-168},{-193.25,-168}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Ringline1.gasPort[2], Ringline2.gasPortIn) annotation (Line(
      points={{-193.75,-168},{-194,-168},{-194,-93}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Ringline1.gasPort[3], Ringline1.gasPortOut) annotation (Line(
      points={{-194.25,-168},{-98,-168},{-98,-183}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Ringline1.gasPort[4], offTakeHarburg) annotation (Line(
      points={{-194.75,-168},{-124,-168},{-124,-146}},
      color={255,255,0},
      thickness=1.5));
  connect(Ringline3.gasPortOut, junction_Ringline2.gasPort3) annotation (Line(
      points={{-194,17},{-194,8}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Ringline2.gasPort2, offTakeAltona) annotation (Line(
      points={{-184,-2},{-176,-2},{-176,-2},{-160,-2}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Ringline2.gasPort1, Ringline2.gasPortOut) annotation (Line(
      points={{-194,-12},{-194,-65}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Ringline3.gasPort1, Ringline3.gasPortIn) annotation (Line(
      points={{-194,56},{-194,45}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Ringline3.gasPort2, offTakeEimsbuettel) annotation (Line(
      points={{-184,66},{-134,66}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Ringline3.gasPort3, Ringline4.gasPortOut) annotation (Line(
      points={{-194,76},{-194,135}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Ringline4.gasPort3, Ringline5.gasPortIn) annotation (Line(
      points={{-184,264},{-96,264}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Ringline4.gasPort2, Ringline4.gasPortIn) annotation (Line(
      points={{-194,254},{-194,163}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Ringline4.gasPort1, pipe_Tornesch.gasPortOut) annotation (Line(
      points={{-204,264},{-216,264}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe_Tornesch.gasPortIn, GTSTor) annotation (Line(
      points={{-244,264},{-284,264}},
      color={255,255,0},
      thickness=1.5));
  connect(Ringline5.gasPortOut, junction_Ringline5.gasPort1) annotation (Line(
      points={{-68,264},{-6,264}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Ringline5.gasPort2, offTakeNord) annotation (Line(
      points={{4,254},{4,198}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Ringline5.gasPort3, Ringline6.gasPortIn) annotation (Line(
      points={{14,264},{86,264}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Ringline6.gasPort2, offTakeWandsbek) annotation (Line(
      points={{152,100},{132,100},{132,100},{108,100}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Ringline6.gasPort3, Ringline7.gasPortOut) annotation (Line(
      points={{162,90},{162,63},{162,63}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Ringline6.gasPort1, Ringline6.gasPortOut) annotation (Line(
      points={{162,110},{162,264},{114,264}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Ringline7.gasPort3, Ringline8.gasPortOut) annotation (Line(
      points={{162,-62},{162,-81}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Ringline7.gasPort2, offTakeMitte) annotation (Line(
      points={{152,-52},{124,-52},{124,-52},{90,-52}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Ringline7.gasPort1, Ringline7.gasPortIn) annotation (Line(
      points={{162,-42},{162,35}},
      color={255,255,0},
      thickness=1.5));
  annotation (
    Diagram(coordinateSystem(
        extent={{-340,-340},{340,340}},
        preserveAspectRatio=true,
        initialScale=0.1)),
    Icon(coordinateSystem(
        extent={{-340,-340},{340,340}},
        preserveAspectRatio=true,
        initialScale=0.1), graphics={Line(
          points={{178,-110}},
          color={0,0,127},
          pattern=LinePattern.Dash,
          arrow={Arrow.Filled,Arrow.Filled})}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Open-loop high pressure gas ring grid of Hamburg.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>This model is an aggregated version of the gas grid in Hamburg based on data from [1] and [2]. The methodology is described in [3].</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>offTakeHarburg: inlet for real gas</p>
<p>offTakeAltona: inlet for real gas</p>
<p>offTakeEimsbuettel: inlet for real gas</p>
<p>offTakeNord: inlet for real gas</p>
<p>offTakeWandsbek: inlet for real gas</p>
<p>offTakeMitte: inlet for real gas</p>
<p>offTakeBergedorf: inlet for real gas</p>
<p>GTSLev: inlet for real gas</p>
<p>GTSTor: inlet for real gas</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] Gasnetz Hamburg GmbH, Strukturdaten&quot;, 2020, [Online]. Available: https://www.gasnetz-hamburg.de/fuer-unternehmen/netzzugang-nutzung/strukturdaten. [Accessed: 27-May-2020].</p>
<p>[2] Gasnetz Hamburg GmbH, &quot;Netzbezogene Daten&quot;, 2020, [Online]. Available: https://www.gasnetz-hamburg.de/fuer-unternehmen/netzzugang-nutzung/netzbezogene-daten. [Accessed: 27-May-2020].</p>
<p>[3] L. Andresen, P. Dubucq, R. Peniche Garcia, G. Ackermann, A. Kather, and G. Schmitz, &ldquo;Transientes Verhalten gekoppelter Energienetze mit hohem Anteil Erneuerbarer Energien: Abschlussbericht des Verbundvorhabens,&rdquo; Hamburg, 2017.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Tom Lindemann (tom.lindemann@tuhh.de), Mar 2016</p>
<p>Edited and revised by Lisa Andresen (andresen@tuhh.de), Jun 2016</p>
<p>Modified by Carsten Bode (c.bode@tuhh.de), May 2020 (updated to new models and improved numerical behavior)</p>
</html>"));
end GasGridHamburg;
