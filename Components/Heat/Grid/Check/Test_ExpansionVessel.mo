within TransiEnt.Components.Heat.Grid.Check;
model Test_ExpansionVessel
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

  inner TransiEnt.SimCenter simCenter
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow boundaryVLE_Txim_source1(
    m_flow_const=-10,
    p_nom(displayUnit="bar") = 600000,
    T_const(displayUnit="degC") = 275.15)
    annotation (Placement(transformation(extent={{86,-10},{66,10}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L2_Simple pipeFlow_L2_Simple(
    h_nom={293457},
    h_start={293457},
    p_start(displayUnit="bar") = {600000},
    Delta_p_nom(displayUnit="bar") = 50000,
    length=1000,
    p_nom={6e5},
    m_flow_nom=10,
    z_out=10,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.VLE_PL.QuadraticNominalPoint_L4,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4,
    initOption=208,
    frictionAtInlet=true,
    frictionAtOutlet=true)
                    annotation (Placement(transformation(extent={{-34,-5},{-6,5}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T(
        displayUnit="degC") = 293.15)
    annotation (Placement(transformation(extent={{-56,44},{-36,64}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow boundaryVLE_Txim_source2(
    p_nom(displayUnit="bar") = 600000,
    m_flow_const=+10,
    T_const(displayUnit="degC") = 343.15,
    variable_m_flow=true)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperature annotation (Placement(transformation(extent={{0,-36},{20,-16}})));
  IdealizedExpansionVessel idealizedExpansionVessel(p=300000) annotation (Placement(transformation(extent={{-12,44},{18,72}})));
Modelica.Blocks.Sources.Ramp ramp(
    height=2,
    offset=9,
    duration=1800,
    startTime=100) annotation (Placement(transformation(extent={{-134,-4},{-114,16}})));

equation
  connect(fixedTemperature.port, pipeFlow_L2_Simple.heat[1]) annotation (Line(
      points={{-36,54},{-20,54},{-20,4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pipeFlow_L2_Simple.outlet, boundaryVLE_Txim_source1.steam_a) annotation (Line(
      points={{-6,0},{30,0},{66,0}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundaryVLE_Txim_source2.steam_a, pipeFlow_L2_Simple.inlet) annotation (Line(
      points={{-70,0},{-44,0},{-34,0}},
      color={0,131,169},
      thickness=0.5));
  connect(temperature.port, pipeFlow_L2_Simple.outlet) annotation (Line(
      points={{10,-36},{2,-36},{-6,-36},{-6,0}},
      color={0,131,169},
      thickness=0.5));
  connect(idealizedExpansionVessel.waterPort, pipeFlow_L2_Simple.outlet) annotation (Line(
      points={{3,44},{3,44},{3,0},{-6,0}},
      color={175,0,0},
      thickness=0.5));
connect(ramp.y, boundaryVLE_Txim_source2.m_flow) annotation (Line(points={{-113,6},{-92,6}}, color={0,0,127}));

  annotation (
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=5000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for expansion vessels</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no elements)</p>
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
</html>"));
end Test_ExpansionVessel;
