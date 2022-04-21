within TransiEnt.Consumer.Systems.HouseholdEnergyConverter.Systems.Control_Battery;
model TimedOperation "Timed operation - no charging during or out of specified hours"



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

  extends TransiEnt.Consumer.Systems.HouseholdEnergyConverter.Systems.Control_Battery.Base.Controller_PV_Battery;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

  parameter Real startTime=11 "Time of day to begin period";
  parameter Real endTime=22 "Time of day to end period";
  parameter Integer mode=1 "Charging blocked during or out of specified period?" annotation(choices(
                choice=1 "No charging between startTime and endTime",
                choice=2 "No charging before startTime and after endTime"));

  // _____________________________________________
  //
  //          Interfaces
  // _____________________________________________

  Modelica.Blocks.Math.Add add2(k2=-1) annotation (Placement(transformation(extent={{-76,-4},{-56,16}})));

  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(extent={{56,-10},{76,10}})));

  TransiEnt.Basics.Blocks.SwitchAtTimeOfDay switchAtTimeOfDay(startTime=startTime, endTime=endTime) annotation (Placement(transformation(extent={{-16,-18},{4,2}})));

  Modelica.Blocks.Math.Min min annotation (Placement(transformation(extent={{-36,-46},{-16,-26}})));

  Modelica.Blocks.Sources.RealExpression zero annotation (Placement(transformation(extent={{-72,-52},{-52,-32}})));

  Modelica.Blocks.Logical.Not not1 if mode==1 annotation (Placement(transformation(extent={{16,30},{36,50}})));

equation

  // _____________________________________________
  //
  //          Connect statements
  // _____________________________________________

  if mode==1 then
      connect(switchAtTimeOfDay.y, not1.u) annotation (Line(points={{4.8,-8},{10,-8},{10,40},{14,40}}, color={255,0,255}));
      connect(not1.y, switch1.u2) annotation (Line(points={{37,40},{42,40},{42,0},{54,0}}, color={255,0,255}));
  else
      connect(switchAtTimeOfDay.y, switch1.u2) annotation (Line(points={{4.8,-8},{28,-8},{28,0},{54,0}},
                                                                                               color={255,0,255}));
  end if;
  connect(P_PV, add2.u1) annotation (Line(points={{-104,60},{-84,60},{-84,12},{-78,12}}, color={0,0,127}));
  connect(P_Consumer, add2.u2) annotation (Line(points={{-104,-60},{-84,-60},{-84,0},{-78,0}},   color={0,0,127}));
  connect(switch1.y, P_set_battery) annotation (Line(points={{77,0},{104,0}}, color={0,0,127}));
  connect(add2.y, switch1.u1) annotation (Line(points={{-55,6},{-2,6},{-2,14},{54,14},{54,8}},
                                                                                        color={0,0,127}));
  connect(zero.y, min.u2) annotation (Line(points={{-51,-42},{-38,-42}},          color={0,0,127}));
  connect(add2.y, min.u1) annotation (Line(points={{-55,6},{-44,6},{-44,-30},{-38,-30}},                    color={0,0,127}));
  connect(min.y, switch1.u3) annotation (Line(points={{-15,-36},{48,-36},{48,-8},{54,-8}},color={0,0,127}));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Control model for a PV battery. Battery charging is only allowed during specific hours of the day..</p>
<p>Mode=1, charging only between startTime and endTime, e.g. with startTime=11 and endTime=15 to reduce midday infeed peak.</p>
<p>Mode=2, charging is blocked between startTime and after endTime, e.g. with startTime=7 and endTime=11, to make sure battery is not already full at the midday infeed peak.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>Modelica.Blocks.Interfaces.RealInput <b>P_PV</b></p>
<p>Modelica.Blocks.Interfaces.RealInput<b> P_Consumer</b></p>
<p>Modelica.Blocks.Interfaces.RealOutput <b>P_set_battery</b></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2018</span></p>
</html>"));
end TimedOperation;
