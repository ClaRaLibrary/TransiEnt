within TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics;
model PackedBedControlVolume_L4 "An array of packed bed cells with a single energy equation for particles and fluid and heat connector at in- and outlet"



//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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

  extends ClaRa.Basics.Icons.Volume_L4;

  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L4");

  import SI = ClaRa.Basics.Units;

  import Modelica.Constants.eps;


  // _____________________________________________
  //
  //          Internal Model Declaration
  // _____________________________________________


    inner model Summary

    extends ClaRa.Basics.Icons.RecordIcon;

    TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.Records.OutlinePackedBedControlVolume_L4 outline;

    ClaRa.Basics.Records.FlangeGas inlet;

    ClaRa.Basics.Records.FlangeGas outlet;

    end Summary;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

    final parameter SI.DensityMassSpecific rho_nom[geo.N_cv]=TILMedia.GasFunctions.density_pTxi(
      medium,
      p_nom,
      T_nom,
      xi_nom) "Nominal density";

protected
  parameter SI.Pressure p_start_internal[geo.N_cv]=if size(p_start, 1) == 2 then linspace(
      p_start[1],
      p_start[2],
      geo.N_cv) else p_start "Internal p_start array which allows the user to either state p_inlet, p_outlet if p_start has length 2, otherwise the user can specify an individual pressure profile for initialisation";

  parameter SI.Temperature T_start_internal[geo.N_cv]=if size(T_start, 1) == 2 then linspace(
      T_start[1],
      T_start[2],
      geo.N_cv) else T_start "Internal T_start array which allows the user to either state T_inlet, T_outlet if T_start has length 2, otherwise the user can specify an individual Temperature profile for initialisation";

  parameter SI.EnthalpyMassSpecific h_start[geo.N_cv]=TILMedia.GasFunctions.specificEnthalpy_pTxi(
      medium,
      p_start_internal,
      T_start_internal,
      xi_start) "Initial specific enthalpy";

  parameter SI.DensityMassSpecific d_start[geo.N_cv]=TILMedia.GasFunctions.density_pTxi(
      medium,
      p_start_internal,
      T_start_internal,
      xi_start) "Initial density";


  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  // Media //



public
  inner parameter TILMedia.GasTypes.BaseGas medium=simCenter.airModel "Medium of heat transfer fluid" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  // Pressure Loss //


  inner parameter Boolean frictionAtInlet=false "True if pressure loss between first cell and inlet shall be considered" annotation (choices(checkBox=true), Dialog(group="Fundamental Definitions"));

  inner parameter Boolean frictionAtOutlet=false "True if pressure loss between last cell and outlet shall be considered" annotation (choices(checkBox=true), Dialog(group="Fundamental Definitions"));

  // Nominal Values //

  parameter SI.Pressure p_nom[geo.N_cv]=1e5*ones(geo.N_cv) "Nominal pressure" annotation (Dialog(group="Nominal Values"));

  parameter SI.Temperature T_nom[geo.N_cv]=293.15*ones(geo.N_cv) "Nominal temperature" annotation (Dialog(group="Nominal Values"));

  parameter SI.MassFraction xi_nom[medium.nc - 1]={0.01,0,0.1,0,0.74,0.13,0,0.02,0} "Nominal gas composition" annotation (Dialog(group="Nominal Values"));

  inner parameter SI.MassFlowRate m_flow_nom=100 "Nominal mass flow" annotation (Dialog(group="Nominal Values"));

  inner parameter SI.Pressure Delta_p_nom=1e4 "Nominal pressure loss" annotation (Dialog(group="Nominal Values"));


  // Initialisation //

  inner parameter Integer initOption=0 "Type of initialisation" annotation (Dialog(tab="Initialisation"), choices(
      choice=0 "Use guess values",
      choice=1 "Steady states",
      choice=201 "Steady pressure",
      choice=202 "Steady enthalpy",
      choice=202 "Steady temperature",
      choice=208 "Steady pressure and enthalpy"));

  inner parameter Boolean useHomotopy=simCenter.useHomotopy "true, if homotopy method is used during initialisation" annotation (Dialog(tab="Initialisation", group="Model Settings"));

  parameter SI.Temperature T_start[:]=293.15*ones(geo.N_cv) "Initial temperature " annotation (Dialog(tab="Initialisation"));

  parameter SI.Pressure p_start[:]=1e5*ones(geo.N_cv) "Initial pressure" annotation (Dialog(tab="Initialisation"));

  parameter SI.MassFlowRate m_flow_start[geo.N_cv + 1]=ones(geo.N_cv + 1)*10 "Initial mass flow rate" annotation (Dialog(tab="Initialisation"));

  parameter SI.MassFraction xi_start[medium.nc - 1]={0.01,0,0.1,0,0.74,0.13,0,0.02,0} "Initial gas composition" annotation (Dialog(tab="Initialisation"));


  // Packed Bed //

  inner parameter Real d_v_m=0.02 "Mean Volume Equivalent Diameter" annotation (Dialog(group="Geometry"));

  inner parameter Real porosity=0.4 "Porosity" annotation (Dialog(group="Geometry"));

  inner parameter Real sphericity=0.8 "Sphericity" annotation (Dialog(group="Geometry"));



  parameter Boolean showData=false "|Summary and Visualisation||True, if a data port containing p,T,h,s,m_flow shall be shown, else false" annotation (choices(checkBox=true), Dialog(group="Fundamental Definitions"));


  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________


  outer ClaRa.SimCenter simCenter;


  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

