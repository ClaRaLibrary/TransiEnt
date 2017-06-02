within TransiEnt.Basics.Icons;
partial package PackageStaticCycle

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
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
                             Rectangle(
          extent={{-98,98},{98,-98}},
          lineColor={0,127,127},
          lineThickness=0.5,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),                                    Text(
          extent={{-100,-98},{100,-64}},
          lineColor={62,62,62},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid,
          textString="%name"),
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

end PackageStaticCycle;
