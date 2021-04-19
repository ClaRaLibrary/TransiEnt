within TransiEnt.Examples.Coupled;
model Coupled_LargeScale "Coupled small-scale example with CPP and meshed electric power grid"
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
  extends TransiEnt.Basics.Icons.Example;

 inner TransiEnt.SimCenter simCenter(
    p_eff_2=1150000,
    initOptionGasPipes=201,
    roughnessGasPipes=0.2e-3,
    tableInterpolationSmoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2,
    useHomotopy=true,
    v_n=110e3,
    ambientConditions(
      redeclare TransiEnt.Basics.Tables.Ambient.GHI_Hamburg_3600s_2012_TMY globalSolarRadiation(startTime=0),
      redeclare TransiEnt.Basics.Tables.Ambient.DNI_Hamburg_3600s_2012_TMY directSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DHI_Hamburg_3600s_2012_TMY diffuseSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_Fuhlsbuettel_3600s_2012 temperature,
      redeclare TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_3600s_TMY wind),
    variableCompositionEntriesGasPipes={7})                                   annotation (Placement(transformation(extent={{-562,140},{-542,160}})));

  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-540,140},{-520,160}})));

 // _____________________________________________
  //
  //              Gas Sector
  // _____________________________________________


  // Sensors
  TransiEnt.Components.Sensors.RealGas.PressureSensor pressureSensor_nw annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-110,134})));
  TransiEnt.Components.Sensors.RealGas.PressureSensor pressureSensor_se annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={102,51})));
  TransiEnt.Components.Sensors.RealGas.PressureSensor pressureSensor_ne annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={84,134})));

  TransiEnt.Components.Sensors.RealGas.GCVSensor gCVSensor_nw annotation (Placement(transformation(extent={{-120,124},{-140,144}})));
  TransiEnt.Components.Sensors.RealGas.GCVSensor gCVSensor_ne annotation (Placement(transformation(extent={{102,124},{122,144}})));
  TransiEnt.Components.Sensors.RealGas.GCVSensor gCVSensor_se annotation (Placement(transformation(extent={{116,41},{136,61}})));
  TransiEnt.Components.Sensors.RealGas.GCVSensor gCVSensor_CHP annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={88,-38})));

  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensor(compositionDefinedBy=2) annotation (Placement(transformation(extent={{-122,41},{-102,61}})));
  TransiEnt.Components.Sensors.RealGas.PressureSensor pressureSensor_CHP annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={88,-4})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massFlowSensor annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={88,18})));

  // Pipes and Fittings
 Modelica.Blocks.Sources.Constant pipeDiameter(k=0.32) annotation (Placement(transformation(extent={{-34,140},{-14,160}})));
  Modelica.Blocks.Sources.Constant scaleFactorPipeLength(k=1) annotation (Placement(transformation(extent={{-2,140},{18,160}})));

  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_isoth pipe_e(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    redeclare model PressureLoss = TransiEnt.Components.Gas.VolumesValvesFittings.Base.PhysicalPL_L4_constVisc,
    m_flow_nom=1,
    diameter_i=pipeDiameter.k,
    p_start=ones(pipe_e.N_cv)*(simCenter.p_amb_const + simCenter.p_eff_2),
    showExpertSummary=true,
    length=5000*scaleFactorPipeLength.k,
    N_cv=1,
    Delta_p_nom=2000) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={20,81})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_isoth pipe_n(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    redeclare model PressureLoss = TransiEnt.Components.Gas.VolumesValvesFittings.Base.PhysicalPL_L4_constVisc,
    diameter_i=pipeDiameter.k,
    p_start=ones(pipe_n.N_cv)*(simCenter.p_amb_const + simCenter.p_eff_2),
    showExpertSummary=true,
    length=10000*scaleFactorPipeLength.k,
    N_cv=1,
    h_nom=ones(pipe_n.N_cv)*(-4667),
    m_flow_nom=1,
    Delta_p_nom=2000) annotation (Placement(transformation(extent={{-26,119},{2,129}})));
 TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_isoth pipe_w(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    m_flow_nom=1,
    diameter_i=pipeDiameter.k,
    p_start=ones(pipe_w.N_cv)*(simCenter.p_amb_const + simCenter.p_eff_2),
    showExpertSummary=true,
    length=8000*scaleFactorPipeLength.k,
    N_cv=1,
    redeclare model PressureLoss = TransiEnt.Components.Gas.VolumesValvesFittings.Base.PhysicalPL_L4_constVisc,
    Delta_p_nom=1000) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={-50,81})));
 TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_isoth pipe_sw(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    m_flow_nom=1,
    diameter_i=0.45,
    p_start=ones(pipe_sw.N_cv)*(simCenter.p_amb_const + simCenter.p_eff_2),
    showExpertSummary=true,
    length=8000*scaleFactorPipeLength.k,
    N_cv=1,
    redeclare model PressureLoss = TransiEnt.Components.Gas.VolumesValvesFittings.Base.PhysicalPL_L4_constVisc,
    Delta_p_nom=2000) annotation (Placement(transformation(extent={{-98,36},{-70,46}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_isoth pipe_s(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    m_flow_nom=1,
    diameter_i=pipeDiameter.k,
    p_start=ones(pipe_s.N_cv)*(simCenter.p_amb_const + simCenter.p_eff_2),
    showExpertSummary=true,
    length=7000*scaleFactorPipeLength.k,
    N_cv=1,
    redeclare model PressureLoss = TransiEnt.Components.Gas.VolumesValvesFittings.Base.PhysicalPL_L4_constVisc,
    Delta_p_nom=2000) annotation (Placement(transformation(extent={{-24,36},{4,46}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_isoth pipe_se(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    m_flow_nom=1,
    diameter_i=pipeDiameter.k,
    p_start=ones(pipe_se.N_cv)*(simCenter.p_amb_const + simCenter.p_eff_2),
    showExpertSummary=true,
    length=5000*scaleFactorPipeLength.k,
    N_cv=1,
    redeclare model PressureLoss = TransiEnt.Components.Gas.VolumesValvesFittings.Base.PhysicalPL_L4_constVisc,
    Delta_p_nom=1000) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=0,
        origin={54,41})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_isoth pipe_ne(
    frictionAtInlet=true,
    frictionAtOutlet=false,
    m_flow_nom=1,
    diameter_i=pipeDiameter.k,
    p_start=ones(pipe_ne.N_cv)*(simCenter.p_amb_const + simCenter.p_eff_2),
    showExpertSummary=true,
    length=1000*scaleFactorPipeLength.k,
    N_cv=1,
    redeclare model PressureLoss = TransiEnt.Components.Gas.VolumesValvesFittings.Base.PhysicalPL_L4_constVisc,
    Delta_p_nom=1000) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=0,
        origin={52,124})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_isoth pipe_nw(
    frictionAtInlet=true,
    frictionAtOutlet=false,
    m_flow_nom=1,
    diameter_i=pipeDiameter.k,
    p_start=ones(pipe_nw.N_cv)*(simCenter.p_amb_const + simCenter.p_eff_2),
    showExpertSummary=true,
    length=3000*scaleFactorPipeLength.k,
    N_cv=1,
    redeclare model PressureLoss = TransiEnt.Components.Gas.VolumesValvesFittings.Base.PhysicalPL_L4_constVisc,
    Delta_p_nom=1000) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=180,
        origin={-80,124})));

  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2_isoth junction_FIS(volume=0.5) annotation (Placement(transformation(extent={{-144,51},{-124,31}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2_isoth junction_ne(volume=0.5) annotation (Placement(transformation(extent={{30,114},{10,134}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2_isoth junction_se(volume=0.5) annotation (Placement(transformation(extent={{10,51},{30,31}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2_isoth junction_nw(volume=0.5) annotation (Placement(transformation(extent={{-40,114},{-60,134}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2_isoth junction_sw(volume=0.5) annotation (Placement(transformation(extent={{-60,51},{-40,31}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2_isoth junction_seAtCHP(volume=0.5) annotation (Placement(transformation(extent={{73,36},{83,46}})));

  // Consumer
  TransiEnt.Consumer.Gas.GasConsumer_HFlow gasConsumer_nw annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-156,124})));

  // Source
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi source annotation (Placement(transformation(extent={{-214,33},{-194,53}})));

  Modelica.Blocks.Sources.RealExpression SetConsumption(y=3e15*1.7/31536000) annotation (Placement(transformation(extent={{-212,120},{-192,140}})));

  // _____________________________________________
  //
  //              Power Sector
  // _____________________________________________


  // Grid
  TransiEnt.Components.Electrical.Grid.PiModelComplex transmissionLine(
    ChooseVoltageLevel=3,
    l(displayUnit="km") = 50000,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L4) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-226,-84})));
  TransiEnt.Components.Electrical.PowerTransformation.TransformerComplex transformerConsumer(U_P=simCenter.v_n, U_S=30e3) annotation (Placement(transformation(extent={{-122,-6},{-110,6}})));
  TransiEnt.Components.Electrical.PowerTransformation.TransformerComplex transformerWindpark(U_P=simCenter.v_n, U_S=30e3) annotation (Placement(transformation(extent={{-120,-48},{-108,-36}})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex transmissionLine1(
    ChooseVoltageLevel=3,
    l=1000,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L4) annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=0,
        origin={-187,-42})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex transmissionLine2(
    ChooseVoltageLevel=3,
    l=1000,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L4) annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=0,
        origin={-187,0})));
  TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary complexPower(
    useInputConnectorP=false,
    P_el_set_const=0,
    useInputConnectorQ=false,
    Q_el_set_const=0,
    useCosPhi=false) annotation (Placement(transformation(extent={{-150,-16},{-142,-8}})));
  TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary complexPower1(
    useInputConnectorP=false,
    P_el_set_const=0,
    useInputConnectorQ=false,
    Q_el_set_const=0,
    useCosPhi=false) annotation (Placement(transformation(extent={{-148,-56},{-140,-48}})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex TransmissionLine(
    ChooseVoltageLevel=3,
    l=2000,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L4) annotation (Placement(transformation(extent={{-368,80},{-348,100}})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex TransmissionLine1(
    ChooseVoltageLevel=3,
    l=2000,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L4) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-410,60})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex TransmissionLine3(
    ChooseVoltageLevel=3,
    l=2000,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L4) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-410,-42})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex TransmissionLine4(
    ChooseVoltageLevel=3,
    l=2000,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L4) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-306,58})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex TransmissionLine5(
    ChooseVoltageLevel=3,
    l=2000,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L4) annotation (Placement(transformation(extent={{-366,-72},{-346,-52}})));
  TransiEnt.Components.Sensors.ElectricFrequencyComplex globalFrequency annotation (Placement(transformation(extent={{-394,114},{-406,126}})));
  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(extent={{-420,140},{-432,152}})));
  Modelica.Blocks.Sources.RealExpression globalFrequency_reference(y=simCenter.f_n) annotation (Placement(transformation(extent={{-368,136},{-404,154}})));
  Modelica.Blocks.Continuous.Integrator integrator(k=-7e3, use_reset=false)
                                                           annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=-90,
        origin={-443,123})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex TransmissionLine6(
    ChooseVoltageLevel=3,
    l=2000,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L4) annotation (Placement(transformation(extent={{-272,-10},{-252,10}})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex TransmissionLine2(
    ChooseVoltageLevel=3,
    l=2000,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L4) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-356,26})));
  TransiEnt.Components.Electrical.PowerTransformation.TransformerComplex transformerWindpark1(U_P=simCenter.v_n, U_S=110e3) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-306,114})));
  TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary complexPower2(
    useInputConnectorP=false,
    P_el_set_const=0,
    useInputConnectorQ=false,
    Q_el_set_const=0,
    useCosPhi=false) annotation (Placement(transformation(extent={{-286,86},{-278,94}})));

  // Consumer
  TransiEnt.Consumer.Electrical.ExponentialElectricConsumerComplex L0_SW(
    useInputConnectorP=true,
    f_n=50,
    P_n=50,
    Q_n=1,
    useCosPhi=true,
    cosphi_set=0.9,
    v_n=simCenter.v_n,
    variability(kpf=61.5e6))
                       annotation (Placement(transformation(extent={{-296,-72},{-276,-52}})));
  TransiEnt.Consumer.Electrical.Profiles.SLPLoader sLPLoader(standardLoadProfile=TransiEnt.Basics.Types.SLP.G0, annualDemand_in_kWh=6.66e8)    annotation (Placement(transformation(extent={{-346,-10},{-366,10}})));
  TransiEnt.Consumer.Electrical.Profiles.SLPLoader sLPLoader1(standardLoadProfile=TransiEnt.Basics.Types.SLP.L0, annualDemand_in_kWh=2.16e8)    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-260,-44})));
  TransiEnt.Consumer.Electrical.Profiles.SLPLoader sLPLoader2(standardLoadProfile=TransiEnt.Basics.Types.SLP.H0, annualDemand_in_kWh=6.3e7)     annotation (Placement(transformation(extent={{-28,4},{-48,24}})));

  TransiEnt.Consumer.Electrical.ExponentialElectricConsumerComplex H0_SE(
    useInputConnectorP=true,
    cosphi_set=0.95,
    v_n=30e3,
    variability(kpf=5.6e6)) annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));

 TransiEnt.Consumer.Electrical.ExponentialElectricConsumerComplex G0_NW(
    useInputConnectorP=true,
    f_n=50,
    P_n=50,
    Q_n=1,
    useCosPhi=true,
    cosphi_set=0.9,
    v_n=simCenter.v_n,
    variability(kpf=200e6))
                           annotation (Placement(transformation(extent={{-398,-24},{-378,-4}})));

  // Producer
  TransiEnt.Producer.Electrical.Others.Biomass biomass(
    integrateElPower=true,
    integrateCDE=false,
    redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
    isPrimaryControlActive=true,
    primaryBalancingController(
      plantType=TransiEnt.Basics.Types.ControlPlantType.Provided,
      providedDroop=0.03,
      maxValuePrCtrl=0.1,
      use_SlewRateLimiter=false),
    set_P_init=false,
    isSecondaryControlActive=true,
    isExternalSecondaryController=true,
    H=10,
    P_min_star=0,
    P_el_n=1e8,
    J=0,
    t_startup=0,
    t_min_operating=900,
    MinimumDownTime=900,
    T_plant=1,
    redeclare TransiEnt.Components.Electrical.Machines.SynchronousMachineComplex Generator(IsSlack=false, R_a=0),
    redeclare TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.SimpleExcitationSystem Exciter(v_n=110.03e3),
    Turbine(useSlewRateLimiter=false)) annotation (Placement(transformation(extent={{-446,74},{-426,94}})));

 TransiEnt.Producer.Electrical.Conventional.Garbage garbage(
    redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
    isPrimaryControlActive=true,
    isSecondaryControlActive=false,
    isExternalSecondaryController=false,
    primaryBalancingController(plantType=TransiEnt.Basics.Types.ControlPlantType.PeakLoad, providedDroop=0.1),
    P_init_set=10e6,
    H=12,
    t_startup=0,
    T_plant=1,
    redeclare TransiEnt.Components.Electrical.Machines.SynchronousMachineComplex Generator(IsSlack=true),
    P_min_star=0.0,
    P_el_n=8e7,
    redeclare TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.SimpleExcitationSystem Exciter,
    Turbine(useSlewRateLimiter=false)) annotation (Placement(transformation(extent={{-444,-80},{-424,-60}})));

  TransiEnt.Producer.Electrical.Photovoltaics.PhotovoltaicPlant photovoltaicPlant(
    redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
    A_module=105000,
    redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PVBoundary powerBoundary(
      useInputConnectorP=true,
      change_sign=false,
      v_gen=110e3) "PU-Boundary for ComplexPowerPort") annotation (Placement(transformation(extent={{-338,114},{-318,134}})));

   TransiEnt.Producer.Electrical.Wind.PowerCurveWindPlant windTurbine(
    height_data=175,
    height_hub=125,
    PowerCurveChar=TransiEnt.Producer.Electrical.Wind.Characteristics.SenvionM104_3400kW(),
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.WindOnshore,
    redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
    P_el_n=59500000,
    redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(
      useInputConnectorQ=false,
      cosphi_boundary=1,
      v_n=30e3) "Power Boundary for ComplexPowerPort") annotation (Placement(transformation(extent={{-68,-59},{-88,-39}})));
  Modelica.Blocks.Sources.RealExpression windSpeed(y=simCenter.ambientConditions.wind.value) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-42,-43})));
  Modelica.Blocks.Sources.RealExpression SetPower(y=(-((photovoltaicPlant.epp.P + windTurbine.epp.P + largeScaleCHP.epp.P)/(70e5 + 595e5 + 8e7)) - (0.15*(sLPLoader.y1 + sLPLoader1.y1 + sLPLoader2.y1)/(1e8)))*(1e6)) annotation (Placement(transformation(extent={{-212,96},{-192,116}})));

  TransiEnt.Grid.Electrical.EconomicDispatch.ControllerMeritOrderSimple controllerMeritOrderSimple(storageOrder={1,4,3,2}, T={0,100,0,0}) annotation (Placement(transformation(extent={{-492,-6},{-472,14}})));

  Modelica.Blocks.Sources.RealExpression P_el_CHP(y=largeScaleCHP.epp.P)  annotation (Placement(transformation(extent={{-556,-8},{-536,15}})));
  Modelica.Blocks.Sources.RealExpression P_Load(y=P_load) annotation (Placement(transformation(extent={{-522,-56},{-500,-32}})));
  Modelica.Blocks.Sources.RealExpression P_el_GAR(y=garbage.epp.P)  annotation (Placement(transformation(extent={{-556,-30},{-536,-7}})));
  Modelica.Blocks.Sources.RealExpression P_el_ren(y=P_gen_ren) annotation (Placement(transformation(extent={{-522,32},{-500,55}})));
  TransiEnt.Basics.Blocks.FilterPosNeg filterPosNeg2(onlyPositive=false) annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=0,
        origin={-454,-56})));

  // Storage
  Storage.Electrical.PumpedStorage_Generator PES(
    redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
    redeclare model StorageModel = TransiEnt.Storage.Base.GenericStorageHyst (
        T_plant=300,
        use_plantDynamic=true,
        relDeltaEnergyHystFull=0.10),
    StorageModelParams=TransiEnt.Storage.Electrical.Specifications.PumpedStorage(
        E_start=0.5*PES.StorageModelParams.E_max,
        E_max=6e12,
        P_max_unload=5e7,
        P_max_load=7e7),
    redeclare TransiEnt.Components.Electrical.Machines.SynchronousMachineComplex Generator,
    redeclare TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.SimpleExcitationSystem Exciter,
    J=2*PES.StorageModelParams.P_max_load*12/(2*simCenter.f_n*Modelica.Constants.pi)^2) annotation (Placement(transformation(extent={{-445,16},{-425,36}})));
  Modelica.Blocks.Sources.RealExpression P_el_PES(y=PES.epp.P) annotation (Placement(transformation(extent={{-556,12},{-534,36}})));

  // Variables
     Modelica.SIunits.Power P_load;
     Modelica.SIunits.Power P_gen_KW;
     Modelica.SIunits.Power P_gen_ren;
     Modelica.SIunits.Power P_gen_tot;

     Modelica.SIunits.Energy E_gen_tot;
     Modelica.SIunits.Energy E_gen_ren;
     Modelica.SIunits.Energy E_load;

  // _____________________________________________
  //
  //              Heat Sector
  // _____________________________________________

  //Sensors
  TransiEnt.Components.Sensors.TemperatureSensor tempAfterCons annotation (Placement(transformation(extent={{-372,-174},{-352,-158}})));
  TransiEnt.Components.Sensors.TemperatureSensor tempBeforeCons annotation (Placement(transformation(extent={{-286,-144},{-302,-128}})));

  // Hydraulic Components
  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_2 hEXHeatCons(
    redeclare model HeatTransfer = TransiEnt.Consumer.Heat.ThermalHeatConsumer_L3.HeatTransfer_EN442 (
        T_mean_supply=353.15,
        DT_nom=30,
        Q_flow_nom=ScaleFactor.k,
        T_air_nom=295.15),
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2,
    redeclare model Geometry = ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry (volume=1*ScaleFactor.k/1.81e6),
    m_flow_nom=ScaleFactor.k/4200/30,
    h_start=291204,
    p_start=6.0276e5,
    initOption=0) annotation (Placement(transformation(extent={{-382,-154},{-402,-134}})));

  TransiEnt.Components.Heat.PumpVLE_L1_simple pumpGrid(presetVariableType="m_flow", m_flowInput=true) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-334,-144})));
  TransiEnt.Components.Heat.PumpVLE_L1_simple pumpProd(presetVariableType="m_flow", m_flowInput=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-158,-175})));

  TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.HotWaterStorage_constProp_L4 hotWaterStorage(
    V=ScaleFactor.k*2*3600/(hotWaterStorage.c_v*hotWaterStorage.rho*(90 - 60)),
    h=(hotWaterStorage.V*4*5^2/Modelica.Constants.pi)^(1/3),
    T_start(displayUnit="degC") = {373.05,370.85,367.75,362.85,343.25}) annotation (Placement(transformation(
        extent={{13,-12},{-13,12}},
        rotation=0,
        origin={-229,-170})));
  TransiEnt.Components.Heat.Grid.IdealizedExpansionVessel idealizedExpansionVessel1(p(displayUnit="bar") = 600000) annotation (Placement(transformation(extent={{-254,-136},{-240,-120}})));

  ClaRa.Components.VolumesValvesFittings.Valves.ThreeWayValveVLE_L1_simple tWV(splitRatio_input=true) annotation (Placement(transformation(extent={{-276,-166},{-260,-182}})));
  ClaRa.Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y joinGrid(
    volume=0.1*ScaleFactor.k/1.81e6,
    m_flow_in_nom={ScaleFactor.k/4200/30,ScaleFactor.k/4200/30},
    h_start=356128,
    redeclare model PressureLossIn1 = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.NoFriction,
    redeclare model PressureLossIn2 = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.NoFriction,
    redeclare model PressureLossOut = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.NoFriction,
    p_start=6e5) annotation (Placement(transformation(extent={{-260,-136},{-278,-152}})));

  TransiEnt.Components.Heat.HeatFlowMultiplier heatFlowMultiplier1(factor=ScaleFactor.k/4793.46) annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={-392,-120})));
  TransiEnt.Components.Heat.HeatFlowMultiplier heatFlowMultiplier3(factor=2.785e8/4793.46) annotation (Placement(transformation(
        extent={{-7.5,-6},{7.5,6}},
        rotation=180,
        origin={154.5,90})));
  TransiEnt.Components.Heat.HeatFlowMultiplier heatFlowMultiplier2(factor=2.785e8/2/4793.46) annotation (Placement(transformation(
        extent={{-6.5,-7},{6.5,7}},
        rotation=180,
        origin={158.5,7})));

  //Control
 TransiEnt.Basics.Blocks.LimPID PID_TWV(
    Tau_d=0,
    initOption=503,
    y_max=1,
    y_min=0,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    k=10,
    Tau_i=0.01,
    y_start=1,
    y_inactive=0) annotation (Placement(transformation(extent={{-294,-209},{-276,-191}})));

  TransiEnt.Basics.Blocks.LimPID PID_PumpGrid(
    u_ref=22 + 273.15,
    y_ref=PID_PumpGrid.y_max,
    Tau_d=0,
    initOption=503,
    y_max=ScaleFactor.k/4200/30,
    y_min=1e-2,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    k=1000,
    Tau_i=1000,
    y_start=1,
    y_inactive=0) annotation (Placement(transformation(extent={{-346,-120},{-334,-108}})));

   TransiEnt.Basics.Blocks.LimPID PID_CHP(
    u_ref=273.15 + 85,
    y_ref=ScaleFactor.k,
    Tau_d=0,
    initOption=503,
    y_max=ScaleFactor.k,
    y_min=0,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    k=10000,
    Tau_i=0.01,
    y_start=1,
    y_inactive=0) annotation (Placement(transformation(extent={{14,-104},{-2,-88}})));

  Modelica.Blocks.Sources.RealExpression meas_temperature_storage(y=hotWaterStorage.controlVolume[1].T) annotation (Placement(transformation(extent={{52,-129},{32,-108}})));
  Modelica.Blocks.Sources.RealExpression set_temperature_storage(y=273.15 + 85) annotation (Placement(transformation(extent={{58,-110},{38,-86}})));

  Modelica.Blocks.Sources.RealExpression setValueTemperature(y=273.15 + 22) annotation (Placement(transformation(extent={{-374,-124},{-354,-104}})));
  Modelica.Blocks.Sources.RealExpression setValueTemperature_ne(y=273.15 + 22) annotation (Placement(transformation(extent={{165,90},{185,110}})));
  Modelica.Blocks.Sources.RealExpression setValueTemperature_se(y=273.15 + 22) annotation (Placement(transformation(extent={{169,6},{189,26}})));

  Modelica.Blocks.Math.Gain gain_ne(k=-1) annotation (Placement(transformation(extent={{192,119},{182,129}})));
  Modelica.Blocks.Math.Gain gain_CHP(k=-1) annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=180,
        origin={-38,-96})));
  Modelica.Blocks.Math.Gain gain_se(k=-1) annotation (Placement(transformation(extent={{190,36},{180,46}})));

  Modelica.Blocks.Sources.RealExpression set_m_flow_pump(y=largeScaleCHP.m_flow_nom) annotation (Placement(transformation(extent={{-204,-170},{-184,-150}})));
  TransiEnt.Basics.Tables.HeatGrid.HeatingCurves.HeatingCurve_FromDataPath heatingCurve(datapath="heat/HeatingCurve_80_60.txt") annotation (Placement(transformation(extent={{-352,-214},{-332,-194}})));
  Modelica.Blocks.Sources.Constant ScaleFactor(k=largeScaleCHP.Q_flow_n_CHP)    annotation (Placement(transformation(extent={{-80,-198},{-60,-178}})));

  // Consumer
  TransiEnt.Consumer.Heat.ThermalHeatConsumer_L3.ThermalHeatConsumer_L3 thermalHeatConsumer_CHP(
    T_start(displayUnit="degC") = 295.13,
    k_Win=1.3,
    redeclare TransiEnt.Consumer.Heat.ThermalHeatConsumer_L3.Base.ConstructionData.EnEV_Ext matLayExt,
    redeclare TransiEnt.Consumer.Heat.ThermalHeatConsumer_L3.Base.ConstructionData.EnEV_Flo matLayFlo,
    redeclare TransiEnt.Consumer.Heat.ThermalHeatConsumer_L3.Base.ConstructionData.EnEV_Roof matLayRoof) annotation (Placement(transformation(
        extent={{-11,-8},{11,8}},
        rotation=180,
        origin={-403,-100})));

   TransiEnt.Consumer.Heat.ThermalHeatConsumer_L3.ThermalHeatConsumer_L3 thermalHeatConsumer_se(
    T_start(displayUnit="degC") = 295.13,
    k_Win=1.3,
    redeclare TransiEnt.Consumer.Heat.ThermalHeatConsumer_L3.Base.ConstructionData.EnEV_Ext matLayExt,
    redeclare TransiEnt.Consumer.Heat.ThermalHeatConsumer_L3.Base.ConstructionData.EnEV_Flo matLayFlo,
    redeclare TransiEnt.Consumer.Heat.ThermalHeatConsumer_L3.Base.ConstructionData.EnEV_Roof matLayRoof) annotation (Placement(transformation(
        extent={{-11,8},{11,-8}},
        rotation=270,
        origin={203,-12})));

  TransiEnt.Consumer.Heat.ThermalHeatConsumer_L3.ThermalHeatConsumer_L3 thermalHeatConsumer_ne(
    T_start(displayUnit="degC") = 295.13,
    k_Win=1.3,
    redeclare TransiEnt.Consumer.Heat.ThermalHeatConsumer_L3.Base.ConstructionData.EnEV_Ext matLayExt,
    redeclare TransiEnt.Consumer.Heat.ThermalHeatConsumer_L3.Base.ConstructionData.EnEV_Flo matLayFlo,
    redeclare TransiEnt.Consumer.Heat.ThermalHeatConsumer_L3.Base.ConstructionData.EnEV_Roof matLayRoof) annotation (Placement(transformation(
        extent={{-11,8},{11,-8}},
        rotation=270,
        origin={199,72})));

  // _____________________________________________
  //
  //              Coupling Technologies
  // _____________________________________________

  TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_Storage feedInStation(
    V_geo=50,
    t_overload=86300,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics1stOrder (tau=10),
    startState=1,
    redeclare model PressureLossAtOutlet = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.Linear,
    redeclare model CostSpecsElectrolyzer = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Electrolyzer_2035,
    redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
    electrolyzer(redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp, redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=1) "Power Boundary for ComplexPowerPort"),
    P_el_n=1000000) annotation (Placement(transformation(extent={{-148,66},{-118,94}})));
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow annotation (Placement(transformation(extent={{-180,33},{-160,53}})));

  TransiEnt.Producer.Combined.LargeScaleCHP.CHP largeScaleCHP(
    PQCharacteristics=TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_CCPGeneric(),
    P_el_n=6e7,
    Q_flow_n_CHP=3e7,
    redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
    plantState(Q_flow_min_operating=10),
    isPrimaryControlActive=true,
    isSecondaryControlActive=false,
    primaryBalancingController(plantType=TransiEnt.Basics.Types.ControlPlantType.PeakLoad),
    m_flow_nom=ScaleFactor.k/4200/30,
    J=10*largeScaleCHP.P_el_n/(100*3.14)^2,
    useGasPort=true,
    usePowerBoundary=false,
    redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=1) "Power Boundary for ComplexPowerPort",
    redeclare TransiEnt.Components.Electrical.Machines.LinearSynchronousMachineComplex Generator,
    redeclare TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem_ComplexPowerPort Exciter) annotation (Placement(transformation(extent={{-48,-160},{-88,-116}})));
  Modelica.Blocks.Sources.RealExpression P_set_CHP(y=-6e7) annotation (Placement(transformation(extent={{-18,-132},{-38,-112}})));

 TransiEnt.Producer.Heat.Gas2Heat.SimpleGasBoiler.SimpleBoiler gasBoiler_se(useFluidPorts=false)    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={150,41})));
 TransiEnt.Basics.Blocks.LimPID PIDGasBoiler_se(
    Tau_d=0,
    initOption=503,
    y_max=1.4e8,
    y_min=1e-2,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    k=1e10,
    Tau_i=0.01,
    y_start=1,
    y_inactive=0) annotation (Placement(transformation(extent={{197,10},{209,22}})));

  TransiEnt.Producer.Heat.Gas2Heat.SimpleGasBoiler.SimpleBoiler gasBoiler_ne(useFluidPorts=false)  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={146,124})));
  TransiEnt.Basics.Blocks.LimPID PIDGasBoiler_ne(
    Tau_d=0,
    initOption=503,
    y_max=2.8e15,
    y_min=1e-2,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    k=1e10,
    Tau_i=0.01,
    y_start=1,
    y_inactive=0) annotation (Placement(transformation(extent={{193,94},{205,106}})));

