within TransiEnt.Producer.Gas.MethanatorSystem;
partial model PartialMethanatorSystem

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
  import      Modelica.Units.SI;
  extends TransiEnt.Basics.Icons.FixedBedReactor_L4;
  extends TransiEnt.Producer.Heat.Base.PartialHeatProvision;

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
  //              Visible Parameters
  // _____________________________________________
  parameter Integer N_cv=10 "Number of control volumes" annotation(Dialog(group="Fundamental Definitions"));

  parameter SI.Temperature T_nom[N_cv]=(273.15+270)*ones(N_cv)  "Nominal gas and catalyst temperature in the control volumes" annotation(Dialog(group="Nominal Values"));
  parameter SI.Pressure p_nom[N_cv]=(17e5)*ones(N_cv)  "Nominal pressure in the control volumes" annotation(Dialog(group="Nominal Values"));
  parameter SI.MassFraction xi_nom[N_cv,vle_sg4.nc-1]=fill({0.30439,0.00997376,0.683929}, N_cv) "Nominal values for mass fractions" annotation(Dialog(group="Nominal Values"));
   parameter Integer scalingOfReactor=2 "Chooce by which value the scaling of the reactor is defined" annotation(Dialog(group="Nominal Values"),choices(
                 choice=1 "Define Reactor Scaling by nominal methane flow at output",
                 choice=2 "Define Reactor Scaling by nominal hydrogen flow at input",
                 choice=3 "Define Reactor Scaling by nominal methane enthalpy flow at output",
                 choice=4 "Define Reactor Scaling by nominal hydrogen enthalpy flow at input"));
  parameter SI.MassFlowRate m_flow_n_Methane=0.0675008 "Nominal mass flow rate of methane at the outlet" annotation(Dialog(group="Nominal Values",enable = if scalingOfReactor== 1 then true else false));
  parameter SI.MassFlowRate m_flow_n_Hydrogen=0.0339027 "Nominal mass flow rate of hydrogen at the inlet" annotation(Dialog(group="Nominal Values",enable = if scalingOfReactor== 2 then true else false));
  parameter SI.EnthalpyFlowRate H_flow_n_Methane=3.375921e6 "Nominal enthalpy flow rate of methane at the output" annotation(Dialog(group="Nominal Values",enable = if scalingOfReactor== 3 then true else false));
  parameter SI.EnthalpyFlowRate H_flow_n_Hydrogen=4.0673747e6 "Nominal enthalpy flow rate of hydrogen at the input" annotation(Dialog(group="Nominal Values",enable = if scalingOfReactor== 4 then true else false));

  parameter SI.Temperature  T_start[N_cv]=(273.15+270)*ones(N_cv) "Initial gas and catalyst temperature in the control volumes" annotation(Dialog(group="Initialization"));
  parameter SI.Pressure p_start[N_cv]=17e5*ones(N_cv) "Initial pressure in the control volumes" annotation(Dialog(group="Initialization"));
  parameter SI.MassFraction xi_start[N_cv,gas_sg4.nc-1]=fill({0.30439,0.00997376,0.683929}, N_cv) "Initial values for mass fractions" annotation(Dialog(group="Initialization"));

  parameter SI.Temperature T_co2_source=simCenter.T_amb_const "Temperature for CO2 from source" annotation(Dialog(group="Sources and Sinks"));
  //parameter SI.MassFlowRate m_flow_water_source=-1 "Mass flow rate of water from source" annotation(Dialog(group="Sources and Sinks"));
  parameter SI.Temperature T_water_source=simCenter.T_amb_const "Temperature of water from source" annotation(Dialog(group="Sources and Sinks"));
  parameter SI.Pressure p_water_sink_hex=simCenter.p_amb_const "Pressure of water at sink after HEX" annotation(Dialog(group="Sources and Sinks"));
  parameter SI.Pressure p_water_sink_dryer=simCenter.p_amb_const "Pressure of water at sink after dryer" annotation(Dialog(group="Sources and Sinks"));

  parameter Boolean useCO2Input=false "Use gas port for CO2 for methanation" annotation (Dialog(               group="General"));
  parameter SI.VolumeFraction hydrogenFraction_fixed=0.1 "target volume fraction of hydrogen" annotation (Dialog(               group="General"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Natural Gas model to be used" annotation (choicesAllMatching,Dialog(tab="General", group="General"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_CO2=simCenter.gasModel1 "CO2 model to be used" annotation (choicesAllMatching,Dialog(tab="General", group="General"));
  parameter SI.Temperature T_out_SNG=20+273.15 "output temperature of synthetic natural gas after drying" annotation(Dialog(group="Dryer"));
  parameter Boolean integrateMassFlow=false "True if mass flow shall be integrated" annotation (Dialog(tab="General", group="General"));
  parameter Boolean useVariableHydrogenFraction=false "meassured hydrogen fraction for hydrogen-fraction-controller" annotation (Dialog(               group="General"));
  parameter Integer heatLossCalculation=1 annotation(Dialog(group="Coolant"),choices(__Dymola_radioButtons=true, choice=1 "logarithmic approximation", choice=2 "use fix percentage", choice=3 "no heat losses"));
  parameter Real percentageLosses=0.01 annotation(Dialog(group="Coolant",enable=if heatLossCalculation==2 then true else false));
  final parameter SI.SpecificEnthalpy[medium.nc] NCV=TransiEnt.Basics.Functions.GasProperties.getRealGasNCVVector(medium, medium.nc) "NCV of gas components";
  final parameter SI.SpecificEnthalpy[medium.nc] GCV=TransiEnt.Basics.Functions.GasProperties.getRealGasGCVVector(medium, medium.nc) "GCV of gas component";
  final parameter SI.Density rho_H2=TILMedia.Internals.VLEFluidFunctions.density_pTxi(p_nom[1],T_out_SNG,{0,0,0},vle_sg4.concatVLEFluidName, vle_sg4.nc+TILMedia.Internals.redirectModelicaFormatMessage());
  final parameter TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG4_var gas_sg4;
  final parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var vle_sg4;
  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.HeatFlowRate Q_flow;
  SI.HeatFlowRate Q_loss "Thermal losses to environment";
  SI.MassFlowRate m_flow_n_Hydrogen_is "Nominal mass flow rate of hydrogen at the inlet calculated by nominal scaling value";
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________
  Basics.Interfaces.General.MassFlowRateIn hydrogenFraction_input if useVariableHydrogenFraction    annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-110,-50})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium)  annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium)  annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn_CO2(Medium=medium_CO2) if useCO2Input annotation (Placement(transformation(extent={{-70,-110},{-50,-90}})));

  ClaRa.Components.Sensors.SensorVLE_L1_T T_coolant_out(unitOption=2) if useFluidCoolantPort annotation (Placement(transformation(extent={{120,-40},{130,-28}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T T_coolant_in(unitOption=2) if useFluidCoolantPort annotation (Placement(transformation(extent={{118,-90},{128,-78}})));
equation
   Q_flow_heatprovision=min(0,Q_flow);

   if heatLossCalculation==1 then
     Q_loss=-(4157.6*log(m_flow_n_Hydrogen_is)+13660);
   elseif heatLossCalculation==2 then
     Q_loss=percentageLosses*Q_flow;
   else
     Q_loss=0;
   end if;

   if useFluidCoolantPort then
  connect(fluidPortOut,T_coolant_out. port) annotation (Line(
      points={{100,-40},{125,-40}},
      color={175,0,0},
      thickness=0.5));
  connect(fluidPortIn,T_coolant_in. port) annotation (Line(
      points={{100,-90},{123,-90}},
      color={175,0,0},
      thickness=0.5));
   end if;
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
<p>This model is partial model for methanator systems.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Calculation of heat losses via simplified correlation taken from calculation results from model &apos;EquilibriumModel.Methanation.ThreeStages&apos;.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn: inlet for real gas</p>
<p>gasPortOut: outlet for real gas</p>
<p>gasPortIn_CDE: inlet for CO2 mass flow</p>
<p>heat: heat port - active if &apos;useHeatPort=true&apos;</p>
<p>fluidPortIn: fluid Port for coolant - active if &apos;useFluidCoolandPort=true&apos;</p>
<p>fluidPortOut: fluid Port for coolant - active if &apos;useFluidCoolandPort=true&apos;</p>
<p>temperatureIn: defines output temperature of coolant - active if &apos;useVariableCoolantOutputTemperature=true&apos;</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) in Jul 2019</p>
</html>"));
end PartialMethanatorSystem;
