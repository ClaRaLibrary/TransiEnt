within TransiEnt.Basics.Records.GasProperties;
record OxygenDemandCombustion "Record containing the Oxygen demand for elementary C, H, O, N, S in mol/mol"

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  extends TransiEnt.Basics.Icons.Record;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  //Oxygen demand given in mol o2 / mol combustible as a vector.

  parameter Real[5] ominsVector = {2,   1/2,     -1, 0,      2};

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This record contains a vector, defining the Oxygen demand for full oxidation of the elements C, H, O, N, S.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>No physical effects considered. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Generation of NO<sub>x</sub> neglected.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>From the molar flow rate of the fuel&apos;s elements, the Oxygen demand can be calculated via</p>
<p><img src=\"modelica://TransiEnt/Images/EqnOStoich.png\"/></p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>No validation needed.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Record created by Jan Braune (jan.braune@tuhh.de), Mar 2015</p>
<p>Edited by Paul Kernstock (paul.kernstock@tuhh.de) August 2015</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Sep 2015</p>
</html>"));
end OxygenDemandCombustion;
