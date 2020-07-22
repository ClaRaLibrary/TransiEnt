within TransiEnt.Producer.Gas.MethanatorSystem.EquilibriumModel.Check;
model Check_MethanatorBlock_equilibrium_L2_

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
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
  extends TransiEnt.Basics.Icons.Checkmodel;
  import TransiEnt;
  Real Q_flow_loss1;
  Real Q_flow_loss2;
  Real Q_flow_loss3;
  Real Q_flow_loss4;
  Real Q_flow_loss5;
  Real Q_flow_loss6;
  Real Q_flow_loss7;
  TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG6_var medium;
  inner TransiEnt.SimCenter simCenter(                                                                    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_SRK_var gasModel2,redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG6_var gasModel3)
                                                                                                          annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  Modelica.Blocks.Sources.Trapezoid trapezoid(
    rising=1,
    falling=1,
    startTime=5,
    width=80000,
    period=300000,
    amplitude=-0.5)
              annotation (Placement(transformation(extent={{-96,38},{-84,50}})));
  Modelica.Blocks.Sources.RealExpression Xi_Harms1[
                                                  5](y={0,0.844884,0,0.155116,0})                      annotation (Placement(transformation(extent={{-138,-18},{-82,10}})));
  TransiEnt.Producer.Gas.MethanatorSystem.MethanatorSystem_L1 methanatorSystem_L2_1(m_flow_n_Hydrogen=1, medium=simCenter.gasModel2) annotation (Placement(transformation(extent={{10,-48},{30,-28}})));
  TransiEnt.Producer.Gas.MethanatorSystem.MethanatorSystem_L4 methanatorSystem_L4_1(m_flow_n_Hydrogen=1, medium=simCenter.gasModel2) annotation (Placement(transformation(extent={{10,-86},{30,-66}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow Source_SynGas2(
    medium=simCenter.gasModel2,
    variable_m_flow=true,
    xi_const={0,0,0,0,0,0})                                                                                           annotation (Placement(transformation(extent={{-34,-86},{-14,-66}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi2(
    medium=simCenter.gasModel2,
    variable_xi=false,
    p_const=2520000,
    T_const=573.15)                                                                                              annotation (Placement(transformation(extent={{78,-48},{58,-28}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi3(
    medium=simCenter.gasModel2,
    variable_xi=false,
    p_const=2520000,
    T_const=573.15)                                                                                              annotation (Placement(transformation(extent={{80,-86},{60,-66}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow Source_SynGas1(
    medium=simCenter.gasModel2,
    variable_m_flow=true,
    xi_const={0,0,0,0,0,0})                                                                                           annotation (Placement(transformation(extent={{-34,-48},{-14,-28}})));
  Modelica.Blocks.Math.Gain gain(k=0.155116) annotation (Placement(transformation(extent={{-64,-58},{-44,-38}})));
  TransiEnt.Producer.Gas.MethanatorSystem.EquilibriumModel.MethanationThreeStages                                                       reactor_09_real1(
    m_flow_nominal=1,
    RecycleRate=1.6,
    useHomotopy=true,
    Delta_p_nominal_reactor_block=0,
    Delta_p_nominal_HEX=0,
    SteadyState=false,
    T_ambient=283.15,
    T_HEX_out=495.15,
    T_reactor_start=283.15,
    Medium=simCenter.gasModel3)
                            annotation (Placement(transformation(extent={{10,-8},{30,12}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow Source_SynGas3(
    medium=simCenter.gasModel3,
    variable_m_flow=true,
    variable_xi=true)                                                                        annotation (Placement(transformation(extent={{-32,-8},{-12,12}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi4(
    medium=simCenter.gasModel3,
    variable_xi=false,
    p_const=2520000,
    T_const=573.15)                                                                                              annotation (Placement(transformation(extent={{74,-8},{54,12}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi     boundaryRealGas_pTxi5(T_const(displayUnit="K"), p_const=6000000)
                                                                                                                   annotation (Placement(transformation(extent={{-30,16},{-10,36}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow     boundaryRealGas_Txim_flow2(
    variable_m_flow=false,
    variable_xi=false,
    m_flow_const=3,
    T_const=283.15)   annotation (Placement(transformation(extent={{66,16},{46,36}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureSensor2 annotation (Placement(transformation(extent={{6,40},{26,60}})));
  TransiEnt.Producer.Gas.MethanatorSystem.EquilibriumModel.MethanationThreeStages                                                       reactor_09_real2(
    m_flow_nominal=1.5,
    RecycleRate=1.6,
    useHomotopy=true,
    Delta_p_nominal_reactor_block=0,
    Delta_p_nominal_HEX=0,
    SteadyState=false,
    T_ambient=283.15,
    T_HEX_out=495.15,
    T_reactor_start=283.15,
    Medium=simCenter.gasModel3)
                            annotation (Placement(transformation(extent={{12,74},{32,94}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow Source_SynGas4(
    medium=simCenter.gasModel3,
    variable_m_flow=true,
    variable_xi=true)                                                                        annotation (Placement(transformation(extent={{-30,74},{-10,94}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi1(
    medium=simCenter.gasModel3,
    variable_xi=false,
    p_const=2520000,
    T_const=573.15)                                                                                              annotation (Placement(transformation(extent={{76,74},{56,94}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi     boundaryRealGas_pTxi6(T_const(displayUnit="K"), p_const=6000000)
                                                                                                                   annotation (Placement(transformation(extent={{-28,98},{-8,118}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow     boundaryRealGas_Txim_flow1(
    variable_m_flow=false,
    variable_xi=false,
    m_flow_const=3,
    T_const=283.15)   annotation (Placement(transformation(extent={{68,98},{48,118}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureSensor1 annotation (Placement(transformation(extent={{8,122},{28,142}})));
  TransiEnt.Producer.Gas.MethanatorSystem.EquilibriumModel.MethanationThreeStages                                                       reactor_09_real3(
    m_flow_nominal=2,
    RecycleRate=1.6,
    useHomotopy=true,
    Delta_p_nominal_reactor_block=0,
    Delta_p_nominal_HEX=0,
    SteadyState=false,
    T_ambient=283.15,
    T_HEX_out=495.15,
    T_reactor_start=283.15,
    Medium=simCenter.gasModel3)
                            annotation (Placement(transformation(extent={{10,158},{30,178}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow Source_SynGas5(
    medium=simCenter.gasModel3,
    variable_m_flow=true,
    variable_xi=true)                                                                        annotation (Placement(transformation(extent={{-32,158},{-12,178}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi7(
    medium=simCenter.gasModel3,
    variable_xi=false,
    p_const=2520000,
    T_const=573.15)                                                                                              annotation (Placement(transformation(extent={{74,158},{54,178}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi     boundaryRealGas_pTxi8(T_const(displayUnit="K"), p_const=6000000)
                                                                                                                   annotation (Placement(transformation(extent={{-30,182},{-10,202}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow     boundaryRealGas_Txim_flow3(
    variable_m_flow=false,
    variable_xi=false,
    m_flow_const=3,
    T_const=283.15)   annotation (Placement(transformation(extent={{66,182},{46,202}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureSensor3 annotation (Placement(transformation(extent={{6,206},{26,226}})));
  TransiEnt.Producer.Gas.MethanatorSystem.EquilibriumModel.MethanationThreeStages                                                       reactor_09_real4(
    m_flow_nominal=2.5,
    RecycleRate=1.6,
    useHomotopy=true,
    Delta_p_nominal_reactor_block=0,
    Delta_p_nominal_HEX=0,
    SteadyState=false,
    T_ambient=283.15,
    T_HEX_out=495.15,
    T_reactor_start=283.15,
    Medium=simCenter.gasModel3)
                            annotation (Placement(transformation(extent={{12,240},{32,260}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow Source_SynGas6(
    medium=simCenter.gasModel3,
    variable_m_flow=true,
    variable_xi=true)                                                                        annotation (Placement(transformation(extent={{-30,240},{-10,260}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi9(
    medium=simCenter.gasModel3,
    variable_xi=false,
    p_const=2520000,
    T_const=573.15)                                                                                              annotation (Placement(transformation(extent={{76,240},{56,260}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi     boundaryRealGas_pTxi10(T_const(displayUnit="K"), p_const=6000000)
                                                                                                                   annotation (Placement(transformation(extent={{-28,264},{-8,284}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow     boundaryRealGas_Txim_flow4(
    variable_m_flow=false,
    variable_xi=false,
    m_flow_const=3,
    T_const=283.15)   annotation (Placement(transformation(extent={{68,264},{48,284}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureSensor4 annotation (Placement(transformation(extent={{8,288},{28,308}})));
  TransiEnt.Producer.Gas.MethanatorSystem.EquilibriumModel.MethanationThreeStages                                                       reactor_09_real5(
    m_flow_nominal=3,
    RecycleRate=1.6,
    useHomotopy=true,
    Delta_p_nominal_reactor_block=0,
    Delta_p_nominal_HEX=0,
    SteadyState=false,
    T_ambient=283.15,
    T_HEX_out=495.15,
    T_reactor_start=283.15,
    Medium=simCenter.gasModel3)
                            annotation (Placement(transformation(extent={{8,320},{28,340}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow Source_SynGas7(
    medium=simCenter.gasModel3,
    variable_m_flow=true,
    variable_xi=true)                                                                        annotation (Placement(transformation(extent={{-34,320},{-14,340}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi11(
    medium=simCenter.gasModel3,
    variable_xi=false,
    p_const=2520000,
    T_const=573.15)                                                                                              annotation (Placement(transformation(extent={{72,320},{52,340}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi     boundaryRealGas_pTxi12(T_const(displayUnit="K"), p_const=6000000)
                                                                                                                   annotation (Placement(transformation(extent={{-32,344},{-12,364}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow     boundaryRealGas_Txim_flow5(
    variable_m_flow=false,
    variable_xi=false,
    m_flow_const=3,
    T_const=283.15)   annotation (Placement(transformation(extent={{64,344},{44,364}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureSensor5 annotation (Placement(transformation(extent={{4,368},{24,388}})));
  TransiEnt.Producer.Gas.MethanatorSystem.EquilibriumModel.MethanationThreeStages                                                       reactor_09_real6(
    m_flow_nominal=3.5,
    RecycleRate=1.6,
    useHomotopy=true,
    Delta_p_nominal_reactor_block=0,
    Delta_p_nominal_HEX=0,
    SteadyState=false,
    T_ambient=283.15,
    T_HEX_out=495.15,
    T_reactor_start=283.15,
    Medium=simCenter.gasModel3)
                            annotation (Placement(transformation(extent={{6,398},{26,418}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow Source_SynGas8(
    medium=simCenter.gasModel3,
    variable_m_flow=true,
    variable_xi=true)                                                                        annotation (Placement(transformation(extent={{-36,398},{-16,418}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi13(
    medium=simCenter.gasModel3,
    variable_xi=false,
    p_const=2520000,
    T_const=573.15)                                                                                              annotation (Placement(transformation(extent={{70,398},{50,418}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi     boundaryRealGas_pTxi14(T_const(displayUnit="K"), p_const=6000000)
                                                                                                                   annotation (Placement(transformation(extent={{-34,422},{-14,442}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow     boundaryRealGas_Txim_flow6(
    variable_m_flow=false,
    variable_xi=false,
    m_flow_const=3,
    T_const=283.15)   annotation (Placement(transformation(extent={{62,422},{42,442}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureSensor6 annotation (Placement(transformation(extent={{2,446},{22,466}})));
  Modelica.Blocks.Math.Gain gain1(k=1.5) annotation (Placement(transformation(extent={{-52,82},{-38,96}})));
  Modelica.Blocks.Math.Gain gain2(k=2) annotation (Placement(transformation(extent={{-54,168},{-40,182}})));
  Modelica.Blocks.Math.Gain gain3(k=2.5) annotation (Placement(transformation(extent={{-54,250},{-40,264}})));
  Modelica.Blocks.Math.Gain gain4(k=3) annotation (Placement(transformation(extent={{-56,328},{-42,342}})));
  Modelica.Blocks.Math.Gain gain5(k=3.5) annotation (Placement(transformation(extent={{-60,408},{-46,422}})));
  TransiEnt.Producer.Gas.MethanatorSystem.EquilibriumModel.MethanationThreeStages                                                       reactor_09_real7(
    m_flow_nominal=4,
    RecycleRate=1.6,
    useHomotopy=true,
    Delta_p_nominal_reactor_block=0,
    Delta_p_nominal_HEX=0,
    SteadyState=false,
    T_ambient=283.15,
    T_HEX_out=495.15,
    T_reactor_start=283.15,
    Medium=simCenter.gasModel3)
                            annotation (Placement(transformation(extent={{-2,476},{18,496}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow Source_SynGas9(
    medium=simCenter.gasModel3,
    variable_m_flow=true,
    variable_xi=true)                                                                        annotation (Placement(transformation(extent={{-44,476},{-24,496}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi15(
    medium=simCenter.gasModel3,
    variable_xi=false,
    p_const=2520000,
    T_const=573.15)                                                                                              annotation (Placement(transformation(extent={{62,476},{42,496}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi     boundaryRealGas_pTxi16(T_const(displayUnit="K"), p_const=6000000)
                                                                                                                   annotation (Placement(transformation(extent={{-42,500},{-22,520}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow     boundaryRealGas_Txim_flow7(
    variable_m_flow=false,
    variable_xi=false,
    m_flow_const=3,
    T_const=283.15)   annotation (Placement(transformation(extent={{54,500},{34,520}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureSensor7 annotation (Placement(transformation(extent={{-6,524},{14,544}})));
  Modelica.Blocks.Math.Gain gain6(k=4) annotation (Placement(transformation(extent={{-68,486},{-54,500}})));
equation
Q_flow_loss1=reactor_09_real1.Block1.Q_flow_loss+reactor_09_real1.Block2.Q_flow_loss+reactor_09_real1.Block3.Q_flow_loss;
Q_flow_loss2=reactor_09_real2.Block1.Q_flow_loss+reactor_09_real2.Block2.Q_flow_loss+reactor_09_real2.Block3.Q_flow_loss;
Q_flow_loss3=reactor_09_real3.Block1.Q_flow_loss+reactor_09_real3.Block2.Q_flow_loss+reactor_09_real3.Block3.Q_flow_loss;
Q_flow_loss4=reactor_09_real4.Block1.Q_flow_loss+reactor_09_real4.Block2.Q_flow_loss+reactor_09_real4.Block3.Q_flow_loss;
Q_flow_loss5=reactor_09_real5.Block1.Q_flow_loss+reactor_09_real5.Block2.Q_flow_loss+reactor_09_real5.Block3.Q_flow_loss;
Q_flow_loss6=reactor_09_real6.Block1.Q_flow_loss+reactor_09_real6.Block2.Q_flow_loss+reactor_09_real6.Block3.Q_flow_loss;
Q_flow_loss7=reactor_09_real7.Block1.Q_flow_loss+reactor_09_real7.Block2.Q_flow_loss+reactor_09_real7.Block3.Q_flow_loss;

  connect(methanatorSystem_L4_1.gasPortIn, Source_SynGas2.gasPort) annotation (Line(
      points={{10,-76},{-14,-76}},
      color={255,255,0},
      thickness=1.5));
  connect(methanatorSystem_L2_1.gasPortOut, boundaryRealGas_pTxi2.gasPort) annotation (Line(
      points={{30,-38},{58,-38}},
      color={255,255,0},
      thickness=1.5));
  connect(methanatorSystem_L4_1.gasPortOut, boundaryRealGas_pTxi3.gasPort) annotation (Line(
      points={{30,-76},{60,-76}},
      color={255,255,0},
      thickness=1.5));
  connect(methanatorSystem_L2_1.gasPortIn, Source_SynGas1.gasPort) annotation (Line(
      points={{10,-38},{-14,-38}},
      color={255,255,0},
      thickness=1.5));
  connect(gain.y, Source_SynGas1.m_flow) annotation (Line(points={{-43,-48},{-40,-48},{-40,-32},{-36,-32}}, color={0,0,127}));
  connect(gain.y, Source_SynGas2.m_flow) annotation (Line(points={{-43,-48},{-40,-48},{-40,-70},{-36,-70}}, color={0,0,127}));
  connect(gain.u, trapezoid.y) annotation (Line(points={{-66,-48},{-72,-48},{-72,44},{-83.4,44}}, color={0,0,127}));
  connect(Source_SynGas3.gasPort, reactor_09_real1.gasPortIn) annotation (Line(
      points={{-12,2},{10,2}},
      color={255,255,0},
      thickness=1.5));
  connect(reactor_09_real1.gasPortOut, boundaryRealGas_pTxi4.gasPort) annotation (Line(
      points={{30,2},{54,2}},
      color={255,255,0},
      thickness=1.5));
  connect(Xi_Harms1.y, Source_SynGas3.xi) annotation (Line(points={{-79.2,-4},{-34,-4}},                   color={0,0,127}));
  connect(trapezoid.y, Source_SynGas3.m_flow) annotation (Line(points={{-83.4,44},{-60,44},{-60,8},{-34,8}},   color={0,0,127}));
  connect(reactor_09_real1.fluidPortOut, boundaryRealGas_pTxi5.steam_a) annotation (Line(
      points={{16,12},{16,26},{-10,26}},
      color={175,0,0},
      thickness=0.5));
  connect(reactor_09_real1.fluidPortIn, boundaryRealGas_Txim_flow2.steam_a) annotation (Line(
      points={{24,11.8},{24,26},{46,26}},
      color={175,0,0},
      thickness=0.5));
  connect(reactor_09_real1.fluidPortOut, temperatureSensor2.port) annotation (Line(
      points={{16,12},{16,40}},
      color={175,0,0},
      thickness=0.5));
  connect(Source_SynGas4.gasPort,reactor_09_real2. gasPortIn) annotation (Line(
      points={{-10,84},{12,84}},
      color={255,255,0},
      thickness=1.5));
  connect(reactor_09_real2.gasPortOut,boundaryRealGas_pTxi1. gasPort) annotation (Line(
      points={{32,84},{56,84}},
      color={255,255,0},
      thickness=1.5));
  connect(Xi_Harms1.y,Source_SynGas4. xi) annotation (Line(points={{-79.2,-4},{-92,-4},{-92,78},{-32,78}}, color={0,0,127}));
  connect(reactor_09_real2.fluidPortOut,boundaryRealGas_pTxi6. steam_a) annotation (Line(
      points={{18,94},{18,108},{-8,108}},
      color={175,0,0},
      thickness=0.5));
  connect(reactor_09_real2.fluidPortIn,boundaryRealGas_Txim_flow1. steam_a) annotation (Line(
      points={{26,93.8},{26,108},{48,108}},
      color={175,0,0},
      thickness=0.5));
  connect(reactor_09_real2.fluidPortOut,temperatureSensor1. port) annotation (Line(
      points={{18,94},{18,122}},
      color={175,0,0},
      thickness=0.5));
  connect(Source_SynGas5.gasPort,reactor_09_real3. gasPortIn) annotation (Line(
      points={{-12,168},{10,168}},
      color={255,255,0},
      thickness=1.5));
  connect(reactor_09_real3.gasPortOut,boundaryRealGas_pTxi7. gasPort) annotation (Line(
      points={{30,168},{54,168}},
      color={255,255,0},
      thickness=1.5));
  connect(Xi_Harms1.y,Source_SynGas5. xi) annotation (Line(points={{-79.2,-4},{-118,-4},{-118,162},{-34,162}},
                                                                                                           color={0,0,127}));
  connect(reactor_09_real3.fluidPortOut,boundaryRealGas_pTxi8. steam_a) annotation (Line(
      points={{16,178},{16,192},{-10,192}},
      color={175,0,0},
      thickness=0.5));
  connect(reactor_09_real3.fluidPortIn,boundaryRealGas_Txim_flow3. steam_a) annotation (Line(
      points={{24,177.8},{24,192},{46,192}},
      color={175,0,0},
      thickness=0.5));
  connect(reactor_09_real3.fluidPortOut,temperatureSensor3. port) annotation (Line(
      points={{16,178},{16,206}},
      color={175,0,0},
      thickness=0.5));
  connect(Source_SynGas6.gasPort,reactor_09_real4. gasPortIn) annotation (Line(
      points={{-10,250},{12,250}},
      color={255,255,0},
      thickness=1.5));
  connect(reactor_09_real4.gasPortOut,boundaryRealGas_pTxi9. gasPort) annotation (Line(
      points={{32,250},{56,250}},
      color={255,255,0},
      thickness=1.5));
  connect(Xi_Harms1.y,Source_SynGas6. xi) annotation (Line(points={{-79.2,-4},{-144,-4},{-144,244},{-32,244}},
                                                                                                           color={0,0,127}));
  connect(reactor_09_real4.fluidPortOut, boundaryRealGas_pTxi10.steam_a) annotation (Line(
      points={{18,260},{18,274},{-8,274}},
      color={175,0,0},
      thickness=0.5));
  connect(reactor_09_real4.fluidPortIn,boundaryRealGas_Txim_flow4. steam_a) annotation (Line(
      points={{26,259.8},{26,274},{48,274}},
      color={175,0,0},
      thickness=0.5));
  connect(reactor_09_real4.fluidPortOut,temperatureSensor4. port) annotation (Line(
      points={{18,260},{18,288}},
      color={175,0,0},
      thickness=0.5));
  connect(Source_SynGas7.gasPort,reactor_09_real5. gasPortIn) annotation (Line(
      points={{-14,330},{8,330}},
      color={255,255,0},
      thickness=1.5));
  connect(reactor_09_real5.gasPortOut, boundaryRealGas_pTxi11.gasPort) annotation (Line(
      points={{28,330},{52,330}},
      color={255,255,0},
      thickness=1.5));
  connect(Xi_Harms1.y,Source_SynGas7. xi) annotation (Line(points={{-79.2,-4},{-190,-4},{-190,324},{-36,324}},
                                                                                                           color={0,0,127}));
  connect(reactor_09_real5.fluidPortOut, boundaryRealGas_pTxi12.steam_a) annotation (Line(
      points={{14,340},{14,354},{-12,354}},
      color={175,0,0},
      thickness=0.5));
  connect(reactor_09_real5.fluidPortIn,boundaryRealGas_Txim_flow5. steam_a) annotation (Line(
      points={{22,339.8},{22,354},{44,354}},
      color={175,0,0},
      thickness=0.5));
  connect(reactor_09_real5.fluidPortOut,temperatureSensor5. port) annotation (Line(
      points={{14,340},{14,368}},
      color={175,0,0},
      thickness=0.5));
  connect(Source_SynGas8.gasPort,reactor_09_real6. gasPortIn) annotation (Line(
      points={{-16,408},{6,408}},
      color={255,255,0},
      thickness=1.5));
  connect(reactor_09_real6.gasPortOut, boundaryRealGas_pTxi13.gasPort) annotation (Line(
      points={{26,408},{50,408}},
      color={255,255,0},
      thickness=1.5));
  connect(Xi_Harms1.y,Source_SynGas8. xi) annotation (Line(points={{-79.2,-4},{-204,-4},{-204,402},{-38,402}},
                                                                                                           color={0,0,127}));
  connect(reactor_09_real6.fluidPortOut, boundaryRealGas_pTxi14.steam_a) annotation (Line(
      points={{12,418},{12,432},{-14,432}},
      color={175,0,0},
      thickness=0.5));
  connect(reactor_09_real6.fluidPortIn,boundaryRealGas_Txim_flow6. steam_a) annotation (Line(
      points={{20,417.8},{20,432},{42,432}},
      color={175,0,0},
      thickness=0.5));
  connect(reactor_09_real6.fluidPortOut,temperatureSensor6. port) annotation (Line(
      points={{12,418},{12,446}},
      color={175,0,0},
      thickness=0.5));
  connect(trapezoid.y, gain1.u) annotation (Line(points={{-83.4,44},{-58,44},{-58,90},{-53.4,89}}, color={0,0,127}));
  connect(gain1.y, Source_SynGas4.m_flow) annotation (Line(points={{-37.3,89},{-34.65,89},{-34.65,90},{-32,90}}, color={0,0,127}));
  connect(trapezoid.y, gain2.u) annotation (Line(points={{-83.4,44},{-60,44},{-60,174},{-55.4,175}}, color={0,0,127}));
  connect(gain2.y, Source_SynGas5.m_flow) annotation (Line(points={{-39.3,175},{-37.65,175},{-37.65,174},{-34,174}}, color={0,0,127}));
  connect(trapezoid.y, gain3.u) annotation (Line(points={{-83.4,44},{-58,44},{-58,256},{-55.4,257}}, color={0,0,127}));
  connect(gain3.y, Source_SynGas6.m_flow) annotation (Line(points={{-39.3,257},{-35.65,257},{-35.65,256},{-32,256}}, color={0,0,127}));
  connect(trapezoid.y, gain4.u) annotation (Line(points={{-83.4,44},{-62,44},{-62,336},{-57.4,335}}, color={0,0,127}));
  connect(gain4.y, Source_SynGas7.m_flow) annotation (Line(points={{-41.3,335},{-39.65,335},{-39.65,336},{-36,336}}, color={0,0,127}));
  connect(trapezoid.y, gain5.u) annotation (Line(points={{-83.4,44},{-64,44},{-64,414},{-61.4,415}}, color={0,0,127}));
  connect(gain5.y, Source_SynGas8.m_flow) annotation (Line(points={{-45.3,415},{-41.65,415},{-41.65,414},{-38,414}}, color={0,0,127}));
  connect(Source_SynGas9.gasPort,reactor_09_real7. gasPortIn) annotation (Line(
      points={{-24,486},{-2,486}},
      color={255,255,0},
      thickness=1.5));
  connect(reactor_09_real7.gasPortOut, boundaryRealGas_pTxi15.gasPort) annotation (Line(
      points={{18,486},{42,486}},
      color={255,255,0},
      thickness=1.5));
  connect(Xi_Harms1.y,Source_SynGas9. xi) annotation (Line(points={{-79.2,-4},{-212,-4},{-212,480},{-46,480}},
                                                                                                           color={0,0,127}));
  connect(reactor_09_real7.fluidPortOut, boundaryRealGas_pTxi16.steam_a) annotation (Line(
      points={{4,496},{4,510},{-22,510}},
      color={175,0,0},
      thickness=0.5));
  connect(reactor_09_real7.fluidPortIn,boundaryRealGas_Txim_flow7. steam_a) annotation (Line(
      points={{12,495.8},{12,510},{34,510}},
      color={175,0,0},
      thickness=0.5));
  connect(reactor_09_real7.fluidPortOut,temperatureSensor7. port) annotation (Line(
      points={{4,496},{4,524}},
      color={175,0,0},
      thickness=0.5));
  connect(gain6.y, Source_SynGas9.m_flow) annotation (Line(points={{-53.3,493},{-49.65,493},{-49.65,492},{-46,492}}, color={0,0,127}));
  connect(trapezoid.y, gain6.u) annotation (Line(points={{-83.4,44},{-83.4,269},{-69.4,269},{-69.4,493}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=450000,
      Interval=60,
      Tolerance=1e-07));
end Check_MethanatorBlock_equilibrium_L2_;
