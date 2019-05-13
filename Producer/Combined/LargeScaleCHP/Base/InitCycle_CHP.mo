within TransiEnt.Producer.Combined.LargeScaleCHP.Base;
model InitCycle_CHP
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  import TILMedia.VLEFluidFunctions.*;
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
  //parameter Modelica.SIunits.Power  P_nom;
  inner parameter SI.MassFlowRate   m_flow_nom=112.8;
  inner parameter Real P_target_=1;
  // Heat Exchangers
  parameter SI.Pressure p_condenser=0.017e5 annotation(Dialog(tab="Heat exchangers",group="Condenser"));
  parameter SI.Pressure p_A4_nom=1.81e5;
  parameter SI.Pressure p_A5_nom=4.272e5;
  parameter SI.MassFlowRate A4_m_flow_nom=45.3407;
  parameter SI.MassFlowRate A5_m_flow_nom=47.013;
  // Valves

  // Boiler
  parameter SI.Temperature T_LS_nom=535+273.15  annotation(Dialog(tab="Boiler"));
  parameter SI.Temperature T_RS_nom=534.9+273.15  annotation(Dialog(tab="Boiler"));
  parameter SI.Pressure p_LS_out_nom=120e5 annotation(Dialog(tab="Boiler"));
  parameter SI.Pressure p_RS_out_nom=37.46e5 annotation(Dialog(tab="Boiler"));

  parameter SI.PressureDifference Delta_p_LS_nom=218.482e5 - 184.864e5 annotation(Dialog(tab="Boiler"));
  parameter SI.PressureDifference Delta_p_RS_nom=37.75e5 - 37.46e5 annotation(Dialog(tab="Boiler"));
  parameter Real CharLine_Delta_p_HP_mLS_[:,:]=[0,0; 0.1,0.01; 0.2,0.04; 0.3,0.09; 0.4,
      0.16; 0.5,0.25; 0.6,0.36; 0.7,0.49; 0.8,0.64; 0.9,0.81; 1,1] "Characteristic line of pressure drop as function of mass flow rate"
                                                                         annotation(Dialog(tab="Boiler"));
  parameter Real CharLine_Delta_p_IP_mRS_[:,:]=[0,0; 0.1,0.01; 0.2,0.04; 0.3,0.09; 0.4,
      0.16; 0.5,0.25; 0.6,0.36; 0.7,0.49; 0.8,0.64; 0.9,0.81; 1,1] "Characteristic line of pressure drop as function of mass flow rate"
                                                                         annotation(Dialog(tab="Boiler"));
  // Turbines
  parameter SI.Pressure tapping_IP_pressure=15e5  annotation(Dialog(tab="Turbines"));
  parameter Real efficiency_Turb_HP=1 annotation(Dialog(tab="Turbines"));
  parameter Real efficiency_Turb_IP=1 annotation(Dialog(tab="Turbines"));
  parameter Real efficiency_Turb_LP=1 annotation(Dialog(tab="Turbines"));
  parameter Real efficiency_Turb_IP2=1 annotation(Dialog(tab="Turbines"));
  parameter Real efficiency_Turb_mech=1 annotation(Dialog(tab="Turbines"));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  ClaRa.StaticCycles.HeatExchanger.Condenser condenser(p_condenser=p_condenser) annotation (Placement(transformation(extent={{82,-16},{102,4}})));
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
    m_flow_RS_nom=m_flow_nom)                          annotation (Placement(transformation(extent={{-88,14},{-68,34}})));
  ClaRa.StaticCycles.Machines.Turbine Turbine_HP(efficiency=efficiency_Turb_HP) annotation (Placement(transformation(extent={{-58,26},{-46,46}})));
  ClaRa.StaticCycles.Machines.Turbine Turbine_IP(efficiency=efficiency_Turb_IP) annotation (Placement(transformation(extent={{-34,38},{-22,58}})));
  ClaRa.StaticCycles.Machines.Turbine Turbine_IP2(efficiency=efficiency_Turb_IP2) annotation (Placement(transformation(extent={{18,26},{30,46}})));
  ClaRa.StaticCycles.Triple triple annotation (Placement(transformation(extent={{-42,30},{-30,40}})));
  ClaRa.StaticCycles.Triple triple2 annotation (Placement(transformation(extent={{-94,44},{-82,54}})));
  ClaRa.StaticCycles.Triple triple3 annotation (Placement(transformation(extent={{-72,40},{-60,50}})));
  ClaRa.StaticCycles.Triple triple5 annotation (Placement(transformation(extent={{36,42},{48,52}})));
  ClaRa.StaticCycles.Machines.Turbine Turbine_LP(efficiency=efficiency_Turb_LP) annotation (Placement(transformation(extent={{78,16},{90,36}})));
  ClaRa.StaticCycles.Boundaries.Sink_green sink_green2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,-50})));
  ClaRa.StaticCycles.Boundaries.Source_blue source_steamGenerator(m_flow=m_flow_nom, h=1365e3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-78,-20})));
  SI.Power P_el_max;
  SI.Power Q_max;
  ClaRa.StaticCycles.HeatExchanger.Condenser A5(p_condenser=p_A5_nom)    annotation (Placement(transformation(extent={{-14,2},{6,22}})));
  ClaRa.StaticCycles.Boundaries.Sink_green sink_green4
                                                      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-2,-24})));
  ClaRa.StaticCycles.Fittings.Split3 split3_1(splitRatio=(m_flow_nom - A5_m_flow_nom)/m_flow_nom)
                                              annotation (Placement(transformation(extent={{-8,34},{2,40}})));
  ClaRa.StaticCycles.HeatExchanger.Condenser A4(p_condenser=p_A4_nom)    annotation (Placement(transformation(extent={{44,-4},{64,16}})));
  ClaRa.StaticCycles.Boundaries.Sink_green sink_green5 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={56,-30})));
  ClaRa.StaticCycles.Fittings.Split3 split3_2(splitRatio=(m_flow_nom - A5_m_flow_nom - A4_m_flow_nom)/m_flow_nom)
                                              annotation (Placement(transformation(extent={{50,24},{60,30}})));
