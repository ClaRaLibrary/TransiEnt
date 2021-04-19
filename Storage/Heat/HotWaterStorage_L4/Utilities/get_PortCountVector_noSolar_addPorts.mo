within TransiEnt.Storage.Heat.HotWaterStorage_L4.Utilities;
function get_PortCountVector_noSolar_addPorts "generates port count vector for tank with solar, CHP and grid in and outputs"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
// Copyright 2020, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE and ResiliEntEE are research projects supported by the German     //
// Federal Ministry of Economics and Energy (FKZ 03ET4003 and 03ET4048).          //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Institute of Electrical Power Systems and Automation                           //
// (Hamburg University of Technology)                                             //
// and is supported by                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//
  extends TransiEnt.Basics.Icons.Function;

  input Integer nSeg "Number of tank segments";

  input Integer CHP_in_layer "CHP input segment";
  input Integer CHP_out_layer "CHP output segment";

  input Integer grid_in_layer "grid input segment";
  input Integer grid_out_layer "grid output segment";

  input Integer nAdditionalPorts "number of additional in and output ports";
  input Integer[nAdditionalPorts]  additionalPorts_layer "additional ports segments";

  //overall port counts to create volume segments with correct port count
  output Integer[nSeg] portCountVector;

// return port number of volume element where the connection has to be made

protected
   Integer CHP_in_port;
   Integer CHP_out_port;

   Integer grid_in_port;
   Integer grid_out_port;

   Integer[nAdditionalPorts] additionalPort_ports;

algorithm
  // inter layer connections. sheme ist layer[i].ports[1]->layer[i+1].ports[2],
  // but layer[nSeg-1].ports[1]->layer[nSeg].ports[1]
    portCountVector :=fill(1, nSeg);
    portCountVector[2:nSeg-1] :=fill(2, nSeg-2);

  //add ports for external fluid connections

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

    //additional ports
     for i in 1 : nAdditionalPorts loop
       portCountVector[additionalPorts_layer[i]] := portCountVector[additionalPorts_layer[i]] + 1;
       additionalPort_ports[i] := portCountVector[additionalPorts_layer[i]];
     end for;

  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
</html>"));
end get_PortCountVector_noSolar_addPorts;
