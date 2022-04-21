within TransiEnt.Components.Electrical.Grid.Check;
model CheckElectricBusbarComplex "Example model for voltage collapse for testing OLTC and Busbar"


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
  //             Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced transmissionLine_Northern(
    ChooseVoltageLevel=3,
    p=2,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L6,
    l(displayUnit="km") = 400000) annotation (Placement(transformation(extent={{-50,26},{-22,54}})));

  inner TransiEnt.SimCenter simCenter(v_n(displayUnit="kV") = 380000) annotation (Placement(transformation(extent={{-148,-98},{-128,-78}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-110,-98},{-90,-78}})));

  TransiEnt.Consumer.Electrical.DynamicExponentialElectricConsumerComplex Lb_DynamicLoad(
    Tp=60,
    Tq=30,
    alpha_s=0.38,
    alpha_t=2.26,
    beta_s=2,
    beta_t=10,
    v_n(displayUnit="kV") = 220000,
    P_n(displayUnit="MW") = 1500000000,
    Q_n=550e6) annotation (Placement(transformation(extent={{102,-30},{122,-10}})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced transmissionLine_Central(
    ChooseVoltageLevel=3,
    p=2,
    MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L1,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L6,
    l(displayUnit="km") = 200000) annotation (Placement(transformation(extent={{18,30},{38,50}})));

  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced transmissionLine_CentralFault(
    activateSwitch=true,
    ChooseVoltageLevel=3,
    p=2,
    MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L1,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L4,
    l(displayUnit="km") = 200000) annotation (Placement(transformation(extent={{16,64},{36,84}})));

  Modelica.Blocks.Sources.BooleanStep BooleanFault(startTime(displayUnit="s") = 400) annotation (Placement(transformation(extent={{-10,92},{6,108}})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced transmissionLine_CentralLower(
    activateSwitch=false,
    ChooseVoltageLevel=3,
    p=2,
    LVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K2,
    MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L1,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L6,
    l(displayUnit="km") = 600000) annotation (Placement(transformation(extent={{116,28},{140,52}})));

  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced transmissionLine_Southern(
    activateSwitch=false,
    ChooseVoltageLevel=3,
    p=2,
    LVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K1,
    MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L1,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L6,
    l(displayUnit="km") = 500000) annotation (Placement(transformation(extent={{184,28},{208,52}})));

  TransiEnt.Components.Electrical.PowerTransformation.SimpleTransformerComplex Transformer_L1(
    UseInput=true,
    U_P(displayUnit="kV") = 380000,
    U_S(displayUnit="kV") = 220000,
    P_p(displayUnit="MW", start=15000000),
    P_n(displayUnit="MW", start=-15000000)) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-60,-20})));
  TransiEnt.Components.Electrical.PowerTransformation.OLTC.TapChangerController OLTC_L1(
    numberTaps=11,
    v_prim_n(displayUnit="kV") = 380000,
    v_sec_n(displayUnit="kV") = 220000) annotation (Placement(transformation(extent={{-74,-58},{-92,-42}})));
  TransiEnt.Components.Electrical.PowerTransformation.SimpleTransformerComplex Transformer_L_a(
    UseInput=true,
    U_P(displayUnit="kV") = 380000,
    U_S(displayUnit="kV") = 220000,
    P_p(displayUnit="MW", start=15000000),
    P_n(displayUnit="MW", start=-15000000)) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-6,2})));
  TransiEnt.Components.Electrical.PowerTransformation.OLTC.TapChangerController OLTC_L_a(
    numberTaps=11,
    v_prim_n(displayUnit="kV") = 380000,
    v_sec_n(displayUnit="kV") = 220000,
    T_delay=10,
    currentTap(start=7)) annotation (Placement(transformation(extent={{-10,-28},{-28,-10}})));
  TransiEnt.Components.Electrical.PowerTransformation.SimpleTransformerComplex Transformer_L_b(
    UseInput=true,
    U_P(displayUnit="kV") = 380000,
    U_S(displayUnit="kV") = 220000,
    P_p(displayUnit="MW", start=15000000),
    P_n(displayUnit="MW", start=-15000000)) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={90,8})));
  TransiEnt.Components.Electrical.PowerTransformation.OLTC.TapChangerController OLTC_L_b(
    numberTaps=11,
    v_prim_n(displayUnit="kV") = 380000,
    v_sec_n(displayUnit="kV") = 220000) annotation (Placement(transformation(extent={{82,-30},{64,-12}})));
  TransiEnt.Components.Electrical.PowerTransformation.SimpleTransformerComplex Transformer_L_c(
    UseInput=true,
    U_P(displayUnit="kV") = 380000,
    U_S(displayUnit="kV") = 220000,
    P_p(displayUnit="MW", start=15000000),
    P_n(displayUnit="MW", start=-15000000)) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={162,2})));
  TransiEnt.Components.Electrical.PowerTransformation.SimpleTransformerComplex Transformer_L2(
    UseInput=true,
    U_P(displayUnit="kV") = 380000,
    U_S(displayUnit="kV") = 220000,
    P_p(displayUnit="MW", start=15000000),
    P_n(displayUnit="MW", start=-15000000)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={258,40})));
  TransiEnt.Components.Electrical.PowerTransformation.OLTC.TapChangerController OLTC_L_c(
    numberTaps=11,
    v_prim_n(displayUnit="kV") = 380000,
    v_sec_n(displayUnit="kV") = 220000,
    currentTap(start=-11)) annotation (Placement(transformation(extent={{154,-28},{136,-10}})));
  TransiEnt.Components.Electrical.PowerTransformation.OLTC.TapChangerController OLTC_L2(
    numberTaps=11,
    v_prim_n(displayUnit="kV") = 380000,
    v_sec_n(displayUnit="kV") = 220000) annotation (Placement(transformation(extent={{274,72},{256,88}})));
  TransiEnt.Producer.Electrical.Others.Biomass biomass_G1_Slack(
    primaryBalancingController(maxGradientPrCtrl=0.03/30, maxValuePrCtrl=0.03),
    H=11,
    redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
    set_P_init=false,
    isPrimaryControlActive=true,
    P_min_star=0.1,
    redeclare TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DCExciter Exciter(
      TA=1,
      KA=80,
      LimitofExcitation=0.6),
    isSecondaryControlActive=true,
    isExternalSecondaryController=true,
    P_el_n(displayUnit="MW") = 3000000000,
    redeclare TransiEnt.Components.Electrical.Machines.SynchronousMachineComplex Generator(IsSlack=true, R_a=0)) annotation (Placement(transformation(extent={{-118,36},{-90,64}})));

  Modelica.Blocks.Sources.Constant const(k=-biomass_G1_Slack.P_init) annotation (Placement(transformation(extent={{-80,86},{-94,100}})));
  Modelica.Blocks.Continuous.Integrator integrator(k=1.36e5) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={-126,80})));
  TransiEnt.Components.Sensors.ElectricFrequencyComplex globalFrequency(isDeltaMeasurement=true) annotation (Placement(transformation(extent={{-102,12},{-114,24}})));
  TransiEnt.Producer.Electrical.Others.Biomass biomass_G3(
    calculateCost=true,
    primaryBalancingController(maxGradientPrCtrl=0.03/30, maxValuePrCtrl=0.03),
    P_init_set=100e6,
    H=11,
    redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
    set_P_init=true,
    isPrimaryControlActive=true,
    redeclare TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DCExciter Exciter(LimitofExcitation=0.5),
    isSecondaryControlActive=false,
    isExternalSecondaryController=true,
    P_el_n(displayUnit="MW") = 250000000,
    redeclare TransiEnt.Components.Electrical.Machines.SynchronousMachineComplex Generator(R_a=0)) annotation (Placement(transformation(extent={{90,70},{66,94}})));

  Modelica.Blocks.Sources.Constant const1(k=-biomass_G3.P_init) annotation (Placement(transformation(extent={{116,96},{102,110}})));
  TransiEnt.Producer.Electrical.Others.Biomass biomass_G2(
    primaryBalancingController(maxGradientPrCtrl=0.03/30, maxValuePrCtrl=0.03),
    P_init_set=50e6,
    H=11,
    redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp,
    set_P_init=true,
    isPrimaryControlActive=true,
    redeclare TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DCExciter Exciter(LimitofExcitation=0.5),
    isSecondaryControlActive=false,
    isExternalSecondaryController=true,
    P_el_n(displayUnit="MW") = 100000000,
    redeclare TransiEnt.Components.Electrical.Machines.SynchronousMachineComplex Generator(R_a=0)) annotation (Placement(transformation(extent={{202,62},{224,84}})));

  Modelica.Blocks.Sources.Constant const2(k=-biomass_G2.P_init) annotation (Placement(transformation(extent={{192,92},{206,106}})));
  Modelica.Blocks.Logical.Not not1 annotation (Placement(transformation(extent={{14,94},{26,106}})));
  TransiEnt.Consumer.Electrical.DynamicExponentialElectricConsumerComplex Lc_DynamicLoad(
    Tp=60,
    Tq=30,
    alpha_s=2.26,
    alpha_t=0.38,
    beta_s=2.5,
    beta_t=2,
    v_n(displayUnit="kV") = 220000,
    P_n(displayUnit="MW") = 100000000) annotation (Placement(transformation(extent={{194,-30},{216,-8}})));
  TransiEnt.Consumer.Electrical.DynamicExponentialElectricConsumerComplex La_DynamicLoad(
    Tp=60,
    Tq=30,
    alpha_s=0.38,
    alpha_t=2.26,
    beta_s=2,
    beta_t=2.5,
    v_n(displayUnit="kV") = 220000,
    P_n(displayUnit="MW") = 100000000,
    Q_n=50e6) annotation (Placement(transformation(extent={{14,-30},{34,-10}})));
  TransiEnt.Consumer.Electrical.DynamicExponentialElectricConsumerComplex L1_DynamicLoad(
    Tp=60,
    Tq=30,
    alpha_s=0.38,
    alpha_t=2.26,
    beta_s=2,
    beta_t=2.5,
    v_n(displayUnit="kV") = 220000,
    P_n(displayUnit="MW") = 200000000,
    Q_n=100e6) annotation (Placement(transformation(extent={{-48,-60},{-28,-40}})));
  TransiEnt.Consumer.Electrical.DynamicExponentialElectricConsumerComplex L2_DynamicLoad(
    Tp=60,
    Tq=30,
    alpha_s=0.38,
    alpha_t=2.26,
    beta_s=2,
    beta_t=2.5,
    v_n(displayUnit="kV") = 220000,
    P_n(displayUnit="MW") = 125000000,
    Q_n=75e6) annotation (Placement(transformation(extent={{296,30},{316,50}})));
  TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary pQBoundary1(
    useInputConnectorP=false,
    useInputConnectorQ=false,
    v_n(displayUnit="kV") = 380000) annotation (Placement(transformation(extent={{-18,72},{-34,88}})));
  TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary pQBoundary2(
    useInputConnectorP=false,
    useInputConnectorQ=false,
    v_n(displayUnit="kV") = 380000) annotation (Placement(transformation(extent={{158,76},{138,94}})));
  // _____________________________________________
  //
  //           Functions
  // _____________________________________________

  function plotResult

    constant String resultFileName="GridN5AreaFirstVoltageCollapse.mat";

    output String resultFile;

  algorithm
    clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
    resultFile := TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
    removePlots();
    createPlot(
          id=1,
          position={809,0,791,733},
          y={"OLTC_L_a.epp.f"},
          grid=true,
          filename=resultFile);
    createPlot(
          id=2,
          position={0,0,791,733},
          y={"OLTC_L_a.epp.v","OLTC_L_b.epp.v"},
          grid=true,
          filename=resultFile);
    resultFile := "Successfully plotted results for file: " + resultFile;

  end plotResult;

  // _____________________________________________
  //
  //               Equations
  // _____________________________________________

  TransiEnt.Components.Electrical.Grid.ElectricBusbarComplex Bus_1(port=3) annotation (Placement(transformation(extent={{-86,10},{-66,30}})));
  TransiEnt.Components.Electrical.Grid.ElectricBusbarComplex Bus_2(port=5) annotation (Placement(transformation(extent={{-20,18},{0,38}})));
  TransiEnt.Components.Electrical.Grid.ElectricBusbarComplex Bus_3(port=5) annotation (Placement(transformation(extent={{56,26},{76,46}})));
  TransiEnt.Components.Electrical.Grid.ElectricBusbarComplex Bus_4(port=4) annotation (Placement(transformation(extent={{144,16},{164,36}})));
  TransiEnt.Components.Electrical.Grid.ElectricBusbarComplex Bus_5(port=3) annotation (Placement(transformation(extent={{218,12},{238,32}})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(OLTC_L1.RatioOut, Transformer_L1.ratio_set) annotation (Line(points={{-92,-50},{-92,-14},{-72,-14}}, color={0,0,127}));
  connect(OLTC_L_a.RatioOut, Transformer_L_a.ratio_set) annotation (Line(points={{-28,-19},{-40,-19},{-40,8},{-18,8}}, color={0,0,127}));
  connect(Transformer_L_b.epp_n, Lb_DynamicLoad.epp) annotation (Line(
      points={{90,-2},{90,-20},{102,-20}},
      color={28,108,200},
      thickness=0.5));
  connect(OLTC_L_b.epp, Lb_DynamicLoad.epp) annotation (Line(
      points={{82,-21},{82,-20},{102,-20}},
      color={28,108,200},
      thickness=0.5));
  connect(OLTC_L_b.RatioOut, Transformer_L_b.ratio_set) annotation (Line(points={{64,-21},{56,-21},{56,14},{78,14}}, color={0,0,127}));
  connect(OLTC_L_c.epp, Transformer_L_c.epp_n) annotation (Line(
      points={{154,-19},{162,-19},{162,-8}},
      color={28,108,200},
      thickness=0.5));
  connect(OLTC_L_c.RatioOut, Transformer_L_c.ratio_set) annotation (Line(points={{136,-19},{136,8},{150,8}}, color={0,0,127}));
  connect(OLTC_L2.RatioOut, Transformer_L2.ratio_set) annotation (Line(points={{256,80},{252,80},{252,52}}, color={0,0,127}));
  connect(const.y, biomass_G1_Slack.P_el_set) annotation (Line(points={{-94.7,93},{-104,93},{-104,63.86},{-106.1,63.86}}, color={0,0,127}));
  connect(integrator.y, biomass_G1_Slack.P_SB_set) annotation (Line(points={{-117.2,80},{-116.46,80},{-116.46,62.46}}, color={0,0,127}));
  connect(const1.y, biomass_G3.P_el_set) annotation (Line(points={{101.3,103},{100,103},{100,102},{90,102},{90,93.88},{79.8,93.88}}, color={0,0,127}));
  connect(const2.y, biomass_G2.P_el_set) annotation (Line(points={{206.7,99},{208,99},{208,100},{218,100},{218,83.89},{211.35,83.89}}, color={0,0,127}));
  connect(BooleanFault.y, not1.u) annotation (Line(points={{6.8,100},{12.8,100}}, color={255,0,255}));
  connect(not1.y, transmissionLine_CentralFault.switched_input) annotation (Line(points={{26.6,100},{28,100},{28,84},{26,84}}, color={255,0,255}));
  connect(Lc_DynamicLoad.epp, OLTC_L_c.epp) annotation (Line(
      points={{194,-19},{154,-19}},
      color={28,108,200},
      thickness=0.5));
  connect(La_DynamicLoad.epp, Transformer_L_a.epp_n) annotation (Line(
      points={{14,-20},{-6,-20},{-6,-8}},
      color={28,108,200},
      thickness=0.5));
  connect(OLTC_L_a.epp, Transformer_L_a.epp_n) annotation (Line(
      points={{-10,-19},{-10,-19},{-10,-20},{-6,-20},{-6,-8}},
      color={28,108,200},
      thickness=0.5));
  connect(OLTC_L1.epp, L1_DynamicLoad.epp) annotation (Line(
      points={{-74,-50},{-48,-50}},
      color={28,108,200},
      thickness=0.5));
  connect(Transformer_L1.epp_n, L1_DynamicLoad.epp) annotation (Line(
      points={{-60,-30},{-60,-50},{-48,-50}},
      color={28,108,200},
      thickness=0.5));
  connect(L2_DynamicLoad.epp, Transformer_L2.epp_n) annotation (Line(
      points={{296,40},{268,40}},
      color={28,108,200},
      thickness=0.5));
  connect(OLTC_L2.epp, Transformer_L2.epp_n) annotation (Line(
      points={{274,80},{280,80},{280,40},{268,40}},
      color={28,108,200},
      thickness=0.5));
  connect(globalFrequency.epp, biomass_G1_Slack.epp) annotation (Line(
      points={{-102,18},{-86,18},{-86,59.8},{-91.4,59.8}},
      color={28,108,200},
      thickness=0.5));
  connect(Bus_1.epp_[1], biomass_G1_Slack.epp) annotation (Line(
      points={{-73,19.3333},{-82,19.3333},{-82,59.8},{-91.4,59.8}},
      color={28,108,200},
      thickness=0.5));
  connect(Bus_1.epp_[2], transmissionLine_Northern.epp_p) annotation (Line(
      points={{-73,20},{-62,20},{-62,40},{-50,40}},
      color={28,108,200},
      thickness=0.5));
  connect(Bus_1.epp_[3], Transformer_L1.epp_p) annotation (Line(
      points={{-73,20.6667},{-66,20.6667},{-66,-10},{-60,-10}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine_Northern.epp_n, Bus_2.epp_[1]) annotation (Line(
      points={{-22,40},{-14,40},{-14,27.2},{-7,27.2}},
      color={28,108,200},
      thickness=0.5));
  connect(Bus_2.epp_[2], Transformer_L_a.epp_p) annotation (Line(
      points={{-7,27.6},{-6,27.6},{-6,12}},
      color={28,108,200},
      thickness=0.5));
  connect(Bus_2.epp_[3], transmissionLine_Central.epp_p) annotation (Line(
      points={{-7,28},{6,28},{6,40},{18,40}},
      color={28,108,200},
      thickness=0.5));
  connect(Bus_2.epp_[4], transmissionLine_CentralFault.epp_p) annotation (Line(
      points={{-7,28.4},{-7,51},{16,51},{16,74}},
      color={28,108,200},
      thickness=0.5));
  connect(Bus_2.epp_[5], pQBoundary1.epp) annotation (Line(
      points={{-7,28.8},{-12,28.8},{-12,80},{-18,80}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine_Central.epp_n, Bus_3.epp_[1]) annotation (Line(
      points={{38,40},{54,40},{54,35.2},{69,35.2}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine_CentralFault.epp_n, Bus_3.epp_[2]) annotation (Line(
      points={{36,74},{52,74},{52,35.6},{69,35.6}},
      color={28,108,200},
      thickness=0.5));
  connect(biomass_G3.epp, Bus_3.epp_[3]) annotation (Line(
      points={{67.2,90.4},{67.2,63.2},{69,63.2},{69,36}},
      color={28,108,200},
      thickness=0.5));
  connect(Bus_3.epp_[4], transmissionLine_CentralLower.epp_p) annotation (Line(
      points={{69,36.4},{80,36.4},{80,26},{96,26},{96,40},{116,40}},
      color={28,108,200},
      thickness=0.5));
  connect(Bus_3.epp_[5], Transformer_L_b.epp_p) annotation (Line(
      points={{69,36.8},{80,36.8},{80,18},{90,18}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine_CentralLower.epp_n, Bus_4.epp_[1]) annotation (Line(
      points={{140,40},{150,40},{150,25.25},{157,25.25}},
      color={28,108,200},
      thickness=0.5));
  connect(Bus_4.epp_[2], pQBoundary2.epp) annotation (Line(
      points={{157,25.75},{158,25.75},{158,85}},
      color={28,108,200},
      thickness=0.5));
  connect(Bus_4.epp_[3], transmissionLine_Southern.epp_p) annotation (Line(
      points={{157,26.25},{170,26.25},{170,40},{184,40}},
      color={28,108,200},
      thickness=0.5));
  connect(Bus_4.epp_[4], Transformer_L_c.epp_p) annotation (Line(
      points={{157,26.75},{158,26.75},{158,12},{162,12}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine_Southern.epp_n, Bus_5.epp_[1]) annotation (Line(
      points={{208,40},{220,40},{220,21.3333},{231,21.3333}},
      color={28,108,200},
      thickness=0.5));
  connect(biomass_G2.epp, Bus_5.epp_[2]) annotation (Line(
      points={{222.9,80.7},{222.9,51.35},{231,51.35},{231,22}},
      color={28,108,200},
      thickness=0.5));
  connect(Bus_5.epp_[3], Transformer_L2.epp_p) annotation (Line(
      points={{231,22.6667},{231,31},{248,31},{248,40}},
      color={28,108,200},
      thickness=0.5));
  connect(integrator.u, globalFrequency.f) annotation (Line(points={{-135.6,80},{-140,80},{-140,18},{-114.24,18}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent={{-160,-100},{320,120}}), graphics={Text(
            extent={{-84,70},{-38,62}},
            lineColor={28,108,200},
            textString="2 parallel AC lines"),Text(
            extent={{-136,122},{-50,112}},
            lineColor={28,108,200},
            textString="N5area Test System (NORDIC 32 adoptation)")}),
    Icon(coordinateSystem(extent={{-160,-100},{320,120}}), graphics={Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-160,-246},{320,242}}), Polygon(
          points={{-24,-80},{-44,-98},{14,-160},{38,-152},{202,160},{174,172},{32,-166},{-8,-128},{-24,-80}},
          smooth=Smooth.Bezier,
          fillColor={0,124,124},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
    experiment(StopTime=600, __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Example model for voltage collapse and test of OLTC and Busbar</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Simulation model with full dynamics</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Simplified Test grid</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no further remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created created by Markus Dressel in March 2020</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised and added to TransiEnt Library by Jan-Peter Heckel (jan.heckel@tuhh.de) in July 2020</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model based on work by Zahra Nadia Faili (zahra.faili@tuhh.de) in July 2019 </span></p>
</html>"));
end CheckElectricBusbarComplex;