public
  ClaRa.Basics.Interfaces.GasPortIn inlet(Medium=medium) "Inlet port" annotation (Placement(transformation(extent={{-150,-10},{-130,10}}), iconTransformation(extent={{-150,-10},{-130,10}})));

  ClaRa.Basics.Interfaces.GasPortOut outlet(Medium=medium) "Outlet port" annotation (Placement(transformation(extent={{130,-10},{150,10}}), iconTransformation(extent={{130,-10},{150,10}})));


  ClaRa.Basics.Interfaces.HeatPort_a heatExternal[geo.N_cv] annotation (Placement(transformation(extent={{-10,40},{10,60}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,40})));

  ClaRa.Basics.Interfaces.HeatPort_a heatInlet[geo.N_cv] annotation (Placement(transformation(extent={{-148,18},{-128,38}})));

  ClaRa.Basics.Interfaces.HeatPort_a heatOutlet[geo.N_cv] annotation (Placement(transformation(extent={{130,16},{150,36}})));




  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________


  replaceable model medium_rock = TransiEnt.Basics.Media.Solids.Basalt       constrainedby TransiEnt.Basics.Media.Base.BaseSolidWithTemperatureVariantHeatCapacity
                                                         "Medium of storage material"           annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));

  replaceable model PressureLoss = TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.PackedBedPressureLoss.Ergun
                                                                         constrainedby TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.PackedBedPressureLoss.PressureLossBasePackedBed
                    "Correlation for packed-bed pressure loss"                                                                                                                  annotation (choicesAllMatching, Dialog(group="Mass Transfer"));
  replaceable model HeatTransferPB2Wall = TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.HeatTransfer.PackedBedToWall.PB2Wall_Ideal
  constrainedby TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.HeatTransfer.PackedBedToWall.HeatTransferBasePB2Wall
  "Correlation for heat transfer from packed bed to wall" annotation (choicesAllMatching, Dialog(group="Heat Transfer"));
  replaceable model HeatTransferPB2Air = TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.HeatTransfer.PackedBedToAir.PB2Air_Adiabat
  constrainedby TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.HeatTransfer.PackedBedToAir.HeatTransferBasePB2Air
  "Correlation for heat transfer from packed bed to air" annotation (choicesAllMatching, Dialog(group="Heat Transfer"));

  replaceable model ThermalConductivity = TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.EffectiveThermalConductivity.Constant
  constrainedby TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.EffectiveThermalConductivity.ThermalConductivityBasePackedBed
  "Correlation for packed bed effeective thermal conductivity "
                                                               annotation (choicesAllMatching, Dialog(group="Heat Transfer"));


  replaceable model Geometry = TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.PackedBedGeometry.BlockShapedUnit
                                                                          constrainedby TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.PackedBedGeometry.PackedBedGeometry_N_cv
                                                                                                                                                                          "Geometry" annotation (choicesAllMatching, Dialog(group="Geometry"));


  // Instantiation of Replaceable Models //

