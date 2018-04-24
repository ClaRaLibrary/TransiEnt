within TransiEnt.Grid.Gas.StaticCycles.Check;
model TestStatCycMix

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
  extends TransiEnt.Basics.Icons.Checkmodel;

  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi pipe1(
    medium=simCenter.gasModel1,
    Delta_p_nom=Init.Delta_p_nom_pipe1,
    frictionAtInlet=true,
    frictionAtOutlet=true,
    m_flow_nom=Init.m_flow_nom_pipe1,
    p_start=linspace(
        Init.pipe1.p_in,
        Init.pipe1.p_out,
        pipe1.N_cv),
    h_start=ones(pipe1.N_cv)*Init.pipe1.h_in,
    length=100,
    diameter_i=0.4,
    N_cv=2,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L4,
    massBalance=1)                                                                                                            annotation (Placement(transformation(
        extent={{14,-5},{-14,5}},
        rotation=180,
        origin={-12,86})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi pipe2(
    medium=simCenter.gasModel1,
    frictionAtInlet=true,
    frictionAtOutlet=true,
    length=300,
    diameter_i=0.4,
    m_flow_nom=Init.m_flow_nom_pipe2,
    Delta_p_nom=Init.Delta_p_nom_pipe2,
    h_start=ones(pipe2.N_cv)*Init.pipe2.h_in,
    p_start=linspace(
        Init.pipe2.p_in,
        Init.pipe2.p_out,
        pipe2.N_cv),
    N_cv=6,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L4,
    massBalance=1)                                                                                                            annotation (Placement(transformation(
        extent={{14,-5},{-14,5}},
        rotation=180,
        origin={52,86})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_hxim_flow sink(m_flow_const=Init.m_flow_sink) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={84,86})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi source(
    p_const=Init.p_source,
    xi_const=Init.xi_source,
    T_const=Init.T_source) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-44,86})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 vLEFluidJunction_L2_MediumMixingRatio(
    p_start=Init.mix.p,
    xi_start=Init.mix.xi_out,
    h_start=Init.mix.h_out,
    volume=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={20,86})));
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1, redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2 gasModel3)
                                                                                                                              annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  TransiEnt.Grid.Gas.StaticCycles.Check.StatCycMix Init(
    m_flow_H2=1,
    m_flow_nom_pipe2=10,
    m_flow_nom_pipe1=30,
    m_flow_sink=15,
    quadraticPressureLoss=true) annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source_H2(
    m_flow_const=-Init.m_flow_H2,
    medium=simCenter.gasModel3,
    T_const=Init.T_H2,
    xi_const=Init.source_H2.xi,
    variable_m_flow=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={20,20})));
  TransiEnt.Basics.Adapters.Gas.RealH2_to_RealNG realH2_to_RealNG annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,64})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi pipe3(
    medium=simCenter.gasModel1,
    Delta_p_nom=Init.Delta_p_nom_pipe1,
    frictionAtInlet=true,
    frictionAtOutlet=true,
    m_flow_nom=Init.m_flow_nom_pipe1,
    length=100,
    diameter_i=0.4,
    h_start=ones(pipe3.N_cv)*Init.pipe1.h_in,
    p_start=linspace(
        Init.pipe1.p_in,
        Init.pipe1.p_out,
        pipe3.N_cv),
    N_cv=2,
    massBalance=3,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L4) annotation (Placement(transformation(
        extent={{14,-5},{-14,5}},
        rotation=180,
        origin={-12,-8})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi pipe4(
    medium=simCenter.gasModel1,
    frictionAtInlet=true,
    frictionAtOutlet=true,
    length=300,
    diameter_i=0.4,
    m_flow_nom=Init.m_flow_nom_pipe2,
    Delta_p_nom=Init.Delta_p_nom_pipe2,
    h_start=ones(pipe4.N_cv)*Init.pipe2.h_in,
    p_start=linspace(
        Init.pipe2.p_in,
        Init.pipe2.p_out,
        pipe4.N_cv),
    N_cv=6,
    massBalance=3,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L4) annotation (Placement(transformation(
        extent={{14,-5},{-14,5}},
        rotation=180,
        origin={50,-8})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_hxim_flow sink1(m_flow_const=Init.m_flow_sink) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={86,-8})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi source1(
    p_const=Init.p_source,
    xi_const=Init.xi_source,
    T_const=Init.T_source) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-44,-8})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 vLEFluidJunction_L2_MediumMixingRatio1(
    p_start=Init.mix.p,
    xi_start=Init.mix.xi_out,
    h_start=Init.mix.h_out,
    volume=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={20,-8})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_hxim_flow source_H2_1(
    m_flow_const=-Init.m_flow_H2,
    medium=simCenter.gasModel3,
    xi_const=Init.source_H2.xi,
    h_const=Init.source_H2.h,
    variable_m_flow=true) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={20,-80})));
  TransiEnt.Basics.Adapters.Gas.RealH2_to_RealNG realH2_to_RealNG1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-34})));
  Modelica.Blocks.Sources.Step step(
    startTime=400,
    height=-1.25,
    offset=-0.25)
               annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_constXi pipeH2_1(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    h_start=ones(pipeH2_1.N_cv)*Init.pipeH2.h_in,
    medium=simCenter.gasModel3,
    p_start=linspace(
        Init.pipeH2.p_in,
        Init.pipeH2.p_out,
        pipeH2_1.N_cv),
    length=10,
    N_cv=2,
    m_flow_nom=Init.m_flow_nom_pipeH2,
    Delta_p_nom=Init.Delta_p_nom_pipeH2,
    xi_nom=zeros(pipeH2_1.medium.nc - 1),
    p_nom=ones(pipeH2_1.N_cv)*Init.pipeH2.p_in,
    h_nom=ones(pipeH2_1.N_cv)*Init.pipeH2.h_in,
    diameter_i=0.6) annotation (Placement(transformation(
        extent={{8,-4},{-8,4}},
        rotation=270,
        origin={20,-56})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_constXi pipeH2(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    medium=simCenter.gasModel3,
    diameter_i=0.3,
    length=10,
    N_cv=2,
    m_flow_nom=Init.m_flow_nom_pipeH2,
    Delta_p_nom=Init.Delta_p_nom_pipeH2,
    p_nom=ones(pipeH2.N_cv)*Init.pipeH2.p_in,
    h_nom=ones(pipeH2.N_cv)*Init.pipeH2.h_in,
    xi_nom=zeros(pipeH2.medium.nc - 1),
    h_start=ones(pipeH2.N_cv)*Init.pipeH2.h_in,
    p_start=linspace(
        Init.pipeH2.p_in,
        Init.pipeH2.p_out,
        pipeH2.N_cv)) annotation (Placement(transformation(
        extent={{8,-4},{-8,4}},
        rotation=270,
        origin={20,42})));
equation
  connect(pipe1.gasPortIn, source.gasPort) annotation (Line(
      points={{-26,86},{-34,86}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe2.gasPortOut, sink.gasPort) annotation (Line(
      points={{66,86},{66,84},{66,86},{74,86}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe1.gasPortOut, vLEFluidJunction_L2_MediumMixingRatio.gasPort1) annotation (Line(
      points={{2,86},{2,86},{10,86}},
      color={255,255,0},
      thickness=1.5));
  connect(vLEFluidJunction_L2_MediumMixingRatio.gasPort3, pipe2.gasPortIn) annotation (Line(
      points={{30,86},{30,86},{38,86}},
      color={255,255,0},
      thickness=1.5));
  connect(vLEFluidJunction_L2_MediumMixingRatio.gasPort2, realH2_to_RealNG.gasPortOut) annotation (Line(
      points={{20,76},{20,72},{20,74}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe3.gasPortIn, source1.gasPort) annotation (Line(
      points={{-26,-8},{-26,-8},{-34,-8}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe4.gasPortOut, sink1.gasPort) annotation (Line(
      points={{64,-8},{64,-8},{76,-8}},
      color={255,255,0},
      thickness=1.5));
  connect(vLEFluidJunction_L2_MediumMixingRatio1.gasPort2, realH2_to_RealNG1.gasPortOut) annotation (Line(
      points={{20,-18},{20,-24}},
      color={255,255,0},
      thickness=1.5));
  connect(step.y, source_H2.m_flow) annotation (Line(points={{-79,10},{-30,10},{-30,4},{26,4},{26,8}}, color={0,0,127}));
  connect(step.y, source_H2_1.m_flow) annotation (Line(points={{-79,10},{-76,10},{-76,-96},{26,-96},{26,-92}}, color={0,0,127}));
  connect(pipeH2_1.gasPortOut, realH2_to_RealNG1.gasPortIn) annotation (Line(
      points={{20,-48},{20,-46},{20,-44}},
      color={255,255,0},
      thickness=1.5));
  connect(source_H2_1.gasPort, pipeH2_1.gasPortIn) annotation (Line(
      points={{20,-70},{20,-67},{20,-64}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe3.gasPortOut, vLEFluidJunction_L2_MediumMixingRatio1.gasPort3) annotation (Line(
      points={{2,-8},{6,-8},{10,-8}},
      color={255,255,0},
      thickness=1.5));
  connect(vLEFluidJunction_L2_MediumMixingRatio1.gasPort1, pipe4.gasPortIn) annotation (Line(
      points={{30,-8},{36,-8}},
      color={255,255,0},
      thickness=1.5));
  connect(realH2_to_RealNG.gasPortIn, pipeH2.gasPortOut) annotation (Line(
      points={{20,54},{20,54},{20,50}},
      color={255,255,0},
      thickness=1.5));
  connect(source_H2.gasPort, pipeH2.gasPortIn) annotation (Line(
      points={{20,30},{20,30},{20,34}},
      color={255,255,0},
      thickness=1.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{34,28},{78,16}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="source with temperature shows a lot of small
fluctuations in the enthalpy
-> is it more robust to use the enthalpy boundary?")}),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for static cycle mixer.</p>
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
<p>Edited by Lisa Andresen (andresen@tuhh.de), Jun 2016</p>
</html>"));
end TestStatCycMix;
