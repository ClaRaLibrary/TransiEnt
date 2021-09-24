within TransiEnt.Components.Gas.Reactor.Controller.Base;
partial model PartialControllerH2OForReformer "Controller to control the water mass flow rate for the prereformer and steam methane reformer"


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

  import      Modelica.Units.SI;
  import Modelica.Constants.eps;
  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  constant SI.MolarMass M_H2O=0.01802;
  constant SI.MolarMass M_CH4=0.01604;
  constant SI.MolarMass M_C2H6=0.03007;
  constant SI.MolarMass M_C3H8=0.04410;
  constant SI.MolarMass M_C4H10=0.05812;

  final parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_SG_var vle_ng7_sg;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.General.MassFractionIn xi[vle_ng7_sg.nc] "Mass composition of the feed before adding water or hydrogen" annotation (Placement(transformation(extent={{-120,20},{-80,60}})));
  TransiEnt.Basics.Interfaces.General.MassFlowRateIn m_flow_feed "Feed mass flow rate before adding water or hydrogen" annotation (Placement(transformation(extent={{-120,-60},{-80,-20}}), iconTransformation(extent={{-120,-60},{-80,-20}})));
  Modelica.Blocks.Interfaces.RealInput desiredMolarRatio(final quantity="MoleRatio", final unit="mol/mol", displayUnit="mol/mol") "Desired molar ratio of H2O to CH4 at the inlet of the SMR" annotation (Placement(transformation(extent={{120,-20},{80,20}}),    iconTransformation(extent={{120,-20},{80,20}})));

  TransiEnt.Basics.Interfaces.General.MassFlowRateOut m_flow_steam "Water mass flow rate that has to be added for given molar ratio" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-100})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  SI.MassFlowRate m_flow_H2OforReformerCalc "Calculated mass flow rate for water, is negative if there is already sufficient water in the gas";

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  m_flow_steam = max(0, m_flow_H2OforReformerCalc);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This is a controller to control the steam mass flow rate for a steam methane reformer. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The composition and mass flow rate of the feed are measured and the necessary steam mass flow rate is calculated. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>The validity is limited because the composition is measured ideally and continuously which is not possible in reality. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>m_flow_feed: input for the feed mass flow rate in kg/s</p>
<p>xi: input for the mass fractions of the feed in kg/kg</p>
<p>m_flow_steam: output for the steam mass flow rate (positive sign) in kg/s</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p><br>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016</p>
<p><br>Partial model derived from old version of ControllerH2OForReformer_StoCbeforeSMR by Carsten Bode (c.bode@tuhh.de) on Fri Jul 04 2017</p>
</html>"));
end PartialControllerH2OForReformer;
