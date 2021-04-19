within TransiEnt.Basics.Blocks;
block DiscreteTimeSlewRateLimiter "Limits the signal with upper and lower boundary using a discrete block with given sample time"

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

  // setting constantlimits to final because if true, model does not check!
  extends Modelica.Blocks.Interfaces.DiscreteSISO;
  extends TransiEnt.Basics.Icons.DiscreteBlock;

  // _____________________________________________
  //
  //               Visible Parameters
  // _____________________________________________

  parameter Real Rising(final unit="1/s")=1/60 "Maximum rate of change of input when rising";
  parameter Real Falling(final unit="1/s")=-Rising "Maximum rate of change of input when falling";

  parameter Real Max=1/Modelica.Constants.eps "Can be used to limit absolute value as well as slew rate";
  parameter Real Min=-Max "Can be used to limit absolute value as well as slew rate";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  // states
  Real y_rcbl_by_rate_max "Reachable output in next step if input is only limited by rising rate";
  Real y_rcbl_by_rate_min "Reachable output in next step if input is only limited by falling rate";
  Real y_limited_by_rate "Limited value without absolute value limit";

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

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
<p>The SlewRateLimiter block limits the slew rate of its input signal in the range of [Falling, Rising].</p>
<p>To ensure this for arbitrary inputs and in order to produce a differential output, the input is numerically differentiated with derivative time constant Td. Smaller time constant Td means nearer ideal derivative.</p>
<p><i>Note: The user has to choose the derivative time constant according to the nature of the input signal.</i></p>
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
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in check model &quot;TestDiscreteTimeSlewRateLimiter&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de), Aug 2014</span></p>
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
<td valign=\"top\">A. Haumer & D. Winkler</td>
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
