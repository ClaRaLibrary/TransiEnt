within TransiEnt.SystemGeneration.Superstructure.Portfolios.Portfolio_Example;
model Superstructures_PortfolioMask "Mask for array of superstructures using this portfolio's technology definitions"


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
  extends TransiEnt.Basics.Icons.SuperstructureIcon;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter Integer Region[nRegions]=1:nRegions "Define Region Numbers" annotation (Dialog(group="General"));
//inner
  final inner parameter  Integer MaximumDifferentTypesOfPowerPlants=max(powerPlantInstancesRecord[:].nPowerPlants);
  final parameter Integer MaximumDifferentTypesOfElectricalStorages=max(electricalStorageInstancesRecord[:].nElectricalStorages);
  final parameter Integer MaximumDifferentTypesOfPtG=max(DifferentTypesOfPowerToGasPlants);
  final parameter Integer MaximumDifferentTypesOfElectricHeaters=max(DifferentTypesOfElectricHeater);

  final parameter Integer DifferentTypesOfPowerPlants[nRegions]={powerPlantInstancesRecord[i].nPowerPlants for i in 1:nRegions} "Amount of different power plant types";
  final parameter Integer DifferentTypesOfElectricalStorages[nRegions]={electricalStorageInstancesRecord[i].nElectricalStorages for i in 1:nRegions} " Amount of different electrical storage types";
  final parameter Integer DifferentTypesOfPowerToGasPlants[nRegions]={powerToGasInstancesRecord[i].nPowerToGasPlants for i in 1:nRegions} "Amount of different power to gas plant types";
  final parameter Integer DifferentTypesOfCHPPlants[nRegions]={heatingGridSystemStorageInstancesRecord[i].nHeatingGrid*heatingGridSystemStorageInstancesRecord[i].heatingGridSystemStorageRecord.CHP_quantity for i in 1:nRegions} " Amount of different CHP plant types";
  final parameter Integer DifferentTypesOfElectricHeater[nRegions]={heatingGridSystemStorageInstancesRecord[i].nHeatingGrid*heatingGridSystemStorageInstancesRecord[i].heatingGridSystemStorageRecord.ElHeater_quantity for i in 1:nRegions} "Amount of different electrical heater types";
  final parameter Integer DifferentTypesOfGasBoiler[nRegions]={heatingGridSystemStorageInstancesRecord[i].nHeatingGrid*heatingGridSystemStorageInstancesRecord[i].heatingGridSystemStorageRecord.GasBoiler_quantity for i in 1:nRegions} "Amount of different gas boiler types";
  final parameter Integer DifferentTypesOfGasStorage[nRegions]={gasStorageInstancesRecord[i].nGasStorages for i in 1:nRegions} "Amount of different gas storage types";

  final parameter Integer NumberOfPowerplantsOverAllRegions=sum(DifferentTypesOfPowerPlants) annotation (Dialog(tab="Helper Paramters", enable=false));
  final parameter Integer NumberOfElectricalStoragesOverAllRegions=sum(DifferentTypesOfElectricalStorages) annotation (Dialog(tab="Helper Paramters", enable=false));
  final parameter Integer NumberOfPowerToGasPlantsOverAllRegions=sum(DifferentTypesOfPowerToGasPlants) annotation (Dialog(tab="Helper Paramters", enable=false));
  final parameter Integer NumberOfElectricalHeatersOverAllRegions=sum(DifferentTypesOfElectricHeater) annotation (Dialog(tab="Helper Paramters", enable=false));

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  replaceable package Config = Portfolios.Portfolio_Example constrainedby Base                   annotation (Dialog(group="Portofolio"), choicesAllMatching=true);

  parameter Integer nRegions=3 "Number of regions" annotation (Dialog(group="General"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_small=0.1 "small leakage mass flow for numerical stability" annotation (Dialog(group="General"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_CO2=simCenter.gasModel1 "CO2 model to be used" annotation (Dialog(group="General"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Gas model to be used" annotation (Dialog(group="General"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_Hydrogen=simCenter.gasModel3 "Hydrogen model to be used" annotation (Dialog(group="General"));

  //GasGrid
  parameter Modelica.Units.SI.Pressure p_gasGrid_desired[nRegions]=fill(simCenter.p_amb_const + simCenter.p_eff_2, nRegions) "desired gas grid pressure in region" annotation (Dialog(group="GasGrid"));
  parameter Modelica.Units.SI.PressureDifference p_gasGrid_desired_bandwidth[nRegions]=fill(0, nRegions) "band width around p_gasGrid_desired in which the set value varies depending on the SOC of the gas storage" annotation (Dialog(group="GasGrid"));
  parameter Boolean useOneGasPortOnly=true "true: one gas port per region, false: 6 gas ports per region one for each technology" annotation (Dialog(group="GasGrid"));
  final parameter Integer n_gasPort=if useOneGasPortOnly then 1 else 6 annotation (Dialog(group="GasGrid"));
  parameter Boolean useImportExportBoundary= fill(false,nRegions) "useOneGasPortOnly has to be turned on for this" annotation (Dialog(enable=useOneGasPortOnly, group="GasGrid"));
  parameter Real junctionVolume[nRegions]=fill(10676.7, nRegions) "Volume of accumulating central gas volume if useOneGasPortOnly" annotation (Dialog(group="GasGrid"));

  //---Failures---//
  parameter SI.Pressure p_min_operating_PowerPlants=1e5 "gas pressure threshold at which powerplants turn off" annotation (dialog(tab="Failures"));
  parameter SI.Pressure p_min_operating_PowerPlants_backin=2e5 "gas pressure threshold at which powerplants turn back on after turning off" annotation (dialog(tab="Failures"));
  parameter SI.Pressure p_min_operating_localDemand=1e5 "gas pressure threshold at which local consumers turn off" annotation (dialog(tab="Failures"));
  parameter SI.Pressure p_min_operating_localDemand_backin=2e5 "gas pressure threshold at which powerplants turn back on after turning off" annotation (dialog(tab="Failures"));

  //---Technologies---//
  //HeatingGrid
  parameter Modelica.Units.NonSI.Temperature_degC T_supply_max_districtHeating[nRegions]=fill(149, nRegions) annotation (Dialog(
      tab="Technology Parametrization",
      group="Heating Grid",
      enable=false));
  parameter Modelica.Units.NonSI.Temperature_degC T_return_min_districtHeating[nRegions]=fill(49, nRegions) annotation (Dialog(
      tab="Technology Parametrization",
      group="Heating Grid",
      enable=false));

  //PowerPlants/ToGas
  parameter Integer[2] slackBoundaryPosition={1,1} "Indices [nRegion, power plant number in region] for powerplant position to act as an epp slack boundary" annotation (Dialog(group="Powerplants", tab="Technology Parametrization"));

  parameter Boolean useHydrogenFromPtGInPowerPlants[nRegions]=fill(false, nRegions) "Hydrogen from PtG is fed directly into powerplants" annotation (Dialog(group="Power To Gas", tab="Technology Parametrization"));
  parameter Boolean useVariableHydrogenFraction[nRegions]=fill(false, nRegions) "if PtG is methanation: H2 fractrion in gas output is controlled" annotation (Dialog(group="Power To Gas", tab="Technology Parametrization"));

  parameter Integer usageOfWasteHeatOfPtG[nRegions]=fill(1, nRegions) "Waste heat usage of PtG: 1=No usage, 2=CO2 Desorption, 3=DistrictHeating(currently disabled)" annotation (Dialog(
      group="Power To Gas",
      tab="Technology Parametrization",
      choices(
        choice=1 "No Usage",
        choice=2 "CO2 Desorption",
        choice=3 "District Heating")));

  //---Tables---//
  parameter String[nRegions] localElectricDemand_pathToTable=localElectricDemand_pathToTable_info "Absolute path to table" annotation (Dialog(tab="Local Demand and Ren. Production tables", group="Local Demand"));
  parameter Real[nRegions] localElectricDemand_constantMultiplier=fill(1.0, nRegions) "Multiply output with constant factor" annotation (Dialog(tab="Local Demand and Ren. Production tables", group="Local Demand"));
  parameter String[nRegions] localGasDemand_pathToTable=localGasDemand_pathToTable_info "Absolute path to table" annotation (Dialog(tab="Local Demand and Ren. Production tables", group="Local Demand"));
  parameter Real[nRegions] localGasDemand_constantMultiplier=fill(1.0, nRegions) "Multiply output with constant factor" annotation (Dialog(tab="Local Demand and Ren. Production tables", group="Local Demand"));
  parameter String[nRegions] localSolarthermalProduction_pathToTable=localSolarthermalProduction_pathToTable_info "Absolute path to table" annotation (Dialog(tab="Local Demand and Ren. Production tables", group="Local Demand"));
  parameter Real[nRegions] localSolarthermalProduction_constantMultiplier=fill(1.0, nRegions) "Multiply output with constant factor" annotation (Dialog(tab="Local Demand and Ren. Production tables", group="Local Demand"));

  parameter String[nRegions] localTemperature_pathToTable=localTemperature_pathToTable_info "Absolute path to table" annotation (Dialog(tab="Local Demand and Ren. Production tables", group="Local Demand"));
  parameter Real[nRegions] localTemperature_constantMultiplier=fill(1.0, nRegions) "Multiply output with constant factor" annotation (Dialog(tab="Local Demand and Ren. Production tables", group="Local Demand"));
  parameter String[nRegions] localHeatDemand_pathToTable=localHeatDemand_pathToTable_info "Absolute path to table" annotation (Dialog(tab="Local Demand and Ren. Production tables", group="Local Demand"));
  parameter Real[nRegions] localHeatDemand_constantMultiplier=fill(1.0, nRegions) "Multiply output with constant factor" annotation (Dialog(tab="Local Demand and Ren. Production tables", group="Local Demand"));
  parameter Real splitHeatingDemand_localHeating[nRegions]=fill(1, nRegions) "Fraction of table data values referring to local heating compared to local heating grid" annotation (Dialog(
      tab="Local Demand and Ren. Production tables",
      group="Local Demand",
      enable=false));

  parameter String[nRegions] localBiogasProduction_pathToTable=localBiogasProduction_pathToTable_info "Absolute path to table" annotation (Dialog(tab="Local Demand and Ren. Production tables", group="Local Renewable Production"));
  parameter Real[nRegions] localBiogasProduction_constantMultiplier=fill(1.0, nRegions) "Multiply output with constant factor" annotation (Dialog(tab="Local Demand and Ren. Production tables", group="Local Renewable Production"));
  parameter String[nRegions] localWindOffshoreProduction_pathToTable=localWindOffshoreProduction_pathToTable_info "Absolute path to table" annotation (Dialog(tab="Local Demand and Ren. Production tables", group="Local Renewable Production"));
  parameter Real[nRegions] localWindOffshoreProduction_constantMultiplier=fill(1.0, nRegions) "Multiply output with constant factor" annotation (Dialog(tab="Local Demand and Ren. Production tables", group="Local Renewable Production"));
  parameter String[nRegions] localBiomassProduction_pathToTable=localBiomassProduction_pathToTable_info "Absolute path to table" annotation (Dialog(tab="Local Demand and Ren. Production tables", group="Local Renewable Production"));
  parameter Real[nRegions] localBiomassProduction_constantMultiplier=fill(1.0, nRegions) "Multiply output with constant factor" annotation (Dialog(tab="Local Demand and Ren. Production tables", group="Local Renewable Production"));
  parameter String[nRegions] localPhotovoltaicProduction_pathToTable=localPhotovoltaicProduction_pathToTable_info "Absolute path to table" annotation (Dialog(tab="Local Demand and Ren. Production tables", group="Local Renewable Production"));
  parameter Real[nRegions] localPhotovoltaicProduction_constantMultiplier=fill(1.0, nRegions) "Multiply output with constant factor" annotation (Dialog(tab="Local Demand and Ren. Production tables", group="Local Renewable Production"));
  parameter String[nRegions] localWindOnshoreProduction_pathToTable=localWindOnshoreProduction_pathToTable_info "Absolute path to table" annotation (Dialog(tab="Local Demand and Ren. Production tables", group="Local Renewable Production"));
  parameter Real[nRegions] localWindOnshoreProduction_constantMultiplier=fill(1.0, nRegions) "Multiply output with constant factor" annotation (Dialog(tab="Local Demand and Ren. Production tables", group="Local Renewable Production"));

  //---Instance Records--//

  //---- Power plants---//
  //  parameter Records.InstancesRecords.PowerPlantInstancesRecord powerPlantInstancesRecord[nRegions]=fill(Records.InstancesRecords.PowerPlantInstancesRecord(), nRegions) "Power plant parametrization" annotation (Dialog(group="Power Plants", tab="Technology Parametrization"));
  parameter Records.InstancesRecords.PowerPlantInstancesRecord powerPlantInstancesRecord[nRegions]=powerPlantInstancesRecordRegionInfo "Power plant parametrization" annotation (Dialog(group="Powerplants", tab="Technology Parametrization"));

  //----Electrical Storage---//
  //parameter Records.InstancesRecords.ElectricalStorageInstancesRecord electricalStorageInstancesRecord[nRegions]= fill(Records.InstancesRecords.ElectricalStorageInstancesRecord(),nRegions) "Electrical storage parametrization" annotation (Dialog(group="Electrical Storages",tab="Technology Parametrization"));
  parameter Records.InstancesRecords.ElectricalStorageInstancesRecord electricalStorageInstancesRecord[nRegions]=electricalStorageInstancesRecordRegionInfo "Electrical Storage parametrization" annotation (Dialog(group="Electrical Storages", tab="Technology Parametrization"));

  //----Power to gas---//
  //   parameter Records.InstancesRecords.PowerToGasInstancesRecord[nRegions] powerToGasInstancesRecord= fill(Records.InstancesRecords.PowerToGasInstancesRecord(), nRegions) "PtG system parametrization" annotation (Dialog(group="Power To Gas", tab="Technology Parametrization"));
  parameter Records.InstancesRecords.PowerToGasInstancesRecord[nRegions] powerToGasInstancesRecord=powerToGasInstancesRecordRegionInfo "PtG system parametrization" annotation (Dialog(group="Power To Gas", tab="Technology Parametrization"));

  //----Gas Storage---//
  //  parameter Records.InstancesRecords.GasStorageInstancesRecord gasStorageInstancesRecord[nRegions]=fill(Records.InstancesRecords.GasStorageInstancesRecord(), nRegions) "Gas storage parametrization" annotation (Dialog(group="Gas Storages", tab="Technology Parametrization"));
  parameter Records.InstancesRecords.GasStorageInstancesRecord gasStorageInstancesRecord[nRegions]=gasStorageInstancesRecordRegionInfo "Gas Storage parametrization" annotation (Dialog(group="Gas Storages", tab="Technology Parametrization"));

  //----Local demand---//
  //  parameter Records.InstancesRecords.LocalDemandInstancesRecord localDemandInstancesRecord[nRegions]= fill(Records.InstancesRecords.LocalDemandInstancesRecord(), nRegions) "Local demand parametrization" annotation (Dialog(group="Local Demand", tab="Technology Parametrization"));
  parameter Records.InstancesRecords.LocalDemandInstancesRecord localDemandInstancesRecord[nRegions]=localDemandInstancesRecordRegionInfo "Local demand parametrization" annotation (Dialog(group="Local Demand", tab="Technology Parametrization"));

  //----Local Renewable Production---//
  parameter Records.InstancesRecords.LocalRenewableProductionInstancesRecord localRenewableProductionInstancesRecord[nRegions]=fill(Records.InstancesRecords.LocalRenewableProductionInstancesRecord(), nRegions) "Local renewable production parametrization" annotation (Dialog(group="Local Renewable Production", tab="Technology Parametrization"));

  //----CO2System---//
  //  parameter Records.InstancesRecords.CO2SystemInstancesRecord cO2SystemInstancesRecord[nRegions]= fill(Records.InstancesRecords.CO2SystemInstancesRecord(), nRegions) "CO2 system parametrization" annotation (Dialog(group="CO2System", tab="Technology Parametrization"));
  parameter Records.InstancesRecords.CO2SystemInstancesRecord cO2SystemInstancesRecord[nRegions]=cO2SystemInstancesRecordRegionInfo "CO2 system parametrization" annotation (Dialog(group="CO2System", tab="Technology Parametrization"));

  //----Heating Grid---//
  parameter Records.InstancesRecords.HeatingGridSystemStorageInstancesRecord[nRegions] heatingGridSystemStorageInstancesRecord=fill(Records.InstancesRecords.HeatingGridSystemStorageInstancesRecord(nHeatingGrid=0), nRegions) "Always disabled, under developmeent" annotation (Dialog(
      tab="Technology Parametrization",
      group="Heating Grid",
      enable=false));
  //fill(Records.InstancesRecords.HeatingGridSystemStorageInstancesRecord(), nRegions) annotation (Dialog(group="Heating Grid", tab="Record"));

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput P_set_PowerPlant[nRegions,MaximumDifferentTypesOfPowerPlants] annotation (Placement(transformation(extent={{-120,30},{-100,50}}), iconTransformation(extent={{-120,30},{-100,50}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_set_ElectricalStorage[nRegions,MaximumDifferentTypesOfElectricalStorages] annotation (Placement(transformation(extent={{-120,-10},{-100,10}}), iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput P_set_PtG[nRegions] annotation (Placement(transformation(extent={{-120,-50},{-100,-30}}), iconTransformation(extent={{-120,-50},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealInput P_set_curtailment[nRegions] annotation (Placement(transformation(extent={{-120,-90},{-100,-70}}), iconTransformation(extent={{-120,-90},{-100,-70}})));
  Modelica.Blocks.Interfaces.RealInput P_set_ElectricalHeater[nRegions] annotation (Placement(transformation(extent={{-120,70},{-100,90}}), iconTransformation(extent={{-120,70},{-100,90}})));

  TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp[nRegions] annotation (Placement(transformation(rotation=0, extent={{95,15},{105,25}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn[nRegions,n_gasPort](each Medium=simCenter.gasModel1) annotation (Placement(transformation(extent={{92,-30},{112,-10}})));

  Modelica.Blocks.Interfaces.RealOutput P_PowerPlant_max[nRegions,MaximumDifferentTypesOfPowerPlants] annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Modelica.Blocks.Interfaces.RealOutput P_PowerPlant_is[nRegions] annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Modelica.Blocks.Interfaces.RealOutput P_DAC[nRegions] annotation (Placement(transformation(extent={{100,-62},{120,-42}})));
  Modelica.Blocks.Interfaces.RealOutput P_PowerToGasPlant_is[nRegions] annotation (Placement(transformation(extent={{100,-80},{120,-60}})));
  Modelica.Blocks.Interfaces.RealOutput P_ElectricalHeater_max[nRegions] annotation (Placement(transformation(extent={{100,-98},{120,-78}})));
  Modelica.Blocks.Interfaces.RealOutput P_surplus_region[nRegions] annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,110})));
  Modelica.Blocks.Interfaces.RealOutput P_renewable[nRegions] annotation (Placement(transformation(extent={{100,78},{122,100}})));
  Modelica.Blocks.Interfaces.RealOutput P_max_unload_storage[nRegions,MaximumDifferentTypesOfElectricalStorages] annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,110})));
  Modelica.Blocks.Interfaces.RealOutput P_max_load_storage[nRegions,MaximumDifferentTypesOfElectricalStorages] annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,110})));
  Modelica.Blocks.Interfaces.RealOutput P_storage_is[nRegions,MaximumDifferentTypesOfElectricalStorages] annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,110})));
  Modelica.Blocks.Interfaces.RealOutput f_grid annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,110})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________
  Modelica.Blocks.Sources.RealExpression expression_f_grid(y=epp[1].f) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-68,90})));
  Modelica.Blocks.Sources.RealExpression zero annotation (Placement(transformation(
        extent={{-6,-7},{6,7}},
        rotation=0,
        origin={0,-29})));

  Components.Records.ControllerInputGeneration controllerInputGeneration(
    redeclare package Config = Config,
    nRegions=nRegions,
    MaximumDifferentTypesOfPowerPlants=MaximumDifferentTypesOfPowerPlants,
    MaximumDifferentTypesOfElectricalStorages=MaximumDifferentTypesOfElectricalStorages,
    MaximumDifferentTypesOfPtG=MaximumDifferentTypesOfPtG,
    MaximumDifferentTypesOfElectricHeaters=MaximumDifferentTypesOfElectricHeaters,
    DifferentTypesOfPowerPlants=DifferentTypesOfPowerPlants,
    DifferentTypesOfElectricalStorages=DifferentTypesOfElectricalStorages,
    DifferentTypesOfPowerToGasPlants=DifferentTypesOfPowerToGasPlants,
    DifferentTypesOfElectricHeater=DifferentTypesOfElectricHeater,
    powerPlantInstancesRecord=powerPlantInstancesRecord,
    electricalStorageInstancesRecord=electricalStorageInstancesRecord,
    powerToGasInstancesRecord=powerToGasInstancesRecord,
    heatingGridSystemStorageInstancesRecord=heatingGridSystemStorageInstancesRecord,
    NumberOfPowerplantsOverAllRegions=NumberOfPowerplantsOverAllRegions,
    NumberOfElectricalStoragesOverAllRegions=NumberOfElectricalStoragesOverAllRegions,
    NumberOfPowerToGasPlantsOverAllRegions=NumberOfPowerToGasPlantsOverAllRegions,
    NumberOfElectricalHeatersOverAllRegions=NumberOfElectricalHeatersOverAllRegions) annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

  //---Superstructures---//
  Components.Superstructure superstructure[nRegions](
    redeclare package Config = Config,
    Region=Region,
    useVariableHydrogenFraction=useVariableHydrogenFraction,
    each medium_CO2=medium_CO2,
    each medium=medium,
    each medium_Hydrogen=medium_Hydrogen,
    splitHeatingDemand_heatingGrid=fill(1, nRegions) - splitHeatingDemand_localHeating,
    splitHeatingDemand_localHeating=splitHeatingDemand_localHeating,
    p_gasGrid_desired=p_gasGrid_desired,
    p_gasGrid_desired_bandwidth=p_gasGrid_desired_bandwidth,
    each m_flow_small=m_flow_small,
    usageOfWasteHeatOfPtG=usageOfWasteHeatOfPtG,
    each useOneGasPortOnly=useOneGasPortOnly,
    T_supply_max_districtHeating=T_supply_max_districtHeating,
    T_return_min_districtHeating=T_return_min_districtHeating,
    useHydrogenFromPtGInPowerPlants=useHydrogenFromPtGInPowerPlants,
    useImportExportBoundary=useImportExportBoundary,
    junctionVolume=junctionVolume,
    each p_min_operating_PowerPlants_backin=p_min_operating_PowerPlants_backin,
    each p_min_operating_PowerPlants=p_min_operating_PowerPlants,
    each p_min_operating_localDemand_backin=p_min_operating_localDemand_backin,
    each p_min_operating_localDemand=p_min_operating_localDemand,
    electricalStorageInstancesRecord=electricalStorageInstancesRecord,
    gasStorageInstancesRecord=gasStorageInstancesRecord,
    powerPlantInstancesRecord=powerPlantInstancesRecord,
    localDemandInstancesRecord=localDemandInstancesRecord,
    localRenewableProductionInstancesRecord=localRenewableProductionInstancesRecord,
    powerToGasInstancesRecord=powerToGasInstancesRecord,
    cO2SystemInstancesRecord=cO2SystemInstancesRecord,
    heatingGridSystemStorageInstancesRecord=heatingGridSystemStorageInstancesRecord,
    DifferentTypesOfPowerPlants=DifferentTypesOfPowerPlants,
    DifferentTypesOfCHPPlants=DifferentTypesOfCHPPlants,
    DifferentTypesOfElectricalStorages=DifferentTypesOfElectricalStorages,
    DifferentTypesOfPowerToGasPlants=DifferentTypesOfPowerToGasPlants,
    DifferentTypesOfElectricHeater=DifferentTypesOfElectricHeater,
    DifferentTypesOfGasBoiler=DifferentTypesOfGasBoiler,
    DifferentTypesOfGasStorage=DifferentTypesOfGasStorage,
    each slackBoundaryPosition=slackBoundaryPosition,
    localElectricDemand_pathToTable=localElectricDemand_pathToTable,
    localElectricDemand_constantMultiplier=localElectricDemand_constantMultiplier,
    localGasDemand_pathToTable=localGasDemand_pathToTable,
    localGasDemand_constantMultiplier=localGasDemand_constantMultiplier,
    localSolarthermalProduction_pathToTable=localSolarthermalProduction_pathToTable,
    localSolarthermalProduction_constantMultiplier=localSolarthermalProduction_constantMultiplier,
    localTemperature_pathToTable=localTemperature_pathToTable,
    localTemperature_constantMultiplier=localTemperature_constantMultiplier,
    localHeatDemand_pathToTable=localHeatDemand_pathToTable,
    localHeatDemand_constantMultiplier=localHeatDemand_constantMultiplier,
    localBiogasProduction_pathToTable=localBiogasProduction_pathToTable,
    localBiogasProduction_constantMultiplier=localBiogasProduction_constantMultiplier,
    localWindOffshoreProduction_pathToTable=localWindOffshoreProduction_pathToTable,
    localWindOffshoreProduction_constantMultiplier=localWindOffshoreProduction_constantMultiplier,
    localBiomassProduction_pathToTable=localBiomassProduction_pathToTable,
    localBiomassProduction_constantMultiplier=localBiomassProduction_constantMultiplier,
    localPhotovoltaicProduction_pathToTable=localPhotovoltaicProduction_pathToTable,
    localPhotovoltaicProduction_constantMultiplier=localPhotovoltaicProduction_constantMultiplier,
    localWindOnshoreProduction_pathToTable=localWindOnshoreProduction_pathToTable,
    localWindOnshoreProduction_constantMultiplier=localWindOnshoreProduction_constantMultiplier) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  //---Extend External Data Import---// // At this place to appear last as last tab
  extends ExternalDataImport(nRegions_info=nRegions);

