within TransiEnt.Basics.Icons;
model SteamCyclewHeatingCondenser2Blocks
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

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-220,-160},{240,160}}),
                               graphics={
                                   Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{14,-102},{214,98}}),
                                   Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-206,-98},{-6,102}}),
        Polygon(
          points={{-70,54},{-70,16},{-60,12},{-60,58},{-70,54}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Rectangle(
          extent={{-66,-6},{-32,-42}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Rectangle(
          extent={{-54,-42},{-42,-50}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Rectangle(
          extent={{-184,44},{-148,-36}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Ellipse(
          extent={{-160,-54},{-122,-90}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Line(
          points={{-122,-72},{-160,-72},{-144,-54}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{-160,-72},{-144,-90}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{-60,12},{-60,2},{-92,2},{-92,-6}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{-48,-50},{-48,-72},{-92,-72}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{-150,-72},{-166,-72},{-166,-36}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Ellipse(
          extent={{-36,45},{-16,25}},
          lineColor={0,0,0},
          lineThickness=0.2,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-26,44},{-26,58},{-4,58}},
          color={0,127,127},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{-20,54},{-14,62}},
          color={0,127,127},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{-18,54},{-12,62}},
          color={0,127,127},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{-16,54},{-10,62}},
          color={0,127,127},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{-4,-12},{-56,-12},{-44,-22},{-56,-34},{-4,-34}},
          color={175,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Polygon(
          points={{-122,42},{-122,28},{-104,22},{-104,48},{-122,42}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Rectangle(
          extent={{-110,-6},{-76,-42}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Rectangle(
          extent={{-98,-42},{-86,-50}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Line(
          points={{-80,16},{-80,-2},{-52,-2},{-52,-6}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{-92,-50},{-92,-72},{-138,-72}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{-76,-12},{-100,-12},{-88,-22},{-100,-34},{-76,-34}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{-36,34},{-104,34}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{-166,44},{-166,94},{-122,94},{-122,42}},
          color={0,0,0}),
        Line(
          points={{-104,48},{-104,72},{-140,72},{-140,24},{-148,24}},
          color={0,0,0}),
        Line(
          points={{-154,44},{-154,82},{-80,82},{-80,52}},
          color={0,0,0}),
        Polygon(
          points={{-96,48},{-96,22},{-80,16},{-80,54},{-96,48}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Polygon(
          points={{134,48},{134,10},{144,6},{144,52},{134,48}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Rectangle(
          extent={{138,-12},{172,-48}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Rectangle(
          extent={{150,-48},{162,-56}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Rectangle(
          extent={{20,38},{56,-42}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Ellipse(
          extent={{44,-60},{82,-96}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Line(
          points={{82,-78},{44,-78},{60,-60}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{44,-78},{60,-96}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{144,6},{144,-4},{112,-4},{112,-12}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{156,-56},{156,-78},{112,-78}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{54,-78},{38,-78},{38,-42}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Ellipse(
          extent={{168,39},{188,19}},
          lineColor={0,0,0},
          lineThickness=0.2,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(
          points={{178,38},{178,52},{200,52}},
          color={0,127,127},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{184,48},{190,56}},
          color={0,127,127},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{186,48},{192,56}},
          color={0,127,127},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{188,48},{194,56}},
          color={0,127,127},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{200,-18},{148,-18},{160,-28},{148,-40},{200,-40}},
          color={175,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Polygon(
          points={{82,36},{82,22},{100,16},{100,42},{82,36}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Rectangle(
          extent={{94,-12},{128,-48}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Rectangle(
          extent={{106,-48},{118,-56}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Line(
          points={{124,10},{124,-8},{152,-8},{152,-12}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{112,-56},{112,-78},{66,-78}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{128,-18},{104,-18},{116,-28},{104,-40},{128,-40}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{168,28},{100,28}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{38,38},{38,88},{82,88},{82,36}},
          color={0,0,0}),
        Line(
          points={{100,40},{100,64},{64,64},{64,16},{56,16}},
          color={0,0,0}),
        Line(
          points={{50,38},{50,76},{124,76},{124,46}},
          color={0,0,0}),
        Polygon(
          points={{108,42},{108,16},{124,10},{124,48},{108,42}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Text(
          extent={{-124,-153},{176,-193}},
          lineColor={0,134,134},
          textString="%name"),
        Line(
          points={{-4,58},{22,58},{22,134},{240,134}},
          color={0,127,127},
          thickness=0.2),
        Line(
          points={{198,52},{222,52},{222,134}},
          color={0,127,127},
          thickness=0.2),
        Line(
          points={{-6,-12},{6,-12},{6,-124},{222,-124},{222,-18},{240,-18}},
          color={162,29,33},
          thickness=0.2),
        Line(
          points={{200,-18},{240,-18}},
          color={162,29,33},
          thickness=0.2),
        Line(points={{-144,28},{-148,24},{-144,20}}, color={0,0,0}),
        Line(points={{-126,46},{-122,42},{-118,46}}, color={0,0,0}),
        Line(points={{-84,58},{-80,54},{-76,58}}, color={0,0,0}),
        Line(points={{60,20},{56,16},{60,12}}, color={0,0,0}),
        Line(points={{78,40},{82,36},{86,40}}, color={0,0,0}),
        Line(points={{120,52},{124,48},{128,52}}, color={0,0,0})}),
                                Diagram(graphics,
                                        coordinateSystem(extent={{-220,-160},{240,160}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model created for using the icon</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end SteamCyclewHeatingCondenser2Blocks;
