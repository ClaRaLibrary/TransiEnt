within TransiEnt.Components.Electrical.FuelCellSystems.FuelCell;
model PEM "Model of PEM-Cell stack"


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
  extends TransiEnt.Basics.Icons.Model;
  import TransiEnt;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

   outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Integer no_Cells = 30 "Number of cells connected in series";

  parameter Modelica.Units.SI.CurrentDensity i_0=0.000006 "Reactive current (empiric)";

  parameter Modelica.Units.SI.CurrentDensity i_L=6 "Limiting current";

  parameter Modelica.Units.SI.CurrentDensity i_Loss=6 "Leakage current";

  parameter Real Ri = 0.15e-4 "Internal resistance according to Barbir in Ohm";

  parameter Real alpha = 1 "Transfer coefficient";

  parameter Real z = 2 "Quantity of transfered electrons";

  parameter Modelica.Units.SI.Area A_cell=361e-4 "Area of one cell";

  parameter Modelica.Units.SI.Pressure p_Anode=150000 "Pressure at the anode";

  parameter Modelica.Units.SI.Pressure p_Kathode=100000 "Pressure at the cathode";

  parameter TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG7_var Syngas=TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG7_var() "Medium model of Syngas" annotation (choicesAllMatching);

  parameter TransiEnt.Basics.Media.Gases.Gas_MoistAir Air=TransiEnt.Basics.Media.Gases.Gas_MoistAir() "Medium model of air" annotation (choicesAllMatching);

  parameter Real cp_tab[3,3] = [28.91404, -0.00084, 2.01e-6; 25.84512, 0.012987, -3.9e-6; 30.62644, 0.009621, 1.18e-6] "Empiric parameter for calculating the Gibbs free energy according to Barbir";

  parameter Modelica.Units.SI.Current I_shutdown=10 "If load controller requests currents below this value, stack will shut down";

  parameter Modelica.Units.SI.Mass m=5 "Mass of the stack";

  parameter Modelica.Units.SI.SpecificHeatCapacity cp=1000 "Specific heat capacity of the stack";

  parameter Real eta_Q = 0.7 "Efficiency of the heat transfer";

  parameter Modelica.Units.SI.Temperature T_nom=820 + 273.15 "Temperature in nominal point (i.e. minimum temperature for heat)";

  parameter Modelica.Units.SI.ThermalConductance ka=0.5 "Thermal conductance of the wall";

  parameter SI.Voltage v_n=simCenter.v_n "Nominal Voltage for grid";

  parameter Boolean usePowerPort=true "True if power port shall be used" annotation (Dialog(group="Replaceable Components"));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Modelica.Units.SI.Temperature T_cell=T_stack "Temperature of one cell";
  Modelica.Units.SI.Temperature T_stack(start=25 + 273.15) "Temperature of the stack" annotation (Dialog(group="Initialization", showStartAttribute=true));
  Modelica.Units.SI.Temperature T_syng_ein "Temperature of the syngas";
  Modelica.Units.SI.Temperature T_air_ein "Temperature of the air";
