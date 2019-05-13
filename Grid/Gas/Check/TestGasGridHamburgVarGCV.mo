within TransiEnt.Grid.Gas.Check;
model TestGasGridHamburgVarGCV "High pressure gas grid of Hamburg with variable gross calorific value at consumption side"
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
  extends TransiEnt.Basics.Icons.Checkmodel;

  //Scaling factors
  parameter Real f_gasDemand=simCenter.f_gasDemand "Scale factor for gas demand";
  parameter Real f_Rei=0.465119;
  parameter Real f_Lev=0.268173;
  parameter Real f_Tor=1-f_Rei-f_Lev;

  //FeedInControl
  parameter Real phi_H2max=0.1 annotation(Evaluate=false);
  parameter Modelica.SIunits.Volume V_mixNG=1 "Volume of NG junctions" annotation (Evaluate=false);

  //Pipe Network
  parameter Real Nper10km=2 "Number of discrete volumes in 10 km pipe length";
  parameter Integer massBalance=1 "Mass balance and species balance fomulation" annotation(Dialog(group="Fundamental Definitions"),choices(choice=1 "ClaRa formulation", choice=2 "TransiEnt formulation 1a", choice=3 "TransiEnt formulation 1b"));
  replaceable model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4 "Pressure loss model in pipes";
  //ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L4
  //ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.QuadraticNominalPoint_L4

  //Consumers
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.P "|Controller|Type of controller";
  parameter Real k_consumer=1e6 "|Controller|Gain for controller in maximum feed in control";
  parameter Real Ti=0.04 "|Controller|Integrator time constant for controller in maximum feed in control";
  parameter Real Td=0.01 "|Controller|Derivative time constant for controller in maximum feed in control";

  // Variable declarations
  SI.Energy H_demand "Gas demand";
  SI.Mass m_H2_max(start=0,fixed=true,stateSelect=StateSelect.never) "Maximal H2 mass that could be fed into the gas grid";
  SI.Mass m_gas_import=-(GTS_Tornesch.m+GTS_Leversen.m+GTS_Reitbrook.m) "Gas demand with H2 fed into the grid";

  inner TransiEnt.SimCenter simCenter(
    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3,
    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1,
    p_amb=101343,
    T_amb=283.15) annotation (Placement(transformation(extent={{-298,212},{-270,240}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-270,212},{-242,240}})));

  TransiEnt.Grid.Gas.GasGridHamburg gasGridHamburg(
    phi_H2max=phi_H2max,
    Nper10km=Nper10km,
    massBalance=massBalance,
    V_mixNG=V_mixNG,
    redeclare model PressureLoss = PressureLoss) annotation (Placement(transformation(extent={{-166,-184},{212,196}})));

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
                   annotation (Placement(transformation(extent={{100,-128},{80,-108}})));
  TransiEnt.Basics.Tables.GasGrid.NaturalGasVolumeFlowSTP H_flow_demand(constantfactor=simCenter.f_gasDemand*12.14348723*3.6e6)   annotation (Placement(transformation(extent={{110,-206},{74,-170}})));

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
  Modelica.Blocks.Logical.Switch switchDem annotation (Placement(transformation(extent={{52,-142},{32,-162}})));
  Modelica.Blocks.Sources.BooleanConstant Table(k=true) annotation (Placement(transformation(extent={{100,-162},{80,-142}})));


  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Tor(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{-10,10.5},{10,-10.5}},
        rotation=0,
        origin={-186,154.5})));
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Lev(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-144,-148})));
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow_Rei(phi_H2max=phi_H2max) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={178,-76})));

