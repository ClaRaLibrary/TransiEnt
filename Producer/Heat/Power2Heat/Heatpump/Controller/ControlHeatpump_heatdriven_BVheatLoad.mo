within TransiEnt.Producer.Heat.Power2Heat.Heatpump.Controller;
model ControlHeatpump_heatdriven_BVheatLoad "Heat-driven operation, if bivalent mode selected, heater will switch on additionally to heatpump if heat demand cannot be met."



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





  extends TransiEnt.Producer.Heat.Power2Heat.Heatpump.Controller.Base.Controller;
  extends TransiEnt.Basics.Icons.Controller;

   //___________________________________________________________________________
   //
   //                      Parameters
   //___________________________________________________________________________

  parameter Real SoCSet_HP=0.7 annotation (Dialog(group="SoC limits"));
  parameter Real SoCLow_HP=0.5 "SoC limit to switch on the heat pump" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SoCHigh_HP=1 "SoC limit to switch off the heat pump" annotation (Dialog(group="SoC limits", enable=control_SoC));

  parameter Real SoCLow_Heater=0.25 "SoC limit to switch on the heater" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SoCHigh_Heater=0.6 "SoC limit to switch off the heater" annotation (Dialog(group="SoC limits", enable=control_SoC));

  input SI.Temperature THigh_HP=T_set+Delta_T_db/2 "Temperature limit to switch on the heatpump" annotation (Dialog(group="Temperature limits", enable=control_SoC==false));
  input SI.Temperature TLow_HP=T_set-Delta_T_db/2
                                                 "Temperature limit to switch on the heatpump" annotation (Dialog(group="Temperature limits", enable=control_SoC==false));
  input SI.Temperature TLow_Heater=T_set-Delta_T_db "Temperature limit to switch on the heater" annotation (Dialog(group="Temperature limits", enable=control_SoC==false));
  input SI.Temperature THigh_Heater=T_set "Temperature limit to switch off the heater" annotation (Dialog(group="Temperature limits", enable=control_SoC==false));

   //___________________________________________________________________________
   //
   //                      Variables
   //___________________________________________________________________________

  Real uHigh_HP;
  Real uLow_HP;
  Real uHigh_Heater;
  Real uLow_Heater;
  Real uSet_HP;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

public
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=180,
        origin={70,34})));
  Modelica.Blocks.Sources.RealExpression zero(y=0) annotation (Placement(transformation(extent={{30,40},{48,58}})));
  Modelica.Blocks.Logical.Not Not
    annotation (Placement(transformation(extent={{-4,28},{8,40}})));
  Modelica.Blocks.Sources.RealExpression uHigh(y=uHigh_HP)
    annotation (Placement(transformation(extent={{-66,34},{-46,56}})));
  Modelica.Blocks.Sources.RealExpression uLow(y=uLow_HP)
    annotation (Placement(transformation(extent={{-66,12},{-46,34}})));
  TransiEnt.Basics.Blocks.Hysteresis_inputVariable hysteresis_HP annotation (Placement(transformation(extent={{-30,26},{-14,42}})));
  TransiEnt.Basics.Blocks.OnOffRelais onOffRelais(
    init_state=init_state,
    t_min_on=t_min_on,
    t_min_off=t_min_off) if MinTimes and not Modulating
    annotation (Placement(transformation(extent={{32,28},{44,40}})));
public
  Modelica.Blocks.Logical.Switch switch2 if  CalculatePHeater  annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=180,
        origin={71,-69})));
  Modelica.Blocks.Sources.RealExpression zero1(y=0) if  CalculatePHeater  annotation (Placement(transformation(extent={{32,-66},{50,-48}})));
  Modelica.Blocks.Sources.RealExpression P_Heater(y=P_elHeater) if  CalculatePHeater  annotation (Placement(transformation(extent={{32,-92},{50,-72}})));
  TransiEnt.Basics.Blocks.Hysteresis_inputVariable hysteresis_heater if  CalculatePHeater  annotation (Placement(transformation(extent={{-26,-76},{-10,-60}})));
  Modelica.Blocks.Sources.RealExpression uHigh1(y=uHigh_Heater) if  CalculatePHeater
    annotation (Placement(transformation(extent={{-66,-70},{-46,-48}})));
  Modelica.Blocks.Sources.RealExpression uLow1(y=uLow_Heater) if  CalculatePHeater  annotation (Placement(transformation(extent={{-66,-90},{-46,-68}})));
  Modelica.Blocks.Logical.Not Not1 if CalculatePHeater
    annotation (Placement(transformation(extent={{0,-76},{14,-62}})));
  Modelica.Blocks.Sources.RealExpression Setpoint_HP(y=uSet_HP) if Modulating annotation (Placement(transformation(extent={{-52,-28},{-34,-10}})));
  Modelica.Blocks.Continuous.LimPID PID(
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMin=0,
    k=5,
    yMax=1) if Modulating annotation (Placement(transformation(extent={{-20,-26},{-6,-12}})));
  Modelica.Blocks.Sources.RealExpression Q_flow(y=Q_flow_n)
                                                          annotation (Placement(transformation(extent={{2,-16},{18,0}})));
  Modelica.Blocks.Math.Product gain if Modulating annotation (Placement(transformation(extent={{32,-20},{46,-6}})));
