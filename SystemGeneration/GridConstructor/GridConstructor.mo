within TransiEnt.SystemGeneration.GridConstructor;
model GridConstructor

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




  // Model block for declaration, parametrisation and connection of n Basic_Grid_Elements to a straight coupled grid beam
  // The n Basic_Grid_Elements are declared and parametrised in the model array Basic_Grid_Elements[n_elements]
  // Every Basic_Grid_Element in the Basic_Grid_Elements[n_elements] array can be parametrised individually by the following approach

  // Every parameter or sub model of the Basic_Grid_Element model can be propagated to the top level of the Grid_Constructor model
  // It can than be set in the parameter window of the Grid_Constructor
  // To assign individual values to a parameter of the Basic_Grid_Element model for individual Basic_Grid_Elements in the Basic_Grid_Elements[n_elements]array,
  // a parameter vector with the respective values for the parameter is used
  // The parameter vector is than passed to the Basic_Grid_Elements[n_elements]array declaration, where the value at the first/second/... position in the parameter vector
  // is assigned to the first/second/... Basic_Grid_Element in the Basic_Grid_Elements[n_elements]array

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.SystemGeneration.GridConstructor.Base.PartialGridCell;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

  // Choose path to csv. or txt. file containing consecutive load-profile triples  (electric, heat, heat for hot water) for any number of buildings
  replaceable model Demand_Consumer_1 = TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_Table_combined constrainedby TransiEnt.Basics.Tables.Combined.CombinedTables.Base.Demand_combined "Load-profile data table for buildings in upper row" annotation (
    choicesAllMatching=true,
    Dialog(tab="Consumer"),
    Placement(transformation(extent={{-8,12},{12,32}})));
  replaceable model Demand_Consumer_2 = TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_Table_combined constrainedby TransiEnt.Basics.Tables.Combined.CombinedTables.Base.Demand_combined "Load-profile data table for buildings in lower row" annotation (
    choicesAllMatching=true,
    Dialog(tab="Consumer", enable=second_row),
    Placement(transformation(extent={{-8,12},{12,32}})));

  parameter Integer start_c1=1 "Number of column in table Demand_Consumer_1 from which the assignment of load-profile data starts" annotation (Dialog(tab="Consumer"));
  parameter Integer start_c2=1 "Number of column in table Demand_Consumer_2 from which the assignment of load-profile data starts" annotation (Dialog(enable=second_row, tab="Consumer"));

  parameter Integer n_elements=1 "|System layout|Number of basic grid elements" annotation (HideResult=true);

  parameter Boolean second_row=false "|System layout|Activate second row of consumers" annotation (
    choices(__Dymola_checkBox=true),
    Dialog(group="System layout"),
    HideResult=true);

public
  final parameter Integer n_consumer=n_elements + TransiEnt.Basics.Functions.calc_true_booleans(second_Consumer, n_elements) "Number of consumers inside a GridConstructor";

  // Technology parameters in Systems models
  parameter TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix Technologies_1[30]={TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix() for i in 1:30} "Technologies in upper row" annotation (Dialog(group="Systems"), HideResult=true);
  parameter TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix Technologies_2[30]={TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix() for i in 1:30} "Technologies in lower row" annotation (Dialog(group="Systems", enable=second_row), HideResult=true);

  parameter TransiEnt.SystemGeneration.GridConstructor.DataRecords.BoilerParameters BoilerParameters_1[30]={TransiEnt.SystemGeneration.GridConstructor.DataRecords.BoilerParameters() for i in 1:30} "Boiler parameters" annotation (Dialog(tab="Boiler"), HideResult=true);
  parameter TransiEnt.SystemGeneration.GridConstructor.DataRecords.BoilerParameters BoilerParameters_2[30]={TransiEnt.SystemGeneration.GridConstructor.DataRecords.BoilerParameters() for i in 1:30} "Boiler parameters" annotation (Dialog(tab="Boiler", enable=second_row), HideResult=true);

  parameter TransiEnt.SystemGeneration.GridConstructor.DataRecords.PVParameters PVParameters_1[30]={TransiEnt.SystemGeneration.GridConstructor.DataRecords.PVParameters() for i in 1:30} "PV parameters" annotation (Dialog(tab="PV"), HideResult=true);
  parameter TransiEnt.SystemGeneration.GridConstructor.DataRecords.PVParameters PVParameters_2[30]={TransiEnt.SystemGeneration.GridConstructor.DataRecords.PVParameters() for i in 1:30} "PV parameters" annotation (Dialog(tab="PV", enable=second_row), HideResult=true);

  parameter TransiEnt.SystemGeneration.GridConstructor.DataRecords.HeatPumpParameters HeatPumpParameters_1[30]={TransiEnt.SystemGeneration.GridConstructor.DataRecords.HeatPumpParameters() for i in 1:30} "Heat pump parameters in upper row" annotation (Dialog(tab="HeatPump"), HideResult=true);
  parameter TransiEnt.SystemGeneration.GridConstructor.DataRecords.HeatPumpParameters HeatPumpParameters_2[30]={TransiEnt.SystemGeneration.GridConstructor.DataRecords.HeatPumpParameters() for i in 1:30} "Heat pump parameters lower row" annotation (Dialog(tab="HeatPump", enable=second_row), HideResult=true);

  parameter TransiEnt.SystemGeneration.GridConstructor.DataRecords.ConsumerParameters Scaling_factor_consumer_1[30]={TransiEnt.SystemGeneration.GridConstructor.DataRecords.ConsumerParameters() for i in 1:30} "Consumer parameters and scaling factors in upper row" annotation (Dialog(tab="Consumer"), HideResult=true);
  parameter TransiEnt.SystemGeneration.GridConstructor.DataRecords.ConsumerParameters Scaling_factor_consumer_2[30]={TransiEnt.SystemGeneration.GridConstructor.DataRecords.ConsumerParameters() for i in 1:30} "Consumer parameters and scaling factors lower row" annotation (Dialog(tab="Consumer", enable=second_row), HideResult=true);
  parameter Real cosphi[:]=fill(simCenter.cosphi, n_elements) "Reactive power factor" annotation (Dialog(tab="Consumer", group="Electrical"), HideResult=true);

  parameter TransiEnt.SystemGeneration.GridConstructor.DataRecords.CHPParameters CHPParameters_1[30]={TransiEnt.SystemGeneration.GridConstructor.DataRecords.CHPParameters() for i in 1:30} "CHP parameters in upper row" annotation (Dialog(tab="CHP"), HideResult=true);
  parameter TransiEnt.SystemGeneration.GridConstructor.DataRecords.CHPParameters CHPParameters_2[30]={TransiEnt.SystemGeneration.GridConstructor.DataRecords.CHPParameters() for i in 1:30} "CHP parameters lower row" annotation (Dialog(tab="CHP", enable=second_row), HideResult=true);

  parameter TransiEnt.SystemGeneration.GridConstructor.DataRecords.SolarHeatingParameters SolarHeatingParameters_1[30]={TransiEnt.SystemGeneration.GridConstructor.DataRecords.SolarHeatingParameters() for i in 1:30} "Solar heating parameters in upper row" annotation (Dialog(tab="SolarThermal"), HideResult=true);
  parameter TransiEnt.SystemGeneration.GridConstructor.DataRecords.SolarHeatingParameters SolarHeatingParameters_2[30]={TransiEnt.SystemGeneration.GridConstructor.DataRecords.SolarHeatingParameters() for i in 1:30} "Solar heating parameters lower row" annotation (Dialog(tab="SolarThermal", enable=second_row), HideResult=true);

  parameter TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters CablePipeParameters[30]={TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters() for i in 1:30} "Parameters of cables and piping" annotation (Dialog(tab="Cables and Piping"), HideResult=true);

  parameter Boolean second_Consumer[:]=fill(false, n_elements) "Activate/deactivate buildings in second row" annotation (Dialog(group="System layout", enable=second_row), HideResult=true);

  //Global PV parameters