public
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Tornesch(compositionDefinedBy=2) annotation (Placement(transformation(extent={{-164,154},{-144,174}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Leversen(compositionDefinedBy=2) annotation (Placement(transformation(extent={{-112,-148},{-92,-128}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor vleCompositionSensor_Reitbrook(compositionDefinedBy=2) annotation (Placement(transformation(extent={{152,-76},{132,-56}})));

  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi GTS_Tornesch(
    medium=simCenter.gasModel1,
    m(fixed=true),
    p_const=Init.p_source,
    h_const=Init.h_source,
    xi_const=Init.xi_source) annotation (Placement(transformation(extent={{-236,138},{-204,170}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi GTS_Leversen(
    medium=simCenter.gasModel1,
    m(fixed=true),
    p_const=Init.p_source,
    h_const=Init.h_source,
    xi_const=Init.xi_source) annotation (Placement(transformation(extent={{-204,-165},{-172,-133}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_phxi GTS_Reitbrook(
    medium=simCenter.gasModel1,
    m(fixed=true),
    p_const=Init.p_source,
    h_const=Init.h_source,
    xi_const=Init.xi_source) annotation (Placement(transformation(
        extent={{-18,17},{18,-17}},
        rotation=180,
        origin={226,-77})));

protected
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
      points={{68,64},{66,64},{66,64.1176},{85.2588,64.1176}},
      color={255,255,0},
      thickness=1.5));
  connect(Bergedorf.fluidPortIn, gasGridHamburg.offTakeBergedorf) annotation (Line(
      points={{82,-77},{82,-76.7059},{104.159,-76.7059}},
      color={255,255,0},
      thickness=1.5));
  connect(HHMitte.fluidPortIn, gasGridHamburg.offTakeMitte) annotation (Line(
      points={{66,-18},{76.3647,-18},{76.3647,-17.4706}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeAltona, Altona.fluidPortIn) annotation (Line(
      points={{-63.7176,7.11765},{-40,7.11765},{-40,7}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeEimsbuettel, Eimsbuettel.fluidPortIn) annotation (Line(
      points={{-44.8176,47.3529},{-44.8176,47},{-38,47}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeHarburg, Harburg.fluidPortIn) annotation (Line(
      points={{-43.7059,-70},{-30,-70},{-30,-69}},
      color={255,255,0},
      thickness=1.5));
  connect(HHNord.fluidPortIn, gasGridHamburg.offTakeNord) annotation (Line(
      points={{16,96},{16,118.882},{27.4471,118.882}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Tornesch.gasPort,maxH2MassFlow_Tor. gasPortIn) annotation (Line(
      points={{-204,154},{-204,154.5},{-196,154.5}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Tornesch.gasPortOut, gasGridHamburg.GTSTor) annotation (Line(
      points={{-144,154},{-134.871,154},{-134.871,153.529}},
      color={255,255,0},
      thickness=1.5));
  connect(maxH2MassFlow_Tor.gasPortOut,vleCompositionSensor_Tornesch. gasPortIn) annotation (Line(
      points={{-176,154.5},{-160,154.5},{-160,154},{-164,154}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Leversen.gasPort,maxH2MassFlow_Lev. gasPortIn) annotation (Line(
      points={{-172,-149},{-154,-149},{-154,-148}},
      color={255,255,0},
      thickness=1.5));
  connect(maxH2MassFlow_Lev.gasPortOut,vleCompositionSensor_Leversen. gasPortIn) annotation (Line(
      points={{-134,-148},{-130,-148},{-112,-148}},
      color={255,255,0},
      thickness=1.5));
  connect(GTS_Reitbrook.gasPort,maxH2MassFlow_Rei. gasPortIn) annotation (Line(
      points={{208,-77},{208,-76},{188,-76}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Reitbrook.gasPortIn,maxH2MassFlow_Rei. gasPortOut) annotation (Line(
      points={{152,-76},{168,-76}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Tornesch.gasPortOut, gasGridHamburg.GTSTor) annotation (Line(
      points={{-144,154},{-130,154},{-130,153.529},{-134.871,153.529}},
      color={255,255,0},
      thickness=1.5));
  connect(vleCompositionSensor_Leversen.gasPortOut, gasGridHamburg.GTSLev) annotation (Line(
      points={{-92,-148},{-59.2706,-148},{-59.2706,-148.235}},
      color={255,255,0},
      thickness=1.5));
  connect(gasGridHamburg.offTakeBergedorf, vleCompositionSensor_Reitbrook.gasPortOut) annotation (Line(
      points={{104.159,-76.7059},{116.459,-76.7059},{116.459,-76},{132,-76}},
      color={255,255,0},
      thickness=1.5));

  connect(Table.y, switchDem.u2) annotation (Line(
      points={{79,-152},{79,-152},{54,-152}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(shareWan.u,switchDem. y) annotation (Line(
      points={{32.8,64},{32.8,64},{20,64},{20,-152},{31,-152}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareEim.u,switchDem. y) annotation (Line(
      points={{3.2,48},{20,48},{20,-152},{31,-152}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareAlt.u,switchDem. y) annotation (Line(
      points={{1.2,7},{20,7},{20,-152},{31,-152}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareMit.u,switchDem. y) annotation (Line(
      points={{26.6,-19},{20,-19},{20,-152},{31,-152}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareHar.u,switchDem. y) annotation (Line(
      points={{13.4,-69},{20,-69},{20,-152},{31,-152}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareBer.u,switchDem. y) annotation (Line(
      points={{38.6,-77},{20,-77},{20,-152},{31,-152}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(shareNor.u,switchDem. y) annotation (Line(
      points={{-21.2,96},{-26,96},{-26,74},{20,74},{20,-152},{31,-152}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Hflow.y,switchDem. u3) annotation (Line(points={{79,-118},{68,-118},{68,-144},{54,-144}}, color={0,0,127}));
  connect(H_flow_demand.y1, switchDem.u1) annotation (Line(points={{72.2,-188},{72,-188},{54,-188},{54,-160}},            color={0,0,127}));
  connect(Altona.H_flow, shareAlt.y) annotation (Line(points={{-19,7},{-15.5,7},{-12.6,7}},               color={0,0,127}));
  connect(Eimsbuettel.H_flow, shareEim.y) annotation (Line(points={{-17,47},{-14.5,47},{-14.5,48},{-10.6,48}}, color={0,0,127}));
  connect(HHNord.H_flow, shareNor.y) annotation (Line(points={{-5,96},{-7.4,96}},            color={0,0,127}));
  connect(Wandsbek.H_flow, shareWan.y) annotation (Line(points={{47,64},{48,64},{46.6,64}},   color={0,0,127}));
  connect(HHMitte.H_flow, shareMit.y) annotation (Line(points={{45,-18},{44,-18},{44,-19},{42.7,-19}},     color={0,0,127}));
  connect(Bergedorf.H_flow, shareBer.y) annotation (Line(points={{61,-77},{58,-77},{54.7,-77}},                  color={0,0,127}));
  connect(Harburg.H_flow, shareHar.y) annotation (Line(points={{-9,-69},{-2.7,-69}},                           color={0,0,127}));

  annotation (Diagram(graphics,
                      coordinateSystem(extent={{-300,-240},{280,240}}, preserveAspectRatio=false)),
                                                                         Icon(graphics,
                                                                              coordinateSystem(extent={{-300,-240},{280,240}})),
    experiment(
      StopTime=2.592e+006,
      Interval=900,
      Tolerance=1e-007),
    __Dymola_experimentSetupOutput(inputs=false, events=false),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for open-loop high pressure gas ring grid of Hamburg with mass flow control.</p>
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
end TestGasGridHamburgVarGCV;
