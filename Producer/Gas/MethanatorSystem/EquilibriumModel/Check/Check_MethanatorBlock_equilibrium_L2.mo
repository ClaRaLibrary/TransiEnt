within TransiEnt.Producer.Gas.MethanatorSystem.EquilibriumModel.Check;
model Check_MethanatorBlock_equilibrium_L2



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
  import TransiEnt;
  Real Q_flow_loss;
  Real Q_flow;
  Real Q_flow_reaction;
  Real Q_flow_reaction3;
  TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG6_var medium;
  inner TransiEnt.SimCenter simCenter(                                                                    redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_SRK_var gasModel2,redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG6_var gasModel3)
                                                                                                          annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  Modelica.Blocks.Sources.Trapezoid trapezoid(
    rising=1,
    falling=1,
    startTime=5,
    width=80000,
    period=300000,
    amplitude=-1)
              annotation (Placement(transformation(extent={{-98,24},{-86,36}})));
  Modelica.Blocks.Sources.RealExpression Xi_Harms1[
                                                  5](y={0,0.844884,0,0.155116,0})                      annotation (Placement(transformation(extent={{-100,-18},{-44,10}})));
  TransiEnt.Producer.Gas.MethanatorSystem.MethanatorSystem_L1 methanatorSystem_L2_1(m_flow_n_Hydrogen=0.155116,
                                                                                                         medium=simCenter.gasModel2) annotation (Placement(transformation(extent={{28,-48},{48,-28}})));
  TransiEnt.Producer.Gas.MethanatorSystem.MethanatorSystem_L4 methanatorSystem_L4_1(m_flow_n_Hydrogen=0.155116,
                                                                                                         medium=simCenter.gasModel2) annotation (Placement(transformation(extent={{28,-86},{48,-66}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow Source_SynGas2(
    medium=simCenter.gasModel2,
    variable_m_flow=true,
    xi_const={0,0,0,0,0,0})                                                                                           annotation (Placement(transformation(extent={{-34,-86},{-14,-66}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi2(
    medium=simCenter.gasModel2,
    variable_xi=false,
    p_const=2520000,
    T_const=573.15)                                                                                              annotation (Placement(transformation(extent={{108,-48},{88,-28}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi3(
    medium=simCenter.gasModel2,
    variable_xi=false,
    p_const=2520000,
    T_const=573.15)                                                                                              annotation (Placement(transformation(extent={{108,-86},{88,-66}})));
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
                            annotation (Placement(transformation(extent={{28,-8},{48,12}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow Source_SynGas3(
    medium=simCenter.gasModel3,
    variable_m_flow=true,
    variable_xi=true,
    T_const=293.15)                                                                          annotation (Placement(transformation(extent={{-32,-8},{-12,12}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi4(
    medium=simCenter.gasModel3,
    variable_xi=false,
    p_const=2520000,
    T_const=573.15)                                                                                              annotation (Placement(transformation(extent={{108,-8},{88,12}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi     boundaryRealGas_pTxi5(T_const(displayUnit="K"), p_const=6000000)
                                                                                                                   annotation (Placement(transformation(extent={{-30,16},{-10,36}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow     boundaryRealGas_Txim_flow2(
    variable_m_flow=false,
    variable_xi=false,
    m_flow_const=3,
    T_const=283.15)   annotation (Placement(transformation(extent={{106,16},{86,36}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureSensor2 annotation (Placement(transformation(extent={{24,40},{44,60}})));
  TransiEnt.Components.Sensors.RealGas.NCVSensor              nCVSensor1(            medium=simCenter.gasModel3)
                                                                                     annotation (Placement(transformation(extent={{54,2},{58,8}})));
  TransiEnt.Components.Sensors.RealGas.NCVSensor              nCVSensor(              medium=simCenter.gasModel3)
                                                                                      annotation (Placement(transformation(extent={{-8,2},{-4,8}})));
  TransiEnt.Components.Sensors.RealGas.GCVSensor gCVSensor2(medium=simCenter.gasModel3)
                                                            annotation (Placement(transformation(extent={{6,2},{16,12}})));
  TransiEnt.Components.Sensors.RealGas.GCVSensor gCVSensor3(medium=simCenter.gasModel3)
                                                            annotation (Placement(transformation(extent={{68,2},{78,12}})));
equation
  Q_flow_loss=reactor_09_real1.Block1.Q_flow_loss+reactor_09_real1.Block2.Q_flow_loss+reactor_09_real1.Block3.Q_flow_loss;
  Q_flow=reactor_09_real1.fluidPortOut.m_flow*(reactor_09_real1.fluidPortOut.h_outflow - inStream(reactor_09_real1.fluidPortIn.h_outflow));
  Q_flow_reaction=nCVSensor.gasPortIn.m_flow*nCVSensor.NCV - nCVSensor1.gasPortIn.m_flow*nCVSensor1.NCV;
  Q_flow_reaction3=gCVSensor2.gasPortIn.m_flow*gCVSensor2.GCV - gCVSensor3.gasPortIn.m_flow*gCVSensor3.GCV;
  connect(methanatorSystem_L4_1.gasPortIn, Source_SynGas2.gasPort) annotation (Line(
      points={{28,-76},{-14,-76}},
      color={255,255,0},
      thickness=1.5));
  connect(methanatorSystem_L4_1.gasPortOut, boundaryRealGas_pTxi3.gasPort) annotation (Line(
      points={{48,-76},{88,-76}},
      color={255,255,0},
      thickness=1.5));
  connect(gain.y, Source_SynGas1.m_flow) annotation (Line(points={{-43,-48},{-40,-48},{-40,-32},{-36,-32}}, color={0,0,127}));
  connect(gain.y, Source_SynGas2.m_flow) annotation (Line(points={{-43,-48},{-40,-48},{-40,-70},{-36,-70}}, color={0,0,127}));
  connect(gain.u, trapezoid.y) annotation (Line(points={{-66,-48},{-72,-48},{-72,30},{-85.4,30}}, color={0,0,127}));
  connect(Xi_Harms1.y, Source_SynGas3.xi) annotation (Line(points={{-41.2,-4},{-34,-4}},                   color={0,0,127}));
  connect(trapezoid.y, Source_SynGas3.m_flow) annotation (Line(points={{-85.4,30},{-60,30},{-60,8},{-34,8}},   color={0,0,127}));
  connect(reactor_09_real1.fluidPortOut, boundaryRealGas_pTxi5.steam_a) annotation (Line(
      points={{34,12},{34,26},{-10,26}},
      color={175,0,0},
      thickness=0.5));
  connect(reactor_09_real1.fluidPortIn, boundaryRealGas_Txim_flow2.steam_a) annotation (Line(
      points={{42,11.8},{42,26},{86,26}},
      color={175,0,0},
      thickness=0.5));
  connect(reactor_09_real1.fluidPortOut, temperatureSensor2.port) annotation (Line(
      points={{34,12},{34,40}},
      color={175,0,0},
      thickness=0.5));
  connect(reactor_09_real1.gasPortOut, nCVSensor1.gasPortIn) annotation (Line(
      points={{48,2},{54,2}},
      color={255,255,0},
      thickness=1.5));
  connect(Source_SynGas3.gasPort, nCVSensor.gasPortIn) annotation (Line(
      points={{-12,2},{-8,2}},
      color={255,255,0},
      thickness=1.5));
  connect(nCVSensor.gasPortOut, gCVSensor2.gasPortIn) annotation (Line(
      points={{-4,2},{6,2}},
      color={255,255,0},
      thickness=1.5));
  connect(gCVSensor2.gasPortOut, reactor_09_real1.gasPortIn) annotation (Line(
      points={{16,2},{28,2}},
      color={255,255,0},
      thickness=1.5));
  connect(nCVSensor1.gasPortOut, gCVSensor3.gasPortIn) annotation (Line(
      points={{58,2},{68,2}},
      color={255,255,0},
      thickness=1.5));
  connect(gCVSensor3.gasPortOut, boundaryRealGas_pTxi4.gasPort) annotation (Line(
      points={{78,2},{88,2}},
      color={255,255,0},
      thickness=1.5));
  connect(Source_SynGas1.gasPort, methanatorSystem_L2_1.gasPortIn) annotation (Line(
      points={{-14,-38},{28,-38}},
      color={255,255,0},
      thickness=1.5));
  connect(methanatorSystem_L2_1.gasPortOut, boundaryRealGas_pTxi2.gasPort) annotation (Line(
      points={{48,-38},{88,-38}},
      color={255,255,0},
      thickness=1.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=60000,
      Interval=60,
      Tolerance=1e-08));
end Check_MethanatorBlock_equilibrium_L2;
