within TransiEnt.Components.Gas.VolumesValvesFittings.Fittings;
model RealGasJunction_L2_nPorts_isoth "Isothermal volume junction with n ports for real gases"


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

  extends TransiEnt.Basics.Icons.RealGasJunction_L2;

  // _____________________________________________
  //
  //        Constants and  Hidden Parameters
  // _____________________________________________

  final parameter Integer dependentCompositionEntries[:]=if variableCompositionEntries[1] == 0 then 1:medium.nc else TransiEnt.Basics.Functions.findSetDifference(
                                                                                                                                                  1:medium.nc, variableCompositionEntries) "Entries of medium vector which are supposed to be dependent on the variable entries";

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium in the component" annotation (Dialog(group="Fundamental Definitions"));
  parameter SI.Temperature T_ground=simCenter.T_ground "Temperature of the surrounding ground" annotation(Dialog(group="Fundamental Definitions"));
  parameter Integer n_ports=3 annotation(Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Volume volume=0.1 "Volume of the junction" annotation (Dialog(group="Fundamental Definitions"));
  parameter Boolean constantComposition=simCenter.useConstCompInGasComp "Use simplified equation for constant composition (xi_nom will be used)" annotation (Dialog(group="Fundamental Definitions"));
  parameter SI.MassFraction xi_nom[medium.nc - 1] = medium.xi_default "Constant composition" annotation (Dialog(group="Fundamental Definitions",enable=constantComposition));
  parameter Integer variableCompositionEntries[:](min=0,max=medium.nc)=simCenter.variableCompositionEntriesGasPipes
                                                                           "Entries of medium vector which are supposed to be completely variable" annotation(Dialog(group="Fundamental Definitions",enable=not constantComposition));
  parameter Integer massBalance=simCenter.massBalanceGasPipes "Mass balance and species balance fomulation" annotation(Dialog(group="Fundamental Definitions"),choices(choice=1 "Dynamic", choice=4 "Quasi stationary"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nom[n_ports]=ones(n_ports)*10 "Nominal mass flow rate" annotation (Dialog(group="Fundamental Definitions"));
  parameter Modelica.Units.SI.PressureDifference Delta_p_nom[n_ports](displayUnit="Pa") = zeros(n_ports) "Nominal pressure loss at m_flow_nom" annotation (Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Pressure p_start=simCenter.p_amb_const + simCenter.p_eff_2 "Initial value for gas pressure" annotation (Dialog(group="Initial Values"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_start=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
      medium,
      p_start,
      T_start,
      xi_start) "Initial value for gas specific enthalpy" annotation (Dialog(group="Initial Values"));
  parameter ClaRa.Basics.Units.MassFraction xi_start[medium.nc - 1]=medium.xi_default "Initial value for mass fractions" annotation (Dialog(group="Initial Values"));
  parameter ClaRa.Basics.Units.Temperature T_start=simCenter.T_ground "Initial value for gas temperature (used in calculation of h_start)" annotation (Dialog(group="Initial Values"));
  parameter Integer initOption=simCenter.initOptionGasPipes
                                 "Type of initialisation" annotation (                              choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=201 "Steady pressure",
      choice=202 "Steady enthalpy",
      choice=208 "Steady pressure and enthalpy",
      choice=210 "Steady density"), Dialog(group="Initial Values"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPort[n_ports](each Medium=medium) annotation (Placement(transformation(extent={{-10,-10},{10,10}}),   iconTransformation(extent={{-10,-10},{10,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2_nPorts junction(
    final initOption=initOption,
    final medium=medium,
    final n_ports=n_ports,
    final massBalance=massBalance,
    final showHeatPort=true,
    final m_flow_nom=m_flow_nom,
    final Delta_p_nom=Delta_p_nom,
    final volume=volume,
    final constantComposition=constantComposition,
    final variableCompositionEntries=variableCompositionEntries,
    final p_start=p_start,
    final h_start=h_start,
    final xi_start=xi_start,
    final T_start=T_start,
    final xi_nom=xi_nom,
    h(stateSelect=StateSelect.never)) annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=T_ground) annotation (Placement(transformation(extent={{-62,50},{-42,70}})));

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  Storage.Gas.Base.ConstantHTOuterTemperature_L2 ht(alpha_nom=10e4, A_heat=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-16,60})));
equation
  connect(junction.gasPort, gasPort) annotation (Line(
      points={{0,30},{0,30},{0,0}},
      color={255,255,0},
      thickness=1.5));
  connect(realExpression.y, ht.T_outer) annotation (Line(points={{-41,60},{-26,60}}, color={0,0,127}));
  connect(ht.heat, junction.heat) annotation (Line(
      points={{-6,60},{0,60},{0,33}},
      color={167,25,48},
      thickness=0.5));
  annotation (defaultComponentName="junction",Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=true)),
                                 Icon(coordinateSystem(extent={{-100,-100},{100,100}},
                   preserveAspectRatio=false), graphics={
        Text(
          extent={{-20,-54},{20,-96}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="L2"),
        Text(
          extent={{0,20},{100,-20}},
          lineColor={238,46,47},
          textString="isoth.")}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents an isothermal junction for real gases with n ports with a given surrounding temperature.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPort1: inlet for gas</p>
<p>gasPort2: inlet for gas</p>
<p>gasPort3: outlet for gas</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Carsten Bode (c.bode@tuhh.de), Sep 2019</p>
<p>Modified by Carsten Bode (c.bode@tuhh.de), May 2020 (added quasi-stationary equations and simplified equations for only dependent mass fractions)</p>
</html>"));
end RealGasJunction_L2_nPorts_isoth;
