within TransiEnt.Basics.Icons;
model SolarElectricalModel
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

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
                                   Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,100},{100,-100}}),
        Polygon(
          points={{2,50},{84,50},{28,-58},{-58,-58},{2,50}},
          smooth=Smooth.None,
          fillColor={0,96,141},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{16,50},{-40,-58}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{34,50},{-22,-58}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{50,50},{-6,-58}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{66,50},{10,-58}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{-2,38},{80,38}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-14,20},{68,20}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-26,0},{56,0}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-34,-20},{48,-20}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-48,-42},{34,-42}},
          color={255,255,255},
          smooth=Smooth.None),
        Ellipse(
          extent={{-28,60},{-74,14}},
          lineColor={255,128,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Sphere)}));
end SolarElectricalModel;
