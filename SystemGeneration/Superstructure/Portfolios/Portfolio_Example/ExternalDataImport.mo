within TransiEnt.SystemGeneration.Superstructure.Portfolios.Portfolio_Example;
record ExternalDataImport "Record of the external data import logic to create InstanceRecords automatically"


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
  //           Instances of other Classes
  // _____________________________________________
  replaceable package Config_info = Portfolios.Portfolio_Example constrainedby Base                   annotation (Dialog(tab="Import of external data sources", group="Portfolio"), choicesAllMatching=true);
  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________
  final parameter Integer Region_info[nRegions_info]=1:nRegions_info "List of regions" annotation (Dialog(tab="Import of external data sources", group="Matlab-script created matrices"));
  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________
  parameter Integer SimulationCounter_info=99 "Data set identifier" annotation (Dialog(tab="Import of external data sources", group="Matlab-script created matrices"));
  parameter Integer nRegions_info=4 "Number of regions in data set" annotation (Dialog(tab="Import of external data sources", group="Matlab-script created matrices"));

  parameter Real scaleFactorGasStorageCap_info=1 "Scale factor for gas storage capacities" annotation (Dialog(tab="Import of external data sources", group="Matlab-script created matrices"));
  parameter Real scaleFactorGasStoragePower_info=1 "Scale factor for gas storage max in/outflow" annotation (Dialog(tab="Import of external data sources", group="Matlab-script created matrices"));

  parameter String input_table_path_info=TransiEnt.SystemGeneration.Superstructure.Types.SUPERSTRUCTURE_TABLES "Environment variable " annotation (
    Evaluate=true,
    HideResult=false,
    Dialog(
      enable=not use_absolute_path,
      tab="Import of external data sources",
      group="Matlab-script created matrices"));
  parameter String input_data_path_info=TransiEnt.SystemGeneration.Superstructure.Types.SUPERSTRUCTURE_INPUT "Environment variable" annotation (
    Evaluate=true,
    HideResult=false,
    Dialog(
      enable=not use_absolute_path,
      tab="Import of external data sources",
      group="Matlab-script created matrices"));

  parameter Boolean LoadInformationPowerPlants_info[nRegions_info]=fill(true, nRegions_info) "true, if power plants exist in region" annotation (Dialog(tab="Import of external data sources", group="General"));
  parameter Boolean LoadInformationElectricalStorages_info[nRegions_info]=fill(true, nRegions_info) "true, if electrical storages exist in region" annotation (Dialog(tab="Import of external data sources", group="General"));
  parameter Boolean LoadInformationPowerToGasPlants_info[nRegions_info]=fill(true, nRegions_info) "true, if power to gas plants exist in region" annotation (Dialog(tab="Import of external data sources", group="General"));
  parameter Boolean LoadInformationGasStorage_info[nRegions_info]=fill(true, nRegions_info) "true, if gas storages exist in region" annotation (Dialog(tab="Import of external data sources", group="General"));
  parameter Boolean LoadInformationCHPPlants_info[nRegions_info]=fill(false, nRegions_info) "true, if CHP plants exist in region" annotation (Dialog(
      tab="Import of external data sources",
      group="General",
      enable=false));
  parameter Boolean LoadInformationElectricalHeater_info[nRegions_info]=fill(false, nRegions_info) "true, if electrical heater exist in region" annotation (Dialog(
      tab="Import of external data sources",
      group="General",
      enable=false));
  parameter Boolean LoadInformationGasBoiler_info[nRegions_info]=fill(false, nRegions_info) "true, if gas boiler exist in region" annotation (Dialog(
      tab="Import of external data sources",
      group="General",
      enable=false));

  final parameter String file_info[nRegions_info]={TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(input_data_path_info) + "Region" + String(Region_info[i]) + "_" + String(SimulationCounter_info, significantDigits=35) + ".mat") for i in 1:nRegions_info};

  final parameter Integer dim_PowerPlants_info[2]=Modelica.Utilities.Streams.readMatrixSize(file_info[1], "Region" + String(Region_info[1]) + ".PowerPlants") "Dimensions of PowerPlants matrix";
  final parameter Integer dim_CHPPlants_info[2]=Modelica.Utilities.Streams.readMatrixSize(file_info[1], "Region" + String(Region_info[1]) + ".CHPPlants") "Dimensions of CHPPlants matrix" annotation (dialog(tab="DataTables-previous"));
  final parameter Integer dim_ElectricalStorages_info[2]=Modelica.Utilities.Streams.readMatrixSize(file_info[1], "Region" + String(Region_info[1]) + ".ElectricalStorages") "Dimensions of ElectricalStorages matrix" annotation (dialog(tab="DataTables-previous"));
  final parameter Integer dim_PowerToGasPlants_info[2]=Modelica.Utilities.Streams.readMatrixSize(file_info[1], "Region" + String(Region_info[1]) + ".PowerToGasPlants") "Dimensions of PowerToGasPlants matrix" annotation (dialog(tab="DataTables-previous"));
  final parameter Integer dim_ElectricHeater_info[2]=Modelica.Utilities.Streams.readMatrixSize(file_info[1], "Region" + String(Region_info[1]) + ".ElectricHeater") "Dimensions of ElectricHeater matrix" annotation (dialog(tab="DataTables-previous"));
  final parameter Integer dim_GasStorages_info[2]=Modelica.Utilities.Streams.readMatrixSize(file_info[1], "Region" + String(Region_info[1]) + ".GasStorages") "Dimensions of GasStorage matrix" annotation (dialog(tab="DataTables-previous"));
  final parameter Integer dim_GasBoiler_info[2]=Modelica.Utilities.Streams.readMatrixSize(file_info[1], "Region" + String(Region_info[1]) + ".GasBoiler") "Dimensions of GasBoiler matrix" annotation (dialog(tab="DataTables-previous"));
  final parameter Integer dim_GeneralInformation_info[2]=Modelica.Utilities.Streams.readMatrixSize(file_info[1], "Region" + String(Region_info[1]) + ".GeneralInformation") "Dimensions of GeneralInformation matrix" annotation (dialog(tab="DataTables-previous"));

  final parameter Real InformationRegion_PowerPlants[nRegions_info,dim_PowerPlants_info[1],dim_PowerPlants_info[2]]={if LoadInformationPowerPlants_info[i] == false then zeros(dim_PowerPlants_info[1], dim_PowerPlants_info[2]) else Modelica.Utilities.Streams.readRealMatrix(
            file_info[i],
            "Region" + String(Region_info[i]) + ".PowerPlants",
            dim_PowerPlants_info[1],
            dim_PowerPlants_info[2]) for i in 1:nRegions_info};
  final parameter Real InformationRegion_CHPPlants[nRegions_info,:,:]={if LoadInformationCHPPlants_info[i] == false then zeros(dim_CHPPlants_info[1], dim_CHPPlants_info[2]) else Modelica.Utilities.Streams.readRealMatrix(
            file_info[i],
            "Region" + String(Region_info[i]) + ".CHPPlants",
            dim_CHPPlants_info[1],
            dim_CHPPlants_info[2]) for i in 1:nRegions_info};
  final parameter Real InformationRegion_ElectricalStorages[nRegions_info,dim_ElectricalStorages_info[1],dim_ElectricalStorages_info[2]]={if LoadInformationElectricalStorages_info[i] == false then zeros(dim_ElectricalStorages_info[1], dim_ElectricalStorages_info[2]) else Modelica.Utilities.Streams.readRealMatrix(
            file_info[i],
            "Region" + String(Region_info[i]) + ".ElectricalStorages",
            dim_ElectricalStorages_info[1],
            dim_ElectricalStorages_info[2]) for i in 1:nRegions_info};
  final parameter Real InformationRegion_PowerToGasPlants[nRegions_info,dim_PowerToGasPlants_info[1],dim_PowerToGasPlants_info[2]]={if LoadInformationPowerToGasPlants_info[i] == false then zeros(dim_PowerToGasPlants_info[1], dim_PowerToGasPlants_info[2]) else Modelica.Utilities.Streams.readRealMatrix(
            file_info[i],
            "Region" + String(Region_info[i]) + ".PowerToGasPlants",
            dim_PowerToGasPlants_info[1],
            dim_PowerToGasPlants_info[2]) for i in 1:nRegions_info};
  final parameter Real InformationRegion_ElectricHeater[nRegions_info,dim_ElectricHeater_info[1],dim_ElectricHeater_info[2]]={if LoadInformationElectricalHeater_info[i] == false then zeros(dim_ElectricHeater_info[1], dim_ElectricHeater_info[2]) else Modelica.Utilities.Streams.readRealMatrix(
            file_info[i],
            "Region" + String(Region_info[i]) + ".ElectricHeater",
            dim_ElectricHeater_info[1],
            dim_ElectricHeater_info[2]) for i in 1:nRegions_info};
  final parameter Real InformationRegion_GasStorages_raw[nRegions_info,dim_GasStorages_info[1],dim_GasStorages_info[2]]={if LoadInformationGasStorage_info[i] == false then zeros(dim_GasStorages_info[1], dim_GasStorages_info[2]) else Modelica.Utilities.Streams.readRealMatrix(
            file_info[i],
            "Region" + String(Region_info[i]) + ".GasStorages",
            dim_GasStorages_info[1],
            dim_GasStorages_info[2]) for i in 1:nRegions_info};
  final parameter Real InformationRegion_GasStorages[nRegions_info,:,:]={if LoadInformationGasStorage_info[i] == false then InformationRegion_GasStorages_raw[i, :, :] else cat(
            2,
            InformationRegion_GasStorages_raw[i, :, 1:3],
            scaleFactorGasStorageCap_info*[InformationRegion_GasStorages_raw[i, :, 4]],
            scaleFactorGasStoragePower_info*InformationRegion_GasStorages_raw[i, :, 5:6],
            InformationRegion_GasStorages_raw[i, :, 7:9],
            scaleFactorGasStorageCap_info*[InformationRegion_GasStorages_raw[i, :, 10]],
            InformationRegion_GasStorages_raw[i, :, 11:dim_GasStorages_info[2]]) for i in 1:nRegions_info};
  final parameter Real InformationRegion_GasBoiler[nRegions_info,dim_GasBoiler_info[1],dim_GasBoiler_info[2]]={if LoadInformationGasBoiler_info[i] == false then zeros(dim_GasBoiler_info[1], dim_GasBoiler_info[2]) else Modelica.Utilities.Streams.readRealMatrix(
            file_info[i],
            "Region" + String(Region_info[i]) + ".GasBoiler",
            dim_GasBoiler_info[1],
            dim_GasBoiler_info[2]) for i in 1:nRegions_info};
  final parameter Real InformationRegion_GeneralInformation[nRegions_info,dim_GeneralInformation_info[1],dim_GeneralInformation_info[2]]={Modelica.Utilities.Streams.readRealMatrix(
            file_info[i],
            "Region" + String(Region_info[i]) + ".GeneralInformation",
            dim_GeneralInformation_info[1],
            dim_GeneralInformation_info[2]) for i in 1:nRegions_info};

  final parameter Integer DifferentTypesOfPowerPlants_info[nRegions_info]={if LoadInformationPowerPlants_info[i] == true then TransiEnt.Basics.Functions.real2integer(max(InformationRegion_PowerPlants[i, :, 2])) else 0 for i in 1:nRegions_info} "Amount of different power plant types" annotation (dialog(tab="DataTables-previous"));
  final parameter Integer DifferentTypesOfElectricalStorages_info[nRegions_info]={if LoadInformationElectricalStorages_info[i] == true then TransiEnt.Basics.Functions.real2integer(max(InformationRegion_ElectricalStorages[i, :, 2])) else 0 for i in 1:nRegions_info} " Amount of different electrical storage types" annotation (dialog(tab="DataTables-previous"));
  final parameter Integer DifferentTypesOfPowerToGasPlants_info[nRegions_info]={if LoadInformationPowerToGasPlants_info[i] == true then TransiEnt.Basics.Functions.real2integer(max(InformationRegion_PowerToGasPlants[i, :, 2])) else 0 for i in 1:nRegions_info} "Amount of different power to gas plant types" annotation (Dialog(tab="DataTables-previous"));
  final parameter Integer DifferentTypesOfCHPPlants_info[nRegions_info]={if LoadInformationCHPPlants_info[i] == true then TransiEnt.Basics.Functions.real2integer(max(InformationRegion_CHPPlants[i, :, 2])) else 0 for i in 1:nRegions_info} " Amount of different CHP plant types" annotation (dialog(tab="DataTables-previous"));
  final parameter Integer DifferentTypesOfElectricHeater_info[nRegions_info]={if LoadInformationElectricalHeater_info[i] == true then TransiEnt.Basics.Functions.real2integer(max(InformationRegion_ElectricHeater[i, :, 2])) else 0 for i in 1:nRegions_info} "Amount of different electrical heater types" annotation (Dialog(tab="DataTables-previous"));
  final parameter Integer DifferentTypesOfGasBoiler_info[nRegions_info]={if LoadInformationGasBoiler_info[i] == true then TransiEnt.Basics.Functions.real2integer(max(InformationRegion_GasBoiler[i, :, 2])) else 0 for i in 1:nRegions_info} "Amount of different gas boiler types" annotation (Dialog(tab="DataTables-previous"));

  // _____________________________________________
  //
  //            Predefined Instance Records
  // _____________________________________________

  // ------------- Electrical Storage ------------
  parameter Config_info.Records.InstancesRecords.ElectricalStorageInstancesRecord electricalStorageInstancesRecordRegionInfo[nRegions_info]={Config_info.Records.InstancesRecords.ElectricalStorageInstancesRecord(
            nElectricalStorages=DifferentTypesOfElectricalStorages_info[i],
            electricalStorageType={Config_info.ElectricalStorageType(integer(max(InformationRegion_ElectricalStorages[i, j, 13], 1))) for j in 1:DifferentTypesOfElectricalStorages_info[i]},
            electricalStorageRecord={Config_info.Records.ElectricalStorageRecord(
              E_start=InformationRegion_ElectricalStorages[i, j, 10],
              E_max=InformationRegion_ElectricalStorages[i, j, 8],
              E_min=InformationRegion_ElectricalStorages[i, j, 9],
              P_max_unload=InformationRegion_ElectricalStorages[i, j, 5],
              P_max_load=InformationRegion_ElectricalStorages[i, j, 4],
              P_grad_max=InformationRegion_ElectricalStorages[i, j, 11],
              eta_unload=InformationRegion_ElectricalStorages[i, j, 7],
              eta_load=InformationRegion_ElectricalStorages[i, j, 6],
              selfDischargeRate=InformationRegion_ElectricalStorages[i, j, 12]) for j in 1:DifferentTypesOfElectricalStorages_info[i]}) for i in 1:nRegions_info} annotation (Dialog(
      tab="Import of external data sources",
      group="InstanceRecord Creation",
      enable=true));

  // ------------- Gas Storage ------------
  parameter Config_info.Records.InstancesRecords.GasStorageInstancesRecord gasStorageInstancesRecordRegionInfo[nRegions_info]={Config_info.Records.InstancesRecords.GasStorageInstancesRecord(gasStorageRecord=Config_info.Records.GasStorageRecord(
            Volume=InformationRegion_GasStorages[i, 1, 4],
            m_gas_start=InformationRegion_GasStorages[i, 1, 10],
            m_flow_nom=InformationRegion_GasStorages[i, 1, 5],
            Vgeo_per_mMax=InformationRegion_GasStorages[i, 1, 4],
            m_flow_inMax=InformationRegion_GasStorages[i, 1, 5],
            m_flow_outMax=InformationRegion_GasStorages[i, 1, 6],
            GasStrorageTypeNo=InformationRegion_GasStorages[i, 1, 11])) for i in 1:nRegions_info} annotation (Dialog(
      tab="Import of external data sources",
      group="InstanceRecord Creation",
      enable=false));

  // ------------- Power plants ------------
  parameter Config_info.Records.InstancesRecords.PowerPlantInstancesRecord powerPlantInstancesRecordRegionInfo[nRegions_info]={Config_info.Records.InstancesRecords.PowerPlantInstancesRecord(
            nPowerPlants=max(DifferentTypesOfPowerPlants_info[i], 1),
            powerPlantType={Config_info.PowerPlantType(integer(InformationRegion_PowerPlants[i, j, 10])) for j in 1:DifferentTypesOfPowerPlants_info[i]},
            powerPlantRecord={Config_info.Records.PowerPlantRecord(
              P_el_n=InformationRegion_PowerPlants[i, j, 4],
              P_min_star=InformationRegion_PowerPlants[i, j, 6],
              P_grad_max_star=InformationRegion_PowerPlants[i, j, 7],
              t_startup=if dim_PowerPlants_info[2] >= 13 then InformationRegion_PowerPlants[i, j, 13] else 0,
              CO2_Deposition_Rate=InformationRegion_PowerPlants[i, j, 11],
              quantity=if InformationRegion_PowerPlants[i, j, 10] == 3 then 1 else integer(InformationRegion_PowerPlants[i, j, 4]/1000e6) + 1,
              eta_total=InformationRegion_PowerPlants[i, j, 5],
              P_init_set=InformationRegion_PowerPlants[i, j, 9] + 1e-3) for j in 1:DifferentTypesOfPowerPlants_info[i]}) for i in 1:nRegions_info} annotation (Dialog(
      tab="Import of external data sources",
      group="InstanceRecord Creation",
      enable=false));

  // ------------- Local demand ------------
  parameter Config_info.Records.InstancesRecords.LocalDemandInstancesRecord localDemandInstancesRecordRegionInfo[nRegions_info]={Config_info.Records.InstancesRecords.LocalDemandInstancesRecord(localDemandRecord=Config_info.Records.LocalDemandRecord(
            Fraction={InformationRegion_GeneralInformation[i, 1, k] for k in 6:15},
            Q_demand_annual=InformationRegion_GeneralInformation[i, 1, 16]*3500*3600,
            volume_junction=InformationRegion_GeneralInformation[i, 1, 21],
            HeatPumpAndSolarSole_COP_n=InformationRegion_GeneralInformation[i, 1, 22],
            HeatPumpSole_COP_n=InformationRegion_GeneralInformation[i, 1, 22],
            HeatPumpAndSolar_COP_n=InformationRegion_GeneralInformation[i, 1, 23],
            HeatPump_COP_n=InformationRegion_GeneralInformation[i, 1, 23],
            gasboiler_eta=InformationRegion_GeneralInformation[i, 1, 24],
            electricBoiler_eta=InformationRegion_GeneralInformation[i, 1, 25])) for i in 1:nRegions_info} annotation (Dialog(
      tab="Import of external data sources",
      group="InstanceRecord Creation",
      enable=false));

  // ------------- Local Renewable Production ------------

  // ------------- CO2System ------------
  parameter Config_info.Records.InstancesRecords.CO2SystemInstancesRecord cO2SystemInstancesRecordRegionInfo[nRegions_info]={Config_info.Records.InstancesRecords.CO2SystemInstancesRecord(cO2SystemRecord=Config_info.Records.CO2SystemRecord(
            DirectAirCapture_EnergyDemandThermal=if dim_PowerToGasPlants_info[2] >= 22 then InformationRegion_PowerToGasPlants[i, 1, 22] else 7.92e6,
            DirectAirCapture_EnergyDemandElectrical=if dim_PowerToGasPlants_info[2] >= 22 then InformationRegion_PowerToGasPlants[i, 1, 21] else 2.52e6,
            m_start_CO2_storage=InformationRegion_PowerToGasPlants[i, 1, 20])) for i in 1:nRegions_info} annotation (Dialog(
      tab="Import of external data sources",
      group="InstanceRecord Creation",
      enable=false));

  // ------------- Power to Gas ------------
  parameter Config_info.Records.InstancesRecords.PowerToGasInstancesRecord powerToGasInstancesRecordRegionInfo[nRegions_info]={if DifferentTypesOfPowerToGasPlants_info[i] > 0 then Config_info.Records.InstancesRecords.PowerToGasInstancesRecord(
            nPowerToGasPlants=DifferentTypesOfPowerToGasPlants_info[i],
            powerToGasType=Config_info.PowerToGasType(integer(max(InformationRegion_PowerToGasPlants[i, 1, 12], 1))),
            powerToGasRecord=Config_info.Records.PowerToGasRecord(
              WasteHeatUsage_V_storage=InformationRegion_PowerToGasPlants[i, 1, 4]*0.22923*48/(4.18*(105 - 20))/959,
              MethanationPlant_m_flow_n_Hydrogen=InformationRegion_PowerToGasPlants[i, 1, 4]*InformationRegion_PowerToGasPlants[i, 1, 5]/(141.79e6 - 219972),
              P_el_n=InformationRegion_PowerToGasPlants[i, 1, 4],
              eta_n=InformationRegion_PowerToGasPlants[i, 1, 5],
              max_storage=InformationRegion_PowerToGasPlants[i, 1, 6]*1000,
              P_el_min_rel=InformationRegion_PowerToGasPlants[i, 1, 7],
              complexityLevelMethanation=integer(InformationRegion_PowerToGasPlants[i, 1, 8]),
              p_Start=InformationRegion_PowerToGasPlants[i, 1, 9]*1e5,
              m_flow_internaldemand_constant=InformationRegion_PowerToGasPlants[i, 1, 14],
              p_minLow_constantDemand=InformationRegion_PowerToGasPlants[i, 1, 15],
              p_minLow=InformationRegion_PowerToGasPlants[i, 1, 16],
              p_minHigh=InformationRegion_PowerToGasPlants[i, 1, 17],
              p_maxLow=InformationRegion_PowerToGasPlants[i, 1, 18],
              p_maxHigh=InformationRegion_PowerToGasPlants[i, 1, 19])) else Config_info.Records.InstancesRecords.PowerToGasInstancesRecord(nPowerToGasPlants=0) for i in 1:nRegions_info} annotation (Dialog(
      tab="Import of external data sources",
      group="InstanceRecord Creation",
      enable=false));

  // ------------- Heating Grid ------------
  parameter Config_info.Records.InstancesRecords.HeatingGridSystemStorageInstancesRecord heatingGridInstancesRecordRegionInfo[nRegions_info]={if (DifferentTypesOfCHPPlants_info[i] > 0 or DifferentTypesOfElectricHeater_info[i] > 0 or DifferentTypesOfGasBoiler_info[i] > 0) then Config_info.Records.InstancesRecords.HeatingGridSystemStorageInstancesRecord(nHeatingGrid=1, heatingGridSystemStorageRecord=Config_info.Records.HeatingGridSystemStorageRecord(
            Q_flow_max=InformationRegion_GeneralInformation[i, 1, 5]*InformationRegion_GeneralInformation[i, 1, 16],
            ElHeater_quantity=integer(InformationRegion_ElectricHeater[i, 1, 3]),
            ElHeater_Q_el_n=InformationRegion_ElectricHeater[i, 1, 4],
            ElHeater_eta_n=InformationRegion_ElectricHeater[i, 1, 5],
            CHP_quantity=integer(InformationRegion_CHPPlants[i, 1, 3]),
            CHP_P_el_n=InformationRegion_CHPPlants[i, 1, 4],
            CHP_Q_flow_n=InformationRegion_CHPPlants[i, 1, 5],
            CHP_meritOrder=integer(InformationRegion_CHPPlants[i, 1, 6]),
            CHP_Q_flow_init=InformationRegion_CHPPlants[i, 1, 7],
            GasBoiler_Q_flow_n=InformationRegion_GasBoiler[i, 1, 4],
            GasBoiler_eta_n=InformationRegion_GasBoiler[i, 1, 5],
            GasBoiler_quantity=integer(InformationRegion_GasBoiler[i, 1, 3]))) else Config_info.Records.InstancesRecords.HeatingGridSystemStorageInstancesRecord(nHeatingGrid=0) for i in 1:nRegions_info} "Always deactivated, still in development" annotation (Dialog(
      tab="Import of external data sources",
      group="InstanceRecord Creation",
      enable=false));

  // _____________________________________________
  //
  //            Predefined Table paths
  // _____________________________________________

  parameter String[nRegions_info] localElectricDemand_pathToTable_info={TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(input_table_path_info) + "LoadProfiles/ElectricalDemandProfile_Region" + String(Region_info[i]) + "_" + String(SimulationCounter_info, significantDigits=35) + ".txt") for i in 1:nRegions_info} annotation (Dialog(
      tab="Import of external data sources",
      group="Local Demand Profile Path",
      enable=false));
  parameter String[nRegions_info] localGasDemand_pathToTable_info={TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(input_table_path_info) + "LoadProfiles/GasDemandProfile_Region" + String(Region_info[i]) + "_" + String(SimulationCounter_info, significantDigits=35) + ".txt") for i in 1:nRegions_info} annotation (Dialog(
      tab="Import of external data sources",
      group="Local Demand Profile Path",
      enable=false));
  parameter String[nRegions_info] localSolarthermalProduction_pathToTable_info={TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(input_table_path_info) + "SolarthermalProduction/SolarthermalProductionProfile_Region" + String(Region_info[i]) + "_" + String(SimulationCounter_info, significantDigits=35) + ".txt") for i in 1:nRegions_info} annotation (Dialog(
      tab="Import of external data sources",
      group="Local Demand Profile Path",
      enable=false));
  parameter String[nRegions_info] localTemperature_pathToTable_info={TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(input_table_path_info) + "Temperature/TemperatureProfile_Region" + String(Region_info[i]) + "_" + String(SimulationCounter_info, significantDigits=35) + ".txt") for i in 1:nRegions_info} annotation (Dialog(
      tab="Import of external data sources",
      group="Local Demand Profile Path",
      enable=false));
  parameter String[nRegions_info] localHeatDemand_pathToTable_info={TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(input_table_path_info) + "HeatDemandProfiles/HeatDemandProfile_Region" + String(Region_info[i]) + "_" + String(SimulationCounter_info, significantDigits=35) + ".txt") for i in 1:nRegions_info} annotation (Dialog(
      tab="Import of external data sources",
      group="Local Demand Profile Path",
      enable=false));
  parameter String[nRegions_info] localBiogasProduction_pathToTable_info={TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(input_table_path_info) + "BioProduction/BiogasProfile_Region" + String(Region_info[i]) + "_" + String(SimulationCounter_info, significantDigits=35) + ".txt") for i in 1:nRegions_info} annotation (Dialog(
      tab="Import of external data sources",
      group="Local Renewable Production Profile Path",
      enable=false));
  parameter String[nRegions_info] localWindOffshoreProduction_pathToTable_info={TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(input_table_path_info) + "WindOffshoreProduction/RenewableWindOffshoreProductionProfile_Region" + String(Region_info[i]) + "_" + String(SimulationCounter_info, significantDigits=35) + ".txt") for i in 1:nRegions_info} annotation (Dialog(
      tab="Import of external data sources",
      group="Local Renewable Production Profile Path",
      enable=false));
  parameter String[nRegions_info] localBiomassProduction_pathToTable_info={TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(input_table_path_info) + "BioProduction/RenewableBioProductionProfile_Region" + String(Region_info[i]) + "_" + String(SimulationCounter_info, significantDigits=35) + ".txt") for i in 1:nRegions_info} annotation (Dialog(
      tab="Import of external data sources",
      group="Local Renewable Production Profile Path",
      enable=false));
  parameter String[nRegions_info] localPhotovoltaicProduction_pathToTable_info={TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(input_table_path_info) + "PVProduction/RenewablePVProductionProfile_Region" + String(Region_info[i]) + "_" + String(SimulationCounter_info, significantDigits=35) + ".txt") for i in 1:nRegions_info} annotation (Dialog(
      tab="Import of external data sources",
      group="Local Renewable Production Profile Path",
      enable=false));
  parameter String[nRegions_info] localWindOnshoreProduction_pathToTable_info={TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(input_table_path_info) + "WindProduction/RenewableWindProductionProfile_Region" + String(Region_info[i]) + "_" + String(SimulationCounter_info, significantDigits=35) + ".txt") for i in 1:nRegions_info} annotation (Dialog(
      tab="Import of external data sources",
      group="Local Renewable Production Profile Path",
      enable=false));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>The purpose of this record is to load parameters of the superstructure from external data sources and write them into InstanceRecords for each technology.</p>