public
  parameter Real lambda=simCenter.lambda "degree of longitude of location" annotation (Dialog(tab="PV", group="Location parameters"), HideResult=true);
  parameter Real phi=simCenter.phi "degree of latitude of location" annotation (Dialog(tab="PV", group="Location parameters"), HideResult=true);
  parameter Real timezone=simCenter.timezone "timezone of location (UTC+) - for Hamburg timezone=1" annotation (Dialog(tab="PV", group="Location parameters"), HideResult=true);

  //Global Solar heating parameters
  parameter SI.Angle latitude_ST=simCenter.phi "latitude of the local position, north posiive, 53,55 North for Hamburg" annotation (Dialog(tab="SolarThermal", group="Location parameters"), HideResult=true);
  parameter SI.Angle longitude_standard_ST=simCenter.timezone*15 "needed for calculation of coordinated universal time (utc), 15 for central european time, 30 for central european summer time" annotation (Dialog(tab="SolarThermal", group="Location parameters"), HideResult=true);
  parameter SI.Angle longitude_ST=simCenter.lambda "longitude of the local position, east positive, 10 East for Hamburg" annotation (Dialog(tab="SolarThermal", group="Location parameters"), HideResult=true);

  //Global Heat pump parameters
  SI.Temperature T_source_ground=simCenter.T_ground "Temperature of ground as heat source" annotation (Dialog(tab="HeatPump", group="Source temperature"), HideResult=true);
  SI.Temperature T_source_ambient=simCenter.ambientConditions.temperature.value + 273.15 "Temperature of ambient air as heat source" annotation (Dialog(tab="HeatPump", group="Source temperature"), HideResult=true);
  SI.Temperature T_source_constant=283.15 "Constant heat source temperature" annotation (Dialog(tab="HeatPump", group="Source temperature"), HideResult=true);
  SI.Temperature T_source_other=283.15 "Other heat source temperature" annotation (Dialog(tab="HeatPump", group="Source temperature"), HideResult=true);

