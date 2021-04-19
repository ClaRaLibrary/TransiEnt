within TransiEnt.Components.Turbogroups.Check;
model TestSlewRateLimited2StateTurbine
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

  TransiEnt.Components.Boundaries.Mechanical.Frequency Grid annotation (Placement(transformation(extent={{88,-18},{38,28}})));
  Modelica.Blocks.Sources.Ramp turbineShutOff(
    duration=10,
    height=10e6,
    offset=-10e6)
    annotation (Placement(transformation(extent={{-92,44},{-72,64}})));
  Modelica.Blocks.Sources.Sine sine(
    offset=50,
    amplitude=0.15,
    freqHz=1/10)
    annotation (Placement(transformation(extent={{12,50},{32,70}})));
  TransiEnt.Components.Mechanical.TwoStateInertiaWithIdealClutch twoStateInertiaWithIdealClutch(J=1000) annotation (Placement(transformation(extent={{0,-4},{20,16}})));
  Modelica.Blocks.Sources.BooleanStep disconnect(startTime=50, startValue=true)
    annotation (Placement(transformation(extent={{-36,50},{-16,70}})));
  TransiEnt.Components.Turbogroups.ThreeStateTurbine slewRateLimited2StateTurbine annotation (Placement(transformation(extent={{-66,-6},{-46,14}})));
  TransiEnt.Grid.Electrical.SecondaryControl.SecondaryBalancingController AGC_Grid_1(
    is_singleton=false,
    T_r=5,
    beta=5,
    P_n=20) annotation (Placement(transformation(extent={{-110,9},{-88,31}})));
  Modelica.Blocks.Sources.Constant zero(k=0) annotation (Placement(transformation(extent={{-142,44},{-122,64}})));
equation
  connect(sine.y, Grid.f_set) annotation (Line(
      points={{33,60},{33,59},{63,59},{63,32.14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(disconnect.y, twoStateInertiaWithIdealClutch.isRunning) annotation (
      Line(
      points={{-15,60},{-2,60},{-2,14.7},{9.9,14.7}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(twoStateInertiaWithIdealClutch.mpp_b, Grid.mpp) annotation (Line(
      points={{20,6},{32,6},{32,5},{38,5}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(slewRateLimited2StateTurbine.mpp, twoStateInertiaWithIdealClutch.mpp_a) annotation (Line(points={{-45.9,3.9},{0,3.9},{0,6}}, color={95,95,95}));
  connect(turbineShutOff.y, slewRateLimited2StateTurbine.P_target) annotation (Line(points={{-71,54},{-50,54},{-50,56},{-50,24},{-56.1,24},{-56.1,12.5}}, color={0,0,127}));
  connect(AGC_Grid_1.y, slewRateLimited2StateTurbine.P_spinning_set) annotation (Line(points={{-86.9,20},{-68,20},{-68,18},{-52.4,18},{-52.4,13.8}}, color={0,0,127}));
  connect(zero.y, AGC_Grid_1.P_tie_is) annotation (Line(points={{-121,54},{-114,54},{-103.62,54},{-103.62,30.01}}, color={0,0,127}));
  connect(zero.y, AGC_Grid_1.P_tie_set) annotation (Line(points={{-121,54},{-108.9,54},{-108.9,30.01}}, color={0,0,127}));
  connect(zero.y, AGC_Grid_1.u) annotation (Line(points={{-121,54},{-118,54},{-118,52},{-118,20},{-112.2,20}}, color={0,0,127}));
  annotation (
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=75),
    __Dymola_experimentSetupOutput);
end TestSlewRateLimited2StateTurbine;
