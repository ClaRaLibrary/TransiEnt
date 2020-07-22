within TransiEnt.Consumer.Gas;
model GasConsumerPipe_mFlow "Sink defining xi, h, m_flow with a pipe representing the distance to a consumer within this district"
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

  extends TransiEnt.Basics.Icons.GasSink;
  import SI = ClaRa.Basics.Units;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter SI.Length length=1000 "Average distance to a consumer within this district" annotation (Dialog(tab="Pipe Network", group="Parameters"));
  parameter SI.Length diameter=0.4 "Diameter" annotation (Dialog(tab="Pipe Network", group="Parameters"));
  parameter Integer N_tubes=1 "Number of parallel tubes" annotation (Dialog(tab="Pipe Network", group="Parameters"));
  parameter Integer N_cv=1 "Number of finite volumes" annotation (Dialog(tab="Pipe Network", group="Parameters"));
  parameter Boolean useIsothPipe=false "true: isothermal pipe model, false: adiabatic pipe model" annotation (Dialog(tab="Pipe Network", group="Parameters"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium to be used" annotation (Dialog(tab="General", group="General"));
  parameter SI.MassFraction xi_start[medium.nc - 1]=medium.xi_default "Composition of the medium for initialization (nc-1)" annotation (Dialog(tab="Pipe Network", group="Initialization"));
  parameter SI.MassFraction xi_nom[medium.nc - 1]=medium.xi_default "Nominal composition of the medium (nc-1)" annotation (Dialog(tab="Pipe Network", group="Nominal values"));
  parameter SI.MassFraction xi_const[medium.nc - 1]=medium.xi_default "Constant composition of medium (nc-1)" annotation (Dialog(tab="Sink", group="General"));
  //parameter Boolean change_of_sign=false "Change of sign of table data" annotation (Dialog(tab="Sink", group="Gas demand"));
  //parameter Real constantFactor=4.7 "Constant factor multiplied with table data" annotation (Dialog(tab="Sink", group="Gas demand"));
  //parameter SI.Time startTime=0 "StartTime of m_flow" annotation (Dialog(tab="Sink", group="Gas demand"));
  //parameter SI.EnthalpyMassSpecific h_const=1e6 "Constant enthalpy" annotation (Dialog(tab="Sink", group="General"));
  parameter SI.Temperature T_const=283.15 "Constant temperature" annotation (Dialog(tab="Sink", group="General"));
  //parameter SI.EnthalpyMassSpecific h_const=2274.9 "Constant specific enthalpy" annotation (Dialog(tab="Sink", group="General"));
  parameter SI.Pressure p_nom[N_cv]=ones(N_cv)*15e5 "Nominal absolute pressure" annotation (Dialog(tab="Pipe Network", group="Nominal values"));
  parameter SI.EnthalpyMassSpecific h_nom[N_cv]=ones(N_cv)*788440 "Nominal enthalpy" annotation (Dialog(tab="Pipe Network", group="Nominal values"));
  parameter SI.MassFlowRate m_flow_nom=140 "Nominal mass flow" annotation (Dialog(tab="Pipe Network", group="Nominal values"));
  parameter SI.PressureDifference Delta_p_nom=3e4 "Nominal pressure loss" annotation (Dialog(tab="Pipe Network", group="Nominal values"));
  parameter SI.Pressure p_start[N_cv]=ones(N_cv)*15e5 "Pressure" annotation (Dialog(tab="Pipe Network", group="Initialization"));
  parameter SI.EnthalpyMassSpecific h_start[N_cv]=ones(N_cv)*788440 "Enthalpy" annotation (Dialog(tab="Pipe Network", group="Initialization"));
  parameter SI.MassFlowRate m_flow_start[N_cv + 1]=ones(N_cv + 1)*140 "Mass flow rate" annotation (Dialog(tab="Pipe Network", group="Initialization"));
  parameter Integer massBalance=1 "Mass balance and species balance fomulation" annotation(Dialog(group="Fundamental Definitions"),choices(choice=1 "ClaRa formulation", choice=2 "TransiEnt formulation 1a", choice=3 "TransiEnt formulation 1b"));
  replaceable model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseVLE_L4 "Pressure loss model" annotation (Dialog(tab="General", group="Pipes"), choices(choicesAllMatching));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn fluidPortIn(Medium=medium) annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow "Mass flow rate input" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={110,0})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple pipe(
    medium=medium,
    length=length,
    diameter_i=diameter,
    p_nom=p_nom,
    h_nom=h_nom,
    m_flow_nom=m_flow_nom,
    Delta_p_nom=Delta_p_nom,
    h_start=h_start,
    p_start=p_start,
    xi_start=xi_start,
    m_flow_start=m_flow_start,
    N_tubes=N_tubes,
    xi_nom=xi_nom,
    N_cv=N_cv,
    frictionAtOutlet=false,
    frictionAtInlet=true,
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss) if not useIsothPipe
                                                 annotation (Placement(transformation(extent={{-82,-5},{-54,5}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sink(
    medium=simCenter.gasModel1,
    T_const=T_const,
    xi_const=xi_const,
    variable_m_flow=true,
    m(fixed=true)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={60,0})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor(compositionDefinedBy=2) annotation (Placement(transformation(extent={{-44,0},{-24,20}})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massflowSensor(xiNumber=massflowSensor.medium.nc) annotation (Placement(transformation(extent={{18,0},{38,20}})));
  TransiEnt.Components.Sensors.RealGas.WobbeGCVSensor vleGCVSensor annotation (Placement(transformation(extent={{-12,0},{8,20}})));

  Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_isoth pipe_isoth(
    medium=medium,
    length=length,
    diameter_i=diameter,
    p_nom=p_nom,
    h_nom=h_nom,
    m_flow_nom=m_flow_nom,
    Delta_p_nom=Delta_p_nom,
    h_start=h_start,
    p_start=p_start,
    xi_start=xi_start,
    m_flow_start=m_flow_start,
    N_tubes=N_tubes,
    xi_nom=xi_nom,
    N_cv=N_cv,
    frictionAtOutlet=false,
    frictionAtInlet=true,
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss) if useIsothPipe
                                                 annotation (Placement(transformation(extent={{-82,-21},{-54,-11}})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(sink.m_flow, m_flow) annotation (Line(points={{72,-6},{78,-6},{78,0},{110,0}}, color={0,0,127}));
  connect(fluidPortIn, pipe.gasPortIn) annotation (Line(
      points={{-100,0},{-91,0},{-82,0}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe.gasPortOut, vleCompositionSensor.gasPortIn) annotation (Line(
      points={{-54,0},{-49,0},{-44,0}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor.gasPortOut, vleGCVSensor.gasPortIn) annotation (Line(
      points={{-24,0},{-18,0},{-12,0}},
      color={255,255,0},
      thickness=1.5));
  connect(vleGCVSensor.gasPortOut, massflowSensor.gasPortIn) annotation (Line(
      points={{8,0},{13,0},{18,0}},
      color={255,255,0},
      thickness=1.5));
  connect(massflowSensor.gasPortOut, sink.gasPort) annotation (Line(
      points={{38,0},{44,0},{50,0}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe_isoth.gasPortOut, vleCompositionSensor.gasPortIn) annotation (Line(
      points={{-54,-16},{-50,-16},{-50,0},{-44,0}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe_isoth.gasPortIn, fluidPortIn) annotation (Line(
      points={{-82,-16},{-86,-16},{-86,0},{-100,0}},
      color={255,255,0},
      thickness=1.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),           Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Real gas consumer with one pipe.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Pipe can represent the average distance to a consumer.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">fluidPortIn - RealGas</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">m_flow - Gas mass flow in [kg/s]</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Tom Lindemann (tom.lindemann@tuhh.de) in Jun 2015</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Edited by Lisa Andresen (andresen@tuhh.de) in May 2016</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Edited by Carsten Bode(c.bode@tuhh.de) in May 2020 (added option to use isothermal pipe model)</span></p>
</html>"));
end GasConsumerPipe_mFlow;
