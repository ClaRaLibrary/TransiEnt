within TransiEnt.Producer.Electrical.Conventional.Components;
model NonlinearThreeStatePlant "Slew Rate limited (=nonlinear), Minimum power limited (shuts down below minimum power), with primary and secondary balancing controller where secondary balancing power is lumped inside"

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Producer.Electrical.Base.PartialDispatchablePowerPlant;
  extends TransiEnt.Producer.Electrical.Base.ControlPower.PartialBalancingPowerProvider(
      final P_nom=P_el_n,
      final typeOfBalancingPowerResource=typeOfResource,
      primaryBalancingController(
      P_nom=P_el_n),
      redeclare Base.ControlPower.PrimarySecondaryAndSchedule controlPowerModel(
      final P_nom=P_el_n,
      P_pr_max=primaryBalancingController.P_pr_max,
      P_el_is = P_el_is,
      P_grad_max_star=P_el_grad_max_SB,
      is_running=is_running,
      P_PB_set=primaryBalancingController.P_PBP_set,
      P_SB_set=P_SB_set_internal),
    redeclare final TransiEnt.Components.Sensors.MechanicalFrequency gridFrequencySensor(isDeltaMeasurement=true),
    isPrimaryControlActive=true,
    isSecondaryControlActive=false,
    isExternalSecondaryController=true,
    P_el_grad_max_SB=P_grad_max_star*P_el_n);

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  // **** Physical Constraints and Inititalization

  parameter Real P_init=P_el_n
                              "Initial or guess value of turbine power" annotation(Dialog(group="Initialization"));

  parameter Real P_min_star=0.2 "Fraction of nominal power (=20% of nominal power)" annotation(Dialog(group="Physical Constraints"));

  parameter Real P_max_star=1 "Fraction of nominal power (=100% of nominal power)"
                                                                                  annotation(Dialog(group="Physical Constraints"));

  parameter Real P_grad_max_star=0.12/60 "Fraction of nominal power per second (12% per minute)"
                                                            annotation(Dialog(group="Physical Constraints"));

  parameter Base.PartloadEfficiency.PartloadEfficiencyCharacteristic EfficiencyCharLine=TransiEnt.Producer.Electrical.Base.PartloadEfficiency.ConstantEfficiency() annotation(Dialog(group="Physical Constraints"), choicesAllMatching=true);

  parameter SI.Time H = 6 "Time constant of plant (For easy definition of J)" annotation(Dialog(group="Physical Constraints"));

  parameter SI.Inertia J=P_el_n*2*H/(2*simCenter.f_n*Modelica.Constants.pi)^2 "Lumped moment of inertia of whole power plant" annotation (Dialog(group="Physical Constraints"));

  // **** Statistics

  parameter Integer nSubgrid=1 "Index of subgrid for moment of inertia statistics"  annotation(Dialog(group="Statistics"));

  // **** Expert Settings

  parameter Boolean fixedStartValue_w = false "Wether or not the start value of the angular velocity of the plants mechanical components is fixed"
   annotation (Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true),Dialog(tab="Expert Settings"));

  parameter SI.Time Td_GradientLimiter=simCenter.Td "Time constant of integrator"
                                  annotation(Dialog(tab="Expert Settings"));

  parameter Boolean useThresh=simCenter.useThresh "Use threshould for suppression of numerical noise"
    annotation (Dialog(tab="Expert Settings"));

  parameter Real thres=simCenter.thres "If abs(u-y)< thres, y becomes a simple pass through of u. Increasing thres can improve simulation speed. However to large values can make the simulation unstable. 
     A good starting point is the choice thres = tolerance/1000."
    annotation (Dialog(tab="Expert Settings"));

  parameter SI.Time t_startup=0 "Startup time (P=0 during startup)" annotation(Dialog(group="Physical Constraints"));

  parameter SI.Time T_plant=0.63/P_grad_max_star "Time constant of first order model representing plant dynamics" annotation(Dialog(group="Physical Constraints"));
  // _____________________________________________
  //
  //       Final and protected parameters
  // _____________________________________________

  final parameter Modelica.SIunits.Power P_min=P_min_star*P_el_n;

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________
public
  replaceable TransiEnt.Components.Turbogroups.FirstOrderThreeStateTurbine Turbine(
    P_turb_init=P_init,
    operationStatus(
      t_startup=t_startup,
      P_min_operating=P_min_star,
      P_max_operating=P_max_star,
      P_grad_operating=P_grad_max_star,
      Td=Td_GradientLimiter,
      useThresh=useThresh,
      thres=thres,
      P_star_init=P_init/P_el_n),
    P_nom=P_el_n,
    T_plant=T_plant) constrainedby TransiEnt.Components.Turbogroups.Base.PartialTurbine annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{-78,-58},{-42,-22}})),
    Dialog(group="Physical Constraints"));
