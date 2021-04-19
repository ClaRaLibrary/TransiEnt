within TransiEnt.Basics.Icons;
partial model ElectricSink "Icon for electric sinks"
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
extends Model;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Rectangle(
          extent={{-100,3},{-50,-3}},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-50,10},{-50,-10},{-30,0},{-50,10}},
          smooth=Smooth.None,
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-10,10},{-10,-10},{10,0},{-10,10}},
          smooth=Smooth.None,
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid,
          origin={40,0},
          rotation=180,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-25,3},{25,-3}},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid,
          origin={75,0},
          rotation=180,
          pattern=LinePattern.None),
        Polygon(
          points={{-10,10},{-10,-10},{10,0},{-10,10}},
          smooth=Smooth.None,
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid,
          origin={0,40},
          rotation=270,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-25,3},{25,-3}},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid,
          origin={0,75},
          rotation=270,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-10,10},{-10,-10},{10,0},{-10,10}},
          smooth=Smooth.None,
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid,
          origin={0,-40},
          rotation=90,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-25,3},{25,-3}},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid,
          origin={0,-75},
          rotation=90,
          pattern=LinePattern.None)}),
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
end ElectricSink;
