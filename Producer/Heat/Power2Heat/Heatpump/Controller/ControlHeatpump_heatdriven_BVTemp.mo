within TransiEnt.Producer.Heat.Power2Heat.Heatpump.Controller;
model ControlHeatpump_heatdriven_BVTemp "Heat-driven operation with optional startup ramp, if bivalent mode selected, heater will switch on instead of heatpump below T_bivalent"


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




  extends TransiEnt.Producer.Heat.Power2Heat.Heatpump.Controller.Base.Controller(control_SoC=false);
  extends TransiEnt.Basics.Icons.Controller;

   //___________________________________________________________________________
   //
   //                      Parameters
   //___________________________________________________________________________

  parameter SI.Temperature T_bivalent=273.15 "Bivalent temperature where heatpump starts operating (if Tamb > T_bivalent)" annotation (Dialog(enable=BivalentOperation, group="Bivalent Operation"));
  parameter SI.Temperature T_heatingLimit=303.15 "Temperature limit above which heatpump is turned off (off ist Tamb>T_heatingLimit)" annotation (Dialog(enable=BivalentOperation, group="Bivalent Operation"));
  parameter Boolean Startupramp=false "If true, ramps at startup and shutdown are considered." annotation (Dialog(group="Configuration"),choices(checkBox=true));

  parameter Real SoCSet_HP=0.7 "SoC setpoint for modulating operation" annotation (Dialog(group="Control parameters",
                                                                                                              enable=control_SoC));
  parameter Real SoCLow_HP=0.5 "SoC limit to switch on the heat pump" annotation (Dialog(group="Control parameters",
                                                                                                             enable=control_SoC));
  parameter Real SoCHigh_HP=1 "SoC limit to switch off the heat pump" annotation (Dialog(group="Control parameters",
                                                                                                             enable=control_SoC));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Logical.GreaterEqualThreshold isBaseload(threshold=T_bivalent) if CalculatePHeater annotation (Placement(transformation(extent={{-30,74},{-18,86}})));
  Modelica.Blocks.Logical.LessThreshold isHeatdemand(threshold=T_heatingLimit) if CalculatePHeater annotation (Placement(transformation(extent={{-30,44},{-20,54}})));
  Modelica.Blocks.MathBoolean.And isStartRequest(nu=3) if CalculatePHeater annotation (Placement(transformation(extent={{-2,0},{10,12}})));

  Basics.Blocks.OnOffRelais onOffRelais(
    init_state=init_state,
    t_min_on=t_min_on,
    t_min_off=t_min_off) if MinTimes and not Modulating annotation (Placement(transformation(extent={{-24,2},{-12,14}})));
  Modelica.Blocks.Math.BooleanToReal P_el_HP(realFalse=0, realTrue=Q_flow_n) if
                                                                              not Modulating annotation (Placement(transformation(extent={{18,-2},{34,14}})));
  Modelica.Blocks.Continuous.FirstOrder shutdown(T=60) if Startupramp annotation (Placement(transformation(extent={{30,-30},{42,-18}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=onOffRelais.switch_to_on.outPort.set) if Startupramp and MinTimes and not Modulating annotation (Placement(transformation(extent={{18,-50},{38,-30}})));
  Modelica.Blocks.Continuous.FirstOrder startup(T=10) if Startupramp annotation (Placement(transformation(extent={{28,-66},{44,-50}})));
  Modelica.Blocks.Logical.Switch dynamic if Startupramp annotation (Placement(transformation(extent={{62,-48},{82,-28}})));
  Modelica.Blocks.Math.Add add(k2=-1) if not control_SoC annotation (Placement(transformation(extent={{-68,2},{-56,14}})));

  Modelica.Blocks.Logical.Switch Q_modulating if Modulating annotation (Placement(transformation(extent={{-20,-52},{0,-32}})));
  Modelica.Blocks.Continuous.LimPID PID(
    Ti=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMin=0,
    k=1000,
    yMax=Q_flow_n) if
                     Modulating annotation (Placement(transformation(extent={{-74,-44},{-60,-30}})));
  Modelica.Blocks.Sources.RealExpression zero(y=0) if Modulating annotation (Placement(transformation(extent={{-54,-70},{-38,-52}})));
  Basics.Blocks.Hysteresis_inputVariable controller(pre_y_start=true) annotation (Placement(transformation(extent={{-40,2},{-28,14}})));
  Modelica.Blocks.Sources.RealExpression uHigh(y=if control_SoC then SoCHigh_HP else Delta_T_db/2) annotation (Placement(transformation(extent={{-74,16},{-58,34}})));
  Modelica.Blocks.Sources.RealExpression uLow(y=if control_SoC then SoCLow_HP else -Delta_T_db/2) annotation (Placement(transformation(extent={{-74,-18},{-58,0}})));
  Modelica.Blocks.Sources.Constant zero1(k=0) annotation (Placement(transformation(extent={{42,19},{52,29}})));
  Modelica.Blocks.Logical.Switch Q_flow_peakload if CalculatePHeater annotation (Placement(transformation(extent={{66,29},{80,43}})));
  Modelica.Blocks.Sources.RealExpression P_heater(y=P_elHeater) annotation (Placement(transformation(extent={{39,58},{59,78}})));
  Modelica.Blocks.Logical.And and_heater if                                         CalculatePHeater annotation (Placement(transformation(extent={{26,48},{38,60}})));
  Modelica.Blocks.Logical.Not isBaseload2 if                                        CalculatePHeater annotation (Placement(transformation(extent={{4,66},{16,78}})));
  Modelica.Blocks.Sources.RealExpression uLow1(y=if control_SoC then SoCSet_HP else T_set) annotation (Placement(transformation(extent={{-126,-50},{-110,-32}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(T, add.u2) annotation (Line(points={{-102,20},{-84,20},{-84,4.4},{-69.2,4.4}}, color={0,0,127}));
  connect(isStartRequest.y, P_el_HP.u) annotation (Line(points={{10.9,6},{16.4,6}}, color={255,0,255}));
  connect(shutdown.y, dynamic.u1) annotation (Line(points={{42.6,-24},{54,-24},{54,-30},{60,-30}}, color={0,0,127}));
  connect(startup.y, dynamic.u3) annotation (Line(points={{44.8,-58},{60,-58},{60,-46}}, color={0,0,127}));
  connect(booleanExpression.y, dynamic.u2) annotation (Line(points={{39,-40},{54,-40},{54,-38},{60,-38}}, color={255,0,255}));
  connect(P_el_HP.y, shutdown.u) annotation (Line(points={{34.8,6},{54,6},{54,-12},{24,-12},{24,-24},{28.8,-24}}, color={0,0,127}));
  connect(P_el_HP.y, startup.u) annotation (Line(points={{34.8,6},{38,6},{38,-12},{24,-12},{24,-24},{14,-24},{14,-58},{26.4,-58}}, color={0,0,127}));
  connect(dynamic.y, Q_flow_set_HP) annotation (Line(points={{83,-38},{84,-38},{84,0},{108,0}}, color={0,0,127}));
  connect(T_source, isBaseload.u) annotation (Line(points={{24,104},{24,94},{-44,94},{-44,80},{-31.2,80}}, color={0,0,127}));
  connect(T_source, isHeatdemand.u) annotation (Line(points={{24,104},{24,94},{-58,94},{-58,49},{-31,49}}, color={0,0,127}));
  connect(onOffRelais.y, isStartRequest.u[1]) annotation (Line(points={{-11.4,8},{-8,8},{-8,8.8},{-2,8.8}}, color={255,0,255}));
  connect(isHeatdemand.y, isStartRequest.u[3]) annotation (Line(points={{-19.5,49},{-18,49},{-18,16},{-6,16},{-6,3.2},{-2,3.2}}, color={255,0,255}));
  connect(isBaseload.y, isStartRequest.u[2]) annotation (Line(points={{-17.4,80},{-12,80},{-12,46},{-16,46},{-16,18},{-10,18},{-10,6},{-2,6}}, color={255,0,255}));
  connect(T_set, add.u1) annotation (Line(points={{-102,46},{-78,46},{-78,11.6},{-69.2,11.6}}, color={0,0,127}));

  if not CalculatePHeater then
    connect(onOffRelais.y, P_el_HP.u);
    connect(onOffRelais.y,Q_modulating. u2);
  end if;

  if not Startupramp then
    connect(P_el_HP.y, Q_flow_set_HP);
    connect(Q_modulating.y, Q_flow_set_HP);
  end if;

  if not MinTimes or Modulating then
    connect(controller.y, dynamic.u2);
    if CalculatePHeater then
      connect(controller.y, isStartRequest.u[1]);
      connect(controller.y, and_heater.u2);
    elseif not Modulating then
      connect(controller.y, P_el_HP.u);
    else
      connect(controller.y,Q_modulating. u2);
    end if;

  end if;

  connect(controller.y, onOffRelais.u) annotation (Line(points={{-27.4,8},{-27.4,12},{-28,12},{-28,4},{-24.24,4},{-24.24,8}}, color={255,0,255}));

  connect(T, PID.u_m) annotation (Line(points={{-102,20},{-84,20},{-84,-56},{-67,-56},{-67,-45.4}}, color={0,0,127}));
  connect(isStartRequest.y,Q_modulating. u2) annotation (Line(points={{10.9,6},{10.9,-14},{-48,-14},{-48,-42},{-22,-42}}, color={255,0,255}));
  connect(Q_modulating.y, shutdown.u) annotation (Line(points={{1,-42},{16,-42},{16,-22},{24,-22},{24,-24},{28.8,-24}}, color={0,0,127}));
  connect(Q_modulating.y, startup.u) annotation (Line(points={{1,-42},{14,-42},{14,-58},{26.4,-58}}, color={0,0,127}));

  connect(uHigh.y, controller.uHigh) annotation (Line(points={{-57.2,25},{-46,25},{-46,12.8},{-40.36,12.8}}, color={0,0,127}));
  connect(uLow.y, controller.uLow) annotation (Line(points={{-57.2,-9},{-40.6,-9},{-40.6,3.2}}, color={0,0,127}));
  connect(controller.u, SoC) annotation (Line(points={{-40.6,8},{-48,8},{-48,-4},{-82,-4},{-82,-20},{-102,-20}}, color={0,0,127}));
  connect(controller.u, add.y) annotation (Line(points={{-40.6,8},{-55.4,8}}, color={0,0,127}));
  connect(Q_flow_peakload.y, P_set_electricHeater) annotation (Line(points={{80.7,36},{88,36},{88,-69},{109,-69}}, color={0,0,127}));

  connect(onOffRelais.y, and_heater.u2) annotation (Line(points={{-11.4,8},{-6,8},{-6,44},{24.8,44},{24.8,49.2}}, color={255,0,255}));
  connect(and_heater.y, Q_flow_peakload.u2) annotation (Line(points={{38.6,54},{58,54},{58,36},{64.6,36}}, color={255,0,255}));
  connect(isBaseload.y, isBaseload2.u) annotation (Line(points={{-17.4,80},{-2,80},{-2,72},{2.8,72}}, color={255,0,255}));
  connect(isBaseload2.y, and_heater.u1) annotation (Line(points={{16.6,72},{20,72},{20,54},{24.8,54}}, color={255,0,255}));
  connect(zero1.y, Q_flow_peakload.u3) annotation (Line(points={{52.5,24},{64.6,24},{64.6,30.4}}, color={0,0,127}));
  connect(P_heater.y, Q_flow_peakload.u1) annotation (Line(points={{60,68},{64.6,68},{64.6,41.6}}, color={0,0,127}));
  connect(PID.y,Q_modulating. u1) annotation (Line(points={{-59.3,-37},{-26,-37},{-26,-34},{-22,-34}}, color={0,0,127}));
  connect(zero.y,Q_modulating. u3) annotation (Line(points={{-37.2,-61},{-28,-61},{-28,-50},{-22,-50}}, color={0,0,127}));
  connect(SoC, PID.u_m) annotation (Line(points={{-102,-20},{-94,-20},{-94,-44},{-67,-44},{-67,-45.4}}, color={0,0,127}));
  connect(uLow1.y, PID.u_s) annotation (Line(points={{-109.2,-41},{-82,-41},{-82,-37},{-75.4,-37}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>Controller model to set electric input power for heat pump and electric heater as well as heat pump temperature according to storage tank level or storage tank temperature.</p>
<p>For bivalent operation, electric heater produces heat with constant power and operates instead of heatpump below T_bivalent.</p>
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
end ControlHeatpump_heatdriven_BVTemp;
