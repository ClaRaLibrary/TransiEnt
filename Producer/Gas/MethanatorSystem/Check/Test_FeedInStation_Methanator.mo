within TransiEnt.Producer.Gas.MethanatorSystem.Check;
model Test_FeedInStation_Methanator "Model for testing the Methanator FeedInStation"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-BSD-clause.           //
// Copyright 2021, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE, ResiliEntEE, IntegraNet and IntegraNet II are research projects  //
// supported by the German Federal Ministry of Economics and Energy               //
// (FKZ 03ET4003, 03ET4048, 0324027 and 03EI1008).                                //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Fraunhofer Institute for Environmental, Safety, and Energy Technology UMSICHT, //
// Gas- und Wärme-Institut Essen						  //
// and                                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//



  extends TransiEnt.Basics.Icons.Checkmodel;
  FeedInStation_Methanation feedInSystem_Methanation(
    usePowerPort=true,
    scalingOfReactor=1,
    redeclare Electrolyzer.Systems.FeedInStation_CavernComp feedInStation_Hydrogen(
      StoreAllHydrogen=true,
      P_el_n=0.7e9,
      p_maxHigh=14000000,
      p_maxLow=13900000,
      p_minHigh=9000000,
      p_start=6000000),
    m_flow_n_Methane=10,
    hydrogenFraction_fixed=0.05) annotation (Placement(transformation(extent={{-54,24},{-34,44}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-44,-4})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-86,34})));
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3, redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_SRK_var gasModel1)
                                                                                                  annotation (Placement(transformation(extent={{60,80},{80,100}})));
  inner TransiEnt.ModelStatistics                                         modelStatistics annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=0.7e9) annotation (Placement(transformation(extent={{-84,58},{-64,78}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=10) annotation (Placement(transformation(extent={{18,48},{-2,68}})));
  FeedInStation_Methanation feedInSystem_Methanation2(
    usePowerPort=true,
    scalingOfReactor=1,
    m_flow_n_Methane=10,
    hydrogenFraction_fixed=0.05,
    redeclare Electrolyzer.Systems.FeedInStation_CavernComp feedInStation_Hydrogen(P_el_n=0.7e9))
                                     annotation (Placement(transformation(extent={{0,-114},{20,-94}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi           boundaryRealGas_pTxi3
                                                                                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={10,-142})));
  Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-32,-104})));
  Modelica.Blocks.Sources.RealExpression realExpression5(y=0.7e9)
                                                                 annotation (Placement(transformation(extent={{-30,-80},{-10,-60}})));
  Modelica.Blocks.Sources.RealExpression realExpression6(y=0.1)
                                                               annotation (Placement(transformation(extent={{72,-90},{52,-70}})));
  FeedInStation_Methanation feedInSystem_Methanation1(
    usePowerPort=true,
    useSeperateHydrogenOutput=true,
    scalingOfReactor=1,
    m_flow_n_Methane=10,
    hydrogenFraction_fixed=0.05,
    redeclare Electrolyzer.Systems.FeedInStation_CavernComp feedInStation_Hydrogen(P_el_n=1.7e9)) annotation (Placement(transformation(extent={{-126,-116},{-106,-96}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi           boundaryRealGas_pTxi1
                                                                                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-116,-144})));
  Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-158,-106})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=1.7e9)
                                                                 annotation (Placement(transformation(extent={{-156,-82},{-136,-62}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi           boundaryRealGas_pTxi2
                                                                                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-58,-134})));
  Modelica.Blocks.Sources.RealExpression realExpression4(y=0.1)
                                                               annotation (Placement(transformation(extent={{-54,-74},{-74,-54}})));
  FeedInStation_Methanation feedInSystem_Methanation3(
    usePowerPort=true,
    useSeperateHydrogenOutput=true,
    useVariableHydrogenFraction=true,
    scalingOfReactor=1,
    m_flow_n_Methane=10,
    hydrogenFraction_fixed=0.05,
    redeclare Electrolyzer.Systems.FeedInStation_CavernComp feedInStation_Hydrogen(P_el_n=0.7e9))
                                      annotation (Placement(transformation(extent={{-138,-244},{-118,-224}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi           boundaryRealGas_pTxi4
                                                                                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-128,-272})));
  Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid3 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-170,-234})));
  Modelica.Blocks.Sources.RealExpression realExpression7(y=0.7e9)
                                                                 annotation (Placement(transformation(extent={{-168,-210},{-148,-190}})));
  Modelica.Blocks.Sources.RealExpression realExpression8(y=0.1)
                                                               annotation (Placement(transformation(extent={{-66,-220},{-86,-200}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi           boundaryRealGas_pTxi5
                                                                                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-70,-262})));
  Modelica.Blocks.Sources.RealExpression realExpression9(y=0.1)
                                                               annotation (Placement(transformation(extent={{-66,-202},{-86,-182}})));
  Modelica.Blocks.Sources.Ramp ramp(duration=36000) annotation (Placement(transformation(extent={{-174,-280},{-154,-260}})));
  Modelica.Blocks.Sources.Ramp ramp1(duration=36000, height=1)
                                                    annotation (Placement(transformation(extent={{-188,-94},{-168,-74}})));
  FeedInStation_Methanation feedInSystem_Methanation4(
    scalingOfReactor=1,
    redeclare Electrolyzer.Systems.FeedInStation_CavernComp feedInStation_Hydrogen(
      StoreAllHydrogen=true,
      P_el_n=0.7e9,
      p_maxHigh=14000000,
      p_maxLow=13900000,
      p_minHigh=9000000,
      p_start=6000000),
    m_flow_n_Methane=10,
    hydrogenFraction_fixed=0.05,
    redeclare MethanatorSystem_L1 methanation) annotation (Placement(transformation(extent={{-174,24},{-154,44}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi           boundaryRealGas_pTxi6
                                                                                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-164,8})));
  Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid4 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-206,34})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y=0.7e9)
                                                                 annotation (Placement(transformation(extent={{-204,58},{-184,78}})));
  Modelica.Blocks.Sources.RealExpression realExpression10(y=10)
                                                               annotation (Placement(transformation(extent={{-102,48},{-122,68}})));
  FeedInStation_Methanation feedInSystem_Methanation5(
    useSeperateHydrogenOutput=true,
    useVariableHydrogenFraction=true,
    scalingOfReactor=1,
    m_flow_n_Methane=11,
    hydrogenFraction_fixed=0.05,
    redeclare Electrolyzer.Systems.FeedInStation_CavernComp feedInStation_Hydrogen(P_el_n=0.7e9),
    redeclare MethanatorSystem_L1 methanation(useVariableHydrogenFraction=true))
                                      annotation (Placement(transformation(extent={{14,-238},{34,-218}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi           boundaryRealGas_pTxi7
                                                                                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={24,-264})));
  Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid5 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-18,-226})));
  Modelica.Blocks.Sources.RealExpression realExpression11(y=0.7e9)
                                                                 annotation (Placement(transformation(extent={{-16,-202},{4,-182}})));
  Modelica.Blocks.Sources.RealExpression realExpression12(y=0.1)
                                                               annotation (Placement(transformation(extent={{86,-212},{66,-192}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi           boundaryRealGas_pTxi8
                                                                                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={82,-254})));
  Modelica.Blocks.Sources.RealExpression realExpression13(y=0.1)
                                                               annotation (Placement(transformation(extent={{86,-194},{66,-174}})));
  Modelica.Blocks.Sources.Ramp ramp2(duration=36000)
                                                    annotation (Placement(transformation(extent={{-22,-272},{-2,-252}})));
equation
  connect(boundaryRealGas_pTxi.gasPort, feedInSystem_Methanation.gasPortOut) annotation (Line(
      points={{-44,6},{-44,23.9},{-44.5,23.9}},
      color={255,255,0},
      thickness=1.5));
  connect(ElectricGrid.epp, feedInSystem_Methanation.epp) annotation (Line(
      points={{-76,34},{-64,34},{-64,34},{-54,34}},
      color={0,135,135},
      thickness=0.5));
  connect(realExpression.y, feedInSystem_Methanation.P_el_set) annotation (Line(points={{-63,68},{-44,68},{-44,44.4}},
                                                                                                                   color={0,0,127}));
  connect(feedInSystem_Methanation.m_flow_feedIn, realExpression1.y) annotation (Line(points={{-34,42},{-24,42},{-24,58},{-3,58}},
                                                                                                                              color={0,0,127}));
  connect(boundaryRealGas_pTxi3.gasPort, feedInSystem_Methanation2.gasPortOut) annotation (Line(
      points={{10,-132},{10,-114.1},{9.5,-114.1}},
      color={255,255,0},
      thickness=1.5));
  connect(ElectricGrid2.epp, feedInSystem_Methanation2.epp) annotation (Line(
      points={{-22,-104},{-10,-104},{-10,-104},{0,-104}},
      color={0,135,135},
      thickness=0.5));
  connect(realExpression5.y, feedInSystem_Methanation2.P_el_set) annotation (Line(points={{-9,-70},{10,-70},{10,-93.6}}, color={0,0,127}));
  connect(feedInSystem_Methanation2.m_flow_feedIn, realExpression6.y) annotation (Line(points={{20,-96},{30,-96},{30,-80},{51,-80}}, color={0,0,127}));
  connect(boundaryRealGas_pTxi1.gasPort, feedInSystem_Methanation1.gasPortOut) annotation (Line(
      points={{-116,-134},{-116,-116.1},{-116.5,-116.1}},
      color={255,255,0},
      thickness=1.5));
  connect(ElectricGrid1.epp, feedInSystem_Methanation1.epp) annotation (Line(
      points={{-148,-106},{-136,-106},{-136,-106},{-126,-106}},
      color={0,135,135},
      thickness=0.5));
  connect(realExpression2.y, feedInSystem_Methanation1.P_el_set) annotation (Line(points={{-135,-72},{-116,-72},{-116,-95.6}}, color={0,0,127}));
  connect(feedInSystem_Methanation1.gasPortOut_H2, boundaryRealGas_pTxi2.gasPort) annotation (Line(
      points={{-106.3,-106.5},{-58,-106.5},{-58,-124}},
      color={255,255,0},
      thickness=1.5));
  connect(boundaryRealGas_pTxi4.gasPort,feedInSystem_Methanation3. gasPortOut) annotation (Line(
      points={{-128,-262},{-128,-244.1},{-128.5,-244.1}},
      color={255,255,0},
      thickness=1.5));
  connect(ElectricGrid3.epp,feedInSystem_Methanation3. epp) annotation (Line(
      points={{-160,-234},{-148,-234},{-148,-234},{-138,-234}},
      color={0,135,135},
      thickness=0.5));
  connect(realExpression7.y,feedInSystem_Methanation3. P_el_set) annotation (Line(points={{-147,-200},{-128,-200},{-128,-223.6}},
                                                                                                                               color={0,0,127}));
  connect(feedInSystem_Methanation3.m_flow_feedIn,realExpression8. y) annotation (Line(points={{-118,-226},{-108,-226},{-108,-210},{-87,-210}},
                                                                                                                                          color={0,0,127}));
  connect(feedInSystem_Methanation3.gasPortOut_H2,boundaryRealGas_pTxi5. gasPort) annotation (Line(
      points={{-118.3,-234.5},{-70,-234.5},{-70,-252}},
      color={255,255,0},
      thickness=1.5));
  connect(realExpression9.y,feedInSystem_Methanation3. m_flow_feedIn_H2) annotation (Line(points={{-87,-192},{-138,-192},{-138,-226},{-137.8,-226}},
                                                                                                                                                 color={0,0,127}));
  connect(ramp.y,feedInSystem_Methanation3.hydrogenFraction_input)  annotation (Line(points={{-153,-270},{-146,-270},{-146,-242},{-137.8,-242}},     color={0,0,127}));
  connect(feedInSystem_Methanation1.m_flow_feedIn, realExpression4.y) annotation (Line(points={{-106,-98},{-106,-64},{-75,-64}}, color={0,0,127}));
  connect(ramp1.y, feedInSystem_Methanation1.m_flow_feedIn_H2) annotation (Line(points={{-167,-84},{-130,-84},{-130,-98},{-125.8,-98}}, color={0,0,127}));
  connect(boundaryRealGas_pTxi6.gasPort, feedInSystem_Methanation4.gasPortOut) annotation (Line(
      points={{-164,18},{-164,23.9},{-164.5,23.9}},
      color={255,255,0},
      thickness=1.5));
  connect(ElectricGrid4.epp, feedInSystem_Methanation4.epp) annotation (Line(
      points={{-196,34},{-174,34}},
      color={0,135,135},
      thickness=0.5));
  connect(realExpression3.y, feedInSystem_Methanation4.P_el_set) annotation (Line(points={{-183,68},{-164,68},{-164,44.4}}, color={0,0,127}));
  connect(feedInSystem_Methanation4.m_flow_feedIn, realExpression10.y) annotation (Line(points={{-154,42},{-144,42},{-144,58},{-123,58}}, color={0,0,127}));
  connect(boundaryRealGas_pTxi7.gasPort,feedInSystem_Methanation5. gasPortOut) annotation (Line(
      points={{24,-254},{24,-238.1},{23.5,-238.1}},
      color={255,255,0},
      thickness=1.5));
  connect(ElectricGrid5.epp,feedInSystem_Methanation5. epp) annotation (Line(
      points={{-8,-226},{4,-226},{4,-228},{14,-228}},
      color={0,135,135},
      thickness=0.5));
  connect(realExpression11.y, feedInSystem_Methanation5.P_el_set) annotation (Line(points={{5,-192},{24,-192},{24,-217.6}}, color={0,0,127}));
  connect(feedInSystem_Methanation5.m_flow_feedIn, realExpression12.y) annotation (Line(points={{34,-220},{44,-220},{44,-202},{65,-202}}, color={0,0,127}));
  connect(feedInSystem_Methanation5.gasPortOut_H2,boundaryRealGas_pTxi8. gasPort) annotation (Line(
      points={{33.7,-228.5},{82,-228.5},{82,-244}},
      color={255,255,0},
      thickness=1.5));
  connect(realExpression13.y, feedInSystem_Methanation5.m_flow_feedIn_H2) annotation (Line(points={{65,-184},{14,-184},{14,-220},{14.2,-220}}, color={0,0,127}));
  connect(ramp2.y, feedInSystem_Methanation5.hydrogenFraction_input) annotation (Line(points={{-1,-262},{6,-262},{6,-236},{14.2,-236}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false, extent={{-220,-300},{100,100}})),
                                                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-300},{100,100}}),
                                                                                                                      graphics={Text(
          extent={{-124,102},{-12,76}},
          lineColor={28,108,200},
          textString="The storage of the FeedInSystem is calibrated such that the methanation only takes place under full load condition and only if enough hydrogen is stored
 such that switching operations of the methanation reactor are reduced (Therefor parameter StoreAllHydrogen is set to true).
The bypass of the FeedInStation is calibrated such that the molar hydrogen content at the output is always 5%
"),                                                                                                                             Text(
          extent={{-106,-32},{6,-58}},
          lineColor={28,108,200},
          textString="Difference of the two following feedInStations: Left one with additional seperate Hydrogen output.
"),                                                                                                                             Text(
          extent={{-118,-160},{-6,-186}},
          lineColor={28,108,200},
          textString="Difference of the two following feedInStations: Left one with MethanatorSystem_L4, right one with MethanatorSystem_L2")}),
    experiment(StopTime=360000, Interval=600),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the Methanator FeedInStation</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=true,
      OutputFlatModelica=true));
end Test_FeedInStation_Methanator;
