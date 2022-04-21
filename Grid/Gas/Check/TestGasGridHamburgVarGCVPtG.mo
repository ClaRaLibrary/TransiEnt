within TransiEnt.Grid.Gas.Check;
model TestGasGridHamburgVarGCVPtG "High pressure gas grid of Hamburg with variable gross calorific value at consumption side"


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





  extends TransiEnt.Basics.Icons.Checkmodel;

  //Scaling factors
  parameter Real f_gasDemand=simCenter.f_gasDemand "Scale factor for gas demand";
  parameter Real f_Rei=0.465119;
  parameter Real f_Lev=0.268173;
  parameter Real f_Tor=1 - f_Rei - f_Lev;

  //Electrolyzer
  parameter SI.ActivePower P_el_n=140e6 annotation (Evaluate=false);
  parameter SI.ActivePower P_el_min=0.04*P_el_n annotation (Evaluate=false);
  parameter SI.ActivePower P_el_overload=1.0*P_el_n annotation (Evaluate=false);
  parameter SI.ActivePower P_el_max=1.68*P_el_n annotation (Evaluate=false);
  parameter SI.Efficiency eta_n=0.75 annotation (Evaluate=false);
  parameter SI.Time t_overload=30*60 annotation (Evaluate=false);
  parameter Real coolingToHeatingRatio=1 annotation (Evaluate=false);
  parameter SI.Pressure p_ely=simCenter.p_amb_const + 35e5 annotation (Evaluate=false);

  //FeedInControl
  parameter Real phi_H2max=0.1 annotation (Evaluate=false);
  parameter Real k_feedIn=1e6 annotation (Evaluate=false);
  parameter SI.Volume V_mixH2=1 annotation (Evaluate=false);
  parameter SI.Volume V_mixNG=1 annotation (Evaluate=false);

  //Storage
  parameter SI.Pressure p_maxLow=17400000 annotation (Evaluate=false);
  parameter SI.Pressure p_maxHigh=17500000 annotation (Evaluate=false);
  parameter SI.Volume V_geo=10000 annotation (Evaluate=false);
  parameter SI.Pressure p_start=11000000 annotation (Evaluate=false);
  parameter SI.Temperature T_start=325.45 annotation (Evaluate=false);
  parameter SI.Pressure p_minLow=5800000 annotation (Evaluate=false);
  parameter SI.Pressure p_minHigh=6000000 annotation (Evaluate=false);

  //Pipe Network
  parameter Real Nper10km=2 "Number of discrete volumes in 10 km pipe length";
  parameter Integer massBalance=1 "Mass balance and species balance fomulation" annotation (Dialog(group="Fundamental Definitions"), choices(
      choice=1 "ClaRa formulation",
      choice=2 "TransiEnt formulation 1a",
      choice=3 "TransiEnt formulation 1b",
      choice=4 "Quasi-Stationary"));
  replaceable model PressureLoss = Components.Gas.VolumesValvesFittings.Base.PhysicalPL_L4                     constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseVLE_L4 "Pressure loss model" annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  //Consumers
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.P "|Controller|Type of controller";
  parameter Real k_consumer=1e6 "|Controller|Gain for controller in maximum feed in control";
  parameter Real Ti=0.04 "|Controller|Integrator time constant for controller in maximum feed in control";
  parameter Real Td=0.01 "|Controller|Derivative time constant for controller in maximum feed in control";

  // Variable declarations
  SI.Energy H_demand "Gas demand";
  SI.Mass m_H2_max(
    start=0,
    fixed=true,
    stateSelect=StateSelect.never) "Maximal H2 mass that could be fed into the gas grid";
  SI.Mass m_gas_import=-(GTS_Tornesch.m + GTS_Leversen.m + GTS_Reitbrook.m) "Gas demand with H2 fed into the grid";

  inner TransiEnt.SimCenter simCenter(
    p_amb=101343,
    T_amb=283.15,
    tableInterpolationSmoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2) annotation (Placement(transformation(extent={{-300,212},{-271,242}})));

  TransiEnt.Grid.Gas.GasGridHamburg gasGridHamburg(
    Nper10km=Nper10km,
    volume_junction=10,
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(extent={{-164,-196},{214,184}})));

  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow Harburg(
    N_cv=if integer(Nper10km*Harburg.length/10000) < 1 then 1 else integer(Nper10km*Harburg.length/10000),
    useIsothPipe=true,
    massBalance=massBalance,
    length(displayUnit="km") = districtPipes.length[1],
    diameter=districtPipes.diameter[1],
    N_tubes=districtPipes.N_ducts[1],
    controllerType=controllerType,
    k=k_consumer,
    Ti=Ti,
    Td=Td,
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(extent={{-28,-91},{-8,-71}})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow Altona(
    N_cv=if integer(Nper10km*Altona.length/10000) < 1 then 1 else integer(Nper10km*Altona.length/10000),
    useIsothPipe=true,
    massBalance=massBalance,
    length(displayUnit="km") = districtPipes.length[2],
    diameter=districtPipes.diameter[2],
    N_tubes=districtPipes.N_ducts[2],
    controllerType=controllerType,
    k=k_consumer,
    Ti=Ti,
    Td=Td,
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(extent={{-46,-15},{-26,5}})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow Eimsbuettel(
    N_cv=if integer(Nper10km*Eimsbuettel.length/10000) < 1 then 1 else integer(Nper10km*Eimsbuettel.length/10000),
    useIsothPipe=true,
    massBalance=massBalance,
    length(displayUnit="km") = districtPipes.length[3],
    diameter=districtPipes.diameter[3],
    N_tubes=districtPipes.N_ducts[3],
    controllerType=controllerType,
    k=k_consumer,
    Ti=Ti,
    Td=Td,
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(extent={{-36,25},{-16,45}})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow HHNord(
    N_cv=if integer(Nper10km*HHNord.length/10000) < 1 then 1 else integer(Nper10km*HHNord.length/10000),
    useIsothPipe=true,
    massBalance=massBalance,
    length(displayUnit="km") = districtPipes.length[4],
    diameter=districtPipes.diameter[4],
    N_tubes=districtPipes.N_ducts[4],
    controllerType=controllerType,
    k=k_consumer,
    Ti=Ti,
    Td=Td,
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={14,92})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow Wandsbek(
    N_cv=if integer(Nper10km*Wandsbek.length/10000) < 1 then 1 else integer(Nper10km*Wandsbek.length/10000),
    useIsothPipe=true,
    massBalance=massBalance,
    length(displayUnit="km") = districtPipes.length[5],
    diameter=districtPipes.diameter[5],
    N_tubes=districtPipes.N_ducts[5],
    controllerType=controllerType,
    k=k_consumer,
    Ti=Ti,
    Td=Td,
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={66,50})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow HHMitte(
    N_cv=if integer(Nper10km*HHMitte.length/10000) < 1 then 1 else integer(Nper10km*HHMitte.length/10000),
    useIsothPipe=true,
    massBalance=massBalance,
    length(displayUnit="km") = districtPipes.length[6],
    diameter=districtPipes.diameter[6],
    N_tubes=districtPipes.N_ducts[6],
    controllerType=controllerType,
    k=k_consumer,
    Ti=Ti,
    Td=Td,
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={62,-31})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow Bergedorf(
    N_cv=if integer(Nper10km*Bergedorf.length/10000) < 1 then 1 else integer(Nper10km*Bergedorf.length/10000),
    useIsothPipe=true,
    massBalance=massBalance,
    length(displayUnit="km") = districtPipes.length[7],
    diameter=districtPipes.diameter[7],
    N_tubes=districtPipes.N_ducts[7],
    controllerType=controllerType,
    k=k_consumer,
    Ti=Ti,
    Td=Td,
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={72,-66})));

  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-270,212},{-239,242}})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Lev(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-138,-160})));
