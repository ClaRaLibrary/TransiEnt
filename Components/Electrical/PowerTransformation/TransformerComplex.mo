within TransiEnt.Components.Electrical.PowerTransformation;
model TransformerComplex "Transformer modell for a predefined Dy with losses and stray inductance, based on ComplexPowerPort"

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
  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

protected
  parameter SI.Length l = 1;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

public
  parameter Boolean UseRatio = false "True: Use ratio value to calculate LV Voltage; False: Use MV and LV Voltage to calculate ratio"
                                                                                            annotation(choices(__Dymola_checkBox = true), Dialog(group = "transformer properties"));
  parameter Real ratio = 25 "turn ratio" annotation(Dialog(enable = UseRatio, group = "transformer properties"));

   parameter SI.Voltage U_P = 10e3 "high voltage side" annotation(Dialog(enable = not UseRatio, group = "transformer properties"));
  parameter SI.Voltage U_S = 400/sqrt(3) "low voltage side" annotation(Dialog(enable = not UseRatio, group = "transformer properties"));

  parameter SI.Reactance X_P( min = 0) = 0.01309 "Primary reactance" annotation(Dialog(group="lose properties"));
  parameter SI.Reactance X_S( min = 0) = X_P "Secundary reactance" annotation(Dialog(group="lose properties"));
  parameter SI.Resistance R_P( min = 0) = 0.00272 "Primary resistance" annotation(Dialog(group="lose properties"));
  parameter SI.Resistance R_S( min= 0) = R_P "Secundary resistance" annotation(Dialog(group="lose properties"));
  parameter SI.Current i_r = 1000 "rated current" annotation(Dialog(group="transformer properties"));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Basics.Interfaces.Electrical.ComplexPowerPort epp_p annotation (Placement(transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  Basics.Interfaces.Electrical.ComplexPowerPort epp_n annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  SimpleTransformerComplex simpleTransformer(
    ratio=ratio,
    UseRatio=UseRatio,
    U_P=U_P,
    U_S=U_S) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TransiEnt.Components.Electrical.Grid.Components.ResistorComplex specificResistorEPP2_1(r=R_P/l) annotation (Placement(transformation(extent={{-74,-10},{-54,10}})));
  TransiEnt.Components.Electrical.Grid.Components.ResistorComplex specificResistorEPP2_2(r=R_S/l) annotation (Placement(transformation(extent={{18,-10},{38,10}})));
  TransiEnt.Components.Electrical.Grid.Components.ReactanceComplex specificReactanceEPP2_1(x=X_P/l) annotation (Placement(transformation(extent={{-44,-10},{-24,10}})));
  TransiEnt.Components.Electrical.Grid.Components.ReactanceComplex specificReactanceEPP2_2(x=X_S/l) annotation (Placement(transformation(extent={{50,-10},{70,10}})));



  // _____________________________________________
  //
  //                  Variables
  // _____________________________________________


  SI.Current i_abs;
  Boolean overload(start=false);
  Real usage;



   // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________



equation

  i_abs
     =Modelica.ComplexMath.'abs'(specificResistorEPP2_1.I);

if i_abs>i_r*sqrt(3) then
  overload=true;
else
  overload=false;
end if;

usage=i_abs/(i_r*sqrt(3));



  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(specificResistorEPP2_1.epp_p,epp_p) annotation(Line(points = {{-74,0},{-100,0}}, color = {0,127,0}, smooth = Smooth.None));
  connect(simpleTransformer.epp_n,specificResistorEPP2_2.epp_p) annotation(Line(points = {{10,0},{18,0}}, color = {0,127,0}, smooth = Smooth.None));
  connect(specificReactanceEPP2_1.epp_n,simpleTransformer.epp_p) annotation(Line(points = {{-24,0},{-10,0}}, color = {0,127,0}, smooth = Smooth.None));
  connect(specificReactanceEPP2_1.epp_p,specificResistorEPP2_1.epp_n) annotation(Line(points = {{-44,0},{-54,0}}, color = {0,127,0}, smooth = Smooth.None));
  connect(specificResistorEPP2_2.epp_n,specificReactanceEPP2_2.epp_p) annotation(Line(points = {{38,0},{50,0}}, color = {0,127,0}, smooth = Smooth.None));
  connect(specificReactanceEPP2_2.epp_n,epp_n) annotation(Line(points = {{70,0},{100,0}}, color = {0,127,0}, smooth = Smooth.None));
  annotation(Icon(graphics={
        Line(
          points={{-90,-2},{-56,-2},{92,-2}},
          color={0,0,0},
          smooth=Smooth.None),
                             Ellipse(
          extent={{-22,34},{52,-36}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Ellipse(
          extent={{-56,34},{18,-36}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-80,12},{-70,-2}},
          lineColor={0,128,0},
          textString="1"),
        Text(
          extent={{70,12},{80,-2}},
          lineColor={0,128,0},
          textString="2")}),                                                                               Diagram(graphics,
                                                                                                                   coordinateSystem(preserveAspectRatio = false, extent = {{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Advanced model of a power transformer. Losses are computed based on resistance and reactance of transformer windings.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L3E (defined in the CodingConventions), Quasi-stationary model with complex value calculation</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">All know limitation of quasi-stationary fixed-frequency modeling</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Two Complex Power Ports for modeling a two pin</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">electric network with simple transformer, reactance and resistance (in series on primary and secondary side)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in January 2018 </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Based on model by Pattrick Göttsch and Pascal Dubucq (dubucq@tuhh.de) from October 2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified to new interface ComplexPowerPort when created</span></p>
</html>"));
end TransformerComplex;
