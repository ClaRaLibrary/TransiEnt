within TransiEnt.SystemGeneration.Superstructure.Components.GasGrid;
model GasGrid_JunctionWithConstantPressureSource "Model of a gas grid with a constant pressure indefinite gas source connected to a mixing volume with a pipeline"

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

  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Integer nRegions=4 " Number of regions";
  parameter Boolean useOneGasPortOnly=true "use 1 or 6 gas ports per superstructure boundary";
  final parameter Integer n_gasPort=if useOneGasPortOnly then 1 else 6 annotation (Dialog(group="GasGrid"));

  parameter SI.Temperature T_const=simCenter.T_ground "Constant temperature of source";
  parameter SI.AbsolutePressure p_const=simCenter.p_amb_const + simCenter.p_eff_2 "Constant absolute pressure";
  parameter SI.MassFraction xi_const[medium.nc - 1]=medium.xi_default "Constant composition";
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium to be used";

  parameter ClaRa.Basics.Units.Volume volume=14005 "Volume of the junction";
  parameter SI.MassFlowRate m_flow_nom=11288 "Nominal mass flow rate at each junction outlet";
  parameter SI.PressureDifference Delta_p_nom=1e4 "Nominal pressure loss at m_flow_nom at junction outler";

  parameter ClaRa.Basics.Units.Length length_pipe=1000 "Length of the pipeline (one pass)";
  parameter ClaRa.Basics.Units.Length diameter_i_pipe=0.05 "Inner diameter of the pipeline";
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom_pipe=11288 "Nominal mass flow of pipeline";
  parameter ClaRa.Basics.Units.PressureDifference Delta_p_nom_pipe=4e5 "Nominal pressure of pipeline at m_flow_nom_pipe";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

   TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortOut[nRegions,n_gasPort](each Medium=simCenter.gasModel1) annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2_nPorts junction_1(
    medium=medium,
    n_ports=nRegions + 1,
    volume=volume,
    m_flow_nom=ones(junction_1.n_ports)*m_flow_nom,
    Delta_p_nom=ones(junction_1.n_ports)*Delta_p_nom) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-12,0})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple pipe_1(
    medium=medium,
    frictionAtInlet=true,
    frictionAtOutlet=true,
    length=length_pipe,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    N_cv=1,
    m_flow_nom=m_flow_nom_pipe,
    Delta_p_nom=Delta_p_nom_pipe,
    diameter_i=diameter_i_pipe) annotation (Placement(transformation(
        extent={{-20,-10},{20,10}},
        rotation=180,
        origin={-2,-20})));

  Modelica.Blocks.Math.Gain gain_negative_1(k=-1) annotation (Placement(transformation(extent={{-52,-22},{-46,-16}})));
  Modelica.Blocks.Sources.RealExpression NoZeroMassFlow_1(y=-0.1) annotation (Placement(transformation(extent={{-82,-40},{-62,-20}})));

  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow2_1(
    medium=medium,
    T_const=T_const,
    xi_const=xi_const,
    m_flow_const=0,
    variable_m_flow=true) annotation (Placement(transformation(extent={{48,-22},{44,-18}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow1_1(
    medium=medium,
    T_const=T_const,
    xi_const=xi_const,
    m_flow_const=0,
    variable_m_flow=true) annotation (Placement(transformation(extent={{-40,-22},{-36,-18}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_gas_1(
    medium=medium,
    p_const=p_const,
    T_const=T_const,
    xi_const=xi_const) annotation (Placement(transformation(extent={{2,-6},{14,6}})));

equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  for i in 1:nRegions loop
    connect(junction_1.gasPort[i + 1], gasPortOut[i, 1]) annotation (Line(
        points={{-12,0},{-12,0},{-100,0}},
        color={255,255,0},
        thickness=1.5));
  end for;

  connect(pipe_1.gasPortIn, boundary_gas_1.gasPort) annotation (Line(
      points={{18,-20},{42,-20},{42,0},{14,0}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe_1.gasPortOut, junction_1.gasPort[1]) annotation (Line(
      points={{-22,-20},{-26,-20},{-26,0},{-12,0}},
      color={255,255,0},
      thickness=1.5));
  connect(NoZeroMassFlow_1.y, boundary_Txim_flow2_1.m_flow) annotation (Line(points={{-61,-30},{-38,-30},{-38,-44},{54,-44},{54,-18.8},{48.4,-18.8}}, color={0,0,127}));
  connect(gain_negative_1.u, NoZeroMassFlow_1.y) annotation (Line(points={{-52.6,-19},{-48,-19},{-48,-30},{-61,-30}}, color={0,0,127}));
  connect(gain_negative_1.y, boundary_Txim_flow1_1.m_flow) annotation (Line(points={{-45.7,-19},{-40.4,-18.8}}, color={0,0,127}));
  connect(boundary_Txim_flow1_1.gasPort, pipe_1.gasPortOut) annotation (Line(
      points={{-36,-20},{-22,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(boundary_Txim_flow2_1.gasPort, pipe_1.gasPortIn) annotation (Line(
      points={{44,-20},{44,-26},{24,-26},{24,-20},{18,-20}},
      color={255,255,0},
      thickness=1.5));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Ellipse(
                extent={{-80,40},{80,-40}},
                fillColor={255,255,0},
                fillPattern=FillPattern.Solid,
                lineColor={0,0,0},
                lineThickness=0.5)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model of a simple, idealized gas grid. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>All input ports connect into a common mixing volume &quot;junction&quot;. This volume has a connection to an indefinite constant pressure source through a <a href=\"TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple\">pipeline</a>.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>One gasPortOut[nRegions, n_gasPort]</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Jon Babst (babst@xrg-simulation.de), 06.09.2021</p>
</html>"));
end GasGrid_JunctionWithConstantPressureSource;
