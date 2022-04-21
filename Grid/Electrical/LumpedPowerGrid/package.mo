within TransiEnt.Grid.Electrical;
package LumpedPowerGrid "Lumped synchronous power grid model containing generators with primary and secondary control, frequency dependen demand and grid error modeling"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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




extends TransiEnt.Basics.Icons.Package;













annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
          {100,100}}), graphics={
      Ellipse(
        extent={{-50,24},{-42,16}},
        lineColor={95,95,95},
        fillColor={95,95,95},
        fillPattern=FillPattern.Solid),
      Ellipse(
        extent={{-50,-32},{-42,-40}},
        lineColor={95,95,95},
        fillColor={95,95,95},
        fillPattern=FillPattern.Solid),
      Line(points={{-28,4},{30,4}}, color={95,95,95}),
      Line(points={{30,26},{30,-12}}, color={95,95,95}),
      Ellipse(
        extent={{38,33},{46,25}},
        fillColor={0,127,127},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
      Ellipse(
        extent={{38,-12},{46,-20}},
        fillColor={0,127,127},
        fillPattern=FillPattern.Solid,
        pattern=LinePattern.None,
        lineColor={0,0,0}),
      Line(points={{30,26},{30,30},{38,30}}, color={95,95,95}),
      Line(points={{30,-12},{30,-16},{38,-16}}, color={95,95,95}),
      Line(points={{-44,20},{-44,20},{-28,20},{-28,-36},{-44,-36}}, color={95,95,95}),
      Ellipse(
        extent={{-50,58},{-42,50}},
        lineColor={95,95,95},
        fillColor={95,95,95},
        fillPattern=FillPattern.Solid),
      Line(points={{-46,54},{-44,54},{-28,54},{-28,20}}, color={95,95,95})}));
end LumpedPowerGrid;
