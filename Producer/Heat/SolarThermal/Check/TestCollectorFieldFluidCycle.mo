within TransiEnt.Producer.Heat.SolarThermal.Check;
model TestCollectorFieldFluidCycle
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
                                                                                   annotation (Placement(transformation(extent={{-92,-14},{-72,6}})));
  inner TransiEnt.SimCenter simCenter(redeclare TILMedia.VLEFluidTypes.TILMedia_SplineWater fluid1, ambientConditions(
      redeclare TransiEnt.Basics.Tables.Ambient.GHI_Hamburg_3600s_2012_TMY globalSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DNI_Hamburg_3600s_2012_TMY directSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DHI_Hamburg_3600s_2012_TMY diffuseSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.Temperature_Berlin_3600s_2012 temperature,
      redeclare TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_Fuhlsbuettel_3600s_2012 wind))         annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

  ClaRa.Components.HeatExchangers.IdealShell_L2 tubeBundle_L2_1(
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.QuadraticNominalPoint_L2,
    h_nom=84000,
    h_start=84000,
    m_flow_nom=0.1,
    p_nom=110000,
    p_start=110000,
    initOption=0)                                                                                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-52,-4})));

  TransiEnt.Components.Heat.Grid.IdealizedExpansionVessel idealizedExpansionVessel(p=110000) annotation (Placement(transformation(extent={{-62,44},{-42,64}})));

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
    Q_flow_n=2e3)  annotation (Placement(transformation(
        extent={{-44,-19},{44,19}},
        rotation=270,
        origin={137,-22})));

  ClaRa.Components.VolumesValvesFittings.Valves.ValveVLE_L1 valveVLE_L1_2(redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=1, m_flow_nom=0.001))
                                                                                        annotation (Placement(transformation(extent={{80,28},{100,40}})));

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
        origin={18,33})));

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
        origin={18,-79})));

   Controller controller(
    G_min=150,
    T=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMax=1000,
    yMin=0,
    initType_PID=Modelica.Blocks.Types.InitPID.InitialOutput,
    y_start_PID=10,
    m_flow_min=0.05,
    k_PID=10,
    T_set=358.15,
    Delta_p=50000) annotation (Placement(transformation(extent={{156,40},{186,64}})));

  ClaRa.Components.TurboMachines.Pumps.PumpVLE_L1_simple pumpVLE_L1_simple annotation (Placement(transformation(extent={{-34,24},{-14,44}})));

  inner ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(tubeBundle_L2_1.heat, fixedTemperature.port) annotation (Line(
      points={{-62,-4},{-72,-4}},
      color={167,25,48},
      thickness=0.5,
      smooth=Smooth.None));

  connect(tubeBundle_L2_1.outlet,idealizedExpansionVessel.waterPort)  annotation (Line(
      points={{-52,6},{-52,26},{-52,44}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(valveVLE_L1_2.inlet, pipeFlow_L2_Simple_in_collector.outlet) annotation (Line(
      points={{80,34},{44,34},{44,33},{32,33}},
      color={0,131,169},
      thickness=0.5));
  connect(tubeBundle_L2_1.inlet, pipeFlow_L2_Simple_out_collector.outlet) annotation (Line(
      points={{-52,-14},{-52,-14},{-52,-79},{4,-79}},
      color={0,131,169},
      thickness=0.5));
  connect(valveVLE_L1_2.outlet, collectorfield.waterIn) annotation (Line(
      points={{100,34},{137,34},{137,20.8421}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pumpVLE_L1_simple.outlet, pipeFlow_L2_Simple_in_collector.inlet) annotation (Line(
      points={{-14,34},{-8,34},{-8,33},{4,33}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pumpVLE_L1_simple.inlet,idealizedExpansionVessel.waterPort)  annotation (Line(
      points={{-34,34},{-52,34},{-52,44}},
      color={0,131,169},
      thickness=0.5));
  connect(collectorfield.T_out, controller.T_out) annotation (Line(points={{154.575,-57.4316},{168,-57.4316},{168,32},{144,32},{144,50},{158,50}}, color={0,0,127}));
  connect(controller.G_total, collectorfield.G_total) annotation (Line(points={{158,45},{148,45},{148,34},{148,28},{164,28},{164,-52.8},{154.575,-52.8}},
                                                                                                  color={0,0,127}));
  connect(pipeFlow_L2_Simple_out_collector.inlet, collectorfield.waterOut) annotation (Line(
      points={{32,-79},{52,-79},{137,-79},{137,-64.8421}},
      color={0,131,169},
      thickness=0.5));
  connect(controller.P_drive, pumpVLE_L1_simple.P_drive) annotation (Line(points={{158,58},{-24,58},{-24,46}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{200,100}})),
    experiment(
      StopTime=3.1536e+007,
      Interval=100,
      Tolerance=0.001),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test model for CollectorFieldCycle Modell</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<h4><span style=\"color: #008000\">(no elements)</span></h4>
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
end TestCollectorFieldFluidCycle;
