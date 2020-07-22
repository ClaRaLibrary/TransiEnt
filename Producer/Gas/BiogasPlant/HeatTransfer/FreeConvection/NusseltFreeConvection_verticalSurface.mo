within TransiEnt.Producer.Gas.BiogasPlant.HeatTransfer.FreeConvection;
function NusseltFreeConvection_verticalSurface "Function for calculating the nusselt number"


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

  extends TransiEnt.Basics.Icons.Function;

  // _____________________________________________
  //
  //                Inputs/Outputs
  // _____________________________________________

  input Modelica.SIunits.RayleighNumber Ra "Rayleight number calculated with properties of medium";
  input Modelica.SIunits.PrandtlNumber Pr "Prandtl number (property of medium)";
  output Modelica.SIunits.NusseltNumber Nu "Nusselt Number calculated by the correlation";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  Real f=(1 + (0.492/Pr)^(9/16))^(-16/9);

  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

algorithm
  Nu := (0.825 + 0.387*(Ra*f)^(1/6))^2;
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Evaluates the Nusselt Correlation for Natural Convection Heat Transfer at rectangular vertical surfaces. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>L (characteristic lenght) must be height of surface</p>
<p>10^-1 &lt; Ra &lt; 10^12 </p>
<p>10^-3 &lt; Pr </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>Ra := Rayleigh number,</p>
<p>Pr := Prandtl number</p>
<p>Nu := Nusselt number</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Nu := (0.825 + 0.387 (Ra *f_1(Pr))^{1/6})^2</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>use together with functions calculating correct Rayleigh and Prandtl numbers</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] Klan, H., &amp; Thess, A. (2013). F2 W&auml;rme&uuml;bertragung durch freie Konvektion: Au&szlig;enstr&ouml;mung. In <i>VDI-W&auml;rmeatlas</i> (pp. 757-764). Springer Vieweg, Berlin, Heidelberg.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Philipp Jahneke (philipp.koziol@tuhh.de), Aug 2018</p>
</html>"));
end NusseltFreeConvection_verticalSurface;
