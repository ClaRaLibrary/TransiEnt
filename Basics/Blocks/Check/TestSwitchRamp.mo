within TransiEnt.Basics.Blocks.Check;
model TestSwitchRamp


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



  extends TransiEnt.Basics.Icons.Checkmodel;

  TransiEnt.Basics.Blocks.SwitchRamp switchRamp(Delta_t13=0)
                                                           annotation (Placement(transformation(extent={{-10,-32},{10,-12}})));
  Modelica.Blocks.Sources.Constant const(k=5) annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Constant const1(k=2) annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(startTime=1, period=10) annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.Blocks.Logical.Not not1 annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(extent={{-10,12},{10,32}})));
  SwitchRamp switchRamp1(Delta_t13=2)
                                    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  SwitchRamp switchRamp2(Delta_t13=2, Delta_t31=0)
                                    annotation (Placement(transformation(extent={{-10,-88},{10,-68}})));
  SwitchRamp switchRamp3(Delta_t13=0, Delta_t31=2)
                                    annotation (Placement(transformation(extent={{-10,-116},{10,-96}})));
equation
  connect(const.y, switchRamp.u1) annotation (Line(points={{-39,30},{-26,30},{-26,-14},{-12,-14}}, color={0,0,127}));
  connect(const1.y, switchRamp.u3) annotation (Line(points={{-39,-30},{-12,-30}}, color={0,0,127}));
  connect(not1.u, booleanPulse.y) annotation (Line(points={{-62,0},{-69,0}},                   color={255,0,255}));
  connect(switch1.u1, const.y) annotation (Line(points={{-12,30},{-26,30},{-26,30},{-39,30}}, color={0,0,127}));
  connect(switch1.u3, const1.y) annotation (Line(points={{-12,14},{-24,14},{-24,-30},{-39,-30}}, color={0,0,127}));
  connect(not1.y, switch1.u2) annotation (Line(points={{-39,0},{-30,0},{-30,22},{-12,22}}, color={255,0,255}));
  connect(not1.y, switchRamp.u2) annotation (Line(points={{-39,0},{-30,0},{-30,-22},{-12,-22}}, color={255,0,255}));
  connect(const.y, switchRamp1.u1) annotation (Line(points={{-39,30},{-26,30},{-26,-42},{-12,-42}}, color={0,0,127}));
  connect(const1.y, switchRamp1.u3) annotation (Line(points={{-39,-30},{-24,-30},{-24,-58},{-12,-58}}, color={0,0,127}));
  connect(not1.y, switchRamp1.u2) annotation (Line(points={{-39,0},{-30,0},{-30,-50},{-12,-50}}, color={255,0,255}));
  connect(const.y,switchRamp2. u1) annotation (Line(points={{-39,30},{-26,30},{-26,-70},{-12,-70}}, color={0,0,127}));
  connect(const1.y,switchRamp2. u3) annotation (Line(points={{-39,-30},{-24,-30},{-24,-86},{-12,-86}}, color={0,0,127}));
  connect(not1.y,switchRamp2. u2) annotation (Line(points={{-39,0},{-30,0},{-30,-78},{-12,-78}}, color={255,0,255}));
  connect(const.y,switchRamp3. u1) annotation (Line(points={{-39,30},{-26,30},{-26,-98},{-12,-98}}, color={0,0,127}));
  connect(const1.y,switchRamp3. u3) annotation (Line(points={{-39,-30},{-24,-30},{-24,-114},{-12,-114}},
                                                                                                       color={0,0,127}));
  connect(not1.y,switchRamp3. u2) annotation (Line(points={{-39,0},{-30,0},{-30,-106},{-12,-106}},
                                                                                                 color={255,0,255}));
  annotation (experiment(
      StopTime=100,
      Interval=0.1,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end TestSwitchRamp;
