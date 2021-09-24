within TransiEnt.Producer.Gas.BiogasPlant.Base.ADM1.ADM1_Functions;
function ADM1_Inhibition_BSM2
  "A Function calculating the inhibition Coefficients using constants from Rosén, C., & Jeppsson, U. (2006). Aspects on ADM1 Implementation within the BSM2 Framework."


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

  extends TransiEnt.Basics.Icons.Function;

  // _____________________________________________
  //
  //                Inputs/Outputs
  // _____________________________________________

  input Real pH "pH-Value";
  input Modelica.Units.SI.Concentration S_IN "Concentration of Inorganic Nitrogen";
  input TransiEnt.Producer.Gas.BiogasPlant.Base.ADM1.ADM1_Units.ConcentrationCOD S_h2 "Concentration of Hydrogen in solution";
  input Modelica.Units.SI.Concentration NH3 "Concentration of free Ammonia in solution";
  input String operationMode "mesophilic or thermophilic conditions";
  output Real[7] I "Inhibition Coefficients";

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  replaceable Records.ADM1_parameters_BSM2 parameters annotation (
    Dialog(group="Replaceable Components"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-10,-10},{10,10}})));

  final parameter ADM1_Units.ConcentrationCOD K_I_H2_c4=if operationMode == "thermophilic" then parameters.K_I_H2_c4_therm else parameters.K_I_H2_c4_meso "Inhibition Constant due to high Hydrogen Concentration affecting Valerate and Butyrate Degraders";
  final parameter ADM1_Units.ConcentrationCOD K_I_H2_pro=if operationMode == "thermophilic" then parameters.K_I_H2_pro_therm else parameters.K_I_H2_pro_meso "Inhibition Constant due to high Hydrogen Concentration affecting Propionate Degraders";
  final parameter Modelica.Units.SI.Concentration K_I_NH3=if operationMode == "thermophilic" then parameters.K_I_NH3_therm else parameters.K_I_NH3_meso "Inhibition Constant due to high Ammonia Concentration affecting Acetate Degraders";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  Real I_IN "Inhibtion due to Nitrogen-Defficiency";
  Real I_pH;
  Real I_pH_ac;
  Real I_pH_h2 "Inhibition due to pH-Value";
  Real I_H2_fa;
  Real I_H2_c4;
  Real I_H2_pro "Inhibition due to Hydrogen-Concentration";
  Real I_NH3 "Inhibition due to Amonium-Concentration";

  Real I_su "composed Inhibition Coefficient affecting Sugar Degraders";
  Real I_aa "composed Inhibition Coefficient affecting Amino Acid Degraders";
  Real I_fa "composed Inhibition Coefficient affecting LCFA Degraders";
  Real I_c4 "composed Inhibition Coefficient affecting Valerate and Butyrate Degraders";
  Real I_pro "composed Inhibition Coefficient affecting Propionate Degraders";
  Real I_ac "composed Inhibition Coefficient affecting Acetate Degraders";
  Real I_h2 "composed Inhibition Coefficient affecting Hydrogen Degraders";

  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________
algorithm
  //Inhibition due to Nitrogen Defficiency
  I_IN := S_IN/(S_IN + parameters.K_S_IN);

  //Inhibition due to low pH-Value
  I_pH := if pH < parameters.pH_UL then exp(-3*((pH - parameters.pH_UL)/(parameters.pH_UL - parameters.pH_LL))^2) else 1 "lower pH-Inhibition if pH Value below Uper Level (Parameters.pH_UL) affecting most microorganims";
  I_pH_ac := if pH < parameters.pH_UL_ac then exp(-3*((pH - parameters.pH_UL_ac)/(parameters.pH_UL_ac - parameters.pH_LL_ac))^2) else 1 "lower pH-Inhibition if pH Value below Uper Level (Parameters.pH_UL) affecting Acetate degraders";
  I_pH_h2 := if pH < parameters.pH_UL_h2 then exp(-3*((pH - parameters.pH_UL_h2)/(parameters.pH_UL_h2 - parameters.pH_LL_h2))^2) else 1 "lower pH-Inhibition if pH Value below Uper Level (Parameters.pH_UL) affecting Hydrogen degraders";

  //Inhibition due to high concentration of Hydrogen or Ammonia
  //to avoid unphysical results Inhibition constants have been set to 1 (no inhibition) in case concentrations are not positive (e.g. from numerical errors)
  I_H2_fa := if operationMode == "mesophilic" and S_h2 > 0 then 1/(1 + S_h2/parameters.K_I_H2_fa_meso) else 1 "Inhibition due to high Hydrogen Concentration affecting LCFA degraders (only for mesophilic conditions)";
  I_H2_c4 := if S_h2 > 0 then 1/(1 + S_h2/K_I_H2_c4) else 1 "Inhibition due to high Hydrogen Concentration affecting Valerate and Butyrate degraders";
  I_H2_pro := if S_h2 > 0 then 1/(1 + S_h2/K_I_H2_pro) else 1 "Inhibition due to high Hydrogen Concentration affecting Propionate degraders ";
  I_NH3 := if NH3 > 0 then 1/(1 + NH3/K_I_NH3) else 1 "Inhibition due to high Ammonia Concentration affecting Acetate Degraders";

  //Composing total Inhibition Coefficients
  I_su := I_IN*I_pH "Sugar Degraders are inhibited by Nitrogen Defficiency and low pH-Value";
  I_aa := I_IN*I_pH "Amino Acid Degraders are inhibited by Nitrogen Defficiency and low pH-Value";
  I_fa := I_IN*I_pH*I_H2_fa "LCFA Degraders are inhibited by Nitrogen Defficiency, low pH-Value and high Hydrogen Concentration";
  I_c4 := I_IN*I_pH*I_H2_c4 "Valerate/Butyrate Degraders are inhibited by Nitrogen Defficiency, low pH-Value and high Hydrogen Concentration";
  I_pro := I_IN*I_pH*I_H2_pro "Propionate Degraders are inhibited by Nitrogen Defficiency, low pH-Value and high Hydrogen Concentration";
  I_ac := I_IN*I_pH_ac*I_NH3 "Acetate Degraders are inhibited by Nitrogen Defficiency, low pH-Value and high Ammonia Concentration";
  I_h2 := I_IN*I_pH_h2 "Hydrogen Degraders are inhibited by Nitrogen Defficiency and low pH-Value";

  I := {I_su,I_aa,I_fa,I_c4,I_pro,I_ac,I_h2} "vector of inhibition Coefficients";
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This function calculates the inhibition coefficients for the adm1 model. It considers inhibtion due to an unfavorable pH-value,  an excessive concentration of hydrogen or ammonia and an insufficient nitrogen concentration.</p>
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
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Philipp Jahneke (philipp.koziol@tuhh.de), August 2018</p>
</html>"));
end ADM1_Inhibition_BSM2;
