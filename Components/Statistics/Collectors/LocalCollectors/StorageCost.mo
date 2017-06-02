within TransiEnt.Components.Statistics.Collectors.LocalCollectors;
model StorageCost "Generatl storage cost model (can be used by all kinds of storages)"

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
    redeclare model CostRecordGeneral = StorageCostModel,
    final Cspec_demAndRev_el=simCenter.Cspec_demAndRev_free,
    final Cspec_demAndRev_heat=simCenter.Cspec_demAndRev_free,
    final Cspec_demAndRev_other=simCenter.Cspec_demAndRev_other_free,
    final Cspec_CO2=simCenter.C_CO2,
    final P_el=P_el_is,
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
    final m_CDE(start=0),
    final m_flow_CDE=0,
    final der_E_n=if isThermalStorage then Q_flow_n else P_n,
    final E_n=Delta_E_n,
    final Cspec_demAndRev_gas_fuel=0,
    final H_flow=0,
    final C_OM_fix=der_E_n * costRecordGeneral.Cspec_fixOM);

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  replaceable model StorageCostModel =        TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.ElectricStorageGeneral constrainedby TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.PartialStorageCostSpecs
                                                                                                                     "Choose preconfigured model or press button to change details"              annotation(choicesAllMatching=true);

  parameter Boolean isThermalStorage = false  annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true));
  parameter Modelica.SIunits.Power P_n(displayUnit="W")= 300e6 "Nominal Power in W" annotation(Dialog(enable=not isThermalStorage));
  parameter Modelica.SIunits.Power Q_flow_n(displayUnit="W")= 300e6 "Nominal Power in W" annotation(Dialog(enable=isThermalStorage));
  parameter Modelica.SIunits.Energy Delta_E_n=0 "Nominal storage capacity (E_max - E_min)";

  // _____________________________________________
  //
  //         Variables appearing in dialog
  // _____________________________________________

  SI.ActivePower P_el_is=0 "Electric power generation of storage" annotation(Dialog(group="Variables",enable=not isThermalStorage));
  SI.EnthalpyFlowRate Q_flow_is=0 "Thermal power generation of storage" annotation(Dialog(group="Variables",enable=isThermalStorage));

end StorageCost;
