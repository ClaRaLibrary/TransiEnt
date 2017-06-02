within TransiEnt.Components.Boundaries.Heat.Base;
partial model PartialHeatBoundary

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.HeatSink;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid  Medium=simCenter.fluid1 "Medium model";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut fluidPortOut(Medium=Medium) annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{76,-108},{96,-88}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn fluidPortIn(Medium=Medium) annotation (Placement(transformation(extent={{-10,-110},{10,-90}}), iconTransformation(extent={{-84,-108},{-64,-88}})));

  // _____________________________________________
  //
  //                Variables
  // _____________________________________________

  Modelica.SIunits.HeatFlowRate Q_flow_boundary = fluidPortIn.m_flow * (actualStream(fluidPortIn.h_outflow) - actualStream(fluidPortOut.h_outflow));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end PartialHeatBoundary;
