within TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Check;
model TestSinglePipe_L2

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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

  TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.SinglePipe_L2 singlePipe_LX(
    p_start=simCenter.p_nom[1],
    T_start=333.15,
    m_flow_start=0.4,
    v_nom=1,
    activate_volumes=true,
    length=1000,
    calc_initial_dstrb=true,
    diameter_i(displayUnit="m"),
    z_in=2,
    z_out=2) annotation (Placement(transformation(extent={{-5,-16},{33,16}})));
  inner SimCenter simCenter(
    activate_volumes=true,
    calc_initial_dstrb=true,
    v_nom=0.18,
    lambda_ground=1.2)      annotation (Placement(transformation(extent={{58,54},{68,64}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow boundaryVLE_Txim_flow(
    variable_m_flow=false,
    variable_T=true,
    m_flow_const=0.4,                                                                             T_const(displayUnit="degC") = 363.15) annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature T_ground(T=simCenter.T_ground)
    annotation (Placement(transformation(extent={{-76,40},{-56,60}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T T_supply_in(unitOption=2) annotation (Placement(transformation(extent={{-36,10},{-16,30}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T T_supply_out(unitOption=2) annotation (Placement(transformation(extent={{39,10},{69,30}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi1(p_const=simCenter.p_nom[1], T_const(displayUnit="degC") = 363.15)
                                                                                                  annotation (Placement(transformation(extent={{94,-10},{74,10}})));
  Modelica.Blocks.Sources.Step step(
    height=10,
    offset=60 + 273.15,
    startTime=5000) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-76,-40})));
equation
  connect(T_supply_in.port, boundaryVLE_Txim_flow.steam_a) annotation (Line(
      points={{-26,10},{-26,6},{-46,6},{-46,0}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(T_supply_out.port, boundaryVLE_pTxi1.steam_a) annotation (Line(
      points={{54,10},{54,6},{74,6},{74,0}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundaryVLE_Txim_flow.steam_a, singlePipe_LX.waterPortIn) annotation (Line(
      points={{-46,0},{-5,0}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(singlePipe_LX.waterPortOut, boundaryVLE_pTxi1.steam_a) annotation (Line(
      points={{33,0},{74,0}},
      color={175,0,0},
      thickness=0.5));
  connect(T_ground.port, singlePipe_LX.heat) annotation (Line(points={{-56,50},{14,50},{14,16}},
                                                                                               color={191,0,0}));
  connect(step.y, boundaryVLE_Txim_flow.T) annotation (Line(points={{-76,-29},{-76,0},{-68,0}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false), graphics={                                Text(
          extent={{-38,102},{36,64}},
          lineColor={0,0,0},
          textString="Look at:
T_supply_in.T_celsius
T_supply_out.T_celsius")}),
    experiment(StopTime=10000, Interval=60));
end TestSinglePipe_L2;
