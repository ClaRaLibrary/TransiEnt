within TransiEnt.Components.Electrical.Grid.Base;
function getMVCableData "function to get middle voltage cable data"

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



  input TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes cabletype "type of medium voltage cable";
  output Real cabledata[4] "returns cable data. [r1,x1,c1,ir]";
algorithm
  // saved cabledata
  // Data r1[Ohm/km], x1[Ohm/km], c1[muF/km], ir[A]
  if cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L1 then
    cabledata:={0.32,0.37,0.01,350};
  elseif cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L2 then
    cabledata:={0.31,0.36,0.01,340};
  elseif cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L3 then
    cabledata:={0.158,0.116,0.44,325};
  elseif cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L4 then
    cabledata:={0.181,0.094,0.48,290};




  else

  end if;
  // 30 kV overheand line, 95/12 Al/St
  // 20 kV overheand line, 95 A
  // 20 kV Cable, 3 * 150 mm^2 Cu
  // 10 kV Cable, 3 * 120 mm^2 Cu

  // Umwandlung der Einheiten in [Ohm/m] und [F/m]
  cabledata[1:2]:=cabledata[1:2] * 0.001;
  cabledata[3]:=cabledata[3] * 1e-009;
end getMVCableData;
