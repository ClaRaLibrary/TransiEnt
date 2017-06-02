within TransiEnt.Components.Boundaries.FluidFlow.Check;
model TestBoundaryVLE_phxi

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
  BoundaryVLE_Txim_flow boundaryVLE_hxim_flow(variable_m_flow=true, variable_xi=false) annotation (Placement(transformation(extent={{-32,-18},{-12,2}})));
  Modelica.Blocks.Sources.Step m_flow_set(
    height=20,
    offset=-10,
    startTime=5) annotation (Placement(transformation(extent={{-66,-12},{-46,8}})));
  BoundaryVLE_phxi boundaryVLE_phxi(boundaryConditions(showData=true)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={10,-8})));
  Visualization.Quadruple                      quadruple1 annotation (Placement(transformation(extent={{10,10},{92,72}})));
  Visualization.Quadruple                      quadruple2 annotation (Placement(transformation(extent={{0,-96},{82,-34}})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(boundaryVLE_hxim_flow.fluidPortOut, boundaryVLE_phxi.fluidPortIn) annotation (Line(
      points={{-12.2,-8.2},{0.2,-8.2},{0.2,-7.8}},
      color={175,0,0},
      thickness=0.5));
  connect(m_flow_set.y, boundaryVLE_hxim_flow.m_flow) annotation (Line(points={{-45,-2},{-39.5,-2},{-34,-2}}, color={0,0,127}));
  connect(boundaryVLE_phxi.eye, quadruple1.eye) annotation (Line(points={{0,0},{-6,0},{-6,41},{10,41}}, color={190,190,190}));
  connect(boundaryVLE_hxim_flow.eye, quadruple2.eye) annotation (Line(points={{-12,-16},{-6,-16},{-6,-65},{0,-65}}, color={190,190,190}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=10),
    __Dymola_experimentSetupOutput);
end TestBoundaryVLE_phxi;
