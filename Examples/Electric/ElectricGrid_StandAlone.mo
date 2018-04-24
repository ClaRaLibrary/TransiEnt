within TransiEnt.Examples.Electric;
model ElectricGrid_StandAlone
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
extends TransiEnt.Basics.Icons.Example;
  TransiEnt.Producer.Combined.LargeScaleCHP.ContinuousCHP CHP(
    P_el_n=3e6,
    Q_flow_n_CHP=CHP.P_el_n/0.3,
    PQCharacteristics=TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_STGeneric(k_Q_flow=1/CHP.Q_flow_n_CHP, k_P_el=CHP.P_el_n),
    p_nom=18e5,
    T_feed_init=373.15) annotation (Placement(transformation(extent={{-236,80},{-176,20}})));
  TransiEnt.Basics.Tables.GenericDataTable heatDemandTable(relativepath="heat/HeatDemand_HHWilhelmsburg_MFH3000_900s_01012012_31122012.txt", constantfactor=-1.2) annotation (Placement(transformation(extent={{-280,190},{-240,230}})));
  Modelica.Blocks.Sources.RealExpression constHeatDemandCHP(y=max(heatDemandTable.y1 - 5e5, -CHP.Q_flow_n_CHP))
                                                                                                     annotation (Placement(transformation(
        extent={{20,-10},{-20,10}},
        rotation=270,
        origin={-195,-40})));
  Modelica.Blocks.Sources.RealExpression electricityDemandCHP1(y=-min(electricDemandTable.y1 + 0.5e6, 1e6))
                                                                                           annotation (Placement(transformation(
        extent={{20,-10},{-20,10}},
        rotation=270,
        origin={-224,-40})));
  inner TransiEnt.SimCenter simCenter(useHomotopy=false, ambientConditions(
      redeclare TransiEnt.Basics.Tables.Ambient.GHI_Hamburg_3600s_2012_TMY globalSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.Temperature_Berlin_3600s_2012 temperature,
      redeclare TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_Fuhlsbuettel_3600s_2012 wind))
                                      annotation (Placement(transformation(extent={{-280,260},{-240,300}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-240,260},{-200,300}})));
  TransiEnt.Consumer.Electrical.LinearElectricConsumer electricDemand annotation (Placement(transformation(
        extent={{-169.786,-5.35691},{-129.6,35.3561}},
        rotation=90,
        origin={-143.644,297.6})));
  TransiEnt.Producer.Electrical.Wind.PowerProfileWindPlant windProduction(P_el_n=2e6) annotation (Placement(transformation(extent={{-220,-238},{-180,-200}})));
  TransiEnt.Producer.Electrical.Photovoltaics.PVProfiles.SolarProfileLoader solarProfileLoader(change_of_sign=true, P_el_n=2e4) annotation (Placement(transformation(extent={{-278,-130},{-238,-90}})));
  TransiEnt.Producer.Electrical.Wind.WindProfiles.WindProfileLoader windProfileLoader(change_of_sign=true, P_el_n=2e6) annotation (Placement(transformation(extent={{-278,-212},{-240,-172}})));
  TransiEnt.Producer.Electrical.Photovoltaics.PhotovoltaicProfilePlant pVPlant(P_el_n=2e4) annotation (Placement(transformation(extent={{-220,-160},{-180,-120}})));
  TransiEnt.Basics.Tables.GenericDataTable electricDemandTable(relativepath="electricity/ElectricityDemand_VDI4665_ExampleHousehold_RG1_HH_2012_900s.txt", constantfactor=1500) annotation (Placement(transformation(extent={{-272,128},{-232,168}})));
  TransiEnt.Components.Electrical.Grid.Line line_L1_1 annotation (Placement(transformation(extent={{-150,-134},{-120,-102}})));
  TransiEnt.Components.Sensors.ElectricActivePower P_12(change_of_sign=true) annotation (Placement(transformation(extent={{-100,-108},{-80,-128}})));
  TransiEnt.Grid.Electrical.LumpedPowerGrid.LumpedGrid UCTE(
    delta_pr=0.2/50/(3/150 - 0.2*0.01),
    P_pr_max_star=0.02,
    k_pr=0.5,
    T_r=150,
    lambda_sec=simCenter.P_n_ref_2/(simCenter.P_n_ref_1 + simCenter.P_n_ref_2)*3e9/0.2,
    P_pr_grad_max_star=0.02/30,
    beta=0.2,
    redeclare TransiEnt.Grid.Electrical.Noise.TypicalLumpedGridError genericGridError) annotation (Placement(transformation(extent={{18,-160},{-62,-80}})));
  Modelica.Blocks.Sources.RealExpression massFlowDHN(y=-25) annotation (Placement(transformation(
        extent={{14,-15},{-14,15}},
        rotation=0,
        origin={-74,81})));
  Modelica.Blocks.Sources.RealExpression returnTemperatureDNH(y=70 + 273) annotation (Placement(transformation(
        extent={{14,-15},{-14,15}},
        rotation=0,
        origin={-74,55})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_Txim_flow boundaryVLE_Txim_flow(variable_T=true, boundaryConditions(p_nom=20e5)) annotation (Placement(transformation(extent={{-114,54},{-134,74}})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_pTxi boundaryVLE_pTxi(boundaryConditions(p_const=16e5)) annotation (Placement(transformation(extent={{-114,30},{-134,50}})));
equation
  connect(electricityDemandCHP1.y, CHP.P_set) annotation (Line(points={{-224,-18},{-224,-18},{-224,16},{-224.3,16},{-224.3,27}},     color={0,0,127}));
  connect(solarProfileLoader.y1, pVPlant.P_el_set) annotation (Line(points={{-236,-110},{-236,-112},{-236,-110},{-198,-110},{-198,-120},{-198,-120.2},{-203,-120.2}},
                                                                                                                                                          color={0,0,127}));
  connect(windProfileLoader.y1, windProduction.P_el_set) annotation (Line(points={{-238.1,-192},{-238.1,-192},{-202,-192},{-202,-192},{-202,-200.19},{-203,-200.19}},         color={0,0,127}));
  connect(line_L1_1.epp_2,P_12. epp_IN) annotation (Line(
      points={{-120.15,-118},{-120.15,-118},{-99.2,-118}},
      color={0,135,135},
      thickness=0.5));
  connect(P_12.epp_OUT,UCTE. epp) annotation (Line(
      points={{-80.6,-118},{-80.6,-120},{-62,-120}},
      color={0,135,135},
      thickness=0.5));
  connect(CHP.epp, line_L1_1.epp_1) annotation (Line(
      points={{-177.5,41},{-168,41},{-168,-32},{-160,-32},{-160,-118.16},{-149.85,-118.16}},
      color={0,135,135},
      thickness=0.5));
  connect(electricDemand.epp, line_L1_1.epp_1) annotation (Line(
      points={{-158.644,128.216},{-160.09,128.216},{-160.09,-118.16},{-149.85,-118.16}},
      color={0,135,135},
      thickness=0.5));
  connect(pVPlant.epp, line_L1_1.epp_1) annotation (Line(
      points={{-182,-126},{-176,-126},{-176,-128},{-172,-128},{-172,-118.16},{-149.85,-118.16}},
      color={0,135,135},
      thickness=0.5));
  connect(windProduction.epp, line_L1_1.epp_1) annotation (Line(
      points={{-182,-205.7},{-172,-205.7},{-172,-118},{-162,-118},{-162,-118.16},{-149.85,-118.16}},
      color={0,135,135},
      thickness=0.5));
  connect(CHP.Q_flow_set, constHeatDemandCHP.y) annotation (Line(points={{-194.9,27},{-194.9,-1.8},{-195,-1.8},{-195,-18}},   color={0,0,127}));
  connect(CHP.inlet, boundaryVLE_Txim_flow.fluidPortOut) annotation (Line(
      points={{-175.4,63.5},{-134,63.5},{-134,64}},
      color={175,0,0},
      thickness=0.5));
  connect(boundaryVLE_pTxi.fluidPortIn, CHP.outlet) annotation (Line(
      points={{-134,40},{-144,40},{-144,56.5},{-175.4,56.5}},
      color={175,0,0},
      thickness=0.5));
  connect(boundaryVLE_Txim_flow.T, returnTemperatureDNH.y) annotation (Line(points={{-112,64},{-104,64},{-104,55},{-89.4,55}}, color={0,0,127}));
  connect(massFlowDHN.y, boundaryVLE_Txim_flow.m_flow) annotation (Line(points={{-89.4,81},{-98,81},{-98,70},{-112,70}}, color={0,0,127}));
  connect(electricDemandTable.y1, electricDemand.P_el_set) annotation (Line(points={{-230,148},{-182.257,148},{-182.257,147.907}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(
        preserveAspectRatio=false,
        initialScale=0.1)), Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-300,-300},{300,300}},
        initialScale=0.1)),
    experiment(StopTime=86400, Interval=900),
    __Dymola_experimentSetupOutput(inputs=false, events=false),
    __Dymola_experimentFlags(
      Advanced(
        EvaluateAlsoTop=false,
        GenerateVariableDependencies=false,
        OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false),
Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Small electric system with CHP. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
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
<p>Created by Johannes Brunnemann (brunnemann@xrg-simulation.de), Jan 2017</p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Apr 2017</p>
<p>Revised by Pascal Dubucq (dubucq@tuhh.de), Apr 2017</p>
</html>"));
end ElectricGrid_StandAlone;
