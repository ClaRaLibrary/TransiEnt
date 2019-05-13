within TransiEnt.Examples.Gas;
model GasGrid_StandAlone "Very simple gas grid featuring the main components"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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
  extends TransiEnt.Basics.Icons.Example;

  // _____________________________________________
  //
  //                  Parameters
  // _____________________________________________

  // feedInStation
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid mediumH2=simCenter.gasModel3 "|General|Hydrogen model to be used";
  parameter Modelica.SIunits.ActivePower P_el_n=3e6 "|Electrolyzer|Nominal power of electrolyzer" annotation (Evaluate=false);
  parameter Modelica.SIunits.ActivePower P_el_max=1.68*P_el_n "|Electrolyzer|Maximum power of electrolyzer" annotation (Evaluate=false);
  parameter Modelica.SIunits.ActivePower P_el_min=0.05*P_el_n "|Electrolyzer|Minimal power of ely, when only 1 stack is working at 2%(?)";
  parameter Modelica.SIunits.ActivePower P_el_overload=1.0*P_el_n "|Electrolyzer|Power at which overload region begins";
  parameter Modelica.SIunits.MassFlowRate m_flow_start=0.0 "|Initialization|Sets initial value for m_flow (value needed for init with StatCycle)";
  parameter Modelica.SIunits.Temperature T_Init=283.15 "|Initialization|Sets initial value for T";
  parameter Modelica.SIunits.Efficiency eta_n(
    min=0,
    max=1)=0.75 "|Electrolyzer|Nominal efficency coefficient (min = 0, max = 1)";
  parameter Modelica.SIunits.Efficiency eta_scale(
    min=0,
    max=1)=0 "|Electrolyzer|Sets a with increasing input power linear degrading efficiency coefficient (min = 0, max = 1)";
  parameter Modelica.SIunits.AbsolutePressure p_out=35e5 "|Electrolyzer|Hydrogen output pressure from electrolyzer";
  parameter Modelica.SIunits.Temperature T_out=283.15 "|Electrolyzer|Hydrogen output temperature from electrolyzer";
  parameter Real t_overload=1.0*3600 "|Electrolyzer|Maximum time the ely can work in overload in seconds";
  parameter Real coolingToHeatingRatio=1 "|Electrolyzer|Defines how much faster electrolyzer cools down than heats up";
  parameter Integer startState=1 "|Electrolyzer|Initial state of the electrolyzer (1: ready to overheat, 2: working in overload, 3: cooling down)";

  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PI "|Controller|Type of controller for feed-in control";
  parameter Real k=1e8 "|Controller|Gain for feed-in control";
  parameter Real Ti=1 "|Controller|Integrator time constant for feed-in control";
  parameter Real Td=0.4 "|Controller|Derivative time constant for feed-in control";

  parameter Real f_1=0.5;
  parameter Real f_2=0.5;
  parameter Real phi_H2max=0.1;

  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 junction1(
    initOption=0,
    xi(
    start =  init.junction1.xi_in),
    h(
    start = init.junction1.h_in),
    volume=1,
    p(
    start = init.junction1.p))
                              annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-24,-156})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi pipe1(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    initOption=0,
    N_cv=5,
    length=500,
    Delta_p_nom=0.5e4,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L4,
    h_start=ones(pipe1.N_cv)*init.pipe1.h_in,
    p_start=linspace(
        init.pipe1.p_in,
        init.pipe1.p_out,
        pipe1.N_cv),
    m_flow_start=ones(pipe1.N_cv + 1)*init.pipe1.m_flow,
    xi_start=init.pipe1.xi_in) annotation (Placement(transformation(
        extent={{-20,-10},{20,10}},
        rotation=90,
        origin={-22,-114})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi source1(m_flow_nom=0) annotation (Placement(transformation(extent={{-164,-176},{-124,-136}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi source2(m_flow_nom=0) annotation (Placement(transformation(extent={{236,-16},{196,24}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sink2(p_nom=0, m_flow_const=1) annotation (Placement(transformation(extent={{170,-114},{150,-94}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sink1(
    p_nom=0,
    m_flow_const=1,
    variable_m_flow=true) annotation (Placement(transformation(extent={{14,-56},{-6,-36}})));
  inner InitGasGrid_PtG init(
    source1_T=source1.T_const,
    source1_xi=source2.xi_const,
    source2_T=source1.T_const,
    source2_xi=source2.xi_const,
    pipe1_Delta_p_nom=pipe1.Delta_p_nom,
    pipe2_Delta_p_nom=pipe2.Delta_p_nom,
    pipe3_Delta_p_nom=pipe3.Delta_p_nom,
    pipe4_Delta_p_nom=pipe4.Delta_p_nom,
    pipe1_m_flow_nom=pipe1.m_flow_nom,
    pipe2_m_flow_nom=pipe2.m_flow_nom,
    pipe3_m_flow_nom=pipe3.m_flow_nom,
    pipe4_m_flow_nom=pipe4.m_flow_nom,
    mediumH2=mediumH2,
    feedIn1_xi=zeros(mediumH2.nc - 1),
    feedin2_xi=zeros(mediumH2.nc - 1),
    sink2_m_flow=sink2.m_flow_const,
    feedIn1_m_flow=m_flow_start,
    feedIn2_m_flow=m_flow_start,
    sink1_m_flow=0.711772,
  quadraticPressureLoss=true)
                      annotation (Placement(transformation(extent={{-260,120},{-220,162}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi pipe2(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    initOption=0,
    h_start=ones(pipe2.N_cv)*init.pipe2.h_in,
    p_start=linspace(
        init.pipe2.p_in,
        init.pipe2.p_out,
        pipe2.N_cv),
    m_flow_start=ones(pipe2.N_cv + 1)*init.pipe2.m_flow,
    xi_start=init.pipe2.xi_in,
    length=1000,
    N_cv=5,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L4) annotation (Placement(transformation(
        extent={{-20,-10},{20,10}},
        rotation=180,
        origin={36,4})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi pipe3(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    initOption=0,
    h_start=ones(pipe3.N_cv)*init.pipe3.h_in,
    p_start=linspace(
        init.pipe3.p_in,
        init.pipe3.p_out,
        pipe3.N_cv),
    m_flow_start=ones(pipe3.N_cv + 1)*init.pipe3.m_flow,
    xi_start=init.pipe3.xi_in,
    length=1000,
    N_cv=5,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L4) annotation (Placement(transformation(
        extent={{-20,-10},{20,10}},
        rotation=270,
        origin={96,-36})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi pipe4(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    initOption=0,
    h_start=ones(pipe4.N_cv)*init.pipe4.h_in,
    p_start=linspace(
        init.pipe4.p_in,
        init.pipe4.p_out,
        pipe4.N_cv),
    m_flow_start=ones(pipe4.N_cv + 1)*init.pipe4.m_flow,
    xi_start=init.pipe4.xi_in,
    length=1000,
    N_cv=5,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L4) annotation (Placement(transformation(
        extent={{-20,-10},{20,10}},
        rotation=0,
        origin={36,-156})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 junction2(
    initOption=0,
    p(
    start = init.junction2.p),
    xi(
    start =  init.junction2.xi_out),
    h(
    start = init.junction2.h_out),
    volume=1) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-24,-46})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 junction3(
    initOption=0,
    xi(
    start =  init.junction3.xi_in),
    h(
    start = init.junction3.h_in),
    volume=1,
    p(
    start = init.junction3.p))
                              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={96,4})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 junction4(
    initOption=0,
    p(
    start = init.junction4.p),
    xi(
    start =  init.junction4.xi_out),
    h(
    start = init.junction4.h_out),
    volume=1) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={96,-106})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow1(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-102,-156})));
  Modelica.Blocks.Math.Gain gainFeedIn1(k=f_1) annotation (Placement(transformation(
        extent={{10,-9.5},{-10,9.5}},
        rotation=180,
        origin={-86,-15.5})));
public
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 junction_feedIn1(
    initOption=0,
    xi(
    start =  init.junction1.xi_in),
    h(
    start = init.junction1.h_in),
    volume=0.1,
    p(
    start = init.junction1.p))
                              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-74,-156})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_1(compositionDefinedBy=2) annotation (Placement(transformation(extent={{-58,-156},{-40,-138}})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow2(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={180,4})));
public
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 junction_feedIn2(
    initOption=0,
    xi(
    start =  init.junction1.xi_in),
    h(
    start = init.junction1.h_in),
    volume=0.1,
    p(
    start = init.junction1.p))
                              annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={152,4})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_2(compositionDefinedBy=2) annotation (Placement(transformation(extent={{116,4},{136,24}})));
protected
  Modelica.Blocks.Math.Gain gainFeedIn2(k=f_2) annotation (Placement(transformation(extent={{96,94},{116,114}})));
public
  Modelica.Blocks.Routing.Replicator replicator(nout=2) annotation (Placement(transformation(extent={{-162,-24},{-142,-4}})));
  inner TransiEnt.SimCenter simCenter(
    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1,
    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2 gasModel3,
    useHomotopy=false,
    T_ground=282.15,
    tableInterpolationSmoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2)                              annotation (Placement(transformation(extent={{-240,160},{-200,200}})));
public
  TransiEnt.Components.Boundaries.Electrical.Frequency ElectricGrid annotation (Placement(transformation(
        extent={{-20,-21},{20,21}},
        rotation=180,
        origin={-232,63})));
  TransiEnt.Basics.Tables.ElectricGrid.ResidualLoadExample residualLoad(negResidualLoad=true) annotation (Placement(transformation(extent={{-252,-34},{-212,6}})));
  TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_woStorage feedInStation1(
    m_flow_start=m_flow_start,
    eta_n=eta_n,
    p_out=p_out,
    T_out=T_out,
    t_overload=t_overload,
    coolingToHeatingRatio=coolingToHeatingRatio,
    startState=startState,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    controllerType=controllerType,
    k=k,
    Ti=Ti,
    Td=Td,
    P_el_n=P_el_n*f_1,
    P_el_max=P_el_max*f_1,
    P_el_min=P_el_min*f_1,
    P_el_overload=P_el_overload*f_1) annotation (Placement(transformation(extent={{-58,-112},{-92,-80}})));
  TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_woStorage feedInStation2(
    m_flow_start=m_flow_start,
    eta_n=eta_n,
    p_out=p_out,
    T_out=T_out,
    t_overload=t_overload,
    coolingToHeatingRatio=coolingToHeatingRatio,
    startState=startState,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder,
    controllerType=controllerType,
    k=k,
    Ti=Ti,
    Td=Td,
    P_el_n=P_el_n*f_2,
    P_el_max=P_el_max*f_2,
    P_el_min=P_el_min*f_2,
    P_el_overload=P_el_overload*f_2) annotation (Placement(transformation(extent={{136,48},{170,80}})));
  Consumer.Gas.GasDemandProfiler gasDemandProfiler(
    mFlowOut=true,
    f_gasDemand=1/45,
    gasDemand_base_a=0) annotation (Placement(transformation(extent={{46,-50},{26,-30}})));
  Modelica.Blocks.Sources.RealExpression T_amb(y=simCenter.T_amb_var) annotation (Placement(transformation(
        extent={{11,-9},{-11,9}},
        rotation=0,
        origin={61,-40})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-220,120},{-180,160}})));
equation
  connect(junction2.gasPort1, pipe2.gasPortOut) annotation (Line(
      points={{-24,-36},{-24,4},{16,4}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe2.gasPortIn, junction3.gasPort1) annotation (Line(
      points={{56,4},{72,4},{86,4}},
      color={255,255,0},
      thickness=1.5));
  connect(junction3.gasPort2, pipe3.gasPortIn) annotation (Line(
      points={{96,-6},{96,-16}},
      color={255,255,0},
      thickness=1.5));
  connect(junction4.gasPort1, pipe3.gasPortOut) annotation (Line(
      points={{96,-96},{96,-56}},
      color={255,255,0},
      thickness=1.5));
  connect(sink2.gasPort, junction4.gasPort2) annotation (Line(
      points={{150,-104},{150,-106},{106,-106}},
      color={255,255,0},
      thickness=1.5));
  connect(junction2.gasPort2, sink1.gasPort) annotation (Line(
      points={{-14,-46},{-6,-46}},
      color={255,255,0},
      thickness=1.5));
  connect(junction1.gasPort3, pipe4.gasPortIn) annotation (Line(
      points={{-14,-156},{-14,-156},{16,-156}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe4.gasPortOut, junction4.gasPort3) annotation (Line(
      points={{56,-156},{96,-156},{96,-116}},
      color={255,255,0},
      thickness=1.5));
  connect(junction2.gasPort3, pipe1.gasPortOut) annotation (Line(
      points={{-24,-56},{-24,-64},{-24,-94},{-22,-94}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe1.gasPortIn, junction1.gasPort2) annotation (Line(
      points={{-22,-134},{-24,-140},{-24,-146}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_feedIn1.gasPort1, vleCompositionSensor_1.gasPortIn) annotation (Line(
      points={{-64,-156},{-61,-156},{-58,-156}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_1.gasPortOut, junction1.gasPort1) annotation (Line(
      points={{-40,-156},{-34,-156}},
      color={255,255,0},
      thickness=1.5));
  connect(gainFeedIn2.u, replicator.y[2]) annotation (Line(points={{94,104},{-18,104},{-118,104},{-118,-13.5},{-141,-13.5}},             color={0,0,127}));
  connect(gainFeedIn1.u, replicator.y[1]) annotation (Line(points={{-98,-15.5},{-118,-15.5},{-118,-14.5},{-141,-14.5}},  color={0,0,127}));
  connect(junction3.gasPort3, vleCompositionSensor_2.gasPortIn) annotation (Line(
      points={{106,4},{116,4}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_2.gasPortOut, junction_feedIn2.gasPort1) annotation (Line(
      points={{136,4},{142,4}},
      color={255,255,0},
      thickness=1.5));
connect(source1.gasPort, maxH2MassFlow1.gasPortIn) annotation (Line(
    points={{-124,-156},{-112,-156}},
    color={255,255,0},
    thickness=1.5));
connect(maxH2MassFlow1.gasPortOut, junction_feedIn1.gasPort3) annotation (Line(
    points={{-92,-156},{-92,-156},{-84,-156}},
    color={255,255,0},
    thickness=1.5));
connect(maxH2MassFlow2.gasPortIn, source2.gasPort) annotation (Line(
    points={{190,4},{193,4},{196,4}},
    color={255,255,0},
    thickness=1.5));
connect(junction_feedIn2.gasPort3, maxH2MassFlow2.gasPortOut) annotation (Line(
    points={{162,4},{166,4},{170,4}},
    color={255,255,0},
    thickness=1.5));
  connect(feedInStation1.gasPortOut, junction_feedIn1.gasPort2) annotation (Line(
      points={{-74.15,-112.16},{-74.15,-129.08},{-74,-129.08},{-74,-146}},
      color={255,255,0},
      thickness=1.5));
  connect(feedInStation1.epp, ElectricGrid.epp) annotation (Line(
      points={{-58,-96},{-58,-96},{-52,-96},{-52,64},{-52,63},{-212,63}},
      color={0,135,135},
      thickness=0.5));
  connect(gainFeedIn1.y, feedInStation1.P_el_set) annotation (Line(points={{-75,-15.5},{-75,-15.5},{-75,-79.36}}, color={0,0,127}));
connect(maxH2MassFlow1.m_flow_H2_max, feedInStation1.m_flow_feedIn) annotation (Line(points={{-102,-147},{-102,-147},{-102,-83.2},{-92,-83.2}}, color={0,0,127}));
  connect(junction_feedIn2.gasPort2, feedInStation2.gasPortOut) annotation (Line(
      points={{152,14},{152.15,14},{152.15,47.84}},
      color={255,255,0},
      thickness=1.5));
connect(feedInStation2.m_flow_feedIn, maxH2MassFlow2.m_flow_H2_max) annotation (Line(points={{170,76.8},{180,76.8},{180,13}}, color={0,0,127}));
  connect(gainFeedIn2.y, feedInStation2.P_el_set) annotation (Line(points={{117,104},{153,104},{153,80.64}}, color={0,0,127}));
  connect(feedInStation2.epp, ElectricGrid.epp) annotation (Line(
      points={{136,64},{136,64},{-52,64},{-52,63},{-212,63}},
      color={0,135,135},
      thickness=0.5));
  connect(gasDemandProfiler.T_amb, T_amb.y) annotation (Line(points={{46.4,-40},{46.4,-40},{48.9,-40}}, color={0,0,127}));
  connect(sink1.m_flow, gasDemandProfiler.gasDemandFlow) annotation (Line(points={{16,-40},{25.4,-40}},            color={0,0,127}));
  connect(residualLoad.P_el, replicator.u) annotation (Line(points={{-210,-14},{-188,-14},{-164,-14}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        initialScale=0.1)), Diagram(graphics,
                                    coordinateSystem(
        preserveAspectRatio=false,
        extent={{-260,-200},{260,200}},
        initialScale=0.1)),
    experiment(
      StopTime=259200,
      Interval=900,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(
      inputs=false,
      equidistant=false,
      events=false),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=true,
      OutputFlatModelica=false),
Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Small stand-alone closed-loop gas grid model. </p>
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
<p>Created by Johannes Brunnemann (brunnemann@xrg-simulation.de), Jan 2017</p>
<p>Edited and revised by Lisa Andresen (andresen@tuhh.de), Apr 2017</p>
<p>Model revised by Carsten Bode (c.bode@tuhh.de) in Apr 2018 (fixed for update to ClaRa 1.3.0)</p>
</html>"));
end GasGrid_StandAlone;
