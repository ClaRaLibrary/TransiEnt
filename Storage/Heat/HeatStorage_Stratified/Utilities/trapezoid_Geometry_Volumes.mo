within TransiEnt.Storage.Heat.HeatStorage_Stratified.Utilities;
function trapezoid_Geometry_Volumes
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

extends TransiEnt.Basics.Icons.Function;

input Integer nSeg;
input Real width_top;
input Real height;
input Real length;
input Real CrossAreas[nSeg-1];

//output WallAreas;
output Real Volumes[nSeg];

algorithm
  Volumes[1] := (width_top*length+CrossAreas[1])/2*height;

  for i in 1:nSeg-1 loop
    Volumes[i+1] := (CrossAreas[i]+CrossAreas[i+1])/2*height;
  end for;

end trapezoid_Geometry_Volumes;
