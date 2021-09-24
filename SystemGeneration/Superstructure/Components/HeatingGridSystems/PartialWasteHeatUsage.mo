within TransiEnt.SystemGeneration.Superstructure.Components.HeatingGridSystems;
partial model PartialWasteHeatUsage


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




  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import TransiEnt;
  import Const = Modelica.Constants;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.fluid1 "Medium to be used" annotation (choicesAllMatching, Dialog(group="Fluid Definition"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // comment: place all inner or outer global setup models here
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn fluidPortIn(Medium=medium) annotation (Placement(transformation(extent={{92,10},{112,30}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut fluidPortOut(Medium=medium) annotation (Placement(transformation(extent={{90,-30},{110,-10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

    ClaRa.Components.Sensors.SensorVLE_L1_T sensorVLE_L1_T_Storage_Producer_Out_lim annotation (Placement(transformation(extent={{62,-54},{42,-34}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T sensorVLE_L1_T_Storage_Producer_In annotation (Placement(transformation(extent={{136,38},{116,58}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature prescribedTemperature(T(displayUnit="K") = 303) annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=-90,
        origin={-1,197})));
  TransiEnt.Components.Boundaries.Heat.Heatflow_L1 heatFlow_externalMassFlowControl(
    Q_flow_const=0,
    use_Q_flow_in=false,
    use_T_out_limit=true,
    p_drop=0,
    T_out_limit_const=273.15 + 55,
    useVariableToutlimit=false) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=180,
        origin={49,-25})));
  ClaRa.Components.Sensors.SensorVLE_L1_T sensorVLE_L1_T_Storage_Producer_Out annotation (Placement(transformation(extent={{76,-6},{56,14}})));
  ClaRa.Components.VolumesValvesFittings.Fittings.JoinVLE_L2_Y joinVLE_L2_Y(
    redeclare model PressureLossIn1 = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.NoFriction,
    redeclare model PressureLossIn2 = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.NoFriction,
    redeclare model PressureLossOut = ClaRa.Components.VolumesValvesFittings.Fittings.Fundamentals.NoFriction,
    volume=10,
    m_flow_in_nom={0.2,0.2},
    p_start=4e5) annotation (Placement(transformation(extent={{-2,32},{-22,12}})));
  ClaRa.Components.VolumesValvesFittings.Valves.ThreeWayValveVLE_L1_simple threeWayValveVLE_L2_1(splitRatio_input=true) annotation (Placement(transformation(extent={{-22,-24},{-2,-42}})));
  ClaRa.Components.Utilities.Blocks.LimPID PIDValve2(
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    Tau_d=0,
    initOption=501,
    y_max=1,
    Tau_i=5,
    y_start=1,
    y_min=1e-7) annotation (Placement(transformation(extent={{-34,-64},{-18,-48}})));
  TransiEnt.Components.Sensors.TemperatureSensor tempBeforeConsumer1(unitOption=1) annotation (Placement(transformation(extent={{-14,32},{-34,52}})));
  TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.HotWaterStorage_constProp_L4 hotWaterStorage1(
    N_cv=6,
    h=10,
    V=1e6,
    U_wall=1e-5,
    U_top=1e-5,
    U_bottom=1e-5,
    T_start={378.15,368.15,353.15,343.15,333.15,323.15},
    T_max_ref=273.15 + 110,
    T_min_ref=273.15 + 50) annotation (Placement(transformation(extent={{32,-10},{12,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=273.15 + 100) annotation (Placement(transformation(extent={{-68,-66},{-48,-46}})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y=2) annotation (Placement(transformation(extent={{34,30},{54,50}})));
  TransiEnt.Components.Heat.Grid.IdealizedExpansionVessel idealizedExpansionVessel(p=400000) annotation (Placement(transformation(extent={{90,52},{110,72}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Modelica.Units.SI.HeatFlowRate Q_flow_in;

equation

  Q_flow_in = fluidPortIn.m_flow*(fluidPortIn.h_outflow - fluidPortOut.h_outflow);
  connect(fluidPortIn, sensorVLE_L1_T_Storage_Producer_In.port) annotation (Line(
      points={{102,20},{100,20},{100,38},{126,38}},
      color={175,0,0},
      thickness=0.5));
  connect(heatFlow_externalMassFlowControl.fluidPortIn, fluidPortOut) annotation (Line(
      points={{52,-20},{100,-20}},
      color={175,0,0},
      thickness=0.5));
  connect(threeWayValveVLE_L2_1.outlet2, joinVLE_L2_Y.inlet2) annotation (Line(
      points={{-12,-24},{-12,12}},
      color={175,0,0},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(PIDValve2.y, threeWayValveVLE_L2_1.splitRatio_external) annotation (Line(points={{-17.2,-56},{-12,-56},{-12,-43}}, color={0,0,127}));
  connect(tempBeforeConsumer1.T, PIDValve2.u_m) annotation (Line(points={{-35,42},{-60,42},{-60,-66},{-28,-66},{-28,-65.6},{-25.92,-65.6}}, color={0,0,127}));
  connect(prescribedTemperature.port, hotWaterStorage1.heatPortAmbient) annotation (Line(points={{-1,190},{0,190},{0,188},{22,188},{22,8.5}}, color={191,0,0}));
  connect(fluidPortOut, sensorVLE_L1_T_Storage_Producer_Out.port) annotation (Line(
      points={{100,-20},{84,-20},{84,-6},{66,-6}},
      color={175,0,0},
      thickness=0.5));
  connect(threeWayValveVLE_L2_1.outlet1, hotWaterStorage1.waterPortIn_grid[1]) annotation (Line(
      points={{-2,-34},{-2,-32},{12,-32},{12,-4}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(hotWaterStorage1.waterPortOut_grid[1], joinVLE_L2_Y.inlet1) annotation (Line(
      points={{12,4},{12,22},{-2,22}},
      color={175,0,0},
      thickness=0.5));
  connect(PIDValve2.u_s, realExpression1.y) annotation (Line(points={{-35.6,-56},{-47,-56}}, color={0,0,127}));
  connect(joinVLE_L2_Y.outlet, tempBeforeConsumer1.port) annotation (Line(
      points={{-22,22},{-24,22},{-24,32}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(hotWaterStorage1.waterPortOut_prod[1], heatFlow_externalMassFlowControl.fluidPortOut) annotation (Line(
      points={{32,-4},{40,-4},{40,-20},{46,-20}},
      color={175,0,0},
      thickness=0.5));
  connect(sensorVLE_L1_T_Storage_Producer_Out_lim.port, hotWaterStorage1.waterPortOut_prod[1]) annotation (Line(
      points={{52,-54},{32,-54},{32,-4}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(hotWaterStorage1.waterPortIn_prod[1], fluidPortIn) annotation (Line(
      points={{32,4},{38,4},{38,20},{102,20}},
      color={175,0,0},
      thickness=0.5));
  connect(fluidPortIn, idealizedExpansionVessel.waterPort) annotation (Line(
      points={{102,20},{100,20},{100,52}},
      color={175,0,0},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Base class to model the storage and usage of excess heat from PtG in the super structure. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
</html>"));
end PartialWasteHeatUsage;
