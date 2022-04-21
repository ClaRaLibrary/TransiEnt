within TransiEnt.Components.Heat.Grid;
model PressureDifferenceControl "ClaRa pump regulated by pressure differnce in heat grid "



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
  import TransiEnt;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________
  parameter Modelica.Units.SI.Power P_max=2000 "Maximum electric power of pump";
  parameter Modelica.Units.SI.Power P_min=0.1*P_max "Minimum electric power of pump";

  parameter Modelica.Units.SI.PressureDifference Delta_p_set=1.2e5 "Set pressure at worst hydraulc point";

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid Medium = simCenter.fluid1 "Medium in the component";

  parameter Real k=5 "Gain for PI-Controller" annotation(Dialog(group="PI-Controller"));
  parameter Modelica.Units.SI.Time Tc=1 "Time constant for PI-Controller" annotation (Dialog(group="PI-Controller"));

  parameter Real deviationThreshold=0.1 "Deviation threshold before adjustment control (bar)";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut(Medium=Medium) "fluidport supply on consumer side" annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=Medium) "fluidport return on consumer side" annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.General.PressureDifferenceIn Delta_p_measured "at worst hydraulic point" annotation (Placement(transformation(extent={{-128,30},{-88,70}}), iconTransformation(extent={{-108,50},{-88,70}})));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pump_L1_simple(
    medium=Medium,
    eta_mech=1,
    Delta_p_eps=100,
    showData=false) annotation (Placement(transformation(extent={{22,10},{42,-10}})));

  ClaRa.Components.Sensors.SensorVLE_L1_p returnPressureSensor(medium=Medium) annotation (Placement(transformation(extent={{104,-92},{84,-72}})));
  ClaRa.Components.Sensors.SensorVLE_L1_p supplyPressureSensor1(medium=Medium) annotation (Placement(transformation(extent={{104,-50},{84,-70}})));

  Modelica.Blocks.Sources.Constant p_set_Consumer(k=Delta_p_set)
                                                            annotation (Placement(transformation(extent={{6,-6},{-6,6}}, rotation=90)));
  Modelica.Blocks.Math.Feedback feedbackLoop
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=270,
        origin={-8,50})));
  Modelica.Blocks.Math.Gain gain(k=1) annotation (Placement(transformation(extent={{-66,42},{-50,58}})));
  Modelica.Blocks.Nonlinear.DeadZone deadZone(uMax=deviationThreshold, uMin=-deviationThreshold)
                                                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-8,-40})));
  Modelica.Blocks.Math.Gain pascal2Bar(k=1e-5) annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=-90,
        origin={-8,20})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=P_max, uMin=P_min)
                                                                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={32,-32})));
  TransiEnt.Basics.Blocks.LimPID PID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    use_activateInput=false,
    Tau_lag_I=60,
    k=k,
    y_max=P_max,
    y_min=P_min,
    Tau_i=Tc,
    t_activation=300,
    y_inactive=1000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={32,-64})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
  Modelica.Blocks.Sources.Constant zero(k=0) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=270,
        origin={32,-86})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(waterPortIn, returnPressureSensor.port) annotation (Line(
      points={{-100,0},{-44,0},{-44,-94},{94,-94},{94,-92}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(waterPortOut, supplyPressureSensor1.port) annotation (Line(
      points={{100,0},{94,0},{94,-50}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(pump_L1_simple.outlet, supplyPressureSensor1.port) annotation (Line(
      points={{42,0},{94,0},{94,-50}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));

  connect(waterPortIn, waterPortIn) annotation (Line(
      points={{-100,0},{-100,0}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(pump_L1_simple.inlet, waterPortIn) annotation (Line(
      points={{22,0},{-100,0}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(feedbackLoop.u1,p_set_Consumer.y)  annotation (Line(points={{-8,54.8},{-8,24},{-8,-6.6},{0,-6.6}}, color={0,0,127}));
  connect(gain.y, feedbackLoop.u2) annotation (Line(points={{-49.2,50},{-40,50},{-12.8,50}},        color={0,0,127}));
  connect(gain.u, Delta_p_measured) annotation (Line(points={{-67.6,50},{-108,50}},        color={0,0,127}));
  connect(feedbackLoop.y, pascal2Bar.u) annotation (Line(points={{-8,44.6},{-8,44.6},{-8,29.6}},
                                                                                               color={0,0,127}));
  connect(pascal2Bar.y, deadZone.u) annotation (Line(points={{-8,11.2},{-8,11.2},{-8,-28}}, color={0,0,127}));
  connect(limiter.y, pump_L1_simple.P_drive) annotation (Line(points={{32,-21},{32,-12}}, color={0,0,127}));

  connect(PID.y, limiter.u) annotation (Line(points={{32,-53},{32,-44}},   color={0,0,127}));

  connect(PID.u_m, deadZone.y) annotation (Line(points={{20,-63.9},{16,-63.9},{16,-64},{-8,-64},{-8,-51}}, color={0,0,127}));
  connect(zero.y, PID.u_s) annotation (Line(points={{32,-79.4},{32,-76}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255}),
                              Line(
          points={{-60,80},{100,2},{-60,-80}},
          color={0,0,255},
          smooth=Smooth.None)}),Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Pump regulated due to target pressure difference in hydraulic grid. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>fPReturnConsumer, fPSupplyConsumer - fluid ports</p>
<p>Delta_p_measured - RealInput for measured pressure difference </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Tobias Ramm (tobias.ramm@tuhh.de) November 2015</p>
<p>Model modified by Lisa Andresen (andresen@tuhh.de) December 2015</p>
</html>"));
end PressureDifferenceControl;
