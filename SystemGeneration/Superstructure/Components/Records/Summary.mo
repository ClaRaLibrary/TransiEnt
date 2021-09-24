within TransiEnt.SystemGeneration.Superstructure.Components.Records;
record Summary "A summary of relevant values"

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
  extends Modelica.Icons.Record;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  //-----               Inputs               -----
  SI.Power P_set_powerPlants annotation (Dialog);
  SI.Power P_set_PtG annotation (Dialog);
  SI.Power P_set_electricStorages annotation (Dialog);
  SI.Power P_set_electricHeaters annotation (Dialog);
  SI.Power P_set_curtailment annotation (Dialog);

  //-----        Electric Production         -----
  SI.Power electricProduction_powerplants_P annotation (Dialog);
  SI.Power electricProduction_renewables_biomass_P annotation (Dialog);
  SI.Power electricProduction_renewables_windOnShore_P annotation (Dialog);
  SI.Power electricProduction_renewables_windOffShore_P annotation (Dialog);
  SI.Power electricProduction_renewables_photovoltaic_P annotation (Dialog);

  //-----        Electric Consumption        -----
  SI.Power electricConsumption_localDemand_P annotation (Dialog);
  SI.Power electricConsumption_localHeating_P annotation (Dialog);
  SI.Power electricConsumption_PtG_P annotation (Dialog);
  SI.Power electricConsumption_heatingGrid_P annotation (Dialog);
  SI.Power electricConsumption_DAC_P annotation (Dialog);

  //-----          Gas Production            -----
  SI.MassFlowRate gasProduction_renewables_biogas_m_flow annotation (Dialog);
  SI.MassFlowRate gasProduction_PtG_m_flow annotation (Dialog);

  //-----          Gas Consumption           -----
  SI.MassFlowRate gasConsumption_localHeating_m_flow annotation (Dialog);
  SI.MassFlowRate gasConsumption_localDirectUse_m_flow annotation (Dialog);
  SI.MassFlowRate gasConsumption_powerPlants_m_flow annotation (Dialog);
  SI.MassFlowRate gasConsumption_heatingGrid_m_flow annotation (Dialog);

  //-----          Storage States            -----
  SI.Energy storages_electricStorages_E annotation (Dialog);
  SI.Mass storages_gasStorage_m annotation (Dialog);
  //SI.Mass storages_CO2Storage_m annotation (Dialog);

  SI.Power storages_electricStorages_P annotation (Dialog);
  SI.MassFlowRate storages_gasStorage_m_flow annotation (Dialog);
  //SI.MassFlowRate storages_CO2Storage_m_flow annotation (Dialog);

  //----               CO2                  ----
  SI.MassFlowRate CO2Sytem_fromPowerPlants_m_flow annotation (Dialog);
  SI.MassFlowRate CO2Sytem_toPtG_m_flow annotation (Dialog);

//    //-----  Reactive power -----
//    SI.ReactivePower electricReactiveBalance_powerplants_Q annotation (Dialog);
//    SI.ReactivePower electricReactiveBalance_PtG_Q annotation (Dialog);
//    SI.ReactivePower electricReactiveBalance_localDemand_Q annotation (Dialog);
//    SI.ReactivePower electricReactiveBalance_electricStorages_Q annotation (Dialog);
//    SI.ReactivePower electricReactiveBalance_DAC_Q annotation (Dialog);
//    SI.ReactivePower electricReactiveBalance_heatingGrid_Q annotation (Dialog);
//    SI.ReactivePower electricReactiveBalance_renewables_Q annotation (Dialog);

  //-----  Heat  -----
  SI.HeatFlowRate HeatFlow_localHeatingDemand annotation (Dialog);
  SI.HeatFlowRate HeatFlow_solarthermalProduction annotation (Dialog);

  //-----          Boundary States            -----
  SI.Frequency eppBoundary_f annotation (Dialog);
  SI.Voltage eppBoundary_v annotation (Dialog);
  SI.Power eppBoundray_P annotation (Dialog);
  SI.ReactivePower eppBoundary_Q annotation (Dialog);

  SI.Pressure gasBoundary_p annotation (Dialog);
  SI.MassFlowRate gasBoundary_m_flow annotation (Dialog);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end Summary;
