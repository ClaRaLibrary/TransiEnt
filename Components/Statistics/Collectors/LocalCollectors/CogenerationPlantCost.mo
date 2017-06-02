within TransiEnt.Components.Statistics.Collectors.LocalCollectors;
model CogenerationPlantCost "Cost model for conventional thermal or renewable power plants with cogeneration "

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
  // _____________________________________________
  //
  //            Imports
  // _____________________________________________

  // set everything to final such that options which are not needed dont cloud up the parameter dialog
  extends PowerPlantCost(final A_alloc_power_internal=A_alloc_power, Q_flow_internal=Q_flow_is);

  // _____________________________________________
  //
  //         Variables appearing in dialog
  // _____________________________________________

  SI.ActivePower Q_flow_is=0 "Thermal power generation of plant" annotation(Dialog(group="Variables"));
  SI.ActivePower A_alloc_power=0.5 "Cost allocation factor for calculation of LCOE" annotation(Dialog(group="Variables"));
  SI.ActivePower A_alloc_heat=0.5 "Cost allocation factor for calculation of LCOH" annotation(Dialog(group="Variables"));

  // _____________________________________________
  //
  //   Variables for power plant cost diagnostics
  // _____________________________________________

  TransiEnt.Basics.Units.MonetaryUnitPerEnergy LCOH=C/max(simCenter.E_small, Q_demand)*3.6e9*A_alloc_heat "Levelized cost of heat";

end CogenerationPlantCost;