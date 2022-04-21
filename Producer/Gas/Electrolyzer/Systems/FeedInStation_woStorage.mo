within TransiEnt.Producer.Gas.Electrolyzer.Systems;
model FeedInStation_woStorage



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

  extends TransiEnt.Producer.Gas.Electrolyzer.Base.PartialFeedInStation(gasPortOut(Medium=medium_ng));

  // _____________________________________________
  //
  //          Constants and Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel3 "Hydrogen model to be used" annotation (Dialog(tab="General", group="General"));
  parameter Boolean useFluidAdapter=true "true: fluid adapter to natural gas at gasPortOut is used, false: no adapter, then set medium_ng to medium_h2" annotation (Dialog(tab="General", group="General"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_ng=simCenter.gasModel1 "Natural gas with H2 model to be used" annotation (Dialog(tab="General", group="General"));
  parameter SI.ActivePower P_el_n=1e6 "Nominal power of electrolyzer" annotation (Dialog(tab="General", group="Electrolyzer"));
  parameter SI.ActivePower P_el_max=1.68*P_el_n "Maximum power of electrolyzer" annotation (Dialog(tab="General", group="Electrolyzer"));
  parameter SI.ActivePower P_el_min=0.05*P_el_n "Minimal power of electrolyzer" annotation (Dialog(tab="General", group="Electrolyzer"));
  parameter SI.ActivePower P_el_overload=1.0*P_el_n "Power at which overload region begins" annotation (Dialog(tab="General", group="Electrolyzer"));
  parameter SI.ActivePower P_el_cooldown=P_el_n "Power below which cooldown of electrolyzer starts" annotation (Dialog(group="Electrolyzer"));
  parameter SI.MassFlowRate m_flow_start=0.0 "Sets initial value for m_flow from a buffer" annotation (Dialog(tab="General", group="Initialization"));
  //parameter SI.Temperature T_Init=283.15 "Sets initial value for T" annotation (Dialog(tab="General", group="Initialization"));
  parameter Modelica.Units.SI.Efficiency eta_n(
    min=0,
    max=1) = 0.75 "Nominal efficency refering to the GCV (min = 0, max = 1)" annotation (Dialog(tab="General", group="Electrolyzer"));
  parameter Modelica.Units.SI.Efficiency eta_scale(
    min=0,
    max=1) = 0 "Sets a with increasing input power linear degrading efficiency coefficient (min = 0, max = 1)" annotation (Dialog(tab="General", group="Electrolyzer"));
  parameter SI.AbsolutePressure p_out=35e5 "Hydrogen output pressure from electrolyzer" annotation (Dialog(tab="General", group="Electrolyzer"));
  parameter SI.Temperature T_out=283.15 "Hydrogen output temperature from electrolyzer" annotation (Dialog(tab="General", group="Electrolyzer"));
  parameter Real specificWaterConsumption=10 "Mass of water per mass of hydrogen" annotation (Dialog(tab="General", group="Electrolyzer"));
  parameter Real t_overload=0.5*3600 "Maximum time the ely can work in overload in seconds" annotation (Dialog(tab="General", group="Electrolyzer"));
  parameter Real coolingToHeatingRatio=1 "Defines how much faster electrolyzer cools down than heats up" annotation (Dialog(tab="General", group="Electrolyzer"));
  parameter Integer startState=1 "Initial state of the electrolyzer (1: ready to overheat, 2: working in overload, 3: cooling down)" annotation (Dialog(tab="General", group="Electrolyzer"));

  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PI "Type of controller for feed-in control" annotation (Dialog(tab="General", group="Controller"));
  parameter Real k=1e8 "Gain for feed-in control" annotation (Dialog(tab="General", group="Controller"));
  parameter Real Ti=1 "Integrator time constant for feed-in control" annotation (Dialog(tab="General", group="Controller"));
  parameter Real Td=0.1 "Derivative time constant for feed-in control" annotation (Dialog(tab="General", group="Controller"));

  replaceable model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200 constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.PartialElectrolyzerEfficiencyCharline "Calculate the efficiency" annotation (Dialog(tab="General", group="Electrolyzer"), choices(__Dymola_choicesAllMatching=true));
  replaceable model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics0thOrder constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.PartialElectrolyzerDynamics "Dynamic behavior of electrolyser" annotation (Dialog(tab="General", group="Electrolyzer"), choices(__Dymola_choicesAllMatching=true));

  //Statistics
  replaceable model CostSpecsElectrolyzer = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Empty constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs "Cost configuration electrolyzer" annotation (Dialog(tab="Statistics"), choices(choicesAllMatching=true));
  parameter Real Cspec_demAndRev_other_water=simCenter.Cspec_demAndRev_other_water "Specific demand-related cost per cubic meter water of electrolyzer" annotation (Dialog(tab="Statistics"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_el_electrolyzer=simCenter.Cspec_demAndRev_free "Specific demand-related cost per electric energy for electrolyzer" annotation (Dialog(tab="Statistics"));
  parameter Boolean useMassFlowControl=true "choose if output of FeedInStation is limited by m_flow_feedIn - if 'false': m_flow_feedIn has no effect" annotation (Dialog(tab="General", group="General"));

  parameter Boolean useFluidCoolantPort=false "choose if fluid port for coolant shall be used" annotation (Dialog(enable=not useHeatPort,group="Coolant"));
  parameter Boolean useHeatPort=false "choose if heat port for coolant shall be used" annotation (Dialog(enable=not useFluidCoolantPort,group="Coolant"));
  parameter Boolean useVariableCoolantOutputTemperature=false "choose if temperature of cooland output shall be defined by input" annotation (Dialog(enable=useFluidCoolantPort,group="Coolant"));
  parameter SI.Temperature T_out_coolant_target=500+273.15 "output temperature of coolant - will be limited by temperature which is technically feasible" annotation (Dialog(enable=useFluidCoolantPort,group="Coolant"));
  parameter Boolean externalMassFlowControl=false "choose if heat port for coolant shall be used" annotation (Dialog(enable=useFluidCoolantPort and (not useVariableCoolantOutputTemperature), group="Coolant"));

  // _____________________________________________
  //
  //               Complex Components
  // _____________________________________________

protected
  model Outline
    extends TransiEnt.Basics.Icons.Record;
    input SI.Power P_el "Consumed electric power";
    input SI.Energy W_el "Consumed electric energy";
    input SI.Mass mass_H2 "Produced hydrogen mass";
    input SI.Efficiency eta_NCV "Electroyzer efficiency based on NCV";
    input SI.Efficiency eta_GCV "Electroyzer efficiency based on GCV";
  end Outline;

  model Summary
    extends TransiEnt.Basics.Icons.Record;
    Outline outline;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOutElectrolyzer;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
    TransiEnt.Basics.Records.Costs costs;
  end Summary;

  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sourceH2(
    variable_m_flow=true,
    final medium=medium,
    xi_const=zeros(sourceH2.medium.nc - 1)) annotation (Placement(transformation(extent={{-44,-44},{-28,-28}})));

  Modelica.Blocks.Sources.Ramp ramp(
    duration=1,
    startTime=3,
    height=m_flow_start,
    offset=-m_flow_start) annotation (Placement(transformation(extent={{-64,-38},{-50,-25}})));
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
    Cspec_demAndRev_el=Cspec_demAndRev_el_electrolyzer) annotation (Placement(transformation(extent={{-16,-16},{16,16}})));
protected
  TransiEnt.Components.Gas.VolumesValvesFittings.Valves.ValveDesiredPressureBefore valve_pBeforeValveDes(final medium=medium, p_BeforeValveDes=p_out) annotation (Placement(transformation(
        extent={{-8,-4},{8,4}},
        rotation=270,
        origin={20,-12})));

  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massflowSensor(medium=medium, xiNumber=0) annotation (Placement(transformation(
        extent={{7,6},{-7,-6}},
        rotation=90,
        origin={6,-49})));

  TransiEnt.Basics.Adapters.Gas.RealH2_to_RealNG h2toNG(final medium_h2=medium, medium_ng=medium_ng) if useFluidAdapter annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=90,
        origin={0,-68})));

