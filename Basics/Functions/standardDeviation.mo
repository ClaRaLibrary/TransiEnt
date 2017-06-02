within TransiEnt.Basics.Functions;
function standardDeviation "function calculates the standard deviation"
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
  import TransiEnt;
  input Real x[:] "Input Vector";
  output Real result "Result value";
protected
  Real mean;
algorithm
  result:=0 "variable initilaisation";
  mean:=TransiEnt.Basics.Functions.MeanValue(x) "gets the mean value of x";
  for i in 1:size(x, 1) loop
      result:=result + (x[i] - mean) ^ 2;
  end for "sums up the squared difference between value and mean value";
  result:=result / size(x, 1);
  result:=sqrt(result);
end standardDeviation;
