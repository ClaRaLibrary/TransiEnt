within TransiEnt.Basics.Records.GasProperties;
record PressureVirialCoefficients "Record containing the pressure virial coefficients B'0 and B'30 for 0 and 30 degC"

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



  //values in [10^-5 / kPa]
  //use the following formular for interpolation of the first pressure virial coefficient: B'(t) = B'0 + (B'30 - B'0)*t/30 (t in C)
  //calculate approximate compression factor from: Z(t,p) = 1 + B'(t)*p (p in kPa)
  //Source: DIN EN ISO 14912:2006 (D)

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Record;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  parameter String[:] names = {"Methane", "CH4", "Ethane", "C2H6", "Propane", "C3H8", "Butane", "C4H10", "Nitrogen", "N2", "carbon_dioxide", "CO2", "Hydrogen", "H2"};
  parameter Real[:] B0 = {-2.36, -2.36, -9.86, -9.86, -20.87, -20.87, -42.2, -42.2, -0.452, -0.452, -6.69, -6.69, 0.605, 0.605};
  parameter Real[:] B30 = {-1.63, -1.63, -7.16, -7.16, -14.79, -14.79, -28.9, -28.9, -0.151, -0.151, -4.75, -4.75, 0.574, 0.574};

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record containing the pressure virial coefficients B&apos;0 and B&apos;30 for 0 and 30 degC.</p>
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
<p>In the virial pressure coefficients vectors the coefficients are defined in 10^-5 / kPa</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>Be sure to store the molar mass for each component in virial pressure coefficients vector in the same column in which the name is stored in the names vector.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>No validation needed.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] DIN EN ISO 14912<span style=\"font-family: Courier New;\">, </span>&quot;Gasanalyse - Umrechnung von Zusammensetzungsangaben für Gasgemische&quot;, Deutsches Institut für Normung DIN, Berlin, 2006</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Lisa Andresen (andresen@tuhh.de), Apr 2016</p>
</html>"));
end PressureVirialCoefficients;
