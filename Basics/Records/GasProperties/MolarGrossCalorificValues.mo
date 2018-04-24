within TransiEnt.Basics.Records.GasProperties;
record MolarGrossCalorificValues "Record containing the gross calorific values for different molecules in kJ per mol for 25 °C"

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

  // Reference: DIN EN ISO 6976, „Erdgas - Berechnung von Brenn- und Heizwert, Dichte, relativer Dichte und Wobbeindex aus der Zusammensetzung“, Deutsches Institut für Normung DIN, Berlin, Sep-2005.

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Record;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  parameter String[:] components =  {"Water", "CARBON_MONOXIDE", "CO",     "HYDROGEN",   "H2",     "Nitrogen",   "N2",   "CARBON_DIOXIDE",   "CO2",   "Methane",  "CH4",  "Ethane",  "C2H6",  "ETHENE", "C2H4",  "Propane", "C3H8",  "PROPENE",  "C3H6",   "Butane", "C4H10"};
  parameter Real[:]   compValues =  {44.016,  282.98,            282.98,   285.83,       285.83,   0,            0,      0,                  0,       890.63,     890.63, 1560.69,   1560.69, 1411.18,  1411.18, 2219.17,   2219.17, 2058.02,    2058.02,  2877.40,  2877.40};

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This record contains a matrix, defining the molar gross calorific values for different components of gases.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>No physical effects considered. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>Components: Array containing fuel gas component names</p>
<p>Params: Array containing associated molar calorific values at standard volume and 25 &deg;C</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>Be sure to store the molar gross calorific value for each component in params in the same column in which the name is stored in the components vector.</p>
<p>In component names with two words, these are to be separated by an underscore. Don&apos;t use spaces, as in the shortenCompName functions spaces are replaced by underscores!</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>No validation needed.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Paul Kernstock (paul.kernstock@tuhh.de), Jun 2015</p>
<p>Revised and edited by Lisa Andresen (andresen@tuhh.de), Jul 2015</p>
</html>"));
end MolarGrossCalorificValues;
