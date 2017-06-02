within TransiEnt.Basics.Records.GasProperties;
record NetCalorificValues "Record containing the net calorific values for different molecules in MJ per kg for 25 °C"

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  // Reference: DIN EN ISO 6976, „Erdgas - Berechnung von Brenn- und Heizwert, Dichte, relativer Dichte und Wobbeindex aus der Zusammensetzung“, Deutsches Institut für Normung DIN, Berlin, Sep-2005.

  extends TransiEnt.Basics.Icons.Record;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter String[:] components =  {"Water", "CARBON_MONOXIDE", "CO",     "HYDROGEN",   "H2",     "Nitrogen",   "N2",   "CARBON_DIOXIDE",   "CO2",   "Methane",  "CH4",  "Ethane",  "C2H6", "Propane", "C3H8",  "Butane", "C4H10", "Oxygen", "O2"};
  parameter Real[:]   compValues =  {0,       10.10,             10.10,    119.95,       119.95,   0.0,          0.0,    0.0,                0.0,     50.029,     50.029, 47.51,     47.51,  46.33,     46.33,   45.72,    45.72,   0.0,      0.0};

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This record contains a matrix, defining the mass weighted net calorific values for different gases.</p>
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
<p>In the params vector the mass weighted net calorific value for each component is defined in MJ/kg at 25 &deg;C</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>Be sure to store the mass weighted net calorific value for each component in params in the same column in which the name is stored in the components vector.</p>
<p>In component names with two words, these are to be separated by an underscore. Don&apos;t use spaces, as in the shortenCompName functions spaces are replaced by underscores!</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>No validation needed.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Lisa Andresen (andresen@tuhh.de), Nov 2016</p>
</html>"));
end NetCalorificValues;