public
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi GTS_Leversen(m(fixed=true)) annotation (Placement(transformation(extent={{-188,-176},{-156,-144}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Leversen(compositionDefinedBy=2, flowDefinition=3) annotation (Placement(transformation(extent={{-90,-160},{-70,-140}})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Tor(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{-10,10.5},{10,-10.5}},
        rotation=0,
        origin={-216,142.5})));
public
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi GTS_Tornesch(m(fixed=true)) annotation (Placement(transformation(extent={{-266,126},{-234,158}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Tornesch(compositionDefinedBy=2, flowDefinition=3) annotation (Placement(transformation(extent={{-164,142},{-144,162}})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Rei(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={194,-66})));
  Modelica.Blocks.Math.Gain gainTor(k=f_Tor) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-184,38})));
  Modelica.Blocks.Math.Gain gainLev(k=f_Lev) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-111,-45})));
  Modelica.Blocks.Math.Gain gainRei(k=f_Rei) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={164,-206})));
public
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi GTS_Reitbrook(m(fixed=true)) annotation (Placement(transformation(
        extent={{-18,17},{18,-17}},
        rotation=180,
        origin={232,-66})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Reitbrook(compositionDefinedBy=2, flowDefinition=3) annotation (Placement(transformation(extent={{146,-66},{126,-46}})));
  inner TransiEnt.Basics.Records.PipeParameter ringPipes(
    N_pipes=12,
    length={2353.4,9989.1,10203.5,11846.6,7285.6,10878.7,4420.5,11961.1,10915.2,13932.2,28366.9,16710},
    diameter(displayUnit="m") = {0.6,0.4,0.4,0.4,0.4,0.4,0.5,0.4,0.4,0.607307197,0.6,0.5},
    m_flow_nom={20.2,10.1,10.1,12.4,0.3,10.5,21.9,6.7,10.1,30.6,3.6,32.4},
    Delta_p_nom(displayUnit="Pa") = {10605,63939.6,63939.6,184435.5,56.5,125548.4,67207.8,56975.5,116965.7,140705.4,3963.8,133488.2}) annotation (Placement(transformation(extent={{-296,186},{-276,206}})));
  inner TransiEnt.Basics.Records.PipeParameter districtPipes(
    N_pipes=7,
    f_mFlow={0.0869,0.1346,0.1199,0.1688,0.187,0.2267,0.076},
    length={3774,5152,2739,10564,4075,9480,6770},
    diameter={0.221,0.221,0.221,0.221,0.221,0.221,0.221},
    N_ducts={4,5,5,6,7,8,3},
    m_flow_nom={7.83,12.12,10.8,15.2,16.83,20.42,6.84},
    Delta_p_nom(displayUnit="Pa") = {31226.22,78102.46,31207.91,126637.22,63836.59,152213.2,73490.95}) annotation (Placement(transformation(extent={{-266,186},{-246,206}})));

  TransiEnt.Basics.Tables.GasGrid.NaturalGasVolumeFlowSTP H_flow_demand(constantfactor=simCenter.f_gasDemand*12.14348723*3.6e6) annotation (Placement(transformation(extent={{78,-146},{42,-110}})));

  Modelica.Blocks.Math.Gain shareHar(k=districtPipes.f_mFlow[1]) annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=180,
        origin={5,-81})));
  Modelica.Blocks.Math.Gain shareAlt(k=districtPipes.f_mFlow[2]) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={-12,-6})));
  Modelica.Blocks.Math.Gain shareEim(k=districtPipes.f_mFlow[3]) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={-6,36})));
  Modelica.Blocks.Math.Gain shareNor(k=districtPipes.f_mFlow[4]) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=180,
        origin={-6,92})));
  Modelica.Blocks.Math.Gain shareWan(k=districtPipes.f_mFlow[5]) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=180,
        origin={44,50})));
  Modelica.Blocks.Math.Gain shareMit(k=districtPipes.f_mFlow[6]) annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=180,
        origin={39,-31})));
  Modelica.Blocks.Math.Gain shareBer(k=districtPipes.f_mFlow[7]) annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=180,
        origin={47,-66})));

  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2_isoth junction_Leversen(final volume=gasGridHamburg.volume_junction) annotation (Placement(transformation(extent={{96,-76},{116,-56}})));
  TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_CavernComp FeedIn_Tornesch(
    T_out=simCenter.T_ground,
    p_out=p_ely,
    t_overload=t_overload,
    eta_n=eta_n,
    useIsothMix=true,
    k=k_feedIn,
    alpha_nom=133,
    p_start=p_start,
    T_start=T_start,
    coolingToHeatingRatio=coolingToHeatingRatio,
    volume_junction=V_mixH2,
    P_el_n=P_el_n*f_Tor,
    P_el_max=P_el_max*f_Tor,
    P_el_min=P_el_min*f_Tor,
    P_el_overload=P_el_overload*f_Tor,
    V_geo=V_geo*f_Tor,
    p_maxHigh=p_maxHigh,
    p_maxLow=p_maxLow,
    p_minLow=p_minLow,
    p_minHigh=p_minHigh) annotation (Placement(transformation(
        extent={{-23,-23},{23,23}},
        rotation=180,
        origin={-184.5,96})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid annotation (Placement(transformation(
        extent={{-19,20},{19,-20}},
        rotation=180,
        origin={-251,-196})));
  TransiEnt.Basics.Tables.ElectricGrid.ResidualLoadExample P_residual_neg(negResidualLoad=true) annotation (Placement(transformation(extent={{-270,-150},{-232,-114}})));
  TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_CavernComp FeedIn_Leversen(
    T_out=simCenter.T_ground,
    p_out=p_ely,
    t_overload=t_overload,
    eta_n=eta_n,
    useIsothMix=true,
    k=k_feedIn,
    alpha_nom=133,
    p_start=p_start,
    T_start=T_start,
    coolingToHeatingRatio=coolingToHeatingRatio,
    volume_junction=V_mixH2,
    P_el_n=P_el_n*f_Lev,
    P_el_max=P_el_max*f_Lev,
    P_el_min=P_el_min*f_Lev,
    P_el_overload=P_el_overload*f_Lev,
    V_geo=V_geo*f_Lev,
    p_maxHigh=p_maxHigh,
    p_maxLow=p_maxLow,
    p_minLow=p_minLow,
    p_minHigh=p_minHigh) annotation (Placement(transformation(
        extent={{-23,23},{23,-23}},
        rotation=180,
        origin={-110.5,-105})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2_isoth Mix_Leversen(volume=V_mixNG) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-108,-160})));
  TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_CavernComp FeedIn_Reitbrook(
    T_out=simCenter.T_ground,
    p_out=p_ely,
    t_overload=t_overload,
    eta_n=eta_n,
    useIsothMix=true,
    k=k_feedIn,
    alpha_nom=133,
    p_start=p_start,
    T_start=T_start,
    coolingToHeatingRatio=coolingToHeatingRatio,
    volume_junction=V_mixH2,
    P_el_n=P_el_n*f_Rei,
    P_el_max=P_el_max*f_Rei,
    P_el_min=P_el_min*f_Rei,
    P_el_overload=P_el_overload*f_Rei,
    V_geo=V_geo*f_Rei,
    p_maxHigh=p_maxHigh,
    p_maxLow=p_maxLow,
    p_minLow=p_minLow,
    p_minHigh=p_minHigh) annotation (Placement(transformation(
        extent={{23,-23},{-23,23}},
        rotation=180,
        origin={163.5,-145})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2_isoth Mix_Tornesch(volume=V_mixNG) annotation (Placement(transformation(extent={{-194,132},{-174,152}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2_isoth Mix_Reitbrook(volume=V_mixNG) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={162,-66})));
equation
  der(H_demand) = H_flow_demand.y1;
  der(m_H2_max) = maxH2MassFlow_Rei.m_flow_H2_max + maxH2MassFlow_Lev.m_flow_H2_max + maxH2MassFlow_Tor.m_flow_H2_max;

  connect(gasGridHamburg.offTakeEimsbuettel, Eimsbuettel.fluidPortIn) annotation (Line(
      points={{-42.8176,35.3529},{-38.5276,35.3529},{-38.5276,35},{-36,35}},
      color={255,255,0},
      thickness=1.5));
  connect(HHNord.fluidPortIn, gasGridHamburg.offTakeNord) annotation (Line(
      points={{24,92},{29.4471,92},{29.4471,106.882}},
      color={255,255,0},
      thickness=1.5));
  connect(Wandsbek.fluidPortIn, gasGridHamburg.offTakeWandsbek) annotation (Line(
      points={{76,50},{87.2588,50},{87.2588,52.1176}},
      color={255,255,0},
      thickness=1.5));
  connect(HHMitte.fluidPortIn, gasGridHamburg.offTakeMitte) annotation (Line(
      points={{72,-31},{78.3647,-31},{78.3647,-29.4706}},
      color={255,255,0},
      thickness=1.5));
  connect(Altona.fluidPortIn, gasGridHamburg.offTakeAltona) annotation (Line(
      points={{-46,-5},{-50,-5},{-50,-4.88235},{-61.7176,-4.88235}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeHarburg, Harburg.fluidPortIn) annotation (Line(
      points={{-41.7059,-82},{-31.6034,-82},{-31.6034,-81},{-28,-81}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Leversen.gasPort, maxH2MassFlow_Lev.gasPortIn) annotation (Line(
      points={{-156,-160},{-148,-160}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Tornesch.gasPort, maxH2MassFlow_Tor.gasPortIn) annotation (Line(
      points={{-234,142},{-234,142.5},{-226,142.5}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Reitbrook.gasPort, maxH2MassFlow_Rei.gasPortIn) annotation (Line(
      points={{214,-66},{204,-66}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Tornesch.gasPortOut, gasGridHamburg.GTSTor) annotation (Line(
      points={{-144,142},{-132.871,142},{-132.871,141.529}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Leversen.gasPortOut, gasGridHamburg.GTSLev) annotation (Line(
      points={{-70,-160},{-57.2706,-160},{-57.2706,-160.235}},
      color={255,255,0},
      thickness=1.5));
  connect(shareWan.y, Wandsbek.H_flow) annotation (Line(points={{50.6,50},{50,50},{55,50}}, color={0,0,127}));
  connect(shareNor.y, HHNord.H_flow) annotation (Line(points={{0.6,92},{0.6,92},{3,92}}, color={0,0,127}));
  connect(Eimsbuettel.H_flow, shareEim.y) annotation (Line(points={{-15,35},{-14,35},{-14,36},{-12.6,36}}, color={0,0,127}));
  connect(Altona.H_flow, shareAlt.y) annotation (Line(points={{-25,-5},{-16,-5},{-16,-6},{-18.6,-6}}, color={0,0,127}));
  connect(Harburg.H_flow, shareHar.y) annotation (Line(points={{-7,-81},{-2.7,-81}}, color={0,0,127}));
  connect(shareWan.u, H_flow_demand.y1) annotation (Line(
      points={{36.8,50},{24,50},{24,-128},{40.2,-128}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareEim.u, H_flow_demand.y1) annotation (Line(
      points={{1.2,36},{24,36},{24,-128},{40.2,-128}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareAlt.u, H_flow_demand.y1) annotation (Line(
      points={{-4.8,-6},{24,-6},{24,-128},{40.2,-128}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareMit.u, H_flow_demand.y1) annotation (Line(
      points={{30.6,-31},{24,-31},{24,-128},{40.2,-128}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareHar.u, H_flow_demand.y1) annotation (Line(
      points={{13.4,-81},{24,-81},{24,-128},{40.2,-128}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareBer.u, H_flow_demand.y1) annotation (Line(
      points={{38.6,-66},{24,-66},{24,-128},{40.2,-128}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareNor.u, H_flow_demand.y1) annotation (Line(
      points={{-13.2,92},{-18,92},{-18,72},{24,72},{24,-128},{40.2,-128}},
      color={0,0,127},
      pattern=LinePattern.Dash));

  connect(HHMitte.H_flow, shareMit.y) annotation (Line(points={{51,-31},{48,-31},{46.7,-31}}, color={0,0,127}));
  connect(vleCompositionSensor_Reitbrook.gasPortOut, junction_Leversen.gasPort3) annotation (Line(
      points={{126,-66},{116,-66}},
      color={255,255,0},
      thickness=1.5));
  connect(junction_Leversen.gasPort2, gasGridHamburg.offTakeBergedorf) annotation (Line(
      points={{106,-76},{106,-82},{106,-88.7059},{106.159,-88.7059}},
      color={255,255,0},
      thickness=1.5));
  connect(Bergedorf.fluidPortIn, junction_Leversen.gasPort1) annotation (Line(
      points={{82,-66},{96,-66}},
      color={255,255,0},
      thickness=1.5));
  connect(shareBer.y, Bergedorf.H_flow) annotation (Line(points={{54.7,-66},{61,-66}}, color={0,0,127}));
  connect(gainTor.y, FeedIn_Tornesch.P_el_set) annotation (Line(
      points={{-184,49},{-184.5,49},{-184.5,72.08}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Mix_Leversen.gasPort2, FeedIn_Leversen.gasPortOut) annotation (Line(
      points={{-108,-150},{-108,-127.77},{-110.5,-127.77}},
      color={255,255,0},
      thickness=1.5));
  connect(gainLev.y, FeedIn_Leversen.P_el_set) annotation (Line(
      points={{-111,-56},{-110.5,-56},{-110.5,-81.08}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(gainRei.y, FeedIn_Reitbrook.P_el_set) annotation (Line(
      points={{164,-195},{163.5,-195},{163.5,-168.92}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(maxH2MassFlow_Rei.m_flow_H2_max, FeedIn_Reitbrook.m_flow_feedIn) annotation (Line(
      points={{194,-75},{194,-163.4},{186.5,-163.4}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Mix_Tornesch.gasPort2, FeedIn_Tornesch.gasPortOut) annotation (Line(
      points={{-184,132},{-184,118.77},{-184.5,118.77}},
      color={255,255,0},
      thickness=1.5));
  connect(maxH2MassFlow_Tor.m_flow_H2_max, FeedIn_Tornesch.m_flow_feedIn) annotation (Line(
      points={{-216,133.05},{-216,77.6},{-207.5,77.6}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Mix_Tornesch.gasPort3, vleCompositionSensor_Tornesch.gasPortIn) annotation (Line(
      points={{-174,142},{-164,142}},
      color={255,255,0},
      thickness=1.5));
  connect(Mix_Tornesch.gasPort1, maxH2MassFlow_Tor.gasPortOut) annotation (Line(
      points={{-194,142},{-200,142},{-200,142.5},{-206,142.5}},
      color={255,255,0},
      thickness=1.5));
  connect(Mix_Reitbrook.gasPort2, FeedIn_Reitbrook.gasPortOut) annotation (Line(
      points={{162,-76},{162,-122.23},{163.5,-122.23}},
      color={255,255,0},
      thickness=1.5));
  connect(maxH2MassFlow_Lev.gasPortOut, Mix_Leversen.gasPort1) annotation (Line(
      points={{-128,-160},{-118,-160}},
      color={255,255,0},
      thickness=1.5));
  connect(Mix_Leversen.gasPort3, vleCompositionSensor_Leversen.gasPortIn) annotation (Line(
      points={{-98,-160},{-94,-160},{-94,-160},{-90,-160}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Reitbrook.gasPortIn, Mix_Reitbrook.gasPort3) annotation (Line(
      points={{146,-66},{152,-66}},
      color={255,255,0},
      thickness=1.5));
  connect(Mix_Reitbrook.gasPort1, maxH2MassFlow_Rei.gasPortOut) annotation (Line(
      points={{172,-66},{184,-66}},
      color={255,255,0},
      thickness=1.5));
  connect(P_residual_neg.P_el, gainTor.u) annotation (Line(
      points={{-230.1,-132},{-184,-132},{-184,26}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(P_residual_neg.P_el, gainLev.u) annotation (Line(
      points={{-230.1,-132},{-184,-132},{-184,-18},{-111,-18},{-111,-33}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(P_residual_neg.P_el, gainRei.u) annotation (Line(
      points={{-230.1,-132},{-206,-132},{-206,-234},{164,-234},{164,-218}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(ElectricGrid.epp, FeedIn_Reitbrook.epp) annotation (Line(
      points={{-232,-196},{116,-196},{116,-145},{140.5,-145}},
      color={0,135,135},
      thickness=0.5));
  connect(FeedIn_Tornesch.epp, FeedIn_Reitbrook.epp) annotation (Line(
      points={{-161.5,96},{-148,96},{-148,-138},{-216,-138},{-216,-196},{116,-196},{116,-145},{140.5,-145}},
      color={0,135,135},
      thickness=0.5));
  connect(FeedIn_Leversen.epp, FeedIn_Reitbrook.epp) annotation (Line(
      points={{-87.5,-105},{-76,-105},{-76,-8},{-148,-8},{-148,-138},{-216,-138},{-216,-196},{116,-196},{116,-145},{140.5,-145}},
      color={0,135,135},
      thickness=0.5));
  connect(maxH2MassFlow_Lev.m_flow_H2_max, FeedIn_Leversen.m_flow_feedIn) annotation (Line(
      points={{-138,-151},{-138,-86.6},{-133.5,-86.6}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (
    Diagram(coordinateSystem(extent={{-300,-240},{280,240}}, preserveAspectRatio=false)),
    Icon(graphics, coordinateSystem(extent={{-300,-240},{280,240}})),
    experiment(
      StopTime=2592000,
      Interval=900,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput(inputs=false, events=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for open-loop high pressure gas ring grid of Hamburg with variable gas composition calculation. At the three gas transfer stations, hydrogen is fed into the natural gas and the limitation of it as well as the reaction of the consumers can be observed.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The methodology is described in [1].</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] L. Andresen, P. Dubucq, R. Peniche Garcia, G. Ackermann, A. Kather, and G. Schmitz, &ldquo;Transientes Verhalten gekoppelter Energienetze mit hohem Anteil Erneuerbarer Energien: Abschlussbericht des Verbundvorhabens,&rdquo; Hamburg, 2017.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Lisa Andresen (andresen@tuhh.de), Jun 2016</p>
<p>Modified by Carsten Bode (c.bode@tuhh.de), May 2020 (updated to new models and improved numerical behavior)</p>
</html>"),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end TestGasGridHamburgVarGCVPtG;
