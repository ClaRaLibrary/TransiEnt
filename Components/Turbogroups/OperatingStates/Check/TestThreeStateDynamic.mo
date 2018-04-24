within TransiEnt.Components.Turbogroups.OperatingStates.Check;
model TestThreeStateDynamic
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
  TransiEnt.Components.Turbogroups.OperatingStates.ThreeStateDynamic threeStateDynamic(
    t_startup=900,
    t_eps=950,
    useThresh=true) annotation (Placement(transformation(extent={{12,-32},{48,4}})));
  Modelica.Blocks.Sources.Trapezoid Trapezoid(
    amplitude=1,
    rising=900,
    falling=900,
    period=86400,
    width=60000) annotation (Placement(transformation(extent={{-62,-46},{-42,-26}})));
  Modelica.Blocks.Sources.Step Step(
    height=0.8,
    offset=0.2,
    startTime=7.5e4) annotation (Placement(transformation(extent={{-64,-2},{-44,18}})));
  Modelica.Blocks.Math.Product P_set annotation (Placement(transformation(extent={{-28,-24},{-8,-4}})));
equation
  connect(Trapezoid.y, P_set.u2) annotation (Line(points={{-41,-36},{-36,-36},{-36,-20},{-30,-20}}, color={0,0,127}));
  connect(Step.y, P_set.u1) annotation (Line(points={{-43,8},{-36,8},{-36,-8},{-30,-8}}, color={0,0,127}));
  connect(P_set.y, threeStateDynamic.P_set_star) annotation (Line(points={{-7,-14},{12,-14}},                     color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-50,80},{38,38}},
          lineColor={0,0,0},
          textString="Look at:
P_set
threeStateDynamic.y
halt.active
startup.active
operating.active")}),
    experiment(StopTime=90000),
    __Dymola_experimentSetupOutput);
end TestThreeStateDynamic;
