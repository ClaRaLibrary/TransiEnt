within TransiEnt.Examples.Coupled;
model Coupled_ElectricGrid_GasGrid "Example for sector coupling in TransiEnt library"
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
  extends TransiEnt.Basics.Icons.Example;

  TransiEnt.Producer.Combined.LargeScaleCHP.ContinuousCHP CHP(
    P_el_n=3e6,
    Q_flow_n_CHP=CHP.P_el_n/0.3,
    PQCharacteristics=TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_STGeneric(k_Q_flow=1/CHP.Q_flow_n_CHP, k_P_el=CHP.P_el_n)) annotation (Placement(transformation(extent={{-202,90},{-122,170}})));
  TransiEnt.Producer.Heat.SimpleGasboilerGasport gasBoiler(Q_flow_n=5e6, typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.NaturalGas) annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={38,34})));
  TransiEnt.Basics.Tables.GenericDataTable heatDemandTable(relativepath="heat/HeatDemand_HHWilhelmsburg_MFH3000_900s_01012012_31122012.txt", constantfactor=-1.2) annotation (Placement(transformation(extent={{-384,-6},{-344,34}})));
  Modelica.Blocks.Sources.RealExpression electricityDemandCHP(y=-min(max(0, electricDemand.epp.P + electricGrid_SubSystem.pVPlant.epp.P + electricGrid_SubSystem.windProduction.epp.P), 1e6)) annotation (Placement(transformation(
        extent={{-52,-13},{52,13}},
        rotation=0,
        origin={-244,187})));
  inner TransiEnt.SimCenter simCenter(useHomotopy=false)
                                      annotation (Placement(transformation(extent={{-380,260},{-340,300}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-380,220},{-340,260}})));
  TransiEnt.Consumer.Electrical.LinearElectricConsumer electricDemand annotation (Placement(transformation(
        extent={{-177.45,-5.26305},{-135.45,34.7368}},
        rotation=90,
        origin={-208.263,107.45})));
  TransiEnt.Producer.Electrical.Photovoltaics.PVProfiles.SolarProfileLoader solarProfile(change_of_sign=true, P_el_n=2e4) annotation (Placement(transformation(extent={{-386,-171},{-346,-130}})));
  TransiEnt.Producer.Electrical.Wind.WindProfiles.WindProfileLoader windProfile(change_of_sign=true, P_el_n=2e6) annotation (Placement(transformation(extent={{-384,-228},{-346,-188}})));
  TransiEnt.Basics.Tables.GenericDataTable electricDemandTable(relativepath="electricity/ElectricityDemand_VDI4665_ExampleHousehold_RG1_HH_2012_900s.txt") annotation (Placement(transformation(extent={{-382,-70},{-342,-30}})));
  Modelica.Blocks.Math.Gain gain(k=1500) annotation (Placement(transformation(extent={{-324,-60},{-304,-40}})));
  TransiEnt.Components.Sensors.ElectricActivePower P_12(change_of_sign=true) annotation (Placement(transformation(extent={{-20,-166},{8,-194}})));
  TransiEnt.Grid.Electrical.LumpedPowerGrid.LumpedGrid UCTE(
    delta_pr=0.2/50/(3/150 - 0.2*0.01),
    P_pr_max_star=0.02,
    k_pr=0.5,
    T_r=150,
    lambda_sec=simCenter.P_n_ref_2/(simCenter.P_n_ref_1 + simCenter.P_n_ref_2)*3e9/0.2,
    P_pr_grad_max_star=0.02/30,
    beta=0.2,
    redeclare TransiEnt.Grid.Electrical.Noise.TypicalLumpedGridError genericGridError) annotation (Placement(transformation(
        extent={{40,-40},{-40,40}},
        rotation=0,
        origin={60,-180})));
  TransiEnt.Examples.Electric.ElectricGrid_SubSystem electricGrid_SubSystem annotation (Placement(transformation(extent={{-266,-266},{-96,-94}})));
  Modelica.Blocks.Math.Add totalHeatDemand annotation (Placement(transformation(extent={{-306,20},{-266,60}})));
  Modelica.Blocks.Sources.RealExpression varHeatDemandCHP(y=-min(-totalHeatDemand.y, CHP.Q_flow_n_CHP)) annotation (Placement(transformation(
        extent={{47.75,15.75},{-47.75,-15.75}},
        rotation=180,
        origin={-247.75,228.25})));
  Modelica.Blocks.Sources.RealExpression varHeatDemandGasBoiler(y=-min(-totalHeatDemand.y + varHeatDemandCHP.y, gasBoiler.Q_flow_n)) annotation (Placement(transformation(
        extent={{-35.5,-10.5},{35.5,10.5}},
        rotation=0,
        origin={-30.5,58.5})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=0.1)
                                                   annotation (Placement(transformation(extent={{120,-110},{138,-91}})));
  Modelica.Blocks.Sources.RealExpression residualElectricPowerForPtG(y=max(0, -(electricDemand.epp.P + electricGrid_SubSystem.pVPlant.epp.P + electricGrid_SubSystem.windProduction.epp.P + CHP.epp.P))) annotation (Placement(transformation(
        extent={{-63.5,-11.5},{63.5,11.5}},
        rotation=0,
        origin={39.5,-100.5})));
  TransiEnt.Examples.Gas.GasGrid_SubSystem gasGrid_subSystem(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    phi_H2max=0.1,
    P_el_n=3e6,
    m_flow_start=0.001) annotation (Placement(transformation(
        extent={{109.25,107.75},{-109.25,-107.75}},
        rotation=180,
        origin={266.75,-175.75})));
  Modelica.Blocks.Sources.RealExpression heatLoss(y=-0.5e6) annotation (Placement(transformation(extent={{-384,40},{-336,70}})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_Txim_flow DHN_source(
    variable_m_flow=true,
    variable_T=true,
    changeSign=true) annotation (Placement(transformation(extent={{244,136},{204,176}})));
  Modelica.Blocks.Sources.RealExpression m_flow_DHN(y=-38)
                                                          annotation (Placement(transformation(extent={{342,164},{276,192}})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_pTxi dHN_sink(boundaryConditions(p_const=24e5, T_const=100 + 273.15)) annotation (Placement(transformation(extent={{246,74},{206,114}})));
  Modelica.Blocks.Sources.RealExpression T_VL(y=273.15 + 60) annotation (Placement(transformation(extent={{340,136},{276,162}})));
  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1 valveVLE_L1_1(redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.QuadraticKV (Kvs=38/1000*3600))
                                                                          annotation (Placement(transformation(extent={{152,88},{172,100}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T T_vl_is(unitOption=2) annotation (Placement(transformation(extent={{178,94},{198,114}})));
equation
  connect(electricDemandTable.y1, gain.u) annotation (Line(points={{-340,-50},{-340,-50},{-326,-50}},
                                                                                                   color={0,0,127}));
  connect(P_12.epp_OUT,UCTE. epp) annotation (Line(
      points={{7.16,-180},{7.16,-180},{20,-180}},
      color={0,135,135},
      thickness=0.5));
  connect(CHP.outlet, gasBoiler.inlet) annotation (Line(
      points={{-121.2,121.333},{-92,121.333},{-92,34},{18.4,34}},
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
  connect(gain.y, electricDemand.P_el_set) annotation (Line(points={{-303,-50},{-246.2,-50},{-246.2,-49}}, color={0,0,127}));
  connect(varHeatDemandCHP.y, CHP.Q_flow_set) annotation (Line(points={{-195.225,228.25},{-147.2,228.25},{-147.2,160.667}},
                                                                                                                     color={0,0,127}));
  connect(varHeatDemandGasBoiler.y, gasBoiler.Q_flow_set) annotation (Line(points={{8.55,58.5},{38,58.5},{38,54}},
                                                                                                                 color={0,0,127}));
  connect(CHP.P_set, electricityDemandCHP.y) annotation (Line(points={{-186.4,160.667},{-186.4,184.6},{-186.8,184.6},{-186.8,187}},
                                                                                                                              color={0,0,127}));
  connect(residualElectricPowerForPtG.y,firstOrder. u) annotation (Line(points={{109.35,-100.5},{98.675,-100.5},{118.2,-100.5}},          color={0,0,127}));
  connect(firstOrder.y, gasGrid_subSystem.P_el_set) annotation (Line(points={{138.9,-100.5},{140,-100.5},{140,-100.325},{159.685,-100.325}},
                                                                                                                                   color={0,0,127}));
  connect(gasGrid_subSystem.epp, P_12.epp_IN) annotation (Line(
      points={{157.5,-154.2},{138,-154.2},{138,-232},{138,-270},{-32,-270},{-32,-180},{-18.88,-180}},
      color={0,135,135},
      thickness=0.5));
  connect(gasBoiler.gasIn, gasGrid_subSystem.gasIn) annotation (Line(
      points={{38.4,14},{40,14},{40,-56},{40,-54},{392,-54},{392,-204},{376,-204},{376,-202.688}},
      color={255,255,0},
      thickness=1.5));
  connect(heatDemandTable.y1, totalHeatDemand.u2) annotation (Line(points={{-342,14},{-338,14},{-338,18},{-334,18},{-334,28},{-310,28}}, color={0,0,127}));
  connect(heatLoss.y, totalHeatDemand.u1) annotation (Line(points={{-333.6,55},{-325.8,55},{-325.8,52},{-310,52}}, color={0,0,127}));
  connect(m_flow_DHN.y,DHN_source. m_flow) annotation (Line(points={{272.7,178},{257.05,178},{257.05,168},{248,168}}, color={0,0,127}));
  connect(T_VL.y,DHN_source. T) annotation (Line(points={{272.8,149},{258.05,149},{258.05,156},{248,156}},
                                                                                                       color={0,0,127}));
  connect(valveVLE_L1_1.outlet,T_vl_is. port) annotation (Line(
      points={{172,94},{180,94},{188,94}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(DHN_source.fluidPortOut, CHP.inlet) annotation (Line(
      points={{204.4,155.6},{162,155.6},{10,155.6},{10,112},{-121.2,112}},
      color={175,0,0},
      thickness=0.5));
  connect(dHN_sink.fluidPortIn, T_vl_is.port) annotation (Line(
      points={{206.4,93.6},{198,93.6},{198,94},{188,94}},
      color={175,0,0},
      thickness=0.5));
  connect(gasBoiler.outlet, valveVLE_L1_1.inlet) annotation (Line(
      points={{58,34},{70,34},{70,32},{82,32},{82,96},{152,96},{152,94}},
      color={175,0,0},
      thickness=0.5));
  annotation (Icon(coordinateSystem(
        preserveAspectRatio=false,
        initialScale=0.1)), Diagram(coordinateSystem(
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
      OutputCPUtime=true,
      OutputFlatModelica=false),
Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Coupled electric and gas grid system. </p>
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
end Coupled_ElectricGrid_GasGrid;
