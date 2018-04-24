within TransiEnt.Examples.Hamburg;
record ExampleGenerationPark2035 "Example Generation Park for the year of 2035 (loosely based on german network development plan 2015)"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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
  extends ExampleGenerationPark2012(
  nPlants=20,
  nDispPlants=13,
  P_max={P_el_n_BCG, P_el_n_WT, P_el_n_GUDTS, P_el_n_WW1, P_el_n_BC, P_el_n_CCP,
  P_el_n_GT1,P_el_n_GT2,P_el_n_GT3, P_el_n_OIL, P_el_n_GAR, P_el_n_BM, P_el_n_PS},
  P_min={P_min_star_BCG, P_min_star_CHP, P_min_star_CCP, P_min_star_CHP, P_min_star_BC,P_min_star_CCP,
         P_min_star_GT,P_min_star_GT,P_min_star_GT, P_min_star_OIL, P_min_star_GAR, P_min_star_BM, P_min_star_PS}.*P_max,
  P_grad_max_star={P_grad_max_star_BCG, P_grad_max_star_BC, P_grad_max_star_CCP,P_grad_max_star_CCP,
         P_grad_max_star_BC, P_grad_max_star_CCP, P_grad_max_star_GT,P_grad_max_star_GT,P_grad_max_star_GT,
  P_grad_max_star_OIL, P_grad_max_star_GAR, P_grad_max_star_BM,P_grad_max_star_PS},
  C_var={C_var_BCG, C_var_BC, C_var_CCP,C_var_CCP,
         C_var_BC, C_var_CCP, C_var_GT,C_var_GT,C_var_GT,
  C_var_OIL, C_var_GAR, C_var_BM,C_var_PS},
  index={"BK", "WT", "GuDTS", "WW1", "SKEL", "GuD", "GT1", "GT2", "GT3", "OIL", "GAR", "BM", "PS_T", "PS_P", "Curtailment", "Import", "ROW", "PV", "Onshore", "Offshore"},
  P_el_n_BCG = 191e6,P_el_n_WT = 206e6,P_el_n_GUDTS = 125e6, P_el_n_WW1 = 470e6, P_el_n_BC = 24e6, P_el_n_CCP = 77e6, P_el_n_GT1 = 60e6, P_el_n_GT2 = 60e6,
  P_el_n_OIL = 17e6, P_el_n_GAR = 33e6, P_el_n_PS = 260e6,
  P_el_n_BM = 196e6, P_el_n_WindOn = 1816e6, P_el_n_WindOff = 378e6, P_el_n_PV = 1225e6,
  P_el_n_ROH = 86e6,
  nMODPlants=11,
  isMOD=1:11,
  isCHP={2,4},
  isFRE=nDispPlants+1:nPlants);

  parameter Modelica.SIunits.Power P_el_n_GT3 = 70e6 "Installed capacity gas turbines" annotation(Dialog(group="Installed capacity, dispatchable units"));

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
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarsk for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on Mon Aug 18 2014</span></p>
</html>"));
end ExampleGenerationPark2035;
