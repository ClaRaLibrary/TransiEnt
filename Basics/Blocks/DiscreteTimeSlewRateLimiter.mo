within TransiEnt.Basics.Blocks;
block DiscreteTimeSlewRateLimiter "Limits the signal with upper and lower boundary using a discrete block with given sample time"

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  // setting constantlimits to final because if true, model does not check!
  extends Modelica.Blocks.Interfaces.DiscreteSISO;
  extends TransiEnt.Basics.Icons.DiscreteBlock;

  parameter Real Rising(final unit="1/s")=1/60 "Maximum rate of change of input when rising";
  parameter Real Falling(final unit="1/s")=-Rising "Maximum rate of change of input when falling";

  parameter Real Max=1/Modelica.Constants.eps "Can be used to limit absolute value as well as slew rate";
  parameter Real Min=-Max "Can be used to limit absolute value as well as slew rate";

  // states
  Real y_rcbl_by_rate_max "Reachable output in next step if input is only limited by rising rate";
  Real y_rcbl_by_rate_min "Reachable output in next step if input is only limited by falling rate";
  Real y_limited_by_rate "Limited value without absolute value limit";

algorithm
  when {initial()} then
   y_rcbl_by_rate_max:=0;
   y_rcbl_by_rate_min:=0;
   y_limited_by_rate:=0;
   y:=min(max(u, Min), Max);
  end when;

  when {sampleTrigger} then
    y_rcbl_by_rate_max :=pre(y) + Rising*samplePeriod;
    y_rcbl_by_rate_min :=pre(y) + Falling*samplePeriod;
    y_limited_by_rate :=min(max(u, y_rcbl_by_rate_min), y_rcbl_by_rate_max);
    y:=min(max(y_limited_by_rate, Min), Max);
  end when;

  annotation (defaultComponentName="SlewRateLimiter", Icon(graphics={
    Line(points={{-90,0},{68,0}}, color={192,192,192}),
    Line(points={{0,-90},{0,68}}, color={192,192,192}),
    Polygon(
      points={{0,90},{-8,68},{8,68},{0,90}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Polygon(
      points={{90,0},{68,-8},{68,8},{90,0}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(
      points={{-50,-70},{50,70}},
      color={0,0,0},
      smooth=Smooth.None),
    Line(
      visible=strict,
      points={{32,78},{-50,-70}},
      color={255,0,0},
      smooth=Smooth.None)}),
Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The <code></span><span style=\"font-family: Courier New,courier;\">SlewRateLimiter</code></span><span style=\"font-family: MS Shell Dlg 2;\"> block limits the slew rate of its input signal in the range of <code></span><span style=\"font-family: Courier New,courier;\">[Falling, Rising]</code></span><span style=\"font-family: MS Shell Dlg 2;\">.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">To ensure this for arbitrary inputs and in order to produce a differential output, the input is numerically differentiated with derivative time constant <code></span><span style=\"font-family: Courier New,courier;\">Td</code></span><span style=\"font-family: MS Shell Dlg 2;\">. Smaller time constant <code></span><span style=\"font-family: Courier New,courier;\">Td</code></span><span style=\"font-family: MS Shell Dlg 2;\"> means nearer ideal derivative.</span></p>
<p><i><span style=\"font-family: MS Shell Dlg 2;\">Note: The user has to choose the derivative time constant according to the nature of the input signal.</span></i></p>
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
</html>",
revisions="<html>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"1\"><tr>
<th>Revision</th>
<th>Date</th>
<th>Author</th>
<th>Comment</th>
</tr>
<tr>
<td valign=\"top\">4954</td>
<td valign=\"top\">2012-03-02</td>
<td valign=\"top\">A. Haumer &amp; D. Winkler</td>
<td valign=\"top\"><p>Initial version based on discussion in <a href=\"https://trac.modelica.org/Modelica/ticket/529/Modelica\">#529</a></p></td>
</tr>
</table>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
    Line(points={{-90,0},{68,0}}, color={192,192,192}),
    Polygon(
      points={{90,0},{68,-8},{68,8},{90,0}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid)}));
end DiscreteTimeSlewRateLimiter;
