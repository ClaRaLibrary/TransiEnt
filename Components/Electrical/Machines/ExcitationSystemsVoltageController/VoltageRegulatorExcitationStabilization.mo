within TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController;
model VoltageRegulatorExcitationStabilization "Simple Voltage Controller with PT1-dynamics of excitation and stabilization by feedback"


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
  parameter Real KA=70 "Gain of Controller";
  parameter Real TE=1 "Time constant of Exciter";
  parameter Real KE=0.5 "Gain of Exciter";
  parameter Real Tr=2 "Time constant of machine";
  parameter Real Kr=1 "Gain of machine";
  parameter Real TST=1 "Time constantb of stabilization loop";
  parameter Real KST=0.5 "Gain of stabilization loop";


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

  Modelica.Blocks.Continuous.FirstOrder firstOrder(
    k=KA,
    T=TA,
    initType=Modelica.Blocks.Types.Init.SteadyState,
    y_start=1.94444*v_n) annotation (Placement(transformation(extent={{10,36},{-10,56}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(
    k=KE,
    T=TE,
    initType=Modelica.Blocks.Types.Init.SteadyState,
    y_start=0.97222*v_n) annotation (Placement(transformation(extent={{-18,36},{-38,56}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(
    k=Kr,
    T=Tr,
    initType=Modelica.Blocks.Types.Init.SteadyState,
    y_start=0.97222*v_n) annotation (Placement(transformation(extent={{-66,36},{-86,56}})));
  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(extent={{64,56},{44,36}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=v_n) annotation (Placement(transformation(extent={{94,36},{74,56}})));
  Modelica.Blocks.Continuous.Derivative derivative(k=KST, T=TST,
    initType=Modelica.Blocks.Types.Init.SteadyState)             annotation (Placement(transformation(extent={{-30,6},{-10,26}})));
  Modelica.Blocks.Math.Feedback feedback1
                                         annotation (Placement(transformation(extent={{40,36},{20,56}})));

  Sensors.ElectricVoltageComplex electricVoltageComplex annotation (Placement(transformation(extent={{24,68},{44,88}})));

equation


  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________


  connect(firstOrder1.y,firstOrder2. u) annotation (Line(points={{-39,46},{-64,46}}, color={0,0,127}));
  connect(feedback.u1,realExpression1. y) annotation (Line(points={{62,46},{73,46}}, color={0,0,127}));
  connect(firstOrder.y,firstOrder1. u) annotation (Line(points={{-11,46},{-16,46}}, color={0,0,127}));
  connect(derivative.u,firstOrder2. u) annotation (Line(points={{-32,16},{-56,16},{-56,46},{-64,46}}, color={0,0,127}));
  connect(feedback1.y,firstOrder. u) annotation (Line(points={{21,46},{12,46}},               color={0,0,127}));
  connect(feedback1.u1,feedback. y) annotation (Line(points={{38,46},{45,46}}, color={0,0,127}));
  connect(feedback1.u2,derivative. y) annotation (Line(points={{30,38},{18,38},{18,16},{-9,16}}, color={0,0,127}));
  connect(firstOrder2.y, y) annotation (Line(points={{-87,46},{-88,46},{-88,0},{106,0}}, color={0,0,127}));
  connect(y, y) annotation (Line(points={{106,0},{106,0}}, color={0,0,127}));
  connect(electricVoltageComplex.v, feedback.u2) annotation (Line(points={{44,84},{54,84},{54,54},{54,54}}, color={0,0,127}));
  connect(electricVoltageComplex.epp, epp1) annotation (Line(
      points={{24,78.2},{-100,78.2},{-100,0}},
      color={28,108,200},
      thickness=0.5));
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
<p>simple voltage controller for many applications</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] E. Handschin, &ldquo;Elektrische Energieübertragungssysteme&rdquo;, Dr. Alfred Hüthig Verlag Heidelberg, 2nd edition , 1987, p. 255</span></p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Jan-Peter Heckel (jan.heckel@tuhh.de), Apr 2018</p>
</html>"),
Icon(graphics,
     coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                           coordinateSystem(preserveAspectRatio=false)));
end VoltageRegulatorExcitationStabilization;
