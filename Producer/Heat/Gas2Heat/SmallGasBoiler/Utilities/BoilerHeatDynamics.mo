within TransiEnt.Producer.Heat.Gas2Heat.SmallGasBoiler.Utilities;
block BoilerHeatDynamics "Block to implement a boiler's dynamics by signal means from a set value"



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
  outer Boolean switch "Boiler switch";

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________

  parameter Real damping;
  parameter Real y_start=0 annotation (Dialog(group="Initialization"));

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput set
    annotation (Placement(transformation(extent={{-136,-10},{-116,10}})));
  Modelica.Blocks.Interfaces.RealOutput out
    annotation (Placement(transformation(extent={{116,-10},{136,10}})));

  // _____________________________________________
  //
  //                   Complex Components
  // _____________________________________________

  Modelica.Blocks.Continuous.FirstOrder firstOrder1(
    y_start=y_start,
    k=1,
    T=damping)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(
    y_start=y_start,
    k=1,
    T=damping,
    initType=Modelica.Blocks.Types.Init.InitialState)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Logical.Switch switchDynamics
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=switch)
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Modelica.Blocks.Continuous.Derivative derivative(
    y_start=0.1,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T=200,
    k=0.01*sqrt(damping))
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Modelica.Blocks.Math.Abs abs(generateEvent=false)
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  FirstOrder_variableDamping firstOrder_variableDamping
    annotation (Placement(transformation(extent={{14,-10},{34,10}})));
  Modelica.Blocks.Math.Feedback error
    annotation (Placement(transformation(extent={{90,-60},{110,-80}})));

equation
  connect(set, error.u1) annotation (Line(
      points={{-126,0},{-100,0},{-100,-70},{92,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(set, firstOrder1.u) annotation (Line(
      points={{-126,0},{-82,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, switchDynamics.u3) annotation (Line(
      points={{41,-40},{52,-40},{52,-8},{58,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switchDynamics.y, out) annotation (Line(
      points={{81,0},{126,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switchDynamics.y, error.u2) annotation (Line(
      points={{81,0},{100,0},{100,-62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booleanExpression.y, switchDynamics.u2) annotation (Line(
      points={{41,40},{52,40},{52,0},{58,0}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(firstOrder1.y, firstOrder2.u) annotation (Line(
      points={{-59,0},{-42,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder2.y, firstOrder_variableDamping.u[1]) annotation (Line(
      points={{-19,0},{-4,0},{-4,0},{12,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder_variableDamping.y, switchDynamics.u1) annotation (Line(
      points={{35,0},{48,0},{48,8},{58,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder2.y, derivative.u) annotation (Line(
      points={{-19,0},{-12,0},{-12,-20},{-90,-20},{-90,-40},{-82,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(derivative.y, abs.u) annotation (Line(
      points={{-59,-40},{-42,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(abs.y, firstOrder_variableDamping.u[2]) annotation (Line(
      points={{-19,-40},{-6,-40},{-6,-18},{6,-18},{6,0},{12,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),  graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-62,94},{-70,72},{-54,72},{-62,94}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-62,72},{-62,-66}}, color={192,192,192}),
        Text(
          extent={{-44,102},{-2,60}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Q_flow"),
        Polygon(
          points={{94,-44},{72,-36},{72,-52},{94,-44}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-86,-44},{86,-44}}, color={192,192,192}),
        Text(
          extent={{44,-50},{74,-80}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="t"),
        Line(
          points={{64,58},{4,54},{-20,-28},{-52,-28}},
          color={255,0,0},
          smooth=Smooth.Bezier,
          thickness=0.5)}),      Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,
            -100},{100,100}}),  graphics),
    Documentation(revisions="<html>
</html>", info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This block representates a boiler&apos;s dynamics as a third order control path. It is designed to delay the generated heat in respect to a given heat duty.</p>
<p><img src=\"modelica://TransiEnt/Images/BoilerControlPath.png\"/></p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>The damping of the path is dynamically dependent on the rate of change or the step size of the duty.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<ul>
<li>set: input value</li>
<li>out: output value</li>
</ul>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<ul>
<li>firstOrder1: First damping element</li>
<li>firstOrder2: Second damping element</li>
<li>derivative: Derivative block to compute rate of change of the second element</li>
<li>limiter: Limits derivative to zero in order to avoid negative dampings in third element</li>
<li>firstOrder_variableDamping: Third damping element with damping dependent to rate of change of the second element&apos;s output</li>
<li>switchDynamics: Switches the output to zero if the boiler is of. This is due to the lack of a heat capacity of a signal-based boiler, where all heat flow in off-state must be zero.</li>
<li>error: Computes heat generation error for analytical purposes.</li>
</ul>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Paul Kernstock (paul.kernstock@tu-harburg.de) June 2015</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Aug 2015</p>
</html>"));
end BoilerHeatDynamics;
