within TransiEnt.Basics.Icons;
partial package RandomPackage "Icon for  packages using statistical methods"
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
        extent={{-100.0,-100.0},{100.0,100.0}},
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
        pattern=LinePattern.None),
    Line(points={{-88,-50},{70,-50}},
                                  color={192,192,192}),
    Line(points={{-2,-66},{-2,68}},
                                  color={192,192,192}),
    Polygon(
      points={{-2,90},{-10,68},{6,68},{-2,90}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Polygon(
      points={{92,-50},{70,-58},{70,-42},{92,-50}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
      Line(
        points={{-86,-44},{-76,-44},{-72,-42},{-66,-40},{-64,-40},{-56,-34},{
            -54,-32},{-44,-26},{-40,-18},{-38,-16},{-32,-8},{-30,-2},{-26,10},{
            -26,14},{-22,28},{-20,30},{-14,46},{-14,48},{-12,52},{-10,54},{-8,
            56},{-6,56},{-2,56}},
        color={0,134,134}),
      Line(
        points={{82,-44},{72,-44},{68,-42},{62,-40},{60,-40},{52,-34},{50,-32},
            {40,-26},{36,-18},{34,-16},{28,-8},{26,-2},{22,10},{22,14},{18,28},
            {16,30},{10,46},{10,48},{8,52},{6,54},{4,56},{2,56},{-2,56}},
        color={0,134,134})}),        Documentation(info="<html>
<p>Standard package icon.</p>
</html>"));
end RandomPackage;
