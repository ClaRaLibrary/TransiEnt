within TransiEnt.Components.Electrical.Grid.Base;
function getHVCableData "function to get high voltage cable data"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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




  input TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes cabletype "type of high voltage cable";
  output Real cabledata[4] "returns cable data. [r1,x1,c1,ir]";
algorithm
  // saved cabledata
  // Data r1[Ohm/km], x1[Ohm/km], c1[muF/km], ir[A]
  if cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L1 then
    cabledata:={0.06,0.301,0.0125,1290};
  elseif cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L2 then
    cabledata:={0.03,0.246,0.0138,2580};
  elseif cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L3 then
    cabledata:={0.025,0.26,0.014,2520};
  elseif cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L4 then
    cabledata:={0.12,0.39,0.009,645};
  elseif cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L5 then
    cabledata:={0.0744,0.3194,0.0113,1290};
  elseif cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L6 then
    cabledata:={0.0275,0.264,0.0138,2520};



  else

  end if;
  // 220 kV overhead line, 2-wire-bundle Al/St 240/40
  // 380 kV overhead line, 4-wire-bundle Al/St 240/40
  // 380 kV overhead line, 3-wire-bundle Al/St 380/50
  // 110 kV overhead line, Al/St 240/40
  // 220 kV average transmission line, Northern Germany
  // 380 kV average transmission line, Northern Germany

  // Conversion of dimensions to [Ohm/m] and [F/m]
  cabledata[1:2]:=cabledata[1:2] * 0.001;
  cabledata[3]:=cabledata[3] * 1e-009;
end getHVCableData;
