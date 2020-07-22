within TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Pressures;
model Pressures1
  "PEMElectrolyzer partial pressures as modeled by Espinosa, 2018"
  //The following must all be calculated in the Pressure model or else provided externally (p_cat operating pressure).
  // pp_H2O, pp_H2, pp_O2, p_cat
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
  extends TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Pressures.PartialPressures;

  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Real atmToPa=101325 "conversion factor for partial pressures";
  parameter SI.Pressure p_mem_grad=1e5 "pressure gradient across PEM cell";

  // _____________________________________________
  //
  //              Variables
  // _____________________________________________

  //Temperature modeling
public
  outer SI.Temperature T_op "Operating stack temperature";

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  p_cat = gasPortPressure; //5.86E5 for best fit with Espinosa-López 2018;
  p_an = p_cat - p_mem_grad;
  pp_H2O = (6.1078e-3*exp(17.2694*(T_op - 273.15)/(T_op - 34.85)))*atmToPa "expression calculates in atm, converted to Pa";
  pp_H2 = p_cat - pp_H2O;
  pp_O2 = p_an - pp_H2O;

  annotation (
    defaultConnectionStructurallyInconsistent=true,
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This is a model to calculate varying pressures for electrolyzer dynamics. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Pressure is modeled using empirical expression for H2O partial pressure and Dalton&apos;s Law of partial pressures for O2 and H2. Dependent on operating temperature T_op, cathode and anode side storage tank pressures.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Original model developed and validated in the range of 20-60 &deg;C with operating H2 and O2 tank pressure of 15-35 bar. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Pressure is modeled according to Espinosa-L&oacute;pez et al 2018 empirical expression for H2O partial pressure and Dalton&apos;s Law of partial pressures for O2 and H2. Cathode and anode pressures are defined as constants with a negative 1 bar gradient (i.e. if cathode at 30bar then anode at 29bar). </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Results have been validated against Espinosa-L&oacute;pez et al 2018 published figures. </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>Manuel Espinosa-L&oacute;pez, Philippe Baucour, Serge Besse, Christophe Darras, Raynal Glises, Philippe Poggi, Andr&eacute; Rakotondrainibe, and Pierre Serre-Combe. Modelling and experimental validation of a 46 kW PEM high pressure water electrolyser. Renewable Energy, 119, pp. 160-173, 2018. doi: 10.1016/J.RENENE.2017.11.081. </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by John Webster (jcwebste@edu.uwaterloo.ca) October 2018.</p>
</html>"));
end Pressures1;
