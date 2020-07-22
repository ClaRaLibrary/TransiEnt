within TransiEnt.Components.Gas.VolumesValvesFittings;
model RealGasJunction_L2_isoth "Isothermal volume junction for real gases"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
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
  parameter ClaRa.Basics.Units.Volume volume=0.1 "Volume of the junction" annotation (Dialog(group="Fundamental Definitions"));
  parameter Boolean constantComposition=simCenter.useConstCompInGasComp "Use simplified equation for constant composition (xi_nom will be used)" annotation (Dialog(group="Fundamental Definitions"));
  parameter SI.MassFraction xi_nom[medium.nc - 1] = medium.xi_default "Constant composition" annotation (Dialog(group="Fundamental Definitions",enable=constantComposition));
  parameter Integer variableCompositionEntries[:](min=0,max=medium.nc)={0} "Entries of medium vector which are supposed to be completely variable" annotation(Dialog(group="Fundamental Definitions",enable=not constantComposition));
  parameter Integer massBalance=simCenter.massBalanceGasPipes "Mass balance and species balance fomulation" annotation(Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Pressure p_start=simCenter.p_amb_const + simCenter.p_eff_2 "Initial value for gas pressure" annotation (Dialog(group="Initial Values"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_start=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
      medium,
      p_start,
      T_start,
      xi_start) "Initial value for gas specific enthalpy" annotation (Dialog(group="Initial Values"));
  parameter ClaRa.Basics.Units.MassFraction xi_start[medium.nc - 1]=medium.xi_default "Initial value for mass fractions" annotation (Dialog(group="Initial Values"));
  parameter ClaRa.Basics.Units.Temperature T_start=simCenter.T_ground "Initial value for gas temperature (used in calculation of h_start)" annotation (Dialog(group="Initial Values"));
  parameter Integer initOption=simCenter.initOptionGasPipes "Type of initialisation" annotation (                              choices(
      choice=0 "Use guess values",
      choice=1 "Steady state",
      choice=201 "Steady pressure",
      choice=202 "Steady enthalpy",
      choice=208 "Steady pressure and enthalpy",
      choice=210 "Steady density"), Dialog(group="Initial Values"));
  parameter Boolean showData=true "True, if a data port containing p,T,h,s,m_flow shall be shown, else false" annotation (Dialog(tab="Summary and Visualisation"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPort1(Medium=medium) annotation (Placement(transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPort2(Medium=medium) annotation (Placement(transformation(extent={{-10,-110},{10,-90}}), iconTransformation(extent={{-10,-110},{10,-90}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPort3(Medium=medium) annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable model PressureLoss1 = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.NoFriction constrainedby ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.BaseDp annotation (__Dymola_choicesAllMatching=true,Dialog(group="Fundamental Definitions"));
  replaceable model PressureLoss2 = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.NoFriction constrainedby ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.BaseDp annotation (__Dymola_choicesAllMatching=true,Dialog(group="Fundamental Definitions"));
  replaceable model PressureLoss3 = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.NoFriction constrainedby ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.BaseDp annotation (__Dymola_choicesAllMatching=true,Dialog(group="Fundamental Definitions"));

  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 junction(
    final initOption=initOption,
    final medium=medium,
    redeclare final model PressureLoss1 = PressureLoss1,
    redeclare final model PressureLoss2 = PressureLoss2,
    redeclare final model PressureLoss3 = PressureLoss3,
    final volume=volume,
    final constantComposition=constantComposition,
    final variableCompositionEntries=variableCompositionEntries,
    final massBalance=massBalance,
    final showHeatPort=true,
    final showData=showData,
    final p_start=p_start,
    final h_start=h_start,
    final xi_start=xi_start,
    final T_start=T_start,
    final xi_nom=xi_nom,
    h(stateSelect=StateSelect.never)) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=T_ground) annotation (Placement(transformation(extent={{-62,20},{-42,40}})));

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

equation
  connect(realExpression.y, prescribedTemperature.T) annotation (Line(points={{-41,30},{-32,30}}, color={0,0,127}));
  connect(gasPort1, junction.gasPort1) annotation (Line(
      points={{-100,0},{-10,0}},
      color={255,255,0},
      thickness=1.5));
  connect(junction.gasPort2, gasPort2) annotation (Line(
      points={{0,-10},{0,-100}},
      color={255,255,0},
      thickness=1.5));
  connect(junction.gasPort3, gasPort3) annotation (Line(
      points={{10,0},{100,0}},
      color={255,255,0},
      thickness=1.5));
  connect(prescribedTemperature.port, junction.heat) annotation (Line(points={{-10,30},{0,30},{0,3}}, color={191,0,0}));
  annotation (defaultComponentName="junction",Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
          preserveAspectRatio=true)),
                                 Icon(coordinateSystem(extent={{-100,-100},{100,100}},
                   preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-92,32},{-74,-32}},
          pattern=LinePattern.None,
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid,
          visible=junction.pressureLoss1.hasPressureLoss), Rectangle(
          extent={{74,32},{92,-32}},
          pattern=LinePattern.None,
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid,
          visible=junction.pressureLoss2.hasPressureLoss),
        Rectangle(
          extent={{-32,-76},{32,-92}},
          pattern=LinePattern.None,
          fillColor={118,106,98},
          fillPattern=FillPattern.Solid,
          visible=junction.pressureLoss3.hasPressureLoss),
        Text(
          extent={{-20,-54},{20,-96}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="L2"),
        Text(
          extent={{-60,20},{60,-20}},
          lineColor={238,46,47},
          textString="isoth.")}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model represents an isothermal junction for real gases with a given surrounding temperature.</p>
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
end RealGasJunction_L2_isoth;
