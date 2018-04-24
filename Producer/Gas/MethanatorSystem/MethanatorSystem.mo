within TransiEnt.Producer.Gas.MethanatorSystem;
model MethanatorSystem
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
  extends TransiEnt.Basics.Icons.FixedBedReactor_L4;
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
  //           Instances of other Classes
  // _____________________________________________
public
  Components.Gas.Reactor.Methanator_L4 methanator(
    N_cv=N_cv,
    redeclare model CostSpecsGeneral = CostSpecsGeneral,
    ScalingOfReactor=ScalingOfReactor,
    m_flow_n_Methane=m_flow_n_Methane,
    m_flow_n_Hydrogen=m_flow_n_Hydrogen,
    H_flow_n_Methane=H_flow_n_Methane,
    H_flow_n_Hydrogen=H_flow_n_Hydrogen,
    pressureCalculation=1,
    T_start=T_start,
    p_start=p_start,
    xi_start=xi_start,
    T_nom=T_nom,
    p_nom=p_nom,
    Delta_p=Delta_p_meth) annotation (Placement(transformation(extent={{-16,-10},{4,10}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor moleCompIn(medium=vle_sg4, compositionDefinedBy=2) annotation (Placement(transformation(extent={{-82,0},{-70,12}})));
protected
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature[N_cv] annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-76,58})));
  TransiEnt.Basics.Adapters.Gas.Ideal_to_Real ideal_to_Real(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var real, redeclare TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG4_var ideal) annotation (Placement(transformation(extent={{8,-10},{28,10}})));
  TransiEnt.Basics.Adapters.Gas.Real_to_Ideal real_to_Ideal(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var real, redeclare TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG4_var ideal) annotation (Placement(transformation(extent={{-42,-10},{-22,10}})));
public
  TransiEnt.Components.Sensors.RealGas.CompositionSensor moleCompOut_Dried(medium=vle_sg4, compositionDefinedBy=2) annotation (Placement(transformation(extent={{78,0},{88,12}})));
protected
  Modelica.Blocks.Sources.RealExpression realExpression[N_cv](y=T_nom) annotation (Placement(transformation(extent={{-120,48},{-100,68}})));
public
  Components.Gas.GasCleaning.Dryer_L1 dryer(
    medium_gas=vle_sg4,
    medium_water=TILMedia.VLEFluidTypes.TILMedia_SplineWater(),
    pressureLoss=Delta_p_dryer)                                                                                                                                                                                                         annotation (Placement(transformation(extent={{54,-10},{74,10}})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_pTxi
                                                           sink_water(
    boundaryConditions(showData=false),
    variable_p=false,
    medium=TILMedia.VLEFluidTypes.TILMedia_SplineWater())                                             annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={64,26})));

