within TransiEnt.Basics.Icons;
partial model ExpansionVessel
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
 extends TransiEnt.Basics.Icons.Model;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-62,78},{62,-82}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,0,0},
          radius=10),
        Ellipse(
          extent={{-62,48},{61,-23}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-62,70},{61,-2}},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215},
          radius=11,
          lineColor={0,0,0}),
        Text(
          extent={{-24,38},{24,4}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="p=const
"),     Rectangle(
          extent={{-62,70},{62,-82}},
          lineColor={0,0,0},
          radius=10),
        Line(
          points={{0,-82},{0,-100}},
          color={0,0,0},
          smooth=Smooth.None,
          thickness=1)}));

end ExpansionVessel;
