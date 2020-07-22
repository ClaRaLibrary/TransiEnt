within TransiEnt.Grid.Gas.StaticCycles.Check;
model TestStatCycMix2

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
  import TransiEnt;
  extends TransiEnt.Basics.Icons.Checkmodel;
  parameter SI.PressureDifference Delta_p_smooth = 200 "For Delta_p<Delta_p_smooth sqrt in PL model is regularized";

  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple pipe1(
    medium=simCenter.gasModel1,
    p_start=linspace(
        Init.pipe1.p_in,
        Init.pipe1.p_out,
        pipe1.N_cv),
    h_start=ones(pipe1.N_cv)*Init.pipe1.h_in,
    m_flow_start=ones(pipe1.N_cv + 1)*Init.pipe1.m_flow,
    length=100,
    diameter_i=0.4,
    p_nom=linspace(
        Nom.pipe1.p_in,
        Nom.pipe1.p_out,
        pipe1.N_cv),
    h_nom=Nom.pipe1.h_in*ones(pipe1.N_cv),
    m_flow_nom=Nom.m_flow_nom_pipe1,
    Delta_p_nom=Nom.Delta_p_nom_pipe1,
    frictionAtInlet=true,
    frictionAtOutlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L4 (Delta_p_smooth=Delta_p_smooth),
    N_cv=20) annotation (Placement(transformation(
        extent={{14,-5},{-14,5}},
        rotation=180,
        origin={-34,0})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple pipe2(
    medium=simCenter.gasModel1,
    N_cv=3,
    h_start=ones(pipe2.N_cv)*Init.pipe2.h_in,
    p_start=linspace(
        Init.pipe2.p_in,
        Init.pipe2.p_out,
        pipe2.N_cv),
    m_flow_start=ones(pipe2.N_cv + 1)*Init.pipe2.m_flow,
    length=200,
    frictionAtInlet=true,
    p_nom=linspace(
        Nom.pipe2.p_in,
        Nom.pipe2.p_out,
        pipe2.N_cv),
    h_nom=Nom.pipe2.h_in*ones(pipe2.N_cv),
    m_flow_nom=Nom.m_flow_nom_pipe2,
    Delta_p_nom=Nom.Delta_p_nom_pipe2,
    diameter_i=0.4,
    frictionAtOutlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L4 (Delta_p_smooth=Delta_p_smooth)) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=270,
        origin={4,-35})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple pipe3(
    medium=simCenter.gasModel1,
    h_start=ones(pipe3.N_cv)*Init.pipe3.h_in,
    p_start=linspace(
        Init.pipe3.p_in,
        Init.pipe3.p_out,
        pipe3.N_cv),
    m_flow_start=ones(pipe3.N_cv + 1)*Init.pipe3.m_flow,
    length=300,
    diameter_i=0.4,
    p_nom=linspace(
        Nom.pipe3.p_in,
        Nom.pipe3.p_out,
        pipe3.N_cv),
    h_nom=Nom.pipe3.h_in*ones(pipe3.N_cv),
    m_flow_nom=Nom.m_flow_nom_pipe3,
    Delta_p_nom=Nom.Delta_p_nom_pipe3,
    frictionAtInlet=true,
    frictionAtOutlet=true,
    N_cv=2,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L4 (Delta_p_smooth=Delta_p_smooth)) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=180,
        origin={36,0})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi source2(
    m(fixed=true),
    p_const=Nom.p_source2,
    h_const=Nom.h_source2,
    xi_const=Nom.xi_source2) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={74,0})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_hxim_flow sink(
    m(fixed=true),
    m_flow_const=Init.m_flow_sink,
    variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={4,-74})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi source1(
    m(fixed=true),
    p_const=Nom.p_source1,
    h_const=Nom.h_source1,
    xi_const=Nom.xi_source1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-72,0})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 vLEFluidJunction_L2_MediumMixingRatio(p(
                                                                                                          start = Init.split.p),volume=0.1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={4,0})));
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1, p_eff_2=1400000) annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  TransiEnt.Grid.Gas.StaticCycles.Check.StatCycMix2 Init(
    Delta_p_nom_pipe1=Nom.Delta_p_nom_pipe1,
    Delta_p_nom_pipe2=Nom.Delta_p_nom_pipe2,
    Delta_p_nom_pipe3=Nom.Delta_p_nom_pipe3,
    m_flow_nom_pipe1=Nom.m_flow_nom_pipe1,
    m_flow_nom_pipe2=Nom.m_flow_nom_pipe2,
    m_flow_nom_pipe3=Nom.m_flow_nom_pipe3,
    quadraticPressureLoss=Nom.quadraticPressureLoss,
    m_flow_sink=6) annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  TransiEnt.Grid.Gas.StaticCycles.Check.StatCycMix2 Nom(
    m_flow_nom_pipe2=10,
    m_flow_sink=10,
    m_flow_nom_pipe1=5,
    m_flow_nom_pipe3=5,
    quadraticPressureLoss=true,
    Delta_p_nom_pipe1=100000,
    Delta_p_nom_pipe2=100000,
    Delta_p_nom_pipe3=100000) annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Modelica.Blocks.Sources.Sine mFlow(
    amplitude=4,
    offset=6,
    freqHz=1/30/60) annotation (Placement(transformation(extent={{-34,-94},{-18,-78}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=10,
    height=4,
    offset=6,
    startTime=600)
              annotation (Placement(transformation(extent={{44,-94},{28,-78}})));
equation
  connect(pipe1.gasPortIn, source1.gasPort) annotation (Line(
      points={{-48,0},{-46,0},{-62,0}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe1.gasPortOut, vLEFluidJunction_L2_MediumMixingRatio.gasPort1) annotation (Line(
      points={{-20,0},{-12,0},{-6,0}},
      color={255,255,0},
      thickness=1.5));
  connect(vLEFluidJunction_L2_MediumMixingRatio.gasPort2, pipe2.gasPortIn) annotation (Line(
      points={{4,-10},{4,-16},{4,-21}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe2.gasPortOut, sink.gasPort) annotation (Line(
      points={{4,-49},{4,-49},{4,-64}},
      color={255,255,0},
      thickness=1.5));
  connect(source2.gasPort, pipe3.gasPortIn) annotation (Line(
      points={{64,0},{50,0}},
      color={255,255,0},
      thickness=1.5));
  connect(vLEFluidJunction_L2_MediumMixingRatio.gasPort3, pipe3.gasPortOut) annotation (Line(
      points={{14,0},{18,0},{22,0}},
      color={255,255,0},
      thickness=1.5));
  connect(mFlow.y, sink.m_flow) annotation (Line(points={{-17.2,-86},{-2,-86},{-2,-86}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-50,96},{98,52}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="#LA, 21.02.2017:
Note that Delta_p_smooth in Quadratic nominal point
pressure loss model has an impact on mass flow distribution 
for small mass flow rates/small pressure drops. Below Delta_p_smooth the sqrt of 
the mass flow calculation is regulized. See
ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L4
for details.")}),
    experiment(StopTime=1800, __Dymola_NumberOfIntervals=1800),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=true,
      OutputFlatModelica=false),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for static cycle mixer 2.</p>
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
<p>Created by Lisa Andresen (andresen@tuhh.de), Jun 2016</p>
</html>"));
end TestStatCycMix2;
