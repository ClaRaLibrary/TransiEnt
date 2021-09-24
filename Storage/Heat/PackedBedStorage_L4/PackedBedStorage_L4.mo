within TransiEnt.Storage.Heat.PackedBedStorage_L4;
model PackedBedStorage_L4 "Model for thermal energy storage in packed beds with gaseous heat transfer fluid"


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

    extends TransiEnt.Basics.Icons.PackedBedThermalStorage;


  // _____________________________________________
  //
  //          Internal Model Declaration
  // _____________________________________________


  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.Records.OutlinePackedBedStorage_L4 outline;
    ClaRa.Basics.Records.FlangeGas hotSide;
    ClaRa.Basics.Records.FlangeGas coldSide;
  end Summary;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________



  final parameter SI.Temperature[N_cv] T_start_bed_int = if linearInit then linspace(T_start_hot,T_start_cold,N_cv) else T_start_bed;

  final parameter SI.Power E_flow_nom = m_flow_nom*cp_nom*(T_c - T_d) annotation (Dialog(group="Nominal Values"));
  final parameter SI.HeatCapacityMassSpecific cp_nom = (TILMedia.GasFunctions.specificIsobaricHeatCapacity_pTxi(medium_air,simCenter.p_amb_start,T_c,medium_air.xi_default)+TILMedia.GasFunctions.specificIsobaricHeatCapacity_pTxi(medium_air,simCenter.p_amb_start,T_d,medium_air.xi_default))/2;
  final parameter SI.EnthalpyMassSpecific h_nom = TILMedia.GasFunctions.specificEnthalpy_pTxi(
      medium_air,
      p_nom,
      T_nom,
      medium_air.xi_default) "Nominal enthalpy";

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________



  parameter Boolean linearInit = true "True for linear bed temperature initialisation" annotation (Dialog(tab="Initialisation"));
  parameter SI.Temperature[N_cv] T_start_bed=fill(293.15, N_cv) "Packed Bed Initial Temperature"  annotation (Dialog(tab="Initialisation"));
  parameter SI.Temperature T_start_hot=simCenter.T_amb_start "Hot Side Initial Temperature"  annotation (Dialog(tab="Initialisation"));
  parameter SI.Temperature T_start_cold=simCenter.T_amb_start "Cold Side Initial Temperature"  annotation (Dialog(tab="Initialisation"));
  parameter SI.Pressure p_start_hot = simCenter.p_amb_start "Initial hot side pressure" annotation (Dialog(tab="Initialisation"));
  parameter SI.Pressure p_start_cold = simCenter.p_amb_start "Initial cold side pressure" annotation (Dialog(tab="Initialisation"));
  parameter SI.MassFlowRate m_flow_start = 0 "Initial mass flow rate" annotation (Dialog(tab="Initialisation"));

  parameter SI.Pressure p_nom=simCenter.p_amb_start "Nominal pressure (for nominal pressure loss calculation)" annotation (Dialog(group="Nominal Values"));
  parameter SI.Temperature T_nom=simCenter.T_amb_start "Nominal Temperature (for nominal pressure loss calculation)" annotation (Dialog(group="Nominal Values"));
  parameter SI.MassFlowRate m_flow_nom = 10 "Nominal mass flow rate" annotation (Dialog(group="Nominal Values"));
  parameter SI.Pressure Delta_p_nom_bed = 2e3 "Nominal pressure loss (used for regularization around zero)" annotation (Dialog(group="Nominal Values"));

  parameter SI.Temperature T_ref=273.15 "Reference Temperature (for nominal storage capacity calculation)" annotation (Dialog(group="Nominal Values"));
  parameter SI.Temperature T_c=273.15 + 600 "Nominal Charge Temperature (for nominal storage capacity calculation)" annotation (Dialog(group="Nominal Values"));
  parameter SI.Temperature T_d=273.15 + 20 "Nominal Discharge Temperature (for calculation of nominal rate of charge and discharge)" annotation (Dialog(group="Nominal Values"));
  parameter SI.Temperature T_stop_c=273.15 + 100 "Outlet Temperature to stop charge operation (for usable capacity ratio calculation)" annotation (Dialog(group="Nominal Values"));
  parameter SI.Temperature T_stop_d=273.15 + 520 "Outlet Temperature to stop discharge operation (for usable capacity ratio calculation)" annotation (Dialog(group="Nominal Values"));

  parameter Real d_v_m = 0.03 "Mean volume-equivalent diameter of storage material particles" annotation (Dialog(group="Geometry"));
  parameter Real porosity = 0.4 "Packed-bed porosity" annotation (Dialog(group="Geometry"));
  parameter Real sphericity = 0.8 "Packed-bed mean sphericity (see definition in documentation section)" annotation (Dialog(group="Geometry"));
  parameter SI.Length pipe_thickness = 0.005 "Wall thickness at enclosed air spaces" annotation (Dialog(group="Geometry"));
  parameter Integer N_cv = 10 "Number of finite control volumes in flow direction" annotation (Dialog(group="Geometry"));

  parameter TILMedia.GasTypes.BaseGas medium_air=simCenter.airModel "Medium of heat transfer fluid" annotation (Dialog(group="Fundamental Definitions"),__Dymola_choicesAllMatching=true);




  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________


    outer TransiEnt.SimCenter simCenter;


  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________



  ClaRa.Basics.Interfaces.GasPortIn HotAirPort(Medium=medium_air)    annotation (Placement(transformation(extent={{-160,-10},{-140,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})),HideResult=true);
  ClaRa.Basics.Interfaces.GasPortOut ColdAirPort(Medium=medium_air)    annotation (Placement(transformation(extent={{140,-10},{160,10}}),
        iconTransformation(extent={{90,-10},{110,10}})), HideResult=true);

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________


// Geometry //

   replaceable model PackedBedGeometry =
      TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.PackedBedGeometry.BlockShapedUnit
     constrainedby TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.PackedBedGeometry.PackedBedGeometry_N_cv
     "Packed-bed geometry "                           annotation(choicesAllMatching,Dialog(group="Geometry"));
    replaceable model ColdAirGeometry =
      TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.StorageAirVolumeGeometry.BlockShapedUnit
     constrainedby TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.StorageAirVolumeGeometry.StorageAirVolumeGeometry
      "Geometry of enclosed air space on cold side of storage unit"                                                annotation(choicesAllMatching,Dialog(group="Geometry"));

  replaceable model HotAirGeometry =
      TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.StorageAirVolumeGeometry.BlockShapedUnit
     constrainedby TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.StorageAirVolumeGeometry.StorageAirVolumeGeometry
      "Geometry of enclosed air space on hot side of storage unit"                                                annotation(choicesAllMatching,Dialog(group="Geometry"));

// Media //

  replaceable model medium_rock = TransiEnt.Basics.Media.Solids.Basalt       constrainedby TransiEnt.Basics.Media.Base.BaseSolidWithTemperatureVariantHeatCapacity
                                                         "Solid storage material medium"           annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  replaceable model medium_pipe = TILMedia.SolidTypes.TILMedia_Steel constrainedby TILMedia.SolidTypes.BaseSolid
  "Medium of hot and cold side construction" annotation (Dialog(group="Fundamental Definitions"),__Dymola_choicesAllMatching=true);


// Insulation //
  replaceable model Insulation_bed = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer
                                                                                       constrainedby TransiEnt.Components.Heat.ThermalInsulation.Basics.ThermalInsulation_base
   "Insulation in lateral direction of packed bed"                                                                                                                                           annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
  replaceable model Insulation_hot = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer
                                                                                       constrainedby TransiEnt.Components.Heat.ThermalInsulation.Basics.ThermalInsulation_base
   "Insulation around enclosed space on hot side"                                                                                                                                          annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
  replaceable model Insulation_cold = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer
                                                                                       constrainedby TransiEnt.Components.Heat.ThermalInsulation.Basics.ThermalInsulation_base
   "Insulation around enclosed space on cold side"                                                                                                                                        annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

// Pressure Loss //
  replaceable model PressureLossPB = TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.PackedBedPressureLoss.Ergun
                                                                         constrainedby TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.PackedBedPressureLoss.PressureLossBasePackedBed
    "Packed-bed pressure loss correlation"                                                                                                                                 annotation (choicesAllMatching, Dialog(group="Mass Transfer"));

  replaceable model PressureLossHotAir = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2
  constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseGas_L2
    "Pressure loss correlation for enclosed space on hot side" annotation (choicesAllMatching, Dialog(group="Mass Transfer"));

  replaceable model PressureLossColdAir = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L2
  constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseGas_L2
      "Pressure loss correlation for enclosed space on cold side" annotation (choicesAllMatching, Dialog(group="Mass Transfer"));

// Effective Thermal Conductivity //

  replaceable model ThermalConductivityPB = TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.EffectiveThermalConductivity.Constant
                                                                                                          constrainedby TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.EffectiveThermalConductivity.ThermalConductivityBasePackedBed "Packed-bed effective thermal conductivity correlation" annotation (choicesAllMatching, Dialog(group="Heat Transfer"));

// Heat Transfer //

  replaceable model HeatTransferPB2Wall = TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.HeatTransfer.PackedBedToWall.PB2Wall_Ideal
  constrainedby TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.HeatTransfer.PackedBedToWall.HeatTransferBasePB2Wall "Heat transfer correlation at packed-bed to wall" annotation (choicesAllMatching, Dialog(group="Heat Transfer"));

  replaceable model HeatTransferPB2Air = TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.HeatTransfer.PackedBedToAir.PB2Air_Adiabat
  constrainedby TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.HeatTransfer.PackedBedToAir.HeatTransferBasePB2Air "Heat transfer correlation at packed-bed to air" annotation (choicesAllMatching, Dialog(group="Heat Transfer"));

  replaceable model HeatTransferAir2Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2
  constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas_only "Heat transfer correlation for air in enclosed space to wall" annotation (Dialog(group="Heat Transfer"), choicesAllMatching=true);

  replaceable model HeatTransferAir2PB =     ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2
  constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseGas_only "Heat transfer correlation for air in enclosed space to packed bed"  annotation (Dialog(group="Heat Transfer"), choicesAllMatching=true);

   // Other //

  Summary summary(
    hotSide(
      mediumModel=air_hot.medium,
      m_flow=air_hot.summary.inlet.m_flow,
      T=air_hot.summary.inlet.T,
      p=air_hot.summary.inlet.p,
      h=air_hot.summary.inlet.h,
      xi=air_hot.summary.inlet.xi,
      H_flow=air_hot.summary.inlet.m_flow*air_hot.summary.inlet.h),
    coldSide(
      mediumModel=air_cold.medium,
      m_flow=air_cold.summary.inlet.m_flow,
      T=air_cold.summary.inlet.T,
      p=air_cold.summary.inlet.p,
      h=air_cold.summary.inlet.h,
      xi=air_cold.summary.inlet.xi,
      H_flow=air_cold.summary.inlet.m_flow*air_cold.summary.inlet.h),
    outline(
      N_cv=N_cv,
      length=packedBed.geo.length,
      redeclare model medium_rock = medium_rock,
      T_c=T_c,
      T_d=T_d,
      T_ref=T_ref,
      T_start_bed=T_start_bed_int,
      T_stop_c=T_stop_c,
      T_stop_d=T_stop_d,
      T_bed=packedBed.summary.outline.T,
      T_air_hot=air_hot.summary.outline.T,
      T_air_cold=air_cold.summary.outline.T,
      T_air_bed_hot=packedBed.T_inlet,
      T_air_bed_cold=packedBed.T_outlet,
      E_flow=-air_hot.inlet.m_flow*air_hot.flueGasInlet.h - air_cold.inlet.m_flow*air_cold.flueGasInlet.h,
      E_flow_nom=E_flow_nom,
      Ex_flow=summary.outline.E_flow - simCenter.T_amb*(-air_hot.inlet.m_flow*air_hot.flueGasInlet.s - air_cold.inlet.m_flow*air_cold.flueGasInlet.s),
      Delta_p_hot=air_hot.summary.outline.Delta_p,
      Delta_p_cold=-air_cold.summary.outline.Delta_p,
      Delta_p_bed=packedBed.summary.outline.Delta_p,
      volume_rock=packedBed.geo.volume_rock,
      d=packedBed.rock.d,
      x_abs=packedBed.geo.x_abs,
      volume_tot=packedBed.geo.volume_tot,
      Re=packedBed.summary.outline.Re,
      lambda_eff_ax=packedBed.summary.outline.lambda_eff_ax,
      alpha_PB2Wall=packedBed.summary.outline.alpha_PB2Wall,
      alpha_PB2Air_hot=packedBed.summary.outline.alpha_PB2Air_inlet,
      alpha_PB2Air_cold=packedBed.summary.outline.alpha_PB2Air_outlet,
      Q_flow_loss_PB2hotAir=packedBed.summary.outline.Q_flow_inlet,
      Q_flow_loss_PB2coldAir=packedBed.summary.outline.Q_flow_outlet,
      Q_flow_loss_Iso_hot=insulation_hot.summary.Q_flow_loss,
      Q_flow_loss_Iso_cold=insulation_cold.summary.Q_flow_loss,
      Q_flow_loss_Iso_bed=insulation_bed.summary.Q_flow_loss,
      P_isentropicCompression=air_cold.inlet.m_flow*air_cold.flueGasInlet.cp*air_cold.flueGasInlet.T*(if noEvent(air_cold.flueGasInlet.p > air_hot.flueGasInlet.p + 10) then ((air_cold.flueGasInlet.p/max(1, air_hot.flueGasInlet.p))^(((air_cold.flueGasInlet.cp/air_cold.flueGasInlet.cv) - 1)/(air_cold.flueGasInlet.cp/air_cold.flueGasInlet.cv)) - 1) elseif noEvent(air_hot.flueGasInlet.p > air_cold.flueGasInlet.p + 10) then (-1*((air_hot.flueGasInlet.p/max(1, air_cold.flueGasInlet.p))^(((air_cold.flueGasInlet.cp/air_cold.flueGasInlet.cv) - 1)/(air_cold.flueGasInlet.cp/air_cold.flueGasInlet.cv)) - 1)) else 0))) annotation (Placement(transformation(extent={{-70,-86},{-40,-56}})));

  TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.PackedBedControlVolume_L4 packedBed(
    medium=medium_air,
    redeclare model medium_rock = medium_rock,
    xi_start=medium_air.xi_default,
    xi_nom=packedBed.medium.xi_default,
    m_flow_nom=m_flow_nom,
    p_start=linspace(
        p_start_hot,
        p_start_cold,
        N_cv),
    m_flow_start=ones(N_cv + 1)*m_flow_start,
    redeclare model PressureLoss = PressureLossPB,
    redeclare model HeatTransferPB2Wall = HeatTransferPB2Wall,
    redeclare model ThermalConductivity = ThermalConductivityPB,
    redeclare model Geometry = PackedBedGeometry (final N_cv=N_cv),
    Delta_p_nom=Delta_p_nom_bed,
    redeclare model HeatTransferPB2Air = HeatTransferPB2Air,
    T_start=T_start_bed_int,
    frictionAtInlet=true,
    frictionAtOutlet=true,
    p_nom=ones(N_cv)*p_nom,
    T_nom=ones(N_cv)*T_nom,
    d_v_m=d_v_m,
    porosity=porosity,
    sphericity=sphericity)
                    annotation (Placement(transformation(extent={{-26,-10},{26,10}})));

  Insulation_bed insulation_bed(
    final N_cv=N_cv)
         annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Insulation_hot insulation_hot(
  final N_cv=1)
     annotation (Placement(transformation(extent={{-118,40},{-98,60}})));


  Insulation_cold insulation_cold(
  final N_cv=1)
      annotation (Placement(transformation(extent={{50,40},{70,60}})));

  ClaRa.Basics.ControlVolumes.GasVolumes.VolumeGas_L2_advanced air_hot(
    use2HeatPorts=true,
    h_nom=h_nom,
    xi_start=medium_air.xi_default,
    medium=medium_air,
    m_flow_nom=m_flow_nom,
    T_start=T_start_hot,
    p_start=p_start_hot,
    redeclare model Geometry = HotAirGeometry,
    p_nom=p_nom,
    redeclare model PressureLoss = PressureLossHotAir,
    redeclare model HeatTransferInner = HeatTransferAir2Wall,
    redeclare model HeatTransferOuter = HeatTransferAir2PB)
                                         annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));

  ClaRa.Basics.ControlVolumes.GasVolumes.VolumeGas_L2_advanced air_cold(
    use2HeatPorts=true,
    h_nom=h_nom,
    xi_start=medium_air.xi_default,
    medium=medium_air,
    T_start=T_start_cold,
    p_start=p_start_cold,
    redeclare model PressureLoss = PressureLossColdAir,
    redeclare model Geometry = ColdAirGeometry,
    m_flow_nom=m_flow_nom,
    p_nom=p_nom,
    redeclare model HeatTransferInner = HeatTransferAir2Wall,
    redeclare model HeatTransferOuter = HeatTransferAir2PB)                     annotation (Placement(transformation(extent={{90,-10},{70,10}})));


  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort(equalityMode="Equal Temperatures", N=packedBed.geo.N_cv) annotation (Placement(transformation(extent={{-62,4},{-42,24}})));
  ClaRa.Components.Adapters.Scalar2VectorHeatPort scalar2VectorHeatPort1(equalityMode="Equal Temperatures", N=packedBed.geo.N_cv) annotation (Placement(transformation(extent={{56,6},{36,26}})));

    ClaRa.Basics.ControlVolumes.SolidVolumes.ThinPlateWall_L4 thinPlateWall_L4_1(
    redeclare model Material = medium_pipe,
    thickness_wall=pipe_thickness,
    final length=1,
    final width=air_cold.geo.A_heat[1],
    final T_start={T_start_cold},
    final N_ax=1,
    final stateLocation=2) annotation (Placement(transformation(extent={{70,22},{90,32}})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.ThinPlateWall_L4 thinPlateWall_L4_2(
    redeclare model Material = medium_pipe,
    thickness_wall=pipe_thickness,
    final length=1,
    final width=air_hot.geo.A_heat[1],
    final T_start={T_start_hot},
    final N_ax=1,
    final stateLocation=2) annotation (Placement(transformation(extent={{-90,22},{-70,32}})));


equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________


  connect(HotAirPort, air_hot.inlet) annotation (Line(
      points={{-150,0},{-90,0}},
      color={118,106,98},
      thickness=0.5));
  connect(air_hot.outlet, packedBed.inlet) annotation (Line(
      points={{-70,0},{-26,0}},
      color={118,106,98},
      thickness=0.5));
  connect(air_cold.inlet, ColdAirPort) annotation (Line(
      points={{90,0},{150,0}},
      color={118,106,98},
      thickness=0.5));
  connect(air_cold.outlet, packedBed.outlet) annotation (Line(
      points={{70,0},{26,0}},
      color={118,106,98},
      thickness=0.5));
  connect(insulation_bed.heat, packedBed.heatExternal) annotation (Line(
      points={{-20,50},{0,50},{0,8}},
      color={167,25,48},
      thickness=0.5));
  connect(scalar2VectorHeatPort.heatVector, packedBed.heatInlet) annotation (Line(
      points={{-42,14},{-25.6286,14},{-25.6286,5.6}},
      color={167,25,48},
      thickness=0.5));
  connect(packedBed.heatOutlet, scalar2VectorHeatPort1.heatVector) annotation (Line(
      points={{26,5.2},{26,16},{36,16}},
      color={167,25,48},
      thickness=0.5));
  connect(insulation_cold.heat, thinPlateWall_L4_1.outerPhase) annotation (Line(
      points={{70,50},{80,50},{80,32}},
      color={167,25,48},
      thickness=0.5));
  connect(insulation_hot.heat, thinPlateWall_L4_2.outerPhase) annotation (Line(
      points={{-98,50},{-80,50},{-80,32}},
      color={167,25,48},
      thickness=0.5));
  connect(thinPlateWall_L4_2.innerPhase[1], air_hot.heatOuter) annotation (Line(
      points={{-80,22},{-80,10}},
      color={167,25,48},
      thickness=0.5));
  connect(air_hot.heatInner, scalar2VectorHeatPort.heatScalar) annotation (Line(
      points={{-84.4,10},{-84,10},{-84,14},{-62,14}},
      color={167,25,48},
      thickness=0.5));
  connect(thinPlateWall_L4_1.innerPhase[1], air_cold.heatOuter) annotation (Line(
      points={{80,22},{80,10}},
      color={167,25,48},
      thickness=0.5));
  connect(scalar2VectorHeatPort1.heatScalar, air_cold.heatInner) annotation (Line(
      points={{56,16},{84.4,16},{84.4,10}},
      color={167,25,48},
      thickness=0.5));
  annotation (Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
      Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>The model describes a sensible high-temperature packed-bed thermal energy storage unit. It is composed of the packed-bed, fluid in and outlet spaces, and thermal insulation. Gaseous heat transfer fluid and solid media storage material are generally assumed. It has been validated with air as heat transfer fluid and natural rock as storage material. Main focus is the</p>
<ul>
<li>transient behavior of the temperature field in the packed bed,</li>
<li>fluid pressure loss and</li>
<li>transmission heat losses to the environment.</li>
</ul>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<ul>
<li>The packed bed is discretized in one dimension, which is the main fluid flow direction.</li>
<li>A single energy equation is used for each finite volume, meaning particle and fluid temperature are not distinct, but a mean packed-bed temperature is used. This generally holds for ideal heat transfer between the storage material and heat transfer fluid. Neverthess, the effect of a limited heat transfer between both can be still taken into account by adoption of the effective packed-bed thermal conductivity correlation for example using the approach of Vortmeyer (1974).</li>
<li>An additional body force according to the Darcy-Forchheimer equation is added to the dynamic momentum balance to account for the packed bed flow resistance.</li>
<li>Enclosed fluid volumes on the hot and cold side of the storage unit are included using a single control volume. They can be used to model additional pressure and heat loss at the fluid in- and outflow.</li>
<li>An additional heat port is added between the packed bed and air in and outlet space. It can be used to account for other means of heat transport such as conduction, radiation or natural convection besides the advective energy transport into and out of the packed bed.</li>
<li>The thermal insulation model is replaceable and can therefore consider static or dynamic heat transfer with various heat paths and insulation layers.</li>
<li>A storage material medium model is required, which has an additional state variable for the specific internal energy in order to account for a temperature variant specific heat capacity.</li>
</ul>
<p><br><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<ul>
<li>The one-dimensional spatial representation leads to the plug-flow assumption, meaning no lateral temperature and velocity variations are taken into account</li>
<li>No gravitational force is taken into account in the dynamic momentum balance, as a horizontal air flow direction has been used at all tested plants so far. </li>
<li>Natural convection inside the packed bed is not taken into account</li>
<li>The convective heat transfer between packed bed and insulation depends on the lateral packed bed temperature profile. This profile generally requires a dynamic model for the heat transfer coefficient. Nevertheless, several correlations are implemented, but the user should be aware of this.</li>
<li>The thermal capacity and flow resistance of the grating used to hold the storage material at in and outlet is not taken into account, but added to the packed bed volume</li>
</ul>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<ol>
<li>Hot Air Inlet/Outlet</li>
<li>Cold Air Inlet/Outlet</li>
</ol>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">The heat transfer fluid momentum balance is dynamic to allow very small mass flows without numerical errors</span></li>
<li><span style=\"font-family: MS Shell Dlg 2;\">The mean sphericity describes the ratio of the surface of a set of monodisperse spheres with the same number and overall volume as the particle set to the particles set surface. It thus is not solely depended on the particles shape, but also on the particle size distribution.</span></li>
</ul>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>The model has been validated with two experimental setups of Siemens Gamesa Renewable Energy in Hamburg-Altenwerder (6 MWh_th) and -Bergedorf (130 MWh_th), Germany.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] M. von der Heyde, Abschlussbericht zum Teilprojekt der TUHH im Verbundforschungsprojekt Future Energy Solution (FES), BMWI 03ET6072C, 2021</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[2] M. von der Heyde, Electric Thermal Energy Storage based on Packed Beds for Renewable Energy Integration, Dissertation, Hamburg University of Technology, 2021</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">First Version in 04.2020 for the research project Future Energy Solution (FES) by Michael von der Heyde (heyde@tuhh.de)</span></p>
</html>", revisions="<html>
</html>"));
end PackedBedStorage_L4;
