within TransiEnt.Grid.Heat.HeatGridControl.Check;
model TestSupplyAndReturnTemperatureDHG
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
 extends TransiEnt.Basics.Icons.Checkmodel;

  Modelica.Blocks.Sources.Ramp T_amb(
    duration=3600,
    height=-35,
    offset=20) annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

  function plotResult

  algorithm
  createPlot(id=1, position={0, 0, 1408, 910}, x="T_amb.y", y={"supplyAndReturnTemperatureDHG.T_set[1]", "supplyAndReturnTemperatureDHG.T_set[2]"}, range={-15.0, 20.0, 45.0, 140.0}, grid=true, filename="TestSupplyAndReturnTemperatureDHG.mat", colors={{28,108,200}, {238,46,47}});

  end plotResult;

  SupplyAndReturnTemperatureDHG supplyAndReturnTemperatureDHG(T_set_DHG=Base.T_set_DHG.Sample_T_set_DHG()) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(T_amb.y, supplyAndReturnTemperatureDHG.T_amb) annotation (Line(points={{-29,0},{-12,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=3600));
end TestSupplyAndReturnTemperatureDHG;
