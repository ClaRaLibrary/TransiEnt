within TransiEnt.Components.Turbogroups.OperatingStates;
model ThreeStateDynamic "Three state dynamic model - operating at init"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

  extends TransiEnt.Components.Turbogroups.OperatingStates.PartialStateDynamic;
   import TransiEnt.Basics.Types;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter SI.Time t_startup = 3600 "Startup time";
  parameter SI.Time t_min_operating = 0 "Minimum operation time";
  parameter Real P_min_operating = 0.3 "Minimum power  (p.u.)";
  parameter Real P_max_operating = 1 "Maximum power (p.u.)";

  parameter SI.Frequency P_grad_startup = P_grad_inf "Maximum Gradient during startup";
  parameter TransiEnt.Basics.Types.ThermalPlantStatus init_state=if P_star_init < P_min_operating then 0 else 1 "State of plant at initialization" annotation (__Dymola_editText=false);

  parameter Real thres_hyst=1e-10 "Threshold for hysteresis for switch from halt to startup (chattering might occur, hysteresis might help avoiding this)";
  parameter SI.Time MinimumDownTime=0 "Minimum time the plant needs to be shut down before starting again";
  // _____________________________________________
  //
  //            Complex Components
  // _____________________________________________

  Modelica.StateGraph.StepWithSignal
                                  halt(nIn=4) annotation (Placement(transformation(extent={{-46,20},{-26,40}},   rotation=0)));
  Modelica.StateGraph.StepWithSignal operating_minimum(nOut=2, nIn=3) annotation (Placement(transformation(extent={{46,20},{66,40}}, rotation=0)));

  // _____________________________________________
  //
  //           Variables
  // _____________________________________________

  Modelica.StateGraph.Transition startupSuccess(
    condition=true,
    enableTimer=true,
    waitTime=t_startup) annotation (Placement(transformation(extent={{24,20},{44,40}},rotation=0)));
  Modelica.StateGraph.StepWithSignal
                           startup(       nOut=2, nIn=2)
                                   annotation (Placement(transformation(extent={{6,20},{26,40}},     rotation=0)));
  Modelica.StateGraph.Transition threshold(
    waitTime=t_eps,
    enableTimer=true,
    condition=hysteresis.y)                                         annotation (Placement(transformation(extent={{-18,20},{2,40}},    rotation=0)));
  Modelica.StateGraph.Transition noThreshold(
    waitTime=t_eps,
    enableTimer=true,
    condition=P_set_star > -P_min_operating + 2*thres)
                                                   annotation (Placement(transformation(extent={{26,54},{6,74}},   rotation=0)));
  Modelica.StateGraph.Transition noThreshold2(
    waitTime=t_eps,
    enableTimer=true,
    condition=P_set_star > -P_min_operating + 2*thres)
                    annotation (Placement(transformation(extent={{66,74},{46,94}}, rotation=0)));
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
  Modelica.StateGraph.InitialStep init(nIn=0, nOut=3) annotation (Placement(transformation(extent={{-132,52},{-112,72}}, rotation=0)));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=P_min_operating - thres - thres_hyst, uHigh=P_min_operating - thres)
                                                                                                     annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(extent={{-76,-80},{-56,-60}})));
  Modelica.StateGraph.StepWithSignal DownTime(nIn=4) annotation (Placement(transformation(extent={{-90,20},{-70,40}}, rotation=0)));
  Modelica.StateGraph.Transition minimumDownTimeBlock(enableTimer=true, waitTime=MinimumDownTime)
                                                                                       annotation (Placement(transformation(extent={{-68,20},{-48,40}}, rotation=0)));
  Modelica.StateGraph.Transition startupSuccess1(
    condition=true,
    enableTimer=true,
    waitTime=t_min_operating)
                        annotation (Placement(transformation(extent={{72,20},{92,40}},rotation=0)));
  Modelica.StateGraph.StepWithSignal operating(nOut=2, nIn=3) annotation (Placement(transformation(extent={{96,20},{116,40}}, rotation=0)));
equation
  // _____________________________________________
  //
  //              Characteristic equations
  // _____________________________________________

  isOperating =operating_minimum.active or operating.active or init.active;

  P_min =if operating_minimum.active or operating.active then -P_max_operating else 0;
  P_max =if operating_minimum.active or operating.active then -P_min_operating else 0;
  P_grad_min = if halt.active then -P_grad_inf elseif startup.active then -P_grad_startup else -P_grad_operating;
  P_grad_max = if halt.active then P_grad_inf elseif startup.active then P_grad_startup else P_grad_operating;

  // _____________________________________________
  //
  //              Connect Statements
  // _____________________________________________

  connect(halt.outPort[1], threshold.inPort)
    annotation (Line(points={{-25.5,30},{-12,30}},             color={0,0,0}));
  connect(startupSuccess.outPort, operating_minimum.inPort[1]) annotation (Line(points={{35.5,30},{45,30},{45,30.6667}}, color={0,0,0}));
  connect(threshold.outPort,startup. inPort[1]) annotation (Line(points={{-6.5,30},{0,30},{0,30.5},{5,30.5}},
                                                                                                    color={0,0,0}));
  connect(startup.outPort[1],startupSuccess. inPort) annotation (Line(points={{26.5,30.25},{30,30.25},{30,30}},
                                                                                                    color={0,0,0}));
  connect(startup.outPort[2],noThreshold. inPort) annotation (Line(points={{26.5,29.75},{28,29.75},{28,32},{28,64},{20,64}},         color={0,0,0}));

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

  connect(DownTime.inPort[1], noThreshold2.outPort) annotation (Line(points={{-91,30.75},{-94,30.75},{-94,84},{54.5,84}}, color={0,0,0}));
  connect(noThreshold.outPort, DownTime.inPort[2]) annotation (Line(points={{14.5,64},{-91,64},{-91,30.25}},                   color={0,0,0}));
  connect(halt.inPort[1], minimumDownTimeBlock.outPort) annotation (Line(points={{-47,30.75},{-54.5,30.75},{-54.5,30},{-56.5,30}}, color={0,0,0}));
  connect(DownTime.outPort[1], minimumDownTimeBlock.inPort) annotation (Line(points={{-69.5,30},{-62,30}}, color={0,0,0}));
  connect(operating_minimum.outPort[1], startupSuccess1.inPort) annotation (Line(points={{66.5,30.25},{72,30.25},{72,30},{78,30}}, color={0,0,0}));
  connect(startupSuccess1.outPort, operating.inPort[1]) annotation (Line(points={{83.5,30},{94,30},{94,30.6667},{95,30.6667}}, color={0,0,0}));
  connect(operating.outPort[1], noThreshold2.inPort) annotation (Line(points={{116.5,30.25},{132,30.25},{132,84},{60,84}}, color={0,0,0}));
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) in Nov 2018: added Minimum Down Time</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de) on April 2019: added option to deactivate slewRateLimiter, added minimum operation time</span></p>
</html>"));
end ThreeStateDynamic;
