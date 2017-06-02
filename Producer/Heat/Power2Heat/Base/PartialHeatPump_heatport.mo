within TransiEnt.Producer.Heat.Power2Heat.Base;
partial model PartialHeatPump_heatport
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
  extends PartialHeatPump;
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatFlowBoundary annotation (Placement(transformation(extent={{72,-10},{92,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatPort annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));
equation
  connect(heatFlowBoundary.port,heatPort)  annotation (Line(points={{92,0},{92,0},{100,0}},
                                                                                     color={191,0,0}));
end PartialHeatPump_heatport;
