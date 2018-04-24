within TransiEnt.Producer.Gas.Electrolyzer.Systems;
model FeedInStation_CavernComp

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

  extends TransiEnt.Producer.Gas.Electrolyzer.Base.PartialFeedInStation;

  // _____________________________________________
  //
  //                  Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_h2=simCenter.gasModel3 "|General|Hydrogen model to be used";
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_ng=simCenter.gasModel1 "|General|Natural gas with H2 model to be used";
  parameter SI.ActivePower P_el_n=1e6 "|Electrolyzer|nominal power of electrolyser" annotation(Evaluate=false);
  parameter SI.ActivePower P_el_max=1.68*P_el_n "|Electrolyzer|Maximum power of electrolyzer" annotation(Evaluate=false);
  parameter SI.ActivePower P_el_min=0.05*P_el_n "|Electrolyzer|Minimal power of ely, when only 1 stack is working at 2%(?)";
  parameter SI.ActivePower P_el_overload=1.0*P_el_n "|Electrolyzer|Power at which overload region begins";
  parameter SI.ActivePower P_el_cooldown=P_el_n "Power below which cooldown of electrolyzer starts" annotation(Dialog(group="Electrolyzer"));
  parameter SI.MassFlowRate m_flow_start=0.0 "|Initialization|Sets initial value for m_flow from a buffer";
  //parameter SI.Temperature T_Init=283.15 "|Initialization|Sets initial value for T";
  parameter Modelica.SIunits.Efficiency eta_n(
    min=0,
    max=1)=0.75 "|Electrolyzer|Nominal efficency coefficient (min = 0, max = 1)";
  parameter Modelica.SIunits.Efficiency eta_scale(
    min=0,
    max=1)=0 "|Electrolyzer|Sets a with increasing input power linear degrading efficiency coefficient (min = 0, max = 1)";

  parameter SI.Time t_overload=0.5*3600 "|Electrolyzer|Maximum admissible time the electrolyzer can work in overload region in seconds";
  parameter Real coolingToHeatingRatio=1 "|Electrolyzer|Defines how much faster electrolyzer cools down than heats up";
  parameter Integer startState=1 "|Electrolyzer|Initial state of the electrolyzer (1: ready to overheat, 2: working in overload, 3: cooling down)";

  parameter SI.AbsolutePressure p_out=35e5 "|Electrolyzer|Hydrogen output pressure from electrolyser";
  parameter SI.Temperature T_out=283.15 "|Electrolyzer|Hydrogen output temperature from electrolyser";
  parameter Real specificWaterConsumption=10 "|Electrolyzer|Mass of water per mass of hydrogen";

  parameter SI.SpecificEnthalpy h_start_junction=139565 "|Junction|Initial specific enthalpy";
  parameter SI.AbsolutePressure p_start_junction=simCenter.p_amb_const+simCenter.p_eff_2 "|Junction|Initial pressure";
  parameter ClaRa.Basics.Units.Volume volume_junction=0.1 "|Junction|Volume of the junction";
  parameter Integer initOption=0 "|Junction|Type of initialisation" annotation(choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=201 "Steady pressure",
      choice=202 "Steady enthalpy",
      choice=208 "Steady pressure and enthalpy",
      choice=210 "Steady density"));

  parameter Boolean start_pressure=true "|Storage||true if a start pressure is defined, false if a start mass is defined";
  //parameter Boolean includeHeatTransfer=true "|Storage||false for neglecting heat transfer";
  parameter SI.Pressure p_maxHigh= 175e5 "|Storage||Maximum pressure";
  parameter SI.Pressure p_maxLow= 174e5 "|Storage||Lower value of the storage where it can be filled again";
  parameter SI.Pressure p_minLow=58e5 "|Storage||if valve open and p<p_low, close valve";
  parameter SI.Pressure p_minHigh=60e5 "|Storage||if valve closed and p>p_high, open valve";
  parameter SI.Volume V_geo=1e5 "|Storage||Geometric volume of storage";
  parameter SI.Height height=3.779*V_geo^(1/3) "|Storage||Height of storage";
  parameter SI.CoefficientOfHeatTransfer alpha_nom=133 "|Storage||Heat transfer coefficient inside the storage cylinder";
  parameter SI.ThermodynamicTemperature T_surrounding=317.15 "|Storage||Temperature of the surrounding media";
  parameter SI.Thickness thickness_salt=2 "|Storage||Thickness of the salt that changes temperature";
  parameter SI.Mass m_start=1 "|Storage||Stored gas mass at t=0";
  parameter SI.Pressure p_start=1e5 "|Storage||Pressure in storage at t=0";
  parameter SI.ThermodynamicTemperature T_start=283.15 "|Storage||Temperature of gas in storage at t=0";

  parameter SI.Efficiency eta_mech_compressor = 0.95 "|Storage|Compressor|Mechanical efficiency";
  parameter SI.Efficiency eta_el_compressor = 0.97 "|Storage|Compressor|Electrical efficiency";

  parameter Boolean StoreAllHydrogen=false "|Storage|All Hydrogen is stored before beeing fed in";

  parameter Real k=1e3 "|Controller|Gain for feed-in control";

  replaceable model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200
     constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.PartialElectrolyzerEfficiencyCharline "|Electrolyzer|Calculate the efficiency" annotation (choicesAllMatching=true);
  replaceable model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder
     constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.PartialElectrolyzerDynamics "|Electrolyzer|Dynamic behavior of electrolyser" annotation (choicesAllMatching=true);

  //Statistics
  replaceable model CostSpecsElectrolyzer = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Empty
    constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs "|Statistics||Cost configuration electrolyzer" annotation (choicesAllMatching=true);
  replaceable model CostSpecsStorage = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Empty
    constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs "|Statistics||Cost configuration storage" annotation (choicesAllMatching=true);
  parameter Real Cspec_demAndRev_other_water=simCenter.Cspec_demAndRev_other_water "|Statistics||Specific demand-related cost per cubic meter water of electrolyzer";
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_el_electrolyzer=simCenter.Cspec_demAndRev_free "|Statistics||Specific demand-related cost per electric energy for electrolyzer";
  replaceable model CostSpecsCompressor = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Empty
    constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs "|Statistics||Cost configuration compressor" annotation (choicesAllMatching=true);
  parameter Modelica.SIunits.Power P_el_n_compressor=1e5 "|Statistics||Nominal power of compressor for cost calculation";
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_el_other=simCenter.Cspec_demAndRev_el_70_150_GWh "|Statistics||Specific demand-related cost per electric energy for compressor and start gas generation";

  // _____________________________________________
  //
  //                  Variables
  // _____________________________________________
  SI.Mass mass_H2_fedIn "Hydrogen mass fed into grid";


  // _____________________________________________
  //
  //               Complex Components
  // _____________________________________________
