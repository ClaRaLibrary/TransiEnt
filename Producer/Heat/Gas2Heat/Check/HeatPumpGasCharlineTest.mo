within TransiEnt.Producer.Heat.Gas2Heat.Check;
model HeatPumpGasCharlineTest
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
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T=308.15)
                                                                                    annotation (Placement(transformation(extent={{50,-10},{30,10}})));
  Modelica.Blocks.Sources.Sine sine1(
    amplitude=1500,
    freqHz=1/86400,
    offset=2000) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-70,0})));
  TransiEnt.Producer.Heat.Gas2Heat.HeatPumpGasCharlineHeatPort_L1 heatPump(use_T_source_input_K=true, COP_n=1.5) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi GasGrid annotation (Placement(transformation(extent={{-34,-42},{-14,-22}})));
  Modelica.Blocks.Math.Gain gain1(
                                 k=-1) annotation (Placement(transformation(extent={{-34,-4},{-26,4}})));
  Modelica.Blocks.Sources.Sine sine2(
    freqHz=1/86400,
    amplitude=15,
    phase=1.5707963267949,
    offset=-5 + 273.15)
                 annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-20,40})));
equation
  connect(heatPump.heat, fixedTemperature1.port) annotation (Line(points={{10,0},{30,0}}, color={191,0,0}));
  connect(gain1.y, heatPump.Q_flow_set) annotation (Line(points={{-25.6,0},{-10.4,0}}, color={0,0,127}));
  connect(GasGrid.gasPort, heatPump.gasIn) annotation (Line(
      points={{-14,-32},{10,-32},{10,-4}},
      color={255,255,0},
      thickness=1.5));
  connect(sine1.y, gain1.u) annotation (Line(points={{-59,0},{-34.8,0}}, color={0,0,127}));
  connect(sine2.y, heatPump.T_source_input_K) annotation (Line(points={{-9,40},{0,40},{0,10.6}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=432000, Interval=900));
end HeatPumpGasCharlineTest;
