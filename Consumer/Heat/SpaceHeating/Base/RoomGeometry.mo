within TransiEnt.Consumer.Heat.SpaceHeating.Base;
record RoomGeometry
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
  extends TransiEnt.Basics.Icons.Record;

  // Room geometry

  parameter Modelica.SIunits.Length a = 10 "Length of the room";
  parameter Modelica.SIunits.Length b = 10 "Width of the room";
  parameter Modelica.SIunits.Length h = 2.9 "Hight of the room";
  parameter Modelica.SIunits.Length d_wall = 0.6 "Thickness of the external walls";
  parameter Modelica.SIunits.Length d_wallInt = 0.25 "Thickness of the internal walls";
  parameter Modelica.SIunits.Length d_ceiling = 0.4 "Thickness of the ceiling";

  final parameter Modelica.SIunits.Volume V_room = a*b*h*0.76 "Volume of the house according to EnEV";
  final parameter Modelica.SIunits.Area A_eff=V_room/0.76*0.32 "effective area of the house";
  final parameter Modelica.SIunits.Area A_ext=(2*a+2*b)*(h-d_ceiling) "walls to the environement";
  final parameter Modelica.SIunits.Area A_int=(2*a+b)*(h-d_ceiling) "walls in the house";
  final parameter Modelica.SIunits.Area A_floor = a*b "Floor with installed heating floor system";
  final parameter Modelica.SIunits.Area A_roof = a*b*0.5 "Roof area of a house with two floors";

end RoomGeometry;
