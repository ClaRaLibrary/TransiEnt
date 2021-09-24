within TransiEnt.Producer.Combined.SmallScaleCHP.SmallScaleCHP_simple.Control;
model ControlBoilerCHP_modulatingBoiler_PriceLed "Simple controller for a price driven CHP system with modulating boiler based on SoC or temperature of a heat storage"


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




  extends TransiEnt.Producer.Combined.SmallScaleCHP.SmallScaleCHP_simple.Control.Base.ControlBoilerCHP_Base;
  extends TransiEnt.Basics.Icons.Controller;
  outer TransiEnt.SimCenter simCenter;

  //___________________________________________________________________________
  //
  //                      Parameters
  //___________________________________________________________________________

  parameter SI.Temperature TLow_CHP=354.15 "Storage charging level for CHP switch on " annotation (Dialog(group="Temperature limits", enable=not control_SoC));
  parameter SI.Temperature THigh_CHP=359.15 "Storage charging level for CHP switch off" annotation (Dialog(group="Temperature limits", enable=not control_SoC));

  parameter SI.Temperature TLow_Boiler=351.15 "Storage charging level for boiler switch on" annotation (Dialog(group="Temperature limits", enable=not control_SoC));
  parameter SI.Temperature THigh_Boiler=355.15 "Storage charging level for boiler switch off" annotation (Dialog(group="Temperature limits", enable=not control_SoC));
  parameter SI.Temperature Tset_Boiler=355.15 "Charging level setpoint for boiler operation" annotation (Dialog(group="Temperature limits", enable=not control_SoC));

  parameter Real SoCLow_CHP=0.55 "SoC limit to switch on the CHP" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SoCHigh_CHP=0.8 "SoC limit to switch off the CHP" annotation (Dialog(group="SoC limits", enable=control_SoC));

  parameter Real SoCLow_Boiler=0.4 "SoC limit to switch on the boiler" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SoCHigh_Boiler=0.6 "SoC limit to switch off the boiler" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SOCset_Boiler=0.5 "Storage temperature setpoint for boiler operation" annotation (Dialog(group="SoC limits"));

  parameter Real t_min_on_CHP=3600 "Minimum on time after startup of the CHP" annotation (Dialog(group="Controller parameters"));
  parameter Real t_min_off_CHP=3600 "Minimum off time after shutdown of the CHP" annotation (Dialog(group="Controller parameters"));

  parameter Real Price_Threshold(unit="€/Kwh") = 0.05 "Price limit for the operation of the CHP" annotation (Dialog(group="Controller parameters"));

  //___________________________________________________________________________
  //
  //                      Variables
  //___________________________________________________________________________

  Real uHigh_CHP;
  Real uLow_CHP;
  Real uHigh_Boiler;
  Real uLow_Boiler;
  Real uset_Boiler;

  // __________________________________________________________________________
  //
  //                   Complex Components
  // ___________________________________________________________________________

  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=180,
        origin={72,48})));
  Modelica.Blocks.Sources.RealExpression zero(y=0) annotation (Placement(transformation(extent={{30,56},{48,74}})));
  Modelica.Blocks.Logical.Not Not annotation (Placement(transformation(extent={{-12,42},{0,54}})));
  Modelica.Blocks.Sources.RealExpression uHigh(y=uHigh_CHP) annotation (Placement(transformation(extent={{-72,46},{-52,68}})));
  Modelica.Blocks.Sources.RealExpression uLow(y=uLow_CHP) annotation (Placement(transformation(extent={{-72,26},{-52,48}})));
  TransiEnt.Basics.Blocks.Hysteresis_inputVariable hysteresis_CHP annotation (Placement(transformation(extent={{-34,40},{-18,56}})));
  TransiEnt.Basics.Blocks.OnOffRelais onOffRelais(
    init_state=2,
    t_min_on=t_min_on_CHP,
    t_min_off=t_min_off_CHP) annotation (Placement(transformation(extent={{38,42},{50,54}})));
  Modelica.Blocks.Sources.RealExpression Q_CHP1(y=Q_n_CHP) annotation (Placement(transformation(extent={{30,12},{48,30}})));
  TransiEnt.Basics.Blocks.Hysteresis_inputVariable hysteresis_boiler annotation (Placement(transformation(extent={{-34,-8},{-18,8}})));
  Modelica.Blocks.Sources.RealExpression uHigh1(y=uHigh_Boiler) annotation (Placement(transformation(extent={{-72,-2},{-52,20}})));
  Modelica.Blocks.Sources.RealExpression uLow1(y=uLow_Boiler) annotation (Placement(transformation(extent={{-72,-22},{-52,0}})));
  Modelica.Blocks.Logical.Not Not1 annotation (Placement(transformation(extent={{-10,-6},{2,6}})));
  Modelica.Blocks.Sources.RealExpression max_Storage_Heat(y=uset_Boiler) annotation (Placement(transformation(extent={{-68,-72},{-46,-52}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(k=1) annotation (Placement(transformation(extent={{-66,-88},{-54,-76}})));
  Modelica.Blocks.Continuous.LimPID PID(
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMax=Q_n_Boiler,
    k=Q_n_Boiler,
    yMin=0,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=Q_n_Boiler) annotation (Placement(transformation(extent={{-16,-76},{0,-60}})));
  Modelica.Blocks.Logical.Switch switch3 annotation (Placement(transformation(
        extent={{9,-9},{-9,9}},
        rotation=180,
        origin={71,-51})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=0) annotation (Placement(transformation(extent={{34,-30},{48,-14}})));
  Modelica.Blocks.Sources.RealExpression electricityPrice(y=simCenter.electricityPrice.y1) annotation (Placement(transformation(extent={{-74,82},{-54,104}})));
  Modelica.Blocks.Logical.GreaterThreshold hysteresis(threshold=Price_Threshold) annotation (Placement(transformation(extent={{-16,78},{0,94}})));
  Modelica.Blocks.Logical.And and2 annotation (Placement(transformation(extent={{16,54},{28,42}})));

equation

  uHigh_CHP = if control_SoC then SoCHigh_CHP else THigh_CHP;
  uLow_CHP = if control_SoC then SoCLow_CHP else TLow_CHP;
  uHigh_Boiler = if control_SoC then SoCHigh_Boiler else THigh_Boiler;
  uLow_Boiler = if control_SoC then SoCLow_Boiler else TLow_Boiler;
  uset_Boiler = if control_SoC then SOCset_Boiler else Tset_Boiler;

  connect(hysteresis_CHP.y, Not.u) annotation (Line(points={{-17.2,48},{-13.2,48}}, color={255,0,255}));
  connect(uLow.y, hysteresis_CHP.uLow) annotation (Line(points={{-51,37},{-38,37},{-38,42},{-34.8,42},{-34.8,41.6}}, color={0,0,127}));
  connect(uHigh.y, hysteresis_CHP.uHigh) annotation (Line(points={{-51,57},{-52,57},{-52,58},{-40,58},{-40,54.4},{-34.48,54.4}}, color={0,0,127}));
  connect(Q_CHP1.y, switch1.u1) annotation (Line(points={{48.9,21},{54,21},{54,41.6},{62.4,41.6}}, color={0,0,127}));
  connect(onOffRelais.y, switch1.u2) annotation (Line(points={{50.6,48},{62.4,48}}, color={255,0,255}));
  connect(uHigh1.y, hysteresis_boiler.uHigh) annotation (Line(points={{-51,9},{-42,9},{-42,6.4},{-34.48,6.4}}, color={0,0,127}));
  connect(uLow1.y, hysteresis_boiler.uLow) annotation (Line(points={{-51,-11},{-42,-11},{-42,-6.4},{-34.8,-6.4}}, color={0,0,127}));
  connect(hysteresis_boiler.y, Not1.u) annotation (Line(points={{-17.2,0},{-11.2,0}}, color={255,0,255}));
  connect(zero.y, switch1.u3) annotation (Line(points={{48.9,65},{52,65},{52,54.4},{62.4,54.4}}, color={0,0,127}));
  connect(T, hysteresis_CHP.u) annotation (Line(points={{-102,20},{-82,20},{-82,48},{-34.8,48}}, color={0,0,127}));
  connect(SoC, hysteresis_CHP.u) annotation (Line(points={{-102,-20},{-82,-20},{-82,48},{-34.8,48}}, color={0,0,127}));
  connect(SoC, hysteresis_boiler.u) annotation (Line(points={{-102,-20},{-82,-20},{-82,0},{-34.8,0}}, color={0,0,127}));
  connect(T, hysteresis_boiler.u) annotation (Line(points={{-102,20},{-82,20},{-82,0},{-34.8,0}}, color={0,0,127}));
  connect(switch1.y, Q_flow_set_CHP) annotation (Line(points={{80.8,48},{108,48}}, color={0,0,127}));
  connect(SoC, firstOrder1.u) annotation (Line(points={{-102,-20},{-82,-20},{-82,-82},{-67.2,-82}}, color={0,0,127}));
  connect(firstOrder1.y, PID.u_m) annotation (Line(points={{-53.4,-82},{-8,-82},{-8,-77.6}}, color={0,0,127}));
  connect(max_Storage_Heat.y, PID.u_s) annotation (Line(points={{-44.9,-62},{-32,-62},{-32,-68},{-17.6,-68}}, color={0,0,127}));
  connect(PID.y, switch3.u1) annotation (Line(points={{0.8,-68},{54,-68},{54,-58},{60,-58},{60,-58.2},{60.2,-58.2}}, color={0,0,127}));
  connect(realExpression.y, switch3.u3) annotation (Line(points={{48.7,-22},{54,-22},{54,-36},{60.2,-36},{60.2,-43.8}}, color={0,0,127}));
  connect(switch3.y, Q_flow_set_boiler) annotation (Line(points={{80.9,-51},{109,-51}}, color={0,0,127}));
  connect(Not.y, and2.u1) annotation (Line(points={{0.6,48},{14.8,48}}, color={255,0,255}));
  connect(and2.y, onOffRelais.u) annotation (Line(points={{28.6,48},{37.76,48}}, color={255,0,255}));
  connect(hysteresis.y, and2.u2) annotation (Line(points={{0.8,86},{8,86},{8,52.8},{14.8,52.8}}, color={255,0,255}));
  connect(electricityPrice.y, hysteresis.u) annotation (Line(points={{-53,93},{-22,93},{-22,86},{-17.6,86}}, color={0,0,127}));
  connect(Not1.y, switch3.u2) annotation (Line(points={{2.6,0},{30,0},{30,-51},{60.2,-51}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>Controller for the operation of a CHP unit and a boiler. CHP is operated only if electricity prices are above a threshold value and if storage tank is not full. </p>
<p>The boiler will switch on additionally if the storage tank state of charge drops below threshold value. The boiler has a modulating power output so that the storage tank level stays at set point value.</p>
<p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">4. Interfaces</span></b></p>
<p>Modelica.Blocks.Interfaces.RealInput SoC</p>
<p>Modelica.Blocks.Interfaces.BooleanOutput toCHP</p>
<p>TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut toBoiler</p>
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
<p>Model created by Yousef Omran, Fraunhofer UMSICHT, 2017</p>
<p>Model revised by Anne Hagemeier, Fraunhofer UMSICHT, 2018 and 2021</p>
</html>"));
end ControlBoilerCHP_modulatingBoiler_PriceLed;
