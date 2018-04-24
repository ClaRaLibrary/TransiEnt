within TransiEnt.Consumer.DemandSideManagement.PVBatteryPoolControl.Controller;
model BatteryPrimaryBalancingController
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

  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  parameter Real k_loading=1.2 "Gain of setpoint while loading (to balance energy losses)";
  parameter Real SOC_low=0.5 "If SOC is below this threshold, the primary balancing setpoint can be increased using a gain factor (to prevent storage running empty)";
  parameter SI.Frequency delta_f_db=0.01 "Frequency deadband of primary control";
  parameter Real delta_pr=0.2 "droop of primary balancing control (delta_pr = delta_f / delta_P)";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Producer.Electrical.Controllers.PrimaryBalancingControllerDeadband P_PBP_set(
    delta_pr=delta_pr,
    delta_f_db=delta_f_db,
    P_nom=P_nom) annotation (Placement(transformation(extent={{-88,44},{-68,64}})));
  Modelica.Blocks.Math.Product P_el_PBP_set_star annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={44,12})));
  Modelica.Blocks.Interfaces.RealInput P_el_pbp_band_set "Assigned primary balancing power bandwidth of unit (dtermined by pool controller)" annotation (Placement(transformation(extent={{-120,-100},{-80,-60}})));
  Modelica.Blocks.Interfaces.RealInput delta_f "Connector of Real input signal" annotation (Placement(transformation(extent={{-120,60},{-80,100}})));
  Modelica.Blocks.Interfaces.RealOutput P_el_pbp_set "Actual setpoint of frequency control" annotation (Placement(transformation(extent={{96,-38},{116,-18}}), iconTransformation(extent={{96,-38},{116,-18}})));
  Modelica.Blocks.Interfaces.RealInput SOC "Connector of Real input signal 2"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Logical.And loadRequestAndLowSOC annotation (Placement(transformation(extent={{-32,-1},{-18,13}})));
  Modelica.Blocks.Sources.Constant const120(k=k_loading)
    annotation (Placement(transformation(extent={{-22,24},{-8,38}})));
  Modelica.Blocks.Logical.LessThreshold isLowSOC(threshold=SOC_low) annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{2,-4},{22,16}})));
  Modelica.Blocks.Sources.Constant constOne(k=1) annotation (Placement(
        transformation(
        extent={{-7,-7},{7,7}},
        rotation=0,
        origin={-17,-17})));
  Modelica.Blocks.Logical.GreaterThreshold isOverFrequency annotation (Placement(transformation(extent={{-58,18},{-44,32}})));

  Modelica.Blocks.Nonlinear.VariableLimiter
                                    P_PBP_limit_star(
    strict=true) annotation (Placement(transformation(extent={{72,-38},{92,-18}})));
  Modelica.Blocks.Math.Gain gain(k=-1)
    annotation (Placement(transformation(extent={{44,-42},{56,-30}})));
  parameter Real P_nom "Nominal power of primary control";
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(delta_f, P_PBP_set.delta_f) annotation (Line(
      points={{-100,80},{-58,80},{-58,68},{-92,68},{-92,54},{-89,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_PBP_set.P_PBP_set, P_el_PBP_set_star.u1) annotation (Line(
      points={{-67.4,54},{24,54},{24,18},{32,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(loadRequestAndLowSOC.u2, isLowSOC.y) annotation (Line(
      points={{-33.4,0.4},{-40,0.4},{-40,0},{-45,0}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(P_el_PBP_set_star.u2, switch1.y) annotation (Line(
      points={{32,6},{23,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch1.u1, const120.y) annotation (Line(
      points={{0,14},{-4,14},{-4,31},{-7.3,31}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch1.u3, constOne.y) annotation (Line(
      points={{0,-2},{-6,-2},{-6,-17},{-9.3,-17}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(loadRequestAndLowSOC.y, switch1.u2) annotation (Line(
      points={{-17.3,6},{0,6}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(loadRequestAndLowSOC.u1, isOverFrequency.y) annotation (Line(
      points={{-33.4,6},{-39,6},{-39,25},{-43.3,25}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(P_PBP_set.P_PBP_set, isOverFrequency.u) annotation (Line(
      points={{-67.4,54},{-64,54},{-64,25},{-59.4,25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(isLowSOC.u, SOC) annotation (Line(points={{-68,0},{-100,0}}, color={0,0,127}));
  connect(P_PBP_limit_star.y, P_el_pbp_set) annotation (Line(points={{93,-28},{106,-28}}, color={0,0,127}));
  connect(P_el_PBP_set_star.y, P_PBP_limit_star.u) annotation (Line(points={{55,12},{58,12},{58,-28},{70,-28}}, color={0,0,127}));
  connect(gain.y, P_PBP_limit_star.limit2) annotation (Line(points={{56.6,-36},{62,-36},{70,-36}}, color={0,0,127}));
  connect(P_el_pbp_band_set, gain.u) annotation (Line(points={{-100,-80},{-82,-80},{28,-80},{28,-36},{42.8,-36}}, color={0,0,127}));
  connect(P_PBP_limit_star.limit1, P_el_pbp_band_set) annotation (Line(points={{70,-20},{28,-20},{28,-80},{-100,-80}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          Icon(coordinateSystem(extent={{-100,-100},{100,100}},
                              preserveAspectRatio=false)),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Primary balancing controller that can be used for battery systems. The control is characterized by</p>
<p>- proportional behaviour (droop control)</p>
<p>- a frequency deadband</p>
<p>- a saturation block limiting the control setpoint to the available power reserve</p>
<p><br>- the option to increase setpoints by a constant gain when the storage capacity is low and the frequency control action requires a loading of the storage (overfrequency) in order to use the control action as a battery conditioing measure</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The control output is limited by the units reserved power which is passed to the model by a real input connector</p>
<p>while a frequency deadband is considered, there is no limit with respect to</p>
<p>- communication intervall or dynamic</p>
<p>- minimum increments of setpoints</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>see above</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>delta_f: Is the deviation of frequency of its nominal value in Hz</p>
<p>P_el_pbp_band_set: <code><span style=\"color: #006400;\">A</span>ssigned primary balancing power bandwidth of unit (dtermined by pool controller) eqals maximum control power of unti</code></p>
<p>SOC: is the state of charge of the unit</p>
<p>P_el_pbp_set: Is the resulting setpoint for the controlled unit (zero if frequency equals nominal frequency)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>See interfaces.</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>P_pbp = (f - f_nom) / f_nom / droop * P_pbp_max</p>
<h4><span style=\"color: #008000\">7. Remarsk for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end BatteryPrimaryBalancingController;
