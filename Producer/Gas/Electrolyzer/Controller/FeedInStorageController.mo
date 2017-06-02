within TransiEnt.Producer.Gas.Electrolyzer.Controller;
model FeedInStorageController "Controller model for limited hydrogen output with mass flow feedback and storage pressure"
//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //                  Parameters
  // _____________________________________________

  parameter SI.ActivePower P_el_n=1e6 "Nominal power of electrolyzer";
  //partial-load operational range from 2%-300%
  parameter SI.ActivePower P_el_max = 3*P_el_n "Maximum permitted input power";
  parameter SI.ActivePower P_el_min = 0.02*P_el_n "Minimum permitted input power";
  parameter SI.Efficiency eta_n(
    min=0,
    max=1)=0.75 "Nominal efficiency coefficient (min = 0, max = 1)";

  parameter SI.Efficiency eta_scale(
    min=0,
    max=1)=0 "Sets a with increasing input power linear degrading efficiency coefficient (min = 0, max = 1)";
  parameter Integer startState=1 "Initial state of the electrolyzer (1: ready to overheat, 2: working in overload, 3: cooling down)";

  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.P "|Controller|Type of controller";
  parameter Real k=1 "|Controller|Gain for controller";
  parameter Real Ti=0.1 "|Controller|Integrator time constant";
  parameter Real Td=0.1 "|Controller|Derivative time constant";

  parameter SI.Pressure p_maxLow=29e5 "|Controller|Lower limit of the target pressure in storage";
  parameter SI.Pressure p_maxHigh=30e5 "|Controller|Upper limit of the target pressure in storage";

protected
  SI.Efficiency eta_min = charline.eta;

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
public
  Boolean storageFull=hysteresis.y "true if storage is full";

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

public
  Modelica.Blocks.Interfaces.RealInput m_flow_bypass "Current hydrogen mass flow in kg/s"
                                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,110})));
  Modelica.Blocks.Interfaces.RealInput m_flow_feedIn "Maximum admissible hydrogen mass flow in kg/s"
                                            annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-84,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-80,110})));
  Modelica.Blocks.Interfaces.RealOutput P_el_ely "Maximum power considering constraints"
                                      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput P_el_set "Desired output power"    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,0})));

  Modelica.Blocks.Interfaces.RealInput p "Pressure in storage" annotation (Placement(transformation(extent={{11,-11},{-11,11}},
        rotation=90,
        origin={0,111}), iconTransformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,110})));
  // _____________________________________________
  //
  //               Complex Components
  // _____________________________________________

  TransiEnt.Basics.Blocks.SmoothLimPID limPID(
    k=k,
    yMax=P_el_max,
    Ti=Ti,
    Td=Td,
    controllerType=controllerType,
    thres=0.05,
    y_start=P_el_min,
    yMin=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-62,58})));

  replaceable model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200        constrainedby TransiEnt.Producer.Gas.Electrolyzer.Base.PartialElectrolyzerEfficiencyCharline        "Calculate the efficiency" annotation (Placement(transformation(extent={{10,-10},{30,10}})), choicesAllMatching=true);
protected
  Charline charline(final P_el_n=P_el_n, final eta_n=eta_n, final eta_scale=eta_scale) annotation (Placement(transformation(extent={{-96,-96},{-76,-76}})));

public
  Modelica.Blocks.Math.Min minimum "Minimum of both input signals" annotation (Placement(transformation(extent={{-32,20},{-12,40}})));
  Modelica.Blocks.Logical.Switch switch1
                                        annotation (Placement(transformation(extent={{22,12},{42,32}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression1(y=storageFull)                                                      annotation (Placement(transformation(extent={{-6,15},{12,29}})));

  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=p_maxLow, uHigh=p_maxHigh)
                                                annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,70})));
public
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=P_el_max, uMin=0) annotation (Placement(transformation(extent={{-80,-2},{-60,18}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=(P_el_set < P_el_min or (storageFull and m_flow_feedIn < eta_min*P_el_min/141.8e6)))
                                                                                                    annotation (Placement(transformation(extent={{-54,-10},{52,10}})));
  Modelica.Blocks.Logical.Switch switch annotation (Placement(transformation(extent={{68,10},{88,-10}})));
  Modelica.Blocks.Sources.Constant const(k=0) annotation (Placement(transformation(extent={{22,-32},{42,-12}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  charline.P_el=P_el_min;

  // _____________________________________________
  //
  //             Connect Statements
  // _____________________________________________

  connect(P_el_set, minimum.u2) annotation (Line(points={{-110,0},{-88,0},{-88,24},{-34,24}},color={0,0,127}));
  connect(m_flow_feedIn, limPID.u_s) annotation (Line(points={{-84,110},{-84,82},{-84,58},{-74,58}},          color={0,0,127}));
  connect(limPID.y, minimum.u1) annotation (Line(points={{-51,58},{-44,58},{-44,36},{-34,36}}, color={0,0,127}));
  connect(switch1.u2, booleanExpression1.y) annotation (Line(points={{20,22},{20,22},{12.9,22}}, color={255,0,255}));
  connect(minimum.y, switch1.u1) annotation (Line(points={{-11,30},{20,30},{20,30}}, color={0,0,127}));
  connect(m_flow_bypass, limPID.u_m) annotation (Line(points={{60,110},{60,110},{60,52},{60,46},{-62,46}}, color={0,0,127}));
  connect(p, hysteresis.u) annotation (Line(points={{0,111},{0,111},{0,82},{8.88178e-016,82}}, color={0,0,127}));
  connect(P_el_set, limiter.u) annotation (Line(points={{-110,0},{-88,0},{-88,8},{-82,8}}, color={0,0,127}));
  connect(limiter.y, switch1.u3) annotation (Line(points={{-59,8},{-48,8},{-48,14},{20,14}}, color={0,0,127}));
  connect(const.y,switch. u1) annotation (Line(points={{43,-22},{50,-22},{50,-8},{66,-8}}, color={0,0,127}));
  connect(switch1.y,switch. u3) annotation (Line(points={{43,22},{52,22},{52,8},{66,8}}, color={0,0,127}));
  connect(switch.y, P_el_ely) annotation (Line(points={{89,0},{94,0},{110,0}}, color={0,0,127}));
  connect(booleanExpression.y, switch.u2) annotation (Line(points={{57.3,0},{61.65,0},{66,0}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model of a controller for the PtG plant in operation mode RE with limited hydrogen output.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Controller considers minimum and maximum power of electrolyzer. If desired power is too low, output signal is zero.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Three inputs: mass flow from PtG plant; maximum permitted mass flow; available RE power</p>
<p>One output: desired electrical power of PtG plant</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>Definiton of minimum and maximum power of PtG plant is required. </p>
<p>Depending on application adjustment of PID controller will be helpful.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<h4><span style=\"color: #008000\">9. References</span></h4>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Lisa Andresen (andresen@tuhh.de) in Sep 2016</p>
</html>"));
end FeedInStorageController;
