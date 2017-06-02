within TransiEnt.Storage.Heat.HeatStorage_Stratified.Utilities;
function get_init_segment_enthalpy_linear "[nLayer, T1, T2, T3, T4, T1_layer, T2_layer, T3_layer, T4_layer] calculates initial values through linear interpolation between the four measured temperatures in the tank"
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

  input Integer nLayer;
  input Real T_min;  // C
  input Real T_max;  // C

  output Real[nLayer] layered_h;
protected
  Real h_min;
  Real h_max;
  Real dh;
  Integer k=1;
  constant Real c_p = 4180;  //bei 20C
algorithm
  h_min :=c_p*T_min;
  h_max :=c_p*T_max;

//layer 1
layered_h[1]:=h_max;

//layers 2 to nLayer linear interpolation
dh:=(h_min - h_max)/(nLayer-1);
k:=1;
for i in 2:nLayer loop
  layered_h[i]:=h_max + k*dh;
  k:=k + 1;
end for;

end get_init_segment_enthalpy_linear;
