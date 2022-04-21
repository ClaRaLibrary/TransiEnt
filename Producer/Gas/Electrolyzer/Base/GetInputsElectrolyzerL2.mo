within TransiEnt.Producer.Gas.Electrolyzer.Base;
model GetInputsElectrolyzerL2 "Get enabled inputs and parameters of disabled inputs"


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

  extends Modelica.Blocks.Icons.Block;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput i_dens_set "Prescribed current density profile" annotation (Placement(transformation(extent={{-140,-30},{-100,10}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput T_input "Prescribed temp profile" annotation (Placement(transformation(extent={{-140,-6},{-100,34}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput m_flow_H2_set "Prescribed hydrogen mass flow rate profile" annotation (Placement(transformation(extent={{-140,-86},{-100,-46}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput P_el_set "Prescribed electric power profile" annotation (Placement(transformation(extent={{-140,20},{-100,60}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput i_el_stack_set "Prescribed current profile" annotation (Placement(transformation(extent={{-140,-56},{-100,-16}}, rotation=0)));
  annotation (Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>This model is a simple block to collect inputs like ClaRa.Components.TurboMachines.Compressors.Fundamentals but for an electrolyzer. </p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>P_el_set: input for set electric power </p>
<p>m_flow_H2_set: input for set hydrogen mass flow </p>
<p>T_input: input for temperature profile </p>
<p> i_dens_set: input for current density profile </p>
<p> i_stack_set: input for current profile </p>


<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by John Webster (jcwebste@edu.uwaterloo.ca) in October 2018</p>
</html>"));
end GetInputsElectrolyzerL2;
