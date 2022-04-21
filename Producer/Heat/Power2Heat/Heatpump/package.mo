within TransiEnt.Producer.Heat.Power2Heat;
package Heatpump



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




  extends TransiEnt.Basics.Icons.CheckPackage;








  annotation (Icon(graphics={
      Rectangle(
        extent={{-70,74},{68,-68}},
        lineColor={28,108,200},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None),
        Rectangle(
          extent={{-42,44},{38,-44}},
          lineColor={0,0,0}),
        Polygon(
          points={{-52,12},{-48,12},{-34,12},{-42,0},{-34,-10},{-52,-10},{-42,0},{-52,12}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-22,52},{16,36}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,-36},{18,-52}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{26,14},{52,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{30,-6},{38,14},{48,-6}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-24,26},{-24,-20},{24,-20}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-24,-18},{-20,-10},{-8,8},{-6,10},{2,16},{12,20},{20,20}},
          color={0,0,255},
          smooth=Smooth.None)}));
end Heatpump;
