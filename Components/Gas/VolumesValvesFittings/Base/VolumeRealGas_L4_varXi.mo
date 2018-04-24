within TransiEnt.Components.Gas.VolumesValvesFittings.Base;
model VolumeRealGas_L4_varXi "A 1D tube-shaped control volume considering one-phase heat transfer in a straight pipe with static momentum balance, simple energy balance, and variable composition"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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
// Modified component of the ClaRa library, version: 1.3.0
// Path: ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L4
// Modifications: simCenter, media models, connectors changed to TransiEnt instances
// two-phase region deactivated
// added different mass balances (choosable with massBalance)
// added xi_nom, m_flow_start
// added w_inlet, w_outlet, medium, xi, x in summary

  extends ClaRa.Basics.Icons.Volume_L4;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L4");
  import SI = ClaRa.Basics.Units;
  import Modelica.Constants.eps;
  import Modelica.Constants.g_n "gravity constant";
  import ClaRa.Basics.Functions.Stepsmoother;

  outer TransiEnt.SimCenter simCenter;

  //## S U M M A R Y   D E F I N I T I O N #######################################################################
  model Outline
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary annotation (Dialog(hide));

    input ClaRa.Basics.Units.Volume volume_tot "Total volume of system" annotation (Dialog(show));

    parameter Integer N_cv "Number of finite volumes" annotation(Dialog(group="Discretisation"));

    input ClaRa.Basics.Units.PressureDifference Delta_p "Pressure difference between outlet and inlet" annotation (Dialog);
    input ClaRa.Basics.Units.Mass mass_tot "Total fluid mass in system mass" annotation (Dialog(show));
    input ClaRa.Basics.Units.Enthalpy H_tot if showExpertSummary "Total system enthalpy" annotation (Dialog(show));
    input ClaRa.Basics.Units.HeatFlowRate Q_flow_tot "Heat flow through entire pipe wall" annotation (Dialog);

    input ClaRa.Basics.Units.Mass mass[N_cv] if showExpertSummary "Fluid mass in cells" annotation (Dialog(show));
    input ClaRa.Basics.Units.Momentum I[N_cv + 1] if showExpertSummary "Momentum of fluid flow volumes through cell borders" annotation (Dialog(show));
    input ClaRa.Basics.Units.Force I_flow[N_cv + 2] if showExpertSummary "Momentum flow through cell borders" annotation (Dialog(show));
    input ClaRa.Basics.Units.MassFlowRate m_flow[N_cv + 1] if showExpertSummary "Mass flow through cell borders" annotation (Dialog(show));
    input ClaRa.Basics.Units.Velocity w[N_cv] if showExpertSummary "Velocity of flow in cells" annotation (Dialog(show));
    input ClaRa.Basics.Units.Velocity w_inlet if showExpertSummary "Velocity at the inlet" annotation (Dialog(show));
    input ClaRa.Basics.Units.Velocity w_outlet if showExpertSummary "Velocity at the inlet" annotation (Dialog(show));
  end Outline;

  model Wall_L4
    extends ClaRa.Basics.Icons.RecordIcon;
    parameter Boolean showExpertSummary annotation (Dialog(hide));
    parameter Integer N_wall "Number of wall segments" annotation (Dialog(hide));
    input ClaRa.Basics.Units.Temperature T[N_wall] if showExpertSummary "Temperatures of wall segments" annotation (Dialog);
    input ClaRa.Basics.Units.HeatFlowRate Q_flow[N_wall] if showExpertSummary "Heat flows through wall segments" annotation (Dialog);
  end Wall_L4;

  model Inlet
    extends ClaRa.Basics.Records.FlangeVLE;
    parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium "Medium" annotation (Dialog);
    input ClaRa.Basics.Units.MassFraction xi[medium.nc-1] "Mass composition at the inlet" annotation (Dialog);
    input Modelica.SIunits.MoleFraction x[medium.nc-1] "Molar composition at the inlet" annotation (Dialog);
  end Inlet;

  model Outlet
    extends ClaRa.Basics.Records.FlangeVLE;
    parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium "Medium" annotation (Dialog);
    input ClaRa.Basics.Units.MassFraction xi[medium.nc-1] "Mass composition at the outlet" annotation (Dialog);
    input Modelica.SIunits.MoleFraction x[medium.nc-1] "Molar composition at the outlet" annotation (Dialog);
  end Outlet;

  model Fluid
    extends ClaRa.Basics.Records.FluidVLE_L34;
    parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium "Medium" annotation (Dialog);
    input ClaRa.Basics.Units.MassFraction xi[N_cv, medium.nc-1] "Mass composition of the fluid" annotation (Dialog);
    input Modelica.SIunits.MoleFraction x[N_cv, medium.nc-1] "Molar composition of the fluid" annotation (Dialog);
  end Fluid;

  model Summary
    extends ClaRa.Basics.Icons.RecordIcon;
    Outline outline;
    Inlet inlet;
    Outlet outlet;
    Fluid fluid;
    Wall_L4 wall;
  end Summary;

