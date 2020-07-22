within TransiEnt.Producer.Electrical.Conventional.Components;
model VDI3508Plant_PrimaryBalancing "Transient behaviour by multiple first order systems according to VDI 3508, no states, with balancing control"
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

  import Modelica.Constants.pi;
  import TransiEnt.Basics.Types.ClaRaPlantControlStrategy;

  extends TransiEnt.Producer.Electrical.Base.PartialDispatchablePowerPlant;
  extends TransiEnt.Producer.Electrical.Base.ControlPower.PartialBalancingPowerProvider(
      final typeOfBalancingPowerResource=typeOfResource,
      primaryBalancingController(
      P_n=P_el_n),
      controlPowerModel(
      P_n=P_el_n,
      P_pr_max=primaryBalancingController.maxValuePrCtrl,
      P_el_is = P_el_is,
      P_grad_max_star=P_el_grad_max_SB,
      is_running=is_running,
      P_PB_set=primaryBalancingController.P_PBP_set,
      P_SB_set=P_SB_set_internal),
    redeclare final TransiEnt.Components.Sensors.MechanicalFrequency gridFrequencySensor(isDeltaMeasurement=true),
    isPrimaryControlActive=true,
    isSecondaryControlActive=false,
    isExternalSecondaryController=true);

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  // Steam power plant parameters

  parameter Real P_min_star(max=1, min=0)=0.4 annotation(Dialog(group="Physical Constraints"));
  parameter SI.Frequency P_grad_max_star=0.12/60 "Fraction of nominal power per second (12% per minute)" annotation(Dialog(group="Physical Constraints"));
  parameter SI.Time t_startup=3600 "Block startup time" annotation(Dialog(group="Physical Constraints"));

  // Dynamic parameters
  parameter SI.Time T_u=60 "Dead time of steam generation (5...200s)" annotation(Dialog(group="Plant characteristics", tab="Expert Settings"));
  parameter SI.Time T_g=250 "Balancing time of steam generation (60...250s)" annotation(Dialog(group="Plant characteristics", tab="Expert Settings"));
  parameter SI.Time T_S=130 "Storage time of steam generator (60...250s)" annotation(Dialog(group="Plant characteristics", tab="Expert Settings"));
  parameter Real x_T_hp=0.2 "Fraction of power provided by high pressure turbine stage (fast response)" annotation(Dialog(group="Plant characteristics", tab="Expert Settings"));
  parameter SI.Time T_lp=20 "Time constant of low pressure turbine (10...25s)" annotation(Dialog(group="Plant characteristics", tab="Expert Settings"));
  parameter SI.Time T_gen=10 "Generator run-up time constant (5...15s)" annotation(Dialog(group="Plant characteristics", tab="Expert Settings"));
  parameter SI.Inertia J=T_gen*P_el_n/(2*simCenter.f_n*pi)^2 "Lumped moment of inertia of whole power plant" annotation (Dialog(group="Plant characteristics", tab="Expert Settings"));

  //Statistics parameters
  parameter Integer nSubgrid=1 "Index of subgrid for moment of inertia statistics" annotation(Dialog(group="Statistics"));

  // Initialization
  parameter SI.ActivePower P_el_star_init=1 annotation(Dialog(group="Initialization"));

  // Control parameters
  parameter TransiEnt.Basics.Types.ClaRaPlantControlStrategy steamGeneratorControl=ClaRaPlantControlStrategy.MSP "Control strategy for power plant" annotation (Dialog(tab="Block control", group="Block control"));
  parameter Real m_T_set_slp_start=0.3 "Relative mass flow at which modified pressure operation begins" annotation(Dialog(tab="Block control", group="Block control"));
  parameter Real m_T_set_slp_end=0.9 "Relative mass flow at which modified pressure operation ends" annotation(Dialog(tab="Block control", group="Block control"));
  parameter Real y_T_slp=0.9 "Constant turbine valve apparture in modified pressure operation" annotation(Dialog(tab="Block control", group="Block control"));

  // Expert Settings (Numerical)
  parameter SI.Time t_eps=10 "Set point power has to be above the minimum power for t_eps time before plant leaves halt state"
                                                                                                    annotation(Dialog(tab="Expert Settings"));
  //parameter SI.Time T_thresh=0.2 "Time constant of numerical element between saturation block and slew rate limiter block"
  //                                                                                                  annotation(Dialog(tab="Expert Settings"));
  parameter SI.Frequency y_grad_inf=1 "Very high power gradient used for plant shut-down" annotation(Dialog(tab="Expert Settings"));
  parameter Boolean fixedStartValue_w = false "Whether or not the start value of the angular velocity of the plants mechanical components is fixed"
   annotation (Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true),Dialog(tab="Expert Settings"));

  parameter SI.Time Td=simCenter.Td "Time constant of integrator"
                                  annotation(Dialog(tab="Expert Settings"));

  parameter Boolean useThresh=simCenter.useThresh "Use threshould for suppression of numerical noise"
    annotation (Dialog(tab="Expert Settings"));

  parameter Real thres=simCenter.thres "If abs(u-y)< thres, y becomes a simple pass through of u. Increasing thres can improve simulation speed. However to large values can make the simulation unstable. 
     A good starting point is the choice thres = tolerance/1000."
    annotation (Dialog(tab="Expert Settings"));
  parameter Real thres_hyst=1e-10 "Threshold for hysteresis for switch from halt to startup (chattering might occur, hysteresis might help avoiding this)" annotation (Dialog(tab="Expert Settings"));

  // **** Frequency Control

  parameter TransiEnt.Basics.Types.ControlPlantType plantType=TransiEnt.Basics.Types.ControlPlantType.Provided "Droop of Turbine (Relative frequency change, when demanded power changes)" annotation (Dialog(
      enable=isPrimaryControlActive,
      group="Frequency Control",
      tab="Block control"));

  parameter Real providedDroop=0.2 "Value used if plantType is set to 'Provided'" annotation(Dialog(enable = isPrimaryControlActive, group="Frequency Control", tab="Block control"));

  parameter Real maxGradientPrCtrl=0.02/30 "Two percent of design case power in 30s" annotation(Dialog(enable = isPrimaryControlActive, group="Frequency Control", tab="Block control"));

  parameter Real maxValuePrCtrl=0.2 "Two percent of design case power" annotation(Dialog(enable = isPrimaryControlActive, group="Frequency Control", tab="Block control"));

  parameter Real k_pr=1 "Participation factor primary control"   annotation(Dialog(enable = isPrimaryControlActive, group="Frequency Control", tab="Block control"));

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  Modelica.Blocks.Math.Gain deNormalize(k=-P_el_n) annotation (Placement(transformation(extent={{6,-22},{12,-16}})));
  TransiEnt.Components.Turbogroups.OperatingStates.ThreeStateDynamic setPointLimiter(
    t_eps=t_eps,
    t_startup=t_startup,
    P_min_operating=P_min_star,
    P_grad_operating=P_grad_max_star,
    P_grad_inf=y_grad_inf,
    Td=Td,
    useThresh=useThresh,
    thres=thres,
    thres_hyst=thres_hyst)
                 annotation (Placement(transformation(extent={{-118,52},{-98,72}})));
    //T_thresh=T_thresh,

  Modelica.Blocks.Math.Gain normalize(k=-1/P_el_n) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=90,
        origin={-128,74})));
  TransiEnt.Components.Heat.SteamGenerator_L0 SteamGenerator_MSP(
    T_u=T_u,
    T_g=T_g,
    y_start=P_el_star_init) annotation (Placement(transformation(extent={{-92,-50},{-72,-30}})));
  TransiEnt.Components.Heat.SteamVolumeWithValve_L0 SteamVolume_MSP(T=T_S, y_start=P_el_star_init) annotation (Placement(transformation(extent={{-56,-50},{-36,-30}})));
  TransiEnt.Components.Heat.SteamTurbine_L0 SteamTurbine_MSP(
    x_highPressureStage=x_T_hp,
    T_lowPressure=T_lp,
    y_start_lowPressure=P_el_star_init/(1 - x_T_hp)) annotation (Placement(transformation(extent={{-26,-50},{-6,-30}})));
  TransiEnt.Components.Heat.Controller.TurbineValveController turbineValveController_MSP(
    controlStrategy=steamGeneratorControl,
    m_T_set_slp_start=m_T_set_slp_start,
    m_T_set_slp_end=m_T_set_slp_end,
    y_T_slp=y_T_slp) annotation (Placement(transformation(extent={{-83,15},{-67,31}})));
  Modelica.Blocks.Math.Sum y_T_set(nin=2) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={-53,2})));
  Modelica.Blocks.Math.Sum Q_flow_set(nin=2) annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={-113,3})));
  TransiEnt.Components.Boundaries.Mechanical.Power MechanicalBoundary annotation (Placement(transformation(extent={{8,-46},{28,-26}})));
  TransiEnt.Components.Mechanical.TwoStateInertiaWithIdealClutch MechanicalConnection(
    omega(fixed=fixedStartValue_w, start=2*simCenter.f_n*Modelica.Constants.pi),
    J=J,
    nSubgrid=nSubgrid,
    P_n=P_el_n) annotation (choicesAllMatching=true, Placement(transformation(extent={{36,-47},{52,-24}})));
  replaceable TransiEnt.Components.Electrical.Machines.ActivePowerGenerator Generator(eta=1) constrainedby TransiEnt.Components.Electrical.Machines.Base.PartialActivePowerGenerator "Choice of generator model. The generator model must match the power port."
                                                                                                                                                                                     annotation (Dialog(group="Replaceable Components"),choicesAllMatching=true, Placement(transformation(
        extent={{-11.5,-12},{11.5,12}},
        rotation=0,
        origin={72.5,-34})));
  TransiEnt.Basics.Blocks.PD pD(
    wp=0.3,
    Td=500,
    k=5) annotation (Placement(transformation(extent={{-36,17},{-50,31}})));
  TransiEnt.Basics.Blocks.PD pD1(
    wp=0.3,
    Td=500,
    k=5) annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=0,
        origin={-111,25})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=is_running) annotation (Placement(transformation(extent={{24,-10},{44,10}})));
  replaceable TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem Exciter constrainedby TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem "Choice of excitation system model with voltage control"
                                                                                                                                                                                              annotation (Dialog(group="Replaceable Components"),choicesAllMatching=true, Placement(transformation(
        extent={{-10,-10.5},{10,10.5}},
        rotation=-90,
        origin={74.5,26})));
