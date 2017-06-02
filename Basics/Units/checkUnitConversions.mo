within TransiEnt.Basics.Units;
model checkUnitConversions
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

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end checkUnitConversions;
