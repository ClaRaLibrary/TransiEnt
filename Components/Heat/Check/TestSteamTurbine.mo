within TransiEnt.Components.Heat.Check;
model TestSteamTurbine
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
  SteamTurbine_L0 SteamTurbine(T_lowPressure=200, y_start_lowPressure=0) annotation (Placement(transformation(extent={{12,-28},{48,2}})));
  Modelica.Blocks.Sources.Step m_flow_in(
    startTime=400,
    height=1,
    offset=0) annotation (Placement(transformation(extent={{-28,-22},{-8,-2}})));
equation
  connect(m_flow_in.y, SteamTurbine.Q_flow_in) annotation (Line(points={{-7,-12},{11.28,-12},{11.28,-13}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-100,100},{12,52}},
          lineColor={0,0,0},
          textString="Look at:
m_flow_in.y
SteamTurbine.y
SteamTurbine.x_highPressureStage")}),
    experiment(StopTime=4000),
    __Dymola_experimentSetupOutput);
end TestSteamTurbine;
