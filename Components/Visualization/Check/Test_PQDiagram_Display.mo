within TransiEnt.Components.Visualization.Check;
model Test_PQDiagram_Display
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

  TransiEnt.Producer.Combined.LargeScaleCHP.ContinuousCHP largeScaleCHP_L1_TimeConstant(
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.HardCoal,
    m_flow_nom=500,
    Q_flow_init=145e6,
    h_nom=547e3,
    useConstantEfficiencies=false,
    P_el_n=1.4e+14,
    typeOfCO2AllocationMethod=1) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  Modelica.Blocks.Sources.RealExpression P_set(y=-200e6)
                                                        annotation (Placement(
        transformation(
        extent={{-20,-11},{20,11}},
        rotation=0,
        origin={-80,64})));
  Modelica.Blocks.Sources.RealExpression Q_flow_set(y=-100e6)
                                                            annotation (
      Placement(transformation(
        extent={{-20,-11},{20,11}},
        rotation=0,
        origin={-80,42})));
  Boundaries.Electrical.Frequency constantFrequency_L1_1(useInputConnector=false) annotation (Placement(transformation(extent={{40,42},{60,62}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi pressureSink_pT2(p_const(displayUnit="Pa") = 450000, T_const(displayUnit="K") = 384.624)
                                           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,0})));
  ClaRa.Visualisation.Quadruple quadruple annotation (Placement(transformation(extent={{68,22},{88,32}})));
  ClaRa.Visualisation.Quadruple quadruple1 annotation (Placement(transformation(extent={{70,-44},{90,-34}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow boundaryVLE_Txim_flow(m_flow_const=550,
    T_const(displayUnit="K") = 326.15,
    variable_m_flow=true)                                                                                           annotation (Placement(transformation(extent={{92,-34},{72,-14}})));
  ClaRa.Visualisation.Quadruple quadruple2
                                          annotation (Placement(transformation(extent={{32,18},{52,28}})));
  TransiEnt.Components.Visualization.InfoBoxLargeCHP infoBoxLargeCHP annotation (Placement(transformation(extent={{38,-50},{58,-28}})));
  TransiEnt.Components.Heat.Valve valve(opening_const_=1, redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=10e5 - 4.6e5)) annotation (Placement(transformation(extent={{34,-6},{54,6}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_set1(y=-gain.y/200e6*580)
                                                            annotation (
      Placement(transformation(
        extent={{-20,-11},{20,11}},
        rotation=0,
        origin={74,-60})));
  TransiEnt.Components.Visualization.PQDiagram_Display pQDiagram_Display(PQCharacteristics=TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_WW1()) annotation (Placement(transformation(extent={{-24,-94},{34,-40}})));
  Modelica.Blocks.Math.Gain gain(k=-200e6) annotation (Placement(transformation(extent={{-38,14},{-18,34}})));
  Modelica.Blocks.Sources.Pulse pulse(          period=3000000,
    amplitude=0.2,
    offset=0.8,
    width=50)                                                   annotation (Placement(transformation(extent={{-76,14},{-56,34}})));
equation
  connect(largeScaleCHP_L1_TimeConstant.epp, constantFrequency_L1_1.epp) annotation (Line(
      points={{9.5,3},{9.5,51.9},{39.9,51.9}},
      color={0,135,135},
      thickness=0.5));
  connect(pressureSink_pT2.eye, quadruple.eye) annotation (Line(
      points={{70,8},{70,18},{68,18},{68,27}},
      color={190,190,190}));
  connect(quadruple1.eye, boundaryVLE_Txim_flow.eye) annotation (Line(points={{70,-39},{72,-39},{72,-32}}, color={190,190,190}));
  connect(largeScaleCHP_L1_TimeConstant.eye, infoBoxLargeCHP.eye) annotation (Line(points={{11,-9.16667},{11,-37.2},{39,-37.2}},
                                                                                                                           color={28,108,200}));
  connect(P_set.y, largeScaleCHP_L1_TimeConstant.P_set) annotation (Line(points={{-58,64},{-12,64},{-12,7.66667},{-6.1,7.66667}},
                                                                                                                            color={0,0,127}));
  connect(largeScaleCHP_L1_TimeConstant.outlet, valve.inlet) annotation (Line(
      points={{10.2,-2.16667},{22,-2.16667},{22,0},{34,0}},
      color={175,0,0},
      thickness=0.5));
  connect(pressureSink_pT2.steam_a, valve.outlet) annotation (Line(
      points={{70,1.22125e-015},{62,1.22125e-015},{62,0},{54,0}},
      color={0,131,169},
      thickness=0.5));
  connect(quadruple2.eye, valve.eye) annotation (Line(points={{32,23},{58,23},{58,-4},{54,-4}}, color={190,190,190}));
  connect(boundaryVLE_Txim_flow.steam_a, largeScaleCHP_L1_TimeConstant.inlet) annotation (Line(
      points={{72,-24},{16,-24},{16,-4.5},{10.2,-4.5}},
      color={0,131,169},
      thickness=0.5));
  connect(boundaryVLE_Txim_flow.m_flow, Q_flow_set1.y) annotation (Line(points={{94,-18},{96,-18},{96,-60}}, color={0,0,127}));
  connect(pQDiagram_Display.eyeIn, largeScaleCHP_L1_TimeConstant.eye) annotation (Line(points={{-32.12,-67},{-38.12,-67},{-38.12,-52},{-38.12,-9.16667},{11,-9.16667}},
                                                                                                    color={28,108,200}));
  connect(gain.y, largeScaleCHP_L1_TimeConstant.Q_flow_set) annotation (Line(points={{-17,24},{4,24},{4,20},{4,12},{3.7,12},{3.7,7.66667}},
                                                                                                                                         color={0,0,127}));
  connect(gain.u, pulse.y) annotation (Line(points={{-40,24},{-55,24}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                                         Bitmap(extent={{-122,-100},{-44,-44}},
                                                                              fileName="modelica://TransiEnt/Images/PQ_WW1.PNG")}),
    experiment(StopTime=3.1536e+007, Interval=900),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end Test_PQDiagram_Display;
