within TransiEnt.Basics.Blocks;
model SwitchRamp "Switch with ramp switching between signals"



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
  //              Visible Parameters
  // _____________________________________________

  parameter Modelica.Units.SI.Time Delta_t13=100 "Time to switch from u1 to u3" annotation (Dialog(group="Fundamental Definitions"));
  parameter Modelica.Units.SI.Time Delta_t31=Delta_t13 "Time to switch from u3 to u1" annotation (Dialog(group="Fundamental Definitions"));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput u1 "Connector of first Real input signal" annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.BooleanInput u2 "Connector of Boolean input signal" annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput u3 "Connector of second Real input signal" annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal" annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  discrete Modelica.Units.SI.Time t_start_switchFromU1ToU3;
  discrete Modelica.Units.SI.Time t_start_switchFromU3ToU1;
  Boolean switchFromU1ToU3;
  Boolean switchFromU3ToU1;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

initial equation
  y = if u2 then u1 else u3;
  switchFromU1ToU3 = false;
  switchFromU3ToU1 = false;
  t_start_switchFromU1ToU3 = -2*(Delta_t13+Delta_t31);
  t_start_switchFromU3ToU1 = -2*(Delta_t13+Delta_t31);
algorithm
  when pre(u2) and not u2 and Delta_t13 > 0 then
    t_start_switchFromU1ToU3 := time;
    switchFromU1ToU3 := true;
  end when;
  when not pre(u2) and u2 and Delta_t31 > 0 then
    t_start_switchFromU3ToU1 := time;
    switchFromU3ToU1 := true;
  end when;
  when time - t_start_switchFromU1ToU3 > Delta_t13 and Delta_t13 > 0 and switchFromU1ToU3 then
    switchFromU1ToU3 := false;
  end when;
  when time - t_start_switchFromU3ToU1 > Delta_t31 and Delta_t31 > 0 and switchFromU3ToU1 then
    switchFromU3ToU1 := false;
  end when;
equation
  if switchFromU1ToU3 and Delta_t13 > 0 then
    y = noEvent(u1*(1 - (time - t_start_switchFromU1ToU3)/Delta_t13) + u3*(time - t_start_switchFromU1ToU3)/Delta_t13);
  elseif switchFromU3ToU1 and Delta_t31 > 0 then
    y = noEvent(u3*(1 - (time - t_start_switchFromU3ToU1)/Delta_t31) + u1*(time - t_start_switchFromU3ToU1)/Delta_t31);
  else
    y = if u2 then u1 else u3;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{-38.0,80.0},{6.0,2.0}},
          color={0,0,127},
          thickness=1.0),
        Line(points={{-100.0,80.0},{-38.0,80.0}}, color={0,0,127}),
        Line(points={{-100.0,0.0},{-40.0,0.0}}, color={255,0,255}),
        Line(points={{-40.0,12.0},{-40.0,-12.0}}, color={255,0,255}),
        Line(points={{-100.0,-80.0},{-40.0,-80.0},{-40.0,-80.0}}, color={0,0,127}),
        Line(points={{12.0,0.0},{100.0,0.0}}, color={0,0,127}),
        Ellipse(
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{2.0,-8.0},{18.0,8.0}}),
        Text(
          extent={{-84,-10},{80,-70}},
          lineColor={0,0,0},
          textString="ramp")}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is a switch which does not switch directly but connecting the two signals with a ramp with a given time difference. The basic structure is copied from Modelica.Blocks.Logical.Switch. For time difference=0, it works like Modelica.Blocks.Logical.Switch.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Jun 2019</p>
</html>"));
end SwitchRamp;
