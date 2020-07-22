within TransiEnt.Producer.Electrical.Wind.Controller;
model PitchController
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

    extends TransiEnt.Basics.Icons.Controller;
  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Characteristics.VariableSpeed.WindSpeedOperationRanges turbine=Characteristics.VariableSpeed.ExampleTurbineRanges() "Turbine chearcteristics" annotation (choicesAllMatching=true);
  parameter Real k=5e-5 "Gain of controller";
  parameter SI.Time Ti=14 "Controller integral time constant";
  parameter SI.Time Td=3.5 "Controller derivative time constant";
  parameter Real yMax=30 "Upper limit of PI controlled beta setpoint";
  parameter Real yMin=0 "Lower limit of output";
  parameter Real wp=1 "Set-point weight for Proportional block (0..1)";
  parameter Real Ni=0.9 "Ni*Ti is time constant of anti-windup compensation";

  parameter Real beta_start=85 "Setpoint for pitch angle";
  parameter Real v_wind_start=0 "Setpoint to determine beta_start";

  parameter Modelica.Blocks.Types.SimpleController controllerTypePitchCtrl=.Modelica.Blocks.Types.SimpleController.PID "Type of controller";

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
  input SI.Velocity v_wind( start=v_wind_start) "Wind velocity" annotation(Dialog);

  Modelica.StateGraph.InitialStepWithSignal
                                  halt(nOut=1, nIn=1) annotation (Placement(transformation(extent={{-80,20},{-60,40}},   rotation=0)));
  Modelica.StateGraph.Transition cutIn(
    waitTime=1,
    enableTimer=false,
    condition=v_wind >= turbine.v_cutIn)                   annotation (Placement(transformation(extent={{-14,20},
            {6,40}},                                                                                                    rotation=0)));
  Modelica.StateGraph.Step partLoad(nOut=2, nIn=2)
                                    annotation (Placement(transformation(extent={{8,20},{28,40}},    rotation=0)));
  Modelica.StateGraph.Transition nominalSpeed(
    waitTime=1,
    enableTimer=false,
    condition=v_wind >= turbine.v_fullLoad) annotation (Placement(transformation(extent={{30,20},{50,40}},  rotation=0)));
  Modelica.StateGraph.StepWithSignal
                           fullLoad(nOut=2, nIn=2)
                                    annotation (Placement(transformation(extent={{52,20},{72,40}},  rotation=0)));
  Modelica.StateGraph.Transition cutOut(
    waitTime=1,
    enableTimer=false,
    condition=v_wind >= turbine.v_cutOut) annotation (Placement(transformation(extent={{80,20},
            {100,40}},                                                                                    rotation=0)));
    inner Modelica.StateGraph.StateGraphRoot
                         stateGraphRoot
      annotation (Placement(transformation(extent={{-72,78},{-58,92}})));
  Modelica.StateGraph.StepWithSignal
                           startup(nOut=2, nIn=2)
                                   annotation (Placement(transformation(extent={{-34,20},{-14,40}},  rotation=0)));
  Modelica.StateGraph.Transition threshold(
    waitTime=1,
    enableTimer=false,
    condition=v_wind >= turbine.v_threshold)                               annotation (Placement(transformation(extent={{-58,20},{-38,40}},  rotation=0)));
  Modelica.StateGraph.Transition noThreshold(
    waitTime=1,
    enableTimer=false,
    condition=v_wind < turbine.v_threshold) annotation (Placement(transformation(extent={{-14,54},{-34,74}},rotation=0)));
  Modelica.StateGraph.Transition noCutIn(
    waitTime=1,
    enableTimer=false,
    condition=v_wind < turbine.v_cutIn) annotation (Placement(transformation(extent={{24,62},{4,82}},  rotation=0)));
  Modelica.StateGraph.Transition noNominalSpeed(
    waitTime=1,
    enableTimer=false,
    condition=v_wind < turbine.v_fullLoad) annotation (Placement(transformation(extent={{50,68},{30,88}}, rotation=0)));
  Modelica.Blocks.Sources.Constant beta_halt(k=85) annotation (Placement(transformation(extent={{-96,-6},
            {-76,14}})));
  Modelica.Blocks.Sources.Constant beta_startup(k=65) annotation (Placement(transformation(extent={{-34,-12},
            {-14,8}})));
  Modelica.Blocks.Sources.Constant beta_partLoad(k=0) annotation (Placement(transformation(extent={{-96,-36},
            {-76,-16}})));
