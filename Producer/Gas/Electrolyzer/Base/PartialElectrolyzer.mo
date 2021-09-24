within TransiEnt.Producer.Gas.Electrolyzer.Base;
partial model PartialElectrolyzer "partial class for electrolyzer"


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

  extends TransiEnt.Basics.Icons.Electrolyser2;
  extends TransiEnt.Producer.Heat.Base.PartialHeatProvision(       T_out_coolant_target=68+273.15);

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
public
  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;
  replaceable model CostSpecsGeneral = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.Empty
                                                                                                      constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs
                                                                                                                                                                                             "General Cost Record" annotation(Dialog(group="Statistics"),choicesAllMatching);

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________


  final parameter SI.MassFraction xi_out[medium.nc-1]=zeros(medium.nc-1);
  final parameter SI.SpecificEnergy NCV_H2[:]=TransiEnt.Basics.Functions.GasProperties.getRealGasNCVVector(medium, medium.nc) "Net calorific value of hydrogen at 25 C and 1 bar";
  final parameter SI.SpecificEnergy GCV_H2[:]=TransiEnt.Basics.Functions.GasProperties.getRealGasGCVVector(medium, medium.nc) "Gross calorific value of hydrogen at 25 C and 1 bar";
  final parameter SI.SpecificEnthalpy h0= TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(medium, 1e5, 298.15) "Specific enthalpy at 25 C and 1 bar";
  parameter EnergyResource typeOfResource=EnergyResource.Consumer "Type of energy resource for global model statistics";

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel3 "Medium model" annotation (Dialog(group="Fundamental Definitions"));
  parameter Boolean usePowerPort=true "True if power port shall be used" annotation (Dialog(group="Replaceable Components"));
  parameter SI.ActivePower P_el_n "Nominal power of the electrolyzer" annotation(Dialog(group="Fundamental Definitions"));
  parameter SI.ActivePower P_el_max "Maximum power of the electrolyzer" annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean integrateH2Flow=false "true if hydrogen mass flow shall be integrated" annotation (Dialog(group="Statistics"));
  parameter Boolean integrateElPower=simCenter.integrateElPower "true if electric powers shall be integrated" annotation (Dialog(group="Statistics"));
  parameter Boolean calculateCost=simCenter.calculateCost "true if cost shall be calculated"  annotation (Dialog(group="Statistics"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_el=simCenter.Cspec_demAndRev_free "Specific demand-related cost per electric energy" annotation (Dialog(group="Statistics"));
  parameter Real Cspec_demAndRev_other=simCenter.Cspec_demAndRev_other_free "Specific demand-related cost per cubic meter water" annotation (Dialog(group="Statistics"));
  parameter SI.Temperature T_out=283.15 "Hydrogen output temperature" annotation(Dialog(group="Fundamental Definitions"));

  // _____________________________________________
  //
  //              Variable Declarations
  // _____________________________________________

  SI.HeatFlowRate Q_flow "waste heat";
  SI.Power P_el "Electric power consumed by the electrolyzer";
  SI.MassFlowRate m_flow_H2O "water mass flow rate into the electrolyzer";

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________


  replaceable TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort  epp if usePowerPort constrainedby TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort  "Choice of power port" annotation(choicesAllMatching=true, Dialog(group="Replaceable Components"), Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=P_el) if usePowerPort annotation (Placement(transformation(extent={{-72,52},{-52,72}})));
  replaceable TransiEnt.Components.Boundaries.Electrical.ActivePower.Power powerBoundary if
                                                                                usePowerPort constrainedby TransiEnt.Components.Boundaries.Electrical.ActivePower.Power              "Choice of power boundary model. The power boundary model must match the power port." annotation (
    choices(choice(redeclare TransiEnt.Components.Boundaries.Electrical.ActivePower.Power powerBoundary "PowerBoundary for ActivePowerPort"), choice(redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=1) "Power Boundary for ComplexPowerPort")),
    Dialog(group="Replaceable Components"),
    Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-28,40})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortOut gasPortOut(Medium=medium) annotation (Placement(transformation(extent={{90,-10},{110,10}})));

protected
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=typeOfResource, integrateElPower=integrateElPower)
                                                                                                                                      annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectCostsGeneral collectCosts(
    redeclare model CostRecordGeneral = CostSpecsGeneral,
    der_E_n=P_el_n,
    E_n=0,
    Cspec_demAndRev_el=Cspec_demAndRev_el,
    Cspec_demAndRev_other=Cspec_demAndRev_other,
    P_el=P_el,
    other_flow=m_flow_H2O,
    produces_P_el=false,
    produces_Q_flow=false,
    consumes_Q_flow=false,
    produces_H_flow=false,
    consumes_H_flow=false,
    produces_other_flow=false,
    produces_m_flow_CDE=false,
    consumes_m_flow_CDE=false,
    calculateCost=calculateCost)
                             annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
public
  TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluid_pT vleFluidH2(
    vleFluidType=medium,
    computeSurfaceTension=false,
    deactivateDensityDerivatives=true,
    deactivateTwoPhaseRegion=true,
    p=gasPortOut.p,
    T=T_out,
    xi=xi_out) annotation (Placement(transformation(extent={{76,10},{96,30}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  T_out_coolant_max=T_out_coolant_target;
  Q_flow_heatprovision=Q_flow;

    //Collectors
  collectElectricPower.powerCollector.P = P_el;

  connect(powerBoundary.epp,epp)  annotation (Line(
      points={{-38,40},{-60,40},{-60,0},{-100,0}},
      color={0,135,135},
      thickness=0.5));
  connect(realExpression.y,powerBoundary. P_el_set) annotation (Line(points={{-51,62},{-34,62},{-34,52}}, color={0,0,127}));
  connect(modelStatistics.powerCollector[typeOfResource],collectElectricPower.powerCollector);
  connect(modelStatistics.costsCollector, collectCosts.costsCollector);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008300\">1. Purpose of model</span></h4>
<p>Partial class for electrolyzer</p>
<h4><span style=\"color: #008300\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008300\">3. Limits of validity </span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008300\">4. Interfaces</span></h4>
<p>gasPortOut: gas port for hydrogen</p>
<p>PowerPort epp: power port for electric power </p>
<h4><span style=\"color: #008300\">5. Nomenclature</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008300\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008300\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008300\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008300\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008300\">10. Version History</span></h4>
<p>Created by Jan Westphal (j.westphal@tuhh.de), dec 2019 </p>
</html>"));
end PartialElectrolyzer;
