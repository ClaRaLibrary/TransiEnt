within TransiEnt.Producer.Combined.SmallScaleCHP.SmallScaleCHP_simple.Control;
model Control_BoilerCHP_simple_HeatLed "Simple 2-point-controller for a heat led CHP system based on SoC or temperature of a heat storage"



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





  extends TransiEnt.Producer.Combined.SmallScaleCHP.SmallScaleCHP_simple.Control.Base.ControlBoilerCHP_Base;
  extends TransiEnt.Basics.Icons.Controller;

  //___________________________________________________________________________
  //
  //                      Parameters
  //___________________________________________________________________________

  parameter SI.Temperature TLow_CHP=353.15 "Storage charging level for CHP switch on" annotation (Dialog(group="Temperature limits"));
  parameter SI.Temperature THigh_CHP=357.15 "Storage charging level for CHP switch off" annotation (Dialog(group="Temperature limits"));

  parameter SI.Temperature TLow_Boiler=347.15 "Storage charging level for boiler switch on" annotation (Dialog(group="Temperature limits"));
  parameter SI.Temperature THigh_Boiler=355.15 "Storage charging level for boiler switch off" annotation (Dialog(group="Temperature limits"));

  parameter Real SoCLow_CHP=0.5 "SoC limit to switch on the CHP" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SoCHigh_CHP=1 "SoC limit to switch off the CHP" annotation (Dialog(group="SoC limits", enable=control_SoC));

  parameter Real SoCLow_Boiler=0.2 "SoC limit to switch on the boiler" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SoCHigh_Boiler=0.7 "SoC limit to switch off the boiler" annotation (Dialog(group="SoC limits", enable=control_SoC));

  parameter Real t_min_on_CHP=3600 "Minimum on time after startup of the CHP" annotation (Dialog(group="Controller parameters"));
  parameter Real t_min_off_CHP=3600 "Minimum off time after shutdown of the CHP" annotation (Dialog(group="Controller parameters"));

  //___________________________________________________________________________
  //
  //                      Variables
  //___________________________________________________________________________

  Real uHigh_CHP;
  Real uLow_CHP;
  Real uHigh_Boiler;
  Real uLow_Boiler;

  // __________________________________________________________________________
  //
  //                   Complex Components
  // ___________________________________________________________________________

  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=180,
        origin={72,48})));
  Modelica.Blocks.Sources.RealExpression zero(y=0) annotation (Placement(transformation(extent={{32,54},{50,72}})));
  Modelica.Blocks.Logical.Not Not annotation (Placement(transformation(extent={{-2,42},{10,54}})));

  Modelica.Blocks.Sources.RealExpression uHigh(y=uHigh_CHP) annotation (Placement(transformation(extent={{-64,48},{-44,70}})));
  Modelica.Blocks.Sources.RealExpression uLow(y=uLow_CHP) annotation (Placement(transformation(extent={{-64,26},{-44,48}})));
  TransiEnt.Basics.Blocks.Hysteresis_inputVariable hysteresis_HP annotation (Placement(transformation(extent={{-28,40},{-12,56}})));
  TransiEnt.Basics.Blocks.OnOffRelais onOffRelais(
    init_state=2,
    t_min_on=t_min_on_CHP,
    t_min_off=t_min_off_CHP) annotation (Placement(transformation(extent={{34,42},{46,54}})));
  Modelica.Blocks.Sources.RealExpression Q_CHP(y=Q_n_CHP) annotation (Placement(transformation(extent={{32,18},{50,36}})));

  Modelica.Blocks.Logical.Switch switch2 annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=180,
        origin={71,-51})));
  Modelica.Blocks.Sources.RealExpression zero1(y=0) annotation (Placement(transformation(extent={{32,-48},{50,-30}})));
  Modelica.Blocks.Sources.RealExpression Q_Boiler(y=Q_n_Boiler) annotation (Placement(transformation(extent={{32,-80},{50,-60}})));
  TransiEnt.Basics.Blocks.Hysteresis_inputVariable hysteresis_heater annotation (Placement(transformation(extent={{-26,-58},{-10,-42}})));
  Modelica.Blocks.Sources.RealExpression uHigh1(y=uHigh_Boiler) annotation (Placement(transformation(extent={{-66,-52},{-46,-30}})));
  Modelica.Blocks.Sources.RealExpression uLow1(y=uLow_Boiler) annotation (Placement(transformation(extent={{-66,-72},{-46,-50}})));
  Modelica.Blocks.Logical.Not Not1 annotation (Placement(transformation(extent={{0,-58},{14,-44}})));

