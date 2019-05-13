within TransiEnt.Components.Heat.Grid;
model PressureControl_p_input "ClaRa pump regulated by pressure in heat grid "

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
  import TransiEnt;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________
  parameter Modelica.SIunits.Power P_max= 2000 "Maximum electric power of pump";
  parameter Modelica.SIunits.Power P_min=0.1*P_max "Minimum electric power of pump";

  parameter Modelica.SIunits.Pressure p_set = 6.5e5 "Set pressure at worst hydraulc point";

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid Medium = simCenter.fluid1 "Medium in the component";

  parameter Real k=0.5 "Gain for PI-Controller" annotation(Dialog(group="PI-Controller"));
  parameter Modelica.SIunits.Time Tc=3 "Time constant for PI-Controller" annotation(Dialog(group="PI-Controller"));

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
  TransiEnt.Basics.Interfaces.General.PressureIn p_measured "at worst hydraulic point" annotation (Placement(transformation(extent={{-128,30},{-88,70}}), iconTransformation(extent={{-108,50},{-88,70}})));
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pump_L1_simple(
    medium=Medium,
    eta_mech=1,
    Delta_p_eps=1000,
    showData=false) annotation (Placement(transformation(extent={{22,10},{42,-10}})));

  ClaRa.Components.Sensors.SensorVLE_L1_p returnPressureSensor(medium=Medium) annotation (Placement(transformation(extent={{90,-92},{70,-72}})));
  ClaRa.Components.Sensors.SensorVLE_L1_p supplyPressureSensor1(medium=Medium) annotation (Placement(transformation(extent={{90,-50},{70,-70}})));
  Modelica.Blocks.Continuous.PI PI(
    x_start=1000,
    y_start=1000,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T=Tc,
    k=k)                                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={32,-66})));

  Modelica.Blocks.Sources.Constant p_soll_Consumer(k=p_set) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=90,
        origin={-10,72})));
  Modelica.Blocks.Math.Feedback feedbackLoop
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=270,
        origin={-10,50})));
  Modelica.Blocks.Math.Gain gain(k=1) annotation (Placement(transformation(extent={{-70,42},{-54,58}})));
  Modelica.Blocks.Nonlinear.DeadZone deadZone(uMax=deviationThreshold, uMin=-deviationThreshold)
                                                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,-40})));
  Modelica.Blocks.Math.Gain pascal2Bar(k=1e-5) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,20})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=P_max, uMin=P_min)
                                                                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={32,-32})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(waterPortIn, returnPressureSensor.port) annotation (Line(
      points={{-100,0},{-42,0},{-42,-94},{80,-94},{80,-92}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(waterPortOut, supplyPressureSensor1.port) annotation (Line(
      points={{100,0},{80,0},{80,-50}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(pump_L1_simple.outlet, supplyPressureSensor1.port) annotation (Line(
      points={{42,0},{80,0},{80,-50}},
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
  connect(feedbackLoop.u1, p_soll_Consumer.y) annotation (Line(points={{-10,54.8},{-10,65.4}},      color={0,0,127}));
  connect(gain.y, feedbackLoop.u2) annotation (Line(points={{-53.2,50},{-53.2,50},{-14.8,50}},      color={0,0,127}));
  connect(gain.u, p_measured) annotation (Line(points={{-71.6,50},{-71.6,50},{-108,50}},
                                                                                     color={0,0,127}));
  connect(deadZone.y, PI.u) annotation (Line(points={{-10,-51},{-10,-51},{-10,-84},{32,-84},{32,-78}},
                                                                                                    color={0,0,127}));
  connect(feedbackLoop.y, pascal2Bar.u) annotation (Line(points={{-10,44.6},{-10,44.6},{-10,32}},
                                                                                       color={0,0,127}));
  connect(pascal2Bar.y, deadZone.u) annotation (Line(points={{-10,9},{-10,9},{-10,-28}},   color={0,0,127}));
  connect(limiter.y, pump_L1_simple.P_drive) annotation (Line(points={{32,-21},{32,-12}}, color={0,0,127}));
  connect(limiter.u, PI.y) annotation (Line(points={{32,-44},{32,-44},{32,-55}}, color={0,0,127}));

  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
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
<p>Regulated pump due to a target pressure in hydraulic grid.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>waterPortIn: fluidport supply on consumer side</p>
<p>waterPortOut: fluidport return on consumer side</p>
<p>p_measured: input for pressure in Pa</p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Tobias Ramm (tobias.ramm@tuhh.de) November 2015</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Lisa Andresen (andresen@tuhh.de) December 2015</span></p>
</html>"));
end PressureControl_p_input;
