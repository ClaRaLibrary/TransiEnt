within TransiEnt.Basics.Functions.GasProperties;
function convertMoleToMassFraction "Converts mole ratio/fraction to mass fraction"


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
  //                Inputs/Outputs
  // _____________________________________________
  input Real x[:] "vector of molar composition / mole fraction / mole ratio";
  input Real M[size(x, 1)+1] "vector of molar masses";
  output Real xi[size(x, 1)] "vector of mass fraction";
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________
algorithm
  assert(sum(x)<=1, "sum(x)>1 in convertMoleToMassFraction");

  xi:=x .* M./(sum(x .* M[1:size(x, 1)])+(1-sum(x))*M[size(M, 1)]);

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This function converts a given mole ratio or mole fraction to the mass fraction using the respective molar masses.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>No physical effects considered. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>This function is used best in combination with one of the &quot;getMolarMasses&quot;-functions.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Philipp Jahneke (philipp.koziol@tuhh.de), Jul 2018</p>
</html>"));
end convertMoleToMassFraction;
