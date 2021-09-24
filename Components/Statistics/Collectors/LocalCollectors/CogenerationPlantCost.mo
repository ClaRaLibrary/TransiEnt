within TransiEnt.Components.Statistics.Collectors.LocalCollectors;
model CogenerationPlantCost "Cost model for conventional thermal or renewable power plants with cogeneration "


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-BSD-clause.           //
// Copyright 2021, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE, ResiliEntEE, IntegraNet and IntegraNet II are research projects  //
// supported by the German Federal Ministry of Economics and Energy               //
// (FKZ 03ET4003, 03ET4048, 0324027 and 03EI1008).                                //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Fraunhofer Institute for Environmental, Safety, and Energy Technology UMSICHT, //
// Gas- und Wärme-Institut Essen						  //
// and                                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//



  // _____________________________________________
  //
  //            Imports
  // _____________________________________________

  // set everything to final such that options which are not needed dont cloud up the parameter dialog
  extends PowerPlantCost(final A_alloc_power_internal=A_alloc_power, Q_flow_internal=Q_flow_is, final produces_Q_flow=true, final consumes_H_flow);

  // _____________________________________________
  //
  //         Variables appearing in dialog
  // _____________________________________________

  SI.ActivePower Q_flow_is=0 "Thermal power generation of plant (should be negative)" annotation(Dialog(group="Variables"));
  SI.ActivePower A_alloc_power=0.5 "Cost allocation factor for calculation of LCOE" annotation(Dialog(group="Variables"));
  SI.ActivePower A_alloc_heat=0.5 "Cost allocation factor for calculation of LCOH" annotation(Dialog(group="Variables"));

  // _____________________________________________
  //
  //   Variables for power plant cost diagnostics
  // _____________________________________________

  TransiEnt.Basics.Units.MonetaryUnitPerEnergy LCOH=C/max(simCenter.E_small, -Q_revenue)*3.6e9*A_alloc_heat "Levelized cost of heat";

end CogenerationPlantCost;
