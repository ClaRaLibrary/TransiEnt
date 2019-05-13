within TransiEnt.Components.Turbogroups.Check;
model CheckTwoStateInertiaWitchClutch
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

  TransiEnt.Components.Boundaries.Mechanical.Power Turbine annotation (Placement(transformation(extent={{-66,-18},{-24,24}})));
  TransiEnt.Components.Boundaries.Mechanical.Frequency Grid(useInputConnector=true) annotation (Placement(transformation(extent={{88,-18},{38,28}})));
  Modelica.Blocks.Sources.Ramp turbineShutOff(
    duration=10,
    height=10e6,
    offset=-10e6)
    annotation (Placement(transformation(extent={{-76,50},{-56,70}})));
  Modelica.Blocks.Sources.Sine sine(
    offset=50,
    amplitude=0.15,
    freqHz=1/10)
    annotation (Placement(transformation(extent={{12,50},{32,70}})));
  TransiEnt.Components.Mechanical.TwoStateInertiaWithIdealClutch twoStateInertiaWithIdealClutch(J=1000) annotation (Placement(transformation(extent={{0,-4},{20,16}})));
  Modelica.Blocks.Sources.BooleanStep disconnect(startTime=50, startValue=true)
    annotation (Placement(transformation(extent={{-36,50},{-16,70}})));
equation
  connect(turbineShutOff.y, Turbine.P_mech_set) annotation (Line(
      points={{-55,60},{-55,45},{-45,45},{-45,27.78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine.y, Grid.f_set) annotation (Line(
      points={{33,60},{33,59},{63,59},{63,32.14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(disconnect.y, twoStateInertiaWithIdealClutch.isRunning) annotation (
      Line(
      points={{-15,60},{-2,60},{-2,14.7},{9.9,14.7}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(twoStateInertiaWithIdealClutch.mpp_a, Turbine.mpp) annotation (Line(
      points={{0,6},{-14,6},{-14,3},{-24,3}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(twoStateInertiaWithIdealClutch.mpp_b, Grid.mpp) annotation (Line(
      points={{20,6},{32,6},{32,5},{38,5}},
      color={95,95,95},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=75),
    __Dymola_experimentSetupOutput);
end CheckTwoStateInertiaWitchClutch;
