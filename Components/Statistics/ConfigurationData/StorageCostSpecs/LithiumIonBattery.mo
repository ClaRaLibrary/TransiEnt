within TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs;
model LithiumIonBattery "Lithium ion battery cost (including inverter)"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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
  // data from "Mahnke, Eva ; Mühlenhoff, Jörg ; Lieblang, Leon ; Von, Herausgegeben: Strom Speichern. In: Renews Spezial (2014), Nr. 75 "

  extends TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.PartialStorageCostSpecs(
    factor_OM=0.01 "specific fix annual OM cost (1% of investment)",
    Cspec_OM_W_el=0 "specific variable cost per stored energy in EUR/kWh",
    Cspec_inv_der_E=150/1e3 "Specific invest cost per nominal power (150...200 €/kW)",
    Cspec_inv_E=600/3.6e6 "Specific invest cost per energy capacity (300...800 €/kWh)",
    lifeTime=10);
end LithiumIonBattery;
