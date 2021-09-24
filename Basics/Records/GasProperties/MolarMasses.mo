within TransiEnt.Basics.Records.GasProperties;
record MolarMasses "Record containing the molar masses for components of natural gas in kg/mol"

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

  extends TransiEnt.Basics.Icons.Record;
  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  parameter String[:]                 names = {"Methane", "CH4",    "Ethane", "C2H6",   "Propane", "C3H8",   "Butane",  "C4H10",   "Nitrogen", "N2",      "Carbon_Dioxide", "CO2",     "Hydrogen", "H2",      "Oxygen", "O2",     "Carbon_Monoxide", "CO",     "Water",   "H2O"};
  parameter Modelica.Units.SI.MolarMass[:] M={0.016043,0.016043,0.030070,0.030070,0.044097,0.044097,0.058123,0.058123,0.0280135,0.0280135,0.044010,0.044010,0.0020159,0.0020159,0.319988,0.319988,0.028010,0.028010,0.0180153,0.0180153};

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This record contains the molar masses for some fuel gas components use in the TransiEnt library.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>No physical effects considered. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>The names vector contains the component names</p>
<p><img src=\"modelica://TransiEnt/Images/MolarMasses_Names.png\"/>.</p>
<p>In the molarmasses vector the molar mass for each component is defined in <img src=\"modelica://TransiEnt/Images/equations/equation-FkpD3msT.png\" alt=\"kg/mol\"/></p>
<p><br><img src=\"modelica://TransiEnt/Images/MolarMasses_Values.png\"/>.</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>Be sure to store the molar mass for each component in molarmasses vector in the same column in which the name is stored in the names vector.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>No validation needed.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>G. Cerbe, B. Lendt, K. Brüggemann, M. Dehli, F. Gröschl, K. Heikrodt, T. Kleiber, J. Kuck, J. Mischner, T. Schmidt, A. Seemann, and W. Thielen, Grundlagen der Gastechnik. Gasbeschaffung - Gasverteilung - Gasverwendung, 8th ed. München: Carl Hanser Verlag, 2017.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Jan Braune (jan.braune@tuhh.de), Mar 2015</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Apr 2015</p>
<p>Revised by Carsten Bode (c.bode@tuhh.de), Nov 2018</p>
</html>"));
end MolarMasses;
