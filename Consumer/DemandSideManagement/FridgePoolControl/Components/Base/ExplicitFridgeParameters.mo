within TransiEnt.Consumer.DemandSideManagement.FridgePoolControl.Components.Base;
record ExplicitFridgeParameters
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

  constant Real A_over_m = 0.47;
  constant Real P_over_m = 10.48;

  parameter SI.Temperature Tamb;
  parameter SI.Temperature Tset;
  parameter SI.SpecificHeatCapacity cp;
  parameter SI.Mass m;
  parameter SI.CoefficientOfHeatTransfer k;
  parameter SI.TemperatureDifference DTdb;
  parameter Real COP;
  parameter SI.Temperature T0;
  parameter Real x0;

  final parameter SI.Power P_el_n = P_over_m * m;
  final parameter SI.Area A = A_over_m * m;
  final parameter SI.Time tau=m*cp/(k*A);
  final parameter Real k1=P_el_n/m*COP/cp;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end ExplicitFridgeParameters;
