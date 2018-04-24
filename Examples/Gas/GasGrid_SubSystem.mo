within TransiEnt.Examples.Gas;
model GasGrid_SubSystem "Very simple gas grid featuring the main components"
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

  outer TransiEnt.SimCenter simCenter;
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
  parameter Modelica.SIunits.MassFlowRate m_flow_start=0.001 "|Initialization|Sets initial value for m_flow (value needed for init with StatCycle)";
  parameter Modelica.SIunits.Temperature T_Init=283.15 "|Initialization|Sets initial value for T";
  parameter Modelica.SIunits.Efficiency eta_n(
    min=0,
    max=1)=0.75 "|Electrolyzer|Nominal efficency coefficient (min = 0, max = 1)";
  parameter Modelica.SIunits.Efficiency eta_scale(
    min=0,
    max=1)=0 "|Electrolyzer|Sets a with increasing input power linear degrading efficiency coefficient (min = 0, max = 1)";
  parameter Modelica.SIunits.AbsolutePressure p_out=35e5 "|Electrolyzer|Hydrogen output pressure from electrolyzer";
  parameter Modelica.SIunits.Temperature T_out=283.15 "|Electrolyzer|Hydrogen output temperature from electrolyzer";
  parameter Real t_overload=0.5*3600 "|Electrolyzer|Maximum time the ely can work in overload in seconds";
  parameter Real coolingToHeatingRatio=1 "|Electrolyzer|Defines how much faster electrolyzer cools down than heats up";
  parameter Integer startState=1 "|Electrolyzer|Initial state of the electrolyzer (1: ready to overheat, 2: working in overload, 3: cooling down)";

  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PI "|Controller|Type of controller for feed-in control";
  parameter Real k=1e8 "|Controller|Gain for feed-in control";
  parameter Real Ti=1 "|Controller|Integrator time constant for feed-in control";
  parameter Real Td=0.1 "|Controller|Derivative time constant for feed-in control";

  parameter Real f_1=0.5;
  parameter Real f_2=0.5;
  parameter Real phi_H2max=0.1;

  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 junction1(
    initOption=0,
    xi_start=init.junction1.xi_in,
    h_start=init.junction1.h_in,
    volume=1,
    p_start=init.junction1.p) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-60,-98})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi pipe1(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    initOption=0,
    length=1000,
    N_cv=5,
    h_start=ones(pipe1.N_cv)*init.pipe1.h_in,
    p_start=linspace(
        init.pipe1.p_in,
        init.pipe1.p_out,
        pipe1.N_cv),
    m_flow_start=ones(pipe1.N_cv + 1)*init.pipe1.m_flow,
    xi_start=init.pipe1.xi_in,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (final temperatureDifference="Outlet")) annotation (Placement(transformation(
        extent={{-20,-10},{20,10}},
        rotation=90,
        origin={-60,-56})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi source1(m_flow_nom=0) annotation (Placement(transformation(extent={{-200,-118},{-160,-78}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi source2(m_flow_nom=0) annotation (Placement(transformation(extent={{200,42},{160,82}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sink1(p_nom=0, m_flow_const=1000*m_flow_start) annotation (Placement(transformation(extent={{-22,2},{-42,22}})));
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
    sink1_m_flow=sink1.m_flow_const,
    sink2_m_flow=1e-5,
    feedIn1_m_flow=m_flow_start,
    feedIn2_m_flow=m_flow_start)
                       annotation (Placement(transformation(extent={{-194,162},{-160,196}})));
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
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (final temperatureDifference="Outlet")) annotation (Placement(transformation(
        extent={{-20,-10},{20,10}},
        rotation=180,
        origin={0,62})));
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
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (final temperatureDifference="Outlet")) annotation (Placement(transformation(
        extent={{-20,-10},{20,10}},
        rotation=270,
        origin={60,22})));
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
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (final temperatureDifference="Outlet")) annotation (Placement(transformation(
        extent={{-20,-10},{20,10}},
        rotation=0,
        origin={0,-98})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 junction2(
    initOption=0,
    p_start=init.junction2.p,
    xi_start=init.junction2.xi_out,
    h_start=init.junction2.h_out,
    volume=1) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-60,12})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 junction3(
    initOption=0,
    xi_start=init.junction3.xi_in,
    h_start=init.junction3.h_in,
    volume=1,
    p_start=init.junction3.p) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,62})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 junction4(
    initOption=0,
    p_start=init.junction4.p,
    xi_start=init.junction4.xi_out,
    h_start=init.junction4.h_out,
    volume=1) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={60,-48})));
  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(extent={{-220,20},{-180,60}}), iconTransformation(extent={{-220,20},{-180,60}})));
  Modelica.Blocks.Interfaces.RealInput P_el_set annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-208,138}),
                         iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-196,140})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi c_H2_max_1(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-138,-98})));
  Modelica.Blocks.Math.Gain gainFeedIn1(k=f_1) annotation (Placement(transformation(
        extent={{10,-9.5},{-10,9.5}},
        rotation=90,
        origin={-112,8.5})));
