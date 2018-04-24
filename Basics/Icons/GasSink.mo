within TransiEnt.Basics.Icons;
partial model GasSink "Icon for runnable examples"
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
extends Model;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Rectangle(
          extent={{-100,2},{-50,-4}},
          lineColor={255,240,19},
          fillColor={255,240,19},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-50,8},{-50,-12},{-30,-2},{-50,8}},
          lineColor={255,240,19},
          smooth=Smooth.None,
          fillColor={255,240,19},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-10,10},{-10,-10},{10,0},{-10,10}},
          lineColor={255,240,19},
          smooth=Smooth.None,
          fillColor={255,240,19},
          fillPattern=FillPattern.Solid,
          origin={40,0},
          rotation=180),
        Rectangle(
          extent={{-25,3},{25,-3}},
          lineColor={255,240,19},
          fillColor={255,240,19},
          fillPattern=FillPattern.Solid,
          origin={75,-1},
          rotation=180),
        Polygon(
          points={{-10,10},{-10,-10},{10,0},{-10,10}},
          lineColor={255,240,19},
          smooth=Smooth.None,
          fillColor={255,240,19},
          fillPattern=FillPattern.Solid,
          origin={0,40},
          rotation=270),
        Rectangle(
          extent={{-25,3},{25,-3}},
          lineColor={255,240,19},
          fillColor={255,240,19},
          fillPattern=FillPattern.Solid,
          origin={0,75},
          rotation=270),
        Polygon(
          points={{-10,10},{-10,-10},{10,0},{-10,10}},
          lineColor={255,240,19},
          smooth=Smooth.None,
          fillColor={255,240,19},
          fillPattern=FillPattern.Solid,
          origin={0,-40},
          rotation=90),
        Rectangle(
          extent={{-25,3},{25,-3}},
          lineColor={255,240,19},
          fillColor={255,240,19},
          fillPattern=FillPattern.Solid,
          origin={0,-75},
          rotation=90)}), Documentation(info="<html>
<p>This icon indicates an example. The play button suggests that the example can be executed.</p>
</html>"));
end GasSink;