protected
  parameter Integer PV_1[:]=Technologies_1.PV annotation (HideResult=true);
  parameter Integer El_Consumer_1[:]=Technologies_1.El_Consumer annotation (HideResult=true);
  parameter Integer CHP_1[:]=Technologies_1.CHP annotation (HideResult=true);
  parameter Integer HeatPump_1[:]=Technologies_1.heatPump annotation (HideResult=true);
  parameter Integer Boiler_1[:]=Technologies_1.Boiler annotation (HideResult=true);
  parameter Integer DHN_1[:]=Technologies_1.DHN annotation (HideResult=true);
  parameter Integer ST_1[:]=Technologies_1.ST annotation (HideResult=true);
  parameter Integer NSH_1[:]=Technologies_1.NSH annotation (HideResult=true);
  parameter Integer Oil_1[:]=Technologies_1.Oil annotation (HideResult=true);
  parameter Integer Biomass_1[:]=Technologies_1.Biomass annotation (HideResult=true);

  parameter Integer PV_2[:]=Technologies_2.PV annotation (HideResult=true);
  parameter Integer El_Consumer_2[:]=Technologies_2.El_Consumer annotation (HideResult=true);
  parameter Integer CHP_2[:]=Technologies_2.CHP annotation (HideResult=true);
  parameter Integer HeatPump_2[:]=Technologies_2.heatPump annotation (HideResult=true);
  parameter Integer Boiler_2[:]=Technologies_2.Boiler annotation (HideResult=true);
  parameter Integer DHN_2[:]=Technologies_2.DHN annotation (HideResult=true);
  parameter Integer ST_2[:]=Technologies_2.ST annotation (HideResult=true);
  parameter Integer NSH_2[:]=Technologies_2.NSH annotation (HideResult=true);
  parameter Integer Oil_2[:]=Technologies_2.Oil annotation (HideResult=true);
  parameter Integer Biomass_2[:]=Technologies_2.Biomass annotation (HideResult=true);

  parameter Real cosphi_boundary_c1[:]=cosphi "Reactive power factor" annotation (Dialog(tab="El_Consumer"), HideResult=true);
  parameter Real cosphi_boundary_c2[:]=cosphi "Reactive power factor" annotation (Dialog(tab="El_Consumer", enable=second_row), HideResult=true);

  parameter Real factor_heat_c1[:]=Scaling_factor_consumer_1.factor_heat "scaling factor for heat demand" annotation (Dialog(tab="El_Consumer"), HideResult=true);
  parameter Real factor_heat_c2[:]=Scaling_factor_consumer_2.factor_heat "scaling factor for heat demand" annotation (Dialog(tab="El_Consumer", enable=second_row), HideResult=true);
  parameter Real factor_electricity_c1[:]=Scaling_factor_consumer_1.factor_electricity "scaling factor for electricity demand" annotation (Dialog(tab="El_Consumer"), HideResult=true);
  parameter Real factor_electricity_c2[:]=Scaling_factor_consumer_2.factor_electricity "scaling factor for electricity demand" annotation (Dialog(tab="El_Consumer", enable=second_row), HideResult=true);
  parameter Real factor_warmwater_c1[:]=Scaling_factor_consumer_1.factor_warmwater "scaling factor for warmwater demand" annotation (Dialog(tab="El_Consumer"), HideResult=true);
  parameter Real factor_warmwater_c2[:]=Scaling_factor_consumer_2.factor_warmwater "scaling factor for warmwater demand" annotation (Dialog(tab="El_Consumer", enable=second_row), HideResult=true);

  parameter ClaRa.Basics.Units.Length diameter_i[:]=CablePipeParameters.diameter_i "Inner diameter of the pipe segments in the Basic_Grid_Elements" annotation (Dialog(tab="Cables and Piping"), HideResult=true);
  parameter SI.Length l[:]=CablePipeParameters.l_cable "Length of the cable segments in the Basic_Grid_Elements" annotation (Dialog(tab="Cables and Piping"), HideResult=true);
  parameter ClaRa.Basics.Units.Length length[:]=CablePipeParameters.l_pipe "Length of the gas pipe segments in the Basic_Grid_Elements" annotation (Dialog(tab="Cables and Piping"), HideResult=true);

  parameter TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes CableType[:]=CablePipeParameters.CableType "Type of low voltage cable in the Basic_Grid_Elements" annotation (Dialog(tab="Cables and Piping"), HideResult=true);

  //Boiler parameters
  parameter SI.Efficiency eta_boiler_c1[:]=BoilerParameters_1.eta "Boiler's overall efficiency" annotation (Dialog(tab="Boiler"), HideResult=true);
  parameter SI.Efficiency eta_boiler_c2[:]=BoilerParameters_2.eta "Boiler's overall efficiency" annotation (Dialog(tab="Boiler", enable=second_row), HideResult=true);

  //PV parameters
  parameter SI.Power P_inst_PV_c1[:]=PVParameters_1.P_inst annotation (Dialog(tab="PV"), HideResult=true);
  parameter SI.Power P_inst_PV_c2[:]=PVParameters_2.P_inst annotation (Dialog(tab="PV", enable=second_row), HideResult=true);

  parameter SI.Power Tilt_PV_c1[:]=PVParameters_1.Tilt annotation (Dialog(tab="PV"), HideResult=true);
  parameter SI.Power Tilt_PV_c2[:]=PVParameters_2.Tilt annotation (Dialog(tab="PV", enable=second_row), HideResult=true);

  parameter SI.Power Azimuth_PV_c1[:]=PVParameters_1.Azimuth annotation (Dialog(tab="PV"), HideResult=true);
  parameter SI.Power Azimuth_PV_c2[:]=PVParameters_2.Azimuth annotation (Dialog(tab="PV", enable=second_row), HideResult=true);

  parameter SI.Energy E_max_PV_battery_c1[:]=PVParameters_1.E_max_battery annotation (Dialog(tab="PV"), HideResult=true);
  parameter SI.Energy E_max_PV_battery_c2[:]=PVParameters_2.E_max_battery annotation (Dialog(tab="PV", enable=second_row), HideResult=true);

  parameter SI.Energy E_min_PV_battery_c1[:]=PVParameters_1.E_min_battery annotation (Dialog(tab="PV"), HideResult=true);
  parameter SI.Energy E_min_PV_battery_c2[:]=PVParameters_2.E_min_battery annotation (Dialog(tab="PV", enable=second_row), HideResult=true);

  parameter SI.Power P_load_PV_battery_c1[:]=PVParameters_1.P_battery annotation (Dialog(tab="PV"), HideResult=true);
  parameter SI.Power P_load_PV_battery_c2[:]=PVParameters_2.P_battery annotation (Dialog(tab="PV", enable=second_row), HideResult=true);

  parameter Real eta_load_PV_battery_c1[:]=PVParameters_1.eta_load_battery annotation (Dialog(tab="PV"), HideResult=true);
  parameter Real eta_load_PV_battery_c2[:]=PVParameters_2.eta_load_battery annotation (Dialog(tab="PV", enable=second_row), HideResult=true);

  parameter SI.Frequency selfDischargeRate_PV_battery_c1[:]=PVParameters_1.selfDischargeRate_battery annotation (Dialog(tab="PV"), HideResult=true);
  parameter SI.Frequency selfDischargeRate_PV_battery_c2[:]=PVParameters_2.selfDischargeRate_battery annotation (Dialog(tab="PV", enable=second_row), HideResult=true);

  parameter String PVModuleCharacteristics_c1[:]=PVParameters_1.PVModuleCharacteristics annotation (HideResult=true);
  parameter String PVModuleCharacteristics_c2[:]=PVParameters_2.PVModuleCharacteristics annotation (HideResult=true);

  parameter String RadiationData_PV_c1[:]=PVParameters_1.Radiation_data annotation (HideResult=true);
  parameter String RadiationData_PV_c2[:]=PVParameters_2.Radiation_data annotation (HideResult=true);

  parameter Boolean simple_PV_c1[:]=PVParameters_1.simple_PV annotation (HideResult=true);
  parameter Boolean simple_PV_c2[:]=PVParameters_2.simple_PV annotation (HideResult=true);

  //CHP parameters
  parameter SI.Efficiency eta_total_CHP_c1[:]=CHPParameters_1.eta_total_CHP "CHP overall efficiency" annotation (Dialog(tab="CHP"), HideResult=true);
  parameter SI.Efficiency eta_total_CHP_c2[:]=CHPParameters_2.eta_total_CHP "CHP overall efficiency" annotation (Dialog(tab="CHP", enable=second_row), HideResult=true);

  parameter SI.Efficiency eta_boiler_CHP_c1[:]=CHPParameters_1.eta_boiler "Boiler efficiency of CHP system" annotation (Dialog(tab="CHP"), HideResult=true);
  parameter SI.Efficiency eta_boiler_CHP_c2[:]=CHPParameters_2.eta_boiler "Boiler efficiency of CHP system" annotation (Dialog(tab="CHP", enable=second_row), HideResult=true);

  parameter SI.Power Q_CHP_c1[:]=CHPParameters_1.Q_CHP "Heat output of CHP" annotation (Dialog(tab="CHP"), HideResult=true);
  parameter SI.Power Q_CHP_c2[:]=CHPParameters_2.Q_CHP "Heat output of CHP" annotation (Dialog(
      tab="CHP",
      enable=second_row,
      HideResult=true));

  parameter SI.Power P_CHP_c1[:]=CHPParameters_1.P_CHP "Electric power output of CHP" annotation (Dialog(tab="CHP"), HideResult=true);
  parameter SI.Power P_CHP_c2[:]=CHPParameters_2.P_CHP "Electric power output of CHP" annotation (Dialog(tab="CHP", enable=second_row), HideResult=true);

  parameter SI.Temperature T_s_max_CHP_c1[:]=CHPParameters_1.T_storage_max "Maximum storage temperature of CHP system" annotation (Dialog(tab="CHP"), HideResult=true);
  parameter SI.Temperature T_s_max_CHP_c2[:]=CHPParameters_2.T_storage_max "Maximum storage temperature of CHP system" annotation (Dialog(tab="CHP", enable=second_row), HideResult=true);

  parameter SI.Temperature T_s_min_CHP_c1[:]=CHPParameters_1.T_storage_min "Minimum storage temperature" annotation (Dialog(tab="CHP"), HideResult=true);
  parameter SI.Temperature T_s_min_CHP_c2[:]=CHPParameters_2.T_storage_min "Minimum storage temperature" annotation (Dialog(tab="CHP", enable=second_row), HideResult=true);

  parameter SI.Volume V_s_CHP_c1[:]=CHPParameters_1.V_storage "Volume of the Storage" annotation (Dialog(tab="CHP"), HideResult=true);
  parameter SI.Volume V_s_CHP_c2[:]=CHPParameters_2.V_storage "Volume of the Storage" annotation (Dialog(tab="CHP", enable=second_row), HideResult=true);

  parameter SI.Height h_s_CHP_c1[:]=CHPParameters_1.h_storage "Height of heat storage" annotation (Dialog(tab="CHP"), HideResult=true);
  parameter SI.Height h_s_CHP_c2[:]=CHPParameters_2.h_storage "Height of heat storage" annotation (Dialog(tab="CHP", enable=second_row), HideResult=true);

  parameter Modelica.Units.NonSI.Temperature_degC T_s_amb_CHP_c1[:]=CHPParameters_1.T_storage_amb "Assumed constant temperature in tank installation room" annotation (Dialog(tab="CHP"), HideResult=true);
  parameter Modelica.Units.NonSI.Temperature_degC T_s_amb_CHP_c2[:]=CHPParameters_2.T_storage_amb "Assumed constant temperature in tank installation room" annotation (Dialog(tab="CHP", enable=second_row), HideResult=true);

  parameter SI.SurfaceCoefficientOfHeatTransfer k_s_CHP_c1[:]=CHPParameters_1.k_storage "Coefficient of heat Transfer" annotation (Dialog(tab="CHP"), HideResult=true);
  parameter SI.SurfaceCoefficientOfHeatTransfer k_s_CHP_c2[:]=CHPParameters_2.k_storage "Coefficient of heat Transfer" annotation (Dialog(tab="CHP", enable=second_row), HideResult=true);

  //Heat pump parameters
  parameter SI.HeatFlowRate Q_flow_n_HP_c1[:]=HeatPumpParameters_1.Q_flow_n "Nominal heat flow of heat pump at nominal conditions according to EN14511" annotation (Dialog(tab="HeatPump"), HideResult=true);
  parameter SI.HeatFlowRate Q_flow_n_HP_c2[:]=HeatPumpParameters_2.Q_flow_n "Nominal heat flow of heat pump at nominal conditions according to EN14511" annotation (Dialog(tab="HeatPump", enable=second_row), HideResult=true);

  parameter Real COP_n_HP_c1[:]=HeatPumpParameters_1.COP_n "Heat pump coefficient of performance at nominal conditions according to EN14511" annotation (HideResult=true);
  parameter Real COP_n_HP_c2[:]=HeatPumpParameters_2.COP_n "Heat pump coefficient of performance at nominal conditions according to EN14511" annotation (HideResult=true);

  parameter SI.Temperature T_s_min_HP_c1[:]=HeatPumpParameters_1.T_storage_min "Minimum storage temperature of heat pump system" annotation (HideResult=true);
  parameter SI.Temperature T_s_min_HP_c2[:]=HeatPumpParameters_2.T_storage_min "Minimum storage temperature of heat pump system" annotation (HideResult=true);

  parameter SI.Temperature T_s_max_HP_c1[:]=HeatPumpParameters_1.T_storage_max "Maximum storage temperature of heat pump system" annotation (HideResult=true);
  parameter SI.Temperature T_s_max_HP_c2[:]=HeatPumpParameters_2.T_storage_max "Maximum storage temperature of heat pump system" annotation (HideResult=true);

  parameter Modelica.Units.NonSI.Temperature_degC T_s_amb_HP_c1[:]=HeatPumpParameters_1.T_storage_amb "Assumed constant temperature in tank installation room in heat pump system" annotation (HideResult=true);
  parameter Modelica.Units.NonSI.Temperature_degC T_s_amb_HP_c2[:]=HeatPumpParameters_2.T_storage_amb "Assumed constant temperature in tank installation room in heat pump system" annotation (HideResult=true);

  parameter SI.Volume V_s_HP_c1[:]=HeatPumpParameters_1.V_storage "Volume of the storage of heat pump system" annotation (HideResult=true);
  parameter SI.Volume V_s_HP_c2[:]=HeatPumpParameters_2.V_storage "Volume of the storage of heat pump system" annotation (HideResult=true);

  parameter SI.Height h_s_HP_c1[:]=HeatPumpParameters_1.h_storage "Height of heat storage in heat pump system" annotation (HideResult=true);
  parameter SI.Height h_s_HP_c2[:]=HeatPumpParameters_2.h_storage "Height of heat storage in heat pump system" annotation (HideResult=true);

  parameter SI.SurfaceCoefficientOfHeatTransfer k_s_HP_c1[:]=HeatPumpParameters_1.k_storage "Coefficient of heat transfer through tank surface in heat pump system" annotation (HideResult=true);
  parameter SI.SurfaceCoefficientOfHeatTransfer k_s_HP_c2[:]=HeatPumpParameters_2.k_storage "Coefficient of heat transfer through tank surface in heat pump system" annotation (HideResult=true);

  parameter String T_source_HP_c1[:]=HeatPumpParameters_1.T_source "Temperature of heat source" annotation (HideResult=true);
  parameter String T_source_HP_c2[:]=HeatPumpParameters_2.T_source "Temperature of heat source" annotation (HideResult=true);

  parameter SI.Power P_el_backup_HP_c1[:]=HeatPumpParameters_1.P_el_backup "Nominal electric power of the backup heater" annotation (HideResult=true);
  parameter SI.Power P_el_backup_HP_c2[:]=HeatPumpParameters_2.P_el_backup "Nominal electric power of the backup heater" annotation (HideResult=true);

  //Solar heating parameters
  parameter Boolean SpaceHeating_c1[:]=SolarHeatingParameters_1.SpaceHeating "Does the solar heating system provide energy for space heating?" annotation (Dialog(tab="SolarHeating"), HideResult=true);
  parameter Boolean SpaceHeating_c2[:]=SolarHeatingParameters_2.SpaceHeating "Does the solar heating system provide energy for space heating?" annotation (Dialog(tab="SolarHeating", enable=second_row), HideResult=true);

  parameter SI.Temperature T_return_ST_c1[:]=SolarHeatingParameters_1.T_return "Return temperature of the heating system" annotation (Dialog(tab="SolarHeating"), HideResult=true);
  parameter SI.Temperature T_return_ST_c2[:]=SolarHeatingParameters_2.T_return "Return temperature of the heating system" annotation (Dialog(tab="SolarHeating", enable=second_row), HideResult=true);

  parameter SI.Temperature A_ST_c1[:]=SolarHeatingParameters_1.area "Aperture area" annotation (Dialog(tab="SolarHeating"), HideResult=true);
  parameter SI.Temperature A_ST_c2[:]=SolarHeatingParameters_2.area "Aperture area" annotation (Dialog(tab="SolarHeating", enable=second_row), HideResult=true);

  parameter SI.Temperature T_set_ST_c1[:]=SolarHeatingParameters_1.T_set "Temperature set point for controller" annotation (Dialog(tab="SolarHeating"), HideResult=true);
  parameter SI.Temperature T_set_ST_c2[:]=SolarHeatingParameters_2.T_set "Temperature set point for controller" annotation (Dialog(tab="SolarHeating", enable=second_row), HideResult=true);

  parameter SI.Temperature T_max_ST_c1[:]=SolarHeatingParameters_1.T_max "maximum input temperature for collector switch-off" annotation (Dialog(tab="SolarHeating"), HideResult=true);
  parameter SI.Temperature T_max_ST_c2[:]=SolarHeatingParameters_2.T_max "maximum input temperature for collector switch-off" annotation (Dialog(tab="SolarHeating", enable=second_row), HideResult=true);

  parameter SI.Volume V_ST_c1[:]=SolarHeatingParameters_1.V "Volume of the storage tank" annotation (Dialog(tab="SolarHeating"), HideResult=true);
  parameter SI.Volume V_ST_c2[:]=SolarHeatingParameters_2.V "Volume of the storage tank" annotation (Dialog(tab="SolarHeating", enable=second_row), HideResult=true);

  parameter Real eta_boiler_ST_c1[:]=SolarHeatingParameters_1.eta_boiler "efficiency of the boiler" annotation (Dialog(tab="SolarHeating"), HideResult=true);
  parameter Real eta_boiler_ST_c2[:]=SolarHeatingParameters_2.eta_boiler "efficiency of the boiler" annotation (Dialog(tab="SolarHeating"), HideResult=true);

  parameter SI.Angle slope_ST_c1[:]=SolarHeatingParameters_1.slope "slope of the tilted surface, assumption" annotation (Dialog(tab="SolarHeating"), HideResult=true);
  parameter SI.Angle slope_ST_c2[:]=SolarHeatingParameters_2.slope "slope of the tilted surface, assumption" annotation (Dialog(tab="SolarHeating"), HideResult=true);

  parameter SI.Angle azimuth_ST_c1[:]=SolarHeatingParameters_1.azimuth "Surface azimuth angle" annotation (Dialog(tab="SolarHeating"), HideResult=true);
  parameter SI.Angle azimuth_ST_c2[:]=SolarHeatingParameters_2.azimuth "Surface azimuth angle" annotation (Dialog(tab="SolarHeating"), HideResult=true);

  parameter SI.Temperature T_set_boiler_ST_c1[:]=SolarHeatingParameters_1.T_set_boiler "Temperature set point for controller" annotation (Dialog(tab="SolarHeating"), HideResult=true);
  parameter SI.Temperature T_set_boiler_ST_c2[:]=SolarHeatingParameters_2.T_set_boiler "Temperature set point for controller" annotation (Dialog(tab="SolarHeating", enable=second_row), HideResult=true);

  parameter TransiEnt.Basics.Types.FuelType fuel_boiler_ST_c1[:]=SolarHeatingParameters_1.fuel "Fuel used in boiler" annotation (Dialog(tab="SolarHeating"), HideResult=true);
  parameter TransiEnt.Basics.Types.FuelType fuel_boiler_ST_c2[:]=SolarHeatingParameters_2.fuel "Fuel used in boiler" annotation (Dialog(tab="SolarHeating", enable=second_row), HideResult=true);

  // parameter gaspipe switches off gas pipes if no gas technology is present
  // to make model solveable, last element in grid needs to have gas pipe regardless of presence of gas technology
  parameter Integer gaspipe[:]=if Basic_Grid_Elements[1].Systems_1.onlyElectric then fill(0, n_elements) else Technologies_1.CHP + Technologies_1.Boiler + Technologies_2.CHP + Technologies_2.Boiler + {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1} annotation (HideResult=true);
  parameter Integer gaspipe_add1[n_elements]=cat(
      1,
      gaspipe[1:n_elements - 1],
      {1}) annotation (HideResult=true);