equation

  uHigh_CHP = if control_SoC then SoCHigh_CHP else THigh_CHP;
  uLow_CHP = if control_SoC then SoCLow_CHP else TLow_CHP;
  uHigh_Boiler = if control_SoC then SoCHigh_Boiler else THigh_Boiler;
  uLow_Boiler = if control_SoC then SoCLow_Boiler else TLow_Boiler;

  connect(hysteresis_HP.y,Not. u) annotation (Line(points={{-11.2,48},{-3.2,48}},             color={255,0,255}));
  connect(uLow.y,hysteresis_HP. uLow) annotation (Line(points={{-43,37},{-38,37},{-38,41.6},{-28.8,41.6}},   color={0,0,127}));
  connect(uHigh.y,hysteresis_HP. uHigh) annotation (Line(points={{-43,59},{-43,60},{-38,60},{-38,54},{-28.48,54},{-28.48,54.4}},
                                                                                                                              color={0,0,127}));
  connect(Not.y,onOffRelais. u) annotation (Line(points={{10.6,48},{33.76,48}},
                         color={255,0,255}));
  connect(Q_CHP.y, switch1.u1) annotation (Line(points={{50.9,27},{58,27},{58,41.6},{62.4,41.6}},   color={0,0,127}));
  connect(onOffRelais.y,switch1. u2) annotation (Line(points={{46.6,48},{62.4,48}},
                                  color={255,0,255}));
  connect(zero1.y,switch2. u3) annotation (Line(points={{50.9,-39},{53.45,-39},{53.45,-45.4},{62.6,-45.4}}, color={0,0,127}));
  connect(uHigh1.y,hysteresis_heater. uHigh) annotation (Line(points={{-45,-41},{-36,-41},{-36,-43.6},{-26.48,-43.6}}, color={0,0,127}));
  connect(uLow1.y,hysteresis_heater. uLow) annotation (Line(points={{-45,-61},{-36,-61},{-36,-56.4},{-26.8,-56.4}}, color={0,0,127}));
  connect(hysteresis_heater.y,Not1. u) annotation (Line(points={{-9.2,-50},{-6,-50},{-6,-51},{-1.4,-51}}, color={255,0,255}));
  connect(Not1.y,switch2. u2) annotation (Line(points={{14.7,-51},{62.6,-51}},            color={255,0,255}));
  connect(zero.y,switch1. u3) annotation (Line(points={{50.9,63},{58,63},{58,54.4},{62.4,54.4}},
                                                                                               color={0,0,127}));

  connect(Q_Boiler.y, switch2.u1) annotation (Line(points={{50.9,-70},{62.6,-70},{62.6,-56.6}}, color={0,0,127}));

  connect(T, hysteresis_HP.u) annotation (Line(points={{-102,20},{-82,20},{-82,48},{-28.8,48}},
                                                                                              color={0,0,127}));
  connect(SoC, hysteresis_HP.u) annotation (Line(points={{-102,-20},{-82,-20},{-82,48},{-28.8,48}},
                                                                                                  color={0,0,127}));
  connect(SoC, hysteresis_heater.u) annotation (Line(points={{-102,-20},{-82,-20},{-82,-50},{-26.8,-50}}, color={0,0,127}));
  connect(T, hysteresis_heater.u) annotation (Line(points={{-102,20},{-82,20},{-82,-50},{-26.8,-50}}, color={0,0,127}));
  connect(switch2.y, Q_flow_set_boiler) annotation (Line(points={{78.7,-51},{109,-51}},           color={0,0,127}));
  connect(switch1.y, Q_flow_set_CHP) annotation (Line(points={{80.8,48},{108,48}},             color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>Controller for the operation of a CHP unit and a boiler. CHP is operated at constant heat output as long as the storage tank is not full. </p>
<p>The boiler will switch on additionally with a fixed power output if the storage tank state of charge drops below threshold value.</p>
<p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">4. Interfaces</span></b></p>
<p>Modelica.Blocks.Interfaces.RealInput SoC</p>
<p>TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_set_CHP</p>
<p>TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_set_boiler</p>
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
<p>Model created by Emil Dierkes, Fraunhofer UMSICHT, 2021</p>
<p>Model revised by Anne Hagemeier, Fraunhofer UMSICHT, 2021</p>
</html>"));
end Control_BoilerCHP_simple_HeatLed;
