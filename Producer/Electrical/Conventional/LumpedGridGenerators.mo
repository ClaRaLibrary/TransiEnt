within TransiEnt.Producer.Electrical.Conventional;
model LumpedGridGenerators "Lumped model of a number of generators for the use in a non-detailed electric grid model (including primary and secondary control models)"



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

  extends TransiEnt.Producer.Electrical.Base.PartialDispatchablePowerPlant(redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.BrownCoal);
  extends TransiEnt.Producer.Electrical.Base.ControlPower.PartialBalancingPowerProvider(
      final typeOfBalancingPowerResource=typeOfResource,
      primaryBalancingController(
      P_n=P_el_n,
      providedDroop=delta_pr,
      k_part=k_pr,
      maxGradientPrCtrl=P_pr_grad_max_star,
      maxValuePrCtrl=P_pr_max_star),
      controlPowerModel(
      P_n=P_el_n,
      P_el_is = P_el_is,
      P_pr_max=primaryBalancingController.maxValuePrCtrl,
      P_grad_max_star=P_el_grad_max_SB,
      is_running=is_running,
      P_PB_set=primaryBalancingController.P_PBP_set,
      P_SB_set=secondaryBalancingController.y),
      final isExternalSecondaryController=false,
    redeclare final TransiEnt.Components.Sensors.MechanicalFrequency gridFrequencySensor(isDeltaMeasurement=true));

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  // **** Physical Constraints and Inititalization

 parameter SI.Time T_tc = simCenter.T_grid "Time constant of plant (For easy definition of J)" annotation(Dialog(group="Physical Constraints"));
  parameter SI.Inertia J=P_el_n*T_tc/(2*simCenter.f_n*Modelica.Constants.pi)^2 "Lumped moment of inertia of whole power plant" annotation (Dialog(group="Physical Constraints"));

  // **** Statistics

  parameter Integer nSubgrid=2 "Index of subgrid for moment of inertia statistics"  annotation(Dialog(group="Statistics"));

  // **** Primary Frequency Control
  parameter Real delta_pr=0.2 "Value used if plantType is set to 'Provided'" annotation(Dialog(group="Primary Frequency Control"));

  parameter Real P_pr_grad_max_star=0.02/30 "Two percent of design case power in 30s" annotation(Dialog(group="Primary Frequency Control"));
  parameter Real P_pr_max_star=0.2 "Two percent of design case power" annotation(Dialog(group="Primary Frequency Control"));
  parameter Real k_pr=1 "Participation factor primary control"   annotation(Dialog(group="Primary Frequency Control"));

  // **** Secondary Frequency Control
  parameter Real P_sec_grad_max_star=0.12/60 "Maximum secondary power gradient (= 12% in five Minutes)"  annotation(Dialog(enable=isSecondaryControlActive,group="Secondary Frequency Control"));
  parameter Real beta=1 "Gain of secondary balancing power"  annotation(Dialog(enable=isSecondaryControlActive,group="Secondary Frequency Control"));
  parameter Real T_r=20 "Time constant of secondary balancing power"    annotation(Dialog(enable=isSecondaryControlActive,group="Secondary Frequency Control"));
  parameter Real lambda_sec=1 "Sub grid participation factor"    annotation(Dialog(enable=isSecondaryControlActive,group="Secondary Frequency Control"));

  // **** Expert Settings

  parameter Boolean fixedStartValue_w = false "Whether or not the start value of the angular velocity of the plants mechanical components is fixed"
   annotation (Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true),Dialog(tab="Expert Settings"));

   Real delta_P_star = (P_el_set+P_el_is)/P_el_n;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Grid.Electrical.SecondaryControl.SecondaryBalancingController secondaryBalancingController(
    T_r=T_r,
    beta=beta,
    K_r=lambda_sec,
    is_singleton=false) annotation (Placement(transformation(
        extent={{11.5,-12},{-11.5,12}},
        rotation=0,
        origin={-11.5,18})));

  TransiEnt.Components.Boundaries.Mechanical.Power Turbine annotation (Placement(transformation(extent={{-78,-58},{-42,-22}})));
  replaceable TransiEnt.Components.Electrical.Machines.ActivePowerGenerator Generator(eta=1) constrainedby TransiEnt.Components.Electrical.Machines.Base.PartialActivePowerGenerator annotation (Dialog(tab="General", group="Replaceable Components"),choicesAllMatching=true, Placement(transformation(
        extent={{-18.5,-18},{18.5,18}},
        rotation=0,
        origin={39.5,-40})));
   replaceable TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem Exciter constrainedby TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.PartialExcitationSystem annotation (Dialog(tab="General", group="Replaceable Components"),choicesAllMatching=true, Placement(transformation(
        extent={{-10,-10.5},{10,10.5}},
        rotation=-90,
        origin={62.5,16})));
  TransiEnt.Components.Mechanical.ConstantInertia MechanicalConnection(
    omega(fixed=fixedStartValue_w, start=2*simCenter.f_n*Modelica.Constants.pi),
    J=J,
    nSubgrid=nSubgrid) annotation (choicesAllMatching=true, Placement(transformation(extent={{-26,-57},{6,-23}})));

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_tie_is "Actual tie line power" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-10,100}), iconTransformation(
        extent={{-11,-11},{11,11}},
        rotation=270,
        origin={55,89})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_tie_set "Set point tie line power" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={30,100}), iconTransformation(
        extent={{-11,-11},{11,11}},
        rotation=270,
        origin={15,89})));

  Modelica.Blocks.Math.Sum sum1(nin=3) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-60,2})));

  Modelica.Blocks.Continuous.FirstOrder PT1Transient(k=1,
    y_start=0,
    T=0.632/(P_sec_grad_max_star),
    initType=Modelica.Blocks.Types.Init.InitialOutput)
    annotation (Placement(visible=true, transformation(
        origin={-39.4728,18},
        extent={{6.5272,-7},{-6.5272,7}},
        rotation=0)));
equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  is_running = true "continuous plant";
  eta = eta_total;

   // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(Turbine.mpp,MechanicalConnection. mpp_a) annotation (Line(
      points={{-42,-40},{-26,-40}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(MechanicalConnection.mpp_b,Generator. mpp) annotation (Line(
      points={{6,-40},{12,-40},{12,-40},{21,-40}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(gridFrequencySensor.mpp,MechanicalConnection. mpp_b) annotation (Line(
      points={{33.2,54},{30,54},{30,0},{10,0},{10,-40},{6,-40}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(Generator.epp, epp) annotation (Line(
      points={{58.185,-40.18},{100.093,-40.18},{100.093,78},{100,78}},
      color={0,0,0},
      smooth=Smooth.None));

  connect(P_el_set, sum1.u[1]) annotation (Line(points={{-60,100},{-60,14},{-61.3333,14}}, color={0,0,127}));
  connect(primaryBalancingController.P_PBP_set, sum1.u[2]) annotation (Line(points={{-28.6,54},{-60,54},{-60,14}},
                                                                                                                 color={0,0,127}));
  connect(gridFrequencySensor.f, secondaryBalancingController.u) annotation (Line(points={{13.6,54},{13.6,54},{8,54},{8,18},{2.3,18}},
                                                                                                                                     color={0,0,127}));
  connect(P_tie_is, secondaryBalancingController.P_tie_is) annotation (Line(points={{-10,100},{-10,70},{46,70},{46,36},{-6.67,36},{-6.67,28.92}},   color={0,0,127}));
  connect(secondaryBalancingController.P_tie_set, P_tie_set) annotation (Line(points={{-1.15,28.92},{-1.15,34},{54,34},{54,76},{30,76},{30,100}}, color={0,0,127}));
  connect(sum1.y, Turbine.P_mech_set) annotation (Line(points={{-60,-9},{-60,-18.76}},              color={0,0,127}));
  connect(secondaryBalancingController.y, PT1Transient.u) annotation (Line(points={{-24.15,18},{-31.6402,18}}, color={0,0,127}));
  connect(PT1Transient.y, sum1.u[3]) annotation (Line(points={{-46.6527,18},{-46.6527,18},{-58.6667,18},{-58.6667,14}}, color={0,0,127}));
  connect(Exciter.epp1, epp) annotation (Line(
      points={{62.5,26},{62,26},{62,78},{100,78}},
      color={0,135,135},
      thickness=0.5));
  connect(Exciter.y, Generator.E_input) annotation (Line(points={{62.5,5.4},{62.5,-8.3},{38.945,-8.3},{38.945,-22.18}}, color={0,0,127}));
     annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-62,-30},{28,-76}},
          lineColor={244,125,35},
          textString="G")}),     Diagram(graphics,
                                         coordinateSystem(preserveAspectRatio=false,
                   extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Lumped model of a number of generators for the use in a non-detailed electric grid model (including primary and secondary control models).</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model is a composition of a turbine model, an inertia model, a generator model with excitation system model and a primary controller.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">See base classes TransiEnt.Producer.Electrical.Base.PartialDispatchablePowerPlant and  for more information TransiEnt.Producer.Electrical.Base.ControlPower.PartialBalancingPowerProvider</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_el_set: input for electric power in [W] (setpoint for electric power)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_SB_set: input for electric power in [W] (secondary balancing setpoint)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_tie_set: input for electric power in [W] </span>&quot;Set point tie line power&quot;</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_tie_is: input for electric power in [W] </span>&quot;Actual tie line power&quot;</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">epp: active power port (choice of power port)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">checked in TransiEnt.Grid.Electrical.LumpedPowerGrid.Check</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end LumpedGridGenerators;
