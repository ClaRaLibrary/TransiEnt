within TransiEnt.Grid.Gas.StaticCycles.Check;
model TestStatCycFlowReversal


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



  extends TransiEnt.Basics.Icons.Checkmodel;

  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  StatCycFlowReversal Init(Delta_p_nom_pipe=0.32e5*3, m_flow_sink=-100) annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple pipe(
    p_nom=ones(pipe.N_cv)*15.013e5,
    h_nom=ones(pipe.N_cv)*788440,
    m_flow_nom=100,
    Delta_p_nom=0.32e5,
    h_start=ones(pipe.N_cv)*Init.pipe.h_in,
    m_flow_start=ones(pipe.N_cv + 1)*Init.pipe.m_flow,
    xi_start=Init.pipe.xi_in,
    diameter_i=0.4,
    N_cv=3,
    length(displayUnit="km") = 3000,
    p_start=linspace(
        Init.pipe.p_in,
        Init.pipe.p_out,
        pipe.N_cv),
    frictionAtInlet=false,
    frictionAtOutlet=false) annotation (Placement(transformation(extent={{-14,-6},{14,4}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi source(
    h_const=Init.source.h,
    p_const=Init.p_source,
    xi_const=Init.xi_source) annotation (Placement(transformation(extent={{-80,-11},{-60,9}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_hxim_flow sink(
    variable_m_flow=true,
    h_const=Init.sink.h,
    xi_const=Init.sink.xi) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={48,-1})));
  Modelica.Blocks.Sources.Step step(
    startTime=100,
    height=200,
    offset=-100) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={82,-7})));
equation
  connect(pipe.gasPortOut, sink.gasPort) annotation (Line(
      points={{14,-1},{38,-1}},
      color={255,255,0},
      thickness=0.5));
  connect(pipe.gasPortIn, source.gasPort) annotation (Line(
      points={{-14,-1},{-42,-1},{-60,-1}},
      color={255,255,0},
      thickness=0.75));
  connect(sink.m_flow, step.y) annotation (Line(points={{60,-7},{66,-7},{71,-7}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
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
end TestStatCycFlowReversal;