equation
  // ___________________________________________________________________________
  //
  //            Characteristic equations
  // ___________________________________________________________________________

  uHigh_HP=if control_SoC then SoCHigh_HP else THigh_HP;
  uLow_HP=if control_SoC then SoCLow_HP else TLow_HP;
  uHigh_Heater=if control_SoC then SoCHigh_Heater else THigh_Heater;
  uLow_Heater=if control_SoC then SoCLow_Heater else TLow_Heater;
  uSet_HP=if control_SoC then SoCSet_HP else T_set;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(hysteresis_HP.y, Not.u) annotation (Line(points={{-13.2,34},{-5.2,34}},             color={255,0,255}));
  connect(uLow.y, hysteresis_HP.uLow) annotation (Line(points={{-45,23},{-40,23},{-40,27.6},{-30.8,27.6}},   color={0,0,127}));
  connect(uHigh.y, hysteresis_HP.uHigh) annotation (Line(points={{-45,45},{-45,46},{-40,46},{-40,40},{-30.48,40},{-30.48,40.4}},
                                                                                                                              color={0,0,127}));
  connect(Not.y, onOffRelais.u) annotation (Line(points={{8.6,34},{31.76,34}},
                         color={255,0,255}));
  connect(onOffRelais.y, switch1.u2) annotation (Line(points={{44.6,34},{60.4,34}},
                                  color={255,0,255}));
  connect(T, hysteresis_HP.u) annotation (Line(points={{-102,20},{-80,20},{-80,34},{-30.8,34}},
                                                                                color={0,0,127}));
  connect(switch1.y, Q_flow_set_HP) annotation (Line(points={{78.8,34},{90,34},{90,0},{108,0}}, color={0,0,127}));
  connect(switch2.y, P_set_electricHeater) annotation (Line(points={{78.7,-69},{109,-69}},           color={0,0,127}));
  connect(zero1.y, switch2.u3) annotation (Line(points={{50.9,-57},{53.45,-57},{53.45,-63.4},{62.6,-63.4}}, color={0,0,127}));
  connect(hysteresis_heater.u, T) annotation (Line(points={{-26.8,-68},{-26.8,-68},{-80,-68},{-80,20},{-102,20}},   color={0,0,127}));
  connect(uHigh1.y, hysteresis_heater.uHigh) annotation (Line(points={{-45,-59},{-36,-59},{-36,-61.6},{-26.48,-61.6}}, color={0,0,127}));
  connect(uLow1.y, hysteresis_heater.uLow) annotation (Line(points={{-45,-79},{-36,-79},{-36,-74.4},{-26.8,-74.4}}, color={0,0,127}));
  connect(hysteresis_heater.y, Not1.u) annotation (Line(points={{-9.2,-68},{-6,-68},{-6,-69},{-1.4,-69}}, color={255,0,255}));
  connect(Not1.y, switch2.u2) annotation (Line(points={{14.7,-69},{14.7,-69},{62.6,-69}}, color={255,0,255}));
  connect(zero.y, switch1.u3) annotation (Line(points={{48.9,49},{56,49},{56,40.4},{60.4,40.4}},
                                                                                               color={0,0,127}));
  connect(P_Heater.y, switch2.u1) annotation (Line(points={{50.9,-82},{56,-82},{56,-74.6},{62.6,-74.6}}, color={0,0,127}));
  connect(SoC, hysteresis_HP.u) annotation (Line(points={{-102,-20},{-80,-20},{-80,34},{-30.8,34}},
                                                                                                  color={0,0,127}));
  connect(SoC, hysteresis_heater.u) annotation (Line(points={{-102,-20},{-80,-20},{-80,-68},{-26.8,-68}}, color={0,0,127}));
  connect(Setpoint_HP.y, PID.u_s) annotation (Line(points={{-33.1,-19},{-21.4,-19}}, color={0,0,127}));
  connect(PID.y, gain.u2) annotation (Line(points={{-5.3,-19},{-4,-19},{-4,-20},{22,-20},{22,-17.2},{30.6,-17.2}}, color={0,0,127}));
  connect(Q_flow.y, gain.u1) annotation (Line(points={{18.8,-8},{30.6,-8.8}}, color={0,0,127}));
  if not Modulating then
  connect(Q_flow.y, switch1.u1) annotation (Line(points={{18.8,-8},{22,-8},{22,8},{60.4,8},{60.4,27.6}},   color={0,0,127}));
  end if;

  if not MinTimes or Modulating then
    connect(Not.y,switch1.u2);
  end if;
  connect(gain.y, switch1.u1) annotation (Line(points={{46.7,-13},{60.4,-13},{60.4,27.6}}, color={0,0,127}));
  connect(SoC, PID.u_m) annotation (Line(points={{-102,-20},{-80,-20},{-80,-32},{-13,-32},{-13,-27.4}}, color={0,0,127}));
  connect(T, PID.u_m) annotation (Line(points={{-102,20},{-80,20},{-80,-32},{-13,-32},{-13,-27.4}},                   color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>Controller model to set electric input power for heat pump and electric heater as well as heat pump temperature according to storage tank level or storage tank temperature.</p>
<p>For bivalent operation, electric heater produces heat with constant power and operates additionally to heatpump if minimum temperatur cannot be achieved with heatpump alone.</p>
<p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">4. Interfaces</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">5. Nomenclature</span></b></p>
<p>(no elements)</p>
<p><b><span style=\"color: #008000;\">6. Governing Equations</span></b></p>
<p>(no equations)</p>
<p><b><span style=\"color: #008000;\">7. Remarks for Usage</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">8. Validation</span></b></p>
<p>(no validation or testing necessary)</p>
<p><b><span style=\"color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">10. Version History</span></b></p>
<p>Created by Anne Hagemeier (anne.hagemeier@umsicht.fraunhofer.de), June 2018</p>
</html>"));
end ControlHeatpump_heatdriven_BVheatLoad;