equation
  P_el_max=Turbine_HP.m_flow*(efficiency_Turb_HP*efficiency_Turb_mech*(Turbine_HP.h_out-Turbine_HP.h_in)+efficiency_Turb_IP*efficiency_Turb_mech*(Turbine_IP.h_out-Turbine_IP.h_in)+efficiency_Turb_IP2*efficiency_Turb_mech*(Turbine_IP2.h_out-Turbine_IP2.h_in)+efficiency_Turb_LP*efficiency_Turb_mech*(Turbine_LP.h_out-Turbine_LP.h_in));
  Q_max=A5.m_flow_in*(A5.h_out-A5.h_in)+A4.m_flow_in*(A4.h_out-A4.h_in);
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(triple.steamSignal,Turbine_HP. outlet) annotation (Line(
      points={{-42.375,33.9286},{-44,33.9286},{-44,28},{-45.5,28}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(triple5.steamSignal,Turbine_IP2. outlet) annotation (Line(
      points={{35.625,45.9286},{34,45.9286},{34,28},{30.5,28}},
      color={0,131,169},
      smooth=Smooth.None));
  connect(boiler.hotReheat,triple3. steamSignal) annotation (Line(points={{-72,34.4},{-72,43.9286},{-72.375,43.9286}}, color={0,131,169}));
  connect(Turbine_IP.inlet,boiler. hotReheat) annotation (Line(points={{-34.5,52},{-72,52},{-72,34.4}}, color={0,131,169}));
  connect(boiler.liveSteam,Turbine_HP. inlet) annotation (Line(points={{-78,34.4},{-78,40},{-58.5,40}}, color={0,131,169}));
  connect(boiler.liveSteam,triple2. steamSignal) annotation (Line(points={{-78,34.4},{-86,34.4},{-86,47.9286},{-94.375,47.9286}}, color={0,131,169}));
  connect(Turbine_HP.outlet, boiler.coldReheat) annotation (Line(points={{-45.5,28},{-46,28},{-46,16},{-46,-2},{-74,-2},{-74,13.6}}, color={0,131,169}));
  connect(condenser.inlet, Turbine_LP.outlet) annotation (Line(points={{92,4.5},{92,4.5},{92,18},{90.5,18}},   color={0,131,169}));
  connect(condenser.outlet, sink_green2.inlet) annotation (Line(points={{92,-16.5},{92,-39.5},{90,-39.5}},
                                                                                                         color={0,131,169}));
  connect(source_steamGenerator.outlet, boiler.feedWater) annotation (Line(points={{-78,-9.5},{-78,13.6}},color={0,131,169}));
  connect(A5.outlet, sink_green4.inlet) annotation (Line(points={{-4,1.5},{-4,-8},{-4,-13.5},{-2,-13.5}}, color={0,131,169}));
  connect(A5.inlet, split3_1.outlet_2) annotation (Line(points={{-4,22.5},{-4,22.5},{-4,33.5},{-3,33.5}}, color={0,131,169}));
  connect(split3_1.outlet_1, Turbine_IP2.inlet) annotation (Line(points={{2.5,39},{17.5,39},{17.5,40}}, color={0,131,169}));
  connect(split3_1.inlet, Turbine_IP.outlet) annotation (Line(points={{-8.5,39},{-15.25,39},{-15.25,40},{-21.5,40}}, color={0,131,169}));
  connect(A4.outlet,sink_green5. inlet) annotation (Line(points={{54,-4.5},{54,-19.5},{56,-19.5}},
                                                                                        color={0,131,169}));
  connect(A4.inlet, split3_2.outlet_2) annotation (Line(points={{54,16.5},{54,16.5},{54,23.5},{55,23.5}}, color={0,131,169}));
  connect(Turbine_IP2.outlet, split3_2.inlet) annotation (Line(points={{30.5,28},{49.5,28},{49.5,29}}, color={0,131,169}));
  connect(split3_2.outlet_1, Turbine_LP.inlet) annotation (Line(points={{60.5,29},{69.25,29},{69.25,30},{77.5,30}}, color={0,131,169}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(TODO)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(TODO)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(TODO)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(TODO)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(TODO)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(TODO)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(TODO)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(TODO)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(TODO)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Ricardo Peniche (peniche@tuhh.de)</span></p>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,134,171},
          fillColor={5,130,175},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-90,90},{90,-90}},
          lineColor={0,134,171},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,60},{60,-60}},
          lineColor={0,157,255},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          fillColor={7,128,172}),
        Rectangle(
          extent={{-30,30},{30,-30}},
          lineColor={0,134,171},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{42,-70},{94,-90}},
          lineColor={0,134,171},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="name",
          textStyle={TextStyle.Bold})}));
end InitCycle_CHP;
