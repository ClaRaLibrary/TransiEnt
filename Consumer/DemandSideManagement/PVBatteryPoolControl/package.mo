within TransiEnt.Consumer.DemandSideManagement;
package PVBatteryPoolControl "alle Modelle der Masterarbeit"
//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
  extends TransiEnt.Basics.Icons.Package;
  import SI = Modelica.SIunits "Usage of Modelica Standard library unit package";












































  annotation (Icon(graphics={
        Line(
          points={{0,24},{0,-24}},
          color={255,191,0},
          smooth=Smooth.None,
          origin={4,64},
          rotation=90),
        Line(
          points={{0,24},{-36,-16}},
          color={255,191,0},
          smooth=Smooth.None,
          origin={-6,22},
          rotation=90),
        Line(
          points={{-68,16},{-68,-32}},
          color={255,191,0},
          smooth=Smooth.None),
        Polygon(
          points={{6,56},{88,56},{32,-52},{-54,-52},{6,56}},
          smooth=Smooth.None,
          fillColor={0,96,141},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{20,56},{-36,-52}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{38,56},{-18,-52}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{54,56},{-2,-52}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{70,56},{14,-52}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{2,44},{84,44}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-10,26},{72,26}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-22,6},{60,6}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-30,-14},{52,-14}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-44,-36},{38,-36}},
          color={255,255,255},
          smooth=Smooth.None),
        Ellipse(
          extent={{-44,82},{-90,36}},
          lineColor={255,128,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Sphere)}));
end PVBatteryPoolControl;
