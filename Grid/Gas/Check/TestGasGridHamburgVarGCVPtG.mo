within TransiEnt.Grid.Gas.Check;
model TestGasGridHamburgVarGCVPtG "High pressure gas grid of Hamburg with H2 feedin at GTS and variable gross calorific value at consumption side"
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
  import TransiEnt;
  extends TransiEnt.Basics.Icons.Checkmodel;

  //Scaling factors
  parameter Real f_gasDemand=simCenter.f_gasDemand "Scale factor for gas demand";
  parameter Real f_Rei=0.465119;
  parameter Real f_Lev=0.268173;
  parameter Real f_Tor=1-f_Rei-f_Lev;

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
  parameter SI.Pressure p_maxLow=17400000 annotation(Evaluate=false);
  parameter SI.Pressure p_maxHigh=17500000 annotation(Evaluate=false);
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
  parameter Real Nper10km=2 "Number of discrete volumes in 10 km pipe length";
  parameter Integer massBalance=1 "Mass balance and species balance fomulation" annotation(Dialog(group="Fundamental Definitions"),choices(choice=1 "ClaRa formulation", choice=2 "TransiEnt formulation 1a", choice=3 "TransiEnt formulation 1b"));
  replaceable model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4 "Pressure loss model in pipes";
  //ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L4
  //ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.QuadraticNominalPoint_L4

  // Variable declarations
  SI.Energy H_demand "Gas demand";
  SI.Mass m_H2_max(start=0,fixed=true,stateSelect=StateSelect.never) "Maximal H2 mass that could be fed into the gas grid";
  SI.Mass m_gas_import=-(GTS_Tornesch.m+GTS_Leversen.m+GTS_Reitbrook.m) "Gas demand with H2 fed into the grid";

  inner TransiEnt.SimCenter simCenter(
    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3,
    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1,
    p_amb=101343,
    T_amb=283.15)             annotation (Placement(transformation(extent={{-298,212},{-270,240}})));

  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-270,212},{-242,240}})));

  TransiEnt.Grid.Gas.GasGridHamburg gasGridHamburg(
    phi_H2max=phi_H2max,
    Nper10km=Nper10km,
    massBalance=massBalance,
    redeclare model PressureLoss = PressureLoss,
    V_mixNG=V_mixNG)                       annotation (Placement(transformation(extent={{-172,-186},{216,198}})));

  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow Harburg(
    xi_start=Init.Harburg.pipe.xi_in,
    p_start=linspace(
        Init.Harburg.pipe.p_in,
        Init.Harburg.pipe.p_out,
        Harburg.N_cv),
    h_start=ones(Harburg.pipe.N_cv)*Init.Harburg.pipe.h_in,
    m_flow_start=ones(Harburg.pipe.N_cv + 1)*Init.Harburg.pipe.m_flow,
    N_cv=if integer(Nper10km*Harburg.length/10000) < 2 then 2 else integer(Nper10km*Harburg.length/10000),
    massBalance=massBalance,
    length(displayUnit="km") = districtPipes.length[1],
    diameter=districtPipes.diameter[1],
    N_tubes=districtPipes.N_ducts[1],
    p_nom=ones(Harburg.pipe.N_cv)*Nom.Harburg.pipe.p_in,
    h_nom=ones(Harburg.pipe.N_cv)*Nom.Harburg.pipe.h_in,
    m_flow_nom=Nom.m_flow_nom_Harburg,
    Delta_p_nom=Nom.Delta_p_nom_Harburg,
    controllerType=controllerType,
    k=k_consumer,
    Ti=Ti,
    Td=Td,
    redeclare model PressureLoss = PressureLoss)
                                         annotation (Placement(transformation(extent={{-30,-79},{-10,-59}})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow Altona(
    xi_start=Init.Altona.pipe.xi_in,
    p_start=linspace(
        Init.Altona.pipe.p_in,
        Init.Altona.pipe.p_out,
        Altona.N_cv),
    h_start=ones(Altona.pipe.N_cv)*Init.Altona.pipe.h_in,
    m_flow_start=ones(Altona.pipe.N_cv + 1)*Init.Altona.pipe.m_flow,
    N_cv=if integer(Nper10km*Altona.length/10000) < 2 then 2 else integer(Nper10km*Altona.length/10000),
    massBalance=massBalance,
    length(displayUnit="km") = districtPipes.length[2],
    diameter=districtPipes.diameter[2],
    N_tubes=districtPipes.N_ducts[2],
    p_nom=ones(Altona.pipe.N_cv)*Nom.Altona.pipe.p_in,
    h_nom=ones(Altona.pipe.N_cv)*Nom.Altona.pipe.h_in,
    m_flow_nom=Nom.m_flow_nom_Altona,
    Delta_p_nom=Nom.Delta_p_nom_Altona,
    controllerType=controllerType,
    k=k_consumer,
    Ti=Ti,
    Td=Td,
    redeclare model PressureLoss = PressureLoss)
                                        annotation (Placement(transformation(extent={{-40,-3},{-20,17}})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow Eimsbuettel(
    xi_start=Init.Eimsbuettel.pipe.xi_in,
    p_start=linspace(
        Init.Eimsbuettel.pipe.p_in,
        Init.Eimsbuettel.pipe.p_out,
        Eimsbuettel.N_cv),
    h_start=ones(Eimsbuettel.pipe.N_cv)*Init.Eimsbuettel.pipe.h_in,
    m_flow_start=ones(Eimsbuettel.pipe.N_cv + 1)*Init.Eimsbuettel.pipe.m_flow,
    N_cv=if integer(Nper10km*Eimsbuettel.length/10000) < 2 then 2 else integer(Nper10km*Eimsbuettel.length/10000),
    massBalance=massBalance,
    length(displayUnit="km") = districtPipes.length[3],
    diameter=districtPipes.diameter[3],
    N_tubes=districtPipes.N_ducts[3],
    p_nom=ones(Eimsbuettel.pipe.N_cv)*Nom.Eimsbuettel.pipe.p_in,
    h_nom=ones(Eimsbuettel.pipe.N_cv)*Nom.Eimsbuettel.pipe.h_in,
    m_flow_nom=Nom.m_flow_nom_Eimsbuettel,
    Delta_p_nom=Nom.Delta_p_nom_Eimsbuettel,
    controllerType=controllerType,
    k=k_consumer,
    Ti=Ti,
    Td=Td,
    redeclare model PressureLoss = PressureLoss)
                                             annotation (Placement(transformation(extent={{-38,37},{-18,57}})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow HHNord(
    xi_start=Init.HHNord.pipe.xi_in,
    p_start=linspace(
        Init.HHNord.pipe.p_in,
        Init.HHNord.pipe.p_out,
        HHNord.N_cv),
    h_start=ones(HHNord.pipe.N_cv)*Init.HHNord.pipe.h_in,
    m_flow_start=ones(HHNord.pipe.N_cv + 1)*Init.HHNord.pipe.m_flow,
    N_cv=if integer(Nper10km*HHNord.length/10000) < 2 then 2 else integer(Nper10km*HHNord.length/10000),
    massBalance=massBalance,
    length(displayUnit="km") = districtPipes.length[4],
    diameter=districtPipes.diameter[4],
    N_tubes=districtPipes.N_ducts[4],
    redeclare model PressureLoss = PressureLoss,
    p_nom=ones(HHNord.pipe.N_cv)*Nom.HHNord.pipe.p_in,
    h_nom=ones(HHNord.pipe.N_cv)*Nom.HHNord.pipe.h_in,
    m_flow_nom=Nom.m_flow_nom_HHNord,
    Delta_p_nom=Nom.Delta_p_nom_HHNord,
    controllerType=controllerType,
    k=k_consumer,
    Ti=Ti,
    Td=Td) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={6,96})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow Wandsbek(
    xi_start=Init.Wandsbek.pipe.xi_in,
    p_start=linspace(
        Init.Wandsbek.pipe.p_in,
        Init.Wandsbek.pipe.p_out,
        Wandsbek.N_cv),
    h_start=ones(Wandsbek.pipe.N_cv)*Init.Wandsbek.pipe.h_in,
    m_flow_start=ones(Wandsbek.pipe.N_cv + 1)*Init.Wandsbek.pipe.m_flow,
    N_cv=if integer(Nper10km*Wandsbek.length/10000) < 2 then 2 else integer(Nper10km*Wandsbek.length/10000),
    massBalance=massBalance,
    length(displayUnit="km") = districtPipes.length[5],
    diameter=districtPipes.diameter[5],
    N_tubes=districtPipes.N_ducts[5],
    p_nom=ones(Wandsbek.pipe.N_cv)*Nom.Wandsbek.pipe.p_in,
    h_nom=ones(Wandsbek.pipe.N_cv)*Nom.Wandsbek.pipe.h_in,
    m_flow_nom=Nom.m_flow_nom_Wandsbek,
    Delta_p_nom=Nom.Delta_p_nom_Wandsbek,
    controllerType=controllerType,
    k=k_consumer,
    Ti=Ti,
    Td=Td,
    redeclare model PressureLoss = PressureLoss)
           annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={58,64})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow HHMitte(
    xi_start=Init.HHMitte.pipe.xi_in,
    p_start=linspace(
        Init.HHMitte.pipe.p_in,
        Init.HHMitte.pipe.p_out,
        HHMitte.N_cv),
    h_start=ones(HHMitte.pipe.N_cv)*Init.HHMitte.pipe.h_in,
    m_flow_start=ones(HHMitte.pipe.N_cv + 1)*Init.HHMitte.pipe.m_flow,
    N_cv=if integer(Nper10km*HHMitte.length/10000) < 2 then 2 else integer(Nper10km*HHMitte.length/10000),
    massBalance=massBalance,
    length(displayUnit="km") = districtPipes.length[6],
    diameter=districtPipes.diameter[6],
    N_tubes=districtPipes.N_ducts[6],
    p_nom=ones(HHMitte.pipe.N_cv)*Nom.HHMitte.pipe.p_in,
    h_nom=ones(HHMitte.pipe.N_cv)*Nom.HHMitte.pipe.h_in,
    m_flow_nom=Nom.m_flow_nom_HHMitte,
    Delta_p_nom=Nom.Delta_p_nom_HHMitte,
    controllerType=controllerType,
    k=k_consumer,
    Ti=Ti,
    Td=Td,
    redeclare model PressureLoss = PressureLoss)
           annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={56,-18})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_HFlow Bergedorf(
    xi_start=Init.Bergedorf.pipe.xi_in,
    p_start=linspace(
        Init.Bergedorf.pipe.p_in,
        Init.Bergedorf.pipe.p_out,
        Bergedorf.N_cv),
    h_start=ones(Bergedorf.pipe.N_cv)*Init.Bergedorf.pipe.h_in,
    m_flow_start=ones(Bergedorf.pipe.N_cv + 1)*Init.Bergedorf.pipe.m_flow,
    N_cv=if integer(Nper10km*Bergedorf.length/10000) < 2 then 2 else integer(Nper10km*Bergedorf.length/10000),
    massBalance=massBalance,
    length(displayUnit="km") = districtPipes.length[7],
    diameter=districtPipes.diameter[7],
    N_tubes=districtPipes.N_ducts[7],
    p_nom=ones(Bergedorf.pipe.N_cv)*Nom.Bergedorf.pipe.p_in,
    h_nom=ones(Bergedorf.pipe.N_cv)*Nom.Bergedorf.pipe.h_in,
    m_flow_nom=Nom.m_flow_nom_Bergedorf,
    Delta_p_nom=Nom.Delta_p_nom_Bergedorf,
    controllerType=controllerType,
    k=k_consumer,
    Ti=Ti,
    Td=Td,
    redeclare model PressureLoss = PressureLoss)
           annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={72,-77})));

