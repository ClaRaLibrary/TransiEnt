within TransiEnt.Producer.Heat.SolarThermal.Check;
model TestCollectorFluidCycle_constProp2 "Tester for a solar collector using a fluid cycle"
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
  extends TransiEnt.Basics.Icons.Checkmodel;
  import Const = Modelica.Constants;
  import      Modelica.Units.SI;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

 Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15) annotation (Placement(transformation(extent={{-124,-20},{-104,0}})));
  inner TransiEnt.SimCenter simCenter(redeclare TILMedia.VLEFluidTypes.TILMedia_SplineWater fluid1, ambientConditions(
      redeclare TransiEnt.Basics.Tables.Ambient.GHI_Hamburg_3600s_2012_TMY globalSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DNI_Hamburg_3600s_2012_TMY directSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DHI_Hamburg_3600s_2012_TMY diffuseSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.Temperature_Berlin_3600s_2012 temperature,
      redeclare TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_Fuhlsbuettel_3600s_2012 wind))         annotation (Placement(transformation(extent={{-90,120},{-70,140}})));

  ClaRa.Components.HeatExchangers.IdealShell_L2 tubeBundle_L2_1(
    redeclare model HeatTransfer = Consumer.Heat.ThermalHeatConsumer_L3.HeatTransfer_EN442 (
        T_mean_supply=273.15 + 85,
        DT_nom=15,
        Q_flow_nom=2e3,
        T_air_nom=293.15),
   redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L2,
    m_flow_nom=0.02,
    h_nom=84000,
    h_start=84000,
    p_nom=110000,
    p_start=110000,
    initOption=201)                                                                                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-54,-10})));

  TransiEnt.Components.Heat.Grid.IdealizedExpansionVessel idealizedExpansionVessel(p=110000) annotation (Placement(transformation(extent={{-66,44},{-46,64}})));

  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L2_Simple pipe1(
    frictionAtInlet=true,
    frictionAtOutlet=true,
    m_flow_nom=0.02,
    p_nom={200000},
    Delta_p_nom=100000,
    h_start={84000},
    h_nom={84000},
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    p_start={120000}) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=0,
        origin={12,29})));

  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L2_Simple pipeFlow_L2_Simple_out_collector(
    m_flow_nom=0.02,
    frictionAtInlet=true,
    frictionAtOutlet=true,
    p_nom={200000},
    Delta_p_nom=100000,
    h_nom={200000},
    h_start={160000},
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4,
    p_start={110000}) annotation (Placement(transformation(
        extent={{-14,-5},{14,5}},
        rotation=180,
        origin={12,-53})));

  TransiEnt.Producer.Heat.SolarThermal.Control.ControllerPumpSolarCollectorDeltaT controller(PID(
      y_max=40/3600*solarCollector.area,
      y_min=8/3600*solarCollector.area,
      k=(controller.PID.y_max - controller.PID.y_min)/(90 - 75)), Tau_out=0) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={132,18})));

  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 valveVLE_L1_2(redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint)
                                                                                        annotation (Placement(transformation(extent={{56,24},{76,36}})));
  TransiEnt.Producer.Heat.SolarThermal.SolarCollector_L1_constProp solarCollector(
    area=2.33,
    c_eff=5000,
    eta_0=0.793,
    a1=4.04,
    a2=0.0182,
    redeclare model Skymodel = Base.Skymodel_isotropicDiffuse,
    Q_flow_n=2e3,
    G_min=150)    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={112,-8})));

  TransiEnt.Components.Heat.PumpVLE_L1_simple            pumpVLE_L1_simple(presetVariableType="m_flow", m_flowInput=true)
                                                                           annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  inner ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-90,100},{-70,120}})));
equation

   // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(tubeBundle_L2_1.outlet,idealizedExpansionVessel.waterPort)  annotation (Line(
      points={{-54,0},{-54,22},{-56,22},{-56,44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pipe1.outlet, valveVLE_L1_2.inlet) annotation (Line(
      points={{26,29},{34,29},{34,30},{56,30}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(tubeBundle_L2_1.inlet, pipeFlow_L2_Simple_out_collector.outlet) annotation (Line(
      points={{-54,-20},{-54,-53},{-2,-53}},
      color={0,131,169},
      thickness=0.5));
  connect(valveVLE_L1_2.outlet, solarCollector.waterPortIn) annotation (Line(
      points={{76,30},{112,30},{112,0}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pipeFlow_L2_Simple_out_collector.inlet, solarCollector.waterPortOut) annotation (Line(
      points={{26,-53},{112,-53},{112,-16}},
      color={0,131,169},
      thickness=0.5));
  connect(solarCollector.T_in, controller.T_solar_in) annotation (Line(points={{120.1,-2.9},{128,-2.9},{128,8}},
                                                                                                            color={0,0,127}));
  connect(controller.T_solar_out, solarCollector.T_out) annotation (Line(points={{136,8},{136,-14},{121,-14}},
                                                                                                            color={0,0,127}));
  connect(pipe1.inlet, pumpVLE_L1_simple.fluidPortOut) annotation (Line(
      points={{-2,29},{-12,29},{-12,30},{-20,30}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(tubeBundle_L2_1.outlet, pumpVLE_L1_simple.fluidPortIn) annotation (Line(
      points={{-54,0},{-54,30},{-40,30}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pumpVLE_L1_simple.m_flow_in, controller.y) annotation (Line(points={{-38,41},{-38,48},{132,48},{132,29}}, color={0,0,127}));
  connect(fixedTemperature.port, tubeBundle_L2_1.heat) annotation (Line(points={{-104,-10},{-100,-10},{-100,-8},{-64,-8},{-64,-10}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{180,140}}), graphics={Text(
          extent={{-40,120},{128,102}},
          textColor={28,108,200},
          fontSize=8,
          horizontalAlignment=TextAlignment.Left,
          textString="Look at:
- solarCollector.T_out
- solarCollector.Q_flow_collector
- pumpVLE_L1_simple.outlet.m_flow")}),
    experiment(
      StopTime=31536000,
      Interval=900,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test model for CollectorFluidCycle</p>
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
<p>Model created by Carsten Bode (c.bode@tuhh.de), Nov 2018</p>
</html>"));
end TestCollectorFluidCycle_constProp2;
