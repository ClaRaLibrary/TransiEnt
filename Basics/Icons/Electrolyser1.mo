within TransiEnt.Basics.Icons;
partial class Electrolyser1 "Icon for electrolysers"
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
extends TransiEnt.Basics.Icons.Package;

  annotation(Documentation(info = "<html><p>This is an icon for electrolysers. Electrolysers convert energy <i>E</i> to hydrogen <i>H2</i>.</p><p>The yellow ball represents the energy which is converted into the blue balls of hydrogen</p></html>", revisions = "<html><ul><il>V1.0 Patrick Gttsch<br>first design</il></ul></html>"), Icon(coordinateSystem(extent = {{-100,-100},{100,100}}, preserveAspectRatio = false, initialScale = 0.1, grid = {2,2}), graphics={
                                                                                              Ellipse(origin={
              25.718,34.1269},                                                                                                    fillColor = {85,170,255},
            fillPattern =                                                                                                   FillPattern.Solid, extent={{
              40.282,37.8731},{-40.282,-37.8731}},                                                                                                    endAngle = 360),Ellipse(origin={28,
              -16},                                                                                                    fillColor = {85,170,255},
            fillPattern =                                                                                                   FillPattern.Solid, extent={{
              40,38},{-40,-38}},                                                                                                    endAngle = 360),                                                                                                    Ellipse(origin={
              -44.586,16.8182},                                                                                                    fillColor = {255,255,0},
            fillPattern =                                                                                                   FillPattern.Solid, extent={{
              -29.414,29.1818},{50.586,-44.8182}},                                                                                                    endAngle = 360)}));
end Electrolyser1;