//   Modelica.SIunits.Temperature T_heatdemand = 60+273.15;
  Modelica.Units.SI.CurrentDensity i_cell "Current in one cell";
  // Real Ri = -1.667e-4*T_cell + 0.2289 "Internal resistance in Ohm";
  Modelica.Units.SI.Pressure P_O2=air.p_i[3]/air.p "Partial pressure of oxygen at the cathode";
  Modelica.Units.SI.Pressure P_H2=syng.p_i[5]/syng.p "Partial pressure of hydrogen at the anode";

  Modelica.Units.SI.Voltage E_cell "Voltage of one cell";
  Modelica.Units.SI.Voltage E_stack "Voltage of the stack";
  Modelica.Units.SI.Voltage V1 "Voltage loss 1";
  Modelica.Units.SI.Voltage V2 "Voltage loss 2";
  Modelica.Units.SI.Voltage V3 "Voltage loss 3";
  Modelica.Units.SI.Voltage Er "Reversible electric potential without the other losses";
  Real da= cp_tab[3,1] - cp_tab[1,1] - 0.5* cp_tab[2,1] "Empiric parameter for calculating Gibbs free energy according to Barbir";
  Real db= cp_tab[3,2] - cp_tab[1,2] - 0.5* cp_tab[2,2] "Empiric parameter for calculating Gibbs free energy according to Barbir";
  Real dc= cp_tab[3,3] - cp_tab[1,3] - 0.5* cp_tab[2,3] "Empiric parameter for calculating Gibbs free energy according to Barbir";
  Real Delta_H_T = -241.98*1000 + da*(T_cell-298.15) + db * ((T_cell^2) - 298.15^2)/2 + dc * ((T_cell^3) - 298.15^3)/3 "Empiric equation for calculating the enthalpy of formation according to Barbir";
  Real Delta_S_T = -0.0444*1000 + da*log(T_cell/298.15) + db * (T_cell - 298.15) + dc * ((T_cell^2) - 298.15^2)/2 "Empiric equation for calculating the entropy according to Barbir";

  Modelica.Units.SI.MolarFlowRate N_dot_e "Molar flow rate of the electrons";
  //   Modelica.SIunits.Current I "Electric current of the stack/ electric current of one cell";
  Modelica.Units.SI.MassFlowRate m_dot_H2_react_stack "Required H2 mass flow rate of one cell";
  Modelica.Units.SI.MassFlowRate m_dot_O2_react_stack "Required O2 mass flow rate of one cell";
  Modelica.Units.SI.MassFlowRate m_dot_H2O_gen_stack "Generated H2O mass flow rate of one cell";
  Modelica.Units.SI.MassFlowRate m_dot_air_react_stack "Required air mass flow rate of one cell";
  //Modelica.SIunits.MassFlowRate m_dot_H2_in_stack "Wasserstoffmassenstrom in das Stack";
  Modelica.Units.SI.MolarMass M_H2=syng.M_i[5] "Molar mass H2";
  Modelica.Units.SI.MolarMass M_O2=syng.M_i[2] "Molar mass O2";
  //   Modelica.SIunits.MolarMass M_air = air.M "Molar mass air";
 // Real lambda_H "Stoichiometric ratio";
//   Real lambda_O "Stoichiometric ratio";
  Modelica.Units.SI.MassFraction xi_O2 "Mass fraction of O2 in the air";
  Modelica.Units.SI.SpecificEnthalpy h_hein=syng.h;
  Modelica.Units.SI.SpecificEnthalpy h_haus=synga.h;
  Modelica.Units.SI.SpecificEnthalpy h_aein=air.h;
  Modelica.Units.SI.SpecificEnthalpy h_aaus=aira.h;
  SI.HeatFlowRate Q_flow_reac "Heat flow due to reaction";
