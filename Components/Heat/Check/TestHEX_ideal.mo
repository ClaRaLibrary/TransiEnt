within TransiEnt.Components.Heat.Check;
model TestHEX_ideal
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
  HEX_ideal HEX annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow boundaryIn(
      m_flow_const=5, T_const=293.15)
    annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryOut(p_const=1e5, T_const=
        273.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={62,0})));
  ClaRa.Components.BoundaryConditions.PrescribedHeatFlowScalar
    prescribedHeatFlowScalar annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,32})));
  Modelica.Blocks.Sources.Ramp ramp(height=1e10, duration=1000)
    annotation (Placement(transformation(extent={{-60,28},{-40,48}})));
  inner TransiEnt.SimCenter simCenter
    annotation (Placement(transformation(extent={{-68,66},{-48,86}})));
equation
  connect(boundaryIn.steam_a, HEX.waterPortIn) annotation (Line(
      points={{-46,0},{-10,0}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(HEX.waterPortOut, boundaryOut.steam_a) annotation (Line(
      points={{10,0},{52,0}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(prescribedHeatFlowScalar.port, HEX.heatport) annotation (Line(
      points={{0,22},{0,9.8}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));
  connect(ramp.y, prescribedHeatFlowScalar.Q_flow) annotation (Line(
      points={{-39,38},{-22,38},{-22,50},{0,50},{0,42}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),      graphics), experiment(StopTime=1500));
end TestHEX_ideal;
