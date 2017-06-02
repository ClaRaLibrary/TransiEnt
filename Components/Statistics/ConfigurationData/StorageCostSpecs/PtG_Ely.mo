within TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs;
model PtG_Ely
//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
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
end PtG_Ely;
