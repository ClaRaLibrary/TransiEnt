within TransiEnt.Producer;
package Combined "systems that generate thermal and electrical power"


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






  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________


  extends TransiEnt.Basics.Icons.Package;










annotation (Icon(graphics={
        Line(
          points={{-92,4},{-42,40},{68,48},{86,82}},
          color={0,127,127},
          smooth=Smooth.Bezier),
        Line(
          points={{-88,-24},{-38,12},{72,20},{90,54}},
          color={175,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-84,-54},{-34,-18},{76,-10},{94,24}},
          color={255,170,85},
          smooth=Smooth.Bezier)}));
end Combined;
