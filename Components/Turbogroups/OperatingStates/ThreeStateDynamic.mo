within TransiEnt.Components.Turbogroups.OperatingStates;
model ThreeStateDynamic "Three state dynamic model - operating at init"

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

  extends TransiEnt.Components.Turbogroups.OperatingStates.PartialStateDynamic;
   import TransiEnt.Basics.Types;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

   parameter SI.Time t_startup = 3600 "Startup time";
   parameter Real P_min_operating = 0.3 "Minimum power  (p.u.)";
  parameter Real P_max_operating = 1 "Maximum power (p.u.)";

  parameter SI.Frequency P_grad_startup = P_grad_inf "Maximum Gradient during startup";
  parameter SI.Frequency P_grad_operating = 0.02/60 "Maximum Gradient during operation";
  parameter TransiEnt.Basics.Types.ThermalPlantStatus init_state=if P_star_init < P_min_operating then 0 else 1 "State of plant at initialization" annotation (__Dymola_editText=false);

  // _____________________________________________
  //
  //            Complex Components
  // _____________________________________________

  Modelica.StateGraph.StepWithSignal
                                  halt(nIn=4) annotation (Placement(transformation(extent={{-50,10},{-30,30}},   rotation=0)));
  Modelica.StateGraph.StepWithSignal operating(nOut=2, nIn=3) annotation (Placement(transformation(extent={{46,10},{66,30}}, rotation=0)));

  // _____________________________________________
  //
  //           Variables
  // _____________________________________________

  Modelica.StateGraph.Transition startupSuccess(
    condition=true,
    enableTimer=true,
    waitTime=t_startup) annotation (Placement(transformation(extent={{32,20},{52,40}},rotation=0)));
  Modelica.StateGraph.StepWithSignal
                           startup(       nOut=2, nIn=2)
                                   annotation (Placement(transformation(extent={{6,20},{26,40}},     rotation=0)));
  Modelica.StateGraph.Transition threshold(
    enableTimer=true,
    waitTime=t_eps,
    condition=P_set_star <= -P_min_operating + Modelica.Constants.eps)                        annotation (Placement(transformation(extent={{-18,20},{2,40}},    rotation=0)));
  Modelica.StateGraph.Transition noThreshold(
    enableTimer=true,
    waitTime=t_eps,
    condition=P_set_star > -P_min_operating + Modelica.Constants.eps)
                                                   annotation (Placement(transformation(extent={{26,54},{6,74}},   rotation=0)));
  Modelica.StateGraph.Transition noThreshold2(
    enableTimer=true,
    waitTime=t_eps,
    condition=P_set_star > -P_min_operating + Modelica.Constants.eps)
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
  Modelica.StateGraph.InitialStep init(nIn=0, nOut=3) annotation (Placement(transformation(extent={{-94,42},{-74,62}},   rotation=0)));
equation
  // _____________________________________________
  //
  //              Characteristic equations
  // _____________________________________________

  isOperating = not halt.active;

  P_min = if operating.active then -P_max_operating else 0;
  P_max = if operating.active then -P_min_operating else 0;
  P_grad_min = if halt.active then -P_grad_inf elseif startup.active then -P_grad_startup else -P_grad_operating;
  P_grad_max = if halt.active then P_grad_inf elseif startup.active then P_grad_startup else P_grad_operating;

  // _____________________________________________
  //
  //              Connect Statements
  // _____________________________________________

  connect(noThreshold.outPort, halt.inPort[1]) annotation (Line(points={{14.5,64},{-60,64},{-60,20.75},{-51,20.75}},
                                                     color={0,0,0}));
  connect(noThreshold2.outPort, halt.inPort[2]) annotation (Line(points={{54.5,84},{-62,84},{-62,20.25},{-51,20.25}},
                                           color={0,0,0}));
  connect(halt.outPort[1], threshold.inPort)
    annotation (Line(points={{-29.5,20},{-12,20},{-12,30}},    color={0,0,0}));
  connect(startupSuccess.outPort, operating.inPort[1])
    annotation (Line(points={{43.5,30},{45,30},{45,20.6667}},
                                                           color={0,0,0}));
  connect(operating.outPort[1], noThreshold2.inPort) annotation (Line(points={{66.5,20.25},{70,20.25},{70,84},{60,84}},
                                                   color={0,0,0}));
  connect(threshold.outPort,startup. inPort[1]) annotation (Line(points={{-6.5,30},{0,30},{0,30.5},{5,30.5}},
                                                                                                    color={0,0,0}));
  connect(startup.outPort[1],startupSuccess. inPort) annotation (Line(points={{26.5,30.25},{30,30},{38,30}},
                                                                                                    color={0,0,0}));
  connect(startup.outPort[2],noThreshold. inPort) annotation (Line(points={{26.5,29.75},{28,29.75},{28,32},{28,64},{20,64}},         color={0,0,0}));

   // ------------- Inititalization ----------------
  // from init to initial transition
  connect(init.outPort[1], initOff.inPort);
  connect(init.outPort[2], initOn.inPort);
  connect(init.outPort[3], initStartup.inPort);

  // from initial transition to state
  connect(halt.inPort[3], initOff.outPort);
  connect(operating.inPort[2], initOn.outPort);
  connect(startup.inPort[2], initStartup.outPort);

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
end ThreeStateDynamic;
