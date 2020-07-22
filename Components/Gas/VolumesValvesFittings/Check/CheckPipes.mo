within TransiEnt.Components.Gas.VolumesValvesFittings.Check;
model CheckPipes
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

  import TransiEnt;

  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  inner ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-60,80},{-40,100}})));

  SI.SpecificEnthalpy h_source_out=source_mFlow.gasPort.h_outflow;
  SI.SpecificEnthalpy h_pipe_in=inStream(pipe.gasPortIn.h_outflow);
  SI.SpecificEnthalpy h_pipe_out=pipe.gasPortOut.h_outflow;
  SI.SpecificEnthalpy h_sink_in=inStream(sink_p.gasPort.h_outflow);

  SI.SpecificEnthalpy h_source1_out=source_mFlow1.gasPort.h_outflow;
  SI.SpecificEnthalpy h_pipe1_in=inStream(pipe1.gasPortIn.h_outflow);
  SI.SpecificEnthalpy h_pipe1_out=pipe1.gasPortOut.h_outflow;
  SI.SpecificEnthalpy h_sink1_in=inStream(sink_p1.gasPort.h_outflow);

  SI.SpecificEnthalpy h_source2_out=source_mFlow2.gasPort.h_outflow;
  SI.SpecificEnthalpy h_pipe2_in=inStream(pipe2.gasPortIn.h_outflow);
  SI.SpecificEnthalpy h_pipe2_out=pipe2.gasPortOut.h_outflow;
  SI.SpecificEnthalpy h_sink2_in=inStream(sink_p2.gasPort.h_outflow);


  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow boundaryVLE_hxim_flow(h_const=800e3, m_flow_const=-20) annotation (Placement(transformation(extent={{-54,42},{-34,62}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi boundaryVLE_phxi(p_const=16e5, h_const=800e5) annotation (Placement(transformation(extent={{100,42},{80,62}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow boundary_mFlow(
    medium=simCenter.gasModel1,
    xi_const=boundary_mFlow.medium.xi_default,
    m_flow_const=88.949/2/3,
    T_const=simCenter.T_ground,
    variable_m_flow=true,
    variable_xi=true) annotation (Placement(transformation(extent={{-54,2},{-34,22}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_phxi1(
    medium=simCenter.gasModel1,
    p_const=14.5e5,
    T_const=simCenter.T_ground)                                                                       annotation (Placement(transformation(extent={{100,2},{80,22}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L2_Simple pipeFlow_L2_Simple(
    m_flow_nom=10,
    Delta_p_nom=1e5,
    frictionAtInlet=false,
    frictionAtOutlet=true) annotation (Placement(transformation(extent={{8,47},{36,57}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple pipe_L4(
    frictionAtInlet=false,
    frictionAtOutlet=true,
    medium=simCenter.gasModel1,
    h_start=ones(pipe_L4.N_cv)*(-1849),
    xi_start=pipe_L4.medium.xi_default,
    m_flow_nom=88.949/3,
    Delta_p_nom=534880,
    p_nom=ones(pipe_L4.N_cv)*17e5,
    h_nom=ones(pipe_L4.N_cv)*(-1849),
    length=30650,
    diameter_i=0.366,
    p_start=linspace(
        17e5,
        14.5e5,
        pipe_L4.N_cv),
    initOption=208,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.QuadraticNominalPoint_L4 (rho_nom=14.4327)) annotation (Placement(transformation(extent={{8,7},{36,17}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink_p(p_const=1450000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={88,-22})));
 PipeFlow_L4_Simple pipe(
    diameter_i=0.366,
    Delta_p_nom(displayUnit="bar") = 534880,
    length=30650,
    m_flow_nom=88.949/3,
    N_tubes=1,
    m_flow_start=ones(pipe.N_cv + 1)*88.949/3,
    frictionAtInlet=false,
    frictionAtOutlet=true,
    p_nom=ones(pipe.N_cv)*17e5,
    h_nom=ones(pipe.N_cv)*(-1849),
    h_start=ones(pipe.N_cv)*(-1849),
    p_start=ones(pipe.N_cv)*17e5) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=0,
        origin={22,-22})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source_mFlow(variable_m_flow=false, m_flow_const=-88.949/2/3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-42,-22})));
  PipeFlow_L4_Simple pipe1(
    diameter_i=0.366,
    Delta_p_nom(displayUnit="bar") = 534880,
    length=30650,
    m_flow_nom=88.949/3,
    N_tubes=1,
    frictionAtOutlet=true,
    p_nom=ones(pipe1.N_cv)*17e5,
    h_nom=ones(pipe1.N_cv)*(-1849),
    h_start=ones(pipe1.N_cv)*(-1849),
    frictionAtInlet=false,
    p_start=linspace(
        17,
        14.5,
        pipe1.N_cv),
    N_cv=3,
    m_flow_start=ones(pipe1.N_cv + 1)*88.949/3/2,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.QuadraticNominalPoint_L4) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=0,
        origin={22,-52})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source_mFlow1(                       m_flow_const=-88.949/2/3,
    variable_m_flow=true,
    variable_xi=true)                                                                                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-42,-52})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink_p1(p_const=1450000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={88,-52})));
  PipeFlow_L4_Simple pipe2(
    constantComposition=true,
    diameter_i=0.366,
    Delta_p_nom(displayUnit="bar") = 534880,
    length=30650,
    N_tubes=3,
    m_flow_nom=88.949/3,
    frictionAtOutlet=true,
    frictionAtInlet=false,
    h_start=ones(pipe2.N_cv)*(-1849),
    p_nom=ones(pipe2.N_cv)*17e5,
    p_start=linspace(
        17,
        14.5,
        pipe2.N_cv),
    h_nom=ones(pipe2.N_cv)*(-1849)) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=0,
        origin={22,-82})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source_mFlow2(variable_m_flow=false, m_flow_const=-88.949/2/3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-42,-82})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink_p2(p_const=1450000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={88,-82})));
  Modelica.Blocks.Sources.Constant const(k=-88.949/2/3) annotation (Placement(transformation(extent={{-102,-32},{-82,-12}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=-88.949/2/3/2,
    offset=-88.949/2/3/2,
    startTime=390,
    freqHz=1/120)  annotation (Placement(transformation(extent={{-102,-62},{-82,-42}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(extent={{-70,14},{-62,22}})));
  TransiEnt.Components.Boundaries.Gas.RealGasCompositionByWtFractions_stepVariation realGasCompositionByWtFractions_stepVariation(
    xiNumber=7,
    period=240,
    stepsize=0.011)
                  annotation (Placement(transformation(extent={{-102,-4},{-82,16}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_isoth
                     pipe3(
    diameter_i=0.366,
    Delta_p_nom(displayUnit="bar") = 534880,
    length=30650,
    m_flow_nom=88.949/3,
    N_tubes=1,
    frictionAtOutlet=true,
    p_nom=ones(pipe1.N_cv)*17e5,
    h_nom=ones(pipe1.N_cv)*(-1849),
    h_start=ones(pipe1.N_cv)*(-1849),
    frictionAtInlet=false,
    p_start=linspace(
        17,
        14.5,
        pipe1.N_cv),
    N_cv=3,
    m_flow_start=ones(pipe1.N_cv + 1)*88.949/3/2,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.QuadraticNominalPoint_L4) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=0,
        origin={22,-112})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source_mFlow3(
    m_flow_const=-88.949/2/3,
    variable_m_flow=true,
    variable_xi=true)                                                                                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-42,-112})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink_p3(p_const=1450000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={88,-112})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_isoth
                     pipe4(
    constantComposition=true,
    diameter_i=0.366,
    Delta_p_nom(displayUnit="bar") = 534880,
    length=30650,
    N_tubes=3,
    m_flow_nom=88.949/3,
    frictionAtOutlet=true,
    frictionAtInlet=false,
    h_start=ones(pipe2.N_cv)*(-1849),
    p_nom=ones(pipe2.N_cv)*17e5,
    p_start=linspace(
        17,
        14.5,
        pipe2.N_cv),
    h_nom=ones(pipe2.N_cv)*(-1849)) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=0,
        origin={22,-142})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source_mFlow4(variable_m_flow=false, m_flow_const=-88.949/2/3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-42,-142})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink_p4(p_const=1450000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={88,-142})));
equation
  connect(boundaryVLE_hxim_flow.steam_a, pipeFlow_L2_Simple.inlet) annotation (Line(
      points={{-34,52},{8,52}},
      color={0,131,169},
      thickness=0.5));
  connect(pipeFlow_L2_Simple.outlet, boundaryVLE_phxi.steam_a) annotation (Line(
      points={{36,52},{36,52},{80,52}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundary_mFlow.steam_a, pipe_L4.inlet) annotation (Line(
      points={{-34,12},{8,12}},
      color={0,131,169},
      thickness=0.5));
  connect(pipe_L4.outlet, boundaryVLE_phxi1.steam_a) annotation (Line(
      points={{36,12},{36,12},{80,12}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pipe.gasPortOut, sink_p.gasPort) annotation (Line(
      points={{36,-22},{36,-22},{78,-22}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe.gasPortIn, source_mFlow.gasPort) annotation (Line(
      points={{8,-22},{-32,-22}},
      color={255,255,0},
      thickness=1.5));
  connect(source_mFlow1.gasPort, pipe1.gasPortIn) annotation (Line(
      points={{-32,-52},{8,-52}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe1.gasPortOut, sink_p1.gasPort) annotation (Line(
      points={{36,-52},{58,-52},{78,-52}},
      color={255,255,0},
      thickness=1.5));
  connect(source_mFlow2.gasPort, pipe2.gasPortIn) annotation (Line(
      points={{-32,-82},{-12,-82},{8,-82}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe2.gasPortOut, sink_p2.gasPort) annotation (Line(
      points={{36,-82},{57,-82},{78,-82}},
      color={255,255,0},
      thickness=1.5));
  connect(boundary_mFlow.m_flow, gain.y) annotation (Line(points={{-56,18},{-56,18},{-61.6,18}}, color={0,0,127}));
  connect(sine.y, gain.u) annotation (Line(points={{-81,-52},{-78,-52},{-76,-52},{-76,18},{-70.8,18}}, color={0,0,127}));
  connect(sine.y, source_mFlow1.m_flow) annotation (Line(points={{-81,-52},{-76,-52},{-76,-46},{-54,-46}}, color={0,0,127}));
  connect(realGasCompositionByWtFractions_stepVariation.xi, boundary_mFlow.xi) annotation (Line(points={{-82,6},{-72,6},{-56,6}}, color={0,0,127}));
  connect(realGasCompositionByWtFractions_stepVariation.xi, source_mFlow1.xi) annotation (Line(points={{-82,6},{-72,6},{-72,-58},{-54,-58}}, color={0,0,127}));
  connect(source_mFlow3.gasPort,pipe3. gasPortIn) annotation (Line(
      points={{-32,-112},{8,-112}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe3.gasPortOut,sink_p3. gasPort) annotation (Line(
      points={{36,-112},{78,-112}},
      color={255,255,0},
      thickness=1.5));
  connect(source_mFlow4.gasPort,pipe4. gasPortIn) annotation (Line(
      points={{-32,-142},{8,-142}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe4.gasPortOut,sink_p4. gasPort) annotation (Line(
      points={{36,-142},{78,-142}},
      color={255,255,0},
      thickness=1.5));
  connect(sine.y,source_mFlow3. m_flow) annotation (Line(points={{-81,-52},{-76,-52},{-76,-106},{-54,-106}},
                                                                                                           color={0,0,127}));
  connect(realGasCompositionByWtFractions_stepVariation.xi,source_mFlow3. xi) annotation (Line(points={{-82,6},{-72,6},{-72,-118},{-54,-118}},
                                                                                                                                             color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false, extent={{-120,-160},{120,100}})),
                                                                 Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-120,-160},{120,100}}), graphics={Text(
          extent={{-18,94},{76,72}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="#2017/11/2, LA:
in ClaRa pipe there is no possibility to set xi_nom for rho_nom calculation, instead xi_nom=zeros(nc-1) is taken
=> rho_nom has to be calculated and set manually")}),
    experiment(
      StopTime=600,
      Interval=1,
      Tolerance=1e-006,
      __Dymola_Algorithm="Cvode"),
    __Dymola_experimentSetupOutput(inputs=false),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the pipe models</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end CheckPipes;
