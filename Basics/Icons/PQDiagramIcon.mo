within TransiEnt.Basics.Icons;
model PQDiagramIcon
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

  annotation (Icon(graphics={      Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Text(
          extent={{-150,-101},{150,-141}},
          lineColor={0,134,134},
          textString="%name"),
        Rectangle(
          extent={{-50,60},{0,-60}},
          lineColor={255,255,255},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Line(points={{-50,-60},{-50,60},{50,60},{50,-60},{-50,-60},{-50,-30},{50,-30},{50,0},{-50,0},{-50,30},{50,30},{50,60},{0,60},{0,-61}},
            color={0,0,0}),                     Text(
          extent={{-94,-56},{-44,-104}},
          lineColor={0,128,0},
          textStyle={TextStyle.Bold},
          textString="S4"),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-76,94},{-84,72},{-68,72},{-76,94}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-76,72},{-76,-76}}, color={192,192,192}),
        Line(points={{-86,-66},{86,-66}}, color={192,192,192}),
        Polygon(
          points={{94,-66},{72,-58},{72,-74},{94,-66}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-76,62},{-60,62},{62,14}},
          color={255,128,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-76,-28},{-24,-44},{62,-10}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{62,14},{62,-10}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Text(
          extent={{-100,102},{-78,68}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          fontSize=12,
          textString="%P"),
        Text(
          extent={{72,-70},{94,-104}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          fontSize=12,
          textString="%Q")}), Documentation(info="<html>
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
end PQDiagramIcon;
