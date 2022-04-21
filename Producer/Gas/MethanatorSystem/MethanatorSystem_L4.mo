within TransiEnt.Producer.Gas.MethanatorSystem;
model MethanatorSystem_L4


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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

  extends TransiEnt.Producer.Gas.MethanatorSystem.PartialMethanatorSystem(N_cv=10);
  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter SI.MassFlowRate m_flow_n_CH4=if scalingOfReactor==1 then m_flow_n_Methane elseif scalingOfReactor==2 then m_flow_n_Hydrogen*2.0422868 elseif scalingOfReactor==3 then H_flow_n_Methane/50.013e6 elseif scalingOfReactor==4 then H_flow_n_Hydrogen*0.83/50.013e6 else -99 "esimiation of nominal mass flow of methanation - else case is error case";

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________


  parameter SI.PressureDifference Delta_p_meth=0e5 "Pressure loss in the methanator" annotation(Dialog(group="Pressure Losses"));
  parameter SI.PressureDifference Delta_p_hEXBeforeMeth=0e5 "Pressure loss in the heat exchanger before the methanator" annotation(Dialog(group="Pressure Losses"));
  parameter SI.PressureDifference Delta_p_gas_hEXAfterMeth=0e5 "Pressure loss on the gas side in the heat exchanger after the methanator" annotation(Dialog(group="Pressure Losses"));
  parameter SI.PressureDifference Delta_p_water_hEXAfterMeth=0e5 "Pressure loss on the water side in the heat exchanger after the methanator" annotation(Dialog(group="Pressure Losses"));
  parameter SI.PressureDifference Delta_p_dryer=0e5 "Pressure loss in the dryer" annotation(Dialog(group="Pressure Losses"));



  parameter SI.Pressure p_start_junction=p_start[N_cv] "Initial value for gas pressure"
                                                                                       annotation(Dialog(group="Initial Values"));
  parameter SI.Temperature T_start_junction=T_out_SNG "Initial value for gas temperature (used in calculation of h_start)" annotation(Dialog(group="Initial Values"));
  parameter SI.MassFraction[vle_sg4.nc - 1] xi_start_junction={xi_start[1,1]/(1-xi_start[1,3]),xi_start[1,2]/(1-xi_start[1,3]),0} "Initial value for mass fractions"   annotation(Dialog(group="Initial Values"));
  parameter SI.Volume volume_junction=m_flow_n_CH4*2/10.8563966 "junction of volume" annotation (Dialog(               group="Fundamental Definitions"));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  TransiEnt.Components.Gas.Reactor.Methanator_L4 methanator(
    N_cv=N_cv,
    redeclare model CostSpecsGeneral = CostSpecsGeneral,
    ScalingOfReactor=scalingOfReactor,
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
    xi(start=xi_start)) annotation (Placement(transformation(extent={{-16,36},{-8,44}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor moleCompIn(medium=vle_sg4, compositionDefinedBy=2,
    flowDefinition=3)                                                                                       annotation (Placement(transformation(extent={{-54,40},{-42,52}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature_preheater annotation (Placement(transformation(
        extent={{-3,3},{3,-3}},
        rotation=0,
        origin={-39,63})));
  TransiEnt.Basics.Adapters.Gas.Ideal_to_Real ideal_to_Real(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var real, redeclare TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG4_var ideal) annotation (Placement(transformation(extent={{-2,36},{6,44}})));
  TransiEnt.Basics.Adapters.Gas.Real_to_Ideal real_to_Ideal(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var real, redeclare TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG4_var ideal) annotation (Placement(transformation(extent={{-28,36},{-20,44}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor moleCompOut_Dried(medium=vle_sg4, compositionDefinedBy=2,
    flowDefinition=3)                                                                                              annotation (Placement(transformation(extent={{58,40},{68,52}})));

  Modelica.Blocks.Sources.RealExpression realExpression(y=225 + 273.15)
                                                                    annotation (Placement(transformation(extent={{-56,58},{-46,68}})));

  TransiEnt.Components.Gas.VolumesValvesFittings.Valves.ValveDesiredPressureBefore valve_pBeforeValveDes1(final medium=vle_sg4, p_BeforeValveDes=p_nom[N_cv]) annotation (Placement(transformation(
        extent={{4.5,-4.5},{-4.5,4.5}},
        rotation=90,
        origin={99.5,31.5})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow Sink_CO2(
    medium=medium_CO2,
    variable_m_flow=true,
    xi_const={0,0,0,0,0,1},
    T_const=493.15) if useCO2Input annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-60,-78})));
  TransiEnt.Components.Gas.GasCleaning.Dryer_L1 dryer(
    medium_gas=vle_sg4,
    medium_water=TILMedia.VLEFluidTypes.TILMedia_SplineWater(),
    pressureLoss=Delta_p_dryer) annotation (Placement(transformation(extent={{44,36},{52,44}})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_pTxi
                                                           sink_water(
    boundaryConditions(showData=false),
    variable_p=false,
    medium=TILMedia.VLEFluidTypes.TILMedia_SplineWater())                                             annotation (Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=270,
        origin={48,50})));
  TransiEnt.Components.Gas.HeatExchanger.HEXOneRealGasOuterTIdeal_L1 hEXBeforeMeth(
    medium=TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var(),
    T_fluidOutConst=T_nom[1],
    Delta_p=Delta_p_hEXBeforeMeth) annotation (Placement(transformation(extent={{-40,36},{-32,44}})));
  TransiEnt.Components.Gas.HeatExchanger.HEXOneRealGasOuterTIdeal_L1 hEXOneRealGasOuterTIdeal_L1_1(
    T_fluidOutConst=T_out_SNG,
    Delta_p=Delta_p_gas_hEXAfterMeth,
    medium=TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var()) annotation (Placement(transformation(extent={{10,36},{18,44}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature_cooler annotation (Placement(transformation(
        extent={{-3,3},{3,-3}},
        rotation=0,
        origin={11,63})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=T_out_SNG) annotation (Placement(transformation(extent={{-6,58},{4,68}})));
 TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow Source_CO2(
    medium=vle_sg4,
    variable_m_flow=true,
    T_const=493.15,
    xi_const={0,1,0})  annotation (Placement(transformation(extent={{-4,4},{4,-4}},
        rotation=-90,
        origin={-56,54})));
  TransiEnt.Producer.Gas.MethanatorSystem.Controller.ControllerCO2ForMethanator controllerCO2ForMethanator annotation (Placement(transformation(extent={{-58,62},{-66,70}})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massFlowSensor_Hydrogen(medium=vle_sg4, xiNumber=0)
                                                                                             annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-64,46})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Valves.ThreeWayValveRealGas_L1_simple TWV(medium=vle_sg4, splitRatio_input=true) annotation (Placement(transformation(
        extent={{5,4.5},{-5,-4.5}},
        rotation=180,
        origin={-77,39.5})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2 junction(
    initOption=0,
    medium=vle_sg4,
    redeclare model PressureLoss3 = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.Linear (m_flow_nom=m_flow_n_CH4, dp_nom=1e4),
    volume=volume_junction,
    p_start=p_start_junction,
    T_start=T_start_junction) annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={76,40})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensor(
    medium=vle_sg4,
    compositionDefinedBy=2,
    flowDefinition=3)                                                                              annotation (Placement(transformation(
        extent={{5,6},{-5,-6}},
        rotation=180,
        origin={89,46})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=x_H2)
                                                         annotation (Placement(transformation(extent={{-52,72},{-62,84}})));
  Modelica.Blocks.Sources.RealExpression realExpression4(y=hydrogenFraction_fixed) annotation (Placement(transformation(extent={{-52,80},{-62,92}})));
  TransiEnt.Basics.Blocks.LimPID PID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    sign=-1,
    y_max=1,
    y_min=0,
    k=3,
    Tau_i=5,
    initOption=501,
    y_start=1)
             annotation (Placement(transformation(extent={{-68,82},{-74,88}})));
  TransiEnt.Basics.Adapters.Gas.RealNG7_to_RealSG4 realNG7_SG_to_RealSG4_var(medium_sg4=vle_sg4, medium_ng7_H2=medium) annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-100,18})));
  TransiEnt.Basics.Adapters.Gas.RealSG4_to_RealNG7 realSG4_var_to_RealNG7_SG(medium_sg4=vle_sg4, medium_ng7_H2=medium) annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=90,
        origin={100,18})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow Source_smallMassFlow(
    medium=vle_sg4,
    m_flow_const=-1,
    T_const=283.15,
    xi_const={0,0,0}) annotation (Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=-90,
        origin={-94,66})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow Sink_smallMassFlow(
    medium=vle_sg4,
    variable_m_flow=true,
    m_flow_const=-0.1,
    T_const=493.15,
    xi_const={0,0,0}) annotation (Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=-90,
        origin={94,56})));
  Modelica.Blocks.Sources.RealExpression realExpression5(y=if noEvent(junction.gasPort3.m_flow > 0.1*junction.gasPort3.m_flow/TWV.gasPortIn.m_flow*1.1) then -junction.gasPort3.m_flow else max(0, -1*junction.gasPort3.m_flow/TWV.gasPortIn.m_flow))
                                                         annotation (Placement(transformation(extent={{72,54},{82,66}})));
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
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature_wasteHeat[N_cv] annotation (Placement(transformation(
        extent={{-3,3},{3,-3}},
        rotation=0,
        origin={-17,63})));
  Modelica.Blocks.Sources.RealExpression realExpression3
                                                       [N_cv](y=T_nom) annotation (Placement(transformation(extent={{-34,58},{-24,68}})));
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

  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasIn(
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    h=inStream(gasPortIn.h_outflow),
    p=gasPortIn.p,
    xi=inStream(gasPortIn.xi_outflow),
    deactivateTwoPhaseRegion=true,
    vleFluidType=medium) annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasOut(
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    deactivateTwoPhaseRegion=true,
    vleFluidType=medium,
    p=realSG4_var_to_RealNG7_SG.gasPortOut.p,
    xi=realSG4_var_to_RealNG7_SG.gasPortOut.xi_outflow,
    h=realSG4_var_to_RealNG7_SG.gasPortOut.h_outflow) annotation (Placement(transformation(extent={{80,-80},{100,-60}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
  SI.Mass mass_SNG "total produced SNG";
  SI.VolumeFraction x_H2 "calculated hydrogen volume fraction in output";
public
  SI.Power H_flow_in_NCV "inflowing enthalpy flow based on NCV";
  SI.Power H_flow_out_NCV "outflowing enthalpy flow based on NCV";
  SI.Power H_flow_in_GCV "inflowing enthalpy flow based on GCV";
  SI.Power H_flow_out_GCV "outflowing enthalpy flow based on GCV";
equation
  T_out_coolant_max=methanator.T[1];
  if integrateMassFlow then
    der(mass_SNG)=-dryer.gasPortOut.m_flow;
  else
    mass_SNG=0;
  end if;

  Q_flow=-(H_flow_in_GCV+H_flow_out_GCV)-Q_loss;
  m_flow_n_Hydrogen_is=methanator.H_flow_n_methanation_H2/methanator.NCV[4];

  H_flow_in_NCV=gasPortIn.m_flow*sum(NCV*cat(1,gasIn.xi,{1-sum(gasIn.xi)}));
  H_flow_out_NCV=gasPortOut.m_flow*sum(NCV*cat(1,gasOut.xi,{1-sum(gasOut.xi)}));
  H_flow_in_GCV=gasPortIn.m_flow*sum(GCV*cat(1,gasIn.xi,{1-sum(gasIn.xi)}));
  H_flow_out_GCV=gasPortOut.m_flow*sum(GCV*cat(1,gasOut.xi,{1-sum(gasOut.xi)}));

  x_H2=(1-sum(junction.gasPort3.xi_outflow))/rho_H2*junction.summary.gasPort3.rho;

  connect(real_to_Ideal.gasPortOut, methanator.gasPortIn) annotation (Line(
      points={{-20,40},{-16,40}},
      color={255,213,170},
      thickness=1.5));

  connect(methanator.gasPortOut, ideal_to_Real.gasPortIn) annotation (Line(
      points={{-8,40},{-2,40}},
      color={255,213,170},
      thickness=1.5));
  connect(moleCompOut_Dried.gasPortIn, dryer.gasPortOut) annotation (Line(
      points={{58,40},{52,40}},
      color={255,255,0},
      thickness=1.5));
  connect(moleCompIn.gasPortOut, hEXBeforeMeth.gasPortIn) annotation (Line(
      points={{-42,40},{-40,40}},
      color={255,255,0},
      thickness=1.5));
  connect(real_to_Ideal.gasPortIn, hEXBeforeMeth.gasPortOut) annotation (Line(
      points={{-28,40},{-32,40}},
      color={255,255,0},
      thickness=1.5));
  connect(sink_water.fluidPortIn, dryer.fluidPortOut) annotation (Line(
      points={{48,46},{48,44}},
      color={175,0,0},
      thickness=0.5));
  connect(ideal_to_Real.gasPortOut, hEXOneRealGasOuterTIdeal_L1_1.gasPortIn) annotation (Line(
      points={{6,40},{10,40}},
      color={255,255,0},
      thickness=1.5));
  connect(prescribedTemperature_cooler.port, hEXOneRealGasOuterTIdeal_L1_1.heat) annotation (Line(points={{14,63},{14,44}}, color={191,0,0}));
  connect(controllerCO2ForMethanator.m_flow_CO2, Source_CO2.m_flow) annotation (Line(points={{-62,61.6},{-62,58.8},{-58.4,58.8}},          color={0,0,127}));
  connect(Source_CO2.gasPort, moleCompIn.gasPortIn) annotation (Line(
      points={{-56,50},{-56,40},{-54,40}},
      color={255,255,0},
      thickness=1.5));
  connect(gasPortIn, gasPortIn) annotation (Line(
      points={{-100,0},{-97,0},{-97,0},{-100,0}},
      color={255,255,0},
      thickness=1.5));
  connect(massFlowSensor_Hydrogen.gasPortOut, moleCompIn.gasPortIn) annotation (Line(
      points={{-70,40},{-54,40}},
      color={255,255,0},
      thickness=1.5));
  connect(massFlowSensor_Hydrogen.gasPortIn, TWV.gasPortOut1) annotation (Line(
      points={{-58,40},{-72,40}},
      color={255,255,0},
      thickness=1.5));
  connect(junction.gasPort1, moleCompOut_Dried.gasPortOut) annotation (Line(
      points={{70,40},{68,40}},
      color={255,255,0},
      thickness=1.5));
  connect(controllerCO2ForMethanator.m_flow_H2, massFlowSensor_Hydrogen.m_flow) annotation (Line(points={{-66,66},{-72,66},{-72,46},{-70.6,46}},                 color={0,0,127}));
  connect(compositionSensor.gasPortIn, junction.gasPort3) annotation (Line(
      points={{84,40},{82,40}},
      color={255,255,0},
      thickness=1.5));
  if useVariableHydrogenFraction then
  connect(PID.u_m,hydrogenFraction_input);
  else
  connect(realExpression2.y, PID.u_m) annotation (Line(points={{-62.5,78},{-71.03,78},{-71.03,81.4}}, color={0,0,127}));
  end if;
  connect(PID.u_s, realExpression4.y) annotation (Line(points={{-67.4,85},{-62.5,85},{-62.5,86}}, color={0,0,127}));
  connect(PID.y, TWV.splitRatio_external) annotation (Line(points={{-74.3,85},{-77,85},{-77,44.5}},color={0,0,127}));
  connect(gasPortIn, realNG7_SG_to_RealSG4_var.gasPortIn) annotation (Line(
      points={{-100,0},{-100,12}},
      color={255,255,0},
      thickness=1.5));
  connect(realNG7_SG_to_RealSG4_var.gasPortOut, TWV.gasPortIn) annotation (Line(
      points={{-100,24},{-100,40},{-82,40}},
      color={255,255,0},
      thickness=1.5));
  connect(realSG4_var_to_RealNG7_SG.gasPortOut, gasPortOut) annotation (Line(
      points={{100,12},{100,0}},
      color={255,255,0},
      thickness=1.5));
  if useCO2Input then
    connect(gasPortIn_CO2,Sink_CO2. gasPort) annotation (Line(
      points={{-60,-100},{-60,-84}},
      color={255,255,0},
      thickness=1.5));
    connect(Sink_CO2.m_flow, add.y) annotation (Line(points={{-56.4,-70.8},{-56,-70.8},{-56,-64.6}}, color={0,0,127}));
    connect(realExpression7.y, add.u2) annotation (Line(points={{-63.1,-43},{-59.6,-43},{-59.6,-50.8}}, color={0,0,127}));
    connect(controllerCO2ForMethanator.m_flow_CO2, add.u1) annotation (Line(points={{-62,61.6},{-62,-4},{-52.4,-4},{-52.4,-50.8}}, color={0,0,127}));
  end if;
  connect(Source_smallMassFlow.gasPort, TWV.gasPortIn) annotation (Line(
      points={{-94,62},{-94,40},{-82,40}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensor.gasPortOut, Sink_smallMassFlow.gasPort) annotation (Line(
      points={{94,40},{94,52}},
      color={255,255,0},
      thickness=1.5));
  connect(Sink_smallMassFlow.m_flow, realExpression5.y) annotation (Line(points={{91.6,60.8},{84.8,60.8},{84.8,60},{82.5,60}}, color={0,0,127}));
  connect(realSG4_var_to_RealNG7_SG.gasPortIn, valve_pBeforeValveDes1.gasPortOut) annotation (Line(
      points={{100,24},{100,25.5},{100.143,25.5},{100.143,27}},
      color={255,255,0},
      thickness=1.5));
  connect(valve_pBeforeValveDes1.gasPortIn, compositionSensor.gasPortOut) annotation (Line(
      points={{100.143,36},{100.143,40},{94,40}},
      color={255,255,0},
      thickness=1.5));
  connect(dryer.gasPortIn, hEXOneRealGasOuterTIdeal_L1_1.gasPortOut) annotation (Line(
      points={{44,40},{18,40}},
      color={255,255,0},
      thickness=1.5));
  connect(TWV.gasPortOut2, junction.gasPort2) annotation (Line(
      points={{-77,35},{-77,28},{76,28},{76,34}},
      color={255,255,0},
      thickness=1.5));

  connect(realExpression3.y, prescribedTemperature_wasteHeat.T) annotation (Line(points={{-23.5,63},{-20.6,63}},                         color={0,0,127}));
  connect(prescribedTemperature_wasteHeat.port, methanator.heat) annotation (Line(points={{-14,63},{-14,64},{-12,64},{-12,44}}, color={191,0,0}));
  connect(realExpression.y, prescribedTemperature_preheater.T) annotation (Line(points={{-45.5,63},{-42.6,63}},                         color={0,0,127}));
  connect(prescribedTemperature_preheater.port, hEXBeforeMeth.heat) annotation (Line(points={{-36,63},{-36,44}}, color={191,0,0}));
  connect(realExpression1.y, prescribedTemperature_cooler.T) annotation (Line(points={{4.5,63},{6.25,63},{6.25,63},{7.4,63}}, color={0,0,127}));
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
<p>Calculation of Coolant Heat Flow:</p>
<p>Via the parameteres &apos;useHeatPort&apos; or &apos;useFluidCoolantPort&apos; a heat port or two fluid ports can be activated to model the needed coolant heat flow. Only one port at a time can be modeled. When using the fluid ports the output temperature can be defined via the input &apos;T_set_coolant_out&apos;. This temperature will be limited by the technical feasible temperature. This input needs to be activated via the parameter &apos;useVariableCoolantOutputTemperature&apos;. If not used the temperature of the coolant will be equal to the technical feasible temperature. Consider that using the heatPort will allow a simplified simulation of the heat Flow but will neglect the temperature level of the heat.</p>
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
end MethanatorSystem_L4;
