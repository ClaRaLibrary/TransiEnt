within TransiEnt.Storage.Heat.HeatStorage_Stratified.Utilities;
function get_Layer "[height_port, layer_height, nLayer] Calculates the layer for a given height.
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
  1 is the highest layer, nLayer the lowest"

extends TransiEnt.Basics.Icons.Function;

  input Real height_port(min=0);
  input Real height_segment;
  input Integer nSeg(min=1);

  output Integer segment(min=1);

algorithm
  if (height_port == 0) then
    segment := nSeg;
  else
    segment :=nSeg + 1 - integer(ceil(height_port/height_segment));
  end if;

  assert(height_port <= nSeg*height_segment,
      "Height of port is higher than height of tank. Adjust!");
  assert(height_segment > 0,
      "Height of segment needs a positve value. Adjust!");
  assert(height_port >= 0,
      "Height of port needs a positve or zero value. Adjust!");

end get_Layer;
