within TransiEnt.Basics.Functions;
function findSetDifference "Creates a vector which only contains the elements of vector which do not exist in subset"
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Function;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  input Integer vector[:];
  input Integer subset[:] "Subset of vector";
  output Integer disjunction[size(vector,1)-size(subset,1)] "Disjunctive vector";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  Integer positionOfDisjunctiveElements[size(vector, 1)] "Vector which contains zeros of disjunctive elements";
  Integer idx;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

algorithm
  idx := 1;
  positionOfDisjunctiveElements := Modelica.Math.Vectors.find(vector, subset);
  for i in 1:size(vector, 1) loop
    if positionOfDisjunctiveElements[i] == 0 then
      disjunction[idx] := vector[i];
      idx := idx + 1;
    end if;
  end for;

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Creates&nbsp;a&nbsp;vector <span style=\"font-family: Courier New;\">disjunction</span>&nbsp;which&nbsp;only&nbsp;contains&nbsp;the&nbsp;elements&nbsp;of&nbsp;<span style=\"font-family: Courier New;\">vector</span>&nbsp;which&nbsp;do&nbsp;not&nbsp;exist&nbsp;in&nbsp;<span style=\"font-family: Courier New;\">subset</span>.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), May 2020</p>
</html>"));
end findSetDifference;
