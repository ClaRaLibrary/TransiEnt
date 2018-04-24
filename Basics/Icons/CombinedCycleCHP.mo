within TransiEnt.Basics.Icons;
model CombinedCycleCHP
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
  extends Model;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-44,-6},{-54,-18}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{60,-30},{46,-46}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(
          points={{52,-46},{52,-52}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{52,-24},{52,-30}}, color={0,0,0}),
        Polygon(
          points={{52,-24},{52,-4},{32,-12},{32,-18},{52,-24}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(
          points={{52,-14},{62,-14},{62,60},{80,60}},
          color={0,140,72},
          thickness=0.5),
        Line(
          points={{32,-12},{32,10},{10,10},{6,10}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-22,-36},{-22,-44},{-6,-44},{-6,92}},
          color={0,0,0},
          thickness=0.5),
        Rectangle(
          extent={{-18,84},{8,2}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{-22,-36},{-22,-16},{-42,-24},{-42,-30},{-22,-36}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(
          points={{-56,-24},{-56,-12},{-42,-12},{-42,-24}},
          color={0,0,0},
          thickness=0.5),
        Polygon(
          points={{-76,-36},{-76,-16},{-56,-24},{-56,-30},{-76,-36}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(
          points={{-76,-50},{-76,-36}},
          color={0,0,0},
          thickness=0.5),
        Ellipse(
          extent={{-52,-10},{-46,-16}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Line(points={{-52,-10},{-46,-16}}, color={0,0,0}),
        Line(
          points={{-52,-16},{-46,-10}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-46,46},{-46,-6}},
          color={244,125,35},
          thickness=0.5),
        Line(
          points={{94,-30},{74,-30},{74,-42},{50,-42},{56,-38},{50,-34},{68,-34},{68,0},{98,0}},
          color={162,29,33},
          thickness=0.5)}));
end CombinedCycleCHP;
