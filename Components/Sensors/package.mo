within TransiEnt.Components;
package Sensors
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
          origin={0,-30},
          fillColor={255,255,255},
          extent={{-90.0,-90.0},{90.0,90.0}},
          startAngle=20.0,
          endAngle=160.0),
        Ellipse(
          origin={0,-30},
          fillColor={128,128,128},
          fillPattern=FillPattern.Solid,
          extent={{-20.0,-20.0},{20.0,20.0}}),
        Line(origin={0,-30}, points={{0.0,60.0},{0.0,90.0}}),
        Ellipse(
          origin={0,-30},
          fillColor={64,64,64},
          fillPattern=FillPattern.Solid,
          extent={{-10.0,-10.0},{10.0,10.0}}),
        Polygon(
          origin={0,-30},
          rotation=-35.0,
          fillColor={64,64,64},
          fillPattern=FillPattern.Solid,
          points={{-7.0,0.0},{-3.0,85.0},{0.0,90.0},{3.0,85.0},{7.0,0.0}})}));
end Sensors;
