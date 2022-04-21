within TransiEnt.Grid.Electrical;
package GridConnector "Connection of grid nodes"


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
        Line(
          points={{-50,-36},{-10,-16}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-10,-16},{50,4}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-10,-16},{10,24}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-10,-16},{2,-48}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{2,-48},{-26,-52},{-50,-36}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{44,36},{50,4}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{44,36},{10,24}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{10,24},{50,4}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-10,-18},{50,2}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-10,-16},{-36,64}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-36,64},{10,24}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-80,20},{-50,-36}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-80,20},{-36,64}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-80,20},{-10,-16}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{84,64},{50,4}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{84,64},{44,36}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{16,50},{44,36}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{16,50},{10,24}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{84,64},{16,50}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-36,64},{16,50}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{44,38},{10,26}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{14,50},{8,24}},
          color={0,0,0},
          thickness=0.5)}));
end GridConnector;
