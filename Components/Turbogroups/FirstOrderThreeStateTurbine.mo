within TransiEnt.Components.Turbogroups;
model FirstOrderThreeStateTurbine "Generic model of a turbine with three states (halt / startup / running), pyhsical constraints (Pmin,Pmax,Pgradmax) and first order dynamic"


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
  extends Base.PartialTurbine;


  //  extends Base.PartialTurbine(mpp(tau(start=-P_turb_init/(2*Modelica.Constants.pi*simCenter.f_n), fixed=true)));

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter SI.Power P_n=2e9 "Nominal power" annotation (Dialog(group="Operation Parameter"));

  parameter Real P_min_star=0.2 "Dimensionless minimum power (=20% of nominal power)" annotation (Dialog(group="Operation Parameter"));

  parameter Real P_max_star=1 "Dimensionless maximum power (=Nominal power)" annotation (Dialog(group="Operation Parameter"));

  parameter Real P_grad_max_star=0.12/60 "Dimensionless maximum power gradient per second (12% of P_nom per minute)" annotation (Dialog(group="Operation Parameter"));

  parameter Real P_grad_max_star_primCntrl=0.02/30 "Dimensionless maximum power gradient per second for primary control - default 2% in 30 sec" annotation (Dialog(group="Operation Parameter"));

  parameter SI.Time T_plant=10 "Turbine first order dynamic" annotation (Dialog(group="Operation Parameter"));

  parameter SI.Time t_startup=0 "Startup time (no output during startup)" annotation (Dialog(group="Operation Parameter"));

  parameter SI.Time t_min_operating=0 "Minimum operation time" annotation (Dialog(group="Operation Parameter"));

  parameter SI.Time MinimumDownTime=0 "Minimum time the plant needs to be shut down before starting again" annotation (Dialog(group="Operation Parameter"));

  parameter Base.GradientLimitingChoices gradLimChoice=Base.GradientLimitingChoices.GradLimInFirstOrder "options of gradient limitation" annotation (Evaluate=true, Dialog(group="Assumptions"));

  parameter Boolean useFirstOrderGradLimt=(gradLimChoice > Base.GradientLimitingChoices.GradLimInCntrl) "Activate gradient limitation in first order" annotation (Evaluate=true, Dialog(group="Assumptions"));

  parameter Boolean useSlewRateLimiter=(gradLimChoice == Base.GradientLimitingChoices.GradLimInCntrl) "choose if slewRateLimiter is activated" annotation (Evaluate=true, Dialog(group="Assumptions"));

  parameter Boolean smoothShutDown=true "shut down process will be smoothed - power gradient will be limit by 'P_grad_operating'" annotation (Dialog(group="Assumptions"));

  parameter Real Td=1e-3 "The higher Nd, the closer y follows u" annotation (Dialog(group="Numerical - slew rate limiter"));
  parameter Boolean useThresh=false "Use threshould for suppression of numerical noise" annotation (Dialog(group="Numerical - slew rate limiter"));
  parameter Real thres=1e-7 "If abs(u-y)< thres, y becomes a simple pass through of u. Increasing thres can improve simulation speed. However to large values can make the simulation unstable. 
     A good starting point is the choice thres = tolerance/1000." annotation (Dialog(group="Numerical - slew rate limiter"));
  parameter Boolean useHomotopyVarSlewRateLim=simCenter.useHomotopy "true if homotopy shall be used in variableSlewRateLimiter" annotation (Dialog(group="Numerical - slew rate limiter"));

  parameter Real P_turb_init=0 "Initial or guess value of turbine power (in p.u.)";

  parameter Real thres_hyst=1e-10 "Threshold for hysteresis for switch from halt to startup (chattering might occur, hysteresis might help avoiding this)" annotation (Dialog(group="Numerical"));

  parameter SI.Time t_eps=10 "Threshold time for transitions" annotation (Dialog(group="Numerical"));

  outer SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.BooleanOutput isGeneratorRunning annotation (Placement(transformation(rotation=0, extent={{100,10},{120,30}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_spinning_set "Setpoint for spinning reserve power" annotation (Placement(transformation(
        rotation=270,
        extent={{-12,-12},{12,12}},
        origin={36,98})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Math.Gain normalize(k=1/P_n) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,50})));
  Basics.Blocks.SwitchNoEvent switchOnOff annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Modelica.Blocks.Sources.Constant shutdown(k=0) annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Modelica.Blocks.Math.Gain normalizePbal(k=1/P_n) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={36,48})));

  Modelica.Blocks.Math.MultiSum P_total(nu=2, k={1,1}) annotation (Placement(transformation(
        extent={{-6.5,-6},{6.5,6}},
        rotation=270,
        origin={67.5,-26})));
  Modelica.Blocks.Math.Gain deNormalize(k=P_n) annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=270,
        origin={67,-49})));
  Boundaries.Mechanical.Power MechanicalBoundary annotation (Placement(transformation(extent={{58,-84},{76,-66}})));
  Modelica.Blocks.Nonlinear.Limiter P_max_star_limiter_total(uMax=0, uMin=-P_max_star) "Upper limit is nominal power" annotation (Placement(transformation(extent={{-4,-70},{16,-50}})));

  // _____________________________________________
  //
  //           Diagnostic Variables
  // _____________________________________________

  Real P_set_star=normalize.y;
  Real P_is_star=deNormalize.u;
  replaceable OperatingStates.ThreeStateDynamic operationStatus(
    useSlewRateLimiter=useSlewRateLimiter,
    useHomotopyVarSlewRateLim=useHomotopyVarSlewRateLim,
    t_startup=t_startup,
    P_star_init=P_turb_init/P_n,
    t_min_operating=t_min_operating,
    P_min_operating=P_min_star,
    P_max_operating=P_max_star,
    P_grad_operating=P_grad_max_star,
    smoothShutDown=smoothShutDown,
    thres_hyst=thres_hyst,
    thres=thres,
    useThresh=useThresh,
    P_grad_inf=P_grad_max_star,
    Td=Td,
    t_eps=t_eps,
    MinimumDownTime=MinimumDownTime) constrainedby TransiEnt.Components.Turbogroups.OperatingStates.PartialStateDynamic "Operating State Model" annotation (choicesAllMatching=true, Placement(transformation(extent={{-82,-10},{-62,10}})));

  Basics.Blocks.FirstOrderWithGradientLim plantDynamic(
    Tau=T_plant,
    initOption=2,
    y_start=-P_turb_init/P_n,
    evaluate_y_start=true,
    enable_gradientLimiter=useFirstOrderGradLimt) annotation (Placement(transformation(extent={{24,-70},{44,-50}})));
  Modelica.Blocks.Sources.BooleanExpression isOperating(y=operationStatus.isOperating) annotation (Placement(transformation(extent={{-88,-70},{-68,-50}})));
  Basics.Blocks.FirstOrderWithGradientLim plantPrimaryCtrlDynamic(
    Tau=7,
    initOption=3,                                                 y_start=0, enable_gradientLimiter=useFirstOrderGradLimt) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,0})));
  Modelica.Blocks.Sources.RealExpression primarCntrlMaxGrad(y=P_grad_max_star_primCntrl) if useFirstOrderGradLimt annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={84,52})));
  Modelica.Blocks.Sources.RealExpression primarCntrlMinGrad(y=-P_grad_max_star_primCntrl) if useFirstOrderGradLimt annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={64,52})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(MechanicalBoundary.mpp, mpp) annotation (Line(
      points={{76,-75},{86,-75},{86,-2},{100,-2}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(P_target, normalize.u) annotation (Line(
      points={{0,98},{0,62},{2.22045e-15,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(deNormalize.y, MechanicalBoundary.P_mech_set) annotation (Line(
      points={{67,-56.7},{67,-64.38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_spinning_set, normalizePbal.u) annotation (Line(
      points={{36,98},{36,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(P_max_star_limiter_total.u, switchOnOff.y) annotation (Line(points={{-6,-60},{-19,-60}}, color={0,0,127}));
  connect(normalize.y, operationStatus.P_set_star) annotation (Line(points={{-2.22045e-15,39},{-2.22045e-15,36},{0,36},{0,30},{-94,30},{-94,0},{-82,0}}, color={0,0,127}));
  connect(P_max_star_limiter_total.y, plantDynamic.u) annotation (Line(points={{17,-60},{17,-60},{22,-60}}, color={0,0,127}));
  connect(shutdown.y, switchOnOff.u3) annotation (Line(points={{-59,-80},{-54,-80},{-54,-68},{-42,-68}}, color={0,0,127}));
  connect(operationStatus.P_set_star_lim, switchOnOff.u1) annotation (Line(points={{-60.8,0},{-56,0},{-56,-52},{-42,-52}},           color={0,0,127}));
  connect(plantDynamic.y, P_total.u[1]) annotation (Line(points={{45,-60},{52,-60},{52,-14},{68,-14},{68,-19.5},{69.6,-19.5}}, color={0,0,127}));
  connect(P_total.y, deNormalize.u) annotation (Line(points={{67.5,-33.605},{68,-33.605},{68,-40.6},{67,-40.6}}, color={0,0,127}));
  connect(plantPrimaryCtrlDynamic.y, P_total.u[2]) annotation (Line(points={{70,-11},{70,-18},{68,-18},{68,-19.5},{65.4,-19.5}}, color={0,0,127}));
  connect(plantPrimaryCtrlDynamic.u, normalizePbal.y) annotation (Line(points={{70,12},{70,32},{36,32},{36,37}}, color={0,0,127}));
  connect(switchOnOff.u2, isOperating.y) annotation (Line(points={{-42,-60},{-67,-60}}, color={255,0,255}));
  connect(isGeneratorRunning, isOperating.y) annotation (Line(points={{110,20},{-48,20},{-48,-60},{-67,-60}}, color={255,0,255}));
  connect(operationStatus.P_grad_star_max_out, plantDynamic.maxGrad) annotation (Line(points={{-61.4,-6},{22,-6},{22,-54}}, color={0,0,127}));
  connect(operationStatus.P_grad_star_min_out, plantDynamic.minGrad) annotation (Line(points={{-61.4,-8},{-12,-8},{-12,-76},{22,-76},{22,-66}}, color={0,0,127}));
  connect(primarCntrlMinGrad.y, plantPrimaryCtrlDynamic.minGrad) annotation (Line(points={{64,41},{64,12}}, color={0,0,127}));
  connect(primarCntrlMaxGrad.y, plantPrimaryCtrlDynamic.maxGrad) annotation (Line(points={{84,41},{84,30},{76,30},{76,12}}, color={0,0,127}));
  connect(plantDynamic.y, operationStatus.P_actual_star) annotation (Line(points={{45,-60},{46,-60},{46,-34},{-72,-34},{-72,-10}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(graphics={
        Polygon(
          visible=true,
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          points={{-80,92},{-88,70},{-72,70},{-80,92}}),
        Line(
          visible=true,
          points={{-80,80},{-80,-88}},
          color={192,192,192}),
        Line(
          points={{-80,-80},{20,60}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          visible=true,
          points={{-90,-78},{82,-78}},
          color={192,192,192}),
        Polygon(
          visible=true,
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          points={{90,-78},{68,-70},{68,-86},{90,-78}}),
        Line(
          points={{-50,-18},{-42,-24}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-70,-44},{-62,-50}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-30,10},{-22,4}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-14,34},{-6,28}},
          color={0,0,0},
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Turbine model modeled by </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- minimum / maximum power ouput</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- maximum power gradient</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- on / off status dependent on schedule value without time delay. Turbine shuts down if scheduled value is below minimum power</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">- sends on/off status to momentum of inertia statistics </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Note, that no statistics are involved!</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>mpp: mechanical power port</p>
<p>P_target: input for electric power in W</p>
<p>P_spinning_set: input for electric power in W (setpoint for spinning reserve power)</p>
<p>isGeneratorRunning: BooleanOutput</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The input P_spinning_set is supposed to be gradient limited by limtations of the primary balancing offer mechanism which has normally a higher gradient limit than the rest of the plant.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The input P_target is the sum of secondary balancing setpoint and scheduled set point.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Oliver Schülting (oliver.schuelting@tuhh.de) on April 2019: added minimum operation time</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Robert Flesch (flesch@xrg-simulation.de) in Feb 2021: added choice to apply gradient limit in firstOrder instead of apply limiter in control - avoids numerical problems and improves simulation speed</span></p>
</html>"));
end FirstOrderThreeStateTurbine;
