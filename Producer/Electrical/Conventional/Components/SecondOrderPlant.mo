within TransiEnt.Producer.Electrical.Conventional.Components;
model SecondOrderPlant "Second order transient behaviour, no states, no additional controller"
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

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  //General parameters

  parameter Real P_el_max = 1.00 "Maximum load in % of nominal power (decimal expression)" annotation(Dialog(group="Physical Constraints"));
  parameter Real P_el_min = 0.30 "Minimum load in % of nominal power (decimal expression)" annotation(Dialog(group="Physical Constraints"));
  parameter Real P_el_grad= 0.025 "Ramp rate in % of nominal power per minute (decimal expression)" annotation(Dialog(group="Physical Constraints"));

  parameter TransiEnt.Producer.Electrical.Base.PartloadEfficiency.PartloadEfficiencyCharacteristic PartLoadCharLine=TransiEnt.Producer.Electrical.Base.PartloadEfficiency.ConstantEfficiency() annotation (Dialog(group="Physical Constraints"), __Dymola_choicesAllMatching=true);

  parameter Real eta_gen=1 "Efficiency of the generator"
    annotation (Dialog(group="Physical Constraints"));
  // ** Physical constraints **
  parameter SI.Inertia J=10*P_el_n/(100*3.14)^2 "Lumped moment of inertia of whole power plant" annotation (Dialog(group="Physical Constraints"));

  // ** Statistics **
  parameter Integer nSubgrid=1 "Index of subgrid for moment of inertia statistics" annotation(Dialog(group="Statistics"));

  // ** Inititialization **
  parameter Boolean fixedStartValue_w = false "Wether or not the start value of the angular velocity of the plants mechanical components is fixed"
   annotation (Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true), Dialog(group="Initialization"));
  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Real delta_P_star = (P_el_set+P_el_is)/P_el_n;
  Real delta_f_star = (epp.f-simCenter.f_n)/simCenter.f_n;

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  Modelica.Blocks.Continuous.FirstOrder P_el_net(                        k=1, T=0.5*((0.632/P_el_grad)*60))
    annotation (Placement(              transformation(
        origin={30.1454,47.7058},
        extent={{-10.9091,-10.9091},{10.9091,10.9091}},
        rotation=0)));

  Modelica.Blocks.Continuous.FirstOrder Q_flow_source(                        k=
       1, T=0.5*((0.632/P_el_grad)*60))
          annotation (Placement(transformation(extent={{-17,38},{3,58}})));

  Modelica.Blocks.Math.Gain signChanger(k=-1)         annotation (Placement(
        transformation(
        extent={{-4,-4},{4,4}},
        rotation=270,
        origin={-60,72})));
  Modelica.Blocks.Tables.CombiTable1Ds eta_rel(
    columns={2},
    table=PartLoadCharLine.CL_eta_P,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative) annotation (Placement(transformation(extent={{-62,38},{-42,58}})));
  Modelica.Blocks.Sources.RealExpression nominalPower(y=P_el_n) annotation (Placement(transformation(extent={{-100,28},{-80,48}})));
  Modelica.Blocks.Math.Division relativeLoad annotation (Placement(transformation(extent={{-74,46},{-68,52}})));
  Modelica.Blocks.Math.Division Q_flow_set annotation (Placement(transformation(extent={{-30,45},{-24,51}})));
  Modelica.Blocks.Math.Product product annotation (Placement(transformation(extent={{52,44},{58,50}})));
  Modelica.Blocks.Sources.RealExpression eta_max(y=eta_total) "maximum efficiency (nominal)" annotation (Placement(transformation(extent={{-66,17},{-46,37}})));
  Modelica.Blocks.Math.Product eta_is annotation (Placement(transformation(extent={{-39,26},{-33,32}})));

  TransiEnt.Components.Boundaries.Mechanical.Power MechanicalBoundary(change_sign=true) annotation (Placement(transformation(extent={{8,-19},{28,-1}})));
  TransiEnt.Components.Mechanical.ConstantInertia MechanicalConnection(
    w(fixed=fixedStartValue_w, start=2*simCenter.f_n*Modelica.Constants.pi),
    J=J,
    nSubgrid=nSubgrid,
    P_n=P_el_n) annotation (choicesAllMatching=true, Placement(transformation(extent={{36,-20},{54,1}})));
  TransiEnt.Components.Electrical.Machines.ActivePowerGenerator Generator(eta=eta_gen) annotation (choicesAllMatching=true, Placement(transformation(
        extent={{-9.5,-9},{9.5,9}},
        rotation=0,
        origin={74.5,-9})));
equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  is_running = true "continuous plant";
  eta = eta_is.y "Constant efficiency";

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(Q_flow_source.y, P_el_net.u) annotation (Line(
      points={{4,48},{10,48},{10,47.7058},{17.0545,47.7058}},
      color={0,0,127}));

  connect(P_el_set, signChanger.u) annotation (Line(
      points={{-60,100},{-60,76.8}},
      color={0,0,127}));
  connect(eta_rel.u, relativeLoad.y) annotation (Line(
      points={{-64,48},{-66,48},{-66,49},{-67.7,49}},
      color={0,0,127}));
  connect(nominalPower.y, relativeLoad.u2) annotation (Line(
      points={{-79,38},{-78,38},{-78,47.2},{-74.6,47.2}},
      color={0,0,127}));
  connect(P_el_net.y, product.u1) annotation (Line(
      points={{42.1454,47.7058},{46.0727,47.7058},{46.0727,48.8},{51.4,48.8}},
      color={0,0,127}));
  connect(Q_flow_source.u, Q_flow_set.y) annotation (Line(
      points={{-19,48},{-23.7,48}},
      color={0,0,127}));
  connect(signChanger.y, relativeLoad.u1) annotation (Line(
      points={{-60,67.6},{-84,67.6},{-84,50},{-80,50},{-80,50.8},{-74.6,50.8}},
      color={0,0,127}));
  connect(signChanger.y, Q_flow_set.u1) annotation (Line(
      points={{-60,67.6},{-38,67.6},{-38,49.8},{-30.6,49.8}},
      color={0,0,127}));
  connect(Q_flow_set.u2, eta_is.y) annotation (Line(points={{-30.6,46.2},{-32,46.2},{-32,29},{-32.7,29}}, color={0,0,127}));
  connect(eta_max.y, eta_is.u2) annotation (Line(points={{-45,27},{-40,27},{-40,27.2},{-39.6,27.2}}, color={0,0,127}));
  connect(eta_rel.y[1], eta_is.u1) annotation (Line(points={{-41,48},{-40,48},{-40,30.8},{-39.6,30.8}}, color={0,0,127}));
  connect(eta_is.y, product.u2) annotation (Line(points={{-32.7,29},{52.15,29},{52.15,45.2},{51.4,45.2}}, color={0,0,127}));
  connect(MechanicalConnection.mpp_b,Generator. mpp) annotation (Line(points={{54,-9.5},{60,-9.5},{60,-9.45},{64.525,-9.45}},     color={95,95,95}));
  connect(MechanicalBoundary.mpp,MechanicalConnection. mpp_a) annotation (Line(points={{28,-10},{36,-10},{36,-9.5}},  color={95,95,95}));
  connect(Generator.epp, epp) annotation (Line(
      points={{84.095,-9.09},{100.093,-9.09},{100.093,60},{100,60}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(product.y, MechanicalBoundary.P_mech_set) annotation (Line(points={{58.3,47},{68,47},{68,16},{18,16},{18,0.62}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
    Text( lineColor={255,255,0},
        extent={{-42,-84},{18,-24}},
          textString="PT2")}),            Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This simple power plant model takes the target power output as an input (u) and considers a given ramp rate (P_el_grad in &percnt; P_el_n per minute) to deliver a power output (epp.P).</p>
<p>The model can be tested with the following examples: </p>
<ul>
<li><span style=\"color: #5500ff;\">TransiEnt.Producer.Electrical.Conventional.Check.TestSecondOrderContiuousPlant_PlantStart</span> and </li>
<li><span style=\"color: #5500ff;\">TransiEnt.Producer.Electrical.Conventional.Check.TestSecondOrderContiuousPlant_VDIVDE3507</span></li>
</ul>
<p>The model calculates the plant&apos;s fuel consumption based on the plant&apos;s efficiency, which in turn is dependent on the plant&apos;s operation point.</p>
<p>An example of the usage of this component be found in TransiEnt.Producer.Electrical.Conventional.Check.TestSecondOrderContiuousPlant</p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">The model can be used once the following <b>parameters</b> have been defined:</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: MS Shell Dlg 2;\">Physical restrictions:</span></p>
<p style=\"margin-left: 60px;\"><span style=\"font-family: MS Shell Dlg 2;\">P_nom: nominal power of the plant. It is used to calculate the plant&apos;s investment costs.</span></p>
<p style=\"margin-left: 60px;\"><span style=\"font-family: MS Shell Dlg 2;\">eta_total: nominal efficiency of the plant at full load. It is used together with the part load charline to calculate the plant&apos;s efficiency at different loads</span></p>
<p style=\"margin-left: 60px;\"><span style=\"font-family: MS Shell Dlg 2;\">PartLoadCharline: It is used together with the eta_load parametercalculate the plant&apos;s efficiency at different loads. For further description refer to the documentation of TransiEnt.Producer.Electrical.Base.RelativePartloadEfficiency</span></p>
<p style=\"margin-left: 60px;\"><span style=\"font-family: MS Shell Dlg 2;\">P_el_grad: </span></p>
<p style=\"margin-left: 60px;\"><span style=\"font-family: MS Shell Dlg 2;\">P_el_max and P_el_min are currently not in use. These restrictions should be taken into consideration by the power dispatch algorithm.</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: MS Shell Dlg 2;\">Statistics:</span></p>
<p style=\"margin-left: 60px;\"><span style=\"font-family: MS Shell Dlg 2;\">Type of resource: for energy allocation statistics</span></p>
<p style=\"margin-left: 60px;\"><span style=\"font-family: MS Shell Dlg 2;\">Type of primary energy carrier: for CO2 emissions calculation</span></p>
<p style=\"margin-left: 60px;\"><span style=\"font-family: MS Shell Dlg 2;\">Producer costs: for economic calcualations</span></p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<h4>Part load behaviour</h4>
<p>The part-load behaviour of the plant is calculated by multiyplying the nominal plant efficiency with the relative part load characteristic line of the <span style=\"font-family: MS Shell Dlg 2;\">selected </span>type of plant. </p>
<p align=\"center\"><img src=\"modelica://TransiEnt/Images/equations/equation-CVwKQBXP.png\" alt=\"eta_partload=eta_nom*eta_rel\"/></p>
<p><br><span style=\"font-family: MS Shell Dlg 2;\">Further details regarding the part load efficiencies can be found in the documentation of the package <span style=\"color: #5500ff;\">TransiEnt.Producer.Electrical.Base.RelativePartloadEfficiency</span></p>
<p>Typical resulting part load efficiencies are shown bellow:</p>
<p align=\"center\"><img src=\"modelica://TransiEnt/Images/PartloadEfficiency.tiff\"/></p>
<h4>Time-dependent behaviour</h4>
<p>This model makes use of simple proportionality rules to roughly depict the dynamic behaviour of a power plant&apos;s output to a certain extent. The model however is far from being a physically accurate model of the plant&apos;s dynamics. The model considers </p>
<p>The definition of the time constant (<img src=\"modelica://TransiEnt/Images/equations/equation-9Sd9qLFC.png\" alt=\"tau\"/>) of a first order linear time-invariant system is used to set the reference values of the proportionality, i.e. the time constant as the time after which the response of a system to a step function reaches the 63.2&percnt; of the set value.</p>
<p>Using proportionality rules, the time constant of the model&apos;s first order block is definied as a function of the power plant&apos;s nominal ramp rate as follows:</p>
<p align=\"center\"><br><img src=\"modelica://TransiEnt/Images/time_constant_proportionality.png\"/></p>
<p><br>This leads to the equation:</p>
<p align=\"center\"><img src=\"modelica://TransiEnt/Images/equations/equation-vTVwjPhj.png\" alt=\"tau/0.632=60/P_el_grad\"/></p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p><br>- This plant model is &QUOT;always on&QUOT; meaning that it reacts to power setpoint without delay even if current output is zero</p>
<p><br>- Control power provision is not implemented</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>u: RealInput</p>
<p>epp: ElectricPowerPort_L1 </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>no elements</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>no equations</p>
<h4><span style=\"color: #008000\">7. Remarsk for Usage</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">Recomended <b>nominal</b> <b>efficiencies</b> (based on Strau&szlig;, 2009):</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: MS Shell Dlg 2;\">Steam power plant (hard coal) --&GT; 0.40 - 0.45</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: MS Shell Dlg 2;\">Combined Cycle --&GT; 0.60</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: MS Shell Dlg 2;\">GasTurbines --&GT; 0.32</span></p>
<p><br>Recommended<b> ramp rates in</b> &percnt; P_el_n per minute (based on Brauner et. al., 2012):</p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: MS Shell Dlg 2;\">Steam power plant (hard coal) --&GT; 4 to 6</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: MS Shell Dlg 2;\">Steam power plant (lignite) --&GT; 2.5 to 4</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: MS Shell Dlg 2;\">Combined Cycle power plant --&GT; 4 to 8</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: MS Shell Dlg 2;\">Gas turbine --&GT; 12 to 15</span></p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Instead of a validation, the plausibility of the results will be model results has been roughly proofed.</p>
<p>The results obtained with this model in the test-model <span style=\"color: #5500ff;\">TransiEnt.Producer.Electrical.Conventional.Check.TestSecondOrderContiuousPlant_PlantStart</span> are shown bellow together with rough reference values from <span style=\"font-family: MS Shell Dlg 2;\">[2]</span> are displayed bellow.</p>
<p align=\"center\"><br><img src=\"modelica://TransiEnt/Images/PlantStart.png\"/></p>
<p align=\"center\"><span style=\"font-family: MS Shell Dlg 2;\"><img src=\"modelica://TransiEnt/Images/simple_powerplant_dynamics_brauner.jpg\"/></span></p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p><br>[1] Strau&szlig;, Karl: <i>Kraftwerkstechnik zur Nutzung fossiler, nuklearer und regenerativer Energiequellen</i>. 6. ed. Heidelberg&nbsp;: Springer-Verlag Berlin Heidelberg, 2009 &mdash;&nbsp;ISBN&nbsp;9783642014307</p>
<p><br>[2] Brauner, G&uuml;nther ; Glaunsinger, Wolfgang ; Bofinger, Stefan ; John, Markus ; Magin, Wendelin ; Pyc, Ireneusz ; Sch&uuml;ler, Steffen ; Schulz, Stephan ; Schwing, Ulrich ; et al.: <i>Erneuerbare Energie braucht flexible Kraftwerke - Szenarien bis 2020</i>&nbsp;: Verband der Elektrotechnik Elektronik Informationstechnik e.V., 2012</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>(no remarks)</p>
</html>"));
end SecondOrderPlant;
