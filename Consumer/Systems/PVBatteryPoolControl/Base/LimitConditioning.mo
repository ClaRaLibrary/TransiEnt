within TransiEnt.Consumer.Systems.PVBatteryPoolControl.Base;
model LimitConditioning "Limits setpoint to loading (P_set_base>0) if battery conditioning is active"


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

  extends TransiEnt.Basics.Icons.Block;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer PoolParameter param;

  // _____________________________________________
  //
  //                 Parameters
  // _____________________________________________

  final parameter Real Delta_SOC_Cond = param.P_el_cond*param.t_conditioning/param.E_max_bat "Change of SOC due to one conditioning operation";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_set_base "Basic setpoint from maximum autarky controller" annotation (Placement(transformation(extent={{-126,-12},{-86,28}})));
  Modelica.Blocks.Logical.Hysteresis isConditioningOK(uLow=param.SOC_min + Delta_SOC_Cond, uHigh=param.SOC_min + Delta_SOC_Cond + 0.01) "Turns false, if battery conditioing is needed" annotation (Placement(transformation(extent={{-34,-50},{-14,-30}})));
  Modelica.Blocks.Interfaces.RealInput SOC
    annotation (Placement(transformation(extent={{-126,-60},{-86,-20}})));
  Modelica.Blocks.Logical.Switch P_set_limit_if_conditioning annotation (Placement(transformation(extent={{48,-10},{68,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_set_limit "Base setpoint limited in case of active battery conditioning" annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Nonlinear.Limiter P_set_base_positive(uMin=0, uMax=param.P_el_max_bat) "Only loading set point (>0) passing" annotation (Placement(transformation(extent={{2,-18},{22,2}})));
  Modelica.Blocks.Logical.Not notUseBatteryConditioning annotation (Placement(transformation(extent={{-34,-80},{-14,-60}})));
  Modelica.Blocks.Logical.Or noConditioningActive annotation (Placement(transformation(extent={{6,-50},{26,-30}})));
  Modelica.Blocks.Sources.BooleanExpression useBatteryConditioning(y=param.useBatteryConditioning) annotation (Placement(transformation(extent={{-68,-80},{-48,-60}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(isConditioningOK.u, SOC) annotation (Line(
      points={{-36,-40},{-106,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_set_base, P_set_limit_if_conditioning.u1) annotation (Line(
      points={{-106,8},{46,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_set_limit_if_conditioning.y, P_set_limit) annotation (Line(
      points={{69,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_set_limit_if_conditioning.u3, P_set_base_positive.y) annotation (Line(
      points={{46,-8},{23,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(isConditioningOK.y, noConditioningActive.u1) annotation (Line(
      points={{-13,-40},{4,-40}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(noConditioningActive.y, P_set_limit_if_conditioning.u2) annotation (Line(
      points={{27,-40},{36,-40},{36,0},{46,0}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(useBatteryConditioning.y, notUseBatteryConditioning.u) annotation (Line(points={{-47,-70},{-36,-70}}, color={255,0,255}));
  connect(notUseBatteryConditioning.y, noConditioningActive.u2) annotation (Line(points={{-13,-70},{-8,-70},{-8,-48},{4,-48}}, color={255,0,255}));
  connect(P_set_base, P_set_base_positive.u) annotation (Line(points={{-106,8},{-14,8},{-14,-8},{0,-8}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),                Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{92,-78},{70,-86},{70,-70},{92,-78}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-88,-78},{70,-78}},
                                      color={192,192,192}),
        Line(points={{-72,-78},{-42,-78},{58,62},{88,62}}),
        Polygon(
          points={{-62,94},{-70,72},{-54,72},{-62,94}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-92,72},{74,72},{74,62}},  color={0,0,127}),
        Line(points={{-63,-80},{-62,74}},
                                      color={192,192,192})}),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This block limits the setpoint of a basic battery controller such that only the posive amount is passing (unloading operation is prohibited) if the battery conditioning is active. If battery conditioning is inactive (or completely deactivated) it acts as a simple passthrough.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Technical component without physical effects.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>This block is only working if the battery conditioning controller acts the expected way because it does not communicate with the conditioning controller. Instead it determines the state of conditioning by the SOC.</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>P_set_base: The basic setpoint of a simple controller (e.g. minimising grid power)</p>
<p>SOC: The actual SOC of the battery</p>
<p>P_set_limit: Limited setpoint</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>Delta_SOC_Cond: Change of SOC due to one conditioning operation</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>No equations present</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>See Purpose of model</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>No phyical validation required. For technical validation see: Check.CheckLimitConditioning</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>None</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model revised, tester and documentation added by Pascal Dubucq (dubucq@tuhh.de) on 24.03.2017</p>
<p>Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</p>
<p>Model revised by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</p>
<p>Model created by Arne Doerschlag on 01.09.2014</p>
</html>"));
end LimitConditioning;
