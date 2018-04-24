within TransiEnt.Basics.Blocks.Sources;
block SawTooth "Generate saw tooth signal, with shift option and with infinite number of periods"
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

  parameter Real amplitude=1 "Amplitude of saw tooth";
  parameter SI.Time period(final min=Modelica.Constants.small,start=1) "Time for one period";
  parameter Integer nperiod=-1 "Number of periods (< 0 means infinite number of periods)";
  parameter Real offset=0 "Offset of output signals";
  parameter SI.Time startTime=0 "Output = offset for time < startTime";
  extends Modelica.Blocks.Interfaces.SO;
  extends TransiEnt.Basics.Icons.Block;
public
  SI.Time T_start(final start=startTime) "Start time of current period";
  Integer count "Period count";
initial algorithm
  count := integer((time - startTime)/period);
  T_start := startTime + count*period;
equation
  when integer((time - startTime)/period) > pre(count) then
    count = pre(count) + 1;
    T_start = time;
  end when;
  y = offset + (if ( nperiod == 0 or (nperiod > 0 and
    count >= nperiod)) then 0 else amplitude*(time - T_start)/period);
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-70},{-60,-70},{0,40},{0,-70},{60,41},{60,-70}},
            color={0,0,0}),
        Text(
          extent={{-147,-152},{153,-112}},
          lineColor={0,0,0},
          textString="period=%period")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{-80,90},{-86,68},{-74,68},{-80,90}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={95,95,95}),
        Line(points={{-90,-70},{82,-70}}, color={95,95,95}),
        Polygon(
          points={{90,-70},{68,-65},{68,-75},{90,-70}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-34,-20},{-37,-33},{-31,-33},{-34,-20}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(points={{-34,-20},{-34,-70}}, color={95,95,95}),
        Polygon(
          points={{-34,-70},{-37,-57},{-31,-57},{-34,-70},{-34,-70}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-65,-39},{-29,-47}},
          lineColor={0,0,0},
          textString="offset"),
        Text(
          extent={{-29,-72},{13,-80}},
          lineColor={0,0,0},
          textString="startTime"),
        Text(
          extent={{-82,92},{-43,76}},
          lineColor={0,0,0},
          textString="y"),
        Text(
          extent={{67,-78},{88,-87}},
          lineColor={0,0,0},
          textString="time"),
        Line(points={{-10,-20},{-10,-70}}, color={95,95,95}),
        Line(points={{-10,88},{-10,-20}}, color={95,95,95}),
        Line(points={{30,88},{30,59}}, color={95,95,95}),
        Line(points={{-10,83},{30,83}}, color={95,95,95}),
        Text(
          extent={{-12,94},{34,85}},
          lineColor={0,0,0},
          textString="period"),
        Line(points={{-44,60},{30,60}}, color={95,95,95}),
        Line(points={{-34,47},{-34,-20}},color={95,95,95}),
        Text(
          extent={{-73,25},{-36,16}},
          lineColor={0,0,0},
          textString="amplitude"),
        Polygon(
          points={{-34,60},{-37,47},{-31,47},{-34,60}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-34,-20},{-37,-7},{-31,-7},{-34,-20},{-34,-20}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-10,83},{-1,85},{-1,81},{-10,83}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{30,83},{22,85},{22,81},{30,83}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,-20},{-10,-20},{30,60},{30,-20},{72,60},{72,-20}},
          color={0,0,255},
          thickness=0.5)}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Creates a sawtooth signal based on the MSL <a href=\"Modelica.Blocks.Sources.SawTooth\">SawTooth</a> model but adds a starttime and an offset such that y = offset for time &LT; starttime.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarsk for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on Mon Aug 18 2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised (code conventions and documentation ) by Pascal Dubucq (dubucq@tuhh.de) on 21.04.2017</span></p>
</html>"));
end SawTooth;
