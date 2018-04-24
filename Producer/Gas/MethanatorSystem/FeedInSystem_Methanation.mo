within TransiEnt.Producer.Gas.MethanatorSystem;
model FeedInSystem_Methanation
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
  //              Visible Parameters
  // _____________________________________________

  parameter Real HydrogenContentOutput = 0 "|General|Target fraction of hydrogen in ouput";
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "|General|Natural Gas model to be used";
  parameter SI.Temperature T_nom[N_cv]=(273.15+270)*ones(N_cv)  "|Methanation|Nominal Values|Nominal gas and catalyst temperature in the control volumes" annotation(Dialog(group="Nominal Values"));
  parameter SI.Pressure p_nom[N_cv]=(17e5)*ones(N_cv)  "|Methanation|Nominal Values|Nominal pressure in the control volumes" annotation(Dialog(group="Nominal Values"));
  parameter SI.MassFraction xi_nom[N_cv,vle_sg4.nc-1]=fill({0.296831,0.0304503,0.666944}, N_cv) "|Methanation|Nominal Values|Nominal values for mass fractions" annotation(Dialog(group="Nominal Values"));
  parameter Integer N_cv=10 "|Methanation|Fundamental Definitions|Number of control volumes" annotation(Dialog(group="Fundamental Definitions"));
  parameter Integer ScalingOfReactor=2 "|Methanation|Nominal Values|Chooce by which value the scaling of the reactor is defined" annotation(Dialog(group="Nominal Values"),choices(
                choice=1 "Define Reactor Scaling by nominal methane flow at output",
                choice=2 "Define Reactor Scaling by nominal hydrogen flow at input",
                choice=3 "Define Reactor Scaling by nominal methane enthalpy flow at output",
                choice=4 "Define Reactor Scaling by nominal hydrogen enthalpy flow at input"));
  parameter SI.MassFlowRate m_flow_n_Methane=0.0675008 "Nominal mass flow rate of methane at the outlet" annotation(Dialog(tab="Methanation",group="Nominal Values",enable = if ScalingOfReactor== 1 then true else false));
  parameter SI.MassFlowRate m_flow_n_Hydrogen=0.0339027 "Nominal mass flow rate of hydrogen at the inlet" annotation(Dialog(tab="Methanation",group="Nominal Values",enable = if ScalingOfReactor== 2 then true else false));
  parameter SI.EnthalpyFlowRate H_flow_n_Methane=3.375921e6 "Nominal enthalpy flow rate of methane at the output" annotation(Dialog(tab="Methanation",group="Nominal Values",enable = if ScalingOfReactor== 3 then true else false));
  parameter SI.EnthalpyFlowRate H_flow_n_Hydrogen=4.0673747e6 "Nominal enthalpy flow rate of hydrogen at the input" annotation(Dialog(tab="Methanation",group="Nominal Values",enable = if ScalingOfReactor== 4 then true else false));
  parameter SI.Temperature  T_start[N_cv]=503.15*ones(N_cv) "|Methanation|Initial Values|Initial gas and catalyst temperature in the control volumes" annotation(Dialog(group="Initialization"));
  parameter SI.Pressure p_start[N_cv]=17e5*ones(N_cv) "|Methanation|Initial Values|Initial pressure in the control volumes" annotation(Dialog(group="Initialization"));
  parameter SI.MassFraction xi_start[N_cv,gas_sg4.nc-1]=fill({0.296831,0.0304503,0.666944}, N_cv) "|Methanation|Initial Values|Initial values for mass fractions" annotation(Dialog(group="Initialization"));
  parameter SI.Temperature T_out_SNG=273.15+20 "|Methanation|Fundamental Definitions|Temperature of Synthetic Natural Gas after drying";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_woStorage feedInStation_Hydrogen annotation (Placement(transformation(extent={{-10,-10},{10,10}})), choices(
      choice(redeclare TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_woStorage feedInStation),
      choice(redeclare TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_Storage feedInStation),
      choice(redeclare TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_CavernComp feedInStation)));
  TransiEnt.Producer.Gas.MethanatorSystem.MethanatorSystem methanation(
    T_nom=T_nom,
    p_nom=p_nom,
    xi_nom=xi_nom,
    N_cv=N_cv,
    ScalingOfReactor=ScalingOfReactor,
    m_flow_n_Methane=m_flow_n_Methane,
    m_flow_n_Hydrogen=m_flow_n_Hydrogen,
    H_flow_n_Methane=H_flow_n_Methane,
    H_flow_n_Hydrogen=H_flow_n_Methane,
    T_start=T_start,
    p_start=p_start,
    xi_start=xi_start,
    T_out_SNG=T_out_SNG) annotation (Placement(transformation(extent={{50,-46},{70,-26}})));
