within TransiEnt.Producer.Electrical.Base.ControlPower;
block SecondaryQuickstart "Quickstart capable plant in secondary balancing operation"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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

  extends PartialBalancingPowerPotential;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
      // Quick start capable plants are typically not participating in primary control
    P_pr_neg_offer = 0;
    P_pr_pos_offer = 0;

  if noEvent(is_running) then
    //    P_sec_neg_offer = if isSecondaryControlActive then min(P_grad_max_star*5*60*P_nom, max(0,P_el_is)) else 0;
    P_sec_neg_offer = if isSecondaryControlActive then max(0,P_el_is) else 0;
    P_sec_pos_offer =if isSecondaryControlActive then min(P_grad_max_star*5*60*P_n, max(0, P_max_star*P_n - P_el_is)) else 0;
  else
    P_sec_neg_offer = 0;
    P_sec_pos_offer =P_grad_max_star*simCenter.t_SB_act*P_n;
  end if;
    annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Quickstart capable plant in secondary balancing operation.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>L1 (defined in the CodingConventions) - only active power and frequency.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end SecondaryQuickstart;
