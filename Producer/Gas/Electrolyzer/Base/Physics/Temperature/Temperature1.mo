within TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Temperature;
model Temperature1
  "PEMElectrolyzer thermal model as implemented by Espinosa, 2018"
    //The following must all be calculated in the Temperature model or else provided externally.
    //T_op, T_amb

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  extends TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.Temperature.PartialTemperature;

  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  outer parameter Integer n_cells "number of cells in series";
  outer parameter SI.HeatCapacity C_th "Overall lumped thermal capacitance, Espinosa 2018. 42045J/K from Garcia-Valverdes 2011";
  outer parameter SI.ThermalResistance R_th "K/W;Thermal resistance of stack;Espinosa 2018. 0.0817 K/W in Garcia";
  outer parameter SI.Temperature T_op_max "max operating temp; where Q_cool=MAX_Q_COOL, eqm with heat generated at 400A";
  outer parameter SI.Temperature T_cool_set "Q_cool trigger point";
  outer parameter SI.HeatFlowRate Q_flow_cool_max "equilibrium cooling power for 400A input at 30bar"; //(6039 at operating pressure of 5bar)
  //Can use Q_flow_cool_max=34.88*p_cat + 5864.6; //for pressure dependent maximum cooling power
  outer parameter SI.Power P_el_pump "pump el power consumption, involved in heating";
  outer parameter SI.Efficiency eta_pumpmotor "pump's motor electric efficiency";
  outer parameter SI.VolumeFlowRate V_flow_water "140L/min, water flow rate in cooling loop";
  outer parameter SI.PressureDifference Delta_p_pump "total pump head";
  outer parameter SI.Temperature T_std "STD temperature";

  //Temperature PID Controller Parameters
  parameter SI.Time tau_i=7.7407980342622659e-04 "1/tau_i for cooling system PID integrator gain";
  parameter Real k_p=500 "gain, cooling system PID proportional control";

  // _____________________________________________
  //
  //              Variables
  // _____________________________________________

  //Temperatures
  Boolean cooling_control "control operation of Q_cool";
  SI.TemperatureSlope der_T_op "Operating stack temperature";

  //Voltages
  outer SI.Voltage V_tn "or U_tn, Thermoneutral voltage (voltage at which reaction can occur without releasing any heat)";
  outer SI.Voltage V_cell "PEM cell voltage considering all included physical phenomena";

  //Heat flows

  SI.HeatFlowRate Q_flow_H2Oelectrolysis "W, power dissipated as heat from water electrolysis reaction";
  SI.Power P_pump_diss "W, power dissipated by the pump due to friction";
  SI.HeatFlowRate Q_flow_convective "W; flow of Heat loss to ambient";
  SI.HeatFlowRate H_flow_prod "Enthalpy loss due to the products leaving the system";
  SI.MolarHeatCapacity c_p_m_H2 "Molar specific heat of H2";
  SI.MolarHeatCapacity c_m_p_O2 "Molar specific heat of O2";
  SI.HeatFlowRate Q_flow_cooling "cooling power of heat exchanger";

  //Mass Transport
  outer SI.MolarFlowRate n_flow_H2 "Molar production rate of Hydrogen gas";
  outer SI.MolarFlowRate n_flow_O2 "Molar production rate of Oxygen gas";

  //Current
  outer SI.Current i_el_stack "current across the electrolyzer stack";

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________
  /*
  Modelica.Blocks.Interfaces.RealInput Q_flow_cooling(
    final quantity="HeatFlowRate",
    displayUnit="W",
    final unit="W")                          annotation (Placement(
        transformation(extent={{24,-24},{64,16}},  rotation=0)));
*/
  Modelica.Blocks.Sources.RealExpression PID_T_max(y=T_op_max) annotation (Placement(transformation(extent={{-52,-12},{-32,8}})));
  Modelica.Blocks.Sources.RealExpression PID_T_op(y=T_op) annotation (Placement(transformation(extent={{-52,-40},{-32,-20}})));
  Modelica.Blocks.Sources.BooleanExpression PID_T_control(y=cooling_control) annotation (Placement(transformation(extent={{-52,-26},{-32,-6}})));
  ClaRa.Components.Utilities.Blocks.LimPID cooling_PID(
    y_max=6911,
    y_min=0,
    y_inactive=0,
    use_activateInput=true,
    sign=-1,
    Tau_i=tau_i,
    k=k_p,
    controllerType=Modelica.Blocks.Types.SimpleController.PI) annotation (Placement(transformation(extent={{-10,-14},{10,6}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  if userSetTemp then
    cooling_control = false;
    Q_flow_H2Oelectrolysis = 0;
    P_pump_diss = 0;
    Q_flow_cooling = 0;
    Q_flow_convective = 0;
    c_p_m_H2 = 0;
    c_m_p_O2 = 0;
    H_flow_prod = 0;
  else

    der(T_op) = der_T_op;

    cooling_control = T_op > T_cool_set;

    Q_flow_H2Oelectrolysis = if (V_cell < V_tn) then 0 else n_cells*(V_cell - V_tn)*i_el_stack;

    Q_flow_convective = (T_op - T_amb)/R_th "convection heat transfer rate";

    P_pump_diss = if i_el_stack > 0 then P_el_pump*eta_pumpmotor else 0;

    c_p_m_H2 = 29.11 - 1.92e-3*T_op + 4.0e-6*T_op^2 - 8.7e-10*T_op^3;
    c_m_p_O2 = 25.48 + 1.52e-2*T_op - 7.16e-6*T_op^2 + 1.31e-9*T_op^3;
    H_flow_prod = n_flow_H2*c_p_m_H2*(T_op - T_amb) + n_flow_O2*c_m_p_O2*(T_op - T_amb);

    Q_flow_cooling = cooling_PID.y;

    /**** PID CONTROL DESCRIPTION **********
    zone 1: T_op > T_max, turn on Q_flow_cool_max
    zone 2: T_op < T_max and temperature increasing, turn on PID cooling
    zone 3: T_op < T_max and temperature decreasing or T_op < T_cool_set turn off cooling
    */
  end if;

  C_th*der_T_op =Q_flow_H2Oelectrolysis + P_pump_diss - Q_flow_cooling - Q_flow_convective - H_flow_prod;

  connect(cooling_PID.u_s, PID_T_max.y) annotation (Line(points={{-12,-4},{-24,-4},{-24,-2},{-31,-2}}, color={0,0,127}));
  connect(cooling_PID.u_m, PID_T_op.y) annotation (Line(points={{0.1,-16},{0,-16},{0,-30},{-31,-30}}, color={0,0,127}));
  connect(cooling_PID.activateInput, PID_T_control.y) annotation (Line(points={{-12,-12},{-22,-12},{-22,-16},{-31,-16}}, color={255,0,255}));

  annotation (
    defaultConnectionStructurallyInconsistent=true,
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This is a model for AREVA Inc. Giner electrolyzer system temperature. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Temperature is modeled according to Espinosa-L&oacute;pez et al 2018 based on heat generated from electrolysis, pump, and heat lost due to convection, cooling system, and enthalpy loss. The contribution of the pump is modeled differently.</p>
<p>Cooling:</p>
<ul>
<li>zone&nbsp;1:&nbsp;T_op&nbsp;&gt;&nbsp;T_max,&nbsp;turn&nbsp;on&nbsp;Q_flow_cool_max</li>
<li>zone&nbsp;2:&nbsp;T_op&nbsp;&lt;&nbsp;T_max&nbsp;and&nbsp;temperature&nbsp;increasing,&nbsp;turn&nbsp;on&nbsp;PID&nbsp;cooling</li>
<li>zone&nbsp;3:&nbsp;T_op&nbsp;&lt;&nbsp;T_max&nbsp;and&nbsp;temperature&nbsp;decreasing&nbsp;or&nbsp;T_op&nbsp;&lt;&nbsp;T_cool_set&nbsp;turn&nbsp;off&nbsp;cooling</li>
</ul>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>Original model developed and validated in the range of 20-60 &deg;C, with operating pressure of 15-35 bar and a maximum cooling power for operating current of 400A. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Consist of thermal equations from Espinosa-L&oacute;pez et al 2018 with new PID-cooling power model from ClaRa LimPID block.</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Results have been validated against Espinosa-L&oacute;pez et al 2018 published figures. </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>Manuel Espinosa-L&oacute;pez, Philippe Baucour, Serge Besse, Christophe Darras, Raynal Glises, Philippe Poggi, Andr&eacute; Rakotondrainibe, and Pierre Serre-Combe. Modelling and experimental validation of a 46 kW PEM high pressure water electrolyser. Renewable Energy, 119, pp. 160-173, 2018. doi: 10.1016/J.RENENE.2017.11.081. </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by John Webster (jcwebste@edu.uwaterloo.ca) October 2018.</p>
</html>"));
end Temperature1;
