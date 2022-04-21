within TransiEnt.Components.Electrical.FuelCellSystems.FuelCell;
model SOFC "Model of one SOFC-Cell Stack with three states (Ramp up, Normal operation, Ramp down)"



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

  parameter Real alpha = 1 "Transfer coefficient";

  parameter Real z = 2 "Quantity of transfered electrons";

  parameter Modelica.Units.SI.Area A_cell=361e-4 "Area of one cell";

  parameter Modelica.Units.SI.Pressure p_Anode=1.5e5 "Pressure at the anode";

  parameter Modelica.Units.SI.Pressure p_Kathode=1e5 "Pressure at the cathode";

  parameter TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG7_var Syngas=TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG7_var() "Medium model of Syngas" annotation (choicesAllMatching);

  parameter TransiEnt.Basics.Media.Gases.Gas_MoistAir Air=TransiEnt.Basics.Media.Gases.Gas_MoistAir() "Medium model of air" annotation (choicesAllMatching);

  parameter Real hf_H2O = -285.8 * 1000 "Reaction enthalpy of the steam";

  parameter Real cp_tab[3,3] = [28.91404, -0.00084, 2.01e-6; 25.84512, 0.012987, -3.9e-6; 30.62644, 0.009621, 1.18e-6] "Empiric parameter for calculating Gibbs free energy according to Barbir";

  parameter Real ASR_0 = 0.29e-4 "Reference value of the loss resistance at T_0 according to Saarinen in Ohm";
  parameter Modelica.Units.SI.Temperature T_0=1073 "Reference value of the temperature for calculating the loss resistance according to Saarinen";
  parameter Real E_A = 0.65 "Energy of activation according to Saarinen in eV";

  parameter Modelica.Units.SI.Mass m=5 "Mass of the stack";
  parameter Modelica.Units.SI.SpecificHeatCapacity cp=1000 "Specific heat capacity of the stack";
  parameter SI.Temperature T_n=820 + 273.15 "Temperature in nominal point (i.e. minimum Temperature for operation)";
  parameter Modelica.Units.SI.Temperature T_heater_restart=T_n - 50 "Heater restarts at this temperature when temperature drops while operating";
  parameter Modelica.Units.SI.HeatFlowRate Q_heater_nom=3e3 "Nominal power of heater for ramp up process";
  parameter Modelica.Units.SI.ThermalConductance ka=0.5 "Thermal conductance between FC and ambient when cooling is shut off (i.e. heat loss)";
  parameter Modelica.Units.SI.Temperature T_demand=50 + 273.15 "Temperature of heat demand";
  parameter Modelica.Units.SI.Current I_shutdown=10 "If load controller requests currents below this value, stack will shut down";

  parameter SI.Voltage v_n=simCenter.v_n "Nominal Voltage for grid";

  parameter Boolean usePowerPort=true "True if power port shall be used" annotation (Dialog(group="Replaceable Components"));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  Modelica.Units.SI.Temperature T_stack(start=25 + 273.15) "Temperature of one cell" annotation (Dialog(group="Initialization", showStartAttribute=true));
  Modelica.Units.SI.Temperature T_syng_ein "Temperature of the syngas";
  Modelica.Units.SI.Temperature T_air_ein "Temperature of the air";
  Modelica.Units.SI.Temperature T_heatdemand=60 + 273.15;
  Modelica.Units.SI.CurrentDensity i_cell(start=0) "Electric current of one cell" annotation (Dialog(group="Initialization", showStartAttribute=true));
  Modelica.Units.SI.Pressure P_O2=air.p_i[3]/air.p "Partial pressure of the oxygen at the cathode";
  Modelica.Units.SI.Pressure P_H2=syng.p_i[5]/syng.p "Partial pressure of the hydrogen at the anode";

  Modelica.Units.SI.Voltage E_cell "Voltage of one cell";
  Modelica.Units.SI.Voltage E_stack "Voltage of one stack";
  Real ASR = ASR_0*exp(E_A/Modelica.Constants.R * (1/T_stack - 1/T_0)) "Temperature-dependent resistance for calculating the losses";
  Modelica.Units.SI.Voltage VR "Voltage loss 3";
  Modelica.Units.SI.Voltage Er "Reversible electric potential without any losses";
  Real da= cp_tab[3,1] - cp_tab[1,1] - 0.5* cp_tab[2,1] "Empiric parameter for calculating Gibbs free energy according to Barbir";
  Real db= cp_tab[3,2] - cp_tab[1,2] - 0.5* cp_tab[2,2] "Empiric parameter for calculating Gibbs free energy according to Barbir";
  Real dc= cp_tab[3,3] - cp_tab[1,3] - 0.5* cp_tab[2,3] "Empiric parameter for calculating Gibbs free energy according to Barbir";
  Real Delta_H_T = -241.98*1000 + da*(T_stack-298.15) + db * ((T_stack^2) - 298.15^2)/2 + dc * ((T_stack^3) - 298.15^3)/3 "Empiric equation for calculating the enthalpy of formation according to Barbir";
  Real Delta_S_T = -0.0444*1000 + da*log(T_stack/298.15) + db * (T_stack - 298.15) + dc * ((T_stack^2) - 298.15^2)/2 "Empiric equation for calculating the entropy according to Barbir";

  Modelica.Units.SI.MolarFlowRate N_dot_e "Molar flow of the electrons";
  Modelica.Units.SI.MassFlowRate m_dot_H2_react_stack "Required H2 mass flow rate of one cell";
  Modelica.Units.SI.MassFlowRate m_dot_O2_react_stack "Required O2 mass flow rate of one cell";
  Modelica.Units.SI.MassFlowRate m_dot_H2O_gen_stack "Generated H2O mass flow rate of one cell";
  Modelica.Units.SI.MassFlowRate m_dot_air_react_stack "Required air mass flow rate of one cell";
  Modelica.Units.SI.MolarMass M_H2=syng.M_i[5] "Molar mass H2";
  Modelica.Units.SI.MolarMass M_O2=syng.M_i[2] "Molar mass O2";
  Modelica.Units.SI.MassFraction xi_O2 "Mass fraction of O2 in the air";
  Modelica.Units.SI.SpecificEnthalpy h_hein=syng.h;
  Modelica.Units.SI.SpecificEnthalpy h_haus=synga.h;
  Modelica.Units.SI.SpecificEnthalpy h_aein=air.h;
  Modelica.Units.SI.SpecificEnthalpy h_aaus=aira.h;
  SI.HeatFlowRate Q_flow_reac "Heat flow due to reaction";
  SI.HeatFlowRate Q_flow_heater "Heat flow provided by heater for ramp up";
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

  TransiEnt.Basics.Interfaces.Gas.IdealGasTempPortIn feedh(Medium=Syngas) annotation (Placement(transformation(extent={{-108,30},{-84,52}}), iconTransformation(extent={{-114,46},{-86,74}})));
  TransiEnt.Basics.Interfaces.Gas.IdealGasTempPortOut drainh(Medium=Syngas) annotation (Placement(transformation(extent={{88,30},{112,52}}), iconTransformation(extent={{86,46},{114,74}})));
  TransiEnt.Basics.Interfaces.Gas.IdealGasTempPortIn feeda(Medium=Air) annotation (Placement(transformation(extent={{-108,-54},{-84,-30}}), iconTransformation(extent={{-114,-74},{-86,-46}})));
  TransiEnt.Basics.Interfaces.Gas.IdealGasTempPortOut draina(Medium=Air) annotation (Placement(transformation(extent={{88,-70},{114,-46}}), iconTransformation(extent={{86,-74},{114,-46}})));

  TransiEnt.Basics.Interfaces.Electrical.ElectricCurrentIn I_load "Input for loading current" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-50,100}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-82,-6})));
  TransiEnt.Basics.Interfaces.Electrical.VoltageOut v_stack "Output for voltage of one stack" annotation (Placement(transformation(extent={{-20,-20},{20,20}}, rotation=90)));
  TransiEnt.Basics.Interfaces.General.MassFractionOut lambda_H "Output for excess ratio of hydrogen" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={70,-100}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,-100})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_use "Useful heatflowrate" annotation (Placement(transformation(        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={30,-100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,-100})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_el = -1 * E_stack*I "electrical Power" annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-60,-98}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={100,-120})));
  TransiEnt.Basics.Interfaces.General.MassFractionOut lambda_O "Output for excess ratio of oxygen" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-14,-100}),
                         iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={100,-80})));
  replaceable TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp if usePowerPort constrainedby TransiEnt.Basics.Interfaces.Electrical.PartialPowerPort "Choice of power port" annotation (Dialog(group="Replaceable Components"),choicesAllMatching=true, Placement(transformation(extent={{-10,48},{10,68}}), iconTransformation(extent={{-10,48},{10,68}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________


   Modelica.Blocks.Sources.RealExpression realExpression(y=P_el) if usePowerPort annotation (Placement(transformation(extent={{-62,54},{-42,74}})));
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
      choice(redeclare TransiEnt.Components.Boundaries.Electrical.ApparentPower.PowerVoltage powerBoundary(Use_input_connector_v=false, v_boundary=SOFC.v_n) "PV-Boundary for ApparentPowerPort"),
      choice(redeclare TransiEnt.Components.Electrical.QuasiStationaryComponentsBusses.PUMachine powerBoundary(v_gen=SOFC.v_n, useInputConnectorP=true) "PV-Boundary for ComplexPowerPort")),
    Placement(transformation(extent={{-22,18},{-42,38}})));


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
    T=T_stack,
    xi= drainh.xi_outflow,
    gasType = Syngas)
    annotation (Placement(transformation(extent={{-80,-52},
            {-60,-32}})));

    TILMedia.Gas_pT aira(
    T=T_stack,
    p=1e5,
    xi=draina.xi_outflow,
    gasType = Air) "Moist air is used which consists of N2, H2O and O2. This is why the component O2 can be used from it!"
    annotation (Placement(transformation(extent={{64,-58},{88,-28}})));


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


  // Heating up model
  is_T_reac_min_reached =T_stack > T_n or pre(is_T_reac_min_reached) and T_stack > T_heater_restart;

  // Shutting down model
  is_Shutdown = I_load <= I_shutdown;

  if is_Shutdown then
    // Load current below mimimum value = signal to shut down!
    Q_flow_heater = 0;
    Q_flow_use = ka*(simCenter.T_amb_const - T_stack);
    I = 0;
    v_stack = 0;
    lambda_H = -1; // signal to lambda h controller that we are in shut down mode!
    lambda_O = 0;
  elseif not is_T_reac_min_reached then
    // below T_nom: Heater is running and no reaction nor heat offer
    Q_flow_heater = Q_heater_nom;
    Q_flow_use = ka*(simCenter.T_amb_const - T_stack);
    I = 0;
    v_stack = 0;
    lambda_H = 0;  // signal to lambdah controller to give out ramp up mass flow
    lambda_O = 0;
  else
    // Normal operating point: Heater if off, Reaction is running, Reaction heat leads to positive Heatoffer (negative sign, becuase of sign convention)
    Q_flow_heater = 0;
    Q_flow_use = min(0, -(Q_flow_reac + Q_flow_gas + P_el));
    I = min(I_load,I_is);
    v_stack = E_stack;
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

  der(T_stack)*m*cp =Q_flow_reac + Q_flow_heater + Q_flow_gas + Q_flow_use + P_el;

  // mass balance (total mass)
  feeda.m_flow - m_dot_O2_react_stack = - draina.m_flow;
  feedh.m_flow + m_dot_O2_react_stack = - drainh.m_flow;

  // mass fractions (design flow direction)
  -1*draina.m_flow*draina.xi_outflow[1] = feeda.m_flow*inStream(feeda.xi_outflow[1]);  //Water mass flow rate of cell stack because of the inserted mass and the reaction
  -1*draina.m_flow*draina.xi_outflow[2] = feeda.m_flow*inStream(feeda.xi_outflow[2]);  //Oxygen mass flow rate of the cell stack
  -1*drainh.m_flow*drainh.xi_outflow[1] = feedh.m_flow*inStream(feedh.xi_outflow[1]);
  -1*drainh.m_flow*drainh.xi_outflow[2] = feedh.m_flow*inStream(feedh.xi_outflow[2]);
  -1*drainh.m_flow*drainh.xi_outflow[3] = feedh.m_flow*inStream(feedh.xi_outflow[3]);
  -1*drainh.m_flow*drainh.xi_outflow[4] = feedh.m_flow*inStream(feedh.xi_outflow[4]) + m_dot_H2O_gen_stack;
  -1*drainh.m_flow*drainh.xi_outflow[5] = feedh.m_flow*inStream(feedh.xi_outflow[5]) - m_dot_H2_react_stack;   //Hydrogen mass flow rate of the cell stack
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
  connect(realExpression.y, powerBoundary.P_el_set) annotation (Line(points={{-41,64},{-28,64},{-28,40},{-26,40}},   color={0,0,127}));
  connect(powerBoundary.epp, epp) annotation (Line(
      points={{-22,28},{-22,28},{-22,28},{0,28},{0,58}},
      color={0,127,0},
      thickness=0.5));
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
<p>Model of one SOFC-Cell Stack with three states (Ramp up, Normal operation, Ramp down).</p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger in October 2015</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model generalized for different electrical power ports by Jan-Peter Heckel (jan.heckel@tuhh.de) in July 2018 </span></p>
</html>"));
end SOFC;
