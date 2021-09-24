within TransiEnt.Producer.Combined.LargeScaleCHP;
model DetailedCHP "Example of how a detailed thermodynamic cycle model of a steam turbine combined heat and power plant can be modeled"


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




  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Producer.Combined.LargeScaleCHP.Base.PartialCHP(final quantity=1);

  Real test3;
  Real test4;
 // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 steamTurbine_HP(
    medium=simCenter.fluid1,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,0.98; 1,1])),
    p_nom=NOM.p_LS_out_nom,
    m_flow_nom=NOM.m_flow_nom,
    rho_nom=NOM.Turbine_HP.rho_in,
    p_in_start=INIT.Turbine_HP.p_in,
    p_out_start=INIT.Turbine_HP.p_out,
    Pi=NOM.Turbine_HP.p_out/NOM.Turbine_HP.p_in) annotation (Placement(transformation(extent={{-324,114},{-314,134}})));

  ClaRa.Visualisation.DynDisplay dynDisplay(
    unit="MW",
    varname="Power output HP turbine",
    x1=steamTurbine_HP.summary.outline.P_mech/1e6)
    annotation (Placement(transformation(extent={{148,-2},{228,20}})));
  ClaRa.SubSystems.Boiler.SteamGenerator_L1 steamGenerator(
    medium=simCenter.fluid1,
    p_LS_nom=NOM.p_LS_out_nom,
    m_flow_nomLS=NOM.m_flow_nom,
    p_RH_nom=NOM.p_RS_out_nom,
    T_LS=NOM.T_LS_nom,
    T_RH_nom=NOM.T_RS_nom,
    Delta_p_nomHP=NOM.Delta_p_LS_nom,
    Delta_p_nomIP=NOM.Delta_p_RS_nom,
    CL_mLS_QF_=NOM.boiler.CharLine_Delta_p_HP_mLS_,
    CL_pLS_QF_=NOM.boiler.CharLine_Delta_p_IP_mRS_)
    annotation (Placement(transformation(extent={{-394,112},{-374,144}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowSource_h(
    medium=simCenter.fluid1,
    m_flow_const=108.326,
    variable_m_flow=true,
    showData=true,
    h_const=NOM.source_steamGenerator.h,
    p_nom=NOM.source_steamGenerator.p)
                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-384,62})));
  Modelica.Blocks.Sources.RealExpression m_flow_boiler(y=1*steamGenerator.QF_setl_*steamGenerator.m_flow_nomLS)
    annotation (Placement(transformation(extent={{-442,36},{-400,58}})));
  ClaRa.Visualisation.Quadruple quadruple3
    annotation (Placement(transformation(extent={{-366,154},{-336,172}})));
  ClaRa.Visualisation.Quadruple quadruple4
    annotation (Placement(transformation(extent={{-398,144},{-428,162}})));
  ClaRa.Visualisation.Quadruple quadruple5
    annotation (Placement(transformation(extent={{-372,54},{-342,72}})));
  ClaRa.Visualisation.DynDisplay dynDisplay1(
    unit="MW",
    varname="Power output MP turbine",
    x1=(steamTurbine_MP1.summary.outline.P_mech + steamTurbine_MP2.summary.outline.P_mech)/1e6)
    annotation (Placement(transformation(extent={{136,50},{212,72}})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y split_MP2_LP_A4(
    medium=simCenter.fluid1,
    preciseTwoPhase=false,
    initOption=0,
    p_nom=NOM.split3_2.p,
    h_nom=NOM.split3_2.h1,
    h_start=INIT.split3_2.h1,
    p_start=INIT.split3_2.p,
    m_flow_out_nom={NOM.split3_2.m_flow_2,NOM.split3_2.m_flow_3})
                  annotation (Placement(transformation(extent={{-236,54},{-216,34}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 steamTurbine_LP(
    medium=simCenter.fluid1,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,0.98; 1,1])),
    p_nom=NOM.Turbine_LP.p_in,
    Pi=NOM.Turbine_LP.p_out/NOM.Turbine_LP.p_in,
    rho_nom=NOM.Turbine_LP.rho_in,
    p_in_start=INIT.Turbine_LP.p_in,
    p_out_start=INIT.Turbine_LP.p_out,
    m_flow_nom=NOM.Turbine_LP.m_flow) annotation (Placement(transformation(extent={{-186,114},{-176,134}})));
  ClaRa.Visualisation.DynDisplay dynDisplay2(
    unit="MW",
    varname="Power output LP turbine",
    x1=steamTurbine_LP.summary.outline.P_mech/1e6)
    annotation (Placement(transformation(extent={{142,104},{216,126}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_ph2(medium=simCenter.fluid1,
    p_const=NOM.sink_green2.p,
    h_const=NOM.sink_green2.h)                                                                                                      annotation (Placement(transformation(
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
  ClaRa.Visualisation.DynDisplay dynDisplay5(
    unit="%",
    varname="Electric efficiency (bruto)",
    x1=(steamTurbine_HP.summary.outline.P_mech + steamTurbine_MP1.summary.outline.P_mech + steamTurbine_MP2.summary.outline.P_mech + steamTurbine_LP.summary.outline.P_mech)/Q_flow_set_SG[1].Q_flow_input*100)
    annotation (Placement(transformation(extent={{124,196},{212,214}})));
  ClaRa.Visualisation.DynDisplay dynDisplay6(
    unit="%",
    varname="Fuel utilization rate",
    x1=(steamTurbine_HP.summary.outline.P_mech + steamTurbine_MP1.summary.outline.P_mech + steamTurbine_MP2.summary.outline.P_mech + steamTurbine_LP.summary.outline.P_mech + (-1*A4.summary.outline.Q_flow) + (-1*A5.summary.outline.Q_flow))/Q_flow_set_SG[1].Q_flow_input*100)
    annotation (Placement(transformation(extent={{156,-146},{236,-100}})));
  ClaRa.Components.HeatExchangers.IdealShell_L2 idealShell_L2_1(medium=simCenter.fluid1, redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (             Delta_p_nom=0.1),
    m_flow_nom=NOM.condenser.m_flow_in,
    p_nom=NOM.condenser.p_in,
    h_nom=NOM.condenser.h_in,
    h_start=INIT.condenser.h_in,
    p_start=INIT.condenser.p_in)                                                                                               annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-176,62})));
  ClaRa.Components.BoundaryConditions.PrescribedHeatFlowScalar
    prescribedHeatFlowScalar
    annotation (Placement(transformation(extent={{-140,52},{-160,72}})));
  TransiEnt.Components.Boundaries.Mechanical.Power prescribedPower(change_sign=true) annotation (Placement(transformation(extent={{-70,18},{-50,38}})));
  Modelica.Blocks.Sources.RealExpression P_out_mech(y=(steamTurbine_HP.summary.outline.P_mech + steamTurbine_MP1.summary.outline.P_mech + steamTurbine_MP2.summary.outline.P_mech + steamTurbine_LP.summary.outline.P_mech)) annotation (Placement(transformation(
        extent={{-23,-10.5},{23,10.5}},
        rotation=0,
        origin={-103,44.5})));
  replaceable TransiEnt.Components.Electrical.Machines.ActivePowerGenerator Generator(eta=1) constrainedby TransiEnt.Components.Electrical.Machines.Base.PartialActivePowerGenerator annotation (Dialog(group="Replaceable Components"),choicesAllMatching=true, Placement(transformation(
        extent={{-12.5,-12},{12.5,12}},
        rotation=0,
        origin={12.5,28})));
  replaceable TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem Exciter constrainedby TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.PartialExcitationSystem annotation (Dialog(group="Replaceable Components"),choicesAllMatching=true, Placement(transformation(
        extent={{-10,-10.5},{10,10.5}},
        rotation=180,
        origin={44.5,60})));
  TransiEnt.Components.Mechanical.ConstantInertia constantInertia(omega(fixed=true, start=2*50*Modelica.Constants.pi), J=10e6) annotation (Placement(transformation(extent={{-44,18},{-24,38}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 steamTurbine_MP1(
    medium=simCenter.fluid1,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,0.98; 1,1])),
    p_nom=NOM.Turbine_IP.p_in,
    m_flow_nom=NOM.Turbine_IP.m_flow,
    Pi=NOM.Turbine_IP.p_out/NOM.Turbine_IP.p_in,
    rho_nom=NOM.Turbine_IP.rho_in,
    p_in_start=INIT.Turbine_IP.p_in,
    p_out_start=INIT.Turbine_IP.p_out) annotation (Placement(transformation(extent={{-302,112},{-292,132}})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y split_MP1_MP2_A5(
    medium=simCenter.fluid1,
    preciseTwoPhase=false,
    initOption=0,
    p_nom=NOM.split3_1.p,
    h_nom=NOM.split3_1.h1,
    h_start=INIT.split3_1.h1,
    p_start=INIT.split3_1.p,
    m_flow_out_nom={NOM.split3_1.m_flow_2,NOM.split3_1.m_flow_3})
                  annotation (Placement(transformation(extent={{-274,54},{-254,34}})));
  ClaRa.Components.TurboMachines.Turbines.SteamTurbineVLE_L1 steamTurbine_MP2(
    medium=simCenter.fluid1,
    redeclare model Efficiency = ClaRa.Components.TurboMachines.Fundamentals.TurbineEfficiency.TableMassFlow (eta_mflow=([0.0,0.98; 1,1])),
    p_nom=NOM.Turbine_IP2.p_in,
    Pi=NOM.Turbine_IP2.p_out/NOM.Turbine_IP2.p_in,
    rho_nom=NOM.Turbine_IP2.rho_in,
    p_in_start=INIT.Turbine_IP2.p_in,
    p_out_start=INIT.Turbine_IP2.p_out,
    m_flow_nom=NOM.Turbine_IP2.m_flow) annotation (Placement(transformation(extent={{-250,112},{-240,132}})));
  ClaRa.Components.HeatExchangers.HEXvle2vle_L3_2ph_CU_simple A4(
    length=10.334,
    diameter=1.924,
    z_in_shell=3.409,
    z_out_shell=0.548,
    N_baffle=0,
    radius_flange=0.65,
    mass_struc=0,
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
    N_tubes=2146,
    length_tubes=9.118,
    redeclare model PressureLossShell =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3 (            Delta_p_nom={0.2e5/3,0.2e5/3,0.2e5/3}),
    redeclare model PressureLossTubes =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (             Delta_p_nom=0.2e5),
    p_nom_tubes=10e5,
    h_nom_tubes=221.2e3,
    h_start_tubes=221.2e3,
    z_in_tubes=0.548,
    z_out_tubes=2.898,
    Out1(m_flow(start=-45.0)),
    p_nom_shell(
      displayUnit="Pa",
      nominal=3e5) = NOM.A4.p_in,
    h_nom_shell=NOM.A4.h_in,
    h_liq_start=INIT.A4.h_in,
    h_vap_start=INIT.A4.h_out,
    p_start_shell=INIT.A4.p_in,
    level_rel_start=0.3,
    p_start_tubes=19.5e5,
    m_flow_nom_shell=NOM.A4_m_flow_nom)
                          annotation (Placement(transformation(extent={{-222,-104},{-202,-84}})));
  ClaRa.Components.HeatExchangers.HEXvle2vle_L3_2ph_CU_simple A5(
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
    p_nom_shell(
      displayUnit="Pa",
      nominal=3e5) = NOM.A5.p_in,
    h_nom_shell=NOM.A5.h_in,
    h_liq_start=INIT.A5.h_in,
    h_vap_start=INIT.A5.h_out,
    p_start_shell=INIT.A5.p_in,
    level_rel_start=0.3,
    p_start_tubes=19e5,
    m_flow_nom_shell=NOM.A5_m_flow_nom)
                         annotation (Placement(transformation(extent={{-224,-44},{-204,-24}})));
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
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi pressureSink_pT_3(
    medium=simCenter.fluid1,
    m_flow_nom=45.3407,
    T_const(displayUnit="degC") = 365.15,
    p_const=0.5e5) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-372,-122})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L2(
    medium=simCenter.fluid1,
    showExpertSummary=true,
    opening_const_=1,
    openingInputIsActive=true,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_incompressible (
        paraOption=2,
        m_flow_nom=45,
        Delta_p_nom=0.5e5,
        rho_in_nom=950))       annotation (Placement(transformation(
        extent={{10,-6},{-10,6}},
        rotation=0,
        origin={-262,-122})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L3(
    medium=simCenter.fluid1,
    opening_const_=1,
    openingInputIsActive=false,
    iCom(rho_in(start=1.0)),
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_compressible (
        paraOption=2,
        m_flow_nom=35,
        Delta_p_nom=30,
        rho_in_nom=0.566))         annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={-214,24})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L5(
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_compressible (Kvs_in=2100),
    opening_const_=1,
    openingInputIsActive=false)
                               annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=270,
        origin={-252,26})));

  ClaRa.Visualisation.Quadruple quadruple1
    annotation (Placement(transformation(extent={{-354,100},{-316,112}})));

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
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L1(
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

  TransiEnt.Producer.Combined.LargeScaleCHP.Base.InitCycle_CHP INIT annotation (Placement(transformation(extent={{-424,-154},{-404,-134}})));
  TransiEnt.Producer.Combined.LargeScaleCHP.Base.InitCycle_CHP NOM annotation (Placement(transformation(extent={{-424,-184},{-404,-164}})));
  Modelica.Blocks.Continuous.LimPID PID_steamGenerator(
    yMax=1,
    yMin=0,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0.5,
    Ti=1,
    Td=0.001,
    k=0.000000000003) annotation (Placement(transformation(extent={{-422,112},{-402,132}})));
  Modelica.Blocks.Sources.RealExpression PowerOutput(y=-epp.P) annotation (Placement(transformation(extent={{-440,74},{-414,98}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(extent={{-324,202},{-344,222}})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pumpVLE_L1_simple annotation (Placement(transformation(extent={{-136,-108},{-156,-88}})));
  Modelica.Blocks.Continuous.LimPID PID_pump_DH(
    yMin=0,
    Ti=1,
    Td=0.001,
    yMax=800000,
    y_start=600000,
    k=100,
    initType=Modelica.Blocks.Types.Init.InitialOutput) annotation (Placement(transformation(extent={{-162,-46},{-142,-66}})));
  ClaRa.Components.Sensors.SensorVLE_L1_p sensorVLE_L1_p annotation (Placement(transformation(extent={{-172,-38},{-152,-18}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_boiler4(y=20e5)
    annotation (Placement(transformation(extent={{-190,-66},{-170,-46}})));
  Modelica.Blocks.Continuous.LimPID PID_HEIKOS(
    yMin=0,
    yMax=2,
    y_start=2,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    k=0.000000000001,
    Ti=1,
    Td=10000) annotation (Placement(transformation(extent={{-400,-38},{-380,-18}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_is_input(y=Q_flow_is) annotation (Placement(transformation(extent={{-428,-58},{-408,-38}})));
  Modelica.Blocks.Math.Add add annotation (Placement(transformation(extent={{-360,-54},{-340,-34}})));
  Modelica.Blocks.Nonlinear.Limiter limiter_A5(uMax=1, uMin=0) annotation (Placement(transformation(extent={{-324,-54},{-304,-34}})));
  Modelica.Blocks.Nonlinear.Limiter limiter_A4(uMax=1, uMin=0) annotation (Placement(transformation(extent={{-324,-20},{-304,0}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_cond(y=-(steamTurbine_LP.summary.outlet.h - TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.bubbleSpecificEnthalpy_pxi(simCenter.fluid1, NOM.p_condenser))*steamTurbine_LP.summary.outlet.m_flow) annotation (Placement(transformation(
        extent={{20,-11},{-20,11}},
        rotation=0,
        origin={-104,62})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L6(
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_compressible (Kvs_in=2100),
    opening_const_=1,
    openingInputIsActive=false)
                               annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=0,
        origin={-266,144})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L4(
    medium=simCenter.fluid1,
    showExpertSummary=true,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_compressible (Kvs_in=2100),
    openingInputIsActive=false,
    opening_const_=1)          annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=0,
        origin={-204,144})));
  Modelica.Blocks.Sources.RealExpression Q_flow_boiler5(y=-1)
    annotation (Placement(transformation(extent={{-400,-76},{-380,-56}})));
equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  Q_flow_input = 0;

 test3=outlet.h_outflow;
 test4=inStream(inlet.h_outflow);
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
      points={{-384,72},{-384,112.4}},
      color={0,131,169},
      thickness=0.5));
  connect(steamGenerator.eye_RH, quadruple3.eye) annotation (Line(
      points={{-374,144.6},{-376,144.6},{-376,163},{-366,163}},
      color={190,190,190}));
  connect(steamGenerator.eye_LS, quadruple4.eye) annotation (Line(
      points={{-388,144.6},{-394,144.6},{-394,153},{-398,153}},
      color={190,190,190}));
  connect(massFlowSource_h.eye, quadruple5.eye) annotation (Line(
      points={{-376,72},{-342,72},{-342,63},{-372,63}},
      color={190,190,190}));
  connect(steamGenerator.livesteam, steamTurbine_HP.inlet) annotation (Line(
      points={{-384,144},{-384,176},{-330,176},{-330,130},{-324,130}},
      color={0,131,169},
      thickness=0.5));
  connect(pressureSink_ph2.eye, quadruple7.eye) annotation (Line(
      points={{-170,34},{-170,32},{-160,32}},
      color={190,190,190}));
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
  connect(P_out_mech.y, prescribedPower.P_mech_set) annotation (Line(points={{-77.7,44.5},{-60,44.5},{-60,39.8}}, color={0,0,127}));
  connect(constantInertia.mpp_b, Generator.mpp) annotation (Line(
      points={{-24,28},{0,28}},
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
  connect(A4.Out1, valveVLE_L2.inlet) annotation (Line(
      points={{-212,-104},{-212,-122},{-252,-122}},
      color={0,131,169},
      thickness=0.5));
  connect(valveVLE_L2.outlet, pressureSink_pT_3.steam_a) annotation (Line(
      points={{-272,-122},{-318,-122},{-362,-122}},
      color={0,131,169},
      thickness=0.5));
  connect(split_MP2_LP_A4.outlet1, valveVLE_L3.inlet) annotation (Line(
      points={{-216,44},{-216,40},{-216,34},{-214,34}},
      color={0,131,169},
      thickness=0.5));
  connect(valveVLE_L3.outlet, A4.In1) annotation (Line(
      points={{-214,14},{-214,4},{-232,4},{-232,-54},{-212,-54},{-212,-84}},
      color={0,131,169},
      thickness=0.5));
  connect(split_MP1_MP2_A5.outlet1, valveVLE_L5.inlet) annotation (Line(
      points={{-254,44},{-252,44},{-252,36}},
      color={0,131,169},
      thickness=0.5));
  connect(valveVLE_L5.outlet, A5.In1) annotation (Line(
      points={{-252,16},{-252,-12},{-214,-12},{-214,-24}},
      color={0,131,169},
      thickness=0.5));
  connect(pressureSink_pT_3.eye, quadruple6.eye) annotation (Line(
      points={{-362,-130},{-362,-130},{-358,-130}},
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
      points={{-218,14},{-212,14},{-212,0},{-206,0}},
      color={190,190,190}));
  connect(A5.Out1, valveVLE_L1.inlet) annotation (Line(
      points={{-214,-44},{-232,-44},{-232,-188},{-252,-188}},
      color={0,131,169},
      thickness=0.5));
  connect(valveVLE_L1.outlet, pressureSink_pT_2.steam_a) annotation (Line(
      points={{-272,-188},{-362,-188}},
      color={0,131,169},
      thickness=0.5));
  connect(split_MP2_LP_A4.eye[1], quadruple19.eye) annotation (Line(
      points={{-216,50},{-212,50},{-212,90}},
      color={190,190,190}));
  connect(Generator.epp, epp) annotation (Line(
      points={{25.125,27.88},{48,27.88},{48,28},{72,28},{72,60},{100,60}},
      color={0,135,135},
      thickness=0.5));
  connect(P_set, Q_flow_set_SG[1].P) annotation (Line(points={{-84,144},{-86,144},{-86,108},{-86,108},{-7.27273,108},{-7.27273,102}},
                                                                                                                       color={0,0,127}));
  connect(m_flow_boiler.y, massFlowSource_h.m_flow) annotation (Line(points={{-397.9,47},{-390,47},{-390,50}},   color={0,0,127}));
  connect(P_set, gain.u) annotation (Line(points={{-84,144},{-86,144},{-86,108},{-124,108},{-124,212},{-322,212}},
                                                                                                        color={0,0,127}));
  connect(A4.In2, pumpVLE_L1_simple.outlet) annotation (Line(
      points={{-202,-98},{-180,-98},{-156,-98}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpVLE_L1_simple.inlet, inlet) annotation (Line(
      points={{-136,-98},{-130,-98},{-130,-90},{-130,-24},{100,-24}},
      color={0,131,169},
      thickness=0.5));
  connect(sensorVLE_L1_p.p, PID_pump_DH.u_m) annotation (Line(points={{-151,-28},{-144,-28},{-144,-38},{-152,-38},{-152,-44}}, color={0,0,127}));
  connect(PID_pump_DH.u_s, Q_flow_boiler4.y) annotation (Line(points={{-164,-56},{-166,-56},{-169,-56}}, color={0,0,127}));
  connect(A5.Out2, T_out_sensor.port) annotation (Line(
      points={{-204,-28},{-174,-28},{-174,4},{78,4},{78,4}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(A4.Out2, A5.In2) annotation (Line(
      points={{-202,-88},{-198,-88},{-196,-88},{-196,-38},{-204,-38}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pumpVLE_L1_simple.P_drive, PID_pump_DH.y) annotation (Line(points={{-146,-86},{-142,-86},{-142,-82},{-138,-82},{-138,-56},{-141,-56}}, color={0,0,127}));
  connect(PID_HEIKOS.u_m, Q_flow_is_input.y) annotation (Line(points={{-390,-40},{-390,-40},{-390,-48},{-407,-48}}, color={0,0,127}));
  connect(PID_HEIKOS.y, add.u1) annotation (Line(points={{-379,-28},{-374,-28},{-370,-28},{-370,-38},{-362,-38}}, color={0,0,127}));
  connect(add.y, limiter_A5.u) annotation (Line(points={{-339,-44},{-332,-44},{-326,-44}}, color={0,0,127}));
  connect(PID_HEIKOS.y, limiter_A4.u) annotation (Line(points={{-379,-28},{-370,-28},{-370,-10},{-326,-10}}, color={0,0,127}));
  connect(prescribedHeatFlowScalar.Q_flow, Q_flow_cond.y) annotation (Line(points={{-140,62},{-136,62},{-126,62}}, color={0,0,127}));
  connect(PID_steamGenerator.y, steamGenerator.QF_setl_) annotation (Line(points={{-401,122},{-401,122},{-396,122}}, color={0,0,127}));
  connect(valveVLE_L2.opening_in, limiter_A4.y) annotation (Line(points={{-262,-113},{-262,-10},{-303,-10}}, color={0,0,127}));
  connect(limiter_A5.y, valveVLE_L1.opening_in) annotation (Line(points={{-303,-44},{-294,-44},{-294,-160},{-284,-160},{-284,-160},{-262,-160},{-262,-179}}, color={0,0,127}));
  connect(valveVLE_L6.outlet, steamTurbine_MP2.inlet) annotation (Line(
      points={{-256,144},{-250,144},{-250,126},{-250,128}},
      color={0,131,169},
      thickness=0.5));
  connect(split_MP1_MP2_A5.outlet2,valveVLE_L6. inlet) annotation (Line(
      points={{-264,54},{-274,54},{-274,62},{-282,62},{-282,144},{-276,144}},
      color={0,131,169},
      thickness=0.5));
  connect(split_MP2_LP_A4.outlet2,valveVLE_L4. inlet) annotation (Line(
      points={{-226,54},{-226,144},{-214,144}},
      color={0,131,169},
      thickness=0.5));
  connect(valveVLE_L4.outlet, steamTurbine_LP.inlet) annotation (Line(
      points={{-194,144},{-186,144},{-186,130}},
      color={0,131,169},
      thickness=0.5));
  connect(add.u2, Q_flow_boiler5.y) annotation (Line(points={{-362,-50},{-372,-50},{-372,-66},{-379,-66}}, color={0,0,127}));
  connect(PowerOutput.y, PID_steamGenerator.u_m) annotation (Line(points={{-412.7,86},{-412,86},{-412,110}}, color={0,0,127}));
  connect(gain.y, PID_steamGenerator.u_s) annotation (Line(points={{-345,212},{-345,212},{-434,212},{-434,122},{-424,122}}, color={0,0,127}));
  connect(A5.Out2, sensorVLE_L1_p.port) annotation (Line(
      points={{-204,-28},{-200,-28},{-176,-28},{-176,-38},{-162,-38}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Q_flow_set_pos[1].y, PID_HEIKOS.u_s) annotation (Line(points={{39.4,110},{38,110},{38,86},{104,86},{104,-204},{-452,-204},{-452,-28},{-402,-28}}, color={0,0,127}));
  connect(Exciter.y, Generator.E_input) annotation (Line(points={{33.9,60},{12,60},{12,52},{12.125,52},{12.125,39.88}}, color={0,0,127}));
  connect(Exciter.epp1, epp) annotation (Line(
      points={{54.5,60},{100,60}},
      color={0,135,135},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-500,-220},{260,240}}),
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
          extent={{-446,22},{-282,10}},
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
    Icon(graphics,
         coordinateSystem(extent={{-500,-220},{260,240}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Although in an early state of development, this model illustrates how a CHP plant can be modeled to increase the level of detail. The usage of the library interfaces allows the exchangability of the model with models of less level of detail. </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_set: input for power in [W] (connector of setpoint input signal)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Q_flow_set: input for heat flow rate in [W]</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">outlet: FluidPortOut</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">inlet: FluidPortIn</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">eye: EyeOut</span></p>
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
