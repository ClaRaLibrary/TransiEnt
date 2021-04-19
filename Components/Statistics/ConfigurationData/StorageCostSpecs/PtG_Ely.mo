within TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs;
model PtG_Ely "Power to gas electrolyzer cost specification record"
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
  //Source:Stolzenburg et al, 2014 (NOW Studie)
  extends PartialStorageCostSpecs(
 Cspec_inv_der_E=0.9 "EUR/W, Electrolizer, Stolzenburg",
 Cspec_inv_E=60 "EUR/m3 cavern-storage, Stolzenburg",
 Cspec_fixOM=0 "EUR/a. Regular measurements at the cavern-storage, Stolzenburg",
 Cspec_OM_W_el=0 "zero since the costs are already covered in the annuities. Instead of: 60 EUR/MWh Approximate RE price (feed-in-tariff average), Stolzenburg",
 lifeTime=simCenter.lifeTime_Cavern);

   //Cspec_inv_der_E=900EUR/kW Ely=0.9 EUR/W
   //Cspec_inv_V=60 EUR/m3 cavern
   //Cspec_fixOM=50000 EUR/a regelmeige Bemessungen der Kaverne
   //Cspec_OM_W_el=90 EUR/MWh (Abschtzung EE Strom)
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Power to gas electrolyzer cost specification record</p>
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
<p>[1] K. Stolzenburg, &quot;Integration von Wind-Wasserstoff-Systemen in das Energiesystem&quot;, 2014 </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end PtG_Ely;
