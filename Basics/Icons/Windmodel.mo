within TransiEnt.Basics.Icons;
model Windmodel
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE and ResiliEntEE are research projects supported by the German     //
// Federal Ministry of Economics and Energy (FKZ 03ET4003 and 03ET4048).          //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Institute of Electrical Power Systems and Automation                           //
// (Hamburg University of Technology)                                             //
// and is supported by                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
                                   Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Ellipse(
          extent={{-49,58},{48,-39}},
          lineColor={0,134,134},
          pattern=LinePattern.Dot),
        Rectangle(
          extent={{-9,-61},{9,-67}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-1,12},{1,12},{4,18},{1,60},{-1,56},{-1,12}},
          lineColor={0,134,134},
          pattern=LinePattern.Dot,
          smooth=Smooth.Bezier,
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,7},{2,-61}},
          lineColor={0,0,0},
          pattern=LinePattern.Dot,
          fillColor={95,95,95},
          fillPattern=FillPattern.VerticalCylinder),
        Polygon(
          points={{-2,10},{-8,4},{-38,-14},{-42,-14},{-4,10},{-2,10}},
          lineColor={0,134,134},
          pattern=LinePattern.Dot,
          smooth=Smooth.Bezier,
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{2,10},{8,4},{38,-14},{40,-14},{40,-12},{4,10},{2,10}},
          lineColor={0,134,134},
          pattern=LinePattern.Dot,
          smooth=Smooth.Bezier,
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-3,12},{3,6}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Sphere)}),
                                      Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end Windmodel;
