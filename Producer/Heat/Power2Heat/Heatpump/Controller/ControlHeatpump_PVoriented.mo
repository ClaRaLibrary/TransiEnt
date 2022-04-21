within TransiEnt.Producer.Heat.Power2Heat.Heatpump.Controller;
model ControlHeatpump_PVoriented "Operation preferably when excess PV energy available, if bivalent mode selected, heater will switch on additionally to heatpump"



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

  extends TransiEnt.Producer.Heat.Power2Heat.Heatpump.Controller.Base.Controller_PV;
  extends TransiEnt.Basics.Icons.Controller;

   //___________________________________________________________________________
   //
   //                      Parameters
   //___________________________________________________________________________


  input SI.Temperature TLow_HP=T_set-0.7*Delta_T_db "Temperature limit to switch on the heat pump in case of excess PV energy" annotation (Dialog(group="Temperature limits"));
  input SI.Temperature THigh_HP=T_set+Delta_T_db "Temperature limit to switch off the heat pump in case of excess PV energy" annotation (Dialog(group="Temperature limits"));
  input SI.Temperature THigh2_HP=T_set+Delta_T_db/2 "Temperature limit to switch off the heat pump in case of no excess PV energy" annotation (Dialog(group="Temperature limits"));
  input SI.Temperature TLow2_HP=T_set-Delta_T_db/2 "Temperature limit to switch on the heat pump in case of no excess PV energy" annotation (Dialog(group="Temperature limits"));

  input SI.Temperature TLow_Heater=T_set-1.2*Delta_T_db "Temperature limit to switch on the heater" annotation (Dialog(group="Temperature limits"));
  input SI.Temperature THigh_Heater=T_set "Temperature limit to switch off the heater" annotation (Dialog(group="Temperature limits"));

  parameter Real SoCLow_HP=0.5 "SOC limit to switch off the heat pump" annotation (Dialog(group="SoC limits"));
  parameter Real SoCHigh_HP=1  "SOC limit to switch on the heat pump" annotation (Dialog(group="SoC limits"));

  parameter Real SoCHigh2_HP=0.8 "SOC limit to switch off the heat pump in case of no excess PV energy" annotation (Dialog(group="SoC limits"));
  parameter Real SoCLow2_HP=0.5  "SOC limit to switch on the heat pump in the of no excess PV energy" annotation (Dialog(group="SoC limits"));

  parameter Real SoCLow_Heater=0.25 "SOC limit to switch on the heater" annotation (Dialog(group="SoC limits"));
  parameter Real SoCHigh_Heater=0.6 "SOC limit to switch off the heater" annotation (Dialog(group="SoC limits"));
  parameter Real SoCSet_HP=0.7 annotation (Dialog(group="SoC limits"));

  parameter Real Threshold=1000 "Excess PV power to start heat pump operation" annotation (Dialog(group="Control parameters"));

  parameter Real summer_start=121 "Day of the year for the start of summer operation" annotation (Dialog(group="Control parameters"));
  parameter Real winter_start=274 "Day of the year for the end of summer operation" annotation (Dialog(group="Control parameters"));

  parameter SI.Power P_elHeater=5000 "Nominal electrical power of the electrical heater";

   //___________________________________________________________________________
   //
   //                      Variables
   //___________________________________________________________________________

    Real uHigh_HP;
    Real uLow_HP;
    Real uHigh2_HP;
    Real uLow2_HP;
    Real uHigh_Heater;
    Real uLow_Heater;
    Real uSet_HP;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=180,
        origin={83,1})));
  Modelica.Blocks.Sources.RealExpression zero(y=0) annotation (Placement(transformation(extent={{42,6},{58,22}})));

  Modelica.Blocks.Logical.Not Not  annotation (Placement(transformation(extent={{-32,-22},{-22,-12}})));
  Modelica.Blocks.Sources.RealExpression uHigh(y=uHigh_HP)  annotation (Placement(transformation(extent={{-74,-20},{-58,-4}})));
  Modelica.Blocks.Sources.RealExpression uLow(y=uLow_HP)   annotation (Placement(transformation(extent={{-76,-34},{-60,-18}})));
  TransiEnt.Basics.Blocks.Hysteresis_inputVariable hysteresis_upperStoragePart annotation (Placement(transformation(extent={{-52,-24},{-38,-10}})));
  Modelica.Blocks.Sources.RealExpression Q_flow(y=Q_flow_n) if not Modulating annotation (Placement(transformation(extent={{24,-32},{40,-16}})));
  Modelica.Blocks.Logical.And and1  annotation (Placement(transformation(extent={{-14,28},{-2,40}})));
  Modelica.Blocks.Logical.Greater greaterThreshold annotation (Placement(transformation(extent={{-62,44},{-50,56}})));
  Modelica.Blocks.Sources.RealExpression P_Threshold(y=Threshold) annotation (Placement(transformation(extent={{-84,34},{-70,48}})));

  Modelica.Blocks.Logical.Or  and2  annotation (Placement(transformation(extent={{4,40},{16,28}})));
  Modelica.Blocks.Sources.RealExpression uHigh2(y=uHigh2_HP)  annotation (Placement(transformation(extent={{-32,74},{-15,90}})));
  Modelica.Blocks.Sources.RealExpression uLow2(y=uLow2_HP)  annotation (Placement(transformation(extent={{-30,58},{-14,74}})));
  TransiEnt.Basics.Blocks.Hysteresis_inputVariable hysteresis_lowerStoragePart annotation (Placement(transformation(extent={{-6,68},{8,82}})));
  Modelica.Blocks.Logical.Not not2   annotation (Placement(transformation(extent={{14,70},{24,80}})));
  Basics.Blocks.SwitchAtSeason  summerWinterSwitch(summer_start=summer_start, winter_start=winter_start) annotation (Placement(transformation(extent={{2,-6},{16,6}})));


  Modelica.Blocks.Logical.LogicalSwitch switch3 annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={32,0})));
  TransiEnt.Basics.Blocks.OnOffRelais onOffRelais(
    init_state=2,
    t_min_on=t_min_on,
    t_min_off=t_min_off) if MinTimes and not Modulating annotation (Placement(transformation(extent={{44,-6},{56,6}})));

  Modelica.Blocks.Sources.RealExpression uHigh3(y=uHigh_Heater)  annotation (Placement(transformation(extent={{-62,-80},{-46,-66}})));
  Modelica.Blocks.Sources.RealExpression uLow3(y=uLow_Heater) annotation (Placement(transformation(extent={{-58,-96},{-44,-84}})));
  TransiEnt.Basics.Blocks.Hysteresis_inputVariable hysteresis_heater annotation (Placement(transformation(extent={{-32,-90},{-18,-76}})));
  Modelica.Blocks.Logical.Not Not1 annotation (Placement(transformation(extent={{-12,-88},{-2,-78}})));
  Modelica.Blocks.Sources.RealExpression zero1(y=0) annotation (Placement(transformation(extent={{24,-78},{40,-62}})));
  Modelica.Blocks.Sources.RealExpression P_Heater(y=P_elHeater) annotation (Placement(transformation(extent={{24,-102},{40,-84}})));
  Modelica.Blocks.Logical.Switch switch2 annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=180,
        origin={68,-82})));
  Modelica.Blocks.Sources.RealExpression Setpoint_HP(y=uSet_HP) if Modulating  annotation (Placement(transformation(extent={{26,-50},{42,-34}})));
  Modelica.Blocks.Continuous.LimPID PID(
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMin=0,
    k=5,
    yMax=P_el_n) if Modulating  annotation (Placement(transformation(extent={{54,-44},{64,-34}})));


