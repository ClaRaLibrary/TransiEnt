within TransiEnt.Producer.Electrical.Conventional.Components;
model FourthOrderPlant "Transient behaviour by multiple first order systems according to VDI 3508, no states, no balancing controller"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

//  import TransiEnt;
  extends TransiEnt.Producer.Electrical.Base.PartialDispatchablePowerPlant(eta_total=Eff, P_el_n=
                                                                                                P_n);

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  //VDIVDE Parameters
  parameter Real Tu=60  annotation(Dialog(group="Physical Constraints"));
  parameter Real Tg=250 annotation(Dialog(group="Physical Constraints"));
  parameter Real Ts=130 annotation(Dialog(group="Physical Constraints"));

  //General parameters

  parameter Real Eff=0.40 "Electric efficiency of the power plant"
    annotation (Dialog(group="Physical Constraints"));

  parameter Real eta_gen=1 "Efficiency of the generator"
    annotation (Dialog(group="Physical Constraints"));

  parameter Modelica.SIunits.Power P_n "Nominal power in W"
  annotation(Dialog(group="Physical Constraints"));

  parameter Real Q_br_n = P_n / 0.40 "Rated thermal input"
    annotation(Dialog(group="Physical Constraints"));

  parameter Real alpha_HP_LP=0.162  annotation(Dialog(group="Physical Constraints"));

  // ** Physical constraints **
  parameter SI.Inertia J=10*P_el_n/(100*3.14)^2 "Lumped moment of inertia of whole power plant" annotation (Dialog(group="Physical Constraints"));

  // ** Statistics **
  parameter Integer nSubgrid=1 "Index of subgrid for moment of inertia statistics" annotation(Dialog(group="Statistics"));

  // ** Inititialization **
  parameter Boolean fixedStartValue_w = false "Whether or not the start value of the angular velocity of the plants mechanical components is fixed"
   annotation (Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true), Dialog(group="Initialization"));

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

     Real delta_P_star = (P_el_set+P_el_is)/P_el_n;

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_el_set "Electric power setpoint" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-60,100}), iconTransformation(
        extent={{-11,-11},{11,11}},
        rotation=270,
        origin={-15,99})));
  Modelica.Blocks.Sources.RealExpression ValveOpening(y=1)
    annotation (Placement(transformation(extent={{-22,54},{-2,74}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=Tg/1.5)
    annotation (Placement(transformation(extent={{-64,30},{-52,42}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T=2*Tu)
    annotation (Placement(transformation(extent={{-46,30},{-34,42}})));
  Modelica.Blocks.Continuous.Integrator integrator(k=1/Ts)
    annotation (Placement(transformation(extent={{-12,31},{0,42}})));
  Modelica.Blocks.Math.Product product1 annotation (Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=0,
        origin={12,38})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-30,42},{-18,30}})));
  Modelica.Blocks.Continuous.FirstOrder HPturbine(T=0.2, k=alpha_HP_LP)
    annotation (Placement(transformation(extent={{28,46},{40,58}})));
  Modelica.Blocks.Continuous.FirstOrder LPturbine(T=25, k=1 - alpha_HP_LP)
    annotation (Placement(transformation(extent={{26,18},{38,30}})));
  Modelica.Blocks.Math.Gain nominalToRelativeConverter(k=1/Q_br_n)
    annotation (Placement(transformation(extent={{-78,32},{-70,40}})));
  Modelica.Blocks.Math.Gain relativeToNominal(k=1*P_n)
    annotation (Placement(transformation(extent={{58,35},{64,41}})));
  Modelica.Blocks.Math.Add sum annotation (Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=0,
        origin={50,38})));
  Modelica.Blocks.Math.Gain efficiency(k=1/eta_total) annotation (Placement(
        transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-74,60})));
  TransiEnt.Components.Boundaries.Mechanical.Power MechanicalBoundary(change_sign=true) annotation (Placement(transformation(extent={{8,-23},{28,-5}})));
  TransiEnt.Components.Mechanical.ConstantInertia MechanicalConnection(
    omega(fixed=fixedStartValue_w, start=2*simCenter.f_n*Modelica.Constants.pi),
    J=J,
    nSubgrid=nSubgrid,
    P_n=P_el_n) annotation (choicesAllMatching=true, Placement(transformation(extent={{36,-24},{54,-3}})));
  replaceable TransiEnt.Components.Electrical.Machines.ActivePowerGenerator Generator(eta=eta_gen)  constrainedby TransiEnt.Components.Electrical.Machines.Base.PartialActivePowerGenerator "Choice of generator model. The generator model must match the power port." annotation (Dialog(group="Replaceable Components"), choicesAllMatching=true, Placement(transformation(
        extent={{-9.5,-9},{9.5,9}},
        rotation=0,
        origin={74.5,-13})));
  replaceable TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem Exciter constrainedby TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.PartialExcitationSystem "Choice of excitation system model with voltage control" annotation (Dialog(group="Replaceable Components"),choicesAllMatching=true, Placement(transformation(
        extent={{-10,-10.5},{10,10.5}},
        rotation=-90,
        origin={86.5,18})));
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

  connect(firstOrder.y, firstOrder1.u) annotation (Line(
      points={{-51.4,36},{-47.2,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ValveOpening.y, product1.u2) annotation (Line(
      points={{-1,64},{4,64},{4,40.4},{7.2,40.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(integrator.y, product1.u1) annotation (Line(
      points={{0.6,36.5},{4,36.5},{4,35.6},{7.2,35.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder1.y, feedback.u1) annotation (Line(
      points={{-33.4,36},{-28.8,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(integrator.u, feedback.y) annotation (Line(
      points={{-13.2,36.5},{-16,36.5},{-16,36},{-18.6,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product1.y, feedback.u2) annotation (Line(
      points={{16.4,38},{22,38},{22,54},{-24,54},{-24,40.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product1.y, HPturbine.u) annotation (Line(
      points={{16.4,38},{24,38},{24,52},{26.8,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product1.y, LPturbine.u) annotation (Line(
      points={{16.4,38},{24,38},{24,24},{24.8,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.u, nominalToRelativeConverter.y) annotation (Line(
      points={{-65.2,36},{-69.6,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HPturbine.y, sum.u2) annotation (Line(
      points={{40.6,52},{42,52},{42,41},{46,41},{46,40.4},{45.2,40.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(LPturbine.y, sum.u1) annotation (Line(
      points={{38.6,24},{40,24},{40,35.6},{45.2,35.6}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(efficiency.y, nominalToRelativeConverter.u) annotation (Line(
      points={{-80.6,60},{-96,60},{-96,36},{-78.8,36}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(P_el_set, efficiency.u) annotation (Line(points={{-60,100},{-60,100},{-60,60},{-66.8,60}},
                                         color={0,0,127}));
  connect(relativeToNominal.u, sum.y) annotation (Line(points={{57.4,38},{57.4,38},{54.4,38}},
                                                                                             color={0,0,127}));
  connect(Generator.epp, epp) annotation (Line(
      points={{84.095,-13.09},{100.093,-13.09},{100.093,78},{100,78}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(MechanicalConnection.mpp_b, Generator.mpp) annotation (Line(points={{54,-13.5},{60,-13.5},{60,-13},{65,-13}},           color={95,95,95}));
  connect(MechanicalBoundary.mpp, MechanicalConnection.mpp_a) annotation (Line(points={{28,-14},{36,-14},{36,-13.5}}, color={95,95,95}));
  connect(relativeToNominal.y, MechanicalBoundary.P_mech_set) annotation (Line(points={{64.3,38},{68,38},{68,8},{18,8},{18,-3.38}}, color={0,0,127}));
  connect(Exciter.epp1, epp) annotation (Line(
      points={{86.5,28},{86,28},{86,78},{100,78}},
      color={0,135,135},
      thickness=0.5));
  connect(Exciter.y, Generator.E_input) annotation (Line(points={{86.5,7.4},{86,7.4},{86,2},{74.215,2},{74.215,-4.09}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
    Text( lineColor={255,255,0},
        extent={{-40,-84},{20,-24}},
          textString="PT4")}),            Diagram(graphics,
                                                  coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is based on the simplified representation of a power station unit found in the norm VDI/VDE 3508. </p>
<p>The model takes the set value of the electric power output (P_Target) and translates it to a change into a target thermal input. Meanwhile, the turbine valve aperture remains completely opened. Thus, the model is in <b>natural sliding-pressure operation</b> <b>mode</b>.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The model is based on typical time responses of the power plant components. No phyisical modeling has been conducted.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>- This plant model is &QUOT;always on&QUOT; meaning that it reacts to power setpoint without delay even if current output is zero</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- Control power provision is not implemented</span> (dynamics are then different)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>P_Target: receives the target value of the electric power in W</p>
<p>epp: type of electrical power port can be chosen </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>The values of Tu, Tg, Ts can be found in the norm. The following table summarizes these values:</p>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"1\" width=\"100%\"><tr>
<td></td>
<td><p><br><br><br>Recirculation steam generator (drum)</p></td>
<td><p><span style=\"font-family: MS Shell Dlg 2;\">Once-through steam generator</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: MS Shell Dlg 2;\">Oil and gas</span></p></td>
<td><p><span style=\"font-family: MS Shell Dlg 2;\">Tu=5...10s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Tg=60s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Ts=130...250s</span></p></td>
<td><p><span style=\"font-family: MS Shell Dlg 2;\">Tu=5...10s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Tg=60...150s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Ts=40...120s</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: MS Shell Dlg 2;\">Hard coal with liquid slag removal</span></p></td>
<td><p><span style=\"font-family: MS Shell Dlg 2;\">Tu=120s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Tg=200s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Ts=130...250s</span></p></td>
<td><p><span style=\"font-family: MS Shell Dlg 2;\">Tu=50...200s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Tg=200s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Ts=60...100s</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: MS Shell Dlg 2;\">Hard coal with dry slag removal</span></p></td>
<td><p><span style=\"font-family: MS Shell Dlg 2;\">Tu=20...60s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Tg=150s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Ts=130...250s</span></p></td>
<td><p><span style=\"font-family: MS Shell Dlg 2;\">Tu=20...60s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Tg=150...250s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Ts=60...140s</span></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: MS Shell Dlg 2;\">Brown coal</span></p></td>
<td><p><span style=\"font-family: MS Shell Dlg 2;\">Tu=30...60s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Tg=250s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Ts=130...250s</span></p></td>
<td><p><span style=\"font-family: MS Shell Dlg 2;\">Tu=30...60s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Tg=250s</span></p><p><span style=\"font-family: MS Shell Dlg 2;\">Ts=60...140s</span></p></td>
</tr>
</table>
<p><br><h4><span style=\"color: #008000\">8. Validation</span></h4></p>
<p>According to [1] Chapter 7, &QUOT;in the operating mode &QUOT;steam generator in control&QUOT;... the actual output follows the setpoint after the unit delay, which results from the delay within the controlled power station (Fig. 22a). </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] VDI/VDE3508</p>
<p>Pitscheider, 2007</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Ricardo Peniche</p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model generalized for different electrical power ports by Jan-Peter Heckel (jan.heckel@tuhh.de) in July 2018 </span></p>
</html>"));
end FourthOrderPlant;
