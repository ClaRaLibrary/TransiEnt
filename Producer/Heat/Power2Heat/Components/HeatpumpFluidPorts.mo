within TransiEnt.Producer.Heat.Power2Heat.Components;
model HeatpumpFluidPorts "Heatpump model with on off controller and operating range defined by bivalent point, dynamics are represented only by time relais restriction"

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

  extends Base.PartialHeatPump_fluidport(heatFlowBoundary(Q_flow_n=Q_flow_n));

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.Time t_min_on=3600 "Minimum on time";
  parameter SI.Time t_min_off=600 "Minimum off time";
  parameter SI.Temperature T_bivalent=273.15 "Bivalent temperature where heatpump starts operating (if Tamb > T_bivalent)";
  parameter SI.Temperature T_heatingLimit=293.15 "Temperature limit above which heatpump is turned off (off ist Tamb>T_heatingLimit)";
  parameter TransiEnt.Basics.Types.OnOffRelaisStatus init_state=2 "State of relais at initialization" annotation (choicesAllMatching, Dialog(
      choice=1 "On and ready to switch",
      choice=2 "Off and ready to switch",
      choice=3 "On and blocked by minimum up-time",
      choice=4 "Off and blocked by minimum downtime"));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Basics.Blocks.OnOffRelais onOffRelais(
    init_state=init_state,
    t_min_on=t_min_on,
    t_min_off=t_min_off) annotation (Placement(transformation(extent={{-34,-6},{-22,6}})));

  Modelica.Blocks.Logical.LessThreshold isHeatdemand(threshold=T_heatingLimit) annotation (Placement(transformation(extent={{-62,36},{-42,56}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold isBaseload(threshold=T_bivalent)
                                                                         annotation (Placement(transformation(extent={{-62,66},{-42,86}})));
  Modelica.Blocks.MathBoolean.And isStartRequest(nu=3) annotation (Placement(transformation(extent={{-10,-6},{2,6}})));

  Modelica.Blocks.Sources.RealExpression T_amb_K(y=T_source_internal) annotation (Placement(transformation(extent={{-94,50},{-74,70}})));
  Modelica.Blocks.Continuous.FirstOrder shutdown(T=60) annotation (Placement(transformation(extent={{22,-46},{42,-26}})));
  Modelica.Blocks.Logical.Switch dynamic annotation (Placement(transformation(extent={{54,-62},{74,-42}})));
  Modelica.Blocks.Continuous.FirstOrder startup(T=10) annotation (Placement(transformation(extent={{22,-80},{42,-60}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=onOffRelais.switch_to_on.outPort.set) annotation (Placement(transformation(extent={{-22,-62},{-2,-42}})));
public
  Modelica.Blocks.Logical.Hysteresis Controller(uLow=-Delta_T_db/2, uHigh=+Delta_T_db/2)
                                                                                     annotation (Placement(transformation(extent={{-54,-7},{-40,7}})));
  Modelica.Blocks.Math.BooleanToReal P_el_HP(realFalse=0, realTrue=P_el_n) annotation (Placement(transformation(extent={{8,-8},{24,8}})));
  Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(extent={{96,92},{116,112}}), iconTransformation(extent={{88,68},{112,92}})));
equation

  P_el_HP.y = epp.P;
    //collector
  collectElectricPower.powerCollector.P=epp.P;
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(T_amb_K.y, isHeatdemand.u) annotation (Line(points={{-73,60},{-73,46},{-64,46}}, color={0,0,127}));
  connect(isBaseload.u,T_amb_K. y) annotation (Line(points={{-64,76},{-72,76},{-72,60},{-73,60}},
                                                                                  color={0,0,127}));
  connect(onOffRelais.y, isStartRequest.u[1]) annotation (Line(points={{-21.4,0},{-10,0},{-10,2.8}}, color={255,0,255}));
  connect(isHeatdemand.y, isStartRequest.u[2]) annotation (Line(points={{-41,46},{-16,46},{-16,4.44089e-016},{-10,4.44089e-016}}, color={255,0,255}));
  connect(isBaseload.y, isStartRequest.u[3]) annotation (Line(points={{-41,76},{-18,76},{-18,-2.8},{-10,-2.8}}, color={255,0,255}));
  connect(Controller.y, onOffRelais.u) annotation (Line(points={{-39.3,8.88178e-016},{-36,8.88178e-016},{-36,0},{-34.24,0}},
                                                                                                  color={255,0,255}));
  connect(isStartRequest.y, P_el_HP.u) annotation (Line(points={{2.9,0},{6.4,0}},           color={255,0,255}));
  connect(shutdown.y, dynamic.u1) annotation (Line(points={{43,-36},{44,-36},{46,-36},{46,-44},{52,-44}}, color={0,0,127}));
  connect(startup.y, dynamic.u3) annotation (Line(points={{43,-70},{46,-70},{46,-60},{52,-60}}, color={0,0,127}));
  connect(Q_flow.y, shutdown.u) annotation (Line(points={{59,0},{64,0},{64,-20},{10,-20},{10,-36},{20,-36}}, color={0,0,127}));
  connect(Q_flow.y, startup.u) annotation (Line(points={{59,0},{64,0},{64,-20},{10,-20},{10,-70},{20,-70}}, color={0,0,127}));
  connect(booleanExpression.y, dynamic.u2) annotation (Line(points={{-1,-52},{52,-52}},          color={255,0,255}));
  connect(feedback.y,Controller. u) annotation (Line(points={{-63,0},{-55.4,0}},
                                                                               color={0,0,127}));
  connect(P_el_HP.y,Q_flow. u2) annotation (Line(points={{24.8,0},{24.8,0},{28,0},{28,-6},{36,-6}},
                                                                           color={0,0,127}));
  connect(dynamic.y, heatFlowBoundary.Q_flow_prescribed) annotation (Line(points={{75,-52},{76,-52},{76,-12},{68,-12},{68,1.2},{71.6,1.2}},  color={0,0,127}));
  annotation(defaultComponentName="Heatpump", Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model of a controlled heat pump model with fluidports.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>L2 (defined in the CodingConventions)</p>
<p>On/off controller</p>
<p>Operating range defined by bivalent point</p>
<p>Dynamics represented by time relais restriction</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Modelica.Blocks.Interfaces.RealInput: u_set (setpoint value)</p>
<p>Modelica.Blocks.Interfaces.RealInput: u_meas (measurement value)</p>
<p>Modelica.Blocks.Interfaces.RealInput: T_source_input_K (input ambient temperature in Kelvin)</p>
<p>Modelica.Blocks.Interfaces.RealInput: T_source_internal (ambient temperature from SimCenter)</p>
<p>TransiEnt.Basics.Interfaces.Thermal.FluidPortIn: waterIn</p>
<p>TransiEnt.Basics.Interfaces.Thermal.FluidPortOut: waterOut</p>
<p>Basics.Interfaces.Electrical.ActivePowerPort: epp</p>
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
end HeatpumpFluidPorts;
