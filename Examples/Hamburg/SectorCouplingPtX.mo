within TransiEnt.Examples.Hamburg;
model SectorCouplingPtX "Coupled electric, district heating and gas grids for Hamburg with PtX 2035"
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

  //Scaling factors
  parameter Real f_Rei=0.43;
  parameter Real f_Lev=0.272;
  parameter Real f_Tor=0.298;

  //Electrolyzer
  parameter SI.ActivePower P_el_n=140e6 annotation(Evaluate=false);
  parameter SI.ActivePower P_el_min=0.04*P_el_n annotation(Evaluate=false);
  parameter SI.ActivePower P_el_overload=1.0*P_el_n annotation(Evaluate=false);
  parameter SI.ActivePower P_el_max=1.68*P_el_n annotation(Evaluate=false);
  parameter SI.Efficiency eta_n=0.75 annotation(Evaluate=false);
  parameter SI.Time t_overload=3600 annotation(Evaluate=false);
  parameter Real coolingToHeatingRatio=1 annotation(Evaluate=false);
  parameter SI.Pressure p_ely=simCenter.p_amb_const+35e5 annotation(Evaluate=false);

  //FeedInControl
  parameter Real phi_H2max=0.1 annotation(Evaluate=false);
  parameter Real k_feedIn=1e6 annotation(Evaluate=false);
  parameter SI.Volume V_mixH2=0.1 annotation(Evaluate=false);
  parameter SI.Volume V_mixNG=1 annotation(Evaluate=false);

  //Storage
  parameter SI.Pressure p_max=17500000 annotation(Evaluate=false);
  parameter SI.Volume V_geo=10000 annotation(Evaluate=false);
  parameter SI.Pressure p_start=11000000 annotation(Evaluate=false);
  parameter SI.Temperature T_start=52.3+273.15 annotation(Evaluate=false);
  parameter SI.Pressure p_minLow=58e5 annotation(Evaluate=false);
  parameter SI.Pressure p_minHigh=60e5 annotation(Evaluate=false);

  //Consumers
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.P "Type of controller";
  parameter Real k_consumer=1e6 "Gain for controller in maximum feed in control";
  parameter Real Ti=0.04 "Integrator time constant for controller in maximum feed in control";
  parameter Real Td=0.01 "Derivative time constant for controller in maximum feed in control";

  //Pipe Network
  parameter Real Nper10km=2 "Number of discrete volumes in 10 km pipe length";
  parameter Integer massBalance=1 "Mass balance and species balance fomulation" annotation(Dialog(group="Fundamental Definitions"),choices(choice=1 "ClaRa formulation", choice=2 "TransiEnt formulation 1a", choice=3 "TransiEnt formulation 1b"));

  //___________________
  //Components
  //___________________
  TransiEnt.Grid.Gas.GasGridHamburg gasGridHamburg(
    phi_H2max=phi_H2max,
    Nper10km=Nper10km,
    massBalance=massBalance) annotation (Placement(transformation(extent={{-124,-522},{282,-274}})));

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
  TransiEnt.Grid.Heat.HeatGridTopology.GridConfigurations.DHG_Topology_HH_1port_4sites_MassFlowSink DistrictHeatingGrid annotation (Placement(transformation(extent={{5,-185},{99,-111}})));
  Modelica.Blocks.Sources.RealExpression T_return3(y=supplyandReturnTemperature.T_set[2]) annotation (Placement(transformation(
        extent={{-6,-5},{6,5}},
        rotation=180,
        origin={51,-202})));
  Modelica.Blocks.Sources.RealExpression T_return2(y=supplyandReturnTemperature.T_set[2]) annotation (Placement(transformation(
        extent={{-5,-6},{5,6}},
        rotation=90,
        origin={151,-193})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_Txim_flow massflow_Tm_flow1(variable_m_flow=true, variable_T=true) annotation (Placement(transformation(
        extent={{-4,-3},{4,3}},
        rotation=180,
        origin={32,-206})));
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
    P_el_init=UC.P_init[UC.schedule.WT]) annotation (Placement(transformation(extent={{174,-169},{148,-143}})));

  TransiEnt.Grid.Heat.HeatGridControl.HeatFlowDivision heatSchedulerEast(HeatFlowCL=TransiEnt.Grid.Heat.HeatGridControl.Base.DHGHeatFlowDivisionCharacteristicLines.SampleHeatFlowCharacteristicLines4Units()) annotation (Placement(transformation(extent={{-168,-208},{-148,-188}})));
  Modelica.Blocks.Sources.RealExpression m_flow_return1(y=-1*dHNControl.m_flow_i[3])    annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={49,-209})));
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
        origin={-12,-189})));
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
  inner TransiEnt.SimCenter  simCenter(
    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3,
    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1,
                          thres=1e-9,
    Td=450,
    redeclare TransiEnt.Examples.Hamburg.ExampleGenerationPark2035 generationPark,
    p_amb=101343,
    T_amb=283.15,
    tableInterpolationSmoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    isExpertmode=true,
    useThresh=false,
    useHomotopy=false)
    annotation (Placement(transformation(extent={{-290,238},{-270,258}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-268,238},{-248,258}})));
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
    isSecondaryControlActive=true,
    P_init=UC.P_init[UC.schedule.GAR])
                                   "Garbage" annotation (Placement(transformation(extent={{25,71},{65,109}})));
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
    isSecondaryControlActive=true,
    isExternalSecondaryController=true,
    t_startup=200,
    P_init=UC.P_init[UC.schedule.BM])   annotation (Placement(transformation(extent={{83,71},{123,109}})));
  TransiEnt.Producer.Electrical.Others.PumpedStoragePlant PumpedStorage(
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PumpedStorage,
    t_startup=60,
    P_init=-(UC.P_init[UC.schedule.PS] + UC.P_init[UC.schedule.PS_Pump])) annotation (Placement(transformation(extent={{139,-39},{179,-1}})));
  TransiEnt.Producer.Electrical.Others.IdealContinuousHydropowerPlant RunOfWaterPlant(P_el_n=simCenter.generationPark.P_el_n_ROH, redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.RunOffHydro) annotation (Placement(transformation(extent={{85,177},{125,215}})));
  Modelica.Blocks.Sources.RealExpression P_set_BM(y=UC.schedule.y[UC.schedule.BM])
                                                                             annotation (Placement(transformation(extent={{74,116},{94,136}})));
  Modelica.Blocks.Sources.RealExpression P_set_Offshore(y=UC.schedule.y[UC.schedule.WindOff] + e_wind_prediction_off.y)
                                                                                                    annotation (Placement(transformation(extent={{-106,212},{-86,232}})));
  Modelica.Blocks.Sources.RealExpression P_set_Onshore(y=UC.schedule.y[UC.schedule.WindOn] + e_wind_prediction_on.y)
                                                                                                 annotation (Placement(transformation(extent={{-48,210},{-28,230}})));
  Modelica.Blocks.Sources.RealExpression P_set_PV(y=UC.schedule.y[UC.schedule.PV] + e_pv_prediction.y)
                                                                                   annotation (Placement(transformation(extent={{14,210},{34,230}})));
  Modelica.Blocks.Sources.RealExpression P_set_ROH(y=UC.schedule.y[UC.schedule.ROH])  annotation (Placement(transformation(extent={{74,210},{94,230}})));
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
  Modelica.Blocks.Sources.RealExpression P_load_is(y=-sum(UC.schedule.y)) annotation (Placement(transformation(extent={{280,76},{260,96}})));
  TransiEnt.Basics.Blocks.Sources.RealVectorExpression P_sec_pos(nout=simCenter.generationPark.nDispPlants, y_set=UC.P_sec_pos) annotation (Placement(transformation(extent={{-238,-102},{-218,-82}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_BCG(y=aGC.P_sec_set[UC.schedule.BCG]) annotation (Placement(transformation(extent={{-116,102},{-96,122}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_OIL(y=aGC.P_sec_set[UC.schedule.OIL]) annotation (Placement(transformation(extent={{-60,102},{-40,122}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_GAR(y=aGC.P_sec_set[UC.schedule.GAR]) annotation (Placement(transformation(extent={{0,102},{20,122}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_BM(y=aGC.P_sec_set[UC.schedule.BM]) annotation (Placement(transformation(extent={{58,102},{78,122}})));
  TransiEnt.Basics.Blocks.Sources.RealVectorExpression P_sec_neg(nout=simCenter.generationPark.nDispPlants, y_set=UC.P_sec_neg) annotation (Placement(transformation(extent={{-238,-120},{-218,-100}})));
  Modelica.Blocks.Sources.RealExpression P_set_WT1(
                                                  y=-mod.y[UC.schedule.GUDTS]) annotation (Placement(transformation(extent={{176,-124},{196,-104}})));
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
  Modelica.Blocks.Sources.RealExpression P_load_pred(y=-sum(UC.schedule.y)) annotation (Placement(transformation(extent={{292,18},{272,38}})));
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
  TransiEnt.Grid.Heat.HeatGridControl.Limit_Q_flow_set spiVoWedel(Q_flow_set_max=HKW_Wedel.Q_flow_n_CHP) annotation (Placement(transformation(extent={{-16,-126},{4,-118}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_set_Spivo_Wedel(y=-max(dHNControl.Q_flow_i[2] - HKW_Wedel.Q_flow_n_CHP, 0))
                                                                                                 annotation (Placement(transformation(
        extent={{-9,-5},{9,5}},
        rotation=270,
        origin={-6,-105})));
  TransiEnt.Producer.Heat.Power2Heat.ElectricBoiler PtH(Q_flow_n=HKW_Wedel.Q_flow_n_CHP) annotation (Placement(transformation(extent={{-42,-158},{-22,-138}})));
  TransiEnt.Producer.Heat.Power2Heat.Controller.PtH_limiter ptH_limiter(Q_flow_PtH_max=PtH.Q_flow_n) annotation (Placement(transformation(extent={{-166,-178},{-146,-158}})));
  Modelica.Blocks.Sources.RealExpression P_set_Pth(y=min(P_set_Curt.y, PtH.Q_flow_n)) annotation (Placement(transformation(extent={{-194,-178},{-174,-158}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_set_PtH(y=-ptH_limiter.Q_flow_set_PtH)              annotation (Placement(transformation(
        extent={{-9,-5},{9,5}},
        rotation=270,
        origin={-31,-121})));
  Modelica.Blocks.Sources.RealExpression P_set_Curt_after_P2X(y=P_set_Curt.y - PtH.epp.P - FeedIn_Tornesch.epp.P - FeedIn_Leversen.epp.P - FeedIn_Reitbrook.epp.P)
                                                                                                 annotation (Placement(transformation(extent={{132,206},{152,226}})));
  inner TransiEnt.Grid.Gas.StatCycleGasGridHamburg Init(
    m_flow_feedIn_Tornesch=0.01,
    m_flow_feedIn_Leversen=0.01,
    m_flow_feedIn_Reitbrook=0.01) annotation (Placement(transformation(extent={{194,-308},{237,-277}})));
  Modelica.Blocks.Sources.RealExpression P_set_Electrolysis(y=min(P_set_Curt.y - PtH.epp.P, P_el_max)) annotation (Placement(transformation(extent={{-276,-450},{-246,-426}})));
  Modelica.Blocks.Sources.Constant t_start_set(k=0) annotation (Placement(transformation(extent={{-280,198},{-260,218}})));
  TransiEnt.Basics.Blocks.Sources.ConstantVectorSource P_init_set(nout=simCenter.generationPark.nPlants, k={0.00,184844600.00,0.00,264596300.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,146233700.00,116736400.00,-0.00,-0.00,0.00,53869060.00,0.00,253228800.00,220374400.00}) annotation (Placement(transformation(extent={{-280,162},{-260,182}})));
  Modelica.Blocks.Noise.NormalNoise e_pv_prediction(
    samplePeriod=900,
    mu=0,
    sigma=0*0.85/100*simCenter.generationPark.P_el_n_PV)
                                                       annotation (Placement(transformation(extent={{-200,170},{-180,190}})));
  inner Modelica.Blocks.Noise.GlobalSeed globalSeed annotation (Placement(transformation(extent={{-228,174},{-208,194}})));
  TransiEnt.Basics.Tables.GenericDataTable normalizedWindPredictionError(relativepath="electricity/NormalisedWindPredictionError_900s.txt", constantfactor=1) annotation (Placement(transformation(extent={{-230,206},{-210,226}})));
  Modelica.Blocks.Sources.RealExpression e_wind_prediction_on(y=(normalizedWindPredictionError.y1 + 0.11/100)*simCenter.generationPark.P_el_n_WindOn) annotation (Placement(transformation(extent={{-164,200},{-144,220}})));
  Modelica.Blocks.Sources.RealExpression e_wind_prediction_off(y=(normalizedWindPredictionError2.y1 + 0.11/100)*simCenter.generationPark.P_el_n_WindOff) annotation (Placement(transformation(extent={{-162,184},{-142,204}})));
  TransiEnt.Basics.Tables.GenericDataTable normalizedWindPredictionError2(constantfactor=1, relativepath="electricity/NormalisedWindPredictionError2_900s.txt") annotation (Placement(transformation(extent={{-200,206},{-180,226}})));
  Modelica.Blocks.Sources.RealExpression P_residual_is(y=Demand.epp.P + P_RE_curtailement.epp_out.P + PumpedStorage.epp.P + Biomass.epp.P + P_tieline_set.y)
                                                                                                    annotation (Placement(transformation(extent={{-268,76},{-248,96}})));
  Modelica.Blocks.Sources.RealExpression P_residual_pred(y=-sum(UC.schedule.y[simCenter.generationPark.isMOD])) "All disponible plants (Conventional apart from Pumped Storage and CHP)"
                                                                                     annotation (Placement(transformation(extent={{-262,98},{-242,118}})));
  TransiEnt.Grid.Electrical.EconomicDispatch.DiscretizePrediction discretizePrediction(t_shift=0, samplePeriod=900) annotation (Placement(transformation(extent={{-202,76},{-182,96}})));
  TransiEnt.Grid.Electrical.EconomicDispatch.LoadPredictionAdaption H_lpa(P_lpa_init=0) annotation (Placement(transformation(extent={{-238,76},{-218,96}})));
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
        {true,true})) annotation (Placement(transformation(extent={{-188,114},{-168,134}})));
  Modelica.Blocks.Sources.RealExpression P_residual_pred_1h(y=-sum(UC.prediction.y[simCenter.generationPark.isMOD]))
                                                                                          annotation (Placement(transformation(extent={{-224,104},{-204,124}})));
  TransiEnt.Grid.Electrical.EconomicDispatch.MeritOrderDispatcher mod(
    ntime=discretizePrediction.ntime,
    samplePeriod=discretizePrediction.samplePeriod,
    useVarLimits=true,
    P_init(displayUnit="W") = P_init_set.k[simCenter.generationPark.isMOD],
    nVarLimits=size(simCenter.generationPark.isCHP, 1),
    iVarLimits=simCenter.generationPark.isCHP,
    startTime=60,
    P_max_var={Tiefstack_HardCoal.pQDiagram.P_max,HKW_Wedel.pQDiagram.P_max},
    P_min_var={Tiefstack_HardCoal.pQDiagram.P_min,HKW_Wedel.pQDiagram.P_min}) annotation (Placement(transformation(extent={{-166,72},{-142,98}})));
  TransiEnt.Producer.Combined.LargeScaleCHP.CHP GUDTS(
    isSecondaryControlActive=true,
    P_el_n=simCenter.generationPark.P_el_n_GUDTS,
    P_el_init=UC.P_init[UC.schedule.GUDTS],
    PQCharacteristics=TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_CCPGeneric(k_Q_flow=1/GUDTS.Q_flow_n_CHP, k_P_el=GUDTS.P_el_n),
    Q_flow_n_CHP=180e6) "Combined cycle plant Tiefstack" annotation (Placement(transformation(extent={{199,-162},{224,-135}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_hxim_flow
                                                        massflow_Tm_flow5(m_flow_const=1000, h_const=4.2e3*60)
                                                                          annotation (Placement(transformation(
        extent={{-4,-3},{4,3}},
        rotation=90,
        origin={234,-162})));
  Modelica.Blocks.Sources.RealExpression Q_flow_set_WT1(y=0)                                     annotation (Placement(transformation(
        extent={{7.5,-6},{-7.5,6}},
        rotation=0,
        origin={226.5,-132})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_pTxi massflow_Tm_flow6(variable_p=true) annotation (Placement(transformation(
        extent={{-4,-3},{4,3}},
        rotation=180,
        origin={240,-152})));
  Modelica.Blocks.Sources.RealExpression p_set_WT2(y=12e5) annotation (Placement(transformation(
        extent={{7.5,-6},{-7.5,6}},
        rotation=0,
        origin={266.5,-154})));
  TransiEnt.Producer.Heat.Gas2Heat.SimpleBoiler spiVo_Wedel(typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.NaturalGas, Q_flow_n=250000000) annotation (Placement(transformation(extent={{-18,-158},{2,-138}})));
  TransiEnt.Components.Visualization.InfoBoxLargeCHP infoBoxLargeCHP4 annotation (Placement(transformation(extent={{4,-178},{22,-158}})));

  TransiEnt.Producer.Heat.Gas2Heat.TwoFuelBoiler twoFuelBoiler(redeclare TransiEnt.Producer.Heat.Gas2Heat.SimpleBoiler boiler2(typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.NaturalGas, Q_flow_n=160e6 + 160e6), redeclare TransiEnt.Producer.Heat.Gas2Heat.SimpleBoiler boiler1(
      Q_flow_n=100e6,
      redeclare model BoilerCostModel = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.GarbageBoiler,
      typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.Garbage)) annotation (Placement(transformation(extent={{122,-164},{106,-150}})));
  TransiEnt.Producer.Heat.Gas2Heat.SimpleBoiler wuWSpaldingStr(
    Q_flow_n=100e6,
    typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.Garbage,
    redeclare model BoilerCostModel = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.GarbageBoiler) annotation (Placement(transformation(extent={{102,-224},{82,-204}})));
  TransiEnt.Components.Visualization.InfoBoxLargeCHP infoBoxLargeCHP5 annotation (Placement(transformation(extent={{225,-196},{207,-176}})));

  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow Harburg(
    length(displayUnit="km") = 3770,
    diameter=0.235,
    Delta_p_nom=Init.Delta_p_nom_Harburg,
    xi_start=Init.Harburg.pipe.xi_in,
    p_nom=ones(Harburg.pipe.N_cv)*Init.Harburg.pipe.p_in,
    h_nom=ones(Harburg.pipe.N_cv)*Init.Harburg.pipe.h_in,
    p_start=linspace(
        Init.Harburg.pipe.p_in,
        Init.Harburg.pipe.p_out,
        Harburg.N_cv),
    h_start=ones(Harburg.pipe.N_cv)*Init.Harburg.pipe.h_in,
    m_flow_start=ones(Harburg.pipe.N_cv + 1)*Init.Harburg.pipe.m_flow,
    N_tubes=17,
    m_flow_nom=Init.m_flow_nom_Harburg,
    k=k_consumer,
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    N_cv=if integer(Nper10km*Harburg.length/10000) < 2 then 2 else integer(Nper10km*Harburg.length/10000),
    massBalance=massBalance) annotation (Placement(transformation(extent={{30,-461},{50,-441}})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow Altona(
    length(displayUnit="km") = 5150,
    diameter=0.235,
    Delta_p_nom=Init.Delta_p_nom_Altona,
    xi_start=Init.Altona.pipe.xi_in,
    p_nom=ones(Altona.pipe.N_cv)*Init.Altona.pipe.p_in,
    h_nom=ones(Altona.pipe.N_cv)*Init.Altona.pipe.h_in,
    p_start=linspace(
        Init.Altona.pipe.p_in,
        Init.Altona.pipe.p_out,
        Altona.N_cv),
    h_start=ones(Altona.pipe.N_cv)*Init.Altona.pipe.h_in,
    m_flow_start=ones(Altona.pipe.N_cv + 1)*Init.Altona.pipe.m_flow,
    N_tubes=18,
    m_flow_nom=Init.m_flow_nom_Altona,
    k=k_consumer,
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    N_cv=if integer(Nper10km*Altona.length/10000) < 2 then 2 else integer(Nper10km*Altona.length/10000),
    massBalance=massBalance) annotation (Placement(transformation(extent={{10,-409},{30,-389}})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow Eimsbuettel(
    length(displayUnit="km") = 2740,
    diameter=0.235,
    Delta_p_nom=Init.Delta_p_nom_Eimsbuettel,
    xi_start=Init.Eimsbuettel.pipe.xi_in,
    p_nom=ones(Eimsbuettel.pipe.N_cv)*Init.Eimsbuettel.pipe.p_in,
    h_nom=ones(Eimsbuettel.pipe.N_cv)*Init.Eimsbuettel.pipe.h_in,
    p_start=linspace(
        Init.Eimsbuettel.pipe.p_in,
        Init.Eimsbuettel.pipe.p_out,
        Eimsbuettel.N_cv),
    h_start=ones(Eimsbuettel.pipe.N_cv)*Init.Eimsbuettel.pipe.h_in,
    m_flow_start=ones(Eimsbuettel.pipe.N_cv + 1)*Init.Eimsbuettel.pipe.m_flow,
    N_tubes=12,
    m_flow_nom=Init.m_flow_nom_Eimsbuettel,
    k=k_consumer,
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    N_cv=if integer(Nper10km*Eimsbuettel.length/10000) < 2 then 2 else integer(Nper10km*Eimsbuettel.length/10000),
    massBalance=massBalance) annotation (Placement(transformation(extent={{26,-384},{46,-364}})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow HHNord(
    length(displayUnit="km") = 10560,
    diameter=0.235,
    Delta_p_nom=Init.Delta_p_nom_HHNord,
    xi_start=Init.HHNord.pipe.xi_in,
    p_nom=ones(HHNord.pipe.N_cv)*Init.HHNord.pipe.p_in,
    h_nom=ones(HHNord.pipe.N_cv)*Init.HHNord.pipe.h_in,
    p_start=linspace(
        Init.HHNord.pipe.p_in,
        Init.HHNord.pipe.p_out,
        HHNord.N_cv),
    h_start=ones(HHNord.pipe.N_cv)*Init.HHNord.pipe.h_in,
    m_flow_start=ones(HHNord.pipe.N_cv + 1)*Init.HHNord.pipe.m_flow,
    N_tubes=14,
    m_flow_nom=Init.m_flow_nom_HHNord,
    k=k_consumer,
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    N_cv=if integer(Nper10km*HHNord.length/10000) < 2 then 2 else integer(Nper10km*HHNord.length/10000),
    massBalance=massBalance) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={64,-310})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow Wandsbek(
    length(displayUnit="km") = 4700,
    diameter=0.235,
    Delta_p_nom=Init.Delta_p_nom_Wandsbek,
    xi_start=Init.Wandsbek.pipe.xi_in,
    p_nom=ones(Wandsbek.pipe.N_cv)*Init.Wandsbek.pipe.p_in,
    h_nom=ones(Wandsbek.pipe.N_cv)*Init.Wandsbek.pipe.h_in,
    p_start=linspace(
        Init.Wandsbek.pipe.p_in,
        Init.Wandsbek.pipe.p_out,
        Wandsbek.N_cv),
    h_start=ones(Wandsbek.pipe.N_cv)*Init.Wandsbek.pipe.h_in,
    m_flow_start=ones(Wandsbek.pipe.N_cv + 1)*Init.Wandsbek.pipe.m_flow,
    N_tubes=4,
    m_flow_nom=Init.m_flow_nom_Wandsbek,
    k=k_consumer,
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    N_cv=if integer(Nper10km*Wandsbek.length/10000) < 2 then 2 else integer(Nper10km*Wandsbek.length/10000),
    massBalance=massBalance) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={94,-364})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow HHMitte(
    length(displayUnit="km") = 9480,
    diameter=0.235,
    Delta_p_nom=Init.Delta_p_nom_HHMitte,
    xi_start=Init.HHMitte.pipe.xi_in,
    p_nom=ones(HHMitte.pipe.N_cv)*Init.HHMitte.pipe.p_in,
    h_nom=ones(HHMitte.pipe.N_cv)*Init.HHMitte.pipe.h_in,
    p_start=linspace(
        Init.HHMitte.pipe.p_in,
        Init.HHMitte.pipe.p_out,
        HHMitte.N_cv),
    h_start=ones(HHMitte.pipe.N_cv)*Init.HHMitte.pipe.h_in,
    m_flow_start=ones(HHMitte.pipe.N_cv + 1)*Init.HHMitte.pipe.m_flow,
    N_tubes=23,
    m_flow_nom=Init.m_flow_nom_HHMitte,
    k=k_consumer,
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    N_cv=if integer(Nper10km*HHMitte.length/10000) < 2 then 2 else integer(Nper10km*HHMitte.length/10000),
    massBalance=massBalance) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={72,-414})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow Bergedorf(
    length(displayUnit="km") = 6770,
    diameter=0.235,
    Delta_p_nom=Init.Delta_p_nom_Bergedorf,
    xi_start=Init.Bergedorf.pipe.xi_in,
    p_nom=ones(Bergedorf.pipe.N_cv)*Init.Bergedorf.pipe.p_in,
    h_nom=ones(Bergedorf.pipe.N_cv)*Init.Bergedorf.pipe.h_in,
    p_start=linspace(
        Init.Bergedorf.pipe.p_in,
        Init.Bergedorf.pipe.p_out,
        Bergedorf.N_cv),
    h_start=ones(Bergedorf.pipe.N_cv)*Init.Bergedorf.pipe.h_in,
    m_flow_start=ones(Bergedorf.pipe.N_cv + 1)*Init.Bergedorf.pipe.m_flow,
    N_tubes=15,
    m_flow_nom=Init.m_flow_nom_Bergedorf,
    k=k_consumer,
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    N_cv=if integer(Nper10km*Bergedorf.length/10000) < 2 then 2 else integer(Nper10km*Bergedorf.length/10000),
    massBalance=massBalance) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={94,-455})));
  TransiEnt.Basics.Tables.GasGrid.NaturalGasVolumeFlowSTP H_flow_demand(constantfactor=simCenter.f_gasDemand*12.14348723*3.6e6/7) annotation (Placement(transformation(extent={{100,-512},{74,-488}})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Tor(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{-10,10.5},{10,-10.5}},
        rotation=0,
        origin={-140,-301.5})));
public
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi GTS_Tornesch(
    medium=simCenter.gasModel1,
    m(fixed=true),
    p_const=Init.p_source,
    h_const=Init.h_source,
    xi_const=Init.xi_source) annotation (Placement(transformation(extent={{-192,-316},{-162,-286}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Tornesch(compositionDefinedBy=2) annotation (Placement(transformation(extent={{-82,-302},{-62,-282}})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Lev(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-80,-498})));
public
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi GTS_Leversen(
    medium=simCenter.gasModel1,
    m(fixed=true),
    p_const=Init.p_source,
    h_const=Init.h_source,
    xi_const=Init.xi_source) annotation (Placement(transformation(extent={{-138,-512},{-108,-481}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Leversen(compositionDefinedBy=2) annotation (Placement(transformation(extent={{-24,-498},{-4,-478}})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Rei(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={226,-454})));
public
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi GTS_Reitbrook(
    medium=simCenter.gasModel1,
    m(fixed=true),
    p_const=Init.p_source,
    h_const=Init.h_source,
    xi_const=Init.xi_source) annotation (Placement(transformation(
        extent={{-15,15},{15,-15}},
        rotation=180,
        origin={263,-454})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Reitbrook(compositionDefinedBy=2) annotation (Placement(transformation(extent={{174,-454},{154,-434}})));
protected
  Modelica.Blocks.Math.Gain gainTor(k=f_Tor) annotation (Placement(transformation(extent={{-58,-374},{-70,-362}})));
public
  TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_CavernComp FeedIn_Tornesch(
    m_flow_start=Init.m_flow_feedIn_Tornesch,
    T_out=simCenter.T_ground,
    p_out=p_ely,
    t_overload=t_overload,
    eta_n=eta_n,
    k=k_feedIn,
    alpha_nom=133,
    p_start=p_start,
    T_start=T_start,
    coolingToHeatingRatio=coolingToHeatingRatio,
    volume_junction=V_mixH2,
    p_maxHigh=p_max,
    P_el_n=P_el_n*f_Tor,
    P_el_max=P_el_max*f_Tor,
    P_el_min=P_el_min*f_Tor,
    P_el_overload=P_el_overload*f_Tor,
    V_geo=V_geo*f_Tor,
    p_minLow=p_minLow,
    p_minHigh=p_minHigh,
    p_start_junction=Init.mixH2_Tornesch.p,
    h_start_junction=Init.source_H2_Tornesch.h) annotation (Placement(transformation(
        extent={{-19.75,-19},{19.75,19}},
        rotation=180,
        origin={-104.5,-352})));
protected
  Modelica.Blocks.Math.Gain gainLev(k=f_Lev) annotation (Placement(transformation(extent={{2,-563},{-10,-550}})));
public
  TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_CavernComp FeedIn_Leversen(
    T_out=simCenter.T_ground,
    p_out=p_ely,
    t_overload=t_overload,
    eta_n=eta_n,
    k=k_feedIn,
    alpha_nom=133,
    p_start=p_start,
    T_start=T_start,
    coolingToHeatingRatio=coolingToHeatingRatio,
    volume_junction=V_mixH2,
    p_maxHigh=p_max,
    P_el_n=P_el_n*f_Lev,
    P_el_max=P_el_max*f_Lev,
    P_el_min=P_el_min*f_Lev,
    P_el_overload=P_el_overload*f_Lev,
    V_geo=V_geo*f_Lev,
    p_minLow=p_minLow,
    p_minHigh=p_minHigh,
    p_start_junction=Init.mixH2_Leversen.p,
    m_flow_start=Init.m_flow_feedIn_Leversen,
    h_start_junction=Init.source_H2_Leversen.h) annotation (Placement(transformation(
        extent={{-19.75,-19},{19.75,19}},
        rotation=180,
        origin={-48.5,-541})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 Mix_Tornesch(
    p_start=Init.mixH2_Tornesch.p,
    h_start=Init.mixH2_Tornesch.h_out,
    xi_start=Init.mixH2_Tornesch.xi_out,
    volume=V_mixNG) annotation (Placement(transformation(extent={{-114,-312},{-94,-292}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 Mix_Leversen(
    p_start=Init.mixH2_Leversen.p,
    h_start=Init.mixH2_Leversen.h_out,
    xi_start=Init.mixH2_Leversen.xi_out,
    volume=V_mixNG) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-48,-498})));
  TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_CavernComp FeedIn_Reitbrook(
    T_out=simCenter.T_ground,
    p_out=p_ely,
    t_overload=t_overload,
    eta_n=eta_n,
    k=k_feedIn,
    alpha_nom=133,
    p_start=p_start,
    T_start=T_start,
    coolingToHeatingRatio=coolingToHeatingRatio,
    volume_junction=V_mixH2,
    p_maxHigh=p_max,
    P_el_n=P_el_n*f_Rei,
    P_el_max=P_el_max*f_Rei,
    P_el_min=P_el_min*f_Rei,
    P_el_overload=P_el_overload*f_Rei,
    V_geo=V_geo*f_Rei,
    p_minLow=p_minLow,
    p_minHigh=p_minHigh,
    p_start_junction=Init.mixH2_Reitbrook.p,
    m_flow_start=Init.m_flow_feedIn_Reitbrook,
    h_start_junction=Init.source_H2_Reitbrook.h) annotation (Placement(transformation(
        extent={{19.75,-19},{-19.75,19}},
        rotation=180,
        origin={191.75,-540})));
protected
  Modelica.Blocks.Math.Gain gainRei(k=f_Rei) annotation (Placement(transformation(extent={{144,-562},{156,-549}})));
public
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 Mix_Reitbrook(
    p_start=Init.mixH2_Reitbrook.p,
    h_start=Init.mixH2_Reitbrook.h_out,
    xi_start=Init.mixH2_Reitbrook.xi_out,
    volume=V_mixNG) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={190,-454})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 JunctionHHMitte(
    volume=1,
    p_start=Init.mixH2_Reitbrook.p,
    h_start=Init.mixH2_Reitbrook.h_out,
    xi_start=Init.mixH2_Reitbrook.xi_out) annotation (Placement(transformation(extent={{108,-404},{88,-424}})));
public
  Modelica.Blocks.Routing.Replicator replicator(nout=3) annotation (Placement(transformation(extent={{-230,-448},{-210,-428}})));
  inner TransiEnt.Grid.Gas.StatCycleGasGridHamburg
                                 Nom(
    m_flow_feedIn_Tornesch=0,
    m_flow_feedIn_Leversen=0,
    m_flow_feedIn_Reitbrook=0,
    m_flow_unscaled=Nom.m_flow_nom_unscaled,
    f_Rei=f_Rei,
    f_Lev=f_Lev,
    f_Tor=f_Tor,
    Delta_p_nom_Ringline=ringPipes.Delta_p_nom[2],
    Delta_p_nom_Ringline1=ringPipes.Delta_p_nom[3],
    Delta_p_nom_Ringline2=ringPipes.Delta_p_nom[4],
    Delta_p_nom_Ringline3=ringPipes.Delta_p_nom[5],
    Delta_p_nom_Ringline4=ringPipes.Delta_p_nom[6],
    Delta_p_nom_Ringline5=ringPipes.Delta_p_nom[7],
    Delta_p_nom_Ringline6=ringPipes.Delta_p_nom[8],
    Delta_p_nom_Ringline7=ringPipes.Delta_p_nom[9],
    Delta_p_nom_Ringline8=ringPipes.Delta_p_nom[10],
    Delta_p_nom_Leversen=ringPipes.Delta_p_nom[1],
    Delta_p_nom_Tornesch=ringPipes.Delta_p_nom[12],
    m_flow_Harburg=districtPipes.m_flow_nom[1],
    m_flow_Altona=districtPipes.m_flow_nom[2],
    m_flow_Eimsbuettel=districtPipes.m_flow_nom[3],
    m_flow_HHNord=districtPipes.m_flow_nom[4],
    m_flow_Wandsbek=districtPipes.m_flow_nom[5],
    m_flow_HHMitte=districtPipes.m_flow_nom[6],
    m_flow_Bergedorf=districtPipes.m_flow_nom[7],
    m_flow_nom_Harburg=districtPipes.m_flow_nom[1],
    m_flow_nom_Altona=districtPipes.m_flow_nom[2],
    m_flow_nom_Eimsbuettel=districtPipes.m_flow_nom[3],
    m_flow_nom_HHNord=districtPipes.m_flow_nom[4],
    m_flow_nom_Wandsbek=districtPipes.m_flow_nom[5],
    m_flow_nom_HHMitte=districtPipes.m_flow_nom[6],
    m_flow_nom_Bergedorf=districtPipes.m_flow_nom[7],
    m_flow_nom_Ringline=ringPipes.m_flow_nom[2],
    m_flow_nom_Ringline1=ringPipes.m_flow_nom[3],
    m_flow_nom_Ringline2=ringPipes.m_flow_nom[4],
    m_flow_nom_Ringline3=ringPipes.m_flow_nom[5],
    m_flow_nom_Ringline4=ringPipes.m_flow_nom[6],
    m_flow_nom_Ringline5=ringPipes.m_flow_nom[7],
    m_flow_nom_Ringline6=ringPipes.m_flow_nom[8],
    m_flow_nom_Ringline7=ringPipes.m_flow_nom[9],
    m_flow_nom_Ringline8=ringPipes.m_flow_nom[10],
    m_flow_nom_Leversen=ringPipes.m_flow_nom[1],
    m_flow_nom_Tornesch=ringPipes.m_flow_nom[12],
    Delta_p_nom_Harburg=districtPipes.Delta_p_nom[1],
    Delta_p_nom_Altona=districtPipes.Delta_p_nom[2],
    Delta_p_nom_Eimsbuettel=districtPipes.Delta_p_nom[3],
    Delta_p_nom_HHNord=districtPipes.Delta_p_nom[4],
    Delta_p_nom_Wandsbek=districtPipes.Delta_p_nom[5],
    Delta_p_nom_HHMitte=districtPipes.Delta_p_nom[6],
    Delta_p_nom_Bergedorf=districtPipes.Delta_p_nom[7],
    splitRatioEimsbuettel=0.027784862,
    splitRatioWandsbek=0.397988049,
    quadraticPressureLoss=false,
    T_feedIn_Tornesch=325.45,
    T_feedIn_Leversen=325.45,
    T_feedIn_Reitbrook=325.45)                          annotation (Placement(transformation(extent={{234,-314},{285,-278}})));
  inner TransiEnt.Basics.Records.PipeParameter ringPipes(
    N_pipes=12,
    length={2353.4,9989.1,10203.5,11846.6,7285.6,10878.7,4420.5,11961.1,10915.2,13932.2,28366.9,16710},
    diameter(displayUnit="m") = {0.6,0.4,0.4,0.4,0.4,0.4,0.5,0.4,0.4,0.607307197,0.6,0.5},
    m_flow_nom={20.2,10.1,10.1,12.4,0.3,10.5,21.9,6.7,10.1,30.6,3.6,32.4},
    Delta_p_nom(displayUnit="Pa") = {10605,63939.6,63939.6,184435.5,56.5,125548.4,67207.8,56975.5,116965.7,140705.4,3963.8,133488.2}) annotation (Placement(transformation(extent={{252,-344},{272,-324}})));
  inner TransiEnt.Basics.Records.PipeParameter districtPipes(
    N_pipes=7,
    f_mFlow={0.0869,0.1346,0.1199,0.1688,0.187,0.2267,0.076},
    length={3774,5152,2739,10564,4075,9480,6770},
    diameter={0.221,0.221,0.221,0.221,0.221,0.221,0.221},
    N_ducts={4,5,5,6,7,8,3},
    m_flow_nom={7.83,12.12,10.8,15.2,16.83,20.42,6.84},
    Delta_p_nom(displayUnit="Pa") = {31226.22,78102.46,31207.91,126637.22,63836.59,152213.2,73490.95}) annotation (Placement(transformation(extent={{282,-344},{302,-324}})));
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
      points={{20,-201},{20,-196},{56,-196},{56,-164},{56,-153.1},{49.9,-153.1}},
      color={175,0,0},
      thickness=0.5));
  connect(HW_HafenCity.inlet, massflow_Tm_flow1.fluidPortOut) annotation (Line(
      points={{-1.78,-201},{28,-201},{28,-206}},
      color={175,0,0},
      thickness=0.5));
  connect(T_return2.y, massflow_Tm_flow2.T) annotation (Line(points={{151,-187.5},{149,-187.5},{149,-182.8},{147,-182.8}},
                                                                                                    color={0,0,127}));
  connect(massflow_Tm_flow2.fluidPortOut, Tiefstack_HardCoal.inlet) annotation (Line(
      points={{147,-174},{147,-166.08},{147.74,-166.08},{147.74,-161.85}},
      color={175,0,0},
      thickness=0.5));
  connect(m_flow_return2.y, massflow_Tm_flow2.m_flow) annotation (Line(points={{144,-187.5},{144,-186},{145,-186},{145.86,-186},{145.86,-182.8},{145.2,-182.8}},
                                                                                                    color={0,0,127}));
  connect(HW_HafenCity.eye, infoBoxLargeCHP2.eye) annotation (Line(points={{21.1,-210.9},{24,-210.9},{24,-218.364},{25.9,-218.364}},
                                                                                                    color={28,108,200}));

  connect(Tiefstack_HardCoal.eye, infoBoxLargeCHP3.eye) annotation (Line(points={{146.7,-167.917},{137.5,-167.917},{137.5,-186.364},{134.1,-186.364}},
                                                                                                    color={28,108,200}));

  //General annotations

  connect(Tiefstack_HardCoal.Q_flow_set, Q_flow_set_WT.y) annotation (Line(points={{156.19,-146.033},{153.985,-146.033},{153.985,-138},{152,-138},{152,-136.9}},
                                                                                                    color={0,0,127}));
  connect(HW_HafenCity.Q_flow_set, Q_flow_set_Hafen.y) annotation (Line(points={{9,-190},{9,-189},{-2.1,-189}},
                                                                                                        color={0,0,127}));

  connect(UCTE.epp,P_12. epp_OUT) annotation (Line(
      points={{261,-43},{261,-43.5},{255.13,-43.5}},
      color={0,135,135},
      thickness=0.5));
  connect(P_set_Offshore.y,WindOffshorePlant. P_el_set) annotation (Line(points={{-85,222},{-78,222},{-78,214.81}},    color={0,0,127}));
  connect(P_set_Onshore.y,WindOnshorePlant. P_el_set) annotation (Line(points={{-27,220},{-18,220},{-18,214.81}},    color={0,0,127}));
  connect(P_set_PV.y,PVPlant. P_el_set) annotation (Line(points={{35,220},{42,220},{42,214.81}},    color={0,0,127}));
  connect(P_set_ROH.y,RunOfWaterPlant. P_el_set) annotation (Line(points={{95,220},{95,220},{102,220},{102,214.81}},
                                                                                                    color={0,0,127}));
  connect(P_set_BCG.y,BrownCoal. P_el_set) annotation (Line(points={{-87,126},{-78,126},{-78,108.81}}, color={0,0,127}));
  connect(P_set_OIL.y,OIL. P_el_set) annotation (Line(points={{-29,126},{-18,126},{-18,108.81}}, color={0,0,127}));
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
  connect(P_load_is.y,Demand. P_el_set) annotation (Line(points={{259,86},{251,86},{251,74.04}},      color={0,0,127}));
  connect(P_set_SB_BCG.y,BrownCoal. P_SB_set) annotation (Line(points={{-95,112},{-94,112},{-94,106.91},{-92.8,106.91}}, color={0,0,127}));
  connect(P_set_SB_OIL.y,OIL. P_SB_set) annotation (Line(points={{-39,112},{-34,112},{-34,106.91},{-32.8,106.91}},
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
  connect(Q_flow_set_WW1.y,HKW_Wedel. Q_flow_set) annotation (Line(points={{-71,-120.9},{-71,-140.333},{-71.3,-140.333}},
                                                                                                    color={0,0,127}));
  connect(HKW_Wedel.eye,infoBoxLargeCHP1. eye) annotation (Line(points={{-64,-157.167},{-42,-157.167},{-42,-180.364},{-37.1,-180.364}},
                                                                                                    color={28,108,200}));
  connect(T_return5.y,massflow_Tm_flow3. T) annotation (Line(points={{-53,-171.5},{-57,-171.5},{-57,-166.8},{-60,-166.8}},
                                                                                                    color={0,0,127}));
  connect(m_flow_return3.y,massflow_Tm_flow3. m_flow) annotation (Line(points={{-64,-171.5},{-64,-169.75},{-61.8,-169.75},{-61.8,-166.8}},
                                                                                                    color={0,0,127}));
  connect(massflow_Tm_flow3.fluidPortOut,HKW_Wedel. inlet) annotation (Line(
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
      points={{148.65,-152.1},{138,-152.1},{138,-90},{-44,-90},{-44,52},{231.4,52}},
      color={0,135,135},
      thickness=0.5));
  connect(P_set_CHP_East.y, Tiefstack_HardCoal.P_set) annotation (Line(points={{165,-108},{168,-108},{168,-110},{168,-110},{168,-118},{164,-118},{164,-132},{168.93,-132},{168.93,-146.033}},
                                                                                                                                                                       color={0,0,127}));

  connect(spiVoWedel.Q_flow_set_total,Q_flow_set_Spivo_Wedel. y) annotation (Line(points={{-6,-117.92},{-6,-114.9}},
                                                                                                    color={0,0,127}));

  connect(T_return3.y, massflow_Tm_flow1.T) annotation (Line(points={{44.4,-202},{40,-202},{40,-206},{36.8,-206}},     color={0,0,127}));
  connect(m_flow_return1.y, massflow_Tm_flow1.m_flow) annotation (Line(points={{43.5,-209},{40,-209},{40,-207.8},{36.8,-207.8}},   color={0,0,127}));
  connect(massflow_Tm_flow4.T, T_return1.y) annotation (Line(points={{114.8,-212},{118,-212},{118,-206},{120.4,-206}},     color={0,0,127}));
  connect(massflow_Tm_flow4.m_flow, m_flow_return5.y) annotation (Line(points={{114.8,-213.8},{118,-213.8},{118,-215},{121.5,-215}},   color={0,0,127}));
  connect(PtH.inlet, HKW_Wedel.outlet) annotation (Line(
      points={{-41.8,-148},{-64.8,-148},{-64.8,-150.167}},
      color={175,0,0},
      thickness=0.5));
  connect(P_set_Pth.y, ptH_limiter.P_RE_curtail) annotation (Line(points={{-173,-168},{-167,-168}}, color={0,0,127}));
  connect(PtH.Q_flow_set, Q_flow_set_PtH.y) annotation (Line(points={{-32,-138},{-32,-133.5},{-31,-133.5},{-31,-130.9}},     color={0,0,127}));
  connect(P_set_Curt_after_P2X.y, P_RE_curtailement.u) annotation (Line(points={{153,216},{162,216},{162,226},{171,226},{171,211.58}}, color={0,0,127}));
  connect(PtH.epp, Demand.epp) annotation (Line(
      points={{-32,-158},{-44,-158},{-44,-90},{-44,-90},{-44,52},{231.4,52}},
      color={0,135,135},
      thickness=0.5));
  connect(discretizePrediction.P_predictions,mod. u) annotation (Line(points={{-181,86},{-168.4,86},{-168.4,85}},
                                                                                                    color={0,0,127}));
  connect(H_lpa.y,discretizePrediction. P_is) annotation (Line(points={{-217,86},{-211.5,86},{-204,86}},
                                                                                                    color={0,0,127}));
  connect(UC.P_sec_pos[simCenter.generationPark.isMOD],mod. P_R_pos) annotation (Line(points={{-166.7,121.4},{-158.8,121.4},{-158.8,100.6}},
                                                                                                                                          color={0,0,127}));
  connect(UC.P_sec_neg[simCenter.generationPark.isMOD],mod. P_R_neg) annotation (Line(points={{-166.7,116.8},{-149.2,116.8},{-149.2,100.6}},
                                                                                                                                          color={0,0,127}));
  connect(P_residual_pred_1h.y,discretizePrediction. P_prediction) annotation (Line(points={{-203,114},{-192,114},{-192,98}},
                                                                                                                            color={0,0,127}));
  connect(UC.z[simCenter.generationPark.isMOD],mod. z) annotation (Line(points={{-166.7,128},{-138,128},{-138,64},{-154,64},{-154,69.4}},      color={255,0,255}));
  connect(P_residual_pred.y,H_lpa. P_load_pred) annotation (Line(points={{-241,108},{-228,108},{-228,98}},
                                                                                                       color={0,0,127}));
  connect(P_residual_is.y,H_lpa. P_load_is) annotation (Line(points={{-247,86},{-240,86}},   color={0,0,127}));

  connect(GUDTS.inlet, massflow_Tm_flow5.steam_a) annotation (Line(
      points={{224.25,-154.575},{234,-154.575},{234,-158}},
      color={175,0,0},
      thickness=0.5));
  connect(Q_flow_set_WT1.y, GUDTS.Q_flow_set) annotation (Line(points={{218.25,-132},{216.125,-132},{216.125,-138.15}}, color={0,0,127}));
  connect(GUDTS.epp, Demand.epp) annotation (Line(
      points={{223.375,-144.45},{232,-144.45},{232,-144},{240,-144},{240,-90},{-44,-90},{-44,52},{231.4,52}},
      color={0,135,135},
      thickness=0.5));
  connect(P_set_SB_CHP_East1.y, GUDTS.P_SB_set) annotation (Line(points={{195,-130},{200.375,-130},{200.375,-140.738}}, color={0,0,127}));
  connect(GUDTS.P_set, P_set_WT1.y) annotation (Line(points={{203.875,-138.15},{203.875,-130},{204,-130},{204,-114},{197,-114}}, color={0,0,127}));

  connect(ptH_limiter.Q_flow_set_demand, dHNControl.Q_flow_i[2]) annotation (Line(
      points={{-156,-156},{-180,-156},{-180,-203.04},{-202.733,-203.04}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(HeatFlowEastPlusWUWSPS.y, heatSchedulerEast.Q_flow_total) annotation (Line(points={{-183.75,-189.5},{-183.75,-195.75},{-170,-195.75},{-170,-198}}, color={0,0,127}));
  connect(massflow_Tm_flow6.p, p_set_WT2.y) annotation (Line(points={{244,-153.8},{252,-153.8},{252,-154},{258.25,-154}}, color={0,0,127}));
  connect(GUDTS.outlet, massflow_Tm_flow6.fluidPortIn) annotation (Line(
      points={{224.25,-151.425},{231.125,-151.425},{231.125,-152},{236,-152}},
      color={175,0,0},
      thickness=0.5));
  connect(spiVo_Wedel.outlet, DistrictHeatingGrid.fluidPortWest) annotation (Line(
      points={{2,-148},{22.9,-148},{22.9,-147.9}},
      color={175,0,0},
      thickness=0.5));
  connect(spiVo_Wedel.inlet, PtH.outlet) annotation (Line(
      points={{-17.8,-148},{-19.9,-148},{-22,-148}},
      color={175,0,0},
      thickness=0.5));
  connect(spiVo_Wedel.Q_flow_set, spiVoWedel.Q_flow_set) annotation (Line(points={{-8,-138},{-8,-138},{-8,-126.08},{-6,-126.08}}, color={0,0,127}));
  connect(spiVo_Wedel.eye, infoBoxLargeCHP4.eye) annotation (Line(points={{3,-157},{4,-157},{4,-166.364},{4.9,-166.364}}, color={28,108,200}));
  connect(Q_set_Spivo_Tiefstack.y, twoFuelBoiler.Q_flow_set_B2) annotation (Line(points={{108,-136.9},{108,-136.9},{108,-150.14},{109.2,-150.14}}, color={0,0,127}));
  connect(Q_set_MVB.y, twoFuelBoiler.Q_flow_set_B1) annotation (Line(points={{122,-136.9},{120,-136.9},{120,-150.14},{118.64,-150.14}}, color={0,0,127}));
  connect(Tiefstack_HardCoal.outlet, twoFuelBoiler.inlet) annotation (Line(
      points={{147.74,-158.817},{134,-158.817},{134,-157},{121.84,-157}},
      color={175,0,0},
      thickness=0.5));
  connect(DistrictHeatingGrid.fluidPortEast, twoFuelBoiler.outlet) annotation (Line(
      points={{56.7,-154.9},{82,-154.9},{82,-157},{106,-157}},
      color={175,0,0},
      thickness=0.5));
  connect(massflow_Tm_flow4.fluidPortOut, wuWSpaldingStr.inlet) annotation (Line(
      points={{106,-212},{104,-212},{104,-214},{101.8,-214}},
      color={175,0,0},
      thickness=0.5));
  connect(Q_set_WUWSPS.y, wuWSpaldingStr.Q_flow_set) annotation (Line(points={{91.9,-197},{92,-197},{92,-204}}, color={0,0,127}));
  connect(DistrictHeatingGrid.fluidPortWUWSPS, wuWSpaldingStr.outlet) annotation (Line(
      points={{52.7,-151.3},{68,-151.3},{68,-214},{82,-214}},
      color={175,0,0},
      thickness=0.5));
  connect(GUDTS.eye, infoBoxLargeCHP5.eye) annotation (Line(points={{225.25,-160.875},{224,-160.875},{224,-184.364},{224.1,-184.364}}, color={28,108,200}));

  connect(HHNord.H_flow,H_flow_demand. y1) annotation (Line(
      points={{53,-310},{58,-310},{58,-500},{72.7,-500}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Eimsbuettel.H_flow,H_flow_demand. y1) annotation (Line(
      points={{47,-374},{58,-374},{58,-500},{72.7,-500}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Wandsbek.H_flow,H_flow_demand. y1) annotation (Line(
      points={{83,-364},{58,-364},{58,-500},{72.7,-500}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Altona.H_flow,H_flow_demand. y1) annotation (Line(
      points={{31,-399},{58,-399},{58,-500},{72.7,-500}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(HHMitte.H_flow,H_flow_demand. y1) annotation (Line(
      points={{61,-414},{58,-414},{58,-500},{72.7,-500}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Bergedorf.H_flow,H_flow_demand. y1) annotation (Line(
      points={{83,-455},{58,-455},{58,-500},{72.7,-500}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Harburg.H_flow,H_flow_demand. y1) annotation (Line(
      points={{51,-451},{58,-451},{58,-500},{72.7,-500}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Wandsbek.fluidPortIn,gasGridHamburg. offTakeWandsbek) annotation (Line(
      points={{104,-364},{94,-364},{94,-360.071},{145.871,-360.071}},
      color={255,255,0},
      thickness=1.5));
  connect(Bergedorf.fluidPortIn,gasGridHamburg. offTakeBergedorf) annotation (Line(
      points={{104,-455},{106,-455},{106,-451.976},{166.171,-451.976}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeAltona,Altona. fluidPortIn) annotation (Line(
      points={{-14.1412,-397.271},{10,-397.271},{10,-399}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeEimsbuettel,Eimsbuettel. fluidPortIn) annotation (Line(
      points={{6.15882,-371.012},{6.15882,-374},{26,-374}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeHarburg,Harburg. fluidPortIn) annotation (Line(
      points={{7.35294,-447.6},{30,-447.6},{30,-451}},
      color={255,255,0},
      thickness=1.5));
  connect(HHNord.fluidPortIn,gasGridHamburg. offTakeNord) annotation (Line(
      points={{74,-310},{83.7765,-310},{83.7765,-324.329}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Tornesch.gasPort,maxH2MassFlow_Tor. gasPortIn) annotation (Line(
      points={{-162,-301},{-162,-301.5},{-150,-301.5}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Leversen.gasPort,maxH2MassFlow_Lev. gasPortIn) annotation (Line(
      points={{-108,-496.5},{-90,-496.5},{-90,-498}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Reitbrook.gasPort,maxH2MassFlow_Rei. gasPortIn) annotation (Line(
      points={{248,-454},{248,-454},{236,-454}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Tornesch.gasPortOut,gasGridHamburg. GTSTor) annotation (Line(
      points={{-62,-302},{-56,-302},{-56,-301.718},{-90.5647,-301.718}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Leversen.gasPortOut,gasGridHamburg. GTSLev) annotation (Line(
      points={{-4,-498},{-9.36471,-498},{-9.36471,-498.659}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeBergedorf,vleCompositionSensor_Reitbrook. gasPortOut) annotation (Line(
      points={{166.171,-451.976},{150.459,-451.976},{150.459,-454},{154,-454}},
      color={255,255,0},
      thickness=1.5));
  connect(gainTor.y,FeedIn_Tornesch. P_el_set) annotation (Line(
      points={{-70.6,-368},{-70.5,-368},{-70.5,-371.76},{-104.5,-371.76}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Mix_Tornesch.gasPort2,FeedIn_Tornesch. gasPortOut) annotation (Line(
      points={{-104,-312},{-104,-312},{-104,-332.81},{-103.513,-332.81}},
      color={255,255,0},
      thickness=1.5));
  connect(Mix_Leversen.gasPort2,FeedIn_Leversen. gasPortOut) annotation (Line(
      points={{-48,-508},{-48,-521.81},{-47.5125,-521.81}},
      color={255,255,0},
      thickness=1.5));
  connect(gainLev.y,FeedIn_Leversen. P_el_set) annotation (Line(
      points={{-10.6,-556.5},{-14.5,-556.5},{-14.5,-560.76},{-48.5,-560.76}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(gainRei.y,FeedIn_Reitbrook. P_el_set) annotation (Line(
      points={{156.6,-555.5},{155.5,-555.5},{155.5,-559.76},{191.75,-559.76}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Mix_Reitbrook.gasPort2,FeedIn_Reitbrook. gasPortOut) annotation (Line(
      points={{190,-464},{190,-520.81},{190.762,-520.81}},
      color={255,255,0},
      thickness=1.5));
  connect(Mix_Reitbrook.gasPort1,maxH2MassFlow_Rei. gasPortOut) annotation (Line(
      points={{200,-454},{208,-454},{216,-454}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Reitbrook.gasPortIn,Mix_Reitbrook. gasPort3) annotation (Line(
      points={{174,-454},{174,-454},{180,-454}},
      color={255,255,0},
      thickness=1.5));
  connect(maxH2MassFlow_Rei.m_flow_H2_max,FeedIn_Reitbrook. m_flow_feedIn) annotation (Line(points={{226,-463},{226,-555.2},{211.5,-555.2}},color={0,0,127},
      pattern=LinePattern.Dash));
  connect(maxH2MassFlow_Lev.gasPortOut,Mix_Leversen. gasPort1) annotation (Line(
      points={{-70,-498},{-58,-498}},
      color={255,255,0},
      thickness=1.5));
  connect(Mix_Leversen.gasPort3,vleCompositionSensor_Leversen. gasPortIn) annotation (Line(
      points={{-38,-498},{-38,-498},{-24,-498}},
      color={255,255,0},
      thickness=1.5));
  connect(maxH2MassFlow_Tor.gasPortOut,Mix_Tornesch. gasPort1) annotation (Line(
      points={{-130,-301.5},{-120,-301.5},{-120,-302},{-114,-302}},
      color={255,255,0},
      thickness=1.5));
  connect(Mix_Tornesch.gasPort3,vleCompositionSensor_Tornesch. gasPortIn) annotation (Line(
      points={{-94,-302},{-82,-302}},
      color={255,255,0},
      thickness=1.5));
  connect(maxH2MassFlow_Tor.m_flow_H2_max,FeedIn_Tornesch. m_flow_feedIn) annotation (Line(points={{-140,-310.95},{-140,-310.95},{-140,-367.2},{-124.25,-367.2}},
                                                                                                                                                           color={0,0,127},
      pattern=LinePattern.Dash));
  connect(maxH2MassFlow_Lev.m_flow_H2_max,FeedIn_Leversen. m_flow_feedIn) annotation (Line(points={{-80,-507},{-80,-507},{-80,-554},{-80,-556.2},{-68.25,-556.2}},     color={0,0,127},
      pattern=LinePattern.Dash));
  connect(JunctionHHMitte.gasPort1, gasGridHamburg.offTakeMitte) annotation (Line(
      points={{108,-414},{114,-414},{114,-418},{116,-418},{116,-413.318},{136.318,-413.318}},
      color={255,255,0},
      thickness=1.5));
  connect(HHMitte.fluidPortIn, JunctionHHMitte.gasPort3) annotation (Line(
      points={{82,-414},{82,-414},{88,-414}},
      color={255,255,0},
      thickness=1.5));
  connect(JunctionHHMitte.gasPort2, HW_HafenCity.gasIn) annotation (Line(
      points={{98,-404},{98,-404},{98,-390},{236,-390},{236,-252},{9.22,-252},{9.22,-212}},
      color={255,255,0},
      thickness=1.5));
  connect(P_set_Electrolysis.y, replicator.u) annotation (Line(points={{-244.5,-438},{-232,-438}}, color={0,0,127}));
  connect(replicator.y[1], gainRei.u) annotation (Line(
      points={{-209,-438.667},{-184,-438.667},{-184,-582},{68,-582},{68,-555.5},{142.8,-555.5}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(replicator.y[2], gainLev.u) annotation (Line(
      points={{-209,-438},{-184,-438},{-184,-582},{66,-582},{66,-556.5},{3.2,-556.5}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(replicator.y[3], gainTor.u) annotation (Line(
      points={{-209,-437.333},{-42,-437.333},{-42,-368},{-56.8,-368}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(FeedIn_Leversen.epp, Demand.epp) annotation (Line(
      points={{-28.75,-541},{74,-541},{74,-588},{-312,-588},{-312,-54},{-44,-54},{-44,52},{231.4,52}},
      color={0,135,135},
      thickness=0.5));
  connect(FeedIn_Reitbrook.epp, Demand.epp) annotation (Line(
      points={{172,-540},{72,-540},{72,-542},{74,-541},{74,-588},{-312,-588},{-312,-54},{-44,-54},{-44,52},{231.4,52}},
      color={0,135,135},
      thickness=0.5));
  connect(FeedIn_Tornesch.epp, Demand.epp) annotation (Line(
      points={{-84.75,-352},{-46,-352},{-46,-406},{-312,-406},{-312,-54},{-44,-54},{-44,52},{231.4,52}},
      color={0,135,135},
      thickness=0.5));
  connect(P_set_GAR.y, GAR.P_el_set) annotation (Line(points={{31,126},{42,126},{42,108.81}}, color={0,0,127}));
  connect(P_set_BM.y, Biomass.P_el_set) annotation (Line(points={{95,126},{100,126},{100,108.81}}, color={0,0,127}));
  connect(P_set_SB_GAR.y, GAR.P_SB_set) annotation (Line(points={{21,112},{24,112},{24,106.91},{27.2,106.91}}, color={0,0,127}));
  connect(P_set_SB_BM.y, Biomass.P_SB_set) annotation (Line(points={{79,112},{80,112},{80,114},{85.2,114},{85.2,106.91}}, color={0,0,127}));
   annotation (
    experiment(StopTime=86400, Interval=900),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-320,-600},{320,260}},
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
          extent={{-238,238},{-182,230}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash,
          textString="Prediction Errors"),
        Rectangle(
          extent={{-238,240},{-134,162}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash),
        Text(
          extent={{-268,146},{-200,134}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash,
          textString="Economic Dispatch"),
        Rectangle(
          extent={{-274,144},{-136,62}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash)}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-320,-600},{320,260}},
        initialScale=0.1)),
    Documentation(info="<html>
<p>The district heating grid is modeled as a mass-flow sink, but can be replaced with more detailed models if required.</p>
</html>"),
    __Dymola_experimentSetupOutput(inputs=false, events=false),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end SectorCouplingPtX;
