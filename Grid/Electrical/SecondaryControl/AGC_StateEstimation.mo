within TransiEnt.Grid.Electrical.SecondaryControl;
model AGC_StateEstimation "Automatic generation control with first order state estimation"
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
  extends TransiEnt.Basics.Icons.SystemOperator;

  outer TransiEnt.SimCenter simCenter;
  outer ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter SI.Time samplePeriod=60;
  parameter SI.Time startTime=60;
  parameter Modelica.SIunits.Power P_respond=simCenter.P_el_small "Minimum absolute set value for response of one power plant (Ansprechempfindlichkeit)";

  parameter Integer nout=simCenter.generationPark.nDispPlants "Number of control provision plants";

  parameter Boolean changeSignOfTieLinePower = false "Allows to change the sign of the tie line power input";

  parameter Real K_r = 0.8*3e9/0.2 "Sub grid participation factor";

  parameter Boolean isExternalTielineSetpoint = false "False, tieline input is deactivated";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(rotation=0, extent={{-10,-110},{10,-90}}), iconTransformation(extent={{-10,-110},{10,-90}})));
  Modelica.Blocks.Interfaces.RealInput P_tie_is annotation (Placement(transformation(
        rotation=270,
        extent={{-10,-10},{10,10}},
        origin={-40,100}),
                         iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-40,100})));
  Modelica.Blocks.Interfaces.RealOutput P_sec_set[nout] annotation (Placement(transformation(rotation=0, extent={{96,-10},{116,10}}), iconTransformation(extent={{96,-10},{116,10}})));
  Modelica.Blocks.Interfaces.RealInput P_SB_max_pos[nout] "Reserved positive control power (values are supposed to be positive)" annotation (Placement(transformation(
        rotation=270,
        extent={{-10,-10},{10,10}},
        origin={46,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-96,-40})));
  Modelica.Blocks.Interfaces.RealInput P_SB_max_neg[nout] "Reserved negative control power (values are supposed to be positive)" annotation (Placement(transformation(
        rotation=270,
        extent={{-10,-10},{10,10}},
        origin={72,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-96,40})));

protected
  Modelica.Blocks.Interfaces.RealInput P_tie_set_internal annotation (Placement(transformation(extent={{-86,10},{-66,30}}),  iconTransformation(extent={{-86,10},{-66,30}})));
  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

public
  TransiEnt.Components.Sensors.ElectricFrequency f_is(isDeltaMeasurement=false) annotation (Placement(transformation(extent={{-94,-24},{-74,-4}})));
  Modelica.Blocks.Math.Gain changeSign(k=if changeSignOfTieLinePower then -1 else 1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-74,66})));

  Modelica.Blocks.Interfaces.RealInput P_tie_set if isExternalTielineSetpoint
                                                annotation (Placement(transformation(
        rotation=0,
        extent={{-10,-10},{10,10}},
        origin={-100,26}),
                         iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={42,100})));

  TransiEnt.Basics.Blocks.LimPIDReset H_lfr(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMax=57e6,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    k=k,
    Ti=Ti) annotation (Placement(transformation(extent={{6,-10},{26,10}})));
  replaceable TransiEnt.Grid.Electrical.SecondaryControl.Activation.MeritOrderActivation_Var1 SecondaryControlActivation(C_var_pos=simCenter.generationPark.C_var, C_var_neg=simCenter.generationPark.C_var) constrainedby TransiEnt.Grid.Electrical.SecondaryControl.Activation.PartialActivationType(
    final samplePeriod=samplePeriod,
    final startTime=startTime,
    final P_respond=P_respond,
    final nout=nout) annotation (Placement(transformation(extent={{50,-10},{70,10}})), choices(
      choice(redeclare TransiEnt.Grid.Electrical.SecondaryControl.Activation.MeritOrderActivation_Var1 SecondaryControlActivation(C_var_pos=simCenter.generationPark.C_var, C_var_neg=simCenter.generationPark.C_var) "Merit Order Activation Var1"),
      choice(redeclare TransiEnt.Grid.Electrical.SecondaryControl.Activation.MeritOrderActivation_Var2 SecondaryControlActivation(C_var_pos=simCenter.generationPark.C_var, C_var_neg=simCenter.generationPark.C_var) "Merit Order Activation Var2"),
      choice(redeclare TransiEnt.Grid.Electrical.SecondaryControl.Activation.ProRataActivation SecondaryControlActivation "Pro Rata Activation")));

  Modelica.Blocks.Math.Gain sign[nout](each k=-1) annotation (Placement(transformation(extent={{78,-7},{92,7}})));

  Modelica.Blocks.Sources.Constant f_n(k=simCenter.f_n) annotation (Placement(transformation(extent={{-70,-58},{-50,-38}})));
  Modelica.Blocks.Math.Sum e_set(nin=2, k={1,K_r}) annotation (Placement(transformation(extent={{-24,-7},{-10,7}})));
  Modelica.Blocks.Math.Sum e_is(nin=3, k={1,K_r,1}) annotation (Placement(transformation(extent={{-26,-35},{-12,-21}})));
  Modelica.Blocks.Logical.ZeroCrossing zeroCrossing annotation (Placement(transformation(extent={{36,32},{16,52}})));
  Modelica.Blocks.Sources.BooleanConstant alwaysOn(k=true) annotation (Placement(transformation(extent={{40,14},{30,24}})));
  parameter Real k=0.5 "Gain of controller";
  parameter SI.Time Ti=150 "Time constant of controller";
  TransiEnt.Grid.Electrical.SecondaryControl.FirstOrderStateEstimation h_entl_firstOrder annotation (Placement(transformation(extent={{44,-50},{24,-30}})));
  Modelica.Blocks.Interfaces.RealInput P_baseload_set[nout] annotation (Placement(transformation(
        rotation=0,
        extent={{10,-10},{-10,10}},
        origin={110,-40}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={0,-100})));
  Modelica.Blocks.Math.Sum G(nin=2, k={1,-1}) annotation (Placement(transformation(extent={{2,65},{16,79}})));
