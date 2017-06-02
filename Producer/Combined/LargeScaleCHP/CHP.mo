within TransiEnt.Producer.Combined.LargeScaleCHP;
model CHP "Recommended model for large scale, combined heat and power plants with second order dynamics, three operating states and optional control power "
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
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends Base.PartialCHP;
  extends TransiEnt.Producer.Electrical.Base.ControlPower.PartialBalancingPowerProvider(
    P_nom=P_el_n,
    primaryBalancingController(P_nom=P_el_n),
    P_el_grad_max_SB=P_grad_max_star,
    redeclare Electrical.Base.ControlPower.CombinedHeatAndPower controlPowerModel(
      P_nom=P_el_n,
      P_min_t=pQDiagram.P_min,
      P_max_t=pQDiagram.P_max,
      P_pr_max=primaryBalancingController.P_pr_max,
      P_grad_max_star=P_el_grad_max_SB,
      is_running=isRunning.y,
      P_PB_set=primaryBalancingController.P_PBP_set,
      P_SB_set=P_SB_set_internal,
      P_el_is=P_el_is),
    isExternalSecondaryController=true,
    isSecondaryControlActive=false,
    final typeOfBalancingPowerResource=typeOfResource);

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Real P_grad_max_star=0.03/60 "Fraction of nominal power per second (12% per minute)" annotation(Dialog(group="Physical Constraints"));
  parameter SI.Power P_el_min_operating=min(PQCharacteristics.PQboundaries[:,3]) "Minimum operating thermal power used to determine plant state" annotation(Dialog(group="Physical Constraints"));
  parameter SI.Time T_steamGenerator = 0.5*(0.632/P_grad_max_star) "Time constant of steam generator (overrides value of P_grad_max_star)" annotation(Dialog(group="Physical Constraints"));
  parameter SI.Time T_turboGenerator = 60 "Time constant of turbo generator" annotation(Dialog(group="Physical Constraints"));
  parameter SI.Time T_heatingCondenser = 40 "Time constant of heating condenser" annotation(Dialog(group="Physical Constraints"));

  parameter SI.Temperature T_feed_init = 100+273.15 "Start temperature of feed water" annotation(Dialog(group="Initialization", tab="Advanced"));

  //Heating condenser parameters

  parameter Modelica.SIunits.Pressure p_nom(displayUnit="Pa")=1e5 "Nominal pressure" annotation(Dialog(group="Heating condenser parameters", tab="Advanced"));
  parameter SI.MassFlowRate m_flow_nom=10 "Nominal mass flow rate" annotation(Dialog(group="Heating condenser parameters", tab="Advanced"));
  parameter SI.SpecificEnthalpy h_nom=1e5 "Nominal specific enthalpy" annotation(Dialog(group="Heating condenser parameters", tab="Advanced"));
  final parameter SI.SpecificEnthalpy h_start=TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
      medium,
      p_nom,
      T_feed_init) "Start value of sytsem specific enthalpy" annotation(Dialog(group="Heating condenser parameters", tab="Advanced"));

  parameter SI.Time t_startup=3600 "Time between startup signal and minimum load operation" annotation(Dialog(group="Physical Constraints"));

  parameter SI.Inertia J=10*P_el_n/(100*3.14)^2 "Lumped moment of inertia of whole power plant" annotation(Dialog(group="Physical Constraints"));

  parameter Integer nSubgrid=1 "Index of subgrid for moment of inertia statistics" annotation (Dialog(group="Statistics"));

  parameter Boolean fixedStartValue_w = false "Wether or not the start value of the angular velocity of the plants mechanical components is fixed"
   annotation (Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true), Dialog(tab="Advanced", group="Initialization"));

  // _____________________________________________
  //
  //               Components
  // _____________________________________________

  Modelica.Blocks.Continuous.FirstOrder P(T=T_turboGenerator,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=P_el_init)                                           annotation (Placement(visible=true, transformation(
        origin={-11.8546,7.7058},
        extent={{-10.9091,-10.9091},{10.9091,10.9091}},
        rotation=0)));
  Modelica.Blocks.Continuous.FirstOrder steamGenerator(
    T=T_steamGenerator,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=if useEfficiencyForInit then P_el_init/eta_el_init else Q_flow_SG_init) annotation (Placement(transformation(extent={{-82,-24},{-62,-4}})));
  Modelica.Blocks.Continuous.FirstOrder Q_flow_CHP(
    T=T_heatingCondenser,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=Q_flow_init) annotation (Placement(transformation(extent={{-32,-46},{-12,-26}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow(T_ref(displayUnit="degC"))
     annotation (Placement(
        transformation(
        extent={{-5,-5.5},{5,5.5}},
        rotation=0,
        origin={37,-41.5})));
  ClaRa.Components.HeatExchangers.TubeBundle_L2 HX(
    length=15,
    N_tubes=10,
    N_passes=2,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2,
    m_flow_nom=m_flow_nom,
    p_nom(displayUnit="Pa") = p_nom,
    h_nom=h_nom,
    h_start=h_start,
    p_start=p_nom,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2,
    initOption=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={58,-42})));

  Modelica.Blocks.Math.Product
                            ElectricEfficiency           annotation (Placement(transformation(extent={{-54,12},{-46,4}})));
  Modelica.Blocks.Sources.RealExpression eta_th_is(y=eta_th_target)
                                                             annotation (Placement(transformation(extent={{-74,-48},{-54,-28}})));
  Modelica.Blocks.Math.Product product1 annotation (Placement(transformation(extent={{-46,-40},{-38,-32}})));

  Modelica.Blocks.Math.MultiSum P_set_electric(          nu=2) annotation (Placement(transformation(extent={{-38,12},{-30,4}})));
  Modelica.Blocks.Sources.RealExpression eta_el_is(y=eta_el_target)
                                                             annotation (Placement(transformation(extent={{-84,-4},{-64,16}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_peak(y=min(Q_flow_n_Peak, Q_flow_set_pos.y - Q_flow_CHP.y))
                                                                                                        annotation (Placement(transformation(extent={{-32,-74},{-12,-54}})));
  Modelica.Blocks.Math.Sum Q_flow(nin=2) annotation (Placement(transformation(extent={{10,-47},{20,-37}})));

  Modelica.Blocks.Sources.BooleanExpression isRunning(y=plantState.operating.active) annotation (Placement(transformation(extent={{8,20},{28,40}})));
  Components.Boundaries.Mechanical.Power prescribedPower(change_sign=true) annotation (Placement(transformation(extent={{8,2},{22,16}})));
  Components.Mechanical.TwoStateInertiaWithIdealClutch Shaft(
    w(fixed=fixedStartValue_w, start=2*simCenter.f_n*Modelica.Constants.pi),
    J=J,
    nSubgrid=nSubgrid) annotation (choicesAllMatching=true, Placement(transformation(extent={{30,0},{48,19}})));
  Components.Electrical.Machines.ActivePowerGenerator Generator(eta=1) annotation (choicesAllMatching=true, Placement(transformation(
        extent={{-11.5,-12},{11.5,12}},
        rotation=0,
        origin={68.5,42})));
  Modelica.Blocks.Nonlinear.VariableLimiter P_limit_on annotation (Placement(transformation(extent={{-52,98},{-38,112}})));
  Base.CHPStates_electricityled plantState(
    t_startup=t_startup,
    init_state=if P_el_init > 0 then TransiEnt.Basics.Types.on1 else TransiEnt.Basics.Types.off,
    P_el_min_operating=P_el_min_operating,
    P_el_max_operating=P_el_n) annotation (Placement(transformation(extent={{-81,98},{-67,112}})));
  Modelica.Blocks.Sources.RealExpression P_limit_off(y=if plantState.operating.active then 0 else -pQDiagram.P_min) annotation (Placement(transformation(extent={{-58,74},{-38,94}})));
  Modelica.Blocks.Math.Sum P_set_total(nin=2, k=-ones(2))
                                              "Schedule plus agc setpoint" annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={-90,105})));
  Modelica.Blocks.Math.Sum P_limit(nin=2) annotation (Placement(transformation(extent={{-30,98},{-18,110}})));
equation

  Q_flow_input=steamGenerator.u;

  // _____________________________________________
  //
  //               Connect Statements
  // ____________________________________________
  connect(outlet, HX.outlet) annotation (Line(
      points={{100,4},{58,4},{58,-32}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(inlet, HX.inlet) annotation (Line(
      points={{100,-24},{98,-24},{98,-56},{94,-56},{94,-54},{58,-54},{58,-52}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));

  //Annotations
  connect(Q_flow_CHP.u, product1.y) annotation (Line(points={{-34,-36},{-34,-36},{-37.6,-36}}, color={0,0,127}));
  connect(steamGenerator.y, product1.u1) annotation (Line(points={{-61,-14},{-50,-14},{-50,-33.6},{-46.8,-33.6}}, color={0,0,127}));
  connect(prescribedPower.P_mech_set, P.y) annotation (Line(points={{15,17.26},{15,20},{2,20},{2,8},{0.14541,8},{0.14541,7.7058}}, color={0,0,127}));
  connect(P.u, P_set_electric.y) annotation (Line(points={{-24.9455,7.7058},{-27.4727,7.7058},{-27.4727,8},{-29.32,8}}, color={0,0,127}));
  connect(ElectricEfficiency.y, P_set_electric.u[1]) annotation (Line(points={{-45.6,8},{-38,8},{-38,6.6}}, color={0,0,127}));
  connect(primaryBalancingController.P_PBP_set, P_set_electric.u[2]) annotation (Line(points={{-28.6,54},{-42,54},{-42,9.4},{-38,9.4}},
                                                                                                                                      color={0,0,127}));
  connect(steamGenerator.y, ElectricEfficiency.u1) annotation (Line(points={{-61,-14},{-58,-14},{-58,5.6},{-54.8,5.6}}, color={0,0,127}));
  connect(eta_el_is.y, ElectricEfficiency.u2) annotation (Line(points={{-63,6},{-60,6},{-60,10.4},{-54.8,10.4}}, color={0,0,127}));
  connect(eta_th_is.y, product1.u2) annotation (Line(points={{-53,-38},{-46.8,-38},{-46.8,-38.4}}, color={0,0,127}));
  connect(Q_flow.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{20.5,-42},{32,-42},{32,-41.5}}, color={0,0,127}));
  connect(prescribedHeatFlow.port, HX.heat) annotation (Line(points={{42,-41.5},{44,-41.5},{44,-42},{48,-42}}, color={191,0,0}));
  connect(Q_flow_CHP.y, Q_flow.u[1]) annotation (Line(points={{-11,-36},{-4,-36},{-4,-36},{-2,-36},{-2,-42.5},{9,-42.5}}, color={0,0,127}));
  connect(Q_flow_peak.y, Q_flow.u[2]) annotation (Line(points={{-11,-64},{-4,-64},{-4,-41.5},{9,-41.5}}, color={0,0,127}));
  connect(isRunning.y, Shaft.isRunning) annotation (Line(points={{29,30},{32,30},{38.91,30},{38.91,17.765}}, color={255,0,255}));
  connect(Q_flow_set_SG.Q_flow_input, steamGenerator.u) annotation (Line(
      points={{0,79},{0,72},{-94,72},{-94,-14},{-84,-14}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(prescribedPower.mpp, Shaft.mpp_a) annotation (Line(points={{22,9},{26,9},{26,9.5},{30,9.5}}, color={95,95,95}));
  connect(Shaft.mpp_b, Generator.mpp) annotation (Line(points={{48,9.5},{54,9.5},{54,41.4},{56.425,41.4}}, color={95,95,95}));
  connect(Generator.epp, epp) annotation (Line(
      points={{80.115,41.88},{88.0575,41.88},{88.0575,60},{100,60}},
      color={0,135,135},
      thickness=0.5));
  connect(Generator.mpp, gridFrequencySensor.mpp) annotation (Line(points={{56.425,41.4},{46.2125,41.4},{46.2125,54},{33.2,54}}, color={95,95,95}));
  connect(P_SB_set_internal,P_set_total. u[2]) annotation (Line(points={{-156,60},{-98,60},{-98,105.5},{-96,105.5}}, color={0,0,127}));
  connect(P_limit_on.y,P_limit. u[1]) annotation (Line(points={{-37.3,105},{-31.2,105},{-31.2,103.4}},
                                                                                                     color={0,0,127}));
  connect(P_limit_off.y,P_limit. u[2]) annotation (Line(points={{-37,84},{-34,84},{-34,86},{-34,102},{-34,104.6},{-31.2,104.6}}, color={0,0,127}));
  connect(P_set_total.y,plantState. P_el_set) annotation (Line(points={{-84.5,105},{-85,105},{-85,108},{-85,105},{-81,105}},
                                                                                                                         color={0,0,127}));
  connect(plantState.P_el_set_lim,P_limit_on. u) annotation (Line(points={{-66.16,105},{-66.16,105},{-53.4,105}},            color={0,0,127}));
  connect(P_set, P_set_total.u[1]) annotation (Line(points={{-84,144},{-84,144},{-84,122},{-100,122},{-100,104.5},{-96,104.5}}, color={0,0,127}));
  connect(pQDiagram.P_max, P_limit_on.limit1) annotation (Line(points={{-11,128.4},{-60,128.4},{-60,110.6},{-53.4,110.6}}, color={0,0,127}));
  connect(pQDiagram.P_min, P_limit_on.limit2) annotation (Line(points={{-11,121},{-62,121},{-62,99.4},{-53.4,99.4}}, color={0,0,127}));
  connect(P_limit.y, Q_flow_set_SG.P) annotation (Line(points={{-17.4,104},{-7,104},{-7,102}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,140}})), Icon(coordinateSystem(extent={{-100,-100},{100,140}}, preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
</html>"));
end CHP;
