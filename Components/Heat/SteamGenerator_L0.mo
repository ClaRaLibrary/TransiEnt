within TransiEnt.Components.Heat;
model SteamGenerator_L0 "A steam generation unit following VDI3508"
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

extends TransiEnt.Basics.Icons.Block;
extends ClaRa.Basics.Icons.Boiler;

  Modelica.Blocks.Interfaces.RealInput Q_flow_set "Fuel energy flow setpoint" annotation (Placement(transformation(extent={{-124,-20},{-84,20}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput
             y "Connector of Real output signal" annotation (Placement(
        transformation(extent={{98,-10},{118,10}},  rotation=0)));
  Modelica.Blocks.Nonlinear.FixedDelay delay(delayTime=T_u) annotation (Placement(transformation(extent={{-52,-16},{-20,16}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(k=1, T=T_g,
    y_start=y_start)                               annotation (Placement(transformation(extent={{20,-16},{52,16}})));
  parameter SI.Time T_u=60;
  parameter SI.Time T_g=1800 "Time constant of heat release";
  parameter Real y_start=0 "Initial or guess value of output (= state)";
equation
  connect(Q_flow_set, delay.u) annotation (Line(points={{-104,0},{-55.2,0}}, color={0,0,127}));
  connect(delay.y, firstOrder.u) annotation (Line(points={{-18.4,0},{-2,0},{16.8,0}}, color={0,0,127}));
  connect(firstOrder.y, y) annotation (Line(points={{53.6,0},{108,0}}, color={0,0,127}));
  annotation (defaultComponentName="SteamGenerator", Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end SteamGenerator_L0;