//____Media Data_____________________________________________________________________________________
public
 parameter TILMedia.VLEFluidTypes.BaseVLEFluid  medium=simCenter.gasModel1 "Medium in the component" annotation(Dialog(group="Fundamental Definitions"));

 //____Numerics_________________________________________________________________________________________
public
 parameter Integer massBalance=1 "Mass balance and species balance fomulation" annotation(Dialog(group="Fundamental Definitions"),choices(choice=1 "ClaRa formulation", choice=2 "TransiEnt formulation 1a", choice=3 "TransiEnt formulation 1b"));
//____Physical Effects_____________________________________________________________________________________

public
  inner parameter Boolean frictionAtInlet=false "True if pressure loss between first cell and inlet shall be considered"
                                                                                            annotation (choices(checkBox=true),Dialog(group="Fundamental Definitions"));
  inner parameter Boolean frictionAtOutlet=false "True if pressure loss between last cell and outlet shall be considered"
                                                                                            annotation (choices(checkBox=true),Dialog(group="Fundamental Definitions"));

  replaceable model PressureLoss =
      ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4            constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.PressureLossBaseVLE_L4 "Pressure loss model at the tubes side"
                                                                                            annotation(choicesAllMatching,Dialog(group="Fundamental Definitions"));

  replaceable model HeatTransfer =
      ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4                     constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.HeatTransferBaseVLE_L4 "Heat transfer mode at the tubes side"
                                                                                            annotation(choicesAllMatching,Dialog(group="Fundamental Definitions"));
  replaceable model Geometry =
      ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv                          constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.Geometry.GenericGeometry_N_cv "Pipe geometry"
                                                                                            annotation(choicesAllMatching,Dialog(group="Geometry"));
  replaceable model MechanicalEquilibrium = ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.Homogeneous_L4
                                                                                                  constrainedby ClaRa.Basics.ControlVolumes.Fundamentals.SpacialDistribution.MechanicalEquilibrium_L4
                                                                                                                                                                                         "Mechanical equilibrium model"
                                                                                             annotation(choicesAllMatching,Dialog(group="Fundamental Definitions"));

