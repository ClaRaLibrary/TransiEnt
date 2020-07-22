within TransiEnt.Producer.Gas.BiogasPlant.Base.ADM1;
model ADM1_PetersenMatrix "Constructing the Petersen Matrix of ADM1"

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

  extends TransiEnt.Basics.Icons.ADM1;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  replaceable Records.ADM1_parameters_BSM2 Parameters constrainedby TransiEnt.Producer.Gas.BiogasPlant.Base.ADM1.Records.ADM1_parameters
                                                                                                                                    annotation (
    Dialog(group="Replaceable Components"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-10,-10},{10,10}})));

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________
  //conditional Yield constant for Propionate Degraders

  final parameter Real Y_pro=if operationMode == "thermophilic" then Parameters.Y_pro_therm else Parameters.Y_pro_meso;

  final parameter Real HydSol[4,9]=[{0,1,0,(1 - Parameters.f_fa_li)},{0,0,1,0},{0,0,0,Parameters.f_fa_li},zeros(4, 6)] "part of Petersen Matrix describing effect of processes 1-4 (Disintegration & Hydrolysis) on Components 1-9 (solubles)";
  final parameter Real MonodSol[8,9]=[-1*identity(8),zeros(8, 1)] + [zeros(6, 3),[0,(1 - Parameters.Y_su)*Parameters.f_bu_su,(1 - Parameters.Y_su)*Parameters.f_pro_su,(1 - Parameters.Y_su)*Parameters.f_ac_su,(1 - Parameters.Y_su)*Parameters.f_h2_su; (1 - Parameters.Y_aa)*Parameters.f_va_aa,(1 - Parameters.Y_aa)*Parameters.f_bu_aa,(1 - Parameters.Y_aa)*Parameters.f_pro_aa,(1 - Parameters.Y_aa)*Parameters.f_ac_aa,(1 - Parameters.Y_aa)*Parameters.f_h2_aa; 0,0,0,(1 - Parameters.Y_fa)*0.7,(1 - Parameters.Y_fa)*0.3; 0,0,(1 - Parameters.Y_c4)*0.54,(1 - Parameters.Y_c4)*0.31,(1 - Parameters.Y_c4)*0.15; 0,0,0,(1 - Parameters.Y_c4)*0.8,(1 - Parameters.Y_c4)*0.2; 0,0,0,(1 - Y_pro)*0.57,(1 - Y_pro)*0.43],zeros(6, 1); zeros(2, 8),{1 - Parameters.Y_ac,1 - Parameters.Y_h2}] "part of Petersen Matrix describing effect of processes 5-12 (Metabolism described as Monod Equations) on Components 1-9 (solubles)";
  final parameter Real HydPart[4,11]=[-1*identity(4) + [0,Parameters.f_ch_xc,Parameters.f_pr_xc,Parameters.f_li_xc; zeros(3, 4)],zeros(4, 7)] "part of Petersen Matrix describing effect of processes 1-4 (Disintegration & Hydrolysis) on Components 13-23 (Particulates & Microorganisms)";
  final parameter Real MonodPart[8,11]=[zeros(8, 4),[diagonal({Parameters.Y_su,Parameters.Y_aa,Parameters.Y_fa,Parameters.Y_c4}),zeros(4, 3); zeros(4, 3),diagonal({Parameters.Y_c4,Y_pro,Parameters.Y_ac,Parameters.Y_h2})]] "part of Petersen Matrix describing effect of processes 5-12 (Metabolism described as Monod Equations) on Components 13-23 (Particulates & Microorganisms)";
  final parameter Real DecPart[7,11]=[ones(7, 1),zeros(7, 3),-1*identity(7)] "part of Petersen Matrix describing effect of processes 13-23 (Decay of Microorganisms on Components 13-23 (Particulates & Microorganisms";
  final parameter Real SolInert[19]=cat(
      1,
      {Parameters.f_sI_xc},
      zeros(18)) "part of Petersen Matrix describing Balance of Soluble Inerts";
  final parameter Real PartInert[19]=cat(
      1,
      {Parameters.f_xI_xc},
      zeros(18)) "part of Petersen Matrix describing Balance of Particulate Inerts";
  final parameter Real CBalance[19]=if CarbonBalance == 2 then CBalance2 elseif CarbonBalance == 1 then CBalance1 else CBalance0 "Carbon Balance in Petersen Matrix";
  final parameter Real NBalance[19]=if NitrogenBalance == 2 then NBalance2 else NBalance0 "Nitrgoen Balance in Petersen Matrix";
  //different options on Carbon Balance: CBalance0:= default in ADM1 but not fully closed, CBalance1 := improved Balance, CBalance2:= fully closed balance,
  final parameter Real CBalance0[19]=cat(
      1,
      zeros(4),
      -1*{s5,s6},
      zeros(3),
      -1*{s10,s11,s12},
      zeros(7));
  final parameter Real CBalance1[19]=cat(
      1,
      zeros(4),
      -1*{s5,s6,s7,s8,s9,s10,s11,s12},
      zeros(7));
  final parameter Real CBalance2[19]=cat(
      1,
      -1*{s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12},
      fill(s13, 7));

  //different options on Nitrogen Balance: NBalance0 := default in ADM1 but not fully closed, NBalance2 := fully closed Nitrogen balance;
  final parameter Real NBalance0[19]=cat(
      1,
      zeros(4),
      {0,Parameters.N_aa,0,0,0,0,0,0} - Parameters.N_bac*{Parameters.Y_su,Parameters.Y_aa,Parameters.Y_fa,Parameters.Y_c4,Parameters.Y_c4,Y_pro,Parameters.Y_ac,Parameters.Y_h2},
      zeros(7));
  final parameter Real NBalance2[19]=cat(
      1,
      {Parameters.N_xc - Parameters.f_xI_xc*Parameters.N_I - Parameters.f_sI_xc*Parameters.N_I - Parameters.f_pr_xc*Parameters.N_aa},
      zeros(3),
      {0,Parameters.N_aa,0,0,0,0,0,0} - Parameters.N_bac*{Parameters.Y_su,Parameters.Y_aa,Parameters.Y_fa,Parameters.Y_c4,Parameters.Y_c4,Y_pro,Parameters.Y_ac,Parameters.Y_h2},
      fill(Parameters.N_bac - Parameters.N_xc, 7));

  //Carbon Balances in the 19 processes of ADM1 (s13=Processes 13-19)
  final parameter ADM1_Units.MoleContent s1=-Parameters.C_xc + Parameters.f_sI_xc*Parameters.C_sI + Parameters.f_ch_xc*Parameters.C_ch + Parameters.f_pr_xc*Parameters.C_pr + Parameters.f_li_xc*Parameters.C_li + Parameters.f_xI_xc*Parameters.C_xI;
  final parameter ADM1_Units.MoleContent s2=-Parameters.C_ch + Parameters.C_su;
  final parameter ADM1_Units.MoleContent s3=-Parameters.C_pr + Parameters.C_aa;
  final parameter ADM1_Units.MoleContent s4=-Parameters.C_li + (1 - Parameters.f_fa_li)*Parameters.C_su + Parameters.f_fa_li*Parameters.C_fa;
  final parameter ADM1_Units.MoleContent s5=-Parameters.C_su + (1 - Parameters.Y_su)*(Parameters.f_bu_su*Parameters.C_bu + Parameters.f_pro_su*Parameters.C_pro + Parameters.f_ac_su*Parameters.C_ac) + Parameters.Y_su*Parameters.C_bac;
  final parameter ADM1_Units.MoleContent s6=-Parameters.C_aa + (1 - Parameters.Y_aa)*(Parameters.f_va_aa*Parameters.C_va + Parameters.f_bu_aa*Parameters.C_bu + Parameters.f_pro_aa*Parameters.C_pro + Parameters.f_ac_aa*Parameters.C_ac) + Parameters.Y_aa*Parameters.C_bac;
  final parameter ADM1_Units.MoleContent s7=-Parameters.C_fa + (1 - Parameters.Y_fa)*0.7*Parameters.C_ac + Parameters.Y_fa*Parameters.C_bac;
  final parameter ADM1_Units.MoleContent s8=-Parameters.C_va + (1 - Parameters.Y_c4)*(0.54*Parameters.C_pro + 0.31*Parameters.C_ac) + Parameters.Y_c4*Parameters.C_bac;
  final parameter ADM1_Units.MoleContent s9=-Parameters.C_bu + (1 - Parameters.Y_c4)*0.8*Parameters.C_ac + Parameters.Y_c4*Parameters.C_bac;
  final parameter ADM1_Units.MoleContent s10=-Parameters.C_pro + (1 - Y_pro)*0.57*Parameters.C_ac + Y_pro*Parameters.C_bac;
  final parameter ADM1_Units.MoleContent s11=-Parameters.C_ac + (1 - Parameters.Y_ac)*Parameters.C_ch4 + Parameters.Y_ac*Parameters.C_bac;
  final parameter ADM1_Units.MoleContent s12=(1 - Parameters.Y_h2)*Parameters.C_ch4 + Parameters.Y_h2*Parameters.C_bac;
  final parameter ADM1_Units.MoleContent s13=-Parameters.C_bac + Parameters.C_xc;

  final parameter Real[19,24] PM=[[HydSol; MonodSol; zeros(7, 9)],CBalance,NBalance,SolInert,[HydPart; MonodPart; DecPart],PartInert] "Petersen Matrix as used in ADM1";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter String operationMode="mesophilic" annotation (choices(choice="mesophilic", choice="thermophilic"));
  parameter Integer CarbonBalance=0 annotation (choices(
      choice=0 "ADM1 default",
      choice=1 "Carbon Balance includes all Monod Equations",
      choice=2 "All Processes included in Carbon Balance"));
  parameter Integer NitrogenBalance=0 annotation (choices(choice=0 "ADM1 default", choice=2 "All Processes included in Nitrogen Balance"));

   annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>(Description) </p>
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
<p>[1] <span style=\"font-family: (Default);\">D.J. Batstone, J. Keller*, I. Angelidaki, S.V. Kalyuzhnyi, S.G. Pavlostathis, A. Rozzi, W.T.M. Sanders, H. Siegrist and V.A. Vavilin, (2002),</span> &quot;The IWA Anaerobic Digestion Model No 1 (ADM1)&quot;</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Philipp Jahneke (philipp.koziol@tuhhl.de), Sept 2018</p>
<p>Model adapted for TransiEnt by Jan Westphal (j.westphal@tuhh.de) in May 2020</p>
</html>"));
end ADM1_PetersenMatrix;
