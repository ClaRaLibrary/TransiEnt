within TransiEnt.Storage.Gas.Check;
model TestGasStorage_varXi_L2
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

  TransiEnt.Storage.Gas.GasStorage_varXi_L2 compressedGasStorage(V_geo=500000) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  inner TransiEnt.SimCenter simCenter                                                                    annotation (Placement(transformation(extent={{-90,-100},{-70,-80}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundaryRealGas_Txim_flow1(variable_m_flow=true, variable_xi=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,40})));
  Modelica.Blocks.Sources.TimeTable timeTable1(table=[0,-1000; 1000,0; 2000,0])
                                                                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={6,72})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundaryRealGas_Txim_flow3(variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-40})));
  Modelica.Blocks.Sources.TimeTable timeTable3(table=[0,0; 1000,0; 2000,1000])
                                                                            annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-6,-70})));
  Modelica.Blocks.Sources.CombiTimeTable
                                    timeTable2(table=[0,1,0.0,0.0,0.0,0.0,0.0; 200,1,0.0,0.0,0.0,0.0,0.0; 400,0.5,0.5,0.0,0.0,0.0,0.0; 600,0.5,0.5,0.0,0.0,0.0,0.0; 800,0.0,0.0,0.0,0.0,0.0,0.0; 1000,0.0,0.0,0.0,0.0,0.0,0.0; 2000,0.0,0.0,0.0,0.0,0.0,0.0])
                                                                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-26,72})));

equation
  connect(boundaryRealGas_Txim_flow1.m_flow,timeTable1. y) annotation (Line(points={{6,52},{6,61}},           color={0,0,127}));
  connect(boundaryRealGas_Txim_flow3.m_flow,timeTable3. y) annotation (Line(points={{-6,-52},{-6,-59}}, color={0,0,127}));
  connect(timeTable2.y, boundaryRealGas_Txim_flow1.xi) annotation (Line(points={{-26,61},{-26,58},{-6,58},{-6,52}}, color={0,0,127}));
  connect(boundaryRealGas_Txim_flow1.gasPort, compressedGasStorage.gasPortIn) annotation (Line(
      points={{0,30},{0,4.9}},
      color={255,255,0},
      thickness=1.5));
  connect(compressedGasStorage.gasPortOut, boundaryRealGas_Txim_flow3.gasPort) annotation (Line(
      points={{0,-6.3},{0,-30}},
      color={255,255,0},
      thickness=1.5));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=2000, __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput);
end TestGasStorage_varXi_L2;
