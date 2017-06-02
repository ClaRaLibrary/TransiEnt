within TransiEnt.Grid.Heat.HeatGridTopology.GridConfigurations;
model DHG_Topology_HH_1port_3sites_SimpleGrid

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

  extends TransiEnt.Grid.Heat.HeatGridTopology.Base.Partial_DHG_Topology_HH_1port_3sites;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  Modelica.SIunits.HeatFlowRate Q_flow_dem;
  Modelica.SIunits.Heat Q_dem;
  parameter Modelica.SIunits.MassFlowRate m_flow_nom=1100;

  // _____________________________________________
  //
  //                  Components
  // _____________________________________________

  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple VL_Pipe_Wedel_Karoline(
    diameter_i=0.7,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
    useHomotopy=true,
    showExpertSummary=true,
    showData=true,
    p_nom=linspace(
        1.0,
        0.33,
        noCellPerPipe.k)*20e5,
    h_nom=ones(noCellPerPipe.k)*467000,
    h_start=ones(noCellPerPipe.k)*400.0e3,
    p_start=linspace(
        1.0,
        0.33,
        noCellPerPipe.k)*21.0e5,
    Delta_p_nom=11.5e5/40*35,
    m_flow_nom=1100,
    length=20e3,
    frictionAtInlet=true,
    frictionAtOutlet=true) annotation (Placement(transformation(extent={{-138,18},{-104,30}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple VL_Pipe_HafenCity_CityNord(
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
        noCellPerPipe.k)*20e5,
    h_nom=ones(noCellPerPipe.k)*467000,
    h_start=ones(noCellPerPipe.k)*400.0e3,
    p_start=linspace(
        1.0,
        0.33,
        noCellPerPipe.k)*21.0e5,
    m_flow_nom=1500,
    Delta_p_nom=11.5e5/75*35,
    length=10e3) annotation (Placement(transformation(
        extent={{-17,-6},{17,6}},
        rotation=180,
        origin={116,147})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple VL_Pipe_Tiefstack_Eilbeck(
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
        noCellPerPipe.k)*20e5,
    h_nom=ones(noCellPerPipe.k)*467000,
    h_start=ones(noCellPerPipe.k)*400.0e3,
    p_start=linspace(
        1.0,
        0.33,
        noCellPerPipe.k)*21.0e5,
    m_flow_nom=1500,
    Delta_p_nom=11.5e5/75*35,
    length=5e3) annotation (Placement(transformation(extent={{228,18},{192,30}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple VL_Pipe_Karoline_City_Nord(
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
        noCellPerPipe.k)*20e5,
    h_nom=ones(noCellPerPipe.k)*467000,
    h_start=ones(noCellPerPipe.k)*400.0e3,
    p_start=linspace(
        1.0,
        0.33,
        noCellPerPipe.k)*21.0e5,
    m_flow_nom=1100,
    Delta_p_nom=11.5e5/40*5,
    length=10e3) annotation (Placement(transformation(
        extent={{17,-6},{-17,6}},
        rotation=270,
        origin={-74,103})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple VL_Pipe_Hafen_West(
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
        noCellPerPipe.k)*20e5,
    h_nom=ones(noCellPerPipe.k)*467000,
    h_start=ones(noCellPerPipe.k)*400.0e3,
    p_start=linspace(
        1.0,
        0.33,
        noCellPerPipe.k)*21.0e5,
    m_flow_nom=1500,
    Delta_p_nom=11.5e5/75*35,
    length=10e3) annotation (Placement(transformation(
        extent={{-9.5,-3.49992},{9.5,3.49995}},
        rotation=0,
        origin={-55.5,17.5})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y split_L2_Y annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={76,-2})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi pressureSink_WestDemand(
    medium=simCenter.fluid1,
    T_const=50 + 273.15,
    p_const=4.2e5,
    variable_T=true)
                   annotation (Placement(transformation(
        extent={{-8.5,-9},{8.5,9}},
        rotation=90,
        origin={-107,-98.5})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple VL_Pipe_Karoline_City_Nord1(
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
        noCellPerPipe.k)*20e5,
    h_nom=ones(noCellPerPipe.k)*467000,
    h_start=ones(noCellPerPipe.k)*400.0e3,
    p_start=linspace(
        1.0,
        0.33,
        noCellPerPipe.k)*21.0e5,
    m_flow_nom=1100,
    Delta_p_nom=11.5e5/40*5,
    length=500) annotation (Placement(transformation(
        extent={{-9.9999,-4.00021},{10,4.0002}},
        rotation=180,
        origin={20,10})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y split_L2_Y2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={176,24})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple VL_Pipe_Tiefstack_Eilbeck1(
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
        noCellPerPipe.k)*20e5,
    h_nom=ones(noCellPerPipe.k)*467000,
    h_start=ones(noCellPerPipe.k)*400.0e3,
    p_start=linspace(
        1.0,
        0.33,
        noCellPerPipe.k)*21.0e5,
    m_flow_nom=1500,
    Delta_p_nom=11.5e5/75*35,
    length=5e3) annotation (Placement(transformation(extent={{158,20},{136,28}})));
  ClaRa.Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y join_L2_Y1(volume=1, m_flow_in_nom={577/2,577/2}) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={110,22})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple VL_Pipe_Hafen_West1(
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
        noCellPerPipe.k)*20e5,
    h_nom=ones(noCellPerPipe.k)*467000,
    h_start=ones(noCellPerPipe.k)*400.0e3,
    p_start=linspace(
        1.0,
        0.33,
        noCellPerPipe.k)*21.0e5,
    m_flow_nom=1500,
    Delta_p_nom=11.5e5/75*35,
    length=10e3) annotation (Placement(transformation(
        extent={{9.5,-3.49993},{-9.5,3.49993}},
        rotation=180,
        origin={64.5,-26.5})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple VL_Pipe_Hafen_West2(
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
        noCellPerPipe.k)*20e5,
    h_nom=ones(noCellPerPipe.k)*467000,
    h_start=ones(noCellPerPipe.k)*400.0e3,
    p_start=linspace(
        1.0,
        0.33,
        noCellPerPipe.k)*21.0e5,
    m_flow_nom=1500,
    Delta_p_nom=11.5e5/75*35,
    length=10e3) annotation (Placement(transformation(
        extent={{-10.5,-3.5},{10.5,3.5}},
        rotation=0,
        origin={95.5,3.5})));
  ClaRa.Components.VolumesValvesFittings.Fittings.SplitVLE_L2_Y split_L2_Y3 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-82,18})));
  ClaRa.Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y join_L2_Y2(volume=1, m_flow_in_nom={577/2,577/2}) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-36,8})));
  ClaRa.Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y join_L2_Y3(volume=1, m_flow_in_nom={577/2,577/2}) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-2,158})));

  Components.Visualization.Quadruple quadruple annotation (Placement(transformation(extent={{-120,2},{-100,12}})));
  Components.Visualization.Quadruple quadruple1 annotation (Placement(transformation(extent={{188,-10},{208,0}})));
  Components.Visualization.Quadruple quadruple2 annotation (Placement(transformation(extent={{82,-28},{102,-18}})));
  Components.Visualization.Quadruple quadruple3 annotation (Placement(transformation(extent={{2,176},{22,186}})));
  Components.Visualization.Quadruple quadruple4 annotation (Placement(transformation(extent={{-64,-22},{-44,-12}})));
  Components.Visualization.Quadruple quadruple5 annotation (Placement(transformation(extent={{72,28},{92,38}})));
  Components.Visualization.Quadruple quadruple6 annotation (Placement(transformation(extent={{-76,-92},{-56,-82}})));
  ClaRa.Components.HeatExchangers.TubeBundle_L2 HeatConsumerWest(
    diameter=0.05,
    N_passes=5,
    length=4,
    N_tubes=25,
    m_flow_nom=m_flow_nom,
    p_nom(displayUnit="bar") = simCenter.p_n[2],
    h_start=TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        simCenter.p_n[1],
        273.15 + 50,
        simCenter.fluid1.xi_default),
    p_start(displayUnit="bar") = HeatConsumerWest.p_nom,
    h_nom=TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        simCenter.p_n[2],
        273.15 + 50,
        simCenter.fluid1.xi_default),
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=0.1e5),
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2) annotation (Placement(transformation(
        extent={{13,14},{-13,-14}},
        rotation=90,
        origin={-108,-51})));
  ClaRa.Visualisation.Quadruple quadruple15
    annotation (Placement(transformation(extent={{-178,-80},{-140,-64}})));
  Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperatureHH_900s_01012012_0000_31122012_2345_2 annotation (Placement(transformation(extent={{-50,-47},{-36,-32}})));
  HeatGridControl.SupplyAndReturnTemperatureDHG                     supplyandReturnTemperature1 annotation (Placement(transformation(extent={{-28,-48},{-18,-38}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature annotation (Placement(transformation(extent={{-66,-62},{-86,-42}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi pressureSink_WestDemand1(
    medium=simCenter.fluid1,
    T_const=50 + 273.15,
    p_const=4.2e5,
    variable_T=true)
                   annotation (Placement(transformation(
        extent={{-8.5,-9},{8.5,9}},
        rotation=90,
        origin={43,217.5})));
  Components.Visualization.Quadruple quadruple9 annotation (Placement(transformation(extent={{54,224},{74,234}})));
  ClaRa.Components.HeatExchangers.TubeBundle_L2 HeatConsumerNorth(
    diameter=0.05,
    N_passes=5,
    length=4,
    N_tubes=25,
    m_flow_nom=m_flow_nom,
    p_nom(displayUnit="bar") = simCenter.p_n[2],
    h_start=TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        simCenter.p_n[1],
        273.15 + 50,
        simCenter.fluid1.xi_default),
    p_start(displayUnit="bar") = HeatConsumerWest.p_nom,
    h_nom=TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        simCenter.p_n[2],
        273.15 + 50,
        simCenter.fluid1.xi_default),
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=0.1e5),
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2) annotation (Placement(transformation(
        extent={{13,14},{-13,-14}},
        rotation=90,
        origin={42,265})));
  ClaRa.Visualisation.Quadruple quadruple10
    annotation (Placement(transformation(extent={{-28,236},{10,252}})));
  Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperatureHH_900s_01012012_0000_31122012_2345_1 annotation (Placement(transformation(extent={{92,279},{106,294}})));
  HeatGridControl.SupplyAndReturnTemperatureDHG                     supplyandReturnTemperature2 annotation (Placement(transformation(extent={{118,268},{128,278}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature1
                                                                                    annotation (Placement(transformation(extent={{84,256},{64,276}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi pressureSink_WestDemand2(
    medium=simCenter.fluid1,
    T_const=50 + 273.15,
    p_const=4.2e5,
    variable_T=true)
                   annotation (Placement(transformation(
        extent={{-8.5,-9},{8.5,9}},
        rotation=90,
        origin={257,23.5})));
  Components.Visualization.Quadruple quadruple7 annotation (Placement(transformation(extent={{294,26},{314,36}})));
  ClaRa.Components.HeatExchangers.TubeBundle_L2 HeatConsumerEast(
    diameter=0.05,
    N_passes=5,
    length=4,
    N_tubes=25,
    m_flow_nom=m_flow_nom,
    p_nom(displayUnit="bar") = simCenter.p_n[2],
    h_start=TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        simCenter.p_n[1],
        273.15 + 50,
        simCenter.fluid1.xi_default),
    p_start(displayUnit="bar") = HeatConsumerWest.p_nom,
    h_nom=TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(
        simCenter.fluid1,
        simCenter.p_n[2],
        273.15 + 50,
        simCenter.fluid1.xi_default),
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2 (Delta_p_nom=0.1e5),
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2) annotation (Placement(transformation(
        extent={{13,14},{-13,-14}},
        rotation=90,
        origin={256,71})));
  Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperatureHH_900s_01012012_0000_31122012_2345_3 annotation (Placement(transformation(extent={{306,85},{320,100}})));
  HeatGridControl.SupplyAndReturnTemperatureDHG                     supplyandReturnTemperature3 annotation (Placement(transformation(extent={{332,74},{342,84}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature2
                                                                                    annotation (Placement(transformation(extent={{298,62},{278,82}})));

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

   //Q_flow_dem=WestDemand.Q_flow_dem+EastDemand.Q_flow_dem+NorthDemand.Q_flow_dem;
   Q_flow_dem=-1*(HeatConsumerNorth.summary.outline.Q_flow_tot+HeatConsumerWest.summary.outline.Q_flow_tot+HeatConsumerEast.summary.outline.Q_flow_tot); //EastDemand.Q_flow_dem+NorthDemand.Q_flow_dem;
   der(Q_dem)=Q_flow_dem;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(split_L2_Y2.inlet,VL_Pipe_Tiefstack_Eilbeck. outlet) annotation (
      Line(
      points={{186,24},{192,24}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(VL_Pipe_Tiefstack_Eilbeck1.inlet,split_L2_Y2. outlet1) annotation (
      Line(
      points={{158,24},{166,24}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(VL_Pipe_Tiefstack_Eilbeck1.outlet,join_L2_Y1. inlet2) annotation (
      Line(
      points={{136,24},{128,24},{128,22},{120,22}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(VL_Pipe_Hafen_West1.outlet,split_L2_Y. inlet) annotation (Line(
      points={{74,-26.5},{78,-26.5},{78,-12},{76,-12}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(VL_Pipe_Hafen_West2.inlet,split_L2_Y. outlet1) annotation (Line(
      points={{85,3.5},{81.5,3.5},{81.5,8},{76,8}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(VL_Pipe_Hafen_West2.outlet,join_L2_Y1. inlet1) annotation (Line(
      points={{106,3.5},{110,3.5},{110,12}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(split_L2_Y3.inlet,VL_Pipe_Wedel_Karoline. outlet) annotation (Line(
      points={{-92,18},{-98,18},{-98,24},{-104,24}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(split_L2_Y3.outlet1,VL_Pipe_Hafen_West. inlet) annotation (Line(
      points={{-72,18},{-64,18},{-64,17.5},{-65,17.5}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(VL_Pipe_Hafen_West.outlet,join_L2_Y2. inlet1) annotation (Line(
      points={{-46,17.5},{-46,18},{-36,18}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(split_L2_Y.outlet2,VL_Pipe_Karoline_City_Nord1. inlet) annotation (
      Line(
      points={{66,-2},{50,-2},{50,10},{29.9999,10}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(VL_Pipe_Karoline_City_Nord1.outlet,join_L2_Y2. inlet2) annotation (
      Line(
      points={{10,10},{-26,10},{-26,8}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(split_L2_Y3.outlet2,VL_Pipe_Karoline_City_Nord. inlet) annotation (
      Line(
      points={{-82,28},{-80,28},{-80,86},{-74,86}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(join_L2_Y3.inlet2,VL_Pipe_HafenCity_CityNord. outlet) annotation (
      Line(
      points={{-2,148},{38,148},{38,147},{99,147}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(join_L2_Y3.inlet1,VL_Pipe_Karoline_City_Nord. outlet) annotation (
      Line(
      points={{-12,158},{-44,158},{-44,120},{-74,120}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(split_L2_Y2.outlet2,VL_Pipe_HafenCity_CityNord. inlet) annotation (
      Line(
      points={{176,34},{154,34},{154,147},{133,147}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(fluidPortEast, VL_Pipe_Tiefstack_Eilbeck.inlet) annotation (Line(
      points={{186,-108},{186,-41},{228,-41},{228,24}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(fluidPortCenter, VL_Pipe_Hafen_West1.inlet) annotation (Line(
      points={{14,-84},{14,-56},{55,-56},{55,-26.5}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(fluidPortWest, VL_Pipe_Wedel_Karoline.inlet) annotation (Line(
      points={{-216,-14},{-178,-14},{-178,24},{-138,24}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(VL_Pipe_Wedel_Karoline.eye, quadruple.eye) annotation (Line(points={{-103.271,19.92},{-112,19.92},{-112,7},{-120,7}}, color={190,190,190}));
  connect(VL_Pipe_Tiefstack_Eilbeck.eye, quadruple1.eye) annotation (Line(points={{191.229,19.92},{191.229,19.46},{188,19.46},{188,-5}}, color={190,190,190}));
  connect(VL_Pipe_Hafen_West1.eye, quadruple2.eye) annotation (Line(points={{74.4071,-24.12},{78,-24.12},{78,-23},{82,-23}}, color={190,190,190}));
  connect(join_L2_Y3.eye, quadruple3.eye) annotation (Line(points={{8,166},{12,166},{12,181},{2,181}}, color={190,190,190}));
  connect(join_L2_Y2.eye, quadruple4.eye) annotation (Line(points={{-44,-2},{-44,-10},{-44,-17},{-64,-17}}, color={190,190,190}));
  connect(join_L2_Y1.eye, quadruple5.eye) annotation (Line(points={{102,32},{88,32},{88,33},{72,33}}, color={190,190,190}));
  connect(pressureSink_WestDemand.eye, quadruple6.eye) annotation (Line(points={{-99.8,-90},{-82,-90},{-82,-88},{-80,-88},{-80,-87},{-76,-87}},
                                                                                                                                    color={190,190,190}));
  connect(HeatConsumerWest.eye, quadruple15.eye) annotation (Line(points={{-119.2,-64},{-119.2,-72},{-178,-72}}, color={190,190,190}));
  connect(temperatureHH_900s_01012012_0000_31122012_2345_2.y1,supplyandReturnTemperature1. T_amb) annotation (Line(points={{-35.3,-39.5},{-29,-39.5},{-29,-43}},
                                                                                                                                                              color={0,0,127}));
  connect(HeatConsumerWest.heat, prescribedTemperature.port) annotation (Line(
      points={{-94,-51},{-87,-51},{-87,-52},{-86,-52}},
      color={167,25,48},
      thickness=0.5));
  connect(supplyandReturnTemperature1.T_return_K,prescribedTemperature. T) annotation (Line(points={{-17.5,-46.4},{-10,-46.4},{-10,-52},{-64,-52}},
                                                                                                                                                color={0,0,127}));
  connect(HeatConsumerWest.outlet, pressureSink_WestDemand.steam_a) annotation (Line(
      points={{-108,-64},{-108,-64},{-108,-90},{-107,-90}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(HeatConsumerWest.inlet, join_L2_Y2.outlet) annotation (Line(
      points={{-108,-38},{-102,-38},{-102,-2},{-36,-2}},
      color={0,131,169},
      thickness=0.5));
  connect(pressureSink_WestDemand.T, prescribedTemperature.T) annotation (Line(points={{-107,-107},{-52,-107},{-52,-90},{-52,-52},{-64,-52}},                color={0,0,127}));
  connect(pressureSink_WestDemand1.eye, quadruple9.eye) annotation (Line(points={{50.2,226},{50,226},{50,228},{50,229},{54,229}}, color={190,190,190}));
  connect(HeatConsumerNorth.eye, quadruple10.eye) annotation (Line(points={{30.8,252},{30.8,244},{-28,244}}, color={190,190,190}));
  connect(temperatureHH_900s_01012012_0000_31122012_2345_1.y1,supplyandReturnTemperature2. T_amb) annotation (Line(points={{106.7,286.5},{117,286.5},{117,273}},
                                                                                                                                                              color={0,0,127}));
  connect(HeatConsumerNorth.heat, prescribedTemperature1.port) annotation (Line(
      points={{56,265},{60,265},{60,266},{62,266},{64,266}},
      color={167,25,48},
      thickness=0.5));
  connect(supplyandReturnTemperature2.T_return_K, prescribedTemperature1.T) annotation (Line(points={{128.5,269.6},{132,269.6},{132,266},{86,266}}, color={0,0,127}));
  connect(HeatConsumerNorth.outlet, pressureSink_WestDemand1.steam_a) annotation (Line(
      points={{42,252},{42,252},{42,226},{43,226}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pressureSink_WestDemand1.T, prescribedTemperature1.T) annotation (Line(points={{43,209},{92,209},{92,208},{92,266},{86,266}}, color={0,0,127}));
  connect(join_L2_Y3.outlet, HeatConsumerNorth.inlet) annotation (Line(
      points={{8,158},{20,158},{20,280},{42,280},{42,278}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5,
      smooth=Smooth.Bezier));
  connect(pressureSink_WestDemand2.eye,quadruple7. eye) annotation (Line(points={{264.2,32},{294,32},{294,24},{294,31}},          color={190,190,190}));
  connect(temperatureHH_900s_01012012_0000_31122012_2345_3.y1,supplyandReturnTemperature3. T_amb) annotation (Line(points={{320.7,92.5},{331,92.5},{331,79}}, color={0,0,127}));
  connect(HeatConsumerEast.heat, prescribedTemperature2.port) annotation (Line(
      points={{270,71},{274,71},{274,72},{278,72}},
      color={167,25,48},
      thickness=0.5));
  connect(supplyandReturnTemperature3.T_return_K,prescribedTemperature2. T) annotation (Line(points={{342.5,75.6},{346,75.6},{346,72},{300,72}},    color={0,0,127}));
  connect(HeatConsumerEast.outlet, pressureSink_WestDemand2.steam_a) annotation (Line(
      points={{256,58},{256,58},{256,32},{257,32}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pressureSink_WestDemand2.T,prescribedTemperature2. T) annotation (Line(points={{257,15},{322,15},{322,20},{322,72},{300,72}}, color={0,0,127}));
  connect(HeatConsumerEast.inlet, join_L2_Y1.outlet) annotation (Line(
      points={{256,84},{110,84},{110,32}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.Bezier));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-440,-320},{500,420}})),           Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
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
</html>"));
end DHG_Topology_HH_1port_3sites_SimpleGrid;
