within TransiEnt.Consumer.Systems.HouseholdEnergyConverter.Systems.Control_elHeater;
model ElectricHeater_PV_oriented "operation preferably when excess PV energy available"


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




  extends TransiEnt.Consumer.Systems.HouseholdEnergyConverter.Systems.Control_elHeater.Base.Controller_elHeater;
  extends TransiEnt.Basics.Icons.Controller;

  //___________________________________________________________________________
  //
  //                      Parameters
  //___________________________________________________________________________

  parameter Real uLow_Boiler=0.4 "Lower SOC limit";
  parameter Real uHigh_Boiler=0.8 "Upper SOC limit to switch off the boiler";

  parameter Real uSet_Boiler=0.7 "SOC Setpoint for boiler operation ";

  parameter Real uLow_Heater=0.6 "Lower SOC limit to switch on the heater";
  parameter Real uHigh_Heater=1 "Upper SOC limit to switch off the heater";

  parameter Real Threshold=0.5 "Threshold of PV infeed power to start heater operation";

  parameter SI.Power P_elHeater=3000 "Nominal electrical power of the electrical heater";
  parameter SI.Power Q_flow_n_boiler=10000 "Nominal electrical power of the gas boiler";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=180,
        origin={83,37})));
  Modelica.Blocks.Sources.RealExpression zero(y=0) annotation (Placement(transformation(extent={{54,34},{70,50}})));
  Modelica.Blocks.Logical.And and1 annotation (Placement(transformation(extent={{14,-56},{26,-44}})));
  Modelica.Blocks.Logical.Greater greaterThreshold annotation (Placement(transformation(extent={{-36,-28},{-24,-16}})));
  Modelica.Blocks.Sources.RealExpression P_n(y=Threshold) annotation (Placement(transformation(extent={{-72,-44},{-58,-30}})));

  Modelica.Blocks.Sources.RealExpression uHigh2(y=uHigh_Boiler) annotation (Placement(transformation(extent={{-18,72},{-1,88}})));
  Modelica.Blocks.Sources.RealExpression uLow2(y=uLow_Boiler) annotation (Placement(transformation(extent={{-18,58},{-2,74}})));
  TransiEnt.Basics.Blocks.Hysteresis_inputVariable hysteresis_Boiler annotation (Placement(transformation(extent={{10,66},{26,82}})));
  Modelica.Blocks.Logical.Not not2 annotation (Placement(transformation(extent={{32,68},{46,82}})));

  Modelica.Blocks.Sources.RealExpression uHigh3(y=uHigh_Heater) annotation (Placement(transformation(extent={{-68,-80},{-52,-66}})));
  Modelica.Blocks.Sources.RealExpression uLow3(y=uLow_Heater) annotation (Placement(transformation(extent={{-62,-96},{-48,-84}})));
  TransiEnt.Basics.Blocks.Hysteresis_inputVariable hysteresis_heater annotation (Placement(transformation(extent={{-36,-90},{-22,-76}})));
  Modelica.Blocks.Logical.Not Not1 annotation (Placement(transformation(extent={{-12,-90},{2,-76}})));
  Modelica.Blocks.Sources.RealExpression zero1(y=0) annotation (Placement(transformation(extent={{36,-80},{50,-64}})));
  Modelica.Blocks.Sources.RealExpression P_Heater(y=P_elHeater) annotation (Placement(transformation(extent={{36,-100},{50,-84}})));
  Modelica.Blocks.Logical.Switch switch3 annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=180,
        origin={67,-81})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(k=1) annotation (Placement(transformation(extent={{-16,10},{-4,22}})));
  Modelica.Blocks.Sources.RealExpression Setpoint(y=uSet_Boiler) annotation (Placement(transformation(extent={{-24,34},{-8,50}})));
  Modelica.Blocks.Continuous.LimPID PID(
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMin=0,
    k=5,
    yMax=1) annotation (Placement(transformation(extent={{2,30},{14,42}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_boiler(y=Q_flow_n_boiler) annotation (Placement(transformation(extent={{10,6},{24,20}})));
  Modelica.Blocks.Math.Product gain1 annotation (Placement(transformation(extent={{30,26},{42,38}})));
equation
  // ___________________________________________________________________________
  //
  //            Connect statements
  // ___________________________________________________________________________
  connect(greaterThreshold.y, and1.u1) annotation (Line(points={{-23.4,-22},{-12,-22},{-12,-28},{-12,-50},{12.8,-50}}, color={255,0,255}));
  connect(hysteresis_Boiler.y, not2.u) annotation (Line(points={{26.8,74},{32,74},{32,75},{30.6,75}}, color={255,0,255}));
  connect(uHigh2.y, hysteresis_Boiler.uHigh) annotation (Line(points={{-0.15,80},{5.275,80},{5.275,80.4},{9.52,80.4}}, color={0,0,127}));
  connect(uLow2.y, hysteresis_Boiler.uLow) annotation (Line(points={{-1.2,66},{6.775,66},{6.775,67.6},{9.2,67.6}}, color={0,0,127}));
  connect(switch1.y, Q_flow_set_boiler) annotation (Line(points={{90.7,37},{90.7,36},{94,36},{94,48},{104,48},{104,47},{109,47}}, color={0,0,127}));
  connect(zero.y, switch1.u3) annotation (Line(points={{70.8,42},{70,42},{70,42.6},{74.6,42.6}}, color={0,0,127}));
  connect(PV_excess, greaterThreshold.u1) annotation (Line(points={{-50,102},{-50,102},{-50,78},{-76,78},{-76,-22},{-37.2,-22}}, color={0,127,127}));
  connect(zero1.y, switch3.u3) annotation (Line(points={{50.7,-72},{53.45,-72},{53.45,-75.4},{58.6,-75.4}}, color={0,0,127}));
  connect(P_Heater.y, switch3.u1) annotation (Line(points={{50.7,-92},{50.7,-92},{52,-92},{52,-90},{52,-88},{52,-88.4},{58.6,-88.4},{58.6,-86.6}}, color={0,0,127}));
  connect(uLow3.y, hysteresis_heater.uLow) annotation (Line(points={{-47.3,-90},{-44,-90},{-44,-88.6},{-36.7,-88.6}}, color={0,0,127}));
  connect(uHigh3.y, hysteresis_heater.uHigh) annotation (Line(points={{-51.2,-73},{-50,-73},{-50,-77.4},{-36.42,-77.4}}, color={0,0,127}));
  connect(switch3.y, P_set_electricHeater) annotation (Line(points={{74.7,-81},{88,-81},{88,-69},{109,-69}}, color={0,0,127}));
  connect(hysteresis_heater.y, Not1.u) annotation (Line(points={{-21.3,-83},{-13.4,-83}}, color={255,0,255}));
  connect(Setpoint.y, PID.u_s) annotation (Line(points={{-7.2,42},{-7.2,36},{0.8,36}}, color={0,0,127}));
  connect(PID.y, gain1.u1) annotation (Line(points={{14.6,36},{18,36},{18,35.6},{28.8,35.6}}, color={0,0,127}));
  connect(Q_flow_boiler.y, gain1.u2) annotation (Line(points={{24.7,13},{28,13},{28,28.4},{28.8,28.4}}, color={0,0,127}));
  connect(firstOrder1.y, PID.u_m) annotation (Line(points={{-3.4,16},{2,16},{8,16},{8,28.8}}, color={0,0,127}));
  connect(gain1.y, switch1.u1) annotation (Line(points={{42.6,32},{48,32},{48,31.4},{74.6,31.4}}, color={0,0,127}));
  connect(Not1.y, and1.u2) annotation (Line(points={{2.7,-83},{12,-83},{12,-54.8},{12.8,-54.8}}, color={255,0,255}));
  connect(and1.y, switch3.u2) annotation (Line(points={{26.6,-50},{32,-50},{32,-81},{58.6,-81}}, color={255,0,255}));
  connect(not2.y, switch1.u2) annotation (Line(points={{46.7,75},{46.7,75},{52,75},{52,37},{74.6,37}}, color={255,0,255}));
  connect(hysteresis_Boiler.u, SoC) annotation (Line(points={{9.2,74},{9.2,74},{-70,74},{-70,0},{-104,0}}, color={0,0,127}));
  connect(firstOrder1.u, SoC) annotation (Line(points={{-17.2,16},{-17.2,16},{-34,16},{-34,0},{-104,0}}, color={0,0,127}));
  connect(hysteresis_heater.u, SoC) annotation (Line(points={{-36.7,-83},{-36.7,-83},{-82,-83},{-82,0},{-104,0}}, color={0,0,127}));
  connect(P_n.y, greaterThreshold.u2) annotation (Line(points={{-57.3,-37},{-46,-37},{-46,-26.8},{-37.2,-26.8}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-74,-12},{-22,-46}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-72,-6},{-24,-14}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          textString="Check if sufficient excess PV"),
        Rectangle(
          extent={{-22,88},{48,58}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-22,94},{50,92}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          textString="SoC Threshold for boiler"),
        Rectangle(
          extent={{-74,-62},{10,-98}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-68,-58},{2,-60}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          textString="SoC Threshold for electric backup heater"),
        Rectangle(
          extent={{-30,50},{46,4}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-26,-10},{44,-6}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          textString="Boiler modulation")}),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Control model for an electric heater in combination with a PV plant. The heater will be switched on in case of PV power exceeding the electrical demand of the household and if the storage tank is not full.</p><p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>Modelica.Blocks.Interfaces.RealInput <b>SoC</b></p>
<p>TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut <b>Q_flow_set_boiler</b></p>
<p>TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut <b>P_set_electricHeater</b></p><p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2017</span></p>
</html>"));
end ElectricHeater_PV_oriented;
