within TransiEnt.Grid.Heat.HeatGridTopology.GridConfigurations;
model DHG_Topology_HH_2ports_2sites_ClosedGrid

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

  extends TransiEnt.Grid.Heat.HeatGridTopology.Base.Partial_DHG_Topology_HH_2ports_2sites;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

//  Modelica.SIunits.HeatFlowRate Q_flow_dem;
//  Modelica.SIunits.Heat Q_dem;
  parameter Real m_flow_nom = 1160;
  // _____________________________________________
  //
  //                  Components
  // _____________________________________________

  ClaRa.Visualisation.Quadruple quadruple7
    annotation (Placement(transformation(extent={{-400,122},{-368,140}})));
  ClaRa.Visualisation.Quadruple quadruple12
    annotation (Placement(transformation(extent={{-224,116},{-192,134}})));
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
        origin={-6,245})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 PressureReduction(
    checkValve=false,
    openingInputIsActive=true,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=1e4, m_flow_nom=m_flow_nom)) annotation (Placement(transformation(
        extent={{-9,-5},{9,5}},
        rotation=-90,
        origin={-7,299})));
  ClaRa.Visualisation.Quadruple quadruple3
    annotation (Placement(transformation(extent={{-52,270},{-14,286}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 DifferentialPressure(
    openingInputIsActive=true,
    checkValve=false,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=1e4, m_flow_nom=m_flow_nom)) annotation (Placement(transformation(
        extent={{-9,-5},{9,5}},
        rotation=-90,
        origin={-7,195})));
  ClaRa.Visualisation.Quadruple quadruple17
    annotation (Placement(transformation(extent={{-74,122},{-32,140}})));
  ClaRa.Visualisation.Quadruple quadruple15
    annotation (Placement(transformation(extent={{-56,216},{-18,232}})));
  ClaRa.Visualisation.Quadruple quadruple18
    annotation (Placement(transformation(extent={{-56,160},{-18,176}})));
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
    initOption=0) annotation (Placement(transformation(extent={{-326,338},{-298,348}})));
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
    initOption=0) annotation (Placement(transformation(extent={{-66,338},{-38,348}})));
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
    initOption=0) annotation (Placement(transformation(extent={{-42,140},{-70,150}})));
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
    initOption=0) annotation (Placement(transformation(extent={{-200,138},{-228,148}})));
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
    initOption=0) annotation (Placement(transformation(extent={{-368,138},{-396,148}})));
  Modelica.Blocks.Sources.Constant p_set_VL_Consumer2(k=1) "Pressure limiter of the house system"   annotation (Placement(transformation(extent={{6,6},{-6,-6}}, rotation=-90)));
  Modelica.Blocks.Sources.Constant p_setLeft7(k=10.7e5)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}}, rotation=270)));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pumpLeft annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-398,206})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pumpLeft1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-238,344})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pumpLeft3 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-152,144})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pumpLeft2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-282,144})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L1_4(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                      Delta_p_nom=1e4, m_flow_nom=m_flow_nom)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=90,
        origin={-398,258})));
  ClaRa.Visualisation.Quadruple quadruple1
    annotation (Placement(transformation(extent={{-72,322},{-34,338}})));
  ClaRa.Visualisation.Quadruple quadruple2
    annotation (Placement(transformation(extent={{-334,322},{-296,338}})));
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
        origin={-238,372})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor annotation (Placement(transformation(extent={{-196,344},{-216,364}})));
  ClaRa.Visualisation.Quadruple quadruple5
    annotation (Placement(transformation(extent={{-384,260},{-344,274}})));
  ClaRa.Visualisation.Quadruple quadruple8
    annotation (Placement(transformation(extent={{-158,162},{-118,176}})));
  ClaRa.Visualisation.Quadruple quadruple11
    annotation (Placement(transformation(extent={{-380,218},{-340,232}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi(p_const=21e5, T_const(displayUnit="degC") = 323.15) annotation (Placement(transformation(extent={{-444,226},{-424,246}})));
  ClaRa.Visualisation.Quadruple quadruple14
    annotation (Placement(transformation(extent={{-296,158},{-256,172}})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-408,162})));
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
        origin={-428,206})));
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
        origin={18,300})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor2 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={4,274})));
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
        origin={18,194})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor3 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={18,166})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor4 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-244,134})));
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
        origin={-282,114})));
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
        origin={-152,114})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor5 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-120,128})));
  Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperatureHH_900s_01012012_0000_31122012_2345_2 annotation (Placement(transformation(extent={{150,241},{136,256}})));
  HeatGridControl.SupplyAndReturnTemperatureDHG                     supplyandReturnTemperature1 annotation (Placement(transformation(extent={{112,244},{102,254}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature annotation (Placement(transformation(extent={{82,236},{62,256}})));
  ClaRa.Visualisation.Quadruple quadruple4
    annotation (Placement(transformation(extent={{434,106},{466,124}})));
  ClaRa.Visualisation.Quadruple quadruple6
    annotation (Placement(transformation(extent={{274,28},{306,46}})));
  ClaRa.Visualisation.Quadruple quadruple19
    annotation (Placement(transformation(extent={{52,108},{94,126}})));
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
    initOption=0) annotation (Placement(transformation(extent={{260,340},{232,350}})));
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
    initOption=0) annotation (Placement(transformation(extent={{98,338},{70,348}})));
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
        origin={76,147})));
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
    initOption=0) annotation (Placement(transformation(extent={{246,142},{274,152}})));
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
    initOption=0) annotation (Placement(transformation(extent={{406,142},{434,152}})));
  Modelica.Blocks.Sources.Constant p_setLeft1(k=10.7e5)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}}, rotation=270)));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pumpRight annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={458,208})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pumpRight1 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={198,344})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pumpRight3 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={180,147})));
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pumpRight2 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={338,147})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L1_1(redeclare model PressureLoss =
        ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (                      Delta_p_nom=1e4, m_flow_nom=m_flow_nom)) annotation (Placement(transformation(
        extent={{-10,-6},{10,6}},
        rotation=90,
        origin={458,258})));
  ClaRa.Visualisation.Quadruple quadruple22
    annotation (Placement(transformation(extent={{34,372},{72,388}})));
  ClaRa.Visualisation.Quadruple quadruple23
    annotation (Placement(transformation(extent={{228,372},{266,388}})));
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
        origin={200,374})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor6 annotation (Placement(transformation(extent={{154,344},{134,364}})));
  ClaRa.Visualisation.Quadruple quadruple24
    annotation (Placement(transformation(extent={{472,262},{512,276}})));
  ClaRa.Visualisation.Quadruple quadruple25
    annotation (Placement(transformation(extent={{174,166},{214,180}})));
  ClaRa.Visualisation.Quadruple quadruple27
    annotation (Placement(transformation(extent={{476,220},{516,234}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi1(
                                                                        p_const=21e5, T_const(displayUnit="degC") = 323.15) annotation (Placement(transformation(extent={{412,228},{432,248}})));
  ClaRa.Visualisation.Quadruple quadruple28
    annotation (Placement(transformation(extent={{316,176},{356,190}})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor7 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={448,164})));
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
        origin={428,208})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor10 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={300,116})));
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
        origin={338,116})));
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
        origin={180,118})));
  ClaRa.Components.Sensors.SensorVLE_L1_p vlePressureSensor11 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={142,118})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

