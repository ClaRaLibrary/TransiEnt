within TransiEnt.Basics.Functions.GasProperties;
function shortenCompName "shortens the component names in TILMedia Records"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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
  import x = Modelica.Utilities.Strings;

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

//  input Integer nc "number of components";
  input String[:] nameLong "component names with database identifier (dot-notation used in TILMedia records)";
  output String[size(nameLong,1)] nameShort "component names without database identifier";

algorithm
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  //shorten components name from eg Refprop.Methane to Methane
  //find "." in name as letter i, letters i+1 - end is the shortened component name
  //find spaces and replace them with underscores

  nameShort[1]:=x.replace(x.substring(
    nameLong[1],
    x.find(nameLong[1],".")+1,
    x.find(nameLong[1],"(")-1), " ", "_");

  for i in 2:size(nameLong,1) loop
    nameShort[i]:= x.replace(x.substring(
    nameLong[i],
    x.find(nameLong[i],".")+1,
    x.length(nameLong[i])), " ", "_");
  end for;

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This function is used to remove the database identifier in front of the components name in TILMedia gastype records in order to standardize the components for further usage in combustion models.</p>
<p><img src=\"modelica://TransiEnt/Images/shortenCompName.png\"/></p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>No physical effects considered. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks), just input and output vectors </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>No governing equations, a for-loop is used to iterate through the vector of component names. </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>Problems could occur, if there are more then one dot in the component name.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>For validation see the partial models.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Jan Braune (jan.braune@tu-harburg.de), Mar 2015</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Dec 2015</p>
</html>"));
end shortenCompName;
