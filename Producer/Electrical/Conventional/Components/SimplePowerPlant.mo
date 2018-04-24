within TransiEnt.Producer.Electrical.Conventional.Components;
model SimplePowerPlant "No transient behaviuor, no operating states, constant efficiency (with optional primary balancing controller)"

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Producer.Electrical.Base.PartialDispatchablePowerPlant;
  extends TransiEnt.Producer.Electrical.Base.ControlPower.PartialBalancingPowerProvider(
      final typeOfBalancingPowerResource=typeOfResource,
      primaryBalancingController(P_nom=P_el_n),
      controlPowerModel(
        P_nom=P_el_n,
        P_pr_max=primaryBalancingController.P_pr_max,
        isSecondaryControlActive=false,
        P_el_is = P_el_is,
        is_running=is_running,
        P_PB_set=primaryBalancingController.P_PBP_set),
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
  parameter Boolean fixedStartValue_w = false "Wether or not the start value of the angular velocity of the plants mechanical components is fixed"
   annotation (Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true), Dialog(group="Initialization"));

  parameter SI.Efficiency eta_gen=1 "Generator efficiency" annotation(Dialog(group="Physical constraints"));

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  Real delta_P_star = (P_el_set+P_el_is)/P_el_n;

  TransiEnt.Components.Electrical.Machines.ActivePowerGenerator Generator(eta=eta_gen) annotation (choicesAllMatching=true, Placement(transformation(
        extent={{-18.5,-18},{18.5,18}},
        rotation=0,
        origin={39.5,-40})));
  TransiEnt.Components.Mechanical.ConstantInertia MechanicalConnection(
    w(fixed=fixedStartValue_w, start=2*simCenter.f_n*Modelica.Constants.pi),
    J=J,
    nSubgrid=nSubgrid,
    P_n=P_el_n) annotation (choicesAllMatching=true, Placement(transformation(extent={{-28,-57},{4,-23}})));

  Modelica.Blocks.Math.MultiSum targetSum(nu=2) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={-60,8})));

  TransiEnt.Components.Boundaries.Mechanical.Power Turbine annotation (Placement(transformation(extent={{-74,-56},{-42,-26}})));

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
      points={{4,-40},{12,-40},{12,-40.9},{20.075,-40.9}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(gridFrequencySensor.mpp, MechanicalConnection.mpp_b) annotation (Line(
      points={{33.2,54},{12,54},{12,-40},{4,-40}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(Generator.epp, epp) annotation (Line(
      points={{58.185,-40.18},{100.093,-40.18},{100.093,60},{100,60}},
      color={0,0,0},
      smooth=Smooth.None));

  connect(primaryBalancingController.P_PBP_set, targetSum.u[1]) annotation (Line(
      points={{-28.6,54},{-58,54},{-58,14},{-57.9,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_el_set, targetSum.u[2]) annotation (Line(
      points={{-60,100},{-60,14},{-62.1,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Turbine.mpp, MechanicalConnection.mpp_a) annotation (Line(points={{-42,-41},{-34,-41},{-34,-40},{-28,-40}}, color={95,95,95}));
  connect(targetSum.y, Turbine.P_mech_set) annotation (Line(points={{-60,0.98},{-58,0.98},{-58,-23.3}},             color={0,0,127}));
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
<p>- Power plant model is &QUOT;always on&QUOT;</p>
<p>- Output is not constrained by gradient or capacity limits</p>
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
end SimplePowerPlant;
