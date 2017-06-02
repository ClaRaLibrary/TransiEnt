within TransiEnt.Grid.Gas;
model GasGridHamburg "High pressure gas grid of Hamburg"
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
  import TransiEnt;
  extends TransiEnt.Basics.Icons.HPGasGridHamburg;
  outer TransiEnt.SimCenter simCenter;

  outer TransiEnt.Grid.Gas.StatCycleGasGridHamburg Init;

  //Pipe dicritization and balance equation
  parameter Real Nper10km=5 "Number of discrete volumes in 10 km pipe length";
  parameter Boolean productMassBalance=false "|Pipes|Set to true for product component mass balance formulation in pipe (might be more stable but very slow)";
  replaceable model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseVLE_L4 "|Pipes|Pressure loss model" annotation (choicesAllMatching);

  //FeedInControl
  parameter Real phi_H2max=0.1 "Maximal volumetric share of hydrogen in natural gas" annotation(Evaluate=false);

protected
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi pipe_Leversen(
    initType=ClaRa.Basics.Choices.Init.steadyState,
    length(displayUnit="km") = 2000,
    medium=simCenter.gasModel1,
    diameter_i=0.4,
    h_start=ones(pipe_Leversen.N_cv)*Init.pipe_Leversen.h_in,
    p_start=linspace(
        Init.pipe_Leversen.p_in,
        Init.pipe_Leversen.p_out,
        pipe_Leversen.N_cv),
    m_flow_start=ones(pipe_Leversen.N_cv + 1)*Init.pipe_Leversen.m_flow,
    xi_start=Init.pipe_Leversen.xi_in,
    p_nom=ones(pipe_Leversen.N_cv)*Init.pipe_Leversen.p_in,
    h_nom=ones(pipe_Leversen.N_cv)*Init.pipe_Leversen.h_in,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    N_cv=if integer(Nper10km*pipe_Leversen.length/10000) < 2 then 2 else integer(Nper10km*pipe_Leversen.length/10000),
    productMassBalance=productMassBalance,
    m_flow_nom=Init.m_flow_nom_Leversen,
    Delta_p_nom=Init.Delta_p_nom_Leversen,
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=90,
        origin={-128,-243})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi pipe_Tornesch(
    medium=simCenter.gasModel1,
    diameter_i=0.4,
    p_nom=ones(pipe_Tornesch.N_cv)*Init.pipe_Tornesch.p_in,
    h_nom=ones(pipe_Tornesch.N_cv)*Init.pipe_Tornesch.h_in,
    h_start=ones(pipe_Tornesch.N_cv)*Init.pipe_Tornesch.h_in,
    p_start=linspace(
        Init.pipe_Tornesch.p_in,
        Init.pipe_Tornesch.p_out,
        pipe_Tornesch.N_cv),
    m_flow_start=ones(pipe_Tornesch.N_cv + 1)*Init.pipe_Tornesch.m_flow,
    xi_start=Init.pipe_Tornesch.xi_in,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    length(displayUnit="km") = 10000,
    N_cv=if integer(Nper10km*pipe_Tornesch.length/10000) < 2 then 2 else integer(Nper10km*pipe_Tornesch.length/10000),
    productMassBalance=productMassBalance,
    m_flow_nom=Init.m_flow_nom_Tornesch,
    Delta_p_nom=Init.Delta_p_nom_Tornesch,
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=0,
        origin={-222,265})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi Ringline(
    diameter_i=0.4,
    length(displayUnit="km") = 8850,
    medium=simCenter.gasModel1,
    h_start=ones(Ringline.N_cv)*Init.Ringline.h_in,
    p_start=linspace(
        Init.Ringline.p_in,
        Init.Ringline.p_out,
        Ringline.N_cv),
    m_flow_start=ones(Ringline.N_cv + 1)*Init.Ringline.m_flow,
    xi_start=Init.Ringline.xi_in,
    p_nom=ones(Ringline.N_cv)*Init.Ringline.p_in,
    h_nom=ones(Ringline.N_cv)*Init.Ringline.h_in,
    frictionAtOutlet=true,
    m_flow_nom=Init.m_flow_nom_Ringline,
    Delta_p_nom=Init.Delta_p_nom_Ringline,
    frictionAtInlet=true,
    N_cv=if integer(Nper10km*Ringline.length/10000) < 2 then 2 else integer(Nper10km*Ringline.length/10000),
    productMassBalance=productMassBalance,
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=90,
        origin={-192,-197})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi Ringline1(
    diameter_i=0.4,
    length(displayUnit="km") = 9250,
    medium=simCenter.gasModel1,
    h_start=ones(Ringline1.N_cv)*Init.Ringline1.h_in,
    p_start=linspace(
        Init.Ringline1.p_in,
        Init.Ringline1.p_out,
        Ringline1.N_cv),
    m_flow_start=ones(Ringline1.N_cv + 1)*Init.Ringline1.m_flow,
    xi_start=Init.Ringline1.xi_in,
    p_nom=ones(Ringline1.N_cv)*Init.Ringline1.p_in,
    h_nom=ones(Ringline1.N_cv)*Init.Ringline1.h_in,
    m_flow_nom=Init.m_flow_nom_Ringline1,
    Delta_p_nom=Init.Delta_p_nom_Ringline1,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    N_cv=if integer(Nper10km*Ringline1.length/10000) < 2 then 2 else integer(Nper10km*Ringline1.length/10000),
    productMassBalance=productMassBalance,
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={-98,-197})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi Ringline2(
    diameter_i=0.4,
    length(displayUnit="km") = 11400,
    medium=simCenter.gasModel1,
    h_start=ones(Ringline2.N_cv)*Init.Ringline2.h_in,
    p_start=linspace(
        Init.Ringline2.p_in,
        Init.Ringline2.p_out,
        Ringline2.N_cv),
    m_flow_start=ones(Ringline2.N_cv + 1)*Init.Ringline2.m_flow,
    xi_start=Init.Ringline2.xi_in,
    p_nom=ones(Ringline2.N_cv)*Init.Ringline2.p_in,
    h_nom=ones(Ringline2.N_cv)*Init.Ringline2.h_in,
    m_flow_nom=Init.m_flow_nom_Ringline2,
    Delta_p_nom=Init.Delta_p_nom_Ringline2,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    N_cv=if integer(Nper10km*Ringline2.length/10000) < 2 then 2 else integer(Nper10km*Ringline2.length/10000),
    productMassBalance=productMassBalance,
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=90,
        origin={-194,-79})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi Ringline3(
    diameter_i=0.4,
    length(displayUnit="km") = 5700,
    medium=simCenter.gasModel1,
    h_start=ones(Ringline3.N_cv)*Init.Ringline3.h_in,
    p_start=linspace(
        Init.Ringline3.p_in,
        Init.Ringline3.p_out,
        Ringline3.N_cv),
    m_flow_start=ones(Ringline3.N_cv + 1)*Init.Ringline3.m_flow,
    xi_start=Init.Ringline3.xi_in,
    p_nom=ones(Ringline3.N_cv)*Init.Ringline3.p_in,
    h_nom=ones(Ringline3.N_cv)*Init.Ringline3.h_in,
    frictionAtOutlet=true,
    m_flow_nom=Init.m_flow_nom_Ringline3,
    Delta_p_nom=Init.Delta_p_nom_Ringline3,
    frictionAtInlet=true,
    N_cv=if integer(Nper10km*Ringline3.length/10000) < 2 then 2 else integer(Nper10km*Ringline3.length/10000),
    productMassBalance=productMassBalance,
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=270,
        origin={-192,31})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi Ringline4(
    diameter_i=0.4,
    length(displayUnit="km") = 9200,
    medium=simCenter.gasModel1,
    h_start=ones(Ringline4.N_cv)*Init.Ringline4.h_in,
    p_start=linspace(
        Init.Ringline4.p_in,
        Init.Ringline4.p_out,
        Ringline4.N_cv),
    m_flow_start=ones(Ringline4.N_cv + 1)*Init.Ringline4.m_flow,
    xi_start=Init.Ringline4.xi_in,
    p_nom=ones(Ringline4.N_cv)*Init.Ringline4.p_in,
    h_nom=ones(Ringline4.N_cv)*Init.Ringline4.h_in,
    m_flow_nom=Init.m_flow_nom_Ringline4,
    Delta_p_nom=Init.Delta_p_nom_Ringline4,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    N_cv=if integer(Nper10km*Ringline4.length/10000) < 2 then 2 else integer(Nper10km*Ringline4.length/10000),
    productMassBalance=productMassBalance,
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=270,
        origin={-192,149})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi Ringline5(
    diameter_i=0.4,
    length(displayUnit="km") = 4600,
    medium=simCenter.gasModel1,
    h_start=ones(Ringline5.N_cv)*Init.Ringline5.h_in,
    p_start=linspace(
        Init.Ringline5.p_in,
        Init.Ringline5.p_out,
        Ringline5.N_cv),
    m_flow_start=ones(Ringline5.N_cv + 1)*Init.Ringline5.m_flow,
    xi_start=Init.Ringline5.xi_in,
    p_nom=ones(Ringline5.N_cv)*Init.Ringline5.p_in,
    h_nom=ones(Ringline5.N_cv)*Init.Ringline5.h_in,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    N_cv=if integer(Nper10km*Ringline5.length/10000) < 2 then 2 else integer(Nper10km*Ringline5.length/10000),
    productMassBalance=productMassBalance,
    m_flow_nom=Init.m_flow_nom_Ringline5,
    Delta_p_nom=Init.Delta_p_nom_Ringline5,
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=0,
        origin={-82,265})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi Ringline6(
    diameter_i=0.4,
    length(displayUnit="km") = 11600,
    medium=simCenter.gasModel1,
    h_start=ones(Ringline6.N_cv)*Init.Ringline6.h_in,
    p_start=linspace(
        Init.Ringline6.p_in,
        Init.Ringline6.p_out,
        Ringline6.N_cv),
    m_flow_start=ones(Ringline6.N_cv + 1)*Init.Ringline6.m_flow,
    xi_start=Init.Ringline6.xi_in,
    p_nom=ones(Ringline6.N_cv)*Init.Ringline6.p_in,
    h_nom=ones(Ringline6.N_cv)*Init.Ringline6.h_in,
    m_flow_nom=Init.m_flow_nom_Ringline6,
    Delta_p_nom=Init.Delta_p_nom_Ringline6,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    N_cv=if integer(Nper10km*Ringline6.length/10000) < 2 then 2 else integer(Nper10km*Ringline6.length/10000),
    productMassBalance=productMassBalance,
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=0,
        origin={100,265})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi Ringline7(
    diameter_i=0.4,
    length(displayUnit="km") = 10850,
    medium=simCenter.gasModel1,
    h_start=ones(Ringline7.N_cv)*Init.Ringline7.h_in,
    p_start=linspace(
        Init.Ringline7.p_in,
        Init.Ringline7.p_out,
        Ringline7.N_cv),
    m_flow_start=ones(Ringline7.N_cv + 1)*Init.Ringline7.m_flow,
    xi_start=Init.Ringline7.xi_in,
    p_nom=ones(Ringline7.N_cv)*Init.Ringline7.p_in,
    h_nom=ones(Ringline7.N_cv)*Init.Ringline7.h_in,
    frictionAtOutlet=true,
    m_flow_nom=Init.m_flow_nom_Ringline7,
    Delta_p_nom=Init.Delta_p_nom_Ringline7,
    frictionAtInlet=true,
    N_cv=if integer(Nper10km*Ringline7.length/10000) < 2 then 2 else integer(Nper10km*Ringline7.length/10000),
    productMassBalance=productMassBalance,
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={162,49})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi Ringline8(
    diameter_i=0.4,
    length(displayUnit="km") = 6000,
    medium=simCenter.gasModel1,
    h_start=ones(Ringline8.N_cv)*Init.Ringline8.h_in,
    p_start=linspace(
        Init.Ringline8.p_in,
        Init.Ringline8.p_out,
        Ringline8.N_cv),
    m_flow_start=ones(Ringline8.N_cv + 1)*Init.Ringline8.m_flow,
    xi_start=Init.Ringline8.xi_in,
    p_nom=ones(Ringline8.N_cv)*Init.Ringline8.p_in,
    h_nom=ones(Ringline8.N_cv)*Init.Ringline8.h_in,
    m_flow_nom=Init.m_flow_nom_Ringline8,
    Delta_p_nom=Init.Delta_p_nom_Ringline8,
    frictionAtOutlet=true,
    frictionAtInlet=true,
    N_cv=if integer(Nper10km*Ringline8.length/10000) < 2 then 2 else integer(Nper10km*Ringline8.length/10000),
    productMassBalance=productMassBalance,
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={162,-95})));

