within TransiEnt.Components.Statistics.ConfigurationData.DemAndRevCostSpecs.GasAndFuelCostSpecs;
record Diesel "Cost record for diesel"
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
  extends PartialCostGasAndFuel(
    Cspec_demAndRev_gas_fuel=0.9134/(0.8355*42.5e6) "(=92.60 EUR/MWh) 0.9134 EUR/l_diesel in 2015 (Statistisches Bundesamt https://www.destatis.de/DE/Publikationen/Thematisch/Preise/Energiepreise/EnergiepreisentwicklungPDF_5619001.pdf?__blob=publicationFile), calorific value 42.5 MJ/kg, density 0.8355 kg/l");
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>cost record for diesel (average value of 2015)</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] Statistisches Bundesamt, &quot;Preise - Daten zur Energiepreisentwicklung- Lange Reihen von Januar 2005 bis September 2018&quot;, 2018</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end Diesel;
