within TransiEnt.Components.Gas.Engines.Base;
partial model PartialEngine_idealGas "Base class for engines with necessary connectors"
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  import TransiEnt;
  extends TransiEnt.Basics.Icons.Engine;

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //        Constants and Parameters
  // _____________________________________________
  final parameter SI.HeatFlowRate Q_flow_out_max=Specification.Q_flow_out_max "Maximum heat flow rate in W" annotation (Dialog(tab="Technical Specifications"));
  final parameter SI.HeatFlowRate Q_flow_out_min=Specification.Q_flow_out_min "Maximum heat flow rate in W" annotation (Dialog(tab="Technical Specifications"));
  final parameter SI.Power P_el_max=Specification.P_el_max "Maximum power output in W" annotation (Dialog(tab="Technical Specifications"));
  final parameter SI.Power P_el_min=Specification.P_el_min "Minimum power output in W" annotation (Dialog(tab="Technical Specifications"));

  //Engine parameters
  final parameter SI.Volume engineDisplacement=Specification.engineDisplacement;
  final parameter Integer n_cylinder=Specification.n_cylinder;
  final parameter SI.Conversions.NonSIunits.AngularVelocity_rpm n_n=Specification.n_n;
  final parameter SI.AngularVelocity omega_n=Specification.omega_n;
  final parameter SI.CoefficientOfHeatTransfer k=Specification.k;
  final parameter SI.Area A=Specification.width*Specification.height*2 + Specification.length*Specification.height*2 + Specification.width*Specification.length;
  final parameter SI.Mass m_engine=Specification.m_engine "Approximate mass of motor" annotation (Dialog(tab="Technical Specifications"));
  final parameter SI.ThermalConductivity thermalConductivity=Specification.thermalConductivity "Thermal conductivity between core and mantle";

  //Efficiencies
  final parameter SI.Efficiency eta_el_max=Specification.eta_el_max "Electrical efficiency" annotation (Dialog(tab="Technical Specifications"));
  final parameter SI.Efficiency eta_el_min=Specification.eta_el_min "Electrical efficiency at P_el_min" annotation (Dialog(tab="Technical Specifications"));
  final parameter SI.Efficiency eta_h_max=Specification.eta_h_max "Total efficiency at P_el_min" annotation (Dialog(tab="Technical Specifications"));
  final parameter SI.Efficiency eta_h_min=Specification.eta_h_min "Total efficiency at P_el_max" annotation (Dialog(tab="Technical Specifications"));

   //Temperatures
  final parameter SI.Temperature T_opt=Specification.T_opt "Optimal temperature for maximum efficiency";
  parameter SI.Temperature T_site=290 "Average ambient temperature at plant site" annotation (Dialog(group="Stanby losses"));

  inner parameter TransiEnt.Producer.Combined.SmallScaleCHP.Base.BaseCHPSpecification Specification annotation (choicesAllMatching);

  // _____________________________________________
  //
  //               Variable Declarations
  // _____________________________________________

  SI.HeatFlowRate Q_flow_fuel(start=1) "Heat flow rate input from fuel";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.General.MechanicalPowerPort mpp annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-87},{110,-67}})));
  Modelica.Blocks.Interfaces.RealInput P_el_set annotation (Placement(transformation(extent={{-128,-20},{-88,20}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-98,0})));
  Modelica.Blocks.Interfaces.BooleanInput switch annotation (Placement(transformation(extent={{-128,-70},{-88,-30}}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-98,-50})));

  TransiEnt.Basics.Interfaces.Gas.IdealGasEnthPortOut gasPortOut(Medium=ExhaustGas) annotation (Placement(transformation(extent={{-110,80},{-90,100}}), iconTransformation(extent={{-110,80},{-90,100}})));
  TransiEnt.Basics.Interfaces.Gas.IdealGasEnthPortIn gasPortIn(Medium=FuelMedium) annotation (Placement(transformation(extent={{-110,30},{-90,50}}), iconTransformation(extent={{-110,30},{-90,50}})));

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=simCenter.fluid1) annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut(Medium=simCenter.fluid1) annotation (Placement(transformation(extent={{80,-110},{100,-90}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  replaceable function efficiencyFunction =
  TransiEnt.Basics.Functions.efficiency_linear constrainedby TransiEnt.Basics.Functions.efficiency_base "Efficiency of the heater";

  TILMedia.GasTypes.BaseGas FuelMedium = simCenter.gasModel2;
  TILMedia.GasTypes.BaseGas ExhaustGas = simCenter.exhaustGasModel;

equation
  assert(P_el_set<=Specification.P_el_max,"Your CHP controller appears to be chosen incorrectly.");

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                 Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end PartialEngine_idealGas;