protected
  model Outline
    extends TransiEnt.Basics.Icons.Record;
    input SI.Mass mass_H2_fedIn "Fed in hydrogen mass";
    input SI.Power P_el_compressor "Electric power of the compressor";
  end Outline;

  model ElectrolyzerRecord
    extends TransiEnt.Basics.Icons.Record;
    input SI.Power P_el "Consumed electric power";
    input SI.Energy W_el "Consumed electric energy";
    input SI.Mass mass_H2 "Produced hydrogen mass";
    input SI.Efficiency eta "Efficiency of the electrolyzer";
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
    TransiEnt.Basics.Records.Costs costsCompressor;
  end Summary;

  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sourceH2(
    variable_m_flow=true,
    final medium=medium_h2,
    xi_const=zeros(sourceH2.medium.nc - 1)) annotation (Placement(transformation(extent={{-76,-43},{-60,-27}})));

  Modelica.Blocks.Sources.Ramp ramp(
    duration=1,
    startTime=3,
    offset=-m_flow_start,
    height=+m_flow_start)
                         annotation (Placement(transformation(extent={{-96,-36},{-84,-24}})));
public
  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L1 electrolyzer(
    final P_el_n=P_el_n,
    final P_el_max=P_el_max,
    final eta_n=eta_n,
    final eta_scale=eta_scale,
    final T_out=T_out,
    final medium=medium_h2,
    redeclare model Dynamics = Dynamics,
    redeclare model Charline = Charline,
    specificWaterConsumption=specificWaterConsumption,
    Cspec_demAndRev_other=Cspec_demAndRev_other_water,
    redeclare model CostSpecsGeneral = CostSpecsElectrolyzer,
    Cspec_demAndRev_el=Cspec_demAndRev_el_electrolyzer) annotation (Placement(transformation(extent={{-84,-16},{-54,16}})));
