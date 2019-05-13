within TransiEnt.Grid.Electrical.Base;
record ExampleGenerationPark "Generation park defining one unit for each type of power plant in the Transient Library"
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
  nPlants=13,
  nDispPlants=9,
  P_max={P_el_n_NUC, P_el_n_BCG, P_el_n_BC, P_el_n_CCP, P_el_n_GT, P_el_n_OIL, P_el_n_GAR, P_el_n_PS, P_el_n_BM},
  P_min={P_min_star_NUC, P_min_star_BCG, P_min_star_BC, P_min_star_CCP, P_min_star_GT, P_min_star_OIL, P_min_star_GAR, P_min_star_PS, P_min_star_BM}.*P_max,
  P_grad_max_star={P_grad_max_star_NUC, P_grad_max_star_BCG, P_grad_max_star_BC, P_grad_max_star_CCP, P_grad_max_star_GT, P_grad_max_star_OIL, P_grad_max_star_GAR, P_grad_max_star_PS, P_grad_max_star_BM},
  C_var={C_var_NUC, C_var_BCG, C_var_BC, C_var_CCP, C_var_GT, C_var_OIL, C_var_GAR, C_var_PS, C_var_BM},
  index={"Nuclear", "Brown Coal", "Black Coal", "Combined Cycle Gas Plant", "Gasturbine", "Oil plant", "Garbage Plant", "Pumped Storage", "Biomass units", "Wind Onshore", "Wind Offshore", "Photovoltaic", "Run-off Water plants"},
  isMOD=1:nDispPlants,
  isCHP={0},
  isFRE=nDispPlants+1:nPlants);

  // ==== Installed power ====
  parameter Modelica.SIunits.Power P_el_n_NUC = 300e6 "Installed capacity of nuclear plant" annotation(Dialog(group="Installed capacity, dispatchable units"));
  parameter Modelica.SIunits.Power P_el_n_BCG = 781.6e6 "Installed capacity base load, i.e. brown coal, nuclear and waste incinerator plants" annotation(Dialog(group="Installed capacity, dispatchable units"));
  parameter Modelica.SIunits.Power P_el_n_BC = 540.1e6 "Installed capacity black coal" annotation(Dialog(group="Installed capacity, dispatchable units"));
  parameter Modelica.SIunits.Power P_el_n_CCP = 408e6 "Installed capacity combined cycle plants" annotation(Dialog(group="Installed capacity, dispatchable units"));
  parameter Modelica.SIunits.Power P_el_n_GT = 90.9e6 "Installed capacity gas turbines" annotation(Dialog(group="Installed capacity, dispatchable units"));
  parameter Modelica.SIunits.Power P_el_n_OIL = 99e6 "Installed capacity mineral oil plants" annotation(Dialog(group="Installed capacity, dispatchable units"));
  parameter Modelica.SIunits.Power P_el_n_OILGT = 31e6 "Installed capacity mineral oil plants" annotation(Dialog(group="Installed capacity, dispatchable units"));
 parameter Modelica.SIunits.Power P_el_n_GAR = 39e6 "Installed capacity garbage plants" annotation(Dialog(group="Installed capacity, dispatchable units"));
  parameter Modelica.SIunits.Power P_el_n_PS = 157.3e6 "Installed capacity pumped storage" annotation(Dialog(group="Installed capacity, dispatchable units"));
  parameter Modelica.SIunits.Power P_el_n_BM = 90.9e6 "Installed capacity biomass" annotation(Dialog(group="Installed capacity, dispatchable units"));

  parameter Modelica.SIunits.Power P_el_n_WindOn = 758.9e6 "Installed capacity onshore wind" annotation(Dialog(group="Installed capacity, fluctuating sources"));
  parameter Modelica.SIunits.Power P_el_n_WindOff = 6.88e6 "Installed capacity offshore wind" annotation(Dialog(group="Installed capacity, fluctuating sources"));
  parameter Modelica.SIunits.Power P_el_n_PV = 734.9e6 "Installed capacity photovoltaic" annotation(Dialog(group="Installed capacity, fluctuating sources"));
  parameter Modelica.SIunits.Power P_el_n_ROH = 90.9e6 "Installed capacity runoff hydro plants" annotation(Dialog(group="Installed capacity, fluctuating sources"));

  // ==== Physical constraints ====

 // Minimum power:
  parameter Real P_min_star_NUC = 0.2 "Dimensionless minimum power gas turbines" annotation(Dialog(tab="Physical Constraints", group="Minmum Power"));
  parameter Real P_min_star_GT = 0.2 "Dimensionless minimum power gas turbines" annotation(Dialog(tab="Physical Constraints", group="Minmum Power"));
  parameter Real P_min_star_CCP = 0.2 "Dimensionless minimum power combined cycle plants"
                                                        annotation(Dialog(tab="Physical Constraints", group="Minmum Power"));
  parameter Real P_min_star_BC = 0.3 "Dimensionless minimum power black coal" annotation(Dialog(tab="Physical Constraints", group="Minmum Power"));
  parameter Real P_min_star_BCG = 0.4 "Dimensionless minimum power base load, i.e. brown coal, nuclear and waste incinerator plants"
                                                                                              annotation(Dialog(tab="Physical Constraints", group="Minmum Power"));

  parameter Real P_min_star_PS = 0 "Dimensionless minimum power pumped storage"
                                                 annotation(Dialog(tab="Physical Constraints", group="Minmum Power"));
  parameter Real P_min_star_BM = 0.2 "Dimensionless minimum power biomass" annotation(Dialog(tab="Physical Constraints", group="Minmum Power"));

  parameter Real P_min_star_ROH = 0 "Dimensionless minimum power runoff hydro plants" annotation(Dialog(tab="Physical Constraints", group="Minmum Power"));
  parameter Real P_min_star_OIL = 0.2 "Dimensionless minimum power mineral oil plants" annotation(Dialog(tab="Physical Constraints", group="Minmum Power"));
  parameter Real P_min_star_GAR = 0.2 "Dimensionless minimum power garbage plants" annotation(Dialog(tab="Physical Constraints", group="Minmum Power"));

  // Maximum gradient:
  parameter Real P_grad_max_star_NUC = 0.2/60 "Dimensionless maximum power gradient gas turbines"
                                                        annotation(Dialog(tab="Physical Constraints", group="Maximum power gradient"));

  parameter Real P_grad_max_star_GT = 0.12/60 "Dimensionless maximum power gradient gas turbines"
                                                        annotation(Dialog(tab="Physical Constraints", group="Maximum power gradient"));
  parameter Real P_grad_max_star_CCP = 0.1/60 "Dimensionless maximum power gradient combined cycle plants"
                                                                 annotation(Dialog(tab="Physical Constraints", group="Maximum power gradient"));
  parameter Real P_grad_max_star_BC = 0.08/60 "Dimensionless maximum power gradient black coal"
                                                      annotation(Dialog(tab="Physical Constraints", group="Maximum power gradient"));
  parameter Real P_grad_max_star_BCG = 0.06/60 "Dimensionless maximum power gradient base load, i.e. brown coal, nuclear and waste incinerator plants"
                                                                                              annotation(Dialog(tab="Physical Constraints", group="Maximum power gradient"));
  parameter Real P_grad_max_star_PS = 1/60 "Dimensionless maximum power gradient pumped storage"
                                                          annotation(Dialog(tab="Physical Constraints", group="Maximum power gradient"));
  parameter Real P_grad_max_star_ROH = 0.12/60 "Dimensionless maximum power gradient runoff hydro plants"
                                                      annotation(Dialog(tab="Physical Constraints", group="Maximum power gradient"));
  parameter Real P_grad_max_star_BM = 0.12/60 "Dimensionless maximum power gradient biomass"
                                                      annotation(Dialog(tab="Physical Constraints", group="Maximum power gradient"));
  parameter Real P_grad_max_star_OIL = 0.12/60 "Dimensionless maximum power gradient mineral oil plants"
                                                      annotation(Dialog(tab="Physical Constraints", group="Maximum power gradient"));
  parameter Real P_grad_max_star_GAR = 0.12/60 "Dimensionless maximum power gradient garbage plants"
                                                      annotation(Dialog(tab="Physical Constraints", group="Maximum power gradient"));

  // Inertia constants:
  parameter Modelica.SIunits.Time H_gen_ST = 10 "Inertia constant typical steam turbine" annotation(Dialog(tab="Physical Constraints", group="Inertia"));
  parameter Modelica.SIunits.Time H_gen_GT = 12 "Inertia constant typical gas turbine" annotation(Dialog(tab="Physical Constraints", group="Inertia"));
  parameter Modelica.SIunits.Time H_gen_CCGT = H_gen_GT/3+2*H_gen_ST "Inertia constant typical combined cycle plant" annotation(Dialog(tab="Physical Constraints", group="Inertia"));
  parameter Modelica.SIunits.Time H_gen_HT = 12 "Hydroturbine" annotation(Dialog(tab="Physical Constraints", group="Inertia"));
  parameter Modelica.SIunits.Time H_gen_BM = 10 "Inertia constant biomass (gas motor)" annotation(Dialog(tab="Physical Constraints", group="Inertia"));
  parameter Modelica.SIunits.Time H_gen_RE = 0 "Inertia constant onshore wind" annotation(Dialog(tab="Physical Constraints", group="Inertia"));
  parameter Modelica.SIunits.Time H_gen_CCP = 0;
  parameter Modelica.SIunits.Time H_gen_BC = 0;
  parameter Modelica.SIunits.Time H_gen_BCG = 0;
  parameter Modelica.SIunits.Time H_gen_PS = 0;
  parameter Modelica.SIunits.Time H_gen_WindOn = 0;
  parameter Modelica.SIunits.Time H_gen_WindOff = 0;
  parameter Modelica.SIunits.Time H_gen_PV = 0;
  parameter Modelica.SIunits.Time H_gen_ROH = 0;

  // Efficiencies
  parameter Modelica.SIunits.Efficiency eta_el_n_NUC = 0.35 "Mean electric efficiency nuclear plants" annotation(Dialog(tab="Other properties", group="Efficiency"));

  parameter Modelica.SIunits.Efficiency eta_el_n_GT = 0.35 "Mean electric efficiency gas turbines" annotation(Dialog(tab="Other properties", group="Efficiency"));
  parameter Modelica.SIunits.Efficiency eta_el_n_CCP = 0.52 "Mean electric efficiency combined cycle plants" annotation(Dialog(tab="Other properties", group="Efficiency"));
  parameter Modelica.SIunits.Efficiency eta_el_n_BC = 0.4 "Mean electric efficiency black coal" annotation(Dialog(tab="Other properties", group="Efficiency"));
  parameter Modelica.SIunits.Efficiency eta_el_n_BCG = 0.34 "Mean electric efficiency base load, i.e. brown coal, nuclear and waste incinerator plants" annotation(Dialog(tab="Other properties", group="Efficiency"));
  parameter Modelica.SIunits.Efficiency eta_el_n_BM = 0.35 "Mean electric efficiency biomass" annotation(Dialog(tab="Other properties", group="Efficiency"));
  parameter SI.Efficiency eta_el_n_OIL = 0.40 "Mean electric efficiency mineral oil plants" annotation(Dialog(tab="Other properties", group="Efficiency"));
  parameter SI.Efficiency eta_el_n_GAR = 0.16 "Mean electric efficiency garbage plants" annotation(Dialog(tab="Other properties", group="Efficiency"));

  parameter Real C_var_NUC = 8 "Variable cost in arbitrary units" annotation(Dialog(tab="Other properties", group="Variable Costs for Optimization"));

  parameter Real C_var_GT = 10 "Variable Cost in arbitrary units,  gas turbines" annotation(Dialog(tab="Other properties", group="Variable Costs for Optimization"));
  parameter Real C_var_CCP = 8.6 "Variable Cost in arbitrary units,  combined cycle plants" annotation(Dialog(tab="Other properties", group="Variable Costs for Optimization"));
  parameter Real C_var_BC = 12 "Variable Cost in arbitrary units,  black coal" annotation(Dialog(tab="Other properties", group="Variable Costs for Optimization"));
  parameter Real C_var_BCG = 12 "Variable Cost in arbitrary units,  base load, i.e. brown coal, nuclear and waste incinerator plants"
                                                                                       annotation(Dialog(tab="Other properties", group="Variable Costs for Optimization"));
  parameter Real C_var_PS = 12 "Variable Cost in arbitrary units,  pumped storage" annotation(Dialog(tab="Other properties", group="Variable Costs for Optimization"));
  parameter Real C_var_WindOn = 0 "Variable Cost in arbitrary units,  onshore wind" annotation(Dialog(tab="Other properties", group="Variable Costs for Optimization"));
  parameter Real C_var_WindOff = 0 "Variable Cost in arbitrary units,  offshore wind" annotation(Dialog(tab="Other properties", group="Variable Costs for Optimization"));
  parameter Real C_var_PV = 0 "Variable Cost in arbitrary units,  photovoltaic" annotation(Dialog(tab="Other properties", group="Variable Costs for Optimization"));
  parameter Real C_var_BM = 10 "Variable Cost in arbitrary units,  biomass" annotation(Dialog(tab="Other properties", group="Variable Costs for Optimization"));
  parameter Real C_var_ROH = 10 "Variable Cost in arbitrary units,  runoff hydro plants" annotation(Dialog(tab="Other properties", group="Variable Costs for Optimization"));
  parameter Real C_var_OIL = 10 "Variable Cost in arbitrary units,  mineral oil plants" annotation(Dialog(tab="Other properties", group="Variable Costs for Optimization"));
  parameter Real C_var_GAR = 10 "Variable Cost in arbitrary units,  garbage plants" annotation(Dialog(tab="Other properties", group="Variable Costs for Optimization"));

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
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on Mon Aug 18 2014</span></p>
</html>"));
end ExampleGenerationPark;
