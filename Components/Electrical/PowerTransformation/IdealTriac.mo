within TransiEnt.Components.Electrical.PowerTransformation;
model IdealTriac "Basic model of a PowerTransformer with constant loss in percent"

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

  import TransiEnt;
  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

  parameter Boolean isValveMode = true "Valve mode (input between 1 and 0) / Schedule mode (reduces output by provided value)";
  parameter Boolean change_of_sign = false;
  final parameter Real sign = if change_of_sign then -1 else 1;

  // _____________________________________________
  //
  //          Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp_in "power port on generator side" annotation (Placement(transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp_out "power port on consumer side (smaller power flow if triac active)" annotation (Placement(transformation(extent={{88,-10},{108,10}}), iconTransformation(extent={{88,-10},{108,10}})));
  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,82}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,82})));

  // _____________________________________________
  //
  //          Diagnostic Variables
  // _____________________________________________

  Modelica.SIunits.ActivePower P_el_in = epp_in.P "Power on input";
  Modelica.SIunits.ActivePower P_el_out = -epp_out.P "Power on output";
  Modelica.SIunits.ActivePower P_loss = P_el_in - P_el_out "Power lost / curtailed";

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  if isValveMode then
  epp_in.P * sign* u + epp_out.P = 0;
  else
    epp_out.P = min(0, - (epp_in.P + sign * u));
  end if;
  epp_in.f = epp_out.f;

  annotation (defaultComponentName="IdealTriac",Diagram(graphics,
                                                        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                 Icon(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{-40,0},{-40,-94},{60,-50},{-40,0}},
          lineColor={0,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{58,80},{60,0},{-40,50},{58,80}},
          lineColor={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{60,0},{60,-82}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-40,0},{-40,90}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-40,0},{-100,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{60,0},{100,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-72,-70},{-72,-56},{-40,-44}},
          color={0,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{0,-38},{10,-38},{10,88},{24,88},{-2,114},{-28,88},{-16,88},{-16,-38},{0,-38}},
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          origin={-34,42},
          rotation=-90,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-72,32},{-20,20}},
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
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Partial model of an electric triac circuit using Transient electrical interfaces. Allows to curtail electric power flows using an input value between 0 and 100&percnt;. Cooling is not considered (ideal cooling present).</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L1E (defined in the CodingConventions) - active power and frequency only</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>Active power port epp_in &quot;power port on generator side&quot;</p>
<p>Active power port epp_out &quot;power port on consumer side (smaller power flow if triac active)&quot;</p>
<p>Modelica RealInput: u </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in the check model &quot;CheckIdealTriac&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end IdealTriac;
