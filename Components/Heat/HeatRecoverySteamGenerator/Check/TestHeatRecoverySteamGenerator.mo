within TransiEnt.Components.Heat.HeatRecoverySteamGenerator.Check;
model TestHeatRecoverySteamGenerator


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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

  HeatRecoverySteamGenerator_L1     steamGenerator(
    timeConstant_air=60,
    wall_thickness=0.005,
    Delta_p_nom=500,
    length=3,
    height=8,
    width=2,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Gas_PL.QuadraticNominalPoint_L4,
    redeclare model HeatTransferExternal = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
    redeclare model Insulation = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer (redeclare model medium = TransiEnt.Basics.Media.Solids.MineralWool, thickness=0.25),
    T_start=fill(293.15, steamGenerator.N_cv)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={2,0})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_Txim_flow
    boundaryGas_Txim_flow(medium=simCenter.airModel,
    xi_const=simCenter.airModel.xi_default,
    m_flow_const(displayUnit="t/h") = 12.5,
    T_const=273.15 + 450,
    variable_T=true,
    variable_m_flow=true)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi boundaryGas_pTxi(medium=
        simCenter.airModel, p_const=1e5)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  inner TransiEnt.SimCenter
                        simCenter(redeclare TILMedia.VLEFluidTypes.TILMedia_Water fluid1, redeclare TILMedia.GasTypes.MoistAirMixture airModel,
    showExpertSummary=true)
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi(              T_const=773.15,
    p_const=67e5,
    variable_p=true)                                                                                  annotation (Placement(transformation(extent={{56,-38},{36,-18}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi      boundaryVLE_pTxi1(
    variable_p=true,
    xi_const=simCenter.fluid1.xi_default,
    T_const=273.15 + 128,
    p_const=5e5,
    variable_T=true)  annotation (Placement(transformation(extent={{56,-72},{36,-52}})));
  Modelica.Blocks.Sources.TimeTable
                               timeTable(
    table=[0,0.01; 15,0.01; 16,10; 45,10; 46,15; 105,15; 106,10; 135,10; 136,10; 150,10],
    timeScale=60,
    startTime(displayUnit="s"))
                  annotation (Placement(transformation(extent={{132,18},{112,38}})));
  Modelica.Blocks.Math.Add add annotation (Placement(transformation(extent={{100,-16},{86,-2}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=273.15) annotation (Placement(transformation(extent={{134,-42},{114,-22}})));
  Modelica.Blocks.Sources.TimeTable
                               timeTable1(
    timeScale=60,
    startTime(displayUnit="s"),
    table=[0,20; 15,20; 16,300; 45,600; 46,600; 105,600; 106,600; 135,300; 136,20; 150,20])
                  annotation (Placement(transformation(extent={{132,-14},{112,6}})));
  Modelica.Blocks.Sources.TimeTable
                               timeTable2(
    timeScale=60,
    startTime(displayUnit="s"),
    table=[0,20; 15,20; 16,20; 45,130; 46,130; 105,130; 106,130; 135,20; 136,20; 150,20])
                  annotation (Placement(transformation(extent={{132,-72},{112,-52}})));
  Modelica.Blocks.Math.Add add1 annotation (Placement(transformation(extent={{84,-66},{70,-52}})));
  Modelica.Blocks.Sources.TimeTable
                               timeTable3(
    timeScale=60,
    startTime(displayUnit="s"),
    table=[0,5e5; 15,5e5; 30,5e5; 45,65e5; 46,65e5; 105,65e5; 121,65e5; 135,5e5; 136,5e5; 150,5e5])
                  annotation (Placement(transformation(extent={{84,-38},{64,-18}})));
equation
  connect(boundaryGas_pTxi.gas_a,steamGenerator.gasOutlet)  annotation (Line(
      points={{-80,0},{-7.8,0}},
      color={118,106,98},
      thickness=0.5));
  connect(steamGenerator.gasInlet, boundaryGas_Txim_flow.gas_a) annotation (Line(
      points={{11.8,0},{60,0}},
      color={118,106,98},
      thickness=0.5));
  connect(steamGenerator.livesteam, boundaryVLE_pTxi.steam_a) annotation (Line(
      points={{8,-10},{8,-28},{36,-28}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(steamGenerator.feedwater, boundaryVLE_pTxi1.steam_a) annotation (Line(
      points={{-4,-10},{-4,-62},{36,-62}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(boundaryGas_Txim_flow.m_flow, timeTable.y) annotation (Line(points={{80,6},{90,6},{90,28},{111,28}}, color={0,0,127}));
  connect(boundaryGas_Txim_flow.T, add.y) annotation (Line(points={{80,0},{84,0},{84,-9},{85.3,-9}}, color={0,0,127}));
  connect(realExpression.y, add.u2) annotation (Line(points={{113,-32},{106,-32},{106,-13.2},{101.4,-13.2}}, color={0,0,127}));
  connect(add.u1, timeTable1.y) annotation (Line(points={{101.4,-4.8},{106.7,-4.8},{106.7,-4},{111,-4}}, color={0,0,127}));
  connect(boundaryVLE_pTxi1.T, add1.y) annotation (Line(points={{56,-62},{64,-62},{64,-59},{69.3,-59}}, color={0,0,127}));
  connect(add1.u2, timeTable2.y) annotation (Line(points={{85.4,-63.2},{111,-63.2},{111,-62}}, color={0,0,127}));
  connect(add1.u1, realExpression.y) annotation (Line(points={{85.4,-54.8},{88.7,-54.8},{88.7,-32},{113,-32}}, color={0,0,127}));
  connect(boundaryVLE_pTxi.p, timeTable3.y) annotation (Line(points={{56,-22},{60,-22},{60,-28},{63,-28}}, color={0,0,127}));
  connect(timeTable3.y, boundaryVLE_pTxi1.p) annotation (Line(points={{63,-28},{60,-28},{60,-56},{56,-56}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-92,96},{-2,48}},
          textColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Check the outlet air temperature,
steam temperature
and steam mass flow
")}),
    experiment(
      StopTime=12000,
      Tolerance=1e-05,
      __Dymola_Algorithm="Sdirk34hw"),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Check heat recovery steam generator model.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Michael von der Heyde (heyde@tuhh.de), Apr 2021</p>
</html>"));
end TestHeatRecoverySteamGenerator;
