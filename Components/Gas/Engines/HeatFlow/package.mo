within TransiEnt.Components.Gas.Engines;
package HeatFlow
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