public
  parameter TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters DHNParameters_Main[30]={TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters() for i in 1:30} "Parameters of main pipes" annotation (Dialog(tab="DHN", HideResult=true));
  parameter TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters DHNParameters_Consumer_1[30]={TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters() for i in 1:30} "Parameters of house pipes for top Consumer" annotation (Dialog(tab="DHN", HideResult=true));
  parameter TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters DHNParameters_Consumer_2[30]={TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters() for i in 1:30} "Parameters of house pipes for bottom Consumer" annotation (Dialog(tab="DHN", HideResult=true));

  ///--- Initialization
protected
  parameter ClaRa.Basics.Units.Temperature dhn_T_start_supply=simCenter.T_supply "Temperature at start of the simulation. Only used to calculate h_nom and h_start" annotation (Dialog(tab="DHN", group="Initialisation"), HideResult=true);
  parameter ClaRa.Basics.Units.Temperature dhn_T_start_return=simCenter.T_return "Temperature at start of the simulation. Only used to calculate h_nom and h_start" annotation (Dialog(tab="DHN", group="Initialisation"), HideResult=true);
  parameter ClaRa.Basics.Units.Pressure dhn_p_start_supply=simCenter.p_nom[2] "Pressure in supply at start of the simulation" annotation (Dialog(tab="DHN", group="Initialisation"), HideResult=true);
  parameter ClaRa.Basics.Units.Pressure dhn_p_start_return=simCenter.p_nom[1] "Pressure in supply at start of the simulation" annotation (Dialog(tab="DHN", group="Initialisation"), HideResult=true);
