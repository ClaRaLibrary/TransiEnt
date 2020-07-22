within TransiEnt.Components.Statistics.Functions.CO2Allocation;
function chp_co2_alloc_efficiency "CHP CO2 allocation by efficiency method"
  import TransiEnt;
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2020, Hamburg University of Technology.                              //
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
