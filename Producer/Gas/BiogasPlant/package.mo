within TransiEnt.Producer.Gas;
package BiogasPlant "Package for components of a biogas plant and reactor models"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2020, Hamburg University of Technology.                              //
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

  extends TransiEnt.Basics.Icons.Package;
















  annotation (Icon(graphics={
        Ellipse(
          extent={{-36,-62},{86,-10}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
        extent={{-36,-36},{86,-72}},
        lineColor={95,95,95},
        fillColor={134,134,134},
        fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{-82,-22},{-8,-72}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-76,-26},{-68,-32}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Rectangle(
          extent={{-64,-26},{-56,-32}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Rectangle(
          extent={{-52,-26},{-44,-32}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Rectangle(
          extent={{-28,-26},{-20,-32}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Rectangle(
          extent={{-40,-26},{-32,-32}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215})}));
end BiogasPlant;
