within TransiEnt.Components.Gas.VolumesValvesFittings.Base;
model VolumeRealGas_L4 "A 1D tube-shaped control volume considering one-phase heat transfer in a straight pipe with static momentum balance and simple energy balance"

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
// Modified component of the ClaRa library, version: 1.3.0
// Path: ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L4
// Modifications: simCenter, media models, connectors changed to TransiEnt instances
// two-phase region deactivated
// added different mass balances (choosable with massBalance)
// added xi_nom, m_flow_start
// added w_inlet, w_outlet, medium, xi, x in summary
// added possibility to give temperature start value instead of specific enthalpy
// combined models for variable and constant composition
// added mass quasi-stationary mass balance and mass balances for dependent mass fractions

  extends ClaRa.Basics.Icons.Volume_L4;
  extends ClaRa.Basics.Icons.ComplexityLevel(complexity="L4");
  import SI = ClaRa.Basics.Units;
  import Modelica.Constants.eps;
  import Modelica.Constants.g_n "gravity constant";
  import ClaRa.Basics.Functions.Stepsmoother;
  import Modelica.Math.Vectors.find;
  import TransiEnt.Basics.Functions.findSetDifference;

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
    input ClaRa.Basics.Units.Velocity w[N_cv+1] if showExpertSummary "Velocity of flow in cells" annotation (Dialog(show));
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
 parameter Boolean constantComposition=simCenter.useConstCompInGasComp "true if composition of gas in the pipe is constant (xi_nom will be used)" annotation(Dialog(group="Fundamental Definitions"));
 parameter Integer variableCompositionEntries[:](min=0,max=medium.nc)={0} "Entries of medium vector which are supposed to be completely variable" annotation(Dialog(group="Fundamental Definitions",enable=not constantComposition));
 final parameter Integer dependentCompositionEntries[:]=if variableCompositionEntries[1] == 0 then 1:medium.nc else findSetDifference(1:medium.nc, variableCompositionEntries) "Entries of medium vector which are supposed to be dependent on the variable entries";
 parameter Integer massBalance=1 "Mass balance and species balance fomulation" annotation(Dialog(group="Fundamental Definitions"),choices(choice=1 "ClaRa formulation", choice=2 "TransiEnt formulation 1a", choice=3 "TransiEnt formulation 1b", choice=4 "Quasi stationary"));

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
  final parameter ClaRa.Basics.Units.DensityMassSpecific rho_nom[geo.N_cv]=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.density_phxi(
      medium,
      p_nom,
      h_nom,
      xi_nom) "Nominal density";

//____Initialisation_____________________________________________________________________________________
  inner parameter Integer  initOption=0 "Type of initialisation" annotation(Dialog(tab="Initialisation"), choices(choice = 0 "Use guess values", choice = 208 "Steady pressure and enthalpy", choice=201 "Steady pressure", choice = 202 "Steady enthalpy", choice=210 "Steady density"));
  inner parameter Boolean useHomotopy=simCenter.useHomotopy "true, if homotopy method is used during initialisation" annotation(Dialog(tab="Initialisation",group="Model Settings"));
  parameter ClaRa.Basics.Units.EnthalpyMassSpecific h_start[geo.N_cv]=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(medium,p_start,T_start,xi_start) "Initial specific enthalpy for single tube"
                                                                                                                                                                                                        annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.Pressure p_start[geo.N_cv]=p_nom "Initial pressure"
                                                                                  annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFraction xi_start[medium.nc - 1]=xi_nom "Initial composition for single tube"
                                                                                                                annotation(Dialog(tab="Initialisation"));
  parameter ClaRa.Basics.Units.MassFlowRate m_flow_start[geo.N_cv+1]=m_flow_nom*ones(geo.N_cv+1) "Initial mass flow rate" annotation(Dialog(tab="Initialisation"));
  parameter Modelica.SIunits.Temperature T_start[geo.N_cv]=ones(geo.N_cv)*simCenter.T_ground "Initial temperature for single tube (used in calculation of h_start)" annotation(Dialog(tab="Initialisation"));
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
      w=w_FM,
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
  ClaRa.Basics.Units.EnthalpyMassSpecific h[geo.N_cv](start=h_start, each stateSelect=StateSelect.prefer) "Cell enthalpy";

  //____Pressure__________________________________________________________________________________________________
