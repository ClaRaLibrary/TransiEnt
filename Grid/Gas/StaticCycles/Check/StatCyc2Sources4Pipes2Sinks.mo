within TransiEnt.Grid.Gas.StaticCycles.Check;
model StatCyc2Sources4Pipes2Sinks



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
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.gasModel1 "Medium in the component";
  parameter Boolean quadraticPressureLoss=false "Nominal point pressure loss; set to true for quadratic coefficient";

  parameter SI.Pressure p_source1=simCenter.p_eff_2+simCenter.p_amb_const "|Sources|Absolute Pressure in source 1";
  parameter SI.Pressure p_source2=simCenter.p_eff_2+simCenter.p_amb_const "|Sources|Absolute Pressure in source 2";
  parameter SI.SpecificEnthalpy h_source1=785411 "|Sources|Specific enthalpy in source 1";
  parameter SI.SpecificEnthalpy h_source2=785411 "|Sources|Specific enthalpy in source 2";
  parameter SI.MassFraction xi_source1[medium.nc-1]=medium.xi_default "|Sources|Mass specific composition at source 1";
  parameter SI.MassFraction xi_source2[medium.nc-1]=medium.xi_default "|Sources|Mass specific composition at source 2";
  parameter SI.MassFlowRate m_flow_sink1=141 "|Sinks|Mass flow in sink 1";
  parameter SI.MassFlowRate m_flow_sink2=141 "|Sinks|Mass flow in sink 2";
  parameter SI.Pressure Delta_p_nom_pipe1=0.8e5 "|Pipes|Pressure loss in pipe 1";
  parameter SI.Pressure Delta_p_nom_pipe2=0.8e5 "|Pipes|Pressure loss in pipe 2";
  parameter SI.Pressure Delta_p_nom_pipe3=0.8e5 "|Pipes|Pressure loss in pipe 3";
  parameter SI.Pressure Delta_p_nom_pipe4=0.8e5 "|Pipes|Pressure loss in pipe 4";
  parameter SI.MassFlowRate m_flow_nom_pipe1=141 "|Pipes|Nominal mass flow rate in pipe 1";
  parameter SI.MassFlowRate m_flow_nom_pipe2=141 "|Pipes|Nominal mass flow rate in pipe 2";
  parameter SI.MassFlowRate m_flow_nom_pipe3=141 "|Pipes|Nominal mass flow rate in pipe 3";
  parameter SI.MassFlowRate m_flow_nom_pipe4=141 "|Pipes|Nominal mass flow rate in pipe 4";

  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow pipe2(
    Delta_p_nom=Delta_p_nom_pipe2,
    medium=medium,
    m_flow_nom=m_flow_nom_pipe2,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=180,
        origin={-20,50})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow pipe1(
    Delta_p_nom=Delta_p_nom_pipe1,
    medium=medium,
    m_flow_nom=m_flow_nom_pipe1,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=90,
        origin={-60,-20})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow pipe3(
    Delta_p_nom=Delta_p_nom_pipe3,
    medium=medium,
    m_flow_nom=m_flow_nom_pipe3,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=270,
        origin={60,22})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow pipe4(
    Delta_p_nom=Delta_p_nom_pipe4,
    medium=medium,
    m_flow_nom=m_flow_nom_pipe4,
    quadraticPressureLoss=quadraticPressureLoss) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=0,
        origin={24,-50})));
  TransiEnt.Grid.Gas.StaticCycles.Source_yellow source1(
    p=p_source1,
    medium=medium,
    h=h_source1,
    xi=xi_source1) annotation (Placement(transformation(extent={{-94,-90},{-62,-60}})));
  TransiEnt.Grid.Gas.StaticCycles.Source_yellow source2(
    p=p_source2,
    medium=medium,
    h=h_source2,
    xi=xi_source2) annotation (Placement(transformation(
        extent={{17,-16},{-17,16}},
        rotation=0,
        origin={79,72})));
  TransiEnt.Grid.Gas.StaticCycles.Sink_yellow sink1(m_flow=m_flow_sink1, medium=medium) annotation (Placement(transformation(extent={{-46,5},{-14,34}})));
  TransiEnt.Grid.Gas.StaticCycles.Sink_yellow sink2(m_flow=m_flow_sink2, medium=medium) annotation (Placement(transformation(
        extent={{-16,-16},{16,16}},
        rotation=180,
        origin={30,-20})));

  TransiEnt.Grid.Gas.StaticCycles.Split split1(medium=medium) annotation (Placement(transformation(
        extent={{9,-6},{-9,6}},
        rotation=90,
        origin={-56,-50})));
  TransiEnt.Grid.Gas.StaticCycles.Split split2(medium=medium) annotation (Placement(transformation(
        extent={{8,-5.5},{-8,5.5}},
        rotation=270,
        origin={56,50.5})));
  TransiEnt.Grid.Gas.StaticCycles.Mixer1 mix1(medium=medium) annotation (Placement(transformation(
        extent={{-9.5,-6},{9.5,6}},
        rotation=90,
        origin={-56,19.5})));
  TransiEnt.Grid.Gas.StaticCycles.Mixer1 mix2(medium=medium) annotation (Placement(transformation(
        extent={{-8,-6},{8,6}},
        rotation=270,
        origin={56,-20})));
  TransiEnt.Grid.Gas.StaticCycles.Valve_cutFlow valve_cutFlow(medium=medium) annotation (Placement(transformation(extent={{42,-54},{56,-46}})));
  TransiEnt.Grid.Gas.StaticCycles.Valve_cutFlow valve_cutFlow1(medium=medium) annotation (Placement(transformation(extent={{-38,46},{-52,54}})));
