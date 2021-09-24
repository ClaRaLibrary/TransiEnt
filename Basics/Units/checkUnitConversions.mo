within TransiEnt.Basics.Units;
model checkUnitConversions

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



  extends TransiEnt.Basics.Icons.Checkmodel;

  parameter MonetaryUnit one_EUR = 1;
  parameter MonetaryUnit a_thousand_EUR = 1e3;

  parameter MonetaryUnitPerEnergy a_EUR_per_J = 1;
  parameter MonetaryUnitPerEnergy a_EUR_per_kWh = 1/(1e3*3600);
  parameter MonetaryUnitPerEnergy a_EUR_per_MWh = 1/(1e6*3600);

  parameter MonetaryUnitPerPower a_EUR_per_kW = 1/(1e3);
  parameter MonetaryUnitPerPower a_EUR_per_MW = 1/(1e6);

  parameter Time_year a_year = 1;

  parameter SI.Time a_second = 1;

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)));
end checkUnitConversions;
