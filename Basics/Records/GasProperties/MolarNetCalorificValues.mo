within TransiEnt.Basics.Records.GasProperties;
record MolarNetCalorificValues "Record containing the net calorific values for different molecules in J per mol for 25 °C"

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

  extends TransiEnt.Basics.Icons.Record;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  parameter String[:] components =  {"Water", "Carbon_Monoxide", "CO",     "Hydrogen",   "H2",     "Nitrogen",   "N2",   "Carbon_Dioxide",   "CO2",   "Methane",  "CH4",  "Ethane",  "C2H6",  "Ethene", "C2H4",  "Propane", "C3H8",  "Propene",  "C3H6",   "Butane", "C4H10",  "Oxygen", "O2"};
  parameter Real[:]   compValues =  {0,        282.98,            282.98,   241.81,       241.81,   0,            0,      0,                  0,       802.60,     802.60, 1428.64,  1428.64,  1323.15,  1323.15, 2043.11,   2043.11, 1925.97,    1925.97,  2657.32,  2657.32, 0.0,      0.0}*1e3;

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This record contains a matrix, defining the molar net calorific values for different components of gases.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>No physical effects considered. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>The components vector contains the component names</p>
<p><img src=\"modelica://TransiEnt/Images/LHVparams1.png\"/>.</p>
<p>In the params vector the molar net calorific value for each component is defined in J/mol</p>
<p><img src=\"modelica://TransiEnt/Images/LHVparams2.png\"/>.</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>Be sure to store the molar net calorific value for each component in params in the same column in which the name is stored in the components vector.</p>
<p>In component names with two words, these are to be separated by an underscore. Don&apos;t use spaces, as in the shortenCompName functions spaces are replaced by underscores!</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>No validation needed.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>G. Cerbe, B. Lendt, K. Brüggemann, M. Dehli, F. Gröschl, K. Heikrodt, T. Kleiber, J. Kuck, J. Mischner, T. Schmidt, A. Seemann, and W. Thielen, Grundlagen der Gastechnik. Gasbeschaffung - Gasverteilung - Gasverwendung, 8th ed. München: Carl Hanser Verlag, 2017.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Jan Braune (jan.braune@tuhh.de), Mar 2015</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Apr 2015</p>
<p>Revised by Carsten Bode (c.bode@tuhh.de), Nov 2018</p>
</html>"));
end MolarNetCalorificValues;
