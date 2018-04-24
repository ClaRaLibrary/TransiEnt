within TransiEnt.Components.Boundaries.FluidFlow.Check;
model TestBoundaryVLE_hxim_flow

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Checkmodel;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  inner TransiEnt.SimCenter simCenter(Q_flow_n=100e3, m_flow_nom=1) annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  BoundaryVLE_hxim_flow boundaryVLE_hxim_flow(variable_m_flow=true, variable_xi=false,
    boundaryConditions(showData=true))                                                 annotation (Placement(transformation(extent={{-32,-18},{-12,2}})));
  Modelica.Blocks.Sources.Step m_flow_step(
    height=10,
    startTime=100,
    offset=20) annotation (Placement(transformation(extent={{-66,-12},{-46,8}})));
  Visualization.Quadruple                      quadruple2 annotation (Placement(transformation(extent={{0,-50},{40,-26}})));
  BoundaryVLE_phxi boundaryVLE_phxi(boundaryConditions(showData=true)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,2})));
  Visualization.Quadruple                      quadruple1 annotation (Placement(transformation(extent={{34,37},{74,63}})));
  BoundaryVLE_hxim_flow boundaryVLE_hxim_flow1(                     variable_xi=false,
    boundaryConditions(showData=true, m_flow_const=100),
    variable_m_flow=false)                                                             annotation (Placement(transformation(extent={{-32,30},{-12,50}})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(m_flow_step.y, boundaryVLE_hxim_flow.m_flow) annotation (Line(points={{-45,-2},{-39.5,-2},{-34,-2}}, color={0,0,127}));
  connect(boundaryVLE_hxim_flow.eye, quadruple2.eye) annotation (Line(points={{-12,-16},{-6,-16},{-6,-38},{0,-38}}, color={190,190,190}));
  connect(boundaryVLE_hxim_flow.fluidPortOut, boundaryVLE_phxi.fluidPortIn) annotation (Line(
      points={{-12.2,-8.2},{8.9,-8.2},{8.9,2.2},{20.2,2.2}},
      color={175,0,0},
      thickness=0.5));
  connect(boundaryVLE_phxi.eye, quadruple1.eye) annotation (Line(points={{20,10},{16,10},{16,50},{34,50}},                 color={190,190,190}));
  connect(boundaryVLE_hxim_flow1.fluidPortOut, boundaryVLE_phxi.fluidPortIn) annotation (Line(
      points={{-12.2,39.8},{0,39.8},{0,2.2},{20.2,2.2}},
      color={175,0,0},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=10),
    __Dymola_experimentSetupOutput);
end TestBoundaryVLE_hxim_flow;
