within TransiEnt.Basics.Icons;
partial model ModelStaticCycle

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
extends TransiEnt.Basics.Icons.OuterElement;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
                   graphics={
        Line(
          points={{-72,76},{-72,-58},{76,-58}},
          color={95,95,95},
          smooth=Smooth.None),
        Polygon(
          points={{-72,82},{-74,74},{-70,74},{-72,82}},
          lineColor={95,95,95},
          smooth=Smooth.None,
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,4},{-2,-4},{2,-4},{0,4}},
          lineColor={95,95,95},
          smooth=Smooth.None,
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid,
          origin={74,-58},
          rotation=270),
        Line(
          points={{-72,50},{56,50}},
          color={255,0,0}),
        Ellipse(
          extent={{-30,20},{38,-42}},
          lineColor={0,134,134},
          lineThickness=0.5)}));

end ModelStaticCycle;
