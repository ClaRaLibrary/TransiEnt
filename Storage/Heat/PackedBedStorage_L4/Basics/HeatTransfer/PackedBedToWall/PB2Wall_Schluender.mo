within TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.HeatTransfer.PackedBedToWall;
model PB2Wall_Schluender "PB2Wall - Schluender Correlation"



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

  parameter Real Phi = 0.8 "Partition of wall area in contact with particles"  annotation (Dialog(group="Air to Rock Heat Transfer Nusselt Number Approximation"));
  parameter Real eps_w = 0.9 "Emission Coefficient of wall" annotation (Dialog(group="Air to Rock Heat Transfer Nusselt Number Approximation"));
  parameter Real eps_bed = 0.9 "Emission Coefficient of Bed" annotation (Dialog(group="Air to Rock Heat Transfer Nusselt Number Approximation"));
  parameter Real delta = 5e-6 "Surface Roughness of particles";
  parameter SI.Area[iCom.N_cv] A_heat=geo.A_heat "Area of heat transfer is lateral surface" annotation (Dialog(enable=false, tab = "Internals"));

  final parameter Real C_w_bed = 5.67e-8/(1/eps_w+1/eps_bed-1) "formula 45d";
  final parameter Real lambda_g = 0.05 "heat conductivity of air at 400°C to simplify";
  final parameter Real L = 0.03359/1e5 "Value from VDI heat atlas for air, at t=60°C to simplify";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.CoefficientOfHeatTransfer alpha_rad[iCom.N_cv] "Heat transfer coefficient";
  SI.CoefficientOfHeatTransfer alpha_wp[iCom.N_cv] "Heat transfer coefficient";

  SI.MassFlowRate m_flow[iCom.N_cv + 1] "Mass flow rate";

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
equation

  alpha_wp = ones(iCom.N_cv)*4*lambda_g/iCom.d_SM*((1+2*(L+delta)/iCom.d_SM)*log(1+iCom.d_SM/(2*(L+delta)))-1);

  for i in 1:iCom.N_cv loop

    alpha_rad[i] = 4*C_w_bed*(iCom.T[i])^3;

  end for;

  alpha = Phi.*alpha_wp+alpha_rad;

   heat.Q_flow = alpha .* A_heat .* (heat.T - iCom.T);

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Heat transfer correlation packed bed to wall according to Schl&uuml;nder et al</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>The correlation is only valid, if the temperature field inside the packed bed is discretized in lateral direction / towards the wall, such as in two-dimensional or three dimensional model, as the temperature profile inside the packed bed is not accounted for</p>
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
<p>German Association of Engineers,&nbsp;VDI&nbsp;Heat&nbsp;Atlas,&nbsp;11th&nbsp;ed.,&nbsp;2013.&nbsp;section MG&nbsp;11</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Michael von der Heyde (heyde@tuhh.de) for the FES research project, March 2021</p>
</html>"),    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PB2Wall_Schluender;
