within TransiEnt.Basics.Records.GasProperties;
record StoichiometricCoefficientsCombustion "Record containing the elementary composition of different molecules"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

  //to extend this:
  //add new components to the names-vektor [... , "component-name", "chemical formula"] (this is essential to cover different property sources)
  //define two vectors containing the elementary composition [C, H, O, N, S] as atoms (NOT MOLECULES) named sComponent-Name and sChemicalFormula
  //add those two vectors to the stoich-matrix { ... , sComponent-Name, sChemicalFormula}

  parameter String[:] names = {"Methane", "CH4", "Ethane", "C2H6", "Propane", "C3H8", "Butane", "C4H10", "Hydrogen", "H2", "Oxygen", "O2", "Nitrogen", "N2", "Nitrous_Oxide", "NO", "Nitrous_Dioxide", "NO2", "Carbon_Dioxide", "CO2", "Carbon_Monoxide", "CO", "Water", "H2O", "Sulfur_Dioxide", "SO2", "Ammonia", "NH3"};
  parameter Real[:,5] stoich = {sMethane, sCH4, sEthane, sC2H6, sPropane, sC3H8, sButane, sC4H10, sHydrogen, sH2, sOxygen, sO2, sNitrogen, sN2, sNitrousOxide, sNO, sNitrousDioxide, sNO2, sCarbonDioxide, sCO2, sCarbonMonoxide, sCO, sWater, sH2O, sSulfurDioxide, sSO2, sAmmonia, sNH3};
  //                                  C H O N S
  parameter Real[5] sMethane =       {1,4,0,0,0};
  parameter Real[5] sCH4 =           {1,4,0,0,0};
  parameter Real[5] sEthane =        {2,6,0,0,0};
  parameter Real[5] sC2H6 =          {2,6,0,0,0};
  parameter Real[5] sPropane =       {3,8,0,0,0};
  parameter Real[5] sC3H8 =          {3,8,0,0,0};
  parameter Real[5] sButane =        {4,10,0,0,0};
  parameter Real[5] sC4H10 =         {4,10,0,0,0};
  parameter Real[5] sHydrogen =      {0,2,0,0,0};
  parameter Real[5] sH2 =            {0,2,0,0,0};
  parameter Real[5] sOxygen =        {0,0,2,0,0};
  parameter Real[5] sO2 =            {0,0,2,0,0};
  parameter Real[5] sNitrogen =      {0,0,0,2,0};
  parameter Real[5] sN2 =            {0,0,0,2,0};
  parameter Real[5] sNitrousOxide =  {0,0,1,1,0};
  parameter Real[5] sNO =            {0,0,1,1,0};
  parameter Real[5] sNitrousDioxide= {0,0,2,1,0};
  parameter Real[5] sNO2 =           {0,0,2,1,0};
  parameter Real[5] sCarbonDioxide = {1,0,2,0,0};
  parameter Real[5] sCO2 =           {1,0,2,0,0};
  parameter Real[5] sCarbonMonoxide= {1,0,1,0,0};
  parameter Real[5] sCO =            {1,0,1,0,0};
  parameter Real[5] sWater =         {0,2,1,0,0};
  parameter Real[5] sH2O =           {0,2,1,0,0};
  parameter Real[5] sSulfurDioxide = {0,0,2,0,1};
  parameter Real[5] sSO2 =           {0,0,2,0,1};
  parameter Real[5] sAmmonia =       {0,3,0,1,0};
  parameter Real[5] sNH3 =           {0,3,0,1,0};

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This record contains a matrix, defining the stoichiometric coefficients of the elements C, H, O, N, S in various fuel gas molecules.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>No physical effects considered. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>The molecule names are stored in the &quot;names&quot; vector as follows</p>
<p><img src=\"modelica://TransiEnt/Images/stoich1.png\"/></p>
<p>the corresponding stoichiometric coefficientts are stored in a matrix &quot;stoich&quot; in the following way</p>
<p><img src=\"modelica://TransiEnt/Images/stoich2.png\"/></p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<ul>
<li>Be sure to store the stoichiometric coefficients vector for each component in stoich in the same column in which the name is stored in the names matrix.</li>
<li>In component names with two words, these are to be separated by an underscore. Don&apos;t use spaces, as in the shortenCompName functions spaces are replaced by underscores!</li>
</ul>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>No validation needed.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Record created by Jan Braune (jan.braune@tuhh.de), Mar 2015</p>
<p>Extendend by Paul Kernstock (paul.kernstock@tuhh.de), July 2015</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Sep 2015</p>
</html>"));
end StoichiometricCoefficientsCombustion;
