within TransiEnt.Examples.Coupled;
model Coupled_ElectricGrid "Example for sector coupling in TransiEnt library"

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

  inner TransiEnt.SimCenter simCenter(useHomotopy=false) annotation (Placement(transformation(extent={{-380,260},{-340,300}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-380,220},{-340,260}})));

  TransiEnt.Producer.Combined.LargeScaleCHP.ContinuousCHP CHP(
    P_el_n=3e6,
    Q_flow_n_CHP=CHP.P_el_n/0.3,
    PQCharacteristics=TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_STGeneric(),
    p_nom=18e5,
    m_flow_nom=38,
    h_nom=110*4.2e3,
    T_feed_init=383.15) annotation (Placement(transformation(extent={{-202,90},{-122,170}})));
  TransiEnt.Producer.Heat.Gas2Heat.SimpleGasBoiler.SimpleBoiler gasBoiler(Q_flow_n=5e6, typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.NaturalGas,
    redeclare TransiEnt.Components.Boundaries.Heat.Heatflow_L2 heatFlowBoundary(
      Q_flow_n=gasBoiler.Q_flow_n,
      change_sign=true,
      m_flow_nom=38,
      p_nom=2400000,
      h_nom=4200*60,
      C=1e6,
      p_start=2400000,
      T_start=333.15))                                                                                                                                                               annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={40,24})));
  TransiEnt.Basics.Tables.GenericDataTable heatDemandTable(relativepath="heat/HeatDemand_HHWilhelmsburg_MFH3000_900s_01012012_31122012.txt", constantfactor=-1.2) annotation (Placement(transformation(extent={{-390,76},{-350,116}})));
  Modelica.Blocks.Sources.RealExpression electricityDemandCHP(y=-min(max(0, electricDemand.epp.P + electricGrid_SubSystem.pVPlant.epp.P + electricGrid_SubSystem.windProduction.epp.P), 1e6)) annotation (Placement(transformation(
        extent={{-52,-13},{52,13}},
        rotation=0,
        origin={-252,179})));

  TransiEnt.Consumer.Electrical.LinearElectricConsumer electricDemand annotation (Placement(transformation(
        extent={{-177.45,-5.26305},{-135.45,34.7368}},
        rotation=90,
        origin={-208.263,107.45})));
  TransiEnt.Producer.Electrical.Photovoltaics.PVProfiles.SolarProfileLoader solarProfile(change_of_sign=true, P_el_n=2e4) annotation (Placement(transformation(extent={{-386,-171},{-346,-130}})));
  TransiEnt.Producer.Electrical.Wind.WindProfiles.WindProfileLoader windProfile(change_of_sign=true, P_el_n=2e6) annotation (Placement(transformation(extent={{-384,-228},{-346,-188}})));
  TransiEnt.Basics.Tables.GenericDataTable electricDemandTable(relativepath="electricity/ElectricityDemand_VDI4665_ExampleHousehold_RG1_HH_2012_900s.txt", constantfactor=1500) annotation (Placement(transformation(extent={{-382,-70},{-342,-30}})));
  TransiEnt.Components.Sensors.ElectricActivePower P_12(change_of_sign=true) annotation (Placement(transformation(extent={{-20,-166},{8,-194}})));
  TransiEnt.Grid.Electrical.LumpedPowerGrid.LumpedGrid UCTE(
    delta_pr=0.2/50/(3/150 - 0.2*0.01),
    P_pr_max_star=0.02,
    k_pr=0.5,
    T_r=150,
    lambda_sec=simCenter.P_n_ref_2/(simCenter.P_n_ref_1 + simCenter.P_n_ref_2)*3e9/0.2,
    P_pr_grad_max_star=0.02/30,
    beta=0.2,
    redeclare TransiEnt.Grid.Electrical.Noise.TypicalLumpedGridError genericGridError,
    isSecondaryControlActive=false) annotation (Placement(transformation(
        extent={{40,-40},{-40,40}},
        rotation=0,
        origin={60,-180})));
  TransiEnt.Examples.Electric.ElectricGrid_SubSystem electricGrid_SubSystem annotation (Placement(transformation(extent={{-266,-266},{-96,-94}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi gasGrid annotation (Placement(transformation(extent={{286,-128},{244,-88}})));
  Modelica.Blocks.Sources.RealExpression heatLoss(y=-0.5e6) annotation (Placement(transformation(extent={{-396,116},{-348,146}})));
  Modelica.Blocks.Math.Add totalHeatDemand annotation (Placement(transformation(extent={{-302,98},{-262,138}})));
  Modelica.Blocks.Sources.RealExpression varHeatDemandCHP(y=-min(totalHeatDemand.y, CHP.Q_flow_n_CHP)) annotation (Placement(transformation(
        extent={{47.75,15.75},{-47.75,-15.75}},
        rotation=180,
        origin={-249.75,204.25})));
  Modelica.Blocks.Sources.RealExpression varHeatDemandGasBoiler(y=-min(-totalHeatDemand.y + varHeatDemandCHP.y, gasBoiler.Q_flow_n)) annotation (Placement(transformation(
        extent={{-35.5,-10.5},{35.5,10.5}},
        rotation=0,
        origin={-12.5,54.5})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=0.1) annotation (Placement(transformation(extent={{108,-129},{128,-109}})));
  Modelica.Blocks.Sources.RealExpression residualElectricPowerForPtG(y=max(0, -(electricDemand.epp.P + electricGrid_SubSystem.pVPlant.epp.P + electricGrid_SubSystem.windProduction.epp.P + CHP.epp.P))) annotation (Placement(transformation(
        extent={{-63.5,-11.5},{63.5,11.5}},
        rotation=0,
        origin={29.5,-118.5})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_Txim_flow DHN_source(
    variable_m_flow=true,
    variable_T=true,
    changeSign=true) annotation (Placement(transformation(extent={{204,106},{164,146}})));
  Modelica.Blocks.Sources.RealExpression m_flow_DHN(y=-38) annotation (Placement(transformation(extent={{302,134},{236,162}})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_pTxi dHN_sink(boundaryConditions(p_const=24e5, T_const=100 + 273.15)) annotation (Placement(transformation(extent={{206,44},{166,84}})));
  Modelica.Blocks.Sources.RealExpression T_VL(y=273.15 + 60) annotation (Placement(transformation(extent={{300,106},{236,132}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L1_1(redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.Quadratic_EN60534_incompressible (Kvs_in=38/1000*3600, m_flow_nom=38))
                                                                                                                                                                                                        annotation (Placement(transformation(extent={{112,58},{132,70}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T T_vl_is(unitOption=2) annotation (Placement(transformation(extent={{138,64},{158,84}})));
equation
  // _____________________________________________
  //
  //           Connect Statements
  // _____________________________________________

  connect(P_12.epp_OUT, UCTE.epp) annotation (Line(
      points={{7.16,-180},{7.16,-180},{20,-180}},
      color={0,135,135},
      thickness=0.5));
  connect(CHP.outlet, gasBoiler.inlet) annotation (Line(
      points={{-121.2,121.333},{-96,121.333},{-96,24},{8,24},{20.4,24}},
      color={175,0,0},
      thickness=0.5));
  connect(electricGrid_SubSystem.epp_UCTE, P_12.epp_IN) annotation (Line(
      points={{-96,-180},{-96,-180},{-18.88,-180}},
      color={0,135,135},
      thickness=0.5));
  connect(solarProfile.y1, electricGrid_SubSystem.solarRadiation) annotation (Line(points={{-344,-150.5},{-322,-150.5},{-322,-150.617},{-265.292,-150.617}}, color={0,0,127}));
  connect(windProfile.y1, electricGrid_SubSystem.windPower) annotation (Line(points={{-344.1,-208},{-330,-208},{-330,-207.95},{-265.292,-207.95}}, color={0,0,127}));
  connect(CHP.epp, electricGrid_SubSystem.epp_scheduledProducers) annotation (Line(
      points={{-124,142},{-124,-94},{-124.333,-94}},
      color={0,135,135},
      thickness=0.5));
  connect(electricDemand.epp, electricGrid_SubSystem.epp_electricityDemand) annotation (Line(
      points={{-223,-69.58},{-223,-78.882},{-223.5,-78.882},{-223.5,-94}},
      color={0,135,135},
      thickness=0.5));
  connect(gasGrid.gasPort, gasBoiler.gasIn) annotation (Line(
      points={{244,-108},{190,-108},{190,-22},{42,-22},{42,4},{40.4,4}},
      color={255,255,0},
      thickness=1.5));
  connect(varHeatDemandCHP.y, CHP.Q_flow_set) annotation (Line(points={{-197.225,204.25},{-147.2,204.25},{-147.2,160.667}}, color={0,0,127}));
  connect(varHeatDemandGasBoiler.y, gasBoiler.Q_flow_set) annotation (Line(points={{26.55,54.5},{40,54.5},{40,44}}, color={0,0,127}));
  connect(heatLoss.y, totalHeatDemand.u1) annotation (Line(points={{-345.6,131},{-339.8,131},{-339.8,130},{-306,130}}, color={0,0,127}));
  connect(CHP.P_set, electricityDemandCHP.y) annotation (Line(points={{-186.4,160.667},{-186.4,178.6},{-194.8,178.6},{-194.8,179}}, color={0,0,127}));
  connect(residualElectricPowerForPtG.y, firstOrder.u) annotation (Line(points={{99.35,-118.5},{88.675,-118.5},{88.675,-119},{106,-119}}, color={0,0,127}));
  connect(electricDemandTable.y1, electricDemand.P_el_set) annotation (Line(points={{-340,-50},{-310,-50},{-310,-49},{-246.2,-49}}, color={0,0,127}));
  connect(heatDemandTable.y1, totalHeatDemand.u2) annotation (Line(points={{-348,96},{-334,96},{-334,106},{-306,106}}, color={0,0,127}));
  connect(m_flow_DHN.y, DHN_source.m_flow) annotation (Line(points={{232.7,148},{217.05,148},{217.05,138},{208,138}}, color={0,0,127}));
  connect(T_VL.y, DHN_source.T) annotation (Line(points={{232.8,119},{218.05,119},{218.05,126},{208,126}}, color={0,0,127}));
  connect(gasBoiler.outlet, valveVLE_L1_1.inlet) annotation (Line(
      points={{60,24},{86,24},{86,64},{112,64}},
      color={175,0,0},
      thickness=0.5));
  connect(valveVLE_L1_1.outlet, T_vl_is.port) annotation (Line(
      points={{132,64},{140,64},{148,64}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(DHN_source.fluidPortOut, CHP.inlet) annotation (Line(
      points={{164,126},{122,126},{-30,126},{-30,112},{-121.2,112}},
      color={175,0,0},
      thickness=0.5));
  connect(dHN_sink.fluidPortIn, T_vl_is.port) annotation (Line(
      points={{166,64},{158,64},{158,64},{148,64}},
      color={175,0,0},
      thickness=0.5));
  annotation (
    Icon(graphics, coordinateSystem(preserveAspectRatio=false, initialScale=0.1)),
    Diagram(          coordinateSystem(
        preserveAspectRatio=false,
        extent={{-400,-300},{400,300}},
        initialScale=0.1)),
    experiment(
      StopTime=259200,
      Interval=900,
      __Dymola_Algorithm="Sdirk34hw"),
    __Dymola_experimentSetupOutput(inputs=false, events=false),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Coupled electric grid system. </p>
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
end Coupled_ElectricGrid;
