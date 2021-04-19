within TransiEnt.Producer.Gas.MethanatorSystem.Check;
model Test_MethanatorSystem "Model for testing the MethanatorSystem"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
// Copyright 2020, Hamburg University of Technology.                              //
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
  extends TransiEnt.Basics.Icons.Checkmodel;
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow(
    variable_m_flow=true,
    xi_const={0,0,0,0,0,0},
    T_const=493.15) annotation (Placement(transformation(extent={{-54,6},{-34,26}})));
  Modelica.Blocks.Sources.Ramp ramp3(
    duration=1e6,
    height=0.218564,
    offset=-0.218564,
    startTime=1e6)       annotation (Placement(transformation(extent={{-94,12},{-74,32}})));
  MethanatorSystem_L4 methanatorSystem(
    useFluidCoolantPort=true,
    useVariableCoolantOutputTemperature=true,
    m_flow_n_Hydrogen=0.218564,
    integrateMassFlow=false) annotation (Placement(transformation(extent={{-12,6},{8,26}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi2(
    variable_p=true, p_const=1700000)                                                                      annotation (Placement(transformation(extent={{52,6},{32,26}})));
  Modelica.Blocks.Sources.Ramp ramp4(
    duration=1e6,
    startTime=2e6,
    height=0,
    offset=17e5)         annotation (Placement(transformation(extent={{96,12},{76,32}})));
  inner SimCenter           simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3, redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_SRK_var gasModel1)
                                                                                                  annotation (Placement(transformation(extent={{48,80},{68,100}})));
  inner ModelStatistics                                                   modelStatistics annotation (Placement(transformation(extent={{68,80},{88,100}})));
  Components.Boundaries.Gas.BoundaryRealGas_Txim_flow           boundary_Txim_flow2(
    variable_m_flow=true,
    xi_const={0,0,0,0,0,0},
    T_const=493.15) annotation (Placement(transformation(extent={{-52,-70},{-32,-50}})));
  MethanatorSystem_L1 methanatorSystem1(
    useFluidCoolantPort=true,
    m_flow_n_Hydrogen=0.218564,
    integrateMassFlow=false) annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi           boundaryRealGas_pTxi1(variable_p=true, p_const=1700000)
                                                                                                           annotation (Placement(transformation(extent={{54,-70},{34,-50}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi(p_const=17e5)
                                                                        annotation (Placement(transformation(extent={{-28,-8},{-18,4}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi1(p_const=17e5)
                                                                         annotation (Placement(transformation(extent={{-30,24},{-20,38}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi2(p_const=17e5)
                                                                         annotation (Placement(transformation(extent={{-28,-92},{-18,-82}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi3(p_const=17e5)
                                                                         annotation (Placement(transformation(extent={{-28,-50},{-18,-36}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=1e6,
    startTime=0,
    height=700,
    offset=273.15 + 200) annotation (Placement(transformation(extent={{40,40},{20,60}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_out(unitOption=2) annotation (Placement(transformation(extent={{18,20},{28,32}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_out1(unitOption=2)
                                                                              annotation (Placement(transformation(extent={{22,-50},{32,-38}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_in(unitOption=2) annotation (Placement(transformation(extent={{18,-10},{28,0}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_in1(unitOption=2)
                                                                             annotation (Placement(transformation(extent={{22,-92},{32,-82}})));
equation
  connect(boundary_Txim_flow.m_flow, ramp3.y) annotation (Line(points={{-56,22},{-73,22}},             color={0,0,127}));
  connect(methanatorSystem.gasPortOut, boundaryRealGas_pTxi2.gasPort) annotation (Line(
      points={{8,16},{32,16}},
      color={255,255,0},
      thickness=1.5));
  connect(boundaryRealGas_pTxi2.p, ramp4.y) annotation (Line(points={{54,22},{75,22}},                     color={0,0,127}));
  connect(methanatorSystem.gasPortIn, boundary_Txim_flow.gasPort) annotation (Line(
      points={{-12,16},{-34,16}},
      color={255,255,0},
      thickness=1.5));
  connect(methanatorSystem1.gasPortOut, boundaryRealGas_pTxi1.gasPort) annotation (Line(
      points={{10,-60},{34,-60}},
      color={255,255,0},
      thickness=1.5));
  connect(methanatorSystem1.gasPortIn, boundary_Txim_flow2.gasPort) annotation (Line(
      points={{-10,-60},{-32,-60}},
      color={255,255,0},
      thickness=1.5));
  connect(boundaryVLE_pTxi.steam_a, methanatorSystem.fluidPortIn) annotation (Line(
      points={{-18,-2},{8,-2},{8,7}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundaryVLE_pTxi1.steam_a, methanatorSystem.fluidPortOut) annotation (Line(
      points={{-20,31},{8,31},{8,12}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundaryVLE_pTxi2.steam_a, methanatorSystem1.fluidPortIn) annotation (Line(
      points={{-18,-87},{10,-87},{10,-69}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundaryVLE_pTxi3.steam_a, methanatorSystem1.fluidPortOut) annotation (Line(
      points={{-18,-43},{10,-43},{10,-64}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(methanatorSystem.T_set_coolant_out, ramp1.y) annotation (Line(points={{10,23},{10,35.5},{19,35.5},{19,50}},color={0,0,127}));
  connect(methanatorSystem.fluidPortOut, temperatureSensor_out.port) annotation (Line(
      points={{8,12},{18,12},{18,20},{23,20}},
      color={175,0,0},
      thickness=0.5));
  connect(methanatorSystem.fluidPortIn, temperatureSensor_in.port) annotation (Line(
      points={{8,7},{8,-10},{23,-10}},
      color={175,0,0},
      thickness=0.5));
  connect(methanatorSystem1.fluidPortIn, temperatureSensor_in1.port) annotation (Line(
      points={{10,-69},{10,-92},{27,-92}},
      color={175,0,0},
      thickness=0.5));
  connect(methanatorSystem1.fluidPortOut, temperatureSensor_out1.port) annotation (Line(
      points={{10,-64},{18,-64},{18,-50},{27,-50}},
      color={175,0,0},
      thickness=0.5));
  connect(ramp4.y, boundaryRealGas_pTxi1.p) annotation (Line(points={{75,22},{66,22},{66,-54},{56,-54}}, color={0,0,127}));
  connect(ramp3.y, boundary_Txim_flow2.m_flow) annotation (Line(points={{-73,22},{-66,22},{-66,-54},{-54,-54}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=3e+006, Interval=600),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the MethanatorSystem using the normal gas boundaries</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
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
</html>"));
end Test_MethanatorSystem;
