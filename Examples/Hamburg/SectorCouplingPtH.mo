within TransiEnt.Examples.Hamburg;
model SectorCouplingPtH "Example of an electric generation park coupled with a district heating grid and a power-to-heat unit"
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

  //Imports and extends

  extends TransiEnt.Basics.Icons.Example;

  import TransiEnt;

  //___________________
  //Components
  //___________________

  TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_Fuhlsbuettel_172800s_2012 temperatureHH_900s_01012012_0000_31122012_2345_1 annotation (Placement(transformation(extent={{-266,-190},{-246,-170}})));
  TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction.HeatingGenerationCharline heatingLoadCharline(
    CharLine=TransiEnt.Grid.Heat.HeatGridControl.HeatDemandPrediction.HeatingDemandCharacteristic.CharLineHeatDemandHH(a=100e6),
    Damping_Weekend=0.95,
    offsetOn=false,
    weekendOn=false) annotation (Placement(transformation(extent={{-232,-189},{-218,-175}})));

  //Components-Visualization
  TransiEnt.Grid.Heat.HeatGridControl.SupplyAndReturnTemperatureDHG supplyandReturnTemperature annotation (Placement(transformation(extent={{-229,-167},{-219,-157}})));

  TransiEnt.Producer.Heat.Gas2Heat.SimpleGasboilerGasport HW_HafenCity(typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.NaturalGas, p_drop=1000) annotation (Placement(transformation(
        extent={{-11,-11},{11,11}},
        rotation=0,
        origin={9,-201})));

  TransiEnt.Grid.Heat.HeatGridControl.Controllers.DHG_FeedForward_Controller dHNControl annotation (Placement(transformation(extent={{-242,-222},{-204,-198}})));
  TransiEnt.Grid.Heat.HeatGridTopology.GridConfigurations.DHG_Topology_HH_1port_4sites_MassFlowSink DistrictHeatingGrid annotation (Placement(transformation(extent={{11,-159},{105,-85}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi annotation (Placement(transformation(extent={{-2,-230},{10,-218}})));
  Modelica.Blocks.Sources.RealExpression T_return3(y=supplyandReturnTemperature.T_set[2]) annotation (Placement(transformation(
        extent={{6,-5},{-6,5}},
        rotation=180,
        origin={-27,-200})));
  Modelica.Blocks.Sources.RealExpression T_return2(y=supplyandReturnTemperature.T_set[2]) annotation (Placement(transformation(
        extent={{-5,-6},{5,6}},
        rotation=90,
        origin={151,-193})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_Txim_flow massflow_Tm_flow1(variable_m_flow=true, variable_T=true) annotation (Placement(transformation(
        extent={{4,-3},{-4,3}},
        rotation=180,
        origin={-12,-201})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_Txim_flow massflow_Tm_flow2(variable_m_flow=true, variable_T=true) annotation (Placement(transformation(
        extent={{-4,-3},{4,3}},
        rotation=90,
        origin={147,-178})));
  TransiEnt.Producer.Combined.LargeScaleCHP.ContinuousCHP Tiefstack_HardCoal(
    Q_flow_n_CHP(displayUnit="W") = 285e6,
    P_el_n(displayUnit="W") = 206000000,
    typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.BlackCoal,
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.HardCoal,
    P_grad_max_star=0.06/60,
    PQCharacteristics=TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_WT(),
    Q_flow_init=100e6,
    useConstantEfficiencies=false,
    P_el_init=UC.P_init[UC.schedule.WT]) annotation (Placement(transformation(extent={{172,-169},{146,-143}})));

  TransiEnt.Grid.Heat.HeatGridControl.HeatFlowDivision heatSchedulerEast(HeatFlowCL=TransiEnt.Grid.Heat.HeatGridControl.Base.DHGHeatFlowDivisionCharacteristicLines.SampleHeatFlowCharacteristicLines4Units()) annotation (Placement(transformation(extent={{-166,-214},{-146,-194}})));
  Modelica.Blocks.Sources.RealExpression m_flow_return1(y=-1*dHNControl.m_flow_i[3])    annotation (Placement(transformation(
        extent={{5,-5},{-5,5}},
        rotation=180,
        origin={-27,-207})));
  Modelica.Blocks.Sources.RealExpression m_flow_return2(y=-1*dHNControl.m_flow_i[1])  annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=90,
        origin={144,-193})));
  TransiEnt.Components.Visualization.InfoBoxLargeCHP infoBoxLargeCHP2 annotation (Placement(transformation(extent={{25,-230},{43,-210}})));
  TransiEnt.Components.Visualization.InfoBoxLargeCHP infoBoxLargeCHP3 annotation (Placement(transformation(extent={{135,-198},{117,-178}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_set_WT(y=-1*heatSchedulerEast.Q_flow_i[2])       annotation (Placement(transformation(
        extent={{-9,-5},{9,5}},
        rotation=270,
        origin={152,-127})));
  Modelica.Blocks.Sources.RealExpression Q_flow_set_Hafen(y=-1*dHNControl.Q_flow_i[3])          annotation (Placement(transformation(
        extent={{-9,-5},{9,5}},
        rotation=0,
        origin={-12,-185})));
  Modelica.Blocks.Sources.RealExpression Q_set_MVB(y=heatSchedulerEast.Q_flow_i[1] - dHNControl.Q_flow_i[4])
                                                                                          annotation (Placement(transformation(
        extent={{-9,-5},{9,5}},
        rotation=270,
        origin={122,-127})));
  Modelica.Blocks.Sources.RealExpression Q_set_Spivo_Tiefstack(y=-1*(heatSchedulerEast.Q_flow_i[3] + heatSchedulerEast.Q_flow_i[4]))            annotation (Placement(transformation(
        extent={{-9,-5},{9,5}},
        rotation=270,
        origin={108,-127})));

  Modelica.Blocks.Sources.RealExpression HeatFlowEastPlusWUWSPS(y=dHNControl.Q_flow_i[1] + dHNControl.Q_flow_i[4])                 annotation (Placement(transformation(
        extent={{12.5,-7.5},{-12.5,7.5}},
        rotation=180,
        origin={-197.5,-189.5})));
  Modelica.Blocks.Sources.RealExpression Q_set_WUWSPS(y=-1*dHNControl.Q_flow_i[4])          annotation (Placement(transformation(
        extent={{-9,-5},{9,5}},
        rotation=0,
        origin={82,-197})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_Txim_flow massflow_Tm_flow4(variable_m_flow=true, variable_T=true) annotation (Placement(transformation(
        extent={{-4,-3},{4,3}},
        rotation=180,
        origin={110,-212})));
  Modelica.Blocks.Sources.RealExpression m_flow_return5(y=-1*dHNControl.m_flow_i[4])    annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={127,-215})));
  Modelica.Blocks.Sources.RealExpression T_return1(y=supplyandReturnTemperature.T_set[2]) annotation (Placement(transformation(
        extent={{-6,-5},{6,5}},
        rotation=180,
        origin={127,-206})));
  inner TransiEnt.SimCenter  simCenter(         thres=1e-9,
    useThresh=true,
    tableInterpolationSmoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    Td=450,
    redeclare TransiEnt.Examples.Hamburg.ExampleGenerationPark2035 generationPark)
    annotation (Placement(transformation(extent={{-290,240},{-270,260}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-280,260},{-260,240}})));
  TransiEnt.Components.Sensors.ElectricActivePower P_12(change_of_sign=false) annotation (Placement(transformation(extent={{227,-31},{256,-56}})));
  TransiEnt.Producer.Electrical.Conventional.BrownCoal BrownCoal(
    P_max_star=1,
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.BrownCoal,
    primaryBalancingController(providedDroop=0.2/50/(3/150 - 0.2*0.01)),
    isPrimaryControlActive=true,
    t_startup=0,
    P_init=UC.P_init[UC.schedule.BCG],
    isSecondaryControlActive=true) annotation (Placement(transformation(extent={{-95,71},{-55,109}})));
  TransiEnt.Producer.Electrical.Conventional.Gasturbine Gasturbine2(
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.GasTurbine,
    isPrimaryControlActive=false,
    isSecondaryControlActive=true,
    t_startup=0,
    P_el_n=simCenter.generationPark.P_el_n_GT2,
    P_init=UC.P_init[UC.schedule.GT2]) annotation (Placement(transformation(extent={{-23,-39},{17,-1}})));
  TransiEnt.Grid.Electrical.LumpedPowerGrid.LumpedGrid UCTE(
    delta_pr=0.2/50/(3/150 - 0.2*0.01),
    P_pr_max_star=0.02,
    k_pr=0.5,
    T_r=150,
    lambda_sec=simCenter.P_n_ref_2/(simCenter.P_n_ref_1 + simCenter.P_n_ref_2)*3e9/0.2,
    P_pr_grad_max_star=0.02/30,
    beta=0.2,
    redeclare TransiEnt.Grid.Electrical.Noise.TypicalLumpedGridError genericGridError) annotation (Placement(transformation(extent={{301,-62},{261,-24}})));
  TransiEnt.Producer.Electrical.Controllers.CurtailmentController P_RE_curtailement annotation (Placement(transformation(extent={{151,177},{191,215}})));
  TransiEnt.Consumer.Electrical.LinearElectricConsumer Demand annotation (Placement(transformation(
        extent={{-169,-5},{-129,33}},
        rotation=0,
        origin={400,38})));
  TransiEnt.Producer.Electrical.Conventional.Garbage GAR(
    primaryBalancingController(providedDroop=0.2/50/(3/150 - 0.2*0.01)),
    isPrimaryControlActive=true,
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.BrownCoal,
    t_startup=0,
    P_init=UC.P_init[UC.schedule.GAR],
    isSecondaryControlActive=true) "Garbage" annotation (Placement(transformation(extent={{25,71},{65,109}})));
  TransiEnt.Grid.Electrical.SecondaryControl.AGC aGC(
    K_r=simCenter.P_n_ref_1/(simCenter.P_n_ref_1 + simCenter.P_n_ref_2)*3e9/0.2,
    changeSignOfTieLinePower=false,
    isExternalTielineSetpoint=true,
    samplePeriod=60,
    startTime=60) annotation (Placement(transformation(extent={{-208,-82},{-170,-119}})));
  TransiEnt.Producer.Electrical.Conventional.CCP CCP(
    isSecondaryControlActive=true,
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.GasCCGT,
    t_startup=0,
    P_init=UC.P_init[UC.schedule.CCP]) annotation (Placement(transformation(extent={{-169,-37},{-129,1}})));
  TransiEnt.Producer.Electrical.Conventional.Oil OIL(
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.GasCCGT,
    primaryBalancingController(providedDroop=0.2/50/(3/150 - 0.2*0.01)),
    isPrimaryControlActive=true,
    t_startup=0,
    P_init=UC.P_init[UC.schedule.OIL],
    isSecondaryControlActive=true) "Mineral oil" annotation (Placement(transformation(extent={{-35,71},{5,109}})));
  TransiEnt.Producer.Electrical.Wind.PowerProfileWindPlant WindOnshorePlant(P_el_n=simCenter.generationPark.P_el_n_WindOn) annotation (Placement(transformation(extent={{-35,177},{5,215}})));
  TransiEnt.Producer.Electrical.Wind.PowerProfileWindPlant WindOffshorePlant(
    P_el_n=simCenter.generationPark.P_el_n_WindOff,
    typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.WindOffshore,
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.WindOffshore) annotation (Placement(transformation(extent={{-95,177},{-55,215}})));
  TransiEnt.Producer.Electrical.Photovoltaics.PhotovoltaicProfilePlant PVPlant(P_el_n=simCenter.generationPark.P_el_n_PV) annotation (Placement(transformation(extent={{25,177},{65,215}})));
  TransiEnt.Producer.Electrical.Others.Biomass Biomass(
    P_max_star=1,
    primaryBalancingController(providedDroop=0.2/50/(3/150 - 0.2*0.01)),
    isPrimaryControlActive=false,
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.Biomass,
    t_startup=0,
    P_init=UC.P_init[UC.schedule.BM],
    isSecondaryControlActive=true,
    isExternalSecondaryController=true) annotation (Placement(transformation(extent={{83,71},{123,109}})));
  TransiEnt.Producer.Electrical.Others.PumpedStoragePlant PumpedStorage(
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PumpedStorage,
    t_startup=60,
    P_init=-(UC.P_init[UC.schedule.PS] + UC.P_init[UC.schedule.PS_Pump])) annotation (Placement(transformation(extent={{139,-39},{179,-1}})));
  TransiEnt.Producer.Electrical.Others.IdealContinuousHydropowerPlant RunOfWaterPlant(P_el_n=simCenter.generationPark.P_el_n_ROH, redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.RunOffHydro) annotation (Placement(transformation(extent={{85,177},{125,215}})));

  Modelica.Blocks.Sources.RealExpression P_set_BM(y=UC.schedule.y[UC.schedule.BM])
                                                                             annotation (Placement(transformation(extent={{74,116},{94,136}})));
  Modelica.Blocks.Sources.RealExpression P_set_BCG(y=-mod.y[UC.schedule.BCG])   annotation (Placement(transformation(extent={{-108,116},{-88,136}})));
  Modelica.Blocks.Sources.RealExpression P_set_OIL(y=-mod.y[UC.schedule.OIL])         annotation (Placement(transformation(extent={{-50,116},{-30,136}})));
  Modelica.Blocks.Sources.RealExpression P_set_GAR(y=-mod.y[UC.schedule.GAR])        annotation (Placement(transformation(extent={{10,116},{30,136}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_CCP(y=aGC.P_sec_set[UC.schedule.CCP])
                                                           annotation (Placement(transformation(extent={{-198,-4},{-178,16}})));
  Modelica.Blocks.Sources.RealExpression P_set_CCP(y=-mod.y[UC.schedule.CCP])        annotation (Placement(transformation(extent={{-176,8},{-156,28}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_GT(y=aGC.P_sec_set[UC.schedule.GT1])
                                                          annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.RealExpression P_set_GT2(y=-mod.y[UC.schedule.GT2]) annotation (Placement(transformation(extent={{18,2},{-2,22}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_PS(y=aGC.P_sec_set[UC.schedule.PS])
                                                          annotation (Placement(transformation(extent={{112,-8},{132,12}})));
  Modelica.Blocks.Sources.RealExpression P_set_PS(y=UC.schedule.y[UC.schedule.PS] + UC.schedule.y[UC.schedule.PS_Pump])     annotation (Placement(transformation(extent={{134,6},{154,26}})));
  Modelica.Blocks.Sources.RealExpression P_set_CHP_West(y=UC.schedule.y[UC.schedule.WW1]) annotation (Placement(transformation(extent={{-110,-134},{-90,-114}})));
  Modelica.Blocks.Sources.RealExpression P_set_CHP_East(y=UC.schedule.y[UC.schedule.WT]) annotation (Placement(transformation(extent={{144,-118},{164,-98}})));
  Modelica.Blocks.Sources.RealExpression P_set_Curt(y=UC.schedule.y[UC.schedule.Curt])             annotation (Placement(transformation(extent={{128,222},{148,242}})));
  Modelica.Blocks.Sources.RealExpression P_tieline_set(y=UC.schedule.y[UC.schedule.Import])
                                                                          annotation (Placement(transformation(extent={{-150,-138},{-170,-118}})));
  Modelica.Blocks.Sources.RealExpression P_tieline_is(y=P_12.P) annotation (Placement(transformation(extent={{-222,-138},{-202,-118}})));
  TransiEnt.Basics.Blocks.Sources.RealVectorExpression P_sec_pos(nout=simCenter.generationPark.nDispPlants, y_set=UC.P_sec_pos) annotation (Placement(transformation(extent={{-238,-102},{-218,-82}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_BCG(y=aGC.P_sec_set[UC.schedule.BCG]) annotation (Placement(transformation(extent={{-116,102},{-96,122}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_OIL(y=aGC.P_sec_set[UC.schedule.OIL]) annotation (Placement(transformation(extent={{-60,102},{-40,122}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_GAR(y=aGC.P_sec_set[UC.schedule.GAR]) annotation (Placement(transformation(extent={{0,102},{20,122}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_BM(y=aGC.P_sec_set[UC.schedule.BM]) annotation (Placement(transformation(extent={{58,102},{78,122}})));
  TransiEnt.Basics.Blocks.Sources.RealVectorExpression P_sec_neg(nout=simCenter.generationPark.nDispPlants, y_set=UC.P_sec_neg) annotation (Placement(transformation(extent={{-238,-120},{-218,-100}})));
  Modelica.Blocks.Sources.RealExpression P_set_WT1(
                                                  y=-mod.y[UC.schedule.GUDTS]) annotation (Placement(transformation(extent={{190,-126},{210,-106}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_CHP_East1(
                                                           y=aGC.P_sec_set[UC.schedule.WT]) annotation (Placement(transformation(extent={{174,-140},{194,-120}})));
  TransiEnt.Producer.Electrical.Conventional.BlackCoal BlackCoal(
    isSecondaryControlActive=true,
    t_startup=0,
    P_init=UC.P_init[UC.schedule.BC]) annotation (Placement(transformation(extent={{153,73},{193,111}})));
  Modelica.Blocks.Sources.RealExpression P_set_BC(y=-mod.y[UC.schedule.BC])        annotation (Placement(transformation(extent={{146,118},{166,138}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_BC(y=aGC.P_sec_set[UC.schedule.BC])
                                                          annotation (Placement(transformation(extent={{128,104},{148,124}})));
  TransiEnt.Producer.Electrical.Conventional.Gasturbine Gasturbine3(
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.GasTurbine,
    isPrimaryControlActive=false,
    isSecondaryControlActive=true,
    t_startup=0,
    P_el_n=simCenter.generationPark.P_el_n_GT3,
    P_init=UC.P_init[UC.schedule.GT3]) annotation (Placement(transformation(extent={{53,-37},{93,1}})));
  Modelica.Blocks.Sources.RealExpression P_set_GT3(y=-mod.y[UC.schedule.GT3])
                                                                             annotation (Placement(transformation(extent={{94,4},{74,24}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_GT1(
                                                     y=aGC.P_sec_set[UC.schedule.GT1])
                                                          annotation (Placement(transformation(extent={{36,2},{56,22}})));
  TransiEnt.Producer.Electrical.Conventional.Gasturbine Gasturbine1(
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.GasTurbine,
    isPrimaryControlActive=false,
    isSecondaryControlActive=true,
    t_startup=0,
    P_init=UC.P_init[UC.schedule.GT1],
    P_el_n=simCenter.generationPark.P_el_n_GT1) annotation (Placement(transformation(extent={{-99,-39},{-59,-1}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_GT2(
                                                     y=aGC.P_sec_set[UC.schedule.GT1])
                                                          annotation (Placement(transformation(extent={{-116,0},{-96,20}})));
  Modelica.Blocks.Sources.RealExpression P_set_GT1(y=-mod.y[UC.schedule.GT1])
                                                                             annotation (Placement(transformation(extent={{-58,2},{-78,22}})));
  Modelica.Blocks.Sources.RealExpression P_RE_Pred(y=-sum(UC.schedule.y[UC.schedule.ROH:UC.schedule.WindOff])) annotation (Placement(transformation(extent={{174,224},{194,244}})));
  TransiEnt.Producer.Combined.LargeScaleCHP.ContinuousCHP HKW_Wedel(
    PQCharacteristics=TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_WWGuD(),
    sigma=0.95,
    P_el_n=470e6,
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.GasCCGT,
    typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.NaturalGas,
    P_grad_max_star=0.08/60,
    P_el_init=UC.P_init[UC.schedule.WW1]) annotation (Placement(transformation(extent={{-85,-158},{-65,-138}})));

  Modelica.Blocks.Sources.RealExpression Q_flow_set_WW1(y=-1*(dHNControl.Q_flow_i[2]) + PtH.Q_flow_is)
                                                                                                    annotation (Placement(transformation(
        extent={{-9,-5},{9,5}},
        rotation=270,
        origin={-71,-111})));
  TransiEnt.Components.Visualization.InfoBoxLargeCHP infoBoxLargeCHP1 annotation (Placement(transformation(extent={{-38,-192},{-20,-172}})));
  Modelica.Blocks.Sources.RealExpression T_return5(y=supplyandReturnTemperature.T_set[2]) annotation (Placement(transformation(
        extent={{-5,-6},{5,6}},
        rotation=90,
        origin={-53,-177})));
  Modelica.Blocks.Sources.RealExpression m_flow_return3(y=-1*dHNControl.m_flow_i[2])          annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=90,
        origin={-64,-177})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_Txim_flow massflow_Tm_flow3(variable_m_flow=true, variable_T=true) annotation (Placement(transformation(
        extent={{-4,-3},{4,3}},
        rotation=90,
        origin={-60,-162})));
  TransiEnt.Producer.Heat.Gas2Heat.SimpleBoiler spiVo_Wedel(Q_flow_n=250e6, typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.NaturalGas) annotation (Placement(transformation(extent={{-18,-158},{2,-138}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_set_Spivo_Wedel(y=-max(dHNControl.Q_flow_i[2] - HKW_Wedel.Q_flow_n_CHP, 0))
                                                                                                 annotation (Placement(transformation(
        extent={{-9,-5},{9,5}},
        rotation=270,
        origin={-8,-123})));
  TransiEnt.Producer.Heat.Power2Heat.ElectricBoiler PtH(Q_flow_n=HKW_Wedel.Q_flow_n_CHP) annotation (Placement(transformation(extent={{-44,-158},{-24,-138}})));
  TransiEnt.Producer.Heat.Power2Heat.Controller.PtH_limiter ptH_limiter(Q_flow_PtH_max=PtH.Q_flow_n) annotation (Placement(transformation(extent={{-166,-178},{-146,-158}})));
  Modelica.Blocks.Sources.RealExpression P_set_Pth(y=min(P_set_Curt.y, PtH.Q_flow_n)) annotation (Placement(transformation(extent={{-194,-178},{-174,-158}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_set_PtH(y=-ptH_limiter.Q_flow_set_PtH)              annotation (Placement(transformation(
        extent={{-9,-5},{9,5}},
        rotation=270,
        origin={-31,-121})));
  Modelica.Blocks.Sources.RealExpression P_set_Curt_after_P2H(y=UC.schedule.y[UC.schedule.Curt]) annotation (Placement(transformation(extent={{132,206},{152,226}})));
  Modelica.Blocks.Sources.Constant t_start_set(k=0) annotation (Placement(transformation(extent={{-284,192},{-264,212}})));
  Modelica.Blocks.Sources.RealExpression P_residual_is(y=Demand.epp.P + P_RE_curtailement.epp_out.P + PumpedStorage.epp.P + Biomass.epp.P + P_tieline_set.y)
                                                                                                    annotation (Placement(transformation(extent={{-268,62},{-248,82}})));
  Modelica.Blocks.Sources.RealExpression P_residual_pred(y=-sum(UC.schedule.y[simCenter.generationPark.isMOD])) "All disponible plants (Conventional apart from Pumped Storage and CHP)"
                                                                                     annotation (Placement(transformation(extent={{-262,84},{-242,104}})));
  TransiEnt.Grid.Electrical.EconomicDispatch.DiscretizePrediction discretizePrediction(t_shift=0, samplePeriod=900) annotation (Placement(transformation(extent={{-202,62},{-182,82}})));
  TransiEnt.Grid.Electrical.EconomicDispatch.LoadPredictionAdaption H_lpa(P_lpa_init=0) annotation (Placement(transformation(extent={{-238,62},{-218,82}})));

  TransiEnt.Grid.Electrical.UnitCommitment.BinaryScheduleDataTable UC(
    t_start=t_start_set.k,
    P_init=P_init_set.k,
    unit_mustrun=fill(false, simCenter.generationPark.nDispPlants),
    schedule(
      BC=5,
      CCP=6,
      GT1=7,
      GT2=8,
      GT3=9,
      OIL=10,
      GAR=11,
      BM=12,
      PS=13,
      PS_Pump=14,
      ROH=17,
      PV=18,
      WindOn=19,
      WindOff=20,
      Curt=15,
      Import=16,
      relativepath="electricity/UnitCommitmentSchedules/UnitCommitmentSchedule_3600s_smoothed_REF35.txt",
      use_absolute_path=false),
    reserveAllocation(relativepath="electricity/UnitCommitmentSchedules/ReservePowerCommitmentSchedule_3600s_REF35.txt", use_absolute_path=false),
    unit_blocked=cat(
        1,
        fill(false, simCenter.generationPark.nDispPlants - 2),
        {true,true})) annotation (Placement(transformation(extent={{-188,100},{-168,120}})));
  Modelica.Blocks.Sources.RealExpression P_residual_pred_1h(y=-sum(UC.prediction.y[simCenter.generationPark.isMOD]))
                                                                                          annotation (Placement(transformation(extent={{-224,90},{-204,110}})));
  TransiEnt.Grid.Electrical.EconomicDispatch.MeritOrderDispatcher mod(
    ntime=discretizePrediction.ntime,
    samplePeriod=discretizePrediction.samplePeriod,
    useVarLimits=true,
    P_init(displayUnit="W") = P_init_set.k[simCenter.generationPark.isMOD],
    nVarLimits=size(simCenter.generationPark.isCHP, 1),
    iVarLimits=simCenter.generationPark.isCHP,
    startTime=60,
    P_max_var={Tiefstack_HardCoal.pQDiagram.P_max,HKW_Wedel.pQDiagram.P_max},
    P_min_var={Tiefstack_HardCoal.pQDiagram.P_min,HKW_Wedel.pQDiagram.P_min}) annotation (Placement(transformation(extent={{-166,58},{-142,84}})));
  TransiEnt.Basics.Tables.ElectricGrid.ElectricityDemand_HH_900s_2012 P_Load(startTime=t_start_set.k) annotation (Placement(transformation(extent={{286,76},{266,96}})));
  Modelica.Blocks.Sources.RealExpression P_load_is(y=Demand.epp.P) "Freqeuency dependent load"
                                                                          annotation (Placement(transformation(extent={{296,48},{276,68}})));
  TransiEnt.Basics.Tables.GenericDataTable normalizedWindPredictionError(
    relativepath="electricity/NormalisedWindPredictionError_900s.txt",
    constantfactor=1,
    startTime=t_start_set.k) annotation (Placement(transformation(extent={{-222,208},{-202,228}})));
  Modelica.Blocks.Sources.RealExpression e_wind_prediction_on(y=(normalizedWindPredictionError.y1 + 0.11/100)*simCenter.generationPark.P_el_n_WindOn) annotation (Placement(transformation(extent={{-156,202},{-136,222}})));
  Modelica.Blocks.Sources.RealExpression e_wind_prediction_off(y=(normalizedWindPredictionError2.y1 + 0.11/100)*simCenter.generationPark.P_el_n_WindOff) annotation (Placement(transformation(extent={{-154,186},{-134,206}})));
  TransiEnt.Basics.Tables.GenericDataTable normalizedWindPredictionError2(
    constantfactor=1,
    relativepath="electricity/NormalisedWindPredictionError2_900s.txt",
    startTime=t_start_set.k) annotation (Placement(transformation(extent={{-192,208},{-172,228}})));
  TransiEnt.Basics.Tables.GenericDataTable normalizedPVPredictionError(
    relativepath="electricity/NormalisedWindPredictionError_900s.txt",
    constantfactor=1,
    startTime=t_start_set.k) annotation (Placement(transformation(extent={{-222,176},{-202,196}})));
  Modelica.Blocks.Sources.RealExpression e_pv_prediction(y=normalizedPVPredictionError.y1*simCenter.generationPark.P_el_n_PV)                            annotation (Placement(transformation(extent={{-154,168},{-134,188}})));
  TransiEnt.Basics.Blocks.Sources.ConstantVectorSource P_init_set(nout=simCenter.generationPark.nPlants, k={0.00,184844600.00,0.00,264596300.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,65349610.00,67121080.00,-0.00,-0.00,0.00,45750000.00,0.00,436034500.00,176187200.00}) annotation (Placement(transformation(extent={{-284,160},{-264,180}})));
  Modelica.Blocks.Sources.RealExpression P_set_Offshore(y=P_wind_off_is.y1 + e_wind_prediction_off.y)
                                                                                                    annotation (Placement(transformation(extent={{-106,214},{-86,234}})));
  TransiEnt.Producer.Electrical.Wind.WindProfiles.WindProfileLoader P_wind_off_is(
    P_el_n=simCenter.generationPark.P_el_n_WindOff,
    change_of_sign=true,
    REProfile=TransiEnt.Producer.Electrical.Wind.WindProfiles.WindData.Wind2015_TenneT_Offshore_900s,
    startTime=t_start_set.k) annotation (Placement(transformation(extent={{-72,222},{-54,236}})));
  Modelica.Blocks.Sources.RealExpression P_set_Onshore(y=P_wind_on_is.y1 + e_wind_prediction_on.y)                   annotation (Placement(transformation(extent={{-48,212},{-28,232}})));
  TransiEnt.Producer.Electrical.Wind.WindProfiles.WindProfileLoader P_wind_on_is(
    REProfile=TransiEnt.Producer.Electrical.Wind.WindProfiles.WindData.Wind2015_TenneT_Onshore_900s,
    P_el_n=simCenter.generationPark.P_el_n_WindOn,
    change_of_sign=true,
    startTime=t_start_set.k) annotation (Placement(transformation(extent={{-18,224},{-2,238}})));
  Modelica.Blocks.Sources.RealExpression P_set_PV(y=P_PV_is.y1 + e_pv_prediction.y)
                                                                                   annotation (Placement(transformation(extent={{12,212},{32,232}})));
  TransiEnt.Producer.Electrical.Photovoltaics.PVProfiles.SolarProfileLoader P_PV_is(
    REProfile=TransiEnt.Producer.Electrical.Photovoltaics.PVProfiles.SolarData.Solar2015_Gesamt_900s,
    P_el_n=simCenter.generationPark.P_el_n_PV,
    change_of_sign=true,
    startTime=t_start_set.k) annotation (Placement(transformation(extent={{44,224},{58,236}})));
  Modelica.Blocks.Sources.RealExpression P_set_ROH(y=UC.schedule.y[UC.schedule.ROH])  annotation (Placement(transformation(extent={{72,212},{92,232}})));
  TransiEnt.Producer.Combined.LargeScaleCHP.CHP GUDTS(
    isSecondaryControlActive=true,
    P_el_n=simCenter.generationPark.P_el_n_GUDTS,
    P_el_init=UC.P_init[UC.schedule.GUDTS],
    PQCharacteristics=TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_CCPGeneric(k_Q_flow=1/GUDTS.Q_flow_n_CHP, k_P_el=GUDTS.P_el_n),
    Q_flow_n_CHP=180e6) "Combined cycle plant Tiefstack" annotation (Placement(transformation(extent={{197,-168},{222,-141}})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_pTxi massflow_Tm_flow6(variable_p=true) annotation (Placement(transformation(
        extent={{-4,-3},{4,3}},
        rotation=180,
        origin={242,-158})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow
                                                        massflow_Tm_flow5(m_flow_const=1000, h_const=4.2e3*60)
                                                                          annotation (Placement(transformation(
        extent={{-4,-3},{4,3}},
        rotation=90,
        origin={238,-172})));
  Modelica.Blocks.Sources.RealExpression Q_flow_set_WT1(y=0)                                     annotation (Placement(transformation(
        extent={{7.5,-6},{-7.5,6}},
        rotation=0,
        origin={226.5,-138})));
  TransiEnt.Producer.Heat.Gas2Heat.TwoFuelBoiler twoFuelBoiler(redeclare TransiEnt.Producer.Heat.Gas2Heat.SimpleBoiler boiler2(typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.NaturalGas, Q_flow_n=160e6 + 160e6), redeclare TransiEnt.Producer.Heat.Gas2Heat.SimpleBoiler boiler1(
      Q_flow_n=100e6,
      redeclare model BoilerCostModel = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.GarbageBoiler,
      typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.Garbage)) annotation (Placement(transformation(extent={{122,-164},{106,-150}})));
  TransiEnt.Producer.Heat.Gas2Heat.SimpleBoiler wuWSpaldingStr(
    Q_flow_n=100e6,
    typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.Garbage,
    redeclare model BoilerCostModel = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.GarbageBoiler) annotation (Placement(transformation(extent={{102,-222},{82,-202}})));
  Modelica.Blocks.Sources.RealExpression p_set_WT2(y=12e5) annotation (Placement(transformation(
        extent={{7.5,-6},{-7.5,6}},
        rotation=0,
        origin={268.5,-160})));
  TransiEnt.Components.Visualization.InfoBoxLargeCHP infoBoxLargeCHP4 annotation (Placement(transformation(extent={{225,-208},{207,-188}})));
  TransiEnt.Components.Visualization.InfoBoxLargeCHP infoBoxLargeCHP5 annotation (Placement(transformation(extent={{75,-236},{57,-216}})));
equation

  connect(temperatureHH_900s_01012012_0000_31122012_2345_1.y1,
    heatingLoadCharline.T_amb) annotation (Line(
      points={{-245,-180},{-238,-180},{-238,-181.3},{-232.7,-181.3}},
      color={0,0,127}));
  connect(supplyandReturnTemperature.T_amb, temperatureHH_900s_01012012_0000_31122012_2345_1.value) annotation (Line(
      points={{-230,-162},{-238,-162},{-238,-180},{-247.2,-180}},
      color={95,95,95},
      pattern=LinePattern.Dash));
  connect(temperatureHH_900s_01012012_0000_31122012_2345_1.value, dHNControl.T_ambient) annotation (Line(
      points={{-247.2,-180},{-236,-180},{-236,-210},{-235.667,-210}},
      color={95,95,95},
      pattern=LinePattern.Dash));
  connect(heatingLoadCharline.Q_flow, dHNControl.Q_dot_DH_Targ) annotation (Line(
      points={{-217.3,-182},{-216,-182},{-216,-192},{-222,-192},{-222,-194},{-221.733,-194},{-221.733,-196.8}},
      color={95,95,95},
      pattern=LinePattern.Dash));
  connect(HW_HafenCity.outlet, DistrictHeatingGrid.fluidPortCenter) annotation (Line(
      points={{20,-201},{20,-196},{56,-196},{56,-164},{56,-127.1},{55.9,-127.1}},
      color={175,0,0},
      thickness=0.5));
  connect(HW_HafenCity.gasIn, boundaryRealGas_pTxi.gasPort) annotation (Line(
      points={{9.22,-212},{10,-212},{10,-224}},
      color={255,255,0},
      thickness=0.75));
  connect(HW_HafenCity.inlet, massflow_Tm_flow1.fluidPortOut) annotation (Line(
      points={{-1.78,-201},{-8,-201},{-8,-201}},
      color={175,0,0},
      thickness=0.5));
  connect(T_return2.y, massflow_Tm_flow2.T) annotation (Line(points={{151,-187.5},{149,-187.5},{149,-182.8},{147,-182.8}},
                                                                                                    color={0,0,127}));
  connect(massflow_Tm_flow2.fluidPortOut, Tiefstack_HardCoal.inlet) annotation (Line(
      points={{147,-174},{147,-166.08},{145.74,-166.08},{145.74,-161.85}},
      color={175,0,0},
      thickness=0.5));
  connect(m_flow_return2.y, massflow_Tm_flow2.m_flow) annotation (Line(points={{144,-187.5},{144,-186},{145,-186},{145.86,-186},{145.86,-182.8},{145.2,-182.8}},
                                                                                                    color={0,0,127}));
  connect(HW_HafenCity.eye, infoBoxLargeCHP2.eye) annotation (Line(points={{21.1,-210.9},{24,-210.9},{24,-218.364},{25.9,-218.364}},
                                                                                                    color={28,108,200}));

  connect(Tiefstack_HardCoal.eye, infoBoxLargeCHP3.eye) annotation (Line(points={{144.7,-167.917},{137.5,-167.917},{137.5,-186.364},{134.1,-186.364}},
                                                                                                    color={28,108,200}));

  //General annotations

  connect(Tiefstack_HardCoal.Q_flow_set, Q_flow_set_WT.y) annotation (Line(points={{154.19,-146.033},{153.985,-146.033},{153.985,-138},{152,-138},{152,-136.9}},
                                                                                                    color={0,0,127}));
  connect(HW_HafenCity.Q_flow_set, Q_flow_set_Hafen.y) annotation (Line(points={{9,-190},{9,-187},{-2.1,-187},{-2.1,-185}},
                                                                                                        color={0,0,127}));
  connect(UCTE.epp,P_12. epp_OUT) annotation (Line(
      points={{261,-43},{261,-43.5},{255.13,-43.5}},
      color={0,135,135},
      thickness=0.5));
  connect(P_set_BM.y,Biomass. P_el_set) annotation (Line(points={{95,126},{100,126},{100,108.81}},
                                                                                              color={0,0,127}));
  connect(P_set_BCG.y,BrownCoal. P_el_set) annotation (Line(points={{-87,126},{-78,126},{-78,108.81}}, color={0,0,127}));
  connect(P_set_OIL.y,OIL. P_el_set) annotation (Line(points={{-29,126},{-18,126},{-18,108.81}}, color={0,0,127}));
  connect(P_set_GAR.y,GAR. P_el_set) annotation (Line(points={{31,126},{42,126},{42,108.81}}, color={0,0,127}));
  connect(P_set_SB_CCP.y,CCP. P_SB_set) annotation (Line(points={{-177,6},{-166.8,6},{-166.8,-1.09}},      color={0,0,127}));
  connect(P_set_CCP.y,CCP. P_el_set) annotation (Line(points={{-155,18},{-152,18},{-152,16},{-152,0.81}},      color={0,0,127}));
  connect(P_set_GT2.y,Gasturbine2. P_el_set) annotation (Line(points={{-3,12},{-6,12},{-6,-1.19}},      color={0,0,127}));
  connect(WindOffshorePlant.epp,P_RE_curtailement. epp_in) annotation (Line(
      points={{-57,209.3},{-44,209.3},{-44,206},{-44,160},{140,160},{140,196},{151,196}},
      color={0,135,135},
      thickness=0.5));
  connect(WindOnshorePlant.epp,P_RE_curtailement. epp_in) annotation (Line(
      points={{3,209.3},{6,209.3},{6,206},{18,206},{18,160},{140,160},{140,196},{151,196}},
      color={0,135,135},
      thickness=0.5));
  connect(PVPlant.epp,P_RE_curtailement. epp_in) annotation (Line(
      points={{63,209.3},{74,209.3},{74,206},{74,160},{140,160},{140,196},{151,196}},
      color={0,135,135},
      thickness=0.5));
  connect(RunOfWaterPlant.epp,P_RE_curtailement. epp_in) annotation (Line(
      points={{123,209.3},{140,209.3},{140,204},{140,196},{151,196}},
      color={0,135,135},
      thickness=0.5));
  connect(P_RE_curtailement.epp_out,Demand. epp) annotation (Line(
      points={{190.6,196},{212,196},{212,192},{212,52},{231.4,52}},
      color={0,135,135},
      thickness=0.5));
  connect(BrownCoal.epp,Demand. epp) annotation (Line(
      points={{-57,103.3},{-46,103.3},{-46,52},{231.4,52}},
      color={0,135,135},
      thickness=0.5));
  connect(OIL.epp,Demand. epp) annotation (Line(
      points={{3,103.3},{12,103.3},{12,52},{231.4,52}},
      color={0,135,135},
      thickness=0.5));
  connect(GAR.epp,Demand. epp) annotation (Line(
      points={{63,103.3},{74,103.3},{74,52},{231.4,52}},
      color={0,135,135},
      thickness=0.5));
  connect(Biomass.epp,Demand. epp) annotation (Line(
      points={{121,103.3},{128,103.3},{128,52},{231.4,52}},
      color={0,135,135},
      thickness=0.5));
  connect(Gasturbine2.epp,Demand. epp) annotation (Line(
      points={{15,-6.7},{32,-6.7},{32,52},{231.4,52}},
      color={0,135,135},
      thickness=0.5));
  connect(PumpedStorage.epp,Demand. epp) annotation (Line(
      points={{177,-6.7},{177,-10},{212,-10},{212,52},{231.4,52}},
      color={0,135,135},
      thickness=0.5));
  connect(P_12.epp_IN,PumpedStorage. epp) annotation (Line(
      points={{228.16,-43.5},{218,-43.5},{218,-10},{177,-10},{177,-6.7}},
      color={0,135,135},
      thickness=0.5));
  connect(P_set_SB_PS.y,PumpedStorage. P_SB_set) annotation (Line(points={{133,2},{136,2},{141.2,2},{141.2,-3.09}},
                                                                                                    color={0,0,127}));
  connect(P_set_PS.y,PumpedStorage. P_el_set) annotation (Line(points={{155,16},{155,16},{156,16},{156,-1.19}},
                                                                                                  color={0,0,127}));
  connect(P_tieline_set.y,aGC. P_tie_set) annotation (Line(points={{-171,-128},{-171,-128},{-181.02,-128},{-181.02,-119}},
                                                                                                    color={0,0,127}));
  connect(P_tieline_is.y,aGC. P_tie_is) annotation (Line(points={{-201,-128},{-201,-128},{-196.6,-128},{-196.6,-119}},
                                                                                                    color={0,0,127}));
  connect(P_set_SB_BCG.y,BrownCoal. P_SB_set) annotation (Line(points={{-95,112},{-94,112},{-94,106.91},{-92.8,106.91}}, color={0,0,127}));
  connect(P_set_SB_OIL.y,OIL. P_SB_set) annotation (Line(points={{-39,112},{-34,112},{-34,106.91},{-32.8,106.91}},
                                                                                                    color={0,0,127}));
  connect(P_set_SB_GAR.y,GAR. P_SB_set) annotation (Line(points={{21,112},{27.2,112},{27.2,106.91}}, color={0,0,127}));
  connect(P_set_SB_BM.y,Biomass. P_SB_set) annotation (Line(points={{79,112},{82,112},{82,106.91},{85.2,106.91}},
                                                                                                    color={0,0,127}));
  connect(P_sec_pos.y,aGC. P_SB_max_pos) annotation (Line(points={{-217,-92},{-207.24,-92},{-207.24,-93.1}},    color={0,0,127}));
  connect(P_sec_neg.y,aGC. P_SB_max_neg) annotation (Line(points={{-217,-110},{-212,-110},{-212,-107.9},{-207.24,-107.9}}, color={0,0,127}));
  connect(P_set_BC.y,BlackCoal. P_el_set) annotation (Line(points={{167,128},{170,128},{170,110.81}},
                                                                                                   color={0,0,127}));
  connect(P_set_SB_BC.y,BlackCoal. P_SB_set) annotation (Line(points={{149,114},{149,114},{155.2,114},{155.2,108.91}}, color={0,0,127}));
  connect(BlackCoal.epp,Demand. epp) annotation (Line(
      points={{191,105.3},{202,105.3},{202,52},{231.4,52}},
      color={0,135,135},
      thickness=0.5));
  connect(P_set_SB_GT.y,Gasturbine2. P_SB_set) annotation (Line(points={{-19,10},{-12,10},{-12,2},{-20,2},{-20,-3.09},{-20.8,-3.09}},         color={0,0,127}));
  connect(P_set_GT3.y,Gasturbine3. P_el_set) annotation (Line(points={{73,14},{70,14},{70,0.81}},     color={0,0,127}));
  connect(P_set_SB_GT1.y,Gasturbine3. P_SB_set) annotation (Line(points={{57,12},{64,12},{64,4},{56,4},{56,-1.09},{55.2,-1.09}},         color={0,0,127}));
  connect(Gasturbine3.epp,Demand. epp) annotation (Line(
      points={{91,-4.7},{96,-4.7},{96,-8},{108,-8},{108,52},{231.4,52}},
      color={0,135,135},
      thickness=0.5));
  connect(CCP.epp,Demand. epp) annotation (Line(
      points={{-131,-4.7},{-128,-4.7},{-128,-6},{-122,-6},{-122,52},{231.4,52}},
      color={0,135,135},
      thickness=0.5));
  connect(P_set_GT1.y,Gasturbine1. P_el_set) annotation (Line(points={{-79,12},{-82,12},{-82,-1.19}},    color={0,0,127}));
  connect(P_set_SB_GT2.y,Gasturbine1. P_SB_set) annotation (Line(points={{-95,10},{-88,10},{-88,2},{-96,2},{-96,-3.09},{-96.8,-3.09}},            color={0,0,127}));
  connect(Gasturbine1.epp,Demand. epp) annotation (Line(
      points={{-61,-6.7},{-52,-6.7},{-52,-10},{-44,-10},{-44,52},{231.4,52}},
      color={0,135,135},
      thickness=0.5));
  connect(aGC.epp,Demand. epp) annotation (Line(
      points={{-189,-82},{-189,-72},{-44,-72},{-44,52},{231.4,52}},
      color={0,135,135},
      thickness=0.5));
  connect(Q_flow_set_WW1.y, HKW_Wedel.Q_flow_set) annotation (Line(points={{-71,-120.9},{-71,-140.333},{-71.3,-140.333}},
                                                                                                                      color={0,0,127}));
  connect(massflow_Tm_flow3.fluidPortOut, HKW_Wedel.inlet) annotation (Line(
      points={{-60,-158},{-60,-155.08},{-64.8,-155.08},{-64.8,-152.5}},
      color={175,0,0},
      thickness=0.5));
  connect(P_set_CHP_West.y, HKW_Wedel.P_set) annotation (Line(points={{-89,-124},{-86,-124},{-86,-126},{-81.1,-126},{-81.1,-140.333}},
                                                                                                                                     color={0,0,127}));
  connect(HKW_Wedel.epp, Demand.epp) annotation (Line(
      points={{-65.5,-145},{-44,-145},{-44,52},{231.4,52}},
      color={0,135,135},
      thickness=0.5));
  connect(Tiefstack_HardCoal.epp, Demand.epp) annotation (Line(
      points={{146.65,-152.1},{138,-152.1},{138,-90},{-44,-90},{-44,52},{231.4,52}},
      color={0,135,135},
      thickness=0.5));
  connect(P_set_CHP_East.y, Tiefstack_HardCoal.P_set) annotation (Line(points={{165,-108},{168,-108},{168,-110},{172,-110},{172,-118},{166.93,-118},{166.93,-146.033}},color={0,0,127}));
  connect(T_return3.y, massflow_Tm_flow1.T) annotation (Line(points={{-20.4,-200},{-20,-200},{-20,-201},{-16.8,-201}}, color={0,0,127}));
  connect(m_flow_return1.y, massflow_Tm_flow1.m_flow) annotation (Line(points={{-21.5,-207},{-18,-207},{-18,-202.8},{-16.8,-202.8}},
                                                                                                                                   color={0,0,127}));
  connect(massflow_Tm_flow4.T, T_return1.y) annotation (Line(points={{114.8,-212},{118,-212},{118,-206},{120.4,-206}},     color={0,0,127}));
  connect(massflow_Tm_flow4.m_flow, m_flow_return5.y) annotation (Line(points={{114.8,-213.8},{118,-213.8},{118,-215},{121.5,-215}},   color={0,0,127}));
  connect(PtH.inlet, HKW_Wedel.outlet) annotation (Line(
      points={{-43.8,-148},{-64.8,-148},{-64.8,-150.167}},
      color={175,0,0},
      thickness=0.5));
  connect(P_set_Pth.y, ptH_limiter.P_RE_curtail) annotation (Line(points={{-173,-168},{-167,-168}}, color={0,0,127}));
  connect(PtH.Q_flow_set, Q_flow_set_PtH.y) annotation (Line(points={{-34,-138},{-34,-133.5},{-31,-133.5},{-31,-130.9}},     color={0,0,127}));
  connect(P_set_Curt_after_P2H.y, P_RE_curtailement.u) annotation (Line(points={{153,216},{162,216},{162,226},{171,226},{171,211.58}}, color={0,0,127}));
  connect(PtH.epp, Demand.epp) annotation (Line(
      points={{-34,-158},{-44,-158},{-44,-94},{-44,52},{231.4,52}},
      color={0,135,135},
      thickness=0.5));
  connect(discretizePrediction.P_predictions,mod. u) annotation (Line(points={{-181,72},{-168.4,72},{-168.4,71}},
                                                                                                    color={0,0,127}));
  connect(H_lpa.y,discretizePrediction. P_is) annotation (Line(points={{-217,72},{-211.5,72},{-204,72}},
                                                                                                    color={0,0,127}));
  connect(UC.P_sec_pos[simCenter.generationPark.isMOD],mod. P_R_pos) annotation (Line(points={{-166.7,107.4},{-158.8,107.4},{-158.8,86.6}},
                                                                                                                                          color={0,0,127}));
  connect(UC.P_sec_neg[simCenter.generationPark.isMOD],mod. P_R_neg) annotation (Line(points={{-166.7,102.8},{-149.2,102.8},{-149.2,86.6}},
                                                                                                                                          color={0,0,127}));
  connect(P_residual_pred_1h.y,discretizePrediction. P_prediction) annotation (Line(points={{-203,100},{-192,100},{-192,84}},
                                                                                                                            color={0,0,127}));
  connect(UC.z[simCenter.generationPark.isMOD],mod. z) annotation (Line(points={{-166.7,114},{-138,114},{-138,50},{-154,50},{-154,55.4}},      color={255,0,255}));
  connect(P_residual_pred.y,H_lpa. P_load_pred) annotation (Line(points={{-241,94},{-228,94},{-228,84}},
                                                                                                       color={0,0,127}));
  connect(P_residual_is.y,H_lpa. P_load_is) annotation (Line(points={{-247,72},{-240,72}},   color={0,0,127}));
  connect(m_flow_return3.y, massflow_Tm_flow3.m_flow) annotation (Line(points={{-64,-171.5},{-64,-170},{-61.8,-170},{-61.8,-166.8}}, color={0,0,127}));
  connect(T_return5.y, massflow_Tm_flow3.T) annotation (Line(points={{-53,-171.5},{-53,-170},{-60,-170},{-60,-166.8}}, color={0,0,127}));
  connect(P_Load.y1, Demand.P_el_set) annotation (Line(points={{265,86},{251,86},{251,74.04}},    color={0,0,127}));
  connect(P_set_Offshore.y,WindOffshorePlant. P_el_set) annotation (Line(points={{-85,224},{-78,224},{-78,214.81}},    color={0,0,127}));
  connect(P_set_Onshore.y,WindOnshorePlant. P_el_set) annotation (Line(points={{-27,222},{-18,222},{-18,214.81}},    color={0,0,127}));
  connect(P_set_PV.y,PVPlant. P_el_set) annotation (Line(points={{33,222},{42,222},{42,214.81}},    color={0,0,127}));
  connect(P_set_ROH.y,RunOfWaterPlant. P_el_set) annotation (Line(points={{93,222},{93,222},{102,222},{102,214.81}},  color={0,0,127}));
  connect(GUDTS.inlet,massflow_Tm_flow5. steam_a) annotation (Line(
      points={{222.25,-160.575},{234,-160.575},{234,-168},{238,-168}},
      color={175,0,0},
      thickness=0.5));
  connect(P_set_SB_CHP_East1.y, GUDTS.P_SB_set) annotation (Line(points={{195,-130},{198.375,-130},{198.375,-146.738}}, color={0,0,127}));
  connect(GUDTS.P_set, P_set_WT1.y) annotation (Line(points={{201.875,-144.15},{201.875,-126},{216,-126},{216,-116},{211,-116}}, color={0,0,127}));
  connect(Q_flow_set_WT1.y, GUDTS.Q_flow_set) annotation (Line(points={{218.25,-138},{214.125,-138},{214.125,-144.15}}, color={0,0,127}));
  connect(GUDTS.epp, Demand.epp) annotation (Line(
      points={{221.375,-150.45},{240,-150.45},{240,-90},{-44,-90},{-44,52},{231.4,52}},
      color={0,135,135},
      thickness=0.5));
  connect(DistrictHeatingGrid.fluidPortWest, spiVo_Wedel.outlet) annotation (Line(
      points={{28.9,-121.9},{14.25,-121.9},{14.25,-148},{2,-148}},
      color={175,0,0},
      thickness=0.5));
  connect(spiVo_Wedel.inlet, PtH.outlet) annotation (Line(
      points={{-17.8,-148},{-24,-148}},
      color={175,0,0},
      thickness=0.5));
  connect(Q_flow_set_Spivo_Wedel.y, spiVo_Wedel.Q_flow_set) annotation (Line(points={{-8,-132.9},{-8,-135.45},{-8,-138}}, color={0,0,127}));
  connect(twoFuelBoiler.inlet, Tiefstack_HardCoal.outlet) annotation (Line(
      points={{121.84,-157},{133.92,-157},{133.92,-158.817},{145.74,-158.817}},
      color={175,0,0},
      thickness=0.5));
  connect(twoFuelBoiler.outlet, DistrictHeatingGrid.fluidPortEast) annotation (Line(
      points={{106,-157},{85,-157},{85,-128.9},{62.7,-128.9}},
      color={175,0,0},
      thickness=0.5));
  connect(Q_set_MVB.y, twoFuelBoiler.Q_flow_set_B1) annotation (Line(points={{122,-136.9},{120,-136.9},{120,-142},{118.64,-142},{118.64,-150.14}}, color={0,0,127}));
  connect(Q_set_Spivo_Tiefstack.y, twoFuelBoiler.Q_flow_set_B2) annotation (Line(points={{108,-136.9},{109.2,-136.9},{109.2,-150.14}}, color={0,0,127}));
  connect(wuWSpaldingStr.inlet, massflow_Tm_flow4.fluidPortOut) annotation (Line(
      points={{101.8,-212},{106,-212},{106,-212}},
      color={175,0,0},
      thickness=0.5));
  connect(Q_set_WUWSPS.y, wuWSpaldingStr.Q_flow_set) annotation (Line(points={{91.9,-197},{100,-197},{100,-202},{92,-202}}, color={0,0,127}));
  connect(wuWSpaldingStr.outlet, DistrictHeatingGrid.fluidPortWUWSPS) annotation (Line(
      points={{82,-212},{72,-212},{58.7,-212},{58.7,-125.3}},
      color={175,0,0},
      thickness=0.5));
  connect(ptH_limiter.Q_flow_set_demand, dHNControl.Q_flow_i[2]) annotation (Line(
      points={{-156,-156},{-180,-156},{-180,-203.04},{-202.733,-203.04}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(heatSchedulerEast.Q_flow_total, HeatFlowEastPlusWUWSPS.y) annotation (Line(points={{-168,-204},{-176,-204},{-176,-189.5},{-183.75,-189.5}}, color={0,0,127}));
  connect(HKW_Wedel.eye, infoBoxLargeCHP1.eye) annotation (Line(points={{-64,-157.167},{-50,-157.167},{-50,-180.364},{-37.1,-180.364}}, color={28,108,200}));
  connect(GUDTS.outlet, massflow_Tm_flow6.fluidPortIn) annotation (Line(
      points={{222.25,-157.425},{231.125,-157.425},{231.125,-158},{238,-158}},
      color={175,0,0},
      thickness=0.5));
  connect(massflow_Tm_flow6.p, p_set_WT2.y) annotation (Line(points={{246,-159.8},{254,-159.8},{254,-160},{260.25,-160}}, color={0,0,127}));
  connect(GUDTS.eye, infoBoxLargeCHP4.eye) annotation (Line(points={{223.25,-166.875},{224,-166.875},{224,-196.364},{224.1,-196.364}}, color={28,108,200}));
  connect(wuWSpaldingStr.eye, infoBoxLargeCHP5.eye) annotation (Line(points={{81,-221},{78,-221},{78,-224.364},{74.1,-224.364}}, color={28,108,200}));
   annotation (
    experiment(StopTime=86400, Interval=900),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-300,-260},{300,260}},
        initialScale=0.1), graphics={
        Rectangle(
          extent={{-116,246},{204,154}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash),
        Rectangle(
          extent={{-122,148},{204,60}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash),
        Rectangle(
          extent={{-212,40},{192,-50}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash),
        Rectangle(
          extent={{222,-18},{302,-72}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash),
        Text(
          extent={{220,-18},{276,-26}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash,
          textString="Surrounding grid"),
        Text(
          extent={{-118,148},{-46,136}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash,
          textString="Base Load Power Plants"),
        Text(
          extent={{-210,42},{-132,26}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash,
          textString="Mid- and Peakload Plants"),
        Text(
          extent={{-110,244},{-38,232}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash,
          textString="Fluctuating Renewables"),
        Rectangle(
          extent={{222,98},{298,22}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash),
        Text(
          extent={{202,96},{258,88}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash,
          textString="Load"),
        Text(
          extent={{-244,-58},{-176,-70}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash,
          textString="Control Power dispatch"),
        Rectangle(
          extent={{-246,-58},{-146,-138}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash),
        Text(
          extent={{-288,34},{-274,-120}},
          lineColor={175,175,175},
          horizontalAlignment=TextAlignment.Left,
          fontSize=5,
          textString="BK
WT
SKT
WW
GuDW
GT
OIL
GAR
BM
PS_T

PS_P
Curtailment
Import
ROW
PV
Onshore
Offshore
"),     Text(
          extent={{-298,38},{-284,-116}},
          lineColor={175,175,175},
          horizontalAlignment=TextAlignment.Left,
          fontSize=5,
          textString="1
2
3
4
5
6
7
8
9
10

11
12
13
14
15
16
17"),   Text(
          extent={{-292,-154},{-222,-164}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash,
          textString="DHN Dispatch"),
        Rectangle(
          extent={{-286,-150},{-126,-236}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash),
        Text(
          extent={{-118,-82},{-48,-92}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash,
          textString="District Heating Network"),
        Rectangle(
          extent={{-122,-80},{252,-236}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash),
        Text(
          extent={{-268,132},{-200,120}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash,
          textString="Economic Dispatch"),
        Rectangle(
          extent={{-274,130},{-136,48}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash),
        Text(
          extent={{-230,240},{-174,232}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash,
          textString="Prediction Errors"),
        Rectangle(
          extent={{-230,242},{-126,164}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash)}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-300,-260},{300,260}},
        initialScale=0.1)),
    Documentation(info="<html>
<p>The district heating grid is modeled as a mass-flow sink, but can be replaced with more detailed models if required.</p>
</html>"),
    __Dymola_experimentSetupOutput(inputs=false, events=false),
    __Dymola_experimentFlags(
      Advanced(
        EvaluateAlsoTop=false,
        GenerateVariableDependencies=false,
        OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end SectorCouplingPtH;
