within TransiEnt.Examples.Gas;
model InitGasGrid_PtG


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

  extends TransiEnt.Basics.Icons.ModelStaticCycle;



  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium natural gas mixture";
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid mediumH2=simCenter.gasModel3 "Medium hydrogen";

  parameter Boolean quadraticPressureLoss=false "|Pipes|Nominal point pressure loss, set to true for quadratic coefficient";
  parameter Modelica.Units.SI.Pressure pipe1_Delta_p_nom "|Pipes|Nominal pressure loss";
  parameter Modelica.Units.SI.Pressure pipe2_Delta_p_nom "|Pipes|Nominal pressure loss";
  parameter Modelica.Units.SI.Pressure pipe3_Delta_p_nom "|Pipes|Nominal pressure loss";
  parameter Modelica.Units.SI.Pressure pipe4_Delta_p_nom "|Pipes|Nominal pressure loss";

  parameter Modelica.Units.SI.MassFlowRate pipe1_m_flow_nom "|Pipes|Nominal mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate pipe2_m_flow_nom "|Pipes|Nominal mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate pipe3_m_flow_nom "|Pipes|Nominal mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate pipe4_m_flow_nom "|Pipes|Nominal mass flow rate";

  parameter Modelica.Units.SI.MassFlowRate sink1_m_flow "|Sinks|Mass flow rate at source";
  parameter Modelica.Units.SI.MassFlowRate sink2_m_flow "|Sinks|Mass flow rate at source";

  parameter Modelica.Units.SI.Pressure source1_p=simCenter.p_eff_2 + simCenter.p_amb_const "|Sources|Pressure at the source";
  parameter Modelica.Units.SI.Temperature source1_T=simCenter.T_ground "|Sources|Temperature at the source";
  parameter Modelica.Units.SI.MassFraction source1_xi[medium.nc - 1]=source1.medium.xi_default "|Sources|Mass specific composition at the source";
  parameter Modelica.Units.SI.Pressure source2_p=simCenter.p_eff_2 + simCenter.p_amb_const "|Sources|Pressure at the source";
  parameter Modelica.Units.SI.Temperature source2_T=simCenter.T_ground "|Sources|Temperature at the source";
  parameter Modelica.Units.SI.MassFraction source2_xi[medium.nc - 1]=source2.medium.xi_default "|Sources|Mass specific composition at the source";

  parameter Modelica.Units.SI.MassFlowRate feedIn1_m_flow "|Feed-in|Mass flow rate at source";
  parameter Modelica.Units.SI.MassFraction feedIn1_xi[mediumH2.nc - 1]=zeros(feedIn1.medium.nc - 1) "|Feed-in|Mass specific composition at source";
  parameter Modelica.Units.SI.Temperature feedIn1_T=simCenter.T_ground "|Feed-in|Temperature at source";

  parameter Modelica.Units.SI.MassFlowRate feedIn2_m_flow "|Feed-in|Mass flow rate at source";
  parameter Modelica.Units.SI.MassFraction feedin2_xi[mediumH2.nc - 1]=zeros(feedIn2.medium.nc - 1) "|Feed-in|Mass specific composition at source";
  parameter Modelica.Units.SI.Temperature feedIn2_T=simCenter.T_ground "|Feed-in|Temperature at source";


  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;


  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Grid.Gas.StaticCycles.Source_yellow_T source1(
    medium=medium,
    p=source1_p,
    T=source1_T,
    xi=source1_xi) annotation (Placement(transformation(extent={{-104,-70},{-84,-50}})));
  TransiEnt.Grid.Gas.StaticCycles.Source_yellow_T source2(
    medium=medium,
    p=source2_p,
    T=source2_T,
    xi=source2_xi) annotation (Placement(transformation(extent={{104,50},{84,70}})));
  TransiEnt.Grid.Gas.StaticCycles.Sink_yellow sink1(m_flow=sink1_m_flow, medium=medium) annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  TransiEnt.Grid.Gas.StaticCycles.Sink_yellow sink2(m_flow=sink2_m_flow, medium=medium) annotation (Placement(transformation(extent={{20,-20},{0,0}})));
  TransiEnt.Grid.Gas.StaticCycles.Split junction3(medium=medium) annotation (Placement(transformation(extent={{30,52},{50,62}})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow pipe2(
    medium=medium,
    Delta_p_nom=pipe2_Delta_p_nom,
    m_flow_nom=pipe2_m_flow_nom,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(extent={{10,54},{-10,66}})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow pipe4(
    medium=medium,
    Delta_p_nom=pipe4_Delta_p_nom,
    m_flow_nom=pipe4_m_flow_nom,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(
        extent={{10,-6},{-10,6}},
        rotation=180,
        origin={0,-60})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow pipe3(
    medium=medium,
    Delta_p_nom=pipe3_Delta_p_nom,
    m_flow_nom=pipe3_m_flow_nom,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(
        extent={{10,-6},{-10,6}},
        rotation=90,
        origin={40,30})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow pipe1(
    medium=medium,
    Delta_p_nom=pipe1_Delta_p_nom,
    m_flow_nom=pipe1_m_flow_nom,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(
        extent={{10,-6},{-10,6}},
        rotation=270,
        origin={-40,-30})));
  TransiEnt.Grid.Gas.StaticCycles.Split junction1(medium=medium) annotation (Placement(transformation(
        extent={{-9.5,-6},{9.5,6}},
        rotation=180,
        origin={-39.5,-56})));
  TransiEnt.Grid.Gas.StaticCycles.Valve_cutFlow valve_cutFlow2(medium=medium) annotation (Placement(transformation(extent={{16,-64},{36,-54}})));
  TransiEnt.Grid.Gas.StaticCycles.Mixer1 junction4(medium=medium) annotation (Placement(transformation(
        extent={{9.5,5.5},{-9.5,-5.5}},
        rotation=90,
        origin={35.5,-9.5})));
  TransiEnt.Grid.Gas.StaticCycles.Mixer1 junction2(medium=medium) annotation (Placement(transformation(
        extent={{-9.5,-5.5},{9.5,5.5}},
        rotation=90,
        origin={-35.5,29.5})));
  TransiEnt.Grid.Gas.StaticCycles.Valve_cutFlow valve_cutFlow1(medium=medium) annotation (Placement(transformation(extent={{-16,56},{-36,66}})));
  TransiEnt.Grid.Gas.StaticCycles.Source_blue feedIn1(
    medium=mediumH2,
    m_flow=feedIn1_m_flow,
    xi=feedIn1_xi,
    T=feedIn1_T) annotation (Placement(transformation(extent={{-104,-104},{-84,-84}})));
  TransiEnt.Grid.Gas.StaticCycles.Mixer2 junction_feedIn1(medium=medium) annotation (Placement(transformation(extent={{-78,-68},{-58,-58}})));
  TransiEnt.Grid.Gas.StaticCycles.Source_blue feedIn2(
    medium=mediumH2,
    m_flow=feedIn2_m_flow,
    xi=feedin2_xi,
    T=feedIn2_T) annotation (Placement(transformation(extent={{100,80},{80,100}})));
  TransiEnt.Grid.Gas.StaticCycles.Mixer2 junction_feedIn2(medium=medium) annotation (Placement(transformation(extent={{80,68},{60,58}})));
  TransiEnt.Grid.Gas.StaticCycles.Adapter_H2toNG adapter_H2toNG_1(mediumIn=mediumH2, mediumOut=medium) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-68,-80})));
  TransiEnt.Grid.Gas.StaticCycles.Adapter_H2toNG adapter_H2toNG_2(mediumIn=mediumH2, mediumOut=medium) annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=270,
        origin={70,80})));


