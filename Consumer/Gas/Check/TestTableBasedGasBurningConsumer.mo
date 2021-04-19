within TransiEnt.Consumer.Gas.Check;
model TestTableBasedGasBurningConsumer

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Checkmodel;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  inner TransiEnt.SimCenter simCenter(redeclare TILMedia.VLEFluidTypes.TILMedia_Water fluid1) annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  TransiEnt.Consumer.Gas.TableBasedGasBurningConsumer tableBasedGasConsumer(
    eta=0.95,
    redeclare TransiEnt.Basics.Tables.GasGrid.NaturalGasVolumeFlowSTP consumerDataTable,
    use_Q_flow_input=false,
    constantfactor=-1e6)                                                                 annotation (Placement(transformation(extent={{-50,-20},{-8,26}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi gasGrid(xi_const={0,0,0,0,0,0})
                                                                   annotation (Placement(transformation(extent={{66,-22},{34,8}})));
  TransiEnt.Consumer.Gas.TableBasedGasBurningConsumer_VariableGasComposition tableBasedGasBurningConsumer_VariableGasComposition(
    eta=0.95,
    redeclare TransiEnt.Basics.Tables.GasGrid.NaturalGasVolumeFlowSTP consumerDataTable,
    use_Q_flow_input=false,
    consider_FlueGas_losses=false,
    constantfactor=-1e6)    annotation (Placement(transformation(extent={{-52,-78},{-10,-38}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(gasGrid.gasPort, tableBasedGasConsumer.gasIn) annotation (Line(
      points={{34,-7},{14,-7},{14,-6.2},{-8,-6.2}},
      color={255,255,0},
      thickness=0.75));
  connect(tableBasedGasBurningConsumer_VariableGasComposition.gasIn, gasGrid.gasPort) annotation (Line(
      points={{-10,-66},{16,-66},{16,-7},{34,-7}},
      color={255,255,0},
      thickness=1.5));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test model for the models TableBasedGasBurningConsumer and TableBasedGasBurningConsumer_VariableGasComposition. It shows how the gas consumption changes over the course of a year.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</p>
</html>"),
    experiment(StopTime=31536000, Interval=900));
end TestTableBasedGasBurningConsumer;
