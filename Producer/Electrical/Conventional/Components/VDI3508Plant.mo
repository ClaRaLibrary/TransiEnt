within TransiEnt.Producer.Electrical.Conventional.Components;
model VDI3508Plant "Transient behaviour according to VDI 3508, three operating states (halt, startup, operation) without primary control"

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

  extends TransiEnt.Producer.Electrical.Base.PartialDispatchablePowerPlant;

  import Modelica.Constants.pi;
  import TransiEnt.Basics.Types.ClaRaPlantControlStrategy;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  Real delta_P_star = (P_el_set+P_el_is)/P_el_n;
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
  parameter TransiEnt.Basics.Types.ClaRaPlantControlStrategy steamGeneratorControl=ClaRaPlantControlStrategy.NSP "Control strategy for power plant" annotation (Dialog(tab="Expert Settings", group="Block control"));
  parameter Real m_T_set_slp_start=0.3 "Relative mass flow at which modified pressure operation begins" annotation(Dialog(tab="Expert Settings", group="Block control"));
  parameter Real m_T_set_slp_end=0.9 "Relative mass flow at which modified pressure operation ends" annotation(Dialog(tab="Expert Settings", group="Block control"));
  parameter Real y_T_slp=0.9 "Constant turbine valve apparture in modified pressure operation" annotation(Dialog(tab="Expert Settings", group="Block control"));

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

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  Modelica.Blocks.Math.Gain deNormalize(k=-P_el_n) annotation (Placement(transformation(extent={{6,14},{12,20}})));
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
                 annotation (Placement(transformation(extent={{-128,32},{-108,52}})));
    //T_thresh=T_thresh,
  Modelica.Blocks.Math.Gain normalize(k=1/P_el_n) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=90,
        origin={-60,68})));
  TransiEnt.Components.Heat.SteamGenerator_L0 SteamGenerator_MSP(
    T_u=T_u,
    T_g=T_g,
    y_start=P_el_star_init) annotation (Placement(transformation(extent={{-96,-16},{-76,4}})));
  TransiEnt.Components.Heat.SteamVolumeWithValve_L0 SteamVolume_MSP(T=T_S, y_start=P_el_star_init) annotation (Placement(transformation(extent={{-60,-16},{-40,4}})));
  TransiEnt.Components.Heat.SteamTurbine_L0 SteamTurbine_MSP(
    x_highPressureStage=x_T_hp,
    T_lowPressure=T_lp,
    y_start_lowPressure=P_el_star_init*(1 - x_T_hp)) annotation (Placement(transformation(extent={{-26,-16},{-6,4}})));
  TransiEnt.Components.Heat.Controller.TurbineValveController turbineValveController_MSP(
    controlStrategy=steamGeneratorControl,
    m_T_set_slp_start=m_T_set_slp_start,
    m_T_set_slp_end=m_T_set_slp_end,
    y_T_slp=y_T_slp) annotation (Placement(transformation(extent={{-84,34},{-68,50}})));
  TransiEnt.Components.Boundaries.Mechanical.Power MechanicalBoundary annotation (Placement(transformation(extent={{8,-12},{28,8}})));
  TransiEnt.Components.Mechanical.TwoStateInertiaWithIdealClutch MechanicalConnection(
    omega(fixed=fixedStartValue_w, start=2*simCenter.f_n*Modelica.Constants.pi),
    J=J,
    nSubgrid=nSubgrid,
    P_n=P_el_n) annotation (choicesAllMatching=true, Placement(transformation(extent={{36,-13},{52,10}})));
  replaceable TransiEnt.Components.Electrical.Machines.ActivePowerGenerator Generator(eta=1) constrainedby TransiEnt.Components.Electrical.Machines.Base.PartialActivePowerGenerator "Choice of generator model. The generator model must match the power port." annotation (Dialog(group="Replaceable Components"), choicesAllMatching=true, Placement(transformation(
        extent={{-11.5,-12},{11.5,12}},
        rotation=0,
        origin={72.5,0})));
 replaceable TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem Exciter constrainedby TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem "Choice of excitation system model with voltage control" annotation (Dialog(group="Replaceable Components"),choicesAllMatching=true, Placement(transformation(
        extent={{-10,-10.5},{10,10.5}},
        rotation=-90,
        origin={72.5,44})));

  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=is_running) annotation (Placement(transformation(extent={{16,20},{36,40}})));

  // _____________________________________________
  //
  //          Variables
  // _____________________________________________

  Real P_el_set_star = normalize.y;

equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  is_running =  not setPointLimiter.halt.active "continuous plant";
  eta = eta_total "Constant efficiency";

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(SteamGenerator_MSP.y,SteamVolume_MSP. m_flow_steam_in) annotation (Line(points={{-75.2,-6},{-60.4,-6}},
                                                                                                    color={0,0,127}));
  connect(SteamVolume_MSP.m_flow_steam_out,SteamTurbine_MSP. Q_flow_in) annotation (Line(points={{-39.2,-6},{-26.4,-6}},
                                                                                                    color={0,0,127}));
  connect(setPointLimiter.P_set_star_lim, turbineValveController_MSP.P_T_set) annotation (Line(points={{-106.8,42},{-104,42},{-104,42.16},{-83.36,42.16}},
                                                                                                    color={0,0,127}));
  connect(deNormalize.y, MechanicalBoundary.P_mech_set) annotation (Line(points={{12.3,17},{18,17},{18,9.8}},   color={0,0,127}));
  connect(MechanicalBoundary.mpp, MechanicalConnection.mpp_a) annotation (Line(points={{28,-2},{28,-1.5},{36,-1.5}},    color={95,95,95}));
  connect(deNormalize.u, SteamTurbine_MSP.y) annotation (Line(points={{5.4,17},{0.7,17},{0.7,-6},{-5.2,-6}}, color={0,0,127}));
  connect(MechanicalConnection.mpp_b, Generator.mpp) annotation (Line(points={{52,-1.5},{60,-1.5},{60,0},{61,0}},               color={95,95,95}));
  connect(Generator.epp, epp) annotation (Line(
      points={{84.115,-0.12},{100,-0.12},{100,78}},
      color={0,135,135},
      thickness=0.5));
  connect(setPointLimiter.P_set_star_lim, SteamGenerator_MSP.Q_flow_set) annotation (Line(points={{-106.8,42},{-106,42},{-106,26},{-106,-6},{-96.4,-6}}, color={0,0,127}));
  connect(turbineValveController_MSP.y_T_set, SteamVolume_MSP.opening) annotation (Line(points={{-67.36,44.72},{-50,44.72},{-50,2.4}}, color={0,0,127}));
  connect(booleanExpression.y, MechanicalConnection.isRunning) annotation (Line(points={{37,30},{43.92,30},{43.92,8.505}}, color={255,0,255}));
  connect(normalize.y, setPointLimiter.P_set_star) annotation (Line(points={{-60,61.4},{-60,61.4},{-60,56},{-60,58},{-136,58},{-136,42},{-128,42}}, color={0,0,127}));
  connect(normalize.u, P_el_set) annotation (Line(points={{-60,75.2},{-60,100},
          {-60,100}}, color={0,0,127}));
  connect(Exciter.epp1, epp) annotation (Line(
      points={{72.5,54},{70,54},{70,78},{100,78}},
      color={0,135,135},
      thickness=0.5));
  connect(Exciter.y, Generator.E_input) annotation (Line(points={{72.5,33.4},{72.5,23.7},{72.155,23.7},{72.155,11.88}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{100,100}}),
                               graphics={
    Text( lineColor={255,255,0},
        extent={{-40,-84},{20,-24}},
          textString="PT4")}),            Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-140,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-104,24},{90,-24}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-104,24},{-56,18}},
          pattern=LinePattern.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Steam power plant",
          lineColor={0,0,0}),
        Text(
          extent={{-145,77},{-97,71}},
          pattern=LinePattern.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          textString="Unit Control"),
        Rectangle(
          extent={{-138,78},{-26,26}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          lineThickness=0.5)}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p><br>//rp</p>
<p>This model is based on the simplified representation of a power station unit found in the norm VDI/VDE 3508. </p>
<p>The model takes the set value of the electric power output (P_Target) and translates it to a change into a target thermal input. Meanwhile, the turbine valve aperture remains completely opened. Thus, the model is in <b>natural sliding-pressure operation</b> <b>mode</b>.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The model is based on typical time responses of the power plant components. No phyisical modeling has been conducted.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Can not be used to model plants with control power provision, use VDI3508PBPlant instead</p>
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
<td><p><br><br><span style=\"font-family: MS Shell Dlg 2;\">Recirculation steam generator (drum)</span></p></td>
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
<p><br>*** Recirculation steam generator (drum)</p>
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
end VDI3508Plant;
