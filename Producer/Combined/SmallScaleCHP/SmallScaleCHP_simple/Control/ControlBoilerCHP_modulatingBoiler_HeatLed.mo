within TransiEnt.Producer.Combined.SmallScaleCHP.SmallScaleCHP_simple.Control;
model ControlBoilerCHP_modulatingBoiler_HeatLed "Simple controller for a heat led CHP system with modulating boiler based on SoC or temperature of a heat storage"



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

  parameter SI.Temperature TLow_CHP=354.15 "Storage charging level for CHP switch on" annotation (Dialog(group="Temperature limits"));
  parameter SI.Temperature THigh_CHP=359.15 "Storage charging level for CHP switch off" annotation (Dialog(group="Temperature limits"));

  parameter SI.Temperature TLow_Boiler=351.15 "Storage charging level for boiler switch on" annotation (Dialog(group="Temperature limits"));
  parameter SI.Temperature THigh_Boiler=355.15 "Storage charging level for boiler switch off" annotation (Dialog(group="Temperature limits"));
  parameter SI.Temperature Tset_Boiler=355.15 "Charging level setpoint for boiler operation" annotation (Dialog(group="Temperature limits"));

  parameter Real SoCLow_CHP=0.55 "SoC limit to switch on the CHP" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SoCHigh_CHP=0.8 "SoC limit to switch off the CHP" annotation (Dialog(group="SoC limits", enable=control_SoC));

  parameter Real SoCLow_Boiler=0.4 "SoC limit to switch on the boiler" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SoCHigh_Boiler=0.6 "SoC limit to switch off the boiler" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SOCset_Boiler=0.5 "Storage temperature setpoint for boiler operation" annotation (Dialog(group="SoC limits"));

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
  Real uset_Boiler;

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
  TransiEnt.Basics.Blocks.Hysteresis_inputVariable hysteresis_CHP annotation (Placement(transformation(extent={{-28,40},{-12,56}})));
  TransiEnt.Basics.Blocks.OnOffRelais onOffRelais(
    init_state=2,
    t_min_on=t_min_on_CHP,
    t_min_off=t_min_off_CHP) annotation (Placement(transformation(extent={{32,42},{44,54}})));
  Modelica.Blocks.Sources.RealExpression Q_CHP(y=Q_n_CHP) annotation (Placement(transformation(extent={{32,18},{50,36}})));

  TransiEnt.Basics.Blocks.Hysteresis_inputVariable hysteresis_boiler annotation (Placement(transformation(extent={{-30,-14},{-14,2}})));
  Modelica.Blocks.Sources.RealExpression uHigh1(y=uHigh_Boiler) annotation (Placement(transformation(extent={{-66,-8},{-46,14}})));
  Modelica.Blocks.Sources.RealExpression uLow1(y=uLow_Boiler) annotation (Placement(transformation(extent={{-66,-28},{-46,-6}})));
  Modelica.Blocks.Logical.Not Not1 annotation (Placement(transformation(extent={{-4,-12},{8,0}})));

  Modelica.Blocks.Sources.RealExpression max_Storage_Heat(y=uset_Boiler) annotation (Placement(transformation(extent={{-62,-78},{-40,-58}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(k=1) annotation (Placement(transformation(extent={{-60,-94},{-48,-82}})));
  Modelica.Blocks.Continuous.LimPID PID(
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMax=Q_n_Boiler,
    k=Q_n_Boiler,
    yMin=0,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=Q_n_Boiler) annotation (Placement(transformation(extent={{-10,-82},{6,-66}})));

  Modelica.Blocks.Logical.Switch switch3 annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=180,
        origin={76,-50})));
  Modelica.Blocks.Logical.And and1 annotation (Placement(transformation(extent={{36,-58},{52,-42}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=0) annotation (Placement(transformation(extent={{40,-36},{54,-20}})));

equation

  uHigh_CHP = if control_SoC then SoCHigh_CHP else THigh_CHP;
  uLow_CHP = if control_SoC then SoCLow_CHP else TLow_CHP;
  uHigh_Boiler = if control_SoC then SoCHigh_Boiler else THigh_Boiler;
  uLow_Boiler = if control_SoC then SoCLow_Boiler else TLow_Boiler;
  uset_Boiler = if control_SoC then SOCset_Boiler else Tset_Boiler;

  connect(hysteresis_CHP.y, Not.u) annotation (Line(points={{-11.2,48},{-3.2,48}}, color={255,0,255}));
  connect(uLow.y, hysteresis_CHP.uLow) annotation (Line(points={{-43,37},{-38,37},{-38,41.6},{-28.8,41.6}}, color={0,0,127}));
  connect(uHigh.y, hysteresis_CHP.uHigh) annotation (Line(points={{-43,59},{-43,60},{-38,60},{-38,54},{-28.48,54},{-28.48,54.4}}, color={0,0,127}));
  connect(Not.y,onOffRelais. u) annotation (Line(points={{10.6,48},{31.76,48}},
                         color={255,0,255}));
  connect(Q_CHP.y, switch1.u1) annotation (Line(points={{50.9,27},{58,27},{58,41.6},{62.4,41.6}},   color={0,0,127}));
  connect(onOffRelais.y,switch1. u2) annotation (Line(points={{44.6,48},{62.4,48}},
                                  color={255,0,255}));
  connect(uHigh1.y,hysteresis_boiler. uHigh) annotation (Line(points={{-45,3},{-36,3},{-36,0.4},{-30.48,0.4}},         color={0,0,127}));
  connect(uLow1.y,hysteresis_boiler. uLow) annotation (Line(points={{-45,-17},{-36,-17},{-36,-12.4},{-30.8,-12.4}}, color={0,0,127}));
  connect(hysteresis_boiler.y,Not1. u) annotation (Line(points={{-13.2,-6},{-5.2,-6}},                    color={255,0,255}));
  connect(zero.y,switch1. u3) annotation (Line(points={{50.9,63},{58,63},{58,54.4},{62.4,54.4}},
                                                                                               color={0,0,127}));

  connect(T, hysteresis_CHP.u) annotation (Line(points={{-102,20},{-82,20},{-82,48},{-28.8,48}}, color={0,0,127}));
  connect(SoC, hysteresis_CHP.u) annotation (Line(points={{-102,-20},{-82,-20},{-82,48},{-28.8,48}}, color={0,0,127}));
  connect(SoC,hysteresis_boiler. u) annotation (Line(points={{-102,-20},{-82,-20},{-82,-6},{-30.8,-6}},   color={0,0,127}));
  connect(T,hysteresis_boiler. u) annotation (Line(points={{-102,20},{-82,20},{-82,-6},{-30.8,-6}},   color={0,0,127}));
  connect(switch1.y, Q_flow_set_CHP) annotation (Line(points={{80.8,48},{108,48}},             color={0,0,127}));
  connect(SoC, firstOrder1.u) annotation (Line(points={{-102,-20},{-84,-20},{-84,-88},{-61.2,-88}}, color={0,0,127}));
  connect(firstOrder1.y, PID.u_m) annotation (Line(points={{-47.4,-88},{-2,-88},{-2,-83.6}}, color={0,0,127}));
  connect(max_Storage_Heat.y, PID.u_s) annotation (Line(points={{-38.9,-68},{-26,-68},{-26,-74},{-11.6,-74}}, color={0,0,127}));
  connect(PID.y, switch3.u1) annotation (Line(points={{6.8,-74},{60,-74},{60,-56},{66,-56},{66,-56.4},{66.4,-56.4}}, color={0,0,127}));
  connect(and1.y, switch3.u2) annotation (Line(points={{52.8,-50},{66.4,-50}}, color={255,0,255}));
  connect(realExpression.y, switch3.u3) annotation (Line(points={{54.7,-28},{60,-28},{60,-42},{66.4,-42},{66.4,-43.6}}, color={0,0,127}));
  connect(switch3.y, Q_flow_set_boiler) annotation (Line(points={{84.8,-50},{109,-51}}, color={0,0,127}));
  connect(Not1.y, and1.u2) annotation (Line(points={{8.6,-6},{22,-6},{22,-56.4},{34.4,-56.4}}, color={255,0,255}));
  connect(Not.y, and1.u1) annotation (Line(points={{10.6,48},{24,48},{24,-46},{34.4,-46},{34.4,-50}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>Controller for the operation of a CHP unit and a boiler. CHP is operated at constant heat output as long as the storage tank is not full. </p>
<p>The boiler will switch on additionally if the storage tank state of charge drops below threshold value. The boiler has a modulating power output so that the storage tank level stays at set point value.</p>
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
<p>Model created by Yousef Omran, Fraunhofer UMSICHT, 2017</p>
<p>Model revised by Anne Hagemeier, Fraunhofer UMSICHT, 2018 and 2021</p>
</html>"));
end ControlBoilerCHP_modulatingBoiler_HeatLed;
