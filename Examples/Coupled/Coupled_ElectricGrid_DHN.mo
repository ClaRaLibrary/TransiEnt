within TransiEnt.Examples.Coupled;
model Coupled_ElectricGrid_DHN "Example for sector coupling in TransiEnt library"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

  TransiEnt.Examples.Heat.DHN_SubSystem dHN_SubSystem annotation (Placement(transformation(extent={{120,0},{398,222}})));
  TransiEnt.Producer.Combined.LargeScaleCHP.ContinuousCHP CHP(
    P_el_n=3e6,
    Q_flow_n_CHP=CHP.P_el_n/0.3,
    PQCharacteristics=TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_STGeneric(k_Q_flow=1/CHP.Q_flow_n_CHP, k_P_el=CHP.P_el_n)) annotation (Placement(transformation(extent={{-202,90},{-122,170}})));
  TransiEnt.Producer.Heat.Gas2Heat.SimpleGasBoiler.SimpleBoiler gasBoiler(Q_flow_n=5e6, typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.NaturalGas) annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={42,36})));
  TransiEnt.Components.Boundaries.Heat.Heatflow_L1 heatDemand(use_Q_flow_in=true, p_drop=simCenter.p_nom[2] - simCenter.p_nom[1] - 0.07e5) annotation (Placement(transformation(extent={{358,242},{318,282}})));
  TransiEnt.Basics.Tables.GenericDataTable heatDemandTable(relativepath="heat/HeatDemand_HHWilhelmsburg_MFH3000_900s_01012012_31122012.txt", constantfactor=-1.2) annotation (Placement(transformation(extent={{184,258},{224,298}})));
  Modelica.Blocks.Sources.RealExpression electricityDemandCHP(y=-min(max(0, electricDemand.epp.P + electricGrid_SubSystem.pVPlant.epp.P + electricGrid_SubSystem.windProduction.epp.P), 1e6)) annotation (Placement(transformation(
        extent={{-50,-14},{50,14}},
        rotation=0,
        origin={-248,186})));
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
  TransiEnt.Basics.Tables.GenericDataTable electricDemandTable(relativepath="electricity/ElectricityDemand_VDI4665_ExampleHousehold_RG1_HH_2012_900s.txt", constantfactor=1500) annotation (Placement(transformation(extent={{-384,-70},{-344,-30}})));
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
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=0.1)
                                                   annotation (Placement(transformation(extent={{108,-129},{128,-109}})));
  Modelica.Blocks.Sources.RealExpression residualElectricPowerForPtG(y=max(0, -(electricDemand.epp.P + electricGrid_SubSystem.pVPlant.epp.P + electricGrid_SubSystem.windProduction.epp.P + CHP.epp.P))) annotation (Placement(transformation(
        extent={{-63.5,-11.5},{63.5,11.5}},
        rotation=0,
        origin={29.5,-118.5})));
  Modelica.Blocks.Sources.Constant T_set(k=90) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={130,-70})));
  ClaRa.Components.Utilities.Blocks.LimPID PID_hot_temperature(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_ref=100,
    Tau_i=60,
    y_ref=5e6,
    sign=1,
    y_min=0e3,
    y_max=CHP.Q_flow_n_CHP + gasBoiler.Q_flow_n,
    y_start=1e3,
    initOption=if ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.SteadyState) then 798 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialOutput) then 796 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialState) then 797 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState) then 795 else 501) annotation (Placement(transformation(
        extent={{-11,-11},{11,11}},
        rotation=180,
        origin={95,-69})));
  Modelica.Blocks.Sources.RealExpression varHeatDemandCHP(y=-min(PID_hot_temperature.y, CHP.Q_flow_n_CHP)) annotation (Placement(transformation(
        extent={{47.75,15.75},{-47.75,-15.75}},
        rotation=180,
        origin={-241.75,210.25})));
  Modelica.Blocks.Sources.RealExpression varHeatDemandGasBoiler(y=-min(PID_hot_temperature.y + varHeatDemandCHP.y, gasBoiler.Q_flow_n)) annotation (Placement(transformation(
        extent={{-35.5,-10.5},{35.5,10.5}},
        rotation=0,
        origin={-28.5,64.5})));
  TransiEnt.Examples.Electric.ElectricGrid_SubSystem electricGrid_SubSystem annotation (Placement(transformation(extent={{-266,-266},{-96,-94}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi gasGrid annotation (Placement(transformation(extent={{286,-128},{244,-88}})));
equation
  connect(P_12.epp_OUT,UCTE. epp) annotation (Line(
      points={{7.16,-180},{7.16,-180},{20,-180}},
      color={0,135,135},
      thickness=0.5));
  connect(gasBoiler.outlet, dHN_SubSystem.producerOutlet) annotation (Line(
      points={{62,36},{120,36},{120,35.0526}},
      color={175,0,0},
      thickness=0.5));
  connect(CHP.outlet, gasBoiler.inlet) annotation (Line(
      points={{-121.2,121.333},{-104,121.333},{-104,36},{6,36},{22.4,36}},
      color={175,0,0},
      thickness=0.5));
  connect(dHN_SubSystem.producerInlet, CHP.inlet) annotation (Line(
      points={{120,70.1053},{94,70.1053},{94,69},{68,69},{68,112},{-121.2,112}},
      color={175,0,0},
      thickness=0.5));
  connect(dHN_SubSystem.T1, PID_hot_temperature.u_m) annotation (Line(points={{117.776,23.3684},{94,23.3684},{94,-55.8},{94.89,-55.8}},
                                                                                                                                    color={0,0,127}));
  connect(varHeatDemandGasBoiler.y, gasBoiler.Q_flow_set) annotation (Line(points={{10.55,64.5},{10.55,64.25},{42,64.25},{42,56}},
                                                                                                                                 color={0,0,127}));
  connect(residualElectricPowerForPtG.y, firstOrder.u) annotation (Line(points={{99.35,-118.5},{88.675,-118.5},{88.675,-119},{106,-119}}, color={0,0,127}));
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
  connect(heatDemand.fluidPortOut, dHN_SubSystem.consumerOutlet) annotation (Line(
      points={{326,242},{326,231.2},{320.16,231.2},{320.16,221.416}},
      color={175,0,0},
      thickness=0.5));
  connect(heatDemand.fluidPortIn, dHN_SubSystem.consumerInlet) annotation (Line(
      points={{350,242},{350,232.2},{353.52,232.2},{353.52,222}},
      color={175,0,0},
      thickness=0.5));
  connect(CHP.Q_flow_set, varHeatDemandCHP.y) annotation (Line(points={{-147.2,160.667},{-147.2,210.6},{-189.225,210.6},{-189.225,210.25}},
                                                                                                                                      color={0,0,127}));
  connect(CHP.P_set, electricityDemandCHP.y) annotation (Line(points={{-186.4,160.667},{-186.4,186},{-178,186},{-193,186}},     color={0,0,127}));
  connect(PID_hot_temperature.u_s, T_set.y) annotation (Line(points={{108.2,-69},{117.1,-69},{117.1,-70},{119,-70}}, color={0,0,127}));
  connect(electricDemand.epp, electricGrid_SubSystem.epp_electricityDemand) annotation (Line(
      points={{-223,-69.58},{-223,-78.882},{-223.5,-78.882},{-223.5,-94}},
      color={0,135,135},
      thickness=0.5));
  connect(gasGrid.gasPort, gasBoiler.gasIn) annotation (Line(
      points={{244,-108},{190,-108},{190,-22},{42,-22},{42,16},{42.4,16}},
      color={255,255,0},
      thickness=1.5));
  connect(heatDemandTable.y1, heatDemand.Q_flow_prescribed) annotation (Line(points={{226,278},{252,278},{252,290},{350,290},{350,278}},   color={0,0,127}));
  connect(electricDemandTable.y1, electricDemand.P_el_set) annotation (Line(points={{-342,-50},{-322,-50},{-322,-49},{-246.2,-49}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(
        preserveAspectRatio=false,
        initialScale=0.1)), Diagram(graphics,
                                    coordinateSystem(
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
<p>Coupled electric and DHN system. </p>
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
end Coupled_ElectricGrid_DHN;
