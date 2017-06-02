within TransiEnt.Basics.Tables.Ambient;
model Wind_Hamburg_3600s_TMY "Hamburg TMY, Source: DOE/ASHRAE2015"
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
relativepath="/ambient/Wind_Hamburg_3600s_TMY.txt",
datasource=DataPrivacy.isPublic);
extends TransiEnt.Components.Boundaries.Ambient.Base.PartialWindspeed;
equation
  //  y=value;

 connect(y1, value);
 connect(y[1], value);

end Wind_Hamburg_3600s_TMY;