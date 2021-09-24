within TransiEnt.Producer.Electrical.Conventional.Components;
model NonlinearThreeStatePlant "Slew Rate limited (=nonlinear), Minimum power limited (shuts down below minimum power), with primary and secondary balancing controller where secondary balancing power is lumped inside"


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

  extends TransiEnt.Producer.Electrical.Base.PartialDispatchablePowerPlant(m_flow_gas_CDE_deposited=gain.y);
  extends TransiEnt.Producer.Electrical.Base.ControlPower.PartialBalancingPowerProvider(
    final P_n=P_el_n,
    final typeOfBalancingPowerResource=typeOfResource,
    primaryBalancingController(P_n=P_el_n, useHomotopyVarSlewRateLim=useHomotopyVarSlewRateLim,
      use_SlewRateLimiter=powerGradLimChoice == TransiEnt.Components.Turbogroups.Base.GradientLimitingChoices.GradLimInCntrl),
    redeclare Base.ControlPower.PrimarySecondaryAndSchedule controlPowerModel(
      P_pr_max=primaryBalancingController.P_pr_max,
      P_el_is=P_el_is,
      P_grad_max_star=P_el_grad_max_SB,
      is_running=is_running,
      P_PB_set=primaryBalancingController.P_PBP_set,
      P_SB_set=P_SB_set_internal,
      final P_n=P_el_n),
    redeclare TransiEnt.Components.Sensors.MechanicalFrequency gridFrequencySensor(isDeltaMeasurement=true),
    isPrimaryControlActive=true,
    isSecondaryControlActive=false,
    isExternalSecondaryController=true,
    P_el_grad_max_SB=P_grad_max_star*P_el_n);

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  // **** Physical Constraints and Inititalization

  parameter Boolean set_P_init=true "Use of P_init or calculation of P_init from grid (CPP)" annotation(Dialog(group="Initialization"));

  parameter Real P_init_set=P_el_n "Initial or guess value of turbine power"
                                                                          annotation(Dialog(group="Initialization", enable=set_P_init));

  parameter Real P_min_star=0.2 "Fraction of nominal power (=20% of nominal power)" annotation(Dialog(group="Physical Constraints"));

  parameter Real P_max_star=1 "Fraction of nominal power (=100% of nominal power)"
                                                                                  annotation(Dialog(group="Physical Constraints"));
 // parameter Real P_max_star(fixed=false) "Fraction of nominal power (=100% of nominal power)"annotation(Dialog(group="Physical Constraints"));

  parameter Real P_grad_max_star=0.12/60 "Fraction of nominal power per second (12% per minute)"
                                                            annotation(Dialog(group="Physical Constraints"));

  parameter Base.PartloadEfficiency.PartloadEfficiencyCharacteristic EfficiencyCharLine=TransiEnt.Producer.Electrical.Base.PartloadEfficiency.ConstantEfficiency() "choose characteristic efficiency line" annotation(Dialog(group="Physical Constraints"), choicesAllMatching=true);

  parameter SI.Time H = 6 "Time constant of plant (For easy definition of J)" annotation(Dialog(group="Physical Constraints"));

  parameter SI.Inertia J=P_el_n*2*H/(2*simCenter.f_n*Modelica.Constants.pi)^2 "Lumped moment of inertia of whole power plant" annotation (Dialog(group="Physical Constraints"));

  // **** Statistics

  parameter Integer nSubgrid=1 "Index of subgrid for moment of inertia statistics"  annotation(Dialog(group="Statistics"));

  // **** Expert Settings

  parameter TransiEnt.Components.Turbogroups.Base.GradientLimitingChoices powerGradLimChoice=TransiEnt.Components.Turbogroups.Base.GradientLimitingChoices.GradLimInFirstOrder "options of gradient limitation" annotation(Dialog(tab="Expert Settings"));

  parameter Boolean fixedStartValue_w = false "Whether or not the start value of the angular velocity of the plants mechanical components is fixed"
   annotation (Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true),Dialog(tab="Expert Settings"));

  parameter SI.Time Td_GradientLimiter=simCenter.Td "Time constant of integrator"
                                  annotation(Dialog(tab="Expert Settings"));

  parameter Boolean useThresh=simCenter.useThresh "Use threshould for suppression of numerical noise"
    annotation (Dialog(tab="Expert Settings"));

  parameter Real thres=simCenter.thres "If abs(u-y)< thres, y becomes a simple pass through of u. Increasing thres can improve simulation speed. However to large values can make the simulation unstable. 
  A good starting point is the choice thres = tolerance/1000. For too small values, the power plant is never turned off."
    annotation (Dialog(tab="Expert Settings"));
  parameter Real thres_hyst=1e-10 "Threshold for hysteresis for switch from halt to startup (chattering might occur, hysteresis might help avoiding this)" annotation(Dialog(tab="Expert Settings"));

  parameter SI.Time t_startup=0 "Startup time (P=0 during startup)" annotation(Dialog(group="Physical Constraints"));

  parameter SI.Time t_min_operating = 0 "Minimum operation time" annotation(Dialog(group="Physical Constraints"));

  parameter Boolean smoothShutDown=true "shut down process will be smoothed - power gradient will be limit by 'P_grad_operating'" annotation(Dialog(group="Physical Constraints"));

  parameter SI.Time MinimumDownTime=0 "Minimum time the plant needs to be shut down before starting again" annotation(Dialog(group="Physical Constraints"));

  parameter SI.Time T_plant=0.63/P_grad_max_star "Time constant of first order model representing plant dynamics" annotation(Dialog(group="Physical Constraints"));

  parameter SI.MassFraction CO2_Deposition_Rate=0 "Fraction of CO2 that is deposited via CCS" annotation (Dialog(group="Physical Constraints"));

  parameter Base.CCS.NoCCS CCS_Characteristics=Base.CCS.NoCCS() "Choose characteristic efficiency losses due to CCS" annotation (Dialog(group="Physical Constraints"), __Dymola_choicesAllMatching=true);

  parameter Integer quantity=1 "amount of power plant blocks into which nominal power is split" annotation (Dialog(group="Physical Constraints"));

  parameter Boolean useHomotopyVarSlewRateLim=simCenter.useHomotopy "true if homotopy shall be used in variableSlewRateLimiter in turbine (true might avoid circular equalities, false might help if 0/0 occurs in power plant)" annotation (Dialog(enable=useSlewRateLimiter, tab="Expert Settings"));


  // _____________________________________________
  //
  //       Final and protected parameters
  // _____________________________________________

  final parameter Modelica.Units.SI.Power P_min=P_min_star*P_el_n;
  final parameter SI.Power P_init(fixed=false) "Start value for P";
  //final parameter Modelica.SIunits.Power P_init_calc( fixed=false);
  //final parameter Modelica.SIunits.Power P_init=if set_P_init then P_init_set else P_init_calc;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  Modelica.Blocks.Interfaces.BooleanInput useCCS if CO2_Deposition_Rate>0 "true, if CCS is used"                          annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