protected
  ClaRa.Basics.Units.Pressure p[geo.N_cv](start=p_start_internal, each stateSelect=if massBalance==4 then StateSelect.never else StateSelect.always) "Cell pressure";
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

  ClaRa.Basics.Units.DensityMassSpecific[geo.N_cv + 1] rho_FM "Density at flow model states";

  ClaRa.Basics.Units.MassFraction steamQuality[geo.N_cv] "Steam fraction";
  ClaRa.Basics.Units.MassFraction steamQuality_inlet "Steam fraction";
  ClaRa.Basics.Units.MassFraction steamQuality_outlet "Steam fraction";

  //____Mass Fractions____________________________________________________________________________________________
  Modelica.SIunits.MassFraction xi[geo.N_cv,medium.nc - 1](stateSelect={if find(j, dependentCompositionEntries) == 0 then StateSelect.always else StateSelect.never for j in 1:medium.nc - 1,i in 1:geo.N_cv}) "Mass fraction";
  Modelica.SIunits.MassFraction xi_end[geo.N_cv]=ones(geo.N_cv)-sum(xi[:,i] for i in 1:medium.nc-1) "Last entry of mass fraction";
  Real[geo.N_cv + 1, medium.nc - 1] Xi_flow "Mass flow rate of fraction";
  Real[geo.N_cv + 1] Xi_flow_end "Mass flow rate of last fraction";
  Modelica.SIunits.MassFraction xi_inlet[medium.nc - 1] "Inlet mass fraction of component";
  Modelica.SIunits.MassFraction xi_inlet_end=1-sum(xi_inlet) "Inlet mass fraction of last component";
  Modelica.SIunits.MassFraction xi_outlet[medium.nc - 1] "Outlet mass fraction of component";
  Modelica.SIunits.MassFraction xi_outlet_end=1-sum(xi_outlet) "Outlet mass fraction of last component";
  //____Flows and Velocities______________________________________________________________________________________
  ClaRa.Basics.Units.Power H_flow[geo.N_cv + 1] "Enthalpy flow rate at cell borders";
  ClaRa.Basics.Units.MassFlowRate m_flow[geo.N_cv + 1](start=m_flow_start);
  ClaRa.Basics.Units.Velocity w[geo.N_cv] "flow velocities within cells of energy model == flow velocities across cell borders of flow model ";
  ClaRa.Basics.Units.Velocity w_inlet "flow velocity at inlet";
  ClaRa.Basics.Units.Velocity w_outlet "flow velocity at outlet";
  ClaRa.Basics.Units.Velocity w_FM[geo.N_cv + 1] "flow velocities within cells of flow model == flow velocities across cell borders of energy model ";

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
  inner TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasBulk[geo.N_cv](
    each computeSurfaceTension=false,
    p=p,
    h=h,
    each vleFluidType=medium,
    each computeTransportProperties=true,
    each deactivateTwoPhaseRegion=true,
    xi=xi) annotation (Placement(transformation(extent={{-10,-40},{10,-20}}, rotation=0)));

  inner TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasIn(
    computeSurfaceTension=false,
    p=gasPortIn.p,
    vleFluidType=medium,
    h=noEvent(actualStream(gasPortIn.h_outflow)),
    computeTransportProperties=true,
    deactivateTwoPhaseRegion=true,
    xi=xi_inlet) annotation (Placement(transformation(extent={{-90,-30},{-70,-10}}, rotation=0)));

  inner TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_ph gasOut(
    computeSurfaceTension=false,
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
  elseif initOption == 210 then
    drhodt = zeros(geo.N_cv);
  elseif initOption == 0 then
    // do nothing
  else
    assert(false, "Unknown init option in " + getInstanceName());
  end if;

  if not constantComposition and not massBalance==4 then
    if variableCompositionEntries[1]<>0 then
      for i in 1:geo.N_cv loop
        for j in variableCompositionEntries loop
          if j<>medium.nc then
            xi[i, j] = xi_start[j];
          else
            xi_end[i] = 1-sum(xi_start);
          end if;
        end for;
      end for;
    else
      for i in 1:geo.N_cv loop
        xi[i, :] = xi_start[1:end];
      end for;
    end if;
  end if;
equation

  connect(heat, heatTransfer.heat) annotation (Line(
      points={{0,40},{0,28},{-61,28},{-61,19}},
      color={0,0,0},
      smooth=Smooth.None));

  //-------------------------------------------
  //flow velocities at gasPortIn and gasPortOut
  w_inlet =gasPortIn.m_flow/(geo.A_cross_FM[1]*gasIn.d);
  w_outlet =-gasPortOut.m_flow/(geo.A_cross_FM[geo.N_cv + 1]*gasOut.d);

  //steam quality at inlet and outlet
  steamQuality_inlet =gasIn.q;
  steamQuality_outlet =gasOut.q;

  for i in 1:geo.N_cv loop
     //flow velocities in energy cells
    w[i] =(m_flow[i] + m_flow[i + 1])/(2*gasBulk[i].d*geo.A_cross[i]);
    //steam quality in cells
    steamQuality[i] =gasBulk[i].q;
  end for;

  //flow velocities in flow model
  for i in 1:geo.N_cv+1 loop
     w_FM[i]=m_flow[i]/(geo.A_cross_FM[i]*rho_FM[i]);
  end for;

  //density in flow model
  for i in 2:geo.N_cv loop
    rho_FM[i]=(gasBulk[i].d+gasBulk[i-1].d)/2;
  end for;

  //density in first and last momentum cell
  rho_FM[1]=(gasIn.d+gasBulk[1].d)/2;
  rho_FM[geo.N_cv+1]=(gasOut.d+gasBulk[geo.N_cv].d)/2;

  //-------------------------------------------
  //data exchange with friction model
  m_flow[1] =gasPortIn.m_flow;
  m_flow = pressureLoss.m_flow;
  m_flow[geo.N_cv + 1] =-gasPortOut.m_flow;

  //-------------------------------------------
  //data exchange with replaceable models
  heatTransfer.m_flow = m_flow;
  mechanicalEquilibrium.m_flow = m_flow;

  //-------------------------------------------
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

    if massBalance==4 then //quasi stationary

      drhodt[i]=0;
      0=m_flow[i]-m_flow[i+1] "Mass balance";

      if constantComposition then
        xi[i, :] = xi_nom;
      else
        xi[i, :] = noEvent(actualStream(gasPortIn.xi_outflow));
      end if;

    else

      if constantComposition then

        gasBulk[i].drhodp_hxi*der(p[i]) = (drhodt[i] - der(h[i])*gasBulk[i].drhodh_pxi) "Calculate pressure from enthalpy and density derivative";
        xi[i, :] = xi_nom;
        drhodt[i]*geo.volume[i]=m_flow[i]-m_flow[i+1] "Mass balance";

      else

        gasBulk[i].drhodp_hxi*der(p[i]) = (drhodt[i] - der(h[i])*gasBulk[i].drhodh_pxi - sum({gasBulk[i].drhodxi_ph[j]*der(xi[i, j]) for j in 1:medium.nc - 1})) "Calculate pressure from enthalpy and density derivative";

        if massBalance==1 then

          if variableCompositionEntries[1] == 0 then //all components are considered fully variable
            der(xi[i, :]) = 1/mass[i]*((Xi_flow[i, :] - m_flow[i]*xi[i, :]) - (Xi_flow[i + 1, :] - m_flow[i + 1]*xi[i, :])) "Component mass balance";
          else
            if variableCompositionEntries[end] == medium.nc then //the last component is considered fully variable and the last dependent entry is left out instead
              for j in variableCompositionEntries[1:end-1] loop
                der(xi[i, j]) = 1/mass[i]*((Xi_flow[i, j] - m_flow[i]*xi[i, j]) - (Xi_flow[i + 1, j] - m_flow[i + 1]*xi[i, j])) "Component mass balance";
              end for;
              der(xi_end[i]) = 1/mass[i]*((Xi_flow_end[i] - m_flow[i]*xi_end[i]) - (Xi_flow_end[i + 1] - m_flow[i + 1]*xi_end[i])) "Component mass balance";
              for j in dependentCompositionEntries[1:end - 1] loop
                xi[i, j] = (1 - (sum(xi[i, k] for k in variableCompositionEntries[1:end - 1]) + xi_end[i]))/(1 - (sum(xi_nom[k] for k in variableCompositionEntries[1:end - 1]) + 1 - sum(xi_nom)))*xi_nom[j];
              end for;
            else //the last component is calculated from the sum of the remaining
              for j in variableCompositionEntries loop
                der(xi[i, j]) = 1/mass[i]*((Xi_flow[i, j] - m_flow[i]*xi[i, j]) - (Xi_flow[i + 1, j] - m_flow[i + 1]*xi[i, j])) "Component mass balance";
              end for;
              for j in dependentCompositionEntries[1:end-1] loop
                xi[i, j] = (1 - sum(xi[i, k] for k in variableCompositionEntries))/(1 - sum(xi_nom[k] for k in variableCompositionEntries))*xi_nom[j];
              end for;
            end if;
          end if;

          drhodt[i]*geo.volume[i] = m_flow[i] - m_flow[i + 1] "Mass balance";

        elseif massBalance==2 then

          //-------Version 1a -> slower version, jumps in veleocity and mass flow rate, but more stable (which is bizarre)
          if variableCompositionEntries[1] == 0 then
            der(xi[i, :]*mass[i]) = Xi_flow[i, :] - Xi_flow[i + 1, :];
          else
            if variableCompositionEntries[end] == medium.nc then //the last component is considered fully variable and the last dependent entry is left out instead
              for j in variableCompositionEntries[1:end-1] loop
                der(xi[i, j]*mass[i]) = Xi_flow[i, j] - Xi_flow[i + 1, j];
              end for;
              der(xi_end[i]*mass[i]) = Xi_flow_end[i] - Xi_flow_end[i + 1];
              for j in dependentCompositionEntries[1:end - 1] loop
                xi[i, j] = (1 - (sum(xi[i, k] for k in variableCompositionEntries[1:end - 1]) + xi_end[i]))/(1 - (sum(xi_nom[k] for k in variableCompositionEntries[1:end - 1]) + 1 - sum(xi_nom)))*xi_nom[j];
              end for;
            else //the last component is calculated from the sum of the remaining
              for j in variableCompositionEntries loop
                der(xi[i, j]*mass[i]) = Xi_flow[i, j] - Xi_flow[i + 1, j];
              end for;
              for j in dependentCompositionEntries[1:end-1] loop
                xi[i, j] = (1 - sum(xi[i, k] for k in variableCompositionEntries))/(1 - sum(xi_nom[k] for k in variableCompositionEntries))*xi_nom[j];
              end for;
            end if;
          end if;

          der(mass[i])=m_flow[i]-m_flow[i+1] "Mass balance";

        else
          //-------Version 1b -> is generally faster but might cause simulation failure
          if variableCompositionEntries[1] == 0 then
            der(xi[i,:]) = (Xi_flow[i,:] - Xi_flow[i+1,:] - xi[i,:]*geo.volume[i]*drhodt[i])/mass[i];
          else
            if variableCompositionEntries[end] == medium.nc then //the last component is considered fully variable and the last dependent entry is left out instead
              for j in variableCompositionEntries[1:end-1] loop
                der(xi[i,j]) = (Xi_flow[i,j] - Xi_flow[i+1,j] - xi[i,j]*geo.volume[i]*drhodt[i])/mass[i];
              end for;
              der(xi_end[i]) = (Xi_flow_end[i] - Xi_flow_end[i+1] - xi_end[i]*geo.volume[i]*drhodt[i])/mass[i];
              for j in dependentCompositionEntries[1:end - 1] loop
                xi[i, j] = (1 - (sum(xi[i, k] for k in variableCompositionEntries[1:end - 1]) + xi_end[i]))/(1 - (sum(xi_nom[k] for k in variableCompositionEntries[1:end - 1]) + 1 - sum(xi_nom)))*xi_nom[j];
              end for;
            else //the last component is calculated from the sum of the remaining
              for j in variableCompositionEntries loop
                der(xi[i,j]) = (Xi_flow[i,j] - Xi_flow[i+1,j] - xi[i,j]*geo.volume[i]*drhodt[i])/mass[i];
              end for;
              for j in dependentCompositionEntries[1:end-1] loop
                xi[i, j] = (1 - sum(xi[i, k] for k in variableCompositionEntries))/(1 - sum(xi_nom[k] for k in variableCompositionEntries))*xi_nom[j];
              end for;
            end if;
          end if;

          drhodt[i]*geo.volume[i]=m_flow[i]-m_flow[i+1] "Mass balance";

          //-------Version 2 -> mass fractions won't change as expected
          //der(xi[i,:])=1/mass[i]*(Xi_flow[i,:] - Xi_flow[i+1,:]);
          //drhodt[i]*geo.volume[i]=m_flow[i]-m_flow[i+1] "Mass balance";

        end if;

      end if;

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

  if constantComposition or massBalance==4 then
    for i in 1:geo.N_cv+1 loop
      Xi_flow[i,:]=noEvent(actualStream(gasPortIn.xi_outflow))*m_flow[i];
    end for;
    Xi_flow_end=noEvent(1-sum(actualStream(gasPortIn.xi_outflow)))*m_flow;

    gasPortIn.xi_outflow[:] = inStream(gasPortOut.xi_outflow);
    gasPortOut.xi_outflow[:] = inStream(gasPortIn.xi_outflow);
  else
    for i in 2:geo.N_cv loop
      Xi_flow[i, :] = if useHomotopy then homotopy(semiLinear(
        m_flow[i],
        (xi[i - 1, :]),
        (xi[i, :])), (xi[i - 1, :])*m_flow_nom) else semiLinear(
        m_flow[i],
        (xi[i - 1, :]),
        (xi[i, :]));
      Xi_flow_end[i] = if useHomotopy then homotopy(semiLinear(
        m_flow[i],
        (xi_end[i - 1]),
        (xi_end[i])), (xi_end[i - 1])*m_flow_nom) else semiLinear(
        m_flow[i],
        (xi_end[i - 1]),
        (xi_end[i]));
    end for;
    Xi_flow[1, :] = if useHomotopy then homotopy(semiLinear(
      m_flow[1],
      (gasIn.xi[:]),
      (xi[1, :])), (gasIn.xi[:])*m_flow_nom) else semiLinear(
      m_flow[1],
      (gasIn.xi[:]),
      (xi[1, :]));
    Xi_flow_end[1] = if useHomotopy then homotopy(semiLinear(
      m_flow[1],
      (xi_inlet_end),
      (xi_end[1])), (xi_inlet_end)*m_flow_nom) else semiLinear(
      m_flow[1],
      (xi_inlet_end),
      (xi_end[1]));
    Xi_flow[geo.N_cv + 1, :] = if useHomotopy then homotopy(semiLinear(
      m_flow[geo.N_cv + 1],
      (xi[geo.N_cv, :]),
      (gasOut.xi[:])), (xi[geo.N_cv, :])*m_flow_nom) else semiLinear(
      m_flow[geo.N_cv + 1],
      (xi[geo.N_cv, :]),
      (gasOut.xi[:]));
    Xi_flow_end[geo.N_cv + 1] = if useHomotopy then homotopy(semiLinear(
      m_flow[geo.N_cv + 1],
      (xi_end[geo.N_cv]),
      (xi_outlet_end)), (xi_end[geo.N_cv])*m_flow_nom) else semiLinear(
      m_flow[geo.N_cv + 1],
      (xi_end[geo.N_cv]),
      (xi_outlet_end));

    gasPortIn.xi_outflow[:] = xi[1, :];
    gasPortOut.xi_outflow[:] = xi[geo.N_cv, :];

  end if;

  xi_inlet =noEvent(actualStream(gasPortIn.xi_outflow));
  xi_outlet =noEvent(actualStream(gasPortOut.xi_outflow));

  annotation (defaultComponentName="volume",Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-60},
            {140,60}}),
                   graphics={Text(
          extent={{-130,50},{-30,10}},
          lineColor={238,46,47},
          textString=if constantComposition then "constXi" else "varXi")}),
        Diagram(graphics,
                coordinateSystem(preserveAspectRatio=false,
          extent={{-140,-60},{140,60}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">A 1D tube-shaped control volume considering one-phase and two-phase heat transfer and Pressure Loss in a straight pipe with static momentum balance and simple energy balance. It is a modified version of the model ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L4 from ClaRa version 1.3.0. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The pipe can be discretized in the length direction (L4). It uses real gas mixtures (VLEFluids).</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">It can be chosen if changes in the composition shall be considered or not. In the first case, it considers the time delay of the change of the mass fraction from inlet to outlet.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Compared to the ClaRa version, the simCenter, media model and connectors were exchanged for TransiEnt instances. The two-phase region is deactivated and a xi_nom as well as an m_flow_start is added. Also, different mass balance equations are added. You can choose a quasi-stationary and three different dynamic implementations, see below. Additionally, the parameter </span><span style=\"font-family: Courier New;\">variableCompositionEntries </span>can be used in case that not all components are freely variable, e.g. when hydrogen is fed into natural gas.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks) </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">RealGasPorts</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks) </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><b>Velocity at inlet and outlet: </b></p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-lk3fBRGh.png\" alt=\"w_inlet=m_flow/(A_cross_FM*rho_inlet)\"/></p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-Xu4fGSXc.png\" alt=\"w_outlet=m_flow/(A_cross_FM*rho_outlet)\"/></p>
<p>flow velocity in energy cells:</p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-6hdUP7aO.png\" alt=\"w[i]=(m_flow[i]+m_flow[i+1])/(2*rho*A_cross)\"/>, for&nbsp;i&nbsp;in&nbsp;1:N_cv (number of control volumes)</p>
<p><b>Density in flow model:</b></p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-lr3r9kkw.png\" alt=\"rho_FM[i]=(rho[i]+rho[i-1])/2\"/>,for i in 2:N_cv</p>
<p>and the density in the first and last momentum cell:</p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-SdWVxCFe.png\" alt=\"rho_FM[1]=(rho_in+rho[1])/2\"/></p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-MNE1D0m6.png\" alt=\"rho_FM[N_cv+1]=(rho_out+rho[N_cv])/2\"/></p>
<p><b>Pressure drop due to friction and gravity: </b></p>
<p><br><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-sUaB12zf.png\" alt=\"Delta_p_grav[i] =(rho[i]*Delta_x[i] +rho[i-1]*Delta_x[i - 1])/(Delta_x[i - 1] + Delta_x[i])*g_n*(z[i] - z[i - 1])\"/>, for i in 3: N_cv-1</p>
<p>If there is friction at the inlet:</p>
<p><br><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-2yHwORzo.png\" alt=\"Delta_p_grav[1] =rho[1]*g_n*(z[1] - z_in)
    \"/></p>
<p><br><br><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-9xLaxLsk.png\" alt=\"Delta_p_grav[2] =(rho[1]*Delta_x[1] + rho[2]*Delta_x[2])/(Delta_x[2] +Delta_x[1])*g_n*(.z[2] - z[1])\"/></p>
<p>If there is no friction at the inlet:</p>
<p><br><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-Df4rC8tX.png\" alt=\"Delta_p_grav[1] = 0\"/></p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-bfjV5v9r.png\" alt=\"Delta_p_grav[2] =(rho[1]*Delta_x[1] + rho[2]*Delta_x[2]/2)/(Delta_x[2]/2 +Delta_x[1])*g_n*(z[2] - z_in)\"/></p>
<p>If there is friction at the outlet:</p>
<p><br><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-FFWU6G3c.png\" alt=\" Delta_p_grav[N_cv+1] =rho[N_cv]*g_n*(z_out - z[N_cv])\"/></p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-IJqboncH.png\" alt=\"Delta_p_grav[N_cv] =(rho[N_cv-1]*Delta_x[N_cv - 1] +rho[N_cv]*Delta_x[N_cv])/(Delta_x[N_cv - 1] +.Delta_x[N_cv])*g_n*(.z[N_cv] - z[N_cv - 1])\"/></p>
<p>If there is no friction at the outlet:</p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-wtsOsr8g.png\" alt=\"Delta_p_grav[N_cv+1] = 0\"/></p>
<p><br><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-nbrkl7Re.png\" alt=\"Delta_p_grav[N_cv] =(rho[N_cv-1]*Delta_x[N_cv - 1]/2 + rho[N_cv]*Delta_x[N_cv])/(Delta_x[N_cv - 1]/2 + Delta_x[N_cv])*g_n*(z_out - z[N_cv - 1])\"/></p>
<p><b>Fluid mass:</b></p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-tHmriWOx.png\" alt=\"m = V* rho_mix\"/></p>
<p><b>Equations for calculating the cell states:</b></p>
<p>The model differentiates between four different kind of mass balances and a constant or variable composition. </p>
<p><b>Quasi-stationary:</b></p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-86155oZs.png\" alt=\"0=der(rho[i])\"/>, for i in 1:N_cv</p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-ehaC3cjj.png\" alt=\"0=m_flow[i]-m_flow[i+1]\"/>, for&nbsp;i&nbsp;in&nbsp;1:N_cv</p>
<p><b>Dynamic:</b></p>
<p>Here, you can pick three different mathematically identical equations which are treated differently numerically. In the following, only the mathematical notation of the general equations is shown.</p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-JSjwXV28.png\" alt=\"der(rho[i])*V[i]=m_flow[i]-m_flow[i+1]\"/>, for&nbsp;i&nbsp;in&nbsp;1:N_cv</p>
<p>For all components considered fully variable:</p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-sq9S9I4M.png\" alt=\"der(xi[i, j]) = 1/m[i]*((Xi_flow[i, j] - m_flow[i]*xi[i, j]) - (Xi_flow[i + 1, j] - m_flow[i + 1]*xi[i, j]))\"/>, for i in 1:N_cv and for j in 1:nc-1 (number of components -1)</p>
<p>For the components which are dependent on other components:</p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-QWUBxrTR.png\" alt=\"xi[i, j] = (1 - (sum(xi[i, k] for k in variableCompositionEntries[1:end - 1]) + xi_end[i]))/(1 - (sum(xi_nom[k] for k in variableCompositionEntries[1:end - 1]) + 1 - sum(xi_nom)))*xi_nom[j]\"/>, for&nbsp;j&nbsp;in&nbsp;dependentCompositionEntries[1:end&nbsp;-&nbsp;1]<span style=\"font-family: Courier New;\"> </span>and for&nbsp;i&nbsp;in&nbsp;1:geo.N_cv<span style=\"font-family: Courier New;\"> </span></p>
<p>For constant composition:</p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-ufdzjjtt.png\" alt=\"xi[i, j] = xi[j,nom]\"/>, for i in 1:N_cv and for j in 1:nc-1</p>
<p><b>Static&nbsp;momentum&nbsp;balance in the momentum cells:</b></p>
<p><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-4kjShBEy.png\" alt=\" 0 = p[i - 1] - p[i] - Delta_p_fric[i] - Delta_p_grav[i]\"/> , for i in 2:N_cv</p>
<p>and for the first and last momentum cell</p>
<p><br><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-Mu3mP7U9.png\" alt=\"0 =p_in - p[1] - Delta_p_fric[1] - Delta_p_grav[1]\"/></p>
<p><br><img src=\"modelica://TransiEnt/Resources/Images/equations/equation-XDKUC6XQ.png\" alt=\"0 = p[N_cv] - p_out - Delta_p_fric[N_cv + 1] - Delta_p_grav[N_cv + 1]\"/></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p>Use of certain heat transfer models can lead to warnings like &quot;Differentiating (if pipe_xy.iCom.m_flow_in[1] &gt; 0.0 then junction_beforePipe.gasBulk.xi[1] else junction_beforePipe.gasBulk.xi[1]) under the assumption that it is continuous at switching.&quot;. This can be ignored as long as the composition is set to the same value in every component (even in sinks etc.).</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks) </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">copied and changed from ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_L4, v1.3.0</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Tom Lindemann (tom.lindemann@tuhh.de), Jun 2015</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified by Carsten Bode (c.bode@tuhh.de), Okt 2015</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified by Lisa Andresen (andresen@tuhh.de), May 2016</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Revised by Carsten Bode (c.bode@tuhh.de), Apr 2018 (updated to ClaRa 1.3.0)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified by Carsten Bode (c.bode@tuhh.de), Feb 2019 (added temperature start value)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified by Carsten Bode (c.bode@tuhh.de), Sep 2019 (merged constXi and varXi models)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified by Carsten Bode (c.bode@tuhh.de), May 2020 (added quasi-stationary equations and simplified equations for only dependent mass fractions)</span></p>
</html>"));
end VolumeRealGas_L4;
