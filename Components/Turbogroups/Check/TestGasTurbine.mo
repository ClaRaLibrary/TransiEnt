within TransiEnt.Components.Turbogroups.Check;
model TestGasTurbine
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
  TransiEnt.Components.Turbogroups.Gasturbine Gasturbine(P_nom=100e6) annotation (Placement(transformation(extent={{-26,16},{18,61}})));
  TransiEnt.Components.Boundaries.Mechanical.Frequency NominalSpeed(f_set_const=150/60, useInputConnector=false) annotation (Placement(transformation(extent={{72,26},{46,52}})));
  Modelica.Blocks.Sources.TimeTable TestSchedule(table=[0,0; 120,0; 120,1; 720,1; 720,1; 3e3,1; 3000,0.5; 3001,0.5; 3002,0.5; 4e3,0.5; 4e3,0.2; 4500,0.2; 4500,0.2; 6000,0.2; 6000,0.7; 10e3,0.7; 10e3,0; 1.2e4,0; 1.2e4,0.8; 2e4,0.8; 2e4,0.2; 2.5e4,0.2])
                                                                                                    annotation (Placement(transformation(extent={{-80,68},{-60,88}})));
  Modelica.Blocks.Math.Gain from_pu(k=-Gasturbine.P_nom)
                                                       annotation (Placement(transformation(extent={{-36,68},{-16,88}})));
  Modelica.Blocks.Sources.Constant const(k=0) annotation (Placement(transformation(extent={{30,72},{10,92}})));
equation
  connect(Gasturbine.mpp, NominalSpeed.mpp) annotation (Line(points={{18.22,38.275},{43.09,38.275},{43.09,39},{46,39}}, color={95,95,95}));
  connect(from_pu.y, Gasturbine.P_target) annotation (Line(points={{-15,78},{-4.22,78},{-4.22,57.625}}, color={0,0,127}));
  connect(TestSchedule.y, from_pu.u) annotation (Line(points={{-59,78},{-38,78}}, color={0,0,127}));
  connect(const.y, Gasturbine.P_spinning_set) annotation (Line(points={{9,82},{4.8,82},{4.8,59.2}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-56,-30},{62,-88}},
          lineColor={0,0,0},
          textString="Look at:
Gasturbine.P_set_star
Gasturbine.P_is_star
Gasturbine.operationStatus.P_min_operating

Tip:
Simulate
Click on 'Diagram'
Right click on 'Hydrounit' -> Show Component
Right click on 'operationStatus' -> Show Component
-> Move animation slider to see how states change")}),
                                          experiment(StopTime=24000),
    __Dymola_experimentSetupOutput(equidistant=false));
end TestGasTurbine;
