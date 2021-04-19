within TransiEnt.Producer.Gas.BiogasPlant.Base.ADM1.Records;
record ADM1_parameters_manure_bulkowska "Record with the parameters of Bulkowska et al."

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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

extends TransiEnt.Producer.Gas.BiogasPlant.Base.ADM1.Records.ADM1_parameters(
    f_sI_xc=0.1 "Soluble inerts from Composites",
    f_xI_xc=0.341 "Particulate inerts from Composites",
    f_ch_xc=0.5 "Carbohydrates from Composites",
    f_pr_xc=0.111 "Proteins from Composites",
    f_li_xc=0.048 "Lipids from Composites",
    f_fa_li=0.95 "Fatty Acids from Lipids",
    f_h2_su=0.19 "Hydrogen from Sugars",
    f_bu_su=0.13 "Butyrate from Sugars",
    f_pro_su=0.27 "Propionate from Sugars",
    f_ac_su=0.41 "Acetate from Sugars",
    f_h2_aa=0.06 "Hydrogen from Amino Acids",
    f_va_aa=0.23 "Valerate from Amino Acids",
    f_bu_aa=0.26 "Butyrate from Amino Acids",
    f_pro_aa=0.05 "Propionate from Amino Acids",
    f_ac_aa=0.40 "Acetate from Amino Acids",
    C_su=31.3 "Carbon Content of Sugars in molC/kgCOD",
    C_aa=30 "Carbon Content of Amino Acids in molC/kgCOD",
    C_fa=21.7 "Carbon Content of LCFA in molC/kgCOD",
    C_va=24 "Carbon Content of Valerate in molC/kgCOD",
    C_bu=25 "Carbon Content of Butyrate in molC/kgCOD",
    C_pro=26.8 "Carbon Content of Propionate in molC/kgCOD",
    C_ac=31.3 "Carbon Content of Acetate in molC/kgCOD",
    C_h2=0 "Carbon Content of Hydrogen in molC/kgCOD",
    C_ch4=15.6 "Carbon Content of Methane in molC/kgCOD",
    C_sI=7 "Carbon Content of soluble Inerts in molC/kgCOD",
    C_xc=30.4 "Carbon Content of Composites in molC/kgCOD",
    C_ch=31.3 "Carbon Content of Carbohydrates in molC/kgCOD",
    C_pr=30 "Carbon Content of Proteins in molC/kgCOD",
    C_li=22 "Carbon Content of Lipids in molC/kgCOD",
    C_bac=31.3 "Carbon Content of Microorganisms in molC/kgCOD",
    C_xI=7 "Carbon Content of Particulate Inerts in molC/kgCOD",
    N_aa=7 "Nitrogen Content of Amino Acids in molN/kgCOD",
    N_I=5 "Nitrogen Content of Inerts in molN/kgCOD",
    N_xc=1.75 "Nitrogen Content of Composites in molN/kgCOD",
    N_bac=80/14 "Nitrogen Content of Microorganisms in molN/kgCOD",
    Y_su=0.10 "Yield of Biomass on Sugars in kgCOD/kgCOD",
    Y_aa=0.08 "Yield of Biomass on Amino Acids in kgCOD/kgCOD",
    Y_fa=0.06 "Yield of Biomass on LCFA in kgCOD/kgCOD",
    Y_c4=0.06 "Yield of Biomass on Valerate and Butyrate in kgCOD/kgCOD",
    Y_pro_meso=0.04 "Yield of Biomass on Propionate in kgCOD/kgCOD",
    Y_pro_therm=0.05 "Yield of Biomass on Propionate in kgCOD/kgCOD",
    Y_ac=0.05 "Yield of Biomass on Acetate in kgCOD/kgCOD",
    Y_h2=0.06 "Yield of Biomass on Hydrogen in kgCOD/kgCOD",
    k_dis_meso=0.1/86400 "Disintegration Rate of Composites in 1/s",
    k_hyd_ch_meso=10/86400 "Hydrolyisis Rate of Carbohydrates in 1/s",
    k_hyd_pr_meso=10/86400 "Hydrolyisis Rate of Proteins in 1/s",
    k_hyd_li_meso=10/86400 "Hydrolyisis Rate of Lipids in 1/s",
    k_dec_meso=0.02/86400 "Decay Rate of Microorganisms in 1/s",
    k_dec_ac_meso=0.02/86400 "Decay Rate of Acetate Degraders in 1/s",
    k_dis_therm=1.0/86400 "Disintegration Rate of Composites in 1/s",
    k_hyd_ch_therm=10/86400 "Hydrolyisis Rate of Carbohydrates in 1/s",
    k_hyd_pr_therm=10/86400 "Hydrolyisis Rate of Proteins in 1/s",
    k_hyd_li_therm=10/86400 "Hydrolyisis Rate of Lipids in 1/s",
    k_dec_therm=0.04/86400 "Decay Rate of Microorganisms in 1/s",
    k_m_su_meso=30/86400 "Maximum Uptake Rate of Sugar by Sugar degraders in kgCOD/kgCOD * 1/s",
    k_m_aa_meso=50/86400 "Maximum Uptake Rate of Amino Acid by Amino Acid degraders in kgCOD/kgCOD * 1/s",
    k_m_fa_meso=6/86400 "Maximum Uptake Rate of LCFA by LCFA degraders in kgCOD/kgCOD * 1/s",
    k_m_c4_meso=20/86400 "Maximum Uptake Rate of Valerate and Butyrate by C4 degraders in kgCOD/kgCOD * 1/s",
    k_m_pro_meso=8.5/86400 "Maximum Uptake Rate of Propionate by Propionate degraders in kgCOD/kgCOD * 1/s",
    k_m_ac_meso=7.64/86400 "Maximum Uptake Rate of Acetate by Acetate degraders in kgCOD/kgCOD * 1/s",
    k_m_h2_meso=35/86400 "Maximum Uptake Rate of Hydrogen by Hydrogen degraders in kgCOD/kgCOD * 1/s",
    k_m_su_therm=70/86400 "Maximum Uptake Rate of Sugar by Sugar degraders in kgCOD/kgCOD * 1/s",
    k_m_aa_therm=70/86400 "Maximum Uptake Rate of Amino Acid by Amino Acid degraders in kgCOD/kgCOD * 1/s",
    k_m_fa_therm=10/86400 "Maximum Uptake Rate of LCFA by LCFA degraders in kgCOD/kgCOD * 1/s",
    k_m_c4_therm=30/86400 "Maximum Uptake Rate of Valerate and Butyrate by C4 degraders in kgCOD/kgCOD * 1/s",
    k_m_pro_therm=20/86400 "Maximum Uptake Rate of Propionate by Propionate degraders in kgCOD/kgCOD * 1/s",
    k_m_ac_therm=16/86400 "Maximum Uptake Rate of Acetate by Acetate degraders in kgCOD/kgCOD * 1/s",
    k_m_h2_therm=35/86400 "Maximum Uptake Rate of Hydrogen by Hydrogen degraders in kgCOD/kgCOD * 1/s",
    K_S_su_meso=0.5 "Concentration of Sugar at which (uninhibited) uptake equals half of maximum uptake",
    K_S_aa_meso=0.3 "Concentration of Amino Acids at which (uninhibited) uptake equals half of maximum uptake",
    K_S_fa_meso=0.4 "Concentration of LCFA at which (uninhibited) uptake equals half of maximum uptake",
    K_S_c4_meso=0.23 "Concentration of Valerate or Butyrate at which (uninhibited) uptake equals half of maximum uptake",
    K_S_pro_meso=0.15 "Concentration of Propionate at which (uninhibited) uptake equals half of maximum uptake",
    K_S_ac_meso=0.6 "Concentration of Acetate at which (uninhibited) uptake equals half of maximum uptake",
    K_S_h2_meso=7e-6 "Concentration of Hydrogen at which (uninhibited) uptake equals half of maximum uptake",
    K_S_su_therm=0.5 "Concentration of Sugar at which (uninhibited) uptake equals half of maximum uptake",
    K_S_aa_therm=0.3 "Concentration of Amino Acids at which (uninhibited) uptake equals half of maximum uptake",
    K_S_fa_therm=0.4 "Concentration of LCFA at which (uninhibited) uptake equals half of maximum uptake",
    K_S_c4_therm=0.2 "Concentration of Valerate or Butyrate at which (uninhibited) uptake equals half of maximum uptake",
    K_S_pro_therm=0.1 "Concentration of Propionate at which (uninhibited) uptake equals half of maximum uptake",
    K_S_ac_therm=0.15 "Concentration of Acetate at which (uninhibited) uptake equals half of maximum uptake",
    K_S_h2_therm=7e-6 "Concentration of Hydrogen at which (uninhibited) uptake equals half of maximum uptake",
    pH_UL=5.5 "pH-Value at which no Inhibition due to low pH occurs",
    pH_LL=4 "pH-Value at which Uptake and growth are limited to 0.05, thus pH-Inhibition can be considered complete",
    pH_UL_ac=7 "pH-Value at which Acetate Degraders are not inhibited due to low pH occurs",
    pH_LL_ac=6 "pH-Value at which Uptake through Acetate Degraders limited to 0.05, thus pH-Inhibition can be considered complete",
    pH_UL_h2=6 "pH-Value at which Hydrogen Degraders are not inhibited due to low pH occurs",
    pH_LL_h2=5 "pH-Value at which Uptake through Hydrogen Degraders limited to 0.05, thus pH-Inhibition can be considered complete",
    K_S_IN=0.1 "Inhibition  regarding inhibition due to Nitrogen-Defficiency",
    K_I_H2_fa_meso=5e-6 "Hydrogen Concentration at which LCFA-Degraders are hindered",
    K_I_H2_c4_meso=1e-8 "Hydrogen Concentration at which Butyrate and Valerate Degraders are hindered",
    K_I_H2_pro_meso=4.8e-8 "Hydrogen Concentration at which Propionate Degraders are hindered",
    K_I_NH3_meso=0.30 "Ammonia Concentration at which Acetate Degraders are hindered",
    K_I_H2_c4_therm=3e-5 "Hydrogen Concentration at which Butyrate and Valerate Degraders are hindered under thermophilic conditions",
    K_I_H2_pro_therm=1e-5 "Hydrogen Concentration at which Propionate Degraders are hindered under thermophilic conditions",
    K_I_NH3_therm=11 "Ammonia Concentration at which Acetrate Degraders are hindered under thermophilic conditions",
    Kw_ref=10^(-14)*1e6,
    deltH0_w=55900 "Heat of AcidBase-Reaction",
    Ka_CO2_ref=10^(-6.35)*1000,
    deltH0_CO2=7646 "Heat of AcidBase-Reaction",
    Ka_HCO3_ref=10^(-10.3)*1000,
    deltH0_HCO3=14850 "Heat of AcidBase-Reaction",
    Ka_NH4_ref=10^(-9.25)*1000,
    deltH0_NH4=51965 "Heat of AcidBase-Reaction",
    Ka_H2S_ref=10^(-7.05)*1000,
    deltH0_H2S=21670 "Heat of AcidBase-Reaction",
    Ka_HAc_ref=10^(-4.76)*1000,
    Ka_HAc_max=10^(-4.81)*1000,
    Ka_HPro_ref=10^(-4.88)*1000,
    Ka_HPro_max=10^(-4.94)*1000,
    Ka_HBu_ref=10^(-4.82)*1000,
    Ka_HBu_max=10^(-4.92)*1000,
    Ka_HVa_ref=10^(-4.86)*1000,
    k_AB=1e10/86400,
    k_L=200/86400 "Gas-liquid transfer coefficient in 1/s",
    KH_h2_ref=7.8e-6 "Henry's law coefficient for Hydrogen",
    deltH0_H_h2=-4180 "Heat of Reaction of liquid-gas transfer of Hydrogen at 298K in J/mol",
    KH_ch4_ref=1.4e-5 "Henry's law coefficient for Methane",
    deltH0_H_ch4=-14240 "Heat of Reaction of liquid-gas transfer of Methane at 298K in J/mol",
    KH_co2_ref=3.5e-4 "Henry's law coefficient for Carbondioxide",
    deltH0_H_co2=-19410 "Heat of Reaction of liquid-gas transfer of Carbondioxide at 298K in J/mol",
    p_h2o_ref=3130 "Vapor Pressure of water at 298K in Pa",
    deltH0_vap=43980 "Evaporation Heat at 298K in J/mol",
    deltE_su_1=-25530 "Reaction Energy of sugar conversion path 1 (50%) per mol sugar at mesophilic conditions",
    deltE_su_2=-246690 "Reaction Energy of sugar conversion path 2 (35%) per mol sugar at mesophilic conditions",
    deltE_su_3=-121700 "Reaction Energy of sugar conversion path 3 (15%) per mol sugar at mesophilic conditions",
    deltE_aa=-36460 "Reaction Energy of Amino Acids conversion to acetate, CO2 and ammonia per mol amino acids at mesophilic conditions",
    deltE_fa=494880 "Reaction Energy of fatty acids (palmitate) conversion to acetate and hydrogen per mol fatty acid at mesophilic conditions",
    deltE_va=89990 "Reaction Energy of valerate conversion to propionate, acetate and hydrogen per mol valerate at mesophilic conditions",
    deltE_bu=83670 "Reaction Energy of butyrate conversion to acetate and hydrogen per mol butyrate at mesophilic conditions",
    deltE_pro=90870 "Reaction Energy of propionate conversion to acetate, CO2 and hydrogen per mol propionate at mesophilic conditions",
    deltE_ac=-27340 "Reaction Energy of acetate conversion to CH4 and CO2 per mol acetate at mesophilic conditions",
    deltE_h2=-18860 "Reaction Energy of methanation per mol h2 at mesophilic conditions",
    M_cod_su=192/1000 "Chemical Oxygen Demand in kgCOD per mole Glucose (sugar)",
    M_cod_aa=216/1000 "Chemical Oxygen Demand in kgCOD per mole Alanine and 2 mole Glycine (Stickland Reaction)",
    M_cod_fa=763/1000 "Chemical Oxygen Demand in kgCOD per mole Palmitate (fatty acid)",
    M_cod_va=208/1000 "Chemical Oxygen Demand in kgCOD per mole Valyric Acid",
    M_cod_bu=160/1000 "Chemical Oxygen Demand in kgCOD per mole Butyric Acid",
    M_cod_pro=112/1000 "Chemical Oxygen Demand in kgCOD per mole Propionic Acid",
    M_cod_ac=64/1000 "Chemical Oxygen Demand in kgCOD per mole Acetic Acid",
    M_cod_h2=16/1000 "Chemical Oxygen Demand in kgCOD per mole Hydrogen",
    M_cod_ch4=64/1000 "Chemical Oxygen Demand in kgCOD per mole Methane",
    ThOD_Xc=1.561 "ThOD kgCOD per kg Composites from Lübken et al. (2007). Modelling the energy balance of an anaerobic digester fed with cattle manure and renewable energy crops.",
    ThOD_XI=1.56 "ThOD in kgCOD per kg Inerts (Lignin) from Koch, et. al. (2010). Biogas from grass silage–measurements and modeling with ADM1.",
    ThOD_Xch=1.19 "ThOD in kgCOD per kg Carbohydrates  from Koch, et. al. (2010). Biogas from grass silage–measurements and modeling with ADM1.",
    ThOD_Xli=2.90 "ThOD in kgCOD per kg lipids  from Koch, et. al. (2010). Biogas from grass silage–measurements and modeling with ADM1.",
    ThOD_Xpr=1.42 "ThOD in kgCOD per kg Protein  from Koch, et. al. (2010). Biogas from grass silage–measurements and modeling with ADM1.",
    ThOD_bac=1.416 "ThOD in kgCOD per kg Microorganisms from Lübken et al. (2007). Modelling the energy balance of an anaerobic digester fed with cattle manure and renewable energy crops.",
    k_p=0.5/86400 "pipe resistance coefficient ");
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
<p>[1] Bułkowska, K., et al. (2015). ADM1-based modeling of anaerobic codigestion of maize silage and cattle manure&ndash;calibration of parameters and model verification (part II)</p>
<p>[2] Bułkowska, K., et al. (2015).ADM1-based modeling of anaerobic codigestion of maize silage and cattle manure &ndash; a feedstock characterisation for model implementation (part I)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Philipp Jahneke (philipp.koziol@tuhhl.de), Sept 2018</p>
<p>Model adapted for TransiEnt by Jan Westphal (j.westphal@tuhh.de) in May 2020</p>
</html>"));
end ADM1_parameters_manure_bulkowska;
