within TransiEnt.Components.Turbogroups.OperatingStates;
model PumpstorageStates "Limits input signal by value and gradient depending on active state out of three possible operating states (halt, startup, operating)"



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





  extends TransiEnt.Components.Turbogroups.OperatingStates.PartialStateDynamic;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter TransiEnt.Basics.Types.OnOffPumpstorageStatus init_state=TransiEnt.Basics.Types.off "State of Pumpstorage at initialization" annotation (__Dymola_editText=false);
  parameter SI.Time t_startup = 120 "Startup time";
  parameter Real P_min_operating_pump = 0.1 "Minimum power pump operation (p.u.)";
  parameter Real P_min_operating_turb = 0.1 "Minimum power turbine operation (p.u.)";
  parameter Real P_max_operating_pump = 1 "Maximum power pump operation (p.u.)";
  parameter Real P_max_operating_turb = 1 "Maximum power turbine operation (p.u.)";
  parameter SI.Frequency P_grad_startup = 1/max(t_startup,1) "Maximum Gradient during startup";

  // _____________________________________________
  //
  //            Complex Components
  // _____________________________________________

  Modelica.StateGraph.StepWithSignal
                                  halt(nOut=2, nIn=5)
                                              annotation (Placement(transformation(extent={{-84,66},{-64,86}},   rotation=0)));
  Modelica.StateGraph.Transition startupPumpSuccess(
    condition=true,
    enableTimer=true,
    waitTime=t_startup) annotation (Placement(transformation(extent={{30,84},{50,104}},rotation=0)));
  Modelica.StateGraph.StepWithSignal operatingPump(       nOut=1, nIn=2)
                                                                  annotation (Placement(transformation(extent={{70,84},{90,104}},rotation=0)));
  Modelica.StateGraph.StepWithSignal startupPump(nOut=2, nIn=1) annotation (Placement(transformation(extent={{-16,84},{4,104}},rotation=0)));
  Modelica.StateGraph.Transition thresholdPump(
    waitTime=t_eps,
    condition=P_set_star >= P_min_operating_pump + thres,
    enableTimer=true)                             annotation (Placement(transformation(extent={{-48,84},{-28,104}},rotation=0)));
  Modelica.StateGraph.Transition noThreshold(
    enableTimer=true,
    condition=P_set_star < P_min_operating_pump - thres,
    waitTime=t_eps)                                annotation (Placement(transformation(extent={{4,118},{-16,138}},rotation=0)));
  Modelica.StateGraph.Transition noThreshold2(
    condition=P_set_star < P_min_operating_pump - thres,
    enableTimer=true,
    waitTime=t_eps) annotation (Placement(transformation(extent={{44,138},{24,158}},
                                                                                   rotation=0)));

  Modelica.StateGraph.Transition thresholdTurb(
    waitTime=t_eps,
    condition=P_set_star <= -P_min_operating_turb - thres,
    enableTimer=true)                              annotation (Placement(transformation(extent={{-48,50},{-28,70}}, rotation=0)));
  Modelica.StateGraph.StepWithSignal startupTurb(nOut=2, nIn=1) annotation (Placement(transformation(extent={{-16,50},{4,70}}, rotation=0)));
  Modelica.StateGraph.Transition noThreshold1(
    waitTime=t_eps,
    condition=P_set_star > -P_min_operating_turb + thres,
    enableTimer=true)                              annotation (Placement(transformation(extent={{4,20},{-16,40}},  rotation=0)));
  Modelica.StateGraph.Transition startupTurbSuccess(
    condition=true,
    enableTimer=true,
    waitTime=t_startup) annotation (Placement(transformation(extent={{30,50},{50,70}}, rotation=0)));
  Modelica.StateGraph.StepWithSignal operatingTurb(       nOut=1, nIn=2)
                                                                  annotation (Placement(transformation(extent={{70,50},{90,70}}, rotation=0)));
  Modelica.StateGraph.Transition noThreshold3(
    waitTime=t_eps,
    condition=P_set_star > -P_min_operating_turb + thres,
    enableTimer=true)
                    annotation (Placement(transformation(extent={{44,2},{24,22}},  rotation=0)));
  Modelica.StateGraph.InitialStep init(nIn=0, nOut=3) annotation (Placement(transformation(extent={{-128,-90},{-108,-70}})));
  Modelica.StateGraph.Transition initHalt(condition=init_state == TransiEnt.Basics.Types.off) annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Modelica.StateGraph.Transition initOperatingPump(condition=init_state == TransiEnt.Basics.Types.on1) annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Modelica.StateGraph.Transition initOperatingTurb(condition=init_state == TransiEnt.Basics.Types.on2) annotation (Placement(transformation(extent={{10,-90},{30,-70}})));
