within TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Voltage.ConcentrationVoltageModels;
model V_conc1
  "PEM  cell concentration overvoltage as modeled by Espinosa, 2018"


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
  extends TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Voltage.ConcentrationVoltageModels.PartialConcentrationModel;

  import      Modelica.Units.SI;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //              Variables
  // _____________________________________________
  //Voltage and Overpotential Variables
public
  outer SI.Voltage V_conc "Concentration/diffusion overpotential contribution";

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //const Voltage, 0
  V_conc = 0;
  annotation (
    defaultConnectionStructurallyInconsistent=true,
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This is a model for concentration overvoltage as modeled in Espinosa</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Voltage is modeled according to Espinosa-L&oacute;pez et al 2018.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Original model developed and validated in the range of 20-60 &deg;C with operating pressure of 15-35 bar. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>Manuel Espinosa-L&oacute;pez, Philippe Baucour, Serge Besse, Christophe Darras, Raynal Glises, Philippe Poggi, Andr&eacute; Rakotondrainibe, and Pierre Serre-Combe. Modelling and experimental validation of a 46 kW PEM high pressure water electrolyser. <i>Renewable Energy, </i>119, pp. 160-173, 2018. doi: <a href=\"https://doi.org/10.1016/J.RENENE.2017.11.081\">10.1016/J.RENENE.2017.11.081</a>. </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by John Webster (jcwebste@edu.uwaterloo.ca) October 2018.</p>
</html>"));
end V_conc1;
