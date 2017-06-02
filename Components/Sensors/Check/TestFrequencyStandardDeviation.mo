within TransiEnt.Components.Sensors.Check;
model TestFrequencyStandardDeviation
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
  FrequencyStandardDeviation frequencyStandardDeviation annotation (Placement(transformation(extent={{-16,6},{4,26}})));
  Boundaries.Electrical.Frequency constantFrequency_L1_1 annotation (Placement(transformation(extent={{44,-10},{64,10}})));
  Basics.Tables.GenericDataTable f_1year_60s(
    datasource=TransiEnt.Basics.Tables.DataPrivacy.isPublic,
    relativepath="electricity/GridFrequencyMeasurement_60s_01012012_31122012.txt",
    use_absolute_path=false,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments) annotation (Placement(transformation(extent={{10,40},{30,60}})));
  Modelica.Blocks.Sources.Constant expected(k=0.021561) annotation (Placement(transformation(extent={{-54,42},{-34,62}})));
  Modelica.Blocks.Sources.RealExpression error_in_percent(y=(frequencyStandardDeviation.y - expected.k)/expected.k*100) annotation (Placement(transformation(extent={{-34,-74},{16,-32}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
equation

  connect(frequencyStandardDeviation.epp, constantFrequency_L1_1.epp) annotation (Line(
      points={{-6,6.2},{-6,-0.1},{43.9,-0.1}},
      color={0,135,135},
      thickness=0.5));
  connect(f_1year_60s.y1, constantFrequency_L1_1.f_set) annotation (Line(points={{31,50},{48.6,50},{48.6,12}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(
      StopTime=3.15367e+007,
      Interval=60,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput);
end TestFrequencyStandardDeviation;
