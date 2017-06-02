within TransiEnt.Grid.Gas.Check;
model TestGasGridHamburgVarGCVPtG "High pressure gas grid of Hamburg with H2 feedin at GTS and variable gross calorific value at consumption side"
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
  import TransiEnt;
  extends TransiEnt.Basics.Icons.Checkmodel;

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
  parameter SI.Time t_overload=30*60 annotation(Evaluate=false);
  parameter Real coolingToHeatingRatio=1 annotation(Evaluate=false);
  parameter SI.Pressure p_ely=simCenter.p_amb_const+50e5 annotation(Evaluate=false);

  //FeedInControl
  parameter Real phi_H2max=0.1 annotation(Evaluate=false);
  parameter Real k_feedIn=1e6 annotation(Evaluate=false);
  parameter SI.Volume V_mixH2=0.1 annotation(Evaluate=false);
  parameter SI.Volume V_mixNG=1 annotation(Evaluate=false);

  //Storage
  parameter SI.Pressure p_max=17500000 annotation(Evaluate=false);
  parameter SI.Volume V_geo=10000 annotation(Evaluate=false);
  parameter SI.Pressure p_start=11000000 annotation(Evaluate=false);//1050000
  parameter SI.Temperature T_start=52.3+273.15 annotation(Evaluate=false);//328.15
  parameter SI.Pressure p_minLow=58e5 annotation(Evaluate=false);
  parameter SI.Pressure p_minHigh=60e5 annotation(Evaluate=false);

  //Consumers
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.P "|Controller|Type of controller";
  parameter Real k_consumer=1e6 "|Controller|Gain for controller in maximum feed in control";
  parameter Real Ti=0.04 "|Controller|Integrator time constant for controller in maximum feed in control";
  parameter Real Td=0.01 "|Controller|Derivative time constant for controller in maximum feed in control";

  //Pipe Network
  parameter Real Nper10km=5 "Number of discrete volumes in 10 km pipe length";
  parameter Boolean productMassBalance=false "Set to true for product component mass balance formulation in pipe";

  // Variable declarations
  SI.Energy H_demand "Gas demand";
  SI.Mass m_H2_max(start=0,fixed=true) "Maximal H2 mass that could be fed into the gas grid" annotation(stateSelect=StateSelect.never);
  SI.Mass m_gas_import=-(GTS_Tornesch.m+GTS_Leversen.m+GTS_Reitbrook.m) "Gas demand with H2 fed into the grid";

  inner TransiEnt.SimCenter simCenter(
    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3,
    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1,
    p_amb=101343,
    T_amb=283.15)             annotation (Placement(transformation(extent={{-286,212},{-258,240}})));

  inner TransiEnt.Grid.Gas.StatCycleGasGridHamburg Init(
    m_flow_feedIn_Tornesch=0.01,
    m_flow_feedIn_Leversen=0.01,
    m_flow_feedIn_Reitbrook=0.01,
    h_source=-1849.95) annotation (Placement(transformation(extent={{-298,180},{-251,214}})));

  TransiEnt.Grid.Gas.GasGridHamburg gasGridHamburg(
    phi_H2max=phi_H2max,
    Nper10km=Nper10km,
    productMassBalance=productMassBalance) annotation (Placement(transformation(extent={{-230,-182},{266,198}})));
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
    productMassBalance=productMassBalance) annotation (Placement(transformation(extent={{-42,-81},{-22,-61}})));
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
    productMassBalance=productMassBalance) annotation (Placement(transformation(extent={{-62,-3},{-42,17}})));
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
    productMassBalance=productMassBalance) annotation (Placement(transformation(extent={{-42,34},{-22,54}})));
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
    productMassBalance=productMassBalance) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={2,84})));
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
    productMassBalance=productMassBalance) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={48,62})));
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
    productMassBalance=productMassBalance) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={42,-18})));
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
    productMassBalance=productMassBalance) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={66,-77})));

  TransiEnt.Basics.Tables.GasGrid.NaturalGasVolumeFlowSTP H_flow_demand(constantfactor=simCenter.f_gasDemand*12.14348723*3.6e6/7) annotation (Placement(transformation(extent={{82,-176},{46,-140}})));

  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-258,212},{-230,240}})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Tor(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{-10,10.5},{10,-10.5}},
        rotation=0,
        origin={-214,154.5})));
