within TransiEnt.Producer.Gas.BiogasPlant.Base.ADM1;
model ADM1_CSTR "Modelling anaerobic digestion model number 1 equations"


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

  import      Modelica.Units.SI;
  import Modelica.Constants.R;
  extends TransiEnt.Basics.Icons.ADM1;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  TransiEnt.Producer.Gas.BiogasPlant.Base.GeometryCSTR geometryCSTR;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter Real[19,24] PM=PetersenMatrix.PM;

  final constant Real MIN=Modelica.Constants.eps "very small number used to avoid numerical instability of the acidbase equations, (biggest number so that 1.0+eps = 1.0)";

  //choose Constants according to operation mode, WARNING: only mesophilic operation mode has been validated

  final parameter Real Y_pro=if operationMode == "thermophilic" then PetersenMatrix.Parameters.Y_pro_therm else PetersenMatrix.Parameters.Y_pro_meso;
  final parameter ADM1_Units.KineticRateConstant k_dec=if operationMode == "thermophilic" then PetersenMatrix.Parameters.k_dec_therm else PetersenMatrix.Parameters.k_dec_meso "rate constant of microbial decay";
  final parameter ADM1_Units.KineticRateConstant k_dec_ac=if operationMode == "thermophilic" then PetersenMatrix.Parameters.k_dec_therm else PetersenMatrix.Parameters.k_dec_ac_meso "decay rate constant of acetate degraders";
  final parameter ADM1_Units.KineticRateConstant k_dis=if operationMode == "thermophilic" then PetersenMatrix.Parameters.k_dis_therm else PetersenMatrix.Parameters.k_dis_meso "disintegration rate constant";
  final parameter ADM1_Units.KineticRateConstant k_hyd_ch=if operationMode == "thermophilic" then PetersenMatrix.Parameters.k_hyd_ch_therm else PetersenMatrix.Parameters.k_hyd_ch_meso "hydrolysis rate constant of carbohydrates";
  final parameter ADM1_Units.KineticRateConstant k_hyd_pr=if operationMode == "thermophilic" then PetersenMatrix.Parameters.k_hyd_pr_therm else PetersenMatrix.Parameters.k_hyd_pr_meso "hydrolysis rate constant of proteins";
  final parameter ADM1_Units.KineticRateConstant k_hyd_li=if operationMode == "thermophilic" then PetersenMatrix.Parameters.k_hyd_li_therm else PetersenMatrix.Parameters.k_hyd_li_meso "hydrolysis rate constant of lipids";
  final parameter ADM1_Units.KineticRateConstant k_m_su=if operationMode == "thermophilic" then PetersenMatrix.Parameters.k_m_su_therm else PetersenMatrix.Parameters.k_m_su_meso "Monod maximum uptake rate constant for sugar degraders";
  final parameter ADM1_Units.KineticRateConstant k_m_aa=if operationMode == "thermophilic" then PetersenMatrix.Parameters.k_m_aa_therm else PetersenMatrix.Parameters.k_m_aa_meso "Monod maximum uptake rate constant for amino-acid degraders";
  final parameter ADM1_Units.KineticRateConstant k_m_fa=if operationMode == "thermophilic" then PetersenMatrix.Parameters.k_m_fa_therm else PetersenMatrix.Parameters.k_m_fa_meso "Monod maximum uptake rate constant for LCFA degraders";
  final parameter ADM1_Units.KineticRateConstant k_m_c4=if operationMode == "thermophilic" then PetersenMatrix.Parameters.k_m_c4_therm else PetersenMatrix.Parameters.k_m_c4_meso "Monod maximum uptake rate constant for valerate and butyrate degraders";
  final parameter ADM1_Units.KineticRateConstant k_m_pro=if operationMode == "thermophilic" then PetersenMatrix.Parameters.k_m_pro_therm else PetersenMatrix.Parameters.k_m_pro_meso "Monod maximum uptake rate constant for propionate degraders";
  final parameter ADM1_Units.KineticRateConstant k_m_ac=if operationMode == "thermophilic" then PetersenMatrix.Parameters.k_m_ac_therm else PetersenMatrix.Parameters.k_m_ac_meso "Monod maximum uptake rate for acetate degraders";
  final parameter ADM1_Units.KineticRateConstant k_m_h2=if operationMode == "thermophilic" then PetersenMatrix.Parameters.k_m_h2_therm else PetersenMatrix.Parameters.k_m_h2_meso "Monod maximum uptake rate constant for hydrogen degraders";
  final parameter ADM1_Units.ConcentrationCOD K_S_su=if operationMode == "thermophilic" then PetersenMatrix.Parameters.K_S_su_therm else PetersenMatrix.Parameters.K_S_su_meso "sugar concentration below which uptake is reduced to less than half of maximum uptake";
  final parameter ADM1_Units.ConcentrationCOD K_S_aa=if operationMode == "thermophilic" then PetersenMatrix.Parameters.K_S_aa_therm else PetersenMatrix.Parameters.K_S_aa_meso "amino acid concentration below which uptake is reduced to less than half of maximum uptake";
  final parameter ADM1_Units.ConcentrationCOD K_S_fa=if operationMode == "thermophilic" then PetersenMatrix.Parameters.K_S_fa_therm else PetersenMatrix.Parameters.K_S_fa_meso "LCFA concentration below which uptake is reduced to less than half of maximum uptake";
  final parameter ADM1_Units.ConcentrationCOD K_S_c4=if operationMode == "thermophilic" then PetersenMatrix.Parameters.K_S_c4_therm else PetersenMatrix.Parameters.K_S_c4_meso "Valerate/Butyrate concentration below which uptake is reduced to less than half of maximum uptake";
  final parameter ADM1_Units.ConcentrationCOD K_S_pro=if operationMode == "thermophilic" then PetersenMatrix.Parameters.K_S_pro_therm else PetersenMatrix.Parameters.K_S_pro_meso "Propionate concentration below which uptake is reduced to less than half of maximum uptake";
  final parameter ADM1_Units.ConcentrationCOD K_S_ac=if operationMode == "thermophilic" then PetersenMatrix.Parameters.K_S_ac_therm else PetersenMatrix.Parameters.K_S_ac_meso "Acetate concentration below which uptake is reduced to less than half of maximum uptake";
  final parameter ADM1_Units.ConcentrationCOD K_S_h2=if operationMode == "thermophilic" then PetersenMatrix.Parameters.K_S_h2_therm else PetersenMatrix.Parameters.K_S_h2_meso "Hydrogen concentration below which uptake is reduced to less than half of maximum uptake";

  final parameter ADM1_Units.KineticRateConstant[7] k_m={k_m_su,k_m_aa,k_m_fa,k_m_c4,k_m_pro,k_m_ac,k_m_h2} "vector of Monod maximum uptake rates";

  final parameter Real[24] Component_in={S_su_in,S_aa_in,S_fa_in,S_va_in,S_bu_in,S_pro_in,S_ac_in,S_h2_in,S_ch4_in,S_IC_in,S_IN_in,S_I_in,X_c_in,X_ch_in,X_pr_in,X_li_in,X_su_in,X_aa_in,X_fa_in,X_c4_in,X_pro_in,X_ac_in,X_h2_in,X_I_in} "vector of Inflow Concentrations";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.Volume V_liquid=geometryCSTR.V_fluid "Volume of Substrate in CSTR";
  parameter SI.Volume V_gas=geometryCSTR.V_gas "Gas Volume inside CSTR";
  parameter SI.Time t_res=20*86400 "mean residence time of substrate";
  parameter Boolean ComponentInput=false "=true, if Input Concentration is defined by input";
  parameter Boolean useBSM2=true "true if BSM2 parameters shall be used";
  parameter String operationMode="mesophilic" annotation (choices(choice="mesophilic", choice="thermophilic"));
  input SI.Pressure p_atm=101300 "pressure of gas after leaving the CSTR through port" annotation (Dialog(group=Variables));

  parameter SI.Concentration Cat=40;
  parameter SI.Concentration An=20 "Concentration of Cations and Anions of strong acids or base, whose equilibrium is assumed not to be affected by pH-Value";

  //Inflow Composition for bsm2
  //solubles
  parameter SI.MassConcentration S_su_in=0.01 "Concentration of Monosaccharides in inflowing substrate in kgCOD/m^3";
  parameter SI.MassConcentration S_aa_in=0.001 "Concentration of Amino Acids in inflowing substrate in kgCOD/m^3";
  parameter SI.MassConcentration S_fa_in=0.001 "Concentration of Long Chain Fatty Acids in inflowing substrate in kgCOD/m^3";
  parameter SI.MassConcentration S_va_in=0.001 "Concentration of total Valerate in inflowing substrate in kgCOD/m^3";
  parameter SI.MassConcentration S_bu_in=0.001 "Concentration of total Butyrate in inflowing substrate in kgCOD/m^3";
  parameter SI.MassConcentration S_pro_in=0.001 "Concentration of total Propionate in inflowing substrate in kgCOD/m^3";
  parameter SI.MassConcentration S_ac_in=0.001 "Concentration of total Acetate in inflowing substrate in kgCOD/m^3";
  parameter SI.MassConcentration S_h2_in=1e-8 "Concentration of dissolved Hydrogen gas in inflowing substrate in kgCOD/m^3";
  parameter SI.MassConcentration S_ch4_in=1e-5 "Concentration of dissolved Methane gas in inflowing substrate in kgCOD/m^3";
  parameter SI.Concentration S_IC_in=40 "Concentration of Inorganic Carbon in inflowing substrate in mol/m^3";
  parameter SI.Concentration S_IN_in=10 "Concentration of Inorganic Nitrogen in inflowing substrate in mol/m^3";
  parameter SI.MassConcentration S_I_in=0.02 "Concentration of Soluble Inerts in inflowing substrate in kgCOD/m^3";
  //particulates
  parameter SI.MassConcentration X_c_in=2 "Concentration of Composites in inflowing substrate in kgCOD/m^3";
  parameter SI.MassConcentration X_ch_in=5 "Concentration of Carbohydrates in inflowing substrate in kgCOD/m^3";
  parameter SI.MassConcentration X_pr_in=20 "Concentration of Proteins in inflowing substrate in kgCOD/m^3";
  parameter SI.MassConcentration X_li_in=5 "Concentration of Lipids in inflowing substrate in kgCOD/m^3";
  parameter SI.MassConcentration X_su_in=0.00 "Concentration of Sugar degraders in inflowing substrate in kgCOD/m^3";
  parameter SI.MassConcentration X_aa_in=0.01 "Concentration of Amino Acid degraders in inflowing substrate in kgCOD/m^3";
  parameter SI.MassConcentration X_fa_in=0.01 "Concentration of LCFA degraders in inflowing substrate in kgCOD/m^3";
  parameter SI.MassConcentration X_c4_in=0.01 "Concentration of Valerate and Butyrate degraders in inflowing substrate in kgCOD/m^3";
  parameter SI.MassConcentration X_pro_in=0.01 "Concentration of Propionate degraders in inflowing substrate in kgCOD/m^3";
  parameter SI.MassConcentration X_ac_in=0.01 "Concentration of Acetate degraders in inflowing substrate in kgCOD/m^3";
  parameter SI.MassConcentration X_h2_in=0.01 "Concentration of Hydrogen degraders in inflowing substrate in kgCOD/m^3";
  parameter SI.MassConcentration X_I_in=25 "Concentration of Particulate Inerts in inflowing substrate in kgCOD/m^3";


    //  manure inflow (bulkowska)
 /* parameter SI.MassConcentration S_su_in = 0.24 "Concentration of Monosaccharides in kgCOD/m^3";
  parameter SI.MassConcentration S_aa_in = 0.0011 "Concentration of Amino Acids in kgCOD/m^3";
  parameter SI.MassConcentration S_fa_in = 0.0010 "Concentration of Long Chain Fatty Acids in kgCOD/m^3";
  parameter SI.MassConcentration S_va_in = 0.1680 "Concentration of total Valerate in kgCOD/m^3";
  parameter SI.MassConcentration S_bu_in = 0.39 "Concentration of total Butyrate in kgCOD/m^3";
  parameter SI.MassConcentration S_pro_in = 0.7454 "Concentration of total Propionate in kgCOD/m^3";
  parameter SI.MassConcentration S_ac_in = 2.3467 "Concentration of total Acetate in kgCOD/m^3";
  parameter SI.MassConcentration S_h2_in = 0 "Concentration of dissolved Hydrogen gas in kgCOD/m^3";
  parameter SI.MassConcentration S_ch4_in = 0 "Concentration of dissolved Methane gas in kgCOD/m^3";
  parameter SI.Concentration S_IC_in = 32.3 "Concentration of Inorganic Carbon in mol/m^3";
  parameter SI.Concentration S_IN_in = 18.57 "Concentration of Inorganic Nitrogen in mol/m^3";
  parameter SI.MassConcentration S_I_in = 8.49 "Concentration of Soluble Inerts in kgCOD/m^3";
  //particulates
  parameter SI.MassConcentration X_c_in = 0 "Concentration of Composites in kgCOD/m^3";
  parameter SI.MassConcentration X_ch_in = 59.0555 "Concentration of Carbohydrates in kgCOD/m^3";
  parameter SI.MassConcentration X_pr_in = 13.1103 "Concentration of Proteins in kgCOD/m^3";
  parameter SI.MassConcentration X_li_in = 5.6693 "Concentration of Lipids in kgCOD/m^3";
  parameter SI.MassConcentration X_su_in = 0.0855 "Concentration of Sugar degraders in kgCOD/m^3";
  parameter SI.MassConcentration X_aa_in = 0.0637 "Concentration of Amino Acid degraders in kgCOD/m^3";
  parameter SI.MassConcentration X_fa_in = 0.0670 "Concentration of LCFA degraders in kgCOD/m^3";
  parameter SI.MassConcentration X_c4_in = 0.028 "Concentration of Valerate and Butyrate degraders in kgCOD/m^3";
  parameter SI.MassConcentration X_pro_in = 0.0135 "Concentration of Propionate degraders in kgCOD/m^3";
  parameter SI.MassConcentration X_ac_in = 0.09 "Concentration of Acetate degraders in kgCOD/m^3";
  parameter SI.MassConcentration X_h2_in = 0.0430 "Concentration of Hydrogen degraders in kgCOD/m^3";
  parameter SI.MassConcentration X_I_in = 40.2759 "Concentration of Particulate Inerts in kgCOD/m^3";*/


  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  input SI.Temperature T "Temperatur inside reactor" annotation (Dialog(group=Variables));
  input SI.Density rho "Density of substrate" annotation (Dialog(group=SubstrateProperties));
  SI.VolumeFlowRate q_gas(displayUnit="l/d") "gas volume flow at inside pressure";
  SI.VolumeFlowRate q_gas_out=q_gas*p/p_atm "gas volume flow at nominal pressure";
  SI.VolumeFlowRate q_liquid_in=V_liquid/t_res "Substrate Volume flow flowing into the CSTR";
  SI.VolumeFlowRate q_liquid_out=V_liquid/t_res "Substrate Volume flow leaving the CSTR";

  Boolean gasValveOpen;

  //Composition of Substrate inside CSTR
  //solubles
  SI.MassConcentration S_su "Concentration of Monosaccharides in kgCOD/m^3";
  SI.MassConcentration S_aa "Concentration of Amino Acids in kgCOD/m^3";
  SI.MassConcentration S_fa "Concentration of Long Chain Fatty Acids in kgCOD/m^3";
  SI.MassConcentration S_va "Concentration of total Valerate in kgCOD/m^3";
  SI.MassConcentration S_bu "Concentration of total Butyrate in kgCOD/m^3";
  SI.MassConcentration S_pro "Concentration of total Propionate in kgCOD/m^3";
  SI.MassConcentration S_ac "Concentration of total Acetate in kgCOD/m^3";
  SI.MassConcentration S_h2 "Concentration of dissolved Hydrogen gas in kgCOD/m^3";
  SI.MassConcentration S_ch4 "Concentration of dissolved Methane gas in kgCOD/m^3";
  SI.Concentration S_IC "Concentration of Inorganic Carbon in mol/m^3";
  SI.Concentration S_IN "Concentration of Inorganic Nitrogen in mol/m^3";
  SI.MassConcentration S_I "Concentration of Soluble Inerts in kgCOD/m^3";
  //particulates
  SI.MassConcentration X_c "Concentration of Composites in kgCOD/m^3";
  SI.MassConcentration X_ch "Concentration of Carbohydrates in kgCOD/m^3";
  SI.MassConcentration X_pr "Concentration of Proteins in kgCOD/m^3";
  SI.MassConcentration X_li "Concentration of Lipids in kgCOD/m^3";
  SI.MassConcentration X_su "Concentration of Sugar degraders in kgCOD/m^3";
  SI.MassConcentration X_aa "Concentration of Amino Acid degraders in kgCOD/m^3";
  SI.MassConcentration X_fa "Concentration of LCFA degraders in kgCOD/m^3";
  SI.MassConcentration X_c4 "Concentration of Valerate and Butyrate degraders in kgCOD/m^3";
  SI.MassConcentration X_pro "Concentration of Propionate degraders in kgCOD/m^3";
  SI.MassConcentration X_ac "Concentration of Acetate degraders in kgCOD/m^3";
  SI.MassConcentration X_h2 "Concentration of Hydrogen degraders in kgCOD/m^3";
  SI.MassConcentration X_I "Concentration of Particulate Inerts in kgCOD/m^3";

  //gasPhase Composition
  SI.MassConcentration S_gas_h2 "Concentration of Hydrogen in Gas-Phase in kgCOD/m^3";
  SI.MassConcentration S_gas_ch4 "Concentration of Methane in Gas-Phase in kgCOD/m^3";
  SI.Concentration S_gas_co2 "Concentration of Carbondioxide in Gas-Phase in mol/m^3";
  SI.PartialPressure p_h2 "Partial Pressure of Hydrogen in gas phase";
  SI.PartialPressure p_ch4 "Partial Pressure of Methane in gas phase";
  SI.PartialPressure p_co2 "Partial Pressure of Carbondioxide in gas phase";
  SI.PartialPressure p_h2o "Partial Pressure of Water Vapor in gas phase";
  SI.Pressure p "Absolute pressure of gas inside Reactor";

  //AcidBase Concentrations
  SI.Concentration S_cat_p "Concentration of additional Cations not related to ADM1 components in solution";
  SI.Concentration S_an_n "Concentration of additional Anions not relted to ADM1 components in solution";
  SI.Concentration S_Va_n "Concentration of Valerate Anions in solution";
  SI.Concentration S_Bu_n "Concentration of Butyrate Anions in solution";
  SI.Concentration S_Pro_n "Concentration of Propionate Anions in solution";
  SI.Concentration S_Ac_n "Concentration of Acetate Anions in solution";
  SI.Concentration S_HCO3_n "Concentration of Hydrogencarbonate Anions in solution";
  SI.Concentration S_NH3_aq "Concentration of Ammonia in solution";
  SI.Concentration S_NH4_p "Concentration of Ammonium Cations in solution";
  SI.Concentration S_CO2_aq "Concentration of Carbondioxide in solution";
  SI.Concentration S_H_p "Concentration of Protons in solution";
  SI.Concentration PHI "Charge Balance without Protons and Hydroxide Anions";

  Real pH=3 - log10(S_H_p) "pH Wert if using mol per cubic meter instead of mol per litre";

  // Acid-Base Equilibrium Constants
  Real Kw(final unit="mol2/m6") = TransiEnt.Producer.Gas.BiogasPlant.Base.ADM1.ADM1_Functions.VantHoffEquation(
    PetersenMatrix.Parameters.Kw_ref,
    PetersenMatrix.Parameters.deltH0_w,
    T) "Autoprotolysis Constant of Water";
  SI.Concentration Ka_CO2=TransiEnt.Producer.Gas.BiogasPlant.Base.ADM1.ADM1_Functions.VantHoffEquation(
      PetersenMatrix.Parameters.Ka_CO2_ref,
      PetersenMatrix.Parameters.deltH0_CO2,
      T) "Acid dissociation constant of CO2 in water";
  SI.Concentration Ka_NH4=TransiEnt.Producer.Gas.BiogasPlant.Base.ADM1.ADM1_Functions.VantHoffEquation(
      PetersenMatrix.Parameters.Ka_NH4_ref,
      PetersenMatrix.Parameters.deltH0_NH4,
      T) "Acid dissociation constant of Ammonium Ions";
  SI.Concentration Ka_HVa=PetersenMatrix.Parameters.Ka_HVa_ref "Acid dissociation constant of Valyric Acid";
  SI.Concentration Ka_HBu=PetersenMatrix.Parameters.Ka_HBu_ref "Acid dissociation constant of Butyric Acid";
  SI.Concentration Ka_HPro=PetersenMatrix.Parameters.Ka_HPro_ref "Acid dissociation constant of Propionic Acid";
  SI.Concentration Ka_HAc=PetersenMatrix.Parameters.Ka_HAc_ref "Acid dissociation constant of Acetic Acid";

  //Henry Coefficients
  Real KH_h2(final unit="mol/(m3.Pa)") = TransiEnt.Producer.Gas.BiogasPlant.Base.ADM1.ADM1_Functions.VantHoffEquation(
    PetersenMatrix.Parameters.KH_h2_ref,
    PetersenMatrix.Parameters.deltH0_H_h2,
    T) "Henry Coefficient for liquid gas transfer of Hydrogen";
  Real KH_ch4(final unit="mol/(m3.Pa)") = TransiEnt.Producer.Gas.BiogasPlant.Base.ADM1.ADM1_Functions.VantHoffEquation(
    PetersenMatrix.Parameters.KH_ch4_ref,
    PetersenMatrix.Parameters.deltH0_H_ch4,
    T) "Henry Coefficient for liquid gas transfer of Methane";
  Real KH_co2(final unit="mol/(m3.Pa)") = TransiEnt.Producer.Gas.BiogasPlant.Base.ADM1.ADM1_Functions.VantHoffEquation(
    PetersenMatrix.Parameters.KH_co2_ref,
    PetersenMatrix.Parameters.deltH0_H_co2,
    T) "Henry Coefficient for liquid gas transfer of Carbondioxide";

  //Inhibition Coefficients
  Real I_su "Coefficient describing inhibition of sugar degraders";
  Real I_aa "Coefficient describing inhibition of amino acid degraders";
  Real I_fa "Coefficient describing inhibition of LCFA degraders";
  Real I_c4 "Coefficient describing inhibition of Butyrate and Valerate degraders";
  Real I_pro "Coefficient describing inhibition of Propionate degraders";
  Real I_ac "Coefficient describing inhibition of Acetate degraders";
  Real I_h2 "Coefficient describing inhibition of hydrogen degraders";

  Real[7] I={I_su,I_aa,I_fa,I_c4,I_pro,I_ac,I_h2} "vector of Inhibition constants";

  Real[24] Component={S_su,S_aa,S_fa,S_va,S_bu,S_pro,S_ac,S_h2,S_ch4,S_IC,S_IN,S_I,X_c,X_ch,X_pr,X_li,X_su,X_aa,X_fa,X_c4,X_pro,X_ac,X_h2,X_I} "Compostion vector of substrate inside CSTR";
  Real[7] DecayRate=cat(
      1,
      k_dec*{X_su,X_aa,X_fa,X_c4,X_pro},
      {k_dec_ac*X_ac,k_dec*X_h2}) "Decay Rates of microorganisms";
  Real[4] ProcessRate={k_dis,k_hyd_ch,k_hyd_pr,k_hyd_li} .* {X_c,X_ch,X_pr,X_li} "Process Rates of disintegration and hydrolysis";
  Real[8] MonodRate "Rates of metabolism of microorganisms";
  Real[3] TransferRate "liquid to gas transfer rates";

  Real[24] Reactions "vector containing all Conversion Reactions of ADM1";
  SI.EnergyFlowRate Q_flow_R "Energy Flow released by metabolism reactions";

  Modelica.Units.SI.MassConcentration VS "organic fraction of solids";
  Modelica.Units.SI.MassConcentration VS_in "organic fraction of solids in inflow";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealOutput Components[24]={S_su,S_aa,S_fa,S_va,S_bu,S_pro,S_ac,S_h2,S_ch4,S_IC,S_IN,S_I,X_c,X_ch,X_pr,X_li,X_su,X_aa,X_fa,X_c4,X_pro,X_ac,X_h2,X_I} "output composition of outflow which equals composition in CSTR" annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Interfaces.RealInput Components_In[24] if ComponentInput "input composition if set from outside or taken outflow composition of other CSTR as input" annotation (Placement(transformation(extent={{-124,-12},{-100,12}})));

  // _____________________________________________
  //
  //           Instances of Other Classes
  // _____________________________________________

  replaceable ADM1_PetersenMatrix PetersenMatrix(
    redeclare Records.ADM1_parameters_BSM2 Parameters,
    CarbonBalance=2,
    operationMode="mesophilic",
    NitrogenBalance=0) "Petersen Matrix of ADM1" annotation (
    Dialog(group="Replaceable Components"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-10,-8},{10,12}})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

