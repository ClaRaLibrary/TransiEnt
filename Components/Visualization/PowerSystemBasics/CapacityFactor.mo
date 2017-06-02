within TransiEnt.Components.Visualization.PowerSystemBasics;
model CapacityFactor
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
  extends DynDisplay(
    final varname="Capacity Factor",
    final unit="%",
    decimalSpaces=1,
    final x1=100*E/P_0/max(0.01, time));
    input Modelica.SIunits.Power P "Power (variable name)"  annotation (Dialog);
    Modelica.SIunits.Energy E(start=0, fixed=true);

    parameter Modelica.SIunits.Power P_0=1 "Installed power";
equation
  der(E) = P;
end CapacityFactor;