equation
  connect(source1.outlet, split1.inlet) annotation (Line(points={{-66.96,-75},{-60,-75},{-60,-58.28}},color={0,131,169}));
  connect(split2.outlet1, pipe3.inlet) annotation (Line(points={{59.6667,41.86},{59.6667,42},{60,42},{60,30.3}},
                                                                                            color={0,131,169}));
  connect(split2.outlet2, pipe2.inlet) annotation (Line(points={{49.7667,50.5},{12.7,50.5},{12.7,50},{-11.7,50}},
                                                                                            color={0,131,169}));
  connect(mix1.outlet, sink1.inlet) annotation (Line(points={{-49.2,19.5},{-38.64,19.5}}, color={0,131,169}));
  connect(pipe3.outlet,mix2. inlet1) annotation (Line(points={{60,11.8},{60,-12.64}},       color={0,131,169}));
  connect(mix2.outlet, sink2.inlet) annotation (Line(points={{49.2,-20},{49.2,-20},{38.64,-20}},         color={0,131,169}));
  connect(source2.outlet,split2. inlet) annotation (Line(points={{67.27,72},{67.27,72},{59.6667,72},{59.6667,57.86}},
                                                                                                              color={0,0,0}));
  connect(split1.outlet2, pipe4.inlet) annotation (Line(points={{-49.2,-50},{-49.2,-50},{15.7,-50}},
                                                                                          color={0,0,0}));
  connect(split1.outlet1, pipe1.inlet) annotation (Line(points={{-60,-40.28},{-60,-40.28},{-60,-28.3}},
                                                                                                     color={0,0,0}));
  connect(pipe1.outlet, mix1.inlet1) annotation (Line(points={{-60,-9.8},{-60,10.76}}, color={0,0,0}));
  connect(pipe4.outlet, valve_cutFlow.inlet) annotation (Line(points={{34.2,-50},{42,-50},{42,-50.32},{42.56,-50.32}}, color={0,0,0}));
  connect(valve_cutFlow.outlet, mix2.inlet2) annotation (Line(points={{56.56,-50},{60,-50},{60,-27.36}}, color={0,0,0}));
  connect(pipe2.outlet, valve_cutFlow1.inlet) annotation (Line(points={{-30.2,50},{-38.56,50},{-38.56,49.68}}, color={0,0,0}));
  connect(valve_cutFlow1.outlet, mix1.inlet2) annotation (Line(points={{-52.56,50},{-60,50},{-60,28.24}}, color={0,0,0}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester static cycle closed-loop gas grid.</p>
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
end StatCyc2Sources4Pipes2Sinks;
