within TransiEnt.Producer.Electrical;
package Conventional "Models of conventional power plants i.e. based on thermodynamic cycles"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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
        Rectangle(
          extent={{-46,48},{-32,-30}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{-54,-10},{20,-60}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-46,-14},{-38,-20}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Rectangle(
          extent={{-34,-14},{-26,-20}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Rectangle(
          extent={{-22,-14},{-14,-20}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Rectangle(
          extent={{-10,-14},{-2,-20}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Rectangle(
          extent={{2,-14},{10,-20}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Rectangle(
          extent={{6,10},{56,-60}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.VerticalCylinder),
        Polygon(
          points={{10,16},{16,16},{36,14},{48,14},{52,14},{70,26},{70,34},{68,
            42},{68,44},{70,52},{70,54},{66,54},{56,52},{56,50},{52,48},{50,46},
            {40,40},{38,38},{36,38},{34,34},{30,30},{28,30},{24,26},{20,24},{14,
            22},{14,20},{10,20},{10,16}},
          lineColor={95,95,95},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,52},{-38,52},{-36,52},{-30,52},{-28,54},{-18,60},{-16,60},
            {-4,68},{0,70},{4,72},{6,74},{10,76},{12,78},{18,82},{20,82},{22,84},
            {24,88},{22,88},{16,90},{12,90},{6,92},{4,90},{2,88},{2,84},{0,80},
            {-4,78},{-12,74},{-18,72},{-20,68},{-24,66},{-26,64},{-30,62},{-32,
            60},{-34,58},{-36,56},{-38,56},{-42,56},{-42,52}},
          lineColor={95,95,95},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid)}));
end Conventional;