equation

  // _____________________________________________
  //
  //              Characteristic equations
  // _____________________________________________

  isOperating = not halt.active;

  P_min = if operatingPump.active then P_min_operating_pump elseif operatingTurb.active then -P_max_operating_turb else 0;
  P_max = if operatingPump.active then P_max_operating_pump elseif operatingTurb.active then -P_min_operating_turb else 0;

  P_grad_min = if halt.active then -P_grad_inf elseif (startupPump.active or startupTurb.active) then -P_grad_startup else -P_grad_operating;
  P_grad_max = if halt.active then P_grad_inf elseif (startupPump.active or startupTurb.active) then P_grad_startup else P_grad_operating;

  // _____________________________________________
  //
  //              Connect Statements
  // _____________________________________________

  connect(startupPumpSuccess.outPort, operatingPump.inPort[1]) annotation (Line(points={{41.5,94},{41.5,94.5},{69,94.5}}, color={0,0,0}));
  connect(thresholdPump.inPort, halt.outPort[1]) annotation (Line(points={{-42,94},{-60,94},{-60,86},{-60,76.25},{-62,76.25},{-63.5,76.25}},
                                                                                                    color={0,0,0}));
  connect(thresholdPump.outPort, startupPump.inPort[1]) annotation (Line(points={{-36.5,94},{-17,94}}, color={0,0,0}));
  connect(startupPump.outPort[1], startupPumpSuccess.inPort) annotation (Line(points={{4.5,94.25},{8,94},{36,94}}, color={0,0,0}));
  connect(startupPump.outPort[2], noThreshold.inPort) annotation (Line(points={{4.5,93.75},{16,93.75},{16,96},{16,128},{-2,128}},
                                                                                                    color={0,0,0}));
  connect(noThreshold.outPort,halt. inPort[2]) annotation (Line(points={{-7.5,128},{-86,128},{-86,76.4},{-85,76.4}},
                                                                                                    color={0,0,0}));
  connect(noThreshold2.outPort, halt.inPort[3]) annotation (Line(points={{32.5,148},{32.5,146},{-108,146},{-108,76},{-85,76}},      color={0,0,0}));
  connect(P_max_of_state.y, variableLimiter.limit1) annotation (Line(points={{-71,-20},{-54.6,-20},{-54.6,-20.6}}, color={0,0,127}));
  connect(P_min_of_state.y, variableLimiter.limit2) annotation (Line(
      points={{-71,-42},{-68,-42},{-68,-41.4},{-54.6,-41.4}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(P_grad_max_of_state.y, variableSlewRateLimiter.maxGrad) annotation (Line(
      points={{41,-20},{53.4,-20},{53.4,-20.6}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(P_grad_min_of_state.y, variableSlewRateLimiter.minGrad) annotation (Line(
      points={{41,-42},{46,-42},{46,-41.4},{53.4,-41.4}},
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

  connect(thresholdTurb.outPort, startupTurb.inPort[1]) annotation (Line(points={{-36.5,60},{-17,60}}, color={0,0,0}));
  connect(startupTurb.outPort[1], noThreshold1.inPort) annotation (Line(points={{4.5,60.25},{16,60.25},{16,58},{16,30},{-2,30}},
                                                                                                    color={0,0,0}));
  connect(noThreshold1.outPort, halt.inPort[1]) annotation (Line(points={{-7.5,30},{-86,30},{-86,76.8},{-85,76.8}},
                                                                                                    color={0,0,0}));
  connect(startupTurbSuccess.outPort, operatingTurb.inPort[1]) annotation (Line(points={{41.5,60},{41.5,60.5},{69,60.5}},
                                                                                                    color={0,0,0}));
  connect(noThreshold3.outPort, halt.inPort[4]) annotation (Line(points={{32.5,12},{-90,12},{-90,75.6},{-85,75.6}},     color={0,0,0}));
  connect(startupTurb.outPort[2], startupTurbSuccess.inPort) annotation (Line(points={{4.5,59.75},{14,60},{36,60}}, color={0,0,0}));
  connect(operatingPump.outPort[1], noThreshold2.inPort) annotation (Line(points={{90.5,94},{94,94},{94,96},{94,148},{38,148}}, color={0,0,0}));
  connect(operatingTurb.outPort[1], noThreshold3.inPort) annotation (Line(points={{90.5,60},{94,60},{94,12},{38,12}},   color={0,0,0}));
  connect(halt.outPort[2], thresholdTurb.inPort) annotation (Line(points={{-63.5,75.75},{-60,75.75},{-60,60},{-42,60}}, color={0,0,0}));

  connect(init.outPort[1], initHalt.inPort);
  connect(init.outPort[2], initOperatingPump.inPort);
  connect(init.outPort[3], initOperatingTurb.inPort);
  connect(initHalt.outPort, halt.inPort[5]);
  connect(initOperatingPump.outPort, operatingPump.inPort[2]);
  connect(initOperatingTurb.outPort, operatingTurb.inPort[2]);
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{140,180}})), Icon(graphics,
                                                                                                         coordinateSystem(extent={{-140,-100},{140,180}}, preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Full documentation is not available yet. Please see comments in code or contact author per mail.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
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
<p>Tested in check model &quot;TestPumpstorageStates&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model modified by Oliver Schülting (oliver.schuelting@tuhh.de) on April 2019: added option to deactivate slewRateLimiter</p>
</html>"));
end PumpstorageStates;
