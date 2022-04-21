within TransiEnt.Grid.Gas;
model UsersGuide "User's Guide for Gas Grid Simulation"


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





  extends Modelica.Icons.Information;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4>Purpose of User&apos;s Guide</h4>
<p>This User&apos;s Guide should enable you to get a quick start at gas grid simulation or give you some advice on how to improve your models.</p>
<ol>
<li>Try to avoid big nonlinear systems of equations. This can be done by always using volumes and pressure losses in an alternating fashion. Two pressure losses or two volumes next to each other lead to a bigger nonlinear system of equations. Use <span style=\"font-family: Courier New;\">frictionAtInlet</span>/<span style=\"font-family: Courier New;\">frictionAtOutlet</span> in the pipe models and the pressure losses in the junction models to control this. Note that ignoring this rule can sometimes lead to a faster model since adding pressure losses often adds a state. Before and after boundaries, no pressure loss should be necessary for numerical reasons.</li>
<li><a href=\"TransiEnt.Grid.Gas.StaticCycles\">Static Cycles</a> can help the initialization but are often not necessary if you use the physical pressure loss model <a href=\"TransiEnt.Components.Gas.VolumesValvesFittings.Base.PhysicalPL_L4_constVisc\">PhysicalPL_L4_constVisc</a>. Also experiment with the different initOptions.</li>
<li>Use a discretization high enough to get adequate results but high discretization leads to long simulation times or even failing initialization.</li>
<li>Use isothermal pipe and junction models where possible. This leads to less states.</li>
<li>Use <span style=\"font-family: Courier New;\">constantComposition</span> if possible. If the composition is variable but only certain components vary independenty, e.g. in the case of mixing natural gas with hydrogen, use <span style=\"font-family: Courier New;\">variableCompositionEntries</span>.</li>
<li>Try different solvers, especially Esdirk23a, Esdirk34a, Esdirk45a, Sdirk34hw, Radau IIa. Also experiment with different tolerances.</li>
<li>Depending on the topology, using a sparse and/or a DAE solver can be faster.</li>
</ol>
<p>Examples for a well-built topology can be found <a href=\"TransiEnt.Grid.Gas.Check\">here</a>.</p>
<h4>Version History</h4>
<p>User&apos;s Guid created by Carsten Bode (c.bode@tuhh.de), May 2020</p>
</html>"));
end UsersGuide;