equation

  // _____________________________________________
  //
  //                   Connects
  // _____________________________________________
  for i in 1:nRegions loop
    //Power Plants
    for j in 1:MaximumDifferentTypesOfPowerPlants loop
      if j <= DifferentTypesOfPowerPlants[i] then
        connect(P_set_PowerPlant[i, j], superstructure[i].P_set_PowerPlant[j]) annotation (Line(points={{-110,40},{-58,40},{-58,2.16667},{-10,2.16667}}, color={0,0,127}));
        connect(superstructure[i].P_PowerPlant_max[j], P_PowerPlant_max[i, j]) annotation (Line(points={{10.8333,7.5},{80,7.5},{80,50},{110,50}}, color={0,0,127}));
      else
        connect(zero.y, P_PowerPlant_max[i, j]) annotation (Line(points={{6.6,-29},{40,-29},{40,50},{110,50}}, color={0,0,127}));
      end if;
    end for;

    //Electrical Storages
    for j in 1:MaximumDifferentTypesOfElectricalStorages loop
      if j <= DifferentTypesOfElectricalStorages[i] then
        connect(P_set_ElectricalStorage[i, j], superstructure[i].P_set_ElectricalStorage[j]) annotation (Line(points={{-110,0},{-10,0}},                 color={0,127,127}));

        connect(superstructure[i].P_storage_is[j], P_storage_is[i, j]) annotation (Line(points={{10.8333,-9.16667},{14,-9.16667},{14,96},{0,96},{0,110}}, color={0,0,127}));
        connect(superstructure[i].P_max_load_storage[j], P_max_load_storage[i, j]) annotation (Line(points={{10.8333,-10.8333},{18,-10.8333},{18,92},{80,92},{80,110}}, color={0,0,127}));
        connect(superstructure[i].P_max_unload_storage[j], P_max_unload_storage[i, j]) annotation (Line(points={{10.8333,-12.5},{16,-12.5},{16,96},{40,96},{40,110}}, color={0,0,127}));
      else
        connect(zero.y, P_storage_is[i, j]) annotation (Line(points={{6.6,-29},{14,-29},{14,96},{0,96},{0,110}}, color={0,0,127}));
        connect(zero.y, P_max_load_storage[i, j]) annotation (Line(points={{6.6,-29},{18,-29},{18,92},{80,92},{80,110}}, color={0,0,127}));
        connect(zero.y, P_max_unload_storage[i, j]) annotation (Line(points={{6.6,-29},{16,-29},{16,96},{40,96},{40,110}}, color={0,0,127}));
      end if;
    end for;
    //end if;

    //Power to Gas
    if superstructure[i].PowerToGasPlantsInThisRegion then
      connect(superstructure[i].P_set_PtG, P_set_PtG[i]) annotation (Line(points={{-10,-2.16667},{-60,-2.16667},{-60,-40},{-110,-40}},   color={0,0,127}));
    end if;
    //Curtailment
    connect(superstructure[i].P_set_curtailment, P_set_curtailment[i]) annotation (Line(points={{-10,-4.33333},{-58,-4.33333},{-58,-80},{-110,-80}}, color={0,0,127}));

    //epp and gasPort
    connect(superstructure[i].epp, epp[i]) annotation (Line(
        points={{10,1.66667},{90,1.66667},{90,20},{100,20}},
        color={28,108,200},
        thickness=0.5));
    connect(superstructure[i].gasPortIn, gasPortIn[i, :]) annotation (Line(
        points={{10.1667,-1.66667},{90,-1.66667},{90,-20},{102,-20}},
        color={255,255,0},
        thickness=1.5));
  end for;

  connect(superstructure.P_set_ElectricalHeater, P_set_ElectricalHeater) annotation (Line(points={{-10,4.33333},{-56,4.33333},{-56,80},{-110,80}},                   color={0,0,127}));
  connect(superstructure.P_DAC, P_DAC) annotation (Line(points={{10.8333,5.83333},{80,5.83333},{80,-52},{110,-52}}, color={0,0,127}));
  connect(superstructure.P_PowerToGasPlant_is, P_PowerToGasPlant_is) annotation (Line(points={{10.8333,4.16667},{76,4.16667},{76,-70},{110,-70}}, color={0,0,127}));
  connect(superstructure.P_PowerPlant_is, P_PowerPlant_is) annotation (Line(points={{10.8333,9.16667},{76,9.16667},{76,70},{110,70}}, color={0,0,127}));

  connect(superstructure.P_renewable, P_renewable) annotation (Line(points={{10.8333,-7.5},{68,-7.5},{68,89},{111,89}}, color={0,0,127}));
  connect(superstructure.P_surplus_region, P_surplus_region) annotation (Line(points={{10.8333,-5.83333},{12,-5.83333},{12,92},{-40,92},{-40,110}}, color={0,0,127}));
  connect(superstructure.P_ElectricalHeater_max, P_ElectricalHeater_max) annotation (Line(points={{10.8333,-4.16667},{72,-4.16667},{72,-88},{110,-88}}, color={0,0,127}));
  connect(expression_f_grid.y, f_grid) annotation (Line(points={{-79,90},{-80,90},{-80,110}}, color={0,0,127}));

  annotation (
    Dialog(tab="ControllerInput"),
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={Rectangle(
                extent={{58,24},{48,-2}},
                lineColor={28,108,200},
                fillColor={28,108,200},
                fillPattern=FillPattern.None),Ellipse(
                extent={{-100,100},{100,-100}},
                lineColor={0,0,0},
                lineThickness=1,
                closure=EllipseClosure.None),Polygon(
                points={{-100,100},{-100,0},{-98,26},{-92,42},{-84,56},{-74,68},{-72,70},{-62,80},{-42,92},{-18,100},{0,100},{-100,100}},
                lineColor={0,0,0},
                lineThickness=1,
                fillPattern=FillPattern.Sphere,
                fillColor={28,108,200}),Polygon(
                points={{100,100},{100,0},{98,26},{92,42},{84,56},{74,68},{72,70},{62,80},{42,92},{18,100},{0,100},{100,100}},
                lineColor={0,0,0},
                lineThickness=1,
                fillPattern=FillPattern.Sphere,
                fillColor={28,108,200}),Polygon(
                points={{100,-100},{100,0},{98,-26},{92,-42},{84,-56},{74,-68},{72,-70},{62,-80},{42,-92},{18,-100},{0,-100},{100,-100}},
                lineColor={0,0,0},
                lineThickness=1,
                fillPattern=FillPattern.Sphere,
                fillColor={28,108,200}),Polygon(
                points={{-100,-100},{-100,0},{-98,-26},{-92,-42},{-84,-56},{-74,-68},{-72,-70},{-62,-80},{-42,-92},{-18,-100},{0,-100},{-100,-100}},
                lineColor={0,0,0},
                lineThickness=1,
                fillPattern=FillPattern.Sphere,
                fillColor={28,108,200})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>A mask for <a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Components.Superstructure\">superstructures</a> allowing</p>
<ol>
<li>easy array definition</li>
<li>manual parametrization of this portfolio&apos;s records. </li>
</ol>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span> </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span> </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>Outputs:</p>
<ul>
<li>epp: complex electric power port</li>
<li>gasPort: gas port</li>
<li>f_grid: output current grid frequency at first superstructure epp</li>
<li>P_renewable: output current renewable power </li>
<li>P_max_unload_storage: output current electrical storage maximum unload power</li>
<li>P_max_load_storage: output current electrical storage maximum load power</li>
<li>P_storage_is: output current electrical storage power</li>
<li>P_PowerToGasPlant_is: output current power to gas plants consumed power</li>
<li>P_PowerPlant_max: output current powerplant relative potential power output</li>
<li>P_PowerPlant_is: output current powerplant power in each region</li>
<li>P_ElectricalHeater_max: output current potential of local heating grid power to heat</li>
<li>P_DAC: output current direct air capture power consumption</li>
</ul>
<p>Inputs:</p>
<ul>
<li>P_curtailment: input current curtailment of renewables setpoint</li>
<li>P_set_ElectricalHeater: input local heating grid power to heat setpoint</li>
<li>P_set_ElectricalStorage: input current electrical storage setpoint power</li>
<li>P_set_PowerPlant: input current power plant setpoint power</li>
<li>P_set_PtG: input current power to gas setpoint power </li>
</ul>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span> </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span> </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span> </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks) </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span> </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jon Babst (babst@xrg-simulation.de) on 03.09.2021. </span></p>
</html>"));
end Superstructures_PortfolioMask;
