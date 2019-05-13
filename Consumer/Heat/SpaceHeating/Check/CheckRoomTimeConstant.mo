within TransiEnt.Consumer.Heat.SpaceHeating.Check;
model CheckRoomTimeConstant
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
  extends TransiEnt.Basics.Icons.Checkmodel;
  RoomFloorHeating roomFloorHeating(
    redeclare Base.RoomGeometry geometry,
    redeclare Base.FloorHeatingSystem heatingsystem(T_spreading=10),
    use_T_amb_input=true,
    redeclare Characteristics.HouseType70 thermodynamics,
    T_room(start=566.3),
    T_floor(start=566.3),
    T_wallInside(start=566.3),
    T_wallInternal(start=(273.15 + 20 + 293.15)/2)) annotation (Placement(transformation(extent={{40,-50},{-2,-10}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    T_const=273.15 + 25,
    variable_T=false,
    p_const=1e5) annotation (Placement(transformation(extent={{-60,-68},{-40,-48}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source(
    T_const=273.15 + 45,
    variable_m_flow=false,
    variable_T=true,
    m_flow_const=simCenter.m_flow_small)
                     annotation (Placement(transformation(extent={{-42,-8},{-22,12}})));
  Modelica.Blocks.Sources.Constant normAmbientTemperatur(k=273.15 - 12) "EN 12831 value of Hamburg" annotation (Placement(transformation(extent={{-28,34},{-8,54}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-130,60},{-110,80}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureSensor annotation (Placement(transformation(extent={{-20,-56},{-40,-36}})));
equation
  connect(sink.steam_a, roomFloorHeating.waterOut) annotation (Line(
      points={{-40,-58},{-18,-58},{-18,-48},{0.1,-48}},
      color={0,131,169},
      thickness=0.5));
  connect(roomFloorHeating.waterIn, source.steam_a) annotation (Line(
      points={{0.1,-12},{-12,-12},{-12,2},{-22,2}},
      color={175,0,0},
      thickness=0.5));
  connect(temperatureSensor.port, sink.steam_a) annotation (Line(
      points={{-30,-56},{-30,-58},{-40,-58}},
      color={0,131,169},
      thickness=0.5));
  connect(normAmbientTemperatur.y, roomFloorHeating.T_Amb) annotation (Line(points={{-7,44},{18.37,44},{18.37,-10.2}}, color={0,0,127}));
  connect(roomFloorHeating.T_Room, source.T) annotation (Line(points={{40,-38},{52,-38},{52,18},{-52,18},{-52,2},{-44,2}}, color={0,0,127}));
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
<p>Test environment for a room floor heating with a fluid source, a fluid sink and a constant ambient temperature</p>
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
end CheckRoomTimeConstant;