public
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn offTakeHarburg(Medium=simCenter.gasModel1) annotation (Placement(transformation(extent={{-134,-156},{-114,-136}}), iconTransformation(extent={{-130,-146},{-118,-134}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn offTakeAltona(Medium=simCenter.gasModel1) annotation (Placement(transformation(extent={{-176,-16},{-156,4}}), iconTransformation(extent={{-172,-8},{-160,4}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn offTakeEimsbuettel(Medium=simCenter.gasModel1) annotation (Placement(transformation(extent={{-144,56},{-124,76}}), iconTransformation(extent={{-138,62},{-126,74}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn offTakeNord(Medium=simCenter.gasModel1) annotation (Placement(transformation(extent={{-6,188},{14,208}}), iconTransformation(extent={{-6,192},{6,204}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn offTakeWandsbek(Medium=simCenter.gasModel1) annotation (Placement(transformation(extent={{96,86},{116,106}}), iconTransformation(extent={{96,92},{108,104}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn offTakeMitte(Medium=simCenter.gasModel1) annotation (Placement(transformation(extent={{80,-62},{100,-42}}), iconTransformation(extent={{80,-54},{92,-42}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn offTakeBergedorf(Medium=simCenter.gasModel1) annotation (Placement(transformation(extent={{130,-168},{150,-148}}), iconTransformation(extent={{132,-158},{144,-146}})));

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn GTSLev(Medium=simCenter.gasModel1) annotation (Placement(transformation(extent={{-144,-276},{-124,-256}}), iconTransformation(extent={{-144,-276},{-124,-256}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn GTSTor(Medium=simCenter.gasModel1) annotation (Placement(transformation(extent={{-268,254},{-248,274}}), iconTransformation(extent={{-268,254},{-248,274}})));
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
      points={{-166,-6},{-192,-6},{-192,2},{-192,-6},{-166,-6}},
      color={255,255,0},
      thickness=1.5));
  connect(offTakeAltona, Ringline3.gasPortOut) annotation (Line(
      points={{-166,-6},{-192,-6},{-192,17}},
      color={255,255,0},
      thickness=1.5));
  connect(offTakeNord, Ringline6.gasPortIn) annotation (Line(
      points={{4,198},{4,265},{86,265}},
      color={255,255,0},
      thickness=1.5));
  connect(offTakeWandsbek, Ringline7.gasPortOut) annotation (Line(
      points={{106,96},{162,96},{162,63}},
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
      points={{-128,-257},{-128,-266},{-134,-266}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe_Tornesch.gasPortIn, GTSTor) annotation (Line(
      points={{-236,265},{-240,265},{-240,264},{-258,264}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe_Tornesch.gasPortOut, Ringline5.gasPortIn) annotation (Line(
      points={{-208,265},{-200,265},{-200,266},{-190,266},{-96,265}},
      color={255,255,0},
      thickness=1.5));
  annotation (Diagram(coordinateSystem(extent={{-440,-340},{440,340}}, preserveAspectRatio=false,
        initialScale=0.1)),                                              Icon(coordinateSystem(extent={{-440,-340},{440,340}},
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