Modelica.Blocks.Logical.Switch switchToHalt annotation (Placement(transformation(extent={{-64,-14},
            {-44,6}})));
Modelica.Blocks.Logical.Switch switchToStartup annotation (Placement(transformation(extent={{-6,-30},
            {14,-10}})));
  Modelica.Blocks.Math.MultiSum controlValue(nu=3, y(
                                                   start = 85))
                                                               annotation (Placement(transformation(extent={{56,-68},
            {68,-56}})));
Modelica.Blocks.Logical.Switch switchToFullLoad annotation (Placement(transformation(extent={{18,-88},
            {38,-68}})));
 Modelica.Blocks.Interfaces.RealOutput beta_set( start=beta_start) annotation (Placement(transformation(extent={{124,-88},
            {144,-68}})));
  Modelica.Blocks.Continuous.LimPID PitchController(
    Ti=Ti,
    yMax=yMax,
    yMin=yMin,
    wp=wp,
    Ni=Ni,
    controllerType=controllerTypePitchCtrl,
    Td=Td,
    k=k)                                                      annotation (Placement(transformation(extent={{-60,-72},
            {-40,-52}})));
  Modelica.Blocks.Interfaces.RealInput
            u_s "Connector of setpoint input signal" annotation (Placement(
        transformation(extent={{-116,-96},{-84,-64}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealInput u_m "Connector of measurement input signal" annotation (Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={-100,60})));

  Modelica.StateGraph.Transition backToFullLoad(
    waitTime=1,
    enableTimer=false,
    condition=v_wind < turbine.v_cutOut) annotation (Placement(transformation(
          extent={{104,50},{84,70}}, rotation=0)));
Modelica.Blocks.Logical.Switch switchToHalt1
                                            annotation (Placement(transformation(extent={{132,-24},
            {152,-4}})));
  Modelica.Blocks.Sources.Constant beta_halt1(k=85)
                                                   annotation (Placement(transformation(extent={{88,-16},
            {108,4}})));
  Modelica.StateGraph.StepWithSignal SafetyHalt(nIn=1, nOut=1) annotation (
      Placement(transformation(extent={{110,20},{130,40}}, rotation=0)));
  Modelica.Blocks.Continuous.FirstOrder PitchControllerTimeConstant(T=5) annotation (Placement(transformation(extent={{76,-70},
            {90,-56}})));
  Modelica.Blocks.Math.MultiSum controlValue1(
                                             nu=2) annotation (Placement(transformation(extent={{100,-84},
            {112,-72}})));
  Modelica.Blocks.Sources.Constant beta_halt2(k=0) annotation (Placement(transformation(extent={{88,-46},
            {108,-26}})));
  Modelica.Blocks.Logical.Or or1
    annotation (Placement(transformation(extent={{54,-16},{74,4}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(threshold.inPort, halt.outPort[1]) annotation (Line(points={{-52,30},{-52,30},{-59.5,30}},    color={0,0,0}));
  connect(threshold.outPort, startup.inPort[1]) annotation (Line(points={{-46.5,
          30},{-40,30},{-40,30.5},{-35,30.5}},                                                      color={0,0,0}));
  connect(switchToHalt.u2, halt.active) annotation (Line(points={{-66,-4},{
          -70,-4},{-70,19}},                                                                    color={255,0,255}));
  connect(switchToHalt.u1, beta_halt.y) annotation (Line(points={{-66,4},{-66,
          4},{-75,4}},                                                                 color={0,0,127}));
  connect(beta_partLoad.y, switchToHalt.u3) annotation (Line(points={{-75,-26},
          {-66,-26},{-66,-12}},                                                                                color={0,0,127}));
  connect(switchToStartup.u1, beta_startup.y) annotation (Line(points={{-8,-12},
          {-8,-2},{-13,-2}},                                                                color={0,0,127}));
  connect(beta_partLoad.y, switchToStartup.u3) annotation (Line(points={{-75,-26},
          {-66,-26},{-66,-28},{-8,-28}},                                                                         color={0,0,127}));
  connect(beta_partLoad.y, switchToFullLoad.u3) annotation (Line(points={{-75,-26},
          {-64,-26},{-64,-42},{-8,-42},{-8,-86},{16,-86}},                                                                            color={0,0,127}));
  connect(SafetyHalt.outPort[1], backToFullLoad.inPort) annotation (Line(points={{130.5,
          30},{156,30},{156,60},{98,60}},        color={0,0,0}));
  connect(noThreshold.outPort, halt.inPort[1]) annotation (Line(points={{-25.5,64},
          {-86,64},{-86,30},{-81,30}},     color={0,0,0}));
  connect(startup.outPort[1], cutIn.inPort) annotation (Line(points={{-13.5,30.25},
          {-10.75,30},{-8,30}}, color={0,0,0}));
  connect(noThreshold.inPort, startup.outPort[2]) annotation (Line(points={{-20,
          64},{-10,64},{-10,29.75},{-13.5,29.75}}, color={0,0,0}));
  connect(cutIn.outPort, partLoad.inPort[1])
    annotation (Line(points={{-2.5,30},{7,30},{7,30.5}}, color={0,0,0}));
  connect(noNominalSpeed.outPort, partLoad.inPort[2]) annotation (Line(points={{
          38.5,78},{2,78},{2,29.5},{7,29.5}}, color={0,0,0}));
  connect(partLoad.outPort[1], nominalSpeed.inPort)
    annotation (Line(points={{28.5,30.25},{31.25,30},{36,30}}, color={0,0,0}));
  connect(noCutIn.inPort, partLoad.outPort[2]) annotation (Line(points={{18,72},
          {32,72},{32,29.75},{28.5,29.75}}, color={0,0,0}));
  connect(nominalSpeed.outPort, fullLoad.inPort[1])
    annotation (Line(points={{41.5,30},{51,30},{51,30.5}}, color={0,0,0}));
  connect(backToFullLoad.outPort, fullLoad.inPort[2]) annotation (Line(points={{
          92.5,60},{44,60},{44,29.5},{51,29.5}}, color={0,0,0}));
  connect(fullLoad.outPort[1], cutOut.inPort)
    annotation (Line(points={{72.5,30.25},{76.25,30},{86,30}}, color={0,0,0}));
  connect(noNominalSpeed.inPort, fullLoad.outPort[2]) annotation (Line(points={{
          44,78},{76,78},{76,29.75},{72.5,29.75}}, color={0,0,0}));
  connect(noCutIn.outPort, startup.inPort[2]) annotation (Line(points={{12.5,72},
          {-42,72},{-42,29.5},{-35,29.5}}, color={0,0,0}));
  connect(switchToHalt.y, controlValue.u[1]) annotation (Line(points={{-43,-4},
          {20,-4},{20,-59.2},{56,-59.2}},  color={0,0,127}));
  connect(switchToStartup.y, controlValue.u[2]) annotation (Line(points={{15,-20},
          {14,-20},{14,-62},{56,-62}},       color={0,0,127}));
  connect(startup.active, switchToStartup.u2) annotation (Line(points={{-24,19},
          {-24,-20},{-8,-20}},     color={255,0,255}));
  connect(PitchController.y, switchToFullLoad.u1)
    annotation (Line(points={{-39,-62},{-12,-62},{-12,-70},{16,-70}},
                                                  color={0,0,127}));
  connect(u_s, PitchController.u_m) annotation (Line(points={{-100,-80},{-76,
          -80},{-50,-80},{-50,-74}},         color={0,0,127}));
  connect(u_m, PitchController.u_s) annotation (Line(points={{-100,60},{-100,
          -62},{-62,-62}},
                      color={0,0,127}));
  connect(controlValue.y, PitchControllerTimeConstant.u) annotation (Line(
        points={{69.02,-62},{74.6,-62},{74.6,-63}}, color={0,0,127}));
  connect(PitchControllerTimeConstant.y, controlValue1.u[1]) annotation (Line(
        points={{90.7,-63},{96,-63},{96,-75.9},{100,-75.9}},     color={0,0,127}));
  connect(switchToFullLoad.y, controlValue1.u[2]) annotation (Line(points={{39,-78},
          {100,-78},{100,-80.1}},   color={0,0,127}));
  connect(beta_set, beta_set) annotation (Line(points={{134,-78},{134,-78}},
                  color={0,0,127}));
  connect(switchToHalt1.y, controlValue.u[3]) annotation (Line(points={{153,-14},
          {158,-14},{158,-52},{52,-52},{52,-64.8},{56,-64.8}}, color={0,0,127}));
  connect(beta_halt2.y, switchToHalt1.u3)
    annotation (Line(points={{109,-36},{130,-36},{130,-22}}, color={0,0,127}));
  connect(beta_halt1.y, switchToHalt1.u1) annotation (Line(points={{109,-6},{
          116,-6},{130,-6}},         color={0,0,127}));
  connect(cutOut.outPort, SafetyHalt.inPort[1])
    annotation (Line(points={{91.5,30},{109,30}}, color={0,0,0}));
  connect(fullLoad.active, or1.u2) annotation (Line(points={{62,19},{62,12},{
          38,12},{38,-14},{52,-14}},
                              color={255,0,255}));
  connect(SafetyHalt.active, or1.u1) annotation (Line(points={{120,19},{120,
          10},{42,10},{42,-6},{52,-6}},
                                      color={255,0,255}));
  connect(or1.y, switchToFullLoad.u2) annotation (Line(points={{75,-6},{78,-6},
          {78,4},{78,-34},{6,-34},{6,-78},{16,-78}},     color={255,0,255}));
  connect(switchToHalt1.u2, or1.u1) annotation (Line(points={{130,-14},{120,
          -14},{120,10},{42,10},{42,-6},{52,-6}}, color={255,0,255}));
  connect(controlValue1.y, beta_set) annotation (Line(points={{113.02,-78},{
          134,-78},{134,-78}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -120},{160,100}}), graphics={Text(
          extent={{-126,-62},{-114,-82}},
          lineColor={28,108,200},
          textString="P_N"), Text(
          extent={{-102,-138},{-90,-158}},
          lineColor={28,108,200},
          textString="P_is")}),                                                                     Icon(
        coordinateSystem(extent={{-100,-120},{160,100}}),                                                graphics={
      Rectangle(
        origin={-72,0},
        fillColor={255,255,255},
        extent={{-20.0,-20.0},{20.0,20.0}}),
      Line(origin={-37,0},     points={{15.0,0.0},{-15.0,0.0}}),
      Polygon(
        origin={-18.6667,0},
        pattern=LinePattern.None,
        fillPattern=FillPattern.Solid,
        points={{-3.3333,10.0},{16.667,0.0},{-3.3333,-10.0}}),
      Line(points={{-2,50},{-2,-50}}),
      Line(origin={13,0},       points={{15.0,0.0},{-15.0,-0.0}}),
      Polygon(
        origin={31.3333,0},
        pattern=LinePattern.None,
        fillPattern=FillPattern.Solid,
        points={{-3.3333,10.0},{16.667,0.0},{-3.3333,-10.0}}),
      Rectangle(
        origin={68,0},
        fillColor={255,255,255},
        extent={{-20.0,-20.0},{20.0,20.0}})}),
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
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end PitchController;