//   Q_flow_dem=WestDemand.Q_flow_dem+EastDemand.Q_flow_dem+NorthDemand.Q_flow_dem;
//   der(Q_dem)=Q_flow_dem;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(PressureReduction.eye,quadruple3. eye) annotation (Line(points={{-10.3333,290},{-10.3333,278},{-52,278}},
                                                                                                                 color={190,190,190}));
  connect(HeatConsumer.eye,quadruple15. eye) annotation (Line(points={{-17.2,232},{-17.2,224},{-56,224}},
                                                                                                       color={190,190,190}));
  connect(DifferentialPressure.eye,quadruple18. eye) annotation (Line(points={{-10.3333,186},{-10.3333,168},{-56,168}}, color={190,190,190}));
  connect(supplyPipeLeft2.outlet,PressureReduction. inlet) annotation (Line(
      points={{-38,343},{-7,343},{-7,308}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(returnPipeLeft1.inlet,DifferentialPressure. outlet) annotation (Line(
      points={{-42,145},{-32,145},{-32,144},{-7,144},{-7,186}},
      color={0,131,169},
      thickness=0.5));
  connect(HeatConsumer.outlet,DifferentialPressure. inlet) annotation (Line(
      points={{-6,232},{-6,232},{-6,204},{-7,204}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(HeatConsumer.inlet,PressureReduction. outlet) annotation (Line(
      points={{-6,258},{-6,290},{-7,290}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpLeft1.inlet,supplyPipeLeft1. outlet) annotation (Line(
      points={{-248,344},{-274,344},{-274,343},{-298,343}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpLeft3.inlet,returnPipeLeft1. outlet) annotation (Line(
      points={{-142,144},{-104,144},{-104,145},{-70,145}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpLeft2.inlet,returnPipeLeft2. outlet) annotation (Line(
      points={{-272,144},{-228,144},{-228,143}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpLeft.inlet,returnPipeLeft3. outlet) annotation (Line(
      points={{-398,196},{-398,196},{-398,142},{-398,143},{-396,143}},
      color={0,131,169},
      thickness=0.5));
  connect(valveVLE_L1_4.inlet,pumpLeft. outlet) annotation (Line(
      points={{-398,248},{-398,234},{-398,216}},
      color={0,131,169},
      thickness=0.5));
  connect(quadruple1.eye,supplyPipeLeft2. eye) annotation (Line(points={{-72,330},{-32,330},{-32,339.6},{-37.4,339.6}}, color={190,190,190}));
  connect(quadruple2.eye,supplyPipeLeft1. eye) annotation (Line(points={{-334,330},{-296,330},{-296,339.6},{-297.4,339.6}},
                                                                                                                          color={190,190,190}));
  connect(returnPipeLeft3.eye,quadruple7. eye) annotation (Line(points={{-396.6,139.6},{-402.3,139.6},{-402.3,131},{-400,131}}, color={190,190,190}));
  connect(returnPipeLeft2.eye,quadruple12. eye) annotation (Line(points={{-228.6,139.6},{-224,139.6},{-224,125}},
                                                                                                          color={190,190,190}));
  connect(returnPipeLeft1.eye,quadruple17. eye) annotation (Line(points={{-70.6,141.6},{-70,141.6},{-70,142},{-74,142},{-74,131}}, color={190,190,190}));
  connect(PID.y,pumpLeft1. P_drive) annotation (Line(points={{-238,361},{-238,356}},color={0,0,127}));
  connect(PID.u_s,p_setLeft7.y)  annotation (Line(points={{-238,384},{-238,188},{-238,-6.6},{0,-6.6}}, color={0,0,127}));
  connect(pumpLeft1.outlet,vlePressureSensor. port) annotation (Line(
      points={{-228,344},{-206,344}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(vlePressureSensor.p,PID. u_m) annotation (Line(points={{-217,354},{-218,354},{-218,371.9},{-226,371.9}},
                                                                                                    color={0,0,127}));
  connect(valveVLE_L1_4.eye,quadruple5. eye) annotation (Line(points={{-394,268},{-394,268},{-394,267},{-384,267}},
                                                                                                                color={190,190,190}));
  connect(quadruple8.eye,pumpLeft3. eye) annotation (Line(points={{-158,169},{-162,169},{-162,168},{-163,168},{-163,150}},
                                                                                                                         color={190,190,190}));
  connect(quadruple11.eye,pumpLeft. eye) annotation (Line(points={{-380,225},{-384,225},{-384,224},{-392,224},{-392,217}},
                                                                                                                     color={190,190,190}));
  connect(boundaryVLE_pTxi.steam_a,valveVLE_L1_4. inlet) annotation (Line(
      points={{-424,236},{-398,236},{-398,248}},
      color={0,131,169},
      thickness=0.5));
  connect(quadruple14.eye,pumpLeft2. eye) annotation (Line(points={{-296,165},{-304,165},{-304,150},{-293,150}},color={190,190,190}));
  connect(pumpLeft.inlet,vlePressureSensor1. port) annotation (Line(
      points={{-398,196},{-398,186},{-398,162}},
      color={0,131,169},
      thickness=0.5));
  connect(PID1.u_s,p_setLeft3.y)  annotation (Line(points={{-440,206},{6.6,206},{6.6,0}}, color={0,0,127}));
  connect(PID1.y,pumpLeft. P_drive) annotation (Line(points={{-417,206},{-410,206}}, color={0,0,127}));
  connect(vlePressureSensor1.p,PID1. u_m) annotation (Line(points={{-408,173},{-427.9,173},{-427.9,194}},
                                                                                                    color={0,0,127}));
  connect(PressureReduction.opening_in,PID2. y) annotation (Line(points={{0.5,299},{3.25,299},{3.25,300},{7,300}},
                                                                                                                color={0,0,127}));
  connect(p_setLeft4.y, PID2.u_s) annotation (Line(points={{-6.6,0},{30,0},{30,300}}, color={0,0,127}));
  connect(HeatConsumer.inlet,vlePressureSensor2. port) annotation (Line(
      points={{-6,258},{-6,274}},
      color={0,131,169},
      thickness=0.5));
  connect(vlePressureSensor2.p,PID2. u_m) annotation (Line(points={{4,285},{12,285},{12,288},{17.9,288}},
                                                                                                    color={0,0,127}));
  connect(p_setLeft8.y, PID3.u_s) annotation (Line(points={{-6.6,0},{30,0},{30,194}}, color={0,0,127}));
  connect(vlePressureSensor3.p,PID3. u_m) annotation (Line(points={{18,177},{18,182},{17.9,182}},  color={0,0,127}));
  connect(DifferentialPressure.opening_in,PID3. y) annotation (Line(points={{0.5,195},{6.25,195},{6.25,194},{7,194}},    color={0,0,127}));
  connect(returnPipeLeft1.inlet,vlePressureSensor3. port) annotation (Line(
      points={{-42,145},{-32,145},{-32,144},{8,144},{8,166}},
      color={0,131,169},
      thickness=0.5));
  connect(PID4.u_s,p_setLeft9.y)  annotation (Line(points={{-282,102},{-282,54},{-282,6.6},{0,6.6}}, color={0,0,127}));
  connect(vlePressureSensor4.p,PID4. u_m) annotation (Line(points={{-255,134},{-260,134},{-260,114},{-270,114},{-270,114.1}},
                                                                                                    color={0,0,127}));
  connect(pumpLeft2.inlet,vlePressureSensor4. port) annotation (Line(
      points={{-272,144},{-244,144}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpLeft2.P_drive,PID4. y) annotation (Line(points={{-282,132},{-282,125}}, color={0,0,127}));
  connect(PID5.u_s,p_setLeft5.y)  annotation (Line(points={{-152,102},{-152,54},{-152,6.6},{0,6.6}}, color={0,0,127}));
  connect(vlePressureSensor5.p,PID5. u_m) annotation (Line(points={{-131,128},{-130,128},{-130,114},{-140,114},{-140,114.1}},
                                                                                                    color={0,0,127}));
  connect(pumpLeft3.inlet,vlePressureSensor5. port) annotation (Line(
      points={{-142,144},{-120,144},{-120,138}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpLeft3.P_drive,PID5. y) annotation (Line(points={{-152,132},{-152,125}}, color={0,0,127}));
  connect(vlePressureSensor.port,supplyPipeLeft2. inlet) annotation (Line(
      points={{-206,344},{-66,344},{-66,343}},
      color={0,131,169},
      thickness=0.5));
  connect(returnPipeLeft3.inlet,pumpLeft2. outlet) annotation (Line(
      points={{-368,143},{-329,143},{-329,144},{-292,144}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpLeft3.outlet,returnPipeLeft2. inlet) annotation (Line(
      points={{-162,144},{-200,144},{-200,143}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(temperatureHH_900s_01012012_0000_31122012_2345_2.y1,supplyandReturnTemperature1. T_amb) annotation (Line(points={{135.3,248.5},{113,248.5},{113,249}},
                                                                                                                                                              color={0,0,127}));
  connect(HeatConsumer.heat,prescribedTemperature. port) annotation (Line(
      points={{8,245},{35,245},{35,246},{62,246}},
      color={167,25,48},
      thickness=0.5));
  connect(supplyandReturnTemperature1.T_return_K,prescribedTemperature. T) annotation (Line(points={{101.5,245.6},{100,245.6},{100,246},{84,246}},
                                                                                                                                                color={0,0,127}));
  connect(pumpRight1.inlet,supplyPipeRight1. outlet) annotation (Line(
      points={{208,344},{222,344},{222,345},{232,345}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpRight3.inlet,returnPipeRight1. outlet) annotation (Line(
      points={{170,147},{134,147},{134,146},{118,146},{106,146},{106,147},{90,147}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpRight2.inlet,returnPipeRight2. outlet) annotation (Line(
      points={{328,147},{274,147}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpRight.inlet,returnPipeRight3. outlet) annotation (Line(
      points={{458,198},{458,198},{458,147},{434,147}},
      color={0,131,169},
      thickness=0.5));
  connect(valveVLE_L1_1.inlet,pumpRight. outlet) annotation (Line(
      points={{458,248},{458,218}},
      color={0,131,169},
      thickness=0.5));
  connect(quadruple22.eye,supplyPipeRight2. eye) annotation (Line(points={{34,380},{32,380},{32,339.6},{69.4,339.6}}, color={190,190,190}));
  connect(quadruple23.eye,supplyPipeRight1. eye) annotation (Line(points={{228,380},{226,380},{226,341.6},{231.4,341.6}},     color={190,190,190}));
  connect(returnPipeRight3.eye,quadruple4. eye) annotation (Line(points={{434.6,143.6},{435.7,143.6},{435.7,115},{434,115}},   color={190,190,190}));
  connect(returnPipeRight2.eye,quadruple6. eye) annotation (Line(points={{274.6,143.6},{274,143.6},{274,37}},   color={190,190,190}));
  connect(returnPipeRight1.eye,quadruple19. eye) annotation (Line(points={{90.6,143.6},{52,143.6},{52,117}},  color={190,190,190}));
  connect(PID6.y,pumpRight1. P_drive) annotation (Line(points={{200,363},{200,356},{198,356}},
                                                                                         color={0,0,127}));
  connect(PID6.u_s,p_setLeft1.y)  annotation (Line(points={{200,386},{200,190},{200,-6.6},{0,-6.6}}, color={0,0,127}));
  connect(pumpRight1.outlet,vlePressureSensor6. port) annotation (Line(
      points={{188,344},{168,344},{144,344}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(vlePressureSensor6.p,PID6. u_m) annotation (Line(points={{133,354},{126,354},{126,373.9},{188,373.9}},
                                                                                                    color={0,0,127}));
  connect(valveVLE_L1_1.eye,quadruple24. eye) annotation (Line(points={{462,268},{462,268},{462,269},{472,269}},         color={190,190,190}));
  connect(quadruple25.eye,pumpRight3. eye) annotation (Line(points={{174,173},{170,173},{170,172},{191,172},{191,153}},      color={190,190,190}));
  connect(quadruple27.eye,pumpRight. eye) annotation (Line(points={{476,227},{472,227},{472,226},{464,226},{464,219}},           color={190,190,190}));
  connect(boundaryVLE_pTxi1.steam_a,valveVLE_L1_1. inlet) annotation (Line(
      points={{432,238},{458,238},{458,248}},
      color={0,131,169},
      thickness=0.5));
  connect(quadruple28.eye,pumpRight2. eye) annotation (Line(points={{316,183},{358,183},{358,153},{349,153}},
                                                                                                    color={190,190,190}));
  connect(pumpRight.inlet,vlePressureSensor7. port) annotation (Line(
      points={{458,198},{458,188},{458,164}},
      color={0,131,169},
      thickness=0.5));
  connect(PID7.u_s,p_setLeft2.y)  annotation (Line(points={{416,208},{6.6,208},{6.6,0}}, color={0,0,127}));
  connect(PID7.y,pumpRight. P_drive) annotation (Line(points={{439,208},{446,208}},       color={0,0,127}));
  connect(vlePressureSensor7.p,PID7. u_m) annotation (Line(points={{448,175},{428.1,175},{428.1,196}},
                                                                                                    color={0,0,127}));
  connect(PID10.u_s,p_setLeft11.y)  annotation (Line(points={{338,104},{338,56},{338,6.6},{0,6.6}}, color={0,0,127}));
  connect(vlePressureSensor10.p,PID10. u_m) annotation (Line(points={{311,116},{318,116},{318,116.1},{326,116.1}},      color={0,0,127}));
  connect(pumpRight2.inlet,vlePressureSensor10. port) annotation (Line(
      points={{328,147},{300,147},{300,126}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpRight2.P_drive,PID10. y) annotation (Line(points={{338,135},{338,127}},   color={0,0,127}));
  connect(PID11.u_s,p_setLeft12.y)  annotation (Line(points={{180,106},{180,56},{180,6.6},{0,6.6}}, color={0,0,127}));
  connect(vlePressureSensor11.p,PID11. u_m) annotation (Line(points={{153,118},{153,118.1},{168,118.1}},                      color={0,0,127}));
  connect(pumpRight3.inlet,vlePressureSensor11. port) annotation (Line(
      points={{170,147},{170,148},{162,148},{142,148},{142,128}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpRight3.P_drive,PID11. y) annotation (Line(points={{180,135},{180,129}},     color={0,0,127}));
  connect(vlePressureSensor6.port,supplyPipeRight2. inlet) annotation (Line(
      points={{144,344},{98,344},{98,343}},
      color={0,131,169},
      thickness=0.5));
  connect(returnPipeRight3.inlet,pumpRight2. outlet) annotation (Line(
      points={{406,147},{406,147},{348,147}},
      color={0,131,169},
      thickness=0.5));
  connect(pumpRight3.outlet,returnPipeRight2. inlet) annotation (Line(
      points={{190,147},{246,147}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(supplyPipeRight2.outlet,PressureReduction. inlet) annotation (Line(
      points={{70,343},{-7,343},{-7,308}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(returnPipeRight1.inlet,DifferentialPressure. outlet) annotation (Line(
      points={{62,147},{56,147},{56,144},{-7,144},{-7,186}},
      color={0,131,169},
      thickness=0.5));
  connect(fluidPortWest, supplyPipeLeft1.inlet) annotation (Line(
      points={{-216,-14},{-506,-14},{-506,346},{-326,346},{-326,343}},
      color={175,0,0},
      thickness=0.5));
  connect(valveVLE_L1_4.outlet, fluidPortWestReturn) annotation (Line(
      points={{-398,268},{-398,268},{-398,286},{-398,300},{-476,300},{-476,-60},{-214,-60}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(fluidPortEast, supplyPipeRight1.inlet) annotation (Line(
      points={{186,-108},{242,-108},{242,-102},{556,-102},{556,345},{260,345}},
      color={175,0,0},
      thickness=0.5));
  connect(valveVLE_L1_1.outlet, fluidPortEastReturn) annotation (Line(
      points={{458,268},{458,288},{534,288},{534,-144},{188,-144}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-440,-320},{500,420}}), graphics={
        Text(
          extent={{-70,306},{-18,292}},
          lineColor={28,108,200},
          textString="pressure reducer"),
        Text(
          extent={{-296,350},{-262,346}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 6.7bar"),
        Text(
          extent={{-198,350},{-156,348}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 10.7bar"),
        Text(
          extent={{-104,366},{-72,344}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 10bar"),
        Text(
          extent={{-38,368},{-10,344}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 6bar"),
        Text(
          extent={{-368,362},{-332,344}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 19.5bar"),
        Text(
          extent={{-26,270},{-8,262}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 4.6bar"),
        Text(
          extent={{-40,194},{-22,186}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 4.2bar"),
        Text(
          extent={{-222,140},{-204,132}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 3.7bar"),
        Text(
          extent={{-274,140},{-256,132}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 2.3bar"),
        Text(
          extent={{-348,140},{-328,132}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 15.7bar"),
        Text(
          extent={{-482,138},{-444,126}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 3bar"),
        Text(
          extent={{-430,220},{-412,214}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 21bar"),
        Text(
          extent={{484,356},{524,346}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 19.5bar"),
        Text(
          extent={{252,144},{270,136}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 3.7bar"),
        Text(
          extent={{346,142},{364,134}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 2.3bar"),
        Text(
          extent={{454,138},{474,130}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 15.7bar"),
        Text(
          extent={{394,138},{432,126}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 3bar"),
        Text(
          extent={{426,222},{444,216}},
          lineColor={127,0,0},
          pattern=LinePattern.Dash,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid,
          textString="p = 21bar")}),                                                                          Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Models the heat demand of the district heating grid in Hamburg as simplified closed grid with 2 heat ports to the outside (heat producers)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">fluidPortWest: inlet</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">fluidPortEast: inlet</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">fluidPortWestReturn: outlet</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">fluidPortEastReturn: outlet</span></p>
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
</html>"));
end DHG_Topology_HH_2ports_2sites_ClosedGrid;
