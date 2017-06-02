within TransiEnt.Basics.Functions;
function MeanValue "Function calculates the mean value of an vector"
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

  extends Icons.Function;
  input Real x[:] "Vector of values";
  output Real result "Mean Value";
algorithm
  result:=0 "initialisation of variable";
  for i in 1:size(x, 1) loop
      result:=result + x[i];
  end for "Sum up all elements";
  result:=result / size(x, 1) "Dived throught the number of elements";
end MeanValue;
