﻿within TransiEnt.Producer.Electrical;
package Photovoltaics


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




  extends TransiEnt.Basics.Icons.Package;






































annotation (Icon(graphics={
        Ellipse(
          extent={{-8,76},{-54,30}},
          lineColor={255,128,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Sphere),
        Line(
          points={{-28,6},{-28,-42}},
          color={255,191,0},
          smooth=Smooth.None),
        Line(
          points={{0,24},{-36,-16}},
          color={255,191,0},
          smooth=Smooth.None,
          origin={34,12},
          rotation=90),
        Line(
          points={{0,24},{0,-24}},
          color={255,191,0},
          smooth=Smooth.None,
          origin={44,54},
          rotation=90)}));
end Photovoltaics;
