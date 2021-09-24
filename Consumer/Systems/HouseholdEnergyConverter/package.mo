within TransiEnt.Consumer.Systems;
package HouseholdEnergyConverter


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-BSD-clause.           //
// Copyright 2021, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE, ResiliEntEE, IntegraNet and IntegraNet II are research projects  //
// supported by the German Federal Ministry of Economics and Energy               //
// (FKZ 03ET4003, 03ET4048, 0324027 and 03EI1008).                                //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Fraunhofer Institute for Environmental, Safety, and Energy Technology UMSICHT, //
// Gas- und Wärme-Institut Essen						  //
// and                                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//







annotation (Icon(graphics={
      Rectangle(
        lineColor={200,200,200},
        fillColor={248,248,248},
        fillPattern=FillPattern.HorizontalCylinder,
        extent={{-100.0,-100.0},{100.0,100.0}},
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
      Rectangle(
        extent={{-58,36},{50,-16}},
        lineColor={0,0,0},
        fillColor={0,0,0},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{-50,-24},{-30,-24},{-40,-16},{-50,-24}},
        lineColor={255,0,0},
        fillColor={255,0,0},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-44,-20},{-36,-38}},
        lineColor={255,0,0},
        fillColor={255,0,0},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{-50,-36},{-30,-36},{-40,-44},{-50,-36}},
        lineColor={255,0,0},
        fillColor={255,0,0},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{-14,-24},{6,-24},{-4,-16},{-14,-24}},
        lineColor={255,255,0},
        fillColor={255,255,0},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-8,-20},{0,-38}},
        lineColor={255,255,0},
        fillColor={255,255,0},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{-14,-36},{6,-36},{-4,-44},{-14,-36}},
        lineColor={255,255,0},
        fillColor={255,255,0},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{26,-24},{46,-24},{36,-16},{26,-24}},
        lineColor={0,216,216},
        fillColor={0,226,226},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{32,-20},{40,-38}},
        lineColor={0,216,216},
        fillColor={0,226,226},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{26,-36},{46,-36},{36,-44},{26,-36}},
        lineColor={0,216,216},
        fillColor={0,226,226},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{-12,56},{8,56},{-2,64},{-12,56}},
        lineColor={255,0,0},
        fillColor={255,0,0},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-6,60},{2,42}},
        lineColor={255,0,0},
        fillColor={255,0,0},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{-12,44},{8,44},{-2,36},{-12,44}},
        lineColor={255,0,0},
        fillColor={255,0,0},
        fillPattern=FillPattern.Solid)}));
end HouseholdEnergyConverter;
