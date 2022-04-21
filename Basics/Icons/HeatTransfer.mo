within TransiEnt.Basics.Icons;
model HeatTransfer



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




  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                Rectangle(extent={{-100,100},{100,-100}},
            lineColor={191,0,0}),
        Line(
          points={{-64,100},{-64,-20},{-40,-60},{4,-84},{54,-100},{64,-100}},
          color={191,0,0},
          smooth=Smooth.Bezier,
          origin={0,0},
          rotation=90),
        Text(
          extent={{-100,20},{100,-20}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid,
          textString="ht"),
                Rectangle(extent={{-100,100},{100,-100}},
            lineColor={191,0,0}),
        Line(
          points={{-64,100},{-64,-20},{-40,-60},{4,-84},{54,-100},{64,-100}},
          color={191,0,0},
          smooth=Smooth.Bezier,
          origin={0,0},
          rotation=90),
        Text(
          extent={{-100,20},{100,-20}},
          lineColor={191,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid,
          textString="ht")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end HeatTransfer;
