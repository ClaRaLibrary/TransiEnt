within TransiEnt.Grid.Heat.HeatGridTopology.Check;
model Test_DHG_Topology_HH_1port_3sites_SimpleGrid
  import TransiEnt;


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




  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Example;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-338,240},{-318,260}})));
  inner TransiEnt.SimCenter simCenter(p_nom={420000,460000}) annotation (Placement(transformation(extent={{-358,240},{-338,260}})));
  TransiEnt.Producer.Combined.LargeScaleCHP.ContinuousCHP HKW_Wedel2(
    typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.BlackCoal,
    PQCharacteristics=TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_WW2(),
    P_el_n=137e6,
    p_nom=20e5,
    m_flow_nom=1100,
    h_nom=120*4.2) annotation (Placement(transformation(extent={{-334,-112},{-256,-48}})));
    //typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Cogeneration,
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow massFlowSource_Wedel(
    m_flow_const=2*1905,
    T_const=52 + 273,
    variable_m_flow=true,
    p_nom=20e5,
    variable_T=true)      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-236,-126})));
  TransiEnt.Producer.Combined.LargeScaleCHP.ContinuousCHP HKW_Tiefstack(
    P_el_n=200e6,
    Q_flow_init=300e6,
    typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.BlackCoal,
    PQCharacteristics=TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_WT(),
    p_nom=20e5,
    m_flow_nom=1500,
    h_nom=120*4.2) annotation (Placement(transformation(extent={{340,-50},{272,18}})));
    //typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Cogeneration,
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow massFlowSource_Tiefstack(
    m_flow_const=2*1905,
    T_const=52 + 273,
    variable_m_flow=true,
    p_nom=20e5,
    variable_T=true)      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={263,-98})));
  TransiEnt.Grid.Heat.HeatGridControl.Controllers.SimpleDHNDispatcher simpleHeatDispatcher annotation (Placement(transformation(rotation=0, extent={{-340,168},{-278,230}})));

  TransiEnt.Producer.Heat.Gas2Heat.SimpleGasBoiler.SimpleBoiler HW_HafenCity(typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.NaturalGas, p_drop=50000) annotation (Placement(transformation(
        extent={{-19,-18},{19,18}},
        rotation=0,
        origin={-73,-110})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency constantFrequency_L1_3(useInputConnector=false) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-10,136})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi gasGrid annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,-164})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow massFlowSource_HafenCity(
    m_flow_const=2*1905,
    T_const=52 + 273,
    variable_m_flow=true,
    p_nom=20e5,
    variable_T=true)      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-101,-164})));
  TransiEnt.Grid.Heat.HeatGridTopology.GridConfigurations.DHG_Topology_HH_1port_3sites_SimpleGrid dHN_Topology_HH_SimpleGrid_3sites annotation (Placement(transformation(extent={{-102,-74},{150,100}})));
  TransiEnt.Producer.Combined.LargeScaleCHP.ContinuousCHP HKW_Wedel1(
    typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.BlackCoal,
    PQCharacteristics=TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_WW1(),
    P_el_n=150e6,
    p_nom=20e5,
    m_flow_nom=1100,
    h_nom=120*4.2) annotation (Placement(transformation(extent={{-334,-42},{-256,22}})));
    //typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Cogeneration,
  Modelica.Blocks.Sources.RealExpression P_set(y=simpleHeatDispatcher.P_el_WW/2) annotation (Placement(transformation(extent={{-354,32},{-334,52}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_set(y=simpleHeatDispatcher.Q_flow_WW/2) annotation (Placement(transformation(extent={{-318,58},{-298,78}})));
  Modelica.Blocks.Sources.RealExpression m_flow_set(y=-1*simpleHeatDispatcher.m_flow_WW) annotation (Placement(transformation(extent={{-272,-172},{-252,-152}})));
  Modelica.Blocks.Sources.RealExpression m_flow_set1(y=-1*simpleHeatDispatcher.m_flow_peak) annotation (Placement(transformation(extent={{-136,-212},{-116,-192}})));
  Modelica.Blocks.Sources.RealExpression m_flow_set2(y=-1*simpleHeatDispatcher.m_flow_WT) annotation (Placement(transformation(extent={{222,-120},{242,-100}})));
  TransiEnt.Components.Visualization.Quadruple quadruple annotation (Placement(transformation(extent={{-224,-136},{-134,-110}})));
  TransiEnt.Components.Visualization.Quadruple quadruple1 annotation (Placement(transformation(extent={{-184,-170},{-116,-146}})));
  TransiEnt.Components.Visualization.Quadruple quadruple2 annotation (Placement(transformation(extent={{274,-98},{346,-76}})));
  TransiEnt.Components.Visualization.InfoBoxLargeCHP infoBoxLargeCHP annotation (Placement(transformation(extent={{236,-82},{170,-30}})));
  TransiEnt.Components.Visualization.InfoBoxLargeCHP infoBoxLargeCHP1 annotation (Placement(transformation(extent={{-218,-4},{-154,64}})));
  TransiEnt.Components.Visualization.InfoBoxLargeCHP infoBoxLargeCHP2 annotation (Placement(transformation(extent={{-216,-80},{-156,-18}})));
  TransiEnt.Components.Visualization.InfoBoxLargeCHP infoBoxLargeCHP3 annotation (Placement(transformation(extent={{-32,-146},{38,-76}})));
  Modelica.Blocks.Sources.RealExpression T_return(y=273.15 + simpleHeatDispatcher.supplyandReturnTemperature.T_set[2]) annotation (Placement(transformation(extent={{-248,-188},{-228,-168}})));
  Modelica.Blocks.Sources.RealExpression T_return1(y=273.15 + simpleHeatDispatcher.supplyandReturnTemperature.T_set[2]) annotation (Placement(transformation(extent={{-124,-230},{-104,-210}})));
  Modelica.Blocks.Sources.RealExpression T_return2(y=273.15 + simpleHeatDispatcher.supplyandReturnTemperature.T_set[2]) annotation (Placement(transformation(extent={{242,-138},{262,-118}})));
  TransiEnt.Components.Visualization.DynDisplay Time(
    x1=time/3600,
    unit="h",
    varname="Time") annotation (Placement(transformation(extent={{260,-256},{354,-226}})));
  TransiEnt.Components.Visualization.DynDisplay HeatDemand_Display(
    varname="Heat Demand",
    x1=dHN_Topology_HH_SimpleGrid_3sites.Q_flow_dem/1e6,
    unit="MW") annotation (Placement(transformation(extent={{262,-222},{354,-188}})));
  TransiEnt.Components.Visualization.DynDisplay T_amb_Display(
    varname="T_amb",
    x1=simpleHeatDispatcher.temperatureHH_900s_01012012_0000_31122012_2345.value,
    unit="C") annotation (Placement(transformation(extent={{260,-186},{352,-154}})));

  // _____________________________________________
  //
  //           Functions
  // _____________________________________________

   function plotResult
   constant String resultFileName = "Test_DHG_Topology_HH_1port_3sites_SimpleGrid.mat";
   algorithm
    TransiEnt.Basics.Functions.plotResult("resultFileName");
     createPlot(id=2, position={744, 0, 763, 423}, y={"simpleHeatDispatcher.P_el_WW", "simpleHeatDispatcher.P_el_WT"}, range={0.0, 32000000.0, -300000000.0, 0.0}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
      createPlot(id=2, position={744, 0, 763, 138}, y={"simpleHeatDispatcher.m_flow_WW", "simpleHeatDispatcher.m_flow_WT",
      "simpleHeatDispatcher.m_flow_peak"}, range={0.0, 32000000.0, -2000.0, 0.0}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}, {0,140,72}});
      createPlot(id=2, position={744, 0, 763, 137}, y={"simpleHeatDispatcher.Q_flow_WW", "simpleHeatDispatcher.Q_flow_WT",
      "simpleHeatDispatcher.Q_flow_peak"}, range={0.0, 32000000.0, -1000000000.0, 500000000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}, {0,140,72}});
      createPlot(id=5, position={-13, 0, 741, 858}, y={"dHN_Topology_HH_SimpleGrid_3sites.Q_flow_dem"}, range={0.0, 32000000.0, -200.0, 1800.0}, autoscale=false, grid=true, colors={{28,108,200}}, range2={0.5599999999999999, 0.82});
      createPlot(id=5, position={-13, 0, 741, 426}, y={"dHN_Topology_HH_SimpleGrid_3sites.Q_dem"}, range={0.0, 32000000.0, -500000000.0, 4000000000.0}, grid=true, subPlot=2, colors={{28,108,200}});
      createPlot(id=6, position={743, 457, 758, 410}, y={"dHN_Topology_HH_SimpleGrid_3sites.HeatConsumerWest.fluidIn.T",
      "dHN_Topology_HH_SimpleGrid_3sites.HeatConsumerNorth.fluidIn.T",
      "dHN_Topology_HH_SimpleGrid_3sites.HeatConsumerEast.fluidIn.T",
      "dHN_Topology_HH_SimpleGrid_3sites.HeatConsumerWest.fluidOut.T",
      "dHN_Topology_HH_SimpleGrid_3sites.HeatConsumerNorth.fluidOut.T",
      "dHN_Topology_HH_SimpleGrid_3sites.HeatConsumerEast.fluidOut.T",
      "dHN_Topology_HH_SimpleGrid_3sites.supplyandReturnTemperature1.T_set[1]",
      "dHN_Topology_HH_SimpleGrid_3sites.supplyandReturnTemperature1.T_set[2]"}, range={0.0, 32000000.0, 0.0, 150.0}, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}, {0,0,0}, {162,29,33},
      {244,125,35}, {102,44,145}});
      createPlot(id=6, position={743, 457, 758, 202}, y={"dHN_Topology_HH_SimpleGrid_3sites.HeatConsumerWest.fluidIn.p",
      "dHN_Topology_HH_SimpleGrid_3sites.HeatConsumerNorth.fluidIn.p",
      "dHN_Topology_HH_SimpleGrid_3sites.HeatConsumerEast.fluidIn.p",
      "dHN_Topology_HH_SimpleGrid_3sites.HeatConsumerNorth.fluidOut.p",
      "dHN_Topology_HH_SimpleGrid_3sites.HeatConsumerEast.fluidOut.p",
      "dHN_Topology_HH_SimpleGrid_3sites.HeatConsumerWest.fluidOut.p"}, range={0.0, 32000000.0, 4.15, 4.4}, autoscale=false, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}, {0,0,0}, {162,29,33}}, range2={0.67, 0.7200000000000001});

   end plotResult;

equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(HKW_Tiefstack.inlet,massFlowSource_Tiefstack. steam_a) annotation (
      Line(
      points={{271.32,-31.3},{271.32,-33.78},{263,-33.78},{263,-88}},
      color={175,0,0},
      smooth=Smooth.None,
      thickness=1));
  connect(HKW_Wedel2.inlet, massFlowSource_Wedel.steam_a) annotation (Line(
      points={{-255.22,-94.4},{-255.22,-95.44},{-236,-95.44},{-236,-116}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(simpleHeatDispatcher.Q_flow_peak,HW_HafenCity. Q_flow_set)
    annotation (Line(
      points={{-274.9,174.2},{-258,174.2},{-258,174},{-162,174},{-162,-92},{-73,-92}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HKW_Tiefstack.epp,constantFrequency_L1_3. epp) annotation (Line(
      points={{273.7,-5.8},{272,-5.8},{272,126},{-10,126}},
      color={0,135,135},
      thickness=0.5,
      smooth=Smooth.None));

  connect(HW_HafenCity.inlet,massFlowSource_HafenCity. steam_a) annotation (
      Line(
      points={{-91.62,-110},{-100,-110},{-100,-154},{-101,-154}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(HKW_Wedel2.epp, constantFrequency_L1_3.epp) annotation (Line(
      points={{-257.95,-70.4},{-218.975,-70.4},{-218.975,126},{-10,126}},
      color={0,135,135},
      thickness=0.5,
      smooth=Smooth.None));

  connect(dHN_Topology_HH_SimpleGrid_3sites.fluidPortEast, HKW_Tiefstack.outlet) annotation (Line(
      points={{36.6,-3.22432},{134.75,-3.22432},{134.75,-23.3667},{271.32,-23.3667}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(HW_HafenCity.outlet, dHN_Topology_HH_SimpleGrid_3sites.fluidPortCenter) annotation (Line(
      points={{-54,-110},{-38,-110},{-38,1.00811},{18.3702,1.00811}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(gasGrid.gasPort, HW_HafenCity.gasIn) annotation (Line(
      points={{-70,-154},{-72,-154},{-72,-128},{-72.62,-128}},
      color={255,255,0},
      thickness=0.75));
  connect(simpleHeatDispatcher.Q_flow_WT, HKW_Tiefstack.Q_flow_set) annotation (Line(points={{-274.9,215.12},{293.42,215.12},{293.42,10.0667}},
                                                                                                                                              color={0,0,127}));
  connect(HKW_Tiefstack.P_set, simpleHeatDispatcher.P_el_WT) annotation (Line(points={{326.74,10.0667},{326.74,221.32},{-274.9,221.32}},
                                                                                                                                       color={0,0,127}));
  connect(HKW_Wedel1.epp, constantFrequency_L1_3.epp) annotation (Line(
      points={{-257.95,-0.4},{-236.975,-0.4},{-236.975,126},{-10,126}},
      color={0,135,135},
      thickness=0.5));
  connect(HKW_Wedel2.outlet, HKW_Wedel1.inlet) annotation (Line(
      points={{-255.22,-86.9333},{-236,-86.9333},{-236,-24.4},{-255.22,-24.4}},
      color={175,0,0},
      thickness=0.5));
  connect(HKW_Wedel1.outlet, dHN_Topology_HH_SimpleGrid_3sites.fluidPortWest) annotation (Line(
      points={{-255.22,-16.9333},{-152.61,-16.9333},{-152.61,13.2351},{-54.0128,13.2351}},
      color={175,0,0},
      thickness=0.5));
  connect(P_set.y, HKW_Wedel1.P_set) annotation (Line(points={{-333,42},{-314,42},{-314,14.5333},{-318.79,14.5333}}, color={0,0,127}));
  connect(P_set.y, HKW_Wedel2.P_set) annotation (Line(points={{-333,42},{-316,42},{-316,-55.4667},{-318.79,-55.4667}}, color={0,0,127}));
  connect(Q_flow_set.y, HKW_Wedel1.Q_flow_set) annotation (Line(points={{-297,68},{-290,68},{-290,14.5333},{-280.57,14.5333}}, color={0,0,127}));
  connect(Q_flow_set.y, HKW_Wedel2.Q_flow_set) annotation (Line(points={{-297,68},{-297,4},{-280.57,4},{-280.57,-55.4667}}, color={0,0,127}));
  connect(m_flow_set.y, massFlowSource_Wedel.m_flow) annotation (Line(points={{-251,-162},{-244,-162},{-244,-138},{-242,-138}}, color={0,0,127}));
  connect(massFlowSource_HafenCity.m_flow, m_flow_set1.y) annotation (Line(points={{-107,-176},{-106,-176},{-106,-202},{-115,-202}}, color={0,0,127}));
  connect(m_flow_set2.y, massFlowSource_Tiefstack.m_flow) annotation (Line(points={{243,-110},{252,-110},{257,-110}}, color={0,0,127}));
  connect(massFlowSource_Wedel.eye, quadruple.eye) annotation (Line(points={{-228,-116},{-224,-116},{-224,-123}}, color={190,190,190}));
  connect(massFlowSource_HafenCity.eye, quadruple1.eye) annotation (Line(points={{-93,-154},{-104,-154},{-104,-158},{-184,-158}}, color={190,190,190}));
  connect(massFlowSource_Tiefstack.eye, quadruple2.eye) annotation (Line(points={{271,-88},{272,-88},{272,-87},{274,-87}}, color={190,190,190}));
  connect(HKW_Tiefstack.eye, infoBoxLargeCHP.eye) annotation (Line(points={{268.6,-47.1667},{252,-47.1667},{252,-51.7455},{232.7,-51.7455}}, color={28,108,200}));
  connect(HKW_Wedel1.eye, infoBoxLargeCHP1.eye) annotation (Line(points={{-252.1,-39.3333},{-230,-39.3333},{-230,35.5636},{-214.8,35.5636}}, color={28,108,200}));
  connect(HKW_Wedel2.eye, infoBoxLargeCHP2.eye) annotation (Line(points={{-252.1,-109.333},{-230,-109.333},{-230,-43.9273},{-213,-43.9273}}, color={28,108,200}));
  connect(HW_HafenCity.eye, infoBoxLargeCHP3.eye) annotation (Line(points={{-52.1,-126.2},{-34,-126.2},{-34,-105.273},{-28.5,-105.273}}, color={28,108,200}));
  connect(T_return.y, massFlowSource_Wedel.T) annotation (Line(points={{-227,-178},{-232,-178},{-232,-138},{-236,-138}}, color={0,0,127}));
  connect(massFlowSource_HafenCity.T, T_return1.y) annotation (Line(points={{-101,-176},{-102,-176},{-102,-220},{-103,-220}}, color={0,0,127}));
  connect(massFlowSource_Tiefstack.T, T_return2.y) annotation (Line(points={{263,-110},{264,-110},{264,-128},{263,-128}}, color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-360,-260},{360,260}})),
                                          Icon(graphics,
                                               coordinateSystem(extent={{-360,-260},{360,260}})),
    experiment(StopTime=604800),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for DHG_Topology_HH_1port_3sites_SimpleGrid</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end Test_DHG_Topology_HH_1port_3sites_SimpleGrid;