protected
  TransiEnt.Components.Gas.VolumesValvesFittings.ValveDesiredPressureBefore valve_pBeforeValveDes(final medium=medium_h2, p_BeforeValveDes=p_out) annotation (Placement(transformation(
        extent={{8,-4},{-8,4}},
        rotation=90,
        origin={8,-18})));

  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massflowSensor_bypass(final medium=medium_h2, xiNumber=medium_h2.nc) annotation (Placement(transformation(
        extent={{7,6},{-7,-6}},
        rotation=90,
        origin={14,-37})));

  TransiEnt.Basics.Adapters.Gas.RealH2_to_RealNG h2toNG(final medium_h2=medium_h2, medium_ng=medium_ng)
                                                                                annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=90,
        origin={0,-72})));
public
  TransiEnt.Storage.Gas.UndergroundGasStorageHeatTransfer_L2 storage(
    medium=medium_h2,
    T_surrounding=T_surrounding,
    T_wall_start=T_start,
    thickness_wall=thickness_salt,
    storage(
      start_pressure=start_pressure,
      V_geo=V_geo,
      alpha_nom=alpha_nom,
      m_gas_start=m_start,
      p_gas_start=p_start,
      T_gas_start=T_start,
      p_max=p_maxHigh,
      Cspec_demAndRev_el=Cspec_demAndRev_el_other,
      redeclare model CostSpecsStorage = CostSpecsStorage,
      eta_ely=eta_n)) annotation (Placement(transformation(
        extent={{14,-15},{-14,15}},
        rotation=0,
        origin={66,-17})));
      //includeHeatTransfer=includeHeatTransfer,
protected
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 mix_H2(
    medium=medium_h2,
    volume=volume_junction,
    p_start=p_start_junction,
    h_start=h_start_junction,
    initOption=initOption)
                         annotation (Placement(transformation(
        extent={{-8,8},{8,-8}},
        rotation=0,
        origin={8,-56})));

  TransiEnt.Components.Gas.VolumesValvesFittings.ThreeWayValveRealGas_L1_simple threeWayValve(
    splitRatio_input=true,
    medium=medium_h2,
    showExpertSummary=false,
    showData=false) annotation (Placement(transformation(extent={{0,-8},{16,6}})));

  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massflowSensor_ely(final medium=medium_h2, xiNumber=medium_h2.nc) annotation (Placement(transformation(
        extent={{7,6},{-7,-6}},
        rotation=180,
        origin={-30,6})));
public
  TransiEnt.Producer.Gas.Electrolyzer.Controller.TotalFeedInStorageController controlTotalElyStorage(
    final k=k,
    final coolingToHeatingRatio=coolingToHeatingRatio,
    P_el_n=P_el_n,
    P_el_min=P_el_min,
    P_el_max=P_el_max,
    P_el_overload=P_el_overload,
    t_overload=t_overload,
    eta_n=eta_n,
    eta_scale=eta_scale,
    startState=startState,
    redeclare model Charline = Charline,
    p_maxLow=p_maxLow,
    p_maxHigh=p_maxHigh,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    StoreAllHydrogen=StoreAllHydrogen,
    P_el_cooldown=P_el_cooldown)                             annotation (Placement(transformation(extent={{-2,55},{18,75}})));
