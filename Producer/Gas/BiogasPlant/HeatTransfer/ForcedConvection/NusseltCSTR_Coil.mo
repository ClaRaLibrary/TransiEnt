within TransiEnt.Producer.Gas.BiogasPlant.HeatTransfer.ForcedConvection;
function NusseltCSTR_Coil
  "Function calculating Nusselt Number for Heat Transfer from coil to medium"



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

  import Modelica.Constants.pi;
  extends TransiEnt.Basics.Icons.Function;

  // _____________________________________________
  //
  //                Inputs/Outputs
  // _____________________________________________

  input Modelica.Units.SI.ReynoldsNumber Re "Reynols number inside CSTR";
  input Modelica.Units.SI.PrandtlNumber Pr "Prandtl number of medium at its temperature";
  input Modelica.Units.SI.DynamicViscosity eta "viscosity of medium at its temperature";
  input Modelica.Units.SI.DynamicViscosity eta_w "viscosity of medium at wall temperature";
  input Real C2 "geometrical Coefficient in Nusselt-Equation";
  input Modelica.Units.SI.Diameter D "Inner Diameter of Reactor";
  input Modelica.Units.SI.Diameter d "outer diameter of tube of coil";
  output Modelica.Units.SI.NusseltNumber Nu "Nusselt number inside CSTR";

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  constant Real a=0.56;
  constant Real b=1/3;
  constant Real c=0.14;

  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

algorithm
  Nu := C2*(d/D)^(-0.3)*Re^a*Pr^b*(eta/eta_w)^c;

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
end NusseltCSTR_Coil;
