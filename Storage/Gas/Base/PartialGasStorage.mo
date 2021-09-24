within TransiEnt.Storage.Gas.Base;
partial model PartialGasStorage


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

  import TransiEnt;
  import      Modelica.Units.SI;

  extends TransiEnt.Basics.Icons.StorageGenericGas;
  extends MatchClassGasStorage;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter SI.SpecificEnthalpy[medium.nc] NCV=TransiEnt.Basics.Functions.GasProperties.getRealGasNCVVector(medium, medium.nc) "NCV of gas components";
  final parameter SI.SpecificEnthalpy[medium.nc] GCV=TransiEnt.Basics.Functions.GasProperties.getRealGasGCVVector(medium, medium.nc) "GCV of gas component";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Medium in the gas storage" annotation(Dialog(group="Fundamental Definitions"),choicesAllMatching);
  parameter SI.Volume V_geo=1 "geometric inner volume of the storage cylinder" annotation(Dialog(group="Geometry"));
  parameter SI.Mass m_gas_start=1e5 "Initial mass in the storage" annotation(Dialog(group="Initialization"));
  parameter Boolean calculateCost=simCenter.calculateCost "true if cost shall be calculated"  annotation (Dialog(group="Statistics"));
  parameter Boolean includeHeatTransfer=true "consider heat transfer" annotation(Dialog(group="Fundamental Definitions"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn(Medium=medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,49})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-63})));
  TransiEnt.Basics.Interfaces.General.PressureOut p_gas annotation (Placement(transformation(extent={{-40,-10},{-60,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heat if includeHeatTransfer annotation (Placement(transformation(extent={{30,-10},{50,10}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable model CostSpecsStorage = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Empty
                                                                                                     constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs
                                                                                                                                                                                            "General Storage Cost Record" annotation(Dialog(group="Statistics"),choicesAllMatching);
protected
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectCostsGeneral collectCosts_Storage(
    redeclare model CostRecordGeneral = CostSpecsStorage (size1=V_geo),
    der_E_n=0,
    E_n=0,
    produces_P_el=false,
    consumes_P_el=false,
    produces_Q_flow=false,
    consumes_Q_flow=false,
    produces_H_flow=false,
    consumes_H_flow=false,
    produces_other_flow=false,
    consumes_other_flow=false,
    produces_m_flow_CDE=false,
    consumes_m_flow_CDE=false)
           annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

public
  SI.Mass m_gas(start=m_gas_start) "Gas mass";
  SI.MassFraction xi_gas[medium.nc-1] "Gas composition";
  SI.EnergyFlowRate H_flow_in_NCV "Inflowing enthalpy flow based on NCV";
  SI.EnergyFlowRate H_flow_out_NCV "Inflowing enthalpy flow based on NCV";
  SI.Enthalpy H_gas_NCV "Enthalpy of the gas bulk based on NCV";
  SI.EnergyFlowRate H_flow_in_GCV "Inflowing enthalpy flow based on GCV";
  SI.EnergyFlowRate H_flow_out_GCV "Inflowing enthalpy flow based on GCV";
  SI.Enthalpy H_gas_GCV "Enthalpy of the gas bulk based on GCV";


equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________


  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(collectCosts_Storage.costsCollector, modelStatistics.costsCollector);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is a partial model for simple gas storage for real gases.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">3. Limits of validity</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>gasPortIn and gasPortOut: Real gas input and output</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>No validation necessary because only fundamental equations are used.</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Schülting (oliver.schuelting@tuhh.de), Dec 2018</p>
</html>"));
end PartialGasStorage;
