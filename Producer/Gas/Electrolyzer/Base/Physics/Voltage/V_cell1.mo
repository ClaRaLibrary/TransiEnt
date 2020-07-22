within TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Voltage;
model V_cell1 "PEM cell voltage as modeled by Espinosa, 2018"
  //The following must all be calculated in the Voltage model.
  // V_el_stack, V_cell, V_tn
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

  extends TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Voltage.PartialV_cell;

  import SI = Modelica.SIunits;
  import math = Modelica.Math;
  import const = Modelica.Constants;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  outer parameter Integer whichInput "input selector";

  parameter SI.Voltage V_std=1.23 "std reverse voltage of electrolysis of water";
  outer parameter SI.Temperature T_std "STD temperature";
  parameter Real humidity_const=14 "constant humidity";

  //Electrolyzer system specific parameters
  outer parameter SI.Energy E_exc "Activation energy for anode reaction, Espinosa 2018";
  outer parameter SI.ChemicalPotential E_pro "Temperature independent parameter for activation energy in proton transport, Espinosa 2018";
  outer parameter SI.CurrentDensity i_dens_0_an_std "A/m2, Exchange current density at Pt electrodes at T_std, Espinosa 2018";
  outer parameter SI.Thickness t_mem "PE membrane thickness - ref. Nafion 117";
  outer parameter SI.Conductivity mem_conductivity_ref "S/m, Membrane conductivity reference value at T_std,Espinosa 2018; typically [0.058,0.096]S/cm, 283(Agbli 2011)";
  outer parameter Real alpha_an "charge transfer coefficient for anode, as Espinosa 2018 uses";

  parameter Real z=2 "Stoichiometric coefficient for transferred electrons; = 2 for electrolysis";
  parameter Real PaToAtm=1/101325 "conversion factor for partial pressures";

  // _____________________________________________
  //
  //              Variables
  // _____________________________________________

  //Voltage and Overpotential Variables
public
  MembraneResistance R_mem "Resistance of PE membrane to ionic flow";
  inner SI.Voltage V_rev "Voltage from Gibb's free energy incl. pressure and temp";
  SI.Voltage V_nernst "Nernst potential of Water electrolysis";
  SI.Voltage V_activation "Electrode overpotential contribution";
  SI.Voltage V_act_an "anode overpotential contribution";
  SI.Voltage V_act_cat "cathode overpotential contribution";
  SI.Voltage V_ohmic "Ohmic overpotential contribution";
  inner SI.Voltage V_conc "Concentration/diffusion overpotential contribution";

  //Temperature
  outer SI.Temperature T_op "Operating stack temperature";

  //Electrode/Activation Overpotential
  SI.CurrentDensity i_dens_0_an "exchange current density at anode (i_0c can be neglected, small)";
  outer SI.CurrentDensity i_dens_a "Operating current density at anode, may also be needed for cathode";

  //Ohmic Overpotential
  inner SI.Conductivity mem_conductivity "Conductivity of the PE membrane";

  //Pressure
  outer SI.Pressure pp_H2O "Pa, vapour pressure of water vapour";
  outer SI.Pressure pp_H2 "Pa, partial pressure of H2";
  outer SI.Pressure pp_O2 "Pa, partial pressure of O2,";
  outer SI.Pressure p_cat "cathode pressure";

  replaceable model PEMconductivity = TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Voltage.ConductivityModels.PEMconductivity1 constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Voltage.ConductivityModels.PartialPEMConductivity
                                                                                                                                                                                                        "conductivity of PEM" annotation (
    Dialog(group="Fundamental Definitions"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-30,-10},{-10,10}})));
  replaceable model V_thermoneutral = TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Voltage.ThermoneutralVoltageModels.V_tn1 constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Voltage.ThermoneutralVoltageModels.PartialThermoneutralVoltageModel
                                                                                                                                                                                                        "thermoneutral voltage of electrolysis" annotation (
    Dialog(group="Fundamental Definitions"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-30,-10},{-10,10}})));
  replaceable model V_reversible = TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Voltage.ReversibleVoltageModels.V_rev1 constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Voltage.ReversibleVoltageModels.PartialReversibleModel
                                                                                                                                                                                                        "reversible voltage of cell" annotation (
    Dialog(group="Fundamental Definitions"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-30,-10},{-10,10}})));
  replaceable model V_concentration = TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Voltage.ConcentrationVoltageModels.V_conc1 constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Voltage.ConcentrationVoltageModels.PartialConcentrationModel
                                                                                                                                                                                                        "conductivity of PEM" annotation (
    Dialog(group="Fundamental Definitions"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-30,-10},{-10,10}})));
  V_concentration concVoltageModel;
  PEMconductivity membraneModel;
  V_thermoneutral thermoneutralVoltageModel;
  V_reversible reverseVoltageModel;

equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //Nernst contribution
  V_nernst = const.R*T_op*(log(pp_H2*PaToAtm*((pp_O2*PaToAtm)^0.5)/(pp_H2O*PaToAtm)))/(2*const.F); //all pressures must  be converted  to atm
  //     V_nernst=const.R*T_op*(log((pp_H2*((pp_O2)^0.5)/(pp_H2O))))/(2*const.F); //all pressures must  be converted  to atm

  // Activation Overvoltage
  i_dens_0_an = i_dens_0_an_std*exp(-(E_exc/const.R)*(1/T_op - 1/T_std));
  V_act_an = const.R*T_op*math.asinh(i_dens_a/(2*i_dens_0_an))/(alpha_an*z*const.F);
  V_act_cat = 0;
  V_activation = V_act_an + V_act_cat;

  //Ohmic Overpotential
  R_mem = t_mem/mem_conductivity;
  V_ohmic = R_mem*i_dens_a;

  //Overall cell voltage
  if not i_dens_a == 0 then
    V_cell = V_rev + V_nernst + V_activation + V_ohmic + V_conc;
  else
    V_cell = 0;
  end if;

  annotation (
    defaultConnectionStructurallyInconsistent=true,
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This is a model for electrolyzer dynamics with varying voltage dependent on pressure, current density, and temperature. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Voltage is modeled according to Espinosa-L&oacute;pez et al 2018 based on pressure, temperature, and current. Contains overvoltage components from Nernst potential, activation, and ohmic overpotentials.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Original model developed and validated in the range of 20-60 &deg;C with operating pressure of 15-35 bar. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Consist of voltage equations from Espinosa-L&oacute;pez et al 2018 by default. Can modify membrane conductivity, reverse voltage, concentration overvoltage, and thermoneutral expresssions if desired.</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Results have been validated against Espinosa-L&oacute;pez et al 2018 published figures. </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>Z. Abdin, E. MacA. Gray, and C.J. Webb. Modelling and simulation of a proton exchange membrane (PEM) electrolyzer cell. <i>International Journal of Hydrogen Energy</i>, 40(39):13243-13257, 2015. doi:<a href=\"https://www.sciencedirect.com/science/article/pii/S0360319915019321\">10.1016/j.ijhydene.2015.07.129</a>. </p>
<p>Manuel Espinosa-L&oacute;pez, Philippe Baucour, Serge Besse, Christophe Darras, Raynal Glises, Philippe Poggi, Andr&eacute; Rakotondrainibe, and Pierre Serre-Combe. Modelling and experimental validation of a 46 kW PEM high pressure water electrolyser. <i>Renewable Energy, </i>119, pp. 160-173, 2018. doi: <a href=\"https://doi.org/10.1016/J.RENENE.2017.11.081\">10.1016/J.RENENE.2017.11.081</a>. </p>
<p>R. Garc&iacute;a-Valverde, N. Espinosa, and A. Urbina. Simple PEM water electrolyzer model and experimental validation. <i>International Journal of Hydrogen Energy</i>, 37(2):1927-1938, 2012. doi:<a href=\"https://doi.org/10.1016/j.ijhydene.2011.09.027\">10.1016/j.ijhydene.2011.09.027</a>. </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by John Webster (jcwebste@edu.uwaterloo.ca) October 2018.</p>
</html>"));
end V_cell1;
