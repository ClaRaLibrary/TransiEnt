within TransiEnt.Basics.Records.GasProperties;
record CompressionFactorsNTP "Record containing the compression factors Z of gas components for normal temperature and pressure"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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

  parameter String[:] names = {"Methane", "CH4",  "Ethane", "C2H6", "Propane", "C3H8", "Butane", "C4H10", "Nitrogen", "N2",   "Carbon_Dioxide", "CO2",  "Hydrogen", "H2",   "Oxygen", "O2",   "Water", "H2O",  "Carbon_Monoxide", "CO"};
  parameter Real[:] Z_n =     {0.9976,    0.9976, 0.9900,   0.9900, 0.9789,    0.9789, 0.9572,   0.9572,  0.9995,     0.9995, 0.9934,           0.9934, 1.0006,     1.0006, 0.9992,   0.9992, 1.0004,  1.0004, 0.9993,            0.9993};

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This record contains the compression factors at STP for some fuel gas components use in the TransiEnt library.</p>
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
<p>Values for N2, CO2, O2 and H2O were calculated using <img src=\"modelica://TransiEnt/Resources/Images/equations/equation-4MjwqlbL.png\" alt=\"Z=p/(rho*R*T)\"/>.</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<ul>
<li>Be sure to store the molar mass for each component in molarmasses vector in the same column in which the name is stored in the names vector.</li>
</ul>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>No validation needed.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>G. Cerbe, B. Lendt, K. Brüggemann, M. Dehli, F. Gröschl, K. Heikrodt, T. Kleiber, J. Kuck, J. Mischner, T. Schmidt, A. Seemann, and W. Thielen, <i>Grundlagen der Gastechnik. Gasbeschaffung - Gasverteilung - Gasverwendung</i>, 8th ed. München: Carl Hanser Verlag, 2017.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Jan Braune (jan.braune@tuhh.de), Mar 2015</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Apr 2015</p>
<p>Revised by Carsten Bode (c.bode@tuhh.de), Nov 2018</p>
</html>"));
end CompressionFactorsNTP;
