within TransiEnt.Components.Electrical.PowerTransformation.Check;
model GridN5AreaFirstVoltageCollapse "Example model for voltage collapse for testing OLTC"
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

  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced transmissionLine_Northern_2(
    ChooseVoltageLevel=3,
    p=2,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L6,
    l(displayUnit="km") = 200000) annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  inner TransiEnt.SimCenter simCenter(v_n(displayUnit="kV") = 380000)
    annotation (Placement(transformation(extent={{-148,-98},{-128,-78}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-110,
            -98},{-90,-78}})));

  TransiEnt.Consumer.Electrical.DynamicExponentialElectricConsumerComplex Lb_DynamicLoad(
    Tp=60,
    Tq=30,
    alpha_s=0.38,
    alpha_t=2.26,
    beta_s=2,
    beta_t=10,
    v_n(displayUnit="kV") = 220000,
    P_n(displayUnit="MW") = 1522500000,
    Q_n=558.25e6)
               annotation (Placement(transformation(extent={{102,-30},{122,-10}})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced transmissionLine_Central(
    ChooseVoltageLevel=3,
    p=2,
    MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L1,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L6,
    l(displayUnit="km") = 200000)
    annotation (Placement(transformation(extent={{18,30},{38,50}})));

  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced transmissionLine_CentralFault(
    activateSwitch=true,
    ChooseVoltageLevel=3,
    p=2,
    MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L1,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L4,
    l(displayUnit="km") = 200000)
    annotation (Placement(transformation(extent={{16,64},{36,84}})));

  Modelica.Blocks.Sources.BooleanStep  BooleanFault(
    startTime(displayUnit="s") = 400)
    annotation (Placement(transformation(extent={{-10,92},{6,108}})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced transmissionLine_CentralLower_1(
    activateSwitch=false,
    ChooseVoltageLevel=3,
    p=2,
    LVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K2,
    MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L1,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L6,
    l(displayUnit="km") = 300000) annotation (Placement(transformation(extent={{98,28},{122,52}})));

  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced transmissionLine_Southern_2(
    activateSwitch=false,
    ChooseVoltageLevel=3,
    p=2,
    LVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K1,
    MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L1,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L6,
    l(displayUnit="km") = 250000) annotation (Placement(transformation(extent={{208,28},{232,52}})));

  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced transmissionLine_CentralLower_2(
    activateSwitch=false,
    ChooseVoltageLevel=3,
    p=2,
    LVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K2,
    MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L1,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L6,
    l(displayUnit="km") = 300000) annotation (Placement(transformation(extent={{134,28},{158,52}})));

  TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary pQBoundary3(
    useInputConnectorP=false,
    useInputConnectorQ=false,
    v_n(displayUnit="kV") = 380000)
                                   annotation (Placement(transformation(extent={{132,68},{118,82}})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced transmissionLine_Northern_1(
    ChooseVoltageLevel=3,
    p=2,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L6,
    l(displayUnit="km") = 200000) annotation (Placement(transformation(extent={{-70,30},{-50,50}})));
  TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary pQBoundary4(
    useInputConnectorP=false,
    useInputConnectorQ=false,
    v_n(displayUnit="kV") = 380000)
                                   annotation (Placement(transformation(extent={{-50,72},{-66,88}})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced transmissionLine_Southern_1(
    activateSwitch=false,
    ChooseVoltageLevel=3,
    p=2,
    LVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K1,
    MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L1,
    HVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.HVCabletypes.L6,
    l(displayUnit="km") = 250000) annotation (Placement(transformation(extent={{176,28},{200,52}})));
  TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary pQBoundary5(
    useInputConnectorP=false,
    useInputConnectorQ=false,
    v_n(displayUnit="kV") = 380000)
                                   annotation (Placement(transformation(extent={{204,2},{188,16}})));

  TransiEnt.Components.Electrical.PowerTransformation.SimpleTransformerComplex Transformer_L1(
    UseInput=true,
    U_P(displayUnit="kV") = 380000,
    U_S(displayUnit="kV") = 220000,
    P_p(displayUnit="MW", start=15000000),
    P_n(displayUnit="MW", start=-15000000)) annotation (Placement(
        transformation(
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
    P_n(displayUnit="MW", start=-15000000)) annotation (Placement(
        transformation(
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
    P_n(displayUnit="MW", start=-15000000)) annotation (Placement(
        transformation(
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
    P_n(displayUnit="MW", start=-15000000)) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={162,2})));
  TransiEnt.Components.Electrical.PowerTransformation.SimpleTransformerComplex Transformer_L2(
    UseInput=true,
    U_P(displayUnit="kV") = 380000,
    U_S(displayUnit="kV") = 220000,
    P_p(displayUnit="MW", start=15000000),
    P_n(displayUnit="MW", start=-15000000)) annotation (Placement(
        transformation(
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
    redeclare
      TransiEnt.Components.Electrical.Machines.SynchronousMachineComplex
      Generator(IsSlack=true, R_a=0))
    annotation (Placement(transformation(extent={{-118,36},{-90,64}})));

  Modelica.Blocks.Sources.Constant const(k=-biomass_G1_Slack.P_init)
    annotation (Placement(transformation(extent={{-80,86},{-94,100}})));
  Modelica.Blocks.Continuous.Integrator integrator(k=-1.36e5)
                                                            annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=0,
        origin={-126,80})));
  Modelica.Blocks.Sources.RealExpression globalFrequency_reference(y=simCenter.f_n) annotation (Placement(transformation(extent={{-84,10},
            {-106,22}})));
     TransiEnt.Components.Sensors.ElectricFrequencyComplex globalFrequency annotation (Placement(transformation(extent={{-104,
            -14},{-116,-2}})));
  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(extent={{-122,10},
            {-134,22}})));
  TransiEnt.Producer.Electrical.Others.Biomass biomass_G3(
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
    redeclare
      TransiEnt.Components.Electrical.Machines.SynchronousMachineComplex
      Generator(R_a=0))
    annotation (Placement(transformation(extent={{90,70},{66,94}})));

  Modelica.Blocks.Sources.Constant const1(k=-biomass_G3.P_init)
                                                             annotation (Placement(transformation(extent={{116,96},
            {102,110}})));
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
    redeclare
      TransiEnt.Components.Electrical.Machines.SynchronousMachineComplex
      Generator(R_a=0))
    annotation (Placement(transformation(extent={{202,62},{224,84}})));

  Modelica.Blocks.Sources.Constant const2(k=-biomass_G2.P_init)
                                                             annotation (Placement(transformation(extent={{192,92},
            {206,106}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{14,94},{26,106}})));
  TransiEnt.Consumer.Electrical.DynamicExponentialElectricConsumerComplex Lc_DynamicLoad(
    Tp=60,
    Tq=30,
    alpha_s=2.26,
    alpha_t=0.38,
    beta_s=2.5,
    beta_t=2,
    v_n(displayUnit="kV") = 220000,
    Q_n=50.75e6,
    P_n(displayUnit="MW") = 101500000) annotation (Placement(transformation(extent={{194,-30},{216,-8}})));
  TransiEnt.Consumer.Electrical.DynamicExponentialElectricConsumerComplex La_DynamicLoad(
    Tp=60,
    Tq=30,
    alpha_s=0.38,
    alpha_t=2.26,
    beta_s=2,
    beta_t=2.5,
    v_n(displayUnit="kV") = 220000,
    P_n(displayUnit="MW") = 101500000,
    Q_n=50.75e6)
              annotation (Placement(transformation(extent={{14,-30},{34,-10}})));
  TransiEnt.Consumer.Electrical.DynamicExponentialElectricConsumerComplex L1_DynamicLoad(
    Tp=60,
    Tq=30,
    alpha_s=0.38,
    alpha_t=2.26,
    beta_s=2,
    beta_t=2.5,
    v_n(displayUnit="kV") = 220000,
    P_n(displayUnit="MW") = 203000000,
    Q_n=101.5e6)
               annotation (Placement(transformation(extent={{-48,-60},{-28,-40}})));
  TransiEnt.Consumer.Electrical.DynamicExponentialElectricConsumerComplex L2_DynamicLoad(
    Tp=60,
    Tq=30,
    alpha_s=0.38,
    alpha_t=2.26,
    beta_s=2,
    beta_t=2.5,
    v_n(displayUnit="kV") = 220000,
    P_n(displayUnit="MW") = 126875000,
    Q_n=76.125e6)
              annotation (Placement(transformation(extent={{296,30},{316,50}})));
  TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary pQBoundary1(
    useInputConnectorP=false,
    useInputConnectorQ=false,
    v_n(displayUnit="kV") = 380000)
                                   annotation (Placement(transformation(extent={{-18,72},
            {-34,88}})));
  TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary pQBoundary2(
    useInputConnectorP=false,
    useInputConnectorQ=false,
    v_n(displayUnit="kV") = 380000)
                                   annotation (Placement(transformation(extent={{162,72},{146,86}})));
// _____________________________________________
//
//           Functions
// _____________________________________________

function plotResult

  constant String resultFileName = "GridN5AreaFirstVoltageCollapse.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={809, 0, 791, 733}, y={"OLTC_L_a.epp.f"}, grid=true, filename=resultFile);
createPlot(id=2, position={0, 0, 791, 733}, y={"OLTC_L_a.epp.v", "OLTC_L_b.epp.v"}, grid=true, filename=resultFile);
    resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;

// _____________________________________________
//
//               Equations
// _____________________________________________


equation

// _____________________________________________
//
//               Connect Statements
// _____________________________________________

  connect(transmissionLine_Northern_2.epp_n, transmissionLine_Central.epp_p) annotation (Line(
      points={{-20,40},{18,40}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine_CentralFault.epp_p, transmissionLine_Central.epp_p)
    annotation (Line(
      points={{16,74},{6,74},{6,40},{18,40}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine_CentralFault.epp_n, transmissionLine_Central.epp_n)
    annotation (Line(
      points={{36,74},{48,74},{48,40},{38,40}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine_CentralLower_1.epp_p, transmissionLine_Central.epp_n) annotation (Line(
      points={{98,40},{38,40}},
      color={28,108,200},
      thickness=0.5));
  connect(OLTC_L1.RatioOut, Transformer_L1.ratio_set)
    annotation (Line(points={{-92,-50},{-92,-14},{-72,-14}}, color={0,0,127}));
  connect(Transformer_L_a.epp_p, transmissionLine_Central.epp_p) annotation (
      Line(
      points={{-6,12},{-8,12},{-8,40},{18,40}},
      color={28,108,200},
      thickness=0.5));
  connect(OLTC_L_a.RatioOut, Transformer_L_a.ratio_set) annotation (Line(points={{-28,-19},{-40,-19},{-40,8},{-18,8}},
                                                color={0,0,127}));
  connect(Transformer_L_b.epp_p, transmissionLine_Central.epp_n) annotation (
      Line(
      points={{90,18},{90,40},{38,40}},
      color={28,108,200},
      thickness=0.5));
  connect(Transformer_L_b.epp_n, Lb_DynamicLoad.epp) annotation (Line(
      points={{90,-2},{90,-20},{102,-20}},
      color={28,108,200},
      thickness=0.5));
  connect(OLTC_L_b.epp, Lb_DynamicLoad.epp) annotation (Line(
      points={{82,-21},{82,-20},{102,-20}},
      color={28,108,200},
      thickness=0.5));
  connect(OLTC_L_b.RatioOut, Transformer_L_b.ratio_set) annotation (Line(points={{64,-21},{56,-21},{56,14},{78,14}},
                                              color={0,0,127}));
  connect(OLTC_L_c.epp, Transformer_L_c.epp_n) annotation (Line(
      points={{154,-19},{162,-19},{162,-8}},
      color={28,108,200},
      thickness=0.5));
  connect(OLTC_L_c.RatioOut, Transformer_L_c.ratio_set)
    annotation (Line(points={{136,-19},{136,8},{150,8}}, color={0,0,127}));
  connect(OLTC_L2.RatioOut, Transformer_L2.ratio_set)
    annotation (Line(points={{256,80},{252,80},{252,52}}, color={0,0,127}));
  connect(Transformer_L2.epp_p, transmissionLine_Southern_2.epp_n) annotation (Line(
      points={{248,40},{232,40}},
      color={28,108,200},
      thickness=0.5));
  connect(const.y, biomass_G1_Slack.P_el_set) annotation (Line(points={{-94.7,
          93},{-104,93},{-104,63.86},{-106.1,63.86}}, color={0,0,127}));
  connect(integrator.y, biomass_G1_Slack.P_SB_set) annotation (Line(points={{-117.2,
          80},{-116.46,80},{-116.46,62.46}}, color={0,0,127}));
  connect(globalFrequency_reference.y, feedback.u1)
    annotation (Line(points={{-107.1,16},{-123.2,16}}, color={0,0,127}));
  connect(globalFrequency.f, feedback.u2) annotation (Line(points={{-116.24,-8},
          {-128,-8},{-128,11.2}}, color={0,0,127}));
  connect(feedback.y, integrator.u) annotation (Line(points={{-133.4,16},{-140,
          16},{-140,80},{-135.6,80}}, color={0,0,127}));
  connect(const1.y, biomass_G3.P_el_set) annotation (Line(points={{101.3,103},{
          100,103},{100,102},{90,102},{90,93.88},{79.8,93.88}},
                                                    color={0,0,127}));
  connect(biomass_G2.epp, transmissionLine_Southern_2.epp_n) annotation (Line(
      points={{222.9,80.7},{236,80.7},{236,40},{232,40}},
      color={28,108,200},
      thickness=0.5));
  connect(const2.y, biomass_G2.P_el_set) annotation (Line(points={{206.7,99},{
          208,99},{208,100},{218,100},{218,83.89},{211.35,83.89}},
                                                  color={0,0,127}));
  connect(BooleanFault.y, not1.u)
    annotation (Line(points={{6.8,100},{12.8,100}}, color={255,0,255}));
  connect(not1.y, transmissionLine_CentralFault.switched_input) annotation (
      Line(points={{26.6,100},{28,100},{28,84},{26,84}}, color={255,0,255}));
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
  connect(pQBoundary1.epp, transmissionLine_Central.epp_p) annotation (Line(
      points={{-18,80},{-14,80},{-14,40},{18,40}},
      color={28,108,200},
      thickness=0.5));
  connect(biomass_G3.epp, transmissionLine_Central.epp_n) annotation (Line(
      points={{67.2,90.4},{54,90.4},{54,40},{38,40}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine_CentralLower_2.epp_p, transmissionLine_CentralLower_1.epp_n) annotation (Line(
      points={{134,40},{122,40}},
      color={28,108,200},
      thickness=0.5));
  connect(pQBoundary3.epp, transmissionLine_CentralLower_1.epp_n) annotation (Line(
      points={{132,75},{132,40},{122,40}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine_Northern_2.epp_p, transmissionLine_Northern_1.epp_n) annotation (Line(
      points={{-40,40},{-50,40}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine_Northern_1.epp_p, biomass_G1_Slack.epp) annotation (Line(
      points={{-70,40},{-80,40},{-80,59.8},{-91.4,59.8}},
      color={28,108,200},
      thickness=0.5));
  connect(globalFrequency.epp, biomass_G1_Slack.epp) annotation (Line(
      points={{-104,-8},{-80,-8},{-80,59.8},{-91.4,59.8}},
      color={28,108,200},
      thickness=0.5));
  connect(pQBoundary4.epp, transmissionLine_Northern_1.epp_n) annotation (Line(
      points={{-50,80},{-48,80},{-48,40},{-50,40}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine_Southern_2.epp_p, transmissionLine_Southern_1.epp_n) annotation (Line(
      points={{208,40},{200,40}},
      color={28,108,200},
      thickness=0.5));
  connect(transmissionLine_CentralLower_2.epp_n, transmissionLine_Southern_1.epp_p) annotation (Line(
      points={{158,40},{176,40}},
      color={28,108,200},
      thickness=0.5));
  connect(pQBoundary2.epp, transmissionLine_Southern_1.epp_p) annotation (Line(
      points={{162,79},{164,79},{164,40},{176,40}},
      color={28,108,200},
      thickness=0.5));
  connect(Transformer_L_c.epp_p, transmissionLine_Southern_1.epp_p) annotation (Line(
      points={{162,12},{164,12},{164,40},{176,40}},
      color={28,108,200},
      thickness=0.5));
  connect(pQBoundary5.epp, transmissionLine_Southern_1.epp_n) annotation (Line(
      points={{204,9},{204,40},{200,40}},
      color={28,108,200},
      thickness=0.5));
  connect(Transformer_L1.epp_p, biomass_G1_Slack.epp) annotation (Line(
      points={{-60,-10},{-60,16},{-80,16},{-80,59.8},{-91.4,59.8}},
      color={28,108,200},
      thickness=0.5));
  annotation (
    Diagram(coordinateSystem(extent={{-160,-100},{320,120}}), graphics={Text(
          extent={{8,24},{54,16}},
          lineColor={28,108,200},
          textString="2 parallel AC lines"),                            Text(
          extent={{-136,122},{-50,112}},
          lineColor={28,108,200},
          textString="N5area Test System (NORDIC 32 adoptation)")}),
    Icon(coordinateSystem(extent={{-160,-100},{320,120}}), graphics={
                                   Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-160,-246},{320,242}}), Polygon(
          points={{-24,-80},{-44,-98},{14,-160},{38,-152},{202,160},{174,172},{32,-166},{-8,-128},{-24,-80}},
          smooth=Smooth.Bezier,
          fillColor={0,124,124},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
    experiment(StopTime=600, __Dymola_Algorithm="Dassl"),Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Example model for voltage collapse and test of OLTC</span></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Zahra Nadia Faili (zahra.faili@tuhh.de) in July 2019 </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised and added to TransiEnt Library by Jan-Peter Heckel (jan.heckel@tuhh.de) in December 2019 </span></p>
</html>"));
end GridN5AreaFirstVoltageCollapse;
