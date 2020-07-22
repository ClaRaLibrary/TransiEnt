within TransiEnt.Producer.Gas.BiogasPlant.HeatTransfer.ForcedConvection;
function NusseltInsideCSTR "Model for calculating the nusselt number of a continous stirred tank reactor"


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

  import Modelica.Constants.pi;
  extends TransiEnt.Basics.Icons.Function;

  // _____________________________________________
  //
  //                Inputs/Outputs
  // _____________________________________________

  input Modelica.SIunits.ReynoldsNumber Re "Reynols number inside CSTR";
  input Modelica.SIunits.PrandtlNumber Pr "Prandtl number of medium at its temperature";
  input Modelica.SIunits.DynamicViscosity eta "viscosity of medium at its temperature";
  input Modelica.SIunits.DynamicViscosity eta_w "viscosity of medium at wall temperature";
  input Real C1 "geometrical Coefficient in Nusselt-Equation";
  output Modelica.SIunits.NusseltNumber Nu "Nusselt number inside CSTR";

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  constant Real a=2/3;
  constant Real b=1/3;
  constant Real c=0.14;

  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

algorithm
  Nu := C1*Re^a*Pr^b*(eta/eta_w)^c;

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Calculates the Nusselt number of an impeller driven flow inside a CSTR. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>Nu := Nusselt number,</p>
<p>Pr := Prandtl number</p>
<p>D := Inner Diameter of CSTR</p>
<p>P := power of the stirrer </p>
<p>V := Volume of CSTR filled with medium</p>
<p>rho := density of fluid</p>
<p>eta := dynamic viscosity of fluid</p>
<p>eta_w := dynamic viscosity of fluid at the wall</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Nu := K * (pi/4)^(a/3) * (P*D^4*rho^2/V/eta^3)^(a/3) * Pr^b * (eta/eta_w)^c</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] Judat, H. and Sperling, R. (2005). W&auml;rme&uuml;bergang im R&uuml;hrkessel. In M. Kraume (Ed.) <i>Mischen und R&uuml;hren </i>(pp. 123-145), Wiley-Blackwell</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Philipp Jahneke (philipp.koziol@tuhh.de), Sep 2018</p>
</html>"));
end NusseltInsideCSTR;