initial equation

  if useBSM2 then
    Component = {0.012,0.0053,0.099,0.012,0.0133,0.016,0.20,2.4e-7,0.055,150,130,0.33,0.31,0.028,0.10,0.029,0.42,1.2,0.24,0.43,0.14,0.76,0.32,25.6};
  else
    //(manure)
    Component = {0.008,0.003,0.045,0.13,0.31,0.2,0.3,1.4e-7,0.055,100,130,0.33,0.31,0.028,0.10,0.029,0.42,1.2,0.24,0.43,0.14,0.76,0.32,25.6} "Steady State Composition as Initial Condition";
  end if;

  S_Va_n = 0.997*S_va/208;
  S_Bu_n = 0.997*S_bu/160;
  S_Pro_n = 0.997*S_pro/112;
  S_Ac_n = 0.997*S_ac/64;
  S_HCO3_n = 0.9*S_IC;
  S_NH3_aq = 4.09;

  pre(gasValveOpen)=true;

equation

  //Inhibition Function

  if useBSM2 then
    I = TransiEnt.Producer.Gas.BiogasPlant.Base.ADM1.ADM1_Functions.ADM1_Inhibition_BSM2(
      operationMode=operationMode,
      pH=pH,
      S_IN=S_IN,
      S_h2=S_h2,
      NH3=S_NH3_aq) "function Calculating the inhibition coefficients";
  else
    I = TransiEnt.Producer.Gas.BiogasPlant.Base.ADM1.ADM1_Functions.ADM1_Inhibition_manureBulkowska(
      operationMode=operationMode,
      pH=pH,
      S_IN=S_IN,
      S_h2=S_h2,
      NH3=S_NH3_aq) "function Calculating the inhibition coefficients";
  end if;

  //Monod Rate describing metabolism of organisms
  MonodRate[1] = noEvent(if S_su > 0 then k_m_su*S_su/(K_S_su + S_su)*X_su*I_su else 0) "monod rate equation for sugar degradation, set to zero if sugar concentration is not positive to avoid unphysical results";
  MonodRate[2] = noEvent(if S_aa > 0 then k_m_aa*S_aa/(K_S_aa + S_aa)*X_aa*I_aa else 0) "monod rate equation for amino acid degradation, set to zero if amino acid concentration is not positive to avoid unphysical results";
  MonodRate[3] = noEvent(if S_fa > 0 then k_m_fa*S_fa/(K_S_fa + S_fa)*X_fa*I_fa else 0) "monod rate equation for LCFA degradation, set to zero if LCFA concentration is not positive to avoid unphysical results";
  MonodRate[4] = noEvent(if S_va > 0 then k_m_c4*S_va/(K_S_c4 + S_va)*X_c4*S_va/(S_va + S_bu)*I_c4 else 0) "monod rate equation for Valerate degradation, set to zero if Valerate concentration is not positive to avoid unphysical results";
  MonodRate[5] = noEvent(if S_bu > 0 then k_m_c4*S_bu/(K_S_c4 + S_bu)*X_c4*S_bu/(S_va + S_bu)*I_c4 else 0) "monod rate equation for Butyrate degradation, set to zero if Butyrate concentration is not positive to avoid unphysical results";
  MonodRate[6] = noEvent(if S_pro > 0 then k_m_pro*S_pro/(K_S_pro + S_pro)*X_pro*I_pro else 0) "monod rate equation for Propionate degradation, set to zero if Propionate concentration is not positive to avoid unphysical results";
  MonodRate[7] = noEvent(if S_ac > 0 then k_m_ac*S_ac/(K_S_ac + S_ac)*X_ac*I_ac else 0) "monod rate equation for Acetate degradation, set to zero if Acetate concentration is not positive to avoid unphysical results";
  MonodRate[8] = noEvent(if S_h2 > 0 then k_m_h2*S_h2/(K_S_h2 + S_h2)*X_h2*I_h2 else 0) "monod rate equation for Hydrogen degradation, set to zero if Hydrogen concentration is not positive to avoid unphysical results";

  TransferRate[1] = PetersenMatrix.Parameters.k_L*(S_h2 - PetersenMatrix.Parameters.M_cod_h2*KH_h2*p_h2) "Transfer rate from liquid to gas phase depending on Hydrogen Concentration in liquid and Hydrogen Partial Pressure in gas Phase";
  TransferRate[2] = PetersenMatrix.Parameters.k_L*(S_ch4 - PetersenMatrix.Parameters.M_cod_ch4*KH_ch4*p_ch4) "Transfer rate from liquid to gas phase depending on Methane Concentration in liquid and Methane Partial Pressure in gas Phase";
  TransferRate[3] = PetersenMatrix.Parameters.k_L*(S_CO2_aq - KH_co2*p_co2) "Transfer rate from liquid to gas phase depending on CO2 Concentration in liquid and CO2 Partial Pressure in gas Phase";

  //gas phase equations
  p = p_h2 + p_ch4 + p_co2 + p_h2o "total pressure in headspace as sum of partial pressures";
  p_h2 = R*T*S_gas_h2/PetersenMatrix.Parameters.M_cod_h2 "partial pressure of hydrogen in headspace";
  p_ch4 = R*T*S_gas_ch4/PetersenMatrix.Parameters.M_cod_ch4 "partial pressure of methane in headspace";
  p_co2 = R*T*S_gas_co2 "partial pressure of carbondioxide in headspace";
  p_h2o = TransiEnt.Producer.Gas.BiogasPlant.Base.ADM1.ADM1_Functions.VantHoffEquation(
    PetersenMatrix.Parameters.p_h2o_ref,
    PetersenMatrix.Parameters.deltH0_vap,
    T) "partial pressure of water-vapour in headspace";
  der(S_gas_h2) = -S_gas_h2*q_gas/V_gas + TransferRate[1]*V_liquid/V_gas "DGL for hydrogen concentration in gas-phase";
  der(S_gas_ch4) = -S_gas_ch4*q_gas/V_gas + TransferRate[2]*V_liquid/V_gas "DGL for methane concentration in gas-phase";
  der(S_gas_co2) = -S_gas_co2*q_gas/V_gas + TransferRate[3]*V_liquid/V_gas "DGL for carbondioxide concentration in gas-phase";

  q_gas = if gasValveOpen then PetersenMatrix.Parameters.k_p*(p - p_atm) else 0 "Volume flow of biogas proportional to overpressure in reactor, gas Valve is closed if overpressure is to small to avoid backflow";

  //Balance of Chemical Species in liquid phase
  V_liquid*der(Component) = q_liquid_in*Component_in - q_liquid_out*Component + V_liquid*Reactions "Set of DGLs describing Balance of Composition in Substrate";

  //Reactions inside the Reactor
  Reactions = transpose(PM)*cat(
    1,
    ProcessRate,
    MonodRate,
    DecayRate) - cat(
    1,
    zeros(7),
    TransferRate,
    zeros(14)) "Reactions inside CSTR as matrix product of transposed petersen matrix times rate vector plus liquid-gas transfer rates";

  //Reaction Energy Production
  Q_flow_R = -V_liquid*((0.5*PetersenMatrix.Parameters.deltE_su_1 + 0.35*PetersenMatrix.Parameters.deltE_su_2 + 0.15*PetersenMatrix.Parameters.deltE_su_3)/PetersenMatrix.Parameters.M_cod_su*MonodRate[1] + PetersenMatrix.Parameters.deltE_aa/PetersenMatrix.Parameters.M_cod_aa*MonodRate[2] + PetersenMatrix.Parameters.deltE_fa/PetersenMatrix.Parameters.M_cod_fa*MonodRate[3] + PetersenMatrix.Parameters.deltE_va/PetersenMatrix.Parameters.M_cod_va*MonodRate[4] + PetersenMatrix.Parameters.deltE_bu/PetersenMatrix.Parameters.M_cod_bu*MonodRate[5] + PetersenMatrix.Parameters.deltE_pro/PetersenMatrix.Parameters.M_cod_pro*MonodRate[6] + PetersenMatrix.Parameters.deltE_ac/PetersenMatrix.Parameters.M_cod_ac*MonodRate[7] + PetersenMatrix.Parameters.deltE_h2/PetersenMatrix.Parameters.M_cod_h2*MonodRate[8]) "Energy Production by microorganisms as reaction energy per mol converted to reaction energy per kgCOD times Reaction Rate";

  //Volatile Solids in Substrate of CSTR and inflow
  VS = X_c/PetersenMatrix.Parameters.ThOD_Xc + X_ch/PetersenMatrix.Parameters.ThOD_Xch + X_li/PetersenMatrix.Parameters.ThOD_Xli + X_pr/PetersenMatrix.Parameters.ThOD_Xpr + (X_su + X_aa + X_fa + X_c4 + X_h2 + X_ac + X_pro)/PetersenMatrix.Parameters.ThOD_bac + X_I/PetersenMatrix.Parameters.ThOD_XI "Volatile Solids in kgVS/m3 as sum of particulate concentrations converted from kgCOD/m3 to kg/m3";
  VS_in = X_c_in/PetersenMatrix.Parameters.ThOD_Xc + X_ch_in/PetersenMatrix.Parameters.ThOD_Xch + X_li_in/PetersenMatrix.Parameters.ThOD_Xli + X_pr_in/PetersenMatrix.Parameters.ThOD_Xpr + (X_su_in + X_aa_in + X_fa_in + X_c4_in + X_h2_in + X_ac_in + X_pro_in)/PetersenMatrix.Parameters.ThOD_bac + X_I_in/PetersenMatrix.Parameters.ThOD_XI "Volatile Solids in inflowing Substrate in kgVS/m3 as sum of particulate concentrations converted from kgCOD/m3 to kg/m3";

  //AcidBase - Differential & Algebraic Equations
  //see Rosén, C., & Jeppsson, U. (2006). Aspects on ADM1 Implementation within the BSM2 Framework for details
  der(S_Va_n) = -PetersenMatrix.Parameters.k_AB*(S_Va_n*(Ka_HVa + S_H_p) - Ka_HVa*S_va/PetersenMatrix.Parameters.M_cod_va) "DGL balancing Valerate Anion concentration acc. to Rosén, C., & Jeppsson, U. (2006). Aspects on ADM1 Implementation within the BSM2 Framework.";
  der(S_Bu_n) = -PetersenMatrix.Parameters.k_AB*(S_Bu_n*(Ka_HBu + S_H_p) - Ka_HBu*S_bu/PetersenMatrix.Parameters.M_cod_bu) "DGL balancing Butyrate Anion concentration acc. to Rosén, C., & Jeppsson, U. (2006). Aspects on ADM1 Implementation within the BSM2 Framework.";
  der(S_Pro_n) = -PetersenMatrix.Parameters.k_AB*(S_Pro_n*(Ka_HPro + S_H_p) - Ka_HPro*S_pro/PetersenMatrix.Parameters.M_cod_pro) "DGL balancing Propionate Anion concentration acc. to Rosén, C., & Jeppsson, U. (2006). Aspects on ADM1 Implementation within the BSM2 Framework.";
  der(S_Ac_n) = -PetersenMatrix.Parameters.k_AB*(S_Ac_n*(Ka_HAc + S_H_p) - Ka_HAc*S_ac/PetersenMatrix.Parameters.M_cod_ac) "DGL balancing Acetate Anion concentration acc. to Rosén, C., & Jeppsson, U. (2006). Aspects on ADM1 Implementation within the BSM2 Framework.";
  der(S_HCO3_n) = -PetersenMatrix.Parameters.k_AB*(S_HCO3_n*(Ka_CO2 + S_H_p) - Ka_CO2*S_IC) "DGL balancing Hydrogencarbonate Anion concentration acc. to Rosén, C., & Jeppsson, U. (2006). Aspects on ADM1 Implementation within the BSM2 Framework.";
  der(S_NH3_aq) = -PetersenMatrix.Parameters.k_AB*(S_NH3_aq*(Ka_NH4 + S_H_p) - Ka_NH4*S_IN) "DGL balancing free Ammonia concentration acc. to Rosén, C., & Jeppsson, U. (2006). Aspects on ADM1 Implementation within the BSM2 Framework.";
  S_CO2_aq = S_IC - S_HCO3_n "Algebraic Equation calculating Carbondioxide Concentration in solution as Difference between total inorganic carbon and Hydrogencarbonate concentrations";
  S_NH4_p = S_IN - S_NH3_aq "Algebraic Equation calculating Amonium Cation Concentration as Difference between total inorganic nitrogen and Ammonia concentrations";
  S_cat_p = Cat "Concentration of additional cations is equal to parameter set by user";
  S_an_n = An "Concentration of additional anions is equal to parameter set by user";
  PHI = S_cat_p + S_NH4_p - S_HCO3_n - S_Ac_n - S_Pro_n - S_Bu_n - S_Va_n - S_an_n + MIN "added MIN = very small number for numerical stability, Charge Balance without Protons and Hydroxide Ions acc. to Rosén, C., & Jeppsson, U. (2006). Aspects on ADM1 Implementation within the BSM2 Framework.";
  S_H_p = max(MIN, -PHI/2 + 0.5*sqrt(PHI^2 + 4*Kw)) "Algebraic Equation to calculate Proton concentration charge balance as quadratic equation. Proton Concentration is set to be always greater than MIN = 1e-15 mol/m3 = 1e-18 mol/l to avoid negative concentration";

  gasValveOpen = not pre(gasValveOpen) and p > p_atm+100 or pre(gasValveOpen) and p >= p_atm;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model contains different equatios for modeling the processes of anaerobic digestion. It can be chosen between the parameters of Bulkowska et al. and the bsm2 parameters.</p>
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
<p>It is important to check if the parameters of the record and inflow parameters of the adm1 model fit to each other so that only bsm2 parameters or only bulkowska parameters are used.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>This model has been validated as part of the master thesis of Philip Jahneke and it was tested in the check model &quot;TestADM1&quot; (look there for further information about the validation). Only the mesophilic operation mode has been validated.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] Bułkowska, K., et al. (2015). .ADM1-based modeling of anaerobic codigestion of maize silage and cattle manure &ndash; a feedstock characterisation for model implementation (part I) </p>
<p>[2] Ros&eacute;n, C., &amp; Jeppsson, U. (2006). Aspects on ADM1 Implementation within the BSM2 Framework</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Philipp Jahneke (philipp.koziol@tuhhl.de), Sept 2018</p>
<p>Model adapted for TransiEnt by Jan Westphal (j.westphal@tuhh.de) in May 2020</p>
</html>"),
    experiment(
      StopTime=17280000,
      Interval=3600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end ADM1_CSTR;
