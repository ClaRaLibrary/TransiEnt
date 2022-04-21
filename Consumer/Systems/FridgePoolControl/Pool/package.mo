within TransiEnt.Consumer.Systems.FridgePoolControl;
package Pool


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
        Rectangle(
          extent={{-42,60},{38,-28}},
          lineColor={0,0,0}),
        Polygon(
          points={{-52,28},{-48,28},{-34,28},{-42,16},{-34,6},{-52,6},{-42,16},{-52,28}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-22,68},{16,52}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,-20},{18,-36}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{26,30},{52,6}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{30,10},{38,30},{48,10}},
          color={0,0,0},
          smooth=Smooth.None)}),
            Icon(graphics={
      Ellipse(extent={{-68,56},{-40,28}}, lineColor={0,0,0}),
      Ellipse(extent={{30,72},{58,44}}, lineColor={0,0,0}),
      Ellipse(extent={{-40,-4},{-12,-32}}, lineColor={0,0,0}),
      Ellipse(extent={{30,-20},{58,-48}}, lineColor={0,0,0}),
      Line(
        points={{-40,46},{30,54}},
        color={0,0,0},
        smooth=Smooth.None),
      Line(
        points={{48,44},{50,-22}},
        color={0,0,0},
        smooth=Smooth.None),
      Line(
        points={{-46,30},{-32,-6}},
        color={0,0,0},
        smooth=Smooth.None),
      Line(
        points={{-12,-24},{30,-38}},
        color={0,0,0},
        smooth=Smooth.None)}));
end Pool;
