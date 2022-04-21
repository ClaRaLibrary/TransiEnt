within TransiEnt.Components.Statistics.Functions.CO2Allocation;
function chp_co2_alloc_efficiency "CHP CO2 allocation by efficiency method"
  import TransiEnt;


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





  extends TransiEnt.Basics.Icons.Function;
  //  input (m_spec_fuel,W_fuel, eta_el, W_el, eta_th, W_th,
  input TransiEnt.Basics.Units.MassOfCDEperEnergy m_spec_fuel;
  input SI.Energy E_fuel;
  input SI.Energy E_el;
  input SI.Energy E_th;
  input SI.Efficiency eta_th;
  input SI.Efficiency eta_el;
  output TransiEnt.Basics.Units.MassOfCDEperEnergy m_spec[2] "Specific emissions of thermal [1] and electric [2] generation";

protected
Real  A_Br_el;
Real A_Br_th;
Real CO2_el;
Real CO2_th;

algorithm
A_Br_el :=eta_th ./ (eta_el + eta_th);
A_Br_th :=eta_el ./ (eta_el + eta_th);

CO2_el:=m_spec_fuel .* E_fuel .* A_Br_el;
CO2_th:=m_spec_fuel .* E_fuel .* A_Br_th;

m_spec[1]:=CO2_th ./ max(0.1, E_th);
m_spec[2]:=CO2_el ./ max(0.1, E_el);
  annotation (Library="ModelicaExternalC",Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><pre>
fullName = Files.<b>fullPathName</b>(name);
</pre></blockquote>
<h4>Description</h4>
<p>
Returns the full path name of a file or directory \"name\".
</p>
</html>"));
end chp_co2_alloc_efficiency;
