within TransiEnt.Producer.Electrical.Conventional.Components;
model DetailedSteamPowerPlant_InitCycle
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  import TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.*;
  import SI = ClaRa.Basics.Units;
  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer ClaRa.SimCenter simCenter;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium = simCenter.fluid1 "Medium in the component"
    annotation(choices(choice=simCenter.fluid1 "First fluid defined in global simCenter",
                       choice=simCenter.fluid2 "Second fluid defined in global simCenter",
                       choice=simCenter.fluid3 "Third fluid defined in global simCenter"),
                                                          Dialog(group="Fundamental Definitions"));
  parameter Modelica.SIunits.Power P_n;
  inner parameter SI.MassFlowRate m_flow_nom=7.38e-7*P_n - 6.37;
  inner parameter Real P_target_=1;
  // Heat Exchangers
  parameter SI.Pressure p_condenser=3800 annotation(Dialog(tab="Heat exchangers",group="Condenser"));
  parameter SI.Pressure preheater_HP_p_tap = 55.95e5 annotation(Dialog(tab="Heat exchangers",group="Preheater HP"));
  parameter SI.MassFlowRate preheater_HP_m_flow_tap = 42.812 annotation(Dialog(tab="Heat exchangers",group="Preheater HP"));
  parameter SI.Pressure preheater_LP1_p_tap = 0.207e5 annotation(Dialog(tab="Heat exchangers",group="Preheater LP1"));
  parameter SI.MassFlowRate preheater_LP1_m_flow_tap = 14.5 annotation(Dialog(tab="Heat exchangers",group="Preheater LP1"));
  // Feedwater tank
  parameter SI.Pressure p_FWT=12.81e5 annotation(Dialog(tab="Heat exchangers",group="Feedwater tank"));
  // Valves
  parameter SI.PressureDifference valve1_HP_Delta_p_nom=4e5 annotation(Dialog(group="Valve1_HP",tab="Valves"));
