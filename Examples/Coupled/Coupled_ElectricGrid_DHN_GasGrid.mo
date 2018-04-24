within TransiEnt.Examples.Coupled;
model Coupled_ElectricGrid_DHN_GasGrid "Example for sector coupling in TransiEnt library"
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

  TransiEnt.Examples.Heat.DHN_SubSystem dHN_SubSystem annotation (Placement(transformation(extent={{120,0},{400,220}})));
  TransiEnt.Producer.Combined.LargeScaleCHP.ContinuousCHP CHP(
    P_el_n=3e6,
    PQCharacteristics=TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_STGeneric(k_P_el=CHP.P_el_n),
    Q_flow_n_CHP=CHP.P_el_n/0.3) annotation (Placement(transformation(extent={{-202,90},{-122,170}})));
  TransiEnt.Producer.Heat.Gas2Heat.SimpleGasboilerGasport gasBoiler(Q_flow_n=5e6, typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.NaturalGas) annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={40,34})));
  TransiEnt.Components.Boundaries.Heat.Heatflow_L1 heatDemand(use_Q_flow_in=true, p_drop=simCenter.p_n[2] - simCenter.p_n[1] - 0.07e5) annotation (Placement(transformation(extent={{358,242},{318,282}})));
  TransiEnt.Basics.Tables.GenericDataTable heatDemandTable(relativepath="heat/HeatDemand_HHWilhelmsburg_MFH3000_900s_01012012_31122012.txt") annotation (Placement(transformation(extent={{-384,-6},{-344,34}})));
  Modelica.Blocks.Sources.RealExpression electricityDemandCHP(y=-min(max(0, electricDemand.epp.P + electricGrid_SubSystem.pVPlant.epp.P + electricGrid_SubSystem.windProduction.epp.P), 1e6)) annotation (Placement(transformation(
        extent={{-50,-14},{50,14}},
        rotation=0,
        origin={-250,184})));
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
  TransiEnt.Examples.Gas.GasGrid_SubSystem gasGrid_subSystem(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    phi_H2max=0.1,
    P_el_n=3e6,
    m_flow_start=0.001) annotation (Placement(transformation(
        extent={{-109.25,-110.25},{109.25,110.25}},
        rotation=0,
        origin={271.25,-183.75})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=0.1)
                                                   annotation (Placement(transformation(extent={{114,-117},{134,-97}})));
  Modelica.Blocks.Sources.RealExpression residualElectricPowerForPtG(y=max(0, -(electricDemand.epp.P + electricGrid_SubSystem.pVPlant.epp.P + electricGrid_SubSystem.windProduction.epp.P + CHP.epp.P))) annotation (Placement(transformation(
        extent={{-63.5,-11.5},{63.5,11.5}},
        rotation=0,
        origin={35.5,-106.5})));
  Modelica.Blocks.Math.Gain gain1(k=-1.2)
                                       annotation (Placement(transformation(extent={{-332,4},{-312,24}})));
  Modelica.Blocks.Sources.Constant T_set(k=90) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={130,-56})));
  ClaRa.Components.Utilities.Blocks.LimPID PID_hot_temperature(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    u_ref=100,
    Tau_i=60,
    y_ref=5e6,
    sign=1,
    y_start=1e3,
    y_min=0e3,
    y_max=CHP.Q_flow_n_CHP + gasBoiler.Q_flow_n,
    initOption=if ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.SteadyState) then 798 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialOutput) then 796 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.InitialState) then 797 elseif ((Modelica.Blocks.Types.InitPID.InitialOutput) == Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState) then 795 else 501) annotation (Placement(transformation(
        extent={{-11,-11},{11,11}},
        rotation=180,
        origin={89,-55})));
  Modelica.Blocks.Sources.RealExpression varHeatDemandCHP(y=-min(PID_hot_temperature.y, CHP.Q_flow_n_CHP)) annotation (Placement(transformation(
        extent={{47.75,15.75},{-47.75,-15.75}},
        rotation=180,
        origin={-251.75,216.25})));
  Modelica.Blocks.Sources.RealExpression varHeatDemandGasBoiler(y=-min(PID_hot_temperature.y + varHeatDemandCHP.y, gasBoiler.Q_flow_n)) annotation (Placement(transformation(
        extent={{-35.5,-10.5},{35.5,10.5}},
        rotation=0,
        origin={-32.5,62.5})));
  TransiEnt.Examples.Electric.ElectricGrid_SubSystem electricGrid_SubSystem annotation (Placement(transformation(extent={{-266,-266},{-96,-94}})));
