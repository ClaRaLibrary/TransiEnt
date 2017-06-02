within TransiEnt.Consumer.Heat.SpaceHeating.Base;
record FloorHeatingSystem
//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
  extends TransiEnt.Basics.Icons.Record;

  parameter Modelica.SIunits.TemperatureDifference T_spreading = 5 "Temperature spreading from inlet to outlet of the heating floor system" annotation(Dialog(group="Basic"));
  parameter Modelica.SIunits.PressureDifference dp=0.2e5 "Pressure drop in the floor heating system" annotation(Dialog(group="Basic"));

  parameter Modelica.SIunits.Length distance_pipes = 0.15 "Distance between installed pipes of the heating floor system" annotation(Dialog(group="Pipes"));
  parameter Modelica.SIunits.Length d_pipe = 0.01 "Diameter of pipes" annotation(Dialog(group="Pipes"));
  parameter Real a_used=0.75 "Area ratio of the pipe which is used to transfer heat to the desired direction into the room"
                                                                                                    annotation(Dialog(group="Pipes"));

  final parameter Modelica.SIunits.Area A_crossSectionalPipe = Modelica.Constants.pi/4*d_pipe^2 "Cross sectional area of the pipes of the floor heating system";

  // Floor fill
  parameter Modelica.SIunits.Length h_floorFill = 0.0045 "heigh of floorfill with high temperature (e.g. Estric)" annotation(Dialog(group="Floorfill"));
  parameter Modelica.SIunits.Density rho_floor = 2000 "density of the floor fill (e.g. Estrich)" annotation(Dialog(group="Floorfill"));
  parameter Modelica.SIunits.SpecificHeatCapacity cp_floor = 1.116e3 "specific heat capacity of the floor (e.g. Estrich)" annotation(Dialog(group="Floorfill"));

end FloorHeatingSystem;