public
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 junction_feedIn1(
    initOption=0,
    xi_start=init.junction1.xi_in,
    h_start=init.junction1.h_in,
    volume=0.1,
    p_start=init.junction1.p) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-110,-98})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_1(compositionDefinedBy=2) annotation (Placement(transformation(extent={{-94,-98},{-76,-80}})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi c_H2_max_2(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={144,62})));
public
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 junction_feedIn2(
    initOption=0,
    xi_start=init.junction1.xi_in,
    h_start=init.junction1.h_in,
    volume=0.1,
    p_start=init.junction1.p) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={116,62})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_2(compositionDefinedBy=2) annotation (Placement(transformation(extent={{80,62},{100,82}})));
protected
  Modelica.Blocks.Math.Gain gainFeedIn2(k=f_2) annotation (Placement(transformation(extent={{70,128},{90,148}})));
public
  Modelica.Blocks.Routing.Replicator replicator(nout=2) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-172,138})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasIn(Medium=simCenter.gasModel1) annotation (Placement(transformation(extent={{190,-62},{220,-32}}), iconTransformation(extent={{190,-60},{210,-40}})));
  Components.Electrical.Grid.Line_PS line_L1_PS annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=0,
        origin={-156,40})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sink2(p_nom=0, m_flow_const=1000*m_flow_start) annotation (Placement(transformation(extent={{112,-32},{92,-12}})));
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
    P_el_overload=P_el_overload*f_1) annotation (Placement(transformation(extent={{-94,-52},{-128,-20}})));
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
    P_el_overload=P_el_overload*f_2) annotation (Placement(transformation(extent={{100,100},{134,132}})));
