within TransiEnt.Basics.Functions;
function find_max "Finds the minimum (maximum) value of a vector"
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
input Real vector[:];
input Real stateVector[:]=ones(size(vector,1));
input Integer cond=1 "Only use items where statevector[i]=cond";
output Integer index;
protected
Real value "Min/Max value of vector";
algorithm
  value:=vector[1];//Initial minimum value
  index:=1;
  for i in 1:size(vector,1) loop
    if vector[i]>value and stateVector[i]==cond then
      value:=vector[i];
      index:=i;
    end if;
  end for;
end find_max;
