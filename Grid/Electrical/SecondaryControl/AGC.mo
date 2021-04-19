within TransiEnt.Grid.Electrical.SecondaryControl;
model AGC "Automatic generation control model"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_tie_is annotation (Placement(transformation(
        rotation=270,
        extent={{-10,-10},{10,10}},
        origin={-40,100}),
                         iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-40,100})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerOut P_sec_set[nout] annotation (Placement(transformation(rotation=0, extent={{96,-10},{116,10}}), iconTransformation(extent={{96,-10},{116,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_SB_max_pos[nout] "Reserved positive control power (values are supposed to be positive)" annotation (Placement(transformation(
        rotation=270,
        extent={{-10,-10},{10,10}},
        origin={46,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-96,-40})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_SB_max_neg[nout] "Reserved negative control power (values are supposed to be positive)" annotation (Placement(transformation(
        rotation=270,
        extent={{-10,-10},{10,10}},
        origin={72,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-96,40})));

protected
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_tie_set_internal annotation (Placement(transformation(extent={{-86,10},{-66,30}}),  iconTransformation(extent={{-86,10},{-66,30}})));
  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

public
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower_tielineSet annotation (Placement(transformation(extent={{30,-100},{50,-80}})));
  TransiEnt.Components.Sensors.ElectricFrequency f_is(isDeltaMeasurement=false) annotation (Placement(transformation(extent={{-94,-24},{-74,-4}})));
  Modelica.Blocks.Math.Gain changeSign(k=if changeSignOfTieLinePower then -1 else 1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-74,66})));

 TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_tie_set if isExternalTielineSetpoint
                                                annotation (Placement(transformation(
        rotation=0,
        extent={{-10,-10},{10,10}},
        origin={-100,26}),
                         iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={42,100})));

  Modelica.Blocks.Continuous.LimPID   H_lfr(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=k,
    Ti=Ti,
    I(initType=Modelica.Blocks.Types.Init.InitialState, y_start=0),
    yMax=P_SB_max,
    initType=Modelica.Blocks.Types.InitPID.NoInit)
           annotation (Placement(transformation(extent={{6,-10},{26,10}})));
  replaceable TransiEnt.Grid.Electrical.SecondaryControl.Activation.MeritOrderActivation_Var1 SecondaryControlActivation(C_var_pos=simCenter.generationPark.C_var, C_var_neg=simCenter.generationPark.C_var,
    P_SB_max=P_SB_max)                                                                                                                                                                                       constrainedby TransiEnt.Grid.Electrical.SecondaryControl.Activation.PartialActivationType(
    final samplePeriod=samplePeriod,
    final startTime=startTime,
    final P_respond=P_respond,
    final nout=nout) annotation (Placement(transformation(extent={{50,-10},{70,10}})), choices(
      choice(redeclare TransiEnt.Grid.Electrical.SecondaryControl.Activation.ScheduleActivation SecondaryControlActivation "Continuous external schedule Activation"),
      choice(redeclare TransiEnt.Grid.Electrical.SecondaryControl.Activation.MeritOrderActivation_Var1 SecondaryControlActivation(C_var_pos=simCenter.generationPark.C_var, C_var_neg=simCenter.generationPark.C_var) "Merit Order Activation Var1"),
      choice(redeclare TransiEnt.Grid.Electrical.SecondaryControl.Activation.MeritOrderActivation_Var2 SecondaryControlActivation(C_var_pos=simCenter.generationPark.C_var, C_var_neg=simCenter.generationPark.C_var) "Merit Order Activation Var2"),
      choice(redeclare TransiEnt.Grid.Electrical.SecondaryControl.Activation.ProRataActivation SecondaryControlActivation "Pro Rata Activation")));

  Modelica.Blocks.Math.Gain sign[nout](each k=-1) annotation (Placement(transformation(extent={{78,-7},{92,7}})));

  Modelica.Blocks.Sources.Constant f_n(k=simCenter.f_n) annotation (Placement(transformation(extent={{-70,-58},{-50,-38}})));
  Modelica.Blocks.Math.Sum e_set(nin=2, k={1,K_r}) annotation (Placement(transformation(extent={{-26,-35},{-12,-21}})));
  Modelica.Blocks.Math.Sum e_meas(nin=2, k={1,K_r}) annotation (Placement(transformation(extent={{-24,-7},{-10,7}})));

  parameter Real k=0.5 "Gain of controller";
  parameter SI.Time Ti=150 "Time constant of controller";
  Modelica.Blocks.Math.Sum G(nin=2, k={-1,1}) annotation (Placement(transformation(extent={{2,65},{16,79}})));
  SI.Power P_sec_set_total = sum(P_sec_set);
public
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower_tielineIs annotation (Placement(transformation(extent={{62,-100},{82,-80}})));
  parameter SI.Power P_SB_max=57e6 "Total reserved secondary balancing power";
equation
  if not isExternalTielineSetpoint then
    P_tie_set_internal = 0;
  end if;
  connect(P_tie_set_internal, P_tie_set);

  collectElectricPower_tielineSet.powerCollector.P=P_tie_set_internal;
  collectElectricPower_tielineIs.powerCollector.P=P_tie_is;
  connect(collectElectricPower_tielineSet.powerCollector, modelStatistics.tielineSetPowerCollector);
  connect(collectElectricPower_tielineIs.powerCollector, modelStatistics.tielinePowerCollector);

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
  connect(P_tie_set_internal, e_set.u[1]) annotation (Line(points={{-76,20},{-58,20},{-58,-28.7},{-27.4,-28.7}}, color={0,0,127}));
  connect(f_n.y, e_set.u[2]) annotation (Line(points={{-49,-48},{-44,-48},{-40,-48},{-40,-27.3},{-27.4,-27.3}}, color={0,0,127}));
  connect(changeSign.y, e_meas.u[1]) annotation (Line(points={{-63,66},{-56,66},{-32,66},{-32,-0.7},{-25.4,-0.7}}, color={0,0,127}));
  connect(f_is.f, e_meas.u[2]) annotation (Line(points={{-73.6,-14},{-36,-14},{-36,0.7},{-25.4,0.7}}, color={0,0,127}));
  connect(e_set.y, G.u[2]) annotation (Line(points={{-11.3,-28},{-4,-28},{-4,72.7},{0.6,72.7}}, color={0,0,127}));
  connect(e_meas.y, G.u[1]) annotation (Line(points={{-9.3,0},{-8,0},{-8,71.3},{0.6,71.3}}, color={0,0,127}));
  connect(e_set.y, H_lfr.u_s) annotation (Line(points={{-11.3,-28},{0,-28},{0,0},{4,0}}, color={0,0,127}));
  connect(e_meas.y, H_lfr.u_m) annotation (Line(points={{-9.3,0},{-8,0},{-8,-20},{16,-20},{16,-12}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(extent={{-100,-100},{100,100}},
                                                                     preserveAspectRatio=false)),
                                                                       Icon(graphics,
                                                                            coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Automatic generation control model including secondary controller and replaceable model for control unit activation)</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>L2E: Models are based on (dynamic) transfer functions or differential equations.</p>
<p>nonlinear behavior</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>epp: electrical connector</p>
<p>P_tie_is: Input for Tie Line Power</p>
<p>P_sec_set[nout]: Outputs for secondary balancing power</p>
<p>P_SB_max_pos[nout]: Inputs for reserved positive control power (values are supposed to be positive)</p>
<p>P_SB_max_neg[nout]: Inputs for reserved negative control power (values are supposed to be positive)</p>
<p>nout: Number of considered power plants</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>Tested in check model &quot;TransiEnt.Grid.Electrical.SecondaryControl.Check.TestAGC_compareActivation&quot;</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) in 10/2014</span></p>
</html>"));
end AGC;
