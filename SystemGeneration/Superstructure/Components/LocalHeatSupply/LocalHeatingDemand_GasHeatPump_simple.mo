within TransiEnt.SystemGeneration.Superstructure.Components.LocalHeatSupply;
model LocalHeatingDemand_GasHeatPump_simple


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

  extends TransiEnt.Basics.Icons.HeatPump;
  extends TransiEnt.SystemGeneration.Superstructure.Components.LocalHeatSupply.Base.PartialLocalHeatingDemand_GasHeatPump;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Integer whichHeatPump=1 "choose type of heat pump" annotation (Dialog(group="Fundamental Definitions"), choices(
      __Dymola_radioButtons=true,
      choice=1 "Sole",
      choice=2 "Air"));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable TransiEnt.Producer.Heat.Gas2Heat.HeatPumpGasCharline heatPumpGasCharlineHeatPort_L1(use_T_source_input_K=true, useFluidPorts=false) annotation (Placement(transformation(extent={{-10,-6},{10,14}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=T_surrounding) annotation (Placement(transformation(extent={{-38,18},{-18,38}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=308.15) annotation (Placement(transformation(extent={{8,-26},{0,-18}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  outer Modelica.Units.SI.Temperature T_region;
  Modelica.Units.SI.Temperature T_surrounding=if whichHeatPump == 1 then 273.15 + 9 else T_region;

equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(heatPumpGasCharlineHeatPort_L1.gasPortIn, gasIn) annotation (Line(
      points={{10,0},{100,0}},
      color={255,255,0},
      thickness=1.5));
  connect(heatPumpGasCharlineHeatPort_L1.T_source_input_K, realExpression.y) annotation (Line(points={{0,14},{0,28},{-17,28}}, color={0,0,127}));
  connect(fixedTemperature.port, heatPumpGasCharlineHeatPort_L1.heat) annotation (Line(points={{0,-22},{0,-6}}, color={191,0,0}));
  connect(heatPumpGasCharlineHeatPort_L1.Q_flow_set, Q_flow_set) annotation (Line(
      points={{-10,4},{-74,4},{-74,60},{-120,60}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model of simple gas heat pump to cover local heating demand</p>
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
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
</html>"));
end LocalHeatingDemand_GasHeatPump_simple;
