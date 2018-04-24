within TransiEnt.Producer.Electrical.Conventional.Check;
model CheckBlackCoal_twoVariants
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
  TransiEnt.Components.Boundaries.Electrical.Frequency grid(useInputConnector=false) annotation (Placement(transformation(extent={{36,-18},{56,2}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-88,80},{-68,100}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-68,80},{-48,100}})));

public
  BrownCoal consteffGen(
    isPrimaryControlActive=false,
    isSecondaryControlActive=false,
    PartloadEfficiency(EfficiencyCharLine=TransiEnt.Producer.Electrical.Base.PartloadEfficiency.ConstantEfficiency()),
    P_init=consteffGen.P_min_star*consteffGen.P_el_n) annotation (Placement(transformation(extent={{-26,0},{-6,20}})));
  BrownCoal realisticGen(
    isPrimaryControlActive=false,
    isSecondaryControlActive=false,
    P_init=consteffGen.P_min_star*consteffGen.P_el_n,
    PartloadEfficiency(EfficiencyCharLine=TransiEnt.Producer.Electrical.Base.PartloadEfficiency.SteamturbinePlant(CL_eta_P=[0.3,0.8; 0.50,0.939; 0.60,0.965; 0.70,0.980; 0.8,0.990; 0.9,0.996; 1,1]))) annotation (Placement(transformation(extent={{-26,-36},{-6,-16}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=1 - consteffGen.P_min_star,
    duration=6*3600,
    offset=consteffGen.P_min_star) annotation (Placement(transformation(extent={{-94,18},{-74,38}})));
  Modelica.Blocks.Math.Gain from_pu(k=-consteffGen.P_el_n) annotation (Placement(transformation(extent={{-58,18},{-38,38}})));
equation
  connect(consteffGen.epp, grid.epp) annotation (Line(
      points={{-6.5,15.6},{8,15.6},{8,-8.1},{35.9,-8.1}},
      color={0,135,135},
      thickness=0.5));
  connect(realisticGen.epp, grid.epp) annotation (Line(
      points={{-6.5,-20.4},{8,-20.4},{8,-8.1},{35.9,-8.1}},
      color={0,135,135},
      thickness=0.5));
  connect(ramp.y, from_pu.u) annotation (Line(points={{-73,28},{-60,28}}, color={0,0,127}));
  connect(from_pu.y, consteffGen.P_el_set) annotation (Line(points={{-37,28},{-17.5,28},{-17.5,19.9}}, color={0,0,127}));
  connect(from_pu.y, realisticGen.P_el_set) annotation (Line(points={{-37,28},{-30,28},{-30,-10},{-17.5,-10},{-17.5,-16.1}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
                     experiment(StopTime=28800),
    __Dymola_experimentSetupOutput(events=false));
end CheckBlackCoal_twoVariants;
