within TransiEnt.Consumer.Systems;
package HeatpumpSystems

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
          extent={{-44,54},{36,-34}},
          lineColor={0,0,0}),
        Polygon(
          points={{-54,22},{-50,22},{-36,22},{-44,10},{-36,0},{-54,0},{-44,10},{-54,22}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-24,62},{14,46}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-22,-26},{16,-42}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{24,24},{50,0}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{28,4},{36,24},{46,4}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-26,36},{-26,-10},{22,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-26,-8},{-22,0},{-10,18},{-8,20},{0,26},{10,30},{18,30}},
          color={0,0,255},
          smooth=Smooth.None)}));
end HeatpumpSystems;
