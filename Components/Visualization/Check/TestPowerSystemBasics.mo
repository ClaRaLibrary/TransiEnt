within TransiEnt.Components.Visualization.Check;
model TestPowerSystemBasics
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
  Modelica.Blocks.Sources.Cosine Powerplant(
    amplitude=100e6,
    freqHz=1/86400,
    offset=500e6) annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  PowerSystemBasics.FullLoadHours fullLoadHours(P=Powerplant.y, P_0 = P_0_PowerPlant.k) annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Blocks.Sources.Constant P_0_PowerPlant(k=700e6) annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  PowerSystemBasics.Energy energy(
    E_start=0,
    unit="TWh",
    decimalSpaces=3,
    P=Powerplant.y*1e-12) annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  PowerSystemBasics.Energy energy_defaultUnit(
    E_start=0,
    decimalSpaces=2,
    P=Powerplant.y,
    largeFonts=false) annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  PowerSystemBasics.CapacityFactor capacityFactor(P=Powerplant.y, P_0 = P_0_PowerPlant.k) annotation (Placement(transformation(extent={{60,20},{80,40}})));
equation

  annotation (experiment(StopTime=3.16224e+007, Interval=900), __Dymola_experimentSetupOutput);
end TestPowerSystemBasics;
