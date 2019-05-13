within TransiEnt.Producer.Electrical.Conventional.Components;
model DetailedSteamPowerPlant "A closed steam cycle including single reheat, feedwater tank, LP and HP preheaters"
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
  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  extends TransiEnt.Basics.Icons.SteamCycle;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________
  parameter Modelica.SIunits.Power P_n=577e6 "Nominal Power. Possible values: from 900MW to 500MW";
  parameter Modelica.SIunits.Power P_min=0.25*P_n "Minimum possible load";
  parameter Real k_PID=0.5;//1.305 "Gain of controller";
  parameter Modelica.SIunits.Time Ti_PID=650 "Time constant of Integrator block";
                                            //216.667
  parameter Modelica.SIunits.Time startTime=2000;
  //Real Target;
  parameter Modelica.SIunits.Time Tu=127.469 "equivalent dead time of steam generation";
                                        //127.469
  parameter Modelica.SIunits.Time Tg=204.966 "balancing time of steam generation";
  parameter Modelica.SIunits.Time Ts=60.2459 "Integration time of steam storage";
  parameter Boolean SetValueMinimumLoad=false "If P_set<P_min: If 'true', power plant is shut down - if 'false', power plant operates with minimum load";
  // _____________________________________________
  //
  //                Variables
  // _____________________________________________
  Modelica.SIunits.Power P_output;
  Real efficiency;
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 turbine_HP1(
    p_nom=NOM.Turbine_HP.p_in,
    m_flow_nom=NOM.Turbine_HP.m_flow,
    Pi=NOM.Turbine_HP.p_out/NOM.Turbine_HP.p_in,
    rho_nom=TILMedia.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_HP.p_in,
        NOM.Turbine_HP.h_in),
    eta_mech=1,
    allowFlowReversal=true,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,NOM.efficiency_Turb_HP; 1,NOM.efficiency_Turb_HP])),
    p_in_start=INIT.Turbine_HP.p_in,
    p_out_start=INIT.Turbine_HP.p_out) annotation (Placement(transformation(extent={{-58,38},{-48,58}})));

  ClaRa.SubSystems.Boiler.SteamGenerator_L3 steamGenerator_1_XRG(
    p_LS_start=INIT.boiler.p_LS_out,
    p_RH_start=INIT.boiler.p_RS_out,
    Q_flow_F_nom=NOM.boiler.Q_flow,
    p_LS_nom=NOM.boiler.p_LS_out,
    p_RH_nom=NOM.boiler.p_RS_out,
    h_LS_nom=NOM.boiler.h_LS_out,
    h_RH_nom=NOM.boiler.h_RS_out,
    h_LS_start=INIT.boiler.h_LS_out,
    h_RH_start=INIT.boiler.h_RS_out,
    CL_etaF_QF_=[0,1; 1,1],
    CL_yF_QF_=[0.4207,0.8341; 0.6246,0.8195; 0.8171,0.8049; 1,NOM.boiler.m_flow_feed*(NOM.boiler.h_LS_out - NOM.boiler.h_LS_in)/NOM.boiler.Q_flow],
    m_flow_nomLS=NOM.boiler.m_flow_LS_nom,
    Delta_p_nomHP=NOM.Delta_p_LS_nom,
    Delta_p_nomIP=NOM.Delta_p_RS_nom,
    CL_Delta_pHP_mLS_=INIT.CharLine_Delta_p_HP_mLS_,
    CL_Delta_pIP_mLS_=INIT.CharLine_Delta_p_IP_mRS_,
    initOption_HP=0,
    initOption_IP=208,
    Tau_dead=30,
    Tau_bal=60)        annotation (Placement(transformation(extent={{-152,50},{-124,88}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 Turbine_IP(
    p_nom=NOM.Turbine_IP.p_in,
    m_flow_nom=NOM.Turbine_IP.m_flow,
    Pi=NOM.Turbine_IP.p_out/NOM.Turbine_IP.p_in,
    rho_nom=TILMedia.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_IP.p_in,
        NOM.Turbine_IP.h_in),
    eta_mech=1,
    allowFlowReversal=true,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,NOM.Turbine_IP.efficiency; 1,NOM.Turbine_IP.efficiency])),
    p_in_start=INIT.Turbine_IP.p_in,
    p_out_start=INIT.Turbine_IP.p_out) annotation (Placement(transformation(extent={{-12,38},{-2,58}})));

  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 Turbine_LP2(
    p_nom=NOM.Turbine_LP2.p_in,
    m_flow_nom=NOM.Turbine_LP2.m_flow,
    Pi=NOM.Turbine_LP2.p_out/NOM.Turbine_LP2.p_in,
    rho_nom=TILMedia.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_LP2.p_in,
        NOM.Turbine_LP2.h_in),
    eta_mech=1,
    allowFlowReversal=true,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,NOM.Turbine_LP2.efficiency; 1,NOM.Turbine_LP2.efficiency])),
    p_in_start=INIT.Turbine_LP2.p_in,
    p_out_start=INIT.Turbine_LP2.p_out) annotation (Placement(transformation(extent={{232,6},{242,26}})));

  Modelica.Blocks.Sources.RealExpression realPlantPower_(y=-(turbine_HP1.P_t +
        Turbine_IP.P_t + Turbine_LP1.P_t + Turbine_LP2.P_t)/550e6)
    annotation (Placement(transformation(extent={{-218,-8},{-198,12}})));

  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple Pump_FW(eta_mech=0.8) annotation (Placement(transformation(extent={{-56,-128},{-76,-148}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={272,-34})));

  Modelica.Blocks.Sources.RealExpression Q_cond(y=-(Turbine_LP2.summary.outlet.h
         - TILMedia.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(
        simCenter.fluid1, NOM.p_condenser))*Turbine_LP2.summary.outlet.m_flow)
    annotation (Placement(transformation(extent={{334,-48},{296,-20}})));
  ClaRa.Visualisation.Quadruple quadruple(decimalSpaces(p=2))
                                          annotation (Placement(transformation(
        extent={{-30,-10},{30,10}},
        rotation=0,
        origin={280,10})));
  ClaRa.Visualisation.Quadruple quadruple1
    annotation (Placement(transformation(extent={{-118,98},{-58,118}})));
  ClaRa.Visualisation.Quadruple quadruple2
    annotation (Placement(transformation(extent={{-218,98},{-158,118}})));
  ClaRa.Visualisation.Quadruple quadruple3
    annotation (Placement(transformation(extent={{12,58},{72,78}})));
  ClaRa.Visualisation.Quadruple quadruple4
    annotation (Placement(transformation(extent={{-38,98},{22,118}})));
  ClaRa.Visualisation.DynDisplay dynDisplay(
    decimalSpaces=3,
    varname="eta_el",
    unit="",
    x1=(abs(turbine_HP1.P_t + Turbine_IP.P_t + Turbine_LP1.P_t + Turbine_LP2.P_t) - abs(Pump_preheater_LP1.P_drive + Pump_cond.P_drive + Pump_FW.P_drive))/abs(steamGenerator_1_XRG.Q_flow_HP + steamGenerator_1_XRG.Q_flow_IP)) annotation (Placement(transformation(extent={{-218,26},{-186,38}})));
  ClaRa.Components.HeatExchangers.HEXvle_L3_2ph_BU condenser(
    height=5,
    width=5,
    length=10,
    diameter_o=0.025,
    redeclare model HeatTransfer_Shell = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 (alpha_nom={10000,10000}),
    redeclare model PressureLossShell = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={100,100,100}),
    Tau_cond=0.3,
    Tau_evap=0.03,
    width_hotwell=4,
    length_hotwell=6,
    z_in_shell=4.9,
    z_out_shell=0.1,
    level_rel_start=0.5/6,
    m_flow_nom_shell=NOM.condenser.m_flow_in,
    p_nom_shell=NOM.condenser.p_condenser,
    p_start_shell=INIT.condenser.p_condenser,
    initOptionShell=204) annotation (Placement(transformation(extent={{232,-46},{252,-22}})));

  ClaRa.Visualisation.Quadruple quadruple5(decimalSpaces(p=2))
    annotation (Placement(transformation(extent={{252,-72},{312,-52}})));

  Modelica.Blocks.Sources.RealExpression realPlantPower_1(y=-(turbine_HP1.P_t +
        Turbine_IP.P_t + Turbine_LP1.P_t + Turbine_LP2.P_t))
    annotation (Placement(transformation(extent={{-218,-28},{-198,-8}})));
  ClaRa.Components.MechanicalSeparation.FeedWaterTank_L3 feedWaterTank(
    level_rel_start=0.5,
    diameter=5,
    orientation=ClaRa.Basics.Choices.GeometryOrientation.horizontal,
    p_start(displayUnit="bar") = INIT.feedwatertank.p_FWT,
    length=10,
    z_tapping=4.5,
    z_aux=4.5,
    z_vent=4.5,
    z_condensate=4.5,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={1000,1000,1000}),
    m_flow_cond_nom=NOM.feedwatertank.m_flow_cond,
    p_nom=NOM.feedwatertank.p_FWT,
    h_nom=NOM.feedwatertank.h_cond_in,
    m_flow_heat_nom=NOM.feedwatertank.m_flow_tap1 + NOM.feedwatertank.m_flow_tap2,
    initOption=204) "INIT.feedwatertank.h_cond_out" annotation (Placement(transformation(extent={{-12,-138},{48,-118}})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple Pump_cond(eta_mech=1, showExpertSummary=true) annotation (Placement(transformation(extent={{212,-112},{192,-132}})));
  Modelica.Blocks.Sources.Constant const3(k=0.5/6)
    annotation (Placement(transformation(extent={{262,-162},{242,-142}})));
  Modelica.Blocks.Sources.RealExpression condenser_relLevel(y=condenser.shell.phaseBorder.level_rel) annotation (Placement(transformation(extent={{316,-196},{276,-168}})));
  ClaRa.Components.Utilities.Blocks.LimPID PI_Pump_cond(
    sign=-1,
    y_ref=1e6,
    k=50,
    Tau_d=30,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Tau_i=300,
    y_max=NOM.Pump_cond.P_pump*10,
    y_min=NOM.Pump_cond.P_pump/200,
    y_start=INIT.Pump_cond.P_pump,
    initOption=if ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.SteadyState) then 798 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialOutput) then 796 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialState) then 797 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState) then 795 else 501) annotation (Placement(transformation(extent={{232,-162},{212,-142}})));
  ClaRa.Visualisation.Quadruple quadruple6
    annotation (Placement(transformation(extent={{-14,-172},{46,-152}})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y join_IP(
    h_start=INIT.Turbine_IP.h_out,
    p_start=INIT.Turbine_IP.p_out,
    volume=0.1,
    p_nom=NOM.Turbine_IP.p_out,
    h_nom=NOM.Turbine_IP.h_out,
    m_flow_out_nom={NOM.feedwatertank.m_flow_cond,NOM.feedwatertank.m_flow_tap2},
    initOption=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={34,38})));

  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1 valve_IP(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                      Delta_p_nom=20e5 - 12.8e5, m_flow_nom=65.895))
    annotation (Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=270,
        origin={34,-42})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 Turbine_LP1(
    p_nom=NOM.Turbine_LP1.p_in,
    m_flow_nom=NOM.Turbine_LP1.m_flow,
    Pi=NOM.Turbine_LP1.p_out/NOM.Turbine_LP1.p_in,
    rho_nom=TILMedia.VLEFluidFunctions.density_phxi(
        simCenter.fluid1,
        NOM.Turbine_LP1.p_in,
        NOM.Turbine_LP1.h_in),
    eta_mech=1,
    allowFlowReversal=true,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,NOM.Turbine_LP1.efficiency; 1,NOM.Turbine_LP1.efficiency])),
    p_in_start=INIT.Turbine_LP1.p_in,
    p_out_start=INIT.Turbine_LP1.p_out) annotation (Placement(transformation(extent={{88,22},{98,42}})));

  ClaRa.Visualisation.Quadruple quadruple7
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={142,58})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y join_LP1(
    p_nom=INIT.Turbine_LP1.p_out,
    h_nom=INIT.Turbine_LP1.h_out,
    h_start=INIT.Turbine_LP1.h_out,
    p_start=INIT.Turbine_LP1.p_out,
    volume=0.1,
    m_flow_out_nom={-NOM.preheater_LP1.m_flow_cond,-NOM.preheater_LP1.m_flow_tap},
    initOption=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={162,22})));

  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple Pump_preheater_LP1(eta_mech=1) annotation (Placement(transformation(extent={{102,-160},{82,-180}})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1 valve_LP1(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticNominalPoint (                   Delta_p_nom=NOM.valve_LP1.Delta_p_nom, m_flow_nom=NOM.valve_LP1.m_flow))
    annotation (Placement(transformation(
        extent={{-10,6},{10,-6}},
        rotation=270,
        origin={162,-42})));

  Modelica.Blocks.Sources.Constant const_reheater_LP1_relLevel(k=0.5)
    annotation (Placement(transformation(extent={{162,-202},{142,-182}})));
  Modelica.Blocks.Sources.RealExpression preheater_LP1_relLevel(y=preheater_LP1.shell.phaseBorder.level_rel) annotation (Placement(transformation(extent={{162,-236},{122,-208}})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y join_HP(
    volume=0.1,
    p_start=INIT.Turbine_HP.p_out,
    p_nom=NOM.Turbine_HP.p_out,
    h_nom=NOM.Turbine_HP.h_out,
    h_start=INIT.Turbine_HP.h_out,
    showExpertSummary=true,
    m_flow_out_nom={NOM.join_HP.m_flow_2,NOM.join_HP.m_flow_3},
    initOption=0) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-86,18})));

  ClaRa.Components.HeatExchangers.HEXvle2vle_L3_2ph_CH_simple preheater_HP(
    redeclare replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Steel,
    m_flow_nom_shell=NOM.preheater_HP.m_flow_tap,
    p_nom_shell=NOM.preheater_HP.p_tap,
    h_nom_shell=NOM.preheater_HP.h_tap_out,
    m_flow_nom_tubes=NOM.preheater_HP.m_flow_cond,
    h_nom_tubes=NOM.preheater_HP.h_cond_out,
    h_start_tubes=INIT.preheater_HP.h_cond_out,
    N_passes=1,
    diameter_i=0.0189,
    diameter_o=0.0269,
    z_in_tubes=0.1,
    z_out_tubes=0.1,
    Q_flow_nom=2e8,
    z_out_shell=0.1,
    length=15,
    z_in_shell=preheater_HP.length,
    p_start_shell=INIT.preheater_HP.p_tap,
    N_tubes=1081,
    diameter=2.6,
    showExpertSummary=true,
    Tau_cond=0.3,
    Tau_evap=0.03,
    alpha_ph=50000,
    redeclare model HeatTransferTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (alpha_nom=3500),
    p_nom_tubes=NOM.preheater_HP.p_cond,
    p_start_tubes(displayUnit="bar") = INIT.preheater_HP.p_cond,
    redeclare model HeatTransfer_Shell = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 (alpha_nom={1650,10000}),
    redeclare model PressureLossShell = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={1000,1000,1000}),
    redeclare model PressureLossTubes = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=10),
    initOptionShell=204,
    initOptionTubes=0,
    initOptionWall=1) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-140,-40})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1 valve1_HP(
    openingInputIsActive=false,
    showExpertSummary=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticNominalPoint (
        rho_in_nom=23,
        Delta_p_nom=NOM.valve1_HP.Delta_p_nom,
        m_flow_nom=NOM.valve1_HP.m_flow))
    annotation (Placement(transformation(
        extent={{10,-6},{-10,6}},
        rotation=90,
        origin={-88,-12})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1 valve2_HP(
    openingInputIsActive=true, redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticNominalPoint (                   m_flow_nom=NOM.valve_cut.m_flow, Delta_p_nom=NOM.valve_cut.Delta_p))
    annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=0,
        origin={-68,-82})));
  ClaRa.Visualisation.StatePoint_phTs statePoint_XRG
    annotation (Placement(transformation(extent={{-158,18},{-142,34}})));
  ClaRa.Components.HeatExchangers.HEXvle2vle_L3_2ph_CH_simple preheater_LP1(
    redeclare replaceable model WallMaterial = TILMedia.SolidTypes.TILMedia_Steel,
    m_flow_nom_shell=NOM.preheater_LP1.m_flow_tap,
    p_nom_shell=NOM.preheater_LP1.p_tap,
    h_nom_shell=NOM.preheater_LP1.h_tap_out,
    m_flow_nom_tubes=NOM.preheater_LP1.m_flow_cond,
    h_nom_tubes=NOM.preheater_LP1.h_cond_out,
    h_start_tubes=INIT.preheater_LP1.h_cond_out,
    p_start_shell=INIT.preheater_LP1.p_tap,
    diameter_i=0.017,
    diameter_o=0.020,
    N_passes=1,
    N_tubes=500,
    Q_flow_nom=2e8,
    diameter=1.5,
    z_in_shell=preheater_LP1.length,
    z_in_tubes=preheater_LP1.diameter/2,
    z_out_tubes=preheater_LP1.diameter/2,
    length=13,
    z_out_shell=0.1,
    redeclare model HeatTransferTubes = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (PL_alpha=[0,0.55; 0.5,0.65; 0.7,0.72; 0.8,0.77; 1,1], alpha_nom=3000),
    redeclare model PressureLossTubes = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=1000),
    T_w_start={300,320,340},
    Tau_cond=0.3,
    Tau_evap=0.03,
    redeclare model HeatTransfer_Shell = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 (alpha_nom={1500,8000}),
    redeclare model PressureLossShell = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (Delta_p_nom={100,100,100}),
    p_nom_tubes=NOM.preheater_LP1.p_cond,
    p_start_tubes(displayUnit="bar") = INIT.preheater_LP1.p_cond,
    initOptionShell=204,
    initOptionWall=1,
    initOptionTubes=0)
                      annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={162,-124})));

  Modelica.Blocks.Sources.Constant const2(k=0.5)
    annotation (Placement(transformation(extent={{-208,-102},{-188,-82}})));
  Modelica.Blocks.Sources.RealExpression preheater_HP_relLevel2(y=preheater_HP.shell.phaseBorder.level_rel) annotation (Placement(transformation(extent={{-238,-76},{-198,-48}})));
  Modelica.Blocks.Continuous.LimPID PI_Pump_preheater2(
    Td=1,
    yMax=1,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=100,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    y_start=1,
    yMin=0.01,
    Ti=10000)
    annotation (Placement(transformation(extent={{-188,-72},{-168,-52}})));

  Modelica.Blocks.Continuous.FirstOrder measurement(
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0.1,
    T=10)
    annotation (Placement(transformation(extent={{262,-192},{242,-172}})));
  DetailedSteamPowerPlant_InitCycle INIT(
    P_target_=1,
    valve1_HP_Delta_p_nom=NOM.valve1_HP_Delta_p_nom,
    valve_LP1_Delta_p_nom=NOM.valve_LP1_Delta_p_nom,
    valve_LP2_Delta_p_nom=NOM.valve_LP2_Delta_p_nom,
    CharLine_Delta_p_HP_mLS_=NOM.CharLine_Delta_p_HP_mLS_,
    CharLine_Delta_p_IP_mRS_=NOM.CharLine_Delta_p_IP_mRS_,
    efficiency_Pump_cond=NOM.efficiency_Pump_cond,
    efficiency_Pump_preheater_LP1=NOM.efficiency_Pump_preheater_LP1,
    efficiency_Pump_FW=NOM.efficiency_Pump_FW,
    efficiency_Turb_HP=NOM.efficiency_Turb_HP,
    efficiency_Turb_IP=NOM.efficiency_Turb_IP,
    efficiency_Turb_LP1=NOM.efficiency_Turb_LP1,
    efficiency_Turb_LP2=NOM.efficiency_Turb_LP2,
    P_n=P_n,
    m_flow_nom=NOM.m_flow_nom,
    p_FWT=NOM.p_FWT,
    T_LS_nom=NOM.T_LS_nom,
    T_RS_nom=NOM.T_RS_nom,
    preheater_LP1_p_tap=NOM.preheater_LP1_p_tap*0.2,
    preheater_LP1_m_flow_tap=NOM.preheater_LP1_m_flow_tap*0.2,
    p_LS_out_nom=NOM.p_LS_out_nom*0.2,
    p_RS_out_nom=NOM.p_RS_out_nom*0.2,
    Delta_p_LS_nom=NOM.Delta_p_LS_nom*0.2,
    Delta_p_RS_nom=NOM.Delta_p_RS_nom*0.2,
    tapping_IP_pressure=NOM.tapping_IP_pressure*0.2,
    p_condenser=NOM.p_condenser*0.2,
    preheater_HP_p_tap=NOM.preheater_HP_p_tap*0.2,
    preheater_HP_m_flow_tap=NOM.preheater_HP_m_flow_tap*0.2) annotation (Placement(transformation(extent={{-310,-238},{-290,-218}})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1 valve_LP2(
                                          Tau=1e-3, redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                      m_flow_nom=NOM.valve_LP2.m_flow, Delta_p_nom=NOM.valve_LP2.Delta_p_nom))
    annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=180,
        origin={102,-122})));
  ClaRa.Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y join_LP_main(
    useHomotopy=false,
    volume=0.2,
    m_flow_in_nom={NOM.join_LP_main.m_flow_1,NOM.join_LP_main.m_flow_2},
    p_nom=NOM.join_LP_main.p,
    h_nom=NOM.join_LP_main.h3,
    h_start=INIT.join_LP_main.h3,
    p_start=INIT.join_LP_main.p,
    initOption=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={62,-122})));

  ClaRa.Components.Utilities.Blocks.LimPID PI_preheater1(
    sign=-1,
    Tau_d=30,
    y_max=NOM.Pump_preheater_LP1.P_pump*1.5,
    y_min=NOM.Pump_preheater_LP1.P_pump/100,
    y_ref=1e5,
    y_start=INIT.Pump_preheater_LP1.P_pump,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=200,
    Tau_i=200,
    initOption=if ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.SteadyState) then 798 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialOutput) then 796 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialState) then 797 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState) then 795 else 501) annotation (Placement(transformation(extent={{122,-202},{102,-182}})));
  ClaRa.Visualisation.Quadruple quadruple8
    annotation (Placement(transformation(extent={{-27,-8},{27,8}},
        rotation=0,
        origin={71,-62})));
  ClaRa.Visualisation.Quadruple quadruple9
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={202,-62})));
  ClaRa.Visualisation.Quadruple quadruple10
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={102,-102})));
  ClaRa.Visualisation.Quadruple quadruple11
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={-50,-32})));
  ClaRa.Visualisation.Quadruple quadruple12
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={-68,-104})));
  ClaRa.Visualisation.Quadruple quadruple13
    annotation (Placement(transformation(extent={{-30,-10},{30,10}},
        rotation=0,
        origin={202,-92})));
  ClaRa.Visualisation.Quadruple quadruple14
    annotation (Placement(transformation(extent={{-26,-8},{26,8}},
        rotation=0,
        origin={102,-142})));
  ClaRa.Visualisation.StatePoint_phTs statePoint_XRG2
    annotation (Placement(transformation(extent={{142,-162},{158,-146}})));
  ClaRa.Visualisation.StatePoint_phTs statePoint_XRG3
    annotation (Placement(transformation(extent={{142,-118},{158,-102}})));
  ClaRa.Visualisation.StatePoint_phTs statePoint_XRG1
    annotation (Placement(transformation(extent={{-168,-32},{-152,-16}})));

  ClaRa.Visualisation.DynDisplay fuel2(
    x1=time/3600,
    unit="h",
    decimalSpaces=2,
    varname="Time")
    annotation (Placement(transformation(extent={{-218,38},{-186,50}})));
  ClaRa.Visualisation.DynDisplay fuel3(
    decimalSpaces=2,
    varname="condenser level",
    unit="m",
    x1=condenser.shell.summary.outline.level_abs)
    annotation (Placement(transformation(extent={{188,-38},{228,-26}})));
  DetailedSteamPowerPlant_InitCycle NOM(
    P_n=P_n,
    final P_target_=1,
    preheater_HP_p_tap=51.95e5,
    Delta_p_RS_nom=4.91e5,
    tapping_IP_pressure=13e5,
    efficiency_Pump_cond=0.9,
    efficiency_Pump_preheater_LP1=0.8,
    efficiency_Pump_FW=0.9,
    efficiency_Turb_HP=0.93,
    efficiency_Turb_IP=0.93,
    efficiency_Turb_LP1=0.94,
    efficiency_Turb_LP2=0.94) annotation (Placement(transformation(extent={{-306,-200},{-286,-180}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_set annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-248,256}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-82,128})));
  TransiEnt.Components.Visualization.DynDisplay dynDisplay1(x1=(turbine_HP1.summary.outline.P_mech + Turbine_IP.summary.outline.P_mech + Turbine_LP1.summary.outline.P_mech + Turbine_LP2.summary.outline.P_mech)/1e6, unit="MW") annotation (Placement(transformation(extent={{52,154},{272,176}})));
  Modelica.Blocks.Sources.RealExpression P_out(y=P_output)
    annotation (Placement(transformation(
        extent={{-20,-11},{20,11}},
        rotation=0,
        origin={146,92})));
  TransiEnt.Components.Boundaries.Mechanical.Power prescribedPower(change_sign=true) annotation (Placement(transformation(extent={{176,66},{196,86}})));
  TransiEnt.Components.Mechanical.ConstantInertia constantInertia(
    omega(fixed=false, start=2*50*Modelica.Constants.pi),
    J=10e6,
    P_n=P_n) annotation (Placement(transformation(extent={{202,66},{222,86}})));

    replaceable TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp constrainedby TransiEnt.Basics.Interfaces.Electrical.PartialPowerPort "Choice of power port" annotation (Dialog(group="Replaceable Components"),choicesAllMatching=true, Placement(transformation(extent={{336,98},{356,118}}), iconTransformation(extent={{80,42},{110,70}})));
  replaceable TransiEnt.Components.Electrical.Machines.ActivePowerGenerator Generator(eta=0.9856) constrainedby TransiEnt.Components.Electrical.Machines.Base.PartialActivePowerGenerator "Choice of generator model. The generator model must match the power port."
                                                                                                                                                                                          annotation (Dialog(group="Replaceable Components"),choicesAllMatching=true, Placement(transformation(
        extent={{-12.5,-12},{12.5,12}},
        rotation=0,
        origin={257.5,76})));

  replaceable TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem Exciter constrainedby TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.PartialExcitationSystem "Choice of excitation system model with voltage control"
                                                                                                                                                                                                        annotation (Dialog(group="Replaceable Components"),choicesAllMatching=true, Placement(transformation(
        extent={{10,-10.5},{-10,10.5}},
        rotation=0,
        origin={288,113})));
  ClaRa.Visualisation.Quadruple quadruple15
    annotation (Placement(transformation(extent={{46,-16},{106,4}})));
  ClaRa.Visualisation.Quadruple quadruple16
    annotation (Placement(transformation(extent={{170,-14},{230,6}})));
  Modelica.Blocks.Math.Gain gain1(
                                 k=-1/P_n) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-248,216})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=1) annotation (Placement(transformation(extent={{-194,178},{-182,190}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=0.03)
                                                      annotation (Placement(transformation(extent={{-120,178},{-108,190}})));
  Modelica.Blocks.Logical.Switch switch_limitPn annotation (Placement(transformation(extent={{-158,174},{-138,194}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=1) annotation (Placement(transformation(extent={{-194,190},{-174,210}})));
  Modelica.Blocks.Logical.Switch switch_limitShutdown annotation (Placement(transformation(extent={{-90,174},{-70,194}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=0) annotation (Placement(transformation(extent={{-128,190},{-108,210}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold1(threshold=P_min/P_n)
                                                       annotation (Placement(transformation(extent={{-62,178},{-50,190}})));
  Modelica.Blocks.Logical.Switch switch_limitMinimumLoad annotation (Placement(transformation(extent={{-12,174},{8,194}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=P_min/P_n)
                                                              annotation (Placement(transformation(extent={{-86,196},{-66,216}})));
  Modelica.Blocks.Logical.And and1 annotation (Placement(transformation(extent={{-40,178},{-28,190}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold1(threshold=0.03)
                                                                         annotation (Placement(transformation(extent={{-62,162},{-50,174}})));
  Modelica.Blocks.Math.Add add(k2=-1) annotation (Placement(transformation(extent={{-210,78},{-200,88}})));
  Modelica.Blocks.Math.Gain gain2(k=1/P_n) annotation (Placement(transformation(
        extent={{4,-4},{-4,4}},
        rotation=180,
        origin={-236,66})));
  Modelica.Blocks.Sources.RealExpression P_el_actual(y=-Generator.epp.P) annotation (Placement(transformation(
        extent={{-20,-11},{20,11}},
        rotation=0,
        origin={-276,66})));
  Modelica.Blocks.Continuous.PID PID_Qfuel(
    Td=0,
    Ti=30,
    k=0.07) annotation (Placement(transformation(extent={{-192,72},{-174,90}})));
  Modelica.Blocks.Math.Gain Nominal_PowerFeedwaterPump2(k=NOM.Pump_FW.P_pump)
    annotation (Placement(transformation(extent={{-102,-188},{-82,-168}})));
  Modelica.Blocks.Math.Max max annotation (Placement(transformation(extent={{-160,-182},{-140,-162}})));
  Modelica.Blocks.Math.Max max1 annotation (Placement(transformation(extent={{-130,-188},{-110,-168}})));
  Modelica.Blocks.Sources.RealExpression P_set_pump_FW1(y=1)                                 annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=0,
        origin={-165,-197})));
  Modelica.Blocks.Sources.RealExpression P_set_pump_FW(y=steamGenerator_1_XRG.heatRelease.y) annotation (Placement(transformation(
        extent={{-42,-11.5},{42,11.5}},
        rotation=0,
        origin={-268,-142.5})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y=0) annotation (Placement(transformation(extent={{-86,212},{-66,232}})));
  Modelica.Blocks.Logical.Switch switch_SetValueMinimumLoad annotation (Placement(transformation(extent={{-54,204},{-34,224}})));
  Modelica.Blocks.Sources.BooleanExpression block_SetValueMinimumLoad(y=SetValueMinimumLoad)       annotation (Placement(transformation(extent={{-112,204},{-92,224}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
  if (turbine_HP1.summary.outline.P_mech + Turbine_IP.summary.outline.P_mech + Turbine_LP1.summary.outline.P_mech + Turbine_LP2.summary.outline.P_mech-Pump_FW.P_drive)/P_n<=0.03 then
    P_output=0;
  else
    P_output=turbine_HP1.summary.outline.P_mech + Turbine_IP.summary.outline.P_mech + Turbine_LP1.summary.outline.P_mech + Turbine_LP2.summary.outline.P_mech-Pump_FW.P_drive;//-Pump_preheater_LP1.P_drive-Pump_cond.P_drive
  end if;
  efficiency=-epp.P/(steamGenerator_1_XRG.heatRelease.y*steamGenerator_1_XRG.Q_flow_F_nom);
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(steamGenerator_1_XRG.reheat_out, Turbine_IP.inlet)
                                                            annotation (Line(
      points={{-129.6,88},{-12,88},{-12,54}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(Pump_FW.inlet, feedWaterTank.feedwater)
                                            annotation (Line(
      points={{-56,-138},{-8,-138}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(turbine_HP1.inlet, steamGenerator_1_XRG.livesteam)
                                                           annotation (Line(
      points={{-58,54},{-58,90},{-138,90},{-138,88}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(Pump_FW.outlet, preheater_HP.In2) annotation (Line(
      points={{-76,-138},{-138,-138},{-138,-50}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(preheater_HP.Out2, steamGenerator_1_XRG.feedwater) annotation (Line(
      points={{-138,-30},{-138,50.475}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve1_HP.outlet, preheater_HP.In1)
                                             annotation (Line(
      points={{-88,-22},{-88,-40},{-130.2,-40}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(preheater_HP.Out2, statePoint_XRG.port) annotation (Line(
      points={{-138,-30},{-138,18},{-158,18}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(preheater_LP1.In1, valve_LP1.outlet) annotation (Line(
      points={{162,-114.2},{162,-52}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(preheater_LP1.In2, Pump_cond.outlet) annotation (Line(
      points={{172,-122},{192,-122}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(preheater_LP1.Out1, Pump_preheater_LP1.inlet) annotation (Line(
      points={{162,-134},{162,-170},{102,-170}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(PI_Pump_preheater2.y,valve2_HP. opening_in) annotation (Line(
      points={{-167,-62},{-68,-62},{-68,-73}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const2.y, PI_Pump_preheater2.u_m) annotation (Line(
      points={{-187,-92},{-178,-92},{-178,-74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const3.y, PI_Pump_cond.u_s) annotation (Line(
      points={{241,-152},{234,-152}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(measurement.u, condenser_relLevel.y) annotation (Line(
      points={{264,-182},{274,-182}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(measurement.y, PI_Pump_cond.u_m) annotation (Line(
      points={{241,-182},{221.9,-182},{221.9,-164}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(join_LP1.inlet, Turbine_LP1.outlet) annotation (Line(
      points={{152,22},{98,22}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_LP1.outlet1, Turbine_LP2.inlet) annotation (Line(
      points={{172,22},{232,22}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_LP1.outlet2, valve_LP1.inlet) annotation (Line(
      points={{162,12},{162,-32}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Turbine_IP.outlet, join_IP.inlet) annotation (Line(
      points={{-2,38},{24,38}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_IP.outlet1, Turbine_LP1.inlet) annotation (Line(
      points={{44,38},{88,38}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_IP.outlet2, valve_IP.inlet) annotation (Line(
      points={{34,28},{34,-32}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_HP.inlet, turbine_HP1.outlet) annotation (Line(
      points={{-76,18},{-38,18},{-38,38},{-48,38}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_HP.outlet1, steamGenerator_1_XRG.reheat_in) annotation (Line(
      points={{-96,18},{-129.6,18},{-129.6,50.475}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_HP.outlet2, valve1_HP.inlet) annotation (Line(
      points={{-86,8},{-86,4},{-88,4},{-88,-2}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve_LP2.inlet, preheater_LP1.Out2) annotation (Line(
      points={{112,-122},{152,-122}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(valve_LP2.outlet, join_LP_main.inlet1) annotation (Line(
      points={{92,-122},{72,-122}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(PI_Pump_cond.y, Pump_cond.P_drive) annotation (Line(
      points={{211,-152},{202,-152},{202,-134}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PI_preheater1.u_s, const_reheater_LP1_relLevel.y) annotation (Line(
      points={{124,-192},{141,-192}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preheater_LP1_relLevel.y, PI_preheater1.u_m) annotation (Line(
      points={{120,-222},{111.8,-222},{111.8,-204},{111.9,-204}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PI_preheater1.y, Pump_preheater_LP1.P_drive) annotation (Line(
      points={{101,-192},{92,-192},{92,-182}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(steamGenerator_1_XRG.eye_LS, quadruple2.eye) annotation (Line(
      points={{-143.6,88.7125},{-143.6,108},{-218,108}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(steamGenerator_1_XRG.eye_RH, quadruple1.eye) annotation (Line(
      points={{-124,88.7125},{-124,108},{-118,108}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(turbine_HP1.eye, quadruple4.eye) annotation (Line(
      points={{-47,42},{-38,42},{-38,108}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(Turbine_IP.eye, quadruple3.eye) annotation (Line(
      points={{-1,42},{2,42},{2,68},{12,68}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(Turbine_LP1.eye, quadruple7.eye) annotation (Line(
      points={{99,26},{102,26},{102,58},{112,58}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(Turbine_LP2.eye, quadruple.eye) annotation (Line(
      points={{243,10},{250,10}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple6.eye, feedWaterTank.eye) annotation (Line(
      points={{-14,-162},{-14,-150},{-4,-150},{-4,-139}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple8.eye, valve_IP.eye) annotation (Line(
      points={{44,-62},{38,-62},{38,-52}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple9.eye, valve_LP1.eye) annotation (Line(
      points={{172,-62},{166,-62},{166,-52}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple10.eye, valve_LP2.eye) annotation (Line(
      points={{72,-102},{68,-102},{68,-114},{92,-114},{92,-118}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(valve1_HP.eye, quadruple11.eye) annotation (Line(
      points={{-84,-22},{-84,-21.7},{-80,-21.7},{-80,-32}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple12.eye, valve2_HP.eye) annotation (Line(
      points={{-98,-104},{-32,-104},{-32,-86},{-58,-86}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple13.eye, Pump_cond.eye) annotation (Line(
      points={{172,-92},{172,-116},{191,-116}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(quadruple14.eye, Pump_preheater_LP1.eye) annotation (Line(
      points={{76,-142},{70,-142},{70,-164},{81,-164}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(statePoint_XRG2.port, Pump_preheater_LP1.inlet) annotation (Line(
      points={{142,-162},{142,-170},{102,-170}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(statePoint_XRG3.port, preheater_LP1.Out2) annotation (Line(
      points={{142,-118},{142,-122},{152,-122}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(preheater_HP.Out1, valve2_HP.inlet) annotation (Line(
      points={{-150,-40},{-158,-40},{-158,-82},{-78,-82}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(statePoint_XRG1.port, preheater_HP.Out1) annotation (Line(
      points={{-168,-32},{-160,-32},{-160,-40},{-150,-40}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(valve_IP.outlet, feedWaterTank.aux) annotation (Line(
      points={{34,-52},{34,-122}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(feedWaterTank.heatingSteam, valve2_HP.outlet) annotation (Line(
      points={{-2,-120},{-2,-82},{-58,-82}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Pump_preheater_LP1.outlet, join_LP_main.inlet2) annotation (Line(
      points={{82,-170},{62,-170},{62,-132}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(join_LP_main.outlet, feedWaterTank.condensate) annotation (Line(
      points={{52,-122},{38,-122}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(condenser.outlet, Pump_cond.inlet)
    annotation (Line(
      points={{242,-46},{242,-122},{212,-122}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(Turbine_LP2.outlet, condenser.inlet)
    annotation (Line(
      points={{242,6},{242,-22}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.None));
  connect(condenser.eye, quadruple5.eye) annotation (Line(
      points={{246,-47.2},{246,-62},{252,-62}},
      color={190,190,190},
      smooth=Smooth.None));
  connect(condenser.heat, prescribedHeatFlow.port) annotation (Line(
      points={{252,-34},{262,-34}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Q_cond.y, prescribedHeatFlow.Q_flow) annotation (Line(
      points={{294.1,-34},{282,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preheater_HP_relLevel2.y, PI_Pump_preheater2.u_s) annotation (Line(
      points={{-196,-62},{-190,-62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_out.y,prescribedPower. P_mech_set) annotation (Line(
      points={{168,92},{186,92},{186,87.8}},
      color={0,0,127}));
  connect(constantInertia.mpp_a,prescribedPower. mpp) annotation (Line(
      points={{202,76},{196,76}},
      color={95,95,95}));
  connect(constantInertia.mpp_b,Generator. mpp) annotation (Line(
      points={{222,76},{236,76},{236,76},{245,76}},
      color={95,95,95}));
  connect(Generator.epp,epp)  annotation (Line(
      points={{270.125,75.88},{294,75.88},{294,76},{306,76},{306,108},{346,108}},
      color={0,135,135},
      thickness=0.5));

//   ,  experiment(
//       StopTime=20000,
//       __Dymola_NumberOfIntervals=5000,
//       Tolerance=1e-006,
//       __Dymola_Algorithm="Dassl"),
//     __Dymola_experimentSetupOutput
  connect(join_IP.eye[1], quadruple15.eye) annotation (Line(points={{44,32},{46,32},{46,-6}},     color={190,190,190}));
  connect(join_LP1.eye[1], quadruple16.eye) annotation (Line(points={{172,16},{172,16},{172,-4},{170,-4}},     color={190,190,190}));
  connect(greaterThreshold.y, switch_limitPn.u2) annotation (Line(points={{-181.4,184},{-172,184},{-160,184}}, color={255,0,255}));
  connect(realExpression.y, switch_limitPn.u1) annotation (Line(points={{-173,200},{-168,200},{-168,192},{-160,192}}, color={0,0,127}));
  connect(switch_limitPn.u3, greaterThreshold.u) annotation (Line(points={{-160,176},{-168,176},{-168,158},{-202,158},{-202,184},{-195.2,184}}, color={0,0,127}));
  connect(switch_limitPn.y, lessThreshold.u) annotation (Line(points={{-137,184},{-121.2,184}}, color={0,0,127}));
  connect(lessThreshold.y, switch_limitShutdown.u2) annotation (Line(points={{-107.4,184},{-92,184}}, color={255,0,255}));
  connect(realExpression1.y, switch_limitShutdown.u1) annotation (Line(points={{-107,200},{-100,200},{-100,192},{-92,192}}, color={0,0,127}));
  connect(switch_limitPn.y, switch_limitShutdown.u3) annotation (Line(points={{-137,184},{-132,184},{-132,158},{-100,158},{-100,176},{-92,176}}, color={0,0,127}));
  connect(switch_limitShutdown.y, lessThreshold1.u) annotation (Line(points={{-69,184},{-64,184},{-63.2,184}}, color={0,0,127}));
  connect(lessThreshold1.y,and1. u1) annotation (Line(points={{-49.4,184},{-46,184},{-41.2,184}}, color={255,0,255}));
  connect(switch_limitShutdown.y, greaterThreshold1.u) annotation (Line(points={{-69,184},{-66,184},{-66,168},{-63.2,168}}, color={0,0,127}));
  connect(greaterThreshold1.y,and1. u2) annotation (Line(points={{-49.4,168},{-44,168},{-44,179.2},{-41.2,179.2}}, color={255,0,255}));
  connect(and1.y, switch_limitMinimumLoad.u2) annotation (Line(points={{-27.4,184},{-20,184},{-14,184}}, color={255,0,255}));
  connect(switch_limitShutdown.y, switch_limitMinimumLoad.u3) annotation (Line(points={{-69,184},{-66,184},{-66,158},{-20,158},{-20,176},{-14,176}}, color={0,0,127}));
  connect(gain1.u, P_set) annotation (Line(points={{-248,228},{-248,256}}, color={0,0,127}));
  connect(add.u2,gain2. y) annotation (Line(points={{-211,80},{-222,80},{-222,66},{-231.6,66}},
                                                                              color={0,0,127}));
  connect(P_el_actual.y,gain2. u) annotation (Line(points={{-254,66},{-246,66},{-240.8,66}},               color={0,0,127}));
  connect(switch_limitMinimumLoad.y, add.u1) annotation (Line(points={{9,184},{32,184},{32,180},{32,136},{-208,136},{-210,136},{-298,136},{-300,136},{-300,86},{-212,86},{-211,86}},
                                                                                                                                                               color={0,0,127}));
  connect(add.y, PID_Qfuel.u) annotation (Line(points={{-199.5,83},{-199.5,81},{-193.8,81}}, color={0,0,127}));
  connect(max.u1,add. u1) annotation (Line(points={{-162,-166},{-182,-166},{-182,-124},{-298,-124},{-298,86},{-211,86}},                       color={0,0,127}));
  connect(max.y,max1. u1) annotation (Line(points={{-139,-172},{-139,-172},{-132,-172}}, color={0,0,127}));
  connect(Nominal_PowerFeedwaterPump2.u,max1. y) annotation (Line(points={{-104,-178},{-108,-178},{-109,-178}}, color={0,0,127}));
  connect(P_set_pump_FW1.y,max1. u2) annotation (Line(points={{-155.1,-197},{-140,-197},{-140,-184},{-132,-184}}, color={0,0,127}));
  connect(Nominal_PowerFeedwaterPump2.y, Pump_FW.P_drive) annotation (Line(points={{-81,-178},{-66,-178},{-66,-150}}, color={0,0,127}));
  connect(max.u2, P_set_pump_FW.y) annotation (Line(points={{-162,-178},{-192,-178},{-192,-142.5},{-221.8,-142.5}}, color={0,0,127}));
  connect(PID_Qfuel.y, steamGenerator_1_XRG.QF_setl_) annotation (Line(points={{-173.1,81},{-173.1,81.5},{-154.8,81.5},{-154.8,61.875}}, color={0,0,127}));
  connect(gain1.y, greaterThreshold.u) annotation (Line(points={{-248,205},{-248,184},{-195.2,184}}, color={0,0,127}));
  connect(realExpression2.y, switch_SetValueMinimumLoad.u3) annotation (Line(points={{-65,206},{-60.5,206},{-56,206}}, color={0,0,127}));
  connect(switch_SetValueMinimumLoad.u1, realExpression3.y) annotation (Line(points={{-56,222},{-65,222}}, color={0,0,127}));
  connect(switch_SetValueMinimumLoad.y, switch_limitMinimumLoad.u1) annotation (Line(points={{-33,214},{-28,214},{-24,214},{-24,192},{-14,192}}, color={0,0,127}));
  connect(block_SetValueMinimumLoad.y, switch_SetValueMinimumLoad.u2) annotation (Line(points={{-91,214},{-73.5,214},{-56,214}}, color={255,0,255}));
  connect(Exciter.epp1, epp) annotation (Line(
      points={{298,113},{298,108},{346,108}},
      color={0,135,135},
      thickness=0.5));
  connect(Exciter.y, Generator.E_input) annotation (Line(points={{277.4,113},{277.4,112},{257.125,112},{257.125,87.88}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-320,-240},{340,240}}),
                      graphics={
        Rectangle(
          extent={{-282,-160},{-240,-240}},
          lineColor={175,175,175},
          fillColor={215,215,215},
          fillPattern=FillPattern.Sphere),
        Rectangle(
          extent={{-322,-160},{-282,-240}},
          lineColor={175,175,175},
          fillColor={215,215,215},
          fillPattern=FillPattern.Sphere),
        Text(
          extent={{-316,-158},{-288,-178}},
          lineColor={75,75,75},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="CycleINIT"),
        Text(
          extent={{-322,-198},{-282,-218}},
          lineColor={75,75,75},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="CycleSettings"),
        Text(
          extent={{-278,-178},{-244,-196}},
          lineColor={75,75,75},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="Model
Properties")}),                  Icon(graphics,
                                      coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>This model should demonstrate that power plant models with higher level of detail than the first, second and fourth order power plants can be simulated.</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model is based on the following example from the ClaRa library: <span style=\"color: #5500ff;\">ClaRa.Examples.ClaRaClosedLoop</span></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">To allow a relatively simple change of the plant&apos;s nominal power rating, a function between the the live steam mass flow and the plant&apos;s nominal power plant was obtained with EBSILON(R)Professional as follows:</span></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">the model <span style=\"color: #5500ff;\">ClaRa.Examples.ClaRaClosedLoop </span>was reproduced in EBSILON Professional </li>
<li><span style=\"font-family: MS Shell Dlg 2;\">The turbine&apos;s set values were varied from 100 MW to 900 MW </span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">the resulting nominal live steam mass flow values from Ebsilon were imported to Dymola as a reference. The model was then statically simulated in Dymola to find out the resulting nominal power output</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">The nominal power output was plotted as a function of the nominal live steam mass flow. A characteristic equation of the form m_flow=f(P_out) was calculated</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">The InitCycle component of the Dymola model was modified to allow the usage of this equation</span></li>
</ul>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">This plant model is &QUOT;always on&QUOT; meaning that it reacts to power setpoint without delay even if current output is zero</span></li>
<li>Control power provision is not implemented, power output independent of grid frequency</li>
</ul>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Type of electrical power port can be chosen</span></p>
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
<p>Model created by Ricardo Peniche (peniche@tuhh.de)</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model generalized for different electrical power ports by Jan-Peter Heckel (jan.heckel@tuhh.de) in July 2018 </span></p>
</html>"));
end DetailedSteamPowerPlant;
