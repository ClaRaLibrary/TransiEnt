within TransiEnt.Components.Heat.Check;
model TestSteamVolumeWithValve
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
  extends Basics.Icons.Checkmodel;
  SteamVolumeWithValve_L0 SteamVolumeWithValve(y_start=1, T=900) annotation (Placement(transformation(extent={{12,-28},{48,2}})));
  Modelica.Blocks.Sources.Step Q_flow_set(
    height=0.5,
    offset=0.5,
    startTime=400)  annotation (Placement(transformation(extent={{-16,20},{4,40}})));
  Modelica.Blocks.Sources.Constant
                               Q_flow_set1(k=0.5)
                    annotation (Placement(transformation(extent={{-40,-26},{-20,-6}})));
equation
  connect(Q_flow_set.y, SteamVolumeWithValve.opening) annotation (Line(points={{5,30},{16,30},{30,30},{30,-0.4}}, color={0,0,127}));
  connect(Q_flow_set1.y, SteamVolumeWithValve.m_flow_steam_in) annotation (Line(points={{-19,-16},{-8,-16},{-8,-13},{11.28,-13}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-100,100},{12,52}},
          lineColor={0,0,0},
          textString="Look at:
SteamGenerator.Q_flow_set
SteamGenerator.m_flow_set")}),
    experiment(StopTime=8000),
    __Dymola_experimentSetupOutput);
end TestSteamVolumeWithValve;
