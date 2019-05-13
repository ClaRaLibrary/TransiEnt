within TransiEnt.Basics.Interfaces;
package Electrical
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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
  extends TransiEnt.Basics.Icons.ElectricalPackage;




















  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100.0,-100.0},
            {100.0,100.0}}), graphics),Documentation(info="<html>

<p> This documnentation wants to give a short overview which power ports can be used for different applications. </p>
<p> The ActivePowerPort is only usable for concentrated grids without lines.</p>
<p> The ApparentPowerPort is only usable for radial distribution systems. </p>
<p> The ComplexPowerPort is the most advanced power port and can be used for interconnected grids. </p>
<p> Short description by Jan-Peter Heckel (jan.heckel@tuhh.de), Apr 2018</p>
</html>"));
end Electrical;
