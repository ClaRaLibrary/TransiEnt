within TransiEnt.Components.Gas.Engines;
package Mechanics
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
        Ellipse(
          extent={{-72,2},{-12,-58}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-21,-8},{-19,-18},{-7,-18},{-5,-8},{-13,22},{-21,-8}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-55,-6},
          rotation=180),
        Polygon(
          points={{-21,-8},{-19,-18},{-7,-18},{-5,-8},{-13,22},{-21,-8}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-21,-16},
          rotation=90),
        Polygon(
          points={{-21,-8},{-19,-18},{-7,-18},{-5,-8},{-13,22},{-21,-8}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-29,-50},
          rotation=0),
        Polygon(
          points={{-21,-8},{-19,-18},{-7,-18},{-5,-8},{-13,22},{-21,-8}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-63,-42},
          rotation=-90),
        Polygon(
          points={{2,-7},{10,-13},{20,-5},{14,5},{-13,22},{2,-7}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-21,-16},
          rotation=90),
        Polygon(
          points={{2,-7},{12,-13},{20,-5},{14,5},{-13,22},{2,-7}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-55,-8},
          rotation=180),
        Polygon(
          points={{2,-7},{12,-13},{20,-5},{14,5},{-13,22},{2,-7}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-63,-42},
          rotation=270),
        Polygon(
          points={{2,-7},{12,-13},{20,-5},{14,5},{-13,22},{2,-7}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-29,-48},
          rotation=360),
        Ellipse(
          extent={{-30,70},{30,10}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-21,-8},{-19,-18},{-7,-18},{-5,-8},{-13,22},{-21,-8}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-13,62},
          rotation=180),
        Polygon(
          points={{-21,-8},{-19,-18},{-7,-18},{-5,-8},{-13,22},{-21,-8}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={21,52},
          rotation=90),
        Polygon(
          points={{-21,-8},{-19,-18},{-7,-18},{-5,-8},{-13,22},{-21,-8}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={13,18},
          rotation=0),
        Polygon(
          points={{-21,-8},{-19,-18},{-7,-18},{-5,-8},{-13,22},{-21,-8}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-21,26},
          rotation=-90),
        Polygon(
          points={{2,-7},{10,-13},{20,-5},{14,5},{-13,22},{2,-7}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={21,52},
          rotation=90),
        Polygon(
          points={{2,-7},{12,-13},{20,-5},{14,5},{-13,22},{2,-7}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-13,60},
          rotation=180),
        Polygon(
          points={{2,-7},{12,-13},{20,-5},{14,5},{-13,22},{2,-7}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-21,26},
          rotation=270),
        Polygon(
          points={{2,-7},{12,-13},{20,-5},{14,5},{-13,22},{2,-7}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={11,20},
          rotation=360),
        Ellipse(
          extent={{14,2},{74,-58}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-21,-8},{-19,-18},{-7,-18},{-5,-8},{-13,22},{-21,-8}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={31,-6},
          rotation=180),
        Polygon(
          points={{-21,-8},{-19,-18},{-7,-18},{-5,-8},{-13,22},{-21,-8}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={65,-16},
          rotation=90),
        Polygon(
          points={{-21,-8},{-19,-18},{-7,-18},{-5,-8},{-13,22},{-21,-8}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={57,-50},
          rotation=0),
        Polygon(
          points={{-21,-8},{-19,-18},{-7,-18},{-5,-8},{-13,22},{-21,-8}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={23,-42},
          rotation=-90),
        Polygon(
          points={{2,-7},{10,-13},{20,-5},{14,5},{-13,22},{2,-7}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={65,-16},
          rotation=90),
        Polygon(
          points={{2,-7},{12,-13},{20,-5},{14,5},{-13,22},{2,-7}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={31,-8},
          rotation=180),
        Polygon(
          points={{2,-7},{12,-13},{20,-5},{14,5},{-13,22},{2,-7}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={23,-42},
          rotation=270),
        Polygon(
          points={{2,-7},{12,-13},{20,-5},{14,5},{-13,22},{2,-7}},
          lineColor={0,0,255},
          smooth=Smooth.Bezier,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={57,-48},
          rotation=360),
        Ellipse(
          extent={{-10,50},{8,32}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-52,-18},{-34,-36}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{34,-18},{52,-36}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}));
end Mechanics;
