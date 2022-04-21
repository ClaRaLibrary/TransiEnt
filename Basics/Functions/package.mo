within TransiEnt.Basics;
package Functions "Basic functions"


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




extends Icons.FunctionPackage;




























































































annotation (Diagram(graphics={Text(
        lineColor={0,0,255},
        extent={{-150,105},{150,145}},
        textString="%name",
        fillColor={215,215,215},
        fillPattern=FillPattern.Solid),Ellipse(
        lineColor={108,88,49},
        fillColor={215,215,215},
        fillPattern=FillPattern.Solid,
        extent={{-100,-100},{100,100}}),Text(
        lineColor={108,88,49},
        extent={{-90,-90},{90,90}},
        textString="f",
        fillColor={215,215,215},
        fillPattern=FillPattern.Solid)}), Icon(graphics,
                                               coordinateSystem(
        preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end Functions;
