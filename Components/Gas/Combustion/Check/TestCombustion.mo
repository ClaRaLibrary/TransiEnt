within TransiEnt.Components.Gas.Combustion.Check;
model TestCombustion
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
  extends TransiEnt.Basics.Icons.Checkmodel;

  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

  FullConversion_idealGas combustion annotation (Placement(transformation(extent={{-18,-18},{18,18}})));
  Boundaries.Gas.BoundaryIdealGas_pTxi fuelBoundary(gasModel=simCenter.gasModel2) annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryIdealGas_pTxi exhaustBoundary(gasModel=simCenter.exhaustGasModel) annotation (Placement(transformation(extent={{60,-10},{40,10}})));

equation
  combustion.gasPortIn.m_flow=1;
  connect(fuelBoundary.gasPort, combustion.gasPortIn) annotation (Line(
      points={{-40,0},{-40,0},{-18,0}},
      color={255,213,170},
      thickness=0.5));
  connect(exhaustBoundary.gasPort, combustion.gasPortOut) annotation (Line(
      points={{40,0},{18,0}},
      color={255,213,170},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end TestCombustion;
