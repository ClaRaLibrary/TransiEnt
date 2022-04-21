within TransiEnt.Producer.Gas.BiogasPlant.HeatTransfer.FreeConvection;
function RayleighNumber "function for calculating the rayleigh number"




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





  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import g = Modelica.Constants.g_n;
  extends TransiEnt.Basics.Icons.Function;

  // _____________________________________________
  //
  //                Inputs/Outputs
  // _____________________________________________

  input Modelica.Units.SI.Length l;
  input Modelica.Units.SI.LinearExpansionCoefficient beta;
  input Modelica.Units.SI.TemperatureDifference dT;
  input Modelica.Units.SI.PrandtlNumber Pr;
  input Modelica.Units.SI.KinematicViscosity nue;
  output Modelica.Units.SI.RayleighNumber Ra;

  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

algorithm
  Ra := g*beta*dT*(l^3)*Pr/(nue^2);
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model calculates the rayleigh number for the heat models of the CSTR</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>kinematic viscosity&nbsp;nue</p>
<p>prandtl number Pr</p>
<p>temperature difference dT</p>
<p>linear expansion coefficient beta</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Ra&nbsp;:=g*beta*dT*(l^3)*Pr/(nue^2);</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Philipp Jahneke (philipp.koziol@tuhh.de), August 2018</p>
</html>"));
end RayleighNumber;
