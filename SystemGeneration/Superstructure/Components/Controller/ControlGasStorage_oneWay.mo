within TransiEnt.SystemGeneration.Superstructure.Components.Controller;
model ControlGasStorage_oneWay


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

  extends TransiEnt.SystemGeneration.Superstructure.Components.Controller.Base.ControlGasStorage_Base;
  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Real Vgeo_per_mMax=2.73e+09;
  parameter Real m_flow_inMax=5000;
  parameter Real m_flow_outMax=5000;
  parameter Real GasStrorageTypeNo=1;
  parameter SI.Time failure_table[:,:]=[0,1; 1,1; 2,1; 3,1; 4,1];
  parameter Modelica.Units.SI.Pressure p_gasGrid_desired=simCenter.p_amb_const + simCenter.p_eff_2 "desired gas grid pressure in region";
  parameter Modelica.Units.SI.PressureDifference p_gasGrid_desired_bandwidth=0 "band width around p_gasGrid_desired in which the set value varies depending on the SOC of the gas storage";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Basics.Blocks.LimPID PID_GasGrid2(
    initOption=503,
    Tau_d=0.2,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_start=0,
    y_max=m_flow_outMax,
    y_min=-m_flow_inMax,
    k=1,
    Tau_i=1000) annotation (Placement(transformation(extent={{-82,44},{-62,64}})));
  Modelica.Blocks.Sources.RealExpression realExpression6(y=p_gasGrid_desired + p_gasGrid_desired_bandwidth*(gain_gasStorage_m_gas.y/Vgeo_per_mMax - 0.5)) annotation (Placement(transformation(extent={{-102,50},{-94,58}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(extent={{40,44},{60,64}})));
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(extent={{-30,84},{-10,64}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=if GasStrorageTypeNo == 2 then simCenter.p_amb_const + simCenter.p_eff_2 else 0.01, uHigh=if GasStrorageTypeNo == 2 then simCenter.p_amb_const + simCenter.p_eff_2 + 0.5e5 else Vgeo_per_mMax/1000) annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Logical.Not not1 annotation (Placement(transformation(extent={{8,-40},{28,-20}})));
  Modelica.Blocks.Sources.RealExpression zero annotation (Placement(transformation(rotation=0, extent={{-100,84},{-80,104}})));
  Modelica.Blocks.Sources.BooleanExpression expressionControlValue(y=GasStrorageTypeNo == 1) annotation (Placement(transformation(extent={{-98,-34},{-90,-26}})));
  Modelica.Blocks.Logical.Switch switchControlValue annotation (Placement(transformation(extent={{-60,-20},{-40,-40}})));
  Modelica.Blocks.Math.Gain gain_gasStorage_m_gas(k=1) annotation (Placement(transformation(extent={{104,30},{124,50}})));
  Modelica.Blocks.Math.Gain gain_gasStorage_p_gas(k=1) annotation (Placement(transformation(extent={{104,60},{124,80}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis1(uLow=if GasStrorageTypeNo == 2 then 180e5 else Vgeo_per_mMax*0.99, uHigh=if GasStrorageTypeNo == 2 then 185e5 else Vgeo_per_mMax) annotation (Placement(transformation(extent={{-16,-86},{0,-70}})));
  Modelica.Blocks.Logical.Switch switch2 annotation (Placement(transformation(extent={{-30,52},{-10,32}})));
  FailureController_internal failureController_internal(quantity=1, failure1_table=failure_table) annotation (Placement(transformation(extent={{76,-84},{88,-72}})));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation (Placement(transformation(extent={{8,44},{28,64}})));
  Modelica.Blocks.Sources.RealExpression infPos(y=Modelica.Constants.inf) annotation (Placement(transformation(rotation=0, extent={{-66,72},{-46,92}})));
  Modelica.Blocks.Sources.RealExpression infNeg(y=-Modelica.Constants.inf) annotation (Placement(transformation(rotation=0, extent={{-70,22},{-50,42}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(realExpression6.y, PID_GasGrid2.u_s) annotation (Line(points={{-93.6,54},{-84,54}}, color={0,0,127}));
  connect(hysteresis.y, not1.u) annotation (Line(points={{1,-30},{6,-30}}, color={255,0,255}));
  connect(not1.y, switch1.u2) annotation (Line(points={{29,-30},{42,-30},{42,12},{-46,12},{-46,74},{-32,74}}, color={255,0,255}));
  connect(switch1.u1, zero.y) annotation (Line(points={{-32,66},{-40,66},{-40,94},{-79,94}}, color={0,0,127}));
  connect(expressionControlValue.y, switchControlValue.u2) annotation (Line(points={{-89.6,-30},{-62,-30}}, color={255,0,255}));
  connect(controlBus.gasStorage_p_gas, switchControlValue.u3) annotation (Line(
      points={{98,0},{-78,0},{-78,-22},{-62,-22}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(controlBus.gasStorage_m_gas, switchControlValue.u1) annotation (Line(
      points={{98,0},{-78,0},{-78,-38},{-62,-38}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(switchControlValue.y, hysteresis.u) annotation (Line(points={{-39,-30},{-22,-30}}, color={0,0,127}));
  connect(PID_GasGrid2.u_m, p_gas_region) annotation (Line(points={{-71.9,42},{-71.9,2},{-104,2}}, color={0,0,127}));
  connect(controlBus.gasStorage_m_gas, gain_gasStorage_m_gas.u) annotation (Line(
      points={{98,0},{90,0},{90,40},{102,40}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(controlBus.gasStorage_p_gas, gain_gasStorage_p_gas.u) annotation (Line(
      points={{98,0},{90,0},{90,70},{102,70}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(switchControlValue.y, hysteresis1.u) annotation (Line(points={{-39,-30},{-30,-30},{-30,-78},{-17.6,-78}}, color={0,0,127}));
  connect(hysteresis1.y, switch2.u2) annotation (Line(points={{0.8,-78},{50,-78},{50,22},{-38,22},{-38,42},{-32,42}}, color={255,0,255}));
  connect(switch2.u1, zero.y) annotation (Line(points={{-32,34},{-40,34},{-40,94},{-79,94}}, color={0,0,127}));
  connect(controlBus.gasStorage_mFlowDes, failureController_internal.value_out[1]) annotation (Line(
      points={{98,0},{90,0},{90,-82.8},{88.6,-82.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(PID_GasGrid2.y, variableLimiter.u) annotation (Line(points={{-61,54},{6,54}}, color={0,0,127}));
  connect(variableLimiter.y, gain.u) annotation (Line(points={{29,54},{38,54}}, color={0,0,127}));
  connect(gain.y, failureController_internal.value_in[1]) annotation (Line(points={{61,54},{70,54},{70,-82.8},{74.8,-82.8}}, color={0,0,127}));
  connect(switch2.y, variableLimiter.limit2) annotation (Line(points={{-9,42},{-2,42},{-2,46},{6,46}}, color={0,0,127}));
  connect(switch1.y, variableLimiter.limit1) annotation (Line(points={{-9,74},{-2.5,74},{-2.5,62},{6,62}}, color={0,0,127}));
  connect(infPos.y, switch1.u3) annotation (Line(points={{-45,82},{-32,82}}, color={0,0,127}));
  connect(infNeg.y, switch2.u3) annotation (Line(points={{-49,32},{-48,32},{-48,50},{-32,50}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-80},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Controller for mass flow of gas storage in superstructure. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
</html>"));
end ControlGasStorage_oneWay;
