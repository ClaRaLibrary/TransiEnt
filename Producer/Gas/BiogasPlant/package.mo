within TransiEnt.Producer.Gas;
package BiogasPlant "Package for components of a biogas plant and reactor models"


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




  extends TransiEnt.Basics.Icons.Package;
















  annotation (Icon(graphics={
        Ellipse(
          extent={{-36,-62},{86,-10}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
        extent={{-36,-36},{86,-72}},
        lineColor={95,95,95},
        fillColor={134,134,134},
        fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{-82,-22},{-8,-72}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-76,-26},{-68,-32}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Rectangle(
          extent={{-64,-26},{-56,-32}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Rectangle(
          extent={{-52,-26},{-44,-32}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Rectangle(
          extent={{-28,-26},{-20,-32}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215}),
        Rectangle(
          extent={{-40,-26},{-32,-32}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={215,215,215})}));
end BiogasPlant;
