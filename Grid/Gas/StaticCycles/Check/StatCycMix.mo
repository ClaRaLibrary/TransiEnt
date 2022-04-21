within TransiEnt.Grid.Gas.StaticCycles.Check;
model StatCycMix



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





  import TransiEnt;
  extends TransiEnt.Basics.Icons.ModelStaticCycle;
  outer TransiEnt.SimCenter simCenter;
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid mediumNG = simCenter.gasModel1 "NG medium model";
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid mediumH2 = simCenter.gasModel3 "H2 medium model";
  parameter Boolean quadraticPressureLoss=false "Nominal point pressure loss; set to true for quadratic coefficient";

  parameter SI.Pressure p_source=simCenter.p_eff_2+simCenter.p_amb_const "|Sources|Absolute Pressure in source";
  parameter SI.Temperature T_source=simCenter.T_ground "|Sources|Temperature in source";
  parameter SI.MassFraction xi_source[mediumNG.nc-1]=mediumNG.xi_default "|Sources|Mass specific composition";
  parameter SI.MassFlowRate m_flow_H2=50 "|Sources|Mass flow in H2 source";
  parameter SI.Temperature T_H2=simCenter.T_ground "|Sources|Temperature in H2 source";
  parameter SI.MassFlowRate m_flow_sink=141 "|Sinks|Mass flow in sink 1";
  parameter SI.PressureDifference Delta_p_nom_pipe1=0.8e5 "|Pipes|Nominal pressure drop in pipe 1";
  parameter SI.PressureDifference Delta_p_nom_pipe2=1.2e5 "|Pipes|Nominal pressure drop in pipe 2";
  parameter SI.PressureDifference Delta_p_nom_pipeH2=0.01e5 "|Pipes|Nominal pressure drop in pipe H2";
  parameter SI.MassFlowRate m_flow_nom_pipe1=141 "|Pipes|Nominal mass flow rate in pipe 1";
  parameter SI.MassFlowRate m_flow_nom_pipe2=141 "|Pipes|Nominal mass flow rate in pipe 2";
  parameter SI.MassFlowRate m_flow_nom_pipeH2=5 "|Pipes|Nominal mass flow rate in pipe H2";

  TransiEnt.Grid.Gas.StaticCycles.Source_yellow_T source(
    p=p_source,
    xi=xi_source,
    medium=mediumNG,
    T=T_source) annotation (Placement(transformation(extent={{-98,24},{-62,56}})));
  TransiEnt.Grid.Gas.StaticCycles.Sink_yellow sink(medium=mediumNG, m_flow=m_flow_sink) annotation (Placement(transformation(extent={{54,20},{98,60}})));
  TransiEnt.Grid.Gas.StaticCycles.Source_blue source_H2(
    m_flow=m_flow_H2,
    medium=mediumH2,
    T=T_H2) annotation (Placement(transformation(
        extent={{23,-22},{-23,22}},
        rotation=270,
        origin={0,-72})));
  TransiEnt.Grid.Gas.StaticCycles.Mixer2 mix(medium=mediumNG) annotation (Placement(transformation(
        extent={{-12,-8},{12,8}},
        rotation=0,
        origin={0,35})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow pipe1(
    Delta_p_nom=Delta_p_nom_pipe1,
    medium=mediumNG,
    m_flow_nom=m_flow_nom_pipe1,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(extent={{-48,36},{-28,44}})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow pipe2(
    medium=mediumNG,
    Delta_p_nom=Delta_p_nom_pipe2,
    m_flow_nom=m_flow_nom_pipe2,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(extent={{28,36},{48,44}})));
  TransiEnt.Grid.Gas.StaticCycles.Adapter_H2toNG adapter_H2toNG(
    mediumIn=mediumH2,
    mediumOut=mediumNG) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,8})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_blue pipeH2(
    medium=mediumH2,
    Delta_p_nom=Delta_p_nom_pipeH2,
    m_flow_nom=m_flow_nom_pipeH2) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=90,
        origin={0,-30})));
equation
  connect(source.outlet, pipe1.inlet) annotation (Line(points={{-67.58,40},{-67.58,40},{-46.3,40}},
                                                                                                 color={0,131,169}));
  connect(pipe2.outlet, sink.inlet) annotation (Line(points={{48.2,40},{48.2,40},{64.12,40}},                    color={0,131,169}));
  connect(pipe1.outlet, mix.inlet1) annotation (Line(points={{-27.8,40},{-11.04,40},{-11.04,40.3333}},color={0,0,0}));
  connect(mix.outlet, pipe2.inlet) annotation (Line(points={{12.96,40.3333},{21.48,40.3333},{21.48,40},{29.7,40}}, color={0,0,0}));
  connect(mix.inlet2, adapter_H2toNG.outlet) annotation (Line(points={{0,28.0667},{0,28.0667},{0,19},{6.66134e-16,19}},      color={0,0,0}));
  connect(adapter_H2toNG.inlet, pipeH2.outlet) annotation (Line(points={{-5.55112e-016,-0.5},{0,-0.5},{0,-19.8},{-0.1,-19.8}}, color={0,0,0}));
  connect(source_H2.outlet, pipeH2.inlet) annotation (Line(points={{3.10862e-015,-56.82},{0,-56.82},{0,-38.3},{-0.1,-38.3}}, color={0,0,0}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for static cycle mixer.</p>
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
<p>Created by Tom Lindemann (tom.lindemann@tuhh.de), Mar 2016</p>
<p>Edited by Lisa Andresen (andresen@tuhh.de), Jun 2016</p>
</html>"));
end StatCycMix;
