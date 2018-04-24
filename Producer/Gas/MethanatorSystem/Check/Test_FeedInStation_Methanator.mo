within TransiEnt.Producer.Gas.MethanatorSystem.Check;
model Test_FeedInStation_Methanator
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
  FeedInSystem_Methanation feedInSystem_Methanation(
    ScalingOfReactor=1,
    redeclare Electrolyzer.Systems.FeedInStation_CavernComp feedInStation_Hydrogen(
      StoreAllHydrogen=true,
      P_el_n=0.7e9,
      p_maxHigh=14000000,
      p_maxLow=13900000,
      p_minHigh=9000000,
      p_start=6000000),
    m_flow_n_Methane=10,
    HydrogenContentOutput=0.05) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={0,-38})));
  TransiEnt.Components.Boundaries.Electrical.Frequency ElectricGrid annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-42,0})));
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3, redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_SRK_var gasModel1)
                                                                                                  annotation (Placement(transformation(extent={{60,80},{80,100}})));
  inner TransiEnt.ModelStatistics                                         modelStatistics annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=0.7e9) annotation (Placement(transformation(extent={{-40,24},{-20,44}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=10) annotation (Placement(transformation(extent={{62,14},{42,34}})));
equation
  connect(boundaryRealGas_pTxi.gasPort, feedInSystem_Methanation.gasPortOut) annotation (Line(
      points={{0,-28},{0,-10.1},{-0.5,-10.1}},
      color={255,255,0},
      thickness=1.5));
  connect(ElectricGrid.epp, feedInSystem_Methanation.epp) annotation (Line(
      points={{-31.9,0.1},{-20,0.1},{-20,0},{-10,0}},
      color={0,135,135},
      thickness=0.5));
  connect(realExpression.y, feedInSystem_Methanation.P_el_set) annotation (Line(points={{-19,34},{0,34},{0,10.4}}, color={0,0,127}));
  connect(feedInSystem_Methanation.m_flow_feedIn, realExpression1.y) annotation (Line(points={{10,8},{20,8},{20,24},{41,24}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-64,78},{48,52}},
          lineColor={28,108,200},
          textString="The storage of the FeedInSystem is calibrated such that the methanation only takes place under full load condition and only if enough hydrogen is stored
 such that switching operations of the methanation reactor are reduced.
The bypass of the FeedInStation is calibrated such that the molar hydrogen content at the output is always 5%
")}),
    experiment(StopTime=36000, Interval=600));
end Test_FeedInStation_Methanator;
