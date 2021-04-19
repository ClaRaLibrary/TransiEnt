within TransiEnt.Components.Boundaries.Ambient.Base;
model EmptyWindspeed "Model for outputting an empty windspeed value"

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

   extends PartialWindspeed;

equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  value = 0;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={
        Polygon(
          points={{44,2},{62,-8},{52,-28},{32,-22},{38,-12},{44,2}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{8,22},{24,14},{12,-14},{-6,-8},{0,2},{8,22}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{24,14},{44,2},{32,-22},{12,-14},{14,-8},{24,14}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{44,-6},{66,-28}},
          lineColor={255,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,0,0}),
        Ellipse(
          extent={{22,4},{50,-22}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-2,16},{32,-14}},
          lineColor={255,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,0,0}),
        Polygon(
          points={{-16,36},{8,22},{-6,-8},{-26,-2},{-22,4},{-16,36}},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-18,24},{16,-8}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-38,38},{-10,-2}},
          lineColor={255,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,0,0}),
        Polygon(
          points={{-38,48},{-16,36},{-26,-2},{-52,6},{-52,34},{-38,48}},
          lineColor={255,0,0},
          smooth=Smooth.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-68,52},{-30,6}},
          lineColor={184,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Sphere),
        Rectangle(
          extent={{-80,64},{-72,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,255,255}),
        Ellipse(
          extent={{-83,68},{-69,60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,255})}),
                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Empty Windspeed value.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Modelica RealOutput: velocity in m/s</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>(no remarks)</p>
</html>"));
end EmptyWindspeed;
