within TransiEnt.Basics.Icons;
model SolarThermalCollector
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
  extends Model;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Line(
          points={{-84,-26},{-98,-18}},
          color={0,0,0},
          smooth=Smooth.None),
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
        Polygon(
          points={{-90,-32},{20,-92},{82,50},{4,96},{-90,-32}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95},
          lineThickness=0.5),
        Line(
          points={{-88,-24},{14,-82},{26,-56},{-60,-6},{-46,14},{36,-34},{46,
              -12},{-30,34},{-18,52},{54,10},{64,30},{-4,70},{6,86},{94,34}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{84,46},{88,38},{80,38}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-92,-16},{-88,-24},{-96,-24}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{94,34},{78,44}},
          color={0,0,0},
          smooth=Smooth.None)}));
end SolarThermalCollector;
