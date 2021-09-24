within TransiEnt.Components.Turbogroups;
model Hydroturbine "Model of a hydro turbine with six states (halt / starup / running in pump / turbine mode), pyhsical constraints (Pmin,Pmax,Pgradmax) and first order dynamics"

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

  extends Base.PartialTurbine;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  // parameter SI.Power P_nom=2e9 "Nominal power";
  // parameter SI.Time t_eps = 10;
  // parameter SI.Time t_startup = 3600;
  // parameter Real y_min_operating_pump = 0.3;
  // parameter Real y_min_operating_turb = 0.3;
  // parameter Real y_max_operating_pump = 1;
  // parameter Real y_max_operating_turb = 1;
  // parameter SI.Frequency y_grad_startup = 1/t_startup;
  // parameter SI.Frequency y_grad_operating = 0.02/60;
  // parameter SI.Frequency y_grad_inf=1;

  parameter SI.Power P_n=1e6 "Nominal power of plant";

  parameter Real P_min_star_turb=0.2 "Dimensionless minimum power of turbine (=20% of nominal power)";

  parameter Real P_min_star_pump=0.2 "Dimensionless minimum power of pump (=20% of nominal power)";

  parameter Real P_max_star_turb=1 "Dimensionless maximum power of turbine (=Nominal power)";

  parameter Real P_max_star_pump=1 "Dimensionless maximum power of pump (=Nominal power)";

  parameter Real P_grad_max_star=0.12/60 "Dimensionless maximum power gradient per second (12% of P_nom per minute)";

  parameter Real Td=1e-3 "The higher Nd, the closer y follows u"
                                            annotation(Dialog(group="Numerical"));
  parameter Boolean useThresh=false "Use threshould for suppression of numerical noise"
                                                         annotation(Dialog(group="Numerical"));
  parameter Real thres=1e-7 "If abs(u-y)< thres, y becomes a simple pass through of u. Increasing thres can improve simulation speed. However to large values can make the simulation unstable. 
     A good starting point is the choice thres = tolerance/1000."  annotation(Dialog(group="Numerical"));

  parameter Real P_turb_init=0 "Initial or guess value of turbine power (in p.u.)";

  parameter SI.Time T_plant=10 "Turbine first order dynamic";

  parameter SI.Time t_startup=0 "Startup time (no output during startup)";

  //parameter SI.Time t_shutdown=60 "Time it takes to disconnect from grid (P=P_set during shutdown)";

  parameter Real thres_hyst=1e-10 "Threshold for hysteresis for switch from halt to startup (chattering might occur, hysteresis might help avoiding this)" annotation(Dialog(group="Numerical"));

  parameter SI.Time t_eps=10 "Threshold time for transitions" annotation(Dialog(group="Numerical"));

  parameter Boolean useSlewRateLimiter=true "choose if slewRateLimiter is activated";

  outer SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.BooleanOutput isGeneratorRunning annotation (
      Placement(transformation(rotation=0, extent={{100,10},{120,30}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Math.Gain normalize(k=1/P_n) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,12})));

  Modelica.Blocks.Math.Gain deNormalize(k=P_n) annotation (Placement(transformation(extent={{56,6},{68,18}})));
  Boundaries.Mechanical.Power MechanicalBoundary annotation (Placement(transformation(extent={{62,-12},{80,6}})));

  // _____________________________________________
  //
  //           Diagnostic Variables
  // _____________________________________________

  Real P_set_star = normalize.y;
  Real P_is_star = deNormalize.u;
  Modelica.Blocks.Continuous.FirstOrder plantDynamic(
    T=T_plant,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=-P_turb_init/P_n) annotation (Placement(transformation(extent={{18,2},{38,22}})));
  replaceable OperatingStates.PumpstorageStates operationStatus(
    useSlewRateLimiter=useSlewRateLimiter,
    t_startup=t_startup,
    P_star_init=P_turb_init/P_n,
    P_grad_operating=P_grad_max_star,
    thres=thres,
    useThresh=useThresh,
    P_grad_inf=P_grad_max_star,
    Td=Td,
    t_eps=t_eps,
    init_state=if P_turb_init > operationStatus.P_min_operating_turb then 2 else if P_turb_init < operationStatus.P_min_operating_pump then 1 else 0,
    P_min_operating_pump=P_min_star_pump,
    P_min_operating_turb=P_min_star_turb,
    P_max_operating_pump=P_max_star_pump,
    P_max_operating_turb=P_max_star_turb) constrainedby TransiEnt.Components.Turbogroups.OperatingStates.PartialStateDynamic "Operating State Model" annotation (choicesAllMatching=true, Placement(transformation(extent={{-14,2},{6,26}})));

  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=(operationStatus.operatingTurb.active or operationStatus.operatingPump.active)) annotation (Placement(transformation(extent={{74,10},{94,30}})));

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_spinning_set "Setpoint for spinning reserve power"
                                                      annotation (Placement(transformation(
        rotation=270,
        extent={{-12,-12},{12,12}},
        origin={42,92})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(MechanicalBoundary.mpp, mpp) annotation (Line(
      points={{80,-3},{80,-2},{100,-2}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(P_target, normalize.u) annotation (Line(
      points={{0,98},{0,56},{-64,56},{-64,12},{-52,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(deNormalize.y, MechanicalBoundary.P_mech_set) annotation (
      Line(
      points={{68.6,12},{71,12},{71,7.62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(plantDynamic.y, deNormalize.u) annotation (Line(points={{39,12},{54.8,12}}, color={0,0,127}));
  connect(booleanExpression.y, isGeneratorRunning) annotation (Line(points={{95,20},{98,20},{110,20}}, color={255,0,255}));
  connect(normalize.y, operationStatus.P_set_star) annotation (Line(points={{-29,12},{-22,12},{-22,10.5714},{-11.1429,10.5714}},
                                                                                                color={0,0,127}));
  connect(operationStatus.P_set_star_lim, plantDynamic.u) annotation (Line(points={{4,10.5714},{12,12},{16,12}},
                                                                                                            color={0,0,127}));
  connect(plantDynamic.y, operationStatus.P_actual_star) annotation (Line(points={{39,12},{44,12},{44,-12},{-4,-12},{-4,2}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          Icon(graphics={
                                   Ellipse(
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
    Polygon(visible=true,
          lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{-80,92},{-88,70},{-72,70},{-80,92}}),
      Line(visible=true,
            points={{-80,80},{-80,-88}},
          color={192,192,192}),
    Line(
      points={{-80,-80},{20,60}},
      color={0,0,0},
      smooth=Smooth.None),
    Line(visible=true,
          points={{-90,-78},{82,-78}},
        color={192,192,192}),
    Polygon(visible=true,
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
          smooth=Smooth.None),
        Polygon(
          points={{-80,84},{-62,96},{-52,62},{-22,48},{-14,22},{-12,20},{36,30},{76,0},{70,-6},{34,20},{-18,10},{-22,14},{-30,44},{-60,58},{-66,82},{-74,78},{-80,84}},
          lineColor={0,0,255},
          fillPattern=FillPattern.VerticalCylinder,
          smooth=Smooth.Bezier,
          fillColor={0,0,255}),
        Polygon(
          points={{68,26},{68,-30},{84,-36},{84,34},{68,26}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{80,6},{94,-8}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid)}),
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
<p><span style=\"font-family: MS Shell Dlg 2;\">mpp: mechanical power port</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_target: input for electric power in W</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">P_spinning_set: input for electric power in W (setpoint for spinning reserve power)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">isGeneratorRunning: BooleanOutput</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The input P_spinning_set is supposed to be gradient limited by limtations of the primary balancing offer mechanism which has normally a higher gradient limit than the rest of the plant.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The input P_target is the sum of secondary balancing setpoint and scheduled set point</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Robert Flesch (flesch@xrg-simulation.de) in Feb 2021: added feedback of actual power to control</span></p>
</html>"));
end Hydroturbine;
