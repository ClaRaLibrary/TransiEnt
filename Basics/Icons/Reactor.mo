within TransiEnt.Basics.Icons;
partial model Reactor

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
// Copyright 2020, Hamburg University of Technology.                              //
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
  extends TransiEnt.Basics.Icons.Model
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));

  annotation (Icon(graphics={
        Line(
          points={{-40,50},{-40,-50}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{40,50},{40,-50}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-40,50},{-36,58},{-32,62},{-26,66},{-14,70},{-8,70},{4,70},{12,70},{22,68},{32,62},{38,54},{40,50}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Line(
          points={{-40,-10},{-36,-2},{-32,2},{-26,6},{-14,10},{-8,10},{4,10},{12,10},{22,8},{32,2},{38,-6},{40,-10}},
          color={0,0,0},
          thickness=0.5,
          origin={0,-60},
          rotation=180,
          smooth=Smooth.Bezier),
        Line(
          points={{-40,50},{40,50},{-40,-50},{40,-50},{-40,50}},
          color={0,0,0},
          thickness=0.5)}));
end Reactor;
