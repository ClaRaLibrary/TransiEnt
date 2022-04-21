within TransiEnt.Basics.Functions;
function inverseXRegularized "Function that approximates 1/x by a twice continuously differentiable function"



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





  // Function is taken from the Buildings Library Version 2.10 (https://github.com/lbl-srg/modelica-buildings)

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends Icons.Function;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  input Real x "Abscissa value";
  input Real delta(min=0) "Abscissa value below which approximation occurs";
  output Real y "Function value";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  Real delta2 "Delta^2";
  Real x2_d2 "=x^2/delta^2";

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

algorithm
  if (abs(x) > delta) then
    y := 1/x;
  else
    delta2 :=delta*delta;
    x2_d2  := x*x/delta2;
    y      := x/delta2 + x*abs(x/delta2/delta*(2 - x2_d2*(3 - x2_d2)));
  end if;

  annotation (
    smoothOrder=1,Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Function is taken from the Buildings Library Version 2.10</span> (https://github.com/lbl-srg/modelica-buildings)</code></p>
<p>Function that approximates <i>y=1 &frasl; x</i> inside the interval <i>-&delta; &le; x &le; &delta;</i>. The approximation is twice continuously differentiable with a bounded derivative on the whole real line. </p>
<p>See the package <code>Examples</code> for the graph. </p>
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
<p>Added by Sascha Guddusch (guddusch@tuhh.de), May 2016</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Jun 2016</p><html>"),
smoothOrder=2, Inline=true);
end inverseXRegularized;
