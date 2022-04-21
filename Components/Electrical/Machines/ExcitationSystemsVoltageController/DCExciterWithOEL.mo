within TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController;
model DCExciterWithOEL "Simple Voltage Controller with PT1-dynamics with DC Exciter and OEL"



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

  extends TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.PartialExcitationSystem(redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp1);

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  parameter Modelica.Units.SI.Voltage v_n=simCenter.v_n "Nominal Voltage";
  parameter Real TA=0.1 "Time constant of Controller";
  parameter Real KA=80 "Gain of Controller";

  parameter Real TB=0.06 "Pole Lead";
  parameter Real TC=0.17 "Zero Lead";

  parameter Real TE=1 "Time constant of Exciter";
  parameter Real KE=0.5 "Gain of Exciter";

  parameter Real A=0.001 "coefficient for saturation";
  parameter Real B=1.5 "coefficient for saturation";

  parameter Real TST=1 "Time constantb of stabilization loop";
  parameter Real KST=0.5 "Gain of stabilization loop";

  parameter Real LimitofExcitation=2 "maximum factor of excitation (current)";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Continuous.FirstOrder firstOrder2(
    initType=Modelica.Blocks.Types.Init.SteadyState,
    k=1/KE,
    T=TE,
    y_start=v_n) annotation (Placement(transformation(extent={{-58,38},{-78,58}})));
  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(extent={{72,54},{56,38}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=v_n) annotation (Placement(transformation(extent={{50,-2},{70,18}})));

  TransiEnt.Components.Sensors.ElectricVoltageComplex electricVoltageComplex
    annotation (Placement(transformation(extent={{24,68},{44,88}})));

  Modelica.Blocks.Math.Feedback feedbackSaturation annotation (Placement(transformation(extent={{-24,36},{-44,56}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(
    initType=Modelica.Blocks.Types.Init.SteadyState,
    k=KA,
    T=TA,
    y_start=v_n) annotation (Placement(transformation(extent={{18,40},{6,52}})));
  Modelica.Blocks.Continuous.TransferFunction transferFunction(
    b={TC,1},
    a={TB,1},
    initType=Modelica.Blocks.Types.Init.SteadyState) annotation (Placement(transformation(extent={{34,40},{22,52}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=LimitofExcitation*v_n)
                                                        annotation (Placement(transformation(extent={{-4,40},{-16,52}})));
  Modelica.Blocks.Continuous.Derivative derivative(
    k=KST,
    T=TST,
    initType=Modelica.Blocks.Types.Init.SteadyState)             annotation (Placement(transformation(extent={{-16,4},{4,24}})));
  Modelica.Blocks.Math.Feedback feedback1
                                         annotation (Placement(transformation(extent={{54,38},{38,54}})));
  TransiEnt.Basics.Blocks.UserDefinedFunction userDefinedFunction(y=A*exp(B*(
        userDefinedFunction.u - v_n)/v_n))
    annotation (Placement(transformation(extent={{-64,20},{-40,32}})));
  Modelica.Blocks.Math.Add add1
                               annotation (Placement(transformation(extent={{10,-10},
            {-10,10}},
        rotation=90,
        origin={64,70})));
  replaceable TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.OverExcitationLimiter.OverExcitationLimiterSummation oEL_summation annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=90,
        origin={88,70})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(feedback.u1,realExpression1. y) annotation (Line(points={{70.4,46},{74,46},{74,8},{71,8}},
                                                                                     color={0,0,127}));
  connect(firstOrder2.y, y) annotation (Line(points={{-79,48},{-84,48},{-84,0},{106,0}}, color={0,0,127}));
  connect(y, y) annotation (Line(points={{106,0},{106,0}}, color={0,0,127}));
  connect(electricVoltageComplex.epp, epp1) annotation (Line(
      points={{24,78.2},{-100,78.2},{-100,0}},
      color={28,108,200},
      thickness=0.5));
  connect(firstOrder1.u, transferFunction.y) annotation (Line(points={{19.2,46},{21.4,46}}, color={0,0,127}));
  connect(limiter.u, firstOrder1.y) annotation (Line(points={{-2.8,46},{5.4,46}}, color={0,0,127}));
  connect(limiter.y, feedbackSaturation.u1) annotation (Line(points={{-16.6,46},{-26,46}}, color={0,0,127}));
  connect(feedbackSaturation.y, firstOrder2.u) annotation (Line(points={{-43,46},{-50,46},{-50,48},{-56,48}}, color={0,0,127}));
  connect(derivative.u, y) annotation (Line(points={{-18,14},{-50,14},{-50,12},{-84,12},{-84,0},{106,0}}, color={0,0,127}));
  connect(feedback.y, feedback1.u1) annotation (Line(points={{56.8,46},{52.4,46}}, color={0,0,127}));
  connect(feedback1.y, transferFunction.u) annotation (Line(points={{38.8,46},{35.2,46}}, color={0,0,127}));
  connect(derivative.y, feedback1.u2) annotation (Line(points={{5,14},{46,14},{46,39.6}},           color={0,0,127}));
  connect(userDefinedFunction.u, y) annotation (Line(points={{-66.4,26},{-84,26},
          {-84,0},{106,0}},                                                                        color={0,0,127}));
  connect(userDefinedFunction.y, feedbackSaturation.u2) annotation (Line(points={{-38.8,26},{-33.65,26},{-33.65,38},{-34,38}}, color={0,0,127}));
  connect(add1.u1, electricVoltageComplex.v)
    annotation (Line(points={{58,82},{58,90},{52,90},{52,84},{44,84}},
                                                       color={0,0,127}));
  connect(add1.y, feedback.u2)
    annotation (Line(points={{64,59},{64,52.4}}, color={0,0,127}));
  connect(oEL_summation.Voel, add1.u2) annotation (Line(points={{88,78},{88,92},{70,92},{70,82}},      color={0,0,127}));
  connect(oEL_summation.Vf, y) annotation (Line(points={{88,62},{88,0},{106,0}},                   color={0,0,127}));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Voltage Control with overexcitation limting</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>L2E only transfer functions with PT1-elements</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>No PSS</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>epp (ComplexPowerPort) for Voltage measurement and real output</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>voltage controller from literature</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] P. Kundur, &ldquo;Power system stability and control &rdquo;, EPRI Power System Engineering Series, Mc Graw Hill, 1993</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[2] &ldquo;IEEE Recommended Practice for Excitation System Models for Power System Stability Studies&rdquo;, in IEEE Std 421.5-2016 (Revision of IEEE Std 421.5-2005) , vol., no., pp.1-207, 26 Aug. 2016 doi: 10.1109/IEEESTD.2016.7553421 </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[3] T. Van Cutsem, &ldquo;Excitation systems and automatic voltage regulators&rdquo, lecture material &ldquo;Power system dynamics, control and stability&rdquo;, 2018 </span></p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Jan-Peter Heckel (jan.heckel@tuhh.de), Aug 2018</p>
<p>OEL added by Zahra Nadia Faili (zahra.faili@nithh.de), July 2019</p>
</html>"),
Icon(graphics,
     coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                                   Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end DCExciterWithOEL;
