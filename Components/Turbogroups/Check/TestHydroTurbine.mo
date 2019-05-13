within TransiEnt.Components.Turbogroups.Check;
model TestHydroTurbine
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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
  TransiEnt.Components.Turbogroups.Hydroturbine Hydrounit(P_n=250e6) annotation (Placement(transformation(extent={{-34,10},{10,55}})));
  TransiEnt.Components.Boundaries.Mechanical.Frequency NominalSpeed(f_set_const=150/60, useInputConnector=false) annotation (Placement(transformation(extent={{64,20},{38,46}})));
  Modelica.Blocks.Sources.TimeTable TestSchedule(table=[0,0; 120,0; 120,1; 720,1; 720,0; 840,0; 840,-1; 1440,-1; 1440,0; 1500,0; 1500,1; 2100,1; 2100,0; 2160,0; 2160,-1; 2760,-1; 2760,0; 2800,0; 2800,0.2; 3500,0.2; 3500,-0.2; 5000,-0.2]) annotation (Placement(transformation(extent={{-88,62},{-68,82}})));
  Modelica.Blocks.Math.Gain from_pu(k=Hydrounit.P_n) annotation (Placement(transformation(extent={{-44,62},{-24,82}})));
  Modelica.Blocks.Sources.Constant const(k=0) annotation (Placement(transformation(extent={{24,66},{4,86}})));
equation
  connect(Hydrounit.mpp, NominalSpeed.mpp) annotation (Line(points={{10.22,32.275},{35.09,32.275},{35.09,33},{38,33}}, color={95,95,95}));
  connect(from_pu.y, Hydrounit.P_target) annotation (Line(points={{-23,72},{-12.22,72},{-12.22,51.625}},
                                                                                                    color={0,0,127}));
  connect(TestSchedule.y, from_pu.u) annotation (Line(points={{-67,72},{-62,72},{-56,72},{-46,72}},
                                                                                  color={0,0,127}));
  connect(const.y, Hydrounit.P_spinning_set) annotation (Line(points={{3,76},{-2.76,76},{-2.76,53.2}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-72,-6},{78,-98}},
          lineColor={0,0,0},
          textString="Look at:
Hydrounit.P_set_star
Hydrounit.P_is_star
Hydrounit.operationStatus.P_min_operating

Tip:
Simulate
Click on 'Diagram'
Right click on 'Hydrounit' -> Show Component
Right click on 'operationStatus' -> Show Component
-> Move animation slider to see how states change")}),
                                          experiment(StopTime=5000),
    __Dymola_experimentSetupOutput(equidistant=false));
end TestHydroTurbine;
