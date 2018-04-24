within TransiEnt.Basics.Icons;
block ExponentialBlock "Symbol for a linear block model"
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
  extends Block;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={
    Line(points={{-84,-52},{74,-52}},
                                  color={192,192,192}),
    Line(points={{0,-90},{0,68}}, color={192,192,192}),
    Polygon(
      points={{0,90},{-8,68},{8,68},{0,90}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Polygon(
      points={{96,-52},{74,-60},{74,-44},{96,-52}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
        Line(
          points={{82,36},{82,36},{82,34},{80,32},{80,30},{80,30},{78,28},{78,
              26},{76,24},{74,22},{72,20},{70,18},{68,14},{66,10},{62,4},{58,0},
              {50,-10},{48,-14},{44,-18},{38,-24},{36,-26},{24,-32},{12,-40},{8,
              -42},{-4,-48},{-18,-50},{-32,-50},{-42,-50},{-52,-50},{-60,-50},{
              -78,-50},{-80,-50}},
          color={0,134,134},
          smooth=Smooth.Bezier),
        Text(
          extent={{-66,40},{36,-36}},
          lineColor={0,134,134},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          textString="e"),
        Text(
          extent={{-20,56},{52,-2}},
          lineColor={0,134,134},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          textString="x")}),
Documentation(info="<html>
<p>The <code>SlewRateLimiter</code> block limits the slew rate of its input signal in the range of <code>[Falling, Rising]</code>.</p>
<p>To ensure this for arbitrary inputs and in order to produce a differential output, the input is numerically differentiated
with derivative time constant <code>Td</code>. Smaller time constant <code>Td</code> means nearer ideal derivative.</p>
<p><em>Note: The user has to choose the derivative time constant according to the nature of the input signal.</em></p>
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                    graphics));
end ExponentialBlock;
