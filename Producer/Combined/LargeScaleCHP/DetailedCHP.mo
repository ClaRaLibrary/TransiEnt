within TransiEnt.Producer.Combined.LargeScaleCHP;
model DetailedCHP "Example of how a detailed thermodynamic cycle model of a steam turbine combined heat and power plant can be modeled"

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

  extends TransiEnt.Producer.Combined.LargeScaleCHP.Base.PartialCHP;

 // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 steamTurbine_HP(
    medium=simCenter.fluid1,
    rho_nom=55.7,
    m_flow_nom=120,
    p_nom=18100000,
    Pi=38.49e5/181e5,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.EfficiencyModels.TableMassFlow (eta_mflow=([0.0,0.98; 1,1])),
    p_in_start=18100000) annotation (Placement(transformation(extent={{-324,114},{-314,134}})));

  ClaRa.Visualisation.DynDisplay dynDisplay(
    unit="MW",
    varname="Power output HP turbine",
    x1=steamTurbine_HP.summary.outline.P_mech/1e6)
    annotation (Placement(transformation(extent={{148,-2},{228,20}})));
  ClaRa.SubSystems.Boiler.SteamGenerator_L1 steamGenerator(
    medium=simCenter.fluid1,
    Delta_p_nomHP=218.482e5 - 184.864e5,
    Delta_p_nomIP=37.75e5 - 37.46e5,
    m_flow_nomLS=112.8,
    p_LS_nom=18486400,
    p_RH_nom=3746000,
    T_LS=808.15,
    T_RH_nom=808.05)
    annotation (Placement(transformation(extent={{-394,112},{-374,144}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h(
    medium=simCenter.fluid1,
    m_flow_const=108.326,
    variable_m_flow=true,
    h_const=1365e3,
    showData=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-382,32})));
  Modelica.Blocks.Sources.RealExpression m_flow_boiler(y=1*Q_flow_boiler.y*
        steamGenerator.m_flow_nomLS)
    annotation (Placement(transformation(extent={{-436,-2},{-394,20}})));
  ClaRa.Visualisation.Quadruple quadruple3
    annotation (Placement(transformation(extent={{-366,154},{-336,172}})));
  ClaRa.Visualisation.Quadruple quadruple4
    annotation (Placement(transformation(extent={{-398,144},{-428,162}})));
  ClaRa.Visualisation.Quadruple quadruple5
    annotation (Placement(transformation(extent={{-370,24},{-340,42}})));
  ClaRa.Visualisation.DynDisplay dynDisplay1(
    unit="MW",
    varname="Power output MP turbine",
    x1=(steamTurbine_MP1.summary.outline.P_mech + steamTurbine_MP2.summary.outline.P_mech)/1e6)
    annotation (Placement(transformation(extent={{136,50},{212,72}})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y split_MP2_LP_A4(
    medium=simCenter.fluid1,
    h_nom=2793e3,
    p_nom=1.034e5,
    preciseTwoPhase=false,
    h_start=2793e3,
    m_flow_out_nom={19,45},
    p_start=1.034e5,
    initOption=0) annotation (Placement(transformation(extent={{-236,54},{-216,34}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 steamTurbine_LP(
    medium=simCenter.fluid1,
    m_flow_nom=21.025,
    rho_nom=0.252,
    Pi=0.017e5/0.472e5,
    p_nom=47200,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.EfficiencyModels.TableMassFlow (eta_mflow=([0.0,0.98; 1,1])),
    p_in_start=47200) annotation (Placement(transformation(extent={{-186,114},{-176,134}})));
  ClaRa.Visualisation.DynDisplay dynDisplay2(
    unit="MW",
    varname="Power output LP turbine",
    x1=steamTurbine_LP.summary.outline.P_mech/1e6)
    annotation (Placement(transformation(extent={{142,104},{216,126}})));
  ClaRa.Visualisation.Quadruple quadruple10
    annotation (Placement(transformation(extent={{-140,-214},{-108,-198}})));
  ClaRa.Visualisation.Quadruple quadruple14
    annotation (Placement(transformation(extent={{-146,-138},{-114,-122}})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L2_affinity pump_1(
    medium=simCenter.fluid1,
    steadyStateTorque=false,
    clearSection=0.01,
    exp_rpm=0.15,
    exp_flow=2.8,
    showExpertSummary=true,
    rpm_fixed=4600,
    Tau_stab=1e-2,
    volume_fluid=0.02,
    eta_hyd_nom=0.82,
    useMechanicalPort=true,
    J=10,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2,
    rpm_nom=3000,
    h_start=470.0e3,
    m_flow_nom=600,
    p_start(displayUnit="Pa") = 20.0e5,
    V_flow_max=0.608 + 0.2,
    Delta_p_max=22e5 - 9.81e5,
    p_nom=2000000,
    initOption=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-114,-106})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L2_affinity pump_2(
    medium=simCenter.fluid1,
    steadyStateTorque=false,
    clearSection=0.01,
    exp_rpm=0.15,
    exp_flow=2.8,
    showExpertSummary=true,
    rpm_fixed=4600,
    Tau_stab=1e-2,
    eta_hyd_nom=0.82,
    useMechanicalPort=true,
    J=10,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L2,
    h_start=226640,
    rpm_nom=3000,
    volume_fluid=0.2,
    m_flow_nom=600,
    V_flow_max=0.2 + 0.586,
    Delta_p_max=2.0e5 + 10e5 - 4.5e5,
    p_nom=1000000,
    p_start(displayUnit="Pa") = 11.5e5,
    initOption=0) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-114,-178})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_ph2(medium=simCenter.fluid1, p_const=0.115e5, h_const=55.575e3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-178,24})));
  ClaRa.Visualisation.Quadruple quadruple7
    annotation (Placement(transformation(extent={{-160,24},{-124,40}})));
  ClaRa.Visualisation.DynDisplay dynDisplay3(
    unit="MW",
    varname="Total generated Power ",
    x1=(steamTurbine_HP.summary.outline.P_mech + steamTurbine_MP1.summary.outline.P_mech + steamTurbine_MP2.summary.outline.P_mech + steamTurbine_LP.summary.outline.P_mech)/1e6)
    annotation (Placement(transformation(extent={{126,154},{210,172}})));
  Modelica.Mechanics.Rotational.Sources.Speed shaft(useSupport=false)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-98,-72})));
  Modelica.Blocks.Sources.RealExpression Q_flow_boiler(y=Q_flow_set_SG.Q_flow_input/363e6)
    annotation (Placement(transformation(extent={{-426,110},{-406,130}})));
  ClaRa.Visualisation.DynDisplay dynDisplay5(
    unit="%",
    varname="Electric efficiency (bruto)",
    x1=(steamTurbine_HP.summary.outline.P_mech + steamTurbine_MP1.summary.outline.P_mech + steamTurbine_MP2.summary.outline.P_mech + steamTurbine_LP.summary.outline.P_mech)/Q_flow_set_SG.Q_flow_input*100)
    annotation (Placement(transformation(extent={{124,196},{212,214}})));
  ClaRa.Visualisation.DynDisplay dynDisplay6(
    unit="%",
    varname="Fuel utilization rate",
    x1=(steamTurbine_HP.summary.outline.P_mech + steamTurbine_MP1.summary.outline.P_mech + steamTurbine_MP2.summary.outline.P_mech + steamTurbine_LP.summary.outline.P_mech + (-1*A4.summary.outline.Q_flow) + (-1*A5.summary.outline.Q_flow))/Q_flow_set_SG.Q_flow_input*100)
    annotation (Placement(transformation(extent={{156,-146},{236,-100}})));
  ClaRa.Components.HeatExchangers.IdealShell_L2 idealShell_L2_1(medium=simCenter.fluid1, redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (             Delta_p_nom=0.1)) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-176,62})));
  ClaRa.Components.BoundaryConditions.PrescribedHeatFlowScalar
    prescribedHeatFlowScalar
    annotation (Placement(transformation(extent={{-140,52},{-160,72}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_cond(y=-46.939e6) annotation (
      Placement(transformation(
        extent={{20,-11},{-20,11}},
        rotation=0,
        origin={-104,62})));
  TransiEnt.Components.Boundaries.Mechanical.Power prescribedPower(change_sign=true) annotation (Placement(transformation(extent={{-70,18},{-50,38}})));
  Modelica.Blocks.Sources.RealExpression P_out(y=(steamTurbine_HP.summary.outline.P_mech
         + steamTurbine_MP1.summary.outline.P_mech + steamTurbine_MP2.summary.outline.P_mech
         + steamTurbine_LP.summary.outline.P_mech))
    annotation (Placement(transformation(
        extent={{-20,-11},{20,11}},
        rotation=0,
        origin={-100,44})));
  TransiEnt.Components.Electrical.Machines.ActivePowerGenerator Generator(eta=1) annotation (choicesAllMatching=true, Placement(transformation(
        extent={{-12.5,-12},{12.5,12}},
        rotation=0,
        origin={11.5,28})));
  TransiEnt.Components.Mechanical.ConstantInertia constantInertia(J=10e6, w(fixed=false, start=2*50*Modelica.Constants.pi)) annotation (Placement(transformation(extent={{-44,18},{-24,38}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 steamTurbine_MP1(
    medium=simCenter.fluid1,
    m_flow_nom=105,
    rho_nom=10.08,
    Pi=4.272e5/36.707e5,
    p_nom=3670700,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.EfficiencyModels.TableMassFlow (eta_mflow=([0.0,0.98; 1,1])),
    p_in_start=3670700) annotation (Placement(transformation(extent={{-302,112},{-292,132}})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y split_MP1_MP2_A5(
    medium=simCenter.fluid1,
    h_nom=2931e3,
    h_start=2931e3,
    preciseTwoPhase=false,
    m_flow_out_nom={40,64},
    p_nom=4.27e5,
    p_start=4.27e5,
    initOption=0) annotation (Placement(transformation(extent={{-274,54},{-254,34}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 steamTurbine_MP2(
    medium=simCenter.fluid1,
    m_flow_nom=77,
    rho_nom=1.5,
    p_nom=427200,
    Pi=1.034e5/4.272e5,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.EfficiencyModels.TableMassFlow (eta_mflow=([0.0,0.98; 1,1])),
    p_in_start=4.272e5) annotation (Placement(transformation(extent={{-250,112},{-240,132}})));
  ClaRa.Components.HeatExchangers.HEXvle2vle_L3_2ph_CU_ntu A4(
    length=10.334,
    diameter=1.924,
    z_in_shell=3.409,
    z_out_shell=0.548,
    N_baffle=0,
    radius_flange=0.65,
    mass_struc=0,
    m_flow_nom_shell=45.3407,
    N_passes=2,
    diameter_i=0.022,
    diameter_o=0.025,
    Q_flow_nom=105e6,
    redeclare model HeatTransfer_Shell =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 (                      alpha_nom={13560,13560}),
    redeclare model WallMaterial = TILMedia.SolidTypes.TILMedia_Steel,
    redeclare model HeatTransferTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (                      alpha_nom=8725.7),
    m_flow_nom_tubes=600,
    h_nom_shell=2727e3,
    N_tubes=2146,
    length_tubes=9.118,
    redeclare model PressureLossShell =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (            Delta_p_nom={0.2e5/3,0.2e5/3,0.2e5/3}),
    redeclare model PressureLossTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (             Delta_p_nom=0.2e5),
    p_nom_tubes=10e5,
    h_nom_tubes=221.2e3,
    h_start_tubes=221.2e3,
    p_nom_shell(
      displayUnit="Pa",
      nominal=3e5) = 1.81e5,
    z_in_tubes=0.548,
    z_out_tubes=2.898,
    Out1(m_flow(start=-45.0)),
    p_start_shell=1.008e5 - 0.2e5,
    p_start_tubes=11.0e5) annotation (Placement(transformation(extent={{-222,-104},{-202,-84}})));
  ClaRa.Components.HeatExchangers.HEXvle2vle_L3_2ph_CU_ntu A5(
    N_baffle=0,
    mass_struc=0,
    N_passes=2,
    diameter_i=0.022,
    diameter_o=0.025,
    Q_flow_nom=105e6,
    redeclare model WallMaterial = TILMedia.SolidTypes.TILMedia_Steel,
    m_flow_nom_tubes=600,
    redeclare model PressureLossShell =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (            Delta_p_nom={0.2e5/3,0.2e5/3,0.2e5/3}),
    p_nom_tubes=10e5,
    length=9.381,
    diameter=1.824,
    z_in_shell=3.259,
    z_out_shell=0.523,
    radius_flange=0.639,
    m_flow_nom_shell=47.013,
    p_nom_shell(
      displayUnit="Pa",
      nominal=3e5) = 4.272e5,
    h_nom_shell=2830.12e3,
    p_start_shell=4.272e5,
    redeclare model HeatTransfer_Shell =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L3 (                      alpha_nom={10372,10372}),
    redeclare model HeatTransferTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L2 (                      alpha_nom=9776.5),
    length_tubes=8.214,
    N_tubes=2248,
    z_in_tubes=0.523,
    z_out_tubes=2.773,
    h_nom_tubes=395.85e3,
    h_start_tubes=395.85e3,
    redeclare model PressureLossTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (             Delta_p_nom=0.2e5),
    p_start_tubes=9.8e5) annotation (Placement(transformation(extent={{-224,-44},{-204,-24}})));
  ClaRa.Visualisation.DynDisplay dynDisplay4(
    unit="MW_th",
    decimalSpaces=2,
    x1=(-1*A4.summary.outline.Q_flow/1e6) + (-1*A5.summary.outline.Q_flow/1e6),
    varname="A4+A5 total transfered heat (both)")
    annotation (Placement(transformation(extent={{142,-70},{254,-36}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi pressureSink_pT_2(
    medium=simCenter.fluid1,
    m_flow_nom=45.3407,
    p_const=3.95e5,
    T_const(displayUnit="degC") = 417.41) annotation (Placement(transformation(
        extent={{-7,-10},{7,10}},
        rotation=0,
        origin={-369,-188})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=3600,
    offset=1,
    startTime=2*3600,
    height=0) annotation (Placement(transformation(extent={{-300,-166},{-280,-144}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi pressureSink_pT_3(
    medium=simCenter.fluid1,
    m_flow_nom=45.3407,
    T_const(displayUnit="degC") = 365.15,
    p_const=0.5e5) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-376,-122})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1 valveVLE_L2(
    medium=simCenter.fluid1,
    showExpertSummary=true,
    opening_const_=1,
    openingInputIsActive=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticNominalPoint (
        Delta_p_nom=0.5e5,
        rho_in_nom=950,
        m_flow_nom=45))        annotation (Placement(transformation(
        extent={{10,-6},{-10,6}},
        rotation=0,
        origin={-260,-122})));
  Modelica.Blocks.Sources.Ramp ramp3(
    duration=3600,
    offset=1,
    startTime=2*3600,
    height=0)
    annotation (Placement(transformation(extent={{-300,-102},{-280,-80}})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1 valveVLE_L3(
    medium=simCenter.fluid1,
    opening_const_=1,
    openingInputIsActive=false,
    iCom(rho_in(start=1.0)),
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticNominalPoint (
        Delta_p_nom=30,
        rho_in_nom=0.566,
        m_flow_nom=35))            annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={-216,24})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1 valveVLE_L4(
    medium=simCenter.fluid1,
    showExpertSummary=true,
    redeclare model PressureLoss =
   ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticKV (
         Kvs=2100),
    openingInputIsActive=false,
    opening_const_=1)          annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=0,
        origin={-204,140})));
  Modelica.Blocks.Sources.Ramp ramp2(
    duration=2,
    startTime=3000,
    height=0*500*2*3.1416/60,
    offset=3000*2*3.1416/60)
    annotation (Placement(transformation(extent={{-120,-6},{-100,14}})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1 valveVLE_L5(
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticKV (
         Kvs=2100),
    opening_const_=1,
    openingInputIsActive=false)
                               annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={-252,26})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1 valveVLE_L6(
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticKV (
         Kvs=2100),
    opening_const_=1,
    openingInputIsActive=false)
                               annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=0,
        origin={-264,138})));

  ClaRa.Visualisation.Quadruple quadruple1
    annotation (Placement(transformation(extent={{-354,100},{-316,112}})));

  ClaRa.Visualisation.Quadruple quadruple2
    annotation (Placement(transformation(extent={{-290,176},{-252,188}})));
  ClaRa.Visualisation.Quadruple quadruple6
    annotation (Placement(transformation(extent={{-358,-136},{-320,-124}})));
  ClaRa.Visualisation.Quadruple quadruple8
    annotation (Placement(transformation(extent={{-356,-200},{-318,-188}})));
  ClaRa.Visualisation.Quadruple quadruple9
    annotation (Placement(transformation(extent={{-240,176},{-202,188}})));
  ClaRa.Visualisation.Quadruple quadruple11
    annotation (Placement(transformation(extent={{-176,176},{-138,188}})));
  ClaRa.Visualisation.Quadruple quadruple12
    annotation (Placement(transformation(extent={{-300,10},{-262,22}})));
  ClaRa.Visualisation.Quadruple quadruple13
    annotation (Placement(transformation(extent={{-206,-6},{-168,6}})));
  ClaRa.Visualisation.Quadruple quadruple15
    annotation (Placement(transformation(extent={{-182,-34},{-144,-22}})));
  ClaRa.Visualisation.Quadruple quadruple16
    annotation (Placement(transformation(extent={{-178,-62},{-140,-50}})));
  ClaRa.Visualisation.Quadruple quadruple17
    annotation (Placement(transformation(extent={{-176,-102},{-138,-90}})));
  ClaRa.Visualisation.Quadruple quadruple18
    annotation (Placement(transformation(extent={{-178,-128},{-140,-116}})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1 valveVLE_L7(
    opening_const_=1,
    openingInputIsActive=false,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticNominalPoint (
        Delta_p_nom=0.2e5,
        rho_in_nom=950,
        m_flow_nom=600),
    fluidIn(d(start=900.0)),
    useStabilisedMassFlow=true)
                               annotation (Placement(transformation(
        extent={{10,-6},{-10,6}},
        rotation=270,
        origin={-194,-72})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1 valveVLE_L1(
    medium=simCenter.fluid1,
    showExpertSummary=true,
    opening_const_=1,
    openingInputIsActive=true,
    redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticNominalPoint (
        Delta_p_nom=0.5e5,
        rho_in_nom=950,
        m_flow_nom=45),
    iCom(rho_in(start=900.0))) annotation (Placement(transformation(
        extent={{10,-6},{-10,6}},
        rotation=0,
        origin={-262,-188})));
  ClaRa.Visualisation.Quadruple quadruple19
    annotation (Placement(transformation(extent={{-212,84},{-174,96}})));

equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  Q_flow_input = Q_flow_boiler.y;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(steamTurbine_HP.eye, quadruple1.eye) annotation (Line(
      points={{-313,118},{-332,118},{-332,106},{-354,106}},
      color={190,190,190}));
  connect(steamTurbine_HP.outlet, steamGenerator.reheat_in) annotation (Line(
      points={{-314,114},{-314,84},{-378,84},{-378,112.4}},
      color={0,131,169},
      thickness=0.5));
  connect(massFlowSource_h.steam_a, steamGenerator.feedwater) annotation (Line(
      points={{-382,42},{-384,42},{-384,112.4}},
      color={0,131,169},
      thickness=0.5));
  connect(steamGenerator.eye_RH, quadruple3.eye) annotation (Line(
      points={{-374,144.6},{-376,144.6},{-376,163},{-366,163}},
      color={190,190,190}));
  connect(steamGenerator.eye_LS, quadruple4.eye) annotation (Line(
      points={{-388,144.6},{-394,144.6},{-394,153},{-398,153}},
      color={190,190,190}));
  connect(massFlowSource_h.eye, quadruple5.eye) annotation (Line(
      points={{-374,42},{-340,42},{-340,33},{-370,33}},
      color={190,190,190}));
  connect(steamGenerator.livesteam, steamTurbine_HP.inlet) annotation (Line(
      points={{-384,144},{-384,176},{-330,176},{-330,130},{-324,130}},
      color={0,131,169},
      thickness=0.5));
  connect(pump_2.eye, quadruple10.eye) annotation (Line(
      points={{-125,-172},{-125,-206},{-140,-206}},
      color={190,190,190}));
  connect(pump_1.eye, quadruple14.eye) annotation (Line(
      points={{-103,-112},{-146,-112},{-146,-130}},
      color={190,190,190}));
  connect(pressureSink_ph2.eye, quadruple7.eye) annotation (Line(
      points={{-170,34},{-170,32},{-160,32}},
      color={190,190,190}));
  connect(shaft.flange, pump_2.shaft) annotation (Line(
      points={{-98,-82},{-98,-134},{-114,-134},{-114,-187.9}},
      color={0,0,0}));
  connect(shaft.flange, pump_1.shaft) annotation (Line(
      points={{-98,-82},{-98,-90},{-114,-90},{-114,-96.1}},
      color={0,0,0}));
  connect(idealShell_L2_1.inlet, steamTurbine_LP.outlet) annotation (Line(
      points={{-176,72},{-176,114}},
      color={0,131,169},
      thickness=0.5));
  connect(idealShell_L2_1.outlet, pressureSink_ph2.steam_a) annotation (Line(
      points={{-176,52},{-176,34},{-178,34}},
      color={0,131,169},
      thickness=0.5));
  connect(idealShell_L2_1.heat, prescribedHeatFlowScalar.port) annotation (Line(
      points={{-166,62},{-160,62}},
      color={167,25,48},
      thickness=0.5));
  connect(prescribedHeatFlowScalar.Q_flow, Q_flow_cond.y) annotation (Line(
      points={{-140,62},{-126,62}},
      color={0,0,127}));
  connect(P_out.y, prescribedPower.P_mech_set) annotation (Line(
      points={{-78,44},{-60,44},{-60,39.8}},
      color={0,0,127}));
  connect(constantInertia.mpp_b, Generator.mpp) annotation (Line(
      points={{-24,28},{-10,28},{-10,27.4},{-1.625,27.4}},
      color={95,95,95}));
  connect(constantInertia.mpp_a, prescribedPower.mpp) annotation (Line(
      points={{-44,28},{-50,28}},
      color={95,95,95}));
  connect(steamGenerator.reheat_out, steamTurbine_MP1.inlet) annotation (Line(
      points={{-378,144},{-378,148},{-302,148},{-302,128}},
      color={0,131,169},
      thickness=0.5));
  connect(steamTurbine_MP1.outlet, split_MP1_MP2_A5.inlet) annotation (Line(
      points={{-292,112},{-292,44},{-274,44}},
      color={0,131,169},
      thickness=0.5));
  connect(steamTurbine_MP2.outlet, split_MP2_LP_A4.inlet) annotation (Line(
      points={{-240,112},{-240,44},{-236,44}},
      color={0,131,169},
      thickness=0.5));
  connect(pump_2.outlet, A4.In2) annotation (Line(
      points={{-124,-178},{-190,-178},{-190,-98},{-202,-98}},
      color={0,131,169},
      thickness=0.5));
  connect(A5.Out2, pump_1.inlet) annotation (Line(
      points={{-204,-28},{-136,-28},{-136,-106},{-124,-106}},
      color={0,131,169},
      thickness=0.5));
  connect(ramp3.y,valveVLE_L2. opening_in) annotation (Line(
      points={{-279,-91},{-258.5,-91},{-258.5,-113},{-260,-113}},
      color={0,0,127}));
  connect(A4.Out1, valveVLE_L2.inlet) annotation (Line(
      points={{-212,-104},{-212,-122},{-250,-122}},
      color={0,131,169},
      thickness=0.5));
  connect(valveVLE_L2.outlet, pressureSink_pT_3.steam_a) annotation (Line(
      points={{-270,-122},{-366,-122}},
      color={0,131,169},
      thickness=0.5));
  connect(split_MP2_LP_A4.outlet1, valveVLE_L3.inlet) annotation (Line(
      points={{-216,44},{-216,34}},
      color={0,131,169},
      thickness=0.5));
  connect(valveVLE_L3.outlet, A4.In1) annotation (Line(
      points={{-216,14},{-216,4},{-232,4},{-232,-54},{-212,-54},{-212,-84.2}},
      color={0,131,169},
      thickness=0.5));
  connect(split_MP2_LP_A4.outlet2, valveVLE_L4.inlet) annotation (Line(
      points={{-226,54},{-226,140},{-214,140}},
      color={0,131,169},
      thickness=0.5));
  connect(valveVLE_L4.outlet, steamTurbine_LP.inlet) annotation (Line(
      points={{-194,140},{-186,140},{-186,130}},
      color={0,131,169},
      thickness=0.5));
  connect(split_MP1_MP2_A5.outlet1, valveVLE_L5.inlet) annotation (Line(
      points={{-254,44},{-252,44},{-252,36}},
      color={0,131,169},
      thickness=0.5));
  connect(valveVLE_L5.outlet, A5.In1) annotation (Line(
      points={{-252,16},{-252,-12},{-214,-12},{-214,-24.2}},
      color={0,131,169},
      thickness=0.5));
  connect(valveVLE_L6.outlet, steamTurbine_MP2.inlet) annotation (Line(
      points={{-254,138},{-252,138},{-252,128},{-250,128}},
      color={0,131,169},
      thickness=0.5));
  connect(split_MP1_MP2_A5.outlet2, valveVLE_L6.inlet) annotation (Line(
      points={{-264,54},{-278,54},{-278,138},{-274,138}},
      color={0,131,169},
      thickness=0.5));
  connect(steamTurbine_MP1.eye, quadruple2.eye) annotation (Line(
      points={{-291,116},{-292,116},{-292,182},{-290,182}},
      color={190,190,190}));
  connect(pressureSink_pT_3.eye, quadruple6.eye) annotation (Line(
      points={{-366,-130},{-358,-130}},
      color={190,190,190}));
  connect(pressureSink_pT_2.eye, quadruple8.eye) annotation (Line(
      points={{-362,-196},{-360,-196},{-360,-194},{-356,-194}},
      color={190,190,190}));
  connect(steamTurbine_MP2.eye, quadruple9.eye) annotation (Line(
      points={{-239,116},{-240,116},{-240,182}},
      color={190,190,190}));
  connect(steamTurbine_LP.eye, quadruple11.eye) annotation (Line(
      points={{-175,118},{-176,118},{-176,182}},
      color={190,190,190}));
  connect(valveVLE_L5.eye, quadruple12.eye) annotation (Line(
      points={{-256,16},{-300,16}},
      color={190,190,190}));
  connect(valveVLE_L3.eye, quadruple13.eye) annotation (Line(
      points={{-220,14},{-212,14},{-212,0},{-206,0}},
      color={190,190,190}));
  connect(A5.eye2, quadruple15.eye) annotation (Line(
      points={{-203,-26},{-192,-26},{-192,-28},{-182,-28}},
      color={190,190,190}));
  connect(A5.eye1, quadruple16.eye) annotation (Line(
      points={{-210,-45},{-206,-45},{-206,-56},{-178,-56}},
      color={190,190,190}));
  connect(A4.eye2, quadruple17.eye) annotation (Line(
      points={{-201,-86},{-190,-86},{-190,-96},{-176,-96}},
      color={190,190,190}));
  connect(A4.eye1, quadruple18.eye) annotation (Line(
      points={{-208,-105},{-194,-105},{-194,-122},{-178,-122}},
      color={190,190,190}));
  connect(A4.Out2, valveVLE_L7.inlet) annotation (Line(
      points={{-202,-88},{-198,-88},{-198,-82},{-194,-82}},
      color={0,131,169},
      thickness=0.5));
  connect(valveVLE_L7.outlet, A5.In2) annotation (Line(
      points={{-194,-62},{-198,-62},{-198,-38},{-204,-38}},
      color={0,131,169},
      thickness=0.5));
  connect(m_flow_boiler.y, massFlowSource_h.m_flow) annotation (Line(
      points={{-391.9,9},{-400.95,9},{-400.95,20},{-388,20}},
      color={0,0,127}));
  connect(Q_flow_boiler.y, steamGenerator.QF_setl_) annotation (Line(
      points={{-405,120},{-412,120},{-412,122},{-396,122}},
      color={0,0,127}));
  connect(A5.Out1, valveVLE_L1.inlet) annotation (Line(
      points={{-214,-44},{-232,-44},{-232,-188},{-252,-188}},
      color={0,131,169},
      thickness=0.5));
  connect(valveVLE_L1.outlet, pressureSink_pT_2.steam_a) annotation (Line(
      points={{-272,-188},{-362,-188}},
      color={0,131,169},
      thickness=0.5));
  connect(ramp1.y, valveVLE_L1.opening_in) annotation (Line(
      points={{-279,-155},{-279,-166.5},{-262,-166.5},{-262,-179}},
      color={0,0,127}));
  connect(ramp2.y, shaft.w_ref) annotation (Line(
      points={{-99,4},{-98,4},{-98,-60}},
      color={0,0,127}));
  connect(split_MP2_LP_A4.eye[1], quadruple19.eye) annotation (Line(
      points={{-216,50},{-212,50},{-212,90}},
      color={190,190,190}));
  connect(pump_1.outlet, outlet) annotation (Line(
      points={{-104,-106},{-104,-106},{-104,-104},{-2,-104},{-2,-26},{62,-26},{62,4},{100,4}},
      color={0,131,169},
      thickness=0.5));
  connect(pump_2.inlet, inlet) annotation (Line(
      points={{-104,-178},{128,-178},{128,-24},{100,-24}},
      color={0,131,169},
      thickness=0.5));
  connect(Generator.epp, epp) annotation (Line(
      points={{24.125,27.88},{48,27.88},{48,28},{60,28},{60,60},{100,60}},
      color={0,135,135},
      thickness=0.5));
  connect(P_set, Q_flow_set_SG.P) annotation (Line(points={{-84,144},{-86,144},{-86,108},{-86,108},{-7,108},{-7,102}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-440,-220},{280,220}}),
                      graphics={
        Text(
          extent={{-246,24},{-202,134}},
          lineColor={0,0,255},
          textString="Tip: Splitter: set \"preciseTwoPhase\" to \"false\"
"),     Text(
          extent={{-346,172},{-284,160}},
          lineColor={0,128,0},
          textString="HP"),
        Text(
          extent={{-312,172},{-250,160}},
          lineColor={0,128,0},
          textString="MP1"),
        Text(
          extent={{-212,172},{-150,160}},
          lineColor={0,128,0},
          textString="LP"),
        Text(
          extent={{-402,-52},{-238,-64}},
          lineColor={0,0,255},
          textString="GruVos A4 und A5 from W1 (FK-Aspen)"),
        Text(
          extent={{-258,166},{-228,154}},
          lineColor={0,128,0},
          textString="MP2
"),     Text(
          extent={{-244,-100},{-222,-112}},
          lineColor={0,0,255},
          textString="A4"),
        Text(
          extent={{-250,-26},{-228,-38}},
          lineColor={0,0,255},
          textString="A5")}),
    Icon(coordinateSystem(extent={{-440,-220},{280,220}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Although in an early state of development, this model illustrates how a CHP plant can be modeled to increase the level of detail. The usage of the library interfaces allows the exchangability of the model with models of less level of detail. </p>
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
end DetailedCHP;
