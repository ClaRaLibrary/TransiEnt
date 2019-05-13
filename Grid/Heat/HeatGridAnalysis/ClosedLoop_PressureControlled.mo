within TransiEnt.Grid.Heat.HeatGridAnalysis;
model ClosedLoop_PressureControlled "\"Closed loop district heating model with pressure controlled pumps and valves, constant massflow and variable heat flows\""
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

  extends TransiEnt.Basics.Icons.Example;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-248,178},{-228,198}})));
  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  parameter  Real m_flow_nom=1160;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  ClaRa.Visualisation.Quadruple quadruple7
    annotation (Placement(transformation(extent={{-130,-88},{-98,-70}})));
  ClaRa.Visualisation.Quadruple quadruple12
    annotation (Placement(transformation(extent={{46,-94},{78,-76}})));
  ClaRa.Components.HeatExchangers.TubeBundle_L2 HeatingCondenser(
    diameter=0.05,
    N_passes=5,
    length=4,
    N_tubes=25,
    m_flow_nom=m_flow_nom,
    h_nom=TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        supplyPipe2.p_nom[1],
        273.15 + 100,
        simCenter.fluid1.xi_default),
    p_nom=supplyPipe1.p_nom[1],
    h_start=HeatingCondenser.h_nom,
    p_start(displayUnit="bar") = HeatingCondenser.p_nom,
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (             Delta_p_nom=0.1e5))
                     annotation (Placement(transformation(
        extent={{-13,-14},{13,14}},
        rotation=90,
        origin={-128,79})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow(T_ref=373.15)
    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=0,
        origin={-161,79})));
  ClaRa.Visualisation.Quadruple quadruple13
    annotation (Placement(transformation(extent={{-110,100},{-70,114}})));

  TransiEnt.Components.Visualization.DynDisplay Time(
    varname="Time Display",
    x1=time/3600,
    unit="h") annotation (Placement(transformation(extent={{70,-158},{116,-138}})));
  TransiEnt.Components.Visualization.DynDisplay Time1(
    varname="HeatInput",
    x1=HeatingCondenser.heat.Q_flow/1e6,
    unit="MW") annotation (Placement(transformation(extent={{-72,80},{-26,100}})));
  TransiEnt.Components.Visualization.DynDisplay Time2(
    varname="MassFlow",
    unit="t/h",
    x1=HeatingCondenser.inlet.m_flow*(1/1000)*(3600)) annotation (Placement(transformation(extent={{-72,58},{-26,78}})));
  ClaRa.Components.HeatExchangers.TubeBundle_L2 HeatConsumer(
    diameter=0.05,
    N_passes=5,
    length=4,
    N_tubes=25,
    m_flow_nom=m_flow_nom,
    p_nom(displayUnit="bar") = returnPipe1.p_nom[1],
    h_start=TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        supplyPipe2.p_nom[1],
        273.15 + 50,
        simCenter.fluid1.xi_default),
    p_start(displayUnit="bar") = HeatConsumer.p_nom,
    h_nom=TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        returnPipe1.p_nom[1],
        273.15 + 50,
        simCenter.fluid1.xi_default),
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (             Delta_p_nom=0.1e5),
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2)
                   annotation (Placement(transformation(
        extent={{13,14},{-13,-14}},
        rotation=90,
        origin={264,35})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1 PressureReduction(
    checkValve=false,
    openingInputIsActive=true,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=1e4, m_flow_nom=m_flow_nom)) annotation (Placement(transformation(
        extent={{-9,-5},{9,5}},
        rotation=-90,
        origin={263,89})));
  ClaRa.Visualisation.Quadruple quadruple3
    annotation (Placement(transformation(extent={{218,60},{256,76}})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1 DifferentialPressure(
    openingInputIsActive=true,
    checkValve=false,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=1e4, m_flow_nom=m_flow_nom)) annotation (Placement(transformation(
        extent={{-9,-5},{9,5}},
        rotation=-90,
        origin={263,-15})));
  ClaRa.Visualisation.Quadruple quadruple17
    annotation (Placement(transformation(extent={{196,-88},{238,-70}})));
  ClaRa.Visualisation.Quadruple quadruple15
    annotation (Placement(transformation(extent={{214,6},{252,22}})));
  ClaRa.Visualisation.Quadruple quadruple18
    annotation (Placement(transformation(extent={{214,-50},{252,-34}})));
  TransiEnt.Components.Visualization.DynDisplay Time3(
    unit="MW",
    x1=HeatConsumer.heat.Q_flow/1e6,
    varname="Heatoutput") annotation (Placement(transformation(extent={{184,30},{230,50}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple supplyPipe1(
    m_flow_nom=m_flow_nom,
    h_start=supplyPipe1.h_nom,
    p_start=supplyPipe1.p_nom,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    Delta_p_nom=(19.5 - 6.7)*1e5,
    length=20e3,
    diameter_i=0.7,
    h_nom=ones(supplyPipe1.N_cv)*TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        supplyPipe1.p_nom[1],
        273.15 + 100,
        simCenter.fluid1.xi_default),
    p_nom=linspace(
        6.7e5 + supplyPipe1.Delta_p_nom,
        6.7e5,
        supplyPipe1.N_cv),
    showData=true,
    frictionAtInlet=false,
    frictionAtOutlet=true,
    initOption=0) annotation (Placement(transformation(extent={{-56,128},{-28,138}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple supplyPipe2(
    m_flow_nom=m_flow_nom,
    h_start=supplyPipe2.h_nom,
    p_start=supplyPipe2.p_nom,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    Delta_p_nom=(10 - 6)*1e5,
    length=1000,
    diameter_i=0.7,
    h_nom=ones(supplyPipe2.N_cv)*TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        supplyPipe2.p_nom[1],
        273.15 + 100,
        simCenter.fluid1.xi_default),
    frictionAtOutlet=true,
    showData=true,
    p_nom=linspace(
        2e5 + returnPipe1.p_nom[1] + supplyPipe2.Delta_p_nom,
        2e5 + returnPipe1.p_nom[1],
        supplyPipe2.N_cv),
    frictionAtInlet=false,
    initOption=0) annotation (Placement(transformation(extent={{204,128},{232,138}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple returnPipe1(
    m_flow_nom=m_flow_nom,
    h_start=returnPipe1.h_nom,
    p_start=returnPipe1.p_nom,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    diameter_i=0.8,
    Delta_p_nom=(4.2 - 1.9)*1e5,
    length=1000,
    h_nom=ones(returnPipe1.N_cv)*TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        returnPipe1.p_nom[1],
        273.15 + 50,
        simCenter.fluid1.xi_default),
    p_nom=linspace(
        1.9e5 + returnPipe1.Delta_p_nom,
        1.9e5,
        returnPipe1.N_cv),
    frictionAtOutlet=true,
    showData=true,
    frictionAtInlet=false,
    initOption=0) annotation (Placement(transformation(extent={{228,-70},{200,-60}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple returnPipe2(
    m_flow_nom=m_flow_nom,
    h_start=returnPipe2.h_nom,
    p_start=returnPipe2.p_nom,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    Delta_p_nom=(3.7 - 2.3)*1e5,
    length=3.5e3,
    diameter_i=0.8,
    h_nom=ones(returnPipe2.N_cv)*TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        returnPipe2.p_nom[1],
        273.15 + 50,
        simCenter.fluid1.xi_default),
    p_nom=linspace(
        2.3e5 + returnPipe2.Delta_p_nom,
        2.3e5,
        returnPipe2.N_cv),
    frictionAtOutlet=true,
    frictionAtInlet=false,
    showData=true,
    initOption=0) annotation (Placement(transformation(extent={{70,-72},{42,-62}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple returnPipe3(
    m_flow_nom=m_flow_nom,
    Delta_p_nom=(15.7 - 3)*1e5,
    h_start=returnPipe3.h_nom,
    p_start=returnPipe3.p_nom,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    length=16.5e3,
    diameter_i=0.7,
    h_nom=ones(returnPipe3.N_cv)*TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        returnPipe3.p_nom[1],
        273.15 + 50,
        simCenter.fluid1.xi_default),
    p_nom=linspace(
        3e5 + returnPipe3.Delta_p_nom,
        3e5,
        returnPipe3.N_cv),
    frictionAtOutlet=true,
    frictionAtInlet=false,
    showData=true,
    initOption=0) annotation (Placement(transformation(extent={{-98,-72},{-126,-62}})));
  Modelica.Blocks.Sources.Constant p_sollLeft7(k=10.7e5)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=270,
        origin={32,184})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple Pump_Left annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-128,-4})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pumpSupply annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={32,134})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple Pump_Left3 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={118,-66})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple Pump_Left2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-12,-66})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1 valveVLE_L1_4(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                      Delta_p_nom=1e4, m_flow_nom=m_flow_nom)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=90,
        origin={-128,46})));
  ClaRa.Visualisation.Quadruple quadruple1
    annotation (Placement(transformation(extent={{198,112},{236,128}})));
  ClaRa.Visualisation.Quadruple quadruple2
    annotation (Placement(transformation(extent={{-64,112},{-26,128}})));
  ClaRa.Components.Utilities.Blocks.LimPID PID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_ref=10.7e5,
    y_ref=1e6,
    y_max=2e6,
    y_min=0,
    Tau_i=10,
    sign=1,
    y_start=2e6,
    initOption=if ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.SteadyState) then 798 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialOutput) then 796 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialState) then 797 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState) then 795 else 501) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={32,162})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor annotation (Placement(transformation(extent={{74,134},{54,154}})));
  ClaRa.Visualisation.Quadruple quadruple5
    annotation (Placement(transformation(extent={{-114,50},{-74,64}})));
  ClaRa.Visualisation.Quadruple quadruple8
    annotation (Placement(transformation(extent={{112,-48},{152,-34}})));
  ClaRa.Visualisation.Quadruple quadruple11
    annotation (Placement(transformation(extent={{-110,8},{-70,22}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi(p_const=21e5, T_const(displayUnit="degC") = 323.15) annotation (Placement(transformation(extent={{-174,16},{-154,36}})));
  ClaRa.Visualisation.Quadruple quadruple14
    annotation (Placement(transformation(extent={{-26,-52},{14,-38}})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-138,-48})));
  Modelica.Blocks.Sources.Constant p_sollLeft3(k=3e5)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-182,-4})));
  ClaRa.Components.Utilities.Blocks.LimPID PID1(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_min=0,
    Tau_i=10,
    u_ref=3e5,
    y_ref=2e6,
    y_max=4e6,
    y_start=2e6,
    sign=-1,
    initOption=if ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.SteadyState) then 798 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialOutput) then 796 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialState) then 797 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState) then 795 else 501) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-158,-4})));
  Modelica.Blocks.Sources.Constant p_sollLeft4(k=4.6e5)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=0,
        origin={324,90})));
  ClaRa.Components.Utilities.Blocks.LimPID PID2(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_min=0,
    u_ref=4.6e5,
    y_ref=1,
    y_max=1,
    y_start=1,
    Tau_i=100,
    sign=1,
    initOption=if ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.SteadyState) then 798 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialOutput) then 796 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialState) then 797 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState) then 795 else 501) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={288,90})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor2 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={274,64})));
  Modelica.Blocks.Sources.Constant p_sollLeft8(k=4.2e5)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=0,
        origin={318,-16})));
  ClaRa.Components.Utilities.Blocks.LimPID PID3(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_min=0,
    u_ref=4.6e5,
    y_ref=1,
    y_max=1,
    y_start=1,
    Tau_i=100,
    sign=1,
    initOption=if ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.SteadyState) then 798 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialOutput) then 796 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialState) then 797 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState) then 795 else 501) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={288,-16})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor3 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={272,-48})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor4 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={26,-76})));
  Modelica.Blocks.Sources.Constant p_sollLeft9(k=2.3e5)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-12,-120})));
  ClaRa.Components.Utilities.Blocks.LimPID PID4(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_min=0,
    Tau_i=10,
    u_ref=3e5,
    y_max=4e6,
    y_start=2e6,
    sign=-1,
    y_ref=1e6,
    initOption=if ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.SteadyState) then 798 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialOutput) then 796 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialState) then 797 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState) then 795 else 501) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-12,-96})));
  Modelica.Blocks.Sources.Constant p_sollLeft5(k=1.9e5)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=90,
        origin={118,-120})));
  ClaRa.Components.Utilities.Blocks.LimPID PID5(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_min=0,
    Tau_i=10,
    y_max=4e6,
    sign=-1,
    u_ref=1.9e5,
    y_ref=0.5e6,
    y_start=1e6,
    initOption=if ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.SteadyState) then 798 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialOutput) then 796 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialState) then 797 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState) then 795 else 501) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={118,-96})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor5 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={150,-82})));
  HeatGridControl.Controllers.DHG_FeedForward_Controller
                                                dHNControl annotation (Placement(transformation(extent={{-230,88},{-200,106}})));
  TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperatureHH_900s_01012012_0000_31122012_2345_1 annotation (Placement(transformation(extent={{-268,88},{-250,106}})));
  HeatGridControl.Limit_Q_flow_set limit_Q_flow_set(Q_flow_set_max=200e6) annotation (Placement(transformation(extent={{-192,94},{-172,114}})));
  TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperatureHH_900s_01012012_0000_31122012_2345_2 annotation (Placement(transformation(extent={{350,55},{364,70}})));
  TransiEnt.Grid.Heat.HeatGridControl.SupplyAndReturnTemperatureDHG supplyandReturnTemperature1 annotation (Placement(transformation(extent={{372,58},{382,68}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature annotation (Placement(transformation(extent={{352,26},{332,46}})));
  ClaRa.Visualisation.DynDisplay dynDisplay(
    x1=(Pump_Left3.P_drive + Pump_Left2.P_drive + pumpSupply.P_drive + Pump_Left.P_drive + HeatingCondenser.summary.outline.Q_flow_tot + HeatConsumer.summary.outline.Q_flow_tot)/1e6,
    unit="MW",
    decimalSpaces=2,
    varname="Energy balance") annotation (Placement(transformation(extent={{24,26},{94,46}})));

  Modelica.Blocks.Sources.Pulse pulse(
    offset=0,
    y(final quantity="Power",
      final unit="W",
      displayUnit="W"),
    amplitude=50e6,
    period=7*24*3600,
    startTime=7*24*3600)
                  annotation (Placement(transformation(extent={{-194,46},{-174,66}})));

  Modelica.Blocks.Sources.RealExpression Q_flow_set_HeatingCondenser(y=limit_Q_flow_set.Q_flow_set_total + pulse.y) annotation (Placement(transformation(extent={{-198,68},{-178,88}})));

  // _____________________________________________
  //
  //           Functions
  // _____________________________________________

function plotResult

 constant String resultFileName = "ClosedLoop_PressureControlled.mat";

algorithm

    TransiEnt.Basics.Functions.plotResult(resultFileName);
createPlot(id=1, position={-4, 16, 584, 421}, y={"HeatingCondenser.summary.outline.Q_flow_tot", "pulse.y", "limit_Q_flow_set.Q_flow_set_total"}, range={0.0, 380.0, -100.0, 500.0}, grid=true, colors={{238,46,47}, {238,46,47}, {0,140,72}}, patterns={LinePattern.Solid, LinePattern.Dash, LinePattern.Dot}, filename=resultFileName);
createPlot(id=1, position={-4, 16, 584, 208}, y={"HeatingCondenser.summary.outlet.T", "HeatConsumer.summary.inlet.T"}, range={0.0, 380.0, 40.0, 160.0}, grid=true, subPlot=2, colors={{238,46,47}, {28,108,200}});

end plotResult;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  Components.Visualization.DHG_PressureDiagram pdisplay_DHN(
    minY=1,
    maxY=23,
    Unit="bar",
    n=4,
    m=6,
    p_supply=1e-5*{supplyPipe1.summary.inlet.p,supplyPipe1.summary.outlet.p,supplyPipe2.summary.inlet.p,supplyPipe2.summary.outlet.p},
    p_return=1e-5*{returnPipe3.summary.outlet.p,returnPipe3.summary.inlet.p,returnPipe2.summary.outlet.p,returnPipe2.summary.inlet.p,returnPipe1.summary.outlet.p,returnPipe1.summary.inlet.p},
    relative_positions_supply={0,supplyPipe1.geo.length/(supplyPipe1.geo.length + supplyPipe2.geo.length),supplyPipe1.geo.length/(supplyPipe1.geo.length + supplyPipe2.geo.length),(supplyPipe1.geo.length + supplyPipe2.geo.length)/(supplyPipe1.geo.length + supplyPipe2.geo.length)},
    relative_positions_return={0,returnPipe3.geo.length/(returnPipe1.geo.length + returnPipe2.geo.length + returnPipe3.geo.length),returnPipe3.geo.length/(returnPipe1.geo.length + returnPipe2.geo.length + returnPipe3.geo.length),(returnPipe2.geo.length + returnPipe3.geo.length)/(returnPipe1.geo.length + returnPipe2.geo.length + returnPipe3.geo.length),(returnPipe2.geo.length + returnPipe3.geo.length)/(returnPipe1.geo.length + returnPipe2.geo.length + returnPipe3.geo.length),(returnPipe1.geo.length + returnPipe2.geo.length + returnPipe3.geo.length)/(returnPipe1.geo.length + returnPipe2.geo.length + returnPipe3.geo.length)}) annotation (Placement(transformation(extent={{-134,-204},{-48,-118}})));
  HeatGridControl.HeatDemandPrediction.HeatingGenerationCharline heatingLoadCharline(CharLine=HeatGridControl.HeatDemandPrediction.HeatingDemandCharacteristic.CharLineHeatDemandHH(), SummerDayTypicalHeatLoadCharLine=false) annotation (Placement(transformation(extent={{-244,114},{-228,128}})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(HeatingCondenser.heat,prescribedHeatFlow. port) annotation (Line(
      points={{-142,79},{-144,79},{-154,79}},
      color={167,25,48},
      thickness=0.5));
  connect(HeatingCondenser.eye, quadruple13.eye) annotation (Line(
      points={{-116.8,92},{-116,92},{-116,106},{-110,106},{-110,107}},
      color={190,190,190}));
  connect(PressureReduction.eye, quadruple3.eye) annotation (Line(points={{259.667,80},{259.667,68},{218,68}}, color={190,190,190}));
  connect(HeatConsumer.eye, quadruple15.eye) annotation (Line(points={{252.8,22},{252.8,14},{214,14}}, color={190,190,190}));
  connect(DifferentialPressure.eye, quadruple18.eye) annotation (Line(points={{259.667,-24},{259.667,-42},{214,-42}}, color={190,190,190}));
  connect(supplyPipe2.outlet, PressureReduction.inlet) annotation (Line(
      points={{232,133},{263,133},{263,98}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(returnPipe1.inlet, DifferentialPressure.outlet) annotation (Line(
      points={{228,-65},{238,-65},{238,-66},{263,-66},{263,-24}},
      color={0,131,169},
      thickness=0.5));
  connect(HeatConsumer.outlet, DifferentialPressure.inlet) annotation (Line(
      points={{264,22},{264,22},{264,-6},{263,-6}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(HeatConsumer.inlet, PressureReduction.outlet) annotation (Line(
      points={{264,48},{264,80},{263,80}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpSupply.inlet, supplyPipe1.outlet) annotation (Line(
      points={{22,134},{-4,134},{-4,133},{-28,133}},
      color={0,131,169},
      thickness=0.5));
  connect(Pump_Left3.inlet, returnPipe1.outlet) annotation (Line(
      points={{128,-66},{166,-66},{166,-65},{200,-65}},
      color={0,131,169},
      thickness=0.5));
  connect(Pump_Left2.inlet, returnPipe2.outlet) annotation (Line(
      points={{-2,-66},{42,-66},{42,-67}},
      color={0,131,169},
      thickness=0.5));
  connect(Pump_Left.inlet, returnPipe3.outlet) annotation (Line(
      points={{-128,-14},{-128,-14},{-128,-68},{-128,-67},{-126,-67}},
      color={0,131,169},
      thickness=0.5));
  connect(HeatingCondenser.inlet, valveVLE_L1_4.outlet) annotation (Line(
      points={{-128,66},{-128,56}},
      color={0,131,169},
      thickness=0.5));
  connect(valveVLE_L1_4.inlet, Pump_Left.outlet) annotation (Line(
      points={{-128,36},{-128,6}},
      color={0,131,169},
      thickness=0.5));
  connect(quadruple1.eye, supplyPipe2.eye) annotation (Line(points={{198,120},{238,120},{238,129.6},{232.6,129.6}}, color={190,190,190}));
  connect(quadruple2.eye, supplyPipe1.eye) annotation (Line(points={{-64,120},{-26,120},{-26,129.6},{-27.4,129.6}}, color={190,190,190}));
  connect(returnPipe3.eye, quadruple7.eye) annotation (Line(points={{-126.6,-70.4},{-132.3,-70.4},{-132.3,-79},{-130,-79}}, color={190,190,190}));
  connect(returnPipe2.eye, quadruple12.eye) annotation (Line(points={{41.4,-70.4},{46,-70.4},{46,-85}}, color={190,190,190}));
  connect(returnPipe1.eye, quadruple17.eye) annotation (Line(points={{199.4,-68.4},{200,-68.4},{200,-68},{196,-68},{196,-79}}, color={190,190,190}));
  connect(PID.y, pumpSupply.P_drive) annotation (Line(points={{32,151},{32,146}}, color={0,0,127}));
  connect(PID.u_s, p_sollLeft7.y) annotation (Line(points={{32,174},{32,177.4}}, color={0,0,127}));
  connect(pumpSupply.outlet, vlePressureSensor.port) annotation (Line(
      points={{42,134},{64,134}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(vlePressureSensor.p, PID.u_m) annotation (Line(points={{53,144},{52,144},{52,161.9},{44,161.9}},
                                                                                                    color={0,0,127}));
  connect(valveVLE_L1_4.eye, quadruple5.eye) annotation (Line(points={{-124,56},{-124,56},{-124,57},{-114,57}}, color={190,190,190}));
  connect(quadruple8.eye, Pump_Left3.eye) annotation (Line(points={{112,-41},{108,-41},{108,-42},{107,-42},{107,-60}}, color={190,190,190}));
  connect(quadruple11.eye, Pump_Left.eye) annotation (Line(points={{-110,15},{-114,15},{-114,14},{-122,14},{-122,7}}, color={190,190,190}));
  connect(boundaryVLE_pTxi.steam_a, valveVLE_L1_4.inlet) annotation (Line(
      points={{-154,26},{-128,26},{-128,36}},
      color={0,131,169},
      thickness=0.5));
  connect(quadruple14.eye, Pump_Left2.eye) annotation (Line(points={{-26,-45},{-34,-45},{-34,-60},{-23,-60}}, color={190,190,190}));
  connect(Pump_Left.inlet, vlePressureSensor1.port) annotation (Line(
      points={{-128,-14},{-128,-24},{-128,-48}},
      color={0,131,169},
      thickness=0.5));
  connect(PID1.u_s, p_sollLeft3.y) annotation (Line(points={{-170,-4},{-172,-4},{-175.4,-4}}, color={0,0,127}));
  connect(PID1.y, Pump_Left.P_drive) annotation (Line(points={{-147,-4},{-140,-4}},   color={0,0,127}));
  connect(vlePressureSensor1.p, PID1.u_m) annotation (Line(points={{-138,-37},{-157.9,-37},{-157.9,-16}},
                                                                                                    color={0,0,127}));
  connect(PressureReduction.opening_in, PID2.y) annotation (Line(points={{270.5,89},{273.25,89},{273.25,90},{277,90}}, color={0,0,127}));
  connect(p_sollLeft4.y, PID2.u_s) annotation (Line(points={{317.4,90},{308,90},{300,90}}, color={0,0,127}));
  connect(HeatConsumer.inlet, vlePressureSensor2.port) annotation (Line(
      points={{264,48},{264,64}},
      color={0,131,169},
      thickness=0.5));
  connect(vlePressureSensor2.p, PID2.u_m) annotation (Line(points={{274,75},{282,75},{282,78},{287.9,78}},
                                                                                                    color={0,0,127}));
  connect(p_sollLeft8.y, PID3.u_s) annotation (Line(points={{311.4,-16},{304,-16},{300,-16}}, color={0,0,127}));
  connect(vlePressureSensor3.p, PID3.u_m) annotation (Line(points={{272,-37},{287.9,-37},{287.9,-28}},
                                                                                                   color={0,0,127}));
  connect(DifferentialPressure.opening_in, PID3.y) annotation (Line(points={{270.5,-15},{276.25,-15},{276.25,-16},{277,-16}}, color={0,0,127}));
  connect(returnPipe1.inlet, vlePressureSensor3.port) annotation (Line(
      points={{228,-65},{238,-65},{238,-66},{263,-66},{262,-48}},
      color={0,131,169},
      thickness=0.5));
  connect(PID4.u_s, p_sollLeft9.y) annotation (Line(points={{-12,-108},{-12,-113.4}}, color={0,0,127}));
  connect(vlePressureSensor4.p, PID4.u_m) annotation (Line(points={{15,-76},{10,-76},{10,-96},{0,-96},{0,-95.9}},
                                                                                                    color={0,0,127}));
  connect(Pump_Left2.inlet, vlePressureSensor4.port) annotation (Line(
      points={{-2,-66},{26,-66}},
      color={0,131,169},
      thickness=0.5));
  connect(Pump_Left2.P_drive, PID4.y) annotation (Line(points={{-12,-78},{-12,-85}},   color={0,0,127}));
  connect(PID5.u_s, p_sollLeft5.y) annotation (Line(points={{118,-108},{118,-113.4}}, color={0,0,127}));
  connect(vlePressureSensor5.p, PID5.u_m) annotation (Line(points={{139,-82},{140,-82},{140,-96},{130,-96},{130,-95.9}},
                                                                                                    color={0,0,127}));
  connect(Pump_Left3.inlet, vlePressureSensor5.port) annotation (Line(
      points={{128,-66},{150,-66},{150,-72},{150,-72}},
      color={0,131,169},
      thickness=0.5));
  connect(Pump_Left3.P_drive, PID5.y) annotation (Line(points={{118,-78},{118,-85}},   color={0,0,127}));
  connect(HeatingCondenser.outlet, supplyPipe1.inlet) annotation (Line(
      points={{-128,92},{-128,92},{-128,134},{-56,134},{-56,133}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(vlePressureSensor.port, supplyPipe2.inlet) annotation (Line(
      points={{64,134},{204,134},{204,133}},
      color={0,131,169},
      thickness=0.5));
  connect(returnPipe3.inlet, Pump_Left2.outlet) annotation (Line(
      points={{-98,-67},{-59,-67},{-59,-66},{-22,-66}},
      color={0,131,169},
      thickness=0.5));
  connect(Pump_Left3.outlet, returnPipe2.inlet) annotation (Line(
      points={{108,-66},{70,-66},{70,-67}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(dHNControl.T_ambient,temperatureHH_900s_01012012_0000_31122012_2345_1.
                                                     value) annotation (Line(
      points={{-225,97},{-251.08,97}},
      color={0,0,127}));
  connect(temperatureHH_900s_01012012_0000_31122012_2345_2.y1, supplyandReturnTemperature1.T_amb) annotation (Line(points={{364.7,62.5},{371,62.5},{371,63}}, color={0,0,127}));
  connect(HeatConsumer.heat, prescribedTemperature.port) annotation (Line(
      points={{278,35},{305,35},{305,36},{332,36}},
      color={167,25,48},
      thickness=0.5));
  connect(supplyandReturnTemperature1.T_return_K, prescribedTemperature.T) annotation (Line(points={{382.5,59.6},{390,59.6},{390,36},{354,36}}, color={0,0,127}));
  connect(dHNControl.Q_flow_i[2], limit_Q_flow_set.Q_flow_set_total) annotation (Line(points={{-199,102.22},{-190.5,102.22},{-190.5,114.2},{-182,114.2}}, color={0,0,127}));
  connect(Q_flow_set_HeatingCondenser.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{-177,78},{-174,78},{-172,78},{-172,79},{-168,79}}, color={0,0,127}));
  connect(heatingLoadCharline.Q_flow, dHNControl.Q_dot_DH_Targ) annotation (Line(
      points={{-227.2,121},{-214,121},{-214,106.9}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(temperatureHH_900s_01012012_0000_31122012_2345_1.y1, heatingLoadCharline.T_amb) annotation (Line(points={{-249.1,97},{-248,97},{-248,121.7},{-244.8,121.7}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-260,-220},{400,200}},
          preserveAspectRatio=false), graphics={
        Text(
          extent={{190,96},{242,82}},
          lineColor={28,108,200},
          textString="Pressure reduction"),
        Line(
          points={{-84,42}},
          color={255,128,0},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Line(
          points={{-110,78}},
          color={0,131,169},
          pattern=LinePattern.Dash),
        Line(
          points={{-110,80}},
          color={0,131,169},
          pattern=LinePattern.Dash),
        Line(
          points={{-82,76}},
          color={255,128,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-142,100},{-130,94}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p=~ 20bar"),
        Text(
          extent={{-26,140},{-12,134}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 6.7bar"),
        Text(
          extent={{72,140},{88,134}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 10.7bar"),
        Text(
          extent={{182,140},{198,134}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 10bar"),
        Text(
          extent={{238,140},{252,134}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 6bar"),
        Text(
          extent={{-78,140},{-62,134}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 19.5bar"),
        Text(
          extent={{234,60},{262,52}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 4.6bar"),
        Text(
          extent={{222,-12},{248,-24}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 4.2bar"),
        Text(
          extent={{164,-124},{182,-132}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 1.9bar"),
        Text(
          extent={{48,-70},{66,-78}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 3.7bar"),
        Text(
          extent={{-4,-70},{14,-78}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 2.3bar"),
        Text(
          extent={{-78,-70},{-58,-78}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 15.7bar"),
        Text(
          extent={{-212,-72},{-174,-84}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 3bar"),
        Text(
          extent={{-160,10},{-142,4}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 21bar"),
        Line(
          points={{154,16}},
          color={127,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{188,-2},{240,-16}},
          lineColor={28,108,200},
          textString="Differential pressure")}), Icon(coordinateSystem(extent={{-260,-220},{400,200}},
                              preserveAspectRatio=false), graphics),
    experiment(StopTime=3.1536e+007, Interval=900),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This model illustrates possible applications of the library to model district heating grids. It shows a heat producing unit at the left, a heat consumer at the right and the supply and return lines for distribution. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">In this example, the pumps at the return line are pressure controlled and the mass flow is assumed to be constant.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The supply temperature is controlled by the heat input, which is defined by the feed forward controller.</span></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p>Ricardo Peniche 2017</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Ricardo Peniche and Jan Braune 2016</span></p>
</html>"));
end ClosedLoop_PressureControlled;