//____Nominal Values_________________________________________________________________________________
public
  parameter ClaRa.Basics.Units.Pressure p_nom[geo.N_cv]=ones(geo.N_cv)*(simCenter.p_amb_const+simCenter.p_eff_2) "Nominal pressure" annotation(Dialog(group="Nominal Values"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_nom[geo.N_cv]=ones(geo.N_cv)*(-1850) "Nominal specific enthalpy for single tube" annotation(Dialog(group="Nominal Values"));
  inner parameter ClaRa.Basics.Units.MassFlowRate m_flow_nom=1 "Nominal mass flow w.r.t. all parallel tubes" annotation(Dialog(group="Nominal Values"));
  inner parameter ClaRa.Basics.Units.PressureDifference Delta_p_nom=1e4 "Nominal pressure loss w.r.t. all parallel tubes" annotation(Dialog(group="Nominal Values"));
  inner parameter ClaRa.Basics.Units.MassFraction xi_nom[medium.nc-1]=medium.xi_default "Nominal composition" annotation(Dialog(group="Nominal Values"));
  final parameter ClaRa.Basics.Units.DensityMassSpecific rho_nom[geo.N_cv]=TILMedia.VLEFluidFunctions.density_phxi(
      medium,
      p_nom,
      h_nom,
      xi_nom) "Nominal density";

//____Initialisation_____________________________________________________________________________________
  inner parameter Integer  initOption=0 "Type of initialisation" annotation(Dialog(tab="Initialisation"), choices(choice = 0 "Use guess values", choice = 208 "Steady pressure and enthalpy", choice=201 "Steady pressure", choice = 202 "Steady enthalpy"));
  inner parameter Boolean useHomotopy=simCenter.useHomotopy "true, if homotopy method is used during initialisation" annotation(Dialog(tab="Initialisation",group="Model Settings"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_start[geo.N_cv]=h_nom "Initial specific enthalpy for single tube"
                                                                                                                       annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure p_start[geo.N_cv]=p_nom "Initial pressure"
                                                                                  annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_start[medium.nc - 1]=xi_nom "Initial composition for single tube"
                                                                                                                annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_start[geo.N_cv+1]=m_flow_nom*ones(geo.N_cv+1) "Initial mass flow rate" annotation(Dialog(tab="Initialisation"));
protected
  parameter ClaRa.Basics.Units.Pressure p_start_internal[geo.N_cv]=if size(p_start, 1) == 2 then linspace(
      p_start[1],
      p_start[2],
      geo.N_cv) else p_start "Internal p_start array which allows the user to either state p_inlet, p_outlet if p_start has length 2, otherwise the user can specify an individual pressure profile for initialisation";

  //____Summary and Visualisation_____________________________________________________________________________________
public
  parameter Boolean showExpertSummary=simCenter.showExpertSummary "True, if an extended summary shall be shown, else false"
                                                                                                                           annotation(Dialog(tab="Summary and Visualisation"));
  parameter Boolean showData=false "True, if a data port containing p,T,h,s,m_flow shall be shown, else false"
                                                                                                              annotation(Dialog(tab="Summary and Visualisation"));

  Summary summary(
    outline(
      showExpertSummary=showExpertSummary,
      N_cv=geo.N_cv,
      volume_tot=sum(geo.volume),
      Delta_p=gasPortIn.p - gasPortOut.p,
      mass_tot=sum(mass),
      H_tot=sum(h .* mass),
      Q_flow_tot=sum(heat.Q_flow),
      mass=mass,
      I=geo.Delta_x_FM .* m_flow,
      I_flow=cat(
          1,
          {w_inlet*abs(w_inlet)*gasIn.d*geo.A_cross[1]},
          {w[i]*abs(w[i])*gasBulk[i].d*geo.A_cross[i] for i in 1:geo.N_cv},
          {w_outlet*abs(w_outlet)*gasOut.d*geo.A_cross[geo.N_cv]}),
      m_flow=m_flow,
      w=w,
      w_inlet=w_inlet,
      w_outlet=w_outlet),
    inlet(
      showExpertSummary=showExpertSummary,
      m_flow=gasPortIn.m_flow,
      T=gasIn.T,
      p=gasIn.p,
      h=gasIn.h,
      s=gasIn.s,
      steamQuality=gasIn.q,
      H_flow=H_flow[1],
      rho=gasIn.d,
      medium=medium,
      xi=gasIn.xi,
      x=gasIn.x),
    outlet(
      showExpertSummary=showExpertSummary,
      m_flow=-gasPortOut.m_flow,
      T=gasOut.T,
      p=gasOut.p,
      h=gasOut.h,
      s=gasOut.s,
      steamQuality=gasOut.q,
      H_flow=H_flow[geo.N_cv + 1],
      rho=gasOut.d,
      medium=medium,
      xi=gasOut.xi,
      x=gasOut.x),
    fluid(
      showExpertSummary=showExpertSummary,
      N_cv=geo.N_cv,
      mass=mass,
      T=gasBulk.T,
      T_sat=gasBulk.VLE.T_l,
      p=p,
      h=h,
      h_bub=gasBulk.VLE.h_l,
      h_dew=gasBulk.VLE.h_v,
      s=gasBulk.s,
      steamQuality=gasBulk.q,
      H=mass .* h,
      rho=gasBulk.d,
      medium=medium,
      xi=gasBulk.xi,
      x=gasBulk.x),
    wall(
      showExpertSummary=showExpertSummary,
      N_wall=geo.N_cv,
      T=heat.T,
      Q_flow=heat.Q_flow)) annotation (Placement(transformation(extent={{-60,-52},{-40,-34}})));

//## V A R I A B L E   P A R T#######################################################################################

//____Energy / Enthalpy_________________________________________________________________________________________
protected
  ClaRa.Basics.Units.EnthalpyMassSpecific h[geo.N_cv](start=h_start,each stateSelect=StateSelect.prefer) "Cell enthalpy";


  //____Pressure__________________________________________________________________________________________________
  ClaRa.Basics.Units.Pressure p[geo.N_cv](start=p_start_internal) "Cell pressure";
  ClaRa.Basics.Units.PressureDifference Delta_p_fric[geo.N_cv + 1] "Pressure difference due to friction";
  ClaRa.Basics.Units.PressureDifference Delta_p_grav[geo.N_cv + 1] "pressure drop due to gravity";

  //____Mass and Density__________________________________________________________________________________________
  ClaRa.Basics.Units.Mass mass[geo.N_cv] "Mass of fluid in cells";
  ClaRa.Basics.Units.Mass mass_FM[geo.N_cv + 1]=cat(
      1,
      {mass[1]/2},
      {(mass[i] + mass[i - 1])/2 for i in 2:geo.N_cv},
      {mass[geo.N_cv]/2}) "Mass of fluid in flow cells";
  Real drhodt[geo.N_cv];
  //(unit="kg/(m3s)")

  ClaRa.Basics.Units.MassFraction steamQuality[geo.N_cv] "Steam fraction";
  ClaRa.Basics.Units.MassFraction steamQuality_inlet "Steam fraction";
  ClaRa.Basics.Units.MassFraction steamQuality_outlet "Steam fraction";

  //____Mass Fractions____________________________________________________________________________________________
  Modelica.SIunits.MassFraction xi[geo.N_cv, medium.nc - 1] "Mass fraction";
  Real[geo.N_cv + 1, medium.nc - 1] Xi_flow "Mass flow rate of fraction";
  Modelica.SIunits.MassFraction xi_inlet[medium.nc - 1] "Inlet mass fraction of component";
  Modelica.SIunits.MassFraction xi_outlet[medium.nc - 1] "Outlet mass fraction of component";
  //____Flows and Velocities______________________________________________________________________________________
  ClaRa.Basics.Units.Power H_flow[geo.N_cv + 1] "Enthalpy flow rate at cell borders";
  ClaRa.Basics.Units.MassFlowRate m_flow[geo.N_cv + 1](start=m_flow_start, nominal=ones(geo.N_cv + 1)*m_flow_nom);
  ClaRa.Basics.Units.Velocity w[geo.N_cv] "flow velocities within cells of energy model == flow velocities across cell borders of flow model ";
  ClaRa.Basics.Units.Velocity w_inlet "flow velocity at inlet";
  ClaRa.Basics.Units.Velocity w_outlet "flow velocity at outlet";

//____Connectors________________________________________________________________________________________________
public
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium) "Inlet port" annotation (Placement(transformation(extent={{-150,-10},{-130,10}}), iconTransformation(extent={{-150,-10},{-130,10}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) "Outlet port" annotation (Placement(transformation(extent={{130,-10},{150,10}}), iconTransformation(extent={{130,-10},{150,10}})));

  ClaRa.Basics.Interfaces.HeatPort_a heat[geo.N_cv] annotation (Placement(transformation(extent={{-10,30},{10,50}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,40})));

//___Instantiation of Replaceable Models___________________________________________________________________________
public
  PressureLoss pressureLoss "Pressure loss model" annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  HeatTransfer heatTransfer(A_heat=geo.A_heat_CF[:, 1]) "heat transfer model" annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  inner Geometry geo annotation (Placement(transformation(extent={{0,0},{20,20}})));
  MechanicalEquilibrium mechanicalEquilibrium(final h_start=h_start) "Mechanical equilibrium model" annotation (Placement(transformation(extent={{40,0},{60,20}})));

protected
  inner TILMedia.VLEFluid_ph gasBulk[geo.N_cv](
    p=p,
    h=h,
    each vleFluidType=medium,
    each computeTransportProperties=true,
    each deactivateTwoPhaseRegion=true,
    xi=xi) annotation (Placement(transformation(extent={{-10,-40},{10,-20}}, rotation=0)));

  inner TILMedia.VLEFluid_ph gasIn(
    p=gasPortIn.p,
    vleFluidType=medium,
    h=noEvent(actualStream(gasPortIn.h_outflow)),
    computeTransportProperties=true,
    deactivateTwoPhaseRegion=true,
    xi=xi_inlet) annotation (Placement(transformation(extent={{-90,-30},{-70,-10}}, rotation=0)));

  inner TILMedia.VLEFluid_ph gasOut(
    p=gasPortOut.p,
    vleFluidType=medium,
    h=noEvent(actualStream(gasPortOut.h_outflow)),
    computeTransportProperties=true,
    deactivateTwoPhaseRegion=true,
    xi=xi_outlet) annotation (Placement(transformation(extent={{70,-30},{90,-10}}, rotation=0)));

  inner ClaRa.Basics.Records.IComVLE_L3_OnePort iCom(
    mediumModel=medium,
    N_cv=geo.N_cv,
    xi=xi,
    volume=geo.volume,
    p_in={gasPortIn.p},
    T_in={gasIn.T},
    m_flow_in={gasPortIn.m_flow},
    h_in={gasIn.h},
    xi_in={gasIn.xi},
    p_out={gasPortOut.p},
    T_out={gasOut.T},
    m_flow_out={gasPortOut.m_flow},
    h_out={gasOut.h},
    xi_out={gasOut.xi},
    p_nom=p_nom[1],
    Delta_p_nom=Delta_p_nom,
    m_flow_nom=m_flow_nom,
    h_nom=h_nom[1],
    xi_nom=xi_nom,
    T=gasBulk.T,
    p=p,
    h=h,
    fluidPointer_in={gasIn.vleFluidPointer},
    fluidPointer_out={gasOut.vleFluidPointer},
    fluidPointer=gasBulk.vleFluidPointer) annotation (Placement(transformation(extent={{-80,-52},{-60,-34}})));

  //### E Q U A T I O N P A R T #######################################################################################
  //-------------------------------------------

  //initialisation

initial equation
  if initOption == 208 then
    der(h) = zeros(geo.N_cv);
    der(p) = zeros(geo.N_cv);
  elseif initOption == 201 then
    der(p) = zeros(geo.N_cv);
  elseif initOption == 202 then
    der(h) = zeros(geo.N_cv);
  elseif initOption == 0 then
    // do nothing
  else
    assert(false, "Unknown init option in " + getInstanceName());
  end if;

  for i in 1:geo.N_cv loop
    xi[i, :] = xi_start[1:end];
  end for;
equation

  connect(heat, heatTransfer.heat) annotation (Line(
      points={{0,40},{0,28},{-61,28},{-61,19}},
      color={0,0,0},
      smooth=Smooth.None));

  //-------------------------------------------
  //flow velocities at inlet and outlet
  w_inlet =gasPortIn.m_flow/(geo.A_cross_FM[1]*gasIn.d);
  w_outlet =-gasPortOut.m_flow/(geo.A_cross_FM[geo.N_cv + 1]*gasOut.d);
  steamQuality_inlet =gasIn.q;
  steamQuality_outlet =gasOut.q;

  for i in 1:geo.N_cv loop
     //flow velocities in cells
    w[i] =(m_flow[i] + m_flow[i + 1])/(2*gasBulk[i].d*geo.A_cross[i]);
    //steam quality
    steamQuality[i] =gasBulk[i].q;
  end for;

  //-------------------------------------------
  //data exchange with friction model
  m_flow[1] =gasPortIn.m_flow;
  m_flow = pressureLoss.m_flow;
  m_flow[geo.N_cv + 1] =-gasPortOut.m_flow;

  //-------------------------------------------
  //data exchange with replaceable models
  heatTransfer.m_flow = m_flow;
  mechanicalEquilibrium.m_flow = m_flow;

  //pressure drop due to friction, gravity


  Delta_p_fric = pressureLoss.Delta_p;
  if geo.N_cv==1 then
    if not frictionAtInlet and not frictionAtOutlet then
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] = 0;
    elseif not frictionAtInlet and frictionAtOutlet then
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] =gasBulk[1].d*g_n*(geo.z_out - geo.z_in);
    elseif  frictionAtInlet and not frictionAtOutlet then
      Delta_p_grav[1] =gasBulk[1].d*g_n*(geo.z_out - geo.z_in);
      Delta_p_grav[2] = 0;
      else
      // frictionAtOutlet and frictionAtnlet
      Delta_p_grav[1] =gasBulk[1].d*g_n*(geo.z[1] - geo.z_in);
      Delta_p_grav[2] =gasBulk[1].d*g_n*(geo.z_out - geo.z[1]);
      end if;
  elseif geo.N_cv==2 then
    if not frictionAtInlet and not frictionAtOutlet then
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] =gasBulk[2].d*g_n*(geo.z_out - geo.z_in);
      Delta_p_grav[3] = 0;
    elseif not frictionAtInlet and frictionAtOutlet then
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] =(gasBulk[1].d*geo.Delta_x[1] + gasBulk[2].d*geo.Delta_x[2]/2)/(geo.Delta_x[2]/2 + geo.Delta_x[1])*g_n*(geo.z[2] - geo.z_in);
      Delta_p_grav[3] =gasBulk[2].d*g_n*(geo.z_out - geo.z[2]);
    elseif  frictionAtInlet and not frictionAtOutlet then
      Delta_p_grav[1] =gasBulk[1].d*g_n*(geo.z[1] - geo.z_in);
      Delta_p_grav[2] =(gasBulk[2].d*geo.Delta_x[2] + gasBulk[1].d*geo.Delta_x[1]/2)/(geo.Delta_x[1]/2 + geo.Delta_x[2])*g_n*(geo.z_out - geo.z[1]);
      Delta_p_grav[3] = 0;
      else
      // frictionAtOutlet and frictionAtnlet
      Delta_p_grav[1] =gasBulk[1].d*g_n*(geo.z[1] - geo.z_in);
      Delta_p_grav[2] =(gasBulk[1].d*geo.Delta_x[1] + gasBulk[2].d*geo.Delta_x[2])/(geo.Delta_x[2] + geo.Delta_x[1])*g_n*(geo.z[2] - geo.z[1]);
      Delta_p_grav[3] =gasBulk[2].d*g_n*(geo.z_out - geo.z[2]);
      end if;
  else
    for i in 3:geo.N_cv-1 loop
      Delta_p_grav[i] =(gasBulk[i].d*geo.Delta_x[i] + gasBulk[i - 1].d*geo.Delta_x[i - 1])/(geo.Delta_x[i - 1] + geo.Delta_x[i])*g_n*(geo.z[i] - geo.z[i - 1]);
    end for;

    if frictionAtInlet then
      Delta_p_grav[1] =gasBulk[1].d*g_n*(geo.z[1] - geo.z_in);
      Delta_p_grav[2] =(gasBulk[1].d*geo.Delta_x[1] + gasBulk[2].d*geo.Delta_x[2])/(geo.Delta_x[2] + geo.Delta_x[1])*g_n*(geo.z[2] - geo.z[1]);
      else
      Delta_p_grav[1] = 0;
      Delta_p_grav[2] =(gasBulk[1].d*geo.Delta_x[1] + gasBulk[2].d*geo.Delta_x[2]/2)/(geo.Delta_x[2]/2 + geo.Delta_x[1])*g_n*(geo.z[2] - geo.z_in);
      end if;

    if frictionAtOutlet then
      Delta_p_grav[geo.N_cv+1] =gasBulk[geo.N_cv].d*g_n*(geo.z_out - geo.z[geo.N_cv]);
      Delta_p_grav[geo.N_cv] =(gasBulk[geo.N_cv - 1].d*geo.Delta_x[geo.N_cv - 1] + gasBulk[geo.N_cv].d*geo.Delta_x[geo.N_cv])/(geo.Delta_x[geo.N_cv - 1] + geo.Delta_x[geo.N_cv])*g_n*(geo.z[geo.N_cv] - geo.z[geo.N_cv - 1]);
      else
      Delta_p_grav[geo.N_cv+1] = 0;
      Delta_p_grav[geo.N_cv] =(gasBulk[geo.N_cv - 1].d*geo.Delta_x[geo.N_cv - 1]/2 + gasBulk[geo.N_cv].d*geo.Delta_x[geo.N_cv])/(geo.Delta_x[geo.N_cv - 1]/2 + geo.Delta_x[geo.N_cv])*g_n*(geo.z_out - geo.z[geo.N_cv - 1]);
      end if;
    end if;

  //-------------------------------------------
  //Enthalpy flows
  for i in 2:geo.N_cv loop
    H_flow[i] = if useHomotopy then homotopy(semiLinear(
      m_flow[i],
      mechanicalEquilibrium.h[i - 1],
      mechanicalEquilibrium.h[i]), mechanicalEquilibrium.h[i - 1]*m_flow_nom) else semiLinear(
      m_flow[i],
      mechanicalEquilibrium.h[i - 1],
      mechanicalEquilibrium.h[i]);
  end for;
  H_flow[1] =if useHomotopy then homotopy(semiLinear(
    m_flow[1],
    inStream(gasPortIn.h_outflow),
    mechanicalEquilibrium.h[1]), inStream(gasPortIn.h_outflow)*m_flow_nom) else semiLinear(
    m_flow[1],
    inStream(gasPortIn.h_outflow),
    mechanicalEquilibrium.h[1]);
  H_flow[geo.N_cv + 1] =if useHomotopy then homotopy(semiLinear(
    m_flow[geo.N_cv + 1],
    mechanicalEquilibrium.h[geo.N_cv],
    inStream(gasPortOut.h_outflow)), mechanicalEquilibrium.h[geo.N_cv]*m_flow_nom) else semiLinear(
    m_flow[geo.N_cv + 1],
    mechanicalEquilibrium.h[geo.N_cv],
    inStream(gasPortOut.h_outflow));

  //-------------------------------------------
  //Fluid mass in cells
  mass = if useHomotopy then homotopy(geo.volume .* mechanicalEquilibrium.rho_mix, geo.volume .* rho_nom) else geo.volume .* mechanicalEquilibrium.rho_mix;

  //-------------------------------------------
  // definition of the cells' states:
  for i in 1:geo.N_cv loop

    der(h[i]) = (H_flow[i] - H_flow[i + 1] + heat[i].Q_flow + der(p[i])*geo.volume[i] - h[i]*geo.volume[i]*drhodt[i])/mass[i];
    gasBulk[i].drhodp_hxi*der(p[i]) = (drhodt[i] - der(h[i])*gasBulk[i].drhodh_pxi - sum({gasBulk[i].drhodxi_ph[j]*der(xi[i, j]) for j in 1:medium.nc - 1})) "Calculate pressure from enthalpy and density derivative";

    if massBalance==1 then

      der(xi[i, :]) = 1/mass[i]*((Xi_flow[i, :] -  m_flow[i]*xi[i, :]) - (Xi_flow[i + 1, :] - m_flow[i+1]*xi[i, :])) "Component mass balance";
      drhodt[i]*geo.volume[i] = m_flow[i] - m_flow[i + 1] "Mass balance";

    elseif massBalance==2 then

      //-------Version 1a -> slower version, jumps in veleocity and mass flow rate, but more stable (which is bizarre)
      der(xi[i,:]*mass[i]) = Xi_flow[i,:] - Xi_flow[i+1,:];
      der(mass[i])=m_flow[i]-m_flow[i+1] "Mass balance";

    else
      //-------Version 1b -> is generally faster but might cause simulation failure
      der(xi[i,:]) = (Xi_flow[i,:] - Xi_flow[i+1,:] - xi[i,:]*geo.volume[i]*drhodt[i])/mass[i];
      drhodt[i]*geo.volume[i]=m_flow[i]-m_flow[i+1] "Mass balance";

      //-------Version 2 -> mass fractions won't change as expected
      //der(xi[i,:])=1/mass[i]*(Xi_flow[i,:] - Xi_flow[i+1,:]);
      //drhodt[i]*geo.volume[i]=m_flow[i]-m_flow[i+1] "Mass balance";

    end if;

  end for;

  //-------------------------------------------
  // Static momentum balance:
  // notice that for a static momentum balance we need to apply the same balance as homotopy start equation. Otherwise the equations become trivial.
  // For now we leave the homotopy inside for future development
  for i in 2:geo.N_cv loop
    0 = if useHomotopy then homotopy(p[i - 1] - p[i] - Delta_p_fric[i] - Delta_p_grav[i], p[i - 1] - p[i] - Delta_p_fric[i] - Delta_p_grav[i]) else p[i - 1] - p[i] - Delta_p_fric[i] - Delta_p_grav[i];
  end for;
  0 =if useHomotopy then homotopy(gasPortIn.p - p[1] - Delta_p_fric[1] - Delta_p_grav[1], gasPortIn.p - p[1] - Delta_p_fric[1] - Delta_p_grav[1]) else gasPortIn.p - p[1] - Delta_p_fric[1] - Delta_p_grav[1];
  0 =if useHomotopy then homotopy(p[geo.N_cv] - gasPortOut.p - Delta_p_fric[geo.N_cv + 1] - Delta_p_grav[geo.N_cv + 1], p[geo.N_cv] - gasPortOut.p - Delta_p_fric[geo.N_cv + 1] - Delta_p_grav[geo.N_cv + 1]) else p[geo.N_cv] - gasPortOut.p - Delta_p_fric[geo.N_cv + 1] - Delta_p_grav[geo.N_cv + 1];

  gasPortIn.h_outflow = mechanicalEquilibrium.h[1];
  gasPortOut.h_outflow = mechanicalEquilibrium.h[geo.N_cv];

  //-------------------------------------------
  //species balance

   for i in 2:geo.N_cv loop
     Xi_flow[i, :] = if useHomotopy then homotopy(semiLinear(
       m_flow[i],
       (xi[i - 1, :]),
       (xi[i, :])), (xi[i - 1, :])*m_flow_nom) else semiLinear(
       m_flow[i],
       (xi[i - 1, :]),
       (xi[i, :]));
   end for;
   Xi_flow[1, :] =if useHomotopy then homotopy(semiLinear(
    m_flow[1],
    (gasIn.xi[:]),
    (xi[1, :])), (gasIn.xi[:])*m_flow_nom) else semiLinear(
    m_flow[1],
    (gasIn.xi[:]),
    (xi[1, :]));
   Xi_flow[geo.N_cv + 1, :] =if useHomotopy then homotopy(semiLinear(
    m_flow[geo.N_cv + 1],
    (xi[geo.N_cv, :]),
    (gasOut.xi[:])), (xi[geo.N_cv, :])*m_flow_nom) else semiLinear(
    m_flow[geo.N_cv + 1],
    (xi[geo.N_cv, :]),
    (gasOut.xi[:]));
  gasPortIn.xi_outflow[:] = xi[1, :];
  gasPortOut.xi_outflow[:] = xi[geo.N_cv, :];


  xi_inlet =noEvent(actualStream(gasPortIn.xi_outflow));
  xi_outlet =noEvent(actualStream(gasPortOut.xi_outflow));

  annotation (defaultComponentName="volume",Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-50},
            {140,50}}),
                   graphics),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-140,-50},{140,50}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">A 1D tube-shaped control volume considering one-phase and two-phase heat transfer and Pressure Loss in a straight pipe with static momentum balance and simple energy balance. It is a modified version of the model ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L4 from ClaRa version 1.3.0. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">L4, Discretisation of the pipe Length. Is able to use real gas mixtures (VLEFluids).</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Considers the time delay of the change of the mass fraction from inlet to outlet.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Compared to the ClaRa version, the simCenter, media model and connectors were exchanged for TransiEnt instances. The two-phase region is deactivated and a xi_nom is added. steamQuality and showExpertSummary were left out and the summary can be found in the corresponding pipe model PipeFlow_L4_simple_varXi.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">-</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">RealGasPorts</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">-</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: Courier New; color: #0000ff;\">if&nbsp;</span><span style=\"font-family: Courier New;\">massBalance==1</span><span style=\"font-family: Courier New; color: #0000ff;\">&nbsp;then</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style=\"font-family: Courier New;color: #006400;\">//-------ClaRa formulation</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style=\"font-family: Courier New;color: #ff0000;\">der</span>(xi[i,&nbsp;:])&nbsp;=&nbsp;1/mass[i]*((Xi_flow[i,&nbsp;:]&nbsp;-&nbsp;&nbsp;m_flow[i]*xi[i,&nbsp;:])&nbsp;-&nbsp;(Xi_flow[i&nbsp;+&nbsp;1,&nbsp;:]&nbsp;-&nbsp;m_flow[i+1]*xi[i,&nbsp;:]));</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;drhodt[i]*geo.volume[i]&nbsp;=&nbsp;m_flow[i]&nbsp;-&nbsp;m_flow[i&nbsp;+&nbsp;1];</span></p>
