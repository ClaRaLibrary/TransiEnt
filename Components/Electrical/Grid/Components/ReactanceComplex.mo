within TransiEnt.Components.Electrical.Grid.Components;
model ReactanceComplex "Modell for a specific Reactance. Reactance will be calculated from length and specific reactance, based on ComplexPowerPort"

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
  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends Base.PartialSpecificElement2PinComplex;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

protected
  final parameter SI.Reactance X = x * l "Reactance of SpecificReactance";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

public
  parameter TransiEnt.Basics.Units.SpecificReactance x=1 "specific reactance";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  //public

  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  //initial equation
equation

    Z.re = 0;
    Z.im = X;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation(Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100,-100},{100,100}}), graphics), Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100,-100},{100,100}}), graphics={  Line(points = {{-100,0},{100,0}}, color = {0,0,0}, smooth = Smooth.None),Rectangle(extent = {{-60,32},{60,-30}}, lineColor = {0,0,255}, fillColor = {0,0,255},
            fillPattern =                                                                                                   FillPattern.Solid),Text(extent = {{-62,88},{58,50}}, lineColor = {0,0,0}, fillColor = {255,255,255},
            fillPattern =                                                                                                   FillPattern.Solid, textString = "x=%x
l=%l"),Text(extent = {{-62,-36},{56,-74}}, lineColor = {0,0,0}, fillColor = {255,255,255},
            fillPattern =                                                                                FillPattern.Solid)}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model of Reactance using the ComplexPowerInterface</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L3E, Quasi-stationary model with complex value calculation</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">All know limitation of quasi-stationary fixed-frequency modeling</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Two Complex Power Ports for modeling a two pin</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">U=Z*I</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">S=U*I*</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Kirchhoff's Equations</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model can be used for modeling reactances</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">validated by Jan-Peter Heckel (jan.heckel@tuhh.de)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in January 2018 </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Based on model by Pattrick Göttsch, Pascal Dubucq (dubucq@tuhh.de) and Rebekka Denninger (rebekka.denninger@tuhh.de) from march 2016</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified to new interface ComplexPowerPort when created</span></p>
</html>"));
end ReactanceComplex;