//   Modelica.SIunits.HeatFlowRate Q_heater "Reaction heat";
  SI.HeatFlowRate Q_flow_gas "Heat flow to/from syngas and air";

  Modelica.Units.SI.Current I;
  Modelica.Units.SI.Current I_is;

  // for heating up states:
  Boolean is_T_reac_min_reached(start=false) "true, if minimum temperature for FC reaction reached";
  Boolean is_Shutdown(start=false) "true, if load current is indicating to shut the stack down";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.IdealGasTempPortIn feedh(Medium=Syngas) annotation (Placement(transformation(extent={{-110,30},{-90,50}}), iconTransformation(extent={{-114,46},{-86,74}})));
  TransiEnt.Basics.Interfaces.Gas.IdealGasTempPortOut drainh(Medium=Syngas) annotation (Placement(transformation(extent={{90,30},{110,50}}), iconTransformation(extent={{86,46},{114,74}})));
  TransiEnt.Basics.Interfaces.Gas.IdealGasTempPortIn feeda(Medium=Air) annotation (Placement(transformation(extent={{-106,-66},{-86,-46}}), iconTransformation(extent={{-114,-74},{-86,-46}})));
  TransiEnt.Basics.Interfaces.Gas.IdealGasTempPortOut draina(Medium=Air) annotation (Placement(transformation(extent={{90,-50},{110,-30}}), iconTransformation(extent={{86,-74},{114,-46}})));

  replaceable TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp if usePowerPort constrainedby TransiEnt.Basics.Interfaces.Electrical.PartialPowerPort "Choice of power port" annotation (Dialog(group="Replaceable Components"),choicesAllMatching=true, Placement(transformation(extent={{-10,48},{10,68}}), iconTransformation(extent={{-10,48},{10,68}})));

  TransiEnt.Basics.Interfaces.Electrical.ElectricCurrentIn I_load "Input for loading current" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-50,100}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-82,-6})));
  TransiEnt.Basics.Interfaces.Electrical.VoltageOut V_stack "Output for Voltage of a stack"  annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={50,100}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={100,0})));
  TransiEnt.Basics.Interfaces.General.MassFractionOut lambda_H "Output for excess ratio of hydrogen" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={70,-100}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={100,-80})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_use "Useful heat flow rate" annotation (Placement(transformation(        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={30,-100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={100,-120})));

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_el = -1 * V_stack*I annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-6,-100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,-100})));
  TransiEnt.Basics.Interfaces.General.MassFractionOut lambda_O "Output for excess ratio of oxygen" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-56,-102}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,-100})));
    // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TILMedia.Gas_pT syng(
    p=p_Anode,
    T=T_syng_ein,
    xi= inStream(feedh.xi_outflow),
    gasType = Syngas)
    annotation (Placement(transformation(extent={{-80,28},
            {-60,48}})));

    TILMedia.Gas_pT air(
    T=T_air_ein,
    p=p_Kathode,
    xi=inStream(feeda.xi_outflow),
    gasType = Air) "Moist air is used which consists of N2, H2O and O2. This is why the component O2 can be used from it!"
    annotation (Placement(transformation(extent={{62,24},{86,54}})));

    TILMedia.Gas_pT synga(
    p=1e5,
    T=T_cell,
    xi= drainh.xi_outflow,
    gasType = Syngas)
    annotation (Placement(transformation(extent={{-80,-52},
            {-60,-32}})));

    TILMedia.Gas_pT aira(
    T=T_cell,
    p=1e5,
    xi=draina.xi_outflow,
    gasType = Air) "Moist air is used which consists of N2, H2O and O2. This is why the component O2 can be used from it!"
    annotation (Placement(transformation(extent={{64,-58},{88,-28}})));

  replaceable TransiEnt.Components.Boundaries.Electrical.ActivePower.Power powerBoundary if
                                                                                  usePowerPort constrainedby TransiEnt.Components.Boundaries.Electrical.Base.PartialModelPowerBoundary "Choice of power boundary model. The power boundary model must match the power port." annotation (
    Dialog(group="Replaceable Components"),
    choices(
      choice(redeclare TransiEnt.Components.Boundaries.Electrical.ActivePower.Power powerBoundary "P-Boundary for ActivePowerPort"),
      choice(redeclare TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower powerBoundary(
          useInputConnectorP=true,
          useInputConnectorQ=false,
          useCosPhi=true,
          cosphi_boundary=1) "PQ-Boundary for ApparentPowerPort"),
      choice(redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower powerBoundary(useInputConnectorQ=false, cosphi_boundary=1) "PQ-Boundary for ComplexPowerPort"),
      choice(redeclare TransiEnt.Components.Boundaries.Electrical.ApparentPower.PowerVoltage powerBoundary(Use_input_connector_v=false, v_boundary=PEM.v_n) "PV-Boundary for ApparentPowerPort"),
      choice(redeclare TransiEnt.Components.Electrical.QuasiStationaryComponentsBusses.PUMachine powerBoundary(v_gen=PEM.v_n, useInputConnectorP=true) "PV-Boundary for ComplexPowerPort")),
    Placement(transformation(extent={{-22,18},{-42,38}})));
    Modelica.Blocks.Sources.RealExpression realExpression(y=P_el) if usePowerPort annotation (Placement(transformation(extent={{-62,54},{-42,74}})));


equation
  // _____________________________________________
  //
  //           Characteristic equations
  // _____________________________________________

  // Reactions and current voltage behaviour
  Er = - ((Delta_H_T)/(z * Modelica.Constants.F)- (Delta_S_T*T_cell)/(z * Modelica.Constants.F)) + ( Modelica.Constants.R * T_cell) / (z * Modelica.Constants.F) * log( P_H2 *sqrt( P_O2)/ 1);
  V1 = ( Modelica.Constants.R * T_cell) / (alpha * Modelica.Constants.F) * log(( i_cell +  i_Loss)/ i_0);
  V2 = ( Modelica.Constants.R * T_cell) / (z * Modelica.Constants.F) * log( i_L / (i_L - i_cell));
  V3 = Ri * i_cell;
  E_cell = Er - ( V1 + V2 + V3);
  I_is = 2*feedh.m_flow*inStream(feedh.xi_outflow[5])*Modelica.Constants.F / (M_H2*no_Cells);
  E_stack = E_cell * no_Cells;
  i_cell = I / A_cell;
  N_dot_e = I / Modelica.Constants.F;
