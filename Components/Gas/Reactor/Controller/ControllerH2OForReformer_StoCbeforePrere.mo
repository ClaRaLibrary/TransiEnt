within TransiEnt.Components.Gas.Reactor.Controller;
model ControllerH2OForReformer_StoCbeforePrere "Controller to control the water mass flow rate for the prereformer and steam methane reformer for given steam to carbon ratio in front of Prereformer"

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

  import Modelica.Constants.eps;
  extends Base.PartialControllerH2OForReformer;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  SI.MolarFlowRate n_flow_H2O_beforePrere "molar flow rate of H2O at the inlet of the Prere";
  SI.MolarFlowRate n_flow_C_beforePrere "molar flow rate of C in hydrocarbons at the inlet of the Prere";

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  desiredMolarRatio = n_flow_H2O_beforePrere/n_flow_C_beforePrere;
  n_flow_C_beforePrere =max(eps, m_flow_feed*(xi[1]/M_CH4 + 2*xi[2]/M_C2H6 + 3*xi[3]/M_C3H8 + 4*xi[4]/M_C4H10));
  n_flow_H2O_beforePrere =(m_flow_feed*xi[7] + m_flow_H2OforReformerCalc)/M_H2O;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This is a controller to control the steam mass flow rate for a steam methane reformer to ensure a given molar steam to methane ratio at the inlet of the prereformer. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The composition and mass flow rate of the feed are measured and the necessary steam mass flow rate is calculated using the amount of C atoms in hydrocarbons in the feed. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>The validity is limited because the composition is measured ideally and continuously which is not possible in reality. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>m_flow_feed: input for the feed mass flow rate in [kg/s]</p>
<p>xi: input for the mass fractions of the feed in [kg/kg]</p>
<p>m_flow_steam: output for the steam mass flow rate (positive sign) in [kg/s]</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>The steam mass flow rate is calculated using the amount of C atoms in hydrocarbons in the feed. </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Fri Jul 04 2017</p>
</html>"));
end ControllerH2OForReformer_StoCbeforePrere;
