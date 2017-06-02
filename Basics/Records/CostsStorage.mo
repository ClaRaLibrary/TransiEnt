within TransiEnt.Basics.Records;
model CostsStorage
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

  extends TransiEnt.Basics.Icons.Record;
  input TransiEnt.Basics.Units.MonetaryUnit costs "Total costs";
  input TransiEnt.Basics.Units.MonetaryUnit investCosts "Invest-related costs";
  input TransiEnt.Basics.Units.MonetaryUnit investCostsStartGas "Invest-related costs of the start gas";
  input TransiEnt.Basics.Units.MonetaryUnit demandCosts "Demand-related costs";
  input TransiEnt.Basics.Units.MonetaryUnit oMCosts "Operation-related costs incl. maintenance";
  input TransiEnt.Basics.Units.MonetaryUnit otherCosts "Other costs";
  input TransiEnt.Basics.Units.MonetaryUnit revenues "Revenues";

end CostsStorage;
