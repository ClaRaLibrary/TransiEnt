within TransiEnt.Producer.Heat.Power2Heat.Components;
model StaticHeatpump "Heatpump model with on off controller and no dynamic"

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

  extends Base.PartialHeatPump_heatport;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

public
  Modelica.Blocks.Logical.Hysteresis Controller(uLow=-Delta_T_db/2, uHigh=+Delta_T_db/2)
                                                                                     annotation (Placement(transformation(extent={{-36,-7},{-22,7}})));
  Modelica.Blocks.Math.BooleanToReal P_el_HP(realFalse=0, realTrue=P_el_n) annotation (Placement(transformation(extent={{-6,-8},{10,8}})));
equation
    //collector
  collectElectricPower.powerCollector.P=P_el_HP.y;
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(Controller.y, P_el_HP.u) annotation (Line(points={{-21.3,8.88178e-016},{-7.6,8.88178e-016},{-7.6,0}},
                                                                                          color={255,0,255}));
  connect(Q_flow.y,heatFlowBoundary. Q_flow) annotation (Line(points={{59,0},{59,0},{72,0}},   color={0,0,127}));
  connect(feedback.y,Controller. u) annotation (Line(points={{-63,0},{-56,0},{-56,8.88178e-016},{-37.4,8.88178e-016}},
                                                                               color={0,0,127}));
  connect(P_el_HP.y,Q_flow. u2) annotation (Line(points={{10.8,0},{10.8,0},{34,0},{34,-6},{36,-6}},
                                                                           color={0,0,127}));
  annotation(defaultComponentName="Heatpump", Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model of a heat pump model with heatport, on/off controller and no dynamic.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Modelica.Blocks.Interfaces.RealInput: u_set (setpoint value)</p>
<p>Modelica.Blocks.Interfaces.RealInput: u_meas (measurement value)</p>
<p>Modelica.Blocks.Interfaces.RealInput: T_source_input_K (input ambient temperature in Kelvin)</p>
<p>Modelica.Blocks.Interfaces.RealInput: T_source_internal (ambient temperature from SimCenter)</p>
<p>Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b: heatPort</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>eta_HP = COP_n/((273.15+40)/(40-2))</p>
<p>P_el_n = Q_flow_n / COP_n</p>
<p>COP(y=COP_Carnot*eta_HP)</p>
<p>COP_Carnot=(u_set + Delta_T_internal)/max(2*Delta_T_internal, u_set + 2*Delta_T_internal - T_source_internal)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>(no remarks)</p>
</html>"));
end StaticHeatpump;
