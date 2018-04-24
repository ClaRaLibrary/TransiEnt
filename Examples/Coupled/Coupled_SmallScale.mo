within TransiEnt.Examples.Coupled;
model Coupled_SmallScale "Coupled small-scale example"
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

  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi pipe1(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    length=500,
    N_cv=2,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.QuadraticNominalPoint_L4,
    Delta_p_nom=100000,
    h_start=ones(pipe1.N_cv)*Init.pipe1.h_in,
    p_start=linspace(
        Init.pipe1.p_in,
        Init.pipe1.p_out,
        pipe1.N_cv),
    m_flow_start=ones(pipe1.N_cv + 1)*Init.pipe1.m_flow,
    xi_start=Init.pipe1.xi_in) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=90,
        origin={6,57})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi pipe2(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L4,
    length=1000,
    N_cv=4,
    h_nom=ones(pipe2.N_cv)*(-4667),
    h_start=ones(pipe2.N_cv)*Init.pipe2.h_in,
    p_start=linspace(
        Init.pipe2.p_in,
        Init.pipe2.p_out,
        pipe2.N_cv),
    m_flow_start=ones(pipe2.N_cv + 1)*Init.pipe2.m_flow,
    xi_start=Init.pipe2.xi_in,
    m_flow_nom=1,
    Delta_p_nom=200000)
            annotation (Placement(transformation(extent={{60,94},{32,104}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi pipe4(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    length=1000,
    N_cv=4,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.QuadraticNominalPoint_L4,
    h_start=ones(pipe4.N_cv)*Init.pipe4.h_in,
    p_start=linspace(
        Init.pipe4.p_in,
        Init.pipe4.p_out,
        pipe4.N_cv),
    m_flow_start=ones(pipe4.N_cv + 1)*Init.pipe4.m_flow,
    xi_start=Init.pipe4.xi_in,
    Delta_p_nom=200000)                                                                                                   annotation (Placement(transformation(extent={{32,12},{60,22}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_varXi pipe3(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L4,
    length=1000,
    N_cv=4,
    h_start=ones(pipe3.N_cv)*Init.pipe3.h_in,
    p_start=linspace(
        Init.pipe3.p_in,
        Init.pipe3.p_out,
        pipe3.N_cv),
    m_flow_start=ones(pipe3.N_cv + 1)*Init.pipe3.m_flow,
    xi_start=Init.pipe3.xi_in,
    Delta_p_nom=200000)
            annotation (Placement(transformation(
        extent={{14,-5},{-14,5}},
        rotation=90,
        origin={86,59})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 junction(
    p_start=Init.split1.p,
    xi_start=Init.split1.xi_in,
    h_start=Init.split1.h_in)                                                annotation (Placement(transformation(extent={{-4,28},{16,8}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 junction1(
    p_start=Init.mix1.p,
    xi_start=Init.mix1.xi_out,
    h_start=Init.mix1.h_out)                                                  annotation (Placement(transformation(extent={{16,88},{-4,108}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 junction2(
    p_start=Init.split2.p,
    xi_start=Init.split2.xi_in,
    h_start=Init.split2.h_in)                                                 annotation (Placement(transformation(extent={{96,88},{76,108}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 junction3(
    p_start=Init.mix2.p,
    xi_start=Init.mix2.xi_out,
    h_start=Init.mix2.h_out)                                                  annotation (Placement(transformation(extent={{76,26},{96,6}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi source annotation (Placement(transformation(extent={{-116,8},{-96,28}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi source1 annotation (Placement(transformation(extent={{124,88},{104,108}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sink(m_flow_const=1, variable_m_flow=true) annotation (Placement(transformation(extent={{-36,88},{-16,108}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sink1(m_flow_const=2) annotation (Placement(transformation(extent={{128,6},{108,26}})));
  Modelica.Blocks.Sources.Sine m_flow_gas(
    amplitude=0.3,
    freqHz=2/86400,
    offset=1) annotation (Placement(transformation(extent={{-62,98},{-48,112}})));
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var gasModel1, tableInterpolationSmoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2,
    useHomotopy=true)                                                                                        annotation (Placement(transformation(extent={{-130,120},{-110,140}})));
  TransiEnt.Producer.Gas.Electrolyzer.Systems.FeedInStation_Storage feedInStation(
    V_geo=50,
    t_overload=86300,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics1stOrder,
    P_el_n=3000000,
    startState=1,
    redeclare model CostSpecsElectrolyzer = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Electrolyzer_2035) annotation (Placement(transformation(extent={{-44,32},{-74,60}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.RealGasJunction_L2 junction4(h_start=-3275)
                                                                              annotation (Placement(transformation(extent={{-68,28},{-48,8}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency ElectricGrid annotation (Placement(transformation(extent={{-78,-26},{-98,-6}})));
  Modelica.Blocks.Sources.RealExpression P_ptg(y=max(0, -(consumer.epp.P + windTurbine.epp.P + CHP.epp.P)))
                                                                                           annotation (Placement(transformation(extent={{-114,54},{-94,74}})));
  TransiEnt.Grid.Gas.Controller.MaxH2MassFlow_phi maxH2MassFlow annotation (Placement(transformation(extent={{-94,8},{-74,28}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensor(compositionDefinedBy=2) annotation (Placement(transformation(extent={{-36,18},{-16,38}})));
  TransiEnt.Producer.Combined.SmallScaleCHP.CHP_ice CHP(
    NCV_const=0,
    redeclare model CostRecordCHP = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.CHP_2000kW,
    redeclare model Motorblock = TransiEnt.Components.Gas.Engines.Engine_idealGas,
    redeclare TransiEnt.Producer.Combined.SmallScaleCHP.Specifications.CHP_2MW Specification,
    m_flow_nom=13,
    Delta_p_nom=200000,
    T_init=356.15,
    p_init=800000)      annotation (Placement(transformation(extent={{38,-120},{-28,-58}})));
  TransiEnt.Basics.Adapters.Gas.Real_to_Ideal real_to_Ideal(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var real, redeclare TransiEnt.Basics.Media.Gases.Gas_VDIWA_NG7_H2_var ideal) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={106,-8})));
  TransiEnt.Components.Sensors.IdealGas.GasMassflowSensor gasMassflowSensor(medium=TransiEnt.Basics.Media.Gases.Gas_ExhaustGas(), xiNumber=2) annotation (Placement(transformation(extent={{52,-52},{72,-32}})));
  TransiEnt.Components.Sensors.IdealGas.GasMassflowSensor gasMassflowSensor1(xiNumber=7) annotation (Placement(transformation(extent={{72,-76},{52,-56}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryIdealGas_pTxi boundaryIdealGas_p(gasModel=simCenter.exhaustGasModel) annotation (Placement(transformation(extent={{102,-62},{82,-42}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow boundaryVLE_Txim_flow(
    T_const(displayUnit="degC") = 333.15,
    variable_T=true,
    p_nom(displayUnit="bar") = 800000,
    m_flow_const=13) annotation (Placement(transformation(extent={{-70,-92},{-50,-72}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi boundaryVLE_phxi(p_const=6e5) annotation (Placement(transformation(extent={{-138,-70},{-118,-50}})));
  TransiEnt.Components.Boundaries.Heat.Heatflow_L2 heatFlow(
    initOption=1,
    m_flow_nom=14,
    Q_flow_n=2.2e6,
    C=2.75e7,
    T_start=342.15) annotation (Placement(transformation(extent={{-64,-60},{-84,-40}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureSensor annotation (Placement(transformation(extent={{-124,-71},{-104,-91}})));
  Modelica.Blocks.Sources.Sine Q_flow_consumer(
    freqHz=2/86400,
    offset=1500e3,
    amplitude=700e3) annotation (Placement(transformation(extent={{-46,-44},{-60,-30}})));
  TransiEnt.Producer.Combined.SmallScaleCHP.Controller.ControllerHeatLed controllerHeatLed(Specification=TransiEnt.Producer.Combined.SmallScaleCHP.Specifications.CHP_2MW()) annotation (Placement(transformation(extent={{78,-108},{58,-88}})));
  TransiEnt.Consumer.Electrical.LinearElectricConsumer consumer annotation (Placement(transformation(extent={{-34,-10},{-14,10}})));
  Modelica.Blocks.Sources.Sine P_consumer(
    offset=3e6,
    amplitude=2e6,
    freqHz=6/86400) annotation (Placement(transformation(extent={{12,-6},{-2,8}})));
  TransiEnt.Producer.Electrical.Wind.PowerCurveWindPlant windTurbine(
    height_data=175,
    height_hub=125,
    PowerCurveChar=TransiEnt.Producer.Electrical.Wind.Characteristics.SenvionM104_3400kW(),
    P_el_n=3400000,
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.WindOnshore) annotation (Placement(transformation(extent={{-14,-42},{-34,-22}})));
  Modelica.Blocks.Noise.NormalNoise v_wind(
    sigma=4,
    samplePeriod=900,
    mu=10) annotation (Placement(transformation(extent={{12,-34},{-4,-18}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-130,100},{-110,120}})));
  inner Modelica.Blocks.Noise.GlobalSeed globalSeed annotation (Placement(transformation(extent={{-132,70},{-112,90}})));
  StatCycCoupledSmall Init(
    m_flow_sink1=1,
    m_flow_sink2=2,
    quadraticPressureLoss=true,
    Delta_p_nom_pipe2=200000,
    Delta_p_nom_pipe3=200000,
    Delta_p_nom_pipe4=200000) annotation (Placement(transformation(extent={{-102,120},{-82,140}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=600, y_start=heatFlow.T_start)
                                                   annotation (Placement(transformation(extent={{-94,-87},{-84,-76}})));
equation
  connect(junction1.gasPort1,pipe2. gasPortOut) annotation (Line(
      points={{16,98},{32,98},{32,99}},
      color={255,255,0},
      thickness=1.5));
  connect(junction1.gasPort2, pipe1.gasPortOut) annotation (Line(
      points={{6,88},{6,71}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe1.gasPortIn, junction.gasPort2) annotation (Line(
      points={{6,43},{6,28}},
      color={255,255,0},
      thickness=1.5));
  connect(junction.gasPort3,pipe4. gasPortIn) annotation (Line(
      points={{16,18},{32,18},{32,17}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe4.gasPortOut, junction3.gasPort1) annotation (Line(
      points={{60,17},{68,17},{68,16},{76,16}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe3.gasPortOut, junction3.gasPort2) annotation (Line(
      points={{86,45},{86,26}},
      color={255,255,0},
      thickness=1.5));
  connect(junction2.gasPort2, pipe3.gasPortIn) annotation (Line(
      points={{86,88},{86,88},{86,73}},
      color={255,255,0},
      thickness=1.5));
  connect(pipe2.gasPortIn, junction2.gasPort3) annotation (Line(
      points={{60,99},{68,99},{68,98},{76,98}},
      color={255,255,0},
      thickness=1.5));
  connect(junction2.gasPort1, source1.gasPort) annotation (Line(
      points={{96,98},{100,98},{104,98}},
      color={255,255,0},
      thickness=1.5));
  connect(sink.gasPort, junction1.gasPort3) annotation (Line(
      points={{-16,98},{-10,98},{-4,98}},
      color={255,255,0},
      thickness=1.5));
  connect(junction3.gasPort3, sink1.gasPort) annotation (Line(
      points={{96,16},{108,16}},
      color={255,255,0},
      thickness=1.5));
  connect(sink.m_flow, m_flow_gas.y) annotation (Line(points={{-38,104},{-42,104},{-42,105},{-47.3,105}},
                                                                                                      color={0,0,127}));
  connect(feedInStation.gasPortOut, junction4.gasPort2) annotation (Line(
      points={{-58.25,31.86},{-58.25,29.95},{-58,29.95},{-58,28}},
      color={255,255,0},
      thickness=1.5));
  connect(feedInStation.epp, ElectricGrid.epp) annotation (Line(
      points={{-44,46},{-40,46},{-40,-16.1},{-77.9,-16.1}},
      color={0,135,135},
      thickness=0.5));
  connect(junction4.gasPort1, maxH2MassFlow.gasPortOut) annotation (Line(
      points={{-68,18},{-74,18}},
      color={255,255,0},
      thickness=1.5));
  connect(source.gasPort, maxH2MassFlow.gasPortIn) annotation (Line(
      points={{-96,18},{-94,18}},
      color={255,255,0},
      thickness=1.5));
  connect(maxH2MassFlow.m_flow_H2_max, feedInStation.m_flow_feedIn) annotation (Line(points={{-84,27},{-84,27},{-84,54},{-84,57.2},{-74,57.2}},
                                                                                                                                              color={0,0,127}));
  connect(junction4.gasPort3, compositionSensor.gasPortIn) annotation (Line(
      points={{-48,18},{-36,18}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensor.gasPortOut, junction.gasPort1) annotation (Line(
      points={{-16,18},{-10,18},{-4,18}},
      color={255,255,0},
      thickness=1.5));
  connect(junction3.gasPort3, real_to_Ideal.gasPortIn) annotation (Line(
      points={{96,16},{96,16},{104,16},{106,16},{106,2}},
      color={255,255,0},
      thickness=1.5));
  connect(CHP.gasPortOut, gasMassflowSensor.inlet) annotation (Line(
      points={{38,-64.2},{38,-52},{52,-52}},
      color={255,213,170},
      thickness=1.25));
  connect(gasMassflowSensor.outlet, boundaryIdealGas_p.gasPort) annotation (Line(
      points={{72,-52},{82,-52}},
      color={255,213,170},
      thickness=1.25));
  connect(CHP.epp, ElectricGrid.epp) annotation (Line(
      points={{-28,-101.4},{-40,-101.4},{-40,-16.1},{-77.9,-16.1}},
      color={0,135,135},
      thickness=0.5));
  connect(boundaryVLE_Txim_flow.steam_a, CHP.waterPortIn) annotation (Line(
      points={{-50,-82},{-50,-82},{-46,-82},{-46,-67.61},{-28,-67.61}},
      color={175,0,0},
      thickness=0.5));
  connect(Q_flow_consumer.y, heatFlow.Q_flow_prescribed) annotation (Line(points={{-60.7,-37},{-67.6,-37},{-67.6,-42}}, color={0,0,127}));
  connect(CHP.controlBus, controllerHeatLed.controlBus) annotation (Line(points={{38,-82.8},{48,-82.8},{48,-94},{58,-94}},     color={255,0,0}));
  connect(consumer.epp, ElectricGrid.epp) annotation (Line(
      points={{-33.8,0},{-40,0},{-40,-16.1},{-77.9,-16.1}},
      color={0,135,135},
      thickness=0.5));
  connect(consumer.P_el_set, P_consumer.y) annotation (Line(points={{-24,11.6},{-8,11.6},{-8,1},{-2.7,1}},        color={0,0,127}));
  connect(CHP.gasPortIn, gasMassflowSensor1.outlet) annotation (Line(
      points={{38.33,-75.67},{45.165,-75.67},{45.165,-76},{52,-76}},
      color={255,213,170},
      thickness=1.25));
  connect(gasMassflowSensor1.inlet, real_to_Ideal.gasPortOut) annotation (Line(
      points={{72,-76},{92,-76},{106,-76},{106,-18}},
      color={255,213,170},
      thickness=1.25));
  connect(CHP.waterPortOut, heatFlow.fluidPortIn) annotation (Line(
      points={{-28,-59.55},{-45,-59.55},{-45,-59.8},{-66.6,-59.8}},
      color={175,0,0},
      thickness=0.5));
  connect(boundaryVLE_phxi.steam_a, heatFlow.fluidPortOut) annotation (Line(
      points={{-118,-60},{-82.6,-60},{-82.6,-59.8}},
      color={175,0,0},
      thickness=0.5));
  connect(temperatureSensor.port, heatFlow.fluidPortOut) annotation (Line(
      points={{-114,-71},{-114,-59.8},{-82.6,-59.8}},
      color={175,0,0},
      thickness=0.5));
  connect(windTurbine.epp, ElectricGrid.epp) annotation (Line(
      points={{-33.5,-26.4},{-40,-26.4},{-40,-16.1},{-77.9,-16.1}},
      color={0,135,135},
      thickness=0.5));
  connect(v_wind.y, windTurbine.v_wind) annotation (Line(points={{-4.8,-26},{-8,-26},{-8,-25.9},{-15.1,-25.9}},    color={0,0,127}));
  connect(P_ptg.y, feedInStation.P_el_set) annotation (Line(points={{-93,64},{-78,64},{-59,64},{-59,60.56}}, color={0,0,127}));
  connect(temperatureSensor.T, firstOrder.u) annotation (Line(points={{-103,-81},{-95,-81},{-95,-81.5}}, color={0,0,127}));
  connect(firstOrder.y, boundaryVLE_Txim_flow.T) annotation (Line(points={{-83.5,-81.5},{-77.75,-81.5},{-77.75,-82},{-72,-82}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-140,-140},{140,140}},
        initialScale=0.1)), Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-140,-140},{140,140}},
        initialScale=0.1)),
    experiment(
      StopTime=43200,
      Interval=300,
      Tolerance=1e-006),
    __Dymola_experimentSetupOutput(inputs=false, events=false),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false),
Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Small example of coupled electric, gas, and heating system. </p>
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
<p>Created by Lisa Andresen (andresen@tuhh.de), Mar 2017</p>
</html>"));
end Coupled_SmallScale;