protected
  inner TILMedia.Gas_pT fluid[geo.N_cv](
    p=p,
    T=T,
    xi=xi,
    each gasType=medium,
    each computeTransportProperties=true) annotation (Placement(transformation(extent={{-10,-30},{10,-10}}, rotation=0)));

public
    inner TransiEnt.Basics.Media.SolidWithTemperatureVariantHeatCapacity rock[geo.N_cv](redeclare each model SolidType =
        medium_rock,                                                                T=T) annotation (Placement(transformation(extent={{16,-28},{36,-8}})));

  PressureLoss pressureLoss "Pressure loss model" annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  HeatTransferPB2Wall heatTransferExternal(final A_heat=geo.A_heat) "External heat transfer model" annotation (Placement(transformation(extent={{-42,0},{-22,20}})));

  HeatTransferPB2Air heatTransferOutlet(final inlet=false) "heat transfer model for hot side" annotation (Placement(transformation(extent={{80,0},{100,20}})));

  HeatTransferPB2Air heatTransferInlet(final inlet=true) "heat transfer model for cold side" annotation (Placement(transformation(extent={{-110,0},{-90,20}})));

  ThermalConductivity thermalConductivity "Thermal Conductivity model" annotation (Placement(transformation(extent={{-74,0},{-54,20}})));

public
  inner TILMedia.Gas_pT fluidInlet(
    p=inlet.p,
    T=T_inlet,
    xi=xi_inlet,
    gasType=medium,
    computeTransportProperties=true) "Gas object at inlet port" annotation (Placement(transformation(extent={{-130,-30},{-110,-10}}, rotation=0)));

  inner TILMedia.Gas_pT fluidOutlet(
    gasType=medium,
    T=T_outlet,
    p=outlet.p,
    xi=xi_outlet,
    computeTransportProperties=true) "Gas object at outlet port" annotation (Placement(transformation(extent={{110,-30},{130,-10}}, rotation=0)));

  inner Summary summary(
    outline(
      N_cv=geo.N_cv,
      volume_tot=sum(geo.volume_bed),
      Delta_p=inlet.p - outlet.p,
      mass_air_tot=sum(mass_air),
      H_tot=sum(h .* mass_air),
      T = T,
      Q_flow_wall=sum(heatExternal.Q_flow),
      Q_flow_inlet=sum(heatInlet.Q_flow),
      Q_flow_outlet=sum(heatOutlet.Q_flow),
      m_flow=m_flow,
      Re = pressureLoss.Re,
      lambda_eff_ax = thermalConductivity.lambda_eff_axial,
      alpha_PB2Wall = heatTransferExternal.alpha,
      alpha_PB2Air_inlet = heatTransferInlet.alpha,
      alpha_PB2Air_outlet = heatTransferOutlet.alpha),
    inlet(
      mediumModel=medium,
      m_flow=inlet.m_flow,
      T=fluidInlet.T,
      p=inlet.p,
      h=fluidInlet.h,
      xi=fluidInlet.xi,
      H_flow=inlet.m_flow*fluidInlet.h),
    outlet(
      mediumModel=medium,
      m_flow=-outlet.m_flow,
      T=fluidOutlet.T,
      p=outlet.p,
      h=fluidOutlet.h,
      xi=fluidOutlet.xi,
      H_flow=-outlet.m_flow*fluidOutlet.h)) annotation (Placement(transformation(extent={{-60,-54},{-40,-34}})));

  inner TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.Records.IComPackedBedControlVolume_L4 iCom(
    mediumModel=medium,
    xi=xi,
    N_cv=geo.N_cv,
    volume=geo.volume_bed,
    p_in={inlet.p},
    T_in={fluidInlet.T},
    m_flow_in={inlet.m_flow},
    h_in={fluidInlet.h},
    xi_in={fluidInlet.xi},
    xi_out={fluidOutlet.xi},
    p_out={outlet.p},
    T_out={fluidOutlet.T},
    m_flow_out={outlet.m_flow},
    h_out={fluidOutlet.h},
    p_nom=p_nom[1],
    Delta_p_nom=Delta_p_nom,
    m_flow_nom=m_flow_nom,
    h_nom=TILMedia.GasFunctions.specificEnthalpy_pTxi(
        medium,
        p_nom[1],
        T_nom[1],
        xi_start),
    xi_nom=xi_nom,
    T=fluid.T,
    p=p,
    h=h,
    fluidPointer_in={fluidInlet.gasPointer},
    fluidPointer_out={fluidOutlet.gasPointer},
    fluidPointer=fluid.gasPointer,
    final N_inlet=1,
    final N_outlet=1,
    lambda_eff_rad = thermalConductivity.lambda_eff_radial,
    lambda_eff_ax = thermalConductivity.lambda_eff_axial,
    permeability = pressureLoss.permeability) annotation (Placement(transformation(extent={{-80,-54},{-60,-34}})));

