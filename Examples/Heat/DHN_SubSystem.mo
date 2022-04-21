within TransiEnt.Examples.Heat;
model DHN_SubSystem "A subsystem derived from DHN_StandAlone"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-BSD-clause.           //
// Copyright 2021, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE, ResiliEntEE, IntegraNet and IntegraNet II are research projects  //
// supported by the German Federal Ministry of Economics and Energy               //
// (FKZ 03ET4003, 03ET4048, 0324027 and 03EI1008).                                //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Fraunhofer Institute for Environmental, Safety, and Energy Technology UMSICHT, //
// Gas- und Wärme-Institut Essen						  //
// and                                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//






  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.fluid1 "Medium to be used" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter Modelica.Units.SI.Length L_grid=1000;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut consumerOutlet(Medium=medium) annotation (Placement(transformation(extent={{57,156},{63,162}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn consumerInlet(Medium=medium) annotation (Placement(transformation(extent={{117,157},{123,163}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn producerInlet(Medium=medium) annotation (Placement(transformation(extent={{-303,-103},{-297,-97}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut producerOutlet(Medium=medium) annotation (Placement(transformation(extent={{-303,-163},{-297,-157}})));
  TransiEnt.Basics.Interfaces.General.TemperatureOut T1 "Temperature in port medium" annotation (Placement(transformation(extent={{-300,-184},{-308,-176}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________



  // Consumer
  TransiEnt.Components.Boundaries.Heat.Heatflow_L1 consumer1(use_Q_flow_in=true, Medium=medium) annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=0,
        origin={-64,30})));
  TransiEnt.Basics.Blocks.Sources.HeatExpression heatExpression(y=-0.5e6) annotation (Placement(transformation(extent={{-102,44},{-82,64}})));

  // Hydraulic Components
  ClaRa.Components.MechanicalSeparation.BalanceTank_L3 balanceTank1(
    diameter_i=10,
    s_wall=0.02,
    height=10,
    levelOutput=true,
    initFluid="Fixed value for filling level",
    gasMedium=simCenter.airModel,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearParallelZones_L3,
    T_gas_start=273.15 + 90,
    h_liq_start=600e3,
    p_start=18e5,
    relLevel_start=0.5,
    liquidMedium=medium) annotation (Placement(transformation(extent={{-150,-158},{-180,-128}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi pressurizer(
    showData=false,
    p_const=25e5,
    medium=medium) annotation (Placement(transformation(extent={{-104,-90},{-124,-70}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 make_up_ctrl_valve(
    checkValve=false,
    openingInputIsActive=true,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=2e5, m_flow_nom=50),
    medium=medium) annotation (Placement(transformation(
        extent={{9,-5},{-9,5}},
        rotation=0,
        origin={-142,-80})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveGas_L1 pressure_reduction_valve(medium=simCenter.airModel, redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=50e5, m_flow_nom=0.01)) annotation (Placement(transformation(
        extent={{10,6},{-10,-6}},
        rotation=0,
        origin={-142,-102})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi ambience(
    xi_const={0,0,0,0,0.79,0.21,0,0,0},
    medium=simCenter.airModel,
    p_const=1e5) annotation (Placement(transformation(extent={{-104,-111},{-124,-91}})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pump(medium=medium) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-136,-154})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y split_cold(
    volume=1,
    m_flow_out_nom={577/2,577/2},
    p_start=22e5,
    medium=medium) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-12,-154})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple pipe1(
    diameter_i=0.7,
    frictionAtInlet=true,
    frictionAtOutlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
    useHomotopy=true,
    showExpertSummary=true,
    showData=true,
    p_nom=linspace(
        1.0,
        0.33,
        pipe_N_cv.k)*20e5,
    h_nom=ones(pipe_N_cv.k)*467000,
    h_start=ones(pipe_N_cv.k)*400.0e3,
    p_start=linspace(
        1.0,
        0.33,
        pipe_N_cv.k)*21.0e5,
    N_cv=pipe_N_cv.k,
    m_flow_nom=250,
    length=1e3,
    Delta_p_nom=1e5,
    medium=medium) annotation (Placement(transformation(
        extent={{-17,-6},{17,6}},
        rotation=90,
        origin={-12,-37})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple pipe2(
    diameter_i=0.7,
    frictionAtInlet=true,
    frictionAtOutlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
    useHomotopy=true,
    showExpertSummary=true,
    showData=true,
    p_nom=linspace(
        1.0,
        0.33,
        pipe_N_cv.k)*20e5,
    h_nom=ones(pipe_N_cv.k)*467000,
    h_start=ones(pipe_N_cv.k)*400.0e3,
    p_start=linspace(
        1.0,
        0.33,
        pipe_N_cv.k)*21.0e5,
    N_cv=pipe_N_cv.k,
    m_flow_nom=250,
    Delta_p_nom=1e5,
    length=1e3,
    medium=medium) annotation (Placement(transformation(
        extent={{-17,-6},{17,6}},
        rotation=90,
        origin={120,-37})));
  ClaRa.Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y join_hot(
    volume=1,
    m_flow_in_nom={577/2,577/2},
    p_start=21e5,
    medium=medium,
    initOption=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-236,10})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple pipe3(
    diameter_i=0.7,
    frictionAtInlet=true,
    frictionAtOutlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
    useHomotopy=true,
    showExpertSummary=true,
    showData=true,
    p_nom=linspace(
        1.0,
        0.33,
        pipe_N_cv.k)*20e5,
    h_nom=ones(pipe_N_cv.k)*467000,
    h_start=ones(pipe_N_cv.k)*400.0e3,
    p_start=linspace(
        1.0,
        0.33,
        pipe_N_cv.k)*21.0e5,
    N_cv=pipe_N_cv.k,
    m_flow_nom=500,
    Delta_p_nom=1e5,
    length=1e3,
    medium=medium) annotation (Placement(transformation(
        extent={{17,-6},{-17,6}},
        rotation=90,
        origin={-236,-37})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple pipe4(
    diameter_i=0.7,
    frictionAtInlet=true,
    frictionAtOutlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
    useHomotopy=true,
    showExpertSummary=true,
    showData=true,
    p_nom=linspace(
        1.0,
        0.33,
        pipe_N_cv.k)*20e5,
    h_nom=ones(pipe_N_cv.k)*467000,
    h_start=ones(pipe_N_cv.k)*400.0e3,
    p_start=linspace(
        1.0,
        0.33,
        pipe_N_cv.k)*21.0e5,
    N_cv=pipe_N_cv.k,
    m_flow_nom=250,
    Delta_p_nom=1e4,
    length=1e3,
    medium=medium) annotation (Placement(transformation(
        extent={{-17,-6},{17,6}},
        rotation=180,
        origin={20,67})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow massFlowLosses(
    showData=true,
    m_flow_const=-0.26,
    medium=medium) annotation (Placement(transformation(extent={{-80,-188},{-60,-168}})));

  Modelica.Blocks.Sources.IntegerConstant pipe_N_cv(k=3) annotation (Placement(transformation(extent={{-264,140},{-244,160}})));
  ClaRa.Visualisation.Quadruple quadruple6(decimalSpaces(m_flow=2)) annotation (Placement(transformation(extent={{-46,-191},{10,-176}})));
  ClaRa.Visualisation.Quadruple quadruple1 annotation (Placement(transformation(extent={{122,-15},{178,2}})));
  ClaRa.Visualisation.Quadruple quadruple4 annotation (Placement(transformation(extent={{-4,-19},{50,-2}})));
  ClaRa.Visualisation.Quadruple quadruple3 annotation (Placement(transformation(extent={{-8,77},{44,92}})));
  ClaRa.Visualisation.Quadruple quadruple5 annotation (Placement(transformation(extent={{-292,-16},{-248,-3}})));
  ClaRa.Visualisation.StatePoint_phTs statePoint_phTs annotation (Placement(transformation(extent={{-172,10},{-152,32}})));
  ClaRa.Visualisation.Quadruple quadruple2 annotation (Placement(transformation(extent={{-288,-71},{-240,-58}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperature(unitOption=2, medium=medium) annotation (Placement(transformation(extent={{-198,-170},{-218,-190}})));
  ClaRa.Visualisation.Quadruple quadruple7 annotation (Placement(transformation(extent={{10,-147},{52,-132}})));
  Modelica.Blocks.Sources.Constant P_feedPump(k=1.5e4) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-160,-178})));
  ClaRa.Visualisation.Quadruple quadruple8 annotation (Placement(transformation(extent={{-120,-151},{-78,-136}})));

  // Control
  ClaRa.Components.Utilities.Blocks.LimPID PID_level(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_min=0,
    y_ref=1,
    y_max=1,
    sign=1,
    u_ref=1,
    Tau_i=600,
    y_start=0,
    k=10,
    y_inactive=0,
    t_activation=0,
    initOption=if ((Modelica.Blocks.Types.Init.InitialOutput) == Modelica.Blocks.Types.Init.SteadyState) then 798 elseif ((Modelica.Blocks.Types.Init.InitialOutput) == Modelica.Blocks.Types.Init.InitialOutput) then 796 elseif ((Modelica.Blocks.Types.Init.InitialOutput) == Modelica.Blocks.Types.Init.InitialState) then 797 elseif ((Modelica.Blocks.Types.Init.InitialOutput) == Modelica.Blocks.Types.Init.InitialState) then 795 else 501) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-156,-58})));
  Modelica.Blocks.Sources.Constant level_set(k=0.5) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=180,
        origin={-180,-58})));


equation
  // _____________________________________________
  //
  //           Connect Statements
  // _____________________________________________

  connect(pressure_reduction_valve.inlet, ambience.gas_a) annotation (Line(
      points={{-132,-102},{-126,-101},{-124,-101}},
      color={118,106,98},
      thickness=0.5));
  connect(balanceTank1.vent1, pressure_reduction_valve.outlet) annotation (Line(
      points={{-165,-128},{-165,-100.5},{-152,-100.5},{-152,-102}},
      color={118,106,98},
      thickness=0.5));
  connect(make_up_ctrl_valve.outlet, balanceTank1.inlet1) annotation (Line(
      points={{-151,-80},{-170,-80},{-170,-128}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pressurizer.steam_a, make_up_ctrl_valve.inlet) annotation (Line(
      points={{-124,-80},{-130,-80},{-133,-80}},
      color={0,131,169},
      thickness=0.5));
  connect(pump.outlet, split_cold.inlet) annotation (Line(
      points={{-126,-154},{-74,-154},{-22,-154}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(split_cold.outlet2, pipe1.inlet) annotation (Line(
      points={{-12,-144},{-12,-54}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pipe1.outlet, consumer1.fluidPortIn) annotation (Line(
      points={{-12,-20},{-12,-20},{-12,10},{-52,10}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pump.inlet, balanceTank1.outlet) annotation (Line(
      points={{-146,-154},{-150.4,-154},{-150.4,-153.8}},
      color={0,131,169},
      thickness=0.5));
  connect(split_cold.outlet1, pipe2.inlet) annotation (Line(
      points={{-2,-154},{-2,-154},{120,-154},{120,-54}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_hot.outlet, pipe3.inlet) annotation (Line(
      points={{-236,0},{-236,-20}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(join_hot.inlet2, consumer1.fluidPortOut) annotation (Line(
      points={{-226,10},{-76,10},{-76,10}},
      color={0,131,169},
      thickness=0.5));
  connect(join_hot.inlet1, pipe4.outlet) annotation (Line(
      points={{-236,20},{-236,67},{3,67}},
      color={0,131,169},
      thickness=0.5));
  connect(PID_level.y, make_up_ctrl_valve.opening_in) annotation (Line(points={{-145,-58},{-145,-58},{-142,-58},{-142,-72.5}}, color={0,0,127}));
  connect(level_set.y, PID_level.u_s) annotation (Line(points={{-173.4,-58},{-173.4,-58},{-168,-58}}, color={0,0,127}));
  connect(massFlowLosses.steam_a, split_cold.inlet) annotation (Line(
      points={{-60,-178},{-60,-178},{-44,-178},{-44,-154},{-22,-154}},
      color={0,131,169},
      thickness=0.5));
  connect(split_cold.eye[1], quadruple7.eye) annotation (Line(points={{-2,-148},{2,-148},{2,-139.5},{10,-139.5}}, color={190,190,190}));
  connect(massFlowLosses.eye, quadruple6.eye) annotation (Line(points={{-60,-186},{-46,-186},{-46,-183.5}}, color={190,190,190}));
  connect(pipe2.eye, quadruple1.eye) annotation (Line(points={{124.08,-19.2714},{124.08,-10.6357},{122,-10.6357},{122,-6.5}}, color={190,190,190}));
  connect(pipe1.eye, quadruple4.eye) annotation (Line(points={{-7.92,-19.2714},{-7.92,-14.6357},{-4,-14.6357},{-4,-10.5}}, color={190,190,190}));
  connect(pipe4.eye, quadruple3.eye) annotation (Line(points={{2.27143,71.08},{2.27143,70.54},{-8,70.54},{-8,84.5}}, color={190,190,190}));
  connect(join_hot.eye, quadruple5.eye) annotation (Line(points={{-244,1.77636e-015},{-244,1.77636e-015},{-244,-9.5},{-292,-9.5}}, color={190,190,190}));
  connect(quadruple2.eye, pipe3.eye) annotation (Line(points={{-288,-64.5},{-230,-64.5},{-230,-54.7286},{-231.92,-54.7286}}, color={190,190,190}));
  connect(balanceTank1.inlet3, temperature.port) annotation (Line(
      points={{-178,-128},{-208,-128},{-208,-170}},
      color={0,131,169},
      thickness=0.5));
  connect(join_hot.inlet2, statePoint_phTs.port) annotation (Line(
      points={{-226,10},{-172,10}},
      color={0,131,169},
      thickness=0.5));
  connect(P_feedPump.y, pump.P_drive) annotation (Line(points={{-153.4,-178},{-136,-178},{-136,-166}}, color={0,0,127}));
  connect(balanceTank1.level, PID_level.u_m) annotation (Line(points={{-176,-159},{-176,-180},{-184,-180},{-184,-70},{-155.9,-70}}, color={0,0,127}));
  connect(pump.eye, quadruple8.eye) annotation (Line(points={{-125,-148},{-122,-148},{-122,-143.5},{-120,-143.5}}, color={190,190,190}));
  connect(consumerOutlet, pipe4.inlet) annotation (Line(
      points={{60,159},{60,159},{60,67},{37,67}},
      color={175,0,0},
      thickness=0.5));
  connect(consumerInlet, pipe2.outlet) annotation (Line(
      points={{120,160},{120,160},{120,-20}},
      color={175,0,0},
      thickness=0.5));
  connect(producerOutlet, balanceTank1.inlet3) annotation (Line(
      points={{-300,-160},{-230,-160},{-230,-128},{-178,-128}},
      color={175,0,0},
      thickness=0.5));
  connect(producerInlet, pipe3.outlet) annotation (Line(
      points={{-300,-100},{-300,-100},{-236,-100},{-236,-54}},
      color={175,0,0},
      thickness=0.5));
  connect(temperature.T, T1) annotation (Line(points={{-219,-180},{-304,-180}}, color={0,0,127}));
  connect(heatExpression.y, consumer1.Q_flow_prescribed) annotation (Line(
      points={{-81,54},{-52,54},{-52,46}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-300,-220},{200,160}},
        initialScale=1), graphics={
        Rectangle(
          extent={{-300,160},{200,-220}},
          lineColor={135,135,135},
          radius=5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-300,-180},{200,-220}},
          lineColor={135,135,135},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="District Heating Net"),
        Ellipse(
          extent={{-162,82},{56,-128}},
          lineColor={175,0,0},
          lineThickness=1)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-300,-220},{200,160}},
        initialScale=1), graphics={Rectangle(
          extent={{-300,160},{200,-220}},
          lineColor={135,135,135},
          radius=5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-300,-192},{200,-220}},
          lineColor={135,135,135},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="District Heating Net")}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Small closed-loop district heating subsystem. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>consumerOutlet: FluidPortOut</p>
<p>consumerInlet: FluidPortIn</p>
<p>producerInlet: FluidPortIn</p>
<p>producerOutlet: FluidPortOut</p>
<p>T1: output for temperature in [K]</p>
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
<p>Created by Johannes Brunnemann (brunnemann@xrg-simulation.de), Jan 2017</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Apr 2017</p>
</html>"));
end DHN_SubSystem;
