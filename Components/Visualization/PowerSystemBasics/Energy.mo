within TransiEnt.Components.Visualization.PowerSystemBasics;
model Energy
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
  extends DynDisplay(
    final varname="Energy",
    unit="Wh",
    decimalSpaces=2,
    final x1=E/3600);
    input Modelica.SIunits.Power P "Power (variable name)"  annotation (Dialog);
    Modelica.SIunits.Energy E(start=E_start, fixed=true);
    parameter Modelica.SIunits.Energy E_start "Start value at t=0";
equation
  der(E) = P;
  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Model for dynamic display of energy</p>
</html>"));
end Energy;