//  m_dot_H2_react_stack = max(0.01, N_dot_e / 2 * M_H2 * no_Cells);
  // m_dot_O2_react_stack = max(0.01, N_dot_e / 4 * M_O2 * no_Cells);
  m_dot_H2_react_stack =  N_dot_e / 2 * M_H2 * no_Cells;
  m_dot_O2_react_stack =  N_dot_e / 4 * M_O2 * no_Cells;
  m_dot_H2O_gen_stack = N_dot_e / 2 * syng.M_i[4] * no_Cells;
  xi_O2 = 1 - (air.xi[1] + air.xi[2]);
  m_dot_air_react_stack = m_dot_O2_react_stack / xi_O2;

  // Heating up model
  is_T_reac_min_reached = T_stack>T_nom; // or pre(is_T_reac_min_reached)
  // Shutting down model
  is_Shutdown = I_load <= I_shutdown;

  if is_Shutdown then
    // Load current below mimimum value = signal to shut down!
    Q_flow_use = ka*(simCenter.T_amb_const - T_stack);
    I = 0;
    V_stack = 0;
    lambda_H = -1; // signal to lambda h controller that we are in shut down mode!
    lambda_O = 0;
  elseif not is_T_reac_min_reached then
    // below T_nom: Heater is running and no reaction nor heat offer
    Q_flow_use = ka*(simCenter.T_amb_const - T_stack);
    I = min(I_load,I_is);
    V_stack = 0;
    lambda_H = 0;  // signal to lambdah controller to give out ramp up mass flow
    lambda_O = 0;
  else
    // Normal operating point: Heater if off, Reaction is running, Reaction heat leads to positive Heatoffer (negative sign, becuase of sign convention)
    Q_flow_use = min(0, -(Q_flow_reac + Q_flow_gas + P_el))*eta_Q;
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
  Q_flow_reac = -1*m_dot_H2O_gen_stack/syng.M_i[4]*Delta_H_T;
  Q_flow_gas = feedh.m_flow*h_hein + feeda.m_flow*h_aein + drainh.m_flow*h_haus + draina.m_flow*h_aaus;
//  Q_heater = Modelica.Fluid.Utilities.regStep(T_nom - T_stack-20, Q_heater_nom, 0,0.1);

  der(T_stack)*m*cp =Q_flow_reac + Q_flow_gas + Q_flow_use/eta_Q + P_el;

  // mass balance (total mass)
  feeda.m_flow + m_dot_H2_react_stack = - draina.m_flow;
  feedh.m_flow - m_dot_H2_react_stack = - drainh.m_flow;

  // mass fractions (design flow direction)
  -1*draina.m_flow*draina.xi_outflow[1] = feeda.m_flow*inStream(feeda.xi_outflow[1]) + m_dot_H2O_gen_stack/no_Cells;  //Water mass flow rate of cell stack because of the inserted mass and the reaction
  -1*draina.m_flow*draina.xi_outflow[2] = feeda.m_flow*inStream(feeda.xi_outflow[2]);  //Oxygen mass flow rate of the cell stack
  -1*drainh.m_flow*drainh.xi_outflow[1] = feedh.m_flow*inStream(feedh.xi_outflow[1]);
  -1*drainh.m_flow*drainh.xi_outflow[2] = feedh.m_flow*inStream(feedh.xi_outflow[2]);
  -1*drainh.m_flow*drainh.xi_outflow[3] = feedh.m_flow*inStream(feedh.xi_outflow[3]);
  -1*drainh.m_flow*drainh.xi_outflow[4] = feedh.m_flow*inStream(feedh.xi_outflow[4]);
  -1*drainh.m_flow*drainh.xi_outflow[5] = feedh.m_flow*inStream(feedh.xi_outflow[5]) - m_dot_H2_react_stack/no_Cells;   //Hydrogen mass flow rate of the cell stack
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

  if usePowerPort then
  connect(powerBoundary.epp, epp) annotation (Line(
      points={{-22,28},{-22,27.95},{0,27.95},{0,58}},
      color={0,127,0},
      thickness=0.5));
  connect(realExpression.y, powerBoundary.P_el_set) annotation (Line(points={{-41,64},{-28,64},{-28,40},{-26,40}},   color={0,0,127}));
  end if;
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
          fillPattern=FillPattern.Solid)}), Diagram(graphics,
                                                    coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model of PEM cell stack.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Type of electrical power port can be chosen</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">With the choice of the boundary the the model can be used as PQ or PU bus.</span></p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">Validation has been done as part of the master thesis [1] </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">[1] </span>Modellierung und Simulation von erdgasbetriebenen Brennstoffzellen-Blockheizkraftwerken zur Heimenergieversorgung</p>
<p>Master thesis, Simon Weilbach (2014) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Simon Weilbach (simon.weilbach@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">in October 2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model revised by Pascal Dubucq (dubucq@tuhh.de) in October 2015</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger in October 2016</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model generalized for different electrical power ports by Jan-Peter Heckel (jan.heckel@tuhh.de) in July 2018 </span></p>
</html>"));
end PEM;
