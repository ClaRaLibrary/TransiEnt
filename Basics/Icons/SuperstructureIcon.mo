within TransiEnt.Basics.Icons;
model SuperstructureIcon



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




  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          lineColor={0,125,125},
          fillColor=DynamicSelect({255,255,255}, {min(1, max(0, (2 - ((-epp.P - localRenewableProduction.epp.P)/localDemand.epp.P))))*255,min(1, max(0, ((-epp.P - localRenewableProduction.epp.P)/localDemand.epp.P)))*255,0}),
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Line(
          points={{-80,-40},{-80,-20},{-80,0},{-40,0},{-40,-40}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-86,-6},{-60,22},{-34,-6}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-32,-20},{-32,0},{-32,20},{8,20},{8,-20}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-38,14},{-12,42},{14,14}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-74,20},{-74,40},{-74,60},{-34,60},{-34,20}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-80,54},{-54,82},{-28,54}},
          color={0,0,0},
          thickness=0.5),
        Ellipse(
          extent={{6,62},{103,-35}},
          lineColor={0,134,134},
          pattern=LinePattern.Dot),
        Rectangle(
          extent={{46,-55},{64,-61}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{53,15},{55,15},{57,21},{55,63},{53,59},{53,15}},
          lineColor={0,134,134},
          pattern=LinePattern.Dot,
          smooth=Smooth.Bezier,
          fillColor={0,189,189},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{52,12},{56,-56}},
          lineColor={0,0,0},
          pattern=LinePattern.Dot,
          fillColor={135,135,135},
          fillPattern=FillPattern.VerticalCylinder),
        Polygon(
          points={{52,13},{46,7},{16,-11},{12,-11},{50,13},{52,13}},
          lineColor={0,134,134},
          pattern=LinePattern.Dot,
          smooth=Smooth.Bezier,
          fillColor={0,189,189},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{56,11},{62,5},{92,-13},{94,-13},{94,-11},{58,11},{56,11}},
          lineColor={0,134,134},
          pattern=LinePattern.Dot,
          smooth=Smooth.Bezier,
          fillColor={0,189,189},
          fillPattern=FillPattern.Solid),
        Line(points={{-6,54}}, color={28,108,200}),
        Ellipse(
          extent={{51,16},{57,10}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Sphere)}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end SuperstructureIcon;