protected
  TransiEnt.Producer.Gas.MethanatorSystem.Controller.MassFlowFeedInSystemController massFlowFeedInSystemController(P_el_max=feedInStation_Hydrogen.P_el_max, eta_n_ely=feedInStation_Hydrogen.eta_n) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,64})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massFlowSensor_SNG annotation (Placement(transformation(extent={{-5,-5},{5,5}},
        rotation=-90,
        origin={5,-71})));
  TransiEnt.Basics.Adapters.Gas.RealSG4_var_to_RealNG7_H2_var realSG4_var_to_RealNG7_SG(medium_ng7_H2_var=medium) annotation (Placement(transformation(extent={{46,-64},{32,-50}})));
  TransiEnt.Basics.Adapters.Gas.RealNG7_H2_var_to_RealSG4_var realNG7_SG_to_RealSG4_var(medium_ng7_H2_var=medium) annotation (Placement(transformation(extent={{34,-42},{46,-30}})));

  TransiEnt.Producer.Gas.MethanatorSystem.Controller.ControllerCO2ForMethanator controllerCO2ForMethanator annotation (Placement(transformation(extent={{38,-12},{28,-2}})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massFlowSensor_Hydrogen(medium=medium) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={13,-31})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow Source_CO2(
    medium=medium,
    variable_m_flow=true,
    T_const=493.15,
    xi_const={0,0,0,0,0,1})  annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={28,-24})));
  TransiEnt.Components.Gas.VolumesValvesFittings.ThreeWayValveRealGas_L1_simple TWV(splitRatio_input=true) annotation (Placement(transformation(
        extent={{-6.5,5.5},{6.5,-5.5}},
        rotation=-90,
        origin={0.5,-35.5})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 junction annotation (Placement(transformation(
        extent={{-7,6},{7,-6}},
        rotation=-90,
        origin={0,-57})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensor(compositionDefinedBy=2) annotation (Placement(transformation(
        extent={{-5,5},{5,-5}},
        rotation=-90,
        origin={-5,-83})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=if massFlowSensor_SNG.m_flow <= 1e-5 then 0 else HydrogenContentOutput) annotation (Placement(transformation(extent={{-74,-74},{-56,-56}})));
  Modelica.Blocks.Continuous.LimPID PID(
    y_start=0,
    yMax=1,
    yMin=0,
    k=0.5)                                               annotation (Placement(transformation(extent={{-40,-70},{-30,-60}})));
  TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var vle_sg4;
  TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG4_var gas_sg4;
  TILMedia.VLEFluid_ph gasOut(
    deactivateTwoPhaseRegion=true,
    h=inStream(compositionSensor.gasPortOut.h_outflow),
    p=compositionSensor.gasPortOut.p,
    xi=compositionSensor.gasPortOut.xi_outflow,
    vleFluidType=simCenter.gasModel1) annotation (Placement(transformation(extent={{18,-100},{38,-80}})));

protected
  model Outline
    extends TransiEnt.Basics.Icons.Record;
    input SI.Power P_el "Consumed electric power";
    input SI.Energy W_el "Consumed electric energy";
    input SI.Power H_flow_n_methanation_H2 "approximated nominal power of reactor based on NCV of hydrogen input";
    input SI.Power H_flow_n_methanation_CH4 "approximated nominal power of reactor based on NCV of methane outpur";
    input SI.Mass mass_H2 "Produced hydrogen mass";
    input SI.Mass mass_SNG "Produced hydrogen mass";
    input SI.Efficiency eta_electrolysis_HHV "Efficiency of electrolyzer based on HHV";
    input SI.Efficiency eta_electrolysis_LHV "Efficiency of electrolyzer based on LHV";
    input SI.Efficiency eta_methanation_LHV "Efficiency of methanation based on LHV";
  end Outline;

  model Summary
    extends TransiEnt.Basics.Icons.Record;
    Outline outline;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOutElectrolyzer;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOutMethanation;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
  end Summary;

public
  inner Summary summary(
    outline(
      P_el=feedInStation_Hydrogen.electrolyzer.summary.outline.P_el,
      W_el=feedInStation_Hydrogen.electrolyzer.summary.outline.W_el,
      H_flow_n_methanation_H2=methanation.summary.outline.H_flow_n_methanation_H2,
      H_flow_n_methanation_CH4=methanation.summary.outline.H_flow_n_methanation_CH4,
      mass_H2=feedInStation_Hydrogen.electrolyzer.summary.outline.mass_H2,
      mass_SNG=1,
      eta_electrolysis_HHV=feedInStation_Hydrogen.electrolyzer.summary.outline.eta,
      eta_electrolysis_LHV=feedInStation_Hydrogen.electrolyzer.summary.outline.eta/1.1819425,
      eta_methanation_LHV=methanation.methanator.summary.outline.efficiency),
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

equation

  connect(epp, feedInStation_Hydrogen.epp) annotation (Line(
      points={{-100,0},{-10,0}},
      color={0,135,135},
      thickness=0.5));
  connect(massFlowFeedInSystemController.P_el_set, P_el_set) annotation (Line(points={{2.22045e-015,76},{0,83.4},{0,108}}, color={0,0,127}));
  connect(feedInStation_Hydrogen.P_el_set, massFlowFeedInSystemController.P_el_ely) annotation (Line(points={{0,10.4},{0,53}}, color={0,0,127}));
  connect(feedInStation_Hydrogen.m_flow_feedIn, massFlowFeedInSystemController.m_flow_feed_ely) annotation (Line(points={{10,8},{18,8},{18,46},{8,46},{8,53}}, color={0,0,127}));
  connect(massFlowSensor_SNG.m_flow, massFlowFeedInSystemController.m_flow_feed_CH4_is) annotation (Line(points={{5,-76.5},{46,-76.5},{46,-76},{88,-76},{88,58},{12,58}}, color={0,0,127}));
  connect(realNG7_SG_to_RealSG4_var.gasPortOut, methanation.gasPortIn) annotation (Line(
      points={{46,-36},{46,-36},{50,-36}},
      color={255,255,0},
      thickness=1.5));
  connect(realNG7_SG_to_RealSG4_var.gasPortIn, massFlowSensor_Hydrogen.gasPortOut) annotation (Line(
      points={{34,-36},{22,-36},{18,-36}},
      color={255,255,0},
      thickness=1.5));
  connect(feedInStation_Hydrogen.gasPortOut, TWV.gasPortIn) annotation (Line(
      points={{-0.5,-10.1},{0,-10.1},{0,-24},{0,-26},{-0.111111,-26},{-0.111111,-29}},
      color={255,255,0},
      thickness=1.5));
  connect(massFlowSensor_Hydrogen.gasPortIn, TWV.gasPortOut2) annotation (Line(
      points={{8,-36},{8,-35.5},{6,-35.5}},
      color={255,255,0},
      thickness=1.5));
  connect(Source_CO2.gasPort, realNG7_SG_to_RealSG4_var.gasPortIn) annotation (Line(
      points={{28,-30},{28,-36},{34,-36}},
      color={255,255,0},
      thickness=1.5));
  connect(controllerCO2ForMethanator.m_flow_CO2, Source_CO2.m_flow) annotation (Line(points={{33,-12.5},{33,-14},{32,-14},{32,-16.8},{31.6,-16.8}}, color={0,0,127}));
  connect(TWV.gasPortOut1, junction.gasPort1) annotation (Line(
      points={{-0.111111,-42},{0,-42},{0,-50},{2.16493e-015,-50}},
      color={255,255,0},
      thickness=1.5));
  connect(junction.gasPort2, realSG4_var_to_RealNG7_SG.gasPortOut) annotation (Line(
      points={{6,-57},{20,-57},{32,-57}},
      color={255,255,0},
      thickness=1.5));
  connect(gasPortOut, compositionSensor.gasPortOut) annotation (Line(
      points={{0,-96},{0,-88}},
      color={255,255,0},
      thickness=1.5));
  connect(realExpression.y, PID.u_s) annotation (Line(points={{-55.1,-65},{-55.1,-65},{-41,-65}},
                                                                                                color={0,0,127}));
  connect(controllerCO2ForMethanator.m_flow_H2, massFlowSensor_Hydrogen.m_flow) annotation (Line(points={{28,-7},{18.5,-7},{18.5,-31}}, color={0,0,127}));
  connect(compositionSensor.gasPortIn, massFlowSensor_SNG.gasPortOut) annotation (Line(
      points={{1.77636e-015,-78},{0,-78},{0,-76}},
      color={255,255,0},
      thickness=1.5));
  connect(junction.gasPort3, massFlowSensor_SNG.gasPortIn) annotation (Line(
      points={{-3.88578e-016,-64},{0,-64},{0,-66},{1.77636e-015,-66}},
      color={255,255,0},
      thickness=1.5));
  connect(methanation.gasPortOut, realSG4_var_to_RealNG7_SG.gasPortIn) annotation (Line(
      points={{70,-36},{76,-36},{76,-57},{46,-57}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensor.fraction[7], PID.u_m) annotation (Line(points={{-5,-88.5},{-35,-88.5},{-35,-71}}, color={0,0,127}));
  connect(PID.y, TWV.splitRatio_external) annotation (Line(points={{-29.5,-65},{-25.75,-65},{-25.75,-35.5},{-5.61111,-35.5}}, color={0,0,127}));
  connect(massFlowFeedInSystemController.m_flow_feed, m_flow_feedIn) annotation (Line(points={{12,70},{108,70}}, color={0,0,127}));
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
<p>Consider that the output of the methanator still contains hydrogen such that an actual molar hydrogen content of &apos;0&apos; can not be achieved. This function is inteded to define a molar hydrogen content</p>
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
<p><br>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) in Feb 2018</p>
</html>"));
end FeedInSystem_Methanation;
