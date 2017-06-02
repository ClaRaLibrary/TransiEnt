within TransiEnt.Basics.Icons;
model SystemOperator
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
        Rectangle(extent={{-58,52},{60,-22}}, lineColor={95,95,95}),
        Rectangle(
          extent={{-16,46},{56,-16}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-53,40},{-47,34}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-27,40},{-21,34}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-40,40},{-34,34}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-40,26},{-34,20}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-53,26},{-47,20}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-27,26},{-21,20}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-52,13},{-48,-9}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-39,13},{-35,-9}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-26,13},{-22,-9}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-58,-22},{60,-47}}, lineColor={95,95,95}),
        Rectangle(
          extent={{-7,51},{7,-51}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid,
          origin={1,-35},
          rotation=90)}));
end SystemOperator;
