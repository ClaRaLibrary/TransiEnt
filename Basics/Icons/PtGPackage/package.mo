within TransiEnt.Basics.Icons;
package PtGPackage "Icon for PtG package"
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
extends Package;


annotation (Icon(graphics={
        Rectangle(
        extent={{-76,74},{76,-54}},
        lineColor={0,134,134},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(
        points={{76,74},{-76,-54}},
        color={0,134,134},
        smooth=Smooth.None),
        Text(
          extent={{-46,32},{-24,4}},
          lineColor={0,134,134},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
        textString="P"),
        Text(
          extent={{14,-6},{28,-26}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="H"),
        Text(
          extent={{54,-34},{66,-48}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="2")}));
end PtGPackage;
