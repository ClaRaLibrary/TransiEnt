within TransiEnt.Basics.Icons;
partial class Electrolyser2 "Icon for electrolysers"
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

  annotation(Documentation(info = "<html><p>This is an icon for electrolysers. Electrolysers convert energy <i>E</i> to hydrogen <i>H2</i>.</p><p>The yellow ball represents the energy which is converted into the blue balls of hydrogen</p></html>", revisions = "<html><ul><il>V1.0 Patrick Gttsch<br>first design</il></ul></html>"), Icon(coordinateSystem(extent={{-100,
            -100},{100,100}},                                                                                                    preserveAspectRatio=false,   initialScale = 0.1, grid = {2,2}), graphics={
        Ellipse(
          extent={{32,30},{88,-30}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-88,30},{-32,-30}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),                                                                                                    Rectangle(extent={{
              -60,30},{60,-30}},                                                                                                    fillColor=
              {215,215,215},
            fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Text(
          extent={{62,-2},{90,-20}},
          lineColor={255,226,2},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="2"),
        Rectangle(
          extent={{-60,24},{60,-24}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,18},{60,-18}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,12},{60,-12}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,6},{60,-6}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,18},{-44,-20}},
          lineColor={0,125,125},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="P"),
        Text(
          extent={{32,18},{86,-20}},
          lineColor={255,226,2},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="H"),
        Text(
          extent={{-78,0},{-46,-22}},
          lineColor={0,125,125},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="el")}));
end Electrolyser2;
