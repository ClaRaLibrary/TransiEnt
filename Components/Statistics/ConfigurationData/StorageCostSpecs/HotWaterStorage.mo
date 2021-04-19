within TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs;
model HotWaterStorage "Hot water storage cost specification record"
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
  // Fraunhofer "Speicher fr die Energiewende"
  // the specific investment costs all are scored to the energy capacity due to unknown relation
  // the operating costs alle are scored to the fix costs ue to unknown relation
  // the investmentcosts are stated with a value between 0.5 and 7 EUR/kWh. The maximum ist used.
  // the operating costs chould be compared with others, because its a thump calculation

  extends TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.PartialStorageCostSpecs(
    Cspec_fixOM=1.024/1e3 "specific fix annual OM cost in EUR/(kW*a)",
    Cspec_OM_W_el=0 "specific variable cost per stored energy in EUR/kWh",
    Cspec_inv_der_E=0 "specific invest cost per maximum unload power in EUR/kW",
    Cspec_inv_E=7/3.6e6 "Specific invest cost per energy capacity in EUR/kWh",
    lifeTime=simCenter.Duration);

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Hot water storage cost specification record</p>
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
<p>[1] Fraunhofer UMSICHT, &quot;Speicher fuer die Energiewende&quot;, 2013</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end HotWaterStorage;