public
  inner Summary summary(
   gasPortIn(
     mediumModel=vle_sg4,
     xi=gasIn.xi,
     x=gasIn.x,
     m_flow=gasPortIn.m_flow,
     T=gasIn.T,
     p=gasPortIn.p,
     h=gasIn.h,
     rho=gasIn.d),
   gasPortOut(
     mediumModel=vle_sg4,
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
     eta=methanator.summary.outline.efficiency),
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
    input SI.Efficiency eta "efficiency based on LHV";
  end Outline;

  model Summary
    extends TransiEnt.Basics.Icons.Record;
    TransiEnt.Basics.Records.FlangeRealGas gasPortIn;
    TransiEnt.Basics.Records.FlangeRealGas gasPortOut;
    Outline outline;
    TransiEnt.Basics.Records.Costs costs;
  end Summary;

  TILMedia.VLEFluid_ph gasIn(
    h=inStream(gasPortIn.h_outflow),
    p=gasPortIn.p,
    xi=inStream(gasPortIn.xi_outflow),
    deactivateTwoPhaseRegion=true,
    vleFluidType=vle_sg4) annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  TILMedia.VLEFluid_ph gasOut(
    deactivateTwoPhaseRegion=true,
    vleFluidType=vle_sg4,
    p=dryer.gasPortOut.p,
    xi=dryer.gasPortOut.xi_outflow,
    h=actualStream(dryer.gasPortOut.h_outflow))
                                    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));

  TransiEnt.Components.Gas.HeatExchanger.HEXOneRealGasOuterTIdeal_L1 hEXBeforeMeth(
    medium=TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var(),
    T_fluidOut=T_nom[1],
    Delta_p=Delta_p_hEXBeforeMeth)                                                                    annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  Components.Gas.HeatExchanger.HEXOneRealGasOuterTIdeal_L1 hEXOneRealGasOuterTIdeal_L1_1(
    T_fluidOut=T_out_SNG,
    Delta_p=Delta_p_gas_hEXAfterMeth,
    medium=Basics.Media.Gases.VLE_VDIWA_SG4_var()) annotation (Placement(transformation(extent={{32,-10},{52,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature1 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={22,72})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=T_out_SNG) annotation (Placement(transformation(extent={{-32,62},{-12,82}})));
  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  final parameter TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG4_var gas_sg4;
  final parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var vle_sg4;

public
  parameter Integer N_cv=10 "Number of control volumes" annotation(Dialog(group="Fundamental Definitions"));

  parameter SI.Temperature T_nom[N_cv]=(273.15+270)*ones(N_cv)  "Nominal gas and catalyst temperature in the control volumes" annotation(Dialog(group="Nominal Values"));
  parameter SI.Pressure p_nom[N_cv]=(17e5)*ones(N_cv)  "Nominal pressure in the control volumes" annotation(Dialog(group="Nominal Values"));
  parameter SI.MassFraction xi_nom[N_cv,vle_sg4.nc-1]=fill({0.296831,0.0304503,0.666944}, N_cv) "Nominal values for mass fractions" annotation(Dialog(group="Nominal Values"));
  parameter Integer ScalingOfReactor=2 "Chooce by which value the scaling of the reactor is defined" annotation(Dialog(group="Nominal Values"),choices(
                choice=1 "Define Reactor Scaling by nominal methane flow at output",
                choice=2 "Define Reactor Scaling by nominal hydrogen flow at input",
                choice=3 "Define Reactor Scaling by nominal methane enthalpy flow at output",
                choice=4 "Define Reactor Scaling by nominal hydrogen enthalpy flow at input"));
  parameter SI.MassFlowRate m_flow_n_Methane=0.0675008 "Nominal mass flow rate of methane at the outlet" annotation(Dialog(group="Nominal Values",enable = if ScalingOfReactor== 1 then true else false));
  parameter SI.MassFlowRate m_flow_n_Hydrogen=0.0339027 "Nominal mass flow rate of hydrogen at the inlet" annotation(Dialog(group="Nominal Values",enable = if ScalingOfReactor== 2 then true else false));
  parameter SI.EnthalpyFlowRate H_flow_n_Methane=3.375921e6 "Nominal enthalpy flow rate of methane at the output" annotation(Dialog(group="Nominal Values",enable = if ScalingOfReactor== 3 then true else false));
  parameter SI.EnthalpyFlowRate H_flow_n_Hydrogen=4.0673747e6 "Nominal enthalpy flow rate of hydrogen at the input" annotation(Dialog(group="Nominal Values",enable = if ScalingOfReactor== 4 then true else false));

  parameter SI.Temperature  T_start[N_cv]=503.15*ones(N_cv) "Initial gas and catalyst temperature in the control volumes" annotation(Dialog(group="Initialization"));
  parameter SI.Pressure p_start[N_cv]=17e5*ones(N_cv) "Initial pressure in the control volumes" annotation(Dialog(group="Initialization"));
  parameter SI.MassFraction xi_start[N_cv,gas_sg4.nc-1]=fill({0.296831,0.0304503,0.666944}, N_cv) "Initial values for mass fractions" annotation(Dialog(group="Initialization"));

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

  parameter SI.Temperature T_out_SNG=20+273.15 "output temperature of synthetic natural gas after drying" annotation(Dialog(group="Dryer"));
  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

 SI.Mass mass_SNG "total produced SNG";
  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=vle_sg4) annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=vle_sg4) annotation (Placement(transformation(extent={{90,-10},{110,10}})));

equation

  der(mass_SNG)=-dryer.gasPortOut.m_flow;

  connect(real_to_Ideal.gasPortOut, methanator.gasPortIn) annotation (Line(
      points={{-22,0},{-22,0},{-16,0}},
      color={255,213,170},
      thickness=1.5));
  connect(methanator.gasPortOut, ideal_to_Real.gasPortIn) annotation (Line(
      points={{4,0},{8,0}},
      color={255,213,170},
      thickness=1.5));
  connect(methanator.heat, prescribedTemperature.port) annotation (Line(points={{-6,10},{-6,58},{-66,58}}, color={191,0,0}));
  connect(moleCompIn.gasPortIn, gasPortIn) annotation (Line(
      points={{-82,0},{-100,0}},
      color={255,255,0},
      thickness=1.5));
  connect(gasPortOut, moleCompOut_Dried.gasPortOut) annotation (Line(
      points={{100,0},{94,0},{88,0}},
      color={255,255,0},
      thickness=1.5));
  connect(moleCompOut_Dried.gasPortIn, dryer.gasPortOut) annotation (Line(
      points={{78,0},{74,0}},
      color={255,255,0},
      thickness=1.5));
  connect(realExpression.y, prescribedTemperature.T) annotation (Line(points={{-99,58},{-98,58},{-88,58}}, color={0,0,127}));
  connect(moleCompIn.gasPortOut, hEXBeforeMeth.gasPortIn) annotation (Line(
      points={{-70,4.44089e-016},{-66,4.44089e-016},{-66,0}},
      color={255,255,0},
      thickness=1.5));
  connect(real_to_Ideal.gasPortIn, hEXBeforeMeth.gasPortOut) annotation (Line(
      points={{-42,0},{-46,0}},
      color={255,255,0},
      thickness=1.5));
  connect(sink_water.fluidPortIn, dryer.fluidPortOut) annotation (Line(
      points={{64,16},{64,16},{64,10}},
      color={175,0,0},
      thickness=0.5));
  connect(hEXBeforeMeth.heat, prescribedTemperature[1].port) annotation (Line(points={{-56,10},{-58,10},{-58,36},{-58,56},{-58,58},{-66,58}}, color={191,0,0}));
  connect(ideal_to_Real.gasPortOut, hEXOneRealGasOuterTIdeal_L1_1.gasPortIn) annotation (Line(
      points={{28,0},{30,0},{32,0}},
      color={255,255,0},
      thickness=1.5));
  connect(dryer.gasPortIn, hEXOneRealGasOuterTIdeal_L1_1.gasPortOut) annotation (Line(
      points={{54,0},{54,0},{52,0}},
      color={255,255,0},
      thickness=1.5));
  connect(realExpression1.y, prescribedTemperature1.T) annotation (Line(points={{-11,72},{10,72}}, color={0,0,127}));
  connect(prescribedTemperature1.port, hEXOneRealGasOuterTIdeal_L1_1.heat) annotation (Line(points={{32,72},{42,72},{42,10}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{50,62},{84,32}},
          lineColor={28,108,200},
          textString="CH"),
        Text(
          extent={{68,36},{110,18}},
          lineColor={28,108,200},
          textString="4
"),     Polygon(
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
<p>(no elements)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) in Feb 2018</p>
</html>"));
end MethanatorSystem;
