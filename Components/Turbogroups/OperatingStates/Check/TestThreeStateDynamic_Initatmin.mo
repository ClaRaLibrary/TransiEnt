within TransiEnt.Components.Turbogroups.OperatingStates.Check;
model TestThreeStateDynamic_Initatmin
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
  extends TransiEnt.Basics.Icons.Checkmodel;
  TransiEnt.Components.Turbogroups.OperatingStates.ThreeStateDynamic threeStateDynamic(
    t_startup=900,
    t_eps=950,
    P_star_init=0.3,
    useThresh=simCenter.useThresh,
    variableSlewRateLimiter(y(fixed=false))) annotation (Placement(transformation(extent={{12,-32},{48,4}})));
  Modelica.Blocks.Sources.Ramp Step(
    startTime=7.5e4,
    height=-0.8,
    offset=-0.3)     annotation (Placement(transformation(extent={{-34,-24},{-14,-4}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,78},{-70,98}})));
equation
  connect(Step.y, threeStateDynamic.P_set_star) annotation (Line(points={{-13,-14},{12,-14}}, color={0,0,127}));
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
end TestThreeStateDynamic_Initatmin;
