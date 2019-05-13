within TransiEnt.Producer.Gas.MethanatorSystem;
model FeedInStation_Methanation
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

  extends TransiEnt.Producer.Gas.Electrolyzer.Base.PartialFeedInStation;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Real hydrogenFraction_fixed=0 "Target fraction of hydrogen in ouput"  annotation (Dialog(enable=(not useVariableHydrogenFraction),group="General",enable=not useVariableHydrogenFraction));
  parameter Boolean useSeperateHydrogenOutput=false "Use additional gas port for hydrogen only"  annotation (Dialog(               group="General"));
  parameter Boolean useVariableHydrogenFraction=false "define volumetric hydrogen content in SNG via input - in not 'HydrogenFraction_fixed' is used" annotation (Dialog(               group="General"));
  parameter Boolean useMassFlowControl=true "choose if output of FeedInStation is limited by m_flow_feedIn - if 'false': m_flow_feedIn has no effect - should only be 'false' if feedInStation_Hydrogen has no storage and useMassFlowControl='false' in feedInStation_Hydrogen as well" annotation(Dialog(group="General"));
  parameter Boolean useCO2Input=false "Use gas port for CO2 for methanation" annotation (Dialog(               group="General"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Natural Gas model to be used" annotation (Dialog(tab="General", group="General"));
  parameter SI.Temperature T_nom[N_cv]=(273.15+270)*ones(N_cv)  "Nominal gas and catalyst temperature in the control volumes" annotation(Dialog(tab="Methanation", group="Nominal Values"));
  parameter SI.Pressure p_nom[N_cv]=(17e5)*ones(N_cv)  "Nominal pressure in the control volumes" annotation(Dialog(tab="Methanation", group="Nominal Values"));
  parameter SI.MassFraction xi_nom[N_cv,vle_sg4.nc-1]=fill({0.296831,0.0304503,0.666944}, N_cv) "Nominal values for mass fractions" annotation(Dialog(tab="Methanation", group="Nominal Values"));
  parameter Integer N_cv=10 "Number of control volumes" annotation(Dialog(tab="Methanation", group="Fundamental Definitions"));
  parameter Integer scalingOfReactor=2 "Chooce by which value the scaling of the reactor is defined" annotation(Dialog(tab="Methanation", group="Nominal Values"),choices(
                choice=1 "Define Reactor Scaling by nominal methane flow at output",
                choice=2 "Define Reactor Scaling by nominal hydrogen flow at input",
                choice=3 "Define Reactor Scaling by nominal methane enthalpy flow at output",
                choice=4 "Define Reactor Scaling by nominal hydrogen enthalpy flow at input"));
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

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut_H2(Medium=simCenter.gasModel1) if useSeperateHydrogenOutput annotation (Placement(transformation(extent={{92,-10},{112,10}}), iconTransformation(extent={{82,-20},{112,10}})));
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
        origin={-104,72}), iconTransformation(
        extent={{12,-12},{-12,12}},
        rotation=180,
        origin={-98,-80})));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_woStorage feedInStation_Hydrogen annotation (Placement(transformation(extent={{-10,20},{10,40}})),  choices(
      choice(redeclare TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_woStorage feedInStation_Hydrogen),
      choice(redeclare TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_Storage feedInStation_Hydrogen),
      choice(redeclare TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_CavernComp feedInStation_Hydrogen)));
  TransiEnt.Producer.Gas.MethanatorSystem.Controller.MassFlowFeedInSystemController massFlowFeedInSystemController(P_el_max=feedInStation_Hydrogen.P_el_max, eta_n_ely=feedInStation_Hydrogen.eta_n,
    useMassFlowControl=useMassFlowControl,
    PID(k=1, Ti=0.1))                                                                                                                                                                                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,64})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensor(compositionDefinedBy=2, flowDefinition=3)      annotation (Placement(transformation(
        extent={{-5,5},{5,-5}},
        rotation=-90,
        origin={-5,-63})));
  TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var vle_sg4;
  TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG4_var gas_sg4;
  TILMedia.VLEFluid_ph gasOut(
    deactivateTwoPhaseRegion=true,
    h=inStream(compositionSensor.gasPortOut.h_outflow),
    p=compositionSensor.gasPortOut.p,
    xi=compositionSensor.gasPortOut.xi_outflow,
    vleFluidType=simCenter.gasModel1) annotation (Placement(transformation(extent={{18,-100},{38,-80}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow1(m_flow_const=m_flow_small) if useLeakageMassFlow annotation (Placement(transformation(extent={{-20,-58},{-16,-54}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow2(m_flow_const=-m_flow_small, xi_const={0,0,0,0,0,0}) if useSeperateHydrogenOutput and useLeakageMassFlow annotation (Placement(transformation(
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

  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massFlowSensor_SNG(xiNumber=0)
                                                                         annotation (Placement(transformation(extent={{-5,-5},{5,5}},
        rotation=-90,
        origin={5,-47})));
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
      eta_methanation_NCV=methanation.methanator.summary.outline.eta_NCV),
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
      mediumModel=simCenter.gasModel1,
      xi=gasOut.xi,
      x=gasOut.x,
      m_flow=-gasPortOut.m_flow,
      T=gasOut.T,
      p=gasOut.p,
      h=gasOut.h,
      rho=gasOut.d))
       annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  TransiEnt.Components.Gas.VolumesValvesFittings.ThreeWayValveRealGas_L1_simple TWV1(splitRatio_input=true) if useSeperateHydrogenOutput  annotation (Placement(transformation(
        extent={{-6.50001,6},{6.5,-6}},
        rotation=-90,
        origin={-3.5e-06,0.5})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massFlowSensor_SNG1 if useSeperateHydrogenOutput  annotation (Placement(transformation(extent={{-5,-5},{5,5}},
        rotation=0,
        origin={63,5})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=1 - max(min(1, m_flow_feedIn_H2/max(1e-4, -feedInStation_Hydrogen.gasPortOut.m_flow)), 0)) if useSeperateHydrogenOutput                              annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Sources.RealExpression Zero;
  MethanatorSystem methanation(
    T_nom=T_nom,
    p_nom=p_nom,
    xi_nom=xi_nom,
    ScalingOfReactor=scalingOfReactor,
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
        origin={0,-30})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn_CO2(Medium=medium) if useCO2Input annotation (Placement(transformation(extent={{-70,-110},{-50,-90}})));
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
      points={{-0.5,19.9},{-0.666669,19.9},{-0.666669,7.00001}},
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
    connect(compositionSensor.gasPortIn, boundary_Txim_flow1.gasPort) annotation (Line(
      points={{8.88178e-16,-58},{0,-58},{0,-56},{-16,-56}},
      color={255,255,0},
      thickness=1.5));
  end if;

  connect(methanation.gasPortOut, massFlowSensor_SNG.gasPortIn) annotation (Line(
      points={{-1.77636e-15,-40},{-1.77636e-15,-45},{1.77636e-15,-45},{1.77636e-15,-42}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensor.gasPortIn, massFlowSensor_SNG.gasPortOut) annotation (Line(
      points={{0,-58},{0,-52}},
      color={255,255,0},
      thickness=1.5));
  connect(massFlowSensor_SNG.m_flow, massFlowFeedInSystemController.m_flow_feed_CH4_is) annotation (Line(points={{5,-52.5},{5,-58},{32,-58},{32,58},{12,58}}, color={0,0,127}));
  if useCO2Input then
  connect(methanation.gasPortIn_CO2, gasPortIn_CO2) annotation (Line(
      points={{-10,-24},{-60,-24},{-60,-100}},
      color={255,255,0},
      thickness=1.5));
  end if;

  connect(compositionSensor.gasPortOut, gasPortOut) annotation (Line(
      points={{0,-68},{0,-96}},
      color={255,255,0},
      thickness=1.5));
  if useVariableHydrogenFraction then
    connect(hydrogenFraction_input, methanation.HydrogenFraction_input) annotation (Line(points={{-104,72},{-76,72},{-76,-14},{-7.6,-14},{-7.6,-20.2}},   color={0,0,127}));
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
<p>The methanation can be avoided by a bypass. This bypass is is controlled by the output molar content of hydrogen which can be defined by the parameter &apos;HydrogenContentOutput&apos;. If this parameter is set to &apos;1&apos; all hydrogen is bypassed. If the parameter is set to &apos;0&apos; all hydrogen is methanated.</p>
<p>Consider that the output of the methanator still contains hydrogen such that an actual molar hydrogen content of &apos;0&apos; can not be achieved.</p>
<p>Via the parameter &apos;<span style=\"font-family: Courier New;\">UseSeperateHydrogenOutput</span>&apos; an additional hydrogen output can be activated. The gas of this output is not methanated before and can be controlled via the input m_flow_feedIn_H2.</p>
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
</html>"));
end FeedInStation_Methanation;
