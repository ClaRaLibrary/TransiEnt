within TransiEnt.Grid.Gas.StaticCycles.Check;
model TestStatCyc2Source4Pipes2Sinks


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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
  extends TransiEnt.Basics.Icons.Checkmodel;
  parameter SI.Volume V_junction=0.01 "Volume of split and mix junctions";
  parameter SI.PressureDifference Delta_p_smooth = 200 "For Delta_p<Delta_p_smooth sqrt in PL model is regularized";

  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi source2(
    p_const=Nom.p_source2,
    h_const=Nom.h_source2,
    xi_const=Nom.xi_source2,
    m(fixed=true)) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={108,60})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi source1(
    xi_const=Init.xi_source1,
    p_const=Nom.p_source1,
    h_const=Nom.h_source1,
    m(fixed=true),
    variable_xi=true) annotation (Placement(transformation(extent={{-78,-90},{-58,-70}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_hxim_flow sink2(
    m_flow_const=Init.m_flow_sink2,
    h_const=Init.sink2.h,
    xi_const=Init.sink2.xi,
    m(fixed=true),
    variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,-30})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_hxim_flow sink1(
    m_flow_const=Init.m_flow_sink1,
    h_const=Init.sink1.h,
    xi_const=Init.sink1.xi,
    m(fixed=true),
    variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-2,30})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple pipe1(
    medium=simCenter.gasModel1,
    h_start=ones(pipe1.N_cv)*Init.pipe1.h_in,
    m_flow_start=ones(pipe1.N_cv + 1)*Init.pipe1.m_flow,
    xi_start=Init.pipe1.xi_in,
    diameter_i=0.4,
    p_start=linspace(
        Init.pipe1.p_in,
        Init.pipe1.p_out,
        pipe1.N_cv),
    m_flow_nom=Nom.m_flow_nom_pipe1,
    Delta_p_nom=Nom.Delta_p_nom_pipe1,
    h_nom=ones(pipe1.N_cv)*Nom.pipe1.h_in,
    frictionAtInlet=true,
    frictionAtOutlet=true,
    length=500,
    N_cv=10,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.QuadraticNominalPoint_L4 (Delta_p_smooth=Delta_p_smooth),
    p_nom=Nom.pipe1.p_in*ones(pipe1.N_cv)) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={-36,-23})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple pipe2(
    medium=simCenter.gasModel1,
    length=100,
    h_start=ones(pipe2.N_cv)*Init.pipe2.h_in,
    m_flow_start=ones(pipe2.N_cv + 1)*Init.pipe2.m_flow,
    xi_start=Init.pipe2.xi_in,
    diameter_i=0.4,
    p_start=linspace(
        Init.pipe2.p_in,
        Init.pipe2.p_out,
        pipe2.N_cv),
    p_nom=linspace(
        Nom.pipe2.p_in,
        Nom.pipe2.p_out,
        pipe2.N_cv),
    h_nom=ones(pipe2.N_cv)*Nom.pipe2.h_in,
    m_flow_nom=Nom.m_flow_nom_pipe2,
    Delta_p_nom=Nom.Delta_p_nom_pipe2,
    N_cv=4,
    frictionAtInlet=true,
    frictionAtOutlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.QuadraticNominalPoint_L4 (Delta_p_smooth=Delta_p_smooth)) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=180,
        origin={24,60})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple pipe4(
    medium=simCenter.gasModel1,
    frictionAtInlet=true,
    frictionAtOutlet=true,
    h_start=ones(pipe4.N_cv)*Init.pipe4.h_in,
    m_flow_start=ones(pipe4.N_cv + 1)*Init.pipe4.m_flow,
    xi_start=Init.pipe4.xi_in,
    diameter_i=0.4,
    p_start=linspace(
        Init.pipe4.p_in,
        Init.pipe4.p_out,
        pipe4.N_cv),
    p_nom=linspace(
        Nom.pipe4.p_in,
        Nom.pipe4.p_out,
        pipe4.N_cv),
    h_nom=ones(pipe4.N_cv)*Nom.pipe4.h_in,
    m_flow_nom=Nom.m_flow_nom_pipe4,
    Delta_p_nom=Nom.Delta_p_nom_pipe4,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L4 (Delta_p_smooth=Delta_p_smooth),
    length=500,
    N_cv=10) annotation (Placement(transformation(
        extent={{14,-5},{-14,5}},
        rotation=180,
        origin={48,-80})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple pipe3(
    medium=simCenter.gasModel1,
    frictionAtInlet=true,
    frictionAtOutlet=true,
    h_start=ones(pipe3.N_cv)*Init.pipe3.h_in,
    m_flow_start=ones(pipe3.N_cv + 1)*Init.pipe3.m_flow,
    xi_start=Init.pipe3.xi_in,
    length=100,
    diameter_i=0.4,
    p_start=linspace(
        Init.pipe3.p_in,
        Init.pipe3.p_out,
        pipe3.N_cv),
    p_nom=linspace(
        Nom.pipe3.p_in,
        Nom.pipe3.p_out,
        pipe3.N_cv),
    h_nom=ones(pipe3.N_cv)*Nom.pipe3.h_in,
    m_flow_nom=Nom.m_flow_nom_pipe3,
    Delta_p_nom=Nom.Delta_p_nom_pipe3,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L4 (Delta_p_smooth=Delta_p_smooth),
    N_cv=4) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=270,
        origin={74,13})));
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1, T_ground=282.15)
                                      annotation (Placement(transformation(extent={{-130,100},{-110,120}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2 split1(
    h(start=Init.split1.h_in),
    xi(start=Init.split1.xi_in),
    p(start=Init.split1.p),
    volume=V_junction) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-36,-80})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2 mix2(
    p(start=Init.mix2.p),
    xi(start=Init.mix2.xi_out),
    h(start=Init.mix2.h_out),
    volume=V_junction) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={74,-30})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2 split2(
    xi(start=Init.split2.xi_in),
    h(start=Init.split2.h_in),
    p(start=Init.split2.p),
    volume=V_junction) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={74,60})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2 mix1(
    p(start=Init.mix1.p),
    xi(start=Init.mix1.xi_out),
    h(start=Init.mix1.h_out),
    volume=V_junction) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-36,30})));
  TransiEnt.Grid.Gas.StaticCycles.Check.StatCyc2Sources4Pipes2Sinks Init(
    medium=Nom.medium,
    quadraticPressureLoss=Nom.quadraticPressureLoss,
    p_source1=Nom.p_source1,
    p_source2=Nom.p_source2,
    h_source1=Nom.h_source1,
    h_source2=Nom.h_source2,
    xi_source1=Nom.xi_source1,
    xi_source2=Nom.xi_source2,
    m_flow_nom_pipe1=Nom.m_flow_nom_pipe1,
    m_flow_nom_pipe2=Nom.m_flow_nom_pipe2,
    m_flow_nom_pipe3=Nom.m_flow_nom_pipe3,
    m_flow_nom_pipe4=Nom.m_flow_nom_pipe4,
    Delta_p_nom_pipe1=Nom.Delta_p_nom_pipe1,
    Delta_p_nom_pipe2=Nom.Delta_p_nom_pipe2,
    Delta_p_nom_pipe3=Nom.Delta_p_nom_pipe3,
    Delta_p_nom_pipe4=Nom.Delta_p_nom_pipe4,
    m_flow_sink1=6,
    m_flow_sink2=6) annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  TransiEnt.Components.Boundaries.Gas.RealGasCompositionByWtFractions_stepVariation realGasCompositionByWtFractions_stepVariationXi_1_1(
    stepsize=0.1,
    xiNumber=7,
    period=10*60) annotation (Placement(transformation(extent={{-114,-96},{-94,-76}})));

  TransiEnt.Grid.Gas.StaticCycles.Check.StatCyc2Sources4Pipes2Sinks Nom(
    m_flow_nom_pipe1=10,
    m_flow_nom_pipe2=10,
    m_flow_nom_pipe3=10,
    m_flow_nom_pipe4=10,
    m_flow_sink1=10,
    m_flow_sink2=10,
    Delta_p_nom_pipe1=100000,
    Delta_p_nom_pipe2=100000,
    Delta_p_nom_pipe3=100000,
    Delta_p_nom_pipe4=100000,
    quadraticPressureLoss=true) annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Modelica.Blocks.Sources.Sine mFlow1(
    f=1/30/60,
    amplitude=4,
    offset=6) annotation (Placement(transformation(extent={{38,6},{22,22}})));
  Modelica.Blocks.Sources.Sine mFlow2(
    f=1/30/60,
    amplitude=4,
    offset=6) annotation (Placement(transformation(extent={{2,-32},{18,-16}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=10,
    height=4,
    offset=6,
    startTime=1100)
              annotation (Placement(transformation(extent={{38,32},{24,46}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=10,
    height=4,
    offset=6,
    startTime=1100)
              annotation (Placement(transformation(extent={{2,-54},{16,-40}})));
equation
  connect(split2.gasPort1, source2.gasPort) annotation (Line(
      points={{84,60},{84,60},{98,60}},
      color={255,255,0},
      thickness=0.75));
  connect(split1.gasPort1, source1.gasPort) annotation (Line(
      points={{-46,-80},{-58,-80}},
      color={255,255,0},
      thickness=1.5));
  connect(split1.gasPort2, pipe1.gasPortIn) annotation (Line(
      points={{-36,-70},{-36,-37}},
      color={255,255,0},
      thickness=1.5));
  connect(mix1.gasPort3, pipe2.gasPortOut) annotation (Line(
      points={{-36,40},{-36,60},{10,60}},
      color={255,255,0},
      thickness=1.5));
  connect(mix1.gasPort2, sink1.gasPort) annotation (Line(
      points={{-26,30},{-12,30}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe3.gasPortOut, mix2.gasPort1) annotation (Line(
      points={{74,-1},{74,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(mix2.gasPort2, sink2.gasPort) annotation (Line(
      points={{64,-30},{50,-30}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe2.gasPortIn, split2.gasPort3) annotation (Line(
      points={{38,60},{38,60},{64,60}},
      color={255,255,0},
      thickness=1.5));
  connect(split2.gasPort2, pipe3.gasPortIn) annotation (Line(
      points={{74,50},{74,27}},
      color={255,255,0},
      thickness=1.5));
  connect(mix1.gasPort1, pipe1.gasPortOut) annotation (Line(
      points={{-36,20},{-36,20},{-36,-9}},
      color={255,255,0},
      thickness=1.5));
  connect(split1.gasPort3, pipe4.gasPortIn) annotation (Line(
      points={{-26,-80},{34,-80}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe4.gasPortOut, mix2.gasPort3) annotation (Line(
      points={{62,-80},{70,-80},{74,-80},{74,-40}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp.y, sink1.m_flow) annotation (Line(points={{23.3,39},{16,39},{16,24},{10,24}}, color={0,0,127}));
  connect(realGasCompositionByWtFractions_stepVariationXi_1_1.xi, source1.xi) annotation (Line(points={{-94,-86},{-87,-86},{-80,-86}}, color={0,0,127}));
  connect(ramp1.y, sink2.m_flow) annotation (Line(points={{16.7,-47},{22,-47},{22,-24},{28,-24}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-140,-120},{120,120}}, preserveAspectRatio=false), graphics={Text(
          extent={{-72,108},{44,82}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="#LA, 21.02.2017:
PL model in pipe 1 & 2: quadratic, medium dependent
PL model in pipe 3 & 4: quadratic, medium independent
Note the differnence in
- pipe.summary.outline.m_flow
- pipe.summary.outline.Delta_p
due to the PL models when hydrogen is fed into the grid
at source 1 after 600 s and increased again after 1200 s"), Text(
          extent={{-138,36},{-48,-6}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="#LA, 21.02.2017:
Note that the pressure drop for pipes 1 & 2
and pipes 3 & 4 have to be the same,
since inlet pressures are the same and
outlet pressures have to be the same

The change in density due to H2 feed-in does not
influence pressure drop in pipe 4 (medium independent
PL) but in pipe 1 (dp increases due to lower density).
Since pressure drop has to be the same in pipe 2,
the mass flow rate in pipe 2 is higher because of
the higher density

Medium independent:
dp = dp_nom/m_flow_nom^2 * m_flow^2

Medium dependent:
dp = dp_nom/m_flow_nom^2*rho_nom * m_flow^2/rho")}),                                                Icon(graphics,
                                                                                                         coordinateSystem(extent={{-140,-120},{120,120}})),
    experiment(StopTime=1800, Interval=1),
    __Dymola_experimentSetupOutput(inputs=false, events=false),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester static cycle closed-loop gas grid.</p>
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
end TestStatCyc2Source4Pipes2Sinks;
