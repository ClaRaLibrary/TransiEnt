within TransiEnt.Components.Electrical.Grid;
model Line_PS "Transmission line with constant loss of active power from connection epp_1 to epp_2"
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends Base.PartialLine;
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter Real loss_in_percent=0;

  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________
  Modelica.SIunits.ActivePower P_abs_loss=epp_1.P + epp_2.P;
  Modelica.SIunits.Frequency f_grid=epp_1.f;
  Modelica.SIunits.Frequency delta_f_grid(displayUnit="mHz")=(f_grid - simCenter.f_n);
protected
  Modelica.SIunits.ActivePower epp_2_ps;

initial equation
  epp_2_ps=0;
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
 epp_1.f = epp_2.f;
 der(epp_2_ps)= 0.1*(-epp_1.P/(1+loss_in_percent/100)-epp_2_ps);
 epp_2.P=epp_2_ps;

 annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Text(
          extent={{-66,90},{22,4}},
          lineColor={255,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,134,134},
          textString="%eta %%"),
        Polygon(
          points={{0,-38},{10,-38},{10,88},{24,88},{-2,114},{-28,88},{-16,88},{-16,-38},{0,-38}},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-24,42},
          rotation=-90,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-62,32},{-10,20}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,20},{26,32}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-14,14},{14,-14}},
          lineColor={255,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          startAngle=0,
          endAngle=90,
          origin={26,18},
          rotation=90,
          pattern=LinePattern.None),
        Polygon(
          points={{-12,-24},{-6,-22},{-6,6},{4,6},{-12,22},{-28,6},{-18,6},{-18,-22},{-12,-24}},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={22,-4},
          rotation=180,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-2,2},{2,-2}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          startAngle=0,
          endAngle=360,
          origin={26,18},
          rotation=90,
          pattern=LinePattern.None)}),
                                Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Simple line model using Transient electrical interfaces with L1E (only active power and frequency) and constant power loss specified in percent.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>L1E (defined in the CodingConventions)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>Active power port epp_1</p>
<p>Active power port epp_2</p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end Line_PS;
