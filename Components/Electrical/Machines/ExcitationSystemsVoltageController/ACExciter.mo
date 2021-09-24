within TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController;
model ACExciter "Simple Voltage Controller with PT1-dynamics with AC Exciter"


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

  extends TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.PartialExcitationSystem(redeclare TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp1);

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  parameter SI.Voltage v_n=simCenter.v_n "Nominal Voltage";
  parameter Real TA=0.1 "Time constant of Controller";
  parameter Real KA=100 "Gain of Controller";

  parameter Real TB=0.06 "Pole Lead";
  parameter Real TC=0.17 "Zero Lead";

  parameter Real TE=1 "Time constant of Exciter";
  parameter Real KE=1 "Gain of Exciter";

  parameter Real A=0.1 "coefficient for saturation";
  parameter Real B=0.03 "coefficient for saturation";

  parameter Real TST=1 "Time constantb of stabilization loop";
  parameter Real KST=0.5 "Gain of stabilization loop";

  parameter Real KD=0.38 "Konstant for load dependency";

  parameter Real R_g=0.5 "resistance of excitation circuit";

  parameter Real KC=1 "Gain of rectifier";


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
    T=TE,
    k=1,
    initType=Modelica.Blocks.Types.Init.SteadyState,
    y_start=v_n) annotation (Placement(transformation(extent={{-62,40},{-74,52}})));
  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(extent={{72,54},{56,38}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=v_n) annotation (Placement(transformation(extent={{98,36},{78,56}})));

  Sensors.ElectricVoltageComplex electricVoltageComplex annotation (Placement(transformation(extent={{24,68},{44,88}})));

  Modelica.Blocks.Continuous.FirstOrder firstOrder1(
    initType=Modelica.Blocks.Types.Init.SteadyState,
    k=KA,
    T=TA,
    y_start=v_n) annotation (Placement(transformation(extent={{22,40},{10,52}})));
  Modelica.Blocks.Continuous.TransferFunction transferFunction(
    b={TC,1},
    a={TB,1},
    initType=Modelica.Blocks.Types.Init.SteadyState,
    x_start={v_n}) annotation (Placement(transformation(extent={{38,40},{26,52}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=2*v_n) annotation (Placement(transformation(extent={{6,40},{-6,52}})));
  Modelica.Blocks.Continuous.Derivative derivative(
    k=KST,
    T=TST,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    x_start=0)                                                   annotation (Placement(transformation(extent={{26,-90},{46,-70}})));
  Modelica.Blocks.Math.Feedback feedback1
                                         annotation (Placement(transformation(extent={{56,38},{40,54}})));
  Modelica.Blocks.Math.Gain gain1(k=KD) annotation (Placement(transformation(extent={{-30,0},{-22,8}})));
  Modelica.Blocks.Math.Product product annotation (Placement(transformation(extent={{72,-4},{80,4}})));
  Modelica.Blocks.Math.Gain gain2(k=KC) annotation (Placement(transformation(extent={{18,6},{24,12}})));
  Modelica.Blocks.Math.Division division annotation (Placement(transformation(extent={{4,4},{14,14}})));
  Modelica.Blocks.Math.Gain gain(k=KE) annotation (Placement(transformation(extent={{-56,14},{-50,20}})));
  Modelica.Blocks.Math.Sum sum1(k={1,-1,-1,-1}, nin=4) annotation (Placement(transformation(extent={{-36,40},{-48,52}})));
  Basics.Blocks.UserDefinedFunction IFD(y=IFD.u/R_g) annotation (Placement(transformation(extent={{-52,0},{-40,10}})));
  Basics.Blocks.UserDefinedFunction FEX(y=if FEX.u <= 0.433 then 1 - 0.0577*FEX.u else if FEX.u > 0.433 and FEX.u < 0.75 then sqrt(0.75 - (FEX.u)^2) else 1.732*(1 - FEX.u)) annotation (Placement(transformation(extent={{40,2},{64,12}})));
  Basics.Blocks.UserDefinedFunction Saturation(y=A*exp(B*(Saturation.u - v_n)/v_n)) annotation (Placement(transformation(extent={{-70,24},{-46,36}})));
equation



  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(feedback.u1,realExpression1. y) annotation (Line(points={{70.4,46},{77,46}},
                                                                                     color={0,0,127}));
  connect(y, y) annotation (Line(points={{106,0},{106,0}}, color={0,0,127}));
  connect(electricVoltageComplex.v, feedback.u2) annotation (Line(points={{44,84},{54,84},{54,52.4},{64,52.4}},
                                                                                                            color={0,0,127}));
  connect(electricVoltageComplex.epp, epp1) annotation (Line(
      points={{24,78.2},{-100,78.2},{-100,0}},
      color={28,108,200},
      thickness=0.5));
  connect(firstOrder1.u, transferFunction.y) annotation (Line(points={{23.2,46},{25.4,46}}, color={0,0,127}));
  connect(limiter.u, firstOrder1.y) annotation (Line(points={{7.2,46},{9.4,46}},  color={0,0,127}));
  connect(feedback.y, feedback1.u1) annotation (Line(points={{56.8,46},{54.4,46}}, color={0,0,127}));
  connect(feedback1.y, transferFunction.u) annotation (Line(points={{40.8,46},{39.2,46}}, color={0,0,127}));
  connect(derivative.y, feedback1.u2) annotation (Line(points={{47,-80},{48,-80},{48,39.6}},        color={0,0,127}));
  connect(firstOrder2.y, derivative.u) annotation (Line(points={{-74.6,46},{-80,46},{-80,-80},{24,-80}},
                                                                                                       color={0,0,127}));
  connect(y, product.y) annotation (Line(points={{106,0},{80.4,0}}, color={0,0,127}));
  connect(product.u2, derivative.u) annotation (Line(points={{71.2,-2.4},{-80,-2.4},{-80,-80},{24,-80}}, color={0,0,127}));
  connect(division.y, gain2.u) annotation (Line(points={{14.5,9},{17.4,9}}, color={0,0,127}));
  connect(gain.u, derivative.u) annotation (Line(points={{-56.6,17},{-80,17},{-80,-80},{24,-80}}, color={0,0,127}));
  connect(firstOrder2.u, sum1.y) annotation (Line(points={{-60.8,46},{-48.6,46}}, color={0,0,127}));
  connect(IFD.y, gain1.u) annotation (Line(points={{-39.4,5},{-36.7,5},{-36.7,4},{-30.8,4}}, color={0,0,127}));
  connect(division.u1, gain1.u) annotation (Line(points={{3,12},{-34,12},{-34,4},{-30.8,4}}, color={0,0,127}));
  connect(FEX.y, product.u1) annotation (Line(points={{65.2,7},{65.2,8},{68,8},{68,2.4},{71.2,2.4}}, color={0,0,127}));
  connect(FEX.u, gain2.y) annotation (Line(points={{37.6,7},{30,7},{30,9},{24.3,9}}, color={0,0,127}));
  connect(division.u2, derivative.u) annotation (Line(points={{3,6},{-2,6},{-2,-2},{-8,-2},{-80,-2.4},{-80,-80},{24,-80}}, color={0,0,127}));
  connect(limiter.y, sum1.u[1]) annotation (Line(points={{-6.6,46},{-20,46},{-20,45.1},{-34.8,45.1}}, color={0,0,127}));
  connect(gain.y, sum1.u[2]) annotation (Line(points={{-49.7,17},{-49.7,18},{-34.8,18},{-34.8,45.7}},   color={0,0,127}));
  connect(gain1.y, sum1.u[3]) annotation (Line(points={{-21.6,4},{-28,4},{-28,46.3},{-34.8,46.3}}, color={0,0,127}));
  connect(Saturation.u, derivative.u) annotation (Line(points={{-72.4,30},{-80,30},{-80,-80},{24,-80}}, color={0,0,127}));
  connect(Saturation.y, sum1.u[4]) annotation (Line(points={{-44.8,30},{-36,30},{-36,46.9},{-34.8,46.9}}, color={0,0,127}));
  connect(IFD.u, derivative.u) annotation (Line(points={{-53.2,5},{-80,5},{-80,-80},{24,-80}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Voltage Control</p>
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
<p>simplest voltage controler</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] E. Handschin, &ldquo;Elektrische Energieübertragungssysteme&rdquo;, Dr. Alfred Hüthig Verlag Heidelberg, 2nd edition , 1987, p. 255</span></p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Jan-Peter Heckel (jan.heckel@tuhh.de), Apr 2018</p>
</html>"),
Icon(graphics,
     coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end ACExciter;
