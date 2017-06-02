within TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs;
model DistrictHeatingGrid "Cost model for a distric heating grid"
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
  extends PartialCostSpecs(
    size1=1 "Length of the district heating grid",
    C_inv_size=3000*size1 "DN700, KRM. includes material, mounting and civil engineering (Source: [1]MVV Energie AG: Waermetransport im Wettbewerb zu dislozierter Waeeerzeugung, 2013)",
    lifeTime=20);
end DistrictHeatingGrid;
