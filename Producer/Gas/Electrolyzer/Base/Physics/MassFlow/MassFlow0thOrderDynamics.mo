within TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.MassFlow;
model MassFlow0thOrderDynamics "PEMElectrolyzer mass flow as modeled by Espinosa, 2018"
  //The following must all be calculated in the Mass Flow model, or provided externally
  //m_flow_H2, n_flow_H2O, n_flow_H2, n_flow_O2


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
  extends TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.MassFlow.PartialMassFlow;

  import      Modelica.Units.SI;
  import const = Modelica.Constants;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  constant SI.MolarMass molar_mass_H2=2.016e-3 "Molar mass of hydrogen gas";

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  outer parameter Integer n_cells "number of cells in series";
  parameter SI.Efficiency eta_F=1 "Faraday's efficiency, relating real H2 flow rate and theoretical";

  // _____________________________________________
  //
  //              Variables
  // _____________________________________________

  //Current
  outer SI.Current i_el_stack "current across the electrolyzer stack";

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //Faraday's Law
  n_flow_H2O = n_cells*i_el_stack/(2*const.F);
  n_flow_H2 = n_cells*i_el_stack/(2*const.F)*eta_F;
  n_flow_O2 = n_cells*i_el_stack/(4*const.F)*eta_F;

  m_flow_H2 = molar_mass_H2*n_flow_H2;
  annotation (
    defaultConnectionStructurallyInconsistent=true,
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This is a model to calculate mass flows in typical electrolyzers. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Mass flow is modeled using expressions from Espinosa-L&oacute;pez et al 2018. Dependent on stack current and Faraday&apos;s efficiency (1 by default).</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Original model developed and validated in the range of 20-60 &deg;C with operating H2 and O2 tank pressure of 15-35 bar. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Mass flow is modeled using Faraday&apos;s Law, as in Espinosa-L&oacute;pez et al 2018.</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Results have been validated against Espinosa-L&oacute;pez et al 2018 published figures. </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>Manuel Espinosa-L&oacute;pez, Philippe Baucour, Serge Besse, Christophe Darras, Raynal Glises, Philippe Poggi, Andr&eacute; Rakotondrainibe, and Pierre Serre-Combe. Modelling and experimental validation of a 46 kW PEM high pressure water electrolyser. Renewable Energy, 119, pp. 160-173, 2018. doi: 10.1016/J.RENENE.2017.11.081. </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by John Webster (jcwebste@edu.uwaterloo.ca) October 2018.</p>
</html>"));
end MassFlow0thOrderDynamics;
