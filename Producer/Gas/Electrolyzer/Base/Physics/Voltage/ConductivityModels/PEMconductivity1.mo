within TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Voltage.ConductivityModels;
model PEMconductivity1 "PEM conductivity as modeled by Espinosa, 2018"

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

  extends TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Voltage.ConductivityModels.PartialPEMConductivity;

  import SI = Modelica.SIunits;
  import const = Modelica.Constants;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________
public
  outer parameter SI.Temperature T_std "STD temperature";

  //Electrolyzer system specific parameters
  outer parameter SI.ChemicalPotential E_pro "Temperature independent parameter for activation energy in proton transport, Espinosa 2018";

  outer parameter SI.Conductivity mem_conductivity_ref "S/m, Membrane conductivity reference value at T_std,Espinosa 2018; typically [0.058,0.096]S/cm, 283(Agbli 2011)";

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //Ohmic Overpotential
  mem_conductivity = mem_conductivity_ref*exp(-(E_pro/const.R)*((1/T_op) - (1/T_std))); //Units S/m ; used in Espinosa 2018

  annotation (
    defaultConnectionStructurallyInconsistent=true,
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This is a model for PEM conductivity.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>PEM Conductivity as modeled by Espinosa-Lopez et al, 2018.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Original model developed and validated in the range of 20-60 &deg;C with operating pressure of 15-35 bar. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Results have been validated against Espinosa-L&oacute;pez et al 2018 published figures. </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>Manuel Espinosa-L&oacute;pez, Philippe Baucour, Serge Besse, Christophe Darras, Raynal Glises, Philippe Poggi, Andr&eacute; Rakotondrainibe, and Pierre Serre-Combe. Modelling and experimental validation of a 46 kW PEM high pressure water electrolyser. <i>Renewable Energy, </i>119, pp. 160-173, 2018. doi: <a href=\"https://doi.org/10.1016/J.RENENE.2017.11.081\">10.1016/J.RENENE.2017.11.081</a>. </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by John Webster (jcwebste@edu.uwaterloo.ca) October 2018.</p>
</html>"));
end PEMconductivity1;
