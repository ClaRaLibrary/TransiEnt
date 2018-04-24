within TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs;
model PumpStorage
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
  //Source: Table Schülting
  //C_inv in EUR/W: Mittelwert der Investitionskosten der PSW "Linth-Limmern (CH) 2015" (875€/kW), Nant-de-Drance (CH) 2017" (1666,67€/kW), "Südschwarzwald (D) 2019" (857,14€/kW) und "Goldisthal (D) 2004" (587,74€/kW) https://www.eeh.ee.ethz.ch/uploads/tx_ethpublications/GA_AebliTruessel_FS2012.pdf
  //77,18Mio€/2000MW nach "Rentabilität von Pumpspeicherkraftwerken" an der ETH ,S.15 https://www.eeh.ee.ethz.ch/uploads/tx_ethpublications/GA_AebliTruessel_FS2012.pdf
  extends PartialStorageCostSpecs(
 Cspec_inv_der_E=0.730/1e3,
 Cspec_inv_E=0,
 Cspec_fixOM=0.048/1e3,
 Cspec_OM_W_el=0,
 lifeTime=simCenter.Duration);
end PumpStorage;
