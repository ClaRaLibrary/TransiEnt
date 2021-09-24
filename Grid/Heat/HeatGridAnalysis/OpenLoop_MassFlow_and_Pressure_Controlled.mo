within TransiEnt.Grid.Heat.HeatGridAnalysis;
model OpenLoop_MassFlow_and_Pressure_Controlled

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Example;

  function plotResult

   constant String resultFileName = "OpenLoop_MassFlow_and_Pressure_Controlled.mat";

  algorithm

    TransiEnt.Basics.Functions.plotResult(resultFileName);
  createPlot(id=1, position={0, 0, 743, 891}, y={"HeatingCondenser.heat.Q_flow"}, range={0.0, 32000000.0, 0.0, 500000000.0}, grid=true, colors={{28,108,200}},filename=resultFileName);
  createPlot(id=1, position={0, 0, 743, 219}, y={"HeatingCondenser.summary.outlet.p", "returnPipe2.summary.outlet.p"}, range={0.0, 32000000.0, 0.0, 2500000.0}, grid=true, subPlot=4, colors={{238,46,47}, {28,108,200}});
  createPlot(id=1, position={0, 0, 743, 219}, y={"HeatingCondenser.summary.outlet.T", "HeatingCondenser.summary.inlet.T"}, range={0.0, 32000000.0, 300.0, 450.0}, grid=true, subPlot=3, colors={{238,46,47}, {28,108,200}});
  createPlot(id=1, position={0, 0, 743, 219}, y={"HeatingCondenser.summary.outlet.m_flow"}, range={0.0, 32000000.0, 0.0, 2000.0}, grid=true, subPlot=2, colors={{28,108,200}});
  createPlot(id=2, position={759, 0, 741, 891}, y={"Pump.inlet.m_flow", "dHG_FeedForward_Controller.m_flow_i[2]"}, range={0.0, 32000000.0, 0.0, 3000.0}, grid=true, colors={{28,108,200}, {238,46,47}});
  createPlot(id=2, position={759, 0, 741, 294}, y={"Pump.summary.outline.P_hyd"}, range={0.0, 32000000.0, 0.0, 2500000.0}, grid=true, subPlot=3, colors={{28,108,200}});
  createPlot(id=2, position={759, 0, 741, 293}, y={"p_supply_is_HeatingCondenser.y", "p_supply_set_HeatingCondenser.y"}, range={0.0, 32000000.0, 800000.0, 2200000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}});

  end plotResult;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-260,160},{-240,180}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Real p_supply[2]=1e-5*{supplyPipe.summary.inlet.p,supplyPipe.summary.outlet.p};
  Real p_return[4]=1e-5*{returnPipe2.summary.outlet.p,returnPipe2.summary.inlet.p,returnPipe1.summary.outlet.p,returnPipe1.summary.inlet.p};
  Real relative_positions_supply[2]={0,supplyPipe.geo.length/supplyPipe.geo.length}; //Start, End
  Real relative_positions_return[4]={0,returnPipe2.geo.length/supplyPipe.geo.length,returnPipe2.geo.length/supplyPipe.geo.length,1}; //Start, location of first segment, location of first segment,

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  //Visualization

  Components.Visualization.DynDisplay HeatInputDisplay(
    varname="HeatInput",
    x1=HeatingCondenser.heat.Q_flow/1e6,
    unit="MW") annotation (Placement(transformation(extent={{-68,82},{-22,102}})));
  Components.Visualization.DynDisplay Time2(
    varname="MassFlow",
    unit="t/h",
    x1=HeatingCondenser.inlet.m_flow*(1/1000)*(3600)) annotation (Placement(transformation(extent={{-68,60},{-22,80}})));
  Components.Visualization.DynDisplay Time_Display(
    x1=time/3600,
    unit="h",
    varname="Time display") annotation (Placement(transformation(extent={{-156,-154},{-110,-134}})));
  Components.Visualization.DynDisplay T_amb_Display(
    varname="T_amb display",
    x1=temperatureHH_900s_01012012_0000_31122012_2345.value,
    unit="C") annotation (Placement(transformation(extent={{-104,-154},{-58,-134}})));
  Components.Visualization.DynDisplay T_supply_Display(
    unit="C",
    varname="T_supply display",
    x1=HeatingCondenser.summary.outlet.T - 273.15) annotation (Placement(transformation(extent={{-56,-154},{-10,-134}})));

  Components.Heat.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple supplyPipe(
    length=20e3,
    diameter_i=0.7,
    z_in=0,
    z_out=0,
    showData=true,
    m_flow_nom=1160,
    Delta_p_nom=(19.5 - 6.7)*1e5,
    p_nom=ones(supplyPipe.N_cv)*19.5*1e5,
    h_nom=ones(supplyPipe.N_cv)*TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        supplyPipe.p_nom[1],
        273.15 + 100,
        simCenter.fluid1.xi_default),
    h_start=supplyPipe.h_nom,
    p_start=supplyPipe.p_nom,
    initOption=0) annotation (Placement(transformation(extent={{-50,128},{-26,136}})));

  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 supplyValve1(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                      Delta_p_nom=0.5e5, m_flow_nom(displayUnit="kg/s") = 1160))
                    annotation (Placement(transformation(
        extent={{-9,-5},{9,5}},
        rotation=0,
        origin={-95,133})));
  ClaRa.Visualisation.Quadruple quadruple
    annotation (Placement(transformation(extent={{-118,12},{-86,30}})));
  ClaRa.Visualisation.Quadruple quadruple1
    annotation (Placement(transformation(extent={{-86,138},{-54,152}})));
  ClaRa.Visualisation.Quadruple quadruple2
    annotation (Placement(transformation(extent={{-16,154},{14,168}})));
  ClaRa.Visualisation.Quadruple quadruple3
    annotation (Placement(transformation(extent={{140,144},{178,160}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi pressureSink_pT(
    T_const=273.15 + 60,
    p_const(displayUnit="bar") = 190000,
    m_flow_nom=1160,
    variable_T=true) annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=180,
        origin={153,-65})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L2_affinity Pump(
    J=10,
    m_flow_nom=1160,
    useMechanicalPort=true,
    h_nom=60*4200,
    h_start=4200*60,
    V_flow_max=3.2,
    Delta_p_max=25e5,
    rpm_nom=4600,
    p_nom=2100000,
    p_start=2100000) annotation (Placement(transformation(
        extent={{-5,-6},{5,6}},
        rotation=90,
        origin={-128,13})));
  Modelica.Mechanics.Rotational.Sources.Speed speed annotation (Placement(
        transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={-143,13})));
  Modelica.Blocks.Sources.RealExpression mass_flow_is(y=supplyValve1.inlet.m_flow)
    annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=90,
        origin={-193,11})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-198,20},{-186,32}})));
  Modelica.Blocks.Math.Min min_e_m_flow_e_p_Producer annotation (Placement(transformation(extent={{-184,8},{-174,18}})));
  Modelica.Blocks.Math.Feedback feedback1
    annotation (Placement(transformation(extent={{-230,-32},{-218,-20}})));
  Modelica.Blocks.Math.Min min_e_p_supply_e_p_return_Producer
    annotation (Placement(transformation(extent={{-212,-14},{-204,-6}})));
  Modelica.Blocks.Math.Feedback feedback2
    annotation (Placement(transformation(extent={{-230,0},{-218,12}})));
  Modelica.Blocks.Sources.Constant p_supply_set_HeatingCondenser(k=19.5e5)
    annotation (Placement(transformation(extent={{-254,10},{-238,26}})));
  Modelica.Blocks.Sources.RealExpression p_supply_is_HeatingCondenser(y=HeatingCondenser.outlet.p)
    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=0,
        origin={-247,-11})));
  Modelica.Blocks.Sources.Constant p_return_set_pumpLP(k=2e5)
    annotation (Placement(transformation(extent={{-254,-46},{-242,-34}})));
  Modelica.Blocks.Sources.RealExpression p_return_is_pumpLP(y=Pump.summary.inlet.p)
    annotation (Placement(transformation(
        extent={{-7,-8},{7,8}},
        rotation=0,
        origin={-247,-26})));
  ClaRa.Visualisation.Quadruple quadruple6
    annotation (Placement(transformation(extent={{144,-48},{176,-30}})));
  Modelica.Blocks.Math.Gain gain(k=1/100)
    annotation (Placement(transformation(extent={{-200,-14},{-192,-6}})));
  Components.Heat.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple returnPipe2(
    diameter_i=0.7,
    z_in=0,
    z_out=0,
    showData=true,
    m_flow_nom=1160,
    length=16.5e3,
    Delta_p_nom=(15.7 - 3)*1e5,
    h_start=supplyPipe.h_nom,
    p_start=supplyPipe.p_nom,
    initOption=0) annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=180,
        origin={-94,-65})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L2_affinity returnPump2(
    J=10,
    m_flow_nom=1160,
    useMechanicalPort=true,
    V_flow_max=3,
    h_start=4200*60,
    h_nom=60*4200,
    rpm_nom=4000,
    Delta_p_max=20e5,
    p_nom=1570000,
    p_start=1570000) annotation (Placement(transformation(
        extent={{-5,6},{5,-6}},
        rotation=180,
        origin={-12,-65})));
  Modelica.Mechanics.Rotational.Sources.Speed speed2
                                                    annotation (Placement(
        transformation(
        extent={{3,-3},{-3,3}},
        rotation=0,
        origin={-7,-57})));
  Modelica.Blocks.Sources.RealExpression p_return_is(y=returnPipe2.summary.outlet.p
        *1e-5)
    annotation (Placement(transformation(
        extent={{9,-6},{-9,6}},
        rotation=90,
        origin={-16,-17})));
  Modelica.Blocks.Sources.Constant p_return_set(k=3.0)
    annotation (Placement(transformation(extent={{5,-5},{-5,5}},
        rotation=90,
        origin={-1,-13})));
  ClaRa.Visualisation.Quadruple quadruple7
    annotation (Placement(transformation(extent={{-108,-50},{-76,-32}})));
  ClaRa.Visualisation.Quadruple quadruple8
    annotation (Placement(transformation(extent={{-18,-92},{14,-74}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 returnValve2(
      redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticKV (
         Kvs=5000)) annotation (Placement(transformation(
        extent={{-9,5},{9,-5}},
        rotation=180,
        origin={-49,-65})));
  Modelica.Blocks.Continuous.PI PI_K_VL1(
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=388,
    T=4,
    k=0.8)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=270,
        origin={-2,-44})));
  Modelica.Blocks.Math.Feedback feedback3 annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={-2,-30})));
  ClaRa.Visualisation.Quadruple quadruple9
    annotation (Placement(transformation(extent={{-62,-54},{-30,-36}})));
  Modelica.Blocks.Continuous.PI PI(
    y_start=450,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T=8,
    k=0.9)
    annotation (Placement(transformation(extent={{-168,6},{-154,20}})));
  Components.Heat.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple returnPipe1(
    z_in=0,
    z_out=0,
    showData=true,
    m_flow_nom=1160,
    length=3.5e3,
    diameter_i=0.8,
    Delta_p_nom=(3.7 - 2.3)*1e5,
    h_start=supplyPipe.h_nom,
    p_start=supplyPipe.p_nom,
    initOption=0) annotation (Placement(transformation(
        extent={{-14,5},{14,-5}},
        rotation=180,
        origin={36,-65})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L2_affinity returnPump1(
    J=10,
    m_flow_nom=1160,
    useMechanicalPort=true,
    h_start=4200*60,
    Delta_p_max=8e5,
    V_flow_max=2,
    rpm_nom=2800,
    p_nom=370000,
    p_start=370000) annotation (Placement(transformation(
        extent={{-5,6},{5,-6}},
        rotation=180,
        origin={112,-65})));
  Modelica.Mechanics.Rotational.Sources.Speed speed3
                                                    annotation (Placement(
        transformation(
        extent={{3,-3},{-3,3}},
        rotation=0,
        origin={117,-57})));
  Modelica.Blocks.Sources.RealExpression p_is_returnPump1HP(y=returnPipe1.summary.inlet.p*1e-5) annotation (Placement(transformation(
        extent={{7,-6},{-7,6}},
        rotation=90,
        origin={108,-13})));
  Modelica.Blocks.Sources.Constant p_set_returnPump1HP(k=3.7) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=90,
        origin={122,-12})));
  ClaRa.Visualisation.Quadruple quadruple10
    annotation (Placement(transformation(extent={{100,-98},{132,-80}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 returnValve1(
      redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticKV (
         Kvs=5000)) annotation (Placement(transformation(
        extent={{-9,5},{9,-5}},
        rotation=180,
        origin={79,-65})));
  Modelica.Blocks.Continuous.PI PI_returnPump1(
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=238,
    T=7,
    k=5) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={122,-44})));
  Modelica.Blocks.Math.Feedback feedback4 annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={122,-28})));
  ClaRa.Visualisation.Quadruple quadruple11
    annotation (Placement(transformation(extent={{62,-50},{94,-32}})));
  ClaRa.Visualisation.Quadruple quadruple12
    annotation (Placement(transformation(extent={{18,-46},{50,-28}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi pressureSink_ph(
    p_const=10e5,
    m_flow_nom=1160,
    variable_p=true,
    h_const=4200*100) annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=180,
        origin={157,133})));
  ClaRa.Components.HeatExchangers.TubeBundle_L2 HeatingCondenser(
    diameter=0.05,
    N_passes=5,
    m_flow_nom=1160,
    h_start=4200*60,
    h_nom=4200*60,
    length=4,
    N_tubes=25,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=0.5e5),
    p_start(displayUnit="bar") = 21e5 - 0.5e5,
    p_nom=2300000,
    initOption=1) annotation (Placement(transformation(
        extent={{-13,-14},{13,14}},
        rotation=90,
        origin={-128,79})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-162,80})));
  ClaRa.Visualisation.Quadruple quadruple13
    annotation (Placement(transformation(extent={{-112,104},{-72,118}})));
  TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperatureHH_900s_01012012_0000_31122012_2345 annotation (Placement(transformation(extent={{-252,66},{-234,84}})));
  TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperatureHH_900s_01012012_0000_31122012_2345_2 annotation (Placement(transformation(extent={{100,-117},{114,-102}})));
  TransiEnt.Grid.Heat.HeatGridControl.SupplyAndReturnTemperatureDHG supplyandReturnTemperature1 annotation (Placement(transformation(extent={{122,-114},{132,-104}})));
  TransiEnt.Components.Visualization.DHG_PressureDiagram pdisplay_DHN(
    relative_positions_supply=relative_positions_supply,
    relative_positions_return=relative_positions_return,
    p_supply=p_supply,
    p_return=p_return,
    maxY=23,
    Unit="bar",
    minY=0) annotation (Placement(transformation(extent={{-248,-150},{-162,-64}})));

  Modelica.Blocks.Sources.Constant p_boundary(k=6.7e5)
                                                      annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={156,98})));

  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveHeatingCondenser(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                      m_flow_nom=1160, Delta_p_nom=0.5e5))
                    annotation (Placement(transformation(
        extent={{-9,5},{9,-5}},
        rotation=90,
        origin={-129,45})));
  HeatGridControl.Controllers.DHG_FeedForward_Controller                     dHG_FeedForward_Controller annotation (Placement(transformation(extent={{-228,64},{-198,84}})));
  HeatGridControl.HeatDemandPrediction.HeatingGenerationCharline heatingLoadCharline_11_1(CharLine=HeatGridControl.HeatDemandPrediction.HeatingDemandCharacteristic.CharLineHeatDemandHH(), SummerDayTypicalHeatLoadCharLine=false) annotation (Placement(transformation(extent={{-226,90},{-214,102}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  // _____________________________________________
  //
  //             Private functions
  // _____________________________________________

  connect(supplyValve1.eye, quadruple1.eye) annotation (Line(
      points={{-86,129.667},{-86,145}},
      color={190,190,190}));
  connect(supplyPipe.eye, quadruple2.eye) annotation (Line(
      points={{-25.4857,129.28},{-16,129.28},{-16,161}},
      color={190,190,190}));
  connect(Pump.shaft, speed.flange) annotation (Line(
      points={{-133.94,13},{-138,13}},
      color={0,0,0}));
  connect(Pump.eye, quadruple.eye) annotation (Line(
      points={{-124.4,18.5},{-118,18.5},{-118,21}},
      color={190,190,190}));
  connect(mass_flow_is.y, feedback.u2) annotation (Line(
      points={{-193,16.5},{-193,21.2},{-192,21.2}},
      color={0,0,127}));
  connect(feedback.y, min_e_m_flow_e_p_Producer.u1) annotation (Line(points={{-186.6,26},{-186.6,25.5},{-185,25.5},{-185,16}}, color={0,0,127}));
  connect(feedback2.y, min_e_p_supply_e_p_return_Producer.u1) annotation (Line(
      points={{-218.6,6},{-214,6},{-214,-7.6},{-212.8,-7.6}},
      color={0,0,127}));
  connect(min_e_p_supply_e_p_return_Producer.u2, feedback1.y) annotation (Line(
      points={{-212.8,-12.4},{-214,-12.4},{-214,-26},{-218.6,-26}},
      color={0,0,127}));
  connect(feedback2.u1, p_supply_set_HeatingCondenser.y) annotation (Line(
      points={{-228.8,6},{-234,6},{-234,18},{-237.2,18}},
      color={0,0,127}));
  connect(p_supply_is_HeatingCondenser.y, feedback2.u2) annotation (Line(
      points={{-239.3,-11},{-223.65,-11},{-223.65,1.2},{-224,1.2}},
      color={0,0,127}));
  connect(feedback1.u2, p_return_set_pumpLP.y) annotation (Line(
      points={{-224,-30.8},{-224,-40},{-241.4,-40}},
      color={0,0,127}));
  connect(pressureSink_pT.eye, quadruple6.eye) annotation (Line(
      points={{144,-57.8},{144,-58},{142,-58},{142,-39},{144,-39}},
      color={190,190,190}));
  connect(min_e_p_supply_e_p_return_Producer.y, gain.u) annotation (Line(
      points={{-203.6,-10},{-203.6,-10.5},{-200.8,-10.5},{-200.8,-10}},
      color={0,0,127}));
  connect(gain.y, min_e_m_flow_e_p_Producer.u2) annotation (Line(points={{-191.6,-10},{-186,-10},{-186,10},{-185,10}}, color={0,0,127}));
  connect(supplyValve1.outlet, supplyPipe.inlet) annotation (Line(
      points={{-86,133},{-68,133},{-68,132},{-50,132}},
      color={0,131,169},
      thickness=0.5));
  connect(returnPump2.shaft, speed2.flange) annotation (Line(
      points={{-12,-59.06},{-12,-57},{-10,-57}},
      color={0,0,0}));
  connect(returnPipe2.eye, quadruple7.eye) annotation (Line(
      points={{-108.6,-68.4},{-108,-68.4},{-108,-41}},
      color={190,190,190}));
  connect(Pump.inlet, returnPipe2.outlet) annotation (Line(
      points={{-128,8},{-128,-65},{-108,-65}},
      color={0,131,169},
      thickness=0.5));
  connect(returnPipe2.inlet, returnValve2.outlet) annotation (Line(
      points={{-80,-65},{-58,-65}},
      color={0,131,169},
      thickness=0.5));
  connect(returnPump2.outlet, returnValve2.inlet) annotation (Line(
      points={{-17,-65},{-40,-65}},
      color={0,131,169},
      thickness=0.5));
  connect(quadruple8.eye, returnPump2.eye) annotation (Line(
      points={{-18,-83},{-18,-68.6},{-17.5,-68.6}},
      color={190,190,190}));
  connect(feedback3.u1, p_return_set.y) annotation (Line(points={{-2,-25.2},{-2,-18.5},{-1,-18.5}}, color={0,0,127}));
  connect(feedback3.y, PI_K_VL1.u) annotation (Line(points={{-2,-35.4},{-2,-36.8}}, color={0,0,127}));
  connect(speed2.w_ref, PI_K_VL1.y) annotation (Line(
      points={{-3.4,-57},{-1.5,-57},{-1.5,-50.6},{-2,-50.6}},
      color={0,0,127}));
  connect(returnValve2.eye, quadruple9.eye) annotation (Line(
      points={{-58,-68.3333},{-58,-45},{-62,-45}},
      color={190,190,190}));
  connect(min_e_m_flow_e_p_Producer.y, PI.u) annotation (Line(points={{-173.5,13},{-169.4,13}}, color={0,0,127}));
  connect(speed.w_ref, PI.y) annotation (Line(
      points={{-149,13},{-153.3,13}},
      color={0,0,127}));
  connect(returnPump1.shaft,speed3. flange) annotation (Line(
      points={{112,-59.06},{112,-57},{114,-57}},
      color={0,0,0}));
  connect(returnPump1.outlet, returnValve1.inlet) annotation (Line(
      points={{107,-65},{88,-65}},
      color={0,131,169},
      thickness=0.5));
  connect(quadruple10.eye, returnPump1.eye) annotation (Line(
      points={{100,-89},{108,-89},{108,-68.6},{106.5,-68.6}},
      color={190,190,190}));
  connect(feedback4.u1, p_set_returnPump1HP.y) annotation (Line(points={{122,-23.2},{122,-18.6}}, color={0,0,127}));
  connect(feedback4.y, PI_returnPump1.u) annotation (Line(points={{122,-33.4},{122,-36.8}}, color={0,0,127}));
  connect(feedback4.u2, p_is_returnPump1HP.y) annotation (Line(points={{117.2,-28},{108,-28},{108,-20.7}}, color={0,0,127}));
  connect(speed3.w_ref, PI_returnPump1.y) annotation (Line(points={{120.6,-57},{122.5,-57},{122.5,-50.6},{122,-50.6}}, color={0,0,127}));
  connect(returnPump2.inlet, returnPipe1.outlet) annotation (Line(
      points={{-7,-65},{22,-65}},
      color={0,131,169},
      thickness=0.5));
  connect(returnPipe1.inlet, returnValve1.outlet) annotation (Line(
      points={{50,-65},{70,-65}},
      color={0,131,169},
      thickness=0.5));
  connect(returnPump1.inlet, pressureSink_pT.steam_a) annotation (Line(
      points={{117,-65},{144,-65}},
      color={0,131,169},
      thickness=0.5));
  connect(returnValve1.eye, quadruple11.eye) annotation (Line(
      points={{70,-68.3333},{70,-62},{62,-62},{62,-41}},
      color={190,190,190}));
  connect(returnPipe1.eye, quadruple12.eye) annotation (Line(
      points={{21.4,-68.4},{18,-68.4},{18,-37}},
      color={190,190,190}));
  connect(quadruple3.eye, pressureSink_ph.eye) annotation (Line(
      points={{140,152},{140,140.2},{148,140.2}},
      color={190,190,190}));
  connect(HeatingCondenser.heat,prescribedHeatFlow. port) annotation (Line(
      points={{-142,79},{-144,79},{-144,80},{-152,80}},
      color={167,25,48},
      thickness=0.5));
  connect(HeatingCondenser.eye, quadruple13.eye) annotation (Line(
      points={{-116.8,92},{-112,92},{-112,111}},
      color={190,190,190}));
  connect(HeatingCondenser.outlet, supplyValve1.inlet) annotation (Line(
      points={{-128,92},{-128,133},{-104,133}},
      color={0,131,169},
      thickness=0.5));
  connect(temperatureHH_900s_01012012_0000_31122012_2345_2.y1, supplyandReturnTemperature1.T_amb) annotation (Line(points={{114.7,-109.5},{121,-109.5},{121,-109}}, color={0,0,127}));
  connect(pressureSink_ph.p, p_boundary.y) annotation (Line(points={{166,127.6},{164,127.6},{164,98},{162.6,98}}, color={0,0,127}));
  connect(supplyandReturnTemperature1.T_return_K, pressureSink_pT.T) annotation (Line(points={{132.5,-112.4},{132.5,-114},{172,-114},{172,-64},{162,-64},{162,-65}},
                                                                                                                                                      color={0,0,127}));
  connect(Pump.outlet, valveHeatingCondenser.inlet) annotation (Line(
      points={{-128,18},{-128,18},{-128,36},{-129,36}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(HeatingCondenser.inlet, valveHeatingCondenser.outlet) annotation (Line(
      points={{-128,66},{-128,66},{-128,54},{-129,54}},
      color={0,131,169},
      thickness=0.5));
  connect(temperatureHH_900s_01012012_0000_31122012_2345.y1, dHG_FeedForward_Controller.T_ambient) annotation (Line(points={{-233.1,75},{-224,75},{-224,74},{-223,74}}, color={0,0,127}));
  connect(dHG_FeedForward_Controller.Q_flow_i[2], prescribedHeatFlow.Q_flow) annotation (Line(points={{-197,79.8},{-180.5,79.8},{-180.5,80},{-172,80}}, color={0,0,127}));
  connect(dHG_FeedForward_Controller.m_flow_i[2], feedback.u1) annotation (Line(points={{-197,69.2},{-197,50.6},{-196.8,50.6},{-196.8,26}}, color={0,0,127}));
  connect(p_return_is.y, feedback3.u2) annotation (Line(points={{-16,-26.9},{-12,-26.9},{-12,-30},{-6.8,-30}}, color={0,0,127}));
  connect(p_return_is_pumpLP.y, feedback1.u1) annotation (Line(points={{-239.3,-26},{-228.8,-26}}, color={0,0,127}));
  connect(pressureSink_ph.steam_a, supplyPipe.outlet) annotation (Line(
      points={{148,133},{-26,133},{-26,132}},
      color={0,131,169},
      thickness=0.5));
  connect(temperatureHH_900s_01012012_0000_31122012_2345.y1, heatingLoadCharline_11_1.T_amb) annotation (Line(points={{-233.1,75},{-230,75},{-230,96.6},{-226.6,96.6}}, color={0,0,127}));
  connect(heatingLoadCharline_11_1.Q_flow, dHG_FeedForward_Controller.Q_dot_DH_Targ) annotation (Line(
      points={{-213.4,96},{-212,96},{-212,85}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  annotation (Diagram(coordinateSystem(extent={{-260,-160},{180,180}},
          preserveAspectRatio=false), graphics={
        Text(
          extent={{-222,-36},{-154,-50}},
          lineColor={0,131,169},
          textString="Heating Condenser Pump
Control"),
        Text(
          extent={{-32,14},{20,4}},
          lineColor={0,131,169},
          textString="Return Pump 2 
Control"),
        Text(
          extent={{92,16},{144,6}},
          lineColor={0,131,169},
          textString="Return Pump 1 
Control"),
        Line(
          points={{108,-4},{108,0},{52,0},{52,-64}},
          color={255,128,0},
          pattern=LinePattern.Dash,
          arrow={Arrow.Filled,Arrow.None}),
        Rectangle(extent={{-34,18},{20,-50}},  lineColor={0,131,169},
          pattern=LinePattern.Dash),
        Rectangle(extent={{90,22},{144,-52}},  lineColor={0,131,169},
          pattern=LinePattern.Dash),
        Rectangle(extent={{-256,104},{-152,-52}},
                                               lineColor={0,131,169},
          pattern=LinePattern.Dash),
        Line(
          points={{-16,-8},{-16,0},{-120,0},{-120,-64}},
          color={255,128,0},
          pattern=LinePattern.Dash,
          arrow={Arrow.Filled,Arrow.None})}),    Icon(graphics,
                                                      coordinateSystem(extent={{-260,
            -160},{180,180}}, preserveAspectRatio=false)),
    experiment(StopTime=3.1536e+007, Interval=900),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This model illustrates possible applications of the library to model district heating grids. It shows a heat producing unit and the supply and return lines for distribution. The pump located at the heat production site is controlled based on pressure values as well as on mass-flow values. The pumps at the return line are pressure controlled. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model uses mainly components with level of detail of L2 and L4.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(does not apply)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(does not apply)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(does not apply)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(does not apply)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(does not apply)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(does not apply)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>[1] BEECKEN, J., RIDDER, M., SCHAPER, H., SCHöTTKER, P., MICUS, W., ROGALLA, B.-U. and FEUERRIEGEL, S. <i>Bessere Ausnutzung von Fernwärmeanlagen, Teilprojekt Hannover-Hamburg: Analyse des Regelverhaltens von Fernwärmenetzen</i> [online]. Hamburg : Hamburgische Electricitäts-Werke AG, 2000    [viewed 20 March 2017]. Available from: https://www.tib.eu/de/suchen/download///?tx_tibsearch_search&percnt;5Bdocid&percnt;5D=TIBKAT&percnt;3A32977557X</p>
<p>[2] GäTH, J. <i>Dynamische Modellierung eines Fernwärmestranges unter Berücksichtigung der hydraulischen Betriebssicherheit</i>. TUHH, 2015.</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p>Ricardo Peniche, 2017</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Jakobus Gaeth, 2015</span></p>
</html>"));
end OpenLoop_MassFlow_and_Pressure_Controlled;