public
  inner Geometry geo    annotation (Placement(transformation(extent={{40,0},{60,20}})));


  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  SI.Temperature T[geo.N_cv](start=T_start_internal,min=253.15, max=1273.15, each stateSelect=StateSelect.prefer) "Cell Temperature";

  SI.EnthalpyMassSpecific h[geo.N_cv](start=h_start) "Cell fluid enthalpy";

  SI.Mass mass_rock[geo.N_cv];

  SI.Pressure p[geo.N_cv](start=p_start_internal) "Cell pressure";

  SI.Pressure Delta_p_fric[geo.N_cv + 1] "Pressure difference due to friction";

  SI.Pressure Delta_p_adv[geo.N_cv + 1] "Pressure difference due to advection";

  SI.Mass mass_air[geo.N_cv] "Mass of fluid in cells";

  SI.Mass mass_air_FM[geo.N_cv + 1]=cat(
      1,
      {mass_air[1]/2},
      {(mass_air[i] + mass_air[i - 1])/2 for i in 2:geo.N_cv},
      {mass_air[geo.N_cv]/2}) "Mass of fluid in flow cells";

  Real drhodt[geo.N_cv] "Density derivative";

  SI.MassFraction xi[geo.N_cv,medium.nc - 1];

  Real Xi_flow[geo.N_cv + 1,medium.nc - 1];

  SI.Power H_flow[geo.N_cv + 1] "Enthalpy flow rate at cell borders";

  SI.MassFlowRate m_flow[geo.N_cv + 1](nominal = ones(geo.N_cv+1)*m_flow_nom, start=m_flow_start);

  SI.Velocity w[geo.N_cv] "flow velocities within cells of energy model == flow velocities across cell borders of flow model ";

  SI.Velocity w_inlet "flow velocity at inlet";

  SI.Velocity w_outlet "flow velocity at outlet";

public
  SI.Temperature T_inlet "Inlet temperature of component";

  SI.Temperature T_outlet "Outlet temperature of component";

protected
  SI.MassFraction xi_inlet[medium.nc - 1] "Inlet gas composition of component";

  SI.MassFraction xi_outlet[medium.nc - 1] "Outlet gas composition of component";





  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________