public
  replaceable TransiEnt.Components.Electrical.Machines.ActivePowerGenerator Generator(eta=1) constrainedby TransiEnt.Components.Electrical.Machines.Base.PartialActivePowerGenerator "Choice of generator model. The generator model must match the power port." annotation (Dialog(group="Replaceable Components"),choicesAllMatching=true, Placement(transformation(
        extent={{-18.5,-18},{18.5,18}},
        rotation=0,
        origin={39.5,-39})));
  TransiEnt.Components.Mechanical.TwoStateInertiaWithIdealClutch MechanicalConnection(
    omega(fixed=fixedStartValue_w, start=2*simCenter.f_n*Modelica.Constants.pi),
    J=J,
    phi,
    alpha,
    nSubgrid=nSubgrid,
    P_n=P_el_n) annotation (choicesAllMatching=true, Placement(transformation(extent={{-28,-57},{4,-23}})));

    replaceable TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem Exciter constrainedby TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.PartialExcitationSystem "Choice of excitation system model with voltage control" annotation (Dialog(group="Replaceable Components"),choicesAllMatching=true, Placement(transformation(
        extent={{-10,-10.5},{10,10.5}},
        rotation=-90,
        origin={62.5,16})));

public
  replaceable TransiEnt.Components.Turbogroups.FirstOrderThreeStateTurbine Turbine(
    P_grad_max_star_primCntrl=primaryBalancingController.maxGradientPrCtrl,
    P_turb_init=P_init,
    P_n=P_el_n,
    T_plant=T_plant,
    P_min_star=P_min_star,
    P_max_star=P_max_star,
    P_grad_max_star=P_grad_max_star,
    Td=Td_GradientLimiter,
    useThresh=useThresh,
    thres=thres,
    t_startup=t_startup,
    t_min_operating=t_min_operating,
    smoothShutDown=smoothShutDown,
    thres_hyst=thres_hyst,
    MinimumDownTime=MinimumDownTime,
    useHomotopyVarSlewRateLim=useHomotopyVarSlewRateLim) constrainedby TransiEnt.Components.Turbogroups.Base.PartialTurbine "Choice of turbine model" annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{-78,-58},{-42,-22}})),
    Dialog(group="Replaceable Components"));
  Modelica.Blocks.Logical.Switch switch1 if CO2_Deposition_Rate>0 annotation (Placement(transformation(extent={{-92,-6},{-80,6}})));
  Modelica.Blocks.Sources.RealExpression CO2_Deposited_set(y=m_flow_gas_CDE_deposited_set) if CO2_Deposition_Rate>0 "just for visualisation on diagram layer" annotation (Placement(transformation(extent={{-112,2},{-100,16}})));
  Modelica.Blocks.Sources.RealExpression Zero(y=0) "just for visualisation on diagram layer" annotation (Placement(transformation(extent={{-112,-16},{-100,-2}})));
  Modelica.Blocks.Math.Gain gain(k=1)  annotation (Placement(transformation(extent={{-76,-4},{-68,4}})));
  Modelica.Blocks.Math.Sum P_set_total(nin=2) "Schedule plus agc setpoint" annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=270,
        origin={-59,23})));
  Base.PartloadEfficiency.PartloadEfficiency PartloadEfficiency(eta_n=eta_total, EfficiencyCharLine=EfficiencyCharLine,CCS_Characteristics=CCS_Characteristics, CO2_Deposition_Rate=CO2_Deposition_Rate,
    quantity=quantity,
    P_min_star=P_min_star)                                                                                                                                                                                                     annotation (Placement(transformation(extent={{32,-100},{52,-80}})));
  Modelica.Blocks.Sources.RealExpression p_is(y=P_star) annotation (Placement(transformation(extent={{12,-100},{26,-80}})));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter if  CO2_Deposition_Rate>0                annotation (Placement(transformation(extent={{-5,-5},{5,5}},
        rotation=-90,
        origin={-59,-7})));
  Modelica.Blocks.Sources.RealExpression P_max_with_CCS(y=-P_max_star)  annotation (Placement(transformation(
        extent={{-3,-3},{3,3}},
        rotation=-90,
        origin={-63,11})));
  Modelica.Blocks.Sources.RealExpression P_min_with_CCS(y=0) annotation (Placement(transformation(
        extent={{-3,-3},{3,3}},
        rotation=-90,
        origin={-55,11})));
  // _____________________________________________
  //
  //                Variables
  // _____________________________________________
  SI.MassFlowRate m_flow_gas_CDE_deposited_set=m_flow_CDE/(1-CO2_Deposition_Rate)*CO2_Deposition_Rate;
  Real P_set_star = -Turbine.P_target /P_el_n;
  Real P_set_star_sched = -P_el_set /P_el_n;
  Real delta_P_star = (P_el_set+P_el_is)/P_el_n;
  Modelica.Blocks.Math.Gain gain1(k=P_el_n) if CO2_Deposition_Rate>0 annotation (Placement(transformation(
        extent={{-1,-1},{1,1}},
        rotation=-90,
        origin={-63,5})));
