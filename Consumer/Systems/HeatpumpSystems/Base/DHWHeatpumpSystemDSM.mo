within TransiEnt.Consumer.Systems.HeatpumpSystems.Base;
model DHWHeatpumpSystemDSM "Model for domestic hot water production for demand side management scenarios"

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

  extends TransiEnt.Consumer.Systems.HeatpumpSystems.Base.PartialHeatPumpSystemDSM(final nStor=1, final E_stor={storageDHW.C*params.DTdb_heatpump});

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor storageDHW(C=params.V_stor_dhw*1e3*4.2e3, T(start=params.T_stor_dhw_start)) annotation (Placement(transformation(extent={{22,-22},{42,-2}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatBdryDHW annotation (Placement(transformation(extent={{68,-32},{48,-12}})));
  Modelica.Blocks.Sources.RealExpression
                                   T_stor_dhw_set(y=if isLoadShedding then 0 else params.T_stor_dhw_set)
                                                                           annotation (Placement(transformation(extent={{-74,6},{-54,26}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor T_stor_dhw_is annotation (Placement(transformation(extent={{-8,-32},{-28,-12}})));
  TransiEnt.Consumer.Heat.Profiles.TypicalHotWaterDrawProfile Q_flow_dhw(gain=-1, profile=params.HowWaterDrawProfile) annotation (Placement(transformation(extent={{94,-32},{74,-12}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor wall_a(G=params.G_loss)
                                                                            annotation (Placement(transformation(extent={{20,26},{40,46}})));
  Modelica.Thermal.HeatTransfer.Celsius.PrescribedTemperature T_amb_set annotation (Placement(transformation(extent={{-14,26},{6,46}})));
  TransiEnt.Components.Visualization.PowerSystemBasics.Energy E_Heatpump(
    E_start=0,
    unit="kWh",
    decimalSpaces=3,
    P=heatPumpWithControl.heatPort.Q_flow/1e3) annotation (Placement(transformation(extent={{-72,-28},{-52,-8}})));
  TransiEnt.Components.Visualization.PowerSystemBasics.Energy E_Loss(
    E_start=0,
    unit="kWh",
    decimalSpaces=3,
    P=wall_a.port_b.Q_flow/1e3) annotation (Placement(transformation(extent={{56,28},{76,48}})));
  Producer.Heat.Power2Heat.Heatpump.BivalentHeatPumpWithControl heatPumpWithControl(
    Modulating=false,
    MinTimes=false,
    Delta_T_db=params.DTdb_heatpump,
    usePowerPort=false,
    useFluidPorts=false,
    useHeatPort=true,
    Q_flow_n=params.Q_flow_n_heatpump,
    COP_n=params.COP_n_heatpump) annotation (Placement(transformation(extent={{-38,6},{-18,26}})));
  Modelica.Blocks.Sources.RealExpression
                                   T_amb(y=simCenter.T_amb_var)
                                                        annotation (Placement(transformation(extent={{-44,26},{-24,46}})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  // Characteritic equations for inherited variables
  P_el =heatPumpWithControl.heatPump.P_el.y;
  P_el_n =heatPumpWithControl.P_el_n;
  SOC[1] = (storageDHW.T - params.T_stor_dhw_set + params.DTdb_heatpump/2)/(params.DTdb_heatpump);
  Q_flow_max =heatPumpWithControl.COP.y*heatPumpWithControl.P_el_n;
  Q_flow_demand = wall_a.port_b.Q_flow;
  Q_flow_gen =heatPumpWithControl.heatPort.Q_flow;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

    connect(heatBdryDHW.port, storageDHW.port) annotation (Line(points={{48,-22},{48,-22},{32,-22}}, color={191,0,0}));
    connect(storageDHW.port, T_stor_dhw_is.port) annotation (Line(points={{32,-22},{-8,-22}},  color={191,0,0}));
    connect(Q_flow_dhw.Q_flow_draw, heatBdryDHW.Q_flow) annotation (Line(points={{73.4,-22},{70,-22},{68,-22}}, color={0,0,127}));
  connect(T_amb_set.port, wall_a.port_a) annotation (Line(points={{6,36},{12,36},{16,36},{20,36}}, color={191,0,0}));
    connect(wall_a.port_b, storageDHW.port) annotation (Line(points={{40,36},{44,36},{44,-22},{32,-22}}, color={191,0,0}));
  connect(heatPumpWithControl.heatPort, storageDHW.port) annotation (Line(points={{-18.6,22.4},{12,22.4},{12,-22},{32,-22}}, color={191,0,0}));
    connect(T_amb.y, T_amb_set.T) annotation (Line(points={{-23,36},{-20,36},{-16,36}}, color={0,0,127}));
  connect(T_stor_dhw_set.y, heatPumpWithControl.T_set) annotation (Line(points={{-53,16},{-44,16},{-44,8.7},{-38.3,8.7}}, color={0,0,127}));
  connect(T_stor_dhw_is.T, heatPumpWithControl.T) annotation (Line(points={{-29,-22},{-38,-22},{-38,-16},{-48,-16},{-48,20},{-37.6,20}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{100,100}})),
                                                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">Domestic hot water production by monovalent heat pump system for Demand Side Management scenarios.</span></p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>isLoadShedding - boolean signal</p>
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
<p>(no remarks)</p>
</html>"));
end DHWHeatpumpSystemDSM;
