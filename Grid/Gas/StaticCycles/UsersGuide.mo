within TransiEnt.Grid.Gas.StaticCycles;
model UsersGuide "User's Guide"
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
extends Modelica.Icons.Information;

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of package</span></h4>
<p>This package contains components to model a static gas cycle to get initial and nominal values for the states. The idea is taken from the ClaRa library (ClaRa.StaticCycles) and adapted and expanded to the needs in a gas grid with variable composition of the gas mixture.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Purely parameter calculations, no derivatives, no states. The fixed attribute of the parameters are set to false to allow the calculation of the unknown parameters inside the models. The equations are put into the inital equation section so that all unknown parameters are calculated before the simulation starts and can thus be used by the dynamic models for initial and/or nominal values.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Use these components only for static calculations (inital and nominal values) as no transient effects are considered.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>The interfaces have to different color to mark which parameters are known (and unknown). For example for the Blue Input the value of p is known in the component and provided FOR neighbor component, values of m_flow, h and xi are unknown and provided BY the neighbor component (Blue Output).</p>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"1\" width=\"100%\"><tr>
<td><h4>Interface</h4></td>
<td><h4>Knowns</h4></td>
</tr>
<tr>
<td><p>Blue Input</p></td>
<td><p>p</p></td>
</tr>
<tr>
<td><p>Blue Output</p></td>
<td><p>m_flow, h, xi</p></td>
</tr>
<tr>
<td><p>Green Input</p></td>
<td><p>none</p></td>
</tr>
<tr>
<td><p>Green Output</p></td>
<td><p>p, m_flow, h, xi</p></td>
</tr>
<tr>
<td><p>Red Input</p></td>
<td><p>p, m_flow</p></td>
</tr>
<tr>
<td><p>Red Output</p></td>
<td><p>h, xi</p></td>
</tr>
<tr>
<td><p>Yellow Input</p></td>
<td><p>m_flow</p></td>
</tr>
<tr>
<td><p>Yellow Output</p></td>
<td><p>p, h, xi</p></td>
</tr>
</table>
<h4><span style=\"color: #008000\">5. Remarks for Usage</span></h4>
<p>Connect only interfaces with the same color, inputs with outputs.</p>
</html>"));
end UsersGuide;