initial equation


  if initOption == 1 then
    //steady state in pressure and enthalpy

    der(h) = zeros(geo.N_cv);

    der(outlet.p) = 0;

    for i in 1:geo.N_cv loop

      der(xi[i, :]) = zeros(medium.nc - 1);

    end for;

  elseif initOption == 201 then
    //steady pressure

    der(p) = zeros(geo.N_cv);

  elseif initOption == 202 then
    //steady enthalpy

    der(h) = zeros(geo.N_cv);

  elseif initOption == 203 then
    //steady temperature

    T = T_start;

  elseif initOption == 208 then
    //steady state in pressure and enthalpy

    der(h) = zeros(geo.N_cv);

    der(outlet.p) = 0;

  elseif initOption == 0 then
    //no init

    // do nothing

  else

    assert(initOption == 0, "Invalid init option");

  end if;

  for i in 1:geo.N_cv loop

    //xi[i,:]=xi_start[1:end-1]/sum(xi_start);

    xi[i, :] = xi_start[1:end];

  end for;

equation

  //-------------------------------------------
  //connect flow port variables to internal variables

  T_inlet = noEvent(actualStream(inlet.T_outflow));

  T_outlet = noEvent(actualStream(outlet.T_outflow));

  xi_inlet = noEvent(actualStream(inlet.xi_outflow));

  xi_outlet = noEvent(actualStream(outlet.xi_outflow));

  m_flow[1] = inlet.m_flow;

  m_flow[geo.N_cv + 1] = -outlet.m_flow;

  inlet.T_outflow = T[1];

  outlet.T_outflow = T[geo.N_cv];

  inlet.xi_outflow[:] = xi[1, :];

  outlet.xi_outflow[:] = xi[geo.N_cv, :];

  //-------------------------------------------
  //connect sub models variables to model variables

  pressureLoss.m_flow = m_flow;

  heatTransferExternal.m_flow = m_flow;

  heatTransferOutlet.m_flow = m_flow;

  heatTransferInlet.m_flow = m_flow;

  thermalConductivity.m_flow = m_flow;

  Delta_p_fric = pressureLoss.Delta_p;



  //-------------------------------------------
  //Determine Enthalpy flows

  for i in 2:geo.N_cv loop

    H_flow[i] = if useHomotopy then homotopy(semiLinear(
      m_flow[i],
      h[i - 1],
      h[i]), h[i - 1]*m_flow_nom) else semiLinear(
      m_flow[i],
      h[i - 1],
      h[i]);

  end for;

  H_flow[1] = if useHomotopy then homotopy(semiLinear(
    m_flow[1],
    fluidInlet.h,
    h[1]), fluidInlet.h*m_flow_nom) else semiLinear(
    m_flow[1],
    fluidInlet.h,
    h[1]);

  H_flow[geo.N_cv + 1] = if useHomotopy then homotopy(semiLinear(
    m_flow[geo.N_cv + 1],
    h[geo.N_cv],
    fluidOutlet.h), h[geo.N_cv]*m_flow_nom) else semiLinear(
    m_flow[geo.N_cv + 1],
    h[geo.N_cv],
    fluidOutlet.h);


   //-------------------------------------------
   //Determine Component mass flow

   for i in 2:geo.N_cv loop

     Xi_flow[i, :] = if useHomotopy then homotopy(semiLinear(
       m_flow[i],
       (xi[i - 1, :]),
       (xi[i, :])), (xi[i - 1, :])*m_flow_nom) else semiLinear(
       m_flow[i],
       (xi[i - 1, :]),
       (xi[i, :]));

   end for;

   Xi_flow[1, :] = if useHomotopy then homotopy(semiLinear(
     m_flow[1],
     (fluidInlet.xi[:]),
     (xi[1, :])), (fluidInlet.xi[:])*m_flow_nom) else semiLinear(
     m_flow[1],
     (fluidInlet.xi[:]),
     (xi[1, :]));

   Xi_flow[geo.N_cv + 1, :] = if useHomotopy then homotopy(semiLinear(
     m_flow[geo.N_cv + 1],
     (xi[geo.N_cv, :]),
     (fluidOutlet.xi[:])), (xi[geo.N_cv, :])*m_flow_nom) else semiLinear(
     m_flow[geo.N_cv + 1],
     (xi[geo.N_cv, :]),
     (fluidOutlet.xi[:]));

  //-------------------------------------------
  //Air and rock mass in cells

  mass_air = if useHomotopy then homotopy(geo.volume_air .* fluid.d, geo.volume_air .* d_start) else geo.volume_air .* fluid.d;

  mass_rock = geo.volume_rock .* rock.d;

  //-------------------------------------------
  // Air Mass Balance

    for i in 1:geo.N_cv loop

    drhodt[i]*geo.volume_air[i] = m_flow[i] - m_flow[i + 1] "Air Mass balance";

  end for;

  //-------------------------------------------
  // Component Mass Balance

    for i in 1:geo.N_cv loop

    der(xi[i, :]) = 1/mass_air[i]*((Xi_flow[i, :] - m_flow[i]*xi[i, :]) - (Xi_flow[i + 1, :] - m_flow[i + 1]*xi[i, :])) "Component mass balance";

    end for;

  //-------------------------------------------
  // Energy Balance

  for i in 1:geo.N_cv loop

    der(T[i]) = (H_flow[i] - H_flow[i + 1] + heatExternal[i].Q_flow + thermalConductivity.Q_flow[i] - thermalConductivity.Q_flow[i + 1] + heatInlet[i].Q_flow + heatOutlet[i].Q_flow)/(mass_air[i]*fluid[i].cv+mass_rock[i]*rock[i].cp) "Energy balance";

  end for;


  //-------------------------------------------
  // Determine drho/dt from pressure and temperature state

  for i in 1:geo.N_cv loop

     //fluid[i].drhodp_hxi*der(p[i]) = (drhodt[i] - der(T[i])*fluid[i].cp*fluid[i].drhodh_pxi - sum({fluid[i].drhodxi_ph[j]*der(xi[i, j]) for j in 1:medium.nc - 1})) "Calculate pressure from enthalpy and density derivative";
     fluid[i].d*fluid[i].kappa*der(p[i]) = drhodt[i] + fluid[i].d*fluid[i].beta*der(T[i]) "only valid if der(x)=0";

  end for;

  //-------------------------------------------
  // Determine Enthalpy from pressure and temperature state

  for i in 1:geo.N_cv loop

    h[i] = fluid[i].h;

  end for;

  //-------------------------------------------
  //determine flow velocities (physical velocity is used here)

  w_inlet = inlet.m_flow/(geo.A_cross_air_FM[1]*fluidInlet.d);

  w_outlet = -outlet.m_flow/(geo.A_cross_air_FM[geo.N_cv + 1]*fluidOutlet.d);

  for i in 1:geo.N_cv loop

    w[i] = (m_flow[i] + m_flow[i + 1])/(2*fluid[i].d*geo.A_cross_air[i]);

  end for;

  //-------------------------------------------
  //Determine dynamic pressure for momentum balance

  for i in 3:geo.N_cv - 1 loop

    Delta_p_adv[i] = w[i - 1]*abs(w[i - 1])*fluid[i - 1].d - w[i]*abs(w[i])*fluid[i].d;

  end for;

  if frictionAtInlet then

    Delta_p_adv[1] = w_inlet*abs(w_inlet)*fluidInlet.d - w[1]*abs(w[1])*fluid[1].d;

    Delta_p_adv[2] = w[1]*abs(w[1])*fluid[1].d - w[2]*abs(w[2])*fluid[2].d;

  else

    Delta_p_adv[1] = 0;

    Delta_p_adv[2] = w_inlet*abs(w_inlet)*fluidInlet.d - w[2]*abs(w[2])*fluid[2].d;

  end if;

  if frictionAtOutlet then

    Delta_p_adv[geo.N_cv] = w[geo.N_cv - 1]*abs(w[geo.N_cv - 1])*fluid[geo.N_cv - 1].d - w[geo.N_cv]*abs(w[geo.N_cv])*fluid[geo.N_cv].d;

    Delta_p_adv[geo.N_cv + 1] = w[geo.N_cv]*abs(w[geo.N_cv])*fluid[geo.N_cv].d - w_outlet*abs(w_outlet)*fluidOutlet.d;

  else

    Delta_p_adv[geo.N_cv] = w[geo.N_cv - 1]*abs(w[geo.N_cv - 1])*fluid[geo.N_cv - 1].d - w_outlet*abs(w_outlet)*fluidOutlet.d;

    Delta_p_adv[geo.N_cv + 1] = 0;

  end if;

  //-------------------------------------------
  // Dynamic momentum balance:

  for i in 2:geo.N_cv loop

    geo.Delta_x_FM[i]/geo.A_cross_air_FM[i]*der(m_flow[i]) = if useHomotopy then homotopy(p[i - 1] + 1*der(p[i - 1])*geo.Delta_x[i - 1]/fluid[i].w/2 - p[i] - 1*der(p[i])*geo.Delta_x[i]/fluid[i].w/2 + Delta_p_adv[i] - Delta_p_fric[i], 0) else p[i - 1] + 1*der(p[i - 1])*geo.Delta_x[i - 1]/fluid[i].w/2 - p[i] - 1*der(p[i])*geo.Delta_x[i]/fluid[i].w/2 + Delta_p_adv[i] - Delta_p_fric[i];

  end for;

  //enable / disable pressure losses due to friction for flows  inlet --> first cell / last cell --> outlet

  if not frictionAtInlet and not frictionAtOutlet then

    //no friction pressure loss inlet->first cell / no friction pressure loss last cell->outlet

    inlet.p = fluid[1].p;

    outlet.p = fluid[geo.N_cv].p;

  elseif frictionAtInlet and not frictionAtOutlet then

    //friction pressure loss inlet->first cell / no friction pressure loss last cell->outlet

    geo.Delta_x_FM[1]/geo.A_cross_air_FM[1]*der(m_flow[1]) = if useHomotopy then homotopy(inlet.p - p[1] + Delta_p_adv[1] - Delta_p_fric[1], 0) else inlet.p - p[1] + Delta_p_adv[1] - Delta_p_fric[1];

    outlet.p = fluid[geo.N_cv].p;

  elseif not frictionAtInlet and frictionAtOutlet then

    //"no friction pressure loss inlet->first cell / friction pressure loss last cell->outlet"

    geo.Delta_x_FM[geo.N_cv + 1]/geo.A_cross_air_FM[geo.N_cv + 1]*der(m_flow[geo.N_cv + 1]) = if useHomotopy then homotopy(p[geo.N_cv] - outlet.p + Delta_p_adv[geo.N_cv + 1] - Delta_p_fric[geo.N_cv + 1], 0) else p[geo.N_cv] - outlet.p + Delta_p_adv[geo.N_cv + 1] - Delta_p_fric[geo.N_cv + 1];

    inlet.p = fluid[1].p;

  else

    //friction pressure loss inlet->first cell / friction pressure loss last cell->outlet

    geo.Delta_x_FM[1]/geo.A_cross_air_FM[1]*der(m_flow[1]) = if useHomotopy then homotopy(inlet.p - p[1] + Delta_p_adv[1] - Delta_p_fric[1], 0) else inlet.p - p[1] + Delta_p_adv[1] - Delta_p_fric[1];

    geo.Delta_x_FM[geo.N_cv + 1]/geo.A_cross_air_FM[geo.N_cv + 1]*der(m_flow[geo.N_cv + 1]) = if useHomotopy then homotopy(p[geo.N_cv] - outlet.p + Delta_p_adv[geo.N_cv + 1] - Delta_p_fric[geo.N_cv + 1], 0) else p[geo.N_cv] - outlet.p + Delta_p_adv[geo.N_cv + 1] - Delta_p_fric[geo.N_cv + 1];

  end if;



  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________




  connect(heatTransferExternal.heat, heatExternal) annotation (Line(
      points={{-23,19},{-23,50},{0,50}},
      color={167,25,48},
      thickness=0.5));
  connect(heatTransferInlet.heat, heatInlet) annotation (Line(
      points={{-91,19},{-82,19},{-82,40},{-128,40},{-128,28},{-138,28}},
      color={167,25,48},
      thickness=0.5));
  connect(heatTransferOutlet.heat, heatOutlet) annotation (Line(
      points={{99,19},{128,19},{128,26},{140,26}},
      color={167,25,48},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-50},{140,50}})), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-50},{140,50}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>The model describes an axial-flow packed bed used for thermal energy storage. Gaseous heat transfer fluid and solid media storage material are generally assumed. It has been validated with air as heat transfer fluid and natural rock as storage material. Main focus is the</p>
