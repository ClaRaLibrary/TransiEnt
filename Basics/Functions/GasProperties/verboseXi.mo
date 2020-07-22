within TransiEnt.Basics.Functions.GasProperties;
function verboseXi "prints the component vector and its values to simulation log"

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
  import S = Modelica.Utilities.Streams;

  // _____________________________________________
  //
  //                Inputs/Outputs
  // _____________________________________________

  input String[:] Names "gas names vector [nc]";
  input Real[:] xi_in "mass fraction vector [nc-1]";

protected
  Real xi[size(Names, 1)] "mass fraction vector [nc], to be calculated in the algorithm section";

algorithm
  //
  for i in 1:size(xi_in, 1) loop
    xi[i] := xi_in[i];
  end for;
  xi[end] := 1 - sum(xi_in);

  S.print("VERBOSE MODE IS ACTIVE");
  S.print("NUMBER OF COMPONENTS: " + String(size(Names,1)) + ". YOU'VE SET THE FOLLOWING INITIAL GAS COMPOSITION:");

  //print component vector & values
  for i in 1:size(Names,1) loop
    S.print("[" + String(i) + "]" + " " + Names[i] + ": " + String(xi[i]));
  end for;

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This function is just for evaluation purposes. It writes the component names and the externally set mass fractions to the simulation log. This is helpful for a quick overview, as the massfraction in the external definition tables is set by a vector in which the order of components can&apos;t be seen directly.</p>
<p><br><img src=\"modelica://TransiEnt/Images/verboseXi.png\"/></p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>No physical effects considered. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks), just input vectors.</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>No governing equations.</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<ul>
<li>As it just writes the input vectors into the log with no further treatment, this function might be useful in other contexts, too.</li>
</ul>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Not validated yet.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Jan Braune (jan.braune@tu-harburg.de), Mar 2015</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Dec 2015</p>
</html>"));
end verboseXi;
