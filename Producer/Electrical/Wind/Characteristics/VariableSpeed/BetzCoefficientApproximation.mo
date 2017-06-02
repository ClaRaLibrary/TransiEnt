within TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed;
record BetzCoefficientApproximation "Six parameter approximation model for betz coefficient taken from Heier2009"
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
  Real c[7] "Six parameter for approximation model";
  Real lambdaOpt[:,:] "Data table containing lambda_opt for each value of pitch angle beta";
  parameter SI.Power P_el_n "Nominal power";
end BetzCoefficientApproximation;
