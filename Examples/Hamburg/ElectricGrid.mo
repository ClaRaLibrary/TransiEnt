within TransiEnt.Examples.Hamburg;
model ElectricGrid "Example of an electric grid with several generators, frequency control and economic dispatch models"
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
  import TransiEnt;
  extends TransiEnt.Basics.Icons.Example;

  inner TransiEnt.SimCenter  simCenter(         thres=1e-9,
    useThresh=true,
    tableInterpolationSmoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    redeclare TransiEnt.Examples.Hamburg.ExampleGenerationPark2035 generationPark,
    P_n_ref_1=4e9,
    Td=60)
    annotation (Placement(transformation(extent={{-290,140},{-270,160}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-270,160},{-250,140}})));
  TransiEnt.Components.Sensors.ElectricActivePower P_12(change_of_sign=false) annotation (Placement(transformation(extent={{223,-119},{252,-144}})));
  TransiEnt.Producer.Electrical.Conventional.BrownCoal BrownCoal(
    P_max_star=1,
    isPrimaryControlActive=true,
    t_startup=0,
    P_init_set=UC.P_init[UC.schedule.BCG],
    isSecondaryControlActive=true) annotation (Placement(transformation(extent={{-99,-17},{-59,21}})));
  TransiEnt.Producer.Electrical.Conventional.Gasturbine Gasturbine2(
    isPrimaryControlActive=false,
    isSecondaryControlActive=true,
    t_startup=0,
    P_el_n=simCenter.generationPark.P_el_n_GT2,
    P_init_set=UC.P_init[UC.schedule.GT2]) annotation (Placement(transformation(extent={{-27,-127},{13,-89}})));
  TransiEnt.Grid.Electrical.LumpedPowerGrid.LumpedGrid UCTE(
    T_r=150,
    lambda_sec=simCenter.P_n_ref_2/(simCenter.P_n_ref_1 + simCenter.P_n_ref_2)*3e9/0.2,
    beta=0.2,
    redeclare TransiEnt.Grid.Electrical.Noise.TypicalLumpedGridError genericGridError) annotation (Placement(transformation(extent={{297,-150},{257,-112}})));
  TransiEnt.Producer.Electrical.Controllers.CurtailmentController P_RE_curtailement annotation (Placement(transformation(extent={{147,89},{187,127}})));
  TransiEnt.Consumer.Electrical.LinearElectricConsumer Demand annotation (Placement(transformation(
        extent={{-169,-5},{-129,33}},
        rotation=0,
        origin={396,-50})));
  TransiEnt.Producer.Electrical.Conventional.Garbage GAR(
    isPrimaryControlActive=true,
    t_startup=0,
    P_init_set=UC.P_init[UC.schedule.GAR],
    isSecondaryControlActive=true) "Garbage" annotation (Placement(transformation(extent={{21,-17},{61,21}})));

  TransiEnt.Grid.Electrical.SecondaryControl.AGC aGC(
    changeSignOfTieLinePower=false,
    isExternalTielineSetpoint=true,
    Ti=200,
    samplePeriod=60,
    startTime=60,
    redeclare TransiEnt.Grid.Electrical.SecondaryControl.Activation.ScheduleActivation SecondaryControlActivation(Td=simCenter.Td) "Continuous external schedule Activation",
    P_respond=0*0.855e6,
    K_r=11e6/0.2,
    k=0.4) annotation (Placement(transformation(extent={{-222,-178},{-184,-215}})));
  TransiEnt.Producer.Electrical.Conventional.CCP CCP(
    isSecondaryControlActive=true,
    t_startup=0,
    P_init_set=UC.P_init[UC.schedule.CCP]) annotation (Placement(transformation(extent={{-173,-125},{-133,-87}})));
  TransiEnt.Producer.Electrical.Conventional.Oil OIL(
    isPrimaryControlActive=true,
    t_startup=0,
    P_init_set=UC.P_init[UC.schedule.OIL],
    isSecondaryControlActive=true) "Mineral oil" annotation (Placement(transformation(extent={{-39,-17},{1,21}})));

  TransiEnt.Producer.Electrical.Wind.PowerProfileWindPlant WindOnshorePlant(P_el_n=simCenter.generationPark.P_el_n_WindOn) annotation (Placement(transformation(extent={{-39,89},{1,127}})));
  TransiEnt.Producer.Electrical.Wind.PowerProfileWindPlant WindOffshorePlant(P_el_n=simCenter.generationPark.P_el_n_WindOff) annotation (Placement(transformation(extent={{-99,89},{-59,127}})));
  TransiEnt.Producer.Electrical.Photovoltaics.PhotovoltaicProfilePlant PVPlant(P_el_n=simCenter.generationPark.P_el_n_PV) annotation (Placement(transformation(extent={{21,89},{61,127}})));
  TransiEnt.Producer.Electrical.Others.Biomass Biomass(
    P_max_star=1,
    isPrimaryControlActive=false,
    t_startup=0,
    P_init_set=UC.P_init[UC.schedule.BM],
    isSecondaryControlActive=true,
    isExternalSecondaryController=true) annotation (Placement(transformation(extent={{79,-17},{119,21}})));

  TransiEnt.Producer.Electrical.Others.PumpedStoragePlant PumpedStorage(t_startup=60, P_init_set=-(UC.P_init[UC.schedule.PS] + UC.P_init[UC.schedule.PS_Pump])) annotation (Placement(transformation(extent={{135,-127},{175,-89}})));
  TransiEnt.Producer.Electrical.Others.IdealContinuousHydropowerPlant RunOfWaterPlant(P_el_n=simCenter.generationPark.P_el_n_ROH) annotation (Placement(transformation(extent={{81,89},{121,127}})));

  Modelica.Blocks.Sources.RealExpression P_set_BM(y=UC.schedule.y[UC.schedule.BM])
                                                                             annotation (Placement(transformation(extent={{70,28},{90,48}})));
  Modelica.Blocks.Sources.RealExpression P_set_Offshore(y=P_wind_off_is.y1 + e_wind_prediction_off.y)
                                                                                                    annotation (Placement(transformation(extent={{-108,124},{-88,144}})));
  Modelica.Blocks.Sources.RealExpression P_set_Onshore(y=P_wind_on_is.y1 + e_wind_prediction_on.y)                   annotation (Placement(transformation(extent={{-50,122},{-30,142}})));
  Modelica.Blocks.Sources.RealExpression P_set_PV(y=P_PV_is.y1 + e_pv_prediction.y)
                                                                                   annotation (Placement(transformation(extent={{10,122},{30,142}})));
  Modelica.Blocks.Sources.RealExpression P_set_ROH(y=UC.schedule.y[UC.schedule.ROH])  annotation (Placement(transformation(extent={{70,122},{90,142}})));
  Modelica.Blocks.Sources.RealExpression P_set_BCG(y=mod.y[UC.schedule.BCG])    annotation (Placement(transformation(extent={{-112,28},{-92,48}})));
  Modelica.Blocks.Sources.RealExpression P_set_OIL(y=mod.y[UC.schedule.OIL])          annotation (Placement(transformation(extent={{-54,28},{-34,48}})));
  Modelica.Blocks.Sources.RealExpression P_set_GAR(y=mod.y[UC.schedule.GAR])         annotation (Placement(transformation(extent={{6,28},{26,48}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_CCP(y=aGC.P_sec_set[UC.schedule.CCP])
                                                           annotation (Placement(transformation(extent={{-202,-92},{-182,-72}})));
  Modelica.Blocks.Sources.RealExpression P_set_CCP(y=mod.y[UC.schedule.CCP])         annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_GT(y=aGC.P_sec_set[UC.schedule.GT2])
                                                          annotation (Placement(transformation(extent={{-44,-88},{-24,-68}})));
  Modelica.Blocks.Sources.RealExpression P_set_GT2(y=mod.y[UC.schedule.GT2])  annotation (Placement(transformation(extent={{14,-86},{-6,-66}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_PS(y=aGC.P_sec_set[UC.schedule.PS])
                                                          annotation (Placement(transformation(extent={{108,-96},{128,-76}})));
  Modelica.Blocks.Sources.RealExpression P_set_PS(y=UC.schedule.y[UC.schedule.PS] + UC.schedule.y[UC.schedule.PS_Pump])     annotation (Placement(transformation(extent={{130,-82},{150,-62}})));
  Modelica.Blocks.Sources.RealExpression P_set_CHP_West(y=mod.y[UC.schedule.WW1])         annotation (Placement(transformation(extent={{-108,-182},{-88,-162}})));
  Modelica.Blocks.Sources.RealExpression P_set_CHP_East(y=mod.y[UC.schedule.WT])         annotation (Placement(transformation(extent={{-30,-178},{-10,-158}})));
  Modelica.Blocks.Sources.RealExpression P_set_Curt(y=UC.schedule.y[UC.schedule.Curt])             annotation (Placement(transformation(extent={{134,122},{154,142}})));
  Modelica.Blocks.Sources.RealExpression P_tieline_set(y=-UC.schedule.y[UC.schedule.Import])
                                                                          annotation (Placement(transformation(extent={{-170,-234},{-190,-214}})));
  Modelica.Blocks.Sources.RealExpression P_residual_is(y=Demand.epp.P + P_RE_curtailement.epp_out.P + PumpedStorage.epp.P + Biomass.epp.P)
                                                                                                    annotation (Placement(transformation(extent={{-272,-24},{-252,-4}})));
  Modelica.Blocks.Sources.RealExpression P_tieline_is(y=P_12.P) annotation (Placement(transformation(extent={{-240,-234},{-220,-214}})));

  Modelica.Blocks.Sources.Constant t_start_set(k=0) annotation (Placement(transformation(extent={{-300,100},{-280,120}})));
  TransiEnt.Basics.Blocks.Sources.ConstantVectorSource P_init_set(nout=simCenter.generationPark.nPlants, k={0.00,184844600.00,0.00,264596300.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,65349610.00,67121080.00,-0.00,-0.00,0.00,45750000.00,0.00,436034500.00,176187200.00}) annotation (Placement(transformation(extent={{-300,60},{-280,80}})));
  Modelica.Blocks.Sources.RealExpression P_load_is(y=Demand.epp.P) "Freqeuency dependent load"
                                                                          annotation (Placement(transformation(extent={{290,-36},{270,-16}})));
  TransiEnt.Basics.Blocks.Sources.RealVectorExpression P_sec_pos(nout=simCenter.generationPark.nDispPlants, y_set=UC.P_sec_pos) annotation (Placement(transformation(extent={{-252,-198},{-232,-178}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_CHP_West(y=aGC.P_sec_set[UC.schedule.WW1]) annotation (Placement(transformation(extent={{-134,-192},{-114,-172}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_CHP_East(y=aGC.P_sec_set[UC.schedule.WT]) annotation (Placement(transformation(extent={{-46,-192},{-26,-172}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_BCG(y=aGC.P_sec_set[UC.schedule.BCG]) annotation (Placement(transformation(extent={{-120,14},{-100,34}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_OIL(y=aGC.P_sec_set[UC.schedule.OIL]) annotation (Placement(transformation(extent={{-64,14},{-44,34}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_GAR(y=aGC.P_sec_set[UC.schedule.GAR]) annotation (Placement(transformation(extent={{-4,14},{16,34}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_BM(y=aGC.P_sec_set[UC.schedule.BM]) annotation (Placement(transformation(extent={{54,14},{74,34}})));
  TransiEnt.Basics.Blocks.Sources.RealVectorExpression P_sec_neg(nout=simCenter.generationPark.nDispPlants, y_set=UC.P_sec_neg) annotation (Placement(transformation(extent={{-254,-214},{-234,-194}})));
  Modelica.Blocks.Sources.RealExpression P_set_WT(y=mod.y[UC.schedule.GUDTS])  annotation (Placement(transformation(extent={{44,-176},{64,-156}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_CHP_East1(y=aGC.P_sec_set[UC.schedule.GUDTS])
                                                                                            annotation (Placement(transformation(extent={{34,-190},{54,-170}})));
  TransiEnt.Producer.Electrical.Conventional.BlackCoal BlackCoal(
    isSecondaryControlActive=true,
    t_startup=0,
    P_init_set=UC.P_init[UC.schedule.BC]) annotation (Placement(transformation(extent={{149,-15},{189,23}})));
  Modelica.Blocks.Sources.RealExpression P_set_BC(y=mod.y[UC.schedule.BC])         annotation (Placement(transformation(extent={{142,30},{162,50}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_BC(y=aGC.P_sec_set[UC.schedule.BC])
                                                          annotation (Placement(transformation(extent={{124,16},{144,36}})));
  TransiEnt.Producer.Electrical.Conventional.Gasturbine Gasturbine3(
    isPrimaryControlActive=false,
    isSecondaryControlActive=true,
    t_startup=0,
    P_el_n=simCenter.generationPark.P_el_n_GT3,
    P_init_set=UC.P_init[UC.schedule.GT3]) annotation (Placement(transformation(extent={{49,-125},{89,-87}})));
  Modelica.Blocks.Sources.RealExpression P_set_GT3(y=mod.y[UC.schedule.GT3]) annotation (Placement(transformation(extent={{90,-84},{70,-64}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_GT1(y=aGC.P_sec_set[UC.schedule.GT3])
                                                          annotation (Placement(transformation(extent={{32,-86},{52,-66}})));
  TransiEnt.Producer.Electrical.Conventional.Gasturbine Gasturbine1(
    isPrimaryControlActive=false,
    isSecondaryControlActive=true,
    t_startup=0,
    P_init_set=UC.P_init[UC.schedule.GT1],
    P_el_n=simCenter.generationPark.P_el_n_GT1) annotation (Placement(transformation(extent={{-103,-127},{-63,-89}})));
  Modelica.Blocks.Sources.RealExpression P_set_SB_GT2(
                                                     y=aGC.P_sec_set[UC.schedule.GT1])
                                                          annotation (Placement(transformation(extent={{-120,-88},{-100,-68}})));
  Modelica.Blocks.Sources.RealExpression P_set_GT1(y=mod.y[UC.schedule.GT1]) annotation (Placement(transformation(extent={{-62,-86},{-82,-66}})));
  Modelica.Blocks.Sources.RealExpression P_residual_pred(y=-sum(UC.schedule.y[simCenter.generationPark.isMOD])) "All disponible plants (Conventional apart from Pumped Storage and CHP)"
                                                                                     annotation (Placement(transformation(extent={{-266,-2},{-246,18}})));

  Modelica.Blocks.Sources.RealExpression P_RE_Pred(y=-sum(UC.schedule.y[UC.schedule.ROH:UC.schedule.WindOff])) annotation (Placement(transformation(extent={{170,136},{190,156}})));

function plotResult

  constant String resultFileName = "ElectricGrid.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
  createPlot(id=1, position={0, 0, 805, 842}, y={"modelStatistics.electricPower.P_gen_total", "modelStatistics.electricPower.P_demand","modelStatistics.electricPower.P_residual_pos","modelStatistics.electricPower.P_conventional_with_CHP"}, filename=resultFileName);
  createPlot(id=2, position={0, 0, 805, 418}, y={"P_12.epp_IN.f"}, filename=resultFileName);
  createPlot(id=3, position={821, 439, 804, 403}, y={"P_RE_curtailement.P_el_out", "P_RE_curtailement.P_el_in","P_RE_Pred.y"}, range={0.0, 90000.0, 400000000.0, 1400000000.0},  colors={{0,140,72}, {28,108,200}});
  createPlot(id=3, position={821, 439, 804, 403}, y={"P_RE_curtailement.P_el_out", "P_RE_curtailement.P_el_in","P_RE_Pred.y"}, range={0.0, 90000.0, 400000000.0, 1400000000.0});
  createPlot(id=4, position={821, 0, 804, 405}, y={"WW1.P_set_star", "WW1.P_set_star_sched", "WW1.P_star"}, range={0.0, 90000.0, 0.5, 1.05}, colors={{28,108,200}, {238,46,47}, {0,140,72}});

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;

  TransiEnt.Basics.Tables.GenericDataTable normalizedWindPredictionError(
    relativepath="electricity/NormalisedWindPredictionError_900s.txt",
    constantfactor=1,
    startTime=t_start_set.k) annotation (Placement(transformation(extent={{-228,106},{-208,126}})));
  Modelica.Blocks.Sources.RealExpression e_wind_prediction_on(y=(normalizedWindPredictionError.y1 + 0.11/100)*simCenter.generationPark.P_el_n_WindOn) annotation (Placement(transformation(extent={{-162,100},{-142,120}})));
  Modelica.Blocks.Sources.RealExpression e_wind_prediction_off(y=(normalizedWindPredictionError2.y1 + 0.11/100)*simCenter.generationPark.P_el_n_WindOff) annotation (Placement(transformation(extent={{-160,84},{-140,104}})));
  TransiEnt.Basics.Tables.GenericDataTable normalizedWindPredictionError2(
    constantfactor=1,
    relativepath="electricity/NormalisedWindPredictionError2_900s.txt",
    startTime=t_start_set.k) annotation (Placement(transformation(extent={{-198,106},{-178,126}})));
  TransiEnt.Basics.Tables.GenericDataTable ThermalUnitCommitment(
    multiple_outputs=true,
    startTime=t_start_set.k,
    relativepath="heat/ThermalUnitCommitmentSchedule_3600s_REF35.txt",
    constantfactor=-1,
    columns=2:4) "Q_flow_set for WT / WW1 / WW2" annotation (Placement(transformation(extent={{-132,-226},{-112,-206}})));
  TransiEnt.Grid.Electrical.EconomicDispatch.DiscretizePrediction discretizePrediction(t_shift=0, samplePeriod=900) annotation (Placement(transformation(extent={{-206,-24},{-186,-4}})));
  TransiEnt.Grid.Electrical.EconomicDispatch.LoadPredictionAdaption H_lpa(P_lpa_init=sum(P_init_set.k[simCenter.generationPark.isMOD])) annotation (Placement(transformation(extent={{-242,-24},{-222,-4}})));
  TransiEnt.Grid.Electrical.UnitCommitment.BinaryScheduleDataTable UC(
    t_start=t_start_set.k,
    P_init=P_init_set.k,
    unit_mustrun=fill(false, simCenter.generationPark.nDispPlants),
    unit_blocked=cat(
        1,
        fill(false, simCenter.generationPark.nDispPlants - 2),
        {true,true}),
    reserveAllocation(
      relativepath="electricity/UnitCommitmentSchedules/ReservePowerCommitmentSchedule_3600s_REF35.txt",
      smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
      use_absolute_path=false),
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
      use_absolute_path=false,
      smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1,
      columns=(2:simCenter.generationPark.nPlants + 1))) annotation (Placement(transformation(extent={{-192,14},{-172,34}})));
  Modelica.Blocks.Sources.RealExpression P_residual_pred_1h(y=-sum(UC.prediction.y[simCenter.generationPark.isMOD]))
                                                                                          annotation (Placement(transformation(extent={{-228,4},{-208,24}})));
  TransiEnt.Grid.Electrical.EconomicDispatch.MeritOrderDispatcher mod(
    ntime=discretizePrediction.ntime,
    samplePeriod=discretizePrediction.samplePeriod,
    useVarLimits=true,
    P_init(displayUnit="W") = P_init_set.k[simCenter.generationPark.isMOD],
    nVarLimits=size(simCenter.generationPark.isCHP, 1),
    iVarLimits=simCenter.generationPark.isCHP,
    startTime=discretizePrediction.samplePeriod,
    P_max_var={WT.pQDiagram.P_max,WW1.pQDiagram.P_max},
    P_min_var={WT.pQDiagram.P_min,WW1.pQDiagram.P_min}) annotation (Placement(transformation(extent={{-170,-28},{-146,-2}})));

  TransiEnt.Producer.Electrical.Wind.WindProfiles.WindProfileLoader P_wind_off_is(
    P_el_n=simCenter.generationPark.P_el_n_WindOff,
    change_of_sign=true,
    REProfile=TransiEnt.Producer.Electrical.Wind.WindProfiles.WindData.Wind2015_TenneT_Offshore_900s,
    startTime=t_start_set.k) annotation (Placement(transformation(extent={{-74,132},{-56,146}})));
  TransiEnt.Producer.Electrical.Wind.WindProfiles.WindProfileLoader P_wind_on_is(
    REProfile=TransiEnt.Producer.Electrical.Wind.WindProfiles.WindData.Wind2015_TenneT_Onshore_900s,
    P_el_n=simCenter.generationPark.P_el_n_WindOn,
    change_of_sign=true,
    startTime=t_start_set.k) annotation (Placement(transformation(extent={{-20,134},{-4,148}})));
  TransiEnt.Producer.Electrical.Photovoltaics.PVProfiles.SolarProfileLoader P_PV_is(
    REProfile=TransiEnt.Producer.Electrical.Photovoltaics.PVProfiles.SolarData.Solar2015_Gesamt_900s,
    P_el_n=simCenter.generationPark.P_el_n_PV,
    change_of_sign=true,
    startTime=t_start_set.k) annotation (Placement(transformation(extent={{42,134},{56,146}})));
  TransiEnt.Basics.Tables.GenericDataTable normalizedPVPredictionError(
    relativepath="electricity/NormalisedWindPredictionError_900s.txt",
    constantfactor=1,
    startTime=t_start_set.k) annotation (Placement(transformation(extent={{-228,74},{-208,94}})));
  Modelica.Blocks.Sources.RealExpression e_pv_prediction(y=normalizedPVPredictionError.y1*simCenter.generationPark.P_el_n_PV)                            annotation (Placement(transformation(extent={{-160,66},{-140,86}})));
  TransiEnt.Basics.Tables.ElectricGrid.ElectricityDemand_HH_900s_2012 P_Load(startTime=t_start_set.k) annotation (Placement(transformation(extent={{280,-8},{260,12}})));
  TransiEnt.Producer.Combined.LargeScaleCHP.CHP WT(
    P_el_init=UC.P_init[UC.schedule.WT],
    isSecondaryControlActive=true,
    P_el_n=simCenter.generationPark.P_el_n_WT,
    PQCharacteristics=TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_WT()) "Tiefstack" annotation (Placement(transformation(extent={{-17,-223},{23,-185}})));

  TransiEnt.Producer.Combined.LargeScaleCHP.CHP WW1(
    P_el_init=UC.P_init[UC.schedule.WW1],
    isSecondaryControlActive=true,
    P_el_n=simCenter.generationPark.P_el_n_WW1,
    PQCharacteristics=TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_CCPGeneric(k_Q_flow=1/220e6, k_P_el=simCenter.generationPark.P_el_n_WW1)) "CHP Wedel 1" annotation (Placement(transformation(extent={{-95,-225},{-55,-187}})));
  TransiEnt.Producer.Combined.LargeScaleCHP.CHP GUDTS(
    isSecondaryControlActive=true,
    P_el_n=simCenter.generationPark.P_el_n_GUDTS,
    P_el_init=UC.P_init[UC.schedule.GUDTS],
    PQCharacteristics=TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_CCPGeneric(k_Q_flow=1/GUDTS.Q_flow_n_CHP, k_P_el=GUDTS.P_el_n),
    Q_flow_n_CHP=180e6) "Combined cycle plant Tiefstack" annotation (Placement(transformation(extent={{61,-219},{101,-181}})));

  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_hxim_flow massflow_Tm_flow3(boundaryConditions(m_flow_const=1000, h_const=4.2e3*60), variable_m_flow=false) annotation (Placement(transformation(
        extent={{-4,-3},{4,3}},
        rotation=90,
        origin={-46,-220})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_phxi massflow_Tm_flow1(boundaryConditions(p_const=12e5)) annotation (Placement(transformation(
        extent={{-4,-3},{4,3}},
        rotation=180,
        origin={-42,-206})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_hxim_flow massflow_Tm_flow2(variable_m_flow=false, boundaryConditions(m_flow_const=1000, h_const=4.2e3*60)) annotation (Placement(transformation(
        extent={{-4,-3},{4,3}},
        rotation=90,
        origin={36,-218})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_phxi massflow_Tm_flow4(boundaryConditions(p_const=12e5)) annotation (Placement(transformation(
        extent={{4,-3},{-4,3}},
        rotation=180,
        origin={38,-204})));
  Modelica.Blocks.Sources.RealExpression Q_flow_set_CHP_West(y=ThermalUnitCommitment.y[2]) annotation (Placement(transformation(extent={{-84,-184},{-64,-164}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_set_CHP_East(y=ThermalUnitCommitment.y[1]) annotation (Placement(transformation(extent={{-6,-184},{14,-164}})));
  Modelica.Blocks.Sources.RealExpression P_set_WT1(y=0)                        annotation (Placement(transformation(extent={{74,-176},{94,-156}})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_hxim_flow massflow_Tm_flow5(variable_m_flow=false, boundaryConditions(m_flow_const=1000, h_const=4.2e3*60)) annotation (Placement(transformation(
        extent={{-4,-3},{4,3}},
        rotation=90,
        origin={114,-212})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_phxi massflow_Tm_flow6(boundaryConditions(p_const=12e5)) annotation (Placement(transformation(
        extent={{-4,-3},{4,3}},
        rotation=180,
        origin={118,-198})));
equation
  connect(UCTE.epp,P_12. epp_OUT) annotation (Line(
      points={{257,-131},{257,-131.5},{251.13,-131.5}},
      color={0,135,135},
      thickness=0.5));
  connect(P_set_BM.y,Biomass. P_el_set) annotation (Line(points={{91,38},{96,38},{96,20.81}}, color={0,0,127}));
  connect(P_set_Offshore.y,WindOffshorePlant. P_el_set) annotation (Line(points={{-87,134},{-80,134},{-82,126.81}},    color={0,0,127}));
  connect(P_set_Onshore.y,WindOnshorePlant. P_el_set) annotation (Line(points={{-29,132},{-22,132},{-22,126.81}},    color={0,0,127}));
  connect(P_set_PV.y,PVPlant. P_el_set) annotation (Line(points={{31,132},{38,132},{38,126.81}},    color={0,0,127}));
  connect(P_set_ROH.y,RunOfWaterPlant. P_el_set) annotation (Line(points={{91,132},{91,132},{98,132},{98,126.81}}, color={0,0,127}));
  connect(P_set_BCG.y,BrownCoal. P_el_set) annotation (Line(points={{-91,38},{-82,38},{-82,20.81}},    color={0,0,127}));
  connect(P_set_OIL.y,OIL. P_el_set) annotation (Line(points={{-33,38},{-22,38},{-22,20.81}},    color={0,0,127}));
  connect(P_set_GAR.y,GAR. P_el_set) annotation (Line(points={{27,38},{38,38},{38,20.81}},    color={0,0,127}));
  connect(P_set_SB_CCP.y,CCP. P_SB_set) annotation (Line(points={{-181,-82},{-170.8,-82},{-170.8,-89.09}}, color={0,0,127}));
  connect(P_set_CCP.y,CCP. P_el_set) annotation (Line(points={{-159,-70},{-156,-70},{-156,-72},{-156,-87.19}}, color={0,0,127}));
  connect(P_set_GT2.y, Gasturbine2.P_el_set) annotation (Line(points={{-7,-76},{-10,-76},{-10,-89.19}}, color={0,0,127}));
  connect(P_set_Curt.y,P_RE_curtailement. u) annotation (Line(points={{155,132},{160,132},{167,132},{167,123.58}},
                                                                                                  color={0,0,127}));
  connect(WindOffshorePlant.epp,P_RE_curtailement. epp_in) annotation (Line(
      points={{-61,121.3},{-48,121.3},{-48,118},{-48,72},{136,72},{136,108},{147,108}},
      color={0,135,135},
      thickness=0.5));
  connect(WindOnshorePlant.epp,P_RE_curtailement. epp_in) annotation (Line(
      points={{-1,121.3},{2,121.3},{2,118},{14,118},{14,72},{136,72},{136,108},{147,108}},
      color={0,135,135},
      thickness=0.5));
  connect(PVPlant.epp,P_RE_curtailement. epp_in) annotation (Line(
      points={{59,121.3},{70,121.3},{70,118},{70,72},{136,72},{136,108},{147,108}},
      color={0,135,135},
      thickness=0.5));
  connect(RunOfWaterPlant.epp,P_RE_curtailement. epp_in) annotation (Line(
      points={{119,121.3},{136,121.3},{136,116},{136,108},{147,108}},
      color={0,135,135},
      thickness=0.5));
  connect(P_RE_curtailement.epp_out,Demand. epp) annotation (Line(
      points={{186.6,108},{208,108},{208,104},{208,-36},{227.4,-36}},
      color={0,135,135},
      thickness=0.5));
  connect(BrownCoal.epp,Demand. epp) annotation (Line(
      points={{-61,15.3},{-50,15.3},{-50,-36},{227.4,-36}},
      color={0,135,135},
      thickness=0.5));
  connect(OIL.epp,Demand. epp) annotation (Line(
      points={{-1,15.3},{8,15.3},{8,-36},{227.4,-36}},
      color={0,135,135},
      thickness=0.5));
  connect(GAR.epp,Demand. epp) annotation (Line(
      points={{59,15.3},{70,15.3},{70,-36},{227.4,-36}},
      color={0,135,135},
      thickness=0.5));
  connect(Biomass.epp,Demand. epp) annotation (Line(
      points={{117,15.3},{124,15.3},{124,-36},{227.4,-36}},
      color={0,135,135},
      thickness=0.5));
  connect(Gasturbine2.epp, Demand.epp) annotation (Line(
      points={{11,-94.7},{28,-94.7},{28,-36},{227.4,-36}},
      color={0,135,135},
      thickness=0.5));
  connect(PumpedStorage.epp,Demand. epp) annotation (Line(
      points={{173,-94.7},{173,-98},{208,-98},{208,-36},{227.4,-36}},
      color={0,135,135},
      thickness=0.5));
  connect(P_12.epp_IN,PumpedStorage. epp) annotation (Line(
      points={{224.16,-131.5},{214,-131.5},{214,-98},{173,-98},{173,-94.7}},
      color={0,135,135},
      thickness=0.5));
  connect(P_set_SB_PS.y,PumpedStorage. P_SB_set) annotation (Line(points={{129,-86},{132,-86},{137.2,-86},{137.2,-91.09}},
                                                                                                    color={0,0,127}));
  connect(P_set_PS.y,PumpedStorage. P_el_set) annotation (Line(points={{151,-72},{151,-72},{152,-72},{152,-89.19}},
                                                                                                  color={0,0,127}));
  connect(P_tieline_set.y, aGC.P_tie_set) annotation (Line(points={{-191,-224},{-191,-224},{-195.02,-224},{-195.02,-215}},
                                                                                                    color={0,0,127}));
  connect(P_tieline_is.y, aGC.P_tie_is) annotation (Line(points={{-219,-224},{-219,-224},{-210.6,-224},{-210.6,-215}},
                                                                                                    color={0,0,127}));
  connect(P_set_SB_BCG.y, BrownCoal.P_SB_set) annotation (Line(points={{-99,24},{-98,24},{-98,18.91},{-96.8,18.91}},     color={0,0,127}));
  connect(P_set_SB_OIL.y, OIL.P_SB_set) annotation (Line(points={{-43,24},{-38,24},{-38,18.91},{-36.8,18.91}}, color={0,0,127}));
  connect(P_set_SB_GAR.y, GAR.P_SB_set) annotation (Line(points={{17,24},{23.2,24},{23.2,18.91}},    color={0,0,127}));
  connect(P_set_SB_BM.y, Biomass.P_SB_set) annotation (Line(points={{75,24},{78,24},{78,18.91},{81.2,18.91}}, color={0,0,127}));
  connect(P_set_BC.y,BlackCoal. P_el_set) annotation (Line(points={{163,40},{166,40},{166,22.81}}, color={0,0,127}));
  connect(P_set_SB_BC.y,BlackCoal. P_SB_set) annotation (Line(points={{145,26},{145,26},{151.2,26},{151.2,20.91}},     color={0,0,127}));
  connect(BlackCoal.epp, Demand.epp) annotation (Line(
      points={{187,17.3},{198,17.3},{198,-36},{227.4,-36}},
      color={0,135,135},
      thickness=0.5));
  connect(P_set_SB_GT.y, Gasturbine2.P_SB_set) annotation (Line(points={{-23,-78},{-16,-78},{-16,-86},{-24,-86},{-24,-91.09},{-24.8,-91.09}}, color={0,0,127}));
  connect(P_set_GT3.y, Gasturbine3.P_el_set) annotation (Line(points={{69,-74},{66,-74},{66,-87.19}}, color={0,0,127}));
  connect(P_set_SB_GT1.y, Gasturbine3.P_SB_set) annotation (Line(points={{53,-76},{60,-76},{60,-84},{52,-84},{52,-89.09},{51.2,-89.09}}, color={0,0,127}));
  connect(Gasturbine3.epp, Demand.epp) annotation (Line(
      points={{87,-92.7},{92,-92.7},{92,-96},{104,-96},{104,-36},{227.4,-36}},
      color={0,135,135},
      thickness=0.5));
  connect(CCP.epp, Demand.epp) annotation (Line(
      points={{-135,-92.7},{-132,-92.7},{-132,-94},{-126,-94},{-126,-36},{227.4,-36}},
      color={0,135,135},
      thickness=0.5));
  connect(P_set_GT1.y, Gasturbine1.P_el_set) annotation (Line(points={{-83,-76},{-86,-76},{-86,-89.19}}, color={0,0,127}));
  connect(P_set_SB_GT2.y, Gasturbine1.P_SB_set) annotation (Line(points={{-99,-78},{-92,-78},{-92,-86},{-100,-86},{-100,-91.09},{-100.8,-91.09}}, color={0,0,127}));
  connect(Gasturbine1.epp, Demand.epp) annotation (Line(
      points={{-65,-94.7},{-50,-94.7},{-50,-36},{227.4,-36}},
      color={0,135,135},
      thickness=0.5));
  connect(aGC.epp, Demand.epp) annotation (Line(
      points={{-203,-178},{-152,-178},{-152,-148},{-50,-148},{-50,-36},{227.4,-36}},
      color={0,135,135},
      thickness=0.5));

  connect(P_sec_pos.y, aGC.P_SB_max_pos) annotation (Line(points={{-231,-188},{-221.24,-188},{-221.24,-189.1}}, color={0,0,127}));
  connect(P_sec_neg.y, aGC.P_SB_max_neg) annotation (Line(points={{-233,-204},{-221.24,-204},{-221.24,-203.9}}, color={0,0,127}));
  connect(discretizePrediction.P_predictions, mod.u) annotation (Line(points={{-185,-14},{-172.4,-14},{-172.4,-15}},
                                                                                                    color={0,0,127}));
  connect(H_lpa.y,discretizePrediction. P_is) annotation (Line(points={{-221,-14},{-215.5,-14},{-208,-14}},
                                                                                                    color={0,0,127}));
  connect(UC.P_sec_pos[simCenter.generationPark.isMOD], mod.P_R_pos) annotation (Line(points={{-170.7,21.4},{-162.8,21.4},{-162.8,0.6}},  color={0,0,127}));
  connect(UC.P_sec_neg[simCenter.generationPark.isMOD], mod.P_R_neg) annotation (Line(points={{-170.7,16.8},{-153.2,16.8},{-153.2,0.6}},  color={0,0,127}));
  connect(P_residual_pred_1h.y,discretizePrediction. P_prediction) annotation (Line(points={{-207,14},{-196,14},{-196,-2}}, color={0,0,127}));
  connect(UC.z[simCenter.generationPark.isMOD], mod.z) annotation (Line(points={{-170.7,28},{-142,28},{-142,-36},{-158,-36},{-158,-30.6}},     color={255,0,255}));
  connect(P_residual_pred.y, H_lpa.P_load_pred) annotation (Line(points={{-245,8},{-232,8},{-232,-2}}, color={0,0,127}));
  connect(P_residual_is.y, H_lpa.P_load_is) annotation (Line(points={{-251,-14},{-244,-14}}, color={0,0,127}));
  connect(P_Load.y1, Demand.P_el_set) annotation (Line(points={{259,2},{247,2},{247,-13.96}},     color={0,0,127}));
  connect(WW1.outlet,massflow_Tm_flow1. fluidPortIn) annotation (Line(
      points={{-54.6,-210.117},{-50,-210.117},{-50,-206},{-46,-206}},
      color={175,0,0},
      thickness=0.5));
  connect(massflow_Tm_flow3.fluidPortOut,WW1. inlet) annotation (Line(
      points={{-46,-216},{-48,-216},{-48,-214.55},{-54.6,-214.55}},
      color={0,131,169},
      thickness=0.5));
  connect(WT.inlet,massflow_Tm_flow2. fluidPortOut) annotation (Line(
      points={{23.4,-212.55},{36,-212.55},{36,-214}},
      color={175,0,0},
      thickness=0.5));
  connect(WT.outlet,massflow_Tm_flow4. fluidPortIn) annotation (Line(
      points={{23.4,-208.117},{30,-208.117},{30,-204},{42,-204}},
      color={175,0,0},
      thickness=0.5));
  connect(WW1.epp, Demand.epp) annotation (Line(
      points={{-56,-200.3},{-50,-200.3},{-50,-36},{227.4,-36}},
      color={0,135,135},
      thickness=0.5));
  connect(WT.epp, Demand.epp) annotation (Line(
      points={{22,-198.3},{28,-198.3},{28,-190},{28,-36},{227.4,-36}},
      color={0,135,135},
      thickness=0.5));
  connect(GUDTS.epp, Demand.epp) annotation (Line(
      points={{100,-194.3},{104,-194.3},{104,-36},{227.4,-36}},
      color={0,135,135},
      thickness=0.5));
  connect(WW1.P_set, P_set_CHP_West.y) annotation (Line(points={{-87.2,-191.433},{-87.2,-184},{-80,-184},{-80,-172},{-87,-172}}, color={0,0,127}));
  connect(WW1.P_SB_set, P_set_SB_CHP_West.y) annotation (Line(points={{-92.8,-195.075},{-92.8,-182},{-113,-182}}, color={0,0,127}));
  connect(WT.P_SB_set, P_set_SB_CHP_East.y) annotation (Line(points={{-14.8,-193.075},{-14.8,-182},{-25,-182}}, color={0,0,127}));
  connect(WT.P_set, P_set_CHP_East.y) annotation (Line(points={{-9.2,-189.433},{-9.2,-180},{-2,-180},{-2,-168},{-9,-168}}, color={0,0,127}));
  connect(GUDTS.P_SB_set, P_set_SB_CHP_East1.y) annotation (Line(points={{63.2,-189.075},{63.2,-180},{55,-180}}, color={0,0,127}));
  connect(Q_flow_set_CHP_West.y, WW1.Q_flow_set) annotation (Line(points={{-63,-174},{-58,-174},{-58,-184},{-67.6,-184},{-67.6,-191.433}}, color={0,0,127}));
  connect(Q_flow_set_CHP_East.y, WT.Q_flow_set) annotation (Line(points={{15,-174},{16,-174},{16,-182},{10.4,-182},{10.4,-189.433}},
                                                                                                                                   color={0,0,127}));
  connect(P_set_WT.y, GUDTS.P_set) annotation (Line(points={{65,-166},{68.8,-166},{68.8,-185.433}}, color={0,0,127}));
  connect(P_set_WT1.y, GUDTS.Q_flow_set) annotation (Line(points={{95,-166},{96,-166},{96,-176},{88.4,-176},{88.4,-185.433}}, color={0,0,127}));
  connect(GUDTS.inlet, massflow_Tm_flow5.fluidPortOut) annotation (Line(
      points={{101.4,-208.55},{110,-208.55},{110,-208},{114,-208}},
      color={175,0,0},
      thickness=0.5));
  connect(GUDTS.outlet, massflow_Tm_flow6.fluidPortIn) annotation (Line(
      points={{101.4,-204.117},{108,-204.117},{108,-198},{114,-198}},
      color={175,0,0},
      thickness=0.5));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-300,-240},{300,160}}), graphics={
        Rectangle(
          extent={{-120,158},{200,66}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash),
        Rectangle(
          extent={{-126,60},{200,-28}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash),
        Rectangle(
          extent={{-216,-48},{188,-138}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash),
        Rectangle(
          extent={{-216,-162},{112,-240}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash),
        Text(
          extent={{-134,-156},{-64,-166}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash,
          textString="Combined Heat and Power"),
        Rectangle(
          extent={{218,-106},{298,-160}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash),
        Text(
          extent={{216,-106},{272,-114}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash,
          textString="Surrounding grid"),
        Text(
          extent={{-122,60},{-50,48}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash,
          textString="Base Load Power Plants"),
        Text(
          extent={{-214,-46},{-136,-62}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash,
          textString="Mid- and Peakload Plants"),
        Text(
          extent={{-114,156},{-42,144}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash,
          textString="Fluctuating Renewables"),
        Rectangle(
          extent={{218,10},{294,-66}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash),
        Text(
          extent={{198,8},{254,0}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash,
          textString="Load"),
        Text(
          extent={{-262,-152},{-194,-164}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash,
          textString="Control Power dispatch"),
        Rectangle(
          extent={{-268,-152},{-164,-234}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash),
        Text(
          extent={{-272,46},{-204,34}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash,
          textString="Economic Dispatch"),
        Rectangle(
          extent={{-278,44},{-140,-38}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash),
        Text(
          extent={{-236,138},{-180,130}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash,
          textString="Prediction Errors"),
        Rectangle(
          extent={{-236,140},{-132,62}},
          lineColor={175,175,175},
          pattern=LinePattern.Dash)}),
    experiment(
      StopTime=18000,
      Interval=900,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(events=false),
    Icon(graphics,
         coordinateSystem(extent={{-300,-240},{300,160}})),
    __Dymola_Commands(executeCall=TransiEnt.Examples.Hamburg.ElectricGenerationPark.plotResult() "Plot example results"),
    __Dymola_experimentFlags(
      Advanced(
        EvaluateAlsoTop=false,
        GenerateVariableDependencies=false,
        OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false),
    Documentation(info="<html>
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
end ElectricGrid;
