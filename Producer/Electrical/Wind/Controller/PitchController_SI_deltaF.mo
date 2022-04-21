within TransiEnt.Producer.Electrical.Wind.Controller;
model PitchController_SI_deltaF "Pitch Controller for WTG with delta_f synthetic inertia control"



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
  extends TransiEnt.Basics.Icons.Controller;

  // _____________________________________________
  //
  //             Parameters
  // _____________________________________________
  parameter TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.WindSpeedOperationRanges turbine=TransiEnt.Producer.Electrical.Wind.Characteristics.VariableSpeed.ExampleTurbineRanges() "Turbine characteristics" annotation (choicesAllMatching=true);
  parameter Real k=5e-5 "Gain of controller";
  parameter SI.Time Ti=14 "Controller integral time constant";
  parameter SI.Time Td=3.5 "Controller derivative time constant";
  parameter Real yMax=30 "Upper limit of PI controlled beta setpoint";
  parameter Real yMin=0 "Lower limit of output";
  parameter Real wp=1 "Set-point weight for Proportional block (0..1)";
  parameter Real Ni=0.9 "Ni*Ti is time constant of anti-windup compensation";

  parameter Real P_el_n "Nominal electric Power";
  parameter Real beta_start "Setpoint for pitch angle";
  parameter Real v_wind_start=0 "Setpoint to determine beta_start";
  parameter Boolean limitsAtInit = true "= false, if limits are ignored during initialization";
  parameter Boolean strict=false "= true, if strict limits with noEvent(..)"
    annotation (Evaluate=true, choices(checkBox=true), Dialog(tab="Advanced"));
  parameter Modelica.Blocks.Types.SimpleController controllerTypePitchCtrl=.Modelica.Blocks.Types.SimpleController.PID "Type of controller";
  // _____________________________________________
  //
  //             Variables
  // _____________________________________________

  input SI.Velocity v_wind( start=v_wind_start) "Wind velocity" annotation(Dialog);

  Modelica.StateGraph.InitialStepWithSignal
                                  halt(nOut=1, nIn=1) annotation (Placement(transformation(extent={{-80,28},
            {-60,48}},                                                                                                   rotation=0)));
  Modelica.StateGraph.Transition cutIn(
    waitTime=0.01,
    enableTimer=false,
    condition=v_wind >= turbine.v_cutIn)                   annotation (Placement(transformation(extent={{-14,28},
            {6,48}},                                                                                                    rotation=0)));
  Modelica.StateGraph.Step partLoad(nOut=2, nIn=2)
                                    annotation (Placement(transformation(extent={{8,28},{
            28,48}},                                                                                 rotation=0)));
  Modelica.StateGraph.Transition nominalSpeed(
    waitTime=0.1,
    enableTimer=false,
    condition=v_wind >= wind_fullload)      annotation (Placement(transformation(extent={{30,28},
            {50,48}},                                                                                       rotation=0)));
  Modelica.StateGraph.StepWithSignal
                           fullLoad(nOut=2, nIn=2)
                                    annotation (Placement(transformation(extent={{52,28},
            {72,48}},                                                                               rotation=0)));
  Modelica.StateGraph.Transition cutOut(
    waitTime=1,
    enableTimer=false,
    condition=v_wind >= turbine.v_cutOut) annotation (Placement(transformation(extent={{80,28},
            {100,48}},                                                                                    rotation=0)));
    inner Modelica.StateGraph.StateGraphRoot
                         stateGraphRoot
      annotation (Placement(transformation(extent={{-72,86},{-58,100}})));
  Modelica.StateGraph.StepWithSignal
                           startup(nOut=2, nIn=2)
                                   annotation (Placement(transformation(extent={{-34,28},
            {-14,48}},                                                                               rotation=0)));
  Modelica.StateGraph.Transition threshold(
    waitTime=0.01,
    enableTimer=false,
    condition=v_wind >= turbine.v_threshold)                               annotation (Placement(transformation(extent={{-58,28},
            {-38,48}},                                                                                                    rotation=0)));
  Modelica.StateGraph.Transition noThreshold(
    waitTime=1,
    enableTimer=false,
    condition=v_wind < turbine.v_threshold) annotation (Placement(transformation(extent={{-14,62},
            {-34,82}},                                                                                      rotation=0)));
  Modelica.StateGraph.Transition noCutIn(
    waitTime=1,
    enableTimer=false,
    condition=v_wind < turbine.v_cutIn) annotation (Placement(transformation(extent={{24,70},
            {4,90}},                                                                                   rotation=0)));
  Modelica.StateGraph.Transition noNominalSpeed(
    waitTime=1,
    enableTimer=false,
    condition=v_wind < 0.95*wind_fullload) annotation (Placement(transformation(extent={{50,76},
            {30,96}},                                                                                     rotation=0)));
  Modelica.Blocks.Sources.Constant beta_halt(k=85) annotation (Placement(transformation(extent={{-96,2},
            {-76,22}})));
  Modelica.Blocks.Sources.Constant beta_startup(k=65) annotation (Placement(transformation(extent={{-34,-4},
            {-14,16}})));
  Modelica.Blocks.Sources.Constant beta_partLoad(k=0) annotation (Placement(transformation(extent={{-96,-28},
            {-76,-8}})));
