within TransiEnt.Producer.Gas.BiogasPlant.Base.ADM1.ADM1_Functions;
function VantHoffEquation "applies the van't Hoff Equation to a temperature-sensitive equilibrium constant"

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
  import Modelica.Constants.R;

  // _____________________________________________
  //
  //                Inputs/Outputs
  // _____________________________________________

  input Real K_ref "Equilibrium constant at reference temperature";
  input Modelica.SIunits.MolarEnergy deltH0 "Enthalpy of Reaction for determination of equilibrium";
  input Modelica.SIunits.Temperature T "Temperature at which equilibrium constant is calculated";
  output Real K "Equilibrium constant at Temperature T";

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter Modelica.SIunits.Temperature T_ref=298.15 "Reference Temperature for equilibrium constant";
  // ADM1 default value is 298

  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

algorithm
  K := K_ref*exp(deltH0/R*(1/T_ref - 1/T));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>(Description) </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>K_ref&nbsp;: &quot;Equilibrium&nbsp;constant&nbsp;at&nbsp;reference&nbsp;temperature&quot;</p>
<p>deltH0:&nbsp;&quot;Enthalpy&nbsp;of&nbsp;Reaction&nbsp;for&nbsp;determination&nbsp;of&nbsp;equilibrium&quot;</p>
<p>T:&nbsp;&quot;Temperature&nbsp;at&nbsp;which&nbsp;equilibrium&nbsp;constant&nbsp;is&nbsp;calculated&quot;</p>
<p>K:&nbsp;&quot;Equilibrium&nbsp;constant&nbsp;at&nbsp;Temperature&nbsp;T&quot;</p>
<p><span style=\"font-family: (Default);\">T_ref&nbsp;=&nbsp;298.15&nbsp;&quot;Reference&nbsp;Temperature&nbsp;for&nbsp;equilibrium&nbsp;constant&quot;</span></p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>&nbsp;K&nbsp;:=K_ref*exp(deltH0/R*(1/T_ref&nbsp;-&nbsp;1/T))</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Philipp Jahneke (philipp.koziol@tuhh.de), August 2018</p>
</html>"));
end VantHoffEquation;