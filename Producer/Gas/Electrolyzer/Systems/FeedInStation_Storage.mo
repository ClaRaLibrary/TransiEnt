within TransiEnt.Producer.Gas.Electrolyzer.Systems;
model FeedInStation_Storage

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
// Copyright 2020, Hamburg University of Technology.                              //
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

  extends TransiEnt.Producer.Gas.Electrolyzer.Base.PartialFeedInStation;

  // _____________________________________________
  //
  //           Constants and Parameters
  // _____________________________________________

parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel3 "Hydrogen model to be used" annotation (Dialog(tab="General", group="General"));
  parameter SI.ActivePower P_el_n=1e6 "nominal power of electrolyser" annotation (Dialog(tab="General", group="Electrolyzer"));
  parameter SI.ActivePower P_el_max=1.68*P_el_n "Maximum power of electrolyzer" annotation (Dialog(tab="General", group="Electrolyzer"));
  parameter SI.ActivePower P_el_min=0.05*P_el_n "Minimal power of electrolyzer" annotation (Dialog(tab="General", group="Electrolyzer"));
  parameter SI.ActivePower P_el_overload=1.0*P_el_n "Power at which overload region begins" annotation (Dialog(tab="General", group="Electrolyzer"));
  parameter SI.ActivePower P_el_cooldown=P_el_n "Power below which cooldown of electrolyzer starts" annotation(Dialog(group="Electrolyzer"));
  parameter SI.MassFlowRate m_flow_start=0.0 "Sets initial value for m_flow from a buffer" annotation (Dialog(tab="General", group="Initialization"));
  //parameter SI.Temperature T_Init=283.15 "Sets initial value for T" annotation (Dialog(tab="General", group="Initialization"));
  parameter SI.Efficiency eta_n(
    min=0,
    max=1)=0.75 "Nominal efficency refering to the GCV (min = 0, max = 1)" annotation (Dialog(tab="General", group="Electrolyzer"));
  parameter SI.Efficiency eta_scale(
    min=0,
    max=1)=0 "Sets a with increasing input power linear degrading efficiency coefficient (min = 0, max = 1)" annotation (Dialog(tab="General", group="Electrolyzer"));

  parameter Real t_overload=0.5*3600 "Maximum admissible time the electrolyzer can work in overload region in seconds" annotation (Dialog(tab="General", group="Electrolyzer"));
  parameter Real coolingToHeatingRatio=1 "Defines how much faster electrolyzer cools down than heats up" annotation (Dialog(tab="General", group="Electrolyzer"));
  parameter Integer startState=1 "Initial state of the electrolyzer (1: ready to overheat, 2: working in overload, 3: cooling down)" annotation (Dialog(tab="General", group="Electrolyzer"));

  parameter SI.AbsolutePressure p_out=35e5 "Hydrogen output pressure from electrolyser" annotation (Dialog(tab="General", group="Electrolyzer"));
  parameter SI.Temperature T_out=283.15 "Hydrogen output temperature from electrolyser" annotation (Dialog(tab="General", group="Electrolyzer"));
  parameter Real specificWaterConsumption=10 "Mass of water per mass of hydrogen" annotation (Dialog(tab="General", group="Electrolyzer"));

  parameter Boolean useIsothMix=false "Choose if the temperature changes in junction should be neglected" annotation (Dialog(group="Junction"));
  parameter SI.SpecificEnthalpy h_start_junction=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(medium,p_start_junction,T_start_junction,medium.xi_default) "Initial specific enthalpy (can be calculated by StaticCycle)" annotation (Dialog(tab="General", group="Junction"));
  parameter SI.AbsolutePressure p_start_junction=simCenter.p_amb_const+simCenter.p_eff_2 "Initial pressure in the junction" annotation (Dialog(tab="General", group="Junction"));
  parameter SI.Temperature T_start_junction=simCenter.T_ground "Initial temperature" annotation (Dialog(tab="General", group="Junction"));
  parameter ClaRa.Basics.Units.Volume volume_junction=0.01 "Volume in the junction" annotation (Dialog(tab="General", group="Junction"));
  parameter Integer initOption=0 "Type of initialisation" annotation(Dialog(tab="General", group="Junction"),  choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=201 "Steady pressure",
      choice=202 "Steady enthalpy",
      choice=208 "Steady pressure and enthalpy",
      choice=210 "Steady density"));

  parameter Boolean start_pressure=true "true if a start pressure is defined, false if a start mass is defined" annotation (Dialog(tab="Storage"));
  parameter Boolean includeHeatTransfer=true "false for neglecting heat transfer" annotation (Dialog(tab="Storage"));
  parameter SI.Volume V_geo=1e5 "Geometric volume of storage" annotation (Dialog(tab="Storage"));
  parameter SI.Height height=3.779*V_geo^(1/3) "Height of storage" annotation (Dialog(tab="Storage"));
  parameter SI.CoefficientOfHeatTransfer alpha_nom=4 "Heat transfer coefficient inside the storage cylinder" annotation (Dialog(tab="Storage"));
  parameter SI.Mass m_start=1 "Stored gas mass at t=0" annotation (Dialog(tab="Storage"));
  parameter SI.Pressure p_start=simCenter.p_amb_const+simCenter.p_eff_2 "Pressure in storage at t=0" annotation (Dialog(tab="Storage"));
  parameter SI.ThermodynamicTemperature T_start=283.15 "Temperature of gas in storage at t=0" annotation (Dialog(tab="Storage"));
  parameter SI.Pressure p_maxLow=p_maxHigh-1e5 "Lower limit of the maximum pressure in storage" annotation (Dialog(tab="Storage", group="Control"));
  parameter SI.Pressure p_maxHigh=p_out "Upper limit of the maximum pressure in storage" annotation (Dialog(tab="Storage", group="Control"));
  parameter SI.Pressure p_minLow_constantDemand=0.5e3 "storage can be emptied via 'm_flow_hydrogenDemand_constant' up to 'p_minLow_constantDemand'" annotation (Dialog(tab="Storage", group="Control"));
  parameter SI.MassFlowRate m_flow_hydrogenDemand_constant=0 "constant hydrogen demand if hydrogen is available" annotation (Dialog(tab="Storage", group="Control"));

  parameter SI.Pressure dp_Low=1e3 "if valve open and (p_in-p_out) <= dp_Low, close valve" annotation (Dialog(tab="Storage", group="Control"));
  parameter SI.Pressure dp_High=1e5 "if valve closed and (p_in-p_out) >= dp_High, open valve" annotation (Dialog(tab="Storage", group="Control"));

  parameter Boolean StoreAllHydrogen=false "|Storage|Control|All Hydrogen is stored before beeing fed in" annotation (Dialog(tab="Storage", group="Control"));

  parameter Real k=1e8 "Gain for feed-in control" annotation (Dialog(tab="General", group="Controller"));
  parameter Real Ti=0.1 "Ti for feed-in control";
  parameter Real Td=0.1 "Td for feed-in control";

  replaceable model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200        constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.PartialElectrolyzerEfficiencyCharline        "Calculate the efficiency" annotation (Dialog(group="Electrolyzer"),__Dymola_choicesAllMatching=true);
  replaceable model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder        constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.PartialElectrolyzerDynamics        "Dynamic behavior of electrolyser" annotation (Dialog(group="Electrolyzer"),__Dymola_choicesAllMatching=true);
  replaceable model PressureLossAtOutlet = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.NoFriction constrainedby ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.BaseDp "Pressure loss at outlet (can help reducing the system of equations)" annotation(choicesAllMatching=true);

  //Statistics
  replaceable model CostSpecsElectrolyzer = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Empty
    constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs "Cost configuration electrolyzer" annotation (Dialog(tab="Statistics"), choices(choicesAllMatching=true));
  replaceable model CostSpecsStorage = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Empty
    constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs "Cost configuration storage" annotation (Dialog(tab="Statistics"), choices(choicesAllMatching=true));
  parameter Real Cspec_demAndRev_other_water=simCenter.Cspec_demAndRev_other_water "Specific demand-related cost per cubic meter water of electrolyzer" annotation (Dialog(tab="Statistics"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_el_electrolyzer=simCenter.Cspec_demAndRev_free "Specific demand-related cost per electric energy for electrolyzer" annotation (Dialog(tab="Statistics"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_el_other=simCenter.Cspec_demAndRev_el_70_150_GWh "Specific demand-related cost per electric energy for compressor and start gas generation" annotation (Dialog(tab="Statistics"));
  parameter Boolean integrateMassFlow=false "True, if mass flow shall be integrated";
  parameter Boolean useFluidModelsForSummary=false "True, if fluid models shall be used for the summary" annotation(Dialog(tab="Summary"));

  parameter Boolean useFluidCoolantPort=false "choose if fluid port for coolant shall be used" annotation (Dialog(enable=not useHeatPort,group="Coolant"));
  parameter Boolean useHeatPort=false "choose if heat port for coolant shall be used" annotation (Dialog(enable=not useFluidCoolantPort,group="Coolant"));
  parameter Boolean useVariableCoolantOutputTemperature=false "choose if temperature of cooland output shall be defined by input" annotation (Dialog(enable=useFluidCoolantPort,group="Coolant"));
  parameter SI.Temperature T_out_coolant_target=500+273.15 "output temperature of coolant - will be limited by temperature which is technically feasible" annotation (Dialog(enable=useFluidCoolantPort,group="Coolant"));
  parameter Boolean externalMassFlowControl=false "choose if heat port for coolant shall be used" annotation (Dialog(enable=useFluidCoolantPort and (not useVariableCoolantOutputTemperature), group="Coolant"));

  // _____________________________________________
  //
  //                  Variables
  // _____________________________________________
  SI.Mass mass_H2_fedIn "Fed in hydrogen mass";
  SI.ActivePower P_el_max_is=if controlTotalElyStorage.overloadController.state==3 then controlTotalElyStorage.overloadController.P_el_cooldown elseif controlTotalElyStorage.feedInStorageController.storageFull then controlTotalElyStorage.feedInStorageController.limPID.y else P_el_max;
protected
  model Outline
    extends TransiEnt.Basics.Icons.Record;
    input SI.Mass mass_H2_fedIn "Fed in hydrogen mass";
  end Outline;

  model ElectrolyzerRecord
    extends TransiEnt.Basics.Icons.Record;
    input SI.Power P_el "Consumed electric power";
    input SI.Energy W_el "Consumed electric energy";
    input SI.Mass mass_H2 "Produced hydrogen mass";
    input SI.Efficiency eta_NCV "Electroyzer efficiency based on NCV";
    input SI.Efficiency eta_GCV "Electroyzer efficiency based on GCV";
  end ElectrolyzerRecord;

  model Summary
    extends TransiEnt.Basics.Icons.Record;
    Outline outline;
    ElectrolyzerRecord electrolyzer;
    TransiEnt.Basics.Records.RealGasBulk storage;
    TransiEnt.Basics.Records.FlangeRealGas gasPortElectrolyzer;
    TransiEnt.Basics.Records.FlangeRealGas gasPortStorageIn;
    TransiEnt.Basics.Records.FlangeRealGas gasPortStorageOut;
    TransiEnt.Basics.Records.FlangeRealGas gasPortAfterBypassValve;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
    TransiEnt.Basics.Records.Costs costsElectrolyzer;
    TransiEnt.Basics.Records.CostsStorage costsStorage;
  end Summary;


  // _____________________________________________
  //
  //               Complex Components
  // _____________________________________________
protected
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sourceH2(
    variable_m_flow=true,
    final medium=medium,
    xi_const=zeros(sourceH2.medium.nc - 1)) annotation (Placement(transformation(extent={{-76,-43},{-60,-27}})));

  Modelica.Blocks.Sources.Ramp ramp(
    duration=1,
    startTime=3,
    offset=-m_flow_start,
    height=+m_flow_start)
                         annotation (Placement(transformation(extent={{-96,-36},{-84,-24}})));
public
  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L1 electrolyzer(
    useFluidCoolantPort=useFluidCoolantPort,
    useHeatPort=useHeatPort,
    externalMassFlowControl=externalMassFlowControl,
    useVariableCoolantOutputTemperature=useVariableCoolantOutputTemperature,
    T_out_coolant_target=T_out_coolant_target,
    usePowerPort=usePowerPort,
    final P_el_n=P_el_n,
    final P_el_max=P_el_max,
    final eta_n=eta_n,
    final eta_scale=eta_scale,
    final T_out=T_out,
    final medium=medium,
    redeclare model Dynamics = Dynamics,
    redeclare model Charline = Charline,
    redeclare model CostSpecsGeneral = CostSpecsElectrolyzer,
    specificWaterConsumption=specificWaterConsumption,
    Cspec_demAndRev_other=Cspec_demAndRev_other_water,
    Cspec_demAndRev_el=Cspec_demAndRev_el_electrolyzer)   annotation (Placement(transformation(extent={{-84,-16},{-54,16}})));
protected
  TransiEnt.Components.Gas.VolumesValvesFittings.ValveDesiredPressureBefore valve_pBeforeValveDes(
    final medium=medium,
    p_BeforeValveDes=p_out,
    useFluidModelsForSummary=useFluidModelsForSummary) annotation (Placement(transformation(
        extent={{8,-4},{-8,4}},
        rotation=90,
        origin={8,-18})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massflowSensor_bypass(final medium=medium, xiNumber=0)         annotation (Placement(transformation(
        extent={{7,6},{-7,-6}},
        rotation=90,
        origin={14,-37})));

  TransiEnt.Basics.Adapters.Gas.RealH2_to_RealNG h2toNG(final medium_h2=medium) annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=90,
        origin={0,-72})));
public
  TransiEnt.Storage.Gas.GasStorage_constXi_L2 storage(
    start_pressure=start_pressure,
    includeHeatTransfer=includeHeatTransfer,
    medium=medium,
    V_geo=V_geo,
    redeclare model HeatTransfer = TransiEnt.Storage.Gas.Base.ConstantHTOuterTemperature_L2 (alpha_nom=alpha_nom),
    m_gas_start=m_start,
    p_gas_start=p_start,
    T_gas_start=T_start,
    p_max=p_maxHigh,
    eta_ely=eta_n,
    redeclare model CostSpecsStorage = CostSpecsStorage,
    Cspec_demAndRev_el=Cspec_demAndRev_el_other) annotation (Placement(transformation(
        extent={{14,-15},{-14,15}},
        rotation=0,
        origin={40,-17})));

  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 mix_H2(
    redeclare model PressureLoss1 = PressureLossAtOutlet,
    h(
    start = h_start_junction),
    p(
    start = p_start_junction),
    medium=medium,
    volume=volume_junction,
    initOption=initOption) if not useIsothMix
                         annotation (Placement(transformation(
        extent={{-8,8},{8,-8}},
        rotation=0,
        origin={8,-56})));
protected
  TransiEnt.Components.Gas.VolumesValvesFittings.ThreeWayValveRealGas_L1_simple threeWayValve(
    splitRatio_input=true,
    medium=medium,
    showExpertSummary=false,
    showData=false,
    useFluidModelsForSummary=useFluidModelsForSummary) annotation (Placement(transformation(extent={{0,-8},{16,6}})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massflowSensor_ely(final medium=medium, xiNumber=0)         annotation (Placement(transformation(
        extent={{7,6},{-7,-6}},
        rotation=180,
        origin={-30,6})));
public
  TransiEnt.Producer.Gas.Electrolyzer.Controller.TotalFeedInStorageController controlTotalElyStorage(
    final k=k,
    p_minLow=dp_Low,
    final p_maxHigh=p_maxHigh,
    final p_maxLow=p_maxLow,
    final coolingToHeatingRatio=coolingToHeatingRatio,
    P_el_n=P_el_n,
    P_el_min=P_el_min,
    P_el_max=P_el_max,
    P_el_overload=P_el_overload,
    t_overload=t_overload,
    eta_n=eta_n,
    eta_scale=eta_scale,
    startState=startState,
    p_minHigh=dp_High,
    p_minLow_constantDemand=p_minLow_constantDemand,
    m_flow_hydrogenDemand_constant=m_flow_hydrogenDemand_constant,
    redeclare model Charline = Charline,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    StoreAllHydrogen=StoreAllHydrogen,
    P_el_cooldown=P_el_cooldown,
    Ti=Ti,
    Td=Td)                                                   annotation (Placement(transformation(extent={{-2,55},{18,75}})));
protected
  TransiEnt.Components.Gas.VolumesValvesFittings.ValveDesiredMassFlow valve_mFlowDes(
    medium=medium,
    Delta_p_low=dp_Low,
    Delta_p_high=dp_High) annotation (Placement(transformation(
        extent={{-8,-4},{8,4}},
        rotation=270,
        origin={40,-46})));
public
  inner Summary summary(
    outline(mass_H2_fedIn=mass_H2_fedIn),
    electrolyzer(
      P_el=electrolyzer.summary.outline.P_el,
      W_el=electrolyzer.summary.outline.W_el,
      mass_H2=electrolyzer.summary.outline.mass_H2,
      eta_NCV=electrolyzer.summary.outline.eta_NCV,
      eta_GCV=electrolyzer.summary.outline.eta_GCV),
    storage(
      mediumModel=storage.summary.gasBulk.mediumModel,
      xi=storage.summary.gasBulk.xi,
      x=storage.summary.gasBulk.x,
      mass=storage.summary.gasBulk.mass,
      T=storage.summary.gasBulk.T,
      p=storage.summary.gasBulk.p,
      h=storage.summary.gasBulk.h,
      rho=storage.summary.gasBulk.rho),
    gasPortElectrolyzer(
      mediumModel=electrolyzer.summary.gasPortOut.mediumModel,
      xi=electrolyzer.summary.gasPortOut.xi,
      x=electrolyzer.summary.gasPortOut.x,
      m_flow=electrolyzer.summary.gasPortOut.m_flow,
      T=electrolyzer.summary.gasPortOut.T,
      p=electrolyzer.summary.gasPortOut.p,
      h=electrolyzer.summary.gasPortOut.h,
      rho=electrolyzer.summary.gasPortOut.rho),
    gasPortStorageIn(
      mediumModel=storage.summary.gasPortIn.mediumModel,
      xi=storage.summary.gasPortIn.xi,
      x=storage.summary.gasPortIn.x,
      m_flow=storage.summary.gasPortIn.m_flow,
      T=storage.summary.gasPortIn.T,
      p=storage.summary.gasPortIn.p,
      h=storage.summary.gasPortIn.h,
      rho=storage.summary.gasPortIn.rho),
    gasPortStorageOut(
      mediumModel=storage.summary.gasPortOut.mediumModel,
      xi=storage.summary.gasPortOut.xi,
      x=storage.summary.gasPortOut.x,
      m_flow=storage.summary.gasPortOut.m_flow,
      T=storage.summary.gasPortOut.T,
      p=storage.summary.gasPortOut.p,
      h=storage.summary.gasPortOut.h,
      rho=storage.summary.gasPortOut.rho),
    gasPortAfterBypassValve(
      mediumModel=valve_pBeforeValveDes.summary.gasPortOut.mediumModel,
      useFluidModelsForSummary=useFluidModelsForSummary,
      xi=valve_pBeforeValveDes.summary.gasPortOut.xi,
      x=valve_pBeforeValveDes.summary.gasPortOut.x,
      m_flow=valve_pBeforeValveDes.summary.gasPortOut.m_flow,
      T=valve_pBeforeValveDes.summary.gasPortOut.T,
      p=valve_pBeforeValveDes.summary.gasPortOut.p,
      h=valve_pBeforeValveDes.summary.gasPortOut.h,
      rho=valve_pBeforeValveDes.summary.gasPortOut.rho),
    gasPortOut(
      mediumModel=simCenter.gasModel1,
      xi=gasOut.xi,
      x=gasOut.x,
      m_flow=-gasPortOut.m_flow,
      T=gasOut.T,
      p=gasPortOut.p,
      h=gasOut.h,
      rho=gasOut.d),
    costsElectrolyzer(
      costs=electrolyzer.summary.costs.costs,
      investCosts=electrolyzer.summary.costs.investCosts,
      demandCosts=electrolyzer.summary.costs.demandCosts,
      oMCosts=electrolyzer.summary.costs.oMCosts,
      otherCosts=electrolyzer.summary.costs.otherCosts,
      revenues=electrolyzer.summary.costs.revenues),
    costsStorage(
      costs=storage.summary.costs.costs,
      investCosts=storage.summary.costs.investCosts,
      investCostsStartGas=storage.summary.costs.investCostsStartGas,
      demandCosts=storage.summary.costs.demandCosts,
      oMCosts=storage.summary.costs.oMCosts,
      otherCosts=storage.summary.costs.otherCosts,
      revenues=storage.summary.costs.revenues)) annotation (Placement(transformation(extent={{-58,-100},{-38,-80}})));



  Basics.Interfaces.Thermal.FluidPortIn fluidPortIn(Medium=simCenter.fluid1) if useFluidCoolantPort annotation (Placement(transformation(extent={{90,-100},{110,-80}})));
  Basics.Interfaces.Thermal.FluidPortOut fluidPortOut(Medium=simCenter.fluid1) if useFluidCoolantPort     annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heat if useHeatPort annotation (Placement(transformation(extent={{90,-76},{110,-56}})));
  Basics.Interfaces.General.TemperatureIn T_set_coolant_out if useVariableCoolantOutputTemperature annotation (Placement(transformation(extent={{128,16},{88,56}})));
public
Components.Boundaries.Gas.BoundaryRealGas_Txim_flow           boundary_Txim_flow2(
    medium=medium,
    variable_m_flow=true,
    T_const=T_out)                                                                 annotation (Placement(transformation(extent={{5,-5},{-5,5}},
        rotation=-90,
        origin={55,-51})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=if storage.p_gas >= p_minLow_constantDemand then m_flow_hydrogenDemand_constant else 0) annotation (Placement(transformation(extent={{11,-8},{-11,8}},
        rotation=-90,
        origin={59,-76})));
  Components.Gas.VolumesValvesFittings.RealGasJunction_L2_isoth mix_H2_isoth(
    p_start=p_start_junction,
    redeclare model PressureLoss1 = PressureLossAtOutlet,
    medium=medium,
    volume=volume_junction,
    initOption=initOption) if useIsothMix annotation (Placement(transformation(
        extent={{-8,8},{8,-8}},
        rotation=0,
        origin={-10,-50})));
protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasOut(
    vleFluidType=simCenter.gasModel1,
    deactivateTwoPhaseRegion=true,
    h=gasPortOut.h_outflow,
    p=gasPortOut.p,
    xi=gasPortOut.xi_outflow) annotation (Placement(transformation(extent={{12,-98},{32,-78}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

if integrateMassFlow then
  der(mass_H2_fedIn)=-gasPortOut.m_flow;
else
  mass_H2_fedIn=0;
end if;

  connect(ramp.y,sourceH2.m_flow) annotation (Line(points={{-83.4,-30},{-83.4,-30.2},{-77.6,-30.2}},color={0,0,127}));
  if usePowerPort then
  connect(electrolyzer.epp, epp) annotation (Line(
      points={{-84,0},{-84,0},{-100,0}},
      color={0,135,135},
      thickness=0.5));
  end if;
  connect(threeWayValve.gasPortOut1, storage.gasPortIn) annotation (Line(
      points={{16,-0.222222},{28,-0.222222},{28,0},{40,0},{40,-9.65}},
      color={255,255,0},
      thickness=1.5));
  connect(threeWayValve.gasPortOut2, valve_pBeforeValveDes.gasPortIn) annotation (Line(
      points={{8,-8},{8,-10},{8.57143,-10}},
      color={255,255,0},
      thickness=1.5));
  connect(massflowSensor_bypass.m_flow, controlTotalElyStorage.m_flow_bypass) annotation (Line(points={{14,-44.7},{18,-44.7},{18,-45},{24,-45},{24,59},{18,59}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(massflowSensor_ely.m_flow, controlTotalElyStorage.m_flow_ely) annotation (Line(points={{-22.3,6},{-18,6},{-18,61},{-2,61}},  color={0,0,127},
      pattern=LinePattern.Dash));
  connect(controlTotalElyStorage.P_el_ely, electrolyzer.P_el_set) annotation (Line(points={{2,54},{2,30},{-75,30},{-75,19.2}},   color={0,0,127},
      pattern=LinePattern.Dash));
  connect(m_flow_feedIn, controlTotalElyStorage.m_flow_feedIn) annotation (Line(points={{108,70},{64,70},{64,71},{18,71}},
                                                                                                                   color={0,0,127},
      pattern=LinePattern.Dash));
  connect(controlTotalElyStorage.splitRatio, threeWayValve.splitRatio_external) annotation (Line(points={{8,54},{8,6.77778}},                 color={0,0,127},
      pattern=LinePattern.Dash));
  connect(P_el_set, controlTotalElyStorage.P_el_set) annotation (Line(
      points={{0,108},{0,82},{-12,82},{-12,69},{-2,69}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(h2toNG.gasPortOut, gasPortOut) annotation (Line(
      points={{0,-80},{0,-96},{0,-96}},
      color={255,255,0},
      thickness=1.5));
  connect(storage.p_gas, controlTotalElyStorage.p_storage) annotation (Line(
      points={{47,-17},{72,-17},{72,65},{18,65}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(storage.gasPortOut,valve_mFlowDes. gasPortIn) annotation (Line(
      points={{40,-26.45},{40,-38},{39.4286,-38}},
      color={255,255,0},
      thickness=1.5));
  if not useIsothMix then
    connect(mix_H2.gasPort1, h2toNG.gasPortIn) annotation (Line(
        points={{0,-56},{0,-60},{0,-64}},
        color={255,255,0},
        thickness=1.5));
    connect(valve_mFlowDes.gasPortOut, mix_H2.gasPort3) annotation (Line(
        points={{39.4286,-54},{39.4286,-56},{16,-56}},
        color={255,255,0},
        thickness=1.5));
    connect(massflowSensor_bypass.gasPortOut, mix_H2.gasPort2) annotation (Line(
        points={{8,-44},{8,-46},{8,-48}},
        color={255,255,0},
        thickness=1.5));
  else
    connect(mix_H2_isoth.gasPort1, h2toNG.gasPortIn) annotation (Line(
        points={{-18,-50},{-18,-64},{0,-64}},
        color={255,255,0},
        thickness=1.5));
    connect(valve_mFlowDes.gasPortOut, mix_H2_isoth.gasPort3) annotation (Line(
        points={{39.4286,-54},{39.4286,-50},{-2,-50}},
        color={255,255,0},
        thickness=1.5));
    connect(massflowSensor_bypass.gasPortOut, mix_H2_isoth.gasPort2) annotation (Line(
        points={{8,-44},{8,-42},{-10,-42}},
        color={255,255,0},
        thickness=1.5));
  end if;
  connect(electrolyzer.gasPortOut, massflowSensor_ely.gasPortIn) annotation (Line(
      points={{-54,0},{-37,0}},
      color={255,255,0},
      thickness=1.5));
  connect(massflowSensor_ely.gasPortOut, threeWayValve.gasPortIn) annotation (Line(
      points={{-23,0},{0,0},{0,-0.222222}},
      color={255,255,0},
      thickness=1.5));
  connect(valve_pBeforeValveDes.gasPortOut, massflowSensor_bypass.gasPortIn) annotation (Line(
      points={{8.57143,-26},{8,-28},{8,-30}},
      color={255,255,0},
      thickness=1.5));
  connect(sourceH2.gasPort, massflowSensor_ely.gasPortIn) annotation (Line(
      points={{-60,-35},{-56,-35},{-37,-35},{-37,8.88178e-016}},
      color={255,255,0},
      thickness=1.5));
  connect(controlTotalElyStorage.m_flowDes_valve, valve_mFlowDes.m_flowDes) annotation (Line(
      points={{14,54},{14,40},{58,40},{58,-38},{42.8571,-38}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  if useFluidCoolantPort then
    connect(electrolyzer.fluidPortIn, fluidPortIn) annotation (Line(
      points={{-54,-14.4},{70,-14.4},{70,-90},{100,-90}},
      color={175,0,0},
      thickness=0.5));
    connect(fluidPortOut, electrolyzer.fluidPortOut) annotation (Line(
      points={{100,-40},{82,-40},{82,-6.4},{-54,-6.4}},
      color={175,0,0},
      thickness=0.5));
  end if;
  if useHeatPort then
  connect(heat, electrolyzer.heat) annotation (Line(points={{100,-66},{76,-66},{76,-10.56},{-54,-10.56}},color={191,0,0}));
  end if;
  if useVariableCoolantOutputTemperature then
    connect(electrolyzer.T_set_coolant_out, T_set_coolant_out) annotation (Line(points={{-51,11.2},{74,11.2},{74,36},{108,36}},  color={0,0,127}));
  end if;

  connect(boundary_Txim_flow2.gasPort, storage.gasPortOut) annotation (Line(
      points={{55,-46},{54,-46},{54,-26.45},{40,-26.45}},
      color={255,255,0},
      thickness=1.5));
  connect(boundary_Txim_flow2.m_flow, realExpression.y) annotation (Line(points={{58,-57},{58,-63.9},{59,-63.9}}, color={0,0,127}));
  connect(heat, heat) annotation (Line(points={{100,-66},{100,-66}}, color={191,0,0}));
  annotation (defaultComponentName="feedInStation",Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-150,20},{150,-20}},
          lineColor={0,134,134},
          textString="%name",
          origin={0,149},
          rotation=360)}),
  Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents a feed in station where hydrogen is produced with an electrolyzer, stored in an adiabatic storage and fed into a natural gas grid. The storage can by bypassed and the hydrogen is fed directly into the grid. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>see sub models </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Only valid for negligible heat transfer from the storage to the surroundings, for everything else, see sub models. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>P_el_set: input for the set value for the electric power </p>
<p>m_flow_feedIn: input for the possible feed-in mass flow into the natural grid etc. </p>
<p>epp: electric power port for the electrolyzer </p>
<p>gasPortOut: outlet of the hydrogen </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>For start up, a small hydrogen mass flow for the electrolyzer can be set to allow for simpler initialisation. </p>
<p>Constant mass flow &apos;m_flow_hydrogenDemand_constant&apos; is pulled from hydrogen storage if storage pressure is above p_min_Low_constantDemand. If pressure falls below &apos;p_minLow&apos; hydrogen in storage is only used for supply of &apos;m_flow_hydrogenDemand_constant&apos; and no more hydrogen can be fed in.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in check model &quot;TransiEnt.Producer.Gas.Electrolyzer.Systems.Check.Test_FeedInStation_Storage&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Lisa Andresen (andresen@tuhh.de) in September 2016</p>
<p>Model revised by Carsten Bode (c.bode@tuhh.de) in Apr 2018 (fixed for update to ClaRa 1.3.0)</p>
<p>Model modified by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) in Mar 2020: added boundary for constant internal hydrogen demand</p>
<p>Model modified by Carsten Bode (c.bode@tuhh.de) in May 2020: added option to use isothermal junction</p>
</html>"));
end FeedInStation_Storage;
