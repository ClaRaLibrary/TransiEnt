within TransiEnt.Producer.Gas.BiogasPlant.Base.ADM1.Records;
partial record ADM1_parameters "Partial record for the parameters of the adm1 model"



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




  extends TransiEnt.Basics.Icons.Record;

  import      Modelica.Units.SI;
  // stoichometric parameters
  parameter SI.StoichiometricNumber f_sI_xc "Soluble inerts from Composites";
  parameter SI.StoichiometricNumber f_xI_xc "Particulate inerts from Composites";
  //ADM1 default value = 0.25
  parameter SI.StoichiometricNumber f_ch_xc "Carbohydrates from Composites";
  parameter SI.StoichiometricNumber f_pr_xc "Proteins from Composites";
  parameter SI.StoichiometricNumber f_li_xc "Lipids from Composites";
  //ADM1 default value = 0.25
  parameter SI.StoichiometricNumber f_fa_li "Fatty Acids from Lipids";
  parameter SI.StoichiometricNumber f_h2_su "Hydrogen from Sugars";
  parameter SI.StoichiometricNumber f_bu_su "Butyrate from Sugars";
  parameter SI.StoichiometricNumber f_pro_su "Propionate from Sugars";
  parameter SI.StoichiometricNumber f_ac_su "Acetate from Sugars";
  parameter SI.StoichiometricNumber f_h2_aa "Hydrogen from Amino Acids";
  parameter SI.StoichiometricNumber f_va_aa "Valerate from Amino Acids";
  parameter SI.StoichiometricNumber f_bu_aa "Butyrate from Amino Acids";
  parameter SI.StoichiometricNumber f_pro_aa "Propionate from Amino Acids";
  parameter SI.StoichiometricNumber f_ac_aa "Acetate from Amino Acids";

  //Carbon content
  parameter ADM1_Units.MoleContent C_su "Carbon Content of Sugars in molC/kgCOD";
  parameter ADM1_Units.MoleContent C_aa "Carbon Content of Amino Acids in molC/kgCOD";
  parameter ADM1_Units.MoleContent C_fa "Carbon Content of LCFA in molC/kgCOD";
  parameter ADM1_Units.MoleContent C_va "Carbon Content of Valerate in molC/kgCOD";
  parameter ADM1_Units.MoleContent C_bu "Carbon Content of Butyrate in molC/kgCOD";
  parameter ADM1_Units.MoleContent C_pro "Carbon Content of Propionate in molC/kgCOD";
  parameter ADM1_Units.MoleContent C_ac "Carbon Content of Acetate in molC/kgCOD";
  parameter ADM1_Units.MoleContent C_h2 "Carbon Content of Hydrogen in molC/kgCOD";
  parameter ADM1_Units.MoleContent C_ch4 "Carbon Content of Methane in molC/kgCOD";
  parameter ADM1_Units.MoleContent C_sI "Carbon Content of soluble Inerts in molC/kgCOD";
  parameter ADM1_Units.MoleContent C_xc "Carbon Content of Composites in molC/kgCOD";
  parameter ADM1_Units.MoleContent C_ch "Carbon Content of Carbohydrates in molC/kgCOD";
  parameter ADM1_Units.MoleContent C_pr "Carbon Content of Proteins in molC/kgCOD";
  parameter ADM1_Units.MoleContent C_li "Carbon Content of Lipids in molC/kgCOD";
  parameter ADM1_Units.MoleContent C_bac "Carbon Content of Microorganisms in molC/kgCOD";
  parameter ADM1_Units.MoleContent C_xI "Carbon Content of Particulate Inerts in molC/kgCOD";

  //Nitrogen content
  parameter ADM1_Units.MoleContent N_aa "Nitrogen Content of Amino Acids in molN/kgCOD";
  parameter ADM1_Units.MoleContent N_I "Nitrogen Content of Inerts in molN/kgCOD";
  //ADM1 default value = 2;
  parameter ADM1_Units.MoleContent N_xc "Nitrogen Content of Composites in molN/kgCOD";
  //ADM1 default value = 2;
  parameter ADM1_Units.MoleContent N_bac "Nitrogen Content of Microorganisms in molN/kgCOD";

  //Yield of Biomass
  parameter Real Y_su "Yield of Biomass on Sugars in kgCOD/kgCOD";
  parameter Real Y_aa "Yield of Biomass on Amino Acids in kgCOD/kgCOD";
  parameter Real Y_fa "Yield of Biomass on LCFA in kgCOD/kgCOD";
  parameter Real Y_c4 "Yield of Biomass on Valerate and Butyrate in kgCOD/kgCOD";
  parameter Real Y_pro_meso "Yield of Biomass on Propionate in kgCOD/kgCOD";
  parameter Real Y_pro_therm "Yield of Biomass on Propionate in kgCOD/kgCOD";
  parameter Real Y_ac "Yield of Biomass on Acetate in kgCOD/kgCOD";
  parameter Real Y_h2 "Yield of Biomass on Hydrogen in kgCOD/kgCOD";

  //First order kinetic Rate parameters
  //mesophilic
  parameter ADM1_Units.KineticRateConstant k_dis_meso "Disintegration Rate of Composites in 1/s";
  parameter ADM1_Units.KineticRateConstant k_hyd_ch_meso "Hydrolyisis Rate of Carbohydrates in 1/s";
  parameter ADM1_Units.KineticRateConstant k_hyd_pr_meso "Hydrolyisis Rate of Proteins in 1/s";
  parameter ADM1_Units.KineticRateConstant k_hyd_li_meso "Hydrolyisis Rate of Lipids in 1/s";
  parameter ADM1_Units.KineticRateConstant k_dec_meso "Decay Rate of Microorganisms in 1/s";
  parameter ADM1_Units.KineticRateConstant k_dec_ac_meso "Decay Rate of Acetate Degraders in 1/a";
  //thermophilic
  parameter ADM1_Units.KineticRateConstant k_dis_therm "Disintegration Rate of Composites in 1/s";
  parameter ADM1_Units.KineticRateConstant k_hyd_ch_therm "Hydrolyisis Rate of Carbohydrates in 1/s";
  parameter ADM1_Units.KineticRateConstant k_hyd_pr_therm "Hydrolyisis Rate of Proteins in 1/s";
  parameter ADM1_Units.KineticRateConstant k_hyd_li_therm "Hydrolyisis Rate of Lipids in 1/s";
  parameter ADM1_Units.KineticRateConstant k_dec_therm "Decay Rate of Microorganisms in 1/s";

  //Monod maximum specific uptake rate (mu_max/Y);
  //mesophilic
  parameter ADM1_Units.KineticRateConstant k_m_su_meso "Maximum Uptake Rate of Sugar by Sugar degraders in kgCOD/kgCOD * 1/s";
  parameter ADM1_Units.KineticRateConstant k_m_aa_meso "Maximum Uptake Rate of Amino Acid by Amino Acid degraders in kgCOD/kgCOD * 1/s";
  parameter ADM1_Units.KineticRateConstant k_m_fa_meso "Maximum Uptake Rate of LCFA by LCFA degraders in kgCOD/kgCOD * 1/s";
  parameter ADM1_Units.KineticRateConstant k_m_c4_meso "Maximum Uptake Rate of Valerate and Butyrate by C4 degraders in kgCOD/kgCOD * 1/s";
  parameter ADM1_Units.KineticRateConstant k_m_pro_meso "Maximum Uptake Rate of Propionate by Propionate degraders in kgCOD/kgCOD * 1/s";
  parameter ADM1_Units.KineticRateConstant k_m_ac_meso "Maximum Uptake Rate of Acetate by Acetate degraders in kgCOD/kgCOD * 1/s";
  parameter ADM1_Units.KineticRateConstant k_m_h2_meso "Maximum Uptake Rate of Hydrogen by Hydrogen degraders in kgCOD/kgCOD * 1/s";
  //thermophilic
  parameter ADM1_Units.KineticRateConstant k_m_su_therm "Maximum Uptake Rate of Sugar by Sugar degraders in kgCOD/kgCOD * 1/s";
  parameter ADM1_Units.KineticRateConstant k_m_aa_therm "Maximum Uptake Rate of Amino Acid by Amino Acid degraders in kgCOD/kgCOD * 1/s";
  parameter ADM1_Units.KineticRateConstant k_m_fa_therm "Maximum Uptake Rate of LCFA by LCFA degraders in kgCOD/kgCOD * 1/s";
  parameter ADM1_Units.KineticRateConstant k_m_c4_therm "Maximum Uptake Rate of Valerate and Butyrate by C4 degraders in kgCOD/kgCOD * 1/s";
  parameter ADM1_Units.KineticRateConstant k_m_pro_therm "Maximum Uptake Rate of Propionate by Propionate degraders in kgCOD/kgCOD * 1/s";
  parameter ADM1_Units.KineticRateConstant k_m_ac_therm "Maximum Uptake Rate of Acetate by Acetate degraders in kgCOD/kgCOD * 1/s";
  parameter ADM1_Units.KineticRateConstant k_m_h2_therm "Maximum Uptake Rate of Hydrogen by Hydrogen degraders in kgCOD/kgCOD * 1/s";

  //Half Saturation Value
  //mesophilic
  parameter ADM1_Units.ConcentrationCOD K_S_su_meso "Concentration of Sugar at which (uninhibited) uptake equals half of maximum uptake";
  parameter ADM1_Units.ConcentrationCOD K_S_aa_meso "Concentration of Amino Acids at which (uninhibited) uptake equals half of maximum uptake";
  parameter ADM1_Units.ConcentrationCOD K_S_fa_meso "Concentration of LCFA at which (uninhibited) uptake equals half of maximum uptake";
  parameter ADM1_Units.ConcentrationCOD K_S_c4_meso "Concentration of Valerate or Butyrate at which (uninhibited) uptake equals half of maximum uptake";
  parameter ADM1_Units.ConcentrationCOD K_S_pro_meso "Concentration of Propionate at which (uninhibited) uptake equals half of maximum uptake";
  parameter ADM1_Units.ConcentrationCOD K_S_ac_meso "Concentration of Acetate at which (uninhibited) uptake equals half of maximum uptake";
  parameter ADM1_Units.ConcentrationCOD K_S_h2_meso "Concentration of Hydrogen at which (uninhibited) uptake equals half of maximum uptake";
  //thermophilic
  parameter ADM1_Units.ConcentrationCOD K_S_su_therm "Concentration of Sugar at which (uninhibited) uptake equals half of maximum uptake";
  parameter ADM1_Units.ConcentrationCOD K_S_aa_therm "Concentration of Amino Acids at which (uninhibited) uptake equals half of maximum uptake";
  parameter ADM1_Units.ConcentrationCOD K_S_fa_therm "Concentration of LCFA at which (uninhibited) uptake equals half of maximum uptake";
  parameter ADM1_Units.ConcentrationCOD K_S_c4_therm "Concentration of Valerate or Butyrate at which (uninhibited) uptake equals half of maximum uptake";
  parameter ADM1_Units.ConcentrationCOD K_S_pro_therm "Concentration of Propionate at which (uninhibited) uptake equals half of maximum uptake";
  parameter ADM1_Units.ConcentrationCOD K_S_ac_therm "Concentration of Acetate at which (uninhibited) uptake equals half of maximum uptake";
  parameter ADM1_Units.ConcentrationCOD K_S_h2_therm "Concentration of Hydrogen at which (uninhibited) uptake equals half of maximum uptake";

  //Inhibition parameters
  parameter Real pH_UL "pH-Value at which no Inhibition due to low pH occurs";
  parameter Real pH_LL "pH-Value at which Uptake and growth are limited to 0.05, thus pH-Inhibition can be considered complete";
  parameter Real pH_UL_ac "pH-Value at which Acetate Degraders are not inhibited due to low pH occurs";
  parameter Real pH_LL_ac "pH-Value at which Uptake through Acetate Degraders limited to 0.05, thus pH-Inhibition can be considered complete";
  parameter Real pH_UL_h2 "pH-Value at which Hydrogen Degraders are not inhibited due to low pH occurs";
  parameter Real pH_LL_h2 "pH-Value at which Uptake through Hydrogen Degraders limited to 0.05, thus pH-Inhibition can be considered complete";
  parameter SI.Concentration K_S_IN "Inhibition parameter regarding inhibition due to Nitrogen-Defficiency";
  //mesophilic
  parameter ADM1_Units.ConcentrationCOD K_I_H2_fa_meso "Hydrogen Concentration at which LCFA-Degraders are hindered";
  parameter ADM1_Units.ConcentrationCOD K_I_H2_c4_meso "";
  parameter ADM1_Units.ConcentrationCOD K_I_H2_pro_meso "";
  parameter SI.Concentration K_I_NH3_meso "";
  //thermophilic
  parameter ADM1_Units.ConcentrationCOD K_I_H2_c4_therm;
  parameter ADM1_Units.ConcentrationCOD K_I_H2_pro_therm;
  parameter SI.Concentration K_I_NH3_therm=11;

  //Acid Base parameters
  parameter Real Kw_ref(final unit="mol2/m6");
  parameter SI.MolarEnergy deltH0_w "Heat of AcidBase-Reaction";
  parameter SI.Concentration Ka_CO2_ref;
  parameter SI.MolarEnergy deltH0_CO2 "Heat of AcidBase-Reaction";
  parameter SI.Concentration Ka_HCO3_ref;
  //excluded in original ADM1
  parameter SI.MolarEnergy deltH0_HCO3 "Heat of AcidBase-Reaction";
  //excluded in original ADM1
  parameter SI.Concentration Ka_NH4_ref;
  parameter SI.MolarEnergy deltH0_NH4 "Heat of AcidBase-Reaction";
  parameter SI.Concentration Ka_H2S_ref;
  //not used in ADM1
  parameter SI.MolarEnergy deltH0_H2S "Heat of AcidBase-Reaction";
  // not used in ADM1
  parameter SI.Concentration Ka_HAc_ref;
  parameter SI.Concentration Ka_HAc_max;
  parameter SI.Concentration Ka_HPro_ref;
  parameter SI.Concentration Ka_HPro_max;
  parameter SI.Concentration Ka_HBu_ref;
  parameter SI.Concentration Ka_HBu_max;
  parameter SI.Concentration Ka_HVa_ref;
  //Acid Base velocity parameter
  parameter Real k_AB(final unit="m3/(mol.s)");

  //Liquid-gas transfer parameters
  parameter ADM1_Units.KineticRateConstant k_L "Gas-liquid transfer coefficient in 1/s";
  parameter Real KH_h2_ref(final unit="mol/(m3.Pa)") "Henry's law coefficient for Hydrogen";
  //in ADM1 shown as 7.8 e-4 kmole/m3/bar
  parameter SI.MolarEnergy deltH0_H_h2 "Heat of Reaction of liquid-gas transfer of Hydrogen at 298K in J/mol";
  parameter Real KH_ch4_ref(final unit="mol/(m3.Pa)") "Henry's law coefficient for Methane";
  //in ADM1 shown as 1.4 e-3 kmole/m3/bar
  parameter SI.MolarEnergy deltH0_H_ch4 "Heat of Reaction of liquid-gas transfer of Methane at 298K in J/mol";
  parameter Real KH_co2_ref(final unit="mol/(m3.Pa)") "Henry's law coefficient for Carbondioxide";
  //in ADM1 shown as 3.5 e-2 kmole/m3/bar
  parameter SI.MolarEnergy deltH0_H_co2 "Heat of Reaction of liquid-gas transfer of Carbondioxide at 298K in J/mol";
  parameter SI.PartialPressure p_h2o_ref "Vapor Pressure of water at 298K in Pa";
  parameter SI.MolarEnergy deltH0_vap "Evaporation Heat at 298K in J/mol";

  //Molar Reaction Energy from Lübken et al. (2007). Modelling the energy balance of an anaerobic digester fed with cattle manure and renewable energy crops.
  parameter SI.MolarEnergy deltE_su_1 "Reaction Energy of sugar conversion path 1 (50%) per mol sugar at mesophilic conditions";
  parameter SI.MolarEnergy deltE_su_2 "Reaction Energy of sugar conversion path 2 (35%) per mol sugar at mesophilic conditions";
  parameter SI.MolarEnergy deltE_su_3 "Reaction Energy of sugar conversion path 3 (15%) per mol sugar at mesophilic conditions";
  parameter SI.MolarEnergy deltE_aa "Reaction Energy of Amino Acids conversion to acetate, CO2 and ammonia per mol amino acids at mesophilic conditions";
  parameter SI.MolarEnergy deltE_fa "Reaction Energy of fatty acids (palmitate) conversion to acetate and hydrogen per mol fatty acid at mesophilic conditions";
  parameter SI.MolarEnergy deltE_va "Reaction Energy of valerate conversion to propionate, acetate and hydrogen per mol valerate at mesophilic conditions";
  parameter SI.MolarEnergy deltE_bu "Reaction Energy of butyrate conversion to acetate and hydrogen per mol butyrate at mesophilic conditions";
  parameter SI.MolarEnergy deltE_pro "Reaction Energy of propionate conversion to acetate, CO2 and hydrogen per mol propionate at mesophilic conditions";
  parameter SI.MolarEnergy deltE_ac "Reaction Energy of acetate conversion to CH4 and CO2 per mol acetate at mesophilic conditions";
  parameter SI.MolarEnergy deltE_h2 "Reaction Energy of methanation per mol h2 at mesophilic conditions";

  //Unit Conversion kgCOD to mol
  //COD per mole
  parameter SI.MolarMass M_cod_su "Chemical Oxygen Demand in kgCOD per mole Glucose (sugar)";
  parameter SI.MolarMass M_cod_aa "Chemical Oxygen Demand in kgCOD per mole Alanine and 2 mole Glycine (Stickland Reaction)";
  parameter SI.MolarMass M_cod_fa "Chemical Oxygen Demand in kgCOD per mole Palmitate (fatty acid)";

  //COD per mole Organic Acid
  parameter SI.MolarMass M_cod_va "Chemical Oxygen Demand in kgCOD per mole Valyric Acid";
  parameter SI.MolarMass M_cod_bu "Chemical Oxygen Demand in kgCOD per mole Butyric Acid";
  parameter SI.MolarMass M_cod_pro "Chemical Oxygen Demand in kgCOD per mole Propionic Acid";
  parameter SI.MolarMass M_cod_ac "Chemical Oxygen Demand in kgCOD per mole Acetic Acid";

  //COD per mole gas
  parameter SI.MolarMass M_cod_h2 "Chemical Oxygen Demand in kgCOD per mole Hydrogen";
  parameter SI.MolarMass M_cod_ch4 "Chemical Oxygen Demand in kgCOD per mole Methane";

  //Unit Conversion kgTS to kgCOD
  //Theoretical Oxygen Demand per kg Suspended Solids
  parameter Real ThOD_Xc "ThOD kgCOD per kg Composites from Lübken et al. (2007). Modelling the energy balance of an anaerobic digester fed with cattle manure and renewable energy crops.";
  parameter Real ThOD_XI "ThOD in kgCOD per kg Inerts (Lignin) from Koch, et. al. (2010). Biogas from grass silage–measurements and modeling with ADM1.";
  parameter Real ThOD_Xch "ThOD in kgCOD per kg Carbohydrates  from Koch, et. al. (2010). Biogas from grass silage–measurements and modeling with ADM1.";
  parameter Real ThOD_Xli "ThOD in kgCOD per kg lipids  from Koch, et. al. (2010). Biogas from grass silage–measurements and modeling with ADM1.";
  parameter Real ThOD_Xpr "ThOD in kgCOD per kg Protein  from Koch, et. al. (2010). Biogas from grass silage–measurements and modeling with ADM1.";
  parameter Real ThOD_bac "ThOD in kgCOD per kg Microorganisms from Lübken et al. (2007). Modelling the energy balance of an anaerobic digester fed with cattle manure and renewable energy crops.";

  //pipe resistance coefficient
  parameter Real k_p(final unit="m3/(s.Pa)") "pipe resistance coefficient ";

  annotation (Documentation(info="<html>
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
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Philipp Jahneke (philipp.koziol@tuhhl.de), Sept 2018</p>
<p>Model adapted for TransiEnt by Jan Westphal (j.westphal@tuhh.de) in May 2020</p>
</html>"));
end ADM1_parameters;
