within TransiEnt.Basics.Interfaces;
package Electrical

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
