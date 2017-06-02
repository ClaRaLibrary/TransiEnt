within TransiEnt.Storage.Heat.HeatStorageStratified_constProp.Base;
function getIdxFromHeight "Returns index of closest control volume matching the given height"
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
  input Integer N "Number of volumes";
  input SI.Length h "Total height";
  input SI.Length hq "Query height";
  output Integer iq "Index";
protected
          SI.Length[N] Dh=(1/(2*N):1/N:1)*h;
algorithm
  assert(hq<=h and hq>=0, "Port height must be between 0 and h");
  iq:=N;
  if Dh[1]>= hq then
    iq:=1;
    break;
  end if;
  for i in 1:N loop
    if Dh[i]>=hq then
      iq:=if Dh[i]-hq > hq-Dh[i-1] then i-1 else i;
      break;
    end if;
  end for;

end getIdxFromHeight;