<p>The contents of this record is designed to be rewritten, depending on the format of the avaliable data.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span> </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span> </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<h4>Possible Outputs:</h4>
<p>Instance Records:</p>
<ul>
<li><span style=\"font-family: Courier New;\">electricalStorageInstancesRecordRegionInfo </span></li>
<li><span style=\"font-family: Courier New;\">gasStorageInstancesRecordRegionInfo</span></li>
<li><span style=\"font-family: Courier New;\">powerPlantInstancesRecordRegionInfo</span></li>
<li><span style=\"font-family: Courier New;\">localDemandInstancesRecordRegionInfo</span></li>
<li><span style=\"font-family: Courier New;\">cO2SystemInstancesRecordRegionInfo</span></li>
<li><span style=\"font-family: Courier New;\">powerToGasInstancesRecordRegionInfo</span></li>
<li><span style=\"font-family: Courier New;\">heatingGridInstancesRecordRegionInfo</span></li>
</ul>
<p><br>Paths to tables:</p>
<ul>
<li><span style=\"font-family: Courier New;\">localElectricDemand_pathToTable_info</span></li>
<li><span style=\"font-family: Courier New;\">localGasDemand_pathToTable_info</span></li>
<li><span style=\"font-family: Courier New;\">localSolarthermalProduction_pathToTable_info</span></li>
<li><span style=\"font-family: Courier New;\">localTemperature_pathToTable_info</span></li>
<li><span style=\"font-family: Courier New;\">localHeatDemand_pathToTable_info</span></li>
<li><span style=\"font-family: Courier New;\">localBiogasProduction_pathToTable_info</span></li>
<li><span style=\"font-family: Courier New;\">localWindOffshoreProduction_pathToTable_info</span></li>
<li><span style=\"font-family: Courier New;\">localBiomassProduction_pathToTable_info</span></li>
<li><span style=\"font-family: Courier New;\">localPhotovoltaicProduction_pathToTable_info</span></li>
<li><span style=\"font-family: Courier New;\">localWindOnshoreProduction_pathToTable_info</span></li>
</ul>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span> </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span> </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span> </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>(no remarks) </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span> </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jon Babst (babst@xrg-simulation.de) on 06.09.2021. </span></p>
</html>"));
end ExternalDataImport;
