within TransiEnt.Examples.Hamburg;
record ExampleGenerationPark2012 "Example Generation Park for the year of 2012 (based on german generation park in 2012)"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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
  import TransiEnt;
  extends TransiEnt.Grid.Electrical.Base.PartialGenerationPark(
  nPlants=22,
  nDispPlants=15,
  P_max={P_el_n_NUC, P_el_n_BCG, P_el_n_WT, P_el_n_GUDTS, P_el_n_WW1, P_el_n_WW2, P_el_n_BC,
         P_el_n_CCP, P_el_n_GT1,P_el_n_GT2, P_el_n_OIL, P_el_n_OILGT, P_el_n_GAR, P_el_n_BM,
         P_el_n_PS},
  P_min={P_min_star_NUC, P_min_star_BCG, P_min_star_CHP, P_min_star_CCP,P_min_star_CHP,
         P_min_star_CHP, P_min_star_BC, P_min_star_CCP, P_min_star_GT,P_min_star_GT,
         P_min_star_OIL, P_min_star_GT, P_min_star_GAR, P_min_star_BM, P_min_star_PS}.*P_max,
  P_grad_max_star={P_grad_max_star_NUC, P_grad_max_star_BCG, P_grad_max_star_BC, P_grad_max_star_CCP,
         P_grad_max_star_BC, P_grad_max_star_BC, P_grad_max_star_BC, P_grad_max_star_CCP,
         P_grad_max_star_GT,P_grad_max_star_GT, P_grad_max_star_OIL, P_grad_max_star_GT,
         P_grad_max_star_GAR, P_grad_max_star_BM, P_grad_max_star_PS},
  C_var={C_var_NUC, C_var_BCG, C_var_BC, C_var_CCP, C_var_BC, C_var_BC, C_var_BC, C_var_CCP,
         C_var_GT,C_var_GT, C_var_OIL, C_var_OILGT, C_var_GAR, C_var_BM, C_var_PS},
  index={"Nuclear", "Brown Coal", "CHP East", "CHP East (Combined cycle)", "CHP West, Block1",
         "CHP West, Block2", "Black Coal", "Combined Cycle Plant", "Gas Turbine 1", "Gas Turbine 2",
         "Oil fired plant", "Oil Gas Turbine", "Garbage Plant", "Biomass","Pumped Storage",
         "Pumped Storage (Pump)", "Curtailment", "Import", "Run-off water plants", "Photovoltaic", "Wind Onshore", "Wind Offshore"});

  // ==== Installed power ====
  parameter Modelica.SIunits.Power P_el_n_NUC = 300e6 "Installed capacity of nuclear plant" annotation(Dialog(group="Installed capacity, dispatchable units"));
  parameter Modelica.SIunits.Power P_el_n_BCG = 525e6 "Installed capacity brown coal" annotation(Dialog(group="Installed capacity, dispatchable units"));
  parameter Modelica.SIunits.Power P_el_n_WT = 206e6 "Installed capacity brown coal" annotation(Dialog(group="Installed capacity, dispatchable units"));
  parameter Modelica.SIunits.Power P_el_n_GUDTS = 125e6 "Installed capacity brown coal" annotation(Dialog(group="Installed capacity, dispatchable units"));
  parameter Modelica.SIunits.Power P_el_n_WW1 = 151e6 "Installed capacity brown coal" annotation(Dialog(group="Installed capacity, dispatchable units"));
  parameter Modelica.SIunits.Power P_el_n_WW2 = 138e6 "Installed capacity brown coal" annotation(Dialog(group="Installed capacity, dispatchable units"));
  parameter Modelica.SIunits.Power P_el_n_BC = 134e6 "Installed capacity black coal" annotation(Dialog(group="Installed capacity, dispatchable units"));
  parameter Modelica.SIunits.Power P_el_n_CCP = 402e6 "Installed capacity combined cycle plants" annotation(Dialog(group="Installed capacity, dispatchable units"));
  parameter Modelica.SIunits.Power P_el_n_GT1 = 71e6 "Installed capacity gas turbines" annotation(Dialog(group="Installed capacity, dispatchable units"));
  parameter Modelica.SIunits.Power P_el_n_GT2 = 71e6 "Installed capacity gas turbines" annotation(Dialog(group="Installed capacity, dispatchable units"));
  parameter Modelica.SIunits.Power P_el_n_OIL = 68e6 "Installed capacity mineral oil plants" annotation(Dialog(group="Installed capacity, dispatchable units"));
  parameter Modelica.SIunits.Power P_el_n_OILGT = 31e6 "Installed capacity mineral oil plants" annotation(Dialog(group="Installed capacity, dispatchable units"));
  parameter Modelica.SIunits.Power P_el_n_GAR = 39e6 "Installed capacity garbage plants" annotation(Dialog(group="Installed capacity, dispatchable units"));
  parameter Modelica.SIunits.Power P_el_n_PS = 154e6 "Installed capacity pumped storage" annotation(Dialog(group="Installed capacity, dispatchable units"));
  parameter Modelica.SIunits.Power P_el_n_BM = 157e6 "Installed capacity biomass" annotation(Dialog(group="Installed capacity, dispatchable units"));
  parameter Modelica.SIunits.Power P_el_n_WindOn = 747e6 "Installed capacity onshore wind" annotation(Dialog(group="Installed capacity, fluctuating sources"));
  parameter Modelica.SIunits.Power P_el_n_WindOff = 7e6 "Installed capacity offshore wind" annotation(Dialog(group="Installed capacity, fluctuating sources"));
  parameter Modelica.SIunits.Power P_el_n_PV = 798e6 "Installed capacity photovoltaic" annotation(Dialog(group="Installed capacity, fluctuating sources"));
  parameter Modelica.SIunits.Power P_el_n_ROH = 106e6 "Installed capacity runoff hydro plants" annotation(Dialog(group="Installed capacity, fluctuating sources"));

  // ==== Physical constraints ====

 // Minimum power:
  parameter Real P_min_star_NUC = 0.2 "Dimensionless minimum power gas turbines" annotation(Dialog(tab="Physical Constraints", group="Minmum Power"));
  parameter Real P_min_star_BC = 0.4 "Dimensionless minimum power black coal plants" annotation(Dialog(tab="Physical Constraints", group="Minmum Power"));
  parameter Real P_min_star_BCG = 0.3 "Dimensionless minimum power base load, i.e. brown coal, nuclear and waste incinerator plants" annotation(Dialog(tab="Physical Constraints", group="Minmum Power"));
  parameter Real P_min_star_CCP = 0.2 "Dimensionless minimum power combined cycle plants" annotation(Dialog(tab="Physical Constraints", group="Minmum Power"));
  parameter Real P_min_star_GT = 0.2 "Dimensionless minimum power gas turbines" annotation(Dialog(tab="Physical Constraints", group="Minmum Power"));
  parameter Real P_min_star_OIL = 0.2 "Dimensionless minimum power mineral oil plants" annotation(Dialog(tab="Physical Constraints", group="Minmum Power"));
  parameter Real P_min_star_GAR = 0.2 "Dimensionless minimum power garbage plants" annotation(Dialog(tab="Physical Constraints", group="Minmum Power"));
  parameter Real P_min_star_PS = 0 "Dimensionless minimum power pumped storage"
                                                                               annotation(Dialog(tab="Physical Constraints", group="Minmum Power"));
  parameter Real P_min_star_BM = 0 "Dimensionless minimum power biomass plants" annotation(Dialog(tab="Physical Constraints", group="Minmum Power"));
  parameter Real P_min_star_CHP = 1e-3 "Minium power in p.u. that should be used for plants that have time dependent minimum values (eg. chp plants)" annotation(Dialog(tab="Physical Constraints", group="Minmum Power"));

  // Maximum gradient:
  parameter Real P_grad_max_star_NUC = 0.2/60 "Dimensionless maximum power gradient gas turbines"
                                                        annotation(Dialog(tab="Physical Constraints", group="Maximum power gradient"));
  parameter Real P_grad_max_star_BCG = 0.06/60 "Dimensionless maximum power gradient base load, i.e. brown coal, nuclear and waste incinerator plants"
                                                                                              annotation(Dialog(tab="Physical Constraints", group="Maximum power gradient"));
  parameter Real P_grad_max_star_BC = 0.08/60 "Dimensionless maximum power gradient black coal"
                                                      annotation(Dialog(tab="Physical Constraints", group="Maximum power gradient"));
  parameter Real P_grad_max_star_CCP = 0.1/60 "Dimensionless maximum power gradient combined cycle plants"
                                                                 annotation(Dialog(tab="Physical Constraints", group="Maximum power gradient"));
  parameter Real P_grad_max_star_GT = 0.12/60 "Dimensionless maximum power gradient gas turbines"
                                                        annotation(Dialog(tab="Physical Constraints", group="Maximum power gradient"));
  parameter Real P_grad_max_star_OIL = 0.12/60 "Dimensionless maximum power gradient mineral oil plants"
                                                      annotation(Dialog(tab="Physical Constraints", group="Maximum power gradient"));
  parameter Real P_grad_max_star_GAR = 0.12/60 "Dimensionless maximum power gradient garbage plants"
                                                      annotation(Dialog(tab="Physical Constraints", group="Maximum power gradient"));
  parameter Real P_grad_max_star_PS = 1/60 "Dimensionless maximum power gradient pumped storage"
                                                          annotation(Dialog(tab="Physical Constraints", group="Maximum power gradient"));
  parameter Real P_grad_max_star_BM = 0.12/60 "Dimensionless maximum power gradient biomass"
                                                      annotation(Dialog(tab="Physical Constraints", group="Maximum power gradient"));
  parameter Real P_grad_max_star_ROH = 0.12/60 "Dimensionless maximum power gradient runoff hydro plants"
                                                      annotation(Dialog(tab="Physical Constraints", group="Maximum power gradient"));

  // Inertia constants:
  parameter Modelica.SIunits.Time H_gen_ST = 10 "Inertia constant typical steam turbine" annotation(Dialog(tab="Physical Constraints", group="Inertia"));
  parameter Modelica.SIunits.Time H_gen_GT = 12 "Inertia constant typical gas turbine" annotation(Dialog(tab="Physical Constraints", group="Inertia"));
  parameter Modelica.SIunits.Time H_gen_CCGT = H_gen_GT/3+2*H_gen_ST "Inertia constant typical combined cycle plant" annotation(Dialog(tab="Physical Constraints", group="Inertia"));
  parameter Modelica.SIunits.Time H_gen_HT = 12 "Hydroturbine" annotation(Dialog(tab="Physical Constraints", group="Inertia"));
  parameter Modelica.SIunits.Time H_gen_BM = 10 "Inertia constant biomass (gas motor)" annotation(Dialog(tab="Physical Constraints", group="Inertia"));
  parameter Modelica.SIunits.Time H_gen_RE = 0 "Inertia constant onshore wind" annotation(Dialog(tab="Physical Constraints", group="Inertia"));

  // Efficiencies
  parameter Modelica.SIunits.Efficiency eta_el_n_NUC = 0.35 "Mean electric efficiency nuclear plants" annotation(Dialog(tab="Other properties", group="Efficiency"));
  parameter Modelica.SIunits.Efficiency eta_el_n_BCG = 0.34 "Mean electric efficiency base load, i.e. brown coal, nuclear and waste incinerator plants" annotation(Dialog(tab="Other properties", group="Efficiency"));
  parameter Modelica.SIunits.Efficiency eta_el_n_BC = 0.4 "Mean electric efficiency black coal" annotation(Dialog(tab="Other properties", group="Efficiency"));
  parameter Modelica.SIunits.Efficiency eta_el_n_CCP = 0.52 "Mean electric efficiency combined cycle plants" annotation(Dialog(tab="Other properties", group="Efficiency"));
  parameter Modelica.SIunits.Efficiency eta_el_n_GT = 0.35 "Mean electric efficiency gas turbines" annotation(Dialog(tab="Other properties", group="Efficiency"));
  parameter Modelica.SIunits.Efficiency eta_el_n_OIL = 0.40 "Mean electric efficiency mineral oil plants" annotation(Dialog(tab="Other properties", group="Efficiency"));
  parameter Modelica.SIunits.Efficiency eta_el_n_GAR = 0.16 "Mean electric efficiency garbage plants" annotation(Dialog(tab="Other properties", group="Efficiency"));
  parameter Modelica.SIunits.Efficiency eta_el_n_PS = 0.95 "Mean electric efficiency biomass" annotation(Dialog(tab="Other properties", group="Efficiency"));
  parameter Modelica.SIunits.Efficiency eta_el_n_BM = 0.35 "Mean electric efficiency biomass" annotation(Dialog(tab="Other properties", group="Efficiency"));

  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy C_var_NUC=8/3.6e9 "Variable cost in monetary units" annotation (Dialog(tab="Other properties", group="Variable Costs for Optimization"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy C_var_BCG=12/3.6e9 "Variable Cost in monetary units,  base load, i.e. brown coal, nuclear and waste incinerator plants" annotation (Dialog(tab="Other properties", group="Variable Costs for Optimization"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy C_var_BC=12/3.6e9 "Variable Cost in monetary units,  black coal" annotation (Dialog(tab="Other properties", group="Variable Costs for Optimization"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy C_var_CCP=8.6/3.6e9 "Variable Cost in monetary units,  combined cycle plants" annotation (Dialog(tab="Other properties", group="Variable Costs for Optimization"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy C_var_GT=10/3.6e9 "Variable Cost in monetary units,  gas turbines" annotation (Dialog(tab="Other properties", group="Variable Costs for Optimization"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy C_var_OIL=10/3.6e9 "Variable Cost in monetary units,  mineral oil plants" annotation (Dialog(tab="Other properties", group="Variable Costs for Optimization"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy C_var_OILGT=10/3.6e9 "Variable Cost in monetary units,  mineral oil plants" annotation (Dialog(tab="Other properties", group="Variable Costs for Optimization"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy C_var_GAR=10/3.6e9 "Variable Cost in monetary units,  garbage plants" annotation (Dialog(tab="Other properties", group="Variable Costs for Optimization"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy C_var_PS=12/3.6e9 "Variable Cost in monetary units,  pumped storage" annotation (Dialog(tab="Other properties", group="Variable Costs for Optimization"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy C_var_BM=10/3.6e9 "Variable Cost in monetary units,  biomass" annotation (Dialog(tab="Other properties", group="Variable Costs for Optimization"));

       annotation ( defaultComponentName="GenerationPark", Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This record can be used in model that have 8 Types of electric generating units. It contains basic parameterization such as installed power, power gradients etc.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] 50HERTZ TRANSMISSION, AMPRION, TENNET TSO and TRANSNETBW. Netzentwicklungsplan Strom 2014 -Zweiter Entwurf der &Uuml;bertragungsnetzbetreiber. 2014, </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[2] 50HERTZ TRANSMISSION GMBH, AMPRION GMBH, TENNET TSO GMBH and TRANSNETBW GMBH. Netzentwicklungsplan Strom 2025, 2. Entwurf der &Uuml;bertragungsnetzbetreiber. 2016 </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[3] BUNDESMINISTERIUM and BUNDESMINISTERIUM DER JUSTIZ UND F&Uuml;R VERBRAUCHERSCHUTZ. Gesetz f&uuml;r den Ausbau erneuerbarer Energien (Erneuerbare-Energien-Gesetz-EEG 2014). 2014. </span></p>
<p>[4] L. Andresen, P. Dubucq, R. Peniche Garcia, G. Ackermann, A. Kather, and G. Schmitz, &ldquo;Transientes Verhalten gekoppelter Energienetze mit hohem Anteil Erneuerbarer Energien: Abschlussbericht des Verbundvorhabens,&rdquo; Hamburg, 2017.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on Mon Aug 18 2014</span></p>
</html>"));
end ExampleGenerationPark2012;