<ul>
<li>transient behavior of the temperature field and</li>
<li>fluid pressure loss.</li>
</ul>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<ul>
<li>The packed bed is discretized in one dimension, which is the main fluid flow direction</li>
<li>A single energy equation is used for each finite volume, meaning particle and fluid temperature are not distinct, but a mean packed-bed temperature is used. This generally holds for ideal heat transfer between the storage material and heat transfer fluid. Neverthess, the effect of a limited heat transfer between both can be still taken into account by adoption of the effective packed bed thermal conductivity correlation for example using the approach of Vortmeyer (1974).</li>
<li>An additional heat port is added at the sides. It can be used to account for other means of heat transport such as conduction, radiation or natural convection besides the advective energy transport into and out of the packed bed.</li>
<li>An additional body force according to the Darcy-Forchheimer equation is added to the dynamic momentum balance to account for the packed bed flow resistance.</li>
<li>A storage material medium model is required, which has an additional state variable for the specific internal energy in order to account for a temperature variant specific heat capacity.</li>
</ul>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<ul>
<li>The one-dimensional spatial representation leads to the plug-flow assumption, meaning no lateral temperature and velocity variations are taken into account</li>
<li>A horizontal air flow direction is assumed, thus no gravitational force is taken into account in the dynamic momentum balance</li>
<li><span style=\"font-family: MS Shell Dlg 2;\">Natural convection is not taken into account</span></li>
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
<li>Packed bed correlations are replaceable</li>
<li>The momentum balance is dynamic to allow very small mass flows</li>
<li>The mean sphericity describes the ratio of the surface of a set of monodisperse spheres with the same number and overall volume as the particle set to the particles set surface. It thus is not solely depended on the particles shape, but also on the particle size distribution.</li>
</ul>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>The model is validated with two experimental setup of Siemens Gamesa Renewable Energy in Hamburg-Altenwerder (6 MWh_th) and -Bergedorf (130 MWh_th), Germany.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Abschlussbericht zum Teilprojekt der TUHH im Verbundforschungsprojekt Future Energy Solution (FES) (BMWI 03ET6072C) (2021)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Electric Thermal Energy Storage based on Packed Beds for Renewable Energy Integration, Dissertation, Hamburg University of Technology, Michael von der Heyde (2021)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">First Version in 04.2020 for the research project Future Energy Solution (FES) by Michael von der Heyde (heyde@tuhh.de)</span></p>
</html>"));
end PackedBedControlVolume_L4;
