within TransiEnt.Producer.Electrical.Base.PartloadEfficiency;
record SteamturbinePlant "Typical steam turbine plant partload efficiency"
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
  extends PartloadEfficiencyCharacteristic(
                                CL_eta_P=[0.40, 0.908; 0.50, 0.939; 0.60, 0.965; 0.70, 0.980; 0.8, 0.990; 0.9, 0.996; 1, 1]);
end SteamturbinePlant;
