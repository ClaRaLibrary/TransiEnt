within TransiEnt.SystemGeneration.Superstructure.Components.Controller.Base;
model ControlPowerToGas_Base

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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

  extends TransiEnt.Basics.Icons.Controller;
  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Boolean y_start_hysteresis3=false;
  parameter Integer DifferentTypesOfPowerToGasPlants;
  parameter Boolean useHydrogenFromPtGInPowerPlants;
  parameter Integer usageOfWasteHeatOfPtG;
  parameter Boolean CO2NeededForPowerToGas;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput p_gas_region annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput u2 annotation (Placement(transformation(rotation=0, extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput gasComposition[max(simCenter.gasModel1.nc - 1, 1)] annotation (Placement(transformation(rotation=0, extent={{-120,-70},{-100,-50}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.SystemGeneration.Superstructure.Components.ControlBus controlBus annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={100,0})));
equation

  annotation (
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-80},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Base class for controller for mass flows of hydrogen and SNG of PtG-plants in superstructure</p>
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
end ControlPowerToGas_Base;
