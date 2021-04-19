within TransiEnt.Components.Turbogroups.Check;
model TestSlewRateLimitedTurbineStep
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
  extends TransiEnt.Basics.Icons.Checkmodel;
  Modelica.Blocks.Sources.Step ramp(
    height=-0.5e9,
    offset=-1.5e9,
    startTime=1000)
    annotation (Placement(transformation(extent={{-104,4},{-76,32}})));
  Modelica.Blocks.Sources.Constant
                               ramp1(k=0)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  TransiEnt.Components.Turbogroups.ThreeStateTurbine slewRateLimited2StateTurbine(P_turb_init=1.5e9, operationStatus(P_star_init=1.5/2, P_grad_operating=0.25/1000)) annotation (Placement(transformation(extent={{-56,-80},{-12,-35}})));
  TransiEnt.Components.Boundaries.Mechanical.Frequency Grid(f_set_const=50, useInputConnector=false) annotation (Placement(transformation(extent={{60,-66},{34,-40}})));
equation
  connect(slewRateLimited2StateTurbine.mpp, Grid.mpp) annotation (Line(points={{-11.78,-57.725},{13.09,-57.725},{13.09,-53},{34,-53}}, color={95,95,95}));
  connect(slewRateLimited2StateTurbine.P_target, ramp.y) annotation (Line(points={{-34.22,-38.375},{-74.6,-38.375},{-74.6,18}}, color={0,0,127}));
  connect(slewRateLimited2StateTurbine.P_spinning_set, ramp1.y) annotation (Line(points={{-26.08,-35.45},{-26.08,10},{12,10},{12,50},{-19,50}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                          experiment(StopTime=7200),
    __Dymola_experimentSetupOutput);
end TestSlewRateLimitedTurbineStep;