protected
  TransiEnt.Components.Gas.Compressor.Controller.ControllerCompressor_dp controlCompressorAfterELY(p_beforeCompParam=p_out) annotation (Placement(transformation(extent={{36,30},{56,50}})));
public
  TransiEnt.Components.Gas.Compressor.CompressorRealGasIsothermal_L1_simple compressorCavern(
    presetVariableType="dp",
    use_Delta_p_input=true,
    medium=medium_h2,
    eta_mech=eta_mech_compressor,
    eta_el=eta_el_compressor,
    P_el_n=P_el_n_compressor,
    redeclare model CostSpecsGeneral = CostSpecsCompressor,
    Cspec_demAndRev_el=Cspec_demAndRev_el_other) annotation (Placement(transformation(extent={{28,-10},{48,10}})));
protected
  TransiEnt.Components.Gas.VolumesValvesFittings.ValveDesiredMassFlow valveDesiredMassFlow(
    hysteresisWithDelta_p=false,
    medium=medium_h2,
    p_low=p_minLow,
    p_high=p_minHigh)
                   annotation (Placement(transformation(
        extent={{-7,-6},{7,6}},
        rotation=270,
        origin={66,-47})));

public
  inner Summary summary(
    outline(mass_H2_fedIn=mass_H2_fedIn,
      P_el_compressor=compressorCavern.summary.outline.P_el),
    electrolyzer(
      P_el=electrolyzer.summary.outline.P_el,
      W_el=electrolyzer.summary.outline.W_el,
      mass_H2=electrolyzer.summary.outline.mass_H2,
      eta=electrolyzer.summary.outline.eta),
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
      xi=valve_pBeforeValveDes.summary.gasPortOut.xi,
      x=valve_pBeforeValveDes.summary.gasPortOut.x,
      m_flow=valve_pBeforeValveDes.summary.gasPortOut.m_flow,
      T=valve_pBeforeValveDes.summary.gasPortOut.T,
      p=valve_pBeforeValveDes.summary.gasPortOut.p,
      h=valve_pBeforeValveDes.summary.gasPortOut.h,
      rho=valve_pBeforeValveDes.summary.gasPortOut.rho),
    gasPortOut(
      mediumModel=medium_ng,
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
      revenues=storage.summary.costs.revenues),
    costsCompressor(
      costs=compressorCavern.summary.costs.costs,
      investCosts=compressorCavern.summary.costs.investCosts,
      demandCosts=compressorCavern.summary.costs.demandCosts,
      oMCosts=compressorCavern.summary.costs.oMCosts,
      otherCosts=compressorCavern.summary.costs.otherCosts,
      revenues=compressorCavern.summary.costs.revenues)) annotation (Placement(transformation(extent={{-58,-100},{-38,-80}})));