equation

  if false then
     der(E_gen_tot)=P_gen_tot;
     der(E_load)=P_load;
     der(E_gen_ren)=P_gen_ren;
  else
    E_gen_tot=0;
    E_load=0;
    E_gen_ren=0;
  end if;
     P_load=sLPLoader.y1+sLPLoader1.y1+sLPLoader2.y1;
     P_gen_KW=-(largeScaleCHP.epp.P+biomass.epp.P+garbage.epp.P);
     P_gen_ren=-windTurbine.epp.P-photovoltaicPlant.epp.P;
     P_gen_tot=P_gen_KW+P_gen_ren;

  connect(source.gasPort, maxH2MassFlow.gasPortIn) annotation (Line(
      points={{-194,43},{-180,43}},
      color={255,255,0},
      thickness=1.5));
  connect(maxH2MassFlow.m_flow_H2_max, feedInStation.m_flow_feedIn) annotation (Line(points={{-170,52},{-170,91.2},{-118,91.2}},color={0,0,127}));
  connect(transmissionLine.epp_p, feedInStation.epp) annotation (Line(
      points={{-226,-74},{-226,80},{-148,80}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine1.epp_n, transformerWindpark.epp_p) annotation (Line(
      points={{-178,-42},{-120,-42}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine1.epp_p, feedInStation.epp) annotation (Line(
      points={{-196,-42},{-226,-42},{-226,80},{-148,80}},
      color={28,108,200},
      thickness=0.5));
  connect(transformerConsumer.epp_p, transmissionLine2.epp_n) annotation (Line(
      points={{-122,0},{-178,0}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine2.epp_p, feedInStation.epp) annotation (Line(
      points={{-196,0},{-226,0},{-226,80},{-148,80}},
      color={28,108,200},
      thickness=0.5));
  connect(complexPower.epp, transmissionLine2.epp_n) annotation (Line(
      points={{-150,-12},{-150,0},{-178,0}},
      color={28,108,200},
      thickness=0.5));
  connect(complexPower1.epp, transmissionLine1.epp_n) annotation (Line(
      points={{-148,-52},{-148,-42},{-178,-42}},
      color={28,108,200},
      thickness=0.5));
  connect(transformerConsumer.epp_n, H0_SE.epp) annotation (Line(
      points={{-110,0},{-87.8,0}},
      color={28,108,200},
      thickness=0.5));
  connect(TransmissionLine1.epp_n, TransmissionLine.epp_p) annotation (Line(
      points={{-410,70},{-410,90},{-368,90}},
      color={28,108,200},
      thickness=0.5));
  connect(biomass.epp, TransmissionLine.epp_p) annotation (Line(
      points={{-427,91},{-427,90},{-368,90}},
      color={28,108,200},
      thickness=0.5));
  connect(G0_NW.epp, TransmissionLine1.epp_p) annotation (Line(
      points={{-397.8,-14},{-410,-14},{-410,50}},
      color={28,108,200},
      thickness=0.5));
  connect(TransmissionLine3.epp_n, TransmissionLine1.epp_p) annotation (Line(
      points={{-410,-32},{-410,50}},
      color={28,108,200},
      thickness=0.5));
  connect(TransmissionLine4.epp_n, TransmissionLine.epp_n) annotation (Line(
      points={{-306,68},{-306,90},{-348,90}},
      color={28,108,200},
      thickness=0.5));
  connect(TransmissionLine5.epp_n, TransmissionLine4.epp_p) annotation (Line(
      points={{-346,-62},{-306,-62},{-306,48}},
      color={28,108,200},
      thickness=0.5));
  connect(TransmissionLine5.epp_p, TransmissionLine3.epp_p) annotation (Line(
      points={{-366,-62},{-410,-62},{-410,-52}},
      color={28,108,200},
      thickness=0.5));
  connect(globalFrequency.epp, TransmissionLine.epp_p) annotation (Line(
      points={{-394,120},{-386,120},{-386,90},{-368,90}},
      color={28,108,200},
      thickness=0.5));
  connect(globalFrequency.f, feedback.u2) annotation (Line(points={{-406.24,120},{-426,120},{-426,141.2}},                  color={0,0,127}));
  connect(integrator.u, feedback.y) annotation (Line(points={{-443,133.8},{-443,146},{-431.4,146}},
                                                                                                 color={0,0,127}));
  connect(TransmissionLine6.epp_n, feedInStation.epp) annotation (Line(
      points={{-252,0},{-226,0},{-226,80},{-148,80}},
      color={28,108,200},
      thickness=0.5));
  connect(TransmissionLine6.epp_p, TransmissionLine4.epp_p) annotation (Line(
      points={{-272,0},{-306,0},{-306,48}},
      color={28,108,200},
      thickness=0.5));
  connect(TransmissionLine2.epp_p, TransmissionLine4.epp_p) annotation (Line(
      points={{-346,26},{-306,26},{-306,48}},
      color={28,108,200},
      thickness=0.5));
  connect(TransmissionLine2.epp_n, TransmissionLine1.epp_p) annotation (Line(
      points={{-366,26},{-410,26},{-410,50}},
      color={28,108,200},
      thickness=0.5));
  connect(globalFrequency_reference.y, feedback.u1) annotation (Line(points={{-405.8,145},{-405.8,146},{-421.2,146}},                     color={0,0,127}));
  connect(L0_SW.epp, TransmissionLine4.epp_p) annotation (Line(
      points={{-295.8,-62},{-306,-62},{-306,48}},
      color={28,108,200},
      thickness=0.5));
  connect(sLPLoader.y1,G0_NW. P_el_set) annotation (Line(points={{-367,0},{-388,0},{-388,-2.4}},      color={0,0,127}));
  connect(sLPLoader1.y1,L0_SW. P_el_set) annotation (Line(points={{-271,-44},{-286,-44},{-286,-50.4}},   color={0,0,127}));
  connect(sLPLoader2.y1, H0_SE.P_el_set) annotation (Line(points={{-49,14},{-78,14},{-78,11.6}},                   color={0,0,127}));
  connect(transformerWindpark1.epp_p, TransmissionLine.epp_n) annotation (Line(
      points={{-306,108},{-306,90},{-348,90}},
      color={28,108,200},
      thickness=0.5));
  connect(transformerWindpark1.epp_n, photovoltaicPlant.epp) annotation (Line(
      points={{-306,120},{-306,124},{-318,124}},
      color={28,108,200},
      thickness=0.5));
  connect(complexPower2.epp, TransmissionLine.epp_n) annotation (Line(
      points={{-286,90},{-348,90}},
      color={28,108,200},
      thickness=0.5));
  connect(SetPower.y, feedInStation.P_el_set) annotation (Line(points={{-191,106},{-133,106},{-133,94.56}},
                                                                                                        color={0,0,127}));
  connect(garbage.epp, TransmissionLine3.epp_p) annotation (Line(
      points={{-425,-63},{-410,-63},{-410,-52}},
      color={28,108,200},
      thickness=0.5));
  connect(setValueTemperature.y, PID_PumpGrid.u_s) annotation (Line(points={{-353,-114},{-347.2,-114}}, color={0,0,127}));
  connect(hotWaterStorage.waterPortOut_prod[1],pumpProd. fluidPortIn) annotation (Line(
      points={{-216,-174.8},{-216,-175},{-168,-175}},
      color={175,0,0},
      thickness=0.5));
  connect(thermalHeatConsumer_CHP.T_room, PID_PumpGrid.u_m) annotation (Line(points={{-391.4,-101.2},{-386,-101.2},{-386,-124},{-339.94,-124},{-339.94,-121.2}}, color={0,0,127}));
  connect(set_m_flow_pump.y, pumpProd.m_flow_in) annotation (Line(points={{-183,-160},{-166,-160},{-166,-164}}, color={0,0,127}));
  connect(PID_PumpGrid.y, pumpGrid.m_flow_in) annotation (Line(points={{-333.4,-114},{-326,-114},{-326,-133}}, color={0,0,127}));
  connect(tWV.outlet2,joinGrid. inlet2) annotation (Line(
      points={{-268,-166},{-268,-152},{-269,-152}},
      color={175,0,0},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(hotWaterStorage.waterPortOut_grid[1],joinGrid. inlet1) annotation (Line(
      points={{-242,-165.2},{-242,-144},{-260,-144}},
      color={175,0,0},
      thickness=0.5));
  connect(hotWaterStorage.waterPortIn_grid[1],tWV. outlet1) annotation (Line(
      points={{-242,-174.8},{-254,-174.8},{-254,-174.889},{-260,-174.889}},
      color={175,0,0},
      thickness=0.5));
  connect(thermalHeatConsumer_CHP.port_HeatDemand,heatFlowMultiplier1. port_a) annotation (Line(points={{-392.4,-107.6},{-392.4,-110.8},{-392,-110.8},{-392,-114}},
                                                                                                                                                            color={191,0,0}));
  connect(pumpGrid.fluidPortIn,joinGrid. outlet) annotation (Line(
      points={{-324,-144},{-278,-144}},
      color={175,0,0},
      thickness=0.5));
  connect(pumpGrid.fluidPortIn,tempBeforeCons. port) annotation (Line(
      points={{-324,-144},{-294,-144}},
      color={175,0,0},
      thickness=0.5));
  connect(largeScaleCHP.inlet, pumpProd.fluidPortOut) annotation (Line(
      points={{-88.4,-147.9},{-90,-147.9},{-90,-175},{-148,-175}},
      color={175,0,0},
      thickness=0.5));
  connect(hotWaterStorage.waterPortIn_prod[1], largeScaleCHP.outlet) annotation (Line(
      points={{-216,-165.2},{-216,-142.767},{-88.4,-142.767}},
      color={175,0,0},
      thickness=0.5));
  connect(tempAfterCons.port,tWV. inlet) annotation (Line(
      points={{-362,-174},{-320,-174},{-320,-174.889},{-276,-174.889}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(hEXHeatCons.inlet,pumpGrid. fluidPortOut) annotation (Line(
      points={{-382,-144},{-344,-144}},
      color={162,29,33},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(hEXHeatCons.outlet,tWV. inlet) annotation (Line(
      points={{-402,-144},{-402,-174.889},{-276,-174.889}},
      color={162,29,33},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(heatFlowMultiplier1.port_b,hEXHeatCons. heat) annotation (Line(points={{-392,-126},{-392,-134}},
                                                                                                        color={191,0,0}));
  connect(PID_CHP.y, gain_CHP.u) annotation (Line(points={{-2.8,-96},{-33.2,-96}}, color={0,0,127}));
  connect(PID_CHP.u_m, meas_temperature_storage.y) annotation (Line(points={{5.92,-105.6},{5.08,-105.6},{5.08,-118.5},{31,-118.5}}, color={0,0,127}));
  connect(set_temperature_storage.y, PID_CHP.u_s) annotation (Line(points={{37,-98},{26,-98},{26,-96},{15.6,-96}}, color={0,0,127}));
  connect(transmissionLine.epp_n, largeScaleCHP.epp) annotation (Line(
      points={{-226,-94},{-226,-131.4},{-87,-131.4}},
      color={28,108,200},
      thickness=0.5));
  connect(controllerMeritOrderSimple.P_el_storage_actual[1], P_el_CHP.y) annotation (Line(points={{-492,4},{-532,4},{-532,3.5},{-535,3.5}}, color={0,127,127}));
  connect(controllerMeritOrderSimple.P_el_consDirect, P_Load.y) annotation (Line(points={{-472,12},{-498,12},{-498,-44},{-498.9,-44}}, color={0,127,127}));
  connect(P_el_GAR.y, controllerMeritOrderSimple.P_el_storage_actual[3]) annotation (Line(points={{-535,-18.5},{-522,-18.5},{-522,4},{-492,4}}, color={0,0,127}));
  connect(P_el_ren.y, controllerMeritOrderSimple.P_el_prod) annotation (Line(points={{-498.9,43.5},{-498,43.5},{-498,12},{-492,12}}, color={0,0,127}));
  connect(transformerWindpark.epp_n, windTurbine.epp) annotation (Line(
      points={{-108,-42},{-87,-42}},
      color={28,108,200},
      thickness=0.5));
  connect(windTurbine.v_wind, windSpeed.y) annotation (Line(points={{-69.1,-42.9},{-58,-42.9},{-58,-43},{-53,-43}},   color={0,0,127}));
  connect(P_el_PES.y, controllerMeritOrderSimple.P_el_storage_actual[4]) annotation (Line(points={{-532.9,24},{-522,24},{-522,4},{-492,4}}, color={0,0,127}));
  connect(garbage.P_el_set, filterPosNeg2.y) annotation (Line(points={{-435.5,-60.1},{-436,-60.1},{-436,-56},{-449.6,-56}},   color={0,127,127}));
  connect(filterPosNeg2.u, controllerMeritOrderSimple.P_el_storage_desired[3]) annotation (Line(points={{-458.8,-56},{-462,-56},{-462,-7},{-482,-7}}, color={0,0,127}));
  connect(biomass.P_el_set, controllerMeritOrderSimple.P_el_storage_desired[2]) annotation (Line(points={{-437.5,93.9},{-436,93.9},{-436,98},{-462,98},{-462,-7},{-482,-7}}, color={0,127,127}));
  connect(integrator.y, biomass.P_SB_set) annotation (Line(points={{-443,113.1},{-443,92.9},{-444.9,92.9}},color={0,0,127}));
  connect(G0_NW.epp, PES.epp) annotation (Line(
      points={{-397.8,-14},{-410,-14},{-410,26},{-425,26}},
      color={28,108,200},
      thickness=0.5));
  connect(junction_FIS.gasPort3,compositionSensor. gasPortIn) annotation (Line(
      points={{-124,41},{-122,41}},
      color={255,255,0},
      thickness=1.5));
  connect(pressureSensor_CHP.gasPortIn,massFlowSensor. gasPortOut) annotation (Line(
      points={{78,6},{78,8}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_ne.gasPort2,pipe_e. gasPortOut) annotation (Line(
      points={{20,114},{20,110},{18,110},{18,104},{20,104},{20,95}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_nw.gasPort2,pipe_w. gasPortOut) annotation (Line(
      points={{-50,114},{-50,95}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe_n.gasPortIn,junction_nw. gasPort1) annotation (Line(
      points={{-26,124},{-40,124}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe_n.gasPortOut,junction_ne. gasPort3) annotation (Line(
      points={{2,124},{10,124}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe_w.gasPortIn,junction_sw. gasPort2) annotation (Line(
      points={{-50,67},{-50,51}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_sw.gasPort1,pipe_sw. gasPortOut) annotation (Line(
      points={{-60,41},{-70,41}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_sw.gasPort3,pipe_s. gasPortIn) annotation (Line(
      points={{-40,41},{-24,41}},
      color={255,255,0},
      thickness=1.5));
  connect(setValueTemperature_se.y, PIDGasBoiler_se.u_s) annotation (Line(points={{190,16},{195.8,16}}, color={0,0,127}));
  connect(thermalHeatConsumer_se.port_HeatDemand,heatFlowMultiplier2. port_a) annotation (Line(points={{195.4,-1.4},{195.4,-0.8},{158.5,-0.8},{158.5,-8.88178e-16}},
                                                                                                                                                          color={191,0,0}));
  connect(thermalHeatConsumer_se.T_room, PIDGasBoiler_se.u_m) annotation (Line(points={{201.8,-0.4},{201.8,5.8},{203.06,5.8},{203.06,8.8}}, color={0,0,127}));
  connect(gain_se.y,gasBoiler_se. Q_flow_set) annotation (Line(points={{179.5,41},{160,41}},                   color={0,0,127}));
  connect(setValueTemperature_ne.y, PIDGasBoiler_ne.u_s) annotation (Line(points={{186,100},{191.8,100}}, color={0,0,127}));
  connect(thermalHeatConsumer_ne.port_HeatDemand,heatFlowMultiplier3. port_a) annotation (Line(points={{191.4,82.6},{191.4,83.2},{154.5,83.2},{154.5,84}},
                                                                                                                                                       color={191,0,0}));
  connect(thermalHeatConsumer_ne.T_room, PIDGasBoiler_ne.u_m) annotation (Line(points={{197.8,83.6},{197.8,83.8},{199.06,83.8},{199.06,92.8}}, color={0,0,127}));
  connect(gain_ne.y,gasBoiler_ne. Q_flow_set) annotation (Line(points={{181.5,124},{156,124}},                 color={0,0,127}));
  connect(junction_ne.gasPort1,pipe_ne. gasPortIn) annotation (Line(
      points={{30,124},{38,124}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe_ne.gasPortOut,pressureSensor_ne. gasPortIn) annotation (Line(
      points={{66,124},{74,124}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe_nw.gasPortIn,junction_nw. gasPort3) annotation (Line(
      points={{-66,124},{-60,124}},
      color={255,255,0},
      thickness=1.5));
  connect(pressureSensor_nw.gasPortIn,pipe_nw. gasPortOut) annotation (Line(
      points={{-100,124},{-94,124}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_se.gasPort2,pipe_e. gasPortIn) annotation (Line(
      points={{20,51},{20,56},{14,56},{14,60},{20,60},{20,67}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_se.gasPort3,pipe_se. gasPortIn) annotation (Line(
      points={{30,41},{40,41}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensor.gasPortOut,pipe_sw. gasPortIn) annotation (Line(
      points={{-102,41},{-98,41}},
      color={255,255,0},
      thickness=1.5));
  connect(pressureSensor_se.gasPortIn,junction_seAtCHP. gasPort3) annotation (Line(
      points={{92,41},{83,41}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_seAtCHP.gasPort1,pipe_se. gasPortOut) annotation (Line(
      points={{73,41},{68,41}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_seAtCHP.gasPort2,massFlowSensor. gasPortIn) annotation (Line(
      points={{78,36},{78,28}},
      color={255,255,0},
      thickness=1.5));
  connect(gasConsumer_nw.fluidPortIn,gCVSensor_nw. gasPortOut) annotation (Line(
      points={{-146,124},{-140,124}},
      color={255,255,0},
      thickness=1.5));
  connect(pressureSensor_nw.gasPortOut,gCVSensor_nw. gasPortIn) annotation (Line(
      points={{-120,124},{-120,124}},
      color={255,255,0},
      thickness=1.5));
  connect(pressureSensor_ne.gasPortOut,gCVSensor_ne. gasPortIn) annotation (Line(
      points={{94,124},{102,124}},
      color={255,255,0},
      thickness=1.5));
  connect(gasBoiler_ne.gasIn,gCVSensor_ne. gasPortOut) annotation (Line(
      points={{136,123.8},{130,123.8},{130,124},{122,124}},
      color={255,255,0},
      thickness=1.5));
  connect(pressureSensor_se.gasPortOut,gCVSensor_se. gasPortIn) annotation (Line(
      points={{112,41},{116,41}},
      color={255,255,0},
      thickness=1.5));
  connect(gasBoiler_se.gasIn,gCVSensor_se. gasPortOut) annotation (Line(
      points={{140,40.8},{138,40.8},{138,41},{136,41}},
      color={255,255,0},
      thickness=1.5));
  connect(pressureSensor_CHP.gasPortOut,gCVSensor_CHP. gasPortIn) annotation (Line(
      points={{78,-14},{78,-28}},
      color={255,255,0},
      thickness=1.5));
  connect(feedInStation.gasPortOut, junction_FIS.gasPort2) annotation (Line(
      points={{-133.75,65.86},{-133.75,74},{-132,74},{-132,51},{-134,51}},
      color={255,255,0},
      thickness=1.5));
  connect(maxH2MassFlow.gasPortOut, junction_FIS.gasPort1) annotation (Line(
      points={{-160,43},{-152,43},{-152,44},{-146,44},{-146,41},{-144,41}},
      color={255,255,0},
      thickness=1.5));
  connect(gCVSensor_CHP.gasPortOut, largeScaleCHP.gasPortIn) annotation (Line(
      points={{78,-48},{78,-76},{-88,-76},{-88,-122.967}},
      color={255,255,0},
      thickness=1.5));
  connect(PIDGasBoiler_ne.y, gain_ne.u) annotation (Line(points={{205.6,100},{216,100},{216,124},{193,124}}, color={0,0,127}));
  connect(gain_se.u, PIDGasBoiler_se.y) annotation (Line(points={{191,41},{214,41},{214,16},{209.6,16}}, color={0,0,127}));
  connect(SetConsumption.y, gasConsumer_nw.H_flow) annotation (Line(points={{-191,130},{-167,130},{-167,124}}, color={0,0,127}));
  connect(idealizedExpansionVessel1.waterPort, hotWaterStorage.waterPortOut_grid[1]) annotation (Line(
      points={{-247,-136},{-242,-136},{-242,-165.2}},
      color={175,0,0},
      thickness=0.5));
  connect(tempBeforeCons.T, PID_TWV.u_m) annotation (Line(points={{-302.8,-136},{-312,-136},{-312,-210.8},{-284.91,-210.8}}, color={0,0,127}));
  connect(heatingCurve.T_Supply, PID_TWV.u_s) annotation (Line(points={{-331.2,-200.4},{-300,-200.4},{-300,-200},{-295.8,-200}}, color={0,0,127}));
  connect(PID_TWV.y, tWV.splitRatio_external) annotation (Line(points={{-275.1,-200},{-268,-200},{-268,-182.889}},
                                                                                                                 color={0,0,127}));
  connect(P_set_CHP.y, largeScaleCHP.P_set) annotation (Line(points={{-39,-122},{-55.8,-122},{-55.8,-121.133}}, color={0,0,127}));
  connect(gain_CHP.y, largeScaleCHP.Q_flow_set) annotation (Line(points={{-42.4,-96},{-75.4,-96},{-75.4,-121.133}}, color={0,0,127}));
  connect(pipe_s.gasPortOut, junction_se.gasPort1) annotation (Line(
      points={{4,41},{10,41}},
      color={255,255,0},
      thickness=1.5));
  connect(PES.P_set, controllerMeritOrderSimple.P_el_storage_desired[4]) annotation (Line(points={{-435,35.4},{-434,35.4},{-434,38},{-462,38},{-462,-7},{-482,-7}}, color={0,127,127}));
  connect(heatFlowMultiplier2.port_b, gasBoiler_se.heatPort) annotation (Line(points={{158.5,14},{158.6,14},{158.6,31}}, color={191,0,0}));
  connect(heatFlowMultiplier3.port_b, gasBoiler_ne.heatPort) annotation (Line(points={{154.5,96},{154.6,96},{154.6,114}}, color={191,0,0}));
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-560,-220},{220,160}},
        initialScale=0.1)),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-560,-220},{220,160}},
        initialScale=0.1)),
    experiment(
      StopTime=3456000,
      Interval=900.003,
      Tolerance=1e-06,
      __Dymola_Algorithm="Esdirk45a"),
    __Dymola_experimentSetupOutput(inputs=false),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Example of coupled electric, gas, and heating system. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Simulation model, no component model, level of detail defined in the components</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Sandbox or reference model, no claim of realistic model layout</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>This model uses instances of models from the<u><b> Buildings Library</b></u> developed by the Lawrence Berkeley National Laboratory. The library can be downloaded at https://simulationresearch.lbl.gov/modelica/download.html. </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Sandbox or reference model, no validation</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Lisa Andresen (andresen@tuhh.de), Mar 2017</p>
<p>Extended by Jan-Peter Heckel (jan.heckel@tuhh.de), Nov 2018</p>
<p>Extended by Carsten Bode (c.bode@tuhh.de), June 2019</p>
<p>Extended and Edited by Anne Senkel (anne.senkel@tuhh.de), March 2020</p>
</html>"));
end Coupled_LargeScale;
