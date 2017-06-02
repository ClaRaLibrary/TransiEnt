within TransiEnt.Producer.Heat.SolarThermal.Check;
model TestCollectorFluidCycle
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  extends TransiEnt.Basics.Icons.Checkmodel;
  import Const = Modelica.Constants;
  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
                                                                                   annotation (Placement(transformation(extent={{-94,-6},{-74,14}})));
  inner TransiEnt.SimCenter simCenter(redeclare TILMedia.VLEFluidTypes.TILMedia_SplineWater fluid1, ambientConditions(
      redeclare TransiEnt.Basics.Tables.Ambient.GHI_Hamburg_3600s_2012_TMY globalSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DNI_Hamburg_3600s_2012_TMY directSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DHI_Hamburg_3600s_2012_TMY diffuseSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.Temperature_Berlin_3600s_2012 temperature,
      redeclare TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_Fuhlsbuettel_3600s_2012 wind))         annotation (Placement(transformation(extent={{-90,120},{-70,140}})));

  ClaRa.Components.HeatExchangers.IdealShell_L2 tubeBundle_L2_1(
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L2,
    m_flow_nom=0.02,
    h_nom=84000,
    h_start=84000,
    p_nom=110000,
    p_start=110000,
    initOption=201)                                                                                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-56,4})));

  TransiEnt.Components.Heat.Grid.IdealizedExpansionVessel idealizedExpansionVessel(p=110000) annotation (Placement(transformation(extent={{-66,58},{-46,78}})));

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
        origin={12,43})));

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
        origin={12,-39})));

  Controller controller(
    T=1,
    yMax=1000,
    initType_PID=Modelica.Blocks.Types.InitPID.InitialOutput,
    yMin=0,
    strict=false,
    Ti=10,
    Td=100,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    G_min=150,
    y_start_PID=10,
    k_PID=40,
    m_flow_min=0.015,
    T_set=358.15,
    Delta_p=15000)   annotation (Placement(transformation(extent={{148,50},{182,78}})));

  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1 valveVLE_L1_2(redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint)
                                                                                        annotation (Placement(transformation(extent={{56,38},{76,50}})));
  SolarCollector_L1 solarCollector(
    area=2.33,
    c_eff=5000,
    eta_0=0.793,
    a1=4.04,
    a2=0.0182,
    G_min=controller.G_min,
    redeclare model Skymodel = Base.Skymodel_isotropicDiffuse,
    Q_flow_n=2e3)   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={112,6})));

  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pumpVLE_L1_simple annotation (Placement(transformation(extent={{-40,32},{-20,52}})));

  inner ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-90,100},{-70,120}})));
equation

   // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(tubeBundle_L2_1.heat, fixedTemperature.port) annotation (Line(
      points={{-66,4},{-74,4}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));

  connect(tubeBundle_L2_1.outlet,idealizedExpansionVessel.waterPort)  annotation (Line(
      points={{-56,14},{-56,48},{-56,58}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pipe1.outlet, valveVLE_L1_2.inlet) annotation (Line(
      points={{26,43},{34,43},{34,44},{56,44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(tubeBundle_L2_1.inlet, pipeFlow_L2_Simple_out_collector.outlet) annotation (Line(
      points={{-56,-6},{-56,-6},{-56,-28},{-56,-39},{-2,-39}},
      color={0,131,169},
      thickness=0.5));
  connect(solarCollector.T_out, controller.T_out) annotation (Line(points={{120.6,0.4},{138,0.4},{138,61.6667},{150.267,61.6667}}, color={0,0,127}));
  connect(controller.G_total,solarCollector. G) annotation (Line(points={{150.267,55.8333},{142,55.8333},{142,12},{142,-1.8},{120.6,-1.8}}, color={0,0,127}));
  connect(valveVLE_L1_2.outlet, solarCollector.waterPortIn) annotation (Line(
      points={{76,44},{112,44},{112,14}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pumpVLE_L1_simple.outlet, pipe1.inlet) annotation (Line(
      points={{-20,42},{-2,42},{-2,43}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pumpVLE_L1_simple.inlet,idealizedExpansionVessel.waterPort)  annotation (Line(
      points={{-40,42},{-56,42},{-56,58}},
      color={0,131,169},
      thickness=0.5));
  connect(pipeFlow_L2_Simple_out_collector.inlet, solarCollector.waterPortOut) annotation (Line(
      points={{26,-39},{26,-39},{112,-39},{112,-2}},
      color={0,131,169},
      thickness=0.5));
  connect(controller.P_drive, pumpVLE_L1_simple.P_drive) annotation (Line(points={{150.267,71},{150.267,71},{-30,71},{-30,54}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{180,140}})),
    experiment(
      StopTime=3.1536e+007,
      Interval=100,
      Tolerance=0.001),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
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
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Max Mustermann (max.mustermann@mustermail.com) on Thu Apr 24 2014</p>
</html>"));
end TestCollectorFluidCycle;
