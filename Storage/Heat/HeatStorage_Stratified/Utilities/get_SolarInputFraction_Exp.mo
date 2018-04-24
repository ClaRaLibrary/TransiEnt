within TransiEnt.Storage.Heat.HeatStorage_Stratified.Utilities;
function get_SolarInputFraction_Exp "returns vector with fraction of total inflow for each solar input layer. sum of fractions is 1."
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
  // - the exponent can be changed.
  // - the standard value for the exponent is 2.
  // - the higher the value the more fluid flows in the segment with the smallest
  //   temperature difference
extends TransiEnt.Basics.Icons.Function;

input Integer nSolarInputLayer;
input Real T_solar_input_layer[nSolarInputLayer];
input Real T_load;
input Real exp = 2;

output Real layer_mass_flow_fraction[nSolarInputLayer];

protected
Real sum_dT_layer;
Real dT_max;
Real dT_layer[nSolarInputLayer];
Real dT_layer_nomalized[nSolarInputLayer];
Real dT_layer_sq[nSolarInputLayer];
Real eps=0.0001;
algorithm
  sum_dT_layer :=0;
  dT_max :=0;
  for layer in 1:nSolarInputLayer loop
    dT_layer[layer] :=  max((((T_load - T_solar_input_layer[layer])^2)^0.5)^exp, eps);
  end for;
  dT_max :=max(dT_layer);
  dT_layer_nomalized :=dT_layer/dT_max;
  for layer in 1:nSolarInputLayer loop
    dT_layer_sq[layer] := dT_layer_nomalized[layer]^exp;
    sum_dT_layer :=  sum_dT_layer + 1/dT_layer_sq[layer];
  end for;
  for layer in 1:nSolarInputLayer loop
    layer_mass_flow_fraction[layer] := (1/dT_layer_sq[layer]) / (sum_dT_layer);
  end for;
  annotation (
  Documentation(
  revisions="<html>
  <ul>
  <li>
  20.2.2013<br>
  Function added to the HVAC_Lib by Paul Harmsen.
  </li>
  </ul>
  </html>"));
end get_SolarInputFraction_Exp;
