within TransiEnt.Storage.Heat.HotWaterStorage_L4.Utilities;
function get_init_segment_enthalpy_piecewise_linear_Input_Kelvin "[nLayer, T1, T2, T3, T4, T1_layer, T2_layer, T3_layer, T4_layer] calculates initial values through linear interpolation between the four measured temperatures in the tank"

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




extends TransiEnt.Basics.Icons.Function;

  input Integer nLayer;

  input Real T_1;  // C
  input Real T_2;  // C
  input Real T_3;  // C
  input Real T_4;  // C

  input Integer T1_layer;
  input Integer T2_layer;
  input Integer T3_layer;
  input Integer T4_layer;

  output Real[nLayer] layered_h;

protected
  Real dh;
  Integer k=1;
  //constant Real c_p = 4180;  //bei 20C
  constant Real c_p = 4196;  //damit die Temperatur bei Abkhlung mit 10 Segmenten passt.

  Real T1= T_1-273.15;   // K
  Real T2= T_2-273.15;   // K
  Real T3= T_3-273.15;   // K
  Real T4= T_4-273.15;   // K

algorithm
 for i in 1:T1_layer loop
//layer higher than T1 == T1
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
end get_init_segment_enthalpy_piecewise_linear_Input_Kelvin;
