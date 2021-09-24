within TransiEnt.SystemGeneration;
package Superstructure

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
        lineColor={128,128,128},
        fillPattern=FillPattern.None,
        extent={{-100,-100},{100,100}},
        radius=25.0),
      Rectangle(
        fillColor={95,95,95},
        fillPattern=FillPattern.Solid,
        extent={{-100,-100},{100,-72}},
        radius=25,
        pattern=LinePattern.None),
      Rectangle(
        extent={{-100,-72},{100,-86}},
        fillColor={0,122,122},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None),
        Line(
          points={{-78,-40},{-78,-20},{-78,0},{-38,0},{-38,-40}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-84,-6},{-58,22},{-32,-6}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-38,-20},{-38,0},{-38,20},{2,20},{2,-20}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-44,14},{-18,42},{8,14}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-72,20},{-72,40},{-72,60},{-32,60},{-32,20}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-78,54},{-52,82},{-26,54}},
          color={0,0,0},
          thickness=0.5),
        Ellipse(
          extent={{0,64},{97,-33}},
          lineColor={0,134,134},
          pattern=LinePattern.Dot),
        Rectangle(
          extent={{40,-55},{58,-61}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{47,15},{49,15},{51,21},{49,63},{47,59},{47,15}},
          lineColor={0,134,134},
          pattern=LinePattern.Dot,
          smooth=Smooth.Bezier,
          fillColor={0,189,189},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{46,12},{50,-56}},
          lineColor={0,0,0},
          pattern=LinePattern.Dot,
          fillColor={135,135,135},
          fillPattern=FillPattern.VerticalCylinder),
        Polygon(
          points={{46,13},{40,7},{10,-11},{6,-11},{44,13},{46,13}},
          lineColor={0,134,134},
          pattern=LinePattern.Dot,
          smooth=Smooth.Bezier,
          fillColor={0,189,189},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{50,11},{56,5},{86,-13},{88,-13},{88,-11},{52,11},{50,11}},
          lineColor={0,134,134},
          pattern=LinePattern.Dot,
          smooth=Smooth.Bezier,
          fillColor={0,189,189},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{45,16},{51,10}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Sphere)}));
end Superstructure;
