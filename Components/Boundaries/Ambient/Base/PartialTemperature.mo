within TransiEnt.Components.Boundaries.Ambient.Base;
partial model PartialTemperature

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Ambient.TemperatureOut value annotation (Placement(transformation(extent={{78,-10},{98,10}}), iconTransformation(extent={{78,-10},{98,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                   graphics={
        Ellipse(
          extent={{-20,-96},{20,-58}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-12,42},{12,-66}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-12,42},{-12,82},{-10,88},{-6,90},{0,92},{6,90},{10,88},{12,82},{12,42},{-12,42}},
          lineColor={0,0,0},
          lineThickness=0.5),
        Line(points={{-40,62},{-12,62}}, color={0,0,0}),
        Line(points={{-40,22},{-12,22}}, color={0,0,0}),
        Line(points={{-40,-18},{-12,-18}}, color={0,0,0}),
        Line(points={{12,-8},{60,-8}},
                                     color={0,0,127})}),
                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end PartialTemperature;