equation

  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  is_running = not setPointLimiter.halt.active;
  eta = eta_total "Constant efficiency";

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(normalize.u, P_el_set) annotation (Line(points={{-128,81.2},{-128,86},{-60,86},{-60,100}},
                                                                                                   color={0,0,127}));
  connect(SteamGenerator_MSP.y,SteamVolume_MSP. m_flow_steam_in) annotation (Line(points={{-71.2,-40},{-56.4,-40}},
                                                                                                    color={0,0,127}));
  connect(SteamVolume_MSP.m_flow_steam_out,SteamTurbine_MSP. Q_flow_in) annotation (Line(points={{-35.2,-40},{-26.4,-40}},
                                                                                                    color={0,0,127}));
  connect(y_T_set.y, SteamVolume_MSP.opening) annotation (Line(points={{-47.5,2},{-46,2},{-46,-31.6}}, color={0,0,127}));
  connect(Q_flow_set.y, SteamGenerator_MSP.Q_flow_set) annotation (Line(points={{-107.5,3},{-104,3},{-104,-2},{-104,-40},{-92.4,-40}},
                                                                                                    color={0,0,127}));
  connect(deNormalize.y, MechanicalBoundary.P_mech_set) annotation (Line(points={{12.3,-19},{18,-19},{18,-24.2}},
                                                                                                    color={0,0,127}));
  connect(MechanicalBoundary.mpp, MechanicalConnection.mpp_a) annotation (Line(points={{28,-36},{28,-35.5},{36,-35.5}}, color={95,95,95}));
  connect(deNormalize.u, SteamTurbine_MSP.y) annotation (Line(points={{5.4,-19},{0.7,-19},{0.7,-40},{-5.2,-40}},
                                                                                                    color={0,0,127}));
  connect(MechanicalConnection.mpp_b, Generator.mpp) annotation (Line(points={{52,-35.5},{60,-35.5},{60,-34},{61,-34}},         color={95,95,95}));
  connect(Generator.epp, epp) annotation (Line(
      points={{84.115,-34.12},{100,-34.12},{100,78}},
      color={0,135,135},
      thickness=0.5));
  connect(setPointLimiter.P_set_star_lim, Q_flow_set.u[1]) annotation (Line(points={{-96.8,62},{-86,62},{-86,40},{-136,40},{-136,2.5},{-119,2.5}}, color={0,0,127}));
  connect(pD1.y, Q_flow_set.u[2]) annotation (Line(points={{-118.7,24.86},{-130,24.86},{-130,3.5},{-119,3.5}}, color={0,0,127}));
  connect(primaryBalancingController.P_PBP_set, pD1.u) annotation (Line(points={{-28.6,54},{-90,54},{-90,26},{-90,24.93},{-102.67,24.93}},
                                                                                                                                         color={0,0,127}));
  connect(setPointLimiter.P_set_star_lim, turbineValveController_MSP.P_T_set) annotation (Line(points={{-96.8,62},{-86,62},{-86,23.16},{-82.36,23.16}}, color={0,0,127}));
  connect(pD.y, y_T_set.u[2]) annotation (Line(points={{-50.7,23.86},{-58,23.86},{-58,24},{-60,24},{-60,2},{-60,2.5},{-59,2.5}}, color={0,0,127}));
  connect(turbineValveController_MSP.y_T_set, y_T_set.u[1]) annotation (Line(points={{-66.36,25.72},{-64,25.72},{-64,26},{-64,2},{-59,2},{-59,1.5}}, color={0,0,127}));
  connect(primaryBalancingController.P_PBP_set, pD.u) annotation (Line(points={{-28.6,54},{-64,54},{-64,36},{-28,36},{-28,23.93},{-34.67,23.93}},
                                                                                                                                                color={0,0,127}));
  connect(booleanExpression.y, MechanicalConnection.isRunning) annotation (Line(points={{45,0},{54,0},{54,-20},{43.92,-20},{43.92,-25.495}}, color={255,0,255}));
  connect(Generator.mpp, gridFrequencySensor.mpp) annotation (Line(points={{61,-34},{56,-34},{56,54},{33.2,54}},         color={95,95,95}));
  connect(normalize.y, setPointLimiter.P_set_star) annotation (Line(points={{-128,67.4},{-128,62},{-118,62}}, color={0,0,127}));
  connect(Exciter.epp1, epp) annotation (Line(
      points={{74.5,36},{74,36},{74,78},{100,78}},
      color={0,135,135},
      thickness=0.5));
  connect(Exciter.y, Generator.E_input) annotation (Line(points={{74.5,15.4},{74.5,-3.3},{72.155,-3.3},{72.155,-22.12}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{100,100}}),
                               graphics={
    Text( lineColor={255,255,0},
        extent={{-40,-84},{20,-24}},
          textString="PT4")}),            Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-140,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-138,94},{18,-6}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          lineThickness=0.5),
        Rectangle(
          extent={{-98,-10},{96,-58}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-98,-10},{-50,-16}},
          pattern=LinePattern.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Steam power plant",
          lineColor={0,0,0}),
        Text(
          extent={{-145,93},{-97,87}},
          pattern=LinePattern.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          textString="Unit Control")}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p><br>//rp</p>
