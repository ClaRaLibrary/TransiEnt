within TransiEnt.Producer.Gas.Electrolyzer.Base;
model ElectrolyzerEfficiencyCharlineSilyzer100 "Efficiency charline for Silyzer 100"



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





  //charline approximated from data from Siemens for P_el_n = 1e5 W and eta_nom = 0.746699; P_el_max = 3*P_el_n;

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Producer.Gas.Electrolyzer.Base.PartialElectrolyzerEfficiencyCharline(eta_n_cl=0.746699);

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation
  // Calculating the efficency coefficient in %
  eta_cl =0.000000006999*(P_el/P_el_n*100)^4 - 0.000006*(P_el/P_el_n*100)^3 + 0.002056*(P_el/P_el_n*100)^2 - 0.3894*(P_el/P_el_n*100) + 98.35;

  // Calculating the output efficency coefficient
  eta = (eta_n/eta_n_cl - eta_scale * P_el/P_el_n) * eta_cl/100;

  annotation (
  defaultConnectionStructurallyInconsistent=true,
  Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This is a model for the efficiency curve of a Silyzer 100 electrolyzer [1]. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The curve can be modified by setting the nominal efficiency eta_n and a linear factor eta_cl. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] Siemens AG (2011). Enabling the power of hydrogen. Industry Sector - Hydrogen Electrolyzer - Product Line 1. Erlangen. </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Patrick Göttsch (patrick.goettsch@tuhh.de) in April 2014</p>
<p>Edited by Tom Lindemann (tom.lindemann@tuhh.de) in Dec 2015</p>
<p>Edited by Lisa Andresen (andresen@tuhh.de) in May 2016</p>
<p>Edited by Carsten Bode (c.bode@tuhh.de) in March 2017</p>
</html>"), Icon(graphics={Line(
          points={{-86,30},{-44,6},{-2,-8},{38,-18},{90,-22}},
          color={255,0,0},
          smooth=Smooth.Bezier)}));
end ElectrolyzerEfficiencyCharlineSilyzer100;