public
  parameter ClaRa.Basics.Units.ThermalConductivity dhn_lambda_insulation[:]=fill(0.023, n_elements) "Thermal conductivity of insulation material" annotation (Dialog(tab="DHN", group="HeatTransfer"), HideResult=true);

protected
  parameter Integer activate_consumer_pipes=simCenter.activate_consumer_pipes "Activate / Deactivate house pipes for faster simulation. 1 = house pipes activated" annotation (
    Dialog(tab="DHN"),
    group="Initialisation",
    choices(__Dymola_checkBox=true),
    HideResult=true);

public
  replaceable model HeatTransfer = TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Base.HT_Single_Buried_L2 constrainedby TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Base.HT_PlugFlow_Base_L2 "HeatTransfer-Model choice for district heating" annotation (
    choicesAllMatching=true,
    Dialog(tab="DHN", group="HeatTransfer"),
    Placement(transformation(extent={{-8,12},{12,32}})));

protected
  parameter Integer dhnpipe[:]=Technologies_1.DHN + Technologies_2.DHN annotation (HideResult=true);
  parameter Integer dhnpipe_c1[:]=Technologies_1.DHN annotation (HideResult=true);
  parameter Integer dhnpipe_c2[:]=Technologies_2.DHN annotation (HideResult=true);
  parameter Integer dhnpipe_add1[:]=cat(
      1,
      dhnpipe[1:n_elements - 1],
      {dhnpipe[n_elements]}) annotation (HideResult=true);
  parameter Boolean dhn_hidden_connectors=if sum(dhnpipe_c1) > 0 then true else false "Deactiavates the waterports connecting each gridelement inside the GC if no DHN is used" annotation (HideResult=true);

  parameter SI.Length dhn_length_main[:]=DHNParameters_Main.length annotation (HideResult=true);
  parameter Integer dhnpipe_DN_main[:]=DHNParameters_Main.DN annotation (HideResult=true);

  //Consumer_1
  parameter SI.Length dhn_length_Consumer_1[:]=DHNParameters_Consumer_1.length annotation (HideResult=true);
  parameter Integer dhnpipe_DN_Consumer_1[:]=DHNParameters_Consumer_1.DN annotation (HideResult=true);

  //Consumer_2
  parameter SI.Length dhn_length_Consumer_2[:]=DHNParameters_Consumer_2.length annotation (HideResult=true);
  parameter Integer dhnpipe_DN_Consumer_2[:]=DHNParameters_Consumer_2.DN annotation (HideResult=true);

  // _____________________________________________
  //
  //          VISUALIZATION
  // _____________________________________________

  // Sets color of circles used in Icon
