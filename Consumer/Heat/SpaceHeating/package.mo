within TransiEnt.Consumer.Heat;
package SpaceHeating

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
        Rectangle(
          extent={{-64,60},{72,-44}},
          lineColor={135,135,135},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-52,46},{60,-32}},
          lineColor={135,135,135},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
        points={{-28,0},{-18,6}},
        color={255,0,0},
        origin={-26,-14},
        rotation=90,
        thickness=0.5),
        Line(
        points={{28,0},{18,6}},
        color={255,0,0},
        origin={-32,-60},
        rotation=90,
        thickness=0.5),
        Line(
          points={{-28,0},{-10,-8.19501e-016}},
          color={255,0,0},
          origin={-32,-22},
          rotation=90,
          thickness=0.5),
        Line(
        points={{-28,0},{-18,6}},
        color={255,0,0},
        origin={10,-14},
        rotation=90,
        thickness=0.5),
        Line(
        points={{28,0},{18,6}},
        color={255,0,0},
        origin={4,-60},
        rotation=90,
        thickness=0.5),
        Line(
          points={{-28,0},{-10,-8.19501e-016}},
          color={255,0,0},
          origin={4,-22},
          rotation=90,
          thickness=0.5),
        Line(
        points={{-28,0},{-18,6}},
        color={255,0,0},
        origin={40,-14},
        rotation=90,
        thickness=0.5),
        Line(
        points={{28,0},{18,6}},
        color={255,0,0},
        origin={34,-60},
        rotation=90,
        thickness=0.5),
        Line(
          points={{-28,0},{-10,-8.19501e-016}},
          color={255,0,0},
          origin={34,-22},
          rotation=90,
          thickness=0.5)}));
end SpaceHeating;
