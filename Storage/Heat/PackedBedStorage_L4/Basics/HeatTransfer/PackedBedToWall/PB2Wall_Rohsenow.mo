within TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.HeatTransfer.PackedBedToWall;
model PB2Wall_Rohsenow "PB2Wall - Rohsenow Correlation"



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

  import SI = ClaRa.Basics.Units;
  extends TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.HeatTransfer.PackedBedToWall.HeatTransferBasePB2Wall;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter SI.Area[iCom.N_cv] A_heat=geo.A_heat "Area of heat transfer is lateral surface" annotation (Dialog(enable=false, tab = "Internals"));

  parameter Real NusseltNumber = 5 "Value from Nield and Bejan";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.MassFlowRate m_flow[iCom.N_cv + 1] "Mass flow rate";

  SI.Temperature T_mean[iCom.N_cv];

equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  T_mean = iCom.T;

   alpha = NusseltNumber * iCom.lambda_eff_rad ./ sqrt(geo.A_cross_bed);

   heat.Q_flow = alpha .* A_heat .* (heat.T - T_mean);

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Heat Transfer Correlation for packed bed to wall according to Rohsenow</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>The correlation is valid for a fully developed temperature field inside the packed bed</p>
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
<p>D.A.&nbsp;Nield,&nbsp;A.&nbsp;Bejan,&nbsp;Convection&nbsp;in&nbsp;porous&nbsp;media,&nbsp;4th&nbsp;ed.,&nbsp;Springer,&nbsp;New&nbsp;York,&nbsp;2013.&nbsp;(page&nbsp;80)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Michael von der Heyde (heyde@tuhh.de) for the FES research project, March 2021</p>
</html>"),    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PB2Wall_Rohsenow;
