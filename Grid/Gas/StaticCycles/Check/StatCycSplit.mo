within TransiEnt.Grid.Gas.StaticCycles.Check;
model StatCycSplit

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

   import TransiEnt;
   extends TransiEnt.Basics.Icons.ModelStaticCycle;
   outer TransiEnt.SimCenter simCenter;
   parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.gasModel1 "Medium in the component";

   parameter SI.Pressure p_source=simCenter.p_eff_2+simCenter.p_amb_const "|Sources|Absolute Pressure in source";
   parameter SI.SpecificEnthalpy h_source=785411 "|Sources|Specific enthalpy in source";
   parameter SI.MassFraction xi_source[medium.nc-1]=medium.xi_default "|Sources|Mass specific composition";
   parameter SI.MassFlowRate m_flow_sink1=141 "|Sinks|Mass flow in sink 1";
   parameter SI.MassFlowRate m_flow_sink2=50 "|Sinks|Mass flow in sink 2";
   parameter SI.PressureDifference Delta_p_nom_pipe1=0.8e5 "|Pipes|Nominal pressure drop in pipe 1";
   parameter SI.PressureDifference Delta_p_nom_pipe2=1.2e5 "|Pipes|Nominal pressure drop in pipe 2";
   parameter SI.PressureDifference Delta_p_nom_pipe3=1.6e5 "|Pipes|Nominal pressure drop in pipe 3";
  parameter SI.MassFlowRate m_flow_nom_pipe1=141 "|Pipes|Nominal mass flow rate in pipe 1";
  parameter SI.MassFlowRate m_flow_nom_pipe2=141 "|Pipes|Nominal mass flow rate in pipe 2";
  parameter SI.MassFlowRate m_flow_nom_pipe3=141 "|Pipes|Nominal mass flow rate in pipe 3";

  TransiEnt.Grid.Gas.StaticCycles.Source_yellow source(
    p=p_source,
    xi=xi_source,
    medium=medium,
    h=h_source) annotation (Placement(transformation(extent={{-98,-16},{-62,16}})));
  TransiEnt.Grid.Gas.StaticCycles.Sink_yellow sink1(m_flow=m_flow_sink1, medium=medium) annotation (Placement(transformation(extent={{54,-20},{98,20}})));
  TransiEnt.Grid.Gas.StaticCycles.Sink_yellow sink2(m_flow=m_flow_sink2, medium=medium) annotation (Placement(transformation(
        extent={{-23,-22},{23,22}},
        rotation=270,
        origin={0,-74})));
  TransiEnt.Grid.Gas.StaticCycles.Split split(medium=medium) annotation (Placement(transformation(
        extent={{12,-8},{-12,8}},
        rotation=0,
        origin={0,-5})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow pipe1(
    Delta_p_nom=Delta_p_nom_pipe1,
    medium=medium,
    m_flow_nom=m_flow_nom_pipe1) annotation (Placement(transformation(extent={{-48,-4},{-28,4}})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow pipe3(
    Delta_p_nom=Delta_p_nom_pipe3,
    medium=medium,
    m_flow_nom=m_flow_nom_pipe3) annotation (Placement(transformation(extent={{28,-4},{48,4}})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow pipe2(
    Delta_p_nom=Delta_p_nom_pipe2,
    medium=medium,
    m_flow_nom=m_flow_nom_pipe2) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=270,
        origin={0,-36})));
equation
  connect(source.outlet, pipe1.inlet) annotation (Line(points={{-67.58,0},{-67.58,0},{-46.3,0}}, color={0,131,169}));
  connect(pipe1.outlet, split.inlet) annotation (Line(points={{-27.8,0},{-11.04,0},{-11.04,0.333333}}, color={0,131,169}));
  connect(split.outlet1, pipe3.inlet) annotation (Line(points={{12.96,0.333333},{12.96,0},{29.7,0}}, color={0,131,169}));
  connect(pipe3.outlet, sink1.inlet) annotation (Line(points={{48.2,0},{48.2,4.44089e-016},{64.12,4.44089e-016}}, color={0,131,169}));
  connect(split.outlet2, pipe2.inlet) annotation (Line(points={{0,-14.0667},{0,-28},{1.33227e-15,-28},{1.33227e-15,-27.7}},   color={0,131,169}));
  connect(pipe2.outlet, sink2.inlet) annotation (Line(points={{-1.77636e-015,-46.2},{-1.77636e-015,-61.58},{2.66454e-015,-61.58}}, color={0,131,169}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for static cycle split.</p>
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
<p>Created by Lisa Andresen (andresen@tuhh.de), Jun 2016</p>
</html>"));
end StatCycSplit;
