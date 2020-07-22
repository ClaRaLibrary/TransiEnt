within TransiEnt.Components.Electrical.PowerTransformation;
model SimpleTransformerComplex "Transformer modell of a predefined Dy with simple efficiency modell, based on ComplexPowerPort"

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
  parameter Real CalcRatio = if UseRatio == true then ratio else U_P / (U_S);

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

public
  parameter Boolean UseInput = false "Gets parameter ratio from input connector"  annotation(choices(__Dymola_checkBox = true), Dialog(group = "transformer properties"));
  parameter Boolean UseRatio = false "True: Use ratio value to calculate LV Voltage; False: Use MV and LV Voltage to calculate ratio"
                                                                                            annotation(choices(__Dymola_checkBox = true), Dialog(group = "transformer properties"));
  parameter Real ratio = 25 "turn ratio" annotation(Dialog(enable = UseRatio and not UseInput, group = "transformer properties"));
  parameter SI.Voltage U_P = 10e3 "high voltage side" annotation(Dialog(enable = not UseRatio and not UseInput, group = "transformer properties"));
  parameter SI.Voltage U_S = 400/sqrt(3) "low voltage side" annotation(Dialog(enable = not UseRatio and not UseInput, group = "transformer properties"));
  parameter Real eta( min = 0, max = 1) = 1 "efficiency of transformer" annotation(Dialog(group = "transformer properties"));

  // _____________________________________________
  //
  //                  Variables
  // _____________________________________________

  SI.Voltage v_p(start=U_P);
  SI.Voltage v_n(start=U_S);
  SI.ActivePower P_p(start=0);
  SI.ActivePower P_n(start=0);

protected
  Modelica.Blocks.Interfaces.RealInput ratio_internal "Needed to connect to conditional connector for ratio input";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
public
  TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp_p annotation (Placement(transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp_n annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));

  Modelica.Blocks.Interfaces.RealInput ratio_set if              UseInput "fixed ratio input"
                                                                 annotation (Placement(transformation(extent={{-140,60},{-100,100}},
          rotation=0), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-60,120})));

  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

equation

     epp_p.f = epp_n.f;

   Connections.branch(epp_p.f,epp_n.f);
    if (P_p > 0) and eta<>1 then
      P_p * eta + P_n = 0;
    else
     P_p * 1/eta + P_n = 0;
    end if;

    if not UseInput then
        ratio_internal= CalcRatio;

    end if;


  epp_p.Q + epp_n.Q = 0;
  epp_p.v = ratio_internal * epp_n.v;

  epp_p.delta=epp_n.delta;

  epp_p.v=v_p;
  epp_n.v=v_n;

  epp_p.P=P_p;
  epp_n.P=P_n;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(ratio_internal,ratio_set);
  annotation(Icon(coordinateSystem(preserveAspectRatio=false,   extent={{-100,-100},{100,100}}), graphics={
        Line(
          points={{-92,0},{-58,0},{90,0}},
          color={0,0,0},
          smooth=Smooth.None),
                             Ellipse(
          extent={{-24,36},{50,-34}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Ellipse(
          extent={{-58,36},{16,-34}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-82,14},{-72,0}},
          lineColor={0,128,0},
          textString="1"),
        Text(
          extent={{68,14},{78,0}},
          lineColor={0,128,0},
          textString="2"),
        Text(
          extent={{-34,72},{30,46}},
          lineColor={0,0,0},
          textString="\\eta")}), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Simple model of a power transformer. Losses are specified by constant parameter.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L1E (defined in the CodingConventions) Only the ratio and efficiency of the transformer used.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">No reactance or resistance for modeling the transformer. No dynamics. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Two Complex Power Ports for modeling a two pin</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">U1=ratio*U2</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Do not use for short circuit calculation.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">validated by Jan-Peter Heckel (jan.heckel@tuhh.de)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in January 2018 </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Based on model by Pattrick Göttsch and Pascal Dubucq (dubucq@tuhh.de) from October 2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified to new interface ComplexPowerPort when created</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Ratio as an input by Jan-Peter Heckel (jan.heckel@tuhh.de) in May 2019</span></p>
</html>"));
end SimpleTransformerComplex;
