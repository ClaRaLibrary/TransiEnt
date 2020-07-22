within TransiEnt.Producer.Combined.LargeScaleCHP.Base;
model CHPStates_heatled
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2020, Hamburg University of Technology.                              //
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

  extends TransiEnt.Basics.Icons.Block;

   import TransiEnt.Basics.Types;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer SimCenter simCenter;


  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter SI.Power Q_flow_min_operating=10e3 "Minimum operating thermal power";
  parameter SI.Power Q_flow_max_operating=1e9 "Maximum operating thermal power";
  parameter SI.Time t_startup = 3600 "Startup time";
  parameter SI.Time t_MDT=t_eps "Minimum downtime of plant";
  parameter TransiEnt.Basics.Types.ThermalPlantStatus init_state "State of plant at initialization" annotation (__Dymola_editText=false);
  parameter SI.Time t_eps = 10 "Threshold time for transitions";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_set "Connector of setpoint input signal" annotation (Placement(transformation(extent={{-116,-16},{-84,16}}, rotation=0)));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_set_lim "Limited output signal" annotation (Placement(transformation(extent={{96,-16},{128,16}}, rotation=0)));

  // _____________________________________________
  //
  //            Complex Components
  // _____________________________________________

    inner Modelica.StateGraph.StateGraphRoot
                         stateGraphRoot
      annotation (Placement(transformation(extent={{-98,84},{-84,98}})));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation (Placement(transformation(extent={{-6,-44},{20,-18}})));
  Modelica.Blocks.Sources.RealExpression P_min_of_state(y=-Q_flow_max)
                                                                 annotation (Placement(transformation(extent={{-46,-52},{-26,-32}})));
  Modelica.Blocks.Sources.RealExpression P_max_of_state(y=0)     annotation (Placement(transformation(extent={{-46,-30},{-26,-10}})));


  // _____________________________________________
  //
  //           Variables
  // _____________________________________________

public
  Modelica.StateGraph.InitialStep init(nIn=0, nOut=3) annotation (Placement(transformation(extent={{-94,44},{-74,64}},   rotation=0)));
  Modelica.StateGraph.StepWithSignal
                                  halt(nIn=3) annotation (Placement(transformation(extent={{-46,22},{-26,42}},   rotation=0)));
  Modelica.StateGraph.StepWithSignal operating(        nIn=2, nOut=1)
                                                              annotation (Placement(transformation(extent={{52,22},{72,42}}, rotation=0)));
  Modelica.StateGraph.Transition startupSuccess(
    condition=true,
    enableTimer=true,
    waitTime=t_startup) annotation (Placement(transformation(extent={{32,22},{52,42}},rotation=0)));
  Modelica.StateGraph.StepWithSignal
                           startup(       nOut=2, nIn=2)
                                   annotation (Placement(transformation(extent={{8,22},{28,42}},     rotation=0)));
  Modelica.StateGraph.Transition threshold(
    enableTimer=true,
    condition=Q_flow_set <= -Q_flow_min_operating,
    waitTime=t_MDT)                                                                           annotation (Placement(transformation(extent={{-16,22},{4,42}},    rotation=0)));
  Modelica.StateGraph.Transition noThreshold(
    enableTimer=true,
    waitTime=t_eps,
    condition=Q_flow_set > -Q_flow_min_operating)  annotation (Placement(transformation(extent={{28,56},{8,76}},   rotation=0)));
  Modelica.StateGraph.Transition noThreshold2(
    enableTimer=true,
    waitTime=t_eps,
    condition=Q_flow_set > -Q_flow_min_operating)
                     annotation (Placement(transformation(extent={{68,76},{48,96}}, rotation=0)));

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

SI.Power Q_flow_max;
equation
  Q_flow_max = if operating.active then Q_flow_max_operating else 0;

  // _____________________________________________
  //
  //              Connect Statements
  // _____________________________________________

  connect(P_max_of_state.y, variableLimiter.limit1) annotation (Line(points={{-25,-20},{-8.6,-20},{-8.6,-20.6}},   color={0,0,127}));
  connect(P_min_of_state.y, variableLimiter.limit2) annotation (Line(
      points={{-25,-42},{-20,-42},{-20,-41.4},{-8.6,-41.4}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(variableLimiter.u,Q_flow_set)  annotation (Line(
      points={{-8.6,-31},{-100,-31},{-100,0}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(noThreshold.outPort,halt. inPort[1]) annotation (Line(points={{16.5,66},{-58,66},{-58,32.6667},{-47,32.6667}},
                                                     color={0,0,0}));
  connect(noThreshold2.outPort,halt. inPort[2]) annotation (Line(points={{56.5,86},{-60,86},{-60,32},{-47,32}},
                                           color={0,0,0}));
  connect(halt.outPort[1],threshold. inPort)
    annotation (Line(points={{-25.5,32},{-10,32}},             color={0,0,0}));
  connect(startupSuccess.outPort,operating. inPort[1])
    annotation (Line(points={{43.5,32},{51,32},{51,32.5}}, color={0,0,0}));
  connect(operating.outPort[1],noThreshold2. inPort) annotation (Line(points={{72.5,32},{72,32},{72,86},{62,86}},
                                                   color={0,0,0}));
  connect(threshold.outPort,startup. inPort[1]) annotation (Line(points={{-4.5,32},{2,32},{2,32.5},{7,32.5}},
                                                                                                    color={0,0,0}));
  connect(startup.outPort[1],startupSuccess. inPort) annotation (Line(points={{28.5,32.25},{28.5,32},{38,32}},
                                                                                                    color={0,0,0}));
  connect(startup.outPort[2],noThreshold. inPort) annotation (Line(points={{28.5,31.75},{30,31.75},{30,34},{30,66},{22,66}},         color={0,0,0}));
  connect(variableLimiter.y, Q_flow_set_lim) annotation (Line(points={{21.3,-31},{42,-31},{42,-32},{64,-32},{64,0},{94,0},{94,0},{112,0},{112,0}}, color={0,0,127}));

  // from init to initial transition
  connect(init.outPort[1], initOff.inPort);
  connect(init.outPort[2], initOn.inPort);
  connect(init.outPort[3], initStartup.inPort);

  // from initial transition to state
  connect(halt.inPort[3], initOff.outPort);
  connect(operating.inPort[2], initOn.outPort);
  connect(startup.inPort[2], initStartup.outPort);

  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Icon(graphics={
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
<p>Q_flow_set: input for heat flow rate in [W] (connector for input signal)</p>
<p>Q_flow_set_lim: output for heat flow rate in [W ] (limited output signal)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in check model &quot;TransiEnt.Producer.Combined.LargeScaleCHP.Base.Check.TestCHPStates_heatled&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end CHPStates_heatled;
