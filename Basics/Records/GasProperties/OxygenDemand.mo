within TransiEnt.Basics.Records.GasProperties;
record OxygenDemand "Record containing the Oxygen demand for elementary C, H, O, N, S in mol/mol"



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

  extends TransiEnt.Basics.Icons.Record;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  //Oxygen demand given in mol_o2 / mol_comp as a matrix.
  //3rd line: Oxygen
  //4th line: Nitrogen fed into combustion chamber at an ambient air composition of 21 vol-% Oxygen, 79 vol-% Nitrogen
  //matrix form for easy calculation: omins x [C, H, O, N, S] gives [0, 0, Omin, "Nmin", 0]

                      //           C      H       O  N       S
  parameter Real[:,:] omins = [    0,     0,      0, 0,      0;
                                   0,     0,      0, 0,      0;
                                   2,   1/2,     -1, 0,      2;
                              158/21, 79/42, -79/21, 0, 158/21;
                                   0,     0,      0, 0,      0];

  parameter Real[5] ominsVector = {2,   1/2,     -1, 0,      2};

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This record contains a matrix, defining the Oxygen demand for full combustion of the elements C, H, O, N, S.</p>
<p><img src=\"modelica://TransiEnt/Images/omin.png\"/></p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>No physical effects considered. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>This is for fast inline calculation of the Oxygen demand. Knowing the molar flow rate of elements in the fuel stream, one may calculate the Oxygen demand as follows</p>
<p><img src=\"modelica://TransiEnt/Images/ominCalc.png\"/></p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>No validation needed.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Record created by Jan Braune (jan.braune@tuhh.de), Mar 2015</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Apr 2015</p>
</html>"));
end OxygenDemand;