protected
  TILMedia.VLEFluid_ph gasOut(
    vleFluidType=medium_ng,
    deactivateTwoPhaseRegion=true,
    h=actualStream(gasPortOut.h_outflow),
    p=gasPortOut.p,
    xi=actualStream(gasPortOut.xi_outflow)) annotation (Placement(transformation(extent={{12,-98},{32,-78}})));

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  der(mass_H2_fedIn)=-gasPortOut.m_flow;

  connect(ramp.y,sourceH2.m_flow) annotation (Line(points={{-83.4,-30},{-83.4,-30.2},{-77.6,-30.2}},color={0,0,127}));
  connect(electrolyzer.epp, epp) annotation (Line(
      points={{-84,0},{-84,0},{-100,0}},
      color={0,135,135},
      thickness=0.5));
  connect(threeWayValve.gasPortOut2, valve_pBeforeValveDes.gasPortIn) annotation (Line(
      points={{8,-8},{8,-8},{8,-10}},
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
      points={{0,108},{0,108},{0,69},{-12,69},{-2,69}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(h2toNG.gasPortOut, gasPortOut) annotation (Line(
      points={{0,-80},{0,-96}},
      color={255,255,0},
      thickness=1.5));
  connect(storage.p_gas, controlTotalElyStorage.p_storage) annotation (Line(
      points={{73,-17},{94,-17},{94,65},{18,65}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(threeWayValve.gasPortOut1, compressorCavern.gasPortIn) annotation (Line(
      points={{16,-0.222222},{22,-0.222222},{22,0},{28,0}},
      color={255,255,0},
      thickness=1.5));
  connect(compressorCavern.gasPortOut, storage.gasPortIn) annotation (Line(
      points={{48,0},{66,0},{66,-9.65}},
      color={255,255,0},
      thickness=1.5));
  connect(compressorCavern.dp_in, controlCompressorAfterELY.Delta_p) annotation (Line(points={{46,11},{46,11},{46,29}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(storage.p_gas, controlCompressorAfterELY.p_afterCompIn) annotation (Line(
      points={{73,-17},{94,-17},{94,40},{56,40}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(storage.gasPortOut, valveDesiredMassFlow.gasPortIn) annotation (Line(
      points={{66,-26.45},{66,-32},{66,-40}},
      color={255,255,0},
      thickness=1.5));
  connect(controlTotalElyStorage.m_flowDes_valve, valveDesiredMassFlow.m_flowDes) annotation (Line(
      points={{14,54},{14,16},{86,16},{86,-40},{72,-40}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(mix_H2.gasPort1, h2toNG.gasPortIn) annotation (Line(
      points={{0,-56},{0,-60},{0,-64}},
      color={255,255,0},
      thickness=1.5));
  connect(mix_H2.gasPort3, valveDesiredMassFlow.gasPortOut) annotation (Line(
      points={{16,-56},{42,-56},{66,-56},{66,-54}},
      color={255,255,0},
      thickness=1.5));
  connect(electrolyzer.gasPortOut, massflowSensor_ely.gasPortIn) annotation (Line(
      points={{-54,0},{-37,0}},
      color={255,255,0},
      thickness=1.5));
  connect(massflowSensor_ely.gasPortOut, threeWayValve.gasPortIn) annotation (Line(
      points={{-23,0},{0,0},{0,-0.222222}},
      color={255,255,0},
      thickness=1.5));
  connect(sourceH2.gasPort, massflowSensor_ely.gasPortIn) annotation (Line(
      points={{-60,-35},{-58,-35},{-58,-36},{-46,-36},{-46,0},{-37,0}},
      color={255,255,0},
      thickness=1.5));
  connect(valve_pBeforeValveDes.gasPortOut, massflowSensor_bypass.gasPortIn) annotation (Line(
      points={{8,-26},{8,-28},{8,-30}},
      color={255,255,0},
      thickness=1.5));
  connect(massflowSensor_bypass.gasPortOut, mix_H2.gasPort2) annotation (Line(
      points={{8,-44},{8,-46},{8,-48}},
      color={255,255,0},
      thickness=1.5));
  annotation (defaultComponentName="feedInStation",Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-150,20},{150,-20}},
          lineColor={0,134,134},
          textString="%name",
          origin={0,149},
          rotation=360)}),
  Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents a feed in station where hydrogen is produced with an electrolyzer, compressed with an ionic compressor, stored in an underground storage (salt cavern) and fed into a natural gas grid. The storage can by bypassed and the hydrogen is fed directly into the grid. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>see sub models </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>see sub models </p>
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
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Lisa Andresen (andresen@tuhh.de) in September 2016</p>
<p>Model revised by Carsten Bode (c.bode@tuhh.de) in Apr 2018 (fixed for update to ClaRa 1.3.0)</p>
</html>"));
end FeedInStation_CavernComp;