public
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower_tielineSet annotation (Placement(transformation(extent={{30,-100},{50,-80}})));
public
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower_tielineIs annotation (Placement(transformation(extent={{62,-100},{82,-80}})));
equation
  if not isExternalTielineSetpoint then
    P_tie_set_internal = 0;
  end if;
  connect(P_tie_set_internal, P_tie_set);

  connect(epp, f_is.epp) annotation (Line(
      points={{0,-100},{0,-100},{-98,-100},{-98,-98},{-96,-98},{-96,-14},{-94,-14}},
      color={0,135,135},
      thickness=0.5));
  connect(P_tie_is, changeSign.u) annotation (Line(points={{-40,100},{-40,90},{-96,90},{-96,66},{-94,66},{-86,66}},
                                                                                   color={0,0,127}));
  connect(H_lfr.y, SecondaryControlActivation.u) annotation (Line(points={{27,0},{48,0}}, color={0,0,127}));

  connect(SecondaryControlActivation.y, sign.u) annotation (Line(points={{71,0},{76.6,0}}, color={0,0,127}));
  connect(sign.y, P_sec_set) annotation (Line(points={{92.7,0},{106,0}},         color={0,0,127}));
  connect(P_SB_max_pos, SecondaryControlActivation.P_R_pos) annotation (Line(points={{46,100},{46,100},{46,78},{46,60},{56,60},{56,12}},     color={0,0,127}));
  connect(P_SB_max_neg, SecondaryControlActivation.P_R_neg) annotation (Line(points={{72,100},{72,60},{64,60},{64,12}}, color={0,0,127}));
  connect(e_set.y, H_lfr.u_s) annotation (Line(points={{-9.3,0},{-9.3,0},{4,0}}, color={0,0,127}));
  connect(P_tie_set_internal, e_set.u[1]) annotation (Line(points={{-76,20},{-58,20},{-58,-0.7},{-25.4,-0.7}}, color={0,0,127}));
  connect(f_n.y, e_set.u[2]) annotation (Line(points={{-49,-48},{-44,-48},{-40,-48},{-40,0.7},{-25.4,0.7}}, color={0,0,127}));
  connect(e_is.y, H_lfr.u_m) annotation (Line(points={{-11.3,-28},{16,-28},{16,-12}},
                                                                                    color={0,0,127}));
  connect(changeSign.y, e_is.u[1]) annotation (Line(points={{-63,66},{-56,66},{-56,64},{-22,64},{-22,-28.9333},{-27.4,-28.9333}}, color={0,0,127}));
  connect(f_is.f, e_is.u[2]) annotation (Line(points={{-73.6,-14},{-36,-14},{-36,-28},{-27.4,-28}}, color={0,0,127}));
  connect(zeroCrossing.y, H_lfr.trigger) annotation (Line(points={{15,42},{4,42},{4,22},{15.8,22},{15.8,10.6}}, color={255,0,255}));
  connect(alwaysOn.y, zeroCrossing.enable) annotation (Line(points={{29.5,19},{26,19},{26,30}}, color={255,0,255}));
  connect(P_baseload_set,h_entl_firstOrder. u) annotation (Line(points={{110,-40},{78,-40},{46,-40}}, color={0,0,127}));
  connect(h_entl_firstOrder.y, e_is.u[3]) annotation (Line(points={{23,-40},{-26,-40},{-26,-27.0667},{-27.4,-27.0667}}, color={0,0,127}));
  connect(e_set.y,G. u[1]) annotation (Line(points={{-9.3,0},{-6,0},{-6,71.3},{0.6,71.3}},      color={0,0,127}));
  connect(e_is.y,G. u[2]) annotation (Line(points={{-11.3,-28},{-6,-28},{-6,72.7},{0.6,72.7}},                   color={0,0,127}));
  connect(G.y, zeroCrossing.u) annotation (Line(points={{16.7,72},{24,72},{24,70},{44,70},{44,42},{38,42}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,100}},
                                                                     preserveAspectRatio=false)),
                                                                       Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=false)));
end AGC_StateEstimation;
