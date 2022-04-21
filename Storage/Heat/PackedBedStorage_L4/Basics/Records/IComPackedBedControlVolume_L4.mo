within TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.Records;
record IComPackedBedControlVolume_L4



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

  extends ClaRa.Basics.Records.IComGas_L3;


  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  outer parameter ClaRa.Basics.Units.Length d_v_m = 0.03  "Mean volume-equivalent particle diameter";
  outer parameter Real porosity = 0.5 "Porosity";
  outer parameter Real sphericity = 0.8 "Mean sphericity";
  final parameter Real surfacePerVolume = 6*(1-porosity)/(sphericity*d_v_m) "Particle surface per packed-bed volume";
  final parameter ClaRa.Basics.Units.Length d_h = 4*porosity/surfacePerVolume "Hydraulic diameter";
  final parameter ClaRa.Basics.Units.Length d_SM = 6*(1-porosity)/surfacePerVolume "Sauter mean diameter";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  ClaRa.Basics.Units.ThermalConductivity lambda_eff_rad[N_cv] "Effective Thermal Conductivity of Packed Bed in radial direction";
  ClaRa.Basics.Units.ThermalConductivity lambda_eff_ax[N_cv] "Effective Thermal Conductivity of Packed Bed in axial direction";
  ClaRa.Basics.Units.Area permeability "Permeability of packed bed";


  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>internal communication model for packed bed control volume</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p><br>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Michael von der Heyde (heyde@tuhh.de) for the FES research project, March 2021</p>
</html>"));
end IComPackedBedControlVolume_L4;
