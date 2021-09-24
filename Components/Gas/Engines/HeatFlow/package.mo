within TransiEnt.Components.Gas.Engines;
package HeatFlow

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
          points={{-100,0},{100,0}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier,
          origin={-60,0},
          rotation=90),
        Line(
          points={{-100,0},{100,0}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier,
          origin={60,0},
          rotation=-90),
        Line(
          points={{10,80},{-10,60},{10,40},{-10,20},{10,0},{-10,-20},{10,-40},{
              -10,-60},{10,-80}},
          color={255,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier,
          origin={0,10},
          rotation=-90),
        Line(
          points={{10,80},{-10,60},{10,40},{-10,20},{10,0},{-10,-20},{10,-40},{
              -10,-60},{10,-80}},
          color={255,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier,
          origin={0,-30},
          rotation=270),
        Line(
          points={{10,80},{-10,60},{10,40},{-10,20},{10,0},{-10,-20},{10,-40},{
              -10,-60},{10,-80}},
          color={255,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier,
          origin={0,50},
          rotation=-90),
        Polygon(
          points={{2,-5},{6,5},{-6,3},{2,-5}},
          lineColor={255,0,0},
          lineThickness=0.5,
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={80,39},
          rotation=-90),
        Polygon(
          points={{2,-5},{6,5},{-6,3},{2,-5}},
          lineColor={255,0,0},
          lineThickness=0.5,
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={80,-1},
          rotation=-90),
        Polygon(
          points={{2,-5},{6,5},{-6,3},{2,-5}},
          lineColor={255,0,0},
          lineThickness=0.5,
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={82,-41},
          rotation=-90)}));
end HeatFlow;
