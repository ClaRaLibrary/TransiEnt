within TransiEnt.Grid.Gas.StaticCycles.Check;
model StatCycFlowReversal

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "|General|Medium to be used";

  parameter SI.Pressure p_source=simCenter.p_eff_2+simCenter.p_amb_const "|Sources|Absolute Pressure in source";
  parameter SI.Temperature T_source=simCenter.T_ground "|Sources|Temperature in source";
  parameter SI.MassFraction xi_source[medium.nc-1]=medium.xi_default "|Sources|Mass specific composition";
  parameter SI.MassFlowRate m_flow_sink=141 "|Sinks|Mass flow in sink";
  parameter SI.PressureDifference Delta_p_nom_pipe=0.8e5 "|Pipes|Nominal pressure drop in pipe";
  parameter SI.MassFlowRate m_flow_nom_pipe=141 "|Pipes|Nominal mass flow rate in pipe";

  TransiEnt.Grid.Gas.StaticCycles.Source_yellow_T source(
    p=p_source,
    xi=xi_source,
    T=T_source,
    medium=medium) annotation (Placement(transformation(extent={{-74,-18},{-32,18}})));
  TransiEnt.Grid.Gas.StaticCycles.Pipe_yellow pipe(
    Delta_p_nom=Delta_p_nom_pipe,
    m_flow_nom=m_flow_nom_pipe,
    medium=medium) annotation (Placement(transformation(extent={{-10,-4},{10,4}})));
  inner TransiEnt.SimCenter simCenter1(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1, p_eff_2=1400000) annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  TransiEnt.Grid.Gas.StaticCycles.Sink_yellow sink(m_flow=m_flow_sink, medium=medium) annotation (Placement(transformation(extent={{32,-18},{74,18}})));
equation
  connect(source.outlet, pipe.inlet) annotation (Line(points={{-38.51,0},{-38.51,0},{-8.3,0}},                   color={0,0,0}));
  connect(pipe.outlet, sink.inlet) annotation (Line(points={{10.2,0},{41.66,0},{41.66,3.33067e-016}}, color={0,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for static cycle.</p>
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
end StatCycFlowReversal;
