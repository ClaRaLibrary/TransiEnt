within TransiEnt.Components.Turbogroups.OperatingStates;
model ThreeStateDynamic "Three state dynamic model - operating at init"


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




  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Components.Turbogroups.OperatingStates.PartialStateDynamic(deactivationSignal(y=turndown.active));
   import TransiEnt.Basics.Types;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter SI.Time t_startup = 3600 "Startup time";
  parameter SI.Time t_min_operating = 0 "Minimum operation time";
  parameter Real P_min_operating = 0.3 "Minimum power  (p.u.)";
  parameter Real P_max_operating = 1 "Maximum power (p.u.)";
  parameter Boolean smoothShutDown=true "shut down process will be smoothed - power gradient will be limit by 'P_grad_operating'";

  parameter SI.Frequency P_grad_startup = P_grad_inf "Maximum Gradient during startup";
  parameter TransiEnt.Basics.Types.ThermalPlantStatus init_state=if P_star_init < P_min_operating then 0 else 1 "State of plant at initialization" annotation (__Dymola_editText=false);

  parameter Real thres_hyst=1e-10 "Threshold for hysteresis for switch from halt to startup (chattering might occur, hysteresis might help avoiding this)";
  parameter SI.Time MinimumDownTime=0 "Minimum time the plant needs to be shut down before starting again";
  // _____________________________________________
  //
  //            Complex Components
  // _____________________________________________

  Modelica.StateGraph.StepWithSignal
                                  halt(nIn=4, nOut=1)
                                              annotation (Placement(transformation(extent={{-42,24},{-26,40}},   rotation=0)));
  Modelica.StateGraph.StepWithSignal operating_minimum(nOut=2, nIn=3) annotation (Placement(transformation(extent={{34,24},{50,40}}, rotation=0)));

  // _____________________________________________
  //
  //           Variables
  // _____________________________________________
  Modelica.StateGraph.Transition startupSuccess(
    condition=true,
    enableTimer=true,
    waitTime=t_startup) annotation (Placement(transformation(extent={{12,24},{28,40}},rotation=0)));
  Modelica.StateGraph.StepWithSignal
                           startup(       nOut=2, nIn=2)
                                   annotation (Placement(transformation(extent={{-4,24},{12,40}},    rotation=0)));
  Modelica.StateGraph.Transition threshold(
    waitTime=t_eps,
    enableTimer=true,
    condition=hysteresis.y)                                         annotation (Placement(transformation(extent={{-20,24},{-4,40}},   rotation=0)));
  Modelica.StateGraph.Transition noThreshold(
    waitTime=t_eps,
    enableTimer=true,
    condition=P_set_star > -P_min_operating + 2*thres)
                                                   annotation (Placement(transformation(extent={{8,52},{-8,68}},   rotation=0)));
  Modelica.StateGraph.Transition noThreshold2(
    waitTime=t_eps,
    enableTimer=true,
    condition=P_set_star > -P_min_operating + 2*thres)
                    annotation (Placement(transformation(extent={{64,70},{48,86}}, rotation=0)));
 Modelica.StateGraph.Transition initOff(
    waitTime=0,
    condition=init_state == Types.off,
    enableTimer=false);
  Modelica.StateGraph.Transition initOn(
    waitTime=0,
    condition=init_state == Types.on1,
    enableTimer=false);
  Modelica.StateGraph.Transition initStartup(
    waitTime=t_startup,
    enableTimer=true,
    condition=init_state == Types.on2);

public
  Modelica.StateGraph.InitialStep init(nIn=0, nOut=3) annotation (Placement(transformation(extent={{-130,80},{-110,100}},rotation=0)));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=max(P_min_operating - thres - thres_hyst, 1e-11), uHigh=max(P_min_operating - thres, 1e-10))
                                                                                                     annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(extent={{-76,-80},{-56,-60}})));
  Modelica.StateGraph.StepWithSignal DownTime(nIn=4, nOut=1)
                                                     annotation (Placement(transformation(extent={{-86,24},{-70,40}}, rotation=0)));
  Modelica.StateGraph.Transition minimumDownTimeBlock(enableTimer=true, waitTime=MinimumDownTime)
                                                                                       annotation (Placement(transformation(extent={{-64,24},{-48,40}}, rotation=0)));
  Modelica.StateGraph.Transition startupSuccess1(
    condition=true,
    enableTimer=true,
    waitTime=t_min_operating)
                        annotation (Placement(transformation(extent={{58,24},{74,40}},rotation=0)));
  Modelica.StateGraph.StepWithSignal operating(nOut=2, nIn=3) annotation (Placement(transformation(extent={{76,24},{92,40}},  rotation=0)));
  Modelica.StateGraph.StepWithSignal turndown(nOut=1, nIn=1) annotation (Placement(transformation(extent={{34,70},{18,86}}, rotation=0)));
  Modelica.StateGraph.TransitionWithSignal
                                 turnDownSuccess(enableTimer=true, waitTime=0)
                        annotation (Placement(transformation(extent={{-6,70},{-22,86}},
                                                                                      rotation=0)));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=if smoothShutDown then (if useSlewRateLimiter then P_set_star_lim else P_actual_star)  >= -(P_min_operating + 1e-5) else true)
                                                                                                             annotation (Placement(transformation(extent={{-68,64},{-26,74}})));