Modelica.Blocks.Logical.Switch switchToHalt annotation (Placement(transformation(extent={{-64,-6},
            {-44,14}})));
Modelica.Blocks.Logical.Switch switchToStartup annotation (Placement(transformation(extent={{-6,-22},
            {14,-2}})));
  Modelica.Blocks.Math.MultiSum controlValue(nu=3)             annotation (Placement(transformation(extent={{42,-46},
            {54,-34}})));
Modelica.Blocks.Logical.Switch switchToFullLoad annotation (Placement(transformation(extent={{10,-66},
            {30,-46}})));
 TransiEnt.Basics.Interfaces.General.AngleOut beta_set( start=beta_start)
 annotation (Placement(transformation(extent={{152,-74},
            {172,-54}})));
  Modelica.Blocks.Continuous.LimPID PitchController(
    Ti=Ti,
    yMax=yMax,
    yMin=yMin,
    wp=wp,
    Ni=Ni,
    controllerType=controllerTypePitchCtrl,
    Td=Td,
    k=k,
    y_start=beta_start,
    initType=Modelica.Blocks.Types.Init.NoInit) annotation (Placement(transformation(extent={{-38,-60},{-18,-40}})));
  Modelica.Blocks.Interfaces.RealInput
            u_s "Connector of setpoint input signal" annotation (Placement(
        transformation(extent={{-116,-104},{-84,-72}},rotation=0)));
  Modelica.Blocks.Interfaces.RealInput u_m "Connector of measurement input signal" annotation (Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={-100,-38})));

  Modelica.StateGraph.Transition backToFullLoad(
    waitTime=1,
    enableTimer=false,
    condition=v_wind < turbine.v_cutOut) annotation (Placement(transformation(
          extent={{104,58},{84,78}}, rotation=0)));
