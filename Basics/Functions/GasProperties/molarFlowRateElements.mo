within TransiEnt.Basics.Functions.GasProperties;
function molarFlowRateElements "calculates molar flow rate of elements from TILMedia Definition"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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
  import Modelica.Utilities.Strings;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TransiEnt.Basics.Records.GasProperties.StoichiometricCoefficientsCombustion RCstoichiometry;
  parameter Integer ne= size(RCstoichiometry.stoich,2) "number of elements to take into account(see Record stoichiometry)";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

//  input Integer nc "number of fuel components";
  input String[:] components "shortened fuel component names";
  input Real[size(components,1)] n_dot_i "molar flowrate of fuel components";
  output Real[5] n_dot "molar flowrate of elements in fuelport";

algorithm
  for i in 1:size(components,1) loop
    for j in 1:size(RCstoichiometry.names, 1) loop
      if Strings.isEqual(RCstoichiometry.names[j],components[i], caseSensitive = false) then
        for k in 1:ne loop
          n_dot[k]:=n_dot[k]+n_dot_i[i]*RCstoichiometry.stoich[j,k];
        end for;
      end if;
    end for;
  end for;
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This function is used to convert a molar flow rate of fuel components into a molar flowrate of the elements the components consist of.</p>
<p><img src=\"modelica://TransiEnt/Images/molarFlowRateElements.png\"/></p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>No physical effects considered. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks), just input and output vectors </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>No governing equations, a for-loop is used to iterate through the vector of component names. The stoichiometric coefficients concerning the elementary composition of each component, served in a special record, are then multiplied by the molar flowrate of the component.</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>If there are components in your fuelgas which don&apos;t have a corresponding entry in the stoichiometric coefficients record, they will just be ignored, giving a faulty elements flowrate.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>For validation see the partial models.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Jan Braune (jan.braune@tu-harburg.de), Mar 2015</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Dec 2015</p>
</html>"));
end molarFlowRateElements;
