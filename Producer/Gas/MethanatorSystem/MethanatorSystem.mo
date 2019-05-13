within TransiEnt.Producer.Gas.MethanatorSystem;
model MethanatorSystem
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
  import SI = Modelica.SIunits;
  extends TransiEnt.Basics.Icons.FixedBedReactor_L4;
  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG4_var gas_sg4;
  final parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var vle_sg4;
  final parameter SI.MassFlowRate m_flow_n_CH4=if ScalingOfReactor==1 then m_flow_n_Methane elseif ScalingOfReactor==2 then m_flow_n_Hydrogen*2.0422868 elseif ScalingOfReactor==3 then H_flow_n_Methane/50.013e6 elseif ScalingOfReactor==4 then H_flow_n_Hydrogen*0.83/50.013e6 else -99 "esimiation of nominal mass flow of methanation - else case is error case";
  final parameter SI.Density rho_H2=TILMedia.Internals.VLEFluidFunctions.density_phxi(p_nom[1],T_nom[1],{0,0,0},vle_sg4.concatVLEFluidName, vle_sg4.nc+TILMedia.Internals.redirectModelicaFormatMessage());

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________


  parameter SI.VolumeFraction hydrogenFraction_fixed=0.1 "target volume fraction of hydrogen in output"
                                                                                                  annotation (Dialog(               group="General"));
  parameter Boolean useCO2Input=false "Use gas port for CO2 for methanation" annotation (Dialog(               group="General"));
  parameter Boolean useVariableHydrogenFraction=false "define volumetric hydrogen content in SNG via input - in not 'hydrogenFraction_fixed' is used" annotation (Dialog(               group="General"));
  parameter Integer N_cv=10 "Number of control volumes" annotation(Dialog(group="Fundamental Definitions"));

  parameter SI.Temperature T_nom[N_cv]=(273.15+270)*ones(N_cv)  "Nominal gas and catalyst temperature in the control volumes" annotation(Dialog(group="Nominal Values"));
  parameter SI.Pressure p_nom[N_cv]=(17e5)*ones(N_cv)  "Nominal pressure in the control volumes" annotation(Dialog(group="Nominal Values"));
  parameter SI.MassFraction xi_nom[N_cv,vle_sg4.nc-1]=fill({0.30439,0.00997376,0.683929}, N_cv) "Nominal values for mass fractions" annotation(Dialog(group="Nominal Values"));
  parameter Integer ScalingOfReactor=2 "Chooce by which value the scaling of the reactor is defined" annotation(Dialog(group="Nominal Values"),choices(
                choice=1 "Define Reactor Scaling by nominal methane flow at output",
                choice=2 "Define Reactor Scaling by nominal hydrogen flow at input",
                choice=3 "Define Reactor Scaling by nominal methane enthalpy flow at output",
                choice=4 "Define Reactor Scaling by nominal hydrogen enthalpy flow at input"));
  parameter SI.MassFlowRate m_flow_n_Methane=0.0675008 "Nominal mass flow rate of methane at the outlet" annotation(Dialog(group="Nominal Values",enable = if ScalingOfReactor== 1 then true else false));
  parameter SI.MassFlowRate m_flow_n_Hydrogen=0.0339027 "Nominal mass flow rate of hydrogen at the inlet" annotation(Dialog(group="Nominal Values",enable = if ScalingOfReactor== 2 then true else false));
  parameter SI.EnthalpyFlowRate H_flow_n_Methane=3.375921e6 "Nominal enthalpy flow rate of methane at the output" annotation(Dialog(group="Nominal Values",enable = if ScalingOfReactor== 3 then true else false));
  parameter SI.EnthalpyFlowRate H_flow_n_Hydrogen=4.0673747e6 "Nominal enthalpy flow rate of hydrogen at the input" annotation(Dialog(group="Nominal Values",enable = if ScalingOfReactor== 4 then true else false));

  parameter SI.Temperature  T_start[N_cv]=(273.15+270)*ones(N_cv) "Initial gas and catalyst temperature in the control volumes" annotation(Dialog(group="Initialization"));
  parameter SI.Pressure p_start[N_cv]=17e5*ones(N_cv) "Initial pressure in the control volumes" annotation(Dialog(group="Initialization"));
  parameter SI.MassFraction xi_start[N_cv,gas_sg4.nc-1]=fill({0.30439,0.00997376,0.683929}, N_cv) "Initial values for mass fractions" annotation(Dialog(group="Initialization"));

  parameter SI.Temperature T_co2_source=simCenter.T_amb_const "Temperature for CO2 from source" annotation(Dialog(group="Sources and Sinks"));
  //parameter SI.MassFlowRate m_flow_water_source=-1 "Mass flow rate of water from source" annotation(Dialog(group="Sources and Sinks"));
  parameter SI.Temperature T_water_source=simCenter.T_amb_const "Temperature of water from source" annotation(Dialog(group="Sources and Sinks"));
  parameter SI.Pressure p_water_sink_hex=simCenter.p_amb_const "Pressure of water at sink after HEX" annotation(Dialog(group="Sources and Sinks"));
  parameter SI.Pressure p_water_sink_dryer=simCenter.p_amb_const "Pressure of water at sink after dryer" annotation(Dialog(group="Sources and Sinks"));

  parameter SI.PressureDifference Delta_p_meth=0e5 "Pressure loss in the methanator" annotation(Dialog(group="Pressure Losses"));
  parameter SI.PressureDifference Delta_p_hEXBeforeMeth=0e5 "Pressure loss in the heat exchanger before the methanator" annotation(Dialog(group="Pressure Losses"));
  parameter SI.PressureDifference Delta_p_gas_hEXAfterMeth=0e5 "Pressure loss on the gas side in the heat exchanger after the methanator" annotation(Dialog(group="Pressure Losses"));
  parameter SI.PressureDifference Delta_p_water_hEXAfterMeth=0e5 "Pressure loss on the water side in the heat exchanger after the methanator" annotation(Dialog(group="Pressure Losses"));
  parameter SI.PressureDifference Delta_p_dryer=0e5 "Pressure loss in the dryer" annotation(Dialog(group="Pressure Losses"));

  parameter SI.Temperature T_out_SNG=20+273.15 "output temperature of synthetic natural gas after drying" annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean integrateMassFlow=false "True if mass flow shall be integrated" annotation (Dialog(               group="General"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Natural Gas model to be used" annotation (Dialog(tab="General", group="General"));


  parameter SI.Pressure p_start_junction=p_start[N_cv] "Initial value for gas pressure"
                                                                                       annotation(Dialog(group="Initial Values"));
  parameter SI.Temperature T_start_junction=T_out_SNG "Initial value for gas temperature (used in calculation of h_start)" annotation(Dialog(group="Initial Values"));
  parameter SI.MassFraction[vle_sg4.nc - 1] xi_start_junction={xi_start[1,1]/(1-xi_start[1,3]),xi_start[1,2]/(1-xi_start[1,3]),0} "Initial value for mass fractions"   annotation(Dialog(group="Initial Values"));
  parameter SI.Volume volume_junction=m_flow_n_CH4*2/10.8563966 "junction of volume" annotation (Dialog(               group="Fundamental Definitions"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer TransiEnt.SimCenter simCenter;
  replaceable model CostSpecsGeneral = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Empty
                                                                                                      constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs
                                                                                                                                                                                             "General Cost Record" annotation(Dialog(group="Statistics"),choicesAllMatching);
  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________
  TransiEnt.Basics.Interfaces.General.MassFlowRateIn HydrogenFraction_input if useVariableHydrogenFraction annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-106,-50}), iconTransformation(
        extent={{12,-12},{-12,12}},
        rotation=180,
        origin={-98,-76})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium)  annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium)  annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  TransiEnt.Components.Gas.Reactor.Methanator_L4 methanator(
    N_cv=N_cv,
    redeclare model CostSpecsGeneral = CostSpecsGeneral,
    ScalingOfReactor=ScalingOfReactor,
    m_flow_n_Methane=m_flow_n_Methane,
    m_flow_n_Hydrogen=m_flow_n_Hydrogen,
    H_flow_n_Methane=H_flow_n_Methane,
    H_flow_n_Hydrogen=H_flow_n_Hydrogen,
    pressureCalculation=1,
    T_nom=T_nom,
    p_nom=p_nom,
    Delta_p=Delta_p_meth,
    T(start=T_start),
    p(start=p_start),
    xi(start=xi_start)) annotation (Placement(transformation(extent={{-16,52},{-8,60}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor moleCompIn(medium=vle_sg4, compositionDefinedBy=2,
    flowDefinition=3)                                                                                       annotation (Placement(transformation(extent={{-54,56},{-42,68}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature[N_cv] annotation (Placement(transformation(extent={{-3,3},{3,-3}},
        rotation=0,
        origin={-39,79})));
  TransiEnt.Basics.Adapters.Gas.Ideal_to_Real ideal_to_Real(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var real, redeclare TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG4_var ideal) annotation (Placement(transformation(extent={{-2,52},{6,60}})));
  TransiEnt.Basics.Adapters.Gas.Real_to_Ideal real_to_Ideal(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var real, redeclare TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG4_var ideal) annotation (Placement(transformation(extent={{-28,52},{-20,60}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor moleCompOut_Dried(medium=vle_sg4, compositionDefinedBy=2,
    flowDefinition=3)                                                                                              annotation (Placement(transformation(extent={{58,56},{68,68}})));

  Modelica.Blocks.Sources.RealExpression realExpression[N_cv](y=T_nom) annotation (Placement(transformation(extent={{-56,74},{-46,84}})));

  TransiEnt.Components.Gas.VolumesValvesFittings.ValveDesiredPressureBefore valve_pBeforeValveDes1(final medium=vle_sg4, p_BeforeValveDes=p_nom[N_cv])
                                                                                                                                               annotation (Placement(transformation(
        extent={{4.5,-4.5},{-4.5,4.5}},
        rotation=90,
        origin={99.5,47.5})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow Sink_CO2(
    medium=medium,
    variable_m_flow=true,
    xi_const={0,0,0,0,0,1},
    T_const=493.15) if useCO2Input annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-60,-78})));
  TransiEnt.Components.Gas.GasCleaning.Dryer_L1 dryer(
    medium_gas=vle_sg4,
    medium_water=TILMedia.VLEFluidTypes.TILMedia_SplineWater(),
    pressureLoss=Delta_p_dryer) annotation (Placement(transformation(extent={{44,52},{52,60}})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_pTxi
                                                           sink_water(
    boundaryConditions(showData=false),
    variable_p=false,
    medium=TILMedia.VLEFluidTypes.TILMedia_SplineWater())                                             annotation (Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=270,
        origin={48,72})));
  TransiEnt.Components.Gas.HeatExchanger.HEXOneRealGasOuterTIdeal_L1 hEXBeforeMeth(
    medium=TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var(),
    T_fluidOut=T_nom[1],
    Delta_p=Delta_p_hEXBeforeMeth)                                                                    annotation (Placement(transformation(extent={{-40,52},{-32,60}})));
  TransiEnt.Components.Gas.HeatExchanger.HEXOneRealGasOuterTIdeal_L1 hEXOneRealGasOuterTIdeal_L1_1(
    T_fluidOut=T_out_SNG,
    Delta_p=Delta_p_gas_hEXAfterMeth,
    medium=TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var()) annotation (Placement(transformation(extent={{10,52},{18,60}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature1 annotation (Placement(transformation(
        extent={{-3,3},{3,-3}},
        rotation=0,
        origin={11,69})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=T_out_SNG) annotation (Placement(transformation(extent={{-6,64},{4,74}})));
 TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow Source_CO2(
    medium=vle_sg4,
    variable_m_flow=true,
    T_const=493.15,
    xi_const={0,1,0})  annotation (Placement(transformation(extent={{-4,4},{4,-4}},
        rotation=-90,
        origin={-56,70})));
  TransiEnt.Producer.Gas.MethanatorSystem.Controller.ControllerCO2ForMethanator controllerCO2ForMethanator annotation (Placement(transformation(extent={{-58,78},{-66,86}})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massFlowSensor_Hydrogen(medium=vle_sg4, xiNumber=0)
                                                                                             annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-64,62})));
  TransiEnt.Components.Gas.VolumesValvesFittings.ThreeWayValveRealGas_L1_simple TWV(medium=vle_sg4, splitRatio_input=true)
                                                                                                           annotation (Placement(transformation(
        extent={{5,4.5},{-5,-4.5}},
        rotation=180,
        origin={-77,55.5})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 junction(
    initOption=0,                                                            medium=vle_sg4,
    redeclare model PressureLoss3 = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.Linear (m_flow_nom=m_flow_n_CH4, dp_nom=1e4),
    volume=volume_junction,
    p_start=p_start_junction,
    T_start=T_start_junction)                                                                                                                            annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={76,56})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensor(
    medium=vle_sg4,
    compositionDefinedBy=2,
    flowDefinition=3)                                                                              annotation (Placement(transformation(
        extent={{5,6},{-5,-6}},
        rotation=180,
        origin={89,62})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=x_H2)
                                                         annotation (Placement(transformation(extent={{-38,84},{-48,96}})));
  Modelica.Blocks.Sources.RealExpression realExpression4(y=hydrogenFraction_fixed) annotation (Placement(transformation(extent={{-38,92},{-48,104}})));
  TransiEnt.Basics.Blocks.LimPID PID(
    sign=-1,
    y_max=1,
    y_min=0,
    initOption=501,
    y_start=1)
             annotation (Placement(transformation(extent={{-54,94},{-60,100}})));
  TransiEnt.Basics.Adapters.Gas.RealNG7_to_RealSG4 realNG7_SG_to_RealSG4_var(medium_sg4=vle_sg4, medium_ng7_H2=medium) annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-100,34})));
  TransiEnt.Basics.Adapters.Gas.RealSG4_to_RealNG7 realSG4_var_to_RealNG7_SG(medium_sg4=vle_sg4, medium_ng7_H2=medium) annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=90,
        origin={100,34})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn_CO2(Medium=medium) if useCO2Input annotation (Placement(transformation(extent={{-70,-110},{-50,-90}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow Source_smallMassFlow(
    medium=vle_sg4,
    m_flow_const=-1,
    T_const=283.15,
    xi_const={0,0,0}) annotation (Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=-90,
        origin={-94,82})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow Source_CO3(
    medium=vle_sg4,
    variable_m_flow=true,
    m_flow_const=-0.1,
    T_const=493.15,
    xi_const={0,0,0})  annotation (Placement(transformation(extent={{-4,4},{4,-4}},
        rotation=-90,
        origin={94,82})));
  Modelica.Blocks.Sources.RealExpression realExpression5(y=if noEvent(junction.gasPort3.m_flow > 0.1*junction.gasPort3.m_flow/TWV.gasPortIn.m_flow*1.1) then -junction.gasPort3.m_flow else max(0, -1*junction.gasPort3.m_flow/TWV.gasPortIn.m_flow))
                                                         annotation (Placement(transformation(extent={{70,82},{80,94}})));
  Modelica.Blocks.Sources.RealExpression realExpression7(y=Source_smallMassFlow.m_flow_const*TWV.splitRatio_external/max(1e-10, controllerCO2ForMethanator.m_flow_H2)*controllerCO2ForMethanator.m_flow_CO2) if useCO2Input annotation (Placement(transformation(extent={{-82,-48},{-64,-38}})));
  Modelica.Blocks.Math.Add add(k1=-1,k2=-1) if useCO2Input annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-56,-58})));

  inner Summary summary(
   gasPortIn(
     mediumModel=medium,
     xi=gasIn.xi,
     x=gasIn.x,
     m_flow=gasPortIn.m_flow,
     T=gasIn.T,
     p=gasPortIn.p,
     h=gasIn.h,
     rho=gasIn.d),
   gasPortOut(
     mediumModel=medium,
     xi=gasOut.xi,
     x=gasOut.x,
     m_flow=-gasPortOut.m_flow,
     T=gasOut.T,
     p=gasPortOut.p,
     h=gasOut.h,
     rho=gasOut.d),
   outline(
     N_cv=methanator.N_cv,
     Q_flow=methanator.heat.Q_flow,
     T_flueGas=methanator.heat.T,
     H_flow_n_methanation_H2=methanator.summary.outline.H_flow_n_methanation_H2,
     H_flow_n_methanation_CH4=methanator.summary.outline.H_flow_n_methanation_CH4,
     mass_SNG=mass_SNG,
     eta_NCV=methanator.summary.outline.eta_NCV),
   costs(
     costs=methanator.collectCosts.costsCollector.Costs,
     investCosts=methanator.collectCosts.costsCollector.InvestCosts,
     demandCosts=methanator.collectCosts.costsCollector.DemandCosts,
     oMCosts=methanator.collectCosts.costsCollector.OMCosts,
     otherCosts=methanator.collectCosts.costsCollector.OtherCosts,
     revenues=methanator.collectCosts.costsCollector.Revenues))
        annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
protected
  model Outline
    extends TransiEnt.Basics.Icons.Record;
    parameter Integer N_cv "Number of control volumes";
    input SI.HeatFlowRate Q_flow[N_cv] "Heat flow rate";
    input SI.Temperature T_flueGas[N_cv] "Flue gas temperature";
    input SI.Power H_flow_n_methanation_H2 "approximated nominal power of reactor based on NCV of hydrogen input";
    input SI.Power H_flow_n_methanation_CH4 "approximated nominal power of reactor based on NCV of methane outpur";
    input SI.Mass mass_SNG "produced mass SNG";
    input SI.Efficiency eta_NCV "efficiency based on NCV";
  end Outline;

  model Summary
    extends TransiEnt.Basics.Icons.Record;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn(mediumModel=medium);
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut(mediumModel=medium);
    Outline outline;
    TransiEnt.Basics.Records.Costs costs;
  end Summary;

  TILMedia.VLEFluid_ph gasIn(
    h=inStream(gasPortIn.h_outflow),
    p=gasPortIn.p,
    xi=inStream(gasPortIn.xi_outflow),
    deactivateTwoPhaseRegion=true,
    vleFluidType=medium) annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  TILMedia.VLEFluid_ph gasOut(
    deactivateTwoPhaseRegion=true,
    vleFluidType=medium,
    p=realSG4_var_to_RealNG7_SG.gasPortOut.p,
    xi=realSG4_var_to_RealNG7_SG.gasPortOut.xi_outflow,
    h=realSG4_var_to_RealNG7_SG.gasPortOut.h_outflow)   annotation (Placement(transformation(extent={{80,-80},{100,-60}})));


  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

 SI.Mass mass_SNG "total produced SNG";
 SI.VolumeFraction x_H2 "calculated hydrogen volume fraction in output";

equation

  if integrateMassFlow then
  der(mass_SNG)=-dryer.gasPortOut.m_flow;
  else
    mass_SNG=0;
  end if;

  x_H2=(1-sum(junction.gasPort3.xi_outflow))/rho_H2*junction.summary.gasPort3.rho;

  connect(real_to_Ideal.gasPortOut, methanator.gasPortIn) annotation (Line(
      points={{-20,56},{-16,56}},
      color={255,213,170},
      thickness=1.5));

  connect(methanator.gasPortOut, ideal_to_Real.gasPortIn) annotation (Line(
      points={{-8,56},{-2,56}},
      color={255,213,170},
      thickness=1.5));
  connect(methanator.heat, prescribedTemperature.port) annotation (Line(points={{-12,60},{-12,79},{-36,79}},
                                                                                                           color={191,0,0}));
  connect(moleCompOut_Dried.gasPortIn, dryer.gasPortOut) annotation (Line(
      points={{58,56},{52,56}},
      color={255,255,0},
      thickness=1.5));
  connect(realExpression.y, prescribedTemperature.T) annotation (Line(points={{-45.5,79},{-42.6,79}},      color={0,0,127}));
  connect(moleCompIn.gasPortOut, hEXBeforeMeth.gasPortIn) annotation (Line(
      points={{-42,56},{-40,56}},
      color={255,255,0},
      thickness=1.5));
  connect(real_to_Ideal.gasPortIn, hEXBeforeMeth.gasPortOut) annotation (Line(
      points={{-28,56},{-32,56}},
      color={255,255,0},
      thickness=1.5));
  connect(sink_water.fluidPortIn, dryer.fluidPortOut) annotation (Line(
      points={{48,68},{48,60}},
      color={175,0,0},
      thickness=0.5));
  connect(hEXBeforeMeth.heat, prescribedTemperature[1].port) annotation (Line(points={{-36,60},{-36,79}},                                     color={191,0,0}));
  connect(ideal_to_Real.gasPortOut, hEXOneRealGasOuterTIdeal_L1_1.gasPortIn) annotation (Line(
      points={{6,56},{10,56}},
      color={255,255,0},
      thickness=1.5));
  connect(realExpression1.y, prescribedTemperature1.T) annotation (Line(points={{4.5,69},{7.4,69}},color={0,0,127}));
  connect(prescribedTemperature1.port, hEXOneRealGasOuterTIdeal_L1_1.heat) annotation (Line(points={{14,69},{14,60}},         color={191,0,0}));
  connect(controllerCO2ForMethanator.m_flow_CO2, Source_CO2.m_flow) annotation (Line(points={{-62,77.6},{-62,74.8},{-58.4,74.8}},          color={0,0,127}));
  connect(Source_CO2.gasPort, moleCompIn.gasPortIn) annotation (Line(
      points={{-56,66},{-56,56},{-54,56}},
      color={255,255,0},
      thickness=1.5));
  connect(gasPortIn, gasPortIn) annotation (Line(
      points={{-100,0},{-97,0},{-97,0},{-100,0}},
      color={255,255,0},
      thickness=1.5));
  connect(massFlowSensor_Hydrogen.gasPortOut, moleCompIn.gasPortIn) annotation (Line(
      points={{-70,56},{-54,56}},
      color={255,255,0},
      thickness=1.5));
  connect(massFlowSensor_Hydrogen.gasPortIn, TWV.gasPortOut1) annotation (Line(
      points={{-58,56},{-72,56}},
      color={255,255,0},
      thickness=1.5));
  connect(junction.gasPort1, moleCompOut_Dried.gasPortOut) annotation (Line(
      points={{70,56},{68,56}},
      color={255,255,0},
      thickness=1.5));
  connect(controllerCO2ForMethanator.m_flow_H2, massFlowSensor_Hydrogen.m_flow) annotation (Line(points={{-66,82},{-72,82},{-72,62},{-70.6,62}},                 color={0,0,127}));
  connect(compositionSensor.gasPortIn, junction.gasPort3) annotation (Line(
      points={{84,56},{82,56}},
      color={255,255,0},
      thickness=1.5));
  connect(realExpression2.y, PID.u_m) annotation (Line(points={{-48.5,90},{-57.03,90},{-57.03,93.4}}, color={0,0,127}));
  if useVariableHydrogenFraction then
  connect(PID.u_s, HydrogenFraction_input);
  else
  connect(PID.u_s, realExpression4.y) annotation (Line(points={{-53.4,97},{-48.5,97},{-48.5,98}}, color={0,0,127}));
  end if;
  connect(PID.y, TWV.splitRatio_external) annotation (Line(points={{-60.3,97},{-77,97},{-77,60.5}},color={0,0,127}));
  connect(gasPortIn, realNG7_SG_to_RealSG4_var.gasPortIn) annotation (Line(
      points={{-100,0},{-100,28}},
      color={255,255,0},
      thickness=1.5));
  connect(realNG7_SG_to_RealSG4_var.gasPortOut, TWV.gasPortIn) annotation (Line(
      points={{-100,40},{-100,56},{-82,56}},
      color={255,255,0},
      thickness=1.5));
  connect(realSG4_var_to_RealNG7_SG.gasPortOut, gasPortOut) annotation (Line(
      points={{100,28},{100,0}},
      color={255,255,0},
      thickness=1.5));
  if useCO2Input then
    connect(gasPortIn_CO2,Sink_CO2. gasPort) annotation (Line(
      points={{-60,-100},{-60,-84}},
      color={255,255,0},
      thickness=1.5));
    connect(Sink_CO2.m_flow, add.y) annotation (Line(points={{-56.4,-70.8},{-56,-70.8},{-56,-64.6}}, color={0,0,127}));
    connect(realExpression7.y, add.u2) annotation (Line(points={{-63.1,-43},{-59.6,-43},{-59.6,-50.8}}, color={0,0,127}));
    connect(controllerCO2ForMethanator.m_flow_CO2, add.u1) annotation (Line(points={{-62,77.6},{-62,12},{-52.4,12},{-52.4,-50.8}}, color={0,0,127}));
  end if;
  connect(Source_smallMassFlow.gasPort, TWV.gasPortIn) annotation (Line(
      points={{-94,78},{-94,56},{-82,56}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensor.gasPortOut, Source_CO3.gasPort) annotation (Line(
      points={{94,56},{94,78}},
      color={255,255,0},
      thickness=1.5));
  connect(Source_CO3.m_flow, realExpression5.y) annotation (Line(points={{91.6,86.8},{84.8,86.8},{84.8,88},{80.5,88}}, color={0,0,127}));
  connect(realSG4_var_to_RealNG7_SG.gasPortIn, valve_pBeforeValveDes1.gasPortOut) annotation (Line(
      points={{100,40},{100,41.5},{100.143,41.5},{100.143,43}},
      color={255,255,0},
      thickness=1.5));
  connect(valve_pBeforeValveDes1.gasPortIn, compositionSensor.gasPortOut) annotation (Line(
      points={{100.143,52},{100.143,56},{94,56}},
      color={255,255,0},
      thickness=1.5));
  connect(dryer.gasPortIn, hEXOneRealGasOuterTIdeal_L1_1.gasPortOut) annotation (Line(
      points={{44,56},{18,56}},
      color={255,255,0},
      thickness=1.5));
  connect(TWV.gasPortOut2, junction.gasPort2) annotation (Line(
      points={{-77,51},{-77,44},{76,44},{76,50}},
      color={255,255,0},
      thickness=1.5));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{50,62},{84,32}},
          lineColor={28,108,200},
          textString="CH4"),
        Polygon(
          points={{30,-62},{31,-57},{33,-54},{34,-50},{34,-46},{38,-50},{40,-54},{42,-58},{42,-62},{30,-62}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{30,-56},{42,-68}},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid,
          fillColor={85,170,255},
          pattern=LinePattern.None),
        Polygon(
          points={{52,-52},{53,-47},{55,-44},{56,-40},{56,-36},{60,-40},{62,-44},{64,-48},{64,-52},{52,-52}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{44,-74},{45,-69},{47,-66},{48,-62},{48,-58},{52,-62},{54,-66},{56,-70},{56,-74},{44,-74}},
          pattern=LinePattern.None,
          lineThickness=0.5,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{52,-46},{64,-58}},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid,
          fillColor={85,170,255},
          pattern=LinePattern.None),
        Ellipse(
          extent={{44,-68},{56,-80}},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid,
          fillColor={85,170,255},
          pattern=LinePattern.None),
        Line(
          points={{16,-30},{16,-92}},
          color={28,108,200},
          arrow={Arrow.None,Arrow.Open},
          thickness=0.5,
          smooth=Smooth.Bezier)}),                               Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is based on the Methanator model and is basically only expanded by a dryer-model such that the product gas stream has sufficient properties to be fed in the natural gas grid according to DNVGW G 260/262.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn: inlet for real gas</p>
<p>gasPortOut: outlet for real gas</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in the check model &quot;TransiEnt.Producer.Gas.MethanatorSystem.Check.Test_MethanatorSystem&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) in Feb 2018</p>
<p>Model modified by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) in April 2018: added H2 bypass, changed medium type of gasPortIn/gasPortOut</p>
</html>"));
end MethanatorSystem;
