within TransiEnt.Producer.Heat.Power2Heat.Heatpump.Controller;
model ControlHeatpump_priceoriented "Operation preferably at low energy prices, if bivalent mode selected, heater will switch on additionally to heatpump"



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
  extends TransiEnt.Producer.Heat.Power2Heat.Heatpump.Controller.Base.Controller;
  extends TransiEnt.Basics.Icons.Controller;

   //___________________________________________________________________________
   //
   //                      Parameters
   //___________________________________________________________________________


   SI.Temperature TLow_HP=T_set - Delta_T_db/2 "Temperature limit to switch on the heat pump" annotation (Dialog(group="Temperature limits", enable=control_SoC == false));
   SI.Temperature THigh_HP=T_set + Delta_T_db/2 "Temperature limit to switch off the heat pump" annotation (Dialog(group="Temperature limits", enable=control_SoC == false));

   SI.Temperature TLow2_HP=T_set - 0.7*Delta_T_db "Temperature limit to switch on the heat pump in case of high prize for electricity" annotation (Dialog(group="Temperature limits", enable=control_SoC == false));
   SI.Temperature THigh2_HP=T_set + Delta_T_db "Temperature limit to switch off the heat pump in case of high prize for electricity" annotation (Dialog(group="Temperature limits", enable=control_SoC == false));

   SI.Temperature TLow_Heater=T_set - 1.2*Delta_T_db "Temperature limit to switch on the heater" annotation (Dialog(group="Temperature limits", enable=control_SoC == false));
   SI.Temperature THigh_Heater=T_set "Temperature limit to switch off the heater" annotation (Dialog(group="Temperature limits", enable=control_SoC == false));


  parameter Real SoCLow_HP=0.5 "SOC limit to switch on the heat pump" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SoCHigh_HP=0.7 "SOC limit to switch off the heat pump" annotation (Dialog(group="SoC limits", enable=control_SoC));

  parameter Real SoCLow2_HP=0.7 "SOC limit to switch on the heat pump in case of high prize for electricity" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SoCHigh2_HP=1 "SOC limit to switch off the heat pump in case of high prize for electricity" annotation (Dialog(group="SoC limits", enable=control_SoC));

  parameter Real SoCLow_Heater=0.25 "SOC limit to switch on the heater" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SoCHigh_Heater=0.6 "SOC limit to switch off the heater" annotation (Dialog(group="SoC limits", enable=control_SoC));
  parameter Real SoCSet_HP=0.7 annotation (Dialog(group="SoC limits"));


  parameter Real Price_Threshold(unit="EUR/kWh") = 0.05 "Price limit for the operation of the CHP" annotation (Dialog(group="Control"));


   //___________________________________________________________________________
   //
   //                      Variables
   //___________________________________________________________________________

  SI.Power P_highprize "Heat pump power during high prize period";
  SI.Power P_lowprize "Heat pump power during low prize period";
  Real t_highprize "Time period with high electricity prizes";
  Real t_lowprize "Time period with low electricity prizes";
  Real t_HP_highprize "Time period with high prizes and heat pump operation";
  Real t_HP_lowprize "Time period with low prizes and heat pump operation";

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
        extent={{8,-8},{-8,8}},
        rotation=180,
        origin={84,16})));
  Modelica.Blocks.Sources.RealExpression zero(y=0) annotation (Placement(transformation(extent={{46,22},{64,40}})));
  Modelica.Blocks.Logical.Not Not
    annotation (Placement(transformation(extent={{-20,-28},{-10,-18}})));
  Modelica.Blocks.Sources.RealExpression uHigh(y=uHigh2_HP)
    annotation (Placement(transformation(extent={{-68,-24},{-54,-6}})));
  Modelica.Blocks.Sources.RealExpression uLow(y=uLow2_HP)
    annotation (Placement(transformation(extent={{-70,-42},{-54,-24}})));
  TransiEnt.Basics.Blocks.Hysteresis_inputVariable hysteresis_lowerStoragePart annotation (Placement(transformation(extent={{-42,-32},{-26,-16}})));
  TransiEnt.Basics.Blocks.OnOffRelais onOffRelais(
    init_state=init_state,
    t_min_on=t_min_on,
    t_min_off=t_min_off) if MinTimes and not Modulating
    annotation (Placement(transformation(extent={{56,10},{68,22}})));
  Modelica.Blocks.Logical.Switch switch2 if CalculatePHeater annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=180,
        origin={73,-81})));
  Modelica.Blocks.Sources.RealExpression zero1(y=0) if CalculatePHeater annotation (Placement(transformation(extent={{32,-84},{48,-68}})));
  Modelica.Blocks.Sources.RealExpression P_Heater(y=P_elHeater) if CalculatePHeater annotation (Placement(transformation(extent={{36,-98},{50,-82}})));
  TransiEnt.Basics.Blocks.Hysteresis_inputVariable hysteresis_heater if CalculatePHeater annotation (Placement(transformation(extent={{-38,-90},{-24,-76}})));
  Modelica.Blocks.Sources.RealExpression uHigh1(y=uHigh_Heater) if CalculatePHeater
    annotation (Placement(transformation(extent={{-66,-84},{-50,-68}})));
  Modelica.Blocks.Sources.RealExpression uLow1(y=uLow_Heater) if CalculatePHeater annotation (Placement(transformation(extent={{-66,-100},{-50,-84}})));
  Modelica.Blocks.Logical.Not Not1 if CalculatePHeater
    annotation (Placement(transformation(extent={{-16,-88},{-6,-78}})));
  Modelica.Blocks.Sources.RealExpression electricityPrice(y=simCenter.electricityPrice.y1)
    annotation (Placement(transformation(extent={{-58,74},{-44,92}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=Price_Threshold) annotation (Placement(transformation(extent={{-32,76},{-18,90}})));
  Modelica.Blocks.Sources.RealExpression uHigh2(y=uHigh_HP)
    annotation (Placement(transformation(extent={{-68,34},{-52,50}})));
  Modelica.Blocks.Sources.RealExpression uLow2(y=uLow_HP)
    annotation (Placement(transformation(extent={{-68,16},{-50,32}})));
  TransiEnt.Basics.Blocks.Hysteresis_inputVariable hysteresis_upperStoragePart annotation (Placement(transformation(extent={{-38,28},{-24,42}})));
  Modelica.Blocks.Logical.Not Not2
    annotation (Placement(transformation(extent={{-18,26},{-8,36}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{26,32},{36,42}})));
  Modelica.Blocks.Logical.Or any annotation (Placement(transformation(extent={{40,22},{52,10}})));
  Modelica.Blocks.Sources.RealExpression Setpoint_HP(y=uSet_HP) if Modulating  annotation (Placement(transformation(extent={{8,-62},{24,-46}})));
  Modelica.Blocks.Continuous.LimPID PID(
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMin=0,
    k=5,
    yMax=1) if Modulating
    annotation (Placement(transformation(extent={{32,-56},{42,-46}})));
  Modelica.Blocks.Math.Product  gain1 if Modulating
    annotation (Placement(transformation(extent={{52,-48},{66,-34}})));
  Modelica.Blocks.Sources.RealExpression Q_flow(y=Q_flow_n)
                                                          annotation (Placement(transformation(extent={{18,-44},{34,-28}})));

protected
  Modelica.Blocks.Math.Add P_total;

equation
  // ___________________________________________________________________________
  //
  //            Characteristic equations
  // ___________________________________________________________________________

  P_highprize = if simCenter.electricityPrice.y1 >= Price_Threshold then P_total.y else 0;
  P_lowprize = if simCenter.electricityPrice.y1 < Price_Threshold then P_total.y else 0;
  der(t_highprize) = if simCenter.electricityPrice.y1 >= Price_Threshold then 1 else 0;
  der(t_lowprize) = if simCenter.electricityPrice.y1 < Price_Threshold then 1 else 0;
  der(t_HP_highprize) = if simCenter.electricityPrice.y1 >= Price_Threshold and P_total.y > 0 then 1 else 0;
  der(t_HP_lowprize) = if simCenter.electricityPrice.y1 < Price_Threshold and P_total.y > 0 then 1 else 0;

  uSet_HP = if control_SoC then SoCSet_HP else T_set;
  uHigh_HP = if control_SoC then SoCHigh_HP else THigh_HP;
  uLow_HP = if control_SoC then SoCLow_HP else TLow_HP;
  uHigh2_HP = if control_SoC then SoCHigh2_HP else THigh2_HP;
  uLow2_HP = if control_SoC then SoCLow2_HP else TLow2_HP;
  uHigh_Heater = if control_SoC then SoCHigh_Heater else THigh_Heater;
  uLow_Heater = if control_SoC then SoCLow_Heater else TLow_Heater;


  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________



  connect(P_total.u1, P_set_electricHeater);
  connect(P_total.u2, Q_flow_set_HP);

  connect(hysteresis_lowerStoragePart.y, Not.u) annotation (Line(points={{-25.2,-24},{-25.2,-23},{-21,-23}}, color={255,0,255}));
  connect(uLow.y, hysteresis_lowerStoragePart.uLow) annotation (Line(points={{-53.2,-33},{-50,-33},{-50,-30.4},{-42.8,-30.4}}, color={0,0,127}));
  connect(onOffRelais.y, switch1.u2) annotation (Line(points={{68.6,16},{74.4,16}},
                                  color={255,0,255}));
  connect(switch1.y, Q_flow_set_HP) annotation (Line(points={{92.8,16},{92.8,0},{108,0}}, color={0,0,127}));
  connect(switch2.y, P_set_electricHeater) annotation (Line(points={{80.7,-81},{92,-81},{92,-69},{109,-69}},
                                                                                                     color={0,0,127}));
  connect(zero1.y, switch2.u3) annotation (Line(points={{48.8,-76},{55.45,-76},{55.45,-75.4},{64.6,-75.4}}, color={0,0,127}));
  connect(hysteresis_heater.u, SoC) annotation (Line(points={{-38.7,-83},{-86,-83},{-86,-20},{-102,-20}},           color={0,0,127}));
  connect(uHigh1.y, hysteresis_heater.uHigh) annotation (Line(points={{-49.2,-76},{-44,-76},{-44,-77.4},{-38.42,-77.4}},
                                                                                                                       color={0,0,127}));
  connect(uLow1.y, hysteresis_heater.uLow) annotation (Line(points={{-49.2,-92},{-44,-92},{-44,-88.6},{-38.7,-88.6}}, color={0,0,127}));
  connect(hysteresis_heater.y, Not1.u) annotation (Line(points={{-23.3,-83},{-17,-83}},                   color={255,0,255}));
  connect(Not1.y, switch2.u2) annotation (Line(points={{-5.5,-83},{-5.5,-81},{64.6,-81}}, color={255,0,255}));
  connect(electricityPrice.y, lessThreshold.u) annotation (Line(points={{-43.3,83},{-43.3,83},{-33.4,83}}, color={0,0,127}));
  connect(uHigh2.y, hysteresis_upperStoragePart.uHigh) annotation (Line(points={{-51.2,42},{-46,42},{-46,40.6},{-38.42,40.6}}, color={0,0,127}));
  connect(uLow2.y, hysteresis_upperStoragePart.uLow) annotation (Line(points={{-49.1,24},{-46,24},{-46,29.4},{-38.7,29.4}}, color={0,0,127}));
  connect(hysteresis_upperStoragePart.y, Not2.u) annotation (Line(points={{-23.3,35},{-22,35},{-22,31},{-19,31}},
                                                                                                color={255,0,255}));
  connect(Not2.y, and1.u2) annotation (Line(points={{-7.5,31},{25,31},{25,33}},
                                                                              color={255,0,255}));
  connect(lessThreshold.y, and1.u1) annotation (Line(points={{-17.3,83},{-17.3,80},{22,80},{22,34},{25,34},{25,37}},
                                                                                                                   color={255,0,255}));
  connect(Not.y, any.u1) annotation (Line(points={{-9.5,-23},{32,-23},{32,16},{38.8,16}}, color={255,0,255}));
  connect(SoC, hysteresis_upperStoragePart.u) annotation (Line(points={{-102,-20},{-86,-20},{-86,35},{-38.7,35}},
                                                                                                              color={0,0,127}));
  connect(zero.y, switch1.u3) annotation (Line(points={{64.9,31},{74.4,31},{74.4,22.4}},       color={0,0,127}));
  connect(P_Heater.y, switch2.u1) annotation (Line(points={{50.7,-90},{56,-90},{56,-86.6},{64.6,-86.6}}, color={0,0,127}));
  connect(any.y, onOffRelais.u) annotation (Line(points={{52.6,16},{55.76,16}}, color={255,0,255}));
  connect(and1.y, any.u2) annotation (Line(points={{36.5,37},{40,37},{40,26},{38.8,26},{38.8,20.8}}, color={255,0,255}));
  connect(uHigh.y, hysteresis_lowerStoragePart.uHigh) annotation (Line(points={{-53.3,-15},{-48,-15},{-48,-17.6},{-42.48,-17.6}}, color={0,0,127}));
  connect(T, hysteresis_upperStoragePart.u) annotation (Line(points={{-102,20},{-86,20},{-86,35},{-38.7,35}}, color={0,0,127}));
  connect(T, hysteresis_heater.u) annotation (Line(points={{-102,20},{-86,20},{-86,-83},{-38.7,-83}}, color={0,0,127}));
  connect(SoC, hysteresis_lowerStoragePart.u) annotation (Line(points={{-102,-20},{-86,-20},{-86,-24},{-42.8,-24}},
                                                                                                color={0,0,127}));
  connect(T, hysteresis_lowerStoragePart.u) annotation (Line(points={{-102,20},{-86,20},{-86,-24},{-42.8,-24}}, color={0,0,127}));
  connect(PID.u_s, Setpoint_HP.y) annotation (Line(points={{31,-51},{31,-51.5},{24.8,-51.5},{24.8,-54}}, color={0,0,127}));
  connect(PID.y, gain1.u2) annotation (Line(points={{42.5,-51},{50.6,-51},{50.6,-45.2}}, color={0,0,127}));
  connect(Q_flow.y, gain1.u1) annotation (Line(points={{34.8,-36},{50.6,-36},{50.6,-36.8}}, color={0,0,127}));

    if not Modulating then
      connect(Q_flow.y, switch1.u1) annotation (Line(points={{34.8,-36},{44,-36},{44,-4},{74.4,-4},{74.4,9.6}}, color={0,0,127}));
    end if;
    if not MinTimes or Modulating then
      connect(any.y,switch1.u2);
    end if;

  if not CalculatePHeater then
    connect(zero.y, P_total.u1);
  end if;

  connect(gain1.y, switch1.u1) annotation (Line(points={{66.7,-41},{74.4,-41},{74.4,9.6}}, color={0,0,127}));
  connect(SoC, PID.u_m) annotation (Line(points={{-102,-20},{-86,-20},{-86,-60},{36,-60},{36,-56},{37,-56},{37,-57}}, color={0,0,127}));
  connect(T, PID.u_m) annotation (Line(points={{-102,20},{-86,20},{-86,-60},{36,-60},{36,-58},{37,-58},{37,-57}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-70,-68},{-2,-100}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-72,-64},{-2,-66}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          textString="SoC Threshold for electric backup heater",
          fontSize=9),
        Rectangle(
          extent={{-62,94},{-10,72}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-78,102},{6,92}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          fontSize=9,
          textString="Price < Threshold?"),
        Text(
          extent={{-74,60},{-8,58}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          fontSize=9,
          textString="Upper threshold for
operation at low price"),
        Rectangle(
          extent={{-70,50},{-6,20}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash),
        Text(
          extent={{-94,4},{24,2}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          fontSize=9,
          textString="Lower Threshold for
backup operation at high price"),
        Rectangle(
          extent={{-72,-6},{-8,-40}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash)}),                                   Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>Controller model to set electric input power for heat pump and electric heater as well as heat pump temperature according to storage tank level or storage tank temperature as well as electricity prices. Heatpump will switch on preferably when prices are low, but will operate nonetheless if storage tank temperature drops too low.</p>
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
end ControlHeatpump_priceoriented;
