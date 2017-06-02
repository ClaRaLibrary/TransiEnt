within TransiEnt.Producer.Gas.Electrolyzer.Systems.Check;
model Test_FeedInStation_CavernComp
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
  import TransiEnt;
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-28,-82})));
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3, redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_SRK_var gasModel1)
                                                                                                  annotation (Placement(transformation(extent={{0,40},{20,60}})));
  TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_CavernComp feedInStation(
    start_pressure=true,
    eta_n=0.75,
    t_overload=900,
    m_flow_start=1e-4,
    P_el_min=1e5,
    alpha_nom=133,
    includeHeatTransfer=true,
    V_geo=2,
    k=1e3,
    P_el_n=2e6,
    p_out=5000000,
    p_start=10000000,
    T_start=317.15) annotation (Placement(transformation(extent={{-38,-64},{-18,-44}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency ElectricGrid annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-72,-54})));
  Modelica.Blocks.Sources.Constant constP(k=4e6)  annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Modelica.Blocks.Sources.Step stepP(
    height=4e6,
    offset=0,
    startTime=4) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,10})));
  Modelica.Blocks.Sources.Ramp rampP(
    startTime=100,
    height=4e6,
    duration=1000)                              annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.Constant constM(k=0.01) annotation (Placement(transformation(extent={{40,-66},{20,-46}})));
  Modelica.Blocks.Sources.Step stepM(
    offset=0.01,
    height=-0.005,
    startTime=2)    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={30,4})));
  Modelica.Blocks.Sources.Ramp rampM(
    height=-0.01,
    duration=1000,
    offset=0.01,
    startTime=2200)                             annotation (Placement(transformation(extent={{40,-36},{20,-16}})));
  inner TransiEnt.ModelStatistics                                         modelStatistics annotation (Placement(transformation(extent={{20,40},{40,60}})));
equation
  connect(feedInStation.gasPortOut, boundaryRealGas_pTxi.gasPort) annotation (Line(
      points={{-28.5,-64.1},{-28.5,-72},{-28,-72}},
      color={255,255,0},
      thickness=1.5));
  connect(feedInStation.epp, ElectricGrid.epp) annotation (Line(
      points={{-38,-54},{-42,-54},{-42,-53.9},{-61.9,-53.9}},
      color={0,135,135},
      thickness=0.5));
  connect(rampM.y, feedInStation.m_flow_feedIn) annotation (Line(points={{19,-26},{4,-26},{-14,-26},{-14,-46},{-18,-46}}, color={0,0,127}));
  connect(rampP.y, feedInStation.P_el_set) annotation (Line(points={{-59,40},{-42,40},{-42,-46},{-38,-46}},
                                                                                                    color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=3600, __Dymola_NumberOfIntervals=10000),
    __Dymola_experimentSetupOutput);
end Test_FeedInStation_CavernComp;
