within TransiEnt.Grid.Gas.Check;
model TestGasGridHamburg "High pressure gas grid of Hamburg with constant gross calorific value at consumption side"
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

  //FeedIn Control
  parameter Real phi_H2max=0.1 annotation(Evaluate=false);
  parameter Modelica.SIunits.Volume V_mixNG=1 "Volume of NG junctions" annotation (Evaluate=false);

  //Pipe Network
  parameter Real Nper10km=2 "Number of discrete volumes in 10 km pipe length";
  parameter Integer massBalance=1 "Mass balance and species balance fomulation" annotation(Dialog(group="Fundamental Definitions"),choices(choice=1 "ClaRa formulation", choice=2 "TransiEnt formulation 1a", choice=3 "TransiEnt formulation 1b"));
  replaceable model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4 "Pressure loss model in pipes";
  //ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L4
  //ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.QuadraticNominalPoint_L4

  // Variable declarations
  SI.Mass m_demand(start=0,fixed=true,stateSelect=StateSelect.never) "Gas demand";
  SI.Mass m_H2_max(start=0,fixed=true,stateSelect=StateSelect.never) "Maximal H2 mass that could be fed into the gas grid";
  SI.Mass m_gas_import=-(GTS_Tornesch.m+GTS_Leversen.m+GTS_Reitbrook.m) "Gas demand with H2 fed into the grid";

  inner TransiEnt.SimCenter simCenter(
    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3,
    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1,
    p_amb=101343,
    T_amb=283.15)             annotation (Placement(transformation(extent={{-300,212},{-271,242}})));

  TransiEnt.Grid.Gas.GasGridHamburg gasGridHamburg(
    phi_H2max=phi_H2max,
    Nper10km=Nper10km,
    massBalance=massBalance,
    V_mixNG=V_mixNG,
    redeclare model PressureLoss = PressureLoss)
                                           annotation (Placement(transformation(extent={{-164,-196},{214,184}})));

  TransiEnt.Consumer.Gas.GasConsumerPipe_mFlow Harburg(
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
    redeclare model PressureLoss = PressureLoss,
    p_nom=ones(Harburg.pipe.N_cv)*Nom.Harburg.pipe.p_in,
    h_nom=ones(Harburg.pipe.N_cv)*Nom.Harburg.pipe.h_in,
    m_flow_nom=Nom.m_flow_nom_Harburg,
    Delta_p_nom=Nom.Delta_p_nom_Harburg) annotation (Placement(transformation(extent={{-28,-91},{-8,-71}})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_mFlow Altona(
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
    redeclare model PressureLoss = PressureLoss,
    p_nom=ones(Altona.pipe.N_cv)*Nom.Altona.pipe.p_in,
    h_nom=ones(Altona.pipe.N_cv)*Nom.Altona.pipe.h_in,
    m_flow_nom=Nom.m_flow_nom_Altona,
    Delta_p_nom=Nom.Delta_p_nom_Altona) annotation (Placement(transformation(extent={{-46,-15},{-26,5}})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_mFlow Eimsbuettel(
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
    redeclare model PressureLoss = PressureLoss,
    p_nom=ones(Eimsbuettel.pipe.N_cv)*Nom.Eimsbuettel.pipe.p_in,
    h_nom=ones(Eimsbuettel.pipe.N_cv)*Nom.Eimsbuettel.pipe.h_in,
    m_flow_nom=Nom.m_flow_nom_Eimsbuettel,
    Delta_p_nom=Nom.Delta_p_nom_Eimsbuettel) annotation (Placement(transformation(extent={{-36,25},{-16,45}})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_mFlow HHNord(
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
    Delta_p_nom=Nom.Delta_p_nom_HHNord) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={14,92})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_mFlow Wandsbek(
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
    redeclare model PressureLoss = PressureLoss,
    p_nom=ones(Wandsbek.pipe.N_cv)*Nom.Wandsbek.pipe.p_in,
    h_nom=ones(Wandsbek.pipe.N_cv)*Nom.Wandsbek.pipe.h_in,
    m_flow_nom=Nom.m_flow_nom_Wandsbek,
    Delta_p_nom=Nom.Delta_p_nom_Wandsbek) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={66,50})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_mFlow HHMitte(
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
    redeclare model PressureLoss = PressureLoss,
    p_nom=ones(HHMitte.pipe.N_cv)*Nom.HHMitte.pipe.p_in,
    h_nom=ones(HHMitte.pipe.N_cv)*Nom.HHMitte.pipe.h_in,
    m_flow_nom=Nom.m_flow_nom_HHMitte,
    Delta_p_nom=Nom.Delta_p_nom_HHMitte) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={62,-31})));
  TransiEnt.Consumer.Gas.GasConsumerPipe_mFlow Bergedorf(
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
    redeclare model PressureLoss = PressureLoss,
    p_nom=ones(Bergedorf.pipe.N_cv)*Nom.Bergedorf.pipe.p_in,
    h_nom=ones(Bergedorf.pipe.N_cv)*Nom.Bergedorf.pipe.h_in,
    m_flow_nom=Nom.m_flow_nom_Bergedorf,
    Delta_p_nom=Nom.Delta_p_nom_Bergedorf) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={72,-89})));

    inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-270,212},{-239,242}})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Lev(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-128,-160})));
