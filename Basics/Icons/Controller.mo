within TransiEnt.Basics.Icons;
partial model Controller "Icon for runnable examples"
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
 extends TransiEnt.Basics.Icons.Model;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics={
        Rectangle(
          extent={{-46,29},{46,-34}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-34,50},{-26,29}},
          lineColor={0,0,0},
          fillColor={255,191,30},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-14,50},{-6,29}},
          lineColor={0,0,0},
          fillColor={255,191,30},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{6,50},{14,29}},
          lineColor={0,0,0},
          fillColor={255,191,30},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{26,50},{34,29}},
          lineColor={0,0,0},
          fillColor={255,191,30},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{26,-34},{34,-55}},
          lineColor={0,0,0},
          fillColor={255,191,30},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{6,-34},{14,-55}},
          lineColor={0,0,0},
          fillColor={255,191,30},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-14,-34},{-6,-55}},
          lineColor={0,0,0},
          fillColor={255,191,30},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-34,-34},{-26,-55}},
          lineColor={0,0,0},
          fillColor={255,191,30},
          fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>This icon indicates an example. The play button suggests that the example can be executed.</p>
</html>"));
end Controller;
