within TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.HeatTransfer.PackedBedToAir;
partial model HeatTransferBasePB2Air "Partial heat transfer model for packed Bed 2 Air heat transfer"


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

  import SI = ClaRa.Basics.Units;

  extends ClaRa.Basics.Icons.Alpha;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  constant String gas="true";

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

   outer parameter Boolean useHomotopy;

   parameter Boolean inlet = true annotation (Dialog(enable=false, tab = "Internals"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.Records.IComPackedBedControlVolume_L4 iCom;

  outer TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.PackedBedGeometry.PackedBedGeometry_N_cv geo;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  ClaRa.Basics.Interfaces.HeatPort_a heat[iCom.N_cv] annotation (Placement(transformation(extent={{80,80},{100,100}}), iconTransformation(extent={{80,80},{100,100}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.MassFlowRate m_flow[iCom.N_cv+1] "Mass flow rate";
  SI.Temperature T_mean[iCom.N_cv];

  SI.CoefficientOfHeatTransfer alpha "Heat transfer coefficient";

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Base model for Heat Transfer Correlation from packed bed to air volume</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(none)</p>
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
<p><span style=\"font-family: Courier New;\">(none)</span></p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Michael von der Heyde (heyde@tuhh.de) for the FES research project, March 2021</p>
</html>"));
end HeatTransferBasePB2Air;
