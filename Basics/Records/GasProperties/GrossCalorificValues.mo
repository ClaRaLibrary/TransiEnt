within TransiEnt.Basics.Records.GasProperties;
record GrossCalorificValues "Record containing the gross calorific values for different molecules in J per kg for 25 °C"

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

  parameter String[:] components =  {"Water", "Carbon_Monoxide", "CO",   "Hydrogen", "Hydrogen(eos=SRK,REF=STP)", "H2",    "Nitrogen", "Nitrogen(eos=SRK,REF=STP)", "N2", "Carbon_Dioxide", "Carbon_Dioxide(eos=SRK,REF=STP)", "CO2", "Methane", "Methane(eos=SRK,REF=STP)", "CH4",  "Ethane",  "Ethane(eos=SRK,REF=STP)", "C2H6", "Propane", "Propane(eos=SRK,REF=STP)", "C3H8",  "Butane", "Butane(eos=SRK,REF=STP)", "C4H10", "Oxygen", "O2"};
  parameter Real[:]   compValues =  {2.442,    10.103,           10.103, 141.788,    141.788,                     141.788, 0.0,        0.0,                         0.0,  0.0,              0.0,                               0.0,   55.515,    55.515,                     55.515, 51.900,    51.902,                    51.902, 50.325,    50.325,                     50.325,  49.505,   49.505,                    49.505,  0.0,      0.0}*1e6;

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This record contains a matrix, defining the mass weighted gross calorific values for different gases.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>No physical effects considered. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>The components vector contains the component names.</p>
<p>In the params vector the mass weighted gross calorific value for each component is defined in J/kg at 25 &deg;C</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>Be sure to store the mass weighted gross calorific value for each component in params in the same column in which the name is stored in the components vector.</p>
<p>In component names with two words, these are to be separated by an underscore. Don&apos;t use spaces, as in the shortenCompName functions spaces are replaced by underscores!</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>No validation needed.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>G. Cerbe, B. Lendt, K. Brüggemann, M. Dehli, F. Gröschl, K. Heikrodt, T. Kleiber, J. Kuck, J. Mischner, T. Schmidt, A. Seemann, and W. Thielen, Grundlagen der Gastechnik. Gasbeschaffung - Gasverteilung - Gasverwendung, 8th ed. München: Carl Hanser Verlag, 2017.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Lisa Andresen (andresen@tuhh.de), Nov 2016</p>
<p>Revised by Carsten Bode (c.bode@tuhh.de), Nov 2018</p>
</html>"));
end GrossCalorificValues;
