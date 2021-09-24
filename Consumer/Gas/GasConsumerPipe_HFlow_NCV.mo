within TransiEnt.Consumer.Gas;
model GasConsumerPipe_HFlow_NCV "Gas sink dependent on net calorific value control with a pipe representing the distance to a consumer within this district"

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

  parameter SI.Length length=3 "Average distance to a consumer within this district" annotation (Dialog(tab="Pipe Network", group="Parameters"));
  parameter SI.Length diameter=0.4 "Diameter" annotation (Dialog(tab="Pipe Network", group="Parameters"));
  parameter Integer N_tubes=1 "Number of parallel tubes" annotation (Dialog(tab="Pipe Network", group="Parameters"));
  parameter Integer N_cv=1 "Number of finite Volumes" annotation (Dialog(tab="Pipe Network", group="Parameters"));
  parameter Boolean useIsothPipe=false "true: isothermal pipe model, false: adiabatic pipe model" annotation (Dialog(tab="Pipe Network", group="Parameters"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium to be used" annotation (Dialog(tab="General", group="General"));
  parameter SI.MassFraction xi_start[medium.nc - 1]=medium.xi_default "composition of the medium for initialization (nc-1)" annotation (Dialog(tab="Pipe Network", group="Initialization"));
  parameter SI.MassFraction xi_const[medium.nc - 1]=medium.xi_default "Constant composition of medium (nc-1)" annotation (Dialog(tab="Sink", group="General"));
  parameter SI.MassFraction xi_nom[medium.nc - 1]=medium.xi_default "Nominal composition of the medium (nc-1)" annotation (Dialog(tab="Pipe Network", group="Nominal values"));
  //parameter Boolean change_of_sign=false "change of sign of table data" annotation (Dialog(tab="Sink", group="Gas Demand"));
  //parameter Real constantFactor=4.7 "constant factor multiplied with table data" annotation (Dialog(tab="Sink", group="Gas Demand"));
  //parameter SI.Time startTime=0 "startTime of m_flow" annotation (Dialog(tab="Sink", group="Gas Demand"));
  //parameter SI.EnthalpyMassSpecific h_const=1e6 "constant enthalpy" annotation (Dialog(tab="Sink", group="General"));
  parameter SI.Temperature T_const=283.15 "constant Temperature" annotation (Dialog(tab="Sink", group="General"));
  //parameter SI.EnthalpyMassSpecific h_const=2274.9 "constant specific Enthalpy" annotation (Dialog(tab="Sink", group="General"));
  parameter SI.Pressure p_nom[N_cv]=ones(N_cv)*15e5 "Nominal absolute pressure" annotation (Dialog(tab="Pipe Network", group="Nominal values"));
  parameter SI.EnthalpyMassSpecific h_nom[N_cv]=ones(N_cv)*788440 "Nominal enthalpy" annotation (Dialog(tab="Pipe Network", group="Nominal values"));
  parameter SI.MassFlowRate m_flow_nom=140 "Nominal mass flow" annotation (Dialog(tab="Pipe Network", group="Nominal values"));
  parameter SI.PressureDifference Delta_p_nom=3e4 "Nominal pressure loss" annotation (Dialog(tab="Pipe Network", group="Nominal values"));
  parameter SI.Pressure p_start[N_cv]=ones(N_cv)*15e5 "Pressure" annotation (Dialog(tab="Pipe Network", group="Initialization"));
  parameter SI.EnthalpyMassSpecific h_start[N_cv]=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(medium,p_start,T_start,xi_start) "Enthalpy" annotation (Dialog(tab="Pipe Network", group="Initialization"));
  parameter SI.Temperature T_start[N_cv]=ones(N_cv)*simCenter.T_ground "Temperature" annotation (Dialog(tab="Pipe Network", group="Initialization"));
  parameter SI.MassFlowRate m_flow_start[N_cv + 1]=ones(N_cv + 1)*140 "Mass flow rate" annotation (Dialog(tab="Pipe Network", group="Initialization"));
  parameter Integer massBalance=1 "Mass balance and species balance fomulation" annotation(Dialog(group="Pipes"),choices(choice=1 "ClaRa formulation", choice=2 "TransiEnt formulation 1a", choice=3 "TransiEnt formulation 1b"));
  replaceable model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseVLE_L4 "Pressure loss model" annotation (Dialog(tab="General", group="Pipes"), choices(choicesAllMatching));

  parameter String mode="Consumer" annotation(Dialog(tab="General", group="Controller"),choices(choice = "Consumer" "Consumer", choice = "Producer" "Producer", choice = "Both" "Both", __Dymola_radioButtons=true));
  parameter Boolean usePIDcontroller=true "if 'true' m_flow_desired' is calculated by PID" annotation (Dialog(tab="General", group="Controller"));
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.P "Type of controller" annotation (Dialog(tab="General", group="Controller"));
  parameter Real k=1000 "Gain for controller in maximum feed in control" annotation (Dialog(tab="General", group="Controller"));
  parameter Real Ti=0.1 "Integrator time constant for controller in maximum feed in control" annotation (Dialog(tab="General", group="Controller"));
  parameter Real Td=0.1 "Derivative time constant for controller in maximum feed in control" annotation (Dialog(tab="General", group="Controller"));
  parameter Integer flowDefinition = if mode == "Consumer" then 3 elseif mode == "Producer" then 4 else 1 "Flow definition for sensors" annotation (Dialog(tab="General", group="General"),choices(choice = 1 "both", choice = 2 "both, noEvent", choice = 3 "in -> out", choice = 4 "out -> in"));
  parameter Boolean variable_H_flow=true "True, if enthalpy flow defined by variable input" annotation (Dialog(tab="General", group="General"));
  parameter SI.EnthalpyFlowRate H_flow_const=1e6 "Constant enthalpy flow rate" annotation (Dialog(tab="General", group="General",enable=not variable_H_flow));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn fluidPortIn(Medium=medium) annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.EnthalpyFlowRateIn H_flow if variable_H_flow "Input for enthalpy flow rate" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={110,0})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple pipe(
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
    useHomotopy=true,
    m_flow_start=m_flow_start,
    N_tubes=N_tubes,
    frictionAtInlet=true,
    N_cv=N_cv,
    massBalance=massBalance,
    frictionAtOutlet=false,
    redeclare model PressureLoss = PressureLoss) if not useIsothPipe annotation (Placement(transformation(extent={{-84,-5},{-56,5}})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massflowSensor(xiNumber=0,                        medium=medium) annotation (Placement(transformation(extent={{6,0},{26,20}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sink(
    medium=medium,
    T_const=T_const,
    xi_const=xi_const,
    variable_m_flow=true,
    m(fixed=true),
    p_nom=1500000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={44,0})));
  Control.NCVController nCVController(
    mode=mode,
    usePIDcontroller=usePIDcontroller,
    controllerType=controllerType,
    k=k,
    Ti=Ti,
    Td=Td) annotation (Placement(transformation(extent={{82,-16},{62,4}})));
public
  Components.Sensors.RealGas.NCVSensor                vleNCVSensor(medium=medium,flowDefinition=flowDefinition) annotation (Placement(transformation(extent={{-24,0},{-4,20}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor(compositionDefinedBy=2, medium=medium,flowDefinition=flowDefinition) annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
  Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple_isoth pipe_isoth(
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
    useHomotopy=true,
    m_flow_start=m_flow_start,
    N_tubes=N_tubes,
    frictionAtInlet=true,
    N_cv=N_cv,
    massBalance=massBalance,
    frictionAtOutlet=false,
    redeclare model PressureLoss = PressureLoss) if useIsothPipe annotation (Placement(transformation(extent={{-84,-21},{-56,-11}})));
  Modelica.Blocks.Sources.Constant H_flow_const_(k=H_flow_const) if not variable_H_flow;
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(fluidPortIn, pipe.gasPortIn) annotation (Line(
      points={{-100,0},{-92,0},{-84,0}},
      color={255,255,0},
      thickness=1.5));
  connect(nCVController.m_flow_desired, sink.m_flow) annotation (Line(points={{61,-6},{56,-6}}, color={0,0,127}));
  connect(massflowSensor.m_flow, nCVController.m_flow_is) annotation (Line(points={{27,10},{30,10},{30,32},{68,32},{68,4.6}}, color={0,0,127}));
  connect(pipe.gasPortOut, vleCompositionSensor.gasPortIn) annotation (Line(
      points={{-56,0},{-53,0},{-50,0}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor.gasPortOut, vleNCVSensor.gasPortIn) annotation (Line(
      points={{-30,0},{-27,0},{-24,0}},
      color={255,255,0},
      thickness=1.5));
  connect(vleNCVSensor.gasPortOut, massflowSensor.gasPortIn) annotation (Line(
      points={{-4,0},{1,0},{6,0}},
      color={255,255,0},
      thickness=1.5));
  connect(massflowSensor.gasPortOut, sink.gasPort) annotation (Line(
      points={{26,0},{30,0},{34,0}},
      color={255,255,0},
      thickness=1.5));
  connect(H_flow, nCVController.H_flow_set) annotation (Line(points={{110,0},{86,0},{86,-6},{83,-6}}, color={0,0,127}));
  connect(pipe_isoth.gasPortOut, vleCompositionSensor.gasPortIn) annotation (Line(
      points={{-56,-16},{-52,-16},{-52,0},{-50,0}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe_isoth.gasPortIn, fluidPortIn) annotation (Line(
      points={{-84,-16},{-88,-16},{-88,0},{-100,0}},
      color={255,255,0},
      thickness=1.5));
  connect(vleNCVSensor.NCV_InToOut, nCVController.NCV_is_sink) annotation (Line(points={{-3,14},{0,14},{0,44},{76,44},{76,4.6}}, color={0,0,127}));
  connect(vleNCVSensor.NCV_OutToIn, nCVController.NCV_is_source) annotation (Line(points={{-3,6},{2,6},{2,38},{72,38},{72,4.6}}, color={0,0,127}));
  connect(H_flow_const_.y,nCVController.H_flow_set);
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),           Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Real gas consumer with one pipe. Gas mass flow rate demand controlled by measured net calorific value.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Pipe can reprensent the average distance to a consumer.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Consideres pressure loss in the pipe network of the district.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">RealGas, RealInput for gas enthalpy flow rate in [W]</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Carsten Bode(c.bode@tuhh.de) in Nov 2020 (copied and adapted GasConsumerPipe_Hflow)</span></p>
</html>"));
end GasConsumerPipe_HFlow_NCV;
