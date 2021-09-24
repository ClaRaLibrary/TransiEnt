within TransiEnt.Producer.Gas.MethanatorSystem;
model FeedInStation_Methanation

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

  extends TransiEnt.Producer.Gas.Electrolyzer.Base.PartialFeedInStation;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Real hydrogenFraction_fixed=0 "Target fraction of hydrogen in ouput"  annotation (Dialog(group="General"));
  parameter Boolean useSeperateHydrogenOutput=false "Use additional gas port for hydrogen only"  annotation (Dialog(               group="General"));
  parameter Boolean useVariableHydrogenFraction=false "meassured hydrogen fraction for hydrogen-fraction-controller" annotation (Dialog(               group="General"));
  parameter Boolean useMassFlowControl=true "choose if output of FeedInStation is limited by m_flow_feedIn - if 'false': m_flow_feedIn has no effect - should only be 'false' if feedInStation_Hydrogen has no storage and useMassFlowControl='false' in feedInStation_Hydrogen as well" annotation(Dialog(group="General"));
  parameter Boolean useCO2Input=false "Use gas port for CO2 for methanation" annotation (Dialog(               group="General"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Natural Gas model to be used" annotation (Dialog(tab="General", group="General"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_CO2=simCenter.gasModel1 "CO2 model to be used" annotation (Dialog(tab="General", group="General"));
  parameter SI.Temperature T_nom[N_cv]=(273.15+270)*ones(N_cv)  "Nominal gas and catalyst temperature in the control volumes" annotation(Dialog(tab="Methanation", group="Nominal Values"));
  parameter SI.Pressure p_nom[N_cv]=(17e5)*ones(N_cv)  "Nominal pressure in the control volumes" annotation(Dialog(tab="Methanation", group="Nominal Values"));
  parameter SI.MassFraction xi_nom[N_cv,vle_sg4.nc-1]=fill({0.296831,0.0304503,0.666944}, N_cv) "Nominal values for mass fractions" annotation(Dialog(tab="Methanation", group="Nominal Values"));
  parameter Integer N_cv=10 "Number of control volumes" annotation(Dialog(tab="Methanation", group="Fundamental Definitions"));
  parameter Integer scalingOfReactor=2 "Chooce by which value the scaling of the reactor is defined" annotation(Dialog(tab="Methanation", group="Nominal Values"),choices(
                choice=1 "Define Reactor Scaling by nominal methane flow at output",
                choice=2 "Define Reactor Scaling by nominal hydrogen flow at input",
                choice=3 "Define Reactor Scaling by nominal methane enthalpy flow at output",
                choice=4 "Define Reactor Scaling by nominal hydrogen enthalpy flow at input"));
  parameter Integer heatLossCalculation=1 annotation(Dialog(tab="Methanation",group="Coolant"),choices(__Dymola_radioButtons=true, choice=1 "logarithmic approximation", choice=2 "use fix percentage", choice=3 "no heat losses"));
  parameter Real percentageLosses=0.01 annotation(Dialog(tab="Methanation",group="Coolant",enable=if heatLossCalculation==2 then true else false));
  parameter SI.MassFlowRate m_flow_n_Methane=0.0675008 "Nominal mass flow rate of methane at the outlet" annotation(Dialog(tab="Methanation",group="Nominal Values",enable = if scalingOfReactor== 1 then true else false));
  parameter SI.MassFlowRate m_flow_n_Hydrogen=0.0339027 "Nominal mass flow rate of hydrogen at the inlet" annotation(Dialog(tab="Methanation",group="Nominal Values",enable = if scalingOfReactor== 2 then true else false));
  parameter SI.EnthalpyFlowRate H_flow_n_Methane=3.375921e6 "Nominal enthalpy flow rate of methane at the output" annotation(Dialog(tab="Methanation",group="Nominal Values",enable = if scalingOfReactor== 3 then true else false));
  parameter SI.EnthalpyFlowRate H_flow_n_Hydrogen=4.0673747e6 "Nominal enthalpy flow rate of hydrogen at the input" annotation(Dialog(tab="Methanation",group="Nominal Values",enable = if scalingOfReactor== 4 then true else false));
  parameter SI.Temperature  T_start[N_cv]=503.15*ones(N_cv) "Initial gas and catalyst temperature in the control volumes" annotation(Dialog(tab="Methanation", group="Initialization"));
  parameter SI.Pressure p_start[N_cv]=17e5*ones(N_cv) "Initial pressure in the control volumes" annotation(Dialog(tab="Methanation", group="Initialization"));
  parameter SI.MassFraction xi_start[N_cv,gas_sg4.nc-1]=fill({0.296831,0.0304503,0.666944}, N_cv) "Initial values for mass fractions" annotation(Dialog(tab="Methanation", group="Initialization"));
  parameter SI.Temperature T_out_SNG=273.15+20 "Temperature of Synthetic Natural Gas after drying" annotation (Dialog(tab="Methanation", group="Fundamental Definitions"));
  parameter Boolean useLeakageMassFlow=false "Constant leakage gas mass flow of 'm_flow_small' to avoid zero mass flow"  annotation(Dialog(group="Numerical Stability"));
  parameter SI.MassFlowRate m_flow_small=simCenter.m_flow_small "leakage mass flow if useLeakageMassFlow=true" annotation(Dialog(group="Numerical Stability",enable=useLeakageMassFlow));
  parameter Boolean useFluidCoolantPort=false "choose if fluid port for coolant shall be used" annotation (Dialog(enable=not useHeatPort,group="Coolant"));
  parameter Boolean useHeatPort=false "choose if heat port for coolant shall be used" annotation (Dialog(enable=not useFluidCoolantPort,group="Coolant"));
  parameter Boolean useVariableCoolantOutputTemperature=false "choose if temperature of cooland output shall be defined by input" annotation (Dialog(enable=useFluidCoolantPort,group="Coolant"));
  parameter SI.Temperature T_out_coolant_target=500+273.15 "output temperature of coolant - will be limited by temperature which is technically feasible" annotation (Dialog(enable=useFluidCoolantPort,group="Coolant"));
  parameter Boolean externalMassFlowControl=false "choose if coolant mass flow is defined by input" annotation (Dialog(enable=useFluidCoolantPort and (not useVariableCoolantOutputTemperature), group="Coolant"));
  parameter Integer chooseHeatSources=1 annotation(Dialog(group="Coolant"),choices(__Dymola_radioButtons=true, choice=1 "Methanation", choice=2 "Electrolyzer", choice=3 "Methanation and Electrolyzer"));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut_H2(Medium=medium) if useSeperateHydrogenOutput annotation (Placement(transformation(extent={{92,-10},{112,10}}), iconTransformation(extent={{82,-20},{112,10}})));
  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow_feedIn_H2 if useSeperateHydrogenOutput annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-106,70}), iconTransformation(
        extent={{12,-12},{-12,12}},
        rotation=180,
        origin={-98,80})));
  Modelica.Blocks.Interfaces.RealInput hydrogenFraction_input if useVariableHydrogenFraction              annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-106,-50}),iconTransformation(
        extent={{12,-12},{-12,12}},
        rotation=180,
        origin={-98,-80})));
  Basics.Interfaces.Thermal.FluidPortIn fluidPortIn(Medium=simCenter.fluid1) if useFluidCoolantPort annotation (Placement(transformation(extent={{90,-100},{110,-80}})));
  Basics.Interfaces.Thermal.FluidPortOut fluidPortOut(Medium=simCenter.fluid1) if useFluidCoolantPort     annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn_CO2(Medium=medium_CO2) if useCO2Input annotation (Placement(transformation(extent={{-70,-110},{-50,-90}})));
  Basics.Interfaces.General.TemperatureIn T_set_coolant_out if
                                                           useFluidCoolantPort and useVariableCoolantOutputTemperature annotation (Placement(transformation(extent={{128,16},{88,56}}), iconTransformation(extent={{112,32},{88,56}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heat if useHeatPort annotation (Placement(transformation(extent={{90,-76},{110,-56}})));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_woStorage feedInStation_Hydrogen( usePowerPort=usePowerPort,
    medium_ng=medium,
    useFluidCoolantPort=useFluidCoolantPort and chooseHeatSources>=2,
    useHeatPort=useHeatPort and chooseHeatSources >= 2,
    useVariableCoolantOutputTemperature=useVariableCoolantOutputTemperature and chooseHeatSources == 2,
    T_out_coolant_target=273.15 + 68,
    externalMassFlowControl=externalMassFlowControl and chooseHeatSources==2 or chooseHeatSources==3)                                                                                                annotation (Placement(transformation(extent={{-10,20},{10,40}})),  choices(
      choice(redeclare TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_woStorage feedInStation_Hydrogen),
      choice(redeclare TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_Storage feedInStation_Hydrogen),
      choice(redeclare TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_CavernComp feedInStation_Hydrogen)));
  TransiEnt.Producer.Gas.MethanatorSystem.Controller.MassFlowFeedInSystemController massFlowFeedInSystemController(P_el_max=feedInStation_Hydrogen.P_el_max, eta_n_ely=feedInStation_Hydrogen.eta_n,
    useMassFlowControl=useMassFlowControl,
    PID(k=1, Tau_i=30))                                                                                                                                                                                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,64})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensor(
    medium=medium, compositionDefinedBy=2, flowDefinition=3) annotation (Placement(transformation(
        extent={{-5,5},{5,-5}},
        rotation=-90,
        origin={-5,-63})));
  TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var vle_sg4;
  TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG4_var gas_sg4;
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasOut(
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    deactivateTwoPhaseRegion=true,
    h=inStream(compositionSensor.gasPortOut.h_outflow),
    p=compositionSensor.gasPortOut.p,
    xi=compositionSensor.gasPortOut.xi_outflow,
    vleFluidType=medium) annotation (Placement(transformation(extent={{18,-100},{38,-80}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow1(medium=medium, m_flow_const=m_flow_small*0.9) if
                                                                                                                  useLeakageMassFlow  annotation (Placement(transformation(extent={{-22,-48},{-18,-44}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow2(medium=medium, m_flow_const=-m_flow_small, xi_const={0,0,0,0,0,0}) if useSeperateHydrogenOutput and useLeakageMassFlow annotation (Placement(transformation(
        extent={{-2,-2},{2,2}},
        rotation=90,
        origin={22,-12})));
protected
  model Outline
    extends TransiEnt.Basics.Icons.Record;
    input SI.Power P_el "Consumed electric power";
    input SI.Energy W_el "Consumed electric energy";
    input SI.Power H_flow_n_methanation_H2 "approximated nominal power of reactor based on NCV of hydrogen input";
    input SI.Power H_flow_n_methanation_CH4 "approximated nominal power of reactor based on NCV of methane outpur";
    input SI.Mass mass_H2 "Produced hydrogen mass";
    input SI.Mass mass_SNG "Produced hydrogen mass";
    input SI.Efficiency eta_electrolysis_GCV "Efficiency of electrolyzer based on HHV";
    input SI.Efficiency eta_electrolysis_NCV "Efficiency of electrolyzer based on LHV";
    input SI.Efficiency eta_methanation_NCV "Efficiency of methanation based on LHV";
  end Outline;

  model Summary
    extends TransiEnt.Basics.Icons.Record;
    Outline outline;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOutElectrolyzer;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOutMethanation;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
  end Summary;

  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massFlowSensor_SNG(medium=medium,xiNumber=0)
                                                                         annotation (Placement(transformation(extent={{-5,-5},{5,5}},
        rotation=-90,
        origin={5,-51})));
public
  inner Summary summary(
    outline(
      P_el=feedInStation_Hydrogen.electrolyzer.summary.outline.P_el,
      W_el=feedInStation_Hydrogen.electrolyzer.summary.outline.W_el,
      H_flow_n_methanation_H2=methanation.summary.outline.H_flow_n_methanation_H2,
      H_flow_n_methanation_CH4=methanation.summary.outline.H_flow_n_methanation_CH4,
      mass_H2=feedInStation_Hydrogen.electrolyzer.summary.outline.mass_H2,
      mass_SNG=1,
      eta_electrolysis_GCV=feedInStation_Hydrogen.electrolyzer.summary.outline.eta_GCV,
      eta_electrolysis_NCV=feedInStation_Hydrogen.electrolyzer.summary.outline.eta_NCV,
      eta_methanation_NCV=methanation.summary.outline.eta_NCV),
    gasPortOutElectrolyzer(
      mediumModel=feedInStation_Hydrogen.electrolyzer.summary.gasPortOut.mediumModel,
      xi=feedInStation_Hydrogen.electrolyzer.summary.gasPortOut.xi,
      x=feedInStation_Hydrogen.electrolyzer.summary.gasPortOut.x,
      m_flow=feedInStation_Hydrogen.electrolyzer.summary.gasPortOut.m_flow,
      T=feedInStation_Hydrogen.electrolyzer.summary.gasPortOut.T,
      p=feedInStation_Hydrogen.electrolyzer.summary.gasPortOut.p,
      h=feedInStation_Hydrogen.electrolyzer.summary.gasPortOut.h,
      rho=feedInStation_Hydrogen.electrolyzer.summary.gasPortOut.rho),
    gasPortOutMethanation(
      mediumModel=methanation.summary.gasPortOut.mediumModel,
      xi=methanation.summary.gasPortOut.xi,
      x=methanation.summary.gasPortOut.x,
      m_flow=methanation.summary.gasPortOut.m_flow,
      T=methanation.summary.gasPortOut.T,
      p=methanation.summary.gasPortOut.p,
      h=methanation.summary.gasPortOut.h,
      rho=methanation.summary.gasPortOut.rho),
    gasPortOut(
      mediumModel=medium,
      xi=gasOut.xi,
      x=gasOut.x,
      m_flow=-gasPortOut.m_flow,
      T=gasOut.T,
      p=gasOut.p,
      h=gasOut.h,
      rho=gasOut.d))
       annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  TransiEnt.Components.Gas.VolumesValvesFittings.Valves.ThreeWayValveRealGas_L1_simple TWV1(medium=medium, splitRatio_input=true) if
                                                                                                                             useSeperateHydrogenOutput annotation (Placement(transformation(
        extent={{-6.50001,6},{6.5,-6}},
        rotation=-90,
        origin={-3.5e-06,0.5})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massFlowSensor_SNG1(medium=medium) if useSeperateHydrogenOutput  annotation (Placement(transformation(extent={{-5,-5},{5,5}},
        rotation=0,
        origin={63,5})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=if useLeakageMassFlow then min(max(m_flow_small/max(1e-4, -feedInStation_Hydrogen.gasPortOut.m_flow), (m_flow_small + ((-feedInStation_Hydrogen.gasPortOut.m_flow) - m_flow_feedIn_H2))/max(1e-4, -feedInStation_Hydrogen.gasPortOut.m_flow)), 1) else 1 - max(min(1, m_flow_feedIn_H2/max(1e-4, -feedInStation_Hydrogen.gasPortOut.m_flow)), 0)) if
                                                                                                                                                         useSeperateHydrogenOutput                              annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Sources.RealExpression Zero;
  replaceable MethanatorSystem_L4 methanation(medium=medium, medium_CO2=medium_CO2) constrainedby TransiEnt.Producer.Gas.MethanatorSystem.PartialMethanatorSystem(
    useFluidCoolantPort=useFluidCoolantPort and chooseHeatSources <> 2,
    useHeatPort=useHeatPort and chooseHeatSources <> 2,
    externalMassFlowControl=externalMassFlowControl and chooseHeatSources <> 2,
    N_cv=N_cv,
    useVariableCoolantOutputTemperature=useVariableCoolantOutputTemperature and chooseHeatSources <> 2,
    T_out_coolant_target=T_out_coolant_target,
    T_nom=T_nom,
    p_nom=p_nom,
    xi_nom=xi_nom,
    scalingOfReactor=scalingOfReactor,
    m_flow_n_Methane=m_flow_n_Methane,
    m_flow_n_Hydrogen=m_flow_n_Hydrogen,
    H_flow_n_Methane=H_flow_n_Methane,
    H_flow_n_Hydrogen=H_flow_n_Hydrogen,
    T_start=T_start,
    p_start=p_start,
    xi_start=xi_start,
    T_out_SNG=T_out_SNG,
    hydrogenFraction_fixed=hydrogenFraction_fixed,
    useCO2Input=useCO2Input,
    useVariableHydrogenFraction=useVariableHydrogenFraction) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-30})), choicesAllMatching=true);

equation
  // _____________________________________________
  //
  //          Characteristic equations
  // _____________________________________________

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(epp, feedInStation_Hydrogen.epp) annotation (Line(
      points={{-100,0},{-56,0},{-56,30},{-10,30}},
      color={0,135,135},
      thickness=0.5));
  connect(massFlowFeedInSystemController.P_el_set, P_el_set) annotation (Line(points={{2.22045e-015,76},{0,83.4},{0,108}}, color={0,0,127}));
  connect(feedInStation_Hydrogen.P_el_set, massFlowFeedInSystemController.P_el_ely) annotation (Line(points={{0,40.4},{0,53}}, color={0,0,127}));
  connect(feedInStation_Hydrogen.m_flow_feedIn, massFlowFeedInSystemController.m_flow_feed_ely) annotation (Line(points={{10,38},{16,38},{16,50},{8,50},{8,53}},
                                                                                                                                                               color={0,0,127}));
  connect(massFlowFeedInSystemController.m_flow_feed, m_flow_feedIn) annotation (Line(points={{12,70},{108,70}}, color={0,0,127}));
  if useSeperateHydrogenOutput==true then
    connect(feedInStation_Hydrogen.gasPortOut, TWV1.gasPortIn) annotation (Line(
      points={{0,20.1},{-0.666669,20.1},{-0.666669,7.00001}},
      color={255,255,0},
      thickness=1.5));
    connect(massFlowSensor_SNG1.gasPortOut, gasPortOut_H2) annotation (Line(
      points={{68,0},{102,0}},
      color={255,255,0},
      thickness=1.5));
    connect(TWV1.gasPortOut2, massFlowSensor_SNG1.gasPortIn) annotation (Line(
        points={{6,0.500005},{8,0.500005},{8,0},{58,0}},
        color={255,255,0},
        thickness=1.5));
    connect(realExpression1.y, TWV1.splitRatio_external) annotation (Line(points={{-19,0},{-6.66667,0},{-6.66667,0.500005}},                   color={0,0,127}));
    connect(m_flow_feedIn_H2, massFlowFeedInSystemController.m_flow_feed_H2) annotation (Line(points={{-106,70},{-26,70},{-26,64},{-12,64}}, color={0,0,127}));
    connect(methanation.gasPortIn, TWV1.gasPortOut1) annotation (Line(
        points={{0,-20},{0,-6},{-0.66667,-6}},
        color={255,255,0},
        thickness=1.5));
    if useLeakageMassFlow then
      connect(boundary_Txim_flow2.gasPort, TWV1.gasPortOut2) annotation (Line(
        points={{22,-10},{22,0},{6,0},{6,0.500005}},
        color={255,255,0},
        thickness=1.5));
    end if;
  else
    connect(methanation.gasPortIn,feedInStation_Hydrogen.gasPortOut);
    connect(massFlowFeedInSystemController.m_flow_feed_H2, Zero.y);
  end if;

  if useLeakageMassFlow==true then
    connect(massFlowSensor_SNG.gasPortIn, boundary_Txim_flow1.gasPort) annotation (Line(
      points={{8.88178e-16,-46},{-18,-46}},
      color={255,255,0},
      thickness=1.5));
  end if;

  connect(methanation.gasPortOut, massFlowSensor_SNG.gasPortIn) annotation (Line(
      points={{-1.77636e-15,-40},{-1.77636e-15,-45},{1.77636e-15,-45},{1.77636e-15,-46}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensor.gasPortIn, massFlowSensor_SNG.gasPortOut) annotation (Line(
      points={{0,-58},{0,-56}},
      color={255,255,0},
      thickness=1.5));
  connect(massFlowSensor_SNG.m_flow, massFlowFeedInSystemController.m_flow_feed_CH4_is) annotation (Line(points={{5,-56.5},{5,-58},{32,-58},{32,58},{12,58}}, color={0,0,127}));
  if useCO2Input then
  connect(methanation.gasPortIn_CO2, gasPortIn_CO2) annotation (Line(
      points={{-10,-24},{-60,-24},{-60,-100}},
      color={255,255,0},
      thickness=1.5));
  end if;

  connect(compositionSensor.gasPortOut, gasPortOut) annotation (Line(
      points={{0,-68},{0,-82},{0,-94},{5,-94}},
      color={255,255,0},
      thickness=1.5));
  if useVariableHydrogenFraction then
    connect(hydrogenFraction_input,methanation.hydrogenFraction_input)  annotation (Line(points={{-106,-50},{-76,-50},{-76,-14},{-5,-14},{-5,-19}},       color={0,0,127}));
  end if;

  if chooseHeatSources==1 then
    if useVariableCoolantOutputTemperature then
      connect(methanation.T_set_coolant_out, T_set_coolant_out) annotation (Line(points={{7,-42},{8,-42},{8,-46},{46,-46},{46,36},{108,36}}, color={0,0,127}));
    end if;
    if useFluidCoolantPort then
      connect(methanation.fluidPortIn, fluidPortIn) annotation (Line(
        points={{-9,-40},{-9,-50},{66,-50},{66,-88},{100,-88},{100,-90}},
        color={175,0,0},
        thickness=0.5));
      connect(methanation.fluidPortOut, fluidPortOut) annotation (Line(
        points={{-4,-40},{-4,-48},{66,-48},{66,-40},{100,-40}},
        color={175,0,0},
        thickness=0.5));
    end if;
    if useHeatPort then
      connect(methanation.heat, heat) annotation (Line(points={{-6.6,-40},{-6,-40},{-6,-66},{100,-66}},    color={191,0,0}));
    end if;
  elseif chooseHeatSources==2 then
    if useVariableCoolantOutputTemperature then
      connect(feedInStation_Hydrogen.T_set_coolant_out, T_set_coolant_out);
    end if;
    if useFluidCoolantPort then
      connect(feedInStation_Hydrogen.fluidPortIn, fluidPortIn);
      connect(feedInStation_Hydrogen.fluidPortOut, fluidPortOut);
    end if;
    if useHeatPort then
      connect(feedInStation_Hydrogen.heat, heat);
    end if;
  else
    if useVariableCoolantOutputTemperature then
      connect(methanation.T_set_coolant_out, T_set_coolant_out);
    end if;
    if useFluidCoolantPort then
      connect(fluidPortIn, feedInStation_Hydrogen.fluidPortIn);
      connect(feedInStation_Hydrogen.fluidPortOut,methanation.fluidPortIn);
      connect(methanation.fluidPortOut,fluidPortOut);
    end if;
    if useHeatPort then
      connect(methanation.heat,heat);
      connect(feedInStation_Hydrogen.heat,heat);
    end if;
  end if;


        annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{4,44},{98,-26}},
          lineColor={244,125,35},
          lineThickness=1,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="Syngas")}),                                Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents a feed in station where hydrogen is produced with an electrolyzer and methanated in a methanator to be fed in into a natural gas grid. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The hydrogen can be produced in an electrolyzer and be stored if desired. Herefore one of the FeedInSystems with an electrolzer can be chosen. </p>
<p>The methanation of hydrogen takes place after the hydrogen production and the possible storage. </p>
<p>The methanation can be avoided by a bypass. This bypass is is controlled by the output molar content of hydrogen which can be defined by the parameter &apos;hydrogenContentOutput&apos;. If this parameter is set to &apos;1&apos; all hydrogen is bypassed. If the parameter is set to &apos;0&apos; all hydrogen is methanated. The bypass fraction is controlled via a PID-controller whereby the set value is equal to &apos;hydrogenContentOutput&apos;. if &apos;<span style=\"font-family: Courier New;\">useVariableHydrogenFraction&apos;=false the meassurement-signal is equal to the volumetric hydrogen fraction at the output. If &apos;useVariableHydrogenFraction&apos;=true the meassurement-signal is equal to the input value &apos;hydrogenFraction_input&apos;. </span>This allows defining the hydrogen fraction in the SNG depending of the hydrogen fraction in an outer gas grid.</p>
<p>Consider that the output of the methanator still contains hydrogen such that an actual molar hydrogen content of &apos;0&apos; can not be achieved.</p>
<p>Via the parameter &apos;<span style=\"font-family: Courier New;\">useSeperateHydrogenOutput</span>&apos; an additional hydrogen output can be activated. The gas of this output is not methanated before and can be controlled via the input m_flow_feedIn_H2.</p>
<p>Via parameter &apos;useLeakageMassFlow&apos; a small mass flow of &apos;simCenter.m_flow_small&apos; is always flowing out of gas ports (to avoid Zero-Mass-Flow problems)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>see sub models </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>P_el_set: input for the set value for the electric power </p>
<p>m_flow_feedIn: input for the possible feed-in mass flow into the natural grid etc. </p>
<p>m_flow_feedIn_H2: input for the possible feed-in mass flow of Hydrogen into the natural grid etc. </p>
<p>epp: electric power port for the electrolyzer </p>
<p>gasPortOut: outlet of SNG </p>
<p>gasPortOut_H2: outlet of hydrogen</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>For start up, a small hydrogen mass flow for the electrolyzer can be set to allow for simpler initialisation. </p>
<p>If useMassFlowControl=true, the electrical power of the electrolyzer will no more be limited by given m_flow_feed. This simplifies the controller if limitation is not needed. useMassFlowControl=false should only be used if feedInStation_Hydrogen has no hydrogen storage and the parameter useMassFlowControl is set to &apos;false&apos; in feedInStation_Hydrogen as well.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in check model TransiEnt.Producer.Gas.MethanatorSystem.Check.Test FeedInStation_Methanator</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p><br>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) in Feb 2018</p>
<p>Model modified by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) in Jul 2018: added conditional separate hydrogen port</p>
<p>Model modified by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) in Nov 2018: TWV for Hydrogen output is controled without PID now for faster simulation results. useLeakageMassFlow added</p>
<p>Model modified by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) in April 2019: added Boolean useMassFlowControl</p>
<p>Model modified by Carsten Bode (c.bode@tuhh.de), Feb 2021 (added separate medium models for CO2 and H2/SNG)</p>
</html>"));
end FeedInStation_Methanation;
