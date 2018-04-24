within TransiEnt.Components.Statistics.Collectors.LocalCollectors;
model HeatingPlantCost "Cost model for conventional thermal or renewable power plants generating heat"

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
    redeclare model CostRecordGeneral = HeatingPlantCostModel,
    final Cspec_demAndRev_el=simCenter.Cspec_demAndRev_free,
    final Cspec_demAndRev_heat=simCenter.Cspec_demAndRev_free,
    final Cspec_demAndRev_other=simCenter.Cspec_demAndRev_other_free,
    final Cspec_CO2=simCenter.C_CO2,
    final P_el=0,
    final W_el_demand(start=0),
    final W_el_revenue(start=0),
    final Q_flow=Q_flow_is,
    final Q_demand(start=0),
    final Q_revenue(start=0),
    final H_demand(start=0),
    final H_revenue(start=0),
    final other_flow=0,
    final other_demand(start=0),
    final other_revenue(start=0),
    final m_CDE_consumed(start=0),
    final m_CDE_produced(start=0),
    final m_flow_CDE=m_flow_CDE_is,
    final der_E_n=Q_flow_n,
    final E_n=0,
    final Cspec_demAndRev_gas_fuel=costRecordGeneral.Cspec_fuel,
    final H_flow=Q_flow_fuel_is,
    final produces_P_el=false,
    final consumes_P_el=false,
    final produces_Q_flow=true,
    final consumes_Q_flow=false,
    final produces_H_flow=false,
    final produces_other_flow=false,
    final consumes_other_flow=false,
    final consumes_m_flow_CDE=false);

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  replaceable model HeatingPlantCostModel =        TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.BrownCoal constrainedby TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PartialPowerPlantCostSpecs
                                                                                                                     "Choose preconfigured model or press button to change details"              annotation(choicesAllMatching=true);

  parameter Modelica.SIunits.Power Q_flow_n(displayUnit="W")= 300e6 "Nominal Power in W";

  // _____________________________________________
  //
  //         Variables appearing in dialog
  // _____________________________________________

  SI.ActivePower Q_flow_is=0 "Thermal power generation of plant" annotation(Dialog(group="Variables"));
  SI.EnthalpyFlowRate Q_flow_fuel_is=0 "Enthalpy rate of consumed fuel" annotation(Dialog(group="Variables"));
  SI.MassFlowRate m_flow_CDE_is=Q_flow_fuel_is*costRecordGeneral.m_flow_CDEspec_fuel "Produced CDE mass flow" annotation(Dialog(group="Variables"));

  // _____________________________________________
  //
  //   Variables for power plant cost diagnostics
  // _____________________________________________

  TransiEnt.Basics.Units.MonetaryUnitPerEnergy LCOH=C/max(simCenter.E_small, Q_demand)*3.6e9 "Levelized cost of heat";
  TransiEnt.Basics.Units.MonetaryUnit C_fuel(displayUnit="EUR") = H_demand*Cspec_demAndRev_gas_fuel "Fuel costs";
  TransiEnt.Basics.Units.MonetaryUnit C_CO2_Certificates(displayUnit="EUR") = Cspec_CO2*m_CDE_produced "Fuel costs";

end HeatingPlantCost;
