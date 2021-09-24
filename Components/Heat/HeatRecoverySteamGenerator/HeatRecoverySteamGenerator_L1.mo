within TransiEnt.Components.Heat.HeatRecoverySteamGenerator;
model HeatRecoverySteamGenerator_L1 "Model for heat recovery steam generator (L4 on gas side and L1 on water-steam side)"


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

  import SI = ClaRa.Basics.Units;

  // _____________________________________________
  //
  //          Internal Model Declaration
  // _____________________________________________

   model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Integer N_cv "Number of finite volumes" annotation(Dialog(group="Discretisation"));
    input SI.HeatFlowRate E_flow_air "Enthalpy Flow Difference Air";
    input SI.HeatFlowRate Ex_flow_air "Exergy Part of Enthalpy Flow Difference Air";
    input SI.HeatFlowRate E_flow_steam "Enthalpy Flow Difference Steam";
    input SI.HeatFlowRate Ex_flow_steam "Exergy Part of Enthalpy Flow Difference Steam";
    input SI.HeatFlowRate Q_flow_eco "Transferred Heat in Economizer";
    input SI.HeatFlowRate Q_flow_evap "Transferred Heat in Evaporator";
    input SI.HeatFlowRate Q_flow_sup "Transferred Heat in Superheater";
    input SI.HeatFlowRate Q_flow_tot "Total Transferred Heat";
    input SI.HeatFlowRate Q_flow_loss "Heat flow rate to environment";
    input SI.Power E_flow_loss_blowDown "Loss via Blow Down Flow";
    input SI.Pressure Delta_p "Pressure Drop in pipe";
    input Real BlowDownRate "Blow Down Rate";
    input SI.Temperature[N_cv] T_air "Air Side Temperature";
    input SI.Temperature[N_cv] T_waterSteam "Water/Steam Side Temperature";
   end Outline;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
    ClaRa.Basics.Records.FlangeGas inlet_air;
    ClaRa.Basics.Records.FlangeGas outlet_air;
    ClaRa.Basics.Records.FlangeVLE inlet_water;
    ClaRa.Basics.Records.FlangeVLE outlet_steam;
    ClaRa.Basics.Records.FlangeVLE outlet_blowDown;
  end Summary;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter SI.Length z_in=height "Inlet position from bottom" annotation (Dialog(group="Geometry"));
  final parameter SI.Length z_out=0.1 "Outlet position from bottom" annotation (Dialog(group="Geometry"));
  final parameter Integer N_cv=3 "Number of control volumes" annotation (Dialog(tab="Fundamental Definitions"));

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Boolean useHomotopy=simCenter.useHomotopy "True, if homotopy method is used during initialisation" annotation (Dialog(tab="Initialisation"), choicesAllMatching);

  parameter TILMedia.GasTypes.BaseGas medium1=simCenter.airModel "Medium to be used for gas flow"
    annotation (Dialog(group="Fundamental Definitions"), choicesAllMatching);

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium2=simCenter.fluid1 "Medium for steam side"
                                         annotation(choicesAllMatching=true, Dialog(group="Fundamental Definitions"));

  parameter SI.Time timeConstant_air = 100 "Time constant according to thermal capacity of internal mass" annotation(Dialog(group="Time Response Definition"));

  parameter SI.Temperature T_set_steam = 273.15 + 480 "Steam temperature setpoint" annotation(Dialog(group="Fundamental Definitions"));

  parameter SI.Temperature Delta_T_PP = 10 "Pinch point temperature difference" annotation (Dialog(group="Fundamental Definitions"));
  parameter SI.Temperature Delta_T_AP = 5 "Approach point temperature difference" annotation (Dialog(group="Fundamental Definitions"));
  parameter SI.Temperature Delta_T_hot_min = 30 "Hot side minimum temeprature difference" annotation (Dialog(group="Fundamental Definitions"));

  parameter SI.MassFlowRate m_flow_air_small=1 "Small air mass flow rate (No heat transfer below value)" annotation(Dialog(group="Numerical Stability"));
  parameter SI.HeatFlowRate Q_flow_nom=5e6 "Nominal heat flow rate" annotation(Dialog(group="Fundamental Definitions"));

  parameter SI.MassFlowRate m_flow_water_evap_min=1 "Minimum water mass flow, as required in evaporator pipes" annotation(Dialog(group="Fundamental Definitions"));

  parameter SI.Length length=3 "Length of Steam Generator" annotation (Dialog(group="Geometry", groupImage="modelica://ClaRa/figures/ParameterDialog/HEX_ParameterDialog_BUshellgas2.png"));
  parameter SI.Length height=10 "Height of Steam Generator (gas flow direction)" annotation (Dialog(group="Geometry"));
  parameter SI.Length width=3 "Width of Steam Generator" annotation (Dialog(group="Geometry"));

  parameter SI.Length wall_thickness = 0.005 "wall thickness" annotation (Dialog(group="Geometry"));

  parameter SI.MassFlowRate m_flow_nom=10 "Nominal mass flow " annotation (Dialog(group="Nominal Values"));
  parameter SI.Pressure p_nom = simCenter.p_amb_start "Nominal pressure" annotation (Dialog(group="Nominal Values"));
  parameter SI.Pressure Delta_p_nom=1e3 "Nominal pressure loss" annotation (Dialog(group="Nominal Values"));
  parameter SI.Temperature T_nom= simCenter.T_amb_start "Nominal temperature" annotation (Dialog(group="Nominal Values"));

  parameter SI.Temperature T_start[N_cv]=fill(simCenter.T_amb_start,N_cv) "Start values of gas side temperatures" annotation (Dialog(tab="Initialisation"));
  parameter SI.Pressure p_start[N_cv]=fill(simCenter.p_amb_start, N_cv) "Start values of gas side pressures" annotation (Dialog(tab="Initialisation"));
  parameter SI.MassFraction xi_start[medium1.nc - 1]=medium1.xi_default "Start values of gas side mass fractions" annotation (Dialog(tab="Initialisation"));

  inner parameter Integer initOptionShell=0 "Type of shell initialisation" annotation (Dialog(tab="Initialisation"), choices(
       choice=0 "Use guess values",
       choice=1 "Steady state",
       choice=201 "Steady pressure",
       choice=202 "Steady enthalpy",
       choice=208 "Steady pressure and enthalpy",
       choice=210 "Steady density"));

  parameter Boolean showData=false "True if a data port containing p,T,h,s,m_flow shall be shown, else false" annotation (Dialog(tab="Summary and Visualisation"));
  parameter Boolean showExpertSummary = true "True, if expert summary should be applied"  annotation(Dialog(tab="Summary and Visualisation"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  ClaRa.Basics.Interfaces.GasPortIn gasInlet(Medium=medium1)
    annotation (Placement(transformation(extent={{88,-10},{108,10}}),
        iconTransformation(extent={{88,-10},{108,10}})),HideResult=true);
  ClaRa.Basics.Interfaces.GasPortOut gasOutlet(Medium=medium1)
    annotation (Placement(transformation(extent={{-108,-10},{-88,10}}),
        iconTransformation(extent={{-108,-10},{-88,10}})),HideResult=true);

   ClaRa.Basics.Interfaces.FluidPortIn feedwater(Medium=medium2) annotation (Placement(transformation(extent={{-70,-110},{-50,-90}}), iconTransformation(extent={{-70,-110},{-50,-90}})));
   ClaRa.Basics.Interfaces.FluidPortOut livesteam(Medium=medium2) annotation (Placement(transformation(extent={{50,-110},{70,-90}}), iconTransformation(extent={{50,-110},{70,-90}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable model PressureLoss =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L4
    constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseGas_L4 "Pressure loss model on gas side"  annotation (Dialog(
        group="Mass Transfer"), choicesAllMatching);

  replaceable model HeatTransferExternal =
       ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4
     constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.HeatTransfer_L4 "Heat transfer model gas to inner insulation surface"  annotation (Dialog(
         group="Heat Transfer"), choicesAllMatching);

  replaceable model Insulation = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer
                                                                                       constrainedby TransiEnt.Components.Heat.ThermalInsulation.Basics.ThermalInsulation_base
                                                                                                                                              annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  ClaRa.Basics.ControlVolumes.GasVolumes.VolumeGas_L4_advanced airVolume(
    medium=medium1,
    use2HeatPorts=true,
    m_flow_nom=m_flow_nom,
    useHomotopy=useHomotopy,
    p_start=p_start,
    Delta_p_nom=Delta_p_nom,
    m_flow_start=zeros(N_cv + 1),
    initOption=0,
    xi_start=xi_start,
    T_start=T_start,
    redeclare model PressureLoss = PressureLoss,
    xi_nom=simCenter.airModel.xi_default,
    redeclare model HeatTransferOuter = HeatTransferExternal,
    T_nom=fill(T_nom, N_cv),
    p_nom=fill(p_nom, N_cv),
    redeclare model HeatTransferInner = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
    redeclare model Geometry = TransiEnt.Components.Heat.HeatRecoverySteamGenerator.Basics.HeatRecoverySteamGenerator_N_cv (
        z_in=z_in,
        z_out=z_out,
        N_cv=N_cv,
        height=height,
        width=width,
        length=length)) annotation (Placement(transformation(
        extent={{-14,6},{14,-6}},
        rotation=180,
        origin={0,8.88178e-16})));

  TransiEnt.Components.Heat.PrescribedHeatFlowAdvanced heatExchange(N_axial=N_cv, x={Q_flow_sup,Q_flow_evap,Q_flow_eco}) annotation (Placement(transformation(extent={{-18,32},{-2,48}})));

      Insulation insulation(
    final N_cv=N_cv,
    final length=height,
    final circumference=2*width + 2*length) annotation (Placement(transformation(extent={{56,-38},{36,-22}})));

   TILMedia.Gas_pT air_PP(
    gasType=medium1,
    T=T_PP,
    p=airVolume.summary.inlet.p,
    xi=medium1.xi_default,
    computeTransportProperties=false) "Gas object at outlet port" annotation (Placement(transformation(extent={{-40,60},{-20,80}},   rotation=0)));

  Modelica.Blocks.Sources.RealExpression realExpression2(y=-Q_flow)          annotation (Placement(transformation(extent={{-46,30},{-26,50}})));

public
  Summary summary(
    outline(
      N_cv=N_cv,
      E_flow_air=-(airVolume.inlet.m_flow*airVolume.fluidInlet.h + airVolume.outlet.m_flow*airVolume.fluidOutlet.h),
      Ex_flow_air=summary.outline.E_flow_air - simCenter.T_amb*(-airVolume.inlet.m_flow*airVolume.fluidInlet.s - airVolume.outlet.m_flow*airVolume.fluidOutlet.s),
      E_flow_steam=-(feedwater.m_flow*feedWater.h + livesteam.m_flow*liveSteam.h),
      Ex_flow_steam=summary.outline.E_flow_steam - simCenter.T_amb*(-feedwater.m_flow*feedWater.s - livesteam.m_flow*liveSteam.s),
      Q_flow_eco=Q_flow_eco,
      Q_flow_evap=Q_flow_evap,
      Q_flow_sup=Q_flow_sup,
      Q_flow_tot = Q_flow,
      Q_flow_loss=insulation.summary.Q_flow_loss,
      E_flow_loss_blowDown=m_flow_bd*(h_f - inStream(feedwater.h_outflow)),
      Delta_p=airVolume.fluidInlet.p - airVolume.fluidOutlet.p,
      BlowDownRate=bd,
      T_air=airVolume.T,
      T_waterSteam={T_AP,T_s,T_steam_out}),
    inlet_air(
      mediumModel=medium1,
      m_flow=gasInlet.m_flow,
      T=airVolume.fluidInlet.T,
      p=airVolume.fluidInlet.p,
      h=airVolume.fluidInlet.h,
      xi=airVolume.fluidInlet.xi,
      H_flow=gasInlet.m_flow*airVolume.fluidInlet.h),
    outlet_air(
      mediumModel=medium1,
      m_flow=gasOutlet.m_flow,
      T=airVolume.fluidOutlet.T,
      p=airVolume.fluidOutlet.p,
      h=airVolume.fluidOutlet.h,
      xi=airVolume.fluidOutlet.xi,
      H_flow=gasOutlet.m_flow*airVolume.fluidOutlet.h),
    inlet_water(
      showExpertSummary=showExpertSummary,
      m_flow=feedwater.m_flow,
      T=feedWater.T,
      p=feedWater.p,
      h=feedWater.h,
      s=feedWater.s,
      steamQuality=feedWater.q,
      H_flow=feedwater.m_flow*feedWater.h,
      rho=feedWater.d),
    outlet_steam(
      showExpertSummary=showExpertSummary,
      m_flow=livesteam.m_flow,
      T=liveSteam.T,
      p=liveSteam.p,
      h=liveSteam.h,
      s=liveSteam.s,
      steamQuality=liveSteam.q,
      H_flow=livesteam.m_flow*liveSteam.h,
      rho=liveSteam.d),
    outlet_blowDown(
      showExpertSummary=showExpertSummary,
      m_flow=-m_flow_bd,
      T=water_blowDown.T,
      p=liveSteam.p,
      h=h_f,
      s=water_blowDown.s,
      steamQuality=water_blowDown.q,
      H_flow=-m_flow_bd*h_f,
      rho=liveSteam.d)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-90})));

   TILMedia.VLEFluid_ph       liveSteam(vleFluidType =    medium2,   h = livesteam.h_outflow,                  p=livesteam.p)
    annotation (Placement(transformation(extent={{50,-80},{70,-60}})));

   TILMedia.VLEFluid_ph       feedWater(vleFluidType =    medium2,  h = feedwater.h_outflow,         p=feedwater.p)
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

   TILMedia.VLEFluid_pT steam_out(
    vleFluidType=medium2,
    T=T_steam_out,
    p=livesteam.p) annotation (Placement(transformation(extent={{26,-80},{46,-60}})));

   TILMedia.VLEFluid_pT water_AP(
    vleFluidType=medium2,
    T=T_AP,
    p=livesteam.p) annotation (Placement(transformation(extent={{0,-80},{20,-60}})));

   TILMedia.VLEFluid_ph water_blowDown(
    vleFluidType=medium2,
    h=h_f,
    p=livesteam.p) annotation (Placement(transformation(extent={{-30,-80},{-10,-60}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinPlateWall_L4 wall(
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    thickness_wall=wall_thickness,
    length=height,
    T_start=T_start,
    N_ax=N_cv,
    width=(2*width + 2*length),
    Delta_x=ClaRa.Basics.Functions.GenerateGrid({0}, height, N_cv)) annotation (Placement(transformation(extent={{-30,-14},{-10,-24}})));

  Modelica.Blocks.Continuous.FirstOrder airDynamics(
    T=timeConstant_air,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0) annotation (Placement(transformation(extent={{60,60},{80,80}})));


  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.Temperature T_steam_out "Steam Outlet Temperature";
  SI.Temperature T_AP "Aproach Point Temperature";
  SI.Temperature T_PP "Pinch Point Temperature";
  SI.Temperature T_s(start = TILMedia.VLEFluidFunctions.bubbleTemperature_pxi(medium2,67e5,medium2.xi_default)) "Saturation temperature";

  SI.EnthalpyMassSpecific h_air_out_min "Minimum air outlet enthalpy (if cooled to feedwater temperature)";
  SI.EnthalpyMassSpecific h_s "steam enthalpy at evaporator outlet";
  SI.EnthalpyMassSpecific h_f "water enthalpy at evaporator outlet";

  Real bd "Blow Down Rate";

  SI.Temperature T_steam_out_max "Max steam outlet temperature";

  SI.HeatFlowRate Q_flow_avail_evapAndSup(final start = 0) "Available Heat Flow Rate in evaporator and superheater";
  SI.HeatFlowRate Q_flow_avail_eco(final start = 0) "Available Heat Flow Rate in economizer";
  SI.MassFlowRate m_flow_max_evap "maximum water/steam mass flow according to available heat flow rate in evaporator";
  SI.MassFlowRate m_flow_max_eco "maximum water/steam mass flow according to available heat flow rate in economizer";

  SI.MassFlowRate m_flow_steam "actual water/steam mass flow";
  SI.MassFlowRate m_flow_nobd "water/steam mass flow without required blow down flow";
  SI.MassFlowRate m_flow_bd "blow down water mass flow";

  SI.MassFlowRate m_flow_air "air/gas mass flow";

  SI.HeatFlowRate Q_flow_eco "Actual transferred heat flow rate in economizer";
  SI.HeatFlowRate Q_flow_evap "Actual transferred heat flow rate in evaporator";
  SI.HeatFlowRate Q_flow_sup "Actual transferred heat flow rate in superheater";
  SI.HeatFlowRate Q_flow(final start = 0) "Actual transferred overall heat flow rate";

  SI.Power P_check_overall "Residuum power for verification purpose";
  SI.Power P_check_airSide "Residuum power for verification purpose";
  SI.Energy E_check_airSide "Residuum energy for verification purpose";
  SI.Energy E_check_overall "Residuum energy for verification purpose";

equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //Temperatures
  T_s = TILMedia.VLEFluidFunctions.bubbleTemperature_pxi(medium2,livesteam.p,medium2.xi_default);
  T_PP = T_s + Delta_T_PP; //Pinch-Point Temperature
  T_AP = T_s - Delta_T_AP; //Approach Temperature
  T_steam_out_max = airVolume.summary.inlet.T - Delta_T_hot_min; // max allowed steam outlet temperature
  T_steam_out = max(T_s + 5,min(T_steam_out_max,T_set_steam)); //Steam outlet Temperature, ideally controlled by feedwater massflow

  //Enthalpy
  h_air_out_min = TILMedia.GasFunctions.specificEnthalpy_pTxi(medium1,simCenter.p_amb_start,feedWater.T,medium1.xi_default);
  h_f = TILMedia.VLEFluidFunctions.liquidSpecificEnthalpy_pTxi(medium2,livesteam.p,T_s,medium2.xi_default);
  h_s = TILMedia.VLEFluidFunctions.vapourSpecificEnthalpy_pTxi(medium2,livesteam.p,T_s,medium2.xi_default);

  //Avoid problems at low air mass flow
  m_flow_air = ClaRa.Basics.Functions.Stepsmoother(m_flow_air_small,0.9*m_flow_air_small,airVolume.summary.inlet.m_flow)*airVolume.summary.inlet.m_flow;

  // available heat from air
  airDynamics.u = max(0,m_flow_air*(airVolume.summary.inlet.h  - air_PP.h));
  Q_flow_avail_evapAndSup =airDynamics.y;

  Q_flow_avail_eco = max(0,m_flow_air*(airVolume.h[2]  - h_air_out_min));

  // produced steam mass flow
  m_flow_nobd  = Q_flow_avail_evapAndSup/(steam_out.h - water_AP.h);

  // Blowdown rate
  bd = max(0,(m_flow_water_evap_min-m_flow_nobd)/max(0.1*m_flow_water_evap_min,m_flow_nobd));

  // produced steam mass flow
  m_flow_max_evap = Q_flow_avail_evapAndSup/(((steam_out.h - water_AP.h)+bd*(h_f - water_AP.h))); //ganapathy, page 207
  m_flow_max_eco  = Q_flow_avail_eco/((1+bd)*(water_AP.h - inStream(feedwater.h_outflow)));
  m_flow_steam = max(0,min(m_flow_max_evap,m_flow_max_eco));

  // blow down flow
  m_flow_bd = bd*m_flow_steam;

  // Transferred Heat
  Q_flow_eco = m_flow_steam*(1+bd)*(water_AP.h - inStream(feedwater.h_outflow));
  Q_flow_evap = m_flow_steam*((h_s - water_AP.h) + bd*(h_f - water_AP.h));
  Q_flow_sup = m_flow_steam*(steam_out.h - h_s);

  // Overall transferred heat
  Q_flow = Q_flow_eco+Q_flow_evap+Q_flow_sup;



  // steam oulet state
  livesteam.h_outflow = steam_out.h;
  livesteam.m_flow = -m_flow_steam;

  // mass balance
  feedwater.m_flow = (1+bd)*m_flow_steam;

  // backflow
  feedwater.h_outflow = inStream(feedwater.h_outflow);

  // check energy balance
  P_check_overall = summary.inlet_air.H_flow + summary.outlet_air.H_flow + summary.outlet_steam.H_flow + summary.inlet_water.H_flow - summary.outline.Q_flow_loss + summary.outlet_blowDown.H_flow;
  P_check_airSide = summary.outlet_steam.H_flow + summary.inlet_water.H_flow  - summary.outline.E_flow_loss_blowDown + Q_flow;
  der(E_check_airSide) = P_check_airSide;
  der(E_check_overall) = P_check_overall;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(airVolume.outlet,gasOutlet)  annotation (Line(
      points={{-14,8.88178e-16},{-44,8.88178e-16},{-44,0},{-98,0}},
      color={118,106,98},
      thickness=0.5));
  connect(airVolume.inlet,gasInlet)  annotation (Line(
      points={{14,-2.22045e-15},{14,0},{98,0}},
      color={118,106,98},
      thickness=0.5));

  connect(realExpression2.y, heatExchange.Q_flow) annotation (Line(points={{-25,40},{-18,40}}, color={0,0,127}));
  connect(wall.outerPhase, insulation.heat) annotation (Line(
      points={{-20,-24},{-20,-30},{36,-30}},
      color={167,25,48},
      thickness=0.5));
  connect(heatExchange.port, airVolume.heatInner) annotation (Line(
      points={{-2,40},{8,40},{8,4.8}},
      color={167,25,48},
      thickness=0.5));
  connect(airVolume.heatOuter, wall.innerPhase) annotation (Line(
      points={{0,4.8},{0,12},{-20,12},{-20,-14}},
      color={167,25,48},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                   Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
                                        Line(
          points={{-60,-100},{-60,60},{0,0},{60,60},{60,-100}},
          color={0,0,0},
          thickness=0.5)}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Model for heat recovery steam generator based on pinch point analysis.</p>
<p>The model has been developed to account for the load dependend effect of the water-steam side on the gas outlet temperature without the necessity to use dynamic balance equations for the water/steam side.</p>
<p>It is thus a compromise of numerical robustness and calucations speed as well as physical insight.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<ul>
<li>The outlet temperatures of air and steam are determined from pinch-point analysis. </li>
<li>No detailled design information, such as surface areas have to be known.</li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Air side outlet temperature dynamics is artificially corrected with PT1, according to thermal energy storage in internal steel mass.</span></li>
</ul>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">This model is only valid for once through/benson type heat recovery steam generator with a single pressure level. For these, the pinch point is at the evaporator outlet (in gas flow direction).</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">The air flow direction is assumed as vertical.</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">A constant pinch point and approach point temperature difference is used.</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">At very low loads, such as during start up and cool down, a minimum water flow rate is assured in the evaporator by means of a blow down flow. </span></li>
</ul>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<ol>
<li>Air Inlet</li>
<li>Air Outlet</li>
<li>Water inlet</li>
<li>Steam Outlet</li>
</ol>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The air temperature at the pinch point is determined from the water saturation temperature at the steam outlet pressure, as set by steam turbine or bypass.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The heat available from the gas flow upstream of this point is used for steam generation and superheating and determines the steam and feedwater massflow. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model has been validated with the heat recovery steam generator of the Electric Thermal Energy Storage demonstration plant of Siemens Gamesa Renewable Energy in Hamburg-Bergedorf, Germany.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] V.L. Eriksen (Ed.), Heat recovery steam generator technology, Woodhead Publishing, an imprint of Elsevier, Duxford, United Kingdom, 2017.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[2] V. Ganapathy, Waste heat boiler deskbook, Fairmont Press, Lilburn, GA, 1991.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[3] M. von der Heyde, Abschlussbericht zum Teilprojekt der TUHH im Verbundforschungsprojekt Future Energy Solution (FES), BMWI 03ET6072C, 2021</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[4] M. von der Heyde, Electric Thermal Energy Storage based on Packed Beds for Renewable Energy Integration, Dissertation, Hamburg University of Technology, 2021</span></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">First Version in 04.2020 for the research project Future Energy Solution (FES) by Michael von der Heyde (heyde@tuhh.de)</span></p>
</html>"));
end HeatRecoverySteamGenerator_L1;
