within TransiEnt.Components.Turbogroups;
package OperatingStates "Blocks to model operating states of turbo groups (e.g. halt, operating, startup)"


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



  //________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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
  extends Basics.Icons.Package;










annotation (Icon(graphics={
      Rectangle(
        origin={-70,0},
        fillColor={255,255,255},
        extent={{-20.0,-20.0},{20.0,20.0}}),
      Rectangle(
        origin={70,0},
        fillColor={255,255,255},
        extent={{-20.0,-20.0},{20.0,20.0}}),
      Line(points={{0,50},{0,-50}}),
      Polygon(
        origin={-16.6667,0},
        pattern=LinePattern.None,
        fillPattern=FillPattern.Solid,
        points={{-3.3333,10.0},{16.667,0.0},{-3.3333,-10.0}}),
      Line(origin={-35,0},     points={{15.0,0.0},{-15.0,0.0}}),
      Polygon(
        origin={33.3333,0},
        pattern=LinePattern.None,
        fillPattern=FillPattern.Solid,
        points={{-3.3333,10.0},{16.667,0.0},{-3.3333,-10.0}}),
      Line(origin={15,0},       points={{15.0,0.0},{-15.0,-0.0}})}));
end OperatingStates;
