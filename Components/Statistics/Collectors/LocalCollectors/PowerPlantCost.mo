within TransiEnt.Components.Statistics.Collectors.LocalCollectors;
model PowerPlantCost "Cost model for conventional thermal or renewable power plants"

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
  //            Imports
  // _____________________________________________

  // set everything to final such that options which are not needed dont cloud up the parameter dialog
  extends CollectCostsGeneral(
    final observationPeriod=simCenter.Duration,
    final interestRate=simCenter.InterestRate,
    final priceChangeRateInv=simCenter.priceChangeRateInv,
    final priceChangeRateDemand=simCenter.priceChangeRateDemand,
    final priceChangeRateOM=simCenter.priceChangeRateOM,
    final priceChangeRateOther=simCenter.priceChangeRateOther,
    final priceChangeRateRevenue=simCenter.priceChangeRateRevenue,
    final lifeTime=costRecordGeneral.lifeTime,
    final Cspec_inv_der_E=costRecordGeneral.Cspec_inv_der_E,
    final Cspec_inv_E=costRecordGeneral.Cspec_inv_E,
    final size1=costRecordGeneral.size1,
    final size2=costRecordGeneral.size2,
    final C_inv_size=costRecordGeneral.C_inv_size,
    final factor_OM=costRecordGeneral.factor_OM,
    final Cspec_OM_W_el=costRecordGeneral.Cspec_OM_W_el,
    final Cspec_OM_Q=costRecordGeneral.Cspec_OM_Q,
    final Cspec_OM_H=costRecordGeneral.Cspec_OM_H,
    final Cspec_OM_other=costRecordGeneral.Cspec_OM_other,
    final C_other_fix=costRecordGeneral.C_other_fix,
    redeclare model CostRecordGeneral = PowerPlantCostModel,
    final Cspec_demAndRev_el=simCenter.Cspec_demAndRev_free,
    final Cspec_demAndRev_heat=simCenter.Cspec_demAndRev_free,
    final Cspec_demAndRev_other=simCenter.Cspec_demAndRev_other_free,
    final Cspec_CO2=simCenter.C_CO2,
    final P_el=P_el_is,
    final W_el_demand(start=0),
    final W_el_revenue(start=0),
    final Q_flow=Q_flow_internal,
    final Q_demand(start=0),
    final Q_revenue(start=0),
    final H_demand(start=0),
    final H_revenue(start=0),
    final other_flow=0,
    final other_demand(start=0),
    final other_revenue(start=0),
    final m_CDE(start=0),
    final m_flow_CDE=m_flow_CDE_is,
    final der_E_n=P_n,
    final E_n=0,
    final Cspec_demAndRev_gas_fuel=costRecordGeneral.Cspec_fuel,
    final H_flow=Q_flow_fuel_is);

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  replaceable model PowerPlantCostModel =        TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.BrownCoal constrainedby TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PartialPowerPlantCostSpecs
                                                                                                                     "Choose preconfigured model or press button to change details"              annotation(choicesAllMatching=true);

  parameter Modelica.SIunits.Power P_n(displayUnit="W")= 300e6 "Nominal Power in W";

  // Protected internal parameters will be used (overwritten) by child class 'CogenerationPlantCost'
protected
      Real A_alloc_power_internal = 1 "Allocation parameter (1 for electric plants, 0...1 for cogeneration plants";
      SI.HeatFlowRate Q_flow_internal = 0 "Will be overwritten by CogenerationPlants";

  // _____________________________________________
  //
  //         Variables appearing in dialog
  // _____________________________________________

public
  SI.ActivePower P_el_is=0 "Electric power generation of plant" annotation(Dialog(group="Variables"));
  SI.EnthalpyFlowRate Q_flow_fuel_is=0 "Enthalpy rate of consumed fuel" annotation(Dialog(group="Variables"));
  SI.MassFlowRate m_flow_CDE_is=Q_flow_fuel_is*costRecordGeneral.m_flow_CDEspec_fuel "Produced CDE mass flow" annotation(Dialog(group="Variables"));

  // _____________________________________________
  //
  //   Variables for power plant cost diagnostics
  // _____________________________________________

  TransiEnt.Basics.Units.MonetaryUnitPerEnergy LCOE=C/max(simCenter.E_small, W_el_demand)*3.6e9*A_alloc_power_internal "Levelized cost of electricity";
  TransiEnt.Basics.Units.MonetaryUnit C_fuel(displayUnit="EUR") = H_demand*Cspec_demAndRev_gas_fuel "Fuel costs";
  TransiEnt.Basics.Units.MonetaryUnit C_CO2_Certificates(displayUnit="EUR") = Cspec_CO2*m_CDE "Fuel costs";

end PowerPlantCost;
