within TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs;
model LithiumIonBattery "Lithium ion battery cost (including inverter)"

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



  // data from "Mahnke, Eva ; Mühlenhoff, Jörg ; Lieblang, Leon ; written by, "Strom Speichern". Published in: Renews Spezial (2014), Nr. 75 "

  extends TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.PartialStorageCostSpecs(
    factor_OM=0.01 "specific fix annual OM cost (1% of investment)",
    Cspec_OM_W_el=0 "specific variable cost per stored energy in EUR/kWh",
    Cspec_inv_der_E=150/1e3 "Specific invest cost per nominal power (150...200 €/kW)",
    Cspec_inv_E=600/3.6e6 "Specific invest cost per energy capacity (300...800 €/kWh)",
    lifeTime=10);
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Lithium ion battery cost specification record</p>
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
<p>[1] E. Mahnke, J. Mühlenhoff, L. Lieblang<span style=\"font-family: Courier New;\">, </span>&quot;Strom Speichern&quot;, published in &quot;Renews Spezial Nr. 75&quot;, 2014</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end LithiumIonBattery;