equation
  // _____________________________________________
  //
  //              Characteristic equations
  // _____________________________________________

  isOperating =operating_minimum.active or operating.active or init.active or turndown.active;

  P_min =if isOperating then -P_max_operating else 0;
  P_max =if isOperating then -P_min_operating else 0;
  P_grad_min = if halt.active then -P_grad_inf elseif startup.active then -P_grad_startup else -P_grad_operating;
  P_grad_max = if halt.active then P_grad_inf elseif startup.active then P_grad_startup else P_grad_operating;


  // _____________________________________________
  //
  //              Connect Statements
  // _____________________________________________

  connect(halt.outPort[1], threshold.inPort)
    annotation (Line(points={{-25.6,32},{-15.2,32}},           color={0,0,0}));
  connect(startupSuccess.outPort, operating_minimum.inPort[1]) annotation (Line(points={{21.2,32},{33.2,32},{33.2,32.5333}},
                                                                                                                         color={0,0,0}));
  connect(threshold.outPort,startup. inPort[1]) annotation (Line(points={{-10.8,32},{-6,32},{-6,32.4},{-4.8,32.4}},
                                                                                                    color={0,0,0}));
  connect(startup.outPort[1],startupSuccess. inPort) annotation (Line(points={{12.4,32.2},{16.8,32.2},{16.8,32}},
                                                                                                    color={0,0,0}));
  connect(startup.outPort[2],noThreshold. inPort) annotation (Line(points={{12.4,31.8},{14,31.8},{14,60},{3.2,60}},                  color={0,0,0}));

   // ------------- Inititalization ----------------
  // from init to initial transition
  connect(init.outPort[1], initOff.inPort);
  connect(init.outPort[2], initOn.inPort);
  connect(init.outPort[3], initStartup.inPort);

  // from initial transition to state
  connect(halt.inPort[3], initOff.outPort);
  connect(operating_minimum.inPort[2], initOn.outPort);
  connect(startup.inPort[2], initStartup.outPort);

  connect(hysteresis.u, gain.y) annotation (Line(points={{-42,-70},{-55,-70}}, color={0,0,127}));
  connect(gain.u, P_set_star) annotation (Line(points={{-78,-70},{-100,-70},{-100,0}}, color={0,0,127}));

  connect(noThreshold.outPort, DownTime.inPort[2]) annotation (Line(points={{-1.2,60},{-86.8,60},{-86.8,32.2}},                color={0,0,0}));
  connect(halt.inPort[1], minimumDownTimeBlock.outPort) annotation (Line(points={{-42.8,32.6},{-54.5,32.6},{-54.5,32},{-54.8,32}}, color={0,0,0}));
  connect(DownTime.outPort[1], minimumDownTimeBlock.inPort) annotation (Line(points={{-69.6,32},{-59.2,32}},
                                                                                                           color={0,0,0}));
  connect(operating_minimum.outPort[1], startupSuccess1.inPort) annotation (Line(points={{50.4,32.2},{54,32.2},{54,32},{62.8,32}}, color={0,0,0}));
  connect(startupSuccess1.outPort, operating.inPort[1]) annotation (Line(points={{67.2,32},{76,32},{76,32.5333},{75.2,32.5333}},
                                                                                                                               color={0,0,0}));
  connect(operating.outPort[1], noThreshold2.inPort) annotation (Line(points={{92.4,32.2},{96,32.2},{96,78},{59.2,78}},    color={0,0,0}));
  connect(turndown.inPort[1], noThreshold2.outPort) annotation (Line(points={{34.8,78},{44.8,78},{44.8,78},{54.8,78}},           color={0,0,0}));
  connect(turnDownSuccess.inPort, turndown.outPort[1]) annotation (Line(points={{-10.8,78},{4,78},{4,78},{17.6,78}},     color={0,0,0}));
  connect(turnDownSuccess.outPort, DownTime.inPort[1]) annotation (Line(points={{-15.2,78},{-90,78},{-90,32.6},{-86.8,32.6}}, color={0,0,0}));
  connect(booleanExpression.y, turnDownSuccess.condition) annotation (Line(points={{-23.9,69},{-20,69},{-20,68.4},{-14,68.4}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),                                                                     Icon(graphics={
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
<p>Three state dynamic turbine model as state transition graph</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>L1: Models are based on characteristic lines and / or transfer functions</p>
<p>A hysteresis has been added for the state change from halt to startup. Sometimes chattering can occur at this switch which can be avoided using the hysteresis.</p>
<p>Parameter &apos;MinimumDownTime&apos; defines minimum time that power plant has to be shut down before beeing able to start up again.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>P_set_star: input for electric power in W</p>
<p>P_set_star_lim: output for electric power in W</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>slewRateLimiter: set P_grad_operating =-1, if slewRateLimiter is not needed.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in check model &quot;TestThreeStateDynamic&quot; and &quot;TestThreeStateDynamic_Initatmin&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Hysteresis for halt-startup change added by Carsten Bode (c.bode@tuhh.de) in Nov 2018</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Oliver Schülting (oliver.schuelting@tuhh.de) in Nov 2018: added Minimum Down Time</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Oliver Schülting (oliver.schuelting@tuhh.de) on April 2019: added option to deactivate slewRateLimiter, added minimum operation time</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Robert Flesch (flesch@xrg-simulation.de) in Feb 2021: set output to zero if shutdown is active - check if shutdown is complete by using the power input</span></p>
</html>"));
end ThreeStateDynamic;
