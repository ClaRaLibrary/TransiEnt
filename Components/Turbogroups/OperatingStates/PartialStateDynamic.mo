within TransiEnt.Components.Turbogroups.OperatingStates;
partial model PartialStateDynamic "State graph model with state-depentend maximum values and gradients"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE and ResiliEntEE are research projects supported by the German     //
// Federal Ministry of Economics and Energy (FKZ 03ET4003 and 03ET4048).          //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Institute of Electrical Power Systems and Automation                           //
// (Hamburg University of Technology)                                             //
// and is supported by                                                            //
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

  outer SimCenter simCenter;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter SI.Time t_eps = 10 "Threshold time for transitions";
  parameter Real P_star_init = 0 "Power at startup (p.u.)";
  parameter SI.Frequency P_grad_inf=1 "Numerical value for unlimited gradients during shutdown";
  parameter SI.Time T_thresh=simCenter.thres "Time constant of numerical element between saturation and gradient limiter";
  parameter Real Td=simCenter.Td "Time constant of derivative approximation in slew rate limiter";
  parameter Boolean useThresh=simCenter.useThresh "Use threshould for suppression of numerical noise";
  parameter Real thres=simCenter.thres "If abs(u-y)< thres, y becomes a simple pass through of u. Increasing thres can improve simulation speed. However to large values can make the simulation unstable. 
     A good starting point is the choice thres = tolerance/1000.";

  // _____________________________________________
  //
  //            Complex Components
  // _____________________________________________

    inner Modelica.StateGraph.StateGraphRoot
                         stateGraphRoot
      annotation (Placement(transformation(extent={{-98,84},{-84,98}})));
  Modelica.Blocks.Interfaces.RealInput P_set_star "Connector of setpoint input signal" annotation (Placement(transformation(extent={{-116,-16},{-84,16}}, rotation=0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation (Placement(transformation(extent={{-52,-44},{-26,-18}})));
  Basics.Blocks.VariableSlewRateLimiter variableSlewRateLimiter(
    thres=thres,
    useConstantLimits=false,
    useThresh=false,
    y_start=-P_star_init) annotation (Placement(transformation(extent={{56,-44},{82,-18}})));

  Modelica.Blocks.Interfaces.RealOutput P_set_star_lim "Limited output signal" annotation (Placement(transformation(extent={{96,-16},{128,16}}, rotation=0)));
  Modelica.Blocks.Sources.RealExpression P_min_of_state(y=P_min) annotation (Placement(transformation(extent={{-92,-52},{-72,-32}})));
  Modelica.Blocks.Sources.RealExpression P_max_of_state(y=P_max) annotation (Placement(transformation(extent={{-92,-30},{-72,-10}})));
  Modelica.Blocks.Sources.RealExpression P_grad_min_of_state(y=P_grad_min) annotation (Placement(transformation(extent={{20,-52},{40,-32}})));
  Modelica.Blocks.Sources.RealExpression P_grad_max_of_state(y=P_grad_max) annotation (Placement(transformation(extent={{20,-30},{40,-10}})));

  // _____________________________________________
  //
  //           Variables
  // _____________________________________________

  Boolean isOperating;

protected
  Real P_min,P_max,P_grad_min,P_grad_max;

equation
  // _____________________________________________
  //
  //              Connect Statements
  // _____________________________________________

  connect(P_max_of_state.y, variableLimiter.limit1) annotation (Line(points={{-71,-20},{-54.6,-20},{-54.6,-20.6}}, color={0,0,127}));
  connect(P_min_of_state.y, variableLimiter.limit2) annotation (Line(
      points={{-71,-42},{-66,-42},{-66,-41.4},{-54.6,-41.4}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(P_grad_max_of_state.y, variableSlewRateLimiter.maxGrad) annotation (Line(
      points={{41,-20},{53.4,-20},{53.4,-20.6}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(P_grad_min_of_state.y, variableSlewRateLimiter.minGrad) annotation (Line(
      points={{41,-42},{48,-42},{48,-41.4},{53.4,-41.4}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(variableLimiter.u, P_set_star) annotation (Line(
      points={{-54.6,-31},{-100,-31},{-100,0}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(variableSlewRateLimiter.y, P_set_star_lim) annotation (Line(
      points={{83.3,-31},{112,-31},{112,0}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(variableLimiter.y, variableSlewRateLimiter.u) annotation (Line(points={{-24.7,-31},{53.4,-31}},          color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(graphics={
      Rectangle(
        origin={-70,0},
        fillColor={255,255,255},
        extent={{-20.0,-20.0},{20.0,20.0}}),
      Line(origin={-35,0},     points={{15.0,0.0},{-15.0,0.0}}),
      Polygon(
        origin={-16.6667,0},
        pattern=LinePattern.None,
        fillPattern=FillPattern.Solid,
        points={{-3.3333,10.0},{16.667,0.0},{-3.3333,-10.0}}),
      Line(points={{0,50},{0,-50}}),
      Line(origin={15,0},       points={{15.0,0.0},{-15.0,-0.0}}),
      Polygon(
        origin={33.3333,0},
        pattern=LinePattern.None,
        fillPattern=FillPattern.Solid,
        points={{-3.3333,10.0},{16.667,0.0},{-3.3333,-10.0}}),
      Rectangle(
        origin={70,0},
        fillColor={255,255,255},
        extent={{-20.0,-20.0},{20.0,20.0}}),
    Line(points={{-80,-70},{-50,-70},{50,70},{80,70}}, color={0,0,0}),
    Polygon(
      points={{0,90},{-8,68},{8,68},{0,90}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{0,-90},{0,68}}, color={192,192,192}),
    Line(points={{-90,0},{68,0}}, color={192,192,192})}),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Full documentation is not available yet. Please see comments in code or contact author per mail.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarsk for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end PartialStateDynamic;