public
  TransiEnt.Components.Electrical.Machines.ActivePowerGenerator Generator(eta=1) annotation (choicesAllMatching=true, Placement(transformation(
        extent={{-18.5,-18},{18.5,18}},
        rotation=0,
        origin={39.5,-39})));
  TransiEnt.Components.Mechanical.TwoStateInertiaWithIdealClutch MechanicalConnection(
    J=J,
    phi,
    a,
    w(fixed=fixedStartValue_w, start=2*simCenter.f_n*Modelica.Constants.pi),
    nSubgrid=nSubgrid,
    P_n=P_el_n) annotation (choicesAllMatching=true, Placement(transformation(extent={{-28,-57},{4,-23}})));

  // _____________________________________________
  //
  //                Variables
  // _____________________________________________
  Real P_set_star = -Turbine.P_target /P_el_n;
  Real P_set_star_sched = -P_el_set /P_el_n;
Real delta_P_star = (P_el_set+P_el_is)/P_el_n;
  Modelica.Blocks.Math.Sum P_set_total(nin=2) "Schedule plus agc setpoint" annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=270,
        origin={-59,1})));

  Base.PartloadEfficiency.PartloadEfficiency PartloadEfficiency(eta_n=eta_total, EfficiencyCharLine=TransiEnt.Producer.Electrical.Base.PartloadEfficiency.ConstantEfficiency()) annotation (Placement(transformation(extent={{32,-100},{52,-80}})));
  Modelica.Blocks.Sources.RealExpression p_is(y=P_star) annotation (Placement(transformation(extent={{12,-100},{26,-80}})));
equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  is_running = MechanicalConnection.isRunning "Synchronizing machine (constant delay) state, true if running";
  eta = PartloadEfficiency.eta_is;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(Turbine.mpp, MechanicalConnection.mpp_a) annotation (Line(
      points={{-41.82,-40.18},{-35.91,-40.18},{-35.91,-40},{-28,-40}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(MechanicalConnection.mpp_b, Generator.mpp) annotation (Line(
      points={{4,-40},{12,-40},{12,-39.9},{20.075,-39.9}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(MechanicalConnection.mpp_b, gridFrequencySensor.mpp) annotation (Line(
      points={{4,-40},{12,-40},{12,-8},{46,-8},{46,54},{33.2,54}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(Generator.epp, epp) annotation (Line(
      points={{58.185,-39.18},{79.0925,-39.18},{79.0925,60},{100,60}},
      color={0,0,0},
      smooth=Smooth.None));

  connect(Turbine.isGeneratorRunning, MechanicalConnection.isRunning)
    annotation (Line(
      points={{-40.2,-36.4},{-34,-36.4},{-34,-18},{-12.16,-18},{-12.16,-25.21}},
      color={255,0,255},
      smooth=Smooth.None));

  connect(primaryBalancingController.P_PBP_set, Turbine.P_spinning_set) annotation (Line(points={{-28.6,54},{-53.52,54},{-53.52,-22.36}},
                                                                                                                                        color={0,0,127}));
  connect(P_set_total.y, Turbine.P_target) annotation (Line(points={{-59,-4.5},{-59,-16.25},{-60.18,-16.25},{-60.18,-24.7}}, color={0,0,127}));
  connect(P_el_set, P_set_total.u[1]) annotation (Line(points={{-60,100},{-59.5,100},{-59.5,7}}, color={0,0,127}));
  connect(P_SB_set_internal, P_set_total.u[2]) annotation (Line(points={{-100,56},{-100,34},{-100,32},{-58.5,32},{-58.5,7}},         color={0,0,127}));
  connect(p_is.y, PartloadEfficiency.p_el_is) annotation (Line(points={{26.7,-90},{31.4,-90}},   color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                               graphics={
    Text( lineColor={255,255,0},
        extent={{-44,-82},{16,-22}},
          textString="NLTI")}),  Diagram(coordinateSystem(preserveAspectRatio=false,
                   extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Slew&nbsp;Rate&nbsp;limited&nbsp;(=nonlinear),&nbsp;Minimum&nbsp;power&nbsp;limited&nbsp;(shuts&nbsp;down&nbsp;below&nbsp;minimum&nbsp;power),&nbsp;with&nbsp;primary&nbsp;and&nbsp;secondary&nbsp;balancing&nbsp;controller&nbsp;where&nbsp;secondary&nbsp;balancing&nbsp;power&nbsp;is&nbsp;lumped&nbsp;inside.</p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end NonlinearThreeStatePlant;
