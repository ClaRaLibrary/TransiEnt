within TransiEnt.Producer.Gas.MethanatorSystem.Check;
model Test_MethanatorSystem
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
  extends TransiEnt.Basics.Icons.Checkmodel;
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow(
    medium=TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var(),
    variable_m_flow=true,
    xi_const={0,0.844884,0},
    T_const=493.15) annotation (Placement(transformation(extent={{-54,-42},{-34,-22}})));
  Modelica.Blocks.Sources.Ramp ramp3(
    duration=1e6,
    height=0.218564,
    offset=-0.218564,
    startTime=1e6)       annotation (Placement(transformation(extent={{-94,-36},{-74,-16}})));
  MethanatorSystem methanatorSystem(m_flow_n_Hydrogen=0.0339027) annotation (Placement(transformation(extent={{-12,-42},{8,-22}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi2(
    medium=TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var(),
    variable_p=true,
    p_const=1700000)                                                                                       annotation (Placement(transformation(extent={{52,-42},{32,-22}})));
  Modelica.Blocks.Sources.Ramp ramp4(
    duration=1e6,
    startTime=2e6,
    height=0,
    offset=17e5)         annotation (Placement(transformation(extent={{96,-36},{76,-16}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow1(
    medium=TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var(),
    variable_m_flow=true,
    xi_const={0,1,0},
    T_const=493.15) annotation (Placement(transformation(extent={{-58,-76},{-38,-56}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=4e5,
    startTime=5e5,
    height=0.2,
    offset=-0.2)         annotation (Placement(transformation(extent={{-94,-70},{-74,-50}})));
  inner SimCenter           simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3, redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_SRK_var gasModel1)
                                                                                                  annotation (Placement(transformation(extent={{50,60},{70,80}})));
  inner ModelStatistics                                                   modelStatistics annotation (Placement(transformation(extent={{70,60},{90,80}})));
equation
  connect(boundary_Txim_flow.m_flow, ramp3.y) annotation (Line(points={{-56,-26},{-64,-26},{-73,-26}}, color={0,0,127}));
  connect(methanatorSystem.gasPortOut, boundaryRealGas_pTxi2.gasPort) annotation (Line(
      points={{8,-32},{32,-32}},
      color={255,255,0},
      thickness=1.5));
  connect(boundaryRealGas_pTxi2.p, ramp4.y) annotation (Line(points={{54,-26},{50,-26},{75,-26}},          color={0,0,127}));
  connect(methanatorSystem.gasPortIn, boundary_Txim_flow.gasPort) annotation (Line(
      points={{-12,-32},{-34,-32}},
      color={255,255,0},
      thickness=1.5));
  connect(boundary_Txim_flow1.gasPort, methanatorSystem.gasPortIn) annotation (Line(
      points={{-38,-66},{-32,-66},{-32,-32},{-12,-32}},
      color={255,255,0},
      thickness=1.5));
  connect(boundary_Txim_flow1.m_flow, ramp1.y) annotation (Line(points={{-60,-60},{-73,-60}},           color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-86,42},{64,22}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Look at methanatorSystem.summary.gasPortOut.xi[1]:

Before time= 5e5s: too high CO2 concentration at input -> low CH4-concentration at ouput
From 9e5s on the H2:CO2-ratio is 4:1 (ideal for methanation) -> thus the CH4-concentration at output rises")}),
    experiment(StopTime=3e+006, Interval=600));
end Test_MethanatorSystem;