equation
  // _____________________________________________
  //
  //           Connect Statements
  // _____________________________________________


  connect(junction3.outlet1, pipe2.inlet) annotation (Line(points={{29.2,60.3333},{21.64,60.3333},{21.64,60},{8.3,60}}, color={0,0,0}));
  connect(junction3.outlet2, pipe3.inlet) annotation (Line(points={{40,51.3333},{40,38.3}}, color={0,0,0}));
  connect(pipe3.outlet, junction4.inlet1) annotation (Line(points={{40,19.8},{40,-0.76},{39.1667,-0.76}}, color={0,0,0}));
  connect(junction4.outlet, sink2.inlet) annotation (Line(points={{29.2667,-9.5},{22.6334,-9.5},{22.6334,-10},{15.4,-10}}, color={0,0,0}));
  connect(junction4.inlet2, valve_cutFlow2.outlet) annotation (Line(points={{39.1667,-18.24},{39.1667,-59.12},{36.8,-59.12},{36.8,-59}}, color={0,0,0}));
  connect(pipe4.outlet, valve_cutFlow2.inlet) annotation (Line(points={{10.2,-60},{16.8,-60},{16.8,-59.4}}, color={0,0,0}));
  connect(junction1.outlet1, pipe4.inlet) annotation (Line(points={{-29.24,-60},{-14,-60},{-8.3,-60}}, color={0,0,0}));
  connect(pipe1.inlet, junction1.outlet2) annotation (Line(points={{-40,-38.3},{-40,-38.3},{-40,-49.2},{-39.5,-49.2}}, color={0,0,0}));
  connect(junction2.outlet, sink1.inlet) annotation (Line(points={{-29.2667,29.5},{-21.6334,29.5},{-21.6334,30},{-15.4,30}}, color={0,0,0}));
  connect(junction2.inlet1, pipe1.outlet) annotation (Line(points={{-39.1667,20.76},{-39.1667,-0.62},{-40,-0.62},{-40,-19.8}}, color={0,0,0}));
  connect(valve_cutFlow1.inlet, pipe2.outlet) annotation (Line(points={{-16.8,60.6},{-13.4,60.6},{-13.4,60},{-10.2,60}}, color={0,0,0}));
  connect(valve_cutFlow1.outlet, junction2.inlet2) annotation (Line(points={{-36.8,61},{-39.1667,61},{-39.1667,38.24}}, color={0,0,0}));
  connect(source1.outlet, junction_feedIn1.inlet1) annotation (Line(points={{-87.1,-60},{-77.2,-60},{-77.2,-59.6667}}, color={0,0,0}));
  connect(junction_feedIn1.outlet, junction1.inlet) annotation (Line(points={{-57.2,-59.6667},{-53.6,-59.6667},{-53.6,-60},{-48.24,-60}}, color={0,0,0}));
  connect(junction3.inlet, junction_feedIn2.outlet) annotation (Line(points={{49.2,60.3333},{54.6,60.3333},{54.6,59.6667},{59.2,59.6667}}, color={0,0,0}));
  connect(junction_feedIn2.inlet1, source2.outlet) annotation (Line(points={{79.2,59.6667},{83.6,59.6667},{83.6,60},{87.1,60}}, color={0,0,0}));
  connect(adapter_H2toNG_1.outlet, junction_feedIn1.inlet2) annotation (Line(points={{-68,-73.4},{-68,-67.3333}}, color={0,0,0}));
  connect(feedIn1.outlet, adapter_H2toNG_1.inlet) annotation (Line(points={{-87.4,-94},{-68,-94},{-68,-85.1}}, color={0,0,0}));
  connect(feedIn2.outlet, adapter_H2toNG_2.inlet) annotation (Line(points={{83.4,90},{70,90},{70,85.1}}, color={0,0,0}));
  connect(adapter_H2toNG_2.outlet, junction_feedIn2.inlet2) annotation (Line(points={{70,73.4},{70,67.3333}}, color={0,0,0}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false, initialScale=0.1)),
             Diagram(graphics,
                     coordinateSystem(preserveAspectRatio=false, initialScale=0.1)),
Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Static cycle for small closed-loop gas grid. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Johannes Brunnemann (brunnemann@xrg-simulation.de), Jan 2017</p>
<p>Edited and revised by Lisa Andresen (andresen@tuhh.de), Apr 2017</p>
</html>"));
end InitGasGrid_PtG;