initial equation
  P_init = if set_P_init then P_init_set else -epp.P;

equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  is_running = MechanicalConnection.isRunning "Synchronizing machine (constant delay) state, true if running";
  eta = max(1e-5,PartloadEfficiency.eta_is);
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(Turbine.mpp, MechanicalConnection.mpp_a) annotation (Line(
      points={{-41.82,-40.18},{-35.91,-40.18},{-35.91,-40},{-28,-40}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(MechanicalConnection.mpp_b, Generator.mpp) annotation (Line(
      points={{4,-40},{12,-40},{12,-39},{21,-39}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(MechanicalConnection.mpp_b, gridFrequencySensor.mpp) annotation (Line(
      points={{4,-40},{12,-40},{12,-8},{46,-8},{46,54},{33.2,54}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(Generator.epp, epp) annotation (Line(
      points={{58.185,-39.18},{79.0925,-39.18},{79.0925,78},{100,78}},
      color={0,0,0},
      smooth=Smooth.None));

  connect(Turbine.isGeneratorRunning, MechanicalConnection.isRunning)
    annotation (Line(
      points={{-40.2,-36.4},{-34,-36.4},{-34,-18},{-12.16,-18},{-12.16,-25.21}},
      color={255,0,255},
      smooth=Smooth.None));

  connect(primaryBalancingController.P_PBP_set, Turbine.P_spinning_set) annotation (Line(points={{-28.6,54},{-53.52,54},{-53.52,-22.36}},
                                                                                                                                        color={0,0,127}));
  connect(P_el_set, P_set_total.u[1]) annotation (Line(points={{-60,100},{-59.5,100},{-59.5,29}},color={0,0,127}));
  connect(P_SB_set_internal, P_set_total.u[2]) annotation (Line(points={{-100,56},{-100,32},{-58.5,32},{-58.5,29}},                  color={0,0,127}));
  connect(p_is.y,PartloadEfficiency.P_el_is)  annotation (Line(points={{26.7,-90},{31.4,-90}},   color={0,0,127}));
  connect(Exciter.y, Generator.E_input) annotation (Line(points={{62.5,5.4},{62.5,-16},{38.945,-16},{38.945,-21.18}}, color={0,0,127}));
  connect(Exciter.epp1, epp) annotation (Line(
      points={{62.5,26},{62,26},{62,78},{100,78}},
      color={0,135,135},
      thickness=0.5));

  if CO2_Deposition_Rate>0 then
    connect(useCCS,switch1. u2) annotation (Line(points={{-120,0},{-93.2,0}},                       color={255,0,255}));
    connect(switch1.u1,CO2_Deposited_set. y) annotation (Line(points={{-93.2,4.8},{-96,4.8},{-96,9},{-99.4,9}},
                                                                                             color={0,0,127}));
    connect(Zero.y,switch1. u3) annotation (Line(points={{-99.4,-9},{-96,-9},{-96,-4.8},{-93.2,-4.8}},
                                                                              color={0,0,127}));
    connect(switch1.y,gain. u) annotation (Line(points={{-79.4,0},{-76.8,0}},   color={0,0,127}));
    connect(useCCS, PartloadEfficiency.UseCCS);
    connect(P_set_total.y, variableLimiter.u) annotation (Line(points={{-59,17.5},{-59,-1}},color={0,0,127}));
    connect(variableLimiter.y, Turbine.P_target) annotation (Line(points={{-59,-12.5},{-59,-16.25},{-60.18,-16.25},{-60.18,-24.7}}, color={0,0,127}));
    connect(P_min_with_CCS.y, variableLimiter.limit1) annotation (Line(points={{-55,7.7},{-55,-1}},                       color={0,0,127}));
  else
    connect(P_set_total.y,Turbine.P_target);
    connect(Zero.y,gain.u);
  end if;

if CO2_Deposition_Rate>0 then
  connect(P_max_with_CCS.y, gain1.u) annotation (Line(points={{-63,7.7},{-63,6.2}},  color={0,0,127}));
  connect(variableLimiter.limit2, gain1.y) annotation (Line(points={{-63,-1},{-63,1.5},{-63,1.5},{-63,3.9}}, color={0,0,127}));
end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                               graphics={
    Text( lineColor={255,255,0},
        extent={{-44,-82},{16,-22}},
          textString="NLTI")}),  Diagram(coordinateSystem(preserveAspectRatio=false,
                   extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Slew Rate limited (=nonlinear), Minimum power limited (shuts down below minimum power), with primary and secondary balancing controller where secondary balancing power is lumped inside.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Carbon Capture & Storage (CCS):</span></p>
<p>Via parameter &apos;CO2_Deposition_Rate&apos; the fraction of CO2 that shall be deposited can be defined. The efficiency losses due to CCS can be defined via characterstic lines which are stored in records and which can be chosen via &apos;CCS_Characteristics&apos;. If &apos;NoCCS&apos; is chosen there will be no efficiency losses. Though CO2 will still be depositied if COS_DepostionRate&gt;0.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">epp: type of electrical power port can be chosen</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_el_set: input for electric power in W (electric power setpoint)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_SB_set: input for electric power in W (secondary balancing setpoint)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">UseCCS: if true: CCS is deposited - if false: CCS is not deposited</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">If 0/0 occurs at initialization, try setting useHomotopyVarSlewRateLim to false.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">If circular equalities appear, try setting Evaluate=true in the model.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model generalized for different electrical power ports by Jan-Peter Heckel (jan.heckel@tuhh.de) in July 2018 </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) on Dez 2018: added CCS</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Robert Flesch (flesch@xrg-simulation.de) in Feb 2021: adapted parameter interface to use limiting in firstOrders - this is the new default as it performs much better numerically</span></p>
</html>"));
end NonlinearThreeStatePlant;
