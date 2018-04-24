within TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs;
model Hydrogen
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
  //Source:http://www.energiespeicher-nds.de/fileadmin/Studien/Fichtner_Studie.PDF
  extends PartialStorageCostSpecs(
 Cspec_inv_der_E=1.5/1e3,
 Cspec_inv_E=20000/3.6e6,
 Cspec_fixOM=0.045,
 Cspec_OM_W_el=800/3.6e6,
 lifeTime=simCenter.Duration);
end Hydrogen;
