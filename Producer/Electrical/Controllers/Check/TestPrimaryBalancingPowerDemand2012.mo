within TransiEnt.Producer.Electrical.Controllers.Check;
model TestPrimaryBalancingPowerDemand2012 "Example how to calculate the demand of primary balancing power"
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
  inner TransiEnt.SimCenter simCenter(
    n_consumers=1,
    P_consumer={300e9},
    T_grid=7.5) annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  inner TransiEnt.ModelStatistics                    modelStatistics
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.Constant f_nom(k=simCenter.f_n)
    annotation (Placement(transformation(extent={{-52,23},{-32,43}})));
  PrimaryBalancingController PrimaryBalancingController60(plantType=TransiEnt.Basics.Types.ControlPlantType.Provided) annotation (Placement(transformation(extent={{28,-29},{56,-3}})));
  Modelica.Blocks.Math.Feedback feedback60
    annotation (Placement(transformation(extent={{-26,-6},{-6,-26}})));
  TransiEnt.Basics.Tables.GenericDataTable fmeasured60(
    change_of_sign=false,
    datasource=TransiEnt.Basics.Tables.DataPrivacy.isPublic,
    relativepath="/electricity/GridFrequencyMeasurement_60s_01012012_31122012.txt") annotation (Placement(transformation(extent={{-68,-26},{-48,-6}})));
equation
  connect(feedback60.y, PrimaryBalancingController60.delta_f) annotation (Line(
      points={{-7,-16},{26.6,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(f_nom.y, feedback60.u2) annotation (Line(
      points={{-31,33},{-31,32.5},{-16,32.5},{-16,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fmeasured60.y1, feedback60.u1) annotation (Line(
      points={{-47,-16},{-24,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end TestPrimaryBalancingPowerDemand2012;
