within TransiEnt.Grid.Heat.HeatGridTopology.Check;
model Test_DHG_Topology_HH_2ports_2sites_ClosedGrid
  import TransiEnt;



//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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
    h_nom=120*4.2) annotation (Placement(transformation(extent={{-352,-190},{-284,-108}})));
    //typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Cogeneration,
  TransiEnt.Producer.Combined.LargeScaleCHP.ContinuousCHP HKW_Tiefstack(
    P_el_n=200e6,
    Q_flow_init=300e6,
    typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.BlackCoal,
    PQCharacteristics=TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_WT(),
    p_nom=20e5,
    m_flow_nom=1500,
    h_nom=120*4.2) annotation (Placement(transformation(extent={{340,-50},{272,18}})));
    //typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Cogeneration,
  TransiEnt.Grid.Heat.HeatGridControl.Controllers.SimpleDHNDispatcher simpleHeatDispatcher annotation (Placement(transformation(rotation=0, extent={{-340,168},{-278,230}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency constantFrequency_L1_3(useInputConnector=false) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-10,136})));
  TransiEnt.Grid.Heat.HeatGridTopology.GridConfigurations.DHG_Topology_HH_2ports_2sites_ClosedGrid dHN_Topology_HH_SimpleGrid_2ports annotation (Placement(transformation(extent={{-102,-74},{150,100}})));
  TransiEnt.Producer.Combined.LargeScaleCHP.ContinuousCHP HKW_Wedel1(
    typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.BlackCoal,
    PQCharacteristics=TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_WW1(),
    P_el_n=150e6,
    p_nom=20e5,
    m_flow_nom=1100,
    h_nom=120*4.2) annotation (Placement(transformation(extent={{-338,-60},{-270,22}})));
    //typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Cogeneration,
  Modelica.Blocks.Sources.RealExpression P_set(y=simpleHeatDispatcher.P_el_WW/2) annotation (Placement(transformation(extent={{-354,32},{-334,52}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_set(y=simpleHeatDispatcher.Q_flow_WW/2) annotation (Placement(transformation(extent={{-318,58},{-298,78}})));
  TransiEnt.Components.Visualization.InfoBoxLargeCHP infoBoxLargeCHP annotation (Placement(transformation(extent={{236,-82},{170,-30}})));
  TransiEnt.Components.Visualization.InfoBoxLargeCHP infoBoxLargeCHP1 annotation (Placement(transformation(extent={{-218,-4},{-154,64}})));
  TransiEnt.Components.Visualization.InfoBoxLargeCHP infoBoxLargeCHP2 annotation (Placement(transformation(extent={{-216,-80},{-156,-18}})));
  TransiEnt.Components.Visualization.DynDisplay Time(
    x1=time/3600,
    unit="h",
    varname="Time") annotation (Placement(transformation(extent={{260,-256},{354,-226}})));
  TransiEnt.Components.Visualization.DynDisplay HeatDemand_Display(
    varname="Heat Demand",
    unit="MW",
    x1=-1*dHN_Topology_HH_SimpleGrid_2ports.HeatConsumer.heat.Q_flow/1e6) annotation (Placement(transformation(extent={{262,-222},{354,-188}})));
  TransiEnt.Components.Visualization.DynDisplay T_amb_Display(
    varname="T_amb",
    x1=simpleHeatDispatcher.temperatureHH_900s_01012012_0000_31122012_2345.value,
    unit="C") annotation (Placement(transformation(extent={{260,-186},{352,-154}})));

  // _____________________________________________
  //
  //           Functions
  // _____________________________________________
function plotResult
constant String resultFileName = "Test_DHG_Topology_HH_2ports_2sites_ClosedGrid.mat";
algorithm
    TransiEnt.Basics.Functions.plotResult("resultFileName");
createPlot(id=2, position={744, 0, 763, 423}, y={"simpleHeatDispatcher.P_el_WW", "simpleHeatDispatcher.P_el_WT"}, range={0.0, 32000000.0, -300000000.0, 0.0}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=2, position={744, 0, 763, 138}, y={"simpleHeatDispatcher.m_flow_WW", "simpleHeatDispatcher.m_flow_WT"}, range={0.0, 32000000.0, -2000.0, 0.0}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}});
createPlot(id=2, position={744, 0, 763, 137}, y={"simpleHeatDispatcher.Q_flow_WW", "simpleHeatDispatcher.Q_flow_WT"}, range={0.0, 32000000.0, -800000000.0, 0.0}, autoscale=false, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, range2={0.20000000000000004, 0.6000000000000001});
createPlot(id=5, position={-13, 0, 741, 890}, y={"simpleHeatDispatcher.heatingLoadCharline.Q_flow", "infoBoxLargeCHP.eye.Q_flow",
 "infoBoxLargeCHP1.eye.Q_flow", "infoBoxLargeCHP2.eye.Q_flow",
"dHN_Topology_HH_SimpleGrid_3sites.HeatConsumer.summary.outline.Q_flow_tot"}, range={0.0, 32000000.0, -900000000.0, 2100000000.0}, autoscale=false, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}, {0,0,0}}, range2={0.0984, 0.1032});
createPlot(id=6, position={743, 457, 758, 428}, y={"dHN_Topology_HH_SimpleGrid_3sites.supplyandReturnTemperature1.T_set[1]",
"dHN_Topology_HH_SimpleGrid_3sites.supplyandReturnTemperature1.T_set[2]",
"dHN_Topology_HH_SimpleGrid_3sites.HeatConsumer.fluidIn.T", "dHN_Topology_HH_SimpleGrid_3sites.HeatConsumer.mass",
 "dHN_Topology_HH_SimpleGrid_3sites.HeatConsumer.fluidOut.T"}, range={0.0, 32000000.0, 20.0, 140.0}, autoscale=false, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}, {0,0,0}});