protected
  parameter Real color_1=if not second_row then 255 else 28;
  parameter Real color_2=if not second_row then 255 else 108;
  parameter Real color_3=if not second_row then 255 else 200;

  // _____________________________________________
  //
  //          Instances of Other Classes
  // _____________________________________________

  // Every building in the upper/lower row of each Basic_Grid_Element gets the same Systems model with a predefined selection of technologies
  // The selection of technologies which shall be active in each building can then be finalized by the boolean parameter vectors Technologies_1 and Technologies_2

public
  replaceable model Systems_Consumer_1 = TransiEnt.SystemGeneration.GridConstructor.IndependentTechnologies constrainedby TransiEnt.SystemGeneration.GridConstructor.Base.PartialTechnologies
                                                                                                                                                                     "Systems model for buildings in upper row" annotation (
    choicesAllMatching=true,
    Dialog(group="Systems"),
    Placement(transformation(extent={{-8,12},{12,32}})));

  replaceable model Systems_Consumer_2 = TransiEnt.SystemGeneration.GridConstructor.IndependentTechnologies constrainedby TransiEnt.SystemGeneration.GridConstructor.Base.PartialTechnologies
                                                                                                                                                                     "Systems model for buildings in lower row (if onlyElectric selected in upper row, it needs to be onlyElectric in this row, too)" annotation (
    choicesAllMatching=true,
    Dialog(group="Systems", enable=second_row),
    Placement(transformation(extent={{-8,12},{12,32}})));

  // Declaration of the Basic_Grid_Elements[n_elements] array containing n_elements Basic_Grid_Element models
  // Individual parametrization of the n_elements Basic_Grid_Elements by using the parameter vectors above:

  TransiEnt.SystemGeneration.GridConstructor.GridElement Basic_Grid_Elements[n_elements](
    cable(l=l, CableType=CableType),
    el_in=fill(el_in, n_elements),
    el_out=cat(
        1,
        fill(true, n_elements - 1),
        {el_out}),
    gas_in=fill(gas_in, n_elements),
    gas_out=cat(
        1,
        fill(true, n_elements - 1),
        {gas_out}),
    dhn_in_s=fill(dhn_in_s, n_elements),
    dhn_out_s=cat(
        1,
        fill(dhn_hidden_connectors, n_elements - 1),
        {dhn_out_s}),
    dhn_in_r=cat(
        1,
        fill(dhn_hidden_connectors, n_elements - 1),
        {dhn_in_r}),
    dhn_out_r=fill(dhn_out_r, n_elements),
    dhn_main_pipe=cat(
        1,
        dhnpipe[1:n_elements - 1],
        {dhnpipe[n_elements]}),
    dhn_consumer_1=cat(
        1,
        dhnpipe_c1[1:n_elements - 1],
        {dhnpipe_c1[n_elements]}),
    dhn_consumer_2=cat(
        1,
        dhnpipe_c2[1:n_elements - 1],
        {dhnpipe_c2[n_elements]}),
    second_Consumer=second_Consumer,
    gas_pipe=gaspipe_add1,
    each activate_consumer_pipes=activate_consumer_pipes,
    gas_Pipe(
      length=length,
      diameter_i=diameter_i,
      each frictionAtInlet=true),
    redeclare model Systems_Consumer_1 = Systems_Consumer_1 (
        useGasPort=gas_in,
        El_Consumer=El_Consumer_1,
        Boiler=Boiler_1,
        CHP=CHP_1,
        HeatPump=HeatPump_1,
        PV=PV_1,
        DHN=DHN_1,
        ST=ST_1,
        NSH=NSH_1,
        Oil=Oil_1,
        Biomass=Biomass_1,
        cosphi_boundary=cosphi_boundary_c1,
        eta_boiler=eta_boiler_c1,
        P_inst_PV=P_inst_PV_c1,
        Tilt_PV=Tilt_PV_c1,
        Azimuth_PV=Azimuth_PV_c1,
        PVModuleCharacteristics=PVModuleCharacteristics_c1,
        E_max_PV=E_max_PV_battery_c1,
        E_min_PV=E_min_PV_battery_c1,
        P_load_PV=P_load_PV_battery_c1,
        eta_load_battery_PV=eta_load_PV_battery_c1,
        selfDischargeRate_battery=selfDischargeRate_PV_battery_c1,
        Radiation_data=RadiationData_PV_c1,
        simple_PV=simple_PV_c1,
        eta_CHP=eta_total_CHP_c1,
        eta_boiler_CHP=eta_boiler_CHP_c1,
        Q_CHP=Q_CHP_c1,
        P_CHP=P_CHP_c1,
        T_s_max_CHP=T_s_max_CHP_c1,
        T_s_min_CHP=T_s_min_CHP_c1,
        V_s_CHP=V_s_CHP_c1,
        h_s_CHP=h_s_CHP_c1,
        T_s_amb_CHP=T_s_amb_CHP_c1,
        k_s_CHP=k_s_CHP_c1,
        Q_flow_n_HP=Q_flow_n_HP_c1,
        COP_n_HP=COP_n_HP_c1,
        T_s_min_HP=T_s_min_HP_c1,
        T_s_max_HP=T_s_max_HP_c1,
        T_s_amb_HP=T_s_amb_HP_c1,
        T_source_type_HP=T_source_HP_c1,
        P_el_backup_HP=P_el_backup_HP_c1,
        V_s_HP=V_s_HP_c1,
        h_s_HP=h_s_HP_c1,
        k_s_HP=k_s_HP_c1,
        T_set_ST=T_set_ST_c1,
        area_ST=A_ST_c1,
        T_max_ST=T_max_ST_c1,
        V_ST=V_ST_c1,
        T_return_ST=T_return_ST_c1,
        T_set_boiler_ST=T_set_boiler_ST_c1,
        fuel_ST=fuel_boiler_ST_c1,
        SpaceHeating=SpaceHeating_c1,
        eta_Boiler_ST=eta_boiler_ST_c1,
        azimuth_ST=azimuth_ST_c1,
        slope_ST=slope_ST_c1,
        each phi_PV=phi,
        each lambda_PV=lambda,
        each timezone_PV=timezone,
        each latitude_ST=latitude_ST,
        each longitude_local_ST=longitude_ST,
        each longitude_standard_ST=longitude_standard_ST,
        each T_source_ground=T_source_ground,
        each T_source_ambient=T_source_ambient,
        each T_source_constant=T_source_constant,
        each T_source_other=T_source_other),
    redeclare model Systems_Consumer_2 = Systems_Consumer_2 (
        useGasPort=gas_in,
        El_Consumer=El_Consumer_2,
        Boiler=Boiler_2,
        CHP=CHP_2,
        HeatPump=HeatPump_2,
        PV=PV_2,
        DHN=DHN_2,
        ST=ST_2,
        NSH=NSH_2,
        Oil=Oil_2,
        Biomass=Biomass_2,
        cosphi_boundary=cosphi_boundary_c2,
        eta_boiler=eta_boiler_c2,
        P_inst_PV=P_inst_PV_c2,
        Tilt_PV=Tilt_PV_c2,
        Azimuth_PV=Azimuth_PV_c2,
        PVModuleCharacteristics=PVModuleCharacteristics_c2,
        E_max_PV=E_max_PV_battery_c2,
        E_min_PV=E_min_PV_battery_c2,
        P_load_PV=P_load_PV_battery_c2,
        eta_load_battery_PV=eta_load_PV_battery_c2,
        selfDischargeRate_battery=selfDischargeRate_PV_battery_c2,
        Radiation_data=RadiationData_PV_c2,
        simple_PV=simple_PV_c2,
        eta_CHP=eta_total_CHP_c2,
        eta_boiler_CHP=eta_boiler_CHP_c2,
        Q_CHP=Q_CHP_c2,
        P_CHP=P_CHP_c2,
        T_s_max_CHP=T_s_max_CHP_c2,
        T_s_min_CHP=T_s_min_CHP_c2,
        V_s_CHP=V_s_CHP_c2,
        h_s_CHP=h_s_CHP_c2,
        T_s_amb_CHP=T_s_amb_CHP_c2,
        k_s_CHP=k_s_CHP_c2,
        Q_flow_n_HP=Q_flow_n_HP_c2,
        COP_n_HP=COP_n_HP_c2,
        T_s_min_HP=T_s_min_HP_c2,
        T_s_max_HP=T_s_max_HP_c2,
        T_s_amb_HP=T_s_amb_HP_c2,
        T_source_type_HP=T_source_HP_c2,
        P_el_backup_HP=P_el_backup_HP_c2,
        V_s_HP=V_s_HP_c2,
        h_s_HP=h_s_HP_c2,
        k_s_HP=k_s_HP_c2,
        T_set_ST=T_set_ST_c2,
        area_ST=A_ST_c2,
        T_max_ST=T_max_ST_c2,
        V_ST=V_ST_c2,
        T_return_ST=T_return_ST_c2,
        T_set_boiler_ST=T_set_boiler_ST_c2,
        fuel_ST=fuel_boiler_ST_c2,
        SpaceHeating=SpaceHeating_c2,
        eta_Boiler_ST=eta_boiler_ST_c2,
        azimuth_ST=azimuth_ST_c2,
        slope_ST=slope_ST_c2,
        each phi_PV=phi,
        each lambda_PV=lambda,
        each timezone_PV=timezone,
        each latitude_ST=latitude_ST,
        each longitude_local_ST=longitude_ST,
        each longitude_standard_ST=longitude_standard_ST,
        each T_source_ground=T_source_ground,
        each T_source_ambient=T_source_ambient,
        each T_source_constant=T_source_constant,
        each T_source_other=T_source_other),
    main_dhn_pipe(
      redeclare model HeatTransfer = HeatTransfer,
      DN=dhnpipe_DN_main,
      length=dhn_length_main,
      lambda_insulation=dhn_lambda_insulation,
      each p_start_supply=dhn_p_start_supply,
      each T_start_supply=dhn_T_start_supply,
      each p_start_return=dhn_p_start_return,
      each T_start_return=dhn_T_start_return),
    house_pipe_Consumer_1(
      redeclare model HeatTransfer = HeatTransfer,
      DN=dhnpipe_DN_Consumer_1,
      lambda_insulation=dhn_lambda_insulation,
      each p_start_supply=dhn_p_start_supply,
      each T_start_supply=dhn_T_start_supply,
      each p_start_return=dhn_p_start_return,
      each T_start_return=dhn_T_start_return),
    house_pipe_Consumer_2(
      redeclare model HeatTransfer = HeatTransfer,
      DN=dhnpipe_DN_Consumer_2,
      lambda_insulation=dhn_lambda_insulation,
      each p_start_supply=dhn_p_start_supply,
      each T_start_supply=dhn_T_start_supply,
      each p_start_return=dhn_p_start_return,
      each T_start_return=dhn_T_start_return),
    redeclare model Demand_Consumer_2 = Demand_Consumer_2 (
        consumer_count={i for i in start_c2:(n_elements + start_c2 - 1)},
        heatDemand=factor_heat_c2,
        waterDemand=factor_warmwater_c2,
        electricityDemand=factor_electricity_c2),
    redeclare model Demand_Consumer_1 = Demand_Consumer_1 (
        consumer_count={i for i in start_c1:(n_elements + start_c1 - 1)},
        heatDemand=factor_heat_c1,
        waterDemand=factor_warmwater_c1,
        electricityDemand=factor_electricity_c1)) annotation (Placement(transformation(extent={{-54,-14},{-22,16}})));

