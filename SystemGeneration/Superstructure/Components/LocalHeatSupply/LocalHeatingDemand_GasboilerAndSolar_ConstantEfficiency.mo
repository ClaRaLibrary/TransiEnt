within TransiEnt.SystemGeneration.Superstructure.Components.LocalHeatSupply;
model LocalHeatingDemand_GasboilerAndSolar_ConstantEfficiency


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

  extends TransiEnt.SystemGeneration.Superstructure.Components.LocalHeatSupply.Base.PartialLocalHeatingDemand_Gasboiler;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Modelica.Units.SI.Efficiency eta_gasboiler=0.9;
  parameter SI.Heat Q_annual_solarthermal;
  parameter SI.Heat Q_max_storage;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Consumer.Gas.TableBasedGasBurningConsumer_VariableGasComposition tableBasedGasBurningConsumer_VariableGasComposition(
    eta=1,
    use_Q_flow_input=true,
    consider_FlueGas_losses=false,
    constantfactor=-1/eta_gasboiler) annotation (Placement(transformation(extent={{-10,-6},{10,14}})));
  LocalHeatingDemand_HeatStorage localHeatingDemand_HeatStorage(Q_annual_solarthermal=Q_annual_solarthermal, Q_max_storage=Q_max_storage) annotation (Placement(transformation(extent={{-58,2},{-38,22}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=Q_flow_solarthermal_pu) annotation (Placement(transformation(extent={{-100,-2},{-80,18}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  outer SI.HeatFlowRate Q_flow_solarthermal_pu;

equation

  connect(tableBasedGasBurningConsumer_VariableGasComposition.gasIn, gasIn) annotation (Line(
      points={{10,0},{100,0}},
      color={255,255,0},
      thickness=1.5));
  connect(localHeatingDemand_HeatStorage.Q_flow_set_residual, tableBasedGasBurningConsumer_VariableGasComposition.Q_flow) annotation (Line(points={{-37,12},{-12,12},{-12,10}}, color={0,0,127}));
  connect(localHeatingDemand_HeatStorage.Q_flow_set, Q_flow_set) annotation (Line(points={{-60,16},{-68,16},{-68,60},{-120,60}}, color={0,0,127}));
  connect(realExpression.y, localHeatingDemand_HeatStorage.Q_flow_solarthermal_pu) annotation (Line(points={{-79,8},{-60,8}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model of gas boiler with constant efficiency and solar thermal plant to cover local heating demand</p>
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
end LocalHeatingDemand_GasboilerAndSolar_ConstantEfficiency;