public
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi GTS_Tornesch(
    medium=simCenter.gasModel1,
    m(fixed=true),
    p_const=Init.p_source,
    h_const=Init.h_source,
    xi_const=Init.xi_source) annotation (Placement(transformation(extent={{-268,138},{-236,170}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Tornesch(compositionDefinedBy=2) annotation (Placement(transformation(extent={{-156,154},{-136,174}})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Lev(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-152,-140})));
public
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi GTS_Leversen(
    medium=simCenter.gasModel1,
    m(fixed=true),
    p_const=Init.p_source,
    h_const=Init.h_source,
    xi_const=Init.xi_source) annotation (Placement(transformation(extent={{-212,-155},{-180,-123}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Leversen(compositionDefinedBy=2) annotation (Placement(transformation(extent={{-96,-140},{-76,-120}})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Rei(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={212,-76})));
public
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi GTS_Reitbrook(
    medium=simCenter.gasModel1,
    m(fixed=true),
    p_const=Init.p_source,
    h_const=Init.h_source,
    xi_const=Init.xi_source) annotation (Placement(transformation(
        extent={{-18,17},{18,-17}},
        rotation=180,
        origin={258,-75})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Reitbrook(compositionDefinedBy=2) annotation (Placement(transformation(extent={{134,-76},{114,-56}})));
protected
  Modelica.Blocks.Math.Gain gainTor(k=f_Tor) annotation (Placement(transformation(extent={{-120,76},{-140,96}})));
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
    p_low=p_minLow,
    p_high=p_minHigh,
    p_start_junction=Init.mixH2_Tornesch.p,
    h_start_junction=Init.source_H2_Tornesch.h) annotation (Placement(transformation(
        extent={{-23,-23},{23,23}},
        rotation=180,
        origin={-178.5,104})));
protected
  Modelica.Blocks.Math.Gain gainLev(k=f_Lev) annotation (Placement(transformation(extent={{-62,-221},{-82,-201}})));
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
    p_low=p_minLow,
    p_high=p_minHigh,
    p_start_junction=Init.mixH2_Leversen.p,
    m_flow_start=Init.m_flow_feedIn_Leversen,
    h_start_junction=Init.source_H2_Leversen.h) annotation (Placement(transformation(
        extent={{-23,-23},{23,23}},
        rotation=180,
        origin={-120.5,-193})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 Mix_Tornesch(
    p_start=Init.mixH2_Tornesch.p,
    h_start=Init.mixH2_Tornesch.h_out,
    xi_start=Init.mixH2_Tornesch.xi_out,
    volume=V_mixNG) annotation (Placement(transformation(extent={{-188,144},{-168,164}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 Mix_Leversen(
    p_start=Init.mixH2_Leversen.p,
    h_start=Init.mixH2_Leversen.h_out,
    xi_start=Init.mixH2_Leversen.xi_out,
    volume=V_mixNG) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-120,-140})));
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
    p_low=p_minLow,
    p_high=p_minHigh,
    p_start_junction=Init.mixH2_Reitbrook.p,
    m_flow_start=Init.m_flow_feedIn_Reitbrook,
    h_start_junction=Init.source_H2_Reitbrook.h) annotation (Placement(transformation(
        extent={{23,-23},{-23,23}},
        rotation=180,
        origin={177.5,-193})));
protected
  Modelica.Blocks.Math.Gain gainRei(k=f_Rei) annotation (Placement(transformation(extent={{114,-222},{134,-202}})));
public
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 Mix_Reitbrook(
    p_start=Init.mixH2_Reitbrook.p,
    h_start=Init.mixH2_Reitbrook.h_out,
    xi_start=Init.mixH2_Reitbrook.xi_out,
    volume=V_mixNG) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={176,-76})));
public
  TransiEnt.Components.Boundaries.Electrical.Frequency ElectricGrid annotation (Placement(transformation(
        extent={{-19,-20},{19,20}},
        rotation=180,
        origin={-275,20})));
  TransiEnt.Basics.Tables.ElectricGrid.ResidualLoadExample P_residual_neg(negResidualLoad=true) annotation (Placement(transformation(extent={{-290,-48},{-252,-12}})));
equation
   der(H_demand)=H_flow_demand.y1;
   der(m_H2_max)=maxH2MassFlow_Rei.m_flow_H2_max+maxH2MassFlow_Lev.m_flow_H2_max+maxH2MassFlow_Tor.m_flow_H2_max;

  connect(HHNord.H_flow, H_flow_demand.y1) annotation (Line(
      points={{-9,84},{-14,84},{-14,-158},{44.2,-158}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Eimsbuettel.H_flow, H_flow_demand.y1) annotation (Line(
      points={{-21,44},{-14,44},{-14,-158},{44.2,-158}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Wandsbek.H_flow, H_flow_demand.y1) annotation (Line(
      points={{37,62},{-14,62},{-14,-158},{44.2,-158}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Altona.H_flow, H_flow_demand.y1) annotation (Line(
      points={{-41,7},{-14,7},{-14,-158},{44.2,-158}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(HHMitte.H_flow, H_flow_demand.y1) annotation (Line(
      points={{31,-18},{-14,-18},{-14,-158},{44.2,-158}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Bergedorf.H_flow, H_flow_demand.y1) annotation (Line(
      points={{55,-77},{-14,-77},{-14,-158},{44.2,-158}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Harburg.H_flow, H_flow_demand.y1) annotation (Line(
      points={{-21,-71},{-14,-71},{-14,-158},{44.2,-158}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Wandsbek.fluidPortIn, gasGridHamburg.offTakeWandsbek) annotation (Line(
      points={{58,62},{72,62},{72,62.7647},{75.4909,62.7647}},
      color={255,255,0},
      thickness=1.5));
  connect(Bergedorf.fluidPortIn, gasGridHamburg.offTakeBergedorf) annotation (Line(
      points={{76,-77},{92,-77},{92,-76.9412},{95.7818,-76.9412}},
      color={255,255,0},
      thickness=1.5));
  connect(HHMitte.fluidPortIn, gasGridHamburg.offTakeMitte) annotation (Line(
      points={{52,-18},{66.4727,-18},{66.4727,-18.8235}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeAltona, Altona.fluidPortIn) annotation (Line(
      points={{-75.5636,6.88235},{-62,6.88235},{-62,7}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeEimsbuettel, Eimsbuettel.fluidPortIn) annotation (Line(
      points={{-56.4,46},{-56.4,44},{-42,44}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeHarburg, Harburg.fluidPortIn) annotation (Line(
      points={{-51.8909,-70.2353},{-42,-70.2353},{-42,-71}},
      color={255,255,0},
      thickness=1.5));
  connect(HHNord.fluidPortIn, gasGridHamburg.offTakeNord) annotation (Line(
      points={{12,84},{18,84},{18,118.647}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Tornesch.gasPort,maxH2MassFlow_Tor. gasPortIn) annotation (Line(
      points={{-236,154},{-236,154.5},{-224,154.5}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Tornesch.gasPortOut, gasGridHamburg.GTSTor) annotation (Line(
      points={{-136,154},{-127.418,154},{-127.418,155.529}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Leversen.gasPort,maxH2MassFlow_Lev. gasPortIn) annotation (Line(
      points={{-180,-139},{-162,-139},{-162,-140}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Reitbrook.gasPort,maxH2MassFlow_Rei. gasPortIn) annotation (Line(
      points={{240,-75},{240,-76},{222,-76}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Tornesch.gasPortOut, gasGridHamburg.GTSTor) annotation (Line(
      points={{-136,154},{-130,154},{-130,155.529},{-127.418,155.529}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Leversen.gasPortOut, gasGridHamburg.GTSLev) annotation (Line(
      points={{-76,-140},{-57.5273,-140},{-57.5273,-140.647}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeBergedorf, vleCompositionSensor_Reitbrook.gasPortOut) annotation (Line(
      points={{95.7818,-76.9412},{116.459,-76.9412},{116.459,-76},{114,-76}},
      color={255,255,0},
      thickness=1.5));
  connect(gainTor.y,FeedIn_Tornesch. P_el_set) annotation (Line(
      points={{-141,86},{-144.5,86},{-144.5,85.6},{-155.5,85.6}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Mix_Tornesch.gasPort2,FeedIn_Tornesch. gasPortOut) annotation (Line(
      points={{-178,144},{-178,144},{-178,127.23},{-177.35,127.23}},
      color={255,255,0},
      thickness=1.5));
  connect(Mix_Leversen.gasPort2,FeedIn_Leversen. gasPortOut) annotation (Line(
      points={{-120,-150},{-120,-169.77},{-119.35,-169.77}},
      color={255,255,0},
      thickness=1.5));
  connect(gainLev.y,FeedIn_Leversen. P_el_set) annotation (Line(
      points={{-83,-211},{-86.5,-211},{-86.5,-211.4},{-97.5,-211.4}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(gainRei.y,FeedIn_Reitbrook. P_el_set) annotation (Line(
      points={{135,-212},{133.5,-212},{133.5,-211.4},{154.5,-211.4}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Mix_Reitbrook.gasPort2,FeedIn_Reitbrook. gasPortOut) annotation (Line(
      points={{176,-86},{176,-169.77},{176.35,-169.77}},
      color={255,255,0},
      thickness=1.5));
  connect(Mix_Reitbrook.gasPort1, maxH2MassFlow_Rei.gasPortOut) annotation (Line(
      points={{186,-76},{202,-76}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Reitbrook.gasPortIn, Mix_Reitbrook.gasPort3) annotation (Line(
      points={{134,-76},{150,-76},{166,-76}},
      color={255,255,0},
      thickness=1.5));
  connect(maxH2MassFlow_Rei.m_flow_H2_max, FeedIn_Reitbrook.m_flow_feedIn) annotation (Line(points={{212,-85},{212,-211.4},{200.5,-211.4}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(maxH2MassFlow_Lev.gasPortOut, Mix_Leversen.gasPort1) annotation (Line(
      points={{-142,-140},{-130,-140}},
      color={255,255,0},
      thickness=1.5));
  connect(Mix_Leversen.gasPort3, vleCompositionSensor_Leversen.gasPortIn) annotation (Line(
      points={{-110,-140},{-110,-140},{-96,-140}},
      color={255,255,0},
      thickness=1.5));
  connect(maxH2MassFlow_Tor.gasPortOut, Mix_Tornesch.gasPort1) annotation (Line(
      points={{-204,154.5},{-194,154.5},{-194,154},{-188,154}},
      color={255,255,0},
      thickness=1.5));
  connect(Mix_Tornesch.gasPort3, vleCompositionSensor_Tornesch.gasPortIn) annotation (Line(
      points={{-168,154},{-156,154},{-156,154}},
      color={255,255,0},
      thickness=1.5));
  connect(maxH2MassFlow_Tor.m_flow_H2_max, FeedIn_Tornesch.m_flow_feedIn) annotation (Line(points={{-214,145.05},{-214,145.05},{-214,85.6},{-201.5,85.6}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(maxH2MassFlow_Lev.m_flow_H2_max, FeedIn_Leversen.m_flow_feedIn) annotation (Line(points={{-152,-149},{-152,-149},{-152,-212},{-152,-211.4},{-143.5,-211.4}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(gainRei.u, P_residual_neg.P_el) annotation (Line(
      points={{112,-212},{106,-212},{106,-238},{-242,-238},{-242,-30},{-250.1,-30}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(gainLev.u, P_residual_neg.P_el) annotation (Line(
      points={{-60,-211},{-52,-211},{-52,-238},{-242,-238},{-242,-30},{-250.1,-30}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(FeedIn_Leversen.epp, ElectricGrid.epp) annotation (Line(
      points={{-97.5,-193},{-28,-193},{-28,-234},{-236,-234},{-236,20.2},{-255.81,20.2}},
      color={0,135,135},
      thickness=0.5));
  connect(FeedIn_Reitbrook.epp, ElectricGrid.epp) annotation (Line(
      points={{154.5,-193},{-28,-193},{-28,-234},{-236,-234},{-236,20.2},{-255.81,20.2}},
      color={0,135,135},
      thickness=0.5));
  connect(FeedIn_Tornesch.epp, ElectricGrid.epp) annotation (Line(
      points={{-155.5,104},{-104,104},{-104,54},{-236,54},{-236,20},{-255.81,20.2}},
      color={0,135,135},
      thickness=0.5));
  connect(gainTor.u, P_residual_neg.P_el) annotation (Line(
      points={{-118,86},{-108,86},{-108,60},{-242,60},{-242,-30},{-250.1,-30}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (Diagram(coordinateSystem(extent={{-300,-240},{280,240}}, preserveAspectRatio=false)),
                                                                         Icon(coordinateSystem(extent={{-300,-240},{280,240}})),
    experiment(
      StopTime=604800,
      Interval=900,
      Tolerance=1e-008),
    __Dymola_experimentSetupOutput(inputs=false, events=false),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for open-loop high pressure gas ring grid of Hamburg with power-to-gas stations and mass flow rate control.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Lisa Andresen (andresen@tuhh.de), Jun 2016</p>
</html>"));
end TestGasGridHamburgVarGCVPtG;
