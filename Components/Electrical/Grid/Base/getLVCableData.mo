within TransiEnt.Components.Electrical.Grid.Base;
function getLVCableData "function to get low voltage cable data"
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
  input TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes cabletype "type of low voltage cable";
  output Real cabledata[4] "returns cable data. [r1,x1,c1,ir]";
algorithm
  // saved cabledata
  // Data r1[Ohm/km], x1[Ohm/km], c1[muF/km], ir[A]
  if cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K1 then
    cabledata:={0.13,0.09,0.67,360};
  elseif cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K2 then
    cabledata:={0.001,0.001,0.001,999};

  elseif cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K3 then
    cabledata:={0.211,0.113,0.37,350};

  elseif cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K4 then
    cabledata:={0.21,0.095,0.429998,285};

  elseif cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K5 then
    cabledata:={0.168,0.092,0.459999,320};

  elseif cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K6 then
    cabledata:={0.256,0.097,0.409999,250};

  elseif cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K7 then
    cabledata:={0.211,0.113,0.37,350};

  elseif cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K8 then
    cabledata:={0.21,0.095,0.5399999,285};

  elseif cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K9 then
    cabledata:={0.13,0.105,0.458,460};

  elseif cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K10 then
    cabledata:={0.13,0.105,0.459999,460};

  elseif cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K11 then
    cabledata:={0.211,0.113,0.37,350};

  elseif cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K12 then
    cabledata:={0.211,0.113,0.37,350};

  elseif cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K13 then
    cabledata:={0.872,0.143,0.0225,145};

  elseif cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K14 then
    cabledata:={0.402,0.07000000000000001,0.001,245};

  elseif cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K15 then
    cabledata:={1.379,0.07000000000000001,0.001,110};

  elseif cabletype == TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K16 then
    cabledata:={0.267,0.08,0.001,330};
  else

  end if;
  // 240 Al-M
  // MiSpg-Kabel, verlustfrei
  // 150 M8
  // 150 Al
  // 185 Al
  // 120 Al
  // 150 M7
  // 150 Al-M
  // 240 M8
  // 240 M9
  // 150 M6
  // 150 M9
  // 35 M9
  // 95 N6_NS
  // BA 4x16 H07RN-F_NS
  // 150 AL-M HA_NS
  // Umwandlung der Einheiten in [Ohm/m] und [F/m]
  cabledata[1:2]:=cabledata[1:2] * 0.001;
  cabledata[3]:=cabledata[3] * 1e-009;
end getLVCableData;
