within TransiEnt.Components.Heat;
model SteamTurbine_L0 "A steam generation unit following VDI3508"
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
extends ClaRa.Basics.Icons.SimpleTurbine;

  parameter Real x_highPressureStage=0.2 "Fraction of power provided by high pressure turbine stage (fast response)";
  parameter SI.Time T_lowPressure=60;
  parameter Real y_start_lowPressure=0 "Initial or guess value of output (= state)";

  Modelica.Blocks.Interfaces.RealInput Q_flow_in "Steam energy at input" annotation (Placement(transformation(extent={{-124,-20},{-84,20}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput
             y "Connector of Real output signal" annotation (Placement(
        transformation(extent={{98,-10},{118,10}},  rotation=0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(
    k=1 - x_highPressureStage,
    T=T_lowPressure,
    y_start=y_start_lowPressure)                   annotation (Placement(transformation(extent={{-34,-16},{-2,16}})));

  Modelica.Blocks.Math.MultiSum energyBalance(nu=2) annotation (Placement(transformation(extent={{26,-16},{58,16}})));
  Modelica.Blocks.Math.Gain highPressureStage(k=x_highPressureStage) annotation (Placement(transformation(extent={{-34,38},{-2,70}})));

equation
  connect(energyBalance.y, y) annotation (Line(points={{60.72,0},{108,0}}, color={0,0,127}));
  connect(firstOrder.y, energyBalance.u[1]) annotation (Line(points={{-0.4,0},{12,0},{12,5.6},{26,5.6}}, color={0,0,127}));
  connect(Q_flow_in, firstOrder.u) annotation (Line(points={{-104,0},{-37.2,0}}, color={0,0,127}));
  connect(Q_flow_in, highPressureStage.u) annotation (Line(points={{-104,0},{-84,0},{-58,0},{-58,54},{-37.2,54}}, color={0,0,127}));
  connect(highPressureStage.y, energyBalance.u[2]) annotation (Line(points={{-0.4,54},{10,54},{10,-5.6},{26,-5.6}}, color={0,0,127}));
  annotation (defaultComponentName="SteamTurbine", Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end SteamTurbine_L0;
