within TransiEnt.Grid.Heat.HeatGridAnalysis;
model TwoClosedLoops_PressureControlled "\"Two district heating loops, pressure controlled, variable heat flows, constant mass flow\""
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Example;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-512,148},{-492,168}})));

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  parameter Real m_flow_nom = 1160;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  ClaRa.Visualisation.Quadruple quadruple7
    annotation (Placement(transformation(extent={{-394,-98},{-362,-80}})));
  ClaRa.Visualisation.Quadruple quadruple12
    annotation (Placement(transformation(extent={{-218,-104},{-186,-86}})));
  ClaRa.Components.HeatExchangers.TubeBundle_L2 HeatingCondenserLeft(
    diameter=0.05,
    N_passes=5,
    length=4,
    N_tubes=25,
    m_flow_nom=m_flow_nom,
    h_nom=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        supplyPipeLeft2.p_nom[1],
        273.15 + 100,
        simCenter.fluid1.xi_default),
    p_nom=supplyPipeLeft1.p_nom[1],
    h_start=HeatingCondenserLeft.h_nom,
    p_start(displayUnit="bar") = HeatingCondenserLeft.p_nom,
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (             Delta_p_nom=0.1e5))
                     annotation (Placement(transformation(
        extent={{-13,-14},{13,14}},
        rotation=90,
        origin={-392,69})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow(T_ref=373.15)
    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=0,
        origin={-425,69})));
  ClaRa.Visualisation.Quadruple quadruple13
    annotation (Placement(transformation(extent={{-374,90},{-334,104}})));

  TransiEnt.Components.Visualization.DynDisplay Time1(
    varname="HeatInput",
    x1=HeatingCondenserLeft.heat.Q_flow/1e6,
    unit="MW") annotation (Placement(transformation(extent={{-336,70},{-290,90}})));
  TransiEnt.Components.Visualization.DynDisplay Time2(
    varname="MassFlow",
    unit="t/h",
    x1=HeatingCondenserLeft.inlet.m_flow*(1/1000)*(3600)) annotation (Placement(transformation(extent={{-336,48},{-290,68}})));
  ClaRa.Components.HeatExchangers.TubeBundle_L2 HeatConsumer(
    diameter=0.05,
    N_passes=5,
    length=4,
    N_tubes=25,
    m_flow_nom=m_flow_nom,
    p_nom(displayUnit="bar") = returnPipeLeft1.p_nom[1],
    h_start=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        supplyPipeLeft2.p_nom[1],
        273.15 + 50,
        simCenter.fluid1.xi_default),
    p_start(displayUnit="bar") = HeatConsumer.p_nom,
    h_nom=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        returnPipeLeft1.p_nom[1],
        273.15 + 50,
        simCenter.fluid1.xi_default),
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (             Delta_p_nom=0.1e5),
    redeclare model HeatTransfer =
        ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2)
                   annotation (Placement(transformation(
        extent={{13,14},{-13,-14}},
        rotation=90,
        origin={0,25})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 PressureReduction(
    checkValve=false,
    openingInputIsActive=true,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=1e4, m_flow_nom=m_flow_nom)) annotation (Placement(transformation(
        extent={{-9,-5},{9,5}},
        rotation=-90,
        origin={-1,79})));
  ClaRa.Visualisation.Quadruple quadruple3
    annotation (Placement(transformation(extent={{-46,50},{-8,66}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 DifferentialPressure(
    openingInputIsActive=true,
    checkValve=false,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=1e4, m_flow_nom=m_flow_nom)) annotation (Placement(transformation(
        extent={{-9,-5},{9,5}},
        rotation=-90,
        origin={-1,-25})));
  ClaRa.Visualisation.Quadruple quadruple17
    annotation (Placement(transformation(extent={{-68,-98},{-26,-80}})));
  ClaRa.Visualisation.Quadruple quadruple15
    annotation (Placement(transformation(extent={{-50,-4},{-12,12}})));
  ClaRa.Visualisation.Quadruple quadruple18
    annotation (Placement(transformation(extent={{-50,-60},{-12,-44}})));
  TransiEnt.Components.Visualization.DynDisplay Time3(
    unit="MW",
    x1=HeatConsumer.heat.Q_flow/1e6,
    varname="Heatoutput") annotation (Placement(transformation(extent={{-80,20},{-34,40}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple supplyPipeLeft1(
    m_flow_nom=m_flow_nom,
    h_start=supplyPipeLeft1.h_nom,
    p_start=supplyPipeLeft1.p_nom,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    Delta_p_nom=(19.5 - 6.7)*1e5,
    length=20e3,
    diameter_i=0.7,
    h_nom=ones(supplyPipeLeft1.N_cv)*TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        supplyPipeLeft1.p_nom[1],
        273.15 + 100,
        simCenter.fluid1.xi_default),
    p_nom=linspace(
        6.7e5 + supplyPipeLeft1.Delta_p_nom,
        6.7e5,
        supplyPipeLeft1.N_cv),
    showData=true,
    frictionAtInlet=false,
    frictionAtOutlet=true,
    initOption=0) annotation (Placement(transformation(extent={{-320,118},{-292,128}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple supplyPipeLeft2(
    m_flow_nom=m_flow_nom,
    h_start=supplyPipeLeft2.h_nom,
    p_start=supplyPipeLeft2.p_nom,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    Delta_p_nom=(10 - 6)*1e5,
    length=1000,
    diameter_i=0.7,
    h_nom=ones(supplyPipeLeft2.N_cv)*TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        supplyPipeLeft2.p_nom[1],
        273.15 + 100,
        simCenter.fluid1.xi_default),
    frictionAtOutlet=true,
    showData=true,
    p_nom=linspace(
        2e5 + returnPipeLeft1.p_nom[1] + supplyPipeLeft2.Delta_p_nom,
        2e5 + returnPipeLeft1.p_nom[1],
        supplyPipeLeft2.N_cv),
    frictionAtInlet=false,
    initOption=0) annotation (Placement(transformation(extent={{-60,118},{-32,128}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple returnPipeLeft1(
    m_flow_nom=m_flow_nom,
    h_start=returnPipeLeft1.h_nom,
    p_start=returnPipeLeft1.p_nom,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    diameter_i=0.8,
    Delta_p_nom=(4.2 - 1.9)*1e5,
    length=1000,
    h_nom=ones(returnPipeLeft1.N_cv)*TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        returnPipeLeft1.p_nom[1],
        273.15 + 50,
        simCenter.fluid1.xi_default),
    p_nom=linspace(
        1.9e5 + returnPipeLeft1.Delta_p_nom,
        1.9e5,
        returnPipeLeft1.N_cv),
    frictionAtOutlet=true,
    showData=true,
    frictionAtInlet=false,
    initOption=0) annotation (Placement(transformation(extent={{-36,-80},{-64,-70}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple returnPipeLeft2(
    m_flow_nom=m_flow_nom,
    h_start=returnPipeLeft2.h_nom,
    p_start=returnPipeLeft2.p_nom,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    Delta_p_nom=(3.7 - 2.3)*1e5,
    length=3.5e3,
    diameter_i=0.8,
    h_nom=ones(returnPipeLeft2.N_cv)*TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        returnPipeLeft2.p_nom[1],
        273.15 + 50,
        simCenter.fluid1.xi_default),
    p_nom=linspace(
        2.3e5 + returnPipeLeft2.Delta_p_nom,
        2.3e5,
        returnPipeLeft2.N_cv),
    frictionAtOutlet=true,
    frictionAtInlet=false,
    showData=true,
    initOption=0) annotation (Placement(transformation(extent={{-194,-82},{-222,-72}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple returnPipeLeft3(
    m_flow_nom=m_flow_nom,
    Delta_p_nom=(15.7 - 3)*1e5,
    h_start=returnPipeLeft3.h_nom,
    p_start=returnPipeLeft3.p_nom,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    length=16.5e3,
    diameter_i=0.7,
    h_nom=ones(returnPipeLeft3.N_cv)*TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        returnPipeLeft3.p_nom[1],
        273.15 + 50,
        simCenter.fluid1.xi_default),
    p_nom=linspace(
        3e5 + returnPipeLeft3.Delta_p_nom,
        3e5,
        returnPipeLeft3.N_cv),
    frictionAtOutlet=true,
    frictionAtInlet=false,
    showData=true,
    initOption=0) annotation (Placement(transformation(extent={{-362,-82},{-390,-72}})));
  Modelica.Blocks.Sources.Constant p_set_VL_Consumer2(k=1) "pressure limiter of the house system"   annotation (Placement(transformation(extent={{6,6},{-6,-6}}, rotation=-90)));
  Modelica.Blocks.Sources.Constant p_setLeft7(k=10.7e5)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}}, rotation=270)));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pumpLeft annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-392,-14})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pumpLeft1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-232,124})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pumpLeft3 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-146,-76})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pumpLeft2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-276,-76})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L1_4(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                      Delta_p_nom=1e4, m_flow_nom=m_flow_nom)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=90,
        origin={-392,36})));
  ClaRa.Visualisation.Quadruple quadruple1
    annotation (Placement(transformation(extent={{-66,102},{-28,118}})));
  ClaRa.Visualisation.Quadruple quadruple2
    annotation (Placement(transformation(extent={{-328,102},{-290,118}})));
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
        origin={-232,152})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor annotation (Placement(transformation(extent={{-190,124},{-210,144}})));
  ClaRa.Visualisation.Quadruple quadruple5
    annotation (Placement(transformation(extent={{-378,40},{-338,54}})));
  ClaRa.Visualisation.Quadruple quadruple8
    annotation (Placement(transformation(extent={{-152,-58},{-112,-44}})));
  ClaRa.Visualisation.Quadruple quadruple11
    annotation (Placement(transformation(extent={{-374,-2},{-334,12}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi(p_const=21e5, T_const(displayUnit="degC") = 323.15) annotation (Placement(transformation(extent={{-438,6},{-418,26}})));
  ClaRa.Visualisation.Quadruple quadruple14
    annotation (Placement(transformation(extent={{-290,-62},{-250,-48}})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-402,-58})));
  Modelica.Blocks.Sources.Constant p_setLeft3(k=3e5)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}}, rotation=0)));
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
        origin={-422,-14})));
  Modelica.Blocks.Sources.Constant p_setLeft4(k=4.6e5)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}}, rotation=0)));
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
        origin={24,80})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor2 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={10,54})));
  Modelica.Blocks.Sources.Constant p_setLeft8(k=4.2e5)
    annotation (Placement(transformation(extent={{6,-6},{-6,6}}, rotation=0)));
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
        origin={24,-26})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor3 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={24,-54})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor4 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-238,-86})));
  Modelica.Blocks.Sources.Constant p_setLeft9(k=2.3e5)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}}, rotation=90)));
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
        origin={-276,-106})));
  Modelica.Blocks.Sources.Constant p_setLeft5(k=1.9e5)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}}, rotation=90)));
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
        origin={-146,-106})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor5 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-114,-92})));
  HeatGridControl.Controllers.DHG_FeedForward_Controller
                                                dHNControl annotation (Placement(transformation(extent={{-494,78},{-464,96}})));
  TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperatureHH_900s_01012012_0000_31122012_2345_1 annotation (Placement(transformation(extent={{-532,78},{-514,96}})));
  HeatGridControl.Limit_Q_flow_set limit_Q_flow_set(Q_flow_set_max=220e6 + 165e6)
                                                                          annotation (Placement(transformation(extent={{-456,84},{-436,104}})));
  TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperatureHH_900s_01012012_0000_31122012_2345_2 annotation (Placement(transformation(extent={{156,21},{142,36}})));
  TransiEnt.Grid.Heat.HeatGridControl.SupplyAndReturnTemperatureDHG supplyandReturnTemperature1 annotation (Placement(transformation(extent={{118,24},{108,34}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature annotation (Placement(transformation(extent={{88,16},{68,36}})));
  ClaRa.Visualisation.DynDisplay dynDisplay(
    unit="MW",
    decimalSpaces=2,
    varname="Energy balance 1",
    x1=(pumpLeft3.P_drive + pumpLeft2.P_drive + pumpLeft1.P_drive + pumpLeft.P_drive + HeatingCondenserLeft.summary.outline.Q_flow_tot + HeatConsumer.summary.outline.Q_flow_tot/2)/1e6)
                     annotation (Placement(transformation(extent={{-240,16},{-170,36}})));
  ClaRa.Visualisation.Quadruple quadruple4
    annotation (Placement(transformation(extent={{440,-114},{472,-96}})));
  ClaRa.Visualisation.Quadruple quadruple6
    annotation (Placement(transformation(extent={{280,-192},{312,-174}})));
  ClaRa.Components.HeatExchangers.TubeBundle_L2 HeatingCondenserRight(
    diameter=0.05,
    N_passes=5,
    length=4,
    N_tubes=25,
    m_flow_nom=m_flow_nom,
    h_nom=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        supplyPipeLeft2.p_nom[1],
        273.15 + 100,
        simCenter.fluid1.xi_default),
    p_nom=supplyPipeLeft1.p_nom[1],
    h_start=HeatingCondenserLeft.h_nom,
    p_start(displayUnit="bar") = HeatingCondenserLeft.p_nom,
    redeclare model PressureLoss =
        ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (             Delta_p_nom=0.1e5))
                     annotation (Placement(transformation(
        extent={{-13,14},{13,-14}},
        rotation=90,
        origin={464,71})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow1(T_ref=373.15)
    annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=0,
        origin={499,71})));
  ClaRa.Visualisation.Quadruple quadruple9
    annotation (Placement(transformation(extent={{392,86},{432,100}})));
  TransiEnt.Components.Visualization.DynDisplay Time4(
    varname="Time Display",
    x1=time/3600,
    unit="h") annotation (Placement(transformation(extent={{-14,-190},{32,-170}})));
  TransiEnt.Components.Visualization.DynDisplay Time5(
    varname="HeatInput",
    unit="MW",
    x1=HeatingCondenserRight.heat.Q_flow/1e6) annotation (Placement(transformation(extent={{344,42},{390,62}})));
  TransiEnt.Components.Visualization.DynDisplay Time6(
    varname="MassFlow",
    unit="t/h",
    x1=HeatingCondenserRight.inlet.m_flow*(1/1000)*(3600)) annotation (Placement(transformation(extent={{342,18},{388,38}})));
  ClaRa.Visualisation.Quadruple quadruple19
    annotation (Placement(transformation(extent={{58,-112},{100,-94}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple supplyPipeRight1(
    m_flow_nom=m_flow_nom,
    h_start=supplyPipeLeft1.h_nom,
    p_start=supplyPipeLeft1.p_nom,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    Delta_p_nom=(19.5 - 6.7)*1e5,
    length=20e3,
    diameter_i=0.7,
    h_nom=ones(supplyPipeLeft1.N_cv)*TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        supplyPipeLeft1.p_nom[1],
        273.15 + 100,
        simCenter.fluid1.xi_default),
    p_nom=linspace(
        6.7e5 + supplyPipeLeft1.Delta_p_nom,
        6.7e5,
        supplyPipeLeft1.N_cv),
    showData=true,
    frictionAtInlet=false,
    frictionAtOutlet=true,
    initOption=0) annotation (Placement(transformation(extent={{266,120},{238,130}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple supplyPipeRight2(
    m_flow_nom=m_flow_nom,
    h_start=supplyPipeLeft2.h_nom,
    p_start=supplyPipeLeft2.p_nom,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    Delta_p_nom=(10 - 6)*1e5,
    length=1000,
    diameter_i=0.7,
    h_nom=ones(supplyPipeLeft2.N_cv)*TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        supplyPipeLeft2.p_nom[1],
        273.15 + 100,
        simCenter.fluid1.xi_default),
    frictionAtOutlet=true,
    showData=true,
    p_nom=linspace(
        2e5 + returnPipeLeft1.p_nom[1] + supplyPipeLeft2.Delta_p_nom,
        2e5 + returnPipeLeft1.p_nom[1],
        supplyPipeLeft2.N_cv),
    frictionAtInlet=false,
    initOption=0) annotation (Placement(transformation(extent={{104,118},{76,128}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple returnPipeRight1(
    m_flow_nom=m_flow_nom,
    h_start=returnPipeLeft1.h_nom,
    p_start=returnPipeLeft1.p_nom,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    diameter_i=0.8,
    Delta_p_nom=(4.2 - 1.9)*1e5,
    length=1000,
    h_nom=ones(returnPipeLeft1.N_cv)*TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        returnPipeLeft1.p_nom[1],
        273.15 + 50,
        simCenter.fluid1.xi_default),
    p_nom=linspace(
        1.9e5 + returnPipeLeft1.Delta_p_nom,
        1.9e5,
        returnPipeLeft1.N_cv),
    frictionAtOutlet=true,
    showData=true,
    frictionAtInlet=false,
    initOption=0) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=0,
        origin={82,-73})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple returnPipeRight2(
    m_flow_nom=m_flow_nom,
    h_start=returnPipeLeft2.h_nom,
    p_start=returnPipeLeft2.p_nom,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    Delta_p_nom=(3.7 - 2.3)*1e5,
    length=3.5e3,
    diameter_i=0.8,
    h_nom=ones(returnPipeLeft2.N_cv)*TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        returnPipeLeft2.p_nom[1],
        273.15 + 50,
        simCenter.fluid1.xi_default),
    p_nom=linspace(
        2.3e5 + returnPipeLeft2.Delta_p_nom,
        2.3e5,
        returnPipeLeft2.N_cv),
    frictionAtOutlet=true,
    frictionAtInlet=false,
    showData=true,
    initOption=0) annotation (Placement(transformation(extent={{252,-78},{280,-68}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple returnPipeRight3(
    m_flow_nom=m_flow_nom,
    Delta_p_nom=(15.7 - 3)*1e5,
    h_start=returnPipeLeft3.h_nom,
    p_start=returnPipeLeft3.p_nom,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    length=16.5e3,
    diameter_i=0.7,
    h_nom=ones(returnPipeLeft3.N_cv)*TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        returnPipeLeft3.p_nom[1],
        273.15 + 50,
        simCenter.fluid1.xi_default),
    p_nom=linspace(
        3e5 + returnPipeLeft3.Delta_p_nom,
        3e5,
        returnPipeLeft3.N_cv),
    frictionAtOutlet=true,
    frictionAtInlet=false,
    showData=true,
    initOption=0) annotation (Placement(transformation(extent={{412,-78},{440,-68}})));
  Modelica.Blocks.Sources.Constant p_setLeft1(k=10.7e5)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}}, rotation=270)));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pumpRight annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={464,-12})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pumpRight1 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={204,124})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pumpRight3 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={186,-73})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pumpRight2 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={344,-73})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L1_1(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                      Delta_p_nom=1e4, m_flow_nom=m_flow_nom)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=90,
        origin={464,38})));
  ClaRa.Visualisation.Quadruple quadruple22
    annotation (Placement(transformation(extent={{40,152},{78,168}})));
  ClaRa.Visualisation.Quadruple quadruple23
    annotation (Placement(transformation(extent={{234,152},{272,168}})));
  ClaRa.Components.Utilities.Blocks.LimPID PID6(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_ref=10.7e5,
    y_ref=1e6,
    y_max=2e6,
    y_min=0,
    Tau_i=10,
    sign=1,
    y_start=2e6,
    initOption=if ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.SteadyState) then 798 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialOutput) then 796 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialState) then 797 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState) then 795 else 501) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={206,154})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor6 annotation (Placement(transformation(extent={{160,124},{140,144}})));
  ClaRa.Visualisation.Quadruple quadruple24
    annotation (Placement(transformation(extent={{478,42},{518,56}})));
  ClaRa.Visualisation.Quadruple quadruple25
    annotation (Placement(transformation(extent={{180,-54},{220,-40}})));
  ClaRa.Visualisation.Quadruple quadruple27
    annotation (Placement(transformation(extent={{482,0},{522,14}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi1(
                                                                        p_const=21e5, T_const(displayUnit="degC") = 323.15) annotation (Placement(transformation(extent={{418,8},{438,28}})));
  ClaRa.Visualisation.Quadruple quadruple28
    annotation (Placement(transformation(extent={{322,-44},{362,-30}})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor7 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={454,-56})));
  Modelica.Blocks.Sources.Constant p_setLeft2(k=3e5)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}}, rotation=0)));
  ClaRa.Components.Utilities.Blocks.LimPID PID7(
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
        origin={434,-12})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor10 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={306,-104})));
  Modelica.Blocks.Sources.Constant p_setLeft11(k=2.3e5)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}}, rotation=90)));
  ClaRa.Components.Utilities.Blocks.LimPID PID10(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_min=0,
    Tau_i=10,
    u_ref=3e5,
    y_max=4e6,
    y_start=2e6,
    sign=-1,
    y_ref=1e6,
    initOption=if ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.SteadyState) then 798 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialOutput) then 796 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialState) then 797 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState) then 795 else 501) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={344,-104})));
  Modelica.Blocks.Sources.Constant p_setLeft12(k=1.9e5)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}}, rotation=90)));
  ClaRa.Components.Utilities.Blocks.LimPID PID11(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_min=0,
    Tau_i=10,
    y_max=4e6,
    sign=-1,
    u_ref=1.9e5,
    y_ref=0.5e6,
    y_start=1e6,
    initOption=if ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.SteadyState) then 798 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialOutput) then 796 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialState) then 797 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState) then 795 else 501) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={186,-102})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor11 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={148,-102})));
  HeatGridControl.Controllers.DHG_FeedForward_Controller
                                                dHNControl1 annotation (Placement(transformation(extent={{590,58},{560,76}})));
  TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperatureHH_900s_01012012_0000_31122012_2345_3 annotation (Placement(transformation(extent={{620,58},{602,76}})));
  HeatGridControl.Limit_Q_flow_set limit_Q_flow_set1(Q_flow_set_max=290e6) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={534,72})));
  ClaRa.Visualisation.DynDisplay dynDisplay1(
    unit="MW",
    decimalSpaces=2,
    varname="Energy balance 2",
    x1=(pumpRight3.P_drive + pumpRight2.P_drive + pumpRight1.P_drive + pumpRight.P_drive + HeatingCondenserRight.summary.outline.Q_flow_tot + HeatConsumer.summary.outline.Q_flow_tot/2)/1e6)
                     annotation (Placement(transformation(extent={{198,14},{268,34}})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //Functions
  function plotResult

    constant String resultFileName="TwoClosedLoops_PressureControlled.mat";

  algorithm

    TransiEnt.Basics.Functions.plotResult(resultFileName);
  createPlot(id=1, position={0, 0, 1516, 942}, y={"HeatConsumer.summary.outlet.T", "HeatConsumer.summary.inlet.T"}, range={0.0, 32000000.0, 40.0, 140.0}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
  createPlot(id=1, position={0, 0, 1516, 232}, y={"HeatingCondenserLeft.p", "HeatingCondenserRight.p", "HeatConsumer.p"}, range={0.0, 32000000.0, -5.0, 25.0}, autoscale=false, grid=true, subPlot=4, colors={{28,108,200}, {238,46,47}, {0,140,72}}, range2={0.0, 0.25});
  createPlot(id=1, position={0, 0, 1516, 231}, y={"HeatingCondenserLeft.eye.m_flow", "HeatingCondenserRight.eye.m_flow"}, range={0.0, 32000000.0, 1130.0, 1190.0}, autoscale=false, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}}, range2={0.133, 0.139});
  createPlot(id=1, position={0, 0, 1516, 232}, y={"HeatConsumer.heat.Q_flow", "HeatingCondenserRight.heat.Q_flow",
  "HeatingCondenserLeft.heat.Q_flow"}, range={0.0, 32000000.0, -1000000000.0, 1000000000.0}, autoscale=false, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}, {0,140,72}}, range2={0.167, 0.1695});

  end plotResult;

  Components.Visualization.DHG_PressureDiagram pDisplayLeft(
    minY=1,
    maxY=23,
    Unit="bar",
    n=4,
    m=6,
    p_supply=1e-5*{supplyPipeLeft1.summary.inlet.p,supplyPipeLeft1.summary.outlet.p,supplyPipeLeft2.summary.inlet.p,supplyPipeLeft2.summary.outlet.p},
    p_return=1e-5*{returnPipeLeft3.summary.outlet.p,returnPipeLeft3.summary.inlet.p,returnPipeLeft2.summary.outlet.p,returnPipeLeft2.summary.inlet.p,returnPipeLeft1.summary.outlet.p,returnPipeLeft1.summary.inlet.p},
    relative_positions_supply={0,supplyPipeLeft1.geo.length/(supplyPipeLeft1.geo.length + supplyPipeLeft2.geo.length),supplyPipeLeft1.geo.length/(supplyPipeLeft1.geo.length + supplyPipeLeft2.geo.length),(supplyPipeLeft1.geo.length + supplyPipeLeft2.geo.length)/(supplyPipeLeft1.geo.length + supplyPipeLeft2.geo.length)},
    relative_positions_return={0,returnPipeLeft3.geo.length/(returnPipeLeft1.geo.length + returnPipeLeft2.geo.length + returnPipeLeft3.geo.length),returnPipeLeft3.geo.length/(returnPipeLeft1.geo.length + returnPipeLeft2.geo.length + returnPipeLeft3.geo.length),(returnPipeLeft2.geo.length + returnPipeLeft3.geo.length)/(returnPipeLeft1.geo.length + returnPipeLeft2.geo.length + returnPipeLeft3.geo.length),(returnPipeLeft2.geo.length + returnPipeLeft3.geo.length)/(returnPipeLeft1.geo.length + returnPipeLeft2.geo.length + returnPipeLeft3.geo.length),(returnPipeLeft1.geo.length + returnPipeLeft2.geo.length + returnPipeLeft3.geo.length)/(returnPipeLeft1.geo.length + returnPipeLeft2.geo.length + returnPipeLeft3.geo.length)}) annotation (Placement(transformation(extent={{-122,-238},{-36,-152}})));
  Components.Visualization.DHG_PressureDiagram pDisplayRight(
    minY=1,
    maxY=23,
    Unit="bar",
    n=4,
    m=6,
    p_supply=1e-5*{supplyPipeRight2.summary.outlet.p,supplyPipeRight2.summary.inlet.p,supplyPipeRight1.summary.outlet.p,supplyPipeRight1.summary.inlet.p},
    relative_positions_supply={0,supplyPipeRight2.geo.length/(supplyPipeRight1.geo.length + supplyPipeRight2.geo.length),supplyPipeRight2.geo.length/(supplyPipeRight1.geo.length + supplyPipeRight2.geo.length),(supplyPipeRight1.geo.length + supplyPipeRight2.geo.length)/(supplyPipeRight1.geo.length + supplyPipeRight2.geo.length)},
    p_return=1e-5*{returnPipeRight1.summary.inlet.p,returnPipeRight1.summary.outlet.p,returnPipeRight2.summary.inlet.p,returnPipeRight2.summary.outlet.p,returnPipeRight3.summary.inlet.p,returnPipeRight3.summary.outlet.p},
    relative_positions_return={0,(returnPipeRight1.geo.length)/(returnPipeRight1.geo.length + returnPipeRight2.geo.length + returnPipeRight3.geo.length),(returnPipeRight1.geo.length)/(returnPipeRight1.geo.length + returnPipeRight2.geo.length + returnPipeRight3.geo.length),(returnPipeRight1.geo.length + returnPipeRight2.geo.length)/(returnPipeRight1.geo.length + returnPipeRight2.geo.length + returnPipeRight3.geo.length),(returnPipeRight1.geo.length + returnPipeRight2.geo.length)/(returnPipeRight1.geo.length + returnPipeRight2.geo.length + returnPipeRight3.geo.length),(returnPipeRight1.geo.length + returnPipeRight2.geo.length + returnPipeRight3.geo.length)/(returnPipeRight1.geo.length + returnPipeRight2.geo.length + returnPipeRight3.geo.length)}) annotation (Placement(transformation(extent={{42,-234},{128,-148}})));
  HeatGridControl.HeatDemandPrediction.HeatingGenerationCharline heatingLoadCharline_1(CharLine=HeatGridControl.HeatDemandPrediction.HeatingDemandCharacteristic.CharLineHeatDemandHH()) annotation (Placement(transformation(extent={{-500,108},{-488,120}})));
  HeatGridControl.HeatDemandPrediction.HeatingGenerationCharline heatingLoadCharline_2(CharLine=HeatGridControl.HeatDemandPrediction.HeatingDemandCharacteristic.CharLineHeatDemandHH()) annotation (Placement(transformation(extent={{598,82},{586,94}})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(HeatingCondenserLeft.heat,prescribedHeatFlow. port) annotation (Line(
      points={{-406,69},{-408,69},{-418,69}},
      color={167,25,48},
      thickness=0.5));
  connect(HeatingCondenserLeft.eye, quadruple13.eye) annotation (Line(
      points={{-380.8,82},{-380,82},{-380,96},{-374,96},{-374,97}},
      color={190,190,190}));
  connect(PressureReduction.eye, quadruple3.eye) annotation (Line(points={{-4.33333,70},{-4.33333,58},{-46,58}}, color={190,190,190}));
  connect(HeatConsumer.eye, quadruple15.eye) annotation (Line(points={{-11.2,12},{-11.2,4},{-50,4}},   color={190,190,190}));
  connect(DifferentialPressure.eye, quadruple18.eye) annotation (Line(points={{-4.33333,-34},{-4.33333,-52},{-50,-52}}, color={190,190,190}));
  connect(supplyPipeLeft2.outlet, PressureReduction.inlet) annotation (Line(
      points={{-32,123},{-1,123},{-1,88}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(returnPipeLeft1.inlet, DifferentialPressure.outlet) annotation (Line(
      points={{-36,-75},{-26,-75},{-26,-76},{-1,-76},{-1,-34}},
      color={0,131,169},
      thickness=0.5));
  connect(HeatConsumer.outlet, DifferentialPressure.inlet) annotation (Line(
      points={{0,12},{0,12},{0,-16},{-1,-16}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(HeatConsumer.inlet, PressureReduction.outlet) annotation (Line(
      points={{0,38},{0,70},{-1,70}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpLeft1.inlet, supplyPipeLeft1.outlet) annotation (Line(
      points={{-242,124},{-268,124},{-268,123},{-292,123}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpLeft3.inlet, returnPipeLeft1.outlet) annotation (Line(
      points={{-136,-76},{-98,-76},{-98,-75},{-64,-75}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpLeft2.inlet, returnPipeLeft2.outlet) annotation (Line(
      points={{-266,-76},{-222,-76},{-222,-77}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpLeft.inlet, returnPipeLeft3.outlet) annotation (Line(
      points={{-392,-24},{-392,-24},{-392,-78},{-392,-77},{-390,-77}},
      color={0,131,169},
      thickness=0.5));
  connect(HeatingCondenserLeft.inlet, valveVLE_L1_4.outlet) annotation (Line(
      points={{-392,56},{-392,46}},
      color={0,131,169},
      thickness=0.5));
  connect(valveVLE_L1_4.inlet, pumpLeft.outlet) annotation (Line(
      points={{-392,26},{-392,-4}},
      color={0,131,169},
      thickness=0.5));
  connect(quadruple1.eye, supplyPipeLeft2.eye) annotation (Line(points={{-66,110},{-26,110},{-26,119.6},{-31.4,119.6}}, color={190,190,190}));
  connect(quadruple2.eye, supplyPipeLeft1.eye) annotation (Line(points={{-328,110},{-290,110},{-290,119.6},{-291.4,119.6}},
                                                                                                                          color={190,190,190}));
  connect(returnPipeLeft3.eye, quadruple7.eye) annotation (Line(points={{-390.6,-80.4},{-396.3,-80.4},{-396.3,-89},{-394,-89}}, color={190,190,190}));
  connect(returnPipeLeft2.eye, quadruple12.eye) annotation (Line(points={{-222.6,-80.4},{-218,-80.4},{-218,-95}},
                                                                                                          color={190,190,190}));
  connect(returnPipeLeft1.eye, quadruple17.eye) annotation (Line(points={{-64.6,-78.4},{-64,-78.4},{-64,-78},{-68,-78},{-68,-89}}, color={190,190,190}));
  connect(PID.y, pumpLeft1.P_drive) annotation (Line(points={{-232,141},{-232,136}},color={0,0,127}));
  connect(PID.u_s,p_setLeft7.y)  annotation (Line(points={{-232,164},{-232,78},{-232,-6.6},{0,-6.6}}, color={0,0,127}));
  connect(pumpLeft1.outlet, vlePressureSensor.port) annotation (Line(
      points={{-222,124},{-200,124}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(vlePressureSensor.p, PID.u_m) annotation (Line(points={{-211,134},{-212,134},{-212,151.9},{-220,151.9}},
                                                                                                    color={0,0,127}));
  connect(valveVLE_L1_4.eye, quadruple5.eye) annotation (Line(points={{-388,46},{-388,46},{-388,47},{-378,47}}, color={190,190,190}));
  connect(quadruple8.eye, pumpLeft3.eye) annotation (Line(points={{-152,-51},{-156,-51},{-156,-52},{-157,-52},{-157,-70}},
                                                                                                                         color={190,190,190}));
  connect(quadruple11.eye, pumpLeft.eye) annotation (Line(points={{-374,5},{-378,5},{-378,4},{-386,4},{-386,-3}},    color={190,190,190}));
  connect(boundaryVLE_pTxi.steam_a, valveVLE_L1_4.inlet) annotation (Line(
      points={{-418,16},{-392,16},{-392,26}},
      color={0,131,169},
      thickness=0.5));
  connect(quadruple14.eye, pumpLeft2.eye) annotation (Line(points={{-290,-55},{-298,-55},{-298,-70},{-287,-70}},color={190,190,190}));
  connect(pumpLeft.inlet, vlePressureSensor1.port) annotation (Line(
      points={{-392,-24},{-392,-34},{-392,-58}},
      color={0,131,169},
      thickness=0.5));
  connect(PID1.u_s,p_setLeft3.y)  annotation (Line(points={{-434,-14},{6.6,-14},{6.6,0}}, color={0,0,127}));
  connect(PID1.y, pumpLeft.P_drive) annotation (Line(points={{-411,-14},{-404,-14}}, color={0,0,127}));
  connect(vlePressureSensor1.p, PID1.u_m) annotation (Line(points={{-402,-47},{-421.9,-47},{-421.9,-26}},
                                                                                                    color={0,0,127}));
  connect(PressureReduction.opening_in, PID2.y) annotation (Line(points={{6.5,79},{9.25,79},{9.25,80},{13,80}}, color={0,0,127}));
  connect(p_setLeft4.y, PID2.u_s) annotation (Line(points={{-6.6,0},{36,0},{36,80}}, color={0,0,127}));
  connect(HeatConsumer.inlet, vlePressureSensor2.port) annotation (Line(
      points={{0,38},{0,54}},
      color={0,131,169},
      thickness=0.5));
  connect(vlePressureSensor2.p, PID2.u_m) annotation (Line(points={{10,65},{18,65},{18,68},{23.9,68}},
                                                                                                    color={0,0,127}));
  connect(p_setLeft8.y, PID3.u_s) annotation (Line(points={{-6.6,0},{36,0},{36,-26}}, color={0,0,127}));
  connect(vlePressureSensor3.p, PID3.u_m) annotation (Line(points={{24,-43},{24,-38},{23.9,-38}},  color={0,0,127}));
  connect(DifferentialPressure.opening_in, PID3.y) annotation (Line(points={{6.5,-25},{12.25,-25},{12.25,-26},{13,-26}}, color={0,0,127}));
  connect(returnPipeLeft1.inlet, vlePressureSensor3.port) annotation (Line(
      points={{-36,-75},{-26,-75},{-26,-76},{14,-76},{14,-54}},
      color={0,131,169},
      thickness=0.5));
  connect(PID4.u_s,p_setLeft9.y)  annotation (Line(points={{-276,-118},{-276,-56},{-276,6.6},{0,6.6}}, color={0,0,127}));
  connect(vlePressureSensor4.p, PID4.u_m) annotation (Line(points={{-249,-86},{-254,-86},{-254,-106},{-264,-106},{-264,-105.9}},
                                                                                                    color={0,0,127}));
  connect(pumpLeft2.inlet, vlePressureSensor4.port) annotation (Line(
      points={{-266,-76},{-238,-76}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpLeft2.P_drive, PID4.y) annotation (Line(points={{-276,-88},{-276,-95}}, color={0,0,127}));
  connect(PID5.u_s,p_setLeft5.y)  annotation (Line(points={{-146,-118},{-146,-56},{-146,6.6},{0,6.6}}, color={0,0,127}));
  connect(vlePressureSensor5.p, PID5.u_m) annotation (Line(points={{-125,-92},{-124,-92},{-124,-106},{-134,-106},{-134,-105.9}},
                                                                                                    color={0,0,127}));
  connect(pumpLeft3.inlet, vlePressureSensor5.port) annotation (Line(
      points={{-136,-76},{-114,-76},{-114,-82}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpLeft3.P_drive, PID5.y) annotation (Line(points={{-146,-88},{-146,-95}}, color={0,0,127}));
  connect(HeatingCondenserLeft.outlet, supplyPipeLeft1.inlet) annotation (Line(
      points={{-392,82},{-392,82},{-392,124},{-320,124},{-320,123}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(vlePressureSensor.port, supplyPipeLeft2.inlet) annotation (Line(
      points={{-200,124},{-60,124},{-60,123}},
      color={0,131,169},
      thickness=0.5));
  connect(returnPipeLeft3.inlet, pumpLeft2.outlet) annotation (Line(
      points={{-362,-77},{-323,-77},{-323,-76},{-286,-76}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpLeft3.outlet, returnPipeLeft2.inlet) annotation (Line(
      points={{-156,-76},{-194,-76},{-194,-77}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(dHNControl.T_ambient,temperatureHH_900s_01012012_0000_31122012_2345_1.
                                                     value) annotation (Line(
      points={{-489,87},{-515.08,87}},
      color={0,0,127}));
  connect(temperatureHH_900s_01012012_0000_31122012_2345_2.y1, supplyandReturnTemperature1.T_amb) annotation (Line(points={{141.3,28.5},{119,28.5},{119,29}}, color={0,0,127}));
  connect(HeatConsumer.heat, prescribedTemperature.port) annotation (Line(
      points={{14,25},{41,25},{41,26},{68,26}},
      color={167,25,48},
      thickness=0.5));
  connect(supplyandReturnTemperature1.T_return_K, prescribedTemperature.T) annotation (Line(points={{107.5,25.6},{106,25.6},{106,26},{90,26}},  color={0,0,127}));
  connect(limit_Q_flow_set.Q_flow_set, prescribedHeatFlow.Q_flow) annotation (Line(points={{-446,83.8},{-446,69},{-432,69}}, color={0,0,127}));
  connect(HeatingCondenserRight.heat, prescribedHeatFlow1.port) annotation (Line(
      points={{478,71},{478,71},{492,71}},
      color={167,25,48},
      thickness=0.5));
  connect(HeatingCondenserRight.eye, quadruple9.eye) annotation (Line(points={{452.8,84},{450,84},{450,96},{392,96},{392,93}},                color={190,190,190}));
  connect(pumpRight1.inlet, supplyPipeRight1.outlet) annotation (Line(
      points={{214,124},{228,124},{228,125},{238,125}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpRight3.inlet, returnPipeRight1.outlet) annotation (Line(
      points={{176,-73},{140,-73},{140,-74},{124,-74},{112,-74},{112,-73},{96,-73}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpRight2.inlet, returnPipeRight2.outlet) annotation (Line(
      points={{334,-73},{280,-73}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpRight.inlet, returnPipeRight3.outlet) annotation (Line(
      points={{464,-22},{464,-22},{464,-73},{440,-73}},
      color={0,131,169},
      thickness=0.5));
  connect(HeatingCondenserRight.inlet, valveVLE_L1_1.outlet) annotation (Line(
      points={{464,58},{464,48}},
      color={0,131,169},
      thickness=0.5));
  connect(valveVLE_L1_1.inlet, pumpRight.outlet) annotation (Line(
      points={{464,28},{464,-2}},
      color={0,131,169},
      thickness=0.5));
  connect(quadruple22.eye, supplyPipeRight2.eye) annotation (Line(points={{40,160},{38,160},{38,119.6},{75.4,119.6}}, color={190,190,190}));
  connect(quadruple23.eye, supplyPipeRight1.eye) annotation (Line(points={{234,160},{232,160},{232,121.6},{237.4,121.6}},     color={190,190,190}));
  connect(returnPipeRight3.eye, quadruple4.eye) annotation (Line(points={{440.6,-76.4},{441.7,-76.4},{441.7,-105},{440,-105}}, color={190,190,190}));
  connect(returnPipeRight2.eye, quadruple6.eye) annotation (Line(points={{280.6,-76.4},{280,-76.4},{280,-183}}, color={190,190,190}));
  connect(returnPipeRight1.eye, quadruple19.eye) annotation (Line(points={{96.6,-76.4},{58,-76.4},{58,-103}}, color={190,190,190}));
  connect(PID6.y, pumpRight1.P_drive) annotation (Line(points={{206,143},{206,136},{204,136}},
                                                                                         color={0,0,127}));
  connect(PID6.u_s,p_setLeft1.y)  annotation (Line(points={{206,166},{206,80},{206,-6.6},{0,-6.6}}, color={0,0,127}));
  connect(pumpRight1.outlet, vlePressureSensor6.port) annotation (Line(
      points={{194,124},{174,124},{150,124}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(vlePressureSensor6.p, PID6.u_m) annotation (Line(points={{139,134},{132,134},{132,153.9},{194,153.9}},
                                                                                                    color={0,0,127}));
  connect(valveVLE_L1_1.eye, quadruple24.eye) annotation (Line(points={{468,48},{468,48},{468,49},{478,49}},             color={190,190,190}));
  connect(quadruple25.eye, pumpRight3.eye) annotation (Line(points={{180,-47},{176,-47},{176,-48},{197,-48},{197,-67}},      color={190,190,190}));
  connect(quadruple27.eye, pumpRight.eye) annotation (Line(points={{482,7},{478,7},{478,6},{470,6},{470,-1}},                    color={190,190,190}));
  connect(boundaryVLE_pTxi1.steam_a, valveVLE_L1_1.inlet) annotation (Line(
      points={{438,18},{464,18},{464,28}},
      color={0,131,169},
      thickness=0.5));
  connect(quadruple28.eye,pumpRight2. eye) annotation (Line(points={{322,-37},{364,-37},{364,-67},{355,-67}},
                                                                                                    color={190,190,190}));
  connect(pumpRight.inlet, vlePressureSensor7.port) annotation (Line(
      points={{464,-22},{464,-32},{464,-56}},
      color={0,131,169},
      thickness=0.5));
  connect(PID7.u_s,p_setLeft2.y)  annotation (Line(points={{422,-12},{6.6,-12},{6.6,0}}, color={0,0,127}));
  connect(PID7.y, pumpRight.P_drive) annotation (Line(points={{445,-12},{452,-12}},       color={0,0,127}));
  connect(vlePressureSensor7.p,PID7. u_m) annotation (Line(points={{454,-45},{434.1,-45},{434.1,-24}},
                                                                                                    color={0,0,127}));
  connect(PID10.u_s,p_setLeft11.y)  annotation (Line(points={{344,-116},{344,-54},{344,6.6},{0,6.6}}, color={0,0,127}));
  connect(vlePressureSensor10.p, PID10.u_m) annotation (Line(points={{317,-104},{324,-104},{324,-103.9},{332,-103.9}},  color={0,0,127}));
  connect(pumpRight2.inlet, vlePressureSensor10.port) annotation (Line(
      points={{334,-73},{306,-73},{306,-94}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpRight2.P_drive, PID10.y) annotation (Line(points={{344,-85},{344,-93}},   color={0,0,127}));
  connect(PID11.u_s,p_setLeft12.y)  annotation (Line(points={{186,-114},{186,-54},{186,6.6},{0,6.6}}, color={0,0,127}));
  connect(vlePressureSensor11.p, PID11.u_m) annotation (Line(points={{159,-102},{159,-101.9},{174,-101.9}},                   color={0,0,127}));
  connect(pumpRight3.inlet, vlePressureSensor11.port) annotation (Line(
      points={{176,-73},{176,-72},{168,-72},{148,-72},{148,-92}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpRight3.P_drive, PID11.y) annotation (Line(points={{186,-85},{186,-91}},     color={0,0,127}));
  connect(HeatingCondenserRight.outlet, supplyPipeRight1.inlet) annotation (Line(
      points={{464,84},{464,84},{464,126},{266,126},{266,125}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(vlePressureSensor6.port, supplyPipeRight2.inlet) annotation (Line(
      points={{150,124},{104,124},{104,123}},
      color={0,131,169},
      thickness=0.5));
  connect(returnPipeRight3.inlet, pumpRight2.outlet) annotation (Line(
      points={{412,-73},{412,-73},{354,-73}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpRight3.outlet, returnPipeRight2.inlet) annotation (Line(
      points={{196,-73},{252,-73}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(dHNControl1.T_ambient, temperatureHH_900s_01012012_0000_31122012_2345_3.value) annotation (Line(points={{585,67},{585,67},{603.08,67}},
                                                                                                    color={0,0,127}));
  connect(supplyPipeRight2.outlet, PressureReduction.inlet) annotation (Line(
      points={{76,123},{-1,123},{-1,88}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(returnPipeRight1.inlet, DifferentialPressure.outlet) annotation (Line(
      points={{68,-73},{62,-73},{62,-76},{-1,-76},{-1,-34}},
      color={0,131,169},
      thickness=0.5));
  connect(dHNControl.Q_flow_i[2], limit_Q_flow_set.Q_flow_set_total) annotation (Line(points={{-463,92.22},{-454.5,92.22},{-454.5,104.2},{-446,104.2}},   color={0,0,127}));
  connect(dHNControl1.Q_flow_i[1], limit_Q_flow_set1.Q_flow_set_total) annotation (Line(points={{559,72.22},{549.5,72.22},{549.5,72},{544.2,72}}, color={0,0,127}));
  connect(limit_Q_flow_set1.Q_flow_set, prescribedHeatFlow1.Q_flow) annotation (Line(
      points={{523.8,72},{506,72},{506,71}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(dHNControl.Q_dot_DH_Targ, heatingLoadCharline_1.Q_flow) annotation (Line(points={{-478,96.9},{-478,114},{-487.4,114}}, color={0,0,127}));
  connect(temperatureHH_900s_01012012_0000_31122012_2345_1.y1, heatingLoadCharline_1.T_amb) annotation (Line(points={{-513.1,87},{-506,87},{-506,114.6},{-500.6,114.6}}, color={0,0,127}));
  connect(dHNControl1.Q_dot_DH_Targ, heatingLoadCharline_2.Q_flow) annotation (Line(points={{574,76.9},{574,88},{585.4,88}}, color={0,0,127}));
  connect(heatingLoadCharline_2.T_amb, temperatureHH_900s_01012012_0000_31122012_2345_3.y1) annotation (Line(points={{598.6,88.6},{601.1,88.6},{601.1,67}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-540,-280},{620,200}},
          preserveAspectRatio=false), graphics={
        Text(
          extent={{-64,86},{-12,72}},
          lineColor={28,108,200},
          textString="pressure reducer"),
        Line(
          points={{-76,42}},
          color={255,128,0},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Line(
          points={{-102,78}},
          color={0,131,169},
          pattern=LinePattern.Dash),
        Line(
          points={{-102,80}},
          color={0,131,169},
          pattern=LinePattern.Dash),
        Line(
          points={{-74,76}},
          color={255,128,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-406,90},{-394,84}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p=~ 20bar"),
        Text(
          extent={{-290,130},{-256,126}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 6.7bar"),
        Text(
          extent={{-192,130},{-150,128}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 10.7bar"),
        Text(
          extent={{-98,146},{-66,124}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 10bar"),
        Text(
          extent={{-32,148},{-4,124}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 6bar"),
        Text(
          extent={{-362,142},{-326,124}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 19.5bar"),
        Text(
          extent={{-20,50},{-2,42}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 4.6bar"),
        Text(
          extent={{-34,-26},{-16,-34}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 4.2bar"),
        Text(
          extent={{-100,-134},{-82,-142}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 1.9bar"),
        Text(
          extent={{-216,-80},{-198,-88}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 3.7bar"),
        Text(
          extent={{-268,-80},{-250,-88}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 2.3bar"),
        Text(
          extent={{-342,-80},{-322,-88}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 15.7bar"),
        Text(
          extent={{-476,-82},{-438,-94}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 3bar"),
        Text(
          extent={{-424,0},{-406,-6}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 21bar"),
        Line(
          points={{162,16}},
          color={127,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{450,92},{462,86}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p=~ 20bar"),
        Text(
          extent={{490,136},{530,126}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 19.5bar"),
        Text(
          extent={{258,-76},{276,-84}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 3.7bar"),
        Text(
          extent={{352,-78},{370,-86}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 2.3bar"),
        Text(
          extent={{460,-82},{480,-90}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 15.7bar"),
        Text(
          extent={{400,-82},{438,-94}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 3bar"),
        Text(
          extent={{432,2},{450,-4}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 21bar")}),             Icon(coordinateSystem(extent={{-540,-280},{620,200}},
                              preserveAspectRatio=false), graphics),
    experiment(StopTime=3.1536e+007, Interval=900),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>This model illustrates possible applications of the library to model district heating grids. It shows heat producing units at the left and right, a heat consumer at the center and the supply and return lines for distribution at both sides. </p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This model shows a grid consisting of two closed loops. All pumps are pressure controlled.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
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
end TwoClosedLoops_PressureControlled;