<p><br><span style=\"font-family: Courier New; color: #0000ff;\">elseif&nbsp;</span></span><span style=\"font-family: Courier New;\">massBalance==2</span><span style=\"font-family: Courier New; color: #0000ff;\">&nbsp;then</span></p>
<p><br><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style=\"font-family: Courier New;color: #006400;\">//-------TransiEnt formulation Version&nbsp;1a&nbsp;-&gt;&nbsp;slower&nbsp;version,&nbsp;jumps&nbsp;in&nbsp;veleocity&nbsp;and&nbsp;mass&nbsp;flow&nbsp;rate,&nbsp;but&nbsp;more&nbsp;stable&nbsp;(which&nbsp;is&nbsp;bizarre)</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font-family: Courier New;span style=\"color: #ff0000;\">der</span></span><span style=\"font-family: Courier New;\">(xi[i,:]*mass[i])&nbsp;=&nbsp;Xi_flow[i,:]&nbsp;-&nbsp;Xi_flow[i+1,:];</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font-family: Courier New;span style=\"color: #ff0000;\">der</span></span><span style=\"font-family: Courier New;\">(mass[i])=m_flow[i]-m_flow[i+1];</span></p>
<p><br><span style=\"font-family: Courier New; color: #0000ff;\">else</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style=\"font-family: Courier New;color: #006400;\">//-------TransiEnt formulation Version&nbsp;1b&nbsp;-&gt;&nbsp;is&nbsp;generally&nbsp;faster&nbsp;but&nbsp;might&nbsp;cause&nbsp;simulation&nbsp;failure</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style=\"color: #ff0000;\">der</span>(xi[i,:])&nbsp;=&nbsp;(Xi_flow[i,:]&nbsp;-&nbsp;Xi_flow[i+1,:]&nbsp;-&nbsp;xi[i,:]*geo.volume[i]*drhodt[i])/mass[i];</span></p>
<p><span style=\"font-family: Courier New;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;drhodt[i]*geo.volume[i]=m_flow[i]-m_flow[i+1];</span></p>
<p><br><span style=\"font-family: Courier New; color: #0000ff;\">end&nbsp;if</span>;</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p>-</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>-</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">copied and changed from ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L4</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Tom Lindemann (tom.lindemann@tuhh.de), Jun 2015</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified by Carsten Bode (c.bode@tuhh.de), Okt 2015</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified by Lisa Andresen (andresen@tuhh.de), May 2016</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Revised by Carsten Bode (c.bode@tuhh.de), Apr 2018 (updated to ClaRa 1.3.0)</span></p>
</html>"));
end VolumeRealGas_L4_varXi;
