within TransiEnt.Consumer.DemandSideManagement.HeatpumpSystems.Base;
model DHWHeatpumpSystem "Model for domestic hot water production"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Producer.Heat.Power2Heat.Base.PartialHeatPumpSystemModel(                  final nStor=1, final E_stor={storageDHW.C*params.DTdb_heatpump});

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
  Modelica.Blocks.Sources.Constant T_stor_dhw_set(k=params.T_stor_dhw_set) annotation (Placement(transformation(extent={{-70,6},{-50,26}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor T_stor_dhw_is annotation (Placement(transformation(extent={{-8,-32},{-28,-12}})));
  TransiEnt.Consumer.Heat.Profiles.TypicalHotWaterDrawProfile Q_flow_dhw(gain=-1, profile=params.HowWaterDrawProfile) annotation (Placement(transformation(extent={{94,-32},{74,-12}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor wall_a(G=params.G_loss)
                                                                            annotation (Placement(transformation(extent={{20,26},{40,46}})));
  Modelica.Thermal.HeatTransfer.Celsius.PrescribedTemperature T_amb_set annotation (Placement(transformation(extent={{-14,26},{6,46}})));
  TransiEnt.Components.Visualization.PowerSystemBasics.Energy E_Heatpump(
    E_start=0,
    unit="kWh",
    decimalSpaces=3,
    P=Heatpump.heatPort.Q_flow/1e3) annotation (Placement(transformation(extent={{-72,-28},{-52,-8}})));
  TransiEnt.Components.Visualization.PowerSystemBasics.Energy E_Loss(
    E_start=0,
    unit="kWh",
    decimalSpaces=3,
    P=wall_a.port_b.Q_flow/1e3) annotation (Placement(transformation(extent={{56,28},{76,48}})));
  TransiEnt.Producer.Heat.Power2Heat.Components.StaticHeatpump Heatpump(
    Delta_T_db=params.DTdb_heatpump,
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
  // Characteritic equatuions for inherited variables
  P_el = Heatpump.P_el_HP.y;
  P_el_n = Heatpump.P_el_n;
  SOC[1] = (storageDHW.T - params.T_stor_dhw_set + params.DTdb_heatpump/2)/(params.DTdb_heatpump);
  Q_flow_max = Heatpump.COP.y*Heatpump.P_el_n;
  Q_flow_demand = wall_a.port_b.Q_flow;
  Q_flow_gen = Heatpump.Q_flow.y;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

    connect(heatBdryDHW.port, storageDHW.port) annotation (Line(points={{48,-22},{48,-22},{32,-22}}, color={191,0,0}));
    connect(storageDHW.port, T_stor_dhw_is.port) annotation (Line(points={{32,-22},{-8,-22}},  color={191,0,0}));
    connect(Q_flow_dhw.Q_flow_draw, heatBdryDHW.Q_flow) annotation (Line(points={{73.4,-22},{70,-22},{68,-22}}, color={0,0,127}));
  connect(T_amb_set.port, wall_a.port_a) annotation (Line(points={{6,36},{12,36},{16,36},{20,36}}, color={191,0,0}));
    connect(wall_a.port_b, storageDHW.port) annotation (Line(points={{40,36},{44,36},{44,-22},{32,-22}}, color={191,0,0}));
    connect(Heatpump.heatPort, storageDHW.port) annotation (Line(points={{-18,16},{12,16},{12,-22},{32,-22}}, color={191,0,0}));
    connect(T_amb.y, T_amb_set.T) annotation (Line(points={{-23,36},{-20,36},{-16,36}}, color={0,0,127}));
  connect(T_stor_dhw_set.y, Heatpump.u_set) annotation (Line(points={{-49,16},{-38.4,16}},            color={0,0,127}));
  connect(T_stor_dhw_is.T, Heatpump.u_meas) annotation (Line(points={{-28,-22},{-28,-22},{-28,4.8}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{100,100}})),
                                                                 Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">Domestic hot water production by monovalent heat pump system.</span></p>
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
<p>(no remarks)</p>
</html>"));
end DHWHeatpumpSystem;
