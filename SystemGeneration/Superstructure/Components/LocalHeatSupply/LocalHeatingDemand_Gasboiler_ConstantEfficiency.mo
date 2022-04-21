within TransiEnt.SystemGeneration.Superstructure.Components.LocalHeatSupply;
model LocalHeatingDemand_Gasboiler_ConstantEfficiency


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

  extends Base.PartialLocalHeatingDemand_Gasboiler;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Modelica.Units.SI.Efficiency eta_gasboiler=0.9;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Consumer.Gas.TableBasedGasBurningConsumer_VariableGasComposition tableBasedGasBurningConsumer_VariableGasComposition(
    eta=1,
    use_Q_flow_input=true,
    consider_FlueGas_losses=false,
    constantfactor=-1/eta_gasboiler) annotation (Placement(transformation(extent={{-10,-6},{10,14}})));

equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(tableBasedGasBurningConsumer_VariableGasComposition.gasIn, gasIn) annotation (Line(
      points={{10,0},{100,0}},
      color={255,255,0},
      thickness=1.5));
  connect(tableBasedGasBurningConsumer_VariableGasComposition.Q_flow, Q_flow_set) annotation (Line(points={{-12,10},{-48,10},{-48,60},{-120,60}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model of gas boiler with constant efficiency to cover local heating demand</p>
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
end LocalHeatingDemand_Gasboiler_ConstantEfficiency;