equation
  // ___________________________________________________________________________
  //
  //            Characteristic equations
  // ___________________________________________________________________________

  uSet_HP=if control_SoC then SoCSet_HP else T_set;

  uHigh_HP=if control_SoC then SoCHigh_HP else THigh_HP;
  uLow_HP=if control_SoC then SoCLow_HP else TLow_HP;
  uHigh2_HP=if control_SoC then SoCHigh2_HP else THigh2_HP;
  uLow2_HP=if control_SoC then SoCLow2_HP else TLow2_HP;
  uHigh_Heater=if control_SoC then SoCHigh_Heater else THigh_Heater;
  uLow_Heater=if control_SoC then SoCLow_Heater else TLow_Heater;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(uLow.y, hysteresis_upperStoragePart.uLow) annotation (Line(points={{-59.2,-26},{-56,-26},{-56,-22.6},{-52.7,-22.6}}, color={0,0,127}));
  connect(uHigh.y, hysteresis_upperStoragePart.uHigh) annotation (Line(points={{-57.2,-12},{-57.2,-12},{-58,-12},{-58,-11.4},{-52.42,-11.4}}, color={0,0,127}));
  connect(Q_flow.y, switch1.u1) annotation (Line(points={{40.8,-24},{56,-24},{56,-4},{74.6,-4},{74.6,-4.6}},
                                                                                                       color={0,0,127}));
  connect(SoC, hysteresis_upperStoragePart.u) annotation (Line(points={{-102,-20},{-80,-20},{-80,-18},{-52.7,-18},{-52.7,-17}},
                                                                                                                              color={0,0,127}));
  connect(greaterThreshold.y, and1.u1) annotation (Line(points={{-49.4,50},{-20,50},{-20,34},{-15.2,34}},    color={255,0,255}));
  connect(and1.y, and2.u1) annotation (Line(points={{-1.4,34},{2.8,34}},                  color={255,0,255}));
  connect(not2.y, and2.u2) annotation (Line(points={{24.5,75},{28,75},{28,44},{2.8,44},{2.8,38.8}},     color={255,0,255}));
  connect(hysteresis_lowerStoragePart.y, not2.u) annotation (Line(points={{8.7,75},{13,75}},                        color={255,0,255}));
  connect(uHigh2.y, hysteresis_lowerStoragePart.uHigh) annotation (Line(points={{-14.15,82},{-10.725,82},{-10.725,80.6},{-6.42,80.6}},  color={0,0,127}));
  connect(uLow2.y, hysteresis_lowerStoragePart.uLow) annotation (Line(points={{-13.2,66},{-9.225,66},{-9.225,69.4},{-6.7,69.4}},    color={0,0,127}));
  connect(SoC, hysteresis_lowerStoragePart.u) annotation (Line(points={{-102,-20},{-90,-20},{-90,20},{-40,20},{-40,74},{-12,74},{-12,75},{-6.7,75}},
                                                                                                                                  color={0,0,127}));

  connect(summerWinterSwitch.summer_operation,switch3. u2) annotation (Line(points={{16.42,0},{24.8,1.11022e-15}},
                                                                                                             color={255,0,255}));

  connect(switch1.y, Q_flow_set_HP) annotation (Line(points={{90.7,1},{90.7,0},{108,0}}, color={0,0,127}));
  connect(and2.y,switch3. u1) annotation (Line(points={{16.6,34},{20,34},{20,6},{24.8,6},{24.8,4.8}},
                                                                                                   color={255,0,255}));
  connect(switch3.y, onOffRelais.u) annotation (Line(points={{38.6,-7.21645e-16},{43.76,0}}, color={255,0,255}));
  connect(onOffRelais.y, switch1.u2) annotation (Line(points={{56.6,0},{56.6,1},{74.6,1}}, color={255,0,255}));
  connect(Not.y, and1.u2) annotation (Line(points={{-21.5,-17},{-20,-17},{-20,29.2},{-15.2,29.2}}, color={255,0,255}));
  connect(Not.y,switch3. u3) annotation (Line(points={{-21.5,-17},{-16,-17},{-16,-18},{18,-18},{18,-4},{24.8,-4},{24.8,-4.8}},
                                                                                                     color={255,0,255}));
  connect(zero.y, switch1.u3) annotation (Line(points={{58.8,14},{74.6,14},{74.6,6.6}},          color={0,0,127}));
  connect(PV_excess, greaterThreshold.u1) annotation (Line(points={{-82,100},{-82,62},{-76,62},{-76,54},{-63.2,54},{-63.2,50}},
                                                                                                                      color={0,127,127}));
  connect(hysteresis_heater.u, SoC) annotation (Line(points={{-32.7,-83},{-90,-83},{-90,-20},{-102,-20}},           color={0,0,127}));
  connect(zero1.y,switch2. u3) annotation (Line(points={{40.8,-70},{45.45,-70},{45.45,-75.6},{58.4,-75.6}}, color={0,0,127}));
  connect(P_Heater.y,switch2. u1) annotation (Line(points={{40.8,-93},{40.8,-92},{50,-92},{50,-90},{50,-88},{50,-88.4},{54,-88.4},{58.4,-88.4}},
                                                                                                                                    color={0,0,127}));
  connect(uLow3.y, hysteresis_heater.uLow) annotation (Line(points={{-43.3,-90},{-38,-90},{-38,-88.6},{-32.7,-88.6}}, color={0,0,127}));
  connect(uHigh3.y,hysteresis_heater. uHigh) annotation (Line(points={{-45.2,-73},{-38,-73},{-38,-77.4},{-32.42,-77.4}},
                                                                                                                       color={0,0,127}));
  connect(switch2.y, P_set_electricHeater) annotation (Line(points={{76.8,-82},{88,-82},{88,-69},{109,-69}},
                                                                                                     color={0,0,127}));
  connect(Not1.y,switch2. u2) annotation (Line(points={{-1.5,-83},{-1.5,-82},{58.4,-82}},
                                                                              color={255,0,255}));
  connect(hysteresis_heater.y, Not1.u) annotation (Line(points={{-17.3,-83},{-13,-83}},            color={255,0,255}));
  connect(hysteresis_upperStoragePart.y, Not.u) annotation (Line(points={{-37.3,-17},{-34,-17},{-33,-17}},     color={255,0,255}));
  connect(T, hysteresis_upperStoragePart.u) annotation (Line(points={{-102,20},{-82,20},{-82,-17},{-52.7,-17}},                   color={0,0,127}));
  connect(T, hysteresis_heater.u) annotation (Line(points={{-102,20},{-92,20},{-92,18},{-90,18},{-90,-83},{-32.7,-83}}, color={0,0,127}));
  connect(T, hysteresis_lowerStoragePart.u) annotation (Line(points={{-102,20},{-40,20},{-40,75},{-6.7,75}}, color={0,0,127}));
  connect(P_Threshold.y, greaterThreshold.u2) annotation (Line(points={{-69.3,41},{-64,41},{-64,45.2},{-63.2,45.2}}, color={0,0,127}));
  connect(Setpoint_HP.y, PID.u_s) annotation (Line(points={{42.8,-42},{50,-42},{50,-39},{53,-39}}, color={0,0,127}));
  connect(SoC, PID.u_m) annotation (Line(points={{-102,-20},{-90,-20},{-90,-52},{60,-52},{60,-45},{59,-45}}, color={0,0,127}));
  connect(T, PID.u_m) annotation (Line(points={{-102,20},{-90,20},{-90,-52},{60,-52},{60,-45},{59,-45}}, color={0,0,127}));
  if not MinTimes or Modulating then
    connect(switch3.y,switch1.u2);
  end if;
  connect(PID.y, switch1.u1) annotation (Line(points={{64.5,-39},{74.6,-39},{74.6,-4.6}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-96,58},{-46,30}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-92,70},{-44,62}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          fontSize=8,
          textString="Sufficient 
excess PV?"),
        Rectangle(
          extent={{-34,90},{26,62}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-68,98},{84,94}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          textString="Lower threshold to offer flexibility in summer operation"),
        Rectangle(
          extent={{-78,-2},{-18,-30}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-76,-34},{6,-44}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          fontSize=8,
          textString="Upper threshold for winter operation or 
if enough excess PV power in summer"),
        Rectangle(
          extent={{-64,-66},{0,-94}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-70,-62},{0,-64}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          fontSize=8,
          textString="Threshold for electric heater")}),                 Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>Controller model to set electric input power for heat pump and electric heater as well as heat pump temperature according to storage tank level or storage tank temperature as well as PV power. Heatpump will switch on preferably when there is excess PV power, but will operate nonetheless if storage tank temperature drops too low.</p>
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
end ControlHeatpump_PVoriented;
