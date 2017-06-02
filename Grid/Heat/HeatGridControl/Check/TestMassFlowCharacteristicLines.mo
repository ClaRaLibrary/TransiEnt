within TransiEnt.Grid.Heat.HeatGridControl.Check;
model TestMassFlowCharacteristicLines
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

  MassFlowCharacteristicLines massFlowCharacteristicLines(MassFlowCL=Base.DHGMassFlowCharacteristicLines.SampleMassFlowCharacteristicLines())
                                                          annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Modelica.Blocks.Sources.Ramp m_flow_total(
    duration=3600,
    height=12525/3.6,
    offset=1685/3.6)                        annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

  function plotResult

  algorithm
    createPlot(id=1, position={0, 0, 1481, 910}, y={"massFlowCharacteristicLines.m_flow_i[1]", "massFlowCharacteristicLines.m_flow_i[2]",
    "massFlowCharacteristicLines.m_flow_i[3]", "massFlowCharacteristicLines.m_flow_i[4]",
    "m_flow_total.y"}, range={0.0, 3600.0, -500.0, 14500.0}, grid=true, filename="TestMassFlowCharacteristicLines.mat", colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}, {0,0,0}});

  end plotResult;

equation
  connect(massFlowCharacteristicLines.m_flow_total, m_flow_total.y) annotation (Line(points={{-14,0},{-22,0},{-29,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=3600));
end TestMassFlowCharacteristicLines;
