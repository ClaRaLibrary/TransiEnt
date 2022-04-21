within TransiEnt.Grid.Electrical.Noise.Base;
model LumpedGridDynamicModel "Electric grid dynamic model considering self regulating effect, primary balancing provision and time constant of rotating masses"



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

  extends TransiEnt.Basics.Icons.ElectricSubModel;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn delta_P_Z "Input for power difference" annotation (Placement(transformation(extent={{-106,-10},{-86,10}}), iconTransformation(extent={{-106,-10},{-86,10}})));

  TransiEnt.Basics.Interfaces.General.FrequencyOut f "Output for frequency" annotation (Placement(transformation(extent={{94,-10},{114,10}}), iconTransformation(extent={{94,-10},{114,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Math.Gain Delta_P_V_is(k=-k_pf) annotation (Placement(transformation(extent={{16,54},{-4,74}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=2) annotation (Placement(transformation(extent={{-36,16},{-24,28}})));
  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(extent={{58,54},{38,74}})));
  Modelica.Blocks.Nonlinear.Limiter Delta_P_pr_is(uMax=Delta_P_pr_max, uMin=-
        Delta_P_pr_max)
    annotation (Placement(transformation(extent={{-40,-36},{-60,-16}})));
  TransiEnt.Basics.Blocks.VariableSlewRateLimiter slewRateLimiter(maxGrad_const=Delta_P_pr_dot_max,
    Td=5,
    useThresh=true,
    thres=1e-9)                                                                                     annotation (Placement(transformation(extent={{-4,-36},{-24,-16}})));
  Modelica.Blocks.Continuous.Integrator f_star(
    k=1/T_AN,
    y_start=1,
    initType=Modelica.Blocks.Types.Init.NoInit) annotation (Placement(transformation(extent={{0,12},{20,32}})));
  Modelica.Blocks.Sources.Constant f_0_Const(k=1)        annotation (Placement(transformation(extent={{88,54},{68,74}})));
  Modelica.Blocks.Math.Gain Dimf(k=f_0_star) annotation (Placement(transformation(extent={{62,12},{82,32}})));
  Modelica.Blocks.Math.MultiSum P_V(nu=2, k=fill(-1, P_V.nu)) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=90,
        origin={-42,54})));
  Modelica.Blocks.Math.Gain delta_pr(k=1/delta_P_pr)
                                                   annotation (Placement(transformation(extent={{28,-36},{8,-16}})));
  Modelica.Blocks.Math.MultiSum P_T(nu=3) annotation (Placement(transformation(extent={{-66,16},{-54,28}})));
  Modelica.Blocks.Sources.Constant P_0_Const(k=P_0) annotation (Placement(transformation(extent={{-92,60},{-72,80}})));
  Modelica.Blocks.Math.Feedback feedback1 annotation (Placement(transformation(extent={{56,-16},{36,-36}})));
  Modelica.Blocks.Sources.Constant f_02(k=1)        annotation (Placement(transformation(extent={{84,-36},{64,-16}})));

  parameter Real Delta_P_pr_dot_max=0.02/30;
  parameter Real Delta_P_pr_max=0.2;
  parameter Real delta_P_pr=0.2;
  parameter Real T_AN=10;
  parameter Real f_0_star=50;
  parameter Real P_0=1;
  parameter Real k_pf=1.5;

equation
  connect(feedback.y, Delta_P_V_is.u) annotation (Line(points={{39,64},{18,64}}, color={0,0,127}));
  connect(f_star.y, feedback.u2) annotation (Line(points={{21,22},{48,22},{48,56}}, color={0,0,127}));
  connect(f_0_Const.y, feedback.u1) annotation (Line(points={{67,64},{60.5,64},{56,64}}, color={0,0,127}));
  connect(Dimf.y, f) annotation (Line(points={{83,22},{94,22},{94,0},{104,0}},
                                                                 color={0,0,127}));
  connect(f_star.y, Dimf.u) annotation (Line(points={{21,22},{40,22},{60,22}}, color={0,0,127}));
  connect(multiSum.y, f_star.u) annotation (Line(points={{-22.98,22},{-12.49,22},{-2,22}}, color={0,0,127}));
  connect(Delta_P_V_is.y, P_V.u[1]) annotation (Line(points={{-5,64},{-26,64},{-44.1,64},{-44.1,60}}, color={0,0,127}));
  connect(delta_pr.y, slewRateLimiter.u) annotation (Line(points={{7,-26},{-2,-26}}, color={0,0,127}));
  connect(Delta_P_pr_is.u, slewRateLimiter.y) annotation (Line(points={{-38,-26},{-25,-26}}, color={0,0,127}));
  connect(P_V.y, multiSum.u[1]) annotation (Line(points={{-42,46.98},{-42,24.1},{-36,24.1}}, color={0,0,127}));
  connect(P_T.y, multiSum.u[2]) annotation (Line(points={{-52.98,22},{-44,22},{-44,19.9},{-36,19.9}}, color={0,0,127}));
  connect(Delta_P_pr_is.y, P_T.u[1]) annotation (Line(points={{-61,-26},{-60,-26},{-74,-26},{-74,24.8},{-66,24.8}}, color={0,0,127}));
  connect(P_T.u[2], delta_P_Z) annotation (Line(points={{-66,22},{-82,22},{-82,0},{-96,0}},    color={0,0,127}));
  connect(P_0_Const.y, P_V.u[2]) annotation (Line(points={{-71,70},{-39.9,70},{-39.9,60}}, color={0,0,127}));
  connect(P_0_Const.y, P_T.u[3]) annotation (Line(points={{-71,70},{-66,70},{-66,66},{-66,38},{-66,36},{-80,36},{-80,19.2},{-66,19.2}}, color={0,0,127}));
  connect(feedback1.y, delta_pr.u) annotation (Line(points={{37,-26},{33.5,-26},{30,-26}}, color={0,0,127}));
  connect(feedback1.u2, f_star.y) annotation (Line(points={{46,-18},{48,-18},{48,26},{48,22},{21,22}}, color={0,0,127}));
  connect(f_02.y, feedback1.u1) annotation (Line(points={{63,-26},{58.5,-26},{54,-26}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The frequency behaviour of the electric grid is modeled when a power imbalance (delta_P_Z) is introduced. Considered effects are rotating masses of generators (time constant), self regulating effects and primary balancing control. The purpose is to invert this model such that a measured frequency is the input and the underlying power imbalances can be simulated.</span></p>
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
end LumpedGridDynamicModel;
