within TransiEnt.Consumer.Systems.HeatpumpSystems.Base;
model BivalentHeatpumpSystem "Model of a bivalent heat pump system"

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

  extends TransiEnt.Producer.Heat.Power2Heat.Heatpump.Base.PartialHeatPumpSystemModel(         final nStor=2,  final E_stor={Room.C*params.DTdb_heatpump, Storage.C*(T_stor_ref_max - T_stor_ref_min)});
  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter SI.Temperature T_stor_ref_max = 90+273.15 "Maximum storage temperature for SOC and Capacity calculation";
  parameter SI.Temperature T_stor_ref_min = params.T_feed_lim_degC+273.15 "Minimum storage temperature for SOC and Capacity calculation";
  parameter SI.HeatFlowRate Q_flow_demand_small = 100 "100 Watt is considered small since it would be sufficient to invite a friend to dinner";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Real SOC_set[nStor];
  SI.Power P_el_pl_electric;
  SI.Power P_el_n_pl_electric;
  SI.Energy W_HPS(start=0, fixed=true)
                                      annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.Energy Q_HPS(start=0,fixed=true)
                                     annotation (Dialog(group="Initialization", showStartAttribute=true));
  Real JAZ = Q_HPS / max(W_HPS, simCenter.E_small);

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor
                                              Room(C=params.C_room, T(start=params.T_room_start, fixed=true))
                                                                                              annotation (Placement(transformation(extent={{154,-16},{174,4}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor T_stor_is annotation (Placement(transformation(extent={{26,-52},{6,-32}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor wall_a(G=params.G_loss)
                                                                            annotation (Placement(transformation(extent={{150,44},{170,64}})));
  Modelica.Thermal.HeatTransfer.Celsius.PrescribedTemperature
                                                         T_amb annotation (Placement(transformation(extent={{124,44},{144,64}})));
  TransiEnt.Components.Visualization.PowerSystemBasics.Energy E_Heatpump(
    E_start=0,
    unit="kWh",
    decimalSpaces=3,
    P=-heatPump.heatPort.Q_flow/1e3) annotation (Placement(transformation(extent={{-70,-94},{-50,-74}})));
  TransiEnt.Components.Visualization.PowerSystemBasics.Energy E_heatingdemand(
    E_start=0,
    unit="kWh",
    decimalSpaces=3,
    P=T_amb.port.Q_flow/1e3) annotation (Placement(transformation(extent={{28,-96},{48,-76}})));
  Modelica.Blocks.Sources.RealExpression T_amb_deg_C(y=simCenter.ambientConditions.temperature.value)       annotation (Placement(transformation(extent={{93,44},{113,64}})));
  Modelica.Blocks.Sources.RealExpression T_amb_K(y=273.15 + simCenter.ambientConditions.temperature.value) annotation (Placement(transformation(extent={{-81,6},{-61,26}})));
  Modelica.Blocks.Sources.Constant zero(k=0) annotation (Placement(transformation(extent={{-34,0},{-24,10}})));
  Modelica.Blocks.Logical.Switch Q_flow_peakload annotation (Placement(transformation(extent={{-16,9},{-2,23}})));
  Modelica.Blocks.Continuous.LimPID ctrlPeakload(
    yMin=0,
    Td=0.01,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
      yMax=params.Q_flow_n_peakunit,
    Ti=60,
      k=1e4)                  annotation (Placement(transformation(extent={{-96,34},{-76,54}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatBdryPeakloadFH annotation (Placement(transformation(extent={{6,6},{26,26}})));
  TransiEnt.Components.Visualization.PowerSystemBasics.Energy E_Peakload(
    E_start=0,
    unit="kWh",
    decimalSpaces=3,
    P=Q_flow_peakload.y/1e3)  annotation (Placement(transformation(extent={{-42,-96},{-22,-76}})));
  Modelica.Blocks.Sources.RealExpression x_PeakLoad_per_Cent(y=E_Peakload.E/(E_Heatpump.E + E_Peakload.E + 0.0001)*100) annotation (Placement(transformation(extent={{82,-98},{102,-78}})));
  Producer.Heat.Power2Heat.Heatpump.BivalentHeatPumpWithControl
                                                        heatPump(
    Modulating=false,
    CalculatePHeater=true,
    Delta_T_db=params.DTdb_heatpump,
    t_min_on=params.t_min_on_heatpump,
    t_min_off=params.t_min_off_heatpump,
    usePowerPort=false,
    useFluidPorts=false,
    useHeatPort=true,
    Q_flow_n=params.Q_flow_n_heatpump,
    COP_n=params.COP_n_heatpump,
    init_state=params.HPInitStatus,
    controller(
      CalculatePHeater=true,
      P_elHeater=0,
      T_bivalent=params.T_bivalent,
      T_heatingLimit=params.T_room_set)) annotation (Placement(transformation(extent={{-28,-29},{-2,-3}})));
  Modelica.Blocks.Logical.LessThreshold         isPeakload(threshold=params.T_bivalent)
                                                                         annotation (Placement(transformation(extent={{-52,9},{-38,23}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow FloorHeatingBdry annotation (Placement(transformation(extent={{128,-26},{148,-6}})));
  Modelica.Blocks.Continuous.LimPID ctrlFloorHeating(
    k=params.G_loss*(params.T_room_set - (273.15 - 12)),
    yMax=50e3,
    yMin=0,
    Ti=900,
    initType=Modelica.Blocks.Types.Init.InitialOutput) annotation (Placement(transformation(extent={{98,2},{118,22}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor T_room_is annotation (Placement(transformation(extent={{160,-84},{140,-64}})));
  Modelica.Blocks.Sources.Constant T_room_set(k=params.T_room_set) annotation (Placement(transformation(extent={{163,-50},{143,-30}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor Storage(C=params.V_stor_fh*1e3*4.2e3, T(start=params.T_stor_fh_start, fixed=true)) annotation (Placement(transformation(extent={{40,-2},{60,18}})));
  Modelica.Blocks.Tables.CombiTable1Dv T_stor_set(
    tableOnFile=false,
    table=[params.T_ref_degC - 20,params.T_feed_ref_degC + 273.15; params.T_ref_degC,params.T_feed_ref_degC + 273.15; params.T_lim_degC,params.T_feed_lim_degC + 273.15; params.T_lim_degC + 20,params.T_feed_lim_degC + 273.15],
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments) annotation (Placement(transformation(extent={{-128,-26},{-108,-6}})));
  Modelica.Blocks.Sources.RealExpression T_amb1(
                                               y=simCenter.ambientConditions.temperature.value) annotation (Placement(transformation(extent={{-112,16},{-132,36}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatBdryFloorHeatingDeload annotation (Placement(transformation(extent={{82,-26},{62,-6}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(extent={{84,24},{70,38}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor wall_stor(G=4.58) "Taken from Knop page 48, Viessmann Vitocell 100-W (200l, 2,2kWh loss per 24h at Delta T 45K)"
                                                                                                    annotation (Placement(transformation(extent={{32,42},{52,62}})));
  TransiEnt.Components.Visualization.PowerSystemBasics.Energy E_storageloss(
    E_start=0,
    unit="kWh",
    decimalSpaces=3,
    P=wall_stor.port_b.Q_flow/1e3) annotation (Placement(transformation(extent={{-6,-96},{14,-76}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
                                                           heatBdryPeakloadFH1
                                                                              annotation (Placement(transformation(extent={{2,42},{22,62}})));
  inner Components.Boundaries.Ambient.AmbientConditions ambientConditions annotation (Placement(transformation(extent={{-138,80},{-118,100}})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  // Characteritic equatuions for inherited variables
  P_el_pl_electric =heatPump.controller.Q_flow_set_HP + Q_flow_peakload.y/params.eta_peakunit;
  P_el =heatPump.controller.Q_flow_set_HP;
  P_el_n_pl_electric =heatPump.P_el_n + params.Q_flow_n_peakunit/params.eta_peakunit;
  P_el_n =heatPump.P_el_n;
  SOC[1] = max(0, min(1, (Room.T - params.T_room_set + params.DTdb_heatpump/2)/(params.DTdb_heatpump)));
  SOC[2] = max(0, min((Storage.T - T_stor_ref_min)/(T_stor_ref_max-T_stor_ref_min)));
  SOC_set[1] = 0.5;
  SOC_set[2] = max(0, min((T_stor_set.y[1] - T_stor_ref_min)/(T_stor_ref_max-T_stor_ref_min)));
  Q_flow_demand = max(Q_flow_demand_small,wall_a.port_b.Q_flow);

  Q_flow_max =params.Q_flow_n_peakunit + heatPump.COP.y*heatPump.P_el_n;
  Q_flow_gen =heatPump.Heat_output + Q_flow_peakload.y;

  der(Q_HPS) = Q_flow_gen;
  der(W_HPS) = P_el_pl_electric;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

    connect(T_amb.port, wall_a.port_a) annotation (Line(points={{144,54},{144,54},{150,54}},
                                                                                          color={191,0,0}));
    connect(wall_a.port_b, Room.port) annotation (Line(points={{170,54},{178,54},{178,-16},{164,-16}},
                                                                                                   color={191,0,0}));
    connect(T_amb_deg_C.y, T_amb.T) annotation (Line(points={{114,54},{114,54},{122,54}},
                                                                                        color={0,0,127}));
  connect(ctrlPeakload.y, Q_flow_peakload.u1) annotation (Line(points={{-75,44},{-30,44},{-30,21.6},{-17.4,21.6}},
                                                                                                    color={0,0,127}));
  connect(zero.y, Q_flow_peakload.u3) annotation (Line(points={{-23.5,5},{-23.5,5},{-22,5},{-22,10.4},{-17.4,10.4}},
                                                                                              color={0,0,127}));
  connect(T_stor_is.T, ctrlPeakload.u_m) annotation (Line(points={{5,-42},{-86,-42},{-86,32}},           color={0,0,127}));
    connect(Q_flow_peakload.y, heatBdryPeakloadFH.Q_flow) annotation (Line(points={{-1.3,16},{-1.3,16},{6,16}},  color={0,0,127}));
  connect(isPeakload.y, Q_flow_peakload.u2) annotation (Line(points={{-37.3,16},{-37.3,16},{-17.4,16}},
                                                                                                    color={255,0,255}));
  connect(T_amb_K.y,isPeakload. u) annotation (Line(points={{-60,16},{-53.4,16}}, color={0,0,127}));
  connect(FloorHeatingBdry.port, Room.port) annotation (Line(points={{148,-16},{164,-16}}, color={191,0,0}));
  connect(T_room_is.port, Room.port) annotation (Line(points={{160,-74},{170,-74},{170,-16},{164,-16}},
                                                                                              color={191,0,0}));
  connect(heatPump.heatPort, Storage.port) annotation (Line(points={{-2.78,-7.68},{10,-7.68},{50,-7.68},{50,-2}}, color={191,0,0}));
  connect(heatBdryPeakloadFH.port, Storage.port) annotation (Line(points={{26,16},{32,16},{32,-16},{50,-16},{50,-2}}, color={191,0,0}));
  connect(T_stor_is.port, Storage.port) annotation (Line(points={{26,-42},{34,-42},{50,-42},{50,-2}}, color={191,0,0}));
  connect(T_amb1.y,T_stor_set. u[1]) annotation (Line(points={{-133,26},{-133,-16},{-130,-16}},    color={0,0,127}));
  connect(T_stor_set.y[1], ctrlPeakload.u_s) annotation (Line(points={{-107,-16},{-104,-16},{-104,44},{-98,44}},
                                                                                                    color={0,0,127}));
  connect(heatBdryFloorHeatingDeload.port, Storage.port) annotation (Line(points={{62,-16},{56,-16},{50,-16},{50,-2}},
                                                                                                    color={191,0,0}));
  connect(gain.y, heatBdryFloorHeatingDeload.Q_flow) annotation (Line(points={{69.3,31},{68,31},{68,0},{88,0},{88,-16},{82,-16}}, color={0,0,127}));
  connect(ctrlFloorHeating.y, FloorHeatingBdry.Q_flow) annotation (Line(points={{119,12},{128,12},{128,-8},{120,-8},{120,-16},{128,-16}}, color={0,0,127}));
  connect(ctrlFloorHeating.y, gain.u) annotation (Line(points={{119,12},{128,12},{128,26},{128,31},{85.4,31}}, color={0,0,127}));
  connect(ctrlFloorHeating.u_m, T_room_is.T) annotation (Line(points={{108,0},{108,-74},{139,-74}}, color={0,0,127}));
  connect(T_room_set.y, ctrlFloorHeating.u_s) annotation (Line(points={{142,-40},{132,-40},{90,-40},{90,12},{96,12}}, color={0,0,127}));
  connect(Storage.port, wall_stor.port_b) annotation (Line(points={{50,-2},{54,-2},{54,-4},{60,-4},{60,52},{52,52}}, color={191,0,0}));
    connect(heatBdryPeakloadFH1.port, wall_stor.port_a) annotation (Line(points={{22,52},{32,52}}, color={191,0,0}));
    connect(T_room_is.T, heatBdryPeakloadFH1.T) annotation (Line(points={{139,-74},{139,-74},{-136,-74},{-136,66},{-24,66},{-24,52},{0,52},{0,52}},           color={0,0,127}));
  connect(heatPump.T_set, T_stor_set.y[1]) annotation (Line(points={{-28.39,-25.49},{-102,-25.49},{-102,-16},{-107,-16}}, color={0,0,127}));
  connect(T_stor_is.T, heatPump.T) annotation (Line(points={{5,-42},{-86,-42},{-86,-10},{-27.48,-10},{-27.48,-10.8}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{180,100}})),
                                                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{180,100}}), graphics={Text(
          extent={{144,96},{176,84}},
          lineColor={0,0,0},
          textString="1: Room
2: Storage",
          horizontalAlignment=TextAlignment.Left)}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">Heatpump system with bivalent control, floor heating and lumped heat storage.</span></p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no elements)</p>
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
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) 2014</p>
</html>"));
end BivalentHeatpumpSystem;
