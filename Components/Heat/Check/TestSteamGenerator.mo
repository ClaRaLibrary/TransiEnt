within TransiEnt.Components.Heat.Check;
model TestSteamGenerator
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
  extends Basics.Icons.Checkmodel;
  SteamGenerator_L0 SteamGenerator(
    T_u=120,
    T_g=200,
    y_start=1)                                   annotation (Placement(transformation(extent={{-8,14},{28,44}})));
  Modelica.Blocks.Sources.Step Q_flow_set(
    height=-0.5,
    offset=1,
    startTime=7200) annotation (Placement(transformation(extent={{-54,18},{-34,38}})));
equation
  connect(Q_flow_set.y, SteamGenerator.Q_flow_set) annotation (Line(points={{-33,28},{-8.72,28},{-8.72,29}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-100,100},{12,52}},
          lineColor={0,0,0},
          textString="Look at:
SteamGenerator.Q_flow_set
SteamGenerator.m_flow_set")}),
    experiment(StopTime=20000),
    __Dymola_experimentSetupOutput);
end TestSteamGenerator;