equation

  // _____________________________________________
  //
  //            Connect statements
  // _____________________________________________

  // Connect the outer Basic_Grid_Elements in the Basic_Grid_Elements[n_elements]array to the connectors of the Grid_Constructor taking into account which connectors are active
  // Connect all inner Basic_Grid_Elements in the Basic_Grid_Elements[n_elements]array taking into account which connectors are still active

  if gas_in then
    connect(gasPortIn, Basic_Grid_Elements[1].gasPortIn) annotation (Line(
        points={{-180,60},{-134,60},{-134,4},{-128,4},{-128,5.5},{-54,5.5}},
        color={255,255,0},
        thickness=1.5));

    for i in 1:n_elements - 1 loop

      connect(Basic_Grid_Elements[i].gasPortOut, Basic_Grid_Elements[i + 1].gasPortIn);

    end for;

  end if;

  if gas_out then

    connect(Basic_Grid_Elements[n_elements].gasPortOut, gasPortOut);

  end if;

  if el_in then
    connect(epp_p, Basic_Grid_Elements[1].epp_p) annotation (Line(
        points={{-180,-60},{-134,-60},{-134,-3.5},{-54,-3.5}},
        color={0,127,0},
        thickness=0.5));

    for i in 1:n_elements - 1 loop

      connect(Basic_Grid_Elements[i].epp_n, Basic_Grid_Elements[i + 1].epp_p);

    end for;

  end if;

  if el_out then

    connect(Basic_Grid_Elements[n_elements].epp_n, epp_n);

  end if;

  if (dhn_in_s or dhn_out_s or dhn_out_r or dhn_in_r) then
    for i in 1:n_elements - 1 loop
      connect(Basic_Grid_Elements[i].waterPortOut_supply, Basic_Grid_Elements[i + 1].waterPortIn_supply);
      connect(Basic_Grid_Elements[i].waterPortIn_return, Basic_Grid_Elements[i + 1].waterPortOut_return);
    end for;
  end if;

  if dhn_in_s then
    connect(waterPortIn_supply, Basic_Grid_Elements[1].waterPortIn_supply) annotation (Line(
        points={{-180,20},{-150,20},{-150,2},{-124,2},{-124,2.5},{-54,2.5}},
        color={175,0,0},
        thickness=0.5));
  end if;

  if dhn_out_r then
    connect(waterPortOut_return, Basic_Grid_Elements[1].waterPortOut_return) annotation (Line(
        points={{-180,-20},{-150,-20},{-150,0},{-136,0},{-136,-0.5},{-54,-0.5}},
        color={175,0,0},
        thickness=0.5));
  end if;

  if dhn_out_s then
    connect(Basic_Grid_Elements[n_elements].waterPortOut_supply, waterPortOut_supply);
  end if;

  if dhn_in_r then
    connect(Basic_Grid_Elements[n_elements].waterPortIn_return, waterPortIn_return);
  end if;

  annotation (
    Diagram(graphics={
        Ellipse(extent={{-26,50},{-18,56}}, lineColor={28,108,200}),
        Ellipse(extent={{2,50},{10,56}}, lineColor={28,108,200}),
        Rectangle(extent={{-116,42},{-84,64}}, lineColor={28,108,200}),
        Line(points={{-22,4},{70,4},{70,22},{92,22}}, color={28,108,200}),
        Line(points={{-22,-2},{70,-2},{70,-26},{92,-26}}, color={28,108,200}),
        Ellipse(extent={{-86,54},{-82,58}}, lineColor={28,108,200}),
        Ellipse(extent={{-86,48},{-82,52}}, lineColor={28,108,200}),
        Ellipse(extent={{-118,54},{-114,58}}, lineColor={28,108,200}),
        Ellipse(extent={{-118,48},{-114,52}}, lineColor={28,108,200}),
        Text(
          extent={{-58,-44},{-18,-28}},
          lineColor={28,108,200},
          textString="[%n_elements]"),
        Ellipse(extent={{-12,50},{-4,56}}, lineColor={28,108,200}),
        Rectangle(extent={{-68,42},{-36,64}}, lineColor={28,108,200}),
        Ellipse(extent={{-38,54},{-34,58}}, lineColor={28,108,200}),
        Ellipse(extent={{-38,48},{-34,52}}, lineColor={28,108,200}),
        Ellipse(extent={{-70,54},{-66,58}}, lineColor={28,108,200}),
        Ellipse(extent={{-70,48},{-66,52}}, lineColor={28,108,200}),
        Text(
          extent={{-116,32},{-82,42}},
          lineColor={28,108,200},
          textString="Basic_Grid_Element 1"),
        Text(
          extent={{-70,32},{-36,42}},
          lineColor={28,108,200},
          textString="Basic_Grid_Element 2"),
        Rectangle(extent={{18,42},{50,64}}, lineColor={28,108,200}),
        Ellipse(extent={{48,54},{52,58}}, lineColor={28,108,200}),
        Ellipse(extent={{48,48},{52,52}}, lineColor={28,108,200}),
        Ellipse(extent={{16,54},{20,58}}, lineColor={28,108,200}),
        Ellipse(extent={{16,48},{20,52}}, lineColor={28,108,200}),
        Text(
          extent={{16,32},{50,42}},
          lineColor={28,108,200},
          textString="Basic_Grid_Element n_elements"),
        Line(points={{-84,56},{-68,56}}, color={28,108,200}),
        Line(points={{-84,50},{-68,50}}, color={28,108,200}),
        Text(
          extent={{-28,62},{-12,70}},
          lineColor={28,108,200},
          textString="[n_elements]"),
        Rectangle(extent={{-120,28},{54,72}}, lineColor={28,108,200}),
        Line(points={{-38,16},{-38,26},{-34,24}}, color={28,108,200}),
        Line(points={{-38,26},{-42,24}}, color={28,108,200})}),
    Icon(graphics={
        Rectangle(
          extent={{-180,120},{120,-120}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-136,40},{-74,96}}, lineColor={28,108,200}),
        Line(points={{-144,0},{84,0}}, color={28,108,200}),
        Text(
          extent={{48,-122},{140,-62}},
          lineColor={28,108,200},
          textString="" + DynamicSelect("?", String(n_consumer))),
        Line(points={{-106,40},{-106,0}}, color={28,108,200}),
        Ellipse(extent={{-84,-6},{-70,8}}, lineColor={28,108,200}),
        Ellipse(extent={{-40,-6},{-26,8}}, lineColor={28,108,200}),
        Ellipse(extent={{0,-6},{14,8}}, lineColor={28,108,200}),
        Ellipse(extent={{10,40},{72,96}}, lineColor={28,108,200}),
        Line(points={{40,40},{40,0}}, color={28,108,200}),
        Line(points={{100,0},{84,14},{84,-14},{100,0}}, color={28,108,200}),
        Line(points={{-144,0},{-160,14},{-160,-14},{-144,0}}, color={28,108,200}),
        Ellipse(extent={{-136,-96},{-74,-40}}, lineColor={color_1,color_2,color_3}),
        Ellipse(extent={{10,-96},{72,-40}}, lineColor={color_1,color_2,color_3}),
        Line(points={{-106,0},{-106,-40}}, color={color_1,color_2,color_3}),
        Line(points={{40,0},{40,-40}}, color={color_1,color_2,color_3}),
        Text(
          extent={{-194,-120},{-102,-60}},
          lineColor={28,108,200},
          textString="[%n_elements]"),
        Text(
          extent={{-84,-136},{22,-200}},
          lineColor={28,108,200},
          textString="%name
")}),
    Text(
      extent={{-100,-20},{100,20}},
      lineColor={0,0,0},
      textString="" + DynamicSelect("?", String(n_consumer))),
    defaultComponentName="grid",
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Represents a Grid Segment (e. g. street) with multiple consumers and associated technologies for heat and electricity production. </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b> </p>
<h4>Some remarks about the structure of GridConstructor syntax:</h4>
<p>1. Activate/Deactivate connectors of the Basic_Grid_Elements depending on the setting for el_in/el_out/gas_in/gas_out on Grid_constructor level:</p>
<p>if el_in = false all electric connectors are deactivated</p>
<p>if el_in = true but el_out = false then el_out of last Basic_Grid_Element is set to false --&gt; Grid_Constructor represents the end of a beam of the electric grid</p>
<p>if gas_in = false all electric connectors are deactivated</p>
<p>if gas_in = true but gas_out = false then gas_out of last Basic_Grid_Element is set to false --&gt; Grid_Constructor represents the end of a beam of the gas grid</p>
<p>2. Assign second_Consumer values</p>
<p>3. Deactivate pipe segments, in Basic_Grid_Elements in which none of the buildings is connected to the gas grid while gas_in is still activated</p>
<p><span style=\"font-family: Courier New;\">4.</span>Assign load-profile triples from load-profile data tables to the buildings<span style=\"font-family: Courier New;\">:</span></p>
<p>Starting from column start_c1/start_c2 in table Demand_Consumer_1/Demand_Consumer_2 consecutive load-profile triples are assigned to consecutive buildings in the upper/lower row<span style=\"font-family: Courier New;\"> &nbsp; </span></p>
<p>5. Assign a Systems model Systems_Consumer_1/Systems_Consumer_2 to the buildings in the upper/lower row and finalize the individual technology selection with the respective boolean parameter vectors</p>
<p>6. Parametrise the cable and gas pipe models with the respective parameter vectors</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Michael Djukow, 2017 </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified by Anne Hagemeier, 2021</span></p>
</html>"));
end GridConstructor;
