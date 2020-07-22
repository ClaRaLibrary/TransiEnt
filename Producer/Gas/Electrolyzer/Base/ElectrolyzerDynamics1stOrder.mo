within TransiEnt.Producer.Gas.Electrolyzer.Base;
model ElectrolyzerDynamics1stOrder "1st order electrolyzer dynamics"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2020, Hamburg University of Technology.                              //
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

  extends TransiEnt.Producer.Gas.Electrolyzer.Base.PartialElectrolyzerDynamics;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Modelica.SIunits.Time tau(min=0)=1 "Sets the time constant of the electrolyser";

  // _____________________________________________
  //
  //              Variables
  // _____________________________________________

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

initial equation

  H_flow_H2 = 0;

equation

  P_el * eta = H_flow_H2 + tau * der(H_flow_H2);

  annotation (
  defaultConnectionStructurallyInconsistent=true,Diagram(graphics,
                                                         coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Rectangle(
          extent={{-80,40},{80,-40}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Line(
          points={{-78,-42},{-68,-12},{-50,18},{-18,36},{26,48},{82,48}},
          color={255,0,0},
          smooth=Smooth.Bezier)}),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This is a model for electrolyzer dynamics with first order behavior. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Hydrogen enthalpy flow and electric power are connected by a first order differential equation. </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Patrick Göttsch (patrick.goettsch@tuhh.de) in April 2014</p>
<p>Edited by Tom Lindemann (tom.lindemann@tuhh.de) in Dec 2015</p>
<p>Edited by Lisa Andresen (andresen@tuhh.de) in May 2016</p>
<p><br>Edited by Carsten Bode (c.bode@tuhh.de) in March 2017</p>
</html>"));
end ElectrolyzerDynamics1stOrder;
