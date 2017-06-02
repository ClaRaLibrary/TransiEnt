within TransiEnt.Storage.Heat.HeatStorage_Stratified.Utilities;
function get_Ports_noSolar "Gets ports according to the function \"get_PortCountVector\""
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

  input Integer nSeg "Number of tank segments";

  input Integer CHP_in_layer;
  input Integer CHP_out_layer;

  input Integer grid_in_layer;
  input Integer grid_out_layer;

  //overall port counts to create volume segments with correct port count

  output Integer[4] ports;

protected
   Integer[nSeg] portCountVector;

   Integer  CHP_in_port;
   Integer  CHP_out_port;

   Integer  grid_in_port;
   Integer  grid_out_port;

algorithm
   // inter layer connections. sheme ist layer[i].ports[1]->layer[i+1].ports[2],
  // but layer[nSeg-1].ports[1]->layer[nSeg].ports[1]
    portCountVector :=fill(1, nSeg);
    portCountVector[2:nSeg-1] :=fill(2, nSeg-2);

    //CHP
    portCountVector[CHP_in_layer] :=portCountVector[CHP_in_layer] + 1;
    CHP_in_port := portCountVector[CHP_in_layer];
    portCountVector[CHP_out_layer] :=portCountVector[CHP_out_layer] + 1;
    CHP_out_port := portCountVector[CHP_out_layer];

    //Grid
    portCountVector[grid_in_layer] :=portCountVector[grid_in_layer] + 1;
    grid_in_port :=portCountVector[grid_in_layer];
    portCountVector[grid_out_layer] :=portCountVector[grid_out_layer] + 1;
    grid_out_port :=portCountVector[grid_out_layer];

    // Create output vector

    ports[1] := CHP_in_port;
    ports[2] := CHP_out_port;
    ports[3] := grid_in_port;
    ports[4] := grid_out_port;

end get_Ports_noSolar;
