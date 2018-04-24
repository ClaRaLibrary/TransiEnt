within TransiEnt.Producer.Gas.SteamMethaneReformerSystem;
model SMRSystem_noH2Loop "Steam methane reformer system with sufficient H2 in feed containing prereformer, SMR, WGS, dryer, PSA and heat exchangers"

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter TransiEnt.Basics.Types.TypeOfResource typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Consumer "Type of energy resource for global model statistics";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  replaceable parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_SG_var realGas_ng7_sg constrainedby TILMedia.VLEFluidTypes.BaseVLEFluid "Real NG7_SG gas model" annotation (Dialog(group="Fluid Models"), choicesAllMatching);
  replaceable parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG6_var realGas_sg6 constrainedby TILMedia.VLEFluidTypes.BaseVLEFluid "Real SG6 gas model" annotation (Dialog(group="Fluid Models"), choicesAllMatching);
  replaceable parameter TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG6_var idealGas_sg6 constrainedby TILMedia.GasTypes.BaseGas "Ideal SG6 gas model" annotation (Dialog(group="Fluid Models"), choicesAllMatching);
  replaceable parameter TILMedia.VLEFluidTypes.TILMedia_SplineWater water constrainedby TILMedia.VLEFluidTypes.BaseVLEFluid "VLE water model" annotation(Dialog(group="Fluid Models"), choicesAllMatching);

  parameter SI.Temperature T_preheat=864.18 "Temperature to which the gas mixture and the steam are preheated before the prereformer" annotation(Dialog(group="Heat Exchangers"));
  parameter SI.Temperature T_SG_HEX_out=293.15 "Temperature to which the syngas is cooled down in the water/sg heat exchanger" annotation(Dialog(group="Heat Exchangers"));
  parameter SI.PressureDifference Delta_p_HEX_feed=0 "Pressure loss in the feed preheater" annotation(Dialog(group="Heat Exchangers"));
  parameter SI.PressureDifference Delta_p_HEX_water=0 "Pressure loss in the water preheater" annotation(Dialog(group="Heat Exchangers"));
  parameter SI.PressureDifference Delta_p_HEX_waterSG_water=0 "Pressure loss in the water/sg heat exchanger on the water side" annotation(Dialog(group="Heat Exchangers"));
  parameter SI.PressureDifference Delta_p_HEX_waterSG_SG=0 "Pressure loss in the water/sg heat exchanger on the SG side" annotation(Dialog(group="Heat Exchangers"));

  parameter SI.Volume volume_junction=0.01 "Volume of the junction of feed and water" annotation(Dialog(group="Steam Junction"));
  parameter Boolean steamToCarbonRatioFromTable=false "true if table data is used for the steam to carbon ratio" annotation(Dialog(group="Steam Junction"));
  parameter TransiEnt.Basics.Tables.DataPrivacy datasourceSteamToCarbonRatio=TransiEnt.Basics.Tables.DataPrivacy.isPublic "Source of table data"  annotation (Evaluate=true,HideResult=true,Dialog(enable=not use_absolute_path_SteamToCarbonRatio, group="Steam Junction"));
  parameter String relativepathSteamToCarbonRatio = "gas/SteamToCarbonRatioExampleTimeseries.txt" "Path relative to source directory"
                                                                                                                                     annotation(Evaluate=true, HideResult=true, Dialog(enable=not use_absolute_path_SteamToCarbonRatio, group="Steam Junction"));
  parameter Boolean use_absolute_path_SteamToCarbonRatio = false "Should only be used for testing purposes" annotation (Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true), Dialog(group="Steam Junction"));
  parameter String absolute_path_SteamToCarbonRatio = "" annotation(Evaluate=true, HideResult=true, Dialog(enable=use_absolute_path_SteamToCarbonRatio, group="Steam Junction"));

  parameter SI.PressureDifference Delta_p_prereformer=3e5 "Pressure loss in the prereformer" annotation(Dialog(group="Prereformer"));

  parameter Integer N_cv_SMR=1 "Number of control volumes in the SMR" annotation(Dialog(tab="Steam methane reformer",group="Fundamental Definitions"));
  parameter SI.Efficiency eff_SMR[N_cv_SMR,3]=fill({0.019,0.015,0.021}, N_cv_SMR) "Effectiveness factors for the reactions" annotation(Dialog(tab="Steam methane reformer",group="Fundamental Definitions"));
  parameter SI.PressureDifference Delta_p_SMR=2.3e5 "Total pressure loss over the reactor" annotation(Dialog(tab="Steam methane reformer",group="Fundamental Definitions"));
  parameter Integer pressureCalculation_SMR=2 "Method of pressure calculation" annotation(Dialog(tab="Steam methane reformer",group="Fundamental Definitions"), choices(__Dymola_radioButtons=true,choice=1 "Averaged pressure over the fluid volume",choice=2 "Outlet pressure of the fluid volume"));

  parameter Real N_tube_SMR=176 "Number of tubes" annotation(Dialog(tab="Steam methane reformer",group="Geometry"));
  parameter SI.Diameter dia_tube_i_SMR=0.0795 "Inner tube diameter" annotation(Dialog(tab="Steam methane reformer",group="Geometry"));
  parameter SI.Diameter dia_tube_o_SMR=0.1020 "Outer tube diameter" annotation(Dialog(tab="Steam methane reformer",group="Geometry"));
  parameter SI.Diameter dia_part_SMR=0.0174131 "Equivalent pellet diameter" annotation(Dialog(tab="Steam methane reformer",group="Geometry"));
  parameter SI.Length l_SMR=11.95 "Length of reactor" annotation(Dialog(tab="Steam methane reformer",group="Geometry"));

  parameter SI.VolumeFraction eps_bed_SMR=0.605 "Bed porosity" annotation(Dialog(tab="Steam methane reformer",group="Catalyst"));
  parameter SI.VolumeFraction eps_cat_SMR=0.51963 "Catalyst porosity" annotation(Dialog(tab="Steam methane reformer",group="Catalyst"));
  parameter SI.Density d_cat_SMR=2396.965 "Density of catalyst particle" annotation(Dialog(tab="Steam methane reformer",group="Catalyst"));
  parameter SI.Density d_bed_SMR=d_cat_SMR*(1-eps_bed_SMR) "Density of fixed-bed" annotation(Dialog(tab="Steam methane reformer",group="Catalyst"));
  parameter SI.SpecificHeatCapacity cp_cat_SMR=949.72 "Specific heat capacity of catalyst" annotation(Dialog(tab="Steam methane reformer",group="Catalyst"));

  parameter SI.Area A_refractor_SMR = 1164*N_tube_SMR/176 "Surface area of refractor" annotation(Dialog(tab="Steam methane reformer",group="Heat Transfer"));
  parameter SI.Area A_flame_SMR = 0.01 "Surface area of a flame of one burner" annotation(Dialog(tab="Steam methane reformer",group="Heat Transfer"));
  parameter SI.Emissivity em_gas_SMR = 0.1 "Emissivity of furnace gas" annotation(Dialog(tab="Steam methane reformer",group="Heat Transfer"));
  parameter SI.Emissivity em_flame_SMR = 0.1 "Emissivity of flames" annotation(Dialog(tab="Steam methane reformer",group="Heat Transfer"));
  parameter SI.Emissivity em_tube_SMR = 0.95 "Emissivity of reformer tubes" annotation(Dialog(tab="Steam methane reformer",group="Heat Transfer"));
  parameter SI.Temperature T_adi_SMR = 2200 "Adiabatic flame temperature" annotation(Dialog(tab="Steam methane reformer",group="Heat Transfer"));
  parameter Real N_burner_SMR = 112*N_tube_SMR/176 "Number of burners" annotation(Dialog(tab="Steam methane reformer",group="Heat Transfer"));

  parameter SI.Temperature T_nom_SMR[N_cv_SMR]=(820.574 + 273.15)*ones(N_cv_SMR) "Nominal gas and catalyst temperature in the control volumes of the SMR" annotation(Dialog(tab="Steam methane reformer",group="Nominal Values"));
  parameter SI.Pressure p_nom_SMR[N_cv_SMR]=24.338e5*ones(N_cv_SMR) "Nominal pressure in the control volumes of the SMR" annotation(Dialog(tab="Steam methane reformer",group="Nominal Values"));
  parameter SI.MassFraction xi_nom_SMR[N_cv_SMR,5]=fill({0.0319,0.1893,0.6089,0.0575,0.1073}, N_cv_SMR) "Nominal values for mass fractions in the control volumes of the SMR" annotation(Dialog(tab="Steam methane reformer",group="Nominal Values"));

  parameter Integer initOption_junction=201 "InitOption of the junction of feed and water" annotation (Dialog(tab="Initialization",group="Junction"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=201 "Steady pressure",
      choice=202 "Steady enthalpy",
      choice=208 "Steady pressure and enthalpy",
      choice=210 "Steady density"));
  parameter SI.SpecificEnthalpy h_start_junction=2.13667e6 "Initial specific enthalpy in the junction of feed and water" annotation(Dialog(tab="Initialization",group="Junction"));
  parameter SI.Pressure p_start_junction=29e5 "Initial pressure  in the junction of feed and water" annotation(Dialog(tab="Initialization",group="Junction"));
  parameter SI.MassFraction xi_start_junction[8]={0.0961314,0.0185838,0.00918786,0.034747,0.00354792,0.00311627,0.821655,0} "Initial mass fractions  in the junction of feed and water" annotation(Dialog(tab="Initialization",group="Junction"));

  parameter SI.Temperature T_start_SMR[N_cv_SMR]=(820.574 + 273.15)*ones(N_cv_SMR) "Initial gas and catalyst temperature in the control volumes of the SMR" annotation(Dialog(tab="Initialization",group="Steam Methane Reformer"));
  parameter SI.Pressure p_start_SMR[N_cv_SMR]=24.338e5*ones(N_cv_SMR) "Initial pressure in the control volumes of the SMR" annotation(Dialog(tab="Initialization",group="Steam Methane Reformer"));
  parameter SI.MassFraction xi_start_SMR[N_cv_SMR,5]=fill({0.0319,0.1893,0.6089,0.0575,0.1073}, N_cv_SMR) "Initial values for mass fractions in the SMR" annotation(Dialog(tab="Initialization",group="Steam Methane Reformer"));

  parameter SI.PressureDifference Delta_p_WGS=3.5e5 "Pressure loss in the water gas shift reactor" annotation(Dialog(group="Water Gas Shift Reactor"));
  parameter Real conversionRate_WGS=0.97 "CO conversion rate in the water gas shift reactor" annotation(Dialog(group="Water Gas Shift Reactor"));

  parameter SI.PressureDifference Delta_p_dryer=0 "Pressure loss in the dryer" annotation(Dialog(group="Gas Cleaning"));
  parameter SI.PressureDifference Delta_p_PSA=0.2e5 "Pressure loss in the pressure swing adsorption (on the H2 side)" annotation(Dialog(group="Gas Cleaning"));
  parameter SI.Efficiency eta_H2_PSA=0.8 "Efficiency of the hydrogen separation in the pressure swing adsorption" annotation(Dialog(group="Gas Cleaning"));

  parameter SI.Efficiency eta_mech_pump_H2O=0.97 "Mechanical efficiency of the water pump" annotation(Dialog(group="Water Supply"));
  parameter SI.Efficiency eta_el_pump_H2O=0.98 "Electrical efficiency of the water pump" annotation(Dialog(group="Water Supply"));
  parameter SI.Pressure p_H2O_in=1e5 "Inlet pressure of the water supply" annotation(Dialog(group="Water Supply"));
  parameter SI.Temperature T_H2O_in=293.15 "Inlet temperature of the water supply" annotation(Dialog(group="Water Supply"));

  parameter SI.EnthalpyFlowRate H_flow_H2_n=1e6 "Nominal hydrogen enthalpy flow rate leaving the system" annotation(Dialog(group="Statistics"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_el=simCenter.Cspec_demAndRev_free "Specific demand-related cost per electric energy" annotation (Dialog(group="Demand-related Cost"));
  parameter Real Cspec_demAndRev_other_water=simCenter.Cspec_demAndRev_other_free "Specific cost per cubic meter water" annotation (Dialog(group="Demand-related Cost"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;
  replaceable model CostSpecsGeneral = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Empty constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs
                                                                                                                                                                                                        "General Cost Record" annotation(Dialog(group="Statistics"),choicesAllMatching);
  replaceable model ControllerH2OForReformer = Components.Gas.Reactor.Controller.ControllerH2OForReformer_StoCbeforeSMR  constrainedby TransiEnt.Components.Gas.Reactor.Controller.Base.PartialControllerH2OForReformer
                                                                                                                                                                                                        "Controller for steam for reformer" annotation(Dialog(group="Statistics"),choicesAllMatching);

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=realGas_ng7_sg) annotation (Placement(transformation(extent={{-250,-10},{-230,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut_offGas(Medium=realGas_sg6) annotation (Placement(transformation(extent={{190,90},{210,110}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut_hydrogen(Medium=realGas_sg6) annotation (Placement(transformation(extent={{230,-10},{250,10}})));
  TransiEnt.Basics.Interfaces.Gas.GasMassFlowOut massflow_H2_out annotation (Placement(transformation(extent={{240,70},{260,90}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatFeedPreheater annotation (Placement(transformation(extent={{-210,90},{-190,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatSteamPreheater annotation (Placement(transformation(extent={{-110,90},{-90,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatSMR annotation (Placement(transformation(extent={{-10,90},{10,110}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

protected
  TransiEnt.Components.Gas.Reactor.SteamMethaneReformer_L4 sMR(
    pressureCalculation=pressureCalculation_SMR,
    Delta_p=Delta_p_SMR,
    N_cv=N_cv_SMR,
    eff=eff_SMR,
    N_tube=N_tube_SMR,
    dia_tube_i=dia_tube_i_SMR,
    dia_part=dia_part_SMR,
    l=l_SMR,
    eps_bed=eps_bed_SMR,
    eps_cat=eps_cat_SMR,
    d_cat=d_cat_SMR,
    d_bed=d_bed_SMR,
    cp_cat=cp_cat_SMR,
    T_start=T_start_SMR,
    p_start=p_start_SMR,
    xi_start=xi_start_SMR,
    dia_tube_o=dia_tube_o_SMR,
    A_refractor=A_refractor_SMR,
    A_flame=A_flame_SMR,
    em_gas=em_gas_SMR,
    em_flame=em_flame_SMR,
    em_tube=em_tube_SMR,
    T_adi=T_adi_SMR,
    N_burner=N_burner_SMR,
    T_nom=T_nom_SMR,
    p_nom=p_nom_SMR,
    xi_nom=xi_nom_SMR)     annotation (Placement(transformation(extent={{12,-10},{32,10}})));
  TransiEnt.Basics.Adapters.Gas.Real_to_Ideal real_to_Ideal(real=realGas_sg6, ideal=idealGas_sg6) annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  TransiEnt.Basics.Adapters.Gas.Ideal_to_Real ideal_to_Real(real=realGas_sg6, ideal=idealGas_sg6) annotation (Placement(transformation(extent={{36,-10},{56,10}})));
  TransiEnt.Components.Gas.Reactor.WaterGasShiftReactor_L1 wGS(pressureLoss=Delta_p_WGS, conversion=conversionRate_WGS) annotation (Placement(transformation(extent={{84,-10},{104,10}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor massComp_feed(medium=realGas_ng7_sg, compositionDefinedBy=1) annotation (Placement(transformation(extent={{-180,0},{-160,20}})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massFlow_feed(medium=realGas_ng7_sg) annotation (Placement(transformation(extent={{-156,0},{-136,20}})));
  ControllerH2OForReformer controllerH2OForReformer annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-138,-34})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 junction_feedH2O(
    medium=realGas_ng7_sg,
    volume=volume_junction,
    p_start=p_start_junction,
    xi_start=xi_start_junction,
    h_start=h_start_junction,
    initOption=initOption_junction)
                                  annotation (Placement(transformation(extent={{-132,10},{-112,-10}})));
  TransiEnt.Components.Gas.Reactor.Prereformer_L1 prereformer(pressureLoss=Delta_p_prereformer) annotation (Placement(transformation(extent={{-84,-10},{-64,10}})));
  TransiEnt.Basics.Adapters.Gas.RealNG7_SG_to_RealSG6 realNG7_SG_to_RealSG6_1(medium_ng7_sg=realGas_ng7_sg, medium_sg6=realGas_sg6) annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  TransiEnt.Components.Gas.HeatExchanger.HEXOneRealGasOneFluidIdeal_L1 heatExchanger_SynGasH2O(
    mediumRealGas=realGas_sg6,
    mediumFluid=water,
    Delta_p_realGas=Delta_p_HEX_waterSG_SG,
    Delta_p_fluid=Delta_p_HEX_waterSG_water,
    T_out_fixed=T_SG_HEX_out) annotation (Placement(transformation(extent={{108,-10},{128,10}})));
  TransiEnt.Components.Gas.GasCleaning.PressureSwingAdsorptionReactor_L1 pSA(pressureLoss=Delta_p_PSA, eta_h2=eta_H2_PSA) annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  TransiEnt.Components.Gas.GasCleaning.Dryer_L1 dryer(pressureLoss=Delta_p_dryer,
    medium_water=water,
    positionOfWater=3,
    medium_gas=realGas_sg6)                                                       annotation (Placement(transformation(extent={{156,-10},{176,10}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi     sink_H2O(
    T_const(displayUnit="K"),
  p_const=100000,
    medium=water)   annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={166,26})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi          source_H2O(
    medium=water,
    p_const=p_H2O_in,
    T_const(displayUnit="degC") = T_H2O_in)
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={118,-52})));
  TransiEnt.Components.Gas.HeatExchanger.HEXOneRealGasOuterTIdeal_L1 heatExchanger_feed(
    T_fluidOut(displayUnit="degC") = T_preheat,
    Delta_p=Delta_p_HEX_feed,
    medium=realGas_ng7_sg) annotation (Placement(transformation(extent={{-210,-10},{-190,10}})));
  TransiEnt.Components.Gas.HeatExchanger.HEXOneRealGasOuterTIdeal_L1 heatExchanger_H2O(
    T_fluidOut(displayUnit="degC") = T_preheat,
    Delta_p=Delta_p_HEX_water,
    medium=realGas_ng7_sg) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-100,44})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massFlow_H2(medium=realGas_sg6) annotation (Placement(transformation(extent={{204,0},{224,20}})));
  Components.Heat.PumpVLE_L1_simple pump_H2O(
    presetVariableType="m_flow",
    m_flowInput=true,
    medium=water,
    eta_mech=eta_mech_pump_H2O,
    eta_el=eta_el_pump_H2O,
    redeclare model CostSpecsGeneral = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Empty,
    Cspec_demAndRev_el=Cspec_demAndRev_el) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={118,-26})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectCostsGeneral collectCosts(
    der_E_n=H_flow_H2_n,
    E_n=0,
    redeclare model CostRecordGeneral = CostSpecsGeneral (size1=H_flow_H2_n),
    Cspec_demAndRev_other=Cspec_demAndRev_other_water,
    other_flow=-(source_H2O.steam_a.m_flow + sink_H2O.steam_a.m_flow),
    produces_P_el=false,
    consumes_P_el=false,
    produces_Q_flow=false,
    consumes_Q_flow=false,
    produces_H_flow=false,
    consumes_H_flow=false,
    produces_other_flow=false,
    produces_m_flow_CDE=false,
    consumes_m_flow_CDE=false)                                         annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector(m=N_cv_SMR) annotation (Placement(transformation(extent={{-10,80},{10,60}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensorDryGas moleCompDryGasBeforePreRe(
    medium=realGas_ng7_sg,
    compositionDefinedBy=2,
    indexWater=7) annotation (Placement(transformation(extent={{-108,0},{-88,20}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensorDryGas moleCompDryGasBeforeSMR(
    compositionDefinedBy=2,
    medium=realGas_sg6,
    indexWater=3) annotation (Placement(transformation(extent={{-36,0},{-16,20}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensorDryGas moleCompDryGasBeforeWGS(
    compositionDefinedBy=2,
    medium=realGas_sg6,
    indexWater=3) annotation (Placement(transformation(extent={{60,0},{80,20}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensorDryGas moleCompDryGasBeforeDryer(
    compositionDefinedBy=2,
    medium=realGas_sg6,
    indexWater=3) annotation (Placement(transformation(extent={{132,0},{152,20}})));
  TransiEnt.Basics.Adapters.Gas.RealH2O_to_RealNG7_SG realH2O_to_RealNG7_SG(medium_water=water, medium_ng7_sg=realGas_ng7_sg) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={118,26})));

public
  Summary summary(
    outline(
      m_waterIn=source_H2O_m,
      m_waterOut=sink_H2O_m,
      Delta_m_water=source_H2O_m+sink_H2O_m,
      P_el_pump=pump_H2O.summary.outline.P_el,
      W_el_puimp=pump_H2O.summary.outline.W_el),
    gasPortIn(
      mediumModel=heatExchanger_feed.summary.gasPortIn.mediumModel,
      xi=heatExchanger_feed.summary.gasPortIn.xi,
      x=heatExchanger_feed.summary.gasPortIn.x,
      m_flow=heatExchanger_feed.summary.gasPortIn.m_flow,
      T=heatExchanger_feed.summary.gasPortIn.T,
      p=heatExchanger_feed.summary.gasPortIn.p,
      h=heatExchanger_feed.summary.gasPortIn.h,
      rho=heatExchanger_feed.summary.gasPortIn.rho),
    gasAfterHEX1(
      mediumModel=heatExchanger_feed.summary.gasPortOut.mediumModel,
      xi=heatExchanger_feed.summary.gasPortOut.xi,
      x=heatExchanger_feed.summary.gasPortOut.x,
      m_flow=heatExchanger_feed.summary.gasPortOut.m_flow,
      T=heatExchanger_feed.summary.gasPortOut.T,
      p=heatExchanger_feed.summary.gasPortOut.p,
      h=heatExchanger_feed.summary.gasPortOut.h,
      rho=heatExchanger_feed.summary.gasPortOut.rho),
    gasAfterMix(
      mediumModel=junction_feedH2O.summary.gasPort3.mediumModel,
      xi=junction_feedH2O.summary.gasPort3.xi,
      x=junction_feedH2O.summary.gasPort3.x,
      m_flow=junction_feedH2O.summary.gasPort3.m_flow,
      T=junction_feedH2O.summary.gasPort3.T,
      p=junction_feedH2O.summary.gasPort3.p,
      h=junction_feedH2O.summary.gasPort3.h,
      rho=junction_feedH2O.summary.gasPort3.rho),
    gasSMRIn(
      mediumModel=sMR.summary.gasPortIn.mediumModel,
      xi=sMR.summary.gasPortIn.xi,
      x=sMR.summary.gasPortIn.x,
      m_flow=sMR.summary.gasPortIn.m_flow,
      T=sMR.summary.gasPortIn.T,
      p=sMR.summary.gasPortIn.p,
      h=sMR.summary.gasPortIn.h,
      rho=sMR.summary.gasPortIn.rho),
    gasSMRBulk(
      N_cv=sMR.summary.gasBulk.N_cv,
      mediumModel=sMR.summary.gasBulk.mediumModel,
      xi=sMR.summary.gasBulk.xi,
      x=sMR.summary.gasBulk.x,
      mass=sMR.summary.gasBulk.mass,
      T=sMR.summary.gasBulk.T,
      p=sMR.summary.gasBulk.p,
      h=sMR.summary.gasBulk.h,
      rho=sMR.summary.gasBulk.rho),
    gasSMROut(
      mediumModel=sMR.summary.gasPortOut.mediumModel,
      xi=sMR.summary.gasPortOut.xi,
      x=sMR.summary.gasPortOut.x,
      m_flow=sMR.summary.gasPortOut.m_flow,
      T=sMR.summary.gasPortOut.T,
      p=sMR.summary.gasPortOut.p,
      h=sMR.summary.gasPortOut.h,
      rho=sMR.summary.gasPortOut.rho),
    gasAfterWGS(
      mediumModel=wGS.summary.gasPortOut.mediumModel,
      xi=wGS.summary.gasPortOut.xi,
      x=wGS.summary.gasPortOut.x,
      m_flow=wGS.summary.gasPortOut.m_flow,
      T=wGS.summary.gasPortOut.T,
      p=wGS.summary.gasPortOut.p,
      h=wGS.summary.gasPortOut.h,
      rho=wGS.summary.gasPortOut.rho),
    gasAfterHEX2(
      mediumModel=heatExchanger_SynGasH2O.summary.gasPortOut.mediumModel,
      xi=heatExchanger_SynGasH2O.summary.gasPortOut.xi,
      x=heatExchanger_SynGasH2O.summary.gasPortOut.x,
      m_flow=heatExchanger_SynGasH2O.summary.gasPortOut.m_flow,
      T=heatExchanger_SynGasH2O.summary.gasPortOut.T,
      p=heatExchanger_SynGasH2O.summary.gasPortOut.p,
      h=heatExchanger_SynGasH2O.summary.gasPortOut.h,
      rho=heatExchanger_SynGasH2O.summary.gasPortOut.rho),
    gasAfterDryer(
      mediumModel=dryer.summary.gasPortOut.mediumModel,
      xi=dryer.summary.gasPortOut.xi,
      x=dryer.summary.gasPortOut.x,
      m_flow=dryer.summary.gasPortOut.m_flow,
      T=dryer.summary.gasPortOut.T,
      p=dryer.summary.gasPortOut.p,
      h=dryer.summary.gasPortOut.h,
      rho=dryer.summary.gasPortOut.rho),
    gasPortOutOffGas(
      mediumModel=pSA.summary.gasPortOut_offGas.mediumModel,
      xi=pSA.summary.gasPortOut_offGas.xi,
      x=pSA.summary.gasPortOut_offGas.x,
      m_flow=pSA.summary.gasPortOut_offGas.m_flow,
      T=pSA.summary.gasPortOut_offGas.T,
      p=pSA.summary.gasPortOut_offGas.p,
      h=pSA.summary.gasPortOut_offGas.h,
      rho=pSA.summary.gasPortOut_offGas.rho),
    gasPortOutHydrogen(
      mediumModel=pSA.summary.gasPortOut_hydrogen.mediumModel,
      xi=pSA.summary.gasPortOut_hydrogen.xi,
      x=pSA.summary.gasPortOut_hydrogen.x,
      m_flow=pSA.summary.gasPortOut_hydrogen.m_flow,
      T=pSA.summary.gasPortOut_hydrogen.T,
      p=pSA.summary.gasPortOut_hydrogen.p,
      h=pSA.summary.gasPortOut_hydrogen.h,
      rho=pSA.summary.gasPortOut_hydrogen.rho),
    molarDryCompositions(
      molarDryCompAfterMix=moleCompDryGasBeforePreRe.fractionDry,
      molarDryCompSMRIn=moleCompDryGasBeforeSMR.fractionDry,
      molarDryCompSMROut=moleCompDryGasBeforeWGS.fractionDry,
      molarDryCompAfterHEX2=moleCompDryGasBeforeDryer.fractionDry),
    waterIn(
      mediumModel=pump_H2O.summary.fluidPortIn.mediumModel,
      xi=pump_H2O.summary.fluidPortIn.xi,
      x=pump_H2O.summary.fluidPortIn.x,
      m_flow=pump_H2O.summary.fluidPortIn.m_flow,
      T=pump_H2O.summary.fluidPortIn.T,
      p=pump_H2O.summary.fluidPortIn.p,
      h=pump_H2O.summary.fluidPortIn.h,
      rho=pump_H2O.summary.fluidPortIn.rho),
    waterAfterHEX2(
      mediumModel=heatExchanger_SynGasH2O.summary.fluidPortOut.mediumModel,
      xi=heatExchanger_SynGasH2O.summary.fluidPortOut.xi,
      x=heatExchanger_SynGasH2O.summary.fluidPortOut.x,
      m_flow=heatExchanger_SynGasH2O.summary.fluidPortOut.m_flow,
      T=heatExchanger_SynGasH2O.summary.fluidPortOut.T,
      p=heatExchanger_SynGasH2O.summary.fluidPortOut.p,
      h=heatExchanger_SynGasH2O.summary.fluidPortOut.h,
      rho=heatExchanger_SynGasH2O.summary.fluidPortOut.rho),
    waterAfterHEX3(
      mediumModel=heatExchanger_H2O.summary.gasPortOut.mediumModel,
      xi=heatExchanger_H2O.summary.gasPortOut.xi,
      x=heatExchanger_H2O.summary.gasPortOut.x,
      m_flow=heatExchanger_H2O.summary.gasPortOut.m_flow,
      T=heatExchanger_H2O.summary.gasPortOut.T,
      p=heatExchanger_H2O.summary.gasPortOut.p,
      h=heatExchanger_H2O.summary.gasPortOut.h,
      rho=heatExchanger_H2O.summary.gasPortOut.rho),
    heatFeedPreheater(
      Q_flow=heatExchanger_feed.summary.heat.Q_flow,
      T=heatExchanger_feed.summary.heat.T),
    heatWaterPreheater(
      Q_flow=heatExchanger_H2O.summary.heat.Q_flow,
      T=heatExchanger_H2O.summary.heat.T),
    heatSMR(
      N_cv=sMR.summary.heat.N_cv,
      Q_flow=sMR.summary.heat.Q_flow,
      T_flueGas=sMR.summary.heat.T_flueGas,
      T_wall_i=sMR.summary.heat.T_wall_i,
      T_wall_o=sMR.summary.heat.T_wall_o)) annotation (Placement(transformation(extent={{-200,-100},{-180,-80}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Real expressionSteamToCarbonRatio=4.8 "Desired molar ratio of H2O to C for the steam controller" annotation(Dialog(group="Steam Junction"));

  SI.Mass source_H2O_m(start=0, fixed=true) "Mass from the water source";
  SI.Mass sink_H2O_m(start=0, fixed=true) "Mass into the water sink";

protected
  model Outline
    extends TransiEnt.Basics.Icons.Record;
    input SI.Mass m_waterIn "Water entering the system";
    input SI.Mass m_waterOut "Water leaving the system";
    input SI.Mass Delta_m_water "Total water usage";
    input SI.Power P_el_pump "Electric power of the water pump";
    input SI.Work W_el_puimp "Electric work of the water pump";
  end Outline;

  model MolarDryCompositions
    extends TransiEnt.Basics.Icons.Record;
    input SI.MassFraction molarDryCompAfterMix[9] "Molar dry composition after the feed water mixer";
    input SI.MassFraction molarDryCompSMRIn[6] "Molar dry composition at the inlet of the SMR";
    input SI.MassFraction molarDryCompSMROut[6] "Molar dry composition at the outlet of the SMR";
    input SI.MassFraction molarDryCompAfterHEX2[6] "Molar dry composition after the syngas water heat exchanger";
  end MolarDryCompositions;

  model HeatSMR
    extends TransiEnt.Basics.Icons.Record;
    parameter Integer N_cv "Number of control volumes";
    input SI.HeatFlowRate Q_flow[N_cv] "Heat flow rate";
    input SI.Temperature T_flueGas[N_cv] "Flue gas temperature";
    input SI.Temperature T_wall_o[N_cv] "Outer wall temperature";
    input SI.Temperature T_wall_i[N_cv] "Inner wall temperature";
  end HeatSMR;

  model Summary
    extends TransiEnt.Basics.Icons.Record;
    Outline outline;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeRealGas gasAfterHEX1;
    TransiEnt.Basics.Records.FlangeRealGas gasAfterMix;
    TransiEnt.Basics.Records.FlangeIdealGas gasSMRIn;
    TransiEnt.Basics.Records.IdealGasBulk_L4 gasSMRBulk;
    TransiEnt.Basics.Records.FlangeIdealGas gasSMROut;
    TransiEnt.Basics.Records.FlangeRealGas gasAfterWGS;
    TransiEnt.Basics.Records.FlangeRealGas gasAfterHEX2;
    TransiEnt.Basics.Records.FlangeRealGas gasAfterDryer;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOutOffGas;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOutHydrogen;
    MolarDryCompositions molarDryCompositions;
    TransiEnt.Basics.Records.FlangeRealGas waterIn;
    TransiEnt.Basics.Records.FlangeRealGas waterAfterHEX2;
    TransiEnt.Basics.Records.FlangeRealGas waterAfterHEX3;
    TransiEnt.Basics.Records.FlangeHeat heatFeedPreheater;
    TransiEnt.Basics.Records.FlangeHeat heatWaterPreheater;
    HeatSMR heatSMR;
  end Summary;

public
  Modelica.Blocks.Sources.RealExpression realExpression(y=expressionSteamToCarbonRatio)
                                                                             annotation (Placement(transformation(extent={{-220,-78},{-200,-58}})));
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(extent={{-182,-62},{-162,-42}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=steamToCarbonRatioFromTable)        annotation (Placement(transformation(extent={{-220,-62},{-200,-42}})));
  Basics.Tables.GenericDataTable tableSteamToCarbonRatio(
    change_of_sign=false,
    datasource=datasourceSteamToCarbonRatio,
    relativepath=relativepathSteamToCarbonRatio,
    use_absolute_path=use_absolute_path_SteamToCarbonRatio,
    absolute_path=absolute_path_SteamToCarbonRatio)                annotation (Placement(transformation(extent={{-220,-36},{-200,-16}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  der(sink_H2O_m)=-sink_H2O.steam_a.m_flow;
  der(source_H2O_m)=-source_H2O.steam_a.m_flow;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(collectCosts.costsCollector, modelStatistics.costsCollector);
  connect(sMR.gasPortOut,ideal_to_Real. gasPortIn) annotation (Line(
      points={{32,0},{32,0},{36,0}},
      color={255,213,170},
      thickness=1.5));
  connect(real_to_Ideal.gasPortOut,sMR. gasPortIn) annotation (Line(
      points={{8,0},{12,0}},
      color={255,213,170},
      thickness=1.5));
  connect(controllerH2OForReformer.m_flow_feed, massFlow_feed.m_flow) annotation (Line(points={{-134,-24},{-134,-24},{-134,10},{-135,10}}, color={0,0,127}));
  connect(massComp_feed.fraction, controllerH2OForReformer.massComposition) annotation (Line(points={{-159,10},{-156,10},{-156,-8},{-142,-8},{-142,-24}}, color={0,0,127}));
  connect(prereformer.gasPortOut,realNG7_SG_to_RealSG6_1. gasPortIn) annotation (Line(
      points={{-64,0},{-64,0},{-60,0}},
      color={255,255,0},
      thickness=1.5));
  connect(dryer.gasPortOut, pSA.gasPortIn) annotation (Line(
      points={{176,0},{180,0}},
      color={255,255,0},
      thickness=1.5));
  connect(massComp_feed.gasPortOut, massFlow_feed.gasPortIn) annotation (Line(
      points={{-160,0},{-160,0},{-156,0}},
      color={255,255,0},
      thickness=1.5));
  connect(pSA.gasPortOut_hydrogen, massFlow_H2.gasPortIn) annotation (Line(
      points={{200,0},{204,0}},
      color={255,255,0},
      thickness=1.5));
connect(massFlow_feed.gasPortOut, junction_feedH2O.gasPort1) annotation (Line(
    points={{-136,0},{-132,0}},
    color={255,255,0},
    thickness=1.5));
  connect(heatExchanger_feed.gasPortIn, gasPortIn) annotation (Line(
      points={{-210,0},{-240,0}},
      color={255,255,0},
      thickness=1.5));
  connect(massFlow_H2.gasPortOut, gasPortOut_hydrogen) annotation (Line(
      points={{224,0},{240,0}},
      color={255,255,0},
      thickness=1.5));
  connect(massFlow_H2.m_flow, massflow_H2_out) annotation (Line(points={{225,10},{226,10},{226,80},{250,80}},          color={0,0,127}));
  connect(heatSteamPreheater, heatExchanger_H2O.heat) annotation (Line(points={{-100,100},{-100,80},{-100,54}},       color={191,0,0}));
  connect(heatFeedPreheater, heatExchanger_feed.heat) annotation (Line(points={{-200,100},{-200,80},{-200,10}},           color={191,0,0}));
  connect(thermalCollector.port_b, heatSMR) annotation (Line(points={{0,80},{0,80},{0,100}}, color={191,0,0}));
  connect(thermalCollector.port_a, sMR.heat) annotation (Line(points={{0,60},{22,60},{22,10}},       color={191,0,0}));
  connect(gasPortOut_offGas, pSA.gasPortOut_offGas) annotation (Line(
      points={{200,100},{196,100},{196,82},{196,7}},
      color={255,255,0},
      thickness=1.5));
connect(junction_feedH2O.gasPort3, moleCompDryGasBeforePreRe.gasPortIn) annotation (Line(
    points={{-112,0},{-108,0}},
    color={255,255,0},
    thickness=1.5));
  connect(moleCompDryGasBeforePreRe.gasPortOut, prereformer.gasPortIn) annotation (Line(
      points={{-88,0},{-84,0}},
      color={255,255,0},
      thickness=1.5));
  connect(realNG7_SG_to_RealSG6_1.gasPortOut, moleCompDryGasBeforeSMR.gasPortIn) annotation (Line(
      points={{-40,0},{-38,0},{-36,0}},
      color={255,255,0},
      thickness=1.5));
  connect(moleCompDryGasBeforeSMR.gasPortOut, real_to_Ideal.gasPortIn) annotation (Line(
      points={{-16,0},{-12,0}},
      color={255,255,0},
      thickness=1.5));
  connect(ideal_to_Real.gasPortOut, moleCompDryGasBeforeWGS.gasPortIn) annotation (Line(
      points={{56,0},{60,0}},
      color={255,255,0},
      thickness=1.5));
  connect(moleCompDryGasBeforeWGS.gasPortOut, wGS.gasPortIn) annotation (Line(
      points={{80,0},{84,0}},
      color={255,255,0},
      thickness=1.5));
  connect(moleCompDryGasBeforeDryer.gasPortOut, dryer.gasPortIn) annotation (Line(
      points={{152,0},{156,0}},
      color={255,255,0},
      thickness=1.5));
  connect(heatExchanger_feed.gasPortOut, massComp_feed.gasPortIn) annotation (Line(
      points={{-190,0},{-190,0},{-180,0}},
      color={255,255,0},
      thickness=1.5));
  connect(pump_H2O.fluidPortIn, source_H2O.steam_a) annotation (Line(
      points={{118,-36},{118,-42}},
      color={175,0,0},
      thickness=0.5));
  connect(heatExchanger_H2O.gasPortIn, realH2O_to_RealNG7_SG.gasPortOut) annotation (Line(
      points={{-90,44},{118,44},{118,36}},
      color={255,255,0},
      thickness=1.5));
  connect(heatExchanger_H2O.gasPortOut, junction_feedH2O.gasPort2) annotation (Line(
      points={{-110,44},{-122,44},{-122,10}},
      color={255,255,0},
      thickness=1.5));
  connect(wGS.gasPortOut, heatExchanger_SynGasH2O.gasPortIn) annotation (Line(
      points={{104,0},{106,0},{108,0}},
      color={255,255,0},
      thickness=1.5));
  connect(heatExchanger_SynGasH2O.gasPortOut, moleCompDryGasBeforeDryer.gasPortIn) annotation (Line(
      points={{128,0},{130,0},{132,0}},
      color={255,255,0},
      thickness=1.5));
  connect(heatExchanger_SynGasH2O.fluidPortIn, pump_H2O.fluidPortOut) annotation (Line(
      points={{118,-10},{118,-13},{118,-16}},
      color={175,0,0},
      thickness=0.5));
  connect(realH2O_to_RealNG7_SG.waterPortIn, heatExchanger_SynGasH2O.fluidPortOut) annotation (Line(
      points={{118,16},{118,16},{118,10}},
      color={175,0,0},
      thickness=0.5));
  connect(dryer.fluidPortOut, sink_H2O.steam_a) annotation (Line(
      points={{166,10},{166,13},{166,16}},
      color={175,0,0},
      thickness=0.5));
  connect(controllerH2OForReformer.m_flow_steam, pump_H2O.m_flow_in) annotation (Line(points={{-128,-34},{107,-34}}, color={0,0,127}));
  connect(switch1.y, controllerH2OForReformer.desiredMolarRatio) annotation (Line(points={{-161,-52},{-161,-52},{-138,-52},{-138,-44}}, color={0,0,127}));
  connect(booleanExpression.y, switch1.u2) annotation (Line(points={{-199,-52},{-184,-52}}, color={255,0,255}));
  connect(realExpression.y, switch1.u3) annotation (Line(points={{-199,-68},{-192,-68},{-192,-60},{-184,-60}}, color={0,0,127}));
  connect(tableSteamToCarbonRatio.y1, switch1.u1) annotation (Line(points={{-199,-26},{-192,-26},{-192,-44},{-184,-44}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-240,-100},{240,100}})),Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,-100},{240,100}})),
  Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents typical setup of a steam methane reformer system with enough hydrogen in the feed. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The feed is preheated, mixed with preheated steam and the higher hydrocarbons are decomposed. Thereafter, the steam methane reformer produces hydrogen out of methane and steam. Afterwards, the hydrogen yield is increased in the water gas shift reactor. In the end, the stream is cooled, dried and purified in a pressure swing adsorption reactor (PSA). In a real system there are many more heat exchangers but most of the models work simplified and thus independent of the temperature. Necessary for this process is heat for the preheaters and the steam methane reformer which is usually delivered by a burner in which the PSA off-gas is burned. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>The model is valid if there is enough hydrogen in the stream. The applicability of the submodels should be checked as well before using this model. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn: real gas inlet </p>
<p>gasPortOut_offGas: real gas outlet for the PSA off-gas </p>
<p>gasPortOut_hydrogen: real gas outlet for the produced hydrogen </p>
<p>heatFeedPreheater: heat port for the feed preheater </p>
<p>heatSteamPreheater: heat port for the steam preheater </p>
<p>heatSMR: heat port for the steam methane reformer </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) in March 2017</p>
<p><br>Model revised by Carsten Bode (c.bode@tuhh.de) in Apr 2018 (fixed for update to ClaRa 1.3.0)</p>
</html>"));
end SMRSystem_noH2Loop;