public
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi GTS_Leversen(
    medium=simCenter.gasModel1,
    m(fixed=true),
    p_const=Init.p_source,
    h_const=Init.h_source,
    xi_const=Init.xi_source) annotation (Placement(transformation(extent={{-188,-177},{-156,-145}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Leversen(compositionDefinedBy=2) annotation (Placement(transformation(extent={{-96,-160},{-76,-140}})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Tor(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{-10,10.5},{10,-10.5}},
        rotation=0,
        origin={-162,142.5})));
public
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi GTS_Tornesch(
    medium=simCenter.gasModel1,
    m(fixed=true),
    p_const=Init.p_source,
    h_const=Init.h_source,
    xi_const=Init.xi_source) annotation (Placement(transformation(extent={{-212,126},{-180,158}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Tornesch(compositionDefinedBy=2) annotation (Placement(transformation(extent={{-144,142},{-124,162}})));
protected
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Rei(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={180,-88})));
public
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi GTS_Reitbrook(
    medium=simCenter.gasModel1,
    m(fixed=true),
    p_const=Init.p_source,
    h_const=Init.h_source,
    xi_const=Init.xi_source) annotation (Placement(transformation(
        extent={{-18,17},{18,-17}},
        rotation=180,
        origin={228,-89})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Reitbrook(compositionDefinedBy=2) annotation (Placement(transformation(extent={{154,-88},{134,-68}})));
  inner TransiEnt.Basics.Records.PipeParameter ringPipes(
    N_pipes=12,
    length={2353.4,9989.1,10203.5,11846.6,7285.6,10878.7,4420.5,11961.1,10915.2,13932.2,28366.9,16710},
    diameter(displayUnit="m") = {0.6,0.4,0.4,0.4,0.4,0.4,0.5,0.4,0.4,0.607307197,0.6,0.5},
    m_flow_nom={20.2,10.1,10.1,12.4,0.3,10.5,21.9,6.7,10.1,30.6,3.6,32.4},
    Delta_p_nom(displayUnit="Pa") = {10605,63939.6,63939.6,184435.5,56.5,125548.4,67207.8,56975.5,116965.7,140705.4,3963.8,133488.2}) annotation (Placement(transformation(extent={{-296,152},{-276,172}})));
  inner TransiEnt.Basics.Records.PipeParameter districtPipes(
    N_pipes=7,
    f_mFlow={0.0869,0.1346,0.1199,0.1688,0.187,0.2267,0.076},
    length={3774,5152,2739,10564,4075,9480,6770},
    diameter={0.221,0.221,0.221,0.221,0.221,0.221,0.221},
    N_ducts={4,5,5,6,7,8,3},
    m_flow_nom={7.83,12.12,10.8,15.2,16.83,20.42,6.84},
    Delta_p_nom(displayUnit="Pa") = {31226.22,78102.46,31207.91,126637.22,63836.59,152213.2,73490.95}) annotation (Placement(transformation(extent={{-266,152},{-246,172}})));
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
    T_feedIn_Reitbrook=325.45)                          annotation (Placement(transformation(extent={{-310,180},{-259,216}})));
  inner TransiEnt.Grid.Gas.StatCycleGasGridHamburg
                                 Init(
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

  TransiEnt.Basics.Tables.GasGrid.NaturalGasVolumeFlowSTP V_flow_demand_stp(constantfactor=simCenter.f_gasDemand) annotation (Placement(transformation(extent={{142,-216},{106,-180}})));

  Modelica.Blocks.Sources.Ramp Mflow(
    height=Nom.m_flow - Init.m_flow,
    duration=900,
    offset=Init.m_flow,
    startTime=900) annotation (Placement(transformation(extent={{96,-148},{76,-128}})));

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
        origin={47,-89})));

  Modelica.Blocks.Math.Gain rho_NG_stp(k=0.844499954) annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=180,
        origin={85,-198})));
  Modelica.Blocks.Logical.Switch switchDem annotation (Placement(transformation(extent={{54,-160},{34,-180}})));
  Modelica.Blocks.Sources.BooleanConstant Table(k=true) annotation (Placement(transformation(extent={{96,-180},{76,-160}})));

equation
   der(m_demand)=switchDem.y;
   der(m_H2_max)=maxH2MassFlow_Rei.m_flow_H2_max+maxH2MassFlow_Lev.m_flow_H2_max+maxH2MassFlow_Tor.m_flow_H2_max;

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
  connect(gasGridHamburg.offTakeBergedorf, Bergedorf.fluidPortIn) annotation (Line(
      points={{106.159,-88.7059},{92,-88.7059},{92,-90},{82,-90},{82,-89}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Leversen.gasPort,maxH2MassFlow_Lev. gasPortIn) annotation (Line(
      points={{-156,-161},{-138,-161},{-138,-160}},
      color={255,255,0},
      thickness=1.5));
  connect(maxH2MassFlow_Lev.gasPortOut,vleCompositionSensor_Leversen. gasPortIn) annotation (Line(
      points={{-118,-160},{-114,-160},{-96,-160}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Tornesch.gasPort, maxH2MassFlow_Tor.gasPortIn) annotation (Line(
      points={{-180,142},{-180,142.5},{-172,142.5}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Reitbrook.gasPort, maxH2MassFlow_Rei.gasPortIn) annotation (Line(
      points={{210,-89},{210,-88},{190,-88}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Reitbrook.gasPortIn, maxH2MassFlow_Rei.gasPortOut) annotation (Line(
      points={{154,-88},{170,-88}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Tornesch.gasPortOut, gasGridHamburg.GTSTor) annotation (Line(
      points={{-124,142},{-132.871,142},{-132.871,141.529}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Leversen.gasPortOut, gasGridHamburg.GTSLev) annotation (Line(
      points={{-76,-160},{-57.2706,-160},{-57.2706,-160.235}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeBergedorf, vleCompositionSensor_Reitbrook.gasPortOut) annotation (Line(
      points={{106.159,-88.7059},{120.891,-88.7059},{120.891,-88},{134,-88}},
      color={255,255,0},
      thickness=1.5));
  connect(maxH2MassFlow_Tor.gasPortOut, vleCompositionSensor_Tornesch.gasPortIn) annotation (Line(
      points={{-152,142.5},{-148,142.5},{-148,142},{-144,142}},
      color={255,255,0},
      thickness=1.5));
  connect(shareBer.y, Bergedorf.m_flow) annotation (Line(points={{54.7,-89},{61,-89}},                             color={0,0,127}));
  connect(shareWan.y, Wandsbek.m_flow) annotation (Line(points={{50.6,50},{50,50},{55,50}}, color={0,0,127}));
  connect(shareNor.y, HHNord.m_flow) annotation (Line(points={{0.6,92},{0.6,92},{3,92}},     color={0,0,127}));
  connect(Eimsbuettel.m_flow, shareEim.y) annotation (Line(points={{-15,35},{-14,35},{-14,36},{-12.6,36}}, color={0,0,127}));
  connect(Altona.m_flow, shareAlt.y) annotation (Line(points={{-25,-5},{-16,-5},{-16,-6},{-18.6,-6}}, color={0,0,127}));
  connect(Harburg.m_flow, shareHar.y) annotation (Line(points={{-7,-81},{-2.7,-81}},             color={0,0,127}));
  connect(V_flow_demand_stp.y1, rho_NG_stp.u) annotation (Line(points={{104.2,-198},{94,-198},{93.4,-198}},
                                                                                                 color={0,0,127}));
  connect(Table.y, switchDem.u2) annotation (Line(
      points={{75,-170},{75,-170},{56,-170}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(shareWan.u, switchDem.y) annotation (Line(
      points={{36.8,50},{36.8,50},{24,50},{24,-170},{33,-170}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareEim.u, switchDem.y) annotation (Line(
      points={{1.2,36},{24,36},{24,-170},{33,-170}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareAlt.u, switchDem.y) annotation (Line(
      points={{-4.8,-6},{24,-6},{24,-170},{33,-170}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareMit.u, switchDem.y) annotation (Line(
      points={{30.6,-31},{24,-31},{24,-170},{33,-170}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareHar.u, switchDem.y) annotation (Line(
      points={{13.4,-81},{24,-81},{24,-170},{33,-170}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareBer.u, switchDem.y) annotation (Line(
      points={{38.6,-89},{24,-89},{24,-170},{33,-170}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareNor.u, switchDem.y) annotation (Line(
      points={{-13.2,92},{-18,92},{-18,72},{24,72},{24,-170},{33,-170}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Mflow.y, switchDem.u3) annotation (Line(points={{75,-138},{68,-138},{68,-162},{56,-162}}, color={0,0,127}));
  connect(rho_NG_stp.y, switchDem.u1) annotation (Line(points={{77.3,-198},{68,-198},{64,-198},{64,-178},{56,-178}},           color={0,0,127}));

  connect(HHMitte.m_flow, shareMit.y) annotation (Line(points={{51,-31},{48,-31},{46.7,-31}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-300,-240},{280,240}}, preserveAspectRatio=false)),
                                                                         Icon(coordinateSystem(extent={{-300,-240},{280,240}})),
    experiment(
      StopTime=2.592e+006,
      Interval=900,
      Tolerance=1e-007),
    __Dymola_experimentSetupOutput(inputs=false, events=false),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for open-loop high pressure gas ring grid of Hamburg.</p>
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
end TestGasGridHamburg;
