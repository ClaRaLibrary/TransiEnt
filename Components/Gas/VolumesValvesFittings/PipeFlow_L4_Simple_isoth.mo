within TransiEnt.Components.Gas.VolumesValvesFittings;
model PipeFlow_L4_Simple_isoth "A 1D tube-shaped control volume considering one-phase heat transfer in a straight pipe with static momentum balance and isothermal energy balance"

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

  extends TransiEnt.Basics.Icons.PipeFlow_L4_Simple;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium in the component" annotation (Dialog(group="Fundamental Definitions"));
  parameter Boolean constantComposition=simCenter.useConstCompInGasComp "true if composition of gas in the pipe is constant (xi_nom will be used)" annotation (Dialog(group="Fundamental Definitions"));
  parameter Integer variableCompositionEntries[:](min=0,max=medium.nc)=simCenter.variableCompositionEntriesGasPipes "Entries of medium vector which are supposed to be completely variable" annotation(Dialog(group="Fundamental Definitions",enable=not constantComposition));
  parameter Integer massBalance=simCenter.massBalanceGasPipes "Mass balance and species balance fomulation" annotation (Dialog(group="Fundamental Definitions"), choices(
      choice=1 "ClaRa formulation",
      choice=2 "TransiEnt formulation 1a",
      choice=3 "TransiEnt formulation 1b",
      choice=4 "Quasi stationary"));
  parameter Boolean frictionAtInlet=false "True if pressure loss between first cell and inlet shall be considered" annotation (choices(checkBox=true), Dialog(group="Fundamental Definitions"));
  parameter Boolean frictionAtOutlet=false "True if pressure loss between last cell and outlet shall be considered" annotation (choices(checkBox=true), Dialog(group="Fundamental Definitions"));
  parameter SI.Temperature T_ground=simCenter.T_ground "Temperature of the surrounding ground" annotation (Dialog(group="Fundamental Definitions"));
  parameter ClaRa.Basics.Units.Pressure p_nom[N_cv]=ones(N_cv)*1e5 "Nominal pressure" annotation (Dialog(group="Nominal Values"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_nom[N_cv]=ones(N_cv)*1e5 "Nominal specific enthalpy for single tube" annotation (Dialog(group="Nominal Values"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom=100 "Nominal mass flow w.r.t. all parallel tubes" annotation (Dialog(group="Nominal Values"));
  parameter ClaRa.Basics.Units.PressureDifference Delta_p_nom=1e4 "Nominal pressure loss w.r.t. all parallel tubes" annotation (Dialog(group="Nominal Values"));
  parameter ClaRa.Basics.Units.MassFraction xi_nom[medium.nc - 1]=medium.xi_default "Nominal composition" annotation (Dialog(group="Nominal Values"));
  parameter ClaRa.Basics.Units.Length length=10e3 "Length of the pipe (one pass)" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length diameter_i=0.5 "Inner diameter of the pipe" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_in=0.1 "Height of inlet above ground" annotation (Dialog(group="Geometry"));
  parameter ClaRa.Basics.Units.Length z_out=0.1 "Height of outlet above ground" annotation (Dialog(group="Geometry"));
  parameter Integer N_tubes=1 "Number Of parallel pipes" annotation (Dialog(group="Geometry"));
  parameter Integer N_passes=1 "Number of passes of the tubes" annotation (Dialog(group="Geometry"));
  parameter Integer N_cv=3 "Number of finite volumes (for N_cv=1 set frictionAtInlet=true or frictionAtOutlet=true)" annotation (Dialog(group="Discretisation"));
  parameter ClaRa.Basics.Units.Length Delta_x[N_cv]=ClaRa.Basics.Functions.GenerateGrid(
      {0},
      length*N_passes,
      N_cv) "Discretisation scheme" annotation (Dialog(group="Discretisation"));
  parameter Integer initOption=simCenter.initOptionGasPipes "Type of initialization" annotation (Dialog(tab="Initialisation"), choices(
      choice=0 "Use guess values",
      choice=208 "Steady pressure and enthalpy",
      choice=201 "Steady pressure",
      choice=202 "Steady enthalpy",
      choice=210 "Steady density"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_start[N_cv]=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
      medium,
      p_start,
      T_start,
      xi_nom) "Initial specific enthalpy for single tube" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure p_start[N_cv]=ones(N_cv)*(simCenter.p_eff_2 + simCenter.p_amb_const) "Initial pressure" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_start[medium.nc - 1]=pipe.xi_nom "Initial composition for single tube" annotation (Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_start[N_cv + 1]=ones(N_cv + 1)*0.01 "Initial mass flow rate" annotation (Dialog(tab="Initialisation"));
  parameter SI.Temperature T_start[N_cv]=ones(N_cv)*T_ground "Initial temperature for single tube (used in calculation of h_start)" annotation (Dialog(tab="Initialisation"));
  parameter Boolean useHomotopy=simCenter.useHomotopy "true, if homotopy method is used during initialisation" annotation (Dialog(tab="Initialisation", group="Model Settings"));
  parameter Boolean showExpertSummary=simCenter.showExpertSummary "True, if an extended summary shall be shown, else false" annotation (Dialog(tab="Summary and Visualisation"));
  parameter Boolean showData=false "True, if a data port containing p,T,h,s,m_flow shall be shown, else false" annotation (Dialog(tab="Summary and Visualisation"));
  parameter Boolean contributeToCycleSummary=simCenter.contributeToCycleSummary "True if component shall contribute to automatic efficiency calculation" annotation (Dialog(tab="Summary and Visualisation"));
  parameter Boolean heatFlowIsLoss=true "True if negative heat flow is a loss (not a process product)" annotation (Dialog(tab="Summary and Visualisation"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium) "Inlet port" annotation (Placement(transformation(extent={{-150,-10},{-130,10}}), iconTransformation(extent={{-150,-10},{-130,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) "Outlet port" annotation (Placement(transformation(extent={{130,-10},{150,10}}), iconTransformation(extent={{130,-10},{150,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable model PressureLoss = TransiEnt.Components.Gas.VolumesValvesFittings.Base.PhysicalPL_L4_constVisc constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseVLE_L4
                                                                                                                                                                                                        annotation (__Dymola_choicesAllMatching=true, Dialog(group="Fundamental Definitions"));
  replaceable model MechanicalEquilibrium = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.Homogeneous_L4 constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.MechanicalEquilibrium_L4 annotation (__Dymola_choicesAllMatching=true, Dialog(group="Fundamental Definitions"));
  replaceable model CostSpecsGeneral = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Empty constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs annotation (__Dymola_choicesAllMatching=true, Dialog(group="Statistics"));

  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple pipe(
    final medium=medium,
    final constantComposition=constantComposition,
    final variableCompositionEntries=variableCompositionEntries,
    final massBalance=massBalance,
    final frictionAtInlet=frictionAtInlet,
    final frictionAtOutlet=frictionAtOutlet,
    redeclare final model PressureLoss = PressureLoss,
    redeclare final model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
    redeclare final model MechanicalEquilibrium = MechanicalEquilibrium,
    final p_nom=p_nom,
    final h_nom=h_nom,
    final m_flow_nom=m_flow_nom,
    final Delta_p_nom=Delta_p_nom,
    final xi_nom=xi_nom,
    final initOption=initOption,
    final useHomotopy=useHomotopy,
    final h_start=h_start,
    final p_start=p_start,
    final xi_start=xi_start,
    final m_flow_start=m_flow_start,
    final T_start=T_start,
    final showExpertSummary=showExpertSummary,
    final showData=showData,
    final length=length,
    final diameter_i=diameter_i,
    final z_in=z_in,
    final z_out=z_out,
    final N_tubes=N_tubes,
    final N_passes=N_passes,
    final N_cv=N_cv,
    final Delta_x=Delta_x,
    final contributeToCycleSummary=contributeToCycleSummary,
    final heatFlowIsLoss=heatFlowIsLoss,
    redeclare final model CostSpecsGeneral = CostSpecsGeneral,
    h(stateSelect=StateSelect.never)) annotation (Placement(transformation(extent={{-14,-5},{14,5}})));
protected
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector(final m=N_cv) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={0,20})));
  Modelica.Blocks.Sources.RealExpression realExpression(final y=T_ground) annotation (Placement(transformation(extent={{-62,20},{-42,40}})));

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
equation
  connect(thermalCollector.port_a, pipe.heat) annotation (Line(points={{0,10},{0,3.33333}}, color={191,0,0}));
  connect(thermalCollector.port_b, prescribedTemperature.port) annotation (Line(points={{0,30},{-10,30}}, color={191,0,0}));
  connect(realExpression.y, prescribedTemperature.T) annotation (Line(points={{-41,30},{-32,30}}, color={0,0,127}));
  connect(pipe.gasPortIn, gasPortIn) annotation (Line(
      points={{-14,0},{-140,0}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe.gasPortOut, gasPortOut) annotation (Line(
      points={{14,0},{140,0}},
      color={255,255,0},
      thickness=1.5));
  annotation (
    defaultComponentName="pipe",
    Icon(graphics={
        Polygon(
          points={{-132,42},{-122,42},{-114,34},{-114,-36},{-122,-42},{-132,-42},{-132,42}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          visible=frictionAtInlet),
        Polygon(
          points={{132,42},{122,42},{114,34},{114,-36},{122,-42},{132,-42},{132,42}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,131,169},
          fillPattern=FillPattern.Solid,
          visible=frictionAtOutlet),
        Text(
          extent={{30,0},{130,-40}},
          lineColor={238,46,47},
          textString="isoth.")}, coordinateSystem(preserveAspectRatio=false, extent={{-140,-60},{140,60}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-60},{140,60}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This model is an isothermal pipe with a given surrounding temperature. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>gasportIn: inlet for real gas</p>
<p>gasportOut: outet for real gas</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Use of this model can lead to warnings like &quot;Differentiating (if pipe_xy.iCom.m_flow_in[1] &gt; 0.0 then junction_beforePipe.gasBulk.xi[1] else junction_beforePipe.gasBulk.xi[1]) under the assumption that it is continuous at switching.&quot;. This can be ignored as long as the composition is set to the same value in every component (even in sinks etc.).</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Created by Carsten Bode (c.bode@tuhh.de), Sep 2019</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified by Carsten Bode (c.bode@tuhh.de), May 2020 (added quasi-stationary equations and simplified equations for only dependent mass fractions)</span></p>
</html>"));
end PipeFlow_L4_Simple_isoth;
