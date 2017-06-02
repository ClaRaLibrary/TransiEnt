within TransiEnt.Producer.Gas.Electrolyzer.Base;
model ElectrolyzerDynamics2ndOrder "2nd order electrolyzer dynamics"
//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Producer.Gas.Electrolyzer.Base.PartialElectrolyzerDynamics;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Real omega_n = 17 "Sets the natural frequency of the electrolyser";
  parameter Real zeta = 0.7 "Set the damping ratio of the electrolyser";

  // _____________________________________________
  //
  //              Variables
  // _____________________________________________

protected
  Real x1(final start=0);
  Real x2(final start=0);

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

equation
  //Equations for Ely 2nd Order
  der(x1) = x2;
  der(x2) = - 2 * zeta * omega_n  * x2 - omega_n^2 * x1 + omega_n^2 * P_el * eta;
  H_flow_H2 = x1;

  annotation (
  defaultConnectionStructurallyInconsistent=true,Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Rectangle(
          extent={{-80,40},{80,-40}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Line(
          points={{-74,-42},{-72,-18},{-66,10},{-56,52},{-32,60},{6,36},{58,42},{82,42}},
          color={255,0,0},
          smooth=Smooth.Bezier)}),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This is a model for electrolyzer dynamics with second order behavior. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Hydrogen enthalpy flow and electric power are connected by two first order differential equations. </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Patrick G&ouml;ttsch (patrick.goettsch@tuhh.de) in April 2014</p>
<p>Edited by Tom Lindemann (tom.lindemann@tuhh.de) in Dec 2015</p>
<p>Edited by Lisa Andresen (andresen@tuhh.de) in May 2016</p>
<p>Edited by Carsten Bode (c.bode@tuhh.de) in March 2017</p>
</html>"));
end ElectrolyzerDynamics2ndOrder;
