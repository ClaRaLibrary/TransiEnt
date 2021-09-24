within TransiEnt.Basics;
package Media "Contains fluid type records"

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



  extends TransiEnt.Basics.Icons.Package;











annotation (Icon(graphics={
        Line(
          points={{-66,-48},{-60,-24},{-30,46},{6,72},{50,72},{75,51},{64,-2},{
            50,-44},{48,-50}},
          color={64,64,64},
          smooth=Smooth.Bezier),
        Line(
          points={{-38,26},{70,26}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-38,26},{-40,62},{-40,64}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{70,26},{88,-52}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-58,-22},{58,-22}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{-58,-22},{-64,32},{-66,36}},
          color={175,175,175},
          smooth=Smooth.None),
        Line(
          points={{58,-22},{68,-56}},
          color={175,175,175},
          smooth=Smooth.None)}));
end Media;
