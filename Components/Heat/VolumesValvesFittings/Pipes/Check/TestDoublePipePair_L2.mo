within TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Check;
model TestDoublePipePair_L2


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

  DoublePipePair_L2 doublePipePair_LX(
    p_start_supply=simCenter.p_nom[2],
    T_start_supply=363.15,
    p_start_return=simCenter.p_nom[1],
    T_start_return=363.15,
    m_flow_start=0.35,
    v_nom=1,
    length=100,
    DN=20,
    calc_initial_dstrb=true,
    activate_volumes=true) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  inner SimCenter simCenter(calc_initial_dstrb=false, v_nom=0.07)
                            annotation (Placement(transformation(extent={{-110,88},{-100,98}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow boundaryVLE_Txim_flow(
    variable_m_flow=false,
    variable_T=true,
    m_flow_const=0.35,                                                                            T_const(displayUnit="degC") = 363.15) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi(p_const=simCenter.p_nom[1], T_const(displayUnit="degC") = 343.15)
                                                                                                  annotation (Placement(transformation(extent={{-80,-38},{-60,-18}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_ground(T=simCenter.T_ground)
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T T_supply_in(unitOption=2) annotation (Placement(transformation(extent={{-70,40},{-50,60}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T T_supply_out(unitOption=1) annotation (Placement(transformation(extent={{45,40},{75,60}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T T_return_out(unitOption=2) annotation (Placement(transformation(extent={{-70,-40},{-50,-60}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi1(p_const=simCenter.p_nom[1], T_const(displayUnit="degC") = 363.15)
                                                                                                  annotation (Placement(transformation(extent={{80,20},{60,40}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow boundaryVLE_Txim_flow1(
    variable_m_flow=false,
    variable_T=true,
    m_flow_const=0.35,
    T_const(displayUnit="degC") = 343.15)                                                                                               annotation (Placement(transformation(extent={{80,-40},{60,-20}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T T_return_in(unitOption=2) annotation (Placement(transformation(extent={{50,-40},{70,-60}})));
  Modelica.Blocks.Sources.Step step(
    height=10,
    offset=90 + 273.15,
    startTime=5000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-90,0})));
equation
  connect(boundaryVLE_Txim_flow.steam_a, doublePipePair_LX.waterPortIn_supply) annotation (Line(
      points={{-60,30},{-40,30},{-40,4},{-10,4}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(doublePipePair_LX.waterPortOut_return,boundaryVLE_pTxi. steam_a) annotation (Line(
      points={{-10,-4},{-40,-4},{-40,-28},{-60,-28}},
      color={175,0,0},
      thickness=0.5));
  connect(T_ground.port, doublePipePair_LX.heat_supply) annotation (Line(points={{-70,80},{0,80},{0,10}}, color={191,0,0}));
  connect(T_ground.port, doublePipePair_LX.heat_return) annotation (Line(points={{-70,80},{-26,80},{-26,-38},{0,-38},{0,-10}}, color={191,0,0}));
  connect(T_supply_in.port, boundaryVLE_Txim_flow.steam_a) annotation (Line(
      points={{-60,40},{-60,30}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(T_supply_out.port, boundaryVLE_pTxi1.steam_a) annotation (Line(
      points={{60,40},{60,30}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(T_return_out.port, boundaryVLE_pTxi.steam_a) annotation (Line(
      points={{-60,-40},{-60,-28}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(T_return_in.port, boundaryVLE_Txim_flow1.steam_a) annotation (Line(
      points={{60,-40},{60,-30}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));

  connect(doublePipePair_LX.waterPortOut_supply, boundaryVLE_pTxi1.steam_a) annotation (Line(
      points={{10,4},{44,4},{44,30},{60,30}},
      color={175,0,0},
      thickness=0.5));
  connect(doublePipePair_LX.waterPortIn_return, boundaryVLE_Txim_flow1.steam_a) annotation (Line(
      points={{10.2,-4},{44,-4},{44,-30},{60,-30}},
      color={175,0,0},
      thickness=0.5));
  connect(step.y, boundaryVLE_Txim_flow.T) annotation (Line(points={{-90,11},{-90,30},{-82,30}}, color={0,0,127}));
  connect(T_supply_out.T, boundaryVLE_Txim_flow1.T) annotation (Line(points={{76.5,50},{104,50},{104,-30},{82,-30}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false), graphics={                                Text(
          extent={{0,100},{92,58}},
          lineColor={0,0,0},
          textString="Look at:
T_supply_in.T_celsius
T_supply_out.T_celsius
and
T_return_in.T_celsius
T_return_out.T_celsius")}),
    experiment(
      StopTime=10000,
      Interval=1,
      __Dymola_Algorithm="Dassl"));
end TestDoublePipePair_L2;
