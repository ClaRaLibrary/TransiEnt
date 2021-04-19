within TransiEnt.Producer.Gas.BiogasPlant.HeatTransfer.FreeConvection;
function NusseltFreeConvection_horizontalSurface "Function for calculating the nusselt number of a horizontal surface"


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

  extends TransiEnt.Basics.Icons.Function;

  // _____________________________________________
  //
  //                Inputs/Outputs
  // _____________________________________________

  input Modelica.SIunits.RayleighNumber Ra "Rayleight number calculated with properties of medium";
  input Modelica.SIunits.PrandtlNumber Pr "Prandtl number (property of medium)";
  input Boolean upside=true "true if convection takes place on the upper side of the surface";
  input Boolean hotSurface=true "true if the surface is warmer then the fluid";
  output Modelica.SIunits.NusseltNumber Nu;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter Real f1=(1 + (0.492/Pr)^(9/16))^(-16/9);
  final parameter Real f2=(1 + (0.322/Pr)^(11/20))^(-20/11);

  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

algorithm
  if (upside and hotSurface) or (not upside and not hotSurface) then
    if Ra*f2 <= 70000 then
      Nu := 0.766*(Ra*f2)^(1/5);
    elseif Ra*f2 > 70000 then
      Nu := 0.15*(Ra*f2)^(1/3);
    end if;
  else
    Nu := 0.6*(Ra*f1)^(1/5);
  end if;
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Evaluates the Nusselt Correlation for Natural Convection Heat Transfer at horizontall surfaces. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>L (characteristic length) must be chosen according to geometry</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>Ra := Rayleigh number,</p>
<p>Pr := Prandtl number</p>
<p>Nu := Nusselt number</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Heat flow from surface to fluid on upper surface</p>
<p>for Ra * f_2(Pr) &lt;=7e4 (laminar)</p>
<p>Nu := 0.766 [Ra *f_2(Pr)]^{1/5}</p>
<p>for Ra * f_2(Pr) &gt; 7e4 (turbulent)</p>
<p>Nu := 0.15 [Ra * f_2(Pr)]^{1/3}</p>
<p>f_2(Pr) := [1+(0.322/Pr)^{11/20}]^{-20/11}</p>
<p>Heat flow from surface to fluid on lower surface</p>
<p>Nu := 0.6 [Ra * f_1(Pr)]^{1/5}</p>
<p>f_1(Pr) := [1+(0.492/Pr)^{9/16}]^{-16/9}</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>important to determine whether geometry helping (case 1) or hindering (case2) the flow driven by buoancy.</p>
<p>use together with functions calculating correct Rayleigh and Prandtl numbers</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] Klan, H., &amp; Thess, A. (2013). F2 W&auml;rme&uuml;bertragung durch freie Konvektion: Au&szlig;enstr&ouml;mung. In <i>VDI-W&auml;rmeatlas</i> (pp. 757-764). Springer Vieweg, Berlin, Heidelberg.</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Philipp Jahneke (philipp.koziol@tuhh.de), Aug 2018</p>
</html>"));
end NusseltFreeConvection_horizontalSurface;
