within TransiEnt.Basics.Blocks.Check;
model TestSawTooth
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
  extends Icons.Checkmodel;
  Sources.SawTooth sawTooth(
    amplitude=7*86400,
    period=7*86400,
    startTime=6*86400) annotation (Placement(transformation(extent={{-20,-2},{0,18}})));
  annotation (experiment(StopTime=1.2096e+006, Interval=900), __Dymola_experimentSetupOutput);
end TestSawTooth;