public
  TransiEnt.Producer.Gas.Electrolyzer.Controller.TotalFeedInController controlTotalEly(
    P_el_n=P_el_n,
    P_el_overload=P_el_overload,
    P_el_max=P_el_max,
    t_overload=t_overload,
    coolingToHeatingRatio=coolingToHeatingRatio,
    k=k,
    P_el_min=P_el_min,
    eta_n=eta_n,
    eta_scale=eta_scale,
    startState=startState,
    useMassFlowControl=useMassFlowControl,
    redeclare model Charline = Charline,
    controllerType=controllerType,
    Ti=Ti,
    Td=Td,
    P_el_cooldown=P_el_cooldown) annotation (Placement(transformation(extent={{-10,56},{10,76}})));
public
  inner Summary summary(
    outline(
      P_el=electrolyzer.summary.outline.P_el,
      W_el=electrolyzer.summary.outline.W_el,
      mass_H2=electrolyzer.summary.outline.mass_H2,
      eta_NCV=electrolyzer.summary.outline.eta_NCV,
      eta_GCV=electrolyzer.summary.outline.eta_GCV),
    gasPortOutElectrolyzer(
      mediumModel=electrolyzer.summary.gasPortOut.mediumModel,
      xi=electrolyzer.summary.gasPortOut.xi,
      x=electrolyzer.summary.gasPortOut.x,
      m_flow=electrolyzer.summary.gasPortOut.m_flow,
      T=electrolyzer.summary.gasPortOut.T,
      p=electrolyzer.summary.gasPortOut.p,
      h=electrolyzer.summary.gasPortOut.h,
      rho=electrolyzer.summary.gasPortOut.rho),
    gasPortOut(
      mediumModel=simCenter.gasModel1,
      xi=gasOut.xi,
      x=gasOut.x,
      m_flow=-gasPortOut.m_flow,
      T=gasOut.T,
      p=gasPortOut.p,
      h=gasOut.h,
      rho=gasOut.d),
    costs(
      costs=electrolyzer.summary.costs.costs,
      investCosts=electrolyzer.summary.costs.investCosts,
      demandCosts=electrolyzer.summary.costs.demandCosts,
      oMCosts=electrolyzer.summary.costs.oMCosts,
      otherCosts=electrolyzer.summary.costs.otherCosts,
      revenues=electrolyzer.summary.costs.revenues)) annotation (Placement(transformation(extent={{-58,-100},{-38,-80}})));
  Basics.Interfaces.Thermal.FluidPortIn fluidPortIn(Medium=simCenter.fluid1) if useFluidCoolantPort annotation (Placement(transformation(extent={{90,-100},{110,-80}})));
  Basics.Interfaces.Thermal.FluidPortOut fluidPortOut(Medium=simCenter.fluid1) if useFluidCoolantPort     annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heat if useHeatPort annotation (Placement(transformation(extent={{90,-76},{110,-56}})));
  Basics.Interfaces.General.TemperatureIn T_set_coolant_out if useVariableCoolantOutputTemperature annotation (Placement(transformation(extent={{128,16},{88,56}})));
