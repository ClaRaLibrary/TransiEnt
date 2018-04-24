within TransiEnt.Basics.Icons;
partial package HeatDemandPackage "Icon for heat demand package"
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
            {100,100}}), graphics={
      Rectangle(
        lineColor={200,200,200},
        fillColor={248,248,248},
        fillPattern=FillPattern.HorizontalCylinder,
        extent={{-100,-100},{100,100}},
        radius=25.0),
      Rectangle(
        lineColor={128,128,128},
        fillPattern=FillPattern.None,
        extent={{-100,-100},{100,100}},
        radius=25.0),
      Rectangle(
        fillColor={95,95,95},
        fillPattern=FillPattern.Solid,
        extent={{-100,-100},{100,-72}},
        radius=25,
        pattern=LinePattern.None),
      Rectangle(
        extent={{-100,-72},{100,-86}},
        fillColor={0,122,122},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None),                                                                              Text(
          extent={{-150,-150},{162,-104}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,0},
          textString="%name"),
      Line(
        origin={-49.5,-10.333},
        points={{-2.5,91.6667},{17.5,71.6667},{-22.5,51.6667},{17.5,31.6667},{-22.5,
              11.667},{17.5,-8.3333},{-2.5,-28.3333},{-2.5,-48.3333}},
        smooth=Smooth.Bezier),
      Polygon(
        origin={-52,-51.667},
        fillPattern=FillPattern.Solid,
        points={{0,-21.667},{-10,8.333},{10,8.333}}),
      Line(
        origin={0.5,-10.333},
        points={{-2.5,91.6667},{17.5,71.6667},{-22.5,51.6667},{17.5,31.6667},{-22.5,
              11.667},{17.5,-8.3333},{-2.5,-28.3333},{-2.5,-48.3333}},
        smooth=Smooth.Bezier),
      Polygon(
        origin={-2,-53.667},
        fillPattern=FillPattern.Solid,
        points={{0,-21.667},{-10,8.333},{10,8.333}}),
      Line(
        origin={50.5,-10.333},
        points={{-2.5,91.6667},{17.5,71.6667},{-22.5,51.6667},{17.5,31.6667},{-22.5,
              11.667},{17.5,-8.3333},{-2.5,-28.3333},{-2.5,-48.3333}},
        smooth=Smooth.Bezier),
      Polygon(
        origin={48,-53.667},
        fillPattern=FillPattern.Solid,
        points={{0,-21.667},{-10,8.333},{10,8.333}})}),
                                            Documentation(info="<html>
<p>This icon indicates an example. The play button suggests that the example can be executed.</p>
</html>"));

end HeatDemandPackage;