<p>This model is based on the simplified representation of a power station unit found in the norm VDI/VDE 3508. </p>
<p>The model takes the set value of the electric power output (P_Target) and translates it to a change into a target thermal input. Meanwhile, the turbine valve aperture remains completely opened. Thus, the model is in <b>natural sliding-pressure operation</b> <b>mode</b>.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The model is based on typical time responses of the power plant components. No phyisical modeling has been conducted.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>P_Target: receives the target value of the electric power in W</p>
<p>epp: Mainly delivers the real output of the power plant. </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>The values of Tu, Tg, Ts can be found in the norm. The following table summarizes these values:</p>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"1\" width=\"100%\"><tr>
<td></td>
<td><p><br><span style=\"font-family: MS Shell Dlg 2;\">Recirculation steam generator (drum)</span></p></td>
<td><p><span style=\"font-family: MS Shell Dlg 2;\">Once-through steam generator</span></p></td>
</tr>
<tr>
<td><p>Oil and gas</p></td>
<td><p>Tu=5...10s</p><p><span style=\"font-family: MS Shell Dlg 2;\">Tg=60s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Ts=130...250s</span></p></td>
<td><p><span style=\"font-family: MS Shell Dlg 2;\">Tu=5...10s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Tg=60...150s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Ts=40...120s</span></p></td>
</tr>
<tr>
<td><p>Hard coal with liquid slag removal</p></td>
<td><p><span style=\"font-family: MS Shell Dlg 2;\">Tu=120s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Tg=200s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Ts=130...250s</span></p></td>
<td><p><span style=\"font-family: MS Shell Dlg 2;\">Tu=50...200s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Tg=200s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Ts=60...100s</span></p></td>
</tr>
<tr>
<td><p>Hard coal with dry slag removal</p></td>
<td><p><span style=\"font-family: MS Shell Dlg 2;\">Tu=20...60s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Tg=150s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Ts=130...250s</span></p></td>
<td><p><span style=\"font-family: MS Shell Dlg 2;\">Tu=20...60s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Tg=150...250s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Ts=60...140s</span></p></td>
</tr>
<tr>
<td><p>Brown coal</p></td>
<td><p><span style=\"font-family: MS Shell Dlg 2;\">Tu=30...60s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Tg=250s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Ts=130...250s</span></p></td>
<td><p><span style=\"font-family: MS Shell Dlg 2;\">Tu=30...60s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Tg=250s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Ts=60...140s</span></p></td>
</tr>
</table>
<p>*** Recirculation steam generator (drum)</p>
<p>Oil and gas Tu = 5 to 10 s Tg &asymp; 60 s TS = 130 to 250 s</p>
<p>Hard coal * with liquid slag removal</p>
<p>Hard coal * with dry slag removal</p>
<p>Tu &asymp; 120 s Tg &asymp; 200 s TS = 130 to 250 s</p>
<p>Tu = 20 to 60 s Tg &asymp; 150 s TS = 130 to 250 s</p>
<p>Brown coal* Tu = 30 to 60 s Tg &asymp; 250 s TS = 130 to 250 s</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">*** Once-through steam generator</span></p>
<p>Tu = 5 to 10 s Tg = 60 to 150 s TS = 40 to 120 s</p>
<p>Tu = 50 to 200 s Tg = 200 s TS = 60 to 100 s</p>
<p>Tu = 20 to 60 s Tg = 150 to 250 s TS = 60 to 140 s</p>
<p>Tu = 30 to 60 s Tg &asymp; 250 s TS = 60 to 140 s</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>According to [1] Chapter 7, &QUOT;in the operating mode &QUOT;steam generator in control&QUOT;... the actual output follows the setpoint after the unit delay, which results from the delay within the controlled power station (Fig. 22a). </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] VDI/VDE3508</p>
<p>Pitscheider, 2007</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Ricardo Peniche</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model generalized for different electrical power ports by Jan-Peter Heckel (jan.heckel@tuhh.de) in July 2018 </span></p>
</html>"));
end VDI3508Plant_PrimaryBalancing;