//  parameter SI.PressureDifference valve_IP_m_flow_nom= (m_flow_nom - preheater_HP_m_flow_tap)/10 annotation(Dialog(group="Valve_IP",tab="Valves"));

  parameter SI.PressureDifference valve_LP1_Delta_p_nom=0.001e5 annotation(Dialog(group="Valve_LP1",tab="Valves"));
  parameter SI.PressureDifference valve_LP2_Delta_p_nom=0.001e5 annotation(Dialog(group="Valve_LP2",tab="Valves"));
  // Boiler
  parameter SI.Temperature T_LS_nom=823  annotation(Dialog(tab="Boiler"));
  parameter SI.Temperature T_RS_nom=833  annotation(Dialog(tab="Boiler"));
  parameter SI.Pressure p_LS_out_nom=250.2e5 annotation(Dialog(tab="Boiler"));
  parameter SI.Pressure p_RS_out_nom=51e5 annotation(Dialog(tab="Boiler"));
  parameter SI.PressureDifference Delta_p_LS_nom=89e5 annotation(Dialog(tab="Boiler"));
  parameter SI.PressureDifference Delta_p_RS_nom=5e5 annotation(Dialog(tab="Boiler"));
  parameter Real CharLine_Delta_p_HP_mLS_[:,:]=[0,0; 0.1,0.01; 0.2,0.04; 0.3,0.09; 0.4,
      0.16; 0.5,0.25; 0.6,0.36; 0.7,0.49; 0.8,0.64; 0.9,0.81; 1,1] "Characteristic line of pressure drop as function of mass flow rate"
                                                                         annotation(Dialog(tab="Boiler"));
  parameter Real CharLine_Delta_p_IP_mRS_[:,:]=[0,0; 0.1,0.01; 0.2,0.04; 0.3,0.09; 0.4,
      0.16; 0.5,0.25; 0.6,0.36; 0.7,0.49; 0.8,0.64; 0.9,0.81; 1,1] "Characteristic line of pressure drop as function of mass flow rate"
                                                                         annotation(Dialog(tab="Boiler"));
  // Pumps
  parameter Real efficiency_Pump_cond=1 annotation(Dialog(tab="Pumps"));
  parameter Real efficiency_Pump_preheater_LP1=1 annotation(Dialog(tab="Pumps"));
  parameter Real efficiency_Pump_FW=1 annotation(Dialog(tab="Pumps"));
  // Turbines
  parameter SI.Pressure tapping_IP_pressure=15e5  annotation(Dialog(tab="Turbines"));
  parameter Real efficiency_Turb_HP=1 annotation(Dialog(tab="Turbines"));
  parameter Real efficiency_Turb_IP=1 annotation(Dialog(tab="Turbines"));
  parameter Real efficiency_Turb_LP1=1 annotation(Dialog(tab="Turbines"));
  parameter Real efficiency_Turb_LP2=1 annotation(Dialog(tab="Turbines"));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  ClaRa.StaticCycles.HeatExchanger.Condenser condenser(p_condenser=p_condenser) annotation (Placement(transformation(extent={{74,-20},{94,0}})));
  ClaRa.StaticCycles.Machines.Pump1 Pump_cond(efficiency=efficiency_Pump_cond) annotation (Placement(transformation(extent={{80,-70},{60,-50}})));
  ClaRa.StaticCycles.HeatExchanger.Preheater1 preheater_LP1(m_flow_tap_nom=preheater_LP1_m_flow_tap, p_tap_nom=preheater_LP1_p_tap) annotation (Placement(transformation(extent={{54,-70},{34,-50}})));
  ClaRa.StaticCycles.Machines.Pump1 Pump_preheater_LP1(efficiency=efficiency_Pump_preheater_LP1) annotation (Placement(transformation(extent={{34,-90},{14,-70}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom3 valve_LP2(Delta_p_nom=valve_LP2_Delta_p_nom) annotation (Placement(transformation(extent={{24,-64},{14,-58}})));
  ClaRa.StaticCycles.Storage.Feedwatertank4 feedwatertank(m_flow_nom=m_flow_nom*P_target_, p_FWT_nom=p_FWT) annotation (Placement(transformation(extent={{-6,-64},{-26,-52}})));
  ClaRa.StaticCycles.Fittings.Mixer1 join_LP_main annotation (Placement(transformation(extent={{-2,-66},{8,-60}})));
  ClaRa.StaticCycles.Machines.Pump1 Pump_FW(efficiency=efficiency_Pump_FW) annotation (Placement(transformation(extent={{-40,-70},{-60,-50}})));
  ClaRa.StaticCycles.HeatExchanger.Preheater1 preheater_HP(m_flow_tap_nom=preheater_HP_m_flow_tap, p_tap_nom=preheater_HP_p_tap) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-76,-20})));
  ClaRa.StaticCycles.Furnace.Boiler_simple boiler(
    T_LS_nom=T_LS_nom,
    T_RS_nom=T_RS_nom,
    Delta_p_LS_nom=Delta_p_LS_nom,
    Delta_p_RS_nom=Delta_p_RS_nom,
    p_LS_out_nom=p_LS_out_nom,
    p_RS_out_nom=p_RS_out_nom,
    CharLine_Delta_p_HP_mLS_=CharLine_Delta_p_HP_mLS_,
    CharLine_Delta_p_IP_mRS_=CharLine_Delta_p_IP_mRS_,
    m_flow_LS_nom=m_flow_nom,
    m_flow_RS_nom=m_flow_nom)                          annotation (Placement(transformation(extent={{-86,18},{-66,38}})));
  ClaRa.StaticCycles.Machines.Turbine Turbine_HP(efficiency=efficiency_Turb_HP) annotation (Placement(transformation(extent={{-56,30},{-44,50}})));
  ClaRa.StaticCycles.Fittings.Split1 join_HP annotation (Placement(transformation(extent={{-40,-2},{-50,4}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom1 valve1_HP(Delta_p_nom=valve1_HP_Delta_p_nom) annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={-45,-11})));
  ClaRa.StaticCycles.ValvesConnects.Valve_cutPressure1 valve_cut annotation (Placement(transformation(
        extent={{-5.5,-3},{5.5,3}},
        rotation=180,
        origin={-63.5,3})));
  ClaRa.StaticCycles.ValvesConnects.Valve_cutPressure1 valve2_HP annotation (Placement(transformation(extent={{-52,-44},{-42,-38}})));
  ClaRa.StaticCycles.Machines.Turbine Turbine_IP(efficiency=efficiency_Turb_IP) annotation (Placement(transformation(extent={{-26,42},{-14,62}})));
  ClaRa.StaticCycles.Fittings.Split2 split1(p_nom=tapping_IP_pressure) annotation (Placement(transformation(extent={{-2,38},{8,44}})));
  ClaRa.StaticCycles.Machines.Turbine Turbine_LP1(efficiency=efficiency_Turb_LP1) annotation (Placement(transformation(extent={{20,30},{32,50}})));
  ClaRa.StaticCycles.Fittings.Split1 split2 annotation (Placement(transformation(extent={{40,26},{50,32}})));
  ClaRa.StaticCycles.ValvesConnects.Valve_cutPressure2 valve_IP annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={3,-11})));
  ClaRa.StaticCycles.ValvesConnects.Valve_dp_nom1 valve_LP1(Delta_p_nom=valve_LP1_Delta_p_nom) annotation (Placement(transformation(
        extent={{5,-3},{-5,3}},
        rotation=90,
        origin={45,-11})));
  ClaRa.StaticCycles.Machines.Turbine Turbine_LP2(efficiency=efficiency_Turb_LP2) annotation (Placement(transformation(extent={{60,16},{72,36}})));
  ClaRa.StaticCycles.Triple triple annotation (Placement(transformation(extent={{-40,34},{-28,44}})));
  ClaRa.StaticCycles.Triple triple1 annotation (Placement(transformation(extent={{-8,46},{4,56}})));
  ClaRa.StaticCycles.Triple triple2 annotation (Placement(transformation(extent={{-92,48},{-80,58}})));
  ClaRa.StaticCycles.Triple triple3 annotation (Placement(transformation(extent={{-70,44},{-58,54}})));
  ClaRa.StaticCycles.Triple triple4 annotation (Placement(transformation(extent={{12,22},{24,32}})));
  ClaRa.StaticCycles.Triple triple5 annotation (Placement(transformation(extent={{38,46},{50,56}})));
  ClaRa.StaticCycles.Triple triple6(decimalSpaces(p=2)) annotation (Placement(transformation(extent={{76,24},{88,34}})));
  ClaRa.StaticCycles.Triple triple7 annotation (Placement(transformation(extent={{54,-26},{66,-16}})));
  ClaRa.StaticCycles.Triple triple8 annotation (Placement(transformation(extent={{-38,-40},{-26,-30}})));
  ClaRa.StaticCycles.Triple triple9(decimalSpaces(p=2)) annotation (Placement(transformation(extent={{94,-60},{106,-50}})));
  ClaRa.StaticCycles.Triple triple10 annotation (Placement(transformation(extent={{-34,-80},{-22,-70}})));
  ClaRa.StaticCycles.Triple triple11 annotation (Placement(transformation(extent={{6,-56},{18,-46}})));
  ClaRa.StaticCycles.Triple triple12 annotation (Placement(transformation(extent={{-82,-78},{-70,-68}})));
  ClaRa.StaticCycles.Triple triple13 annotation (Placement(transformation(extent={{-72,-8},{-60,2}})));
  ClaRa.StaticCycles.Triple triple14 annotation (Placement(transformation(extent={{56,-48},{68,-38}})));
  ClaRa.StaticCycles.Triple triple15 annotation (Placement(transformation(extent={{-30,-12},{-18,-2}})));
  ClaRa.StaticCycles.Triple triple16 annotation (Placement(transformation(extent={{-102,-16},{-90,-6}})));
  ClaRa.StaticCycles.Triple triple17 annotation (Placement(transformation(extent={{56,-96},{68,-86}})));
  ClaRa.StaticCycles.Triple triple18 annotation (Placement(transformation(extent={{30,-46},{42,-36}})));
  ClaRa.StaticCycles.Triple triple19 annotation (Placement(transformation(extent={{66,-86},{78,-76}})));
  ClaRa.StaticCycles.Triple triple20 annotation (Placement(transformation(extent={{8,-26},{20,-16}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(condenser.outlet, Pump_cond.inlet) annotation (Line(
      points={{84,-20.5},{84,-60},{80.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Pump_preheater_LP1.inlet, preheater_LP1.tap_out) annotation (Line(
      points={{34.5,-80},{44,-80},{44,-70.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Pump_preheater_LP1.outlet, join_LP_main.inlet_2) annotation (Line(
      points={{13.5,-80},{3,-80},{3,-66.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(join_LP_main.outlet, feedwatertank.cond_in) annotation (Line(
      points={{8.5,-61},{-5.5,-61},{-5.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Pump_FW.inlet, feedwatertank.cond_out) annotation (Line(
      points={{-39.5,-60},{-26.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_HP.cond_in, Pump_FW.outlet) annotation (Line(
      points={{-76,-30.5},{-76,-60},{-60.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Turbine_HP.outlet, join_HP.inlet) annotation (Line(
      points={{-43.5,32},{-28,32},{-28,3},{-39.5,3}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve1_HP.inlet, join_HP.outlet_2) annotation (Line(
      points={{-45,-5.5},{-45,-2.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve1_HP.outlet, preheater_HP.tap_in) annotation (Line(
      points={{-45,-16.5},{-45,-20},{-65.5,-20}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_cut.inlet, join_HP.outlet_1) annotation (Line(
      points={{-57.45,3},{-50.5,3}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve2_HP.inlet, preheater_HP.tap_out) annotation (Line(
      points={{-52.5,-41},{-94,-41},{-94,-20},{-86.5,-20}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split1.inlet, Turbine_IP.outlet) annotation (Line(
      points={{-2.5,43},{-13.5,43},{-13.5,44}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Turbine_LP1.inlet, split1.outlet_1) annotation (Line(
      points={{19.5,44},{20,44},{20,43},{8.5,43}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Turbine_LP1.outlet, split2.inlet) annotation (Line(
      points={{32.5,32},{38,32},{38,31},{39.5,31}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_IP.inlet, split1.outlet_2) annotation (Line(
      points={{3,-5.5},{3,37.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(split2.outlet_2, valve_LP1.inlet) annotation (Line(
      points={{45,25.5},{45,-5.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_LP1.outlet, preheater_LP1.tap_in) annotation (Line(
      points={{45,-16.5},{44,-16.5},{44,-49.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Turbine_LP2.inlet, split2.outlet_1) annotation (Line(
      points={{59.5,30},{50.5,30},{50.5,31}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(Turbine_LP2.outlet, condenser.inlet) annotation (Line(
      points={{72.5,18},{84,18},{84,0.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_LP2.outlet, join_LP_main.inlet_1) annotation (Line(
      points={{13.5,-61},{-2.5,-61}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.cond_out, valve_LP2.inlet) annotation (Line(
      points={{33.5,-60},{24.5,-60},{24.5,-61}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(preheater_LP1.cond_in, Pump_cond.outlet) annotation (Line(
      points={{54.5,-60},{59.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple.steamSignal, Turbine_HP.outlet) annotation (Line(
      points={{-40.375,37.9286},{-42,37.9286},{-42,32},{-43.5,32}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple1.steamSignal, Turbine_IP.outlet) annotation (Line(
      points={{-8.375,49.9286},{-12,49.9286},{-12,44},{-13.5,44}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple4.steamSignal, split1.outlet_2) annotation (Line(
      points={{11.625,25.9286},{10,25.9286},{10,26},{3,26},{3,37.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple5.steamSignal, Turbine_LP1.outlet) annotation (Line(
      points={{37.625,49.9286},{36,49.9286},{36,32},{32.5,32}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple6.steamSignal, Turbine_LP2.outlet) annotation (Line(
      points={{75.625,27.9286},{74,27.9286},{74,18},{72.5,18}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple7.steamSignal, valve_LP1.outlet) annotation (Line(
      points={{53.625,-22.0714},{50,-22.0714},{50,-16.5},{45,-16.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple9.steamSignal, Pump_cond.inlet) annotation (Line(
      points={{93.625,-56.0714},{88,-56.0714},{88,-60},{80.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple10.steamSignal, Pump_FW.inlet) annotation (Line(
      points={{-34.375,-76.0714},{-38,-76.0714},{-38,-60},{-39.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple11.steamSignal, feedwatertank.cond_in) annotation (Line(
      points={{5.625,-52.0714},{-4,-52.0714},{-4,-60},{-5.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple12.steamSignal, Pump_FW.outlet) annotation (Line(
      points={{-82.375,-74.0714},{-72,-74.0714},{-72,-60},{-60.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple13.steamSignal, preheater_HP.cond_out) annotation (Line(
      points={{-72.375,-4.07143},{-74,-4.07143},{-74,-9.5},{-76,-9.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple14.steamSignal, preheater_LP1.tap_in) annotation (Line(
      points={{55.625,-44.0714},{52,-44.0714},{52,-49.5},{44,-49.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple15.steamSignal, join_HP.outlet_2) annotation (Line(
      points={{-30.375,-8.07143},{-38,-8.07143},{-38,-2.5},{-45,-2.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple16.steamSignal, preheater_HP.tap_out) annotation (Line(
      points={{-102.375,-12.0714},{-104,-12.0714},{-104,-20},{-86.5,-20}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple17.steamSignal, preheater_LP1.tap_out) annotation (Line(
      points={{55.625,-92.0714},{52,-92.0714},{52,-92},{44,-92},{44,-70.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple18.steamSignal, preheater_LP1.cond_out) annotation (Line(
      points={{29.625,-42.0714},{29.625,-60},{33.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple19.steamSignal, Pump_cond.outlet) annotation (Line(
      points={{65.625,-82.0714},{64,-82.0714},{64,-82},{59.5,-82},{59.5,-60}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple20.steamSignal, valve_IP.outlet) annotation (Line(
      points={{7.625,-22.0714},{7.625,-19.0357},{3,-19.0357},{3,-16.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve_IP.outlet, feedwatertank.tap_in2) annotation (Line(
      points={{3,-16.5},{3,-28},{-16,-28},{-16,-51.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(valve2_HP.outlet, feedwatertank.tap_in1) annotation (Line(
      points={{-41.5,-41},{-20,-41},{-20,-51.5}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple8.steamSignal, valve2_HP.outlet) annotation (Line(
      points={{-38.375,-36.0714},{-24.1875,-36.0714},{-24.1875,-41},{-41.5,-41}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boiler.hotReheat, triple3.steamSignal) annotation (Line(points={{-70,38.4},{-70,47.9286},{-70.375,47.9286}}, color={0,131,169}));
  connect(Turbine_IP.inlet, boiler.hotReheat) annotation (Line(points={{-26.5,56},{-70,56},{-70,38.4}}, color={0,131,169}));
  connect(boiler.liveSteam, Turbine_HP.inlet) annotation (Line(points={{-76,38.4},{-76,44},{-56.5,44}}, color={0,131,169}));
  connect(valve_cut.outlet, boiler.coldReheat) annotation (Line(points={{-69.55,3},{-72,3},{-72,17.6}}, color={0,131,169}));
  connect(preheater_HP.cond_out, boiler.feedWater) annotation (Line(points={{-76,-9.5},{-76,17.6}}, color={0,131,169}));
  connect(boiler.liveSteam, triple2.steamSignal) annotation (Line(points={{-76,38.4},{-84,38.4},{-84,51.9286},{-92.375,51.9286}}, color={0,131,169}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Ricardo Peniche (peniche@tuhh.de)</span></p>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-102,100},{98,-100}},
          lineColor={0,134,171},
          fillColor={5,130,175},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-92,90},{88,-90}},
          lineColor={0,134,171},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-64,56},{56,-64}},
          lineColor={0,157,255},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          fillColor={7,128,172}),
        Rectangle(
          extent={{-34,28},{26,-32}},
          lineColor={0,134,171},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{36,-70},{88,-90}},
          lineColor={0,134,171},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="name",
          textStyle={TextStyle.Bold})}));
end DetailedSteamPowerPlant_InitCycle;
