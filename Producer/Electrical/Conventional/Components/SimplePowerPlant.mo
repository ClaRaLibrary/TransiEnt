within TransiEnt.Producer.Electrical.Conventional.Components;
model SimplePowerPlant "No transient behaviuor, no operating states, constant efficiency (with optional primary balancing controller)"


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

  extends TransiEnt.Producer.Electrical.Base.PartialDispatchablePowerPlant;
  extends TransiEnt.Producer.Electrical.Base.ControlPower.PartialBalancingPowerProvider(
    final typeOfBalancingPowerResource=typeOfResource,
    final P_n=P_el_n,
    primaryBalancingController(P_n=P_el_n, use_SlewRateLimiter=false),
    controlPowerModel(
      P_pr_max=primaryBalancingController.P_pr_max,
      isSecondaryControlActive=false,
      P_el_is=P_el_is,
      is_running=is_running,
      P_PB_set=primaryBalancingController.P_PBP_set,
      final P_n=P_el_n),
    redeclare final TransiEnt.Components.Sensors.MechanicalFrequency gridFrequencySensor(final isDeltaMeasurement=true));

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  // ** Physical constraints **
  parameter SI.Inertia J=10*P_el_n/(100*3.14)^2 "Lumped moment of inertia of whole power plant" annotation (Dialog(group="Physical Constraints"));

  // ** Statistics **
  parameter Integer nSubgrid=1 "Index of subgrid for moment of inertia statistics" annotation(Dialog(group="Statistics"));

  // ** Inititialization **
  parameter Boolean fixedStartValue_w = false "Whether or not the start value of the angular velocity of the plants mechanical components is fixed"
   annotation (Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true), Dialog(group="Initialization"));

  parameter SI.Efficiency eta_gen=1 "Generator efficiency" annotation(Dialog(group="Physical constraints"));

  parameter Boolean useFirstOrderPrimaryCntrl = true "use first order block to delay primary control power" annotation(Dialog(group="Expert Settings"));

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  Real delta_P_star = (P_el_set+P_el_is)/P_el_n;

  replaceable TransiEnt.Components.Electrical.Machines.ActivePowerGenerator Generator(eta=eta_gen) constrainedby TransiEnt.Components.Electrical.Machines.Base.PartialActivePowerGenerator "Choice of generator model. The generator model must match the power port." annotation (Dialog(group="Replaceable Components"),choicesAllMatching=true, Placement(transformation(
        extent={{-18.5,-18},{18.5,18}},
        rotation=0,
        origin={39.5,-40})));

  replaceable TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem Exciter constrainedby TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.PartialExcitationSystem "Choice of excitation system model with voltage control" annotation (Dialog(group="Replaceable Components"),choicesAllMatching=true, Placement(transformation(
        extent={{-10,-10.5},{10,10.5}},
        rotation=-90,
        origin={62.5,16})));
  replaceable TransiEnt.Components.Mechanical.ConstantInertia MechanicalConnection(
    omega(fixed=fixedStartValue_w, start=2*simCenter.f_n*Modelica.Constants.pi),
    J=J,
    nSubgrid=nSubgrid,
    P_n=P_el_n) constrainedby TransiEnt.Components.Mechanical.Base.PartialMechanicalConnection annotation (choicesAllMatching=true, Placement(transformation(extent={{-28,-57},{4,-23}})));

  Modelica.Blocks.Math.Add      targetSum       annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={-60,8})));

  TransiEnt.Components.Boundaries.Mechanical.Power Turbine annotation (Placement(transformation(extent={{-74,-56},{-42,-26}})));

  TransiEnt.Basics.Blocks.FirstOrderWithGradientLim firstOrderWithGradientLim(
    Tau=1,
    initOption=1,
    evaluate_y_start=true) if useFirstOrderPrimaryCntrl
                           annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-84,36})));
  Modelica.Blocks.Sources.RealExpression maxGradient(y=primaryBalancingController.maxGradientPrCtrl*primaryBalancingController.P_n) if useFirstOrderPrimaryCntrl
                                                                                                                                    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-78,74})));
  Modelica.Blocks.Sources.RealExpression minGrad(y=-primaryBalancingController.maxGradientPrCtrl*primaryBalancingController.P_n) if useFirstOrderPrimaryCntrl
                                                                                                                                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-90,74})));
  Modelica.Blocks.Math.Gain dummy(k=1) if not useFirstOrderPrimaryCntrl
                                       annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=270,
        origin={-47,37})));
equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  is_running = true "continuous plant";
  eta = eta_total "Constant efficiency";

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(MechanicalConnection.mpp_b, Generator.mpp) annotation (Line(
      points={{4,-40},{12,-40},{12,-40},{21,-40}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(gridFrequencySensor.mpp, MechanicalConnection.mpp_b) annotation (Line(
      points={{33.2,54},{12,54},{12,-40},{4,-40}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(Generator.epp, epp) annotation (Line(
      points={{58.185,-40.18},{100.093,-40.18},{100.093,78},{100,78}},
      color={0,0,0},
      smooth=Smooth.None));

  connect(Turbine.mpp, MechanicalConnection.mpp_a) annotation (Line(points={{-42,-41},{-34,-41},{-34,-40},{-28,-40}}, color={95,95,95}));
  connect(targetSum.y, Turbine.P_mech_set) annotation (Line(points={{-60,1.4},{-58,1.4},{-58,-23.3}},               color={0,0,127}));
  connect(Exciter.y, Generator.E_input) annotation (Line(points={{62.5,5.4},{62.5,-8.3},{38.945,-8.3},{38.945,-22.18}}, color={0,0,127}));
  connect(Exciter.epp1, epp) annotation (Line(
      points={{62.5,26},{80,26},{80,78},{100,78}},
      color={0,135,135},
      thickness=0.5));
  connect(firstOrderWithGradientLim.u, primaryBalancingController.P_PBP_set) annotation (Line(points={{-84,48},{-84,54},{-28.6,54}}, color={0,0,127}));
  connect(maxGradient.y, firstOrderWithGradientLim.maxGrad) annotation (Line(points={{-78,63},{-78,48}}, color={0,0,127}));
  connect(minGrad.y, firstOrderWithGradientLim.minGrad) annotation (Line(points={{-90,63},{-90,48}}, color={0,0,127}));
  connect(P_el_set, targetSum.u1) annotation (Line(points={{-60,100},{-60,24},{-56.4,24},{-56.4,15.2}}, color={0,127,127}));
  connect(firstOrderWithGradientLim.y, targetSum.u2) annotation (Line(points={{-84,25},{-84,18},{-63.6,18},{-63.6,15.2}}, color={0,0,127}));
  connect(dummy.y, targetSum.u2) annotation (Line(points={{-47,31.5},{-47,26},{-63.6,26},{-63.6,15.2}}, color={0,0,127}));
  connect(dummy.u, primaryBalancingController.P_PBP_set) annotation (Line(points={{-47,43},{-47,54},{-28.6,54}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
                                 Diagram(coordinateSystem(preserveAspectRatio=false,
                   extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Model contains a total efficiency, statistics adapters and a primary balancing controller.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p>- Power plant model is &quot;always on&quot;</p>
<p>- Output is not constrained by gradient or capacity limits</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Type of electrical power port can be chosen</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_el_set: input for electric power in [W] (setpoint for electric power)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_SB_set: input for electric power in [W] (secondary balancing setpoint)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in check model &quot;TransiEnt.Producer.Electrical.Conventional.Components.Check.CheckSimplePowerPlant&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model generalized for different electrical power ports by Jan-Peter Heckel (jan.heckel@tuhh.de) in July 2018 </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Robert Flesch (flesch@xrg-simulation.de) in Feb 2021: introduced firstOrder behavior for primary control power; slewRateLimiter in control can be deactivated and limiting is done in firstOrder as this performs better numerically</span></p>
</html>"));
end SimplePowerPlant;
