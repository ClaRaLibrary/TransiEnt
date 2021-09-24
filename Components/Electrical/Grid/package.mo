within TransiEnt.Components.Electrical;
package Grid

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









































annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
          {100,100}}), graphics={
      Line(
        points={{-40,68},{-40,-40}},
        color={0,0,0},
        smooth=Smooth.None),
      Line(
        points={{0,68},{0,-40}},
        color={0,0,0},
        smooth=Smooth.None),
      Line(
        points={{42,68},{42,-40}},
        color={0,0,0},
        smooth=Smooth.None),
      Line(
        points={{0,54},{0,-54}},
        color={0,0,0},
        smooth=Smooth.None,
        origin={0,48},
        rotation=90),
      Line(
        points={{0,54},{0,-54}},
        color={0,0,0},
        smooth=Smooth.None,
        origin={0,12},
        rotation=90),
      Line(
        points={{0,54},{0,-54}},
        color={0,0,0},
        smooth=Smooth.None,
        origin={2,-22},
        rotation=90)}));
end Grid;