Modelica.Blocks.Logical.Switch switchToHalt1
                                            annotation (Placement(transformation(extent={{132,-16},
            {152,4}})));
  Modelica.Blocks.Sources.Constant beta_halt1(k=85)
                                                   annotation (Placement(transformation(extent={{76,-8},
            {96,12}})));
  Modelica.StateGraph.StepWithSignal SafetyHalt(nIn=1, nOut=1) annotation (
      Placement(transformation(extent={{110,28},{130,48}}, rotation=0)));
  Modelica.Blocks.Math.MultiSum controlValue1(nu=2)
                                                   annotation (Placement(transformation(extent={{118,-70},
            {130,-58}})));
  Modelica.Blocks.Sources.Constant beta_halt2(k=0) annotation (Placement(transformation(extent={{98,-24},
            {118,-4}})));
  Modelica.Blocks.Logical.Or or1
    annotation (Placement(transformation(extent={{48,-8},{68,12}})));
  TransiEnt.Basics.Interfaces.General.FrequencyIn freq_deviation "Input for frequency deviation" annotation (Placement(
        transformation(
        rotation=90,
        extent={{-10,-10},{10,10}},
        origin={-60,-124})));
  Modelica.Blocks.Math.MultiProduct MultiProduct(nu=2)
    annotation (Placement(transformation(extent={{4,-138},{24,-118}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(
    strict=strict,
    uMin=0,
    uMax=0.1*P_el_n) annotation (Placement(transformation(extent={{34,-138},{54,-118}}, rotation=0)));
  Modelica.Blocks.Math.Gain gain(k=1)
    annotation (Placement(transformation(extent={{-32,-142},{-12,-122}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-22,-104},{-2,-84}})));
  Modelica.Blocks.Continuous.FirstOrder PitchControllerTimeConstant1(T=3)
                                                                         annotation (Placement(transformation(extent={{64,-134},
            {78,-120}})));
Modelica.Blocks.Logical.Switch switchToFullLoad1
                                                annotation (Placement(transformation(extent={{-72,-74},
            {-52,-54}})));
  Modelica.Blocks.Continuous.FirstOrder PitchControllerTimeConstant(T=50, y_start=beta_start)
    annotation (Placement(transformation(extent={{76,-52},{90,-38}})));
  Modelica.Blocks.Continuous.FirstOrder PitchControllerTimeConstant2(T=1)
    annotation (Placement(transformation(extent={{56,-72},{70,-58}})));
 TransiEnt.Basics.Interfaces.Ambient.VelocityIn wind_fullload "Velocity of wind at full load" annotation (Placement(
        transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={-100,80})));
equation
  // _____________________________________________
  //
  //             Equations
  // _____________________________________________

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(threshold.inPort, halt.outPort[1]) annotation (Line(points={{-52,38},
          {-52,38},{-59.5,38}},                                                                         color={0,0,0}));
  connect(threshold.outPort, startup.inPort[1]) annotation (Line(points={{-46.5,
          38},{-40,38},{-40,38.5},{-35,38.5}},                                                      color={0,0,0}));
  connect(switchToHalt.u2, halt.active) annotation (Line(points={{-66,4},{-70,
          4},{-70,27}},                                                                         color={255,0,255}));
  connect(switchToHalt.u1, beta_halt.y) annotation (Line(points={{-66,12},{
          -66,12},{-75,12}},                                                           color={0,0,127}));
  connect(beta_partLoad.y, switchToHalt.u3) annotation (Line(points={{-75,-18},
          {-66,-18},{-66,-4}},                                                                                 color={0,0,127}));
  connect(switchToStartup.u1, beta_startup.y) annotation (Line(points={{-8,-4},
          {-8,6},{-13,6}},                                                                  color={0,0,127}));
  connect(beta_partLoad.y, switchToStartup.u3) annotation (Line(points={{-75,-18},
          {-66,-18},{-66,-20},{-8,-20}},                                                                         color={0,0,127}));
  connect(beta_partLoad.y, switchToFullLoad.u3) annotation (Line(points={{-75,-18},
          {-64,-18},{-64,-34},{-8,-34},{-8,-64},{8,-64}},                                                                             color={0,0,127}));
  connect(SafetyHalt.outPort[1], backToFullLoad.inPort) annotation (Line(points={{130.5,
          38},{156,38},{156,68},{98,68}},        color={0,0,0}));
  connect(noThreshold.outPort, halt.inPort[1]) annotation (Line(points={{-25.5,
          72},{-86,72},{-86,38},{-81,38}}, color={0,0,0}));
  connect(startup.outPort[1], cutIn.inPort) annotation (Line(points={{-13.5,
          38.25},{-10.75,38},{-8,38}},
                                color={0,0,0}));
  connect(noThreshold.inPort, startup.outPort[2]) annotation (Line(points={{-20,72},
          {-10,72},{-10,37.75},{-13.5,37.75}},     color={0,0,0}));
  connect(cutIn.outPort, partLoad.inPort[1])
    annotation (Line(points={{-2.5,38},{7,38},{7,38.5}}, color={0,0,0}));
  connect(noNominalSpeed.outPort, partLoad.inPort[2]) annotation (Line(points={{38.5,86},
          {2,86},{2,37.5},{7,37.5}},          color={0,0,0}));
  connect(partLoad.outPort[1], nominalSpeed.inPort)
    annotation (Line(points={{28.5,38.25},{31.25,38},{36,38}}, color={0,0,0}));
  connect(noCutIn.inPort, partLoad.outPort[2]) annotation (Line(points={{18,80},
          {32,80},{32,37.75},{28.5,37.75}}, color={0,0,0}));
  connect(nominalSpeed.outPort, fullLoad.inPort[1])
    annotation (Line(points={{41.5,38},{51,38},{51,38.5}}, color={0,0,0}));
  connect(backToFullLoad.outPort, fullLoad.inPort[2]) annotation (Line(points={{92.5,68},
          {44,68},{44,37.5},{51,37.5}},          color={0,0,0}));
  connect(fullLoad.outPort[1], cutOut.inPort)
    annotation (Line(points={{72.5,38.25},{76.25,38},{86,38}}, color={0,0,0}));
  connect(noNominalSpeed.inPort, fullLoad.outPort[2]) annotation (Line(points={{44,86},
          {76,86},{76,37.75},{72.5,37.75}},        color={0,0,0}));
  connect(noCutIn.outPort, startup.inPort[2]) annotation (Line(points={{12.5,80},
          {-42,80},{-42,37.5},{-35,37.5}}, color={0,0,0}));
  connect(switchToHalt.y, controlValue.u[1]) annotation (Line(points={{-43,4},
          {20,4},{20,-37.2},{42,-37.2}},   color={0,0,127}));
  connect(switchToStartup.y, controlValue.u[2]) annotation (Line(points={{15,-12},
          {14,-12},{14,-40},{42,-40}},       color={0,0,127}));
  connect(startup.active, switchToStartup.u2) annotation (Line(points={{-24,27},
          {-24,-12},{-8,-12}},     color={255,0,255}));
  connect(switchToHalt1.y, controlValue.u[3]) annotation (Line(points={{153,-6},
          {142,-6},{142,-28},{36,-28},{36,-42.8},{42,-42.8}},  color={0,0,127}));
  connect(beta_halt2.y, switchToHalt1.u3)
    annotation (Line(points={{119,-14},{130,-14}},           color={0,0,127}));
  connect(beta_halt1.y, switchToHalt1.u1) annotation (Line(points={{97,2},{97,
          2},{130,2}},               color={0,0,127}));
  connect(cutOut.outPort, SafetyHalt.inPort[1])
    annotation (Line(points={{91.5,38},{109,38}}, color={0,0,0}));
  connect(fullLoad.active, or1.u2) annotation (Line(points={{62,27},{62,20},{
          38,20},{38,-6},{46,-6}},
                              color={255,0,255}));
  connect(SafetyHalt.active, or1.u1) annotation (Line(points={{120,27},{120,
          18},{42,18},{42,2},{46,2}}, color={255,0,255}));
  connect(or1.y, switchToFullLoad.u2) annotation (Line(points={{69,2},{70,2},
          {70,-24},{4,-24},{4,-56},{8,-56}},             color={255,0,255}));
  connect(switchToHalt1.u2, or1.u1) annotation (Line(points={{130,-6},{120,-6},
          {120,18},{42,18},{42,2},{46,2}}, color={255,0,255}));
  connect(PitchController.y, switchToFullLoad.u1) annotation (Line(points={{-17,-50},
          {-12,-50},{-12,-48},{8,-48}},      color={0,0,127}));
  connect(MultiProduct.y, limiter.u) annotation (Line(points={{25.7,-128},{
          25.7,-128},{32,-128}},
                          color={0,0,127}));
  connect(u_s, add.u1) annotation (Line(points={{-100,-88},{-24,-88}},
                      color={0,0,127}));
  connect(limiter.y, PitchControllerTimeConstant1.u) annotation (Line(points={{55,-128},
          {62.6,-128},{62.6,-127}},        color={0,0,127}));
  connect(beta_set, beta_set) annotation (Line(points={{162,-64},{156,-64},{
          162,-64}}, color={0,0,127}));
  connect(freq_deviation, gain.u) annotation (Line(points={{-60,-124},{-60,
          -132},{-34,-132}}, color={0,0,127}));
  connect(PitchControllerTimeConstant1.y, add.u2) annotation (Line(points={{
          78.7,-127},{84,-127},{84,-108},{-30,-108},{-30,-100},{-24,-100}},
        color={0,0,127}));
  connect(switchToFullLoad1.u2, switchToFullLoad.u2) annotation (Line(points=
          {{-74,-64},{-86,-64},{-86,-44},{-52,-44},{-52,-24},{4,-24},{4,-56},
          {8,-56}}, color={255,0,255}));
  connect(PitchController.u_m, add.y) annotation (Line(points={{-28,-62},{-28,
          -76},{6,-76},{6,-94},{-1,-94}}, color={0,0,127}));
  connect(u_m, switchToFullLoad1.u1) annotation (Line(points={{-100,-38},{-82,
          -38},{-82,-56},{-74,-56}}, color={0,0,127}));
  connect(controlValue1.y, beta_set) annotation (Line(points={{131.02,-64},{
          162,-64},{162,-64}}, color={0,0,127}));
  connect(controlValue.y, PitchControllerTimeConstant.u) annotation (Line(
        points={{55.02,-40},{58,-40},{58,-42},{62,-42},{62,-45},{74.6,-45}},
        color={0,0,127}));
  connect(PitchControllerTimeConstant.y, controlValue1.u[1]) annotation (Line(
        points={{90.7,-45},{98,-45},{98,-61.9},{118,-61.9}}, color={0,0,127}));
  connect(switchToFullLoad.y, PitchControllerTimeConstant2.u) annotation (
      Line(points={{31,-56},{34,-56},{34,-58},{40,-58},{40,-65},{54.6,-65}},
        color={0,0,127}));
  connect(switchToFullLoad1.y, PitchController.u_s) annotation (Line(points={
          {-51,-64},{-46,-64},{-46,-50},{-40,-50}}, color={0,0,127}));
  connect(switchToFullLoad1.u3, beta_partLoad.y) annotation (Line(points={{
          -74,-72},{-78,-72},{-78,-34},{-72,-34},{-72,-18},{-75,-18}}, color=
          {0,0,127}));
  connect(PitchControllerTimeConstant2.y, controlValue1.u[2]) annotation (
      Line(points={{70.7,-65},{90,-65},{90,-66.1},{118,-66.1}}, color={0,0,
          127}));
  connect(MultiProduct.u[1], add.u1) annotation (Line(points={{4,-124.5},{-4,
          -124.5},{-4,-110},{-40,-110},{-40,-88},{-24,-88}}, color={0,0,127}));
  connect(gain.y, MultiProduct.u[2]) annotation (Line(points={{-11,-132},{4,
          -132},{4,-131.5}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -140},{160,100}}), graphics={Text(
          extent={{-126,-62},{-114,-82}},
          lineColor={28,108,200},
          textString="P_N"), Text(
          extent={{-118,-36},{-106,-56}},
          lineColor={28,108,200},
          textString="P_is")}),                                                                     Icon(
        coordinateSystem(extent={{-100,-140},{160,100}}),                                                graphics={
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
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Pitch Controller with synthetic Inertia control depending on frequency deviation (delta f).</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quasistationary model for real power simulation only.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">beta_set: output for angle </span></p>
<p>u_s: Modelica RealInput</p>
<p>u_m: Modelica RealInput</p>
<p>freq_deviation: input for frequency deviation in Hz</p>
<p>wind_fullload: input for velocity of wind in m/s</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Validated according to reference stated below.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Miller, N. et al: &quot;GE Wind Plant Dynamic Performance for Grid and Wind Events&quot;</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Rebekka Denninger (rebekka.denninger@tuhh.de) on June 21 2016</span></p>
</html>"));
end PitchController_SI_deltaF;
