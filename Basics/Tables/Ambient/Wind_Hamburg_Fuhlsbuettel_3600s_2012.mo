within TransiEnt.Basics.Tables.Ambient;
model Wind_Hamburg_Fuhlsbuettel_3600s_2012 "Hamburg-Fuhlsbuettel 2012, 1 h resolution, Source: WebWerdis"
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
extends GenericDataTable(
relativepath="/ambient/Wind_Hamburg-Fuhlsbuettel_3600s_01012012_31122012_11m.txt",
datasource=DataPrivacy.isPublic);
extends TransiEnt.Components.Boundaries.Ambient.Base.PartialWindspeed;
equation
  //  y=value;

 connect(y1, value);
 connect(y[1], value);

end Wind_Hamburg_Fuhlsbuettel_3600s_2012;
