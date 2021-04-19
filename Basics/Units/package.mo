within TransiEnt.Basics;
package Units "Library specific unit package"
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
extends TransiEnt.Basics.Icons.Package;

// Electricity related units





annotation (Icon(graphics={
      Line(
        points={{-56,88},{-56,-30}},
        color={64,64,64},
        smooth=Smooth.None),
      Ellipse(
        extent={{22,46},{78,-28}},
        lineColor={64,64,64},
        fillColor={175,175,175},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-64,88},{-56,-30}},
        lineColor={64,64,64},
        fillColor={175,175,175},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{-56,6},{-56,16},{-6,66},{-6,56},{-56,6}},
        lineColor={64,64,64},
        smooth=Smooth.None,
        fillColor={175,175,175},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{-36,26},{-30,32},{8,-30},{0,-30},{-36,26}},
        lineColor={64,64,64},
        smooth=Smooth.None,
        fillColor={175,175,175},
        fillPattern=FillPattern.Solid),
      Ellipse(
        extent={{32,36},{68,-18}},
        lineColor={64,64,64},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{78,12},{78,-36},{74,-50},{68,-58},{58,-62},{28,-62},{28,-54},{
            56,-54},{64,-50},{68,-44},{70,-36},{70,-16},{74,-10},{78,4},{78,12}},
        lineColor={64,64,64},
        smooth=Smooth.Bezier,
        fillColor={175,175,175},
        fillPattern=FillPattern.Solid)}));
end Units;