protected
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasOut(
    vleFluidType=simCenter.gasModel1,
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    deactivateTwoPhaseRegion=true,
    h=gasPortOut.h_outflow,
    p=gasPortOut.p,
    xi=gasPortOut.xi_outflow) annotation (Placement(transformation(extent={{12,-98},{32,-78}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  connect(ramp.y, sourceH2.m_flow) annotation (Line(points={{-49.3,-31.5},{-49.3,-31.2},{-45.6,-31.2}}, color={0,0,127}));
  if usePowerPort then
  connect(electrolyzer.epp, epp) annotation (Line(
      points={{-16,0},{-16,0},{-100,0}},
      color={0,135,135},
      thickness=0.5));
  end if;
  connect(controlTotalEly.P_el_ely, electrolyzer.P_el_set) annotation (Line(
      points={{0,55},{0,38},{0,19.2},{-6.4,19.2}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(P_el_set, controlTotalEly.P_el_set) annotation (Line(
      points={{0,108},{0,74.8}},
      color={0,0,127},
      pattern=LinePattern.Dash));

  connect(electrolyzer.gasPortOut, valve_pBeforeValveDes.gasPortIn) annotation (Line(
      points={{16,0},{19.4286,0},{19.4286,-4}},
      color={255,255,0},
      thickness=1.5));
  if useFluidAdapter then
    connect(gasPortOut, h2toNG.gasPortOut) annotation (Line(
      points={{0,-96},{0,-96},{0,-76},{-4.996e-016,-76}},
      color={255,255,0},
      thickness=1.5));
    connect(h2toNG.gasPortIn, massflowSensor.gasPortOut) annotation (Line(
      points={{4.996e-016,-60},{0,-60},{0,-56},{-2.66454e-015,-56}},
      color={255,255,0},
      thickness=1.5));
  else
    connect(massflowSensor.gasPortOut, gasPortOut) annotation (Line(
      points={{0,-56},{-16,-56},{-16,-96},{0,-96}},
      color={255,255,0},
      thickness=1.5));
  end if;
  connect(sourceH2.gasPort, massflowSensor.gasPortIn) annotation (Line(
      points={{-28,-36},{0,-36},{0,-42}},
      color={255,255,0},
      thickness=1.5));
  connect(valve_pBeforeValveDes.gasPortOut, massflowSensor.gasPortIn) annotation (Line(
      points={{19.4286,-20},{19.4286,-36},{0,-36},{0,-42},{-1.77636e-15,-42}},
      color={255,255,0},
      thickness=1.5));
  if useMassFlowControl then
    connect(massflowSensor.m_flow, controlTotalEly.m_flow_ely) annotation (Line(
        points={{6,-56.7},{6,-58},{40,-58},{40,62},{9.2,62}},
        color={0,0,127},
        pattern=LinePattern.Dash));
    connect(m_flow_feedIn, controlTotalEly.m_flow_feedIn) annotation (Line(
        points={{108,70},{42,70},{9.2,70}},
        color={0,0,127},
        pattern=LinePattern.Dash));
  end if;
  if useFluidCoolantPort then
    connect(electrolyzer.fluidPortIn, fluidPortIn) annotation (Line(
      points={{16,-14.4},{26,-14.4},{26,-14},{38,-14},{38,-90},{100,-90}},
      color={175,0,0},
      thickness=0.5));
    connect(fluidPortOut, electrolyzer.fluidPortOut) annotation (Line(
      points={{100,-40},{52,-40},{52,-6.4},{16,-6.4}},
      color={175,0,0},
      thickness=0.5));
  end if;
  if useHeatPort then
  connect(heat, electrolyzer.heat) annotation (Line(points={{100,-66},{46,-66},{46,-10.56},{16,-10.56}}, color={191,0,0}));
  end if;
  if useVariableCoolantOutputTemperature then
    connect(electrolyzer.T_set_coolant_out, T_set_coolant_out) annotation (Line(points={{19.2,11.2},{74,11.2},{74,36},{108,36}}, color={0,0,127}));
  end if;
  annotation (
    defaultComponentName="feedInStation",
    Diagram(          coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-150,20},{150,-20}},
          lineColor={0,134,134},
          textString="%name",
          origin={0,149},
          rotation=360)}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents a feed in station where hydrogen is produced with an electrolyzer and fed directly into a natural gas grid. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>see sub models </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>see sub models </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>P_el_set: input for the set value for the electric power </p>
<p>m_flow_feedIn: input for the possible feed-in mass flow into the natural grid etc. </p>
<p>epp: electric power port for the electrolyzer, type can be chosen </p>
<p>gasPortOut: outlet of the hydrogen </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>For start up, a small hydrogen mass flow for the electrolyzer can be set to allow for simpler initialisation. </p>
<p>If <span style=\"font-family: Courier New;\">useMassFlowControl</span>=true, the electrical power of the electrolyzer will no more be limited by given m_flow_feed. This simplifies the controller if limitation is not needed.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Lisa Andresen (andresen@tuhh.de) in September 2016</p>
<p><br>Model modified by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) in April 2019: added Boolean <span style=\"font-family: Courier New;\">useMassFlowControl</span></p>
</html>"));
end FeedInStation_woStorage;
