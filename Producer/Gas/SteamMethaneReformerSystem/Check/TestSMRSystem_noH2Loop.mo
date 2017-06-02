within TransiEnt.Producer.Gas.SteamMethaneReformerSystem.Check;
model TestSMRSystem_noH2Loop
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

  TransiEnt.Producer.Gas.SteamMethaneReformerSystem.SMRSystem_noH2Loop sMRSystem_sufficientH2inFeed(
    redeclare model CostSpecsGeneral = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.SMR,
    H_flow_H2_n=200e6,
    N_cv_SMR=10,
    Cspec_demAndRev_el=simCenter.Cspec_demAndRev_el_70_150_GWh,
    Cspec_demAndRev_other_water=simCenter.Cspec_demAndRev_other_water) annotation (Placement(transformation(extent={{-60,-30},{60,30}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source(
    xi_const=source.medium.xi_default*(1 - 0.1),
    m_flow_const=-3.21,
    medium=Basics.Media.Gases.VLE_VDIWA_NG7_SG_var(),
    T_const=293.15) annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sinkHydrogen(medium=TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG6_var(), p_const=2000000) annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature_HEX_feed(each T(displayUnit="degC") = 864.18)    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-50,50})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature_HEX_H2O(each T(displayUnit="degC") = 864.18)
                                         annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-26,80})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature_SMR(each T(displayUnit="K") = 1625) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,50})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sinkWasteGas(
    T_const(displayUnit="K"),
    medium=TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG6_var(),
    p_const=100000) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={50,78})));
equation
  connect(source.gasPort, sMRSystem_sufficientH2inFeed.gasPortIn) annotation (Line(
      points={{-80,0},{-70,0},{-60,0}},
      color={255,255,0},
      thickness=1.5));
  connect(sMRSystem_sufficientH2inFeed.gasPortOut_hydrogen, sinkHydrogen.gasPort) annotation (Line(
      points={{60,0},{70,0},{80,0}},
      color={255,255,0},
      thickness=1.5));
  connect(fixedTemperature_HEX_feed.port, sMRSystem_sufficientH2inFeed.heatFeedPreheater) annotation (Line(points={{-50,40},{-50,30}},               color={191,0,0}));
  connect(fixedTemperature_HEX_H2O.port, sMRSystem_sufficientH2inFeed.heatSteamPreheater) annotation (Line(points={{-26,70},{-26,70},{-26,30},{-25,30}},      color={191,0,0}));
  connect(fixedTemperature_SMR.port, sMRSystem_sufficientH2inFeed.heatSMR) annotation (Line(points={{-1.77636e-015,40},{-1.77636e-015,30},{0,30}},
                                                                                                                                 color={191,0,0}));
  connect(sinkWasteGas.gasPort, sMRSystem_sufficientH2inFeed.gasPortOut_offGas) annotation (Line(
      points={{50,68},{50,68},{50,30}},
      color={255,255,0},
      thickness=1.5));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-40},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-40},{100,100}})),
    experiment(StopTime=10000));
end TestSMRSystem_noH2Loop;