equation
  connect(electricDemandTable.y1, gain.u) annotation (Line(points={{-340,-50},{-340,-50},{-326,-50}},
                                                                                                   color={0,0,127}));
  connect(P_12.epp_OUT,UCTE. epp) annotation (Line(
      points={{7.16,-180},{7.16,-180},{20,-180}},
      color={0,135,135},
      thickness=0.5));
  connect(heatDemandTable.y1, gain1.u) annotation (Line(points={{-342,14},{-342,14},{-334,14}},      color={0,0,127}));
  connect(gasBoiler.outlet, dHN_SubSystem.producerOutlet) annotation (Line(
      points={{60,34},{120,34},{120,34.7368}},
      color={175,0,0},
      thickness=0.5));
  connect(CHP.outlet, gasBoiler.inlet) annotation (Line(
      points={{-121.2,121.333},{-104,121.333},{-104,34},{-2,34},{20.4,34}},
      color={175,0,0},
      thickness=0.5));
  connect(dHN_SubSystem.producerInlet, CHP.inlet) annotation (Line(
      points={{120,69.4737},{94,69.4737},{94,69},{68,69},{68,112},{-121.2,112}},
      color={175,0,0},
      thickness=0.5));
  connect(dHN_SubSystem.T1, PID_hot_temperature.u_m) annotation (Line(points={{117.76,23.1579},{90,23.1579},{90,-41.8},{88.89,-41.8}},
                                                                                                                                    color={0,0,127}));
  connect(varHeatDemandGasBoiler.y, gasBoiler.Q_flow_set) annotation (Line(points={{6.55,62.5},{6.55,64.25},{40,64.25},{40,54}}, color={0,0,127}));
  connect(heatDemand.Q_flow_prescribed, gain1.y) annotation (Line(points={{352,280.4},{352,292},{300,292},{300,252},{-310,252},{-310,14},{-311,14}}, color={0,0,127}));
  connect(gasBoiler.gasIn, gasGrid_subSystem.gasIn) annotation (Line(
      points={{40.4,14},{40,14},{40,-20},{40,-16},{394,-16},{394,-212},{380,-212},{380.5,-212},{380.5,-211.313}},
      color={255,255,0},
      thickness=1.5));
  connect(residualElectricPowerForPtG.y, firstOrder.u) annotation (Line(points={{105.35,-106.5},{94.675,-106.5},{94.675,-107},{112,-107}},color={0,0,127}));
  connect(firstOrder.y, gasGrid_subSystem.P_el_set) annotation (Line(points={{135,-107},{140,-107},{140,-106.575},{164.185,-106.575}},
                                                                                                                                   color={0,0,127}));
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
      points={{320.8,242.4},{320.8,231.2},{321.6,231.2},{321.6,219.421}},
      color={175,0,0},
      thickness=0.5));
  connect(heatDemand.fluidPortIn, dHN_SubSystem.consumerInlet) annotation (Line(
      points={{352.8,242.4},{352.8,232.2},{355.2,232.2},{355.2,220}},
      color={175,0,0},
      thickness=0.5));
  connect(CHP.Q_flow_set, varHeatDemandCHP.y) annotation (Line(points={{-147.2,160.667},{-147.2,216.6},{-199.225,216.6},{-199.225,216.25}},
                                                                                                                                      color={0,0,127}));
  connect(CHP.P_set, electricityDemandCHP.y) annotation (Line(points={{-186.4,160.667},{-186.4,184},{-182,184},{-195,184}},     color={0,0,127}));
  connect(PID_hot_temperature.u_s, T_set.y) annotation (Line(points={{102.2,-55},{117.1,-55},{117.1,-56},{119,-56}}, color={0,0,127}));
  connect(gasGrid_subSystem.epp, P_12.epp_IN) annotation (Line(
      points={{162,-161.7},{140,-161.7},{140,-262},{-18.88,-262},{-18.88,-180}},
      color={0,135,135},
      thickness=0.5));
  connect(electricDemand.epp, electricGrid_SubSystem.epp_electricityDemand) annotation (Line(
      points={{-223,-69.58},{-223,-78.882},{-223.5,-78.882},{-223.5,-94}},
      color={0,135,135},
      thickness=0.5));
  connect(gain.y, electricDemand.P_el_set) annotation (Line(points={{-303,-50},{-246.2,-50},{-246.2,-49}}, color={0,0,127}));
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
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false),
Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Coupled electric, DHN and gas grid system. </p>
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
end Coupled_ElectricGrid_DHN_GasGrid;
