within TransiEnt.Basics.Icons;
partial model ElectricSource "Icon for runnable examples"
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

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),Rectangle(
          extent={{30,4},{80,-2}},
          lineColor={0,134,134},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),Polygon(
          points={{80,10},{80,-10},{100,0},{80,10}},
          lineColor={0,134,134},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),Rectangle(
          extent={{-25,3},{25,-3}},
          lineColor={0,134,134},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid,
          origin={0,-55},
          rotation=270),Polygon(
          points={{-10,10},{-10,-10},{10,0},{-10,10}},
          lineColor={0,134,134},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid,
          origin={0,-90},
          rotation=270),Rectangle(
          extent={{-25,3},{25,-3}},
          lineColor={0,134,134},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid,
          origin={-55,-1},
          rotation=180),Polygon(
          points={{-10,10},{-10,-10},{10,0},{-10,10}},
          lineColor={0,134,134},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid,
          origin={-90,0},
          rotation=180),Polygon(
          points={{-10,10},{-10,-10},{10,0},{-10,10}},
          lineColor={0,134,134},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid,
          origin={0,90},
          rotation=90),Rectangle(
          extent={{-25,3},{25,-3}},
          lineColor={0,134,134},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid,
          origin={0,55},
          rotation=90),
        Text(
          extent={{-146,-97},{154,-137}},
          lineColor={0,134,134},
          textString="%name")}),
                          Documentation(info="<html>
<p>This icon indicates an example. The play button suggests that the example can be executed.</p>
</html>"));
end ElectricSource;
