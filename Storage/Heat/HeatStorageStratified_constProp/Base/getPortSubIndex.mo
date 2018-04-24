within TransiEnt.Storage.Heat.HeatStorageStratified_constProp.Base;
function getPortSubIndex "Returns index of control volumes fluid port for input fluid connector 1 to 4"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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
  input Integer N;
  input Integer i_primIn;
  input Integer i_primOut;
  input Integer i_gridIn;
  input Integer i_gridOut;
protected
          Integer[N] portCount;
public
      output Integer[4] portSubIdx;
algorithm
  for i in 1:N loop
    if i>1 and i<N then
    portCount[i]:=2 "Volumes in between start at 2";
    else
      portCount[i]:=1 "Volumes at ends of tank start at 1";
    end if;
    if i==i_primIn then
      portCount[i]:=portCount[i]+1;
      portSubIdx[1]:=portCount[i];
    end if;
    if i==i_primOut then
      portCount[i]:=portCount[i]+1;
      portSubIdx[2]:=portCount[i];
    end if;
    if i==i_gridIn then
      portCount[i]:=portCount[i]+1;
      portSubIdx[3]:=portCount[i];
    end if;
    if i==i_gridOut then
      portCount[i]:=portCount[i]+1;
      portSubIdx[4]:=portCount[i];
    end if;
  end for;
end getPortSubIndex;
