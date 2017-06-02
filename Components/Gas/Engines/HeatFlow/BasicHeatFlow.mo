within TransiEnt.Components.Gas.Engines.HeatFlow;
partial model BasicHeatFlow "Partial heat transfer model for gas engine"

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  extends TransiEnt.Basics.Icons.HeatFlowModel;

  // _____________________________________________
  //
  //        Visible Parameters
  // _____________________________________________
  parameter ClaRa.Basics.Units.PressureDifference Delta_p_nom=1e5 "Nominal pressure drop";
  parameter Modelica.SIunits.MassFlowRate m_flow_nom=simCenter.m_flow_nom "Nominal mass flow rates at inlet";

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer TransiEnt.SimCenter simCenter;
  outer parameter TransiEnt.Producer.Combined.SmallScaleCHP.Base.BaseCHPSpecification Specification "Record containing specific chp parameters";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________
  Modelica.Blocks.Interfaces.RealInput P_el_set annotation (Placement(transformation(extent={{-220,40},{-180,80}}), iconTransformation(extent={{-220,40},{-180,80}})));
  Modelica.Blocks.Interfaces.BooleanInput switch annotation (Placement(transformation(extent={{-226,-80},{-186,-40}}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-200,-40})));
  Modelica.Blocks.Interfaces.RealInput[2] efficiencies "[1] = eta_el, [2] = eta_h" annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-80,166}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-76,160})));
  Modelica.Blocks.Interfaces.RealOutput[2] TemperaturesOut "[1] inner engine, [2] outer engine" annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={100,168}),  iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={90,160})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=simCenter.fluid1) annotation (Placement(transformation(extent={{220,-120},{240,-100}}), iconTransformation(extent={{200,-140},{240,-100}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut(Medium=simCenter.fluid1) annotation (Placement(transformation(extent={{220,120},{240,140}}), iconTransformation(extent={{200,100},{240,140}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________
  //Efficiencies
  SI.Efficiency eta_el = efficiencies[1] "Electrical efficiency";
  SI.Efficiency eta_h = efficiencies[2] "Overall efficiency";
  //Heat flow rates
  SI.HeatFlowRate Q_flow_engine "Usable heat flow from engine cooling cycle";
  SI.HeatFlowRate Q_flow_exhaust "Usable heat flow from exhaust";
  SI.HeatFlowRate Q_flow_out "Total usable heat flow fed into the grid";
  SI.HeatFlowRate Q_flow_loss "Total heat flow losses to the environment";
  SI.HeatFlowRate Q_flow_loss_room "Heat flow losses to the room";
  SI.HeatFlowRate Q_flow_loss_exhaust "Heat flow loss due to exhaust losses";
  SI.HeatFlowRate Q_flow_engine_tot "Total heat flow from engine";

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-160},{220,160}})),
                                          Icon(coordinateSystem(extent={{-200,-160},{220,160}}, preserveAspectRatio=false)));
end BasicHeatFlow;