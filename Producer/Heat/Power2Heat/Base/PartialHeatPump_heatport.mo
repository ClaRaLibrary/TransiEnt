within TransiEnt.Producer.Heat.Power2Heat.Base;
partial model PartialHeatPump_heatport
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
  extends PartialHeatPump;
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatFlowBoundary annotation (Placement(transformation(extent={{72,-10},{92,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatPort annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));
equation
  connect(heatFlowBoundary.port,heatPort)  annotation (Line(points={{92,0},{92,0},{100,0}},
                                                                                     color={191,0,0}));
end PartialHeatPump_heatport;
