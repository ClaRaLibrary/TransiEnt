within TransiEnt.Basics.Icons;
partial package ElectricalPackage "Icon for packages containing interfaces"
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
          pattern=LinePattern.None),
        Line(origin={3,54}, points={{-61.0,-45.0},{-61.0,-10.0},{-26.0,-10.0}}),
        Rectangle(origin={22.3125,86.857}, extent={{-45.3125,-57.8571},{4.6875,
              -27.8571}}),
        Line(origin={9,54}, points={{18.0,-10.0},{53.0,-10.0},{53.0,-45.0}}),
        Line(origin={11,58}, points={{31.0,-49.0},{71.0,-49.0}}),
        Line(origin={10,52}, points={{32.0,-58.0},{72.0,-58.0}}),
        Line(origin={8.2593,52}, points={{53.7407,-58.0},{53.7407,-93.0},{-66.2593,
              -93.0},{-66.2593,-58.0}}),
        Line(origin={-1,49}, points={{-72.0,-55.0},{-42.0,-55.0}}),
        Line(origin={0,59}, points={{-83.0,-50.0},{-33.0,-50.0}})}),
      Documentation(info="<html>
<p>This icon indicates packages containing interfaces.</p>
</html>"));

end ElectricalPackage;
