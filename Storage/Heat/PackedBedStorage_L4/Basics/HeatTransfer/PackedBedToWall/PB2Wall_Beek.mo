within TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.HeatTransfer.PackedBedToWall;
model PB2Wall_Beek "PB2Wall - Haenchen Correlation"


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
  extends TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.HeatTransfer.PackedBedToWall.HeatTransferBasePB2Wall;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter SI.Area[iCom.N_cv] A_heat=geo.A_heat "Area of heat transfer" annotation (Dialog(enable=false, tab = "Internals"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TILMedia.Gas_ph fluid[iCom.N_cv];

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.MassFlowRate m_flow[iCom.N_cv + 1] "Mass flow rate";

  SI.Temperature T_mean[iCom.N_cv];

  SI.Velocity w[iCom.N_cv] "Medium velocity";

  Real Re[iCom.N_cv] "Reynolds number";

equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  for i in 1:iCom.N_cv loop
     w[i] = ((m_flow[i]+m_flow[i+1])/2) ./ fluid[i].d ./ geo.A_cross_bed[iCom.N_cv]; //physical velocity
     Re[i] = noEvent(abs(w[i])) .* iCom.d_SM .* fluid[i].d ./ (fluid[i].transp.eta);
  end for;

    T_mean = iCom.T;

  for i in 1:iCom.N_cv loop

    alpha[i] = (fluid[i].transp.lambda/iCom.d_SM)*(2.58*Re[i]^(0.33)+0.094*Re[i]^(0.8)*fluid[i].transp.Pr^(0.4));

  end for;

   heat.Q_flow = alpha .* A_heat .* (heat.T - T_mean);

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Heat Transfer Correlation for packed bed to wall according to Beek et al. It has been used in the simulation study of H&auml;nchen et al.</p>
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
<p>J. Beek. &ldquo;Desing of packed catalytic reactors.&rdquo; In: Adv. Chem. Eng. 3 (1962), pages 203&ndash;271.</p>
<p>M.&nbsp;H&auml;nchen,&nbsp;S.&nbsp;Br&uuml;ckner,&nbsp;A.&nbsp;Steinfeld,&nbsp;High-temperature&nbsp;thermal&nbsp;storage&nbsp;using&nbsp;a&nbsp;packed&nbsp;bed&nbsp;of&nbsp;rocks&nbsp;&ndash;&nbsp;Heat&nbsp;transfer&nbsp;analysis&nbsp;and&nbsp;experimental&nbsp;validation,&nbsp;Applied&nbsp;Thermal&nbsp;Engineering&nbsp;31&nbsp;(2011)&nbsp;1798&ndash;1806.</p>
<p><br><b><span style=\"color: #008000;\">10. Version History</span></b></p>
<p>Model created by Michael von der Heyde (heyde@tuhh.de) for the FES research project, March 2021</p>
</html>"),    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PB2Wall_Beek;
