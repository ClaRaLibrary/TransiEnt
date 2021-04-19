within TransiEnt.Basics.Functions.GasProperties;
function getMolarMasses_fromRecord "gets molar masses from record"

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

  parameter TransiEnt.Basics.Records.GasProperties.MolarMasses molarmasses;

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  //input Integer nc "number of fuel components";
  input String[:] components_in "shortened fuel component names";
  output Real[size(components_in,1)] M "molar mass of components in input vector";

protected
  String[:] components=Basics.Functions.GasProperties.shortenCompName(components_in);

algorithm
  for i in 1:size(components,1) loop
    for j in 1:size(molarmasses.names, 1) loop
      if Strings.isEqual(molarmasses.names[j],components[i], caseSensitive = false) then
          M[i] :=molarmasses.M[j];
      end if;
    end for;
  end for;
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This function supplies the molar masses of the components passed by the input vector. </p>
<p><img src=\"modelica://TransiEnt/Images/GetMolarMass.png\"/></p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>No physical effects considered. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks), just input and output vectors.</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>No governing equations. The function just searches the name vector in the molar masses record for the component names passed. Then it returns the molar mass defined in the molar mass vector in the record.</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<ul>
<li>To unify this function the input vector must contain shortened component names or chemical formulas for the components, e.g. &quot;Methane&quot;, or &quot;CH4&quot;</li>
<li>If there&apos;s no corresponding entry for the component in the molar masses record, the molar mass will be supplied as zero, which might cause troubles (e.g. division by zero)</li>
</ul>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>No validation needed. Tested in check model &quot;TransiEnt.Basics.Functions.GasProperties.Check.TestConvertMoleToMassFraction&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Jan Braune (jan.braune@tu-harburg.de), Mar 2015</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Dec 2015</p>
</html>"));
end getMolarMasses_fromRecord;
