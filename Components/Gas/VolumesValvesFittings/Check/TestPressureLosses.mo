within TransiEnt.Components.Gas.VolumesValvesFittings.Check;
model TestPressureLosses

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2020, Hamburg University of Technology.                              //
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
  PipeFlow_L4_Simple_isoth                                                pipe_physPL(
    frictionAtInlet=false,
    frictionAtOutlet=false,
    redeclare model PressureLoss = TransiEnt.Components.Gas.VolumesValvesFittings.Base.PhysicalPL_L4_constVisc (k=0.1e-3),
    p_nom={16.6991,16.0588,15.3918}*1e5,
    h_nom=pipe_physPL.h_start,
    m_flow_nom=25,
    Delta_p_nom(displayUnit="bar") = 162123,
    p_start={16.6991,16.0588,15.3918}*1e5,
    T_start(displayUnit="K"),
    length=10e3,
    diameter_i=0.5,
    N_cv=3) annotation (Placement(transformation(extent={{-14,56},{14,64}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow(variable_m_flow=true, m_flow_const=25)
                                                                                                      annotation (Placement(transformation(extent={{60,50},{40,70}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi1     annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  inner TransiEnt.SimCenter simCenter(showExpertSummary=true, useConstCompInGasComp=true)
                                                              annotation (Placement(transformation(extent={{-90,-100},{-70,-80}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    height=-24.9,
    duration=86400 - 3600*2,
    offset=25,
    startTime=3600) annotation (Placement(transformation(extent={{92,6},{72,26}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_isoth pipe_linPL(
    frictionAtInlet=false,
    frictionAtOutlet=false,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    p_nom={16.6991,16.0588,15.3918}*1e5,
    h_nom=pipe_linPL.h_start,
    m_flow_nom=25,
    Delta_p_nom(displayUnit="bar") = 162123,
    p_start={16.6991,16.0588,15.3918}*1e5,
    T_start(displayUnit="K"),
    length=10e3,
    diameter_i=0.5,
    N_cv=3) annotation (Placement(transformation(extent={{-14,6},{14,14}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow1(variable_m_flow=true, m_flow_const=25)
                                                                                                      annotation (Placement(transformation(extent={{60,0},{40,20}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi2      annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_isoth pipe_quadVLEPL(
    frictionAtInlet=false,
    frictionAtOutlet=false,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.QuadraticNominalPoint_L4,
    p_nom={16.6991,16.0588,15.3918}*1e5,
    h_nom=pipe_quadVLEPL.h_start,
    m_flow_nom=25,
    Delta_p_nom(displayUnit="bar") = 162123,
    p_start={16.6991,16.0588,15.3918}*1e5,
    T_start(displayUnit="K"),
    length=10e3,
    diameter_i=0.5,
    N_cv=3) annotation (Placement(transformation(extent={{-14,-46},{14,-38}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow3(variable_m_flow=true, m_flow_const=25)
                                                                                                      annotation (Placement(transformation(extent={{60,-52},{40,-32}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi3  annotation (Placement(transformation(extent={{-60,-52},{-40,-32}})));
equation
  connect(boundary_Txim_flow.gasPort, pipe_physPL.gasPortOut) annotation (Line(
      points={{40,60},{14,60}},
      color={255,255,0},
      thickness=1.5));
  connect(boundary_pTxi1.gasPort, pipe_physPL.gasPortIn) annotation (Line(
      points={{-40,60},{-14,60}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp1.y, boundary_Txim_flow.m_flow) annotation (Line(points={{71,16},{68,16},{68,66},{62,66}}, color={0,0,127}));
  connect(ramp1.y, boundary_Txim_flow1.m_flow) annotation (Line(points={{71,16},{62,16}}, color={0,0,127}));
  connect(boundary_pTxi2.gasPort, pipe_linPL.gasPortIn) annotation (Line(
      points={{-40,10},{-14,10}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe_linPL.gasPortOut, boundary_Txim_flow1.gasPort) annotation (Line(
      points={{14,10},{40,10}},
      color={255,255,0},
      thickness=1.5));
  connect(boundary_Txim_flow3.gasPort, pipe_quadVLEPL.gasPortOut) annotation (Line(
      points={{40,-42},{14,-42}},
      color={255,255,0},
      thickness=1.5));
  connect(boundary_pTxi3.gasPort, pipe_quadVLEPL.gasPortIn) annotation (Line(
      points={{-40,-42},{-14,-42}},
      color={255,255,0},
      thickness=1.5));
  connect(boundary_Txim_flow3.m_flow, ramp1.y) annotation (Line(points={{62,-36},{68,-36},{68,16},{71,16}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-16,76},{18,70}},
          lineColor={28,108,200},
          textString="physical PL"),
        Text(
          extent={{-16,26},{18,20}},
          lineColor={28,108,200},
          textString="linear PL"),
        Text(
          extent={{-16,-26},{18,-32}},
          lineColor={28,108,200},
          textString="quadratic PL")}),
    experiment(
      StopTime=86400,
      Interval=900,
      Tolerance=1e-06,
      __Dymola_Algorithm="Sdirk34hw"));
end TestPressureLosses;
