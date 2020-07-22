within TransiEnt.Components.Electrical.Grid.Components;
model CapacitorComplex "Modell for a specific Capacitor. Capacitance will be calculated from length and specific capacitance, based on ComplexPowerPort"

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

  extends Base.PartialSpecificElement1PinComplex;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

protected
  final parameter SI.Capacitance C = c * l "Capacitance of SpecificCapacitor";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

public
  parameter TransiEnt.Basics.Units.SpecificCapacitance c=1 "specific capacitance";
  outer TransiEnt.SimCenter simCenter;
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
  //protected

  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

equation
    Z.re = 0;
    Z.im = -1 / (2 * Modelica.Constants.pi * simCenter.f_n * C);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  annotation(Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100,-100},{100,100}}), graphics), Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100,-100},{100,100}}), graphics={  Text(extent = {{-60,19},{60,-19}}, lineColor = {0,0,0}, fillColor = {255,255,255},
            fillPattern =                                                                                                   FillPattern.Solid, textString = "c=%c
l=%l", origin = {74,1}, rotation = 90),Text(extent = {{-59,19},{59,-19}}, lineColor = {0,0,0}, fillColor = {255,255,255},
            fillPattern =                                                                                                   FillPattern.Solid, origin = {-65,9}, rotation = 90),Line(points = {{-40,0},{40,0}}, color = {0,0,0}, smooth = Smooth.None, origin = {0,60}, rotation = 90),Line(points = {{0,40},{0,-40}}, color = {0,0,255}, smooth = Smooth.None, origin = {0,20}, rotation = 90),Line(points = {{0,40},{0,-40}}, color = {0,0,255}, smooth = Smooth.None, origin = {0,0}, rotation = 90),Line(points={{
              20,1.69959e-015},{80,6.09842e-015}},                                                                                                    color = {0,0,0}, smooth = Smooth.None, origin={0,
              -80},                                                                                                    rotation = 90),Line(points={{
              -30,-60},{30,-60}},                                                                                                    color = {0,0,0}, smooth = Smooth.None),Line(points={{
              -20,-70},{20,-70}},                                                                                                    color = {0,0,0}, smooth = Smooth.None),Line(points={{
              -8,-80},{10,-80}},                                                                                                    color = {0,0,0}, smooth = Smooth.None)}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model of Capacitor using the ComplexPowerInterface</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L3E, Quasi-stationary model with complex value calculation</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">All know limitation of quasi-stationary fixed-frequency modeling</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Complex Power Ports for modeling a one pin</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">U=Z*I</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">S=U*I*</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Kirchhoff's Equations</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model can be used for modeling capacitors</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">validated by Jan-Peter Heckel (jan.heckel@tuhh.de)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in January 2018 </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Based on model by Pattrick Göttsch, Pascal Dubucq (dubucq@tuhh.de) and Rebekka Denninger (rebekka.denninger@tuhh.de) from March 2016</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified to new interface ComplexPowerPort when created</span></p>
</html>"));
end CapacitorComplex;
