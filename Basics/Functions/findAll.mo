within TransiEnt.Basics.Functions;
function findAll "Finds all occurences of e in a given vector v and returns the positions"

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




  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Function;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  input Real e "Search for e";
  input Real v[:] "Real vector";
  input Real eps(min=0) = 0
    "Element e is equal to a element v[i] of vector v if abs(e-v[i]) <= eps";
  output Integer result[:]
    "all occurrences of e; result=0, if not found";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  Integer i;
  Integer j;
  Integer result_internal[size(v,1)];

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

algorithm
  i := 1;
  j := 1;
  for i in 1:size(v, 1) loop
    if abs(v[i] - e) <= eps then
      result_internal[j] := i;
      j := j + 1;
    end if;
  end for;

  if j==1 then
    result:={0};
  else
    result:=result_internal[1:j - 1];
  end if;

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Finds all occurences of e in a given vector v and returns the positions. This is a modified version of Modelica.Math.Vectors.find.</p>
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
<p>Model created by Carsten Bode (c.bode@tuhh.de), Nov 2018</p>
</html>"));
end findAll;
