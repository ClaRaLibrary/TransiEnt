within TransiEnt.Storage.Heat.HeatStorage_Stratified.Utilities;
function get_init_segment_enthalpy_piecewise_linear "[nLayer, T1, T2, T3, T4, T1_layer, T2_layer, T3_layer, T4_layer] calculates initial values through linear interpolation between the four measured temperatures in the tank"
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

  extends TransiEnt.Basics.Icons.Function;

  input Integer nLayer;

  input Real T1;  // C
  input Real T2;  // C
  input Real T3;  // C
  input Real T4;  // C

  input Integer T1_layer;
  input Integer T2_layer;
  input Integer T3_layer;
  input Integer T4_layer;

  output Real[nLayer] layered_h;

protected
  Real dh;
  Integer k=1;
  constant Real c_p = 4180;  //bei 20C

algorithm
//layer higher than T1 == T1
 for i in 1:T1_layer loop
   layered_h[i]:= c_p*T1;
  end for;

//layers T1 to T2 linear interpolation
    dh:= c_p*(T2 - T1)/(T2_layer - T1_layer);
    k:=1;
  for i in (T1_layer+1):T2_layer loop
   layered_h[i]:= c_p*T1 + k*dh;
   k:=k + 1;
  end for;

//layers T2 to T3 linear interpolation
    dh:=c_p*(T3 - T2)/(T3_layer - T2_layer);
    k:=1;
  for i in (T2_layer+1):T3_layer loop
   layered_h[i]:= c_p*T2 + k*dh;
   k:=k + 1;
  end for;

//layers T3 to T4 linear interpolation
    dh:=c_p*(T4 - T3)/(T4_layer - T3_layer);
    k:=1;
  for i in (T3_layer+1):T4_layer loop
    layered_h[i]:=c_p*T3 + k*dh;
    k:=k + 1;
  end for;

//layers lower than T4 == T4
  for i in T4_layer:nLayer loop
    layered_h[i]:=c_p*T4;
  end for;

end get_init_segment_enthalpy_piecewise_linear;
