within TransiEnt.Components.Heat;
model SteamVolumeWithValve_L0 "A steam volume unit following VDI3508"
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

extends TransiEnt.Basics.Icons.Block;
extends ClaRa.Basics.Icons.HEX01;

  Modelica.Blocks.Interfaces.RealInput m_flow_steam_in "Inflowing steam with setpoint enthalpy" annotation (Placement(transformation(extent={{-124,-20},{-84,20}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput m_flow_steam_out "Connector of Real output signal" annotation (Placement(transformation(extent={{98,-10},{118,10}}, rotation=0)));
  Modelica.Blocks.Continuous.Integrator SteamStorage(k=1/T, y_start=y_start) annotation (Placement(transformation(extent={{-22,-22},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput opening "Valve opening" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,84})));
  Modelica.Blocks.Math.Product Valve annotation (Placement(transformation(extent={{38,-12},{70,20}})));
  Modelica.Blocks.Math.MultiSum massBalance(nu=2, k={1,-1})
                                                  annotation (Placement(transformation(extent={{-74,-22},{-42,10}})));
  parameter SI.Time T=100 "Integrator time constant";
  parameter Real y_start=0 "Initial or guess value of output (= state)";
equation
  connect(massBalance.u[1], m_flow_steam_in) annotation (Line(points={{-74,-0.4},{-90,-0.4},{-90,0},{-104,0}}, color={0,0,127}));
  connect(massBalance.y, SteamStorage.u) annotation (Line(points={{-39.28,-6},{-32,-6},{-25.2,-6}}, color={0,0,127}));
  connect(SteamStorage.y, Valve.u2) annotation (Line(points={{11.6,-6},{34.8,-6},{34.8,-5.6}}, color={0,0,127}));
  connect(Valve.y, m_flow_steam_out) annotation (Line(points={{71.6,4},{84,4},{84,0},{108,0}}, color={0,0,127}));
  connect(Valve.y, massBalance.u[2]) annotation (Line(points={{71.6,4},{84,4},{84,-74},{-88,-74},{-88,-11.6},{-74,-11.6}}, color={0,0,127}));
  connect(opening, Valve.u1) annotation (Line(points={{0,100},{0,56},{20,56},{20,13.6},{34.8,13.6}}, color={0,0,127}));
  annotation (defaultComponentName="SteamVolume", Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end SteamVolumeWithValve_L0;
