within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model CHP_500kW "CHP plant (500 kW, gas-fired)"


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




  // Parameters for CHP with ca. 500 kW_el
  // investment: (Kimmling S.175)
  // fuel: natural gas
  // fix costs: maintenace and repair (Kimmling S.176/ VDI 2067-1)

extends PartialCostSpecs(
    Cspec_inv_der_E=500/1000 "EUR/W",
    factor_OM=(0.02 + 0.06) "Percentage of the invest cost that represents the annual O&M cost",
    Cspec_OM_W_el=1.2/100/3.6e6 "EUR/J",
    lifeTime=20 "Life time");

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>CHP plant (500 kW, gas-fired)</p>
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
<p>[1] ASUE Arbeitsgemeinschaft für sparsamen und umweltfreundlichen Energieverbrauch e.V., &quot;BHKW Grundlagen&quot;, 2010</p>
<p><span style=\"font-family: sans-serif;\">[2] KRIMMLING, J. &quot;Energieeffiziente Nahwärmesysteme: Grundwissen, Auslegung, Technik für Energieberater und Planer.&quot; Stuttgart: Fraunhofer IRB Verlag, 2011. ISBN978-3-8167-8342-8. </span></p>
<p>[3] Verein Deutscher Ingenieure (VDI), Richtlinie VDI 2067 Blatt 1, &quot;Wirtschaftlichkeit gebäudetechnischer Anlagen - Grundlagen und Kostenberechnung&quot;, 2012</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end CHP_500kW;
