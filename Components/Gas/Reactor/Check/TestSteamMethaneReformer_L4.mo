within TransiEnt.Components.Gas.Reactor.Check;
model TestSteamMethaneReformer_L4
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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
  extends TransiEnt.Basics.Icons.Checkmodel;

  parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG6_var vle_sg6;
  parameter TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG6_var gas_sg6;

  parameter Integer N_cv=3;

  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source(
    m_flow_const=-17.728,
    variable_m_flow=true,
    variable_T=true,
    variable_xi=true,
    medium=vle_sg6,
    T_const=813.15) annotation (Placement(transformation(extent={{-114,-10},{-94,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink(variable_p=true, medium=vle_sg6) annotation (Placement(transformation(extent={{114,-10},{94,10}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor moleCompIn(medium=vle_sg6, compositionDefinedBy=2) annotation (Placement(transformation(extent={{-62,0},{-42,20}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-10,
    offset=-10,
    duration=1000,
    startTime=1000)
                  annotation (Placement(transformation(extent={{-146,44},{-126,64}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    height=300,
    offset=673.15,
    duration=1000,
    startTime=3000)
                   annotation (Placement(transformation(extent={{-146,14},{-126,34}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor temperatureIn(medium=vle_sg6) annotation (Placement(transformation(extent={{-88,0},{-68,20}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor temperatureOut(medium=vle_sg6) annotation (Placement(transformation(extent={{42,0},{62,20}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    duration=1000,
    height=-20e5,
    offset=30e5,
    startTime=9000)
                   annotation (Placement(transformation(extent={{144,-4},{124,16}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(table=[0,0.16,0.03,0.70,0.01,0.08; 5000,0.16,0.03,0.70,0.01,0.08; 6000,0.10,0.10,0.65,0.05,0.00; 11000,0.10,0.10,0.65,0.05,0.00; 12000,0.5,0.2,0,0.05,0.2; 14000,0.5,0.2,0,0.05,0.2])     annotation (Placement(transformation(extent={{-146,-16},{-126,4}})));
  TransiEnt.Components.Gas.Reactor.SteamMethaneReformer_L4 sMR(
    N_cv=N_cv,
    T_start={680.662,809.68,965.931} + 273.15*ones(N_cv),
    p_start={31.9167,31.15,30.3833}*1e5,
    xi_start=[0.107837,0.220377,0.563447,0.0384457,0.0499259; 0.0417769,0.231705,0.484595,0.0639233,0.158074; 0.00696886,0.182197,0.465761,0.0748017,0.250367]) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature[N_cv](each T(displayUnit="K") = 1625) annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor moleCompOut(medium=vle_sg6, compositionDefinedBy=2) annotation (Placement(transformation(extent={{68,0},{88,20}})));
  TransiEnt.Basics.Adapters.Gas.Real_to_Ideal real_to_Ideal(real=vle_sg6, ideal=gas_sg6) annotation (Placement(transformation(extent={{-36,-10},{-16,10}})));
  TransiEnt.Basics.Adapters.Gas.Ideal_to_Real ideal_to_Real(real=vle_sg6, ideal=gas_sg6) annotation (Placement(transformation(extent={{16,-10},{36,10}})));

protected
  Modelica.SIunits.MolarFlowRate n_flow_In;
public
  Modelica.SIunits.MolarFlowRate n_flow_C_In;
  Modelica.SIunits.MolarFlowRate n_flow_H_In;
  Modelica.SIunits.MolarFlowRate n_flow_O_In;
  Modelica.SIunits.MolarFlowRate n_flow_N_In;
protected
  Modelica.SIunits.MolarFlowRate n_flow_Out;
public
  Modelica.SIunits.MolarFlowRate n_flow_C_Out;
  Modelica.SIunits.MolarFlowRate n_flow_H_Out;
  Modelica.SIunits.MolarFlowRate n_flow_O_Out;
  Modelica.SIunits.MolarFlowRate n_flow_N_Out;

  Modelica.SIunits.MolarFlowRate Delta_n_flow_C=n_flow_C_In-n_flow_C_Out;
  Modelica.SIunits.MolarFlowRate Delta_n_flow_H=n_flow_H_In-n_flow_H_Out;
  Modelica.SIunits.MolarFlowRate Delta_n_flow_O=n_flow_O_In-n_flow_O_Out;
  Modelica.SIunits.MolarFlowRate Delta_n_flow_N=n_flow_N_In-n_flow_N_Out;

  Real rel_Delta_n_flow_C=Delta_n_flow_C/n_flow_C_In;
  Real rel_Delta_n_flow_H=Delta_n_flow_H/n_flow_H_In;
  Real rel_Delta_n_flow_O=Delta_n_flow_O/n_flow_O_In;
  Real rel_Delta_n_flow_N=Delta_n_flow_N/n_flow_N_In;

equation
  n_flow_In=moleCompIn.gasPortIn.m_flow/moleCompIn.molarMass;
  n_flow_Out=moleCompOut.gasPortIn.m_flow/moleCompOut.molarMass;

  n_flow_C_In=n_flow_In*(1*moleCompIn.fraction[1]+1*moleCompIn.fraction[2]+1*moleCompIn.fraction[5]);
  n_flow_C_Out=n_flow_Out*(1*moleCompOut.fraction[1]+1*moleCompOut.fraction[2]+1*moleCompOut.fraction[5]);

  n_flow_H_In=n_flow_In*(4*moleCompIn.fraction[1]+2*moleCompIn.fraction[3]+2*moleCompIn.fraction[4]);
  n_flow_H_Out=n_flow_Out*(4*moleCompOut.fraction[1]+2*moleCompOut.fraction[3]+2*moleCompOut.fraction[4]);

  n_flow_O_In=n_flow_In*(2*moleCompIn.fraction[2]+1*moleCompIn.fraction[3]+1*moleCompIn.fraction[5]);
  n_flow_O_Out=n_flow_Out*(2*moleCompOut.fraction[2]+1*moleCompOut.fraction[3]+1*moleCompOut.fraction[5]);

  n_flow_N_In=n_flow_In*2*moleCompIn.fraction[6];
  n_flow_N_Out=n_flow_Out*2*moleCompOut.fraction[6];

  connect(ramp2.y, sink.p) annotation (Line(points={{123,6},{116,6}}, color={0,0,127}));
  connect(combiTimeTable.y, source.xi) annotation (Line(points={{-125,-6},{-125,-6},{-116,-6}},             color={0,0,127}));
  connect(temperatureOut.gasPortOut, moleCompOut.gasPortIn) annotation (Line(
      points={{62,0},{68,0}},
      color={255,255,0},
      thickness=1.5));
  connect(moleCompOut.gasPortOut, sink.gasPort) annotation (Line(
      points={{88,0},{91,0},{94,0}},
      color={255,255,0},
      thickness=1.5));
  connect(source.gasPort, temperatureIn.gasPortIn) annotation (Line(
      points={{-94,0},{-91,0},{-88,0}},
      color={255,255,0},
      thickness=1.5));
  connect(temperatureIn.gasPortOut, moleCompIn.gasPortIn) annotation (Line(
      points={{-68,0},{-65,0},{-62,0}},
      color={255,255,0},
      thickness=1.5));
  connect(fixedTemperature.port, sMR.heat) annotation (Line(points={{-10,30},{0,30},{0,10}}, color={191,0,0}));
  connect(moleCompIn.gasPortOut, real_to_Ideal.gasPortIn) annotation (Line(
      points={{-42,0},{-39,0},{-36,0}},
      color={255,255,0},
      thickness=1.5));
  connect(real_to_Ideal.gasPortOut, sMR.gasPortIn) annotation (Line(
      points={{-16,0},{-13,0},{-10,0}},
      color={255,213,170},
      thickness=1.5));
  connect(sMR.gasPortOut, ideal_to_Real.gasPortIn) annotation (Line(
      points={{10,0},{13,0},{16,0}},
      color={255,213,170},
      thickness=1.5));
  connect(ideal_to_Real.gasPortOut, temperatureOut.gasPortIn) annotation (Line(
      points={{36,0},{39,0},{42,0}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp1.y, source.T) annotation (Line(points={{-125,24},{-122,24},{-122,0},{-116,0}}, color={0,0,127}));
  connect(ramp.y, source.m_flow) annotation (Line(points={{-125,54},{-120,54},{-120,6},{-116,6}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-20},{160,100}}),  graphics={Text(
          extent={{-58,94},{58,76}},
          lineColor={0,140,72},
          textString="1000-2000 s mass flow from 10 to 20 kg/s
3000-4000 s temperature from 400 to 700 C
5000-6000 s composition changes
9000-10000 s pressure at output from 30 to 20 bar
11000-12000 s lowering steam supply until insufficient"),
                                 Text(
          extent={{-40,66},{40,48}},
          lineColor={0,140,72},
          textString="check molar components C, H, O, N
check that temperature rises
check mass flows
check pressure loss in right direction
check that for insufficient steam supply everything works")}),
    Icon(coordinateSystem(extent={{-160,-20},{160,100}})),
    experiment(StopTime=14000, __Dymola_NumberOfIntervals=700),
    __Dymola_experimentSetupOutput);
end TestSteamMethaneReformer_L4;