equation
  connect(junction2.gasPort1, pipe2.gasPortOut) annotation (Line(
      points={{-60,22},{-60,62},{-20,62}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe2.gasPortIn, junction3.gasPort1) annotation (Line(
      points={{20,62},{36,62},{50,62}},
      color={255,255,0},
      thickness=1.5));
  connect(junction3.gasPort2, pipe3.gasPortIn) annotation (Line(
      points={{60,52},{60,42}},
      color={255,255,0},
      thickness=1.5));
  connect(junction4.gasPort1, pipe3.gasPortOut) annotation (Line(
      points={{60,-38},{60,2}},
      color={255,255,0},
      thickness=1.5));
  connect(junction2.gasPort2, sink1.gasPort) annotation (Line(
      points={{-50,12},{-42,12}},
      color={255,255,0},
      thickness=1.5));
  connect(junction1.gasPort3, pipe4.gasPortIn) annotation (Line(
      points={{-50,-98},{-50,-98},{-20,-98}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe4.gasPortOut, junction4.gasPort3) annotation (Line(
      points={{20,-98},{60,-98},{60,-58}},
      color={255,255,0},
      thickness=1.5));
  connect(junction2.gasPort3, pipe1.gasPortOut) annotation (Line(
      points={{-60,2},{-60,-6},{-60,-16},{-60,-36}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe1.gasPortIn, junction1.gasPort2) annotation (Line(
      points={{-60,-76},{-60,-82},{-60,-88}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_feedIn1.gasPort1, vleCompositionSensor_1.gasPortIn) annotation (Line(
      points={{-100,-98},{-97,-98},{-94,-98}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_1.gasPortOut, junction1.gasPort1) annotation (Line(
      points={{-76,-98},{-70,-98}},
      color={255,255,0},
      thickness=1.5));
  connect(gainFeedIn2.u, replicator.y[2]) annotation (Line(points={{68,138},{68,138},{-161,138},{-161,138.5}},                           color={0,0,127}));
  connect(P_el_set, replicator.u) annotation (Line(points={{-208,138},{-208,138},{-184,138}},
                                                                                           color={0,0,127}));
  connect(junction3.gasPort3, vleCompositionSensor_2.gasPortIn) annotation (Line(
      points={{70,62},{80,62}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_2.gasPortOut, junction_feedIn2.gasPort1) annotation (Line(
      points={{100,62},{106,62}},
      color={255,255,0},
      thickness=1.5));
  connect(source1.gasPort, c_H2_max_1.gasPortIn) annotation (Line(
      points={{-160,-98},{-148,-98}},
      color={255,255,0},
      thickness=1.5));
  connect(c_H2_max_1.gasPortOut, junction_feedIn1.gasPort3) annotation (Line(
      points={{-128,-98},{-128,-98},{-120,-98}},
      color={255,255,0},
      thickness=1.5));
  connect(c_H2_max_2.gasPortIn, source2.gasPort) annotation (Line(
      points={{154,62},{157,62},{160,62}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_feedIn2.gasPort3, c_H2_max_2.gasPortOut) annotation (Line(
      points={{126,62},{130,62},{134,62}},
      color={255,255,0},
      thickness=1.5));
  connect(junction4.gasPort2, gasIn) annotation (Line(
      points={{70,-48},{205,-48},{205,-47}},
      color={255,255,0},
      thickness=1.5));
  connect(line_L1_PS.epp_2, epp) annotation (Line(
      points={{-175.8,40},{-175.8,40},{-200,40}},
      color={0,135,135},
      thickness=0.5));
  connect(sink2.gasPort, junction4.gasPort2) annotation (Line(
      points={{92,-22},{84,-22},{76,-22},{76,-48},{70,-48}},
      color={255,255,0},
      thickness=1.5));
  connect(feedInStation1.gasPortOut, junction_feedIn1.gasPort2) annotation (Line(
      points={{-110.15,-52.16},{-110.15,-69.08},{-110,-69.08},{-110,-88}},
      color={255,255,0},
      thickness=1.5));
  connect(gainFeedIn1.y, feedInStation1.P_el_set) annotation (Line(points={{-112,-2.5},{-111,-2.5},{-111,-19.36}}, color={0,0,127}));
  connect(c_H2_max_1.m_flow_H2_max, feedInStation1.m_flow_feedIn) annotation (Line(points={{-138,-89},{-138,-23.2},{-128,-23.2}}, color={0,0,127}));
  connect(feedInStation2.m_flow_feedIn, c_H2_max_2.m_flow_H2_max) annotation (Line(points={{134,128.8},{134,128},{144,128},{144,90},{144,72},{144,71}}, color={0,0,127}));
  connect(gainFeedIn2.y, feedInStation2.P_el_set) annotation (Line(points={{91,138},{117,138},{117,132.64}}, color={0,0,127}));
  connect(junction_feedIn2.gasPort2, feedInStation2.gasPortOut) annotation (Line(
      points={{116,72},{116.15,72},{116.15,99.84}},
      color={255,255,0},
      thickness=1.5));
  connect(feedInStation2.epp, line_L1_PS.epp_1) annotation (Line(
      points={{100,116},{12,116},{-136.2,116},{-136.2,39.8}},
      color={0,135,135},
      thickness=0.5));
  connect(feedInStation1.epp, line_L1_PS.epp_1) annotation (Line(
      points={{-94,-36},{-90,-36},{-82,-36},{-82,39.8},{-136.2,39.8}},
      color={0,135,135},
      thickness=0.5));
  connect(gainFeedIn1.u, replicator.y[1]) annotation (Line(points={{-112,20.5},{-112,20.5},{-112,128},{-112,137.5},{-161,137.5}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-200,-200},{200,200}},
        initialScale=0.1), graphics={
                                   Rectangle(
          extent={{-200,200},{200,-200}},
          lineColor={135,135,135},
          radius=5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-200,24},{200,-24}},
          lineColor={135,135,135},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Gas Grid",
          origin={4,-172},
          rotation=360),
        Ellipse(
          extent={{-118,110},{110,-108}},
          lineColor={255,255,0},
          lineThickness=1)}),
                            Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-200,-200},{200,200}},
        initialScale=0.1), graphics={
                                   Rectangle(
          extent={{-200,200},{200,-200}},
          lineColor={135,135,135},
          radius=5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-200,24},{200,-24}},
          lineColor={135,135,135},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Gas Grid",
          origin={0,-164},
          rotation=360)}),
Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Small closed-loop gas grid subsystem. </p>
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
end GasGrid_SubSystem;
