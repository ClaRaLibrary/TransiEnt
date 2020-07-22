within TransiEnt.Components.Boundaries.Heat;
model Heatflow_L2 "Heat flow boundary with prescribed power and given volume (L2)"

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

  import TransiEnt;
  extends TransiEnt.Components.Boundaries.Heat.Base.PartialHeatBoundary;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter SI.Power Q_flow_n=100e3 "|Heat demand|Nominal heating power";
  parameter Boolean use_Q_flow_in=true "|Heat demand|Use external value for Q_flow" annotation(choices(__Dymola_checkBox=true));
  parameter Boolean change_sign=false "Change sign on input value (false: setpoint < 0 means producing heat)";
  parameter SI.Power Q_flow_const=100e3 "|Heat demand|Constant heating power" annotation (Dialog(enable = not use_Q_flow_in));

  parameter SI.MassFlowRate m_flow_nom=simCenter.m_flow_nom "|Heat exchanger|Nominal mass flow rate";
  parameter SI.Pressure p_nom=simCenter.p_nom[1] "Nominal pressure" annotation (Dialog(group="Heat exchanger"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_nom=1e5 "|Heat exchanger|Nominal specific enthalpy";
  parameter SI.HeatCapacity C=1e9 "|Heat exchanger|Heat capacity (geometry is calculated by this value)" annotation (Evaluate=true, HideResult=true);
  parameter SI.Pressure p_start=simCenter.p_nom[1] "Start value of system pressure" annotation (Dialog(group="Heat exchanger"));
  parameter SI.Temperature T_start=323.15 "|Heat exchanger|Initial temperature" annotation (Evaluate=true, HideResult=true);
  parameter Integer initOption=0 "|Heat exchanger|Type of initialisation" annotation(choices(choice = 0 "Use guess values", choice = 1 "Steady state", choice=201 "Steady pressure", choice = 202 "Steady enthalpy", choice=204 "Fixed rel.level (for phaseBorder = idealSeparated only)",  choice=205 "Fixed rel.level and steady pressure (for phaseBorder = idealSeparated only)"));
  replaceable model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2
   constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.PressureLoss_L2 "|Heat exchanger|Pressure loss model" annotation (choicesAllMatching=true, Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model for pressure loss</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));

  parameter Real valveAuthority=0.6 "|Valve|Valve authority";
  parameter SI.Pressure Delta_p_nom=simCenter.p_nom[2]-simCenter.p_nom[1] "|Valve|Nominal pressure drop";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

protected
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_internal;

public
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_prescribed if use_Q_flow_in "RealInput (for specification of boundary power)"
    annotation (Placement(transformation(extent={{120,-20},{80,20}}),
        iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={-60,80})));

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  ClaRa.Components.HeatExchangers.IdealShell_L2 heatExchanger(
    medium=Medium,
    width=(C/4186/1000)^(1/3),
    length=(C/4186/1000)^(1/3),
    height=(C/4186/1000)^(1/3),
    m_flow_nom=m_flow_nom,
    p_nom=p_nom,
    showData=false,
    h_nom=h_nom,
    h_start=(T_start - 273.15)*4186,
    initOption=initOption,
    p_start(displayUnit="Pa") = p_start,
    redeclare model PressureLoss = PressureLoss)       annotation (Placement(transformation(
        extent={{16,-14},{-16,14}},
        rotation=-90,
        origin={0,0})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatDemand
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,0})));

  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 controlValve(
      openingInputIsActive=true,
    showData=false,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (
        Delta_p_nom=Delta_p_nom*valveAuthority,
        m_flow_nom=m_flow_nom,
        CL_valve=[0,0.1; 1,1]),
    medium=Medium)                                         annotation (
      Placement(transformation(
        extent={{10,-6},{-10,6}},
        rotation=-90,
        origin={0,-58})));

  Modelica.Blocks.Math.Gain normalizer(k=1/Q_flow_n)
    annotation (Placement(transformation(extent={{38,-69},{16,-47}})));

  Modelica.Blocks.Math.Gain signChanger(k=if change_sign then 1 else -1)
    annotation (Placement(transformation(extent={{72,-11},{50,11}})));

equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  if not use_Q_flow_in then
    Q_flow_internal = Q_flow_const;
  end if;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(Q_flow_internal, Q_flow_prescribed);
  connect(signChanger.u, Q_flow_internal);
  connect(heatDemand.Q_flow, signChanger.y);
  connect(normalizer.u, Q_flow_internal);
  connect(heatDemand.port, heatExchanger.heat) annotation (Line(
      points={{20,1.33227e-015},{18,1.33227e-015},{18,-8.88178e-016},{14,-8.88178e-016}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(normalizer.y, controlValve.opening_in) annotation (Line(
      points={{14.9,-58},{9,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(controlValve.inlet, fluidPortIn) annotation (Line(
      points={{0,-68},{0,-100}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(controlValve.outlet, heatExchanger.inlet) annotation (Line(
      points={{0,-48},{0,-16},{-3.10862e-015,-16}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(heatExchanger.outlet, fluidPortOut) annotation (Line(
      points={{2.88658e-015,16},{2.88658e-015,58},{0,58},{0,100}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics,
                                               coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Boundary with L2 Heat exchanger from ClaRa</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>L2 (defined in the CodingConventions)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>TransiEnt.Base.Interfaces.Thermal.FluidPortIn (x2)</p>
<p>RealInput (for specification of boundary power)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Arne Koeppen / Lisa Andresen (andresen@tuhh.de), Jul 2013</p>
<p>Refactoring after new boundary / consumer concept by Pascal Dubucq (dubucq@tuhh.de) on Mon Aug 18 2014</p>
</html>"));
end Heatflow_L2;
