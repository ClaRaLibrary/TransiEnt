within TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController;
model SimpleExcitationSystem "Simple Voltage Controller"


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
  parameter Real KA=70 "Gain of Controller";
  parameter Real KI=0.9 "Time constant of Controller";

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

  Modelica.Blocks.Math.Feedback feedback annotation (Placement(transformation(extent={{64,56},{44,36}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=v_n) annotation (Placement(transformation(extent={{94,36},{74,56}})));

  Sensors.ElectricVoltageComplex electricVoltageComplex annotation (Placement(transformation(extent={{24,68},{44,88}})));

  Modelica.Blocks.Continuous.Integrator integrator(k=KI, initType=Modelica.Blocks.Types.Init.SteadyState)
                                                   annotation (Placement(transformation(extent={{36,-26},{56,-6}})));
  Modelica.Blocks.Math.Gain gain(k=KA) annotation (Placement(transformation(extent={{38,8},{58,28}})));
  Modelica.Blocks.Math.Add add annotation (Placement(transformation(extent={{72,-10},{92,10}})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(feedback.u1,realExpression1. y) annotation (Line(points={{62,46},{73,46}}, color={0,0,127}));
  connect(y, y) annotation (Line(points={{106,0},{106,0}}, color={0,0,127}));
  connect(electricVoltageComplex.v, feedback.u2) annotation (Line(points={{44,84},{54,84},{54,54},{54,54}}, color={0,0,127}));
  connect(electricVoltageComplex.epp, epp1) annotation (Line(
      points={{24,78.2},{-100,78.2},{-100,0}},
      color={28,108,200},
      thickness=0.5));
  connect(y, add.y) annotation (Line(points={{106,0},{93,0}}, color={0,0,127}));
  connect(add.u1, gain.y) annotation (Line(points={{70,6},{66,6},{66,18},{59,18}}, color={0,0,127}));
  connect(add.u2, integrator.y) annotation (Line(points={{70,-6},{64,-6},{64,-16},{57,-16}}, color={0,0,127}));
  connect(integrator.u, feedback.y) annotation (Line(points={{34,-16},{18,-16},{18,46},{45,46}}, color={0,0,127}));
  connect(gain.u, feedback.y) annotation (Line(points={{36,18},{18,18},{18,46},{45,46}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Voltage Control for simple calculations</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>L1E Pi-Controller</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>No PSS</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>epp (ComplexPowerPort) for Voltage measurement and real output</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>simplest voltage controler, chgosse KI=0 for no additional dynamics</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>no references</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Jan-Peter Heckel (jan.heckel@tuhh.de), Aug 2018</p>
</html>"),
Icon(graphics,
     coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                           coordinateSystem(preserveAspectRatio=false)));
end SimpleExcitationSystem;
