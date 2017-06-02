within TransiEnt.Components.Electrical.FuelCellSystems.FuelCell;
model SOFC "Model of one SOFC-Cell Stack with three states (Ramp up, Normal operation, Ramp down)"

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  extends TransiEnt.Basics.Icons.Model;

  import TransiEnt;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

   outer SimCenter simCenter;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Integer no_Cells = 30 "Number of cells connected in series";

  parameter Real alpha = 1 "Transferkoeffizient";

  parameter Real z = 2 "Anzahl bertragener Elektronen";

  parameter Modelica.SIunits.Area A_cell = 361e-4 "Flche einer Zelle";

  parameter Modelica.SIunits.Pressure p_Anode = 1.5e5 "Druck an der Anode";

  parameter Modelica.SIunits.Pressure p_Kathode = 1e5 "Druck an der Kathode";

  parameter TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG7_var Syngas=TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG7_var() "Medium model of Syngas" annotation (choicesAllMatching);

  parameter TransiEnt.Basics.Media.Gases.Gas_MoistAir Air=TransiEnt.Basics.Media.Gases.Gas_MoistAir() "Medium model of air" annotation (choicesAllMatching);

  parameter Real hf_H2O = -285.8 * 1000 "Reaktions-/Bildungsenthalpie von Wasserdampf";

  parameter Real cp_tab[3,3] = [28.91404, -0.00084, 2.01e-6; 25.84512, 0.012987, -3.9e-6; 30.62644, 0.009621, 1.18e-6] "empirischer Parameter zur Berechnung der freien Gibbs Energie nach BARBIR";

  parameter Real ASR_0 = 0.29e-4 "Referenzwert des Verlustwiderstandes bei T_0 nach SAARINEN in Ohm m";
  parameter Modelica.SIunits.Temperature T_0 = 1073 "Referenzwert der Temperatur zur Berechnung des Verlustwiderstandes nach SAARINEN";
  parameter Real E_A = 0.65 "Aktivierungsenergie nach SAARINEN in eV";

  parameter Modelica.SIunits.Temperature T_start = 25+273.15 "Start value of stack temperature";
  parameter Modelica.SIunits.Mass m = 5 "Masse des Stacks";
  parameter Modelica.SIunits.SpecificHeatCapacity cp = 1000 "Wrmekapazitt des Stacks";
  parameter Modelica.SIunits.Temperature T_nom = 820+273.15 "Temperature in nominal point (i.e. minimum Temperature for operation)";
  parameter Modelica.SIunits.Temperature T_heater_restart = T_nom - 50 "Heater restarts at this temperature when temperature drops while operating";
  parameter Modelica.SIunits.HeatFlowRate Q_heater_nom = 3e3 "Nominal power of heater for ramp up process";
  parameter Modelica.SIunits.ThermalConductance ka = 0.5 "Thermal conductance between FC and ambient when cooling is shut off (i.e. heat loss)";
  parameter Modelica.SIunits.Temperature T_demand = 50+273.15 "Temperature of heat demand";
  parameter Modelica.SIunits.Current I_shutdown = 10 "If load controller requests currents below this value, stack will shut down";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Modelica.SIunits.Temp_K T_stack( start = T_start) "Temperatur einer Zelle";
  Modelica.SIunits.Temp_K T_syng_ein "Temperatur des Syngases";
  Modelica.SIunits.Temp_K T_air_ein "Temperatur der Luft";
  Modelica.SIunits.Temperature T_heatdemand = 60+273.15;
  Modelica.SIunits.CurrentDensity i_cell(start=0) "Zellstrom";
  Modelica.SIunits.Pressure P_O2 = air.p_i[3]/air.p "Sauerstoffpartialdruck an der Kathode";
  Modelica.SIunits.Pressure P_H2 = syng.p_i[5]/syng.p "Wasserstoffpartialdruck an der Anode";

  Modelica.SIunits.Voltage E_cell "Zellspannung";
  Modelica.SIunits.Voltage E_stack "Zellspannung";
  Real ASR = ASR_0*exp(E_A/Modelica.Constants.R * (1/T_stack - 1/T_0)) "Temperaturabhngiger Widerstand zur Berechnung der Verluste";
  Modelica.SIunits.Voltage VR "Verlust 3";
  Modelica.SIunits.Voltage Er "reversibles elektrisches Potenzial ohne die sonstigen Verluste";
  Real da= cp_tab[3,1] - cp_tab[1,1] - 0.5* cp_tab[2,1] "empirischer Parameter zur Berechnung der freien Gibbs Energie nach BARBIR";
  Real db= cp_tab[3,2] - cp_tab[1,2] - 0.5* cp_tab[2,2] "empirischer Parameter zur Berechnung der freien Gibbs Energie nach BARBIR";
  Real dc= cp_tab[3,3] - cp_tab[1,3] - 0.5* cp_tab[2,3] "empirischer Parameter zur Berechnung der freien Gibbs Energie nach BARBIR";
  Real Delta_H_T = -241.98*1000 + da*(T_stack-298.15) + db * ((T_stack^2) - 298.15^2)/2 + dc * ((T_stack^3) - 298.15^3)/3 "empirische Gleichung zur Berechnung der Bildungsenthalpie nach BARBIR";
  Real Delta_S_T = -0.0444*1000 + da*log(T_stack/298.15) + db * (T_stack - 298.15) + dc * ((T_stack^2) - 298.15^2)/2 "empirische Gleichung zur Berechnung der Entropie nach BARBIR";

  Modelica.SIunits.MolarFlowRate N_dot_e "Molenstrom an Elektronen";
  Modelica.SIunits.MassFlowRate m_dot_H2_react_stack "bentigter Massenstrom H2 einer Zelle";
  Modelica.SIunits.MassFlowRate m_dot_O2_react_stack "bentigter Massenstrom O2 einer Zelle";
  Modelica.SIunits.MassFlowRate m_dot_H2O_gen_stack "generierter Massenstrom H2O einer Zelle";
    Modelica.SIunits.MassFlowRate m_dot_air_react_stack "bentigter Luftmassenstrom einer Zelle";
  Modelica.SIunits.MolarMass M_H2 = syng.M_i[5] "Moleklmasse H2";
  Modelica.SIunits.MolarMass M_O2 = syng.M_i[2] "Moleklmasse O2";
  Modelica.SIunits.MassFraction xi_O2 "Massenanteil O2 an Luft";
  Modelica.SIunits.SpecificEnthalpy h_hein = syng.h;
  Modelica.SIunits.SpecificEnthalpy h_haus = synga.h;
  Modelica.SIunits.SpecificEnthalpy h_aein = air.h;
  Modelica.SIunits.SpecificEnthalpy h_aaus = aira.h;
  Modelica.SIunits.HeatFlowRate Q_gen "Reaction heat";
  Modelica.SIunits.HeatFlowRate Q_heater "Heat provided by heater for ramp up";
  Modelica.SIunits.HeatFlowRate Q_massflux "Total heat by mass flows";

  Modelica.SIunits.Current I;
  Modelica.SIunits.Current I_is;

  // for heating up states:
  Boolean is_T_reac_min_reached(start=false) "true, if minimum temperature for FC reaction reached";
  Boolean is_Shutdown(start=false) "true, if load current is indicating to shut the stack down";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TILMedia.Gas_pT syng(
    p=p_Anode,
    T=T_syng_ein,
    xi= inStream(feedh.xi_outflow),
    gasType = Syngas)
    annotation (extent=[-20,20; 0,40], Placement(transformation(extent={{-80,28},
            {-60,48}})));

    TILMedia.Gas_pT air(
    T=T_air_ein,
    p=p_Kathode,
    xi=inStream(feeda.xi_outflow),
    gasType = Air) "Hier wird feuchte Luft verwendet, die aus N H2O und O besteht, deshalb kann die Komponente O hieraus verwendet werden!"
    annotation (Placement(transformation(extent={{62,24},{86,54}})));

    TILMedia.Gas_pT synga(
    p=1e5,
    T=T_stack,
    xi= drainh.xi_outflow,
    gasType = Syngas)
    annotation (extent=[-20,20; 0,40], Placement(transformation(extent={{-80,-52},
            {-60,-32}})));

    TILMedia.Gas_pT aira(
    T=T_stack,
    p=1e5,
    xi=draina.xi_outflow,
    gasType = Air) "Hier wird feuchte Luft verwendet, die aus N H2O und O besteht, deshalb kann die Komponente O hieraus verwendet werden!"
    annotation (Placement(transformation(extent={{64,-58},{88,-28}})));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.IdealGasTempPortIn feedh(Medium=Syngas) annotation (Placement(transformation(extent={{-108,30},{-84,52}}), iconTransformation(extent={{-112,54},{-84,84}})));
  TransiEnt.Basics.Interfaces.Gas.IdealGasTempPortOut drainh(Medium=Syngas) annotation (Placement(transformation(extent={{88,30},{112,52}}), iconTransformation(extent={{86,52},{114,82}})));
  TransiEnt.Basics.Interfaces.Gas.IdealGasTempPortIn feeda(Medium=Air) annotation (Placement(transformation(extent={{-108,-54},{-84,-30}}), iconTransformation(extent={{-110,-70},{-82,-40}})));
  TransiEnt.Basics.Interfaces.Gas.IdealGasTempPortOut draina(Medium=Air) annotation (Placement(transformation(extent={{90,-54},{116,-30}}), iconTransformation(extent={{84,-50},{112,-20}})));

  TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp annotation (Placement(transformation(extent={{-10,48},{10,68}}), iconTransformation(extent={{-10,48},{10,68}})));

  Modelica.Blocks.Interfaces.RealInput I_load annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-50,100}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-82,-6})));
  Modelica.Blocks.Interfaces.RealOutput V_stack annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={50,100}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={102,4})));
  Modelica.Blocks.Interfaces.RealOutput lambda_H annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={70,-100}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={32,-110})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow "Useful heat" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={30,-100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-34,-108})));
  Modelica.Blocks.Interfaces.RealOutput P_el = epp.P "electrical Power" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-60,-98}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={104,-120})));
  Modelica.Blocks.Interfaces.RealOutput lambda_O annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-14,-100}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={104,-74})));
equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  // Reactions and current voltage behaviour
  Er = - ((Delta_H_T)/(z * Modelica.Constants.F)- (Delta_S_T*T_stack)/(z * Modelica.Constants.F)) + ( Modelica.Constants.R * T_stack) / (z * Modelica.Constants.F) * log( P_H2 *sqrt( P_O2)/ 1);
  VR = ASR * i_cell;
  I_is = 2*feedh.m_flow*inStream(feedh.xi_outflow[5])*Modelica.Constants.F / (M_H2*no_Cells);
  E_cell = Er - (VR);
  E_stack = E_cell * no_Cells;
  i_cell = I / A_cell;
  N_dot_e = I / Modelica.Constants.F;
  m_dot_H2_react_stack = N_dot_e / 2 * M_H2 * no_Cells;
  m_dot_O2_react_stack = N_dot_e / 4 * M_O2 * no_Cells;
  m_dot_H2O_gen_stack = m_dot_H2_react_stack + m_dot_O2_react_stack;
  xi_O2 = 1 - (air.xi[1] + air.xi[2]);
  m_dot_air_react_stack = m_dot_O2_react_stack / xi_O2;

  // electric interface
  epp.P = -1 * E_stack*I;
  epp.Q = 0;

  // Heating up model
  is_T_reac_min_reached = T_stack>T_nom or pre(is_T_reac_min_reached) and T_stack>T_heater_restart;

  // Shutting down model
  is_Shutdown = I_load <= I_shutdown;

  if is_Shutdown then
    // Load current below mimimum value = signal to shut down!
    Q_heater = 0;
    Q_flow = ka * (simCenter.T_amb_const - T_stack);
    I = 0;
    V_stack = 0;
    lambda_H = -1; // signal to lambda h controller that we are in shut down mode!
    lambda_O = 0;
  elseif not is_T_reac_min_reached then
    // below T_nom: Heater is running and no reaction nor heat offer
    Q_heater = Q_heater_nom;
    Q_flow = ka * (simCenter.T_amb_const - T_stack);
    I = 0;
    V_stack = 0;
    lambda_H = 0;  // signal to lambdah controller to give out ramp up mass flow
    lambda_O = 0;
  else
    // Normal operating point: Heater if off, Reaction is running, Reaction heat leads to positive Heatoffer (negative sign, becuase of sign convention)
    Q_heater = 0;
    Q_flow = min(0, -( Q_gen + Q_massflux + epp.P));
    I = min(I_load,I_is);
    V_stack = E_stack;
    lambda_H = (feedh.m_flow*inStream(feedh.xi_outflow[5]))/m_dot_H2_react_stack;
    lambda_O = (feeda.m_flow*(1-inStream(feeda.xi_outflow[1])+inStream(feeda.xi_outflow[1])))/m_dot_O2_react_stack;
  end if;

  // temperature design flow direction
  T_syng_ein = inStream(feedh.T_outflow);
  T_air_ein = inStream(feeda.T_outflow);
  drainh.T_outflow = synga.T;
  draina.T_outflow = aira.T;

  // contra design flow direction
  feeda.T_outflow = aira.T;
  feedh.T_outflow = aira.T;

  // energy balance
  Q_gen =  -1 * m_dot_H2O_gen_stack / syng.M_i[4] * Delta_H_T;
  Q_massflux = feedh.m_flow*h_hein + feeda.m_flow*h_aein + drainh.m_flow*h_haus + draina.m_flow*h_aaus;

  der(T_stack)*m*cp = Q_gen + Q_heater + Q_massflux + Q_flow + epp.P;

  // mass balance (total mass)
  feeda.m_flow - m_dot_O2_react_stack = - draina.m_flow;
  feedh.m_flow + m_dot_O2_react_stack = - drainh.m_flow;

  // mass fractions (design flow direction)
  -1*draina.m_flow*draina.xi_outflow[1] = feeda.m_flow*inStream(feeda.xi_outflow[1]);  //Wassermassenstrom aus Zellstapel durch eingebr. Masse und Reaktion
  -1*draina.m_flow*draina.xi_outflow[2] = feeda.m_flow*inStream(feeda.xi_outflow[2]);  //Massenstrom Sauerstoff aus dem Zellstapel
  -1*drainh.m_flow*drainh.xi_outflow[1] = feedh.m_flow*inStream(feedh.xi_outflow[1]);
  -1*drainh.m_flow*drainh.xi_outflow[2] = feedh.m_flow*inStream(feedh.xi_outflow[2]);
  -1*drainh.m_flow*drainh.xi_outflow[3] = feedh.m_flow*inStream(feedh.xi_outflow[3]);
  -1*drainh.m_flow*drainh.xi_outflow[4] = feedh.m_flow*inStream(feedh.xi_outflow[4]) + m_dot_H2O_gen_stack;
  -1*drainh.m_flow*drainh.xi_outflow[5] = feedh.m_flow*inStream(feedh.xi_outflow[5]) - m_dot_H2_react_stack;   //Massenstrom Wasserstoff aus dem Zellstapel
  -1*drainh.m_flow*drainh.xi_outflow[6] = feedh.m_flow*inStream(feedh.xi_outflow[6]);

  // mass fraction (opposite design flow direction)
  feeda.xi_outflow[1] = 0;
  feeda.xi_outflow[2] = 0;
  for i in 1:6 loop
  feedh.xi_outflow[i] = 0;
  end for;

  // impulse equation
  feedh.p = drainh.p;
  feeda.p = draina.p;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-54,44},{-34,-48}},
          lineColor={95,95,95},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{30,44},{50,-48}},
          lineColor={95,95,95},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-34,44},{-22,-48}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{18,44},{30,-48}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-22,44},{-10,-48}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{6,44},{18,-48}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,44},{6,-48}},
          lineColor={95,95,95},
          fillColor={255,0,128},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model&nbsp;of&nbsp;one&nbsp;SOFC-Cell&nbsp;Stack&nbsp;with&nbsp;three&nbsp;states&nbsp;(Ramp&nbsp;up,&nbsp;Normal&nbsp;operation,&nbsp;Ramp&nbsp;down).</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">Validation has been done as part of the master thesis [1] </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] </span>Modellierung und Simulation von erdgasbetriebenen Brennstoffzellen-Blockheizkraftwerken zur Heimenergieversorgung</p>
<p>Master thesis, Simon Weilbach (2014) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Simon Weilbach (simon.weilbach@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2015</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end SOFC;
