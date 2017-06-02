within TransiEnt.Basics.Icons;
model Flywheel
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
  extends Model;

  annotation (Icon(graphics={
        Ellipse(
          extent={{-39,-20},{43,-62}},
          lineColor={0,0,0},
          fillColor={0,134,134},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{-39,-12},{43,-40}},
          lineColor={0,134,134},
          fillColor={0,134,134},
          fillPattern=FillPattern.VerticalCylinder),
        Line(points={{-39,-42},{-38,-8},{42,-10},{43,-42}},color={0,0,0}),
        Ellipse(
          extent={{-39,16},{43,-34}},
          lineColor={0,0,0},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-15,3},{19,-15}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-15,5},{19,-13}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-41,-54},{44,-82}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{-41,69},{44,-68}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.VerticalCylinder),
        Ellipse(
          extent={{-34,52},{38,-66}},
          lineColor={215,215,215},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={215,215,215}),
        Rectangle(
          extent={{-2,36},{-20,-52}},
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95},
          lineColor={0,0,0}),
        Rectangle(
          extent={{24,36},{6,-52}},
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95},
          lineColor={0,0,0}),
        Line(
          points={{2,42},{2,-58}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dot),
        Ellipse(
          extent={{-41,82},{44,54}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-12,36},{18,36}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-14,-52},{16,-52}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-2,28},{2,24}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,28},{6,24}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,-42},{6,-46}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,-42},{2,-46}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-2,24},{2,28}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-2,28},{2,24}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{2,28},{6,24}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{2,24},{6,28}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{2,-42},{6,-46}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{2,-46},{6,-42}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-2,-42},{2,-46}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-2,-46},{2,-42}},
          color={0,0,0},
          smooth=Smooth.None)}));
end Flywheel;
