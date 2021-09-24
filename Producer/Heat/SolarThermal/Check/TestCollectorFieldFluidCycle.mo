within TransiEnt.Producer.Heat.SolarThermal.Check;
model TestCollectorFieldFluidCycle "Tester for a solar collector field using a fluid cycle"

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

  extends TransiEnt.Basics.Icons.Checkmodel;
  import Const = Modelica.Constants;
  import      Modelica.Units.SI;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
                                                                                   annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  inner TransiEnt.SimCenter simCenter(redeclare TILMedia.VLEFluidTypes.TILMedia_SplineWater fluid1, ambientConditions(
      redeclare TransiEnt.Basics.Tables.Ambient.GHI_Hamburg_3600s_2012_TMY globalSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DNI_Hamburg_3600s_2012_TMY directSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DHI_Hamburg_3600s_2012_TMY diffuseSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.Temperature_Berlin_3600s_2012 temperature,
      redeclare TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_Fuhlsbuettel_3600s_2012 wind))         annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

  ClaRa.Components.HeatExchangers.IdealShell_L2 tubeBundle_L2_1(
    redeclare model HeatTransfer = Consumer.Heat.ThermalHeatConsumer_L3.HeatTransfer_EN442 (
        T_mean_supply=273.15 + 85,
        Q_flow_nom=12*2e3,
        T_air_nom=293.15),
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L2,
    h_nom=84000,
    h_start=84000,
    m_flow_nom=0.02,
    p_nom=110000,
    p_start=110000,
    initOption=0)                                                                                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-44,-20})));

  TransiEnt.Components.Heat.Grid.IdealizedExpansionVessel idealizedExpansionVessel(p=110000) annotation (Placement(transformation(extent={{-54,28},{-34,48}})));

  SolarCollectorField_L1 collectorfield(
    area=2.33,
    eta_0=0.793,
    noFriction=true,
    redeclare model Skymodel = Base.Skymodel_isotropicDiffuse,
    G_min=controller.G_min,
    c_eff=5000,
    a1=4.04,
    a2=0.0182,
    constant_iam_dir=0.93,
    constant_iam_diff=0.86,
    constant_iam_ground=0.86,
    a=128,
    b=8329,
    n_serial=12,
    n_parallel=10,
    Q_flow_n=2e3) annotation (Placement(transformation(
        extent={{-44,-19},{44,19}},
        rotation=270,
        origin={145,-40})));

  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L1_2(redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=1, m_flow_nom=0.001))
                                                                                        annotation (Placement(transformation(extent={{88,12},{108,24}})));

  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L2_Simple pipeFlow_L2_Simple_in_collector(
    p_nom={200000},
    h_nom={84000},
    h_start={84000},
    p_start={400000},
    m_flow_nom=0.02,
    Delta_p_nom=10000,
    frictionAtInlet=true,
    frictionAtOutlet=true,
    initOption=0)      annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=0,
        origin={26,17})));

  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L2_Simple pipeFlow_L2_Simple_out_collector(
    h_nom={200000},
    h_start={160000},
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    p_nom={200000},
    p_start={300000},
    m_flow_nom=0.02,
    Delta_p_nom=10000,
    frictionAtInlet=true,
    frictionAtOutlet=true,
    initOption=0)      annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=180,
        origin={26,-89})));

  Control.ControllerPumpSolarCollectorTandG controller(
    G_min=150,
    T=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMax=1000,
    yMin=0,
    initType_PID=Modelica.Blocks.Types.Init.InitialOutput,
    y_start_PID=10,
    m_flow_min=0.05,
    k_PID=10,
    T_set=358.15,
    Delta_p=50000,
    T_stor=273.15 + 75) annotation (Placement(transformation(extent={{164,24},{194,48}})));

  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pumpVLE_L1_simple annotation (Placement(transformation(extent={{-26,8},{-6,28}})));

  inner ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  Components.Sensors.TemperatureSensor temperatureSensor annotation (Placement(transformation(extent={{110,24},{130,44}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(tubeBundle_L2_1.outlet,idealizedExpansionVessel.waterPort)  annotation (Line(
      points={{-44,-10},{-44,28}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveVLE_L1_2.inlet, pipeFlow_L2_Simple_in_collector.outlet) annotation (Line(
      points={{88,18},{52,18},{52,17},{40,17}},
      color={0,131,169},
      thickness=0.5));
  connect(tubeBundle_L2_1.inlet, pipeFlow_L2_Simple_out_collector.outlet) annotation (Line(
      points={{-44,-30},{-44,-89},{12,-89}},
      color={0,131,169},
      thickness=0.5));
  connect(valveVLE_L1_2.outlet, collectorfield.waterIn) annotation (Line(
      points={{108,18},{145,18},{145,2.84211}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pumpVLE_L1_simple.outlet, pipeFlow_L2_Simple_in_collector.inlet) annotation (Line(
      points={{-6,18},{0,18},{0,17},{12,17}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pumpVLE_L1_simple.inlet,idealizedExpansionVessel.waterPort)  annotation (Line(
      points={{-26,18},{-44,18},{-44,28}},
      color={0,131,169},
      thickness=0.5));
  connect(collectorfield.T_out, controller.T_out) annotation (Line(points={{162.575,-75.4316},{176,-75.4316},{176,16},{152,16},{152,34},{166,34}}, color={0,0,127}));
  connect(controller.G_total, collectorfield.G_total) annotation (Line(points={{166,29},{156,29},{156,12},{172,12},{172,-70.8},{162.575,-70.8}},
                                                                                                  color={0,0,127}));
  connect(pipeFlow_L2_Simple_out_collector.inlet, collectorfield.waterOut) annotation (Line(
      points={{40,-89},{145,-89},{145,-82.8421}},
      color={0,131,169},
      thickness=0.5));
  connect(controller.P_drive, pumpVLE_L1_simple.P_drive) annotation (Line(points={{166,42},{-16,42},{-16,30}}, color={0,0,127}));
  connect(temperatureSensor.port, valveVLE_L1_2.outlet) annotation (Line(
      points={{120,24},{108,24},{108,18}},
      color={0,131,169},
      thickness=0.5));
  connect(temperatureSensor.T, controller.T_in) annotation (Line(points={{131,34},{134,34},{134,36},{142,36},{142,38.4},{166,38.4}}, color={0,0,127}));
  connect(fixedTemperature.port, tubeBundle_L2_1.heat) annotation (Line(points={{-80,-20},{-54,-20}}, color={191,0,0}));
  annotation (Diagram(graphics={Text(
          extent={{128,78},{-20,86}},
          textColor={28,108,200},
          fontSize=10,
          horizontalAlignment=TextAlignment.Left,
          textString="Look at:
- solarCollectorField.T_out
- controller.P_drive")},
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{200,100}})),
    experiment(
      StopTime=3.1536e+007,
      Interval=100,
      Tolerance=0.001),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test model for CollectorFieldCycle model</p>
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
<p>Note that the inlet temperature should never fall below 0 &deg;C. A possible controller for this case can be looked at under TransiEnt.Producer.Heat.SolarThermal.Controller.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Lisa Andresen (andresen@tuhh.de), Apr 2014</p>
</html>"));
end TestCollectorFieldFluidCycle;