end plotResult;

equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(HKW_Tiefstack.epp,constantFrequency_L1_3. epp) annotation (Line(
      points={{273.7,-5.8},{272,-5.8},{272,126},{-10,126}},
      color={0,135,135},
      thickness=0.5,
      smooth=Smooth.None));
  connect(HKW_Wedel2.epp,constantFrequency_L1_3. epp) annotation (Line(
      points={{-285.7,-136.7},{-136,-136.7},{-136,126},{-10,126}},
      color={0,135,135},
      thickness=0.5,
      smooth=Smooth.None));
  connect(dHN_Topology_HH_SimpleGrid_2ports.fluidPortEast,HKW_Tiefstack. outlet) annotation (Line(
      points={{38.2085,-3.22432},{134.75,-3.22432},{134.75,-23.3667},{271.32,-23.3667}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(simpleHeatDispatcher.Q_flow_WT,HKW_Tiefstack. Q_flow_set) annotation (Line(points={{-274.9,215.12},{293.42,215.12},{293.42,10.0667}},
                                                                                                                                              color={0,0,127}));
  connect(HKW_Tiefstack.P_set,simpleHeatDispatcher. P_el_WT) annotation (Line(points={{326.74,10.0667},{326.74,221.32},{-274.9,221.32}},
                                                                                                                                       color={0,0,127}));
  connect(HKW_Wedel1.epp,constantFrequency_L1_3. epp) annotation (Line(
      points={{-271.7,-6.7},{-232,-6.7},{-232,126},{-10,126}},
      color={0,135,135},
      thickness=0.5));
  connect(HKW_Wedel2.outlet,HKW_Wedel1. inlet) annotation (Line(
      points={{-283.32,-157.883},{-248,-157.883},{-248,-37.45},{-269.32,-37.45}},
      color={175,0,0},
      thickness=0.5));
  connect(HKW_Wedel1.outlet,dHN_Topology_HH_SimpleGrid_2ports. fluidPortWest) annotation (Line(
      points={{-269.32,-27.8833},{-220,-27.8833},{-220,-8},{-120,-8},{-120,13.7054},{-53.4766,13.7054}},
      color={175,0,0},
      thickness=0.5));
  connect(P_set.y,HKW_Wedel1. P_set) annotation (Line(points={{-333,42},{-324.74,42},{-324.74,12.4333}},             color={0,0,127}));
  connect(P_set.y,HKW_Wedel2. P_set) annotation (Line(points={{-333,42},{-328,42},{-328,64},{-364,64},{-364,-96},{-336,-96},{-336,-108},{-338.74,-108},{-338.74,-117.567}},
                                                                                                                       color={0,0,127}));
  connect(Q_flow_set.y,HKW_Wedel1. Q_flow_set) annotation (Line(points={{-297,68},{-284,68},{-284,16},{-291.42,16},{-291.42,12.4333}},
                                                                                                                               color={0,0,127}));
  connect(Q_flow_set.y,HKW_Wedel2. Q_flow_set) annotation (Line(points={{-297,68},{-284,68},{-284,24},{-348,24},{-348,-92},{-305.42,-92},{-305.42,-117.567}},
                                                                                                                            color={0,0,127}));
  connect(HKW_Tiefstack.eye,infoBoxLargeCHP. eye) annotation (Line(points={{268.6,-47.1667},{252,-47.1667},{252,-51.7455},{232.7,-51.7455}}, color={28,108,200}));
  connect(HKW_Wedel1.eye,infoBoxLargeCHP1. eye) annotation (Line(points={{-266.6,-56.5833},{-244,-56.5833},{-244,-12},{-228,-12},{-228,35.5636},{-214.8,35.5636}},
                                                                                                                                             color={28,108,200}));
  connect(HKW_Wedel2.eye,infoBoxLargeCHP2. eye) annotation (Line(points={{-280.6,-186.583},{-244,-186.583},{-244,-60},{-228,-60},{-228,-43.9273},{-213,-43.9273}},
                                                                                                                                             color={28,108,200}));
  connect(dHN_Topology_HH_SimpleGrid_2ports.fluidPortWestReturn, HKW_Wedel2.inlet) annotation (Line(
      points={{-52.9404,7.59189},{-144,7.59189},{-144,-94},{-283.32,-94},{-283.32,-167.45}},
      color={175,0,0},
      thickness=0.5));
  connect(dHN_Topology_HH_SimpleGrid_2ports.fluidPortEastReturn, HKW_Tiefstack.inlet) annotation (Line(
      points={{38.2085,-10.2784},{58,-10.2784},{124,-10.2784},{124,-31.3},{271.32,-31.3}},
      color={175,0,0},
      thickness=0.5));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-360,-260},{360,260}})),
                                          Icon(graphics,
                                               coordinateSystem(extent={{-360,-260},{360,260}})),
    experiment(StopTime=604800, __Dymola_Algorithm="Esdirk23a"),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for DHG_Topology_HH_2port_2sites_ClosedGrid</p>
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
end Test_DHG_Topology_HH_2ports_2sites_ClosedGrid;