protected
  Modelica.Blocks.Sources.Ramp Hflow(
    duration=900,
    startTime=900,
    height=(Nom.m_flow - Init.m_flow)*12.14348723/0.844499954*3.6e6,
    offset=Init.m_flow*12.14348723/0.844499954*3.6e6)
                   annotation (Placement(transformation(extent={{96,-116},{80,-100}})));
  Modelica.Blocks.Logical.Switch switchDem annotation (Placement(transformation(extent={{52,-126},{32,-146}})));
  Modelica.Blocks.Sources.BooleanConstant Table(k=true) annotation (Placement(transformation(extent={{96,-144},{80,-128}})));
  TransiEnt.Basics.Tables.GasGrid.NaturalGasVolumeFlowSTP H_flow_demand(constantfactor=simCenter.f_gasDemand*12.14348723*3.6e6)   annotation (Placement(transformation(extent={{106,-180},{74,-150}})));

  Modelica.Blocks.Math.Gain shareHar(k=districtPipes.f_mFlow[1]) annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=180,
        origin={5,-69})));
  Modelica.Blocks.Math.Gain shareAlt(k=districtPipes.f_mFlow[2]) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={-6,7})));
  Modelica.Blocks.Math.Gain shareEim(k=districtPipes.f_mFlow[3]) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={-4,48})));
  Modelica.Blocks.Math.Gain shareNor(k=districtPipes.f_mFlow[4]) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=180,
        origin={-14,96})));
  Modelica.Blocks.Math.Gain shareWan(k=districtPipes.f_mFlow[5]) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=180,
        origin={40,64})));
  Modelica.Blocks.Math.Gain shareMit(k=districtPipes.f_mFlow[6]) annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=180,
        origin={35,-19})));
  Modelica.Blocks.Math.Gain shareBer(k=districtPipes.f_mFlow[7]) annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=180,
        origin={47,-77})));
  Modelica.Blocks.Math.Gain gainTor(k=f_Tor) annotation (Placement(transformation(extent={{-120,76},{-140,96}})));
  Modelica.Blocks.Math.Gain gainLev(k=f_Lev) annotation (Placement(transformation(extent={{-62,-221},{-82,-201}})));
  Modelica.Blocks.Math.Gain gainRei(k=f_Rei) annotation (Placement(transformation(extent={{114,-222},{134,-202}})));

protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Tor(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{-10,10.5},{10,-10.5}},
        rotation=0,
        origin={-214,154.5})));
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Lev(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-152,-140})));
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Rei(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={212,-76})));
public
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Tornesch(compositionDefinedBy=2) annotation (Placement(transformation(extent={{-156,154},{-136,174}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Leversen(compositionDefinedBy=2) annotation (Placement(transformation(extent={{-96,-140},{-76,-120}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Reitbrook(compositionDefinedBy=2) annotation (Placement(transformation(extent={{134,-76},{114,-56}})));

  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi GTS_Tornesch(
    medium=simCenter.gasModel1,
    m(fixed=true),
    p_const=Init.p_source,
    h_const=Init.h_source,
    xi_const=Init.xi_source) annotation (Placement(transformation(extent={{-268,138},{-236,170}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi GTS_Leversen(
    medium=simCenter.gasModel1,
    m(fixed=true),
    p_const=Init.p_source,
    h_const=Init.h_source,
    xi_const=Init.xi_source) annotation (Placement(transformation(extent={{-212,-155},{-180,-123}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi GTS_Reitbrook(
    medium=simCenter.gasModel1,
    m(fixed=true),
    p_const=Init.p_source,
    h_const=Init.h_source,
    xi_const=Init.xi_source) annotation (Placement(transformation(
        extent={{-18,17},{18,-17}},
        rotation=180,
        origin={258,-75})));

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
    P_el_n=P_el_n*f_Tor,
    P_el_max=P_el_max*f_Tor,
    P_el_min=P_el_min*f_Tor,
    P_el_overload=P_el_overload*f_Tor,
    V_geo=V_geo*f_Tor,
    p_start_junction=Init.mixH2_Tornesch.p,
    h_start_junction=Init.source_H2_Tornesch.h,
    p_maxHigh=p_maxHigh,
    p_maxLow=p_maxLow,
    p_minLow=p_minLow,
    p_minHigh=p_minHigh)                        annotation (Placement(transformation(
        extent={{-23,-23},{23,23}},
        rotation=180,
        origin={-178.5,104})));

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
    P_el_n=P_el_n*f_Lev,
    P_el_max=P_el_max*f_Lev,
    P_el_min=P_el_min*f_Lev,
    P_el_overload=P_el_overload*f_Lev,
    V_geo=V_geo*f_Lev,
    p_start_junction=Init.mixH2_Leversen.p,
    m_flow_start=Init.m_flow_feedIn_Leversen,
    h_start_junction=Init.source_H2_Leversen.h,
    p_maxHigh=p_maxHigh,
    p_maxLow=p_maxLow,
    p_minLow=p_minLow,
    p_minHigh=p_minHigh)                        annotation (Placement(transformation(
        extent={{-23,-23},{23,23}},
        rotation=180,
        origin={-120.5,-193})));
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
    P_el_n=P_el_n*f_Rei,
    P_el_max=P_el_max*f_Rei,
    P_el_min=P_el_min*f_Rei,
    P_el_overload=P_el_overload*f_Rei,
    V_geo=V_geo*f_Rei,
    p_start_junction=Init.mixH2_Reitbrook.p,
    m_flow_start=Init.m_flow_feedIn_Reitbrook,
    h_start_junction=Init.source_H2_Reitbrook.h,
    p_maxHigh=p_maxHigh,
    p_maxLow=p_maxLow,
    p_minLow=p_minLow,
    p_minHigh=p_minHigh)                         annotation (Placement(transformation(
        extent={{23,-23},{-23,23}},
        rotation=180,
        origin={177.5,-193})));

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
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 Mix_Reitbrook(
    p_start=Init.mixH2_Reitbrook.p,
    h_start=Init.mixH2_Reitbrook.h_out,
    xi_start=Init.mixH2_Reitbrook.xi_out,
    volume=V_mixNG) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={176,-76})));

  TransiEnt.Components.Boundaries.Electrical.Frequency ElectricGrid annotation (Placement(transformation(
        extent={{-19,-20},{19,20}},
        rotation=180,
        origin={-275,20})));
  TransiEnt.Basics.Tables.ElectricGrid.ResidualLoadExample P_residual_neg(negResidualLoad=true) annotation (Placement(transformation(extent={{-290,-48},{-252,-12}})));
  inner TransiEnt.Basics.Records.PipeParameter ringPipes(
    N_pipes=12,
    length={2353.4,9989.1,10203.5,11846.6,7285.6,10878.7,4420.5,11961.1,10915.2,13932.2,28366.9,16710},
    diameter(displayUnit="m") = {0.6,0.4,0.4,0.4,0.4,0.4,0.5,0.4,0.4,0.607307197,0.6,0.5},
    m_flow_nom={20.2,10.1,10.1,12.4,0.3,10.5,21.9,6.7,10.1,30.6,3.6,32.4},
    Delta_p_nom(displayUnit="Pa") = {10605,63939.6,63939.6,184435.5,56.5,125548.4,67207.8,56975.5,116965.7,140705.4,3963.8,133488.2}) annotation (Placement(transformation(extent={{-228,214},{-208,234}})));
  inner TransiEnt.Basics.Records.PipeParameter districtPipes(
    N_pipes=7,
    f_mFlow={0.0869,0.1346,0.1199,0.1688,0.187,0.2267,0.076},
    length={3774,5152,2739,10564,4075,9480,6770},
    diameter={0.221,0.221,0.221,0.221,0.221,0.221,0.221},
    N_ducts={4,5,5,6,7,8,3},
    m_flow_nom={7.83,12.12,10.8,15.2,16.83,20.42,6.84},
    Delta_p_nom(displayUnit="Pa") = {31226.22,78102.46,31207.91,126637.22,63836.59,152213.2,73490.95}) annotation (Placement(transformation(extent={{-198,214},{-178,234}})));
  inner TransiEnt.Grid.Gas.StatCycleGasGridHamburg Nom(
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
    T_feedIn_Reitbrook=325.45)                          annotation (Placement(transformation(extent={{-310,180},{-259,216}})));
  inner TransiEnt.Grid.Gas.StatCycleGasGridHamburg Init(
    medium=Nom.medium,
    quadraticPressureLoss=Nom.quadraticPressureLoss,
    p_source=Nom.p_source,
    h_source=Nom.h_source,
    xi_source=Nom.xi_source,
    Delta_p_nom_Harburg=Nom.Delta_p_nom_Harburg,
    Delta_p_nom_Altona=Nom.Delta_p_nom_Altona,
    Delta_p_nom_Eimsbuettel=Nom.Delta_p_nom_Eimsbuettel,
    Delta_p_nom_HHNord=Nom.Delta_p_nom_HHNord,
    Delta_p_nom_Wandsbek=Nom.Delta_p_nom_Wandsbek,
    Delta_p_nom_HHMitte=Nom.Delta_p_nom_HHMitte,
    Delta_p_nom_Bergedorf=Nom.Delta_p_nom_Bergedorf,
    m_flow_nom_Harburg=Nom.m_flow_nom_Harburg,
    m_flow_nom_Altona=Nom.m_flow_nom_Altona,
    m_flow_nom_Eimsbuettel=Nom.m_flow_nom_Eimsbuettel,
    m_flow_nom_HHNord=Nom.m_flow_nom_HHNord,
    m_flow_nom_Wandsbek=Nom.m_flow_nom_Wandsbek,
    m_flow_nom_HHMitte=Nom.m_flow_nom_HHMitte,
    m_flow_nom_Bergedorf=Nom.m_flow_nom_Bergedorf,
    Delta_p_nom_Ringline=Nom.Delta_p_nom_Ringline,
    Delta_p_nom_Ringline1=Nom.Delta_p_nom_Ringline1,
    Delta_p_nom_Ringline2=Nom.Delta_p_nom_Ringline2,
    Delta_p_nom_Ringline3=Nom.Delta_p_nom_Ringline3,
    Delta_p_nom_Ringline4=Nom.Delta_p_nom_Ringline4,
    Delta_p_nom_Ringline5=Nom.Delta_p_nom_Ringline5,
    Delta_p_nom_Ringline6=Nom.Delta_p_nom_Ringline6,
    Delta_p_nom_Ringline7=Nom.Delta_p_nom_Ringline7,
    Delta_p_nom_Ringline8=Nom.Delta_p_nom_Ringline8,
    Delta_p_nom_Leversen=Nom.Delta_p_nom_Leversen,
    Delta_p_nom_Tornesch=Nom.Delta_p_nom_Tornesch,
    m_flow_nom_Ringline=Nom.m_flow_nom_Ringline,
    m_flow_nom_Ringline1=Nom.m_flow_nom_Ringline1,
    m_flow_nom_Ringline2=Nom.m_flow_nom_Ringline2,
    m_flow_nom_Ringline3=Nom.m_flow_nom_Ringline3,
    m_flow_nom_Ringline4=Nom.m_flow_nom_Ringline4,
    m_flow_nom_Ringline5=Nom.m_flow_nom_Ringline5,
    m_flow_nom_Ringline6=Nom.m_flow_nom_Ringline6,
    m_flow_nom_Ringline7=Nom.m_flow_nom_Ringline7,
    m_flow_nom_Ringline8=Nom.m_flow_nom_Ringline8,
    m_flow_nom_Leversen=Nom.m_flow_nom_Leversen,
    m_flow_nom_Tornesch=Nom.m_flow_nom_Tornesch,
    T_feedIn_Tornesch(displayUnit="K") = 326.598,
    T_feedIn_Leversen(displayUnit="K") = 326.598,
    T_feedIn_Reitbrook(displayUnit="K") = 326.598,
    m_flow_nom_unscaled=Nom.m_flow_nom_unscaled,
    m_flow_nom=Nom.m_flow_nom,
    f_Rei=Nom.f_Rei,
    f_Lev=Nom.f_Lev,
    f_Tor=Nom.f_Tor,
    m_flow_feedIn_Tornesch=0,
    m_flow_feedIn_Leversen=0,
    m_flow_feedIn_Reitbrook=0,
    m_flow_Harburg=26.64515586*simCenter.f_gasDemand*districtPipes.f_mFlow[1],
    m_flow_Altona=26.64515586*simCenter.f_gasDemand*districtPipes.f_mFlow[2],
    m_flow_Eimsbuettel=26.64515586*simCenter.f_gasDemand*districtPipes.f_mFlow[3],
    m_flow_HHNord=26.64515586*simCenter.f_gasDemand*districtPipes.f_mFlow[4],
    m_flow_Wandsbek=26.64515586*simCenter.f_gasDemand*districtPipes.f_mFlow[5],
    m_flow_HHMitte=26.64515586*simCenter.f_gasDemand*districtPipes.f_mFlow[6],
    m_flow_Bergedorf=26.64515586*simCenter.f_gasDemand*districtPipes.f_mFlow[7],
    splitRatioHarburg=Nom.splitRatioHarburg,
    splitRatioWandsbek=Nom.splitRatioWandsbek,
    splitRatioEimsbuettel=Nom.splitRatioEimsbuettel)                             annotation (Placement(transformation(extent={{-280,180},{-230,216}})));

equation
   der(H_demand)=H_flow_demand.y1;
   der(m_H2_max)=maxH2MassFlow_Rei.m_flow_H2_max+maxH2MassFlow_Lev.m_flow_H2_max+maxH2MassFlow_Tor.m_flow_H2_max;

  connect(Wandsbek.fluidPortIn, gasGridHamburg.offTakeWandsbek) annotation (Line(
      points={{68,64},{72,64},{72,64.7294},{85.9059,64.7294}},
      color={255,255,0},
      thickness=1.5));
  connect(Bergedorf.fluidPortIn, gasGridHamburg.offTakeBergedorf) annotation (Line(
      points={{82,-77},{92,-77},{92,-77.5765},{105.306,-77.5765}},
      color={255,255,0},
      thickness=1.5));
  connect(HHMitte.fluidPortIn, gasGridHamburg.offTakeMitte) annotation (Line(
      points={{66,-18},{76.7765,-18},{76.7765,-17.7176}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeAltona, Altona.fluidPortIn) annotation (Line(
      points={{-67.0118,7.12941},{-40,7.12941},{-40,7}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeEimsbuettel, Eimsbuettel.fluidPortIn) annotation (Line(
      points={{-47.6118,47.7882},{-47.6118,47},{-38,47}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeHarburg, Harburg.fluidPortIn) annotation (Line(
      points={{-46.4706,-70.8},{-30,-70.8},{-30,-69}},
      color={255,255,0},
      thickness=1.5));
  connect(HHNord.fluidPortIn, gasGridHamburg.offTakeNord) annotation (Line(
      points={{16,96},{26.5647,96},{26.5647,120.071}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Tornesch.gasPort,maxH2MassFlow_Tor. gasPortIn) annotation (Line(
      points={{-236,154},{-236,154.5},{-224,154.5}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Tornesch.gasPortOut, gasGridHamburg.GTSTor) annotation (Line(
      points={{-136,154},{-140.047,154},{-140.047,155.082}},
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
      points={{-136,154},{-130,154},{-130,155.082},{-140.047,155.082}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Leversen.gasPortOut, gasGridHamburg.GTSLev) annotation (Line(
      points={{-76,-140},{-62.4471,-140},{-62.4471,-149.859}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeBergedorf, vleCompositionSensor_Reitbrook.gasPortOut) annotation (Line(
      points={{105.306,-77.5765},{116.459,-77.5765},{116.459,-76},{114,-76}},
      color={255,255,0},
      thickness=1.5));
  connect(gainTor.y,FeedIn_Tornesch. P_el_set) annotation (Line(
      points={{-141,86},{-144.5,86},{-144.5,80.08},{-178.5,80.08}},
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
      points={{-83,-211},{-86.5,-211},{-86.5,-216.92},{-120.5,-216.92}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(gainRei.y,FeedIn_Reitbrook. P_el_set) annotation (Line(
      points={{135,-212},{133.5,-212},{133.5,-216.92},{177.5,-216.92}},
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

  connect(Table.y, switchDem.u2) annotation (Line(
      points={{79.2,-136},{79.2,-136},{54,-136}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(shareWan.u,switchDem. y) annotation (Line(
      points={{32.8,64},{32.8,64},{20,64},{20,-136},{31,-136}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareEim.u,switchDem. y) annotation (Line(
      points={{3.2,48},{20,48},{20,-136},{31,-136}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareAlt.u,switchDem. y) annotation (Line(
      points={{1.2,7},{20,7},{20,-136},{31,-136}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareMit.u,switchDem. y) annotation (Line(
      points={{26.6,-19},{20,-19},{20,-136},{31,-136}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareHar.u,switchDem. y) annotation (Line(
      points={{13.4,-69},{20,-69},{20,-136},{31,-136}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareBer.u,switchDem. y) annotation (Line(
      points={{38.6,-77},{20,-77},{20,-136},{31,-136}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareNor.u,switchDem. y) annotation (Line(
      points={{-21.2,96},{-26,96},{-26,74},{20,74},{20,-136},{31,-136}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Hflow.y,switchDem. u3) annotation (Line(points={{79.2,-108},{68,-108},{68,-128},{54,-128}},
                                                                                                    color={0,0,127}));
  connect(H_flow_demand.y1, switchDem.u1) annotation (Line(points={{72.4,-165},{72,-165},{54,-165},{54,-144}},            color={0,0,127}));
  connect(Altona.H_flow, shareAlt.y) annotation (Line(points={{-19,7},{-15.5,7},{-12.6,7}},               color={0,0,127}));
  connect(Eimsbuettel.H_flow, shareEim.y) annotation (Line(points={{-17,47},{-14.5,47},{-14.5,48},{-10.6,48}}, color={0,0,127}));
  connect(HHNord.H_flow, shareNor.y) annotation (Line(points={{-5,96},{-7.4,96}},            color={0,0,127}));
  connect(Wandsbek.H_flow, shareWan.y) annotation (Line(points={{47,64},{48,64},{46.6,64}},   color={0,0,127}));
  connect(HHMitte.H_flow, shareMit.y) annotation (Line(points={{45,-18},{44,-18},{44,-19},{42.7,-19}},     color={0,0,127}));
  connect(Bergedorf.H_flow, shareBer.y) annotation (Line(points={{61,-77},{58,-77},{54.7,-77}},                  color={0,0,127}));
  connect(Harburg.H_flow, shareHar.y) annotation (Line(points={{-9,-69},{-2.7,-69}},                           color={0,0,127}));

  annotation (Diagram(coordinateSystem(extent={{-300,-240},{280,240}}, preserveAspectRatio=false)),
                                                                         Icon(coordinateSystem(extent={{-300,-240},{280,240}})),
    experiment(
      StopTime=2.592e+006,
      Interval=900,
      Tolerance=1e-007),
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
</html>"),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end TestGasGridHamburgVarGCVPtG;
