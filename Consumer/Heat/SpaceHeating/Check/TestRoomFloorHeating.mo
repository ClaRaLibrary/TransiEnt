within TransiEnt.Consumer.Heat.SpaceHeating.Check;
model TestRoomFloorHeating
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

  RoomFloorHeating roomFloorHeating(
    redeclare Base.RoomGeometry geometry,
    use_T_amb_input=false,
    redeclare Characteristics.HouseType100 thermodynamics,
    redeclare Base.FloorHeatingSystem heatingsystem(T_spreading=10),
    T_room(start=normSetpointRoomTemperature.T),
    T_floor(start=normSetpointRoomTemperature.T),
    T_wallInside(start=normSetpointRoomTemperature.T),
    T_wallInternal(start=(273.15 + 20 + normSetpointRoomTemperature.T)/2)) annotation (Placement(transformation(extent={{40,-50},{-2,-10}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    T_const=273.15 + 25,
    variable_T=false,
    p_const=1e5) annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source(
    m_flow_const=300/3600,
    T_const=273.15 + 45,
    variable_m_flow=true,
    variable_T=true) annotation (Placement(transformation(extent={{-42,-8},{-22,12}})));
  Modelica.Blocks.Logical.OnOffController ctrl(             pre_y_start=true, bandwidth=2)
                                                                              annotation (Placement(transformation(extent={{60,32},{40,52}})));
  NormSetpointRoomTemperature normSetpointRoomTemperature(roomType=Base.RoomType_EN12831.appartment) annotation (Placement(transformation(extent={{96,38},{76,58}})));
  Modelica.Blocks.Sources.Constant normAmbientTemperatur(k=273.15 - 12) "EN 12831 value of Hamburg" annotation (Placement(transformation(extent={{-40,54},{-20,74}})));
  inner SimCenter simCenter(ambientConditions(redeclare TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperature))
                            annotation (Placement(transformation(extent={{-130,60},{-110,80}})));
  Modelica.Blocks.Sources.RealExpression T_feed_set(y=max((24.5 - simCenter.T_amb_var*25/22) + 273.15, simCenter.T_amb_var + 273.15))
                                                                                                annotation (Placement(transformation(extent={{-89,-26},{-69,-6}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureSensor annotation (Placement(transformation(extent={{-20,-56},{-40,-36}})));
  Modelica.Blocks.Math.BooleanToReal m_flow_nom(realFalse=0, realTrue=3.25e3/4.2e3/10) annotation (Placement(transformation(extent={{-106,14},{-86,34}})));
  Modelica.Blocks.Nonlinear.Limiter m_flow(uMax=1, uMin=simCenter.m_flow_small)
    annotation (Placement(transformation(extent={{-74,14},{-54,34}})));
  TransiEnt.Basics.Blocks.OnOffRelais onOffRelais(
    t_min_on=360,
    t_min_off=360,
    init_state=1) annotation (Placement(transformation(extent={{24,32},{4,52}})));
equation
  connect(sink.steam_a, roomFloorHeating.waterOut) annotation (Line(
      points={{-40,-60},{-10,-60},{-10,-48},{0.1,-48}},
      color={0,131,169},
      thickness=0.5));
  connect(T_feed_set.y, source.T) annotation (Line(points={{-68,-16},{-68,-8},{-68,2},{-56,2},{-44,2}},          color={0,0,127}));
  connect(roomFloorHeating.waterIn, source.steam_a) annotation (Line(
      points={{0.1,-12},{-10,-12},{-10,2},{-22,2}},
      color={175,0,0},
      thickness=0.5));
  connect(temperatureSensor.port, sink.steam_a) annotation (Line(
      points={{-30,-56},{-30,-56},{-30,-60},{-40,-60}},
      color={0,131,169},
      thickness=0.5));
  connect(ctrl.reference, normSetpointRoomTemperature.y) annotation (Line(points={{62,48},{75,48}}, color={0,0,127}));
  connect(ctrl.u, roomFloorHeating.T_Room) annotation (Line(points={{62,36},{74,36},{74,-38},{40,-38}}, color={0,0,127}));
  connect(m_flow_nom.y, m_flow.u) annotation (Line(points={{-85,24},{-76,24}}, color={0,0,127}));
  connect(m_flow.y, source.m_flow) annotation (Line(points={{-53,24},{-44,24},{-44,8}}, color={0,0,127}));
  connect(onOffRelais.u, ctrl.y) annotation (Line(points={{24.4,42},{39,42}}, color={255,0,255}));
  connect(onOffRelais.y, m_flow_nom.u) annotation (Line(points={{3,42},{-122,42},{-122,24},{-108,24}}, color={255,0,255}));
  annotation (Diagram(graphics,
                      coordinateSystem(extent={{-140,-80},{140,80}})), Icon(graphics,
                                                                            coordinateSystem(extent={{-140,-80},{140,80}})),
    experiment(
      StopTime=604800,
      Interval=900,
      __Dymola_fixedstepsize=5,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Test environment for a room floor heating model with a fluid source, a fluid sink and different technical components to make this a runnable example</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
</html>"));
end TestRoomFloorHeating;
