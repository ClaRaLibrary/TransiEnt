within TransiEnt.Components.Electrical.PowerTransformation;
model TransformerPiModelComplex "Transformer modell with pi-Model"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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

//   parameter SI.Reactance X_P( min = 0) = 0.01309 "Primary reactance" annotation(Dialog(group="lose properties"));
//   parameter SI.Reactance X_S( min = 0) = X_P "Secundary reactance" annotation(Dialog(group="lose properties"));
//   parameter SI.Resistance R_P( min = 0) = 0.00272 "Primary resistance" annotation(Dialog(group="lose properties"));
//   parameter SI.Resistance R_S( min= 0) = R_P "Secundary resistance" annotation(Dialog(group="lose properties"));
  parameter Modelica.SIunits.Reactance X_h=80e3 "Main Reactance, applied on primary side" annotation(Dialog(group="lose properties"));
  parameter Modelica.SIunits.Resistance R_Cu=2 "Copper Resistance, applied on primary side" annotation(Dialog(group="lose properties"));
  parameter Modelica.SIunits.Reactance X_sigma=35 "Stray Reactance, applied on primary side" annotation(Dialog(group="lose properties"));
  parameter Modelica.SIunits.Resistance R_Fe=400e3 "Iron Resistance, applied on primary side" annotation(Dialog(group="lose properties"));

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

  Components.PiModelTransformerComplexComponent piModelTransformerComplexComponent(
    X_h=X_h,
    R_Cu=R_Cu,
    X_sigma=X_sigma,
    R_Fe=R_Fe)   annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  // _____________________________________________
  //
  //                  Variables
  // _____________________________________________

  SI.Current i_1_mag;
  SI.Current i_2_mag;
  SI.Current i_g_mag;
  Boolean overload(start=false);
  Real usage;

   // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________


equation

  i_1_mag=Modelica.ComplexMath.'abs'(piModelTransformerComplexComponent.i_p);
  i_2_mag=Modelica.ComplexMath.'abs'(piModelTransformerComplexComponent.i_n);

if i_1_mag > i_2_mag then
  i_g_mag=i_1_mag;
else
  i_g_mag=i_2_mag;
end if;

if i_g_mag>(i_r*sqrt(3)) then
  overload=true;
else
  overload=false;
end if;

usage=i_g_mag/(i_r*sqrt(3));
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(simpleTransformer.epp_n, epp_n) annotation (Line(
      points={{10,0},{100,0}},
      color={28,108,200},
      thickness=0.5));
  connect(piModelTransformerComplexComponent.epp_p, epp_p) annotation (Line(
      points={{-60,0},{-100,0}},
      color={28,108,200},
      thickness=0.5));
  connect(piModelTransformerComplexComponent.epp_n, simpleTransformer.epp_p) annotation (Line(
      points={{-40,0},{-10,0}},
      color={28,108,200},
      thickness=0.5));
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
          textString="2")}),                                                                               Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Advanced model of a power transformer as pi model</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L3E (defined in the CodingConventions), Quasi-stationary model with complex value calculation</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">All know limitation of quasi-stationary fixed-frequency modeling</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Two Complex Power Ports for modeling a two pin</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Two-Port Equations</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">see Checkmodel TransiEnt.Components.Electrical.PowerTransformation.Check.TestTransformerPiModelComplex</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in May 2019 </span></p>
</html>"));
end TransformerPiModelComplex;
