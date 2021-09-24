within TransiEnt.Components.Visualization.PowerSystemBasics;
model CapacityFactor

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



  extends DynDisplay(
    final varname="Capacity Factor",
    final unit="%",
    decimalSpaces=1,
    final x1=100*E/P_0/max(0.01, time));
  input Modelica.Units.SI.Power P "Power (variable name)" annotation (Dialog);
  Modelica.Units.SI.Energy E(start=0, fixed=true);

  parameter Modelica.Units.SI.Power P_0=1 "Installed power";
equation
  der(E) = P;
  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Model for dynamic display of capacity factor</p>
</html>"));
end CapacityFactor;
