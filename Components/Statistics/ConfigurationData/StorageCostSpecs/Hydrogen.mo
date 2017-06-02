within TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs;
model Hydrogen
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
  //Source:http://www.energiespeicher-nds.de/fileadmin/Studien/Fichtner_Studie.PDF
  extends PartialStorageCostSpecs(
 Cspec_inv_der_E=1.5/1e3,
 Cspec_inv_E=20000/3.6e6,
 Cspec_fixOM=0.045,
 Cspec_OM_W_el=800/3.6e6,
 lifeTime=simCenter.Duration);
end Hydrogen;
