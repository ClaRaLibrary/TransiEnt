within TransiEnt.Consumer.DemandSideManagement.PVBatteryPoolControl;
package PVBatteryConsumer
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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
  extends TransiEnt.Basics.Icons.Package;
































annotation (Icon(graphics={
        Ellipse(
          extent={{-42,90},{-88,44}},
          lineColor={255,128,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Sphere),
        Line(
          points={{0,24},{0,-24}},
          color={255,191,0},
          smooth=Smooth.None,
          origin={10,68},
          rotation=90),
        Line(
          points={{0,24},{-36,-16}},
          color={255,191,0},
          smooth=Smooth.None,
          origin={0,26},
          rotation=90),
        Line(
          points={{-62,20},{-62,-28}},
          color={255,191,0},
          smooth=Smooth.None),
        Polygon(
          points={{12,60},{94,60},{38,-48},{-48,-48},{12,60}},
          smooth=Smooth.None,
          fillColor={0,96,141},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{26,60},{-30,-48}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{44,60},{-12,-48}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{60,60},{4,-48}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{76,60},{20,-48}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{8,48},{90,48}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-4,30},{78,30}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-16,10},{66,10}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-24,-10},{58,-10}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-38,-32},{44,-32}},
          color={255,255,255},
          smooth=Smooth.None)}));
end PVBatteryConsumer;
