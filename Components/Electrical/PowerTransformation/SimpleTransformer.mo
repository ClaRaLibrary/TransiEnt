within TransiEnt.Components.Electrical.PowerTransformation;
model SimpleTransformer "Transformer modell of a predefined Dy with simple efficiency modell"

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
  parameter Boolean UseRatio = false "True: Use ratio value to calculate LV Voltage; False: Use MV and LV Voltage to calculate ratio"
                                                                                            annotation(choices(__Dymola_checkBox = true), Dialog(group = "transformer properties"));
  parameter Real ratio = 25 "turn ratio" annotation(Dialog(enable = UseRatio, group = "transformer properties"));
  parameter SI.Voltage U_P = 10e3 "high voltage side" annotation(Dialog(enable = not UseRatio, group = "transformer properties"));
  parameter SI.Voltage U_S = 400/sqrt(3) "low voltage side" annotation(Dialog(enable = not UseRatio, group = "transformer properties"));
  parameter Real eta( min = 0, max = 1) = 1 "efficiency of transformer" annotation(Dialog(group = "transformer properties"));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Basics.Interfaces.Electrical.ApparentPowerPort epp_p annotation (Placement(transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  Basics.Interfaces.Electrical.ApparentPowerPort epp_n annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));

  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  //initial equation
equation
    if (epp_p.P > 0) then
      epp_p.P * eta + epp_n.P = 0;
    else
      epp_p.P * 1/eta + epp_n.P = 0;
    end if;

  epp_p.Q + epp_n.Q = 0;
  epp_p.f = epp_n.f;
  epp_p.v = CalcRatio * epp_n.v;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Simple model of a power transformer with three phases. Losses are specified by constant parameter.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">LoD 3</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pattrick G&ouml;ttsch and revised by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end SimpleTransformer;
