within TransiEnt.SystemGeneration.Superstructure.Components;
model Superstructure "Representation of a certain region in terms of consumption and production of electrical power and gas"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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
  //              General Parameters
  // _____________________________________________

  replaceable package Config = Portfolios.Portfolio_Example constrainedby Portfolios.Base        annotation (choicesAllMatching=true);
  parameter Integer Region=1 "Define Region Number";

  parameter Integer DifferentTypesOfPowerPlants "0 to x";
  parameter Integer DifferentTypesOfCHPPlants "0 or 1";
  parameter Integer DifferentTypesOfElectricalStorages "0 to x";
  parameter Integer DifferentTypesOfPowerToGasPlants "0 or 1";
  parameter Integer DifferentTypesOfElectricHeater "0 or 1";
  parameter Integer DifferentTypesOfGasBoiler "0 or 1";
  parameter Integer DifferentTypesOfGasStorage "0 or 1";

  parameter Boolean CHPPlantsInThisRegion=if DifferentTypesOfCHPPlants > 0 then true else false "true, if CHP plants exist in region";

  parameter Boolean ElectricalHeaterInThisRegion=if DifferentTypesOfElectricHeater > 0 then true else false "true, if electrical heater exist in region";
  parameter Boolean PowerPlantsInThisRegion=if DifferentTypesOfPowerPlants > 0 then true else false "true, if power plants exist in region";
  parameter Boolean PowerToGasPlantsInThisRegion=if DifferentTypesOfPowerToGasPlants > 0 then true else false "true, if power to gas plants exist in region";
  parameter Boolean ElectricalStoragesInThisRegion=if DifferentTypesOfElectricalStorages > 0 then true else false "true, if electrical storages exist in region";
  parameter Boolean GasBoilerInThisRegion=if DifferentTypesOfGasBoiler > 0 then true else false "true, if gas boiler exist in region";
  parameter Boolean GasStorageInThisRegion=if DifferentTypesOfGasStorage > 0 then true else false "true, if gas storages exist in region";

  parameter Boolean useVariableHydrogenFraction=false;

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_CO2=simCenter.gasModel1 "CO2 model to be used";
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.gasModel1 "Gas model to be used" annotation (Dialog(group="Fundamental Definitions"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium_Hydrogen=simCenter.gasModel3 "Hydrogen model zo be used" annotation (Dialog(group="Fundamental Definitions"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_small=0.1 "small leakage mass flow for numerical stability";

  //PowerPlants/ToGas
  parameter Integer[2] slackBoundaryPosition "Indices [Region, MaxDifferentTypesOfPowerplants] of where the epp slack boundary is positioned";
  parameter Boolean useHydrogenFromPtGInPowerPlants=false annotation (Dialog(group="PowerPlants/PtG"));
  final parameter Boolean ptGTypeIsMethanation=if PowerToGasPlantsInThisRegion == false then false else not (powerToGasInstancesRecord.powerToGasType == Config.PowerToGasType(1) or powerToGasInstancesRecord.powerToGasType == Config.PowerToGasType(2) or powerToGasInstancesRecord.powerToGasType == Config.PowerToGasType(3));
  //parameter SI.Mass m_start_CO2_storage=0;//moved to record

  final parameter Boolean CO2NeededForPowerToGas=if PowerToGasPlantsInThisRegion == false then false elseif ptGTypeIsMethanation then true else false annotation (Dialog(group="PowerPlants/PtG"));
  final parameter Boolean CCSInPowerPlants=if PowerPlantsInThisRegion == false then false elseif max(powerPlantInstancesRecord.powerPlantRecord[:].CO2_Deposition_Rate) > 0 then true else false;
  final parameter Real CO2StorageNeeded=if PowerToGasPlantsInThisRegion == false and CCSInPowerPlants == false then 0 elseif CO2NeededForPowerToGas or CCSInPowerPlants == true then 1 else 0 annotation (Dialog(group="PowerPlants/PtG"));

  parameter Integer usageOfWasteHeatOfPtG=1 "Waste heat usage of PtG" annotation (Dialog(group="PowerPlants/PtG"), choices(
      choice=1 "No Usage",
      choice=2 "CO2 Desorption",
      choice=3 "District Heating"));

  parameter Real splitHeatingDemand_heatingGrid=1 - splitHeatingDemand_heatingGrid "Fraction of table data values referring to the heating grid" annotation (Dialog(group="PowerPlants/PtG"));
  parameter Real splitHeatingDemand_localHeating=1 "Fraction of table data values referring to local heating" annotation (Dialog(group="PowerPlants/PtG"));

  //HeatingGrid
  parameter Modelica.Units.NonSI.Temperature_degC T_supply_max_districtHeating=149 annotation (Dialog(group="HeatingGrid"));
  parameter Modelica.Units.NonSI.Temperature_degC T_return_min_districtHeating=49 annotation (Dialog(group="HeatingGrid"));

  //GasGrid
  parameter Modelica.Units.SI.Pressure p_gasGrid_desired=simCenter.p_amb_const + simCenter.p_eff_2 "desired gas grid pressure in region" annotation (Dialog(group="GasGrid"));
  parameter Modelica.Units.SI.PressureDifference p_gasGrid_desired_bandwidth=0 "band width around p_gasGrid_desired in which the set value varies depending on the SOC of the gas storage" annotation (Dialog(group="GasGrid"));

  final parameter Integer NeededGasPortsForJunction=integer(3 + TransiEnt.Basics.Functions.boolean2integer(PowerToGasPlantsInThisRegion) + nPowerPlants + TransiEnt.Basics.Functions.boolean2integer(GasStorageInThisRegion) + TransiEnt.Basics.Functions.boolean2integer(ElectricalHeaterInThisRegion or CHPPlantsInThisRegion)) annotation (Dialog(group="GasGrid"));
  //+TransiEnt.Basics.Functions.boolean2integer(useImportExportBoundary));

  // parameter Real gridLosses_districtHeating=0.127   moved to record
  //inner
  inner parameter Modelica.Units.SI.MassFraction xi_const_noZeroMassFlow[max(simCenter.gasModel1.nc - 1, 1)]=if simCenter.gasModel1.nc == 1 then {1} elseif simCenter.gasModel1.nc == 2 then {1} else {0.85883115,0.06193993,0.01007228,0.00201834,0.04370946,0.02342884} annotation (Dialog(group="GasGrid"));

  parameter Boolean useOneGasPortOnly=true annotation (Dialog(group="GasGrid"));
  final parameter Integer n_gasPort=if useOneGasPortOnly then 1 else 6 annotation (Dialog(group="GasGrid"));

  parameter Boolean useImportExportBoundary=false "useOneGasPortOnly has to be turned on for this" annotation (Dialog(enable=useOneGasPortOnly, group="GasGrid"));

  parameter Real junctionVolume=10676.7 "Central gas volume if useOneGasPortOnly" annotation (Dialog(group="GasGrid"));

  // Gas Port Splitting for connection to multiple gas nodes
  parameter Integer n_gasPortOut_powerPlants=1 annotation (Dialog(group="GasPortSplitter"));
  parameter Integer n_gasPortOut_localDemand=1 annotation (Dialog(group="GasPortSplitter"));
  parameter Real splitRatio_powerPlants[max(1, n_gasPortOut_powerPlants)]={0.1} annotation (Dialog(group="GasPortSplitter"));
  parameter Real splitRatio_localDemand[max(1, n_gasPortOut_localDemand)]={0.1} annotation (Dialog(group="GasPortSplitter"));

  //---Failures---//
  parameter SI.Pressure p_min_operating_PowerPlants=1e5 "gas pressure threshold at which powerplants turn off" annotation (dialog(tab="Failures"));
  parameter SI.Pressure p_min_operating_PowerPlants_backin=2e5 "gas pressure threshold at which powerplants turn back on after turning off" annotation (dialog(tab="Failures"));
  parameter SI.Pressure p_min_operating_localDemand=1e5 "gas pressure threshold at which local consumers turn off" annotation (dialog(tab="Failures"));
  parameter SI.Pressure p_min_operating_localDemand_backin=2e5 "gas pressure threshold at which powerplants turn back on after turning off" annotation (dialog(tab="Failures"));

  //---Tables---//
  parameter String localElectricDemand_pathToTable;
  parameter Real localElectricDemand_constantMultiplier=1.0 "Multiply output with constant factor";
  parameter String localGasDemand_pathToTable;
  parameter Real localGasDemand_constantMultiplier=1.0 "Multiply output with constant factor";
  parameter String localSolarthermalProduction_pathToTable;
  parameter Real localSolarthermalProduction_constantMultiplier=1.0 "Multiply output with constant factor";

  parameter String localTemperature_pathToTable;
  parameter Real localTemperature_constantMultiplier=1.0 "Multiply output with constant factor";
  parameter String localHeatDemand_pathToTable;
  parameter Real localHeatDemand_constantMultiplier=1.0 "Multiply output with constant factor";

  parameter String localBiogasProduction_pathToTable;
  parameter Real localBiogasProduction_constantMultiplier=1.0 "Multiply output with constant factor";
  parameter String localWindOffshoreProduction_pathToTable;
  parameter Real localWindOffshoreProduction_constantMultiplier=1.0 "Multiply output with constant factor";
  parameter String localBiomassProduction_pathToTable;
  parameter Real localBiomassProduction_constantMultiplier=1.0 "Multiply output with constant factor";
  parameter String localPhotovoltaicProduction_pathToTable;
  parameter Real localPhotovoltaicProduction_constantMultiplier=1.0 "Multiply output with constant factor";
  parameter String localWindOnshoreProduction_pathToTable;
  parameter Real localWindOnshoreProduction_constantMultiplier=1.0 "Multiply output with constant factor";

  //---Instance Records--//
  //----Electrical Storage---//
  parameter Config.Records.InstancesRecords.ElectricalStorageInstancesRecord electricalStorageInstancesRecord=Config.Records.InstancesRecords.ElectricalStorageInstancesRecord() annotation (Dialog(tab="Records", group="Electrical Storages"));

  //----Gas Storage---//
  parameter Config.Records.InstancesRecords.GasStorageInstancesRecord gasStorageInstancesRecord=Config.Records.InstancesRecords.GasStorageInstancesRecord() annotation (Dialog(tab="Records", group="Gas Storages"));

  //---- Power plants---//
  final parameter Integer nPowerPlants=powerPlantInstancesRecord.nPowerPlants annotation (Dialog(tab="Records", group="Power Plants"));
  parameter Config.Records.InstancesRecords.PowerPlantInstancesRecord powerPlantInstancesRecord=Config.Records.InstancesRecords.PowerPlantInstancesRecord() annotation (Dialog(tab="Records", group="Power Plants"));

  //----Local demand---//
  parameter Config.Records.InstancesRecords.LocalDemandInstancesRecord localDemandInstancesRecord=Config.Records.InstancesRecords.LocalDemandInstancesRecord() annotation (Dialog(tab="Records", group="Local Demand"));

  //----Local Renewable Production---//
  parameter Config.Records.InstancesRecords.LocalRenewableProductionInstancesRecord localRenewableProductionInstancesRecord=Config.Records.InstancesRecords.LocalRenewableProductionInstancesRecord() annotation (Dialog(tab="Records", group="Local Renewable Production"));

  //----CO2System---//
  parameter Config.Records.InstancesRecords.CO2SystemInstancesRecord cO2SystemInstancesRecord=Config.Records.InstancesRecords.CO2SystemInstancesRecord() annotation (Dialog(tab="Records", group="CO2System"));

  //----Power to gas---//
  parameter Config.Records.InstancesRecords.PowerToGasInstancesRecord powerToGasInstancesRecord=Config.Records.InstancesRecords.PowerToGasInstancesRecord() annotation (Dialog(tab="Records", group="Power To Gas"));

  //----Heating Grid---//
  parameter Config.Records.InstancesRecords.HeatingGridSystemStorageInstancesRecord heatingGridSystemStorageInstancesRecord=Config.Records.InstancesRecords.HeatingGridSystemStorageInstancesRecord() annotation (Dialog(tab="Records", group="Heating Grid"));

  // ---------- Gas Port Connect -------------
  final parameter Integer connectLocalDemand=1;
  final parameter Integer connectlocalRenewableProduction=2;
  final parameter Integer connectGasStorages=3;
  final parameter Integer connectPowerToGas=if GasStorageInThisRegion then 4 else 3;
  final parameter Integer connectPowerPlants=if GasStorageInThisRegion and PowerToGasPlantsInThisRegion then 5 elseif GasStorageInThisRegion or PowerToGasPlantsInThisRegion then 4 else 3;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ComplexPowerPort epp annotation (Placement(transformation(rotation=0, extent={{115,15},{125,25}})));
  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasPortIn[n_gasPort](each Medium=simCenter.gasModel1) annotation (Placement(transformation(extent={{112,-30},{132,-10}})));

  Modelica.Blocks.Interfaces.RealInput P_set_PowerPlant[nPowerPlants] annotation (Placement(transformation(extent={{-140,6},{-100,46}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P_set_ElectricalStorage[DifferentTypesOfElectricalStorages] annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput P_set_curtailment annotation (Placement(transformation(extent={{-140,-72},{-100,-32}})));
  Modelica.Blocks.Interfaces.RealInput P_set_PtG annotation (Placement(transformation(extent={{-140,-46},{-100,-6}})));
  Modelica.Blocks.Interfaces.RealInput P_set_ElectricalHeater annotation (Placement(transformation(extent={{-140,32},{-100,72}})));

  Modelica.Blocks.Interfaces.RealOutput P_PowerPlant_max[DifferentTypesOfPowerPlants] if DifferentTypesOfPowerPlants >= 1 annotation (Placement(transformation(extent={{120,80},{140,100}})));
  Modelica.Blocks.Interfaces.RealOutput P_PowerPlant_is annotation (Placement(transformation(extent={{120,100},{140,120}})));
  Modelica.Blocks.Interfaces.RealOutput P_DAC annotation (Placement(transformation(extent={{120,60},{140,80}})));
  Modelica.Blocks.Interfaces.RealOutput P_PowerToGasPlant_is annotation (Placement(transformation(extent={{120,40},{140,60}})));
  Modelica.Blocks.Interfaces.RealOutput P_max_load_storage[DifferentTypesOfElectricalStorages] if DifferentTypesOfElectricalStorages >= 1 annotation (Placement(transformation(extent={{120,-140},{140,-120}})));
  Modelica.Blocks.Interfaces.RealOutput P_max_unload_storage[DifferentTypesOfElectricalStorages] if DifferentTypesOfElectricalStorages >= 1 annotation (Placement(transformation(extent={{120,-160},{140,-140}})));
  Modelica.Blocks.Interfaces.RealOutput P_storage_is[DifferentTypesOfElectricalStorages] if DifferentTypesOfElectricalStorages >= 1 annotation (Placement(transformation(extent={{120,-120},{140,-100}})));
  Modelica.Blocks.Interfaces.RealOutput P_ElectricalHeater_max annotation (Placement(transformation(extent={{120,-60},{140,-40}})));
  Modelica.Blocks.Interfaces.RealOutput P_surplus_region annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  Modelica.Blocks.Interfaces.RealOutput P_renewable annotation (Placement(transformation(extent={{120,-100},{140,-80}})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  //----Electrical Storage----//
  Config.ElectricalStorageSystem electricalStorageSystem[DifferentTypesOfElectricalStorages](
    redeclare package Config = Config,
    electricalStorageType=electricalStorageInstancesRecord.electricalStorageType,
    electricalStorageRecord=electricalStorageInstancesRecord.electricalStorageRecord) if ElectricalStoragesInThisRegion annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));

  //----Gas Storage----//
  Config.GasStorageSystem gasStorageSystem(
    medium=medium,
    p_gasGrid_desired=p_gasGrid_desired,
    redeclare package Config = Config,
    gasStorageType=gasStorageInstancesRecord.gasStorageType,
    gasStorageRecord=gasStorageInstancesRecord.gasStorageRecord) if GasStorageInThisRegion annotation (Placement(transformation(extent={{-10,56},{10,76}})));

  Modelica.Blocks.Sources.RealExpression expression_pGas_gasStorage(y=gasPortIn[1].p) annotation (Placement(transformation(extent={{-103,59},{-93,73}})));

  Controller.ControlGasStorage_oneWay controlGasStorage(
    Vgeo_per_mMax=gasStorageInstancesRecord.gasStorageRecord.Vgeo_per_mMax,
    m_flow_inMax=gasStorageInstancesRecord.gasStorageRecord.m_flow_inMax,
    m_flow_outMax=gasStorageInstancesRecord.gasStorageRecord.m_flow_outMax,
    GasStrorageTypeNo=gasStorageInstancesRecord.gasStorageRecord.GasStrorageTypeNo,
    failure_table=failure_gasStorage_table,
    p_gasGrid_desired=p_gasGrid_desired,
    p_gasGrid_desired_bandwidth=p_gasGrid_desired_bandwidth) if GasStorageInThisRegion annotation (Placement(transformation(extent={{-82,60},{-66,74}})));

  //----Power Plants----//
  Config.PowerPlantSystem powerPlantSystem[nPowerPlants](
    each mediumGas=medium,
    each medium_CO2=medium_CO2,
    each m_flow_small=m_flow_small,
    each CO2StorageNeeded=CO2StorageNeeded,
    isSlack={(if slackBoundaryPosition[1] == Region and slackBoundaryPosition[2] == j then true else false) for j in 1:nPowerPlants},
    redeclare package Config = Config,
    each CCSInPowerPlants=CCSInPowerPlants,
    each useHydrogenFromPtGInPowerPlants=useHydrogenFromPtGInPowerPlants,
    powerPlantType=powerPlantInstancesRecord.powerPlantType,
    powerPlantRecord=powerPlantInstancesRecord.powerPlantRecord) if PowerPlantsInThisRegion annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  Controller.ControlPowerPlant controlPowerPlant(
    DifferentTypesOfPowerPlants=nPowerPlants,
    p_min=p_min_operating_PowerPlants,
    p_min_backin=p_min_operating_PowerPlants_backin,
    powerPlants_P_el_n=powerPlantInstancesRecord.powerPlantRecord[:].P_el_n,
    n_gasPortOut_split=n_gasPortOut_powerPlants,
    splitRatio=splitRatio_powerPlants) if PowerPlantsInThisRegion annotation (Placement(transformation(extent={{-76,18},{-64,28}})));

  Modelica.Blocks.Sources.RealExpression gasPressure[n_gasPortOut_powerPlants](y=gasPortIn[1].p) annotation (Placement(transformation(rotation=0, extent={{-96,16},{-84,24}})));

  TransiEnt.Components.Gas.VolumesValvesFittings.Fittings.RealGasJunction_L2_nPorts_isoth junction1(
    n_ports=NeededGasPortsForJunction,
    volume=junctionVolume,
    m_flow_nom=ones(junction1.n_ports)*(junction1.volume*48.3588/60)) if useOneGasPortOnly annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={44,-20})));

  //----Local Demand----//
  Config.LocalDemand localDemand(
    medium=medium,
    p_min=p_min_operating_localDemand,
    p_min_backin=p_min_operating_localDemand_backin,
    p_gasGrid_desired=p_gasGrid_desired,
    n_gasPortOut_split=n_gasPortOut_localDemand,
    splitRatio=splitRatio_localDemand,
    localDemandRecord=localDemandInstancesRecord.localDemandRecord,
    localElectricDemand_pathToTable=localElectricDemand_pathToTable,
    localElectricDemand_constantMultiplier=localElectricDemand_constantMultiplier,
    localGasDemand_pathToTable=localGasDemand_pathToTable,
    localGasDemand_constantMultiplier=localGasDemand_constantMultiplier,
    localSolarthermalProduction_pathToTable=localSolarthermalProduction_pathToTable,
    localSolarthermalProduction_constantMultiplier=localSolarthermalProduction_constantMultiplier) annotation (Placement(transformation(extent={{-10,-116},{10,-94}})));
  TransiEnt.Basics.Tables.GenericDataTable DataTable_HeatDemand(
    use_absolute_path=true,
    absolute_path=localHeatDemand_pathToTable,
    constantfactor=localHeatDemand_constantMultiplier) annotation (Placement(transformation(extent={{-96,-116},{-86,-106}})));
  Modelica.Blocks.Math.Gain gain_HeatingDemand_HeatingGrid(k=splitHeatingDemand_heatingGrid) annotation (Placement(transformation(extent={{-78,-106},{-72,-100}})));
  Modelica.Blocks.Math.Gain gain_HeatingDemand_LocalDemand(k=splitHeatingDemand_localHeating) annotation (Placement(transformation(extent={{-78,-118},{-72,-112}})));
  TransiEnt.Basics.Tables.GenericDataTable DataTable_Temperature(
    use_absolute_path=true,
    absolute_path=localTemperature_pathToTable,
    constantfactor=localTemperature_constantMultiplier) annotation (Placement(transformation(extent={{-96,-102},{-86,-92}})));

  inner Modelica.Units.SI.Temperature T_region=DataTable_Temperature.y1;

  TransiEnt.Components.Sensors.ElectricPowerComplex electricPowerComplex_load annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=0,
        origin={16,-110})));
  TransiEnt.Components.Electrical.Grid.IdealPhaseShifter centralPhaseShifter if simCenter.idealSuperstructLocalGrid annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={121,7})));

  //----Local Renewable Porduction----//
  Config.LocalRenewableProduction localRenewableProduction(
    medium=medium,
    localRenewableProductionRecord=localRenewableProductionInstancesRecord.localRenewableProductionRecord,
    useWindOffshoreInThisRegion=true,
    localBiogasProduction_pathToTable=localBiogasProduction_pathToTable,
    localBiogasProduction_constantMultiplier=localBiogasProduction_constantMultiplier,
    localWindOffshoreProduction_pathToTable=localWindOffshoreProduction_pathToTable,
    localWindOffshoreProduction_constantMultiplier=localWindOffshoreProduction_constantMultiplier,
    localBiomassProduction_pathToTable=localBiomassProduction_pathToTable,
    localBiomassProduction_constantMultiplier=localBiomassProduction_constantMultiplier,
    localPhotovoltaicProduction_pathToTable=localPhotovoltaicProduction_pathToTable,
    localPhotovoltaicProduction_constantMultiplier=localPhotovoltaicProduction_constantMultiplier,
    localWindOnshoreProduction_pathToTable=localWindOnshoreProduction_pathToTable,
    localWindOnshoreProduction_constantMultiplier=localWindOnshoreProduction_constantMultiplier) annotation (Placement(transformation(extent={{-10,-90},{10,-68}})));

  TransiEnt.Components.Sensors.ElectricPowerComplex electricPowerComplex_localRenewableProduction annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=0,
        origin={16,-80})));

  //----CO2System----//
  Config.CO2System cO2System(
    medium=medium_CO2,
    CO2NeededForPowerToGas=CO2NeededForPowerToGas,
    CO2StorageNeeded=CO2StorageNeeded,
    nPowerPlants=powerPlantInstancesRecord.nPowerPlants,
    cO2SystemRecord=cO2SystemInstancesRecord.cO2SystemRecord) if CO2StorageNeeded > 0 annotation (Placement(transformation(extent={{-10,28},{10,48}})));

  Controller.ControlCO2 controlCO2(
    CCSInPowerPlants=CCSInPowerPlants,
    CO2NeededForPowerToGas=CO2NeededForPowerToGas,
    usageOfWasteHeatOfPtG=usageOfWasteHeatOfPtG,
    powertToGas_P_el_n=powerToGasInstancesRecord.powerToGasRecord.P_el_n,
    powerToGas_eta_n=powerToGasInstancesRecord.powerToGasRecord.eta_n) annotation (Placement(transformation(extent={{-84,32},{-68,46}})));

  //----PowerToGasSystem----//
  Config.PowerToGasSystem powerToGasSystem(
    medium=medium,
    usageOfWasteHeatOfPtG=usageOfWasteHeatOfPtG,
    medium_Hydrogen=medium_Hydrogen,
    m_flow_small=m_flow_small,
    powerToGasRecord=powerToGasInstancesRecord.powerToGasRecord,
    medium_CO2=medium_CO2,
    useVariableHydrogenFraction=useVariableHydrogenFraction,
    useHydrogenFromPtGInPowerPlants=useHydrogenFromPtGInPowerPlants,
    CO2NeededForPowerToGas=CO2NeededForPowerToGas,
    T_supply_max_districtHeating=T_supply_max_districtHeating,
    powerToGasType=powerToGasInstancesRecord.powerToGasType) if PowerToGasPlantsInThisRegion annotation (Placement(transformation(extent={{-40,-32},{-20,-12}})));

  Controller.ControlPowerToGas controlPowerToGasStorage(
    DifferentTypesOfPowerToGasPlants=1,
    useHydrogenFromPtGInPowerPlants=useHydrogenFromPtGInPowerPlants,
    usageOfWasteHeatOfPtG=usageOfWasteHeatOfPtG,
    CO2NeededForPowerToGas=CO2NeededForPowerToGas,
    P_el_n=powerToGasInstancesRecord.powerToGasRecord.P_el_n,
    eta_n=powerToGasInstancesRecord.powerToGasRecord.eta_n,
    typeIsMethanation=ptGTypeIsMethanation,
    typeIsWOStorage=powerToGasSystem.typeIsWOStorage,
    p_gasGrid_desired=p_gasGrid_desired) if PowerToGasPlantsInThisRegion annotation (Placement(transformation(extent={{-80,-28},{-64,-12}})));

  //----heating grid ---//
  Config.HeatingGrid heatingGridSystem_Storage(
    useExternalHeatSource=if usageOfWasteHeatOfPtG == 3 then true else false,
    T_wasteHeat=if PowerToGasPlantsInThisRegion and ptGTypeIsMethanation then T_supply_max_districtHeating else 68,
    T_supply_max_districtHeating=T_supply_max_districtHeating,
    T_return_min_districtHeating=T_return_min_districtHeating,
    heatingGridSystemStorageRecord=heatingGridSystemStorageInstancesRecord.heatingGridSystemStorageRecord,
    CHPPlantsInThisRegion=CHPPlantsInThisRegion,
    ElectricalHeaterInThisRegion=ElectricalHeaterInThisRegion) if DifferentTypesOfCHPPlants + DifferentTypesOfElectricHeater >= 1 annotation (Placement(transformation(extent={{-10,94},{10,114}})));

  //----other blocks----//
  Modelica.Blocks.Sources.RealExpression expression_pGas_pTG(y=gasPortIn[1].p) annotation (Placement(transformation(extent={{-98,-24},{-88,-10}})));
  Modelica.Blocks.Sources.RealExpression expression_H2gasFrac[max(simCenter.gasModel1.nc - 1, 1)](y=if simCenter.gasModel1.nc == 1 then {1} else inStream(powerToGasSystem.gasPortOut_1.xi_outflow)) if PowerToGasPlantsInThisRegion annotation (Placement(transformation(extent={{-98,-34},{-88,-20}})));
  Modelica.Blocks.Sources.RealExpression realExpression14(y=273.15 + 100) if CO2NeededForPowerToGas and (usageOfWasteHeatOfPtG == 1 or usageOfWasteHeatOfPtG == 3) annotation (Placement(transformation(extent={{-46,44},{-36,52}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature if CO2NeededForPowerToGas and (usageOfWasteHeatOfPtG == 1 or usageOfWasteHeatOfPtG == 3) annotation (Placement(transformation(extent={{-30,46},{-26,50}})));
  //Modelica.Blocks.Sources.RealExpression PP_gasMassFlow(y=sum(powerPlantSystem[:].massFlowSensor_PowerPlants.m_flow)) annotation (Placement(transformation(rotation=0, extent={{-88,-50},{-74,-40}})));

  TransiEnt.Consumer.Gas.GasConsumer_HFlow_NCV boundaryImportExportInRegion(
    xi_const=if simCenter.gasModel1.nc == 2 then {1} else simCenter.gasModel1.xi_default,
    variable_H_flow=false,
    H_flow_const=0,
    mode="Both",
    usePIDcontroller=false,
    flowDefinition=2) if useOneGasPortOnly and useImportExportBoundary annotation (Placement(transformation(extent={{140,20},{160,40}})));

  Modelica.Blocks.Sources.RealExpression Zero annotation (Placement(transformation(
        extent={{-6,-7},{6,7}},
        rotation=0,
        origin={50,117})));

  Modelica.Blocks.Math.MultiSum localSurplusPowerIntern(nu=if DifferentTypesOfCHPPlants + DifferentTypesOfElectricHeater >= 1 then 3 else 2) annotation (Placement(transformation(extent={{106,-74},{114,-66}})));

  Modelica.Blocks.Math.MultiSum sum_P_Powerplants_is(nu=1 + nPowerPlants) annotation (Placement(transformation(extent={{66,10},{72,16}})));
  Modelica.Blocks.Math.MultiSum sum_m_flow_powerPlant_is(nu=1 + nPowerPlants) annotation (Placement(transformation(extent={{66,2},{72,8}})));
  Modelica.Blocks.Math.MultiSum sum_P_PtG_is(nu=1 + (if (PowerToGasPlantsInThisRegion) then 1 else 0)) annotation (Placement(transformation(extent={{66,-28},{72,-22}})));
  Modelica.Blocks.Math.MultiSum sum_m_flow_PtG_is(nu=1 + (if (PowerToGasPlantsInThisRegion)  then 1 else 0)) annotation (Placement(transformation(extent={{66,-36},{72,-30}})));
  Modelica.Blocks.Math.MultiSum sum_E_electricalStorage_is(nu=1 + DifferentTypesOfElectricalStorages) annotation (Placement(transformation(extent={{66,-50},{72,-44}})));
  Modelica.Blocks.Math.MultiSum sum_P_electricalStorage_is(nu=1 + DifferentTypesOfElectricalStorages) annotation (Placement(transformation(extent={{66,-58},{72,-52}})));
  Modelica.Blocks.Math.MultiSum sum_m_gasStorage_is(nu=1 + DifferentTypesOfGasStorage) annotation (Placement(transformation(extent={{68,56},{74,62}})));
  Modelica.Blocks.Math.MultiSum sum_m_flow_gasStorage_is(nu=1 + DifferentTypesOfGasStorage) annotation (Placement(transformation(extent={{68,64},{74,70}})));
  Modelica.Blocks.Math.MultiSum sum_m_flow_CO2fromPowerplants(nu=1 + (if (CO2StorageNeeded>0) then 1 else 0)) annotation (Placement(transformation(extent={{68,34},{74,40}})));
  Modelica.Blocks.Math.MultiSum sum_m_flow_CO2toPtG(nu=1 + (if (CO2StorageNeeded>0) then 1 else 0)) annotation (Placement(transformation(extent={{68,42},{74,48}})));
  Modelica.Blocks.Math.MultiSum sum_P_CO2DAC_is(nu=1 + (if (CO2StorageNeeded>0) then 1 else 0)) annotation (Placement(transformation(extent={{68,26},{74,32}})));
  Modelica.Blocks.Math.MultiSum sum_P_heatingGrid_is(nu=1 + (if (DifferentTypesOfElectricHeater + DifferentTypesOfGasBoiler + DifferentTypesOfCHPPlants) > 0 then 2 else 0)) annotation (Placement(transformation(extent={{68,100},{74,106}})));
  Modelica.Blocks.Math.MultiSum sum_m_flow_heatingGridGas_is(nu=1 + (if (DifferentTypesOfElectricHeater + DifferentTypesOfGasBoiler + DifferentTypesOfCHPPlants) > 0 then 1 else 0)) annotation (Placement(transformation(extent={{68,92},{74,98}})));

  Records.Summary summary(
    P_set_powerPlants=sum({P_set_PowerPlant}),
    P_set_PtG=sum({P_set_PtG}),
    P_set_electricStorages=sum({P_set_ElectricalStorage}),
    P_set_electricHeaters=sum({P_set_ElectricalHeater}),
    P_set_curtailment=sum({P_set_curtailment}),
    electricProduction_powerplants_P=sum_P_Powerplants_is.y,
    electricProduction_renewables_biomass_P=localRenewableProduction.BiomassPlant.epp.P,
    electricProduction_renewables_windOnShore_P=localRenewableProduction.windOnshorePlant.epp.P,
    electricProduction_renewables_windOffShore_P=localRenewableProduction.WindOffshorePlant.epp.P,
    electricProduction_renewables_photovoltaic_P=localRenewableProduction.PVPlant.epp.P,
    electricConsumption_localDemand_P=localDemand.load.epp.P,
    electricConsumption_localHeating_P=localDemand.epp.P - localDemand.load.epp.P,
    electricConsumption_PtG_P=sum_P_PtG_is.y,
    electricConsumption_heatingGrid_P=sum_P_heatingGrid_is.y,
    electricConsumption_DAC_P=sum_P_CO2DAC_is.y,
    gasProduction_renewables_biogas_m_flow=localRenewableProduction.bioGas_HFlow.massflowSensor.m_flow,
    gasProduction_PtG_m_flow=sum_m_flow_PtG_is.y,
    gasConsumption_localHeating_m_flow=localDemand.gasPortOut.m_flow - localDemand.gasConsumer_HFlow.fluidPortIn.m_flow,
    gasConsumption_localDirectUse_m_flow=localDemand.gasConsumer_HFlow.fluidPortIn.m_flow,
    gasConsumption_powerPlants_m_flow=sum_m_flow_powerPlant_is.y,
    gasConsumption_heatingGrid_m_flow=sum_m_flow_heatingGridGas_is.y,
    storages_electricStorages_E=sum_E_electricalStorage_is.y,
    storages_gasStorage_m=sum_m_gasStorage_is.y,
    CO2Sytem_fromPowerPlants_m_flow=sum_m_flow_CO2fromPowerplants.y,
    storages_electricStorages_P=sum_P_electricalStorage_is.y,
    storages_gasStorage_m_flow=sum_m_flow_gasStorage_is.y,
    CO2Sytem_toPtG_m_flow=sum_m_flow_CO2toPtG.y,
    HeatFlow_localHeatingDemand=localDemand.Q_flow,
    HeatFlow_solarthermalProduction=localDemand.gain_SolarthermalProduction.y,
    eppBoundary_f=epp.f,
    eppBoundary_v=epp.v,
    eppBoundray_P=epp.P,
    eppBoundary_Q=epp.Q,
    gasBoundary_p=sum(gasPortIn[:].p)/n_gasPort,
    gasBoundary_m_flow=sum(gasPortIn.m_flow)) annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));

equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////connect statements for electrical storages/////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  connect(P_set_ElectricalStorage, electricalStorageSystem.P_set) annotation (Line(points={{-120,0},{-62,0},{-62,-42.05},{-11.55,-42.05}}, color={0,127,127}));
  for i in 1:DifferentTypesOfElectricalStorages loop
    connect(electricalStorageSystem[i].epp, epp) annotation (Line(
        points={{10,-50},{40,-50},{40,20},{120,20}},
        color={28,108,200},
        thickness=0.5));
  end for;
  connect(electricalStorageSystem.P_max_load_storage, P_max_load_storage) annotation (Line(points={{11.6,-52},{92,-52},{92,-130},{130,-130}}, color={0,0,127}));
  connect(electricalStorageSystem.P_max_unload_storage, P_max_unload_storage) annotation (Line(points={{11.6,-55.8},{90,-55.8},{90,-150},{130,-150}}, color={0,0,127}));
  connect(electricalStorageSystem.P_storage_is, P_storage_is) annotation (Line(points={{11.6,-59},{11.6,-60},{94,-60},{94,-110},{130,-110}}, color={0,0,127}));
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////connect statements for gas storages////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  connect(expression_pGas_gasStorage.y, controlGasStorage.p_gas_region) annotation (Line(points={{-92.5,66},{-92.5,66.3778},{-82.32,66.3778}}, color={0,0,127}));
  connect(controlGasStorage.controlBus, gasStorageSystem.controlBus) annotation (Line(
      points={{-66.16,66.2222},{-10,66}},
      color={255,204,51},
      thickness=0.5));

  if useOneGasPortOnly then
    connect(gasStorageSystem.gasPortIn, junction1.gasPort[connectGasStorages + 1]) annotation (Line(
        points={{10,65.2},{32,65.2},{32,-20},{44,-20}},
        color={255,255,0},
        thickness=1.5));
  else
    connect(gasStorageSystem.gasPortIn, gasPortIn[connectGasStorages]);
  end if;

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////connect statements for power plants////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  for i in 1:nPowerPlants loop
    connect(powerPlantSystem[i].epp_OUT, epp) annotation (Line(
        points={{0,20},{120,20}},
        color={28,108,200},
        thickness=0.5));

    connect(powerToGasSystem.controlBus, powerPlantSystem[i].controlBus) annotation (Line(
        points={{-40.8,-22},{-44,-22},{-44,10},{-10.2,10}},
        color={255,204,51},
        thickness=0.5));
    connect(controlCO2.controlBus, powerPlantSystem[i].controlBus) annotation (Line(
        points={{-68,38.2222},{-44,38.2222},{-44,10},{-10.2,10}},
        color={255,204,51},
        thickness=0.5));
    if useHydrogenFromPtGInPowerPlants then
      connect(powerPlantSystem[i].gasPortIn1, powerToGasSystem.gasPortOut_H2_toPowerPlant) annotation (Line(
          points={{10,4},{22,4},{22,-20},{-20,-20}},
          color={170,213,255},
          thickness=1.5));
    else
    end if;
    if useOneGasPortOnly then
      connect(powerPlantSystem[i].gasPortIn, junction1.gasPort[i + connectPowerPlants]) annotation (Line(
          points={{10,10},{32,10},{32,-20},{44,-20}},
          color={255,255,0},
          thickness=1.5));
    else
      connect(powerPlantSystem[i].gasPortIn, gasPortIn[i + connectPowerPlants - 1]);
    end if;
  end for;

  connect(cO2System.gasPortIn, powerPlantSystem.gasPortOut_CDE) annotation (Line(
      points={{10.2,44},{24,44},{24,14},{10,14}},
      color={215,215,215},
      thickness=1.5));
  connect(controlPowerPlant.P_el_set_out, powerPlantSystem.P_el_set) annotation (Line(points={{-63.7,20.2778},{-10.6,19.4}}, color={0,0,127}));
  connect(gasPressure.y, controlPowerPlant.p_gas) annotation (Line(points={{-83.4,20},{-78,20},{-78,20.1944},{-76.75,20.1944}}, color={0,0,127}));
  connect(P_set_PowerPlant, controlPowerPlant.P_el_set_in) annotation (Line(points={{-120,26},{-80,26},{-80,22.4167},{-76.75,22.4167}}, color={0,0,127}));
  connect(powerPlantSystem.P_max_noCCs, controlPowerPlant.P_max_PowerPlant_in) annotation (Line(points={{-10.6,17.2},{-62,17.2},{-62,14},{-78,14},{-78,24.6389},{-76.75,24.6389}}, color={0,0,127}));

  connect(P_PowerPlant_is, sum_P_Powerplants_is.y) annotation (Line(points={{130,110},{108,110},{108,13},{72.51,13}}, color={0,0,127}));

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////connect statements for local demand////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if useOneGasPortOnly then
    connect(junction1.gasPort[1], gasPortIn[1]) annotation (Line(
        points={{44,-20},{122,-20}},
        color={255,255,0},
        thickness=1.5));
    connect(localDemand.gasPortOut, junction1.gasPort[connectLocalDemand + 1]) annotation (Line(
        points={{10,-102},{32,-102},{32,-20},{44,-20}},
        color={255,255,0},
        thickness=1.5));
  else
    connect(localDemand.gasPortOut, gasPortIn[connectLocalDemand]);
  end if;

  connect(DataTable_HeatDemand.y1, gain_HeatingDemand_LocalDemand.u) annotation (Line(points={{-85.5,-111},{-82,-111},{-82,-115},{-78.6,-115}}, color={0,0,127}));
  connect(gain_HeatingDemand_LocalDemand.y, localDemand.Q_flow) annotation (Line(points={{-71.7,-115},{-16,-115},{-16,-108},{-12,-108}}));
  connect(electricPowerComplex_load.epp_OUT, epp) annotation (Line(
      points={{19.76,-110},{40,-110},{40,20},{120,20}},
      color={28,108,200},
      thickness=0.5));

  connect(localDemand.epp, electricPowerComplex_load.epp_IN) annotation (Line(
      points={{10,-110},{12.32,-110}},
      color={28,108,200},
      thickness=0.5));

  connect(localDemand.Load, localSurplusPowerIntern.u[2]) annotation (Line(points={{11.4,-115.2},{98,-115.2},{98,-70},{106,-70}}, color={0,0,127}));
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////connect statements for local demand and local renewable production/////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  connect(localSurplusPowerIntern.u[1], localRenewableProduction.P_RE_potential) annotation (Line(points={{106,-70},{98,-70},{98,-70.8},{11,-70.8}}, color={0,0,127}));

  connect(localRenewableProduction.P_curtailment, P_set_curtailment) annotation (Line(points={{-12,-70.4},{-16,-70.4},{-16,-52},{-120,-52}}, color={0,0,127}));

  connect(localRenewableProduction.epp, electricPowerComplex_localRenewableProduction.epp_IN) annotation (Line(
      points={{10,-80},{12.32,-80}},
      color={28,108,200},
      thickness=0.5));
  connect(electricPowerComplex_localRenewableProduction.epp_OUT, epp) annotation (Line(
      points={{19.76,-80},{40,-80},{40,20},{120,20}},
      color={28,108,200},
      thickness=0.5));

  if useOneGasPortOnly then
    connect(localRenewableProduction.gasPortOut, junction1.gasPort[connectlocalRenewableProduction]) annotation (Line(
        points={{10,-86},{32,-86},{32,-20},{44,-20}},
        color={255,255,0},
        thickness=1.5));
  else
    connect(localRenewableProduction.gasPortOut, gasPortIn[connectlocalRenewableProduction]);
  end if;

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////connect statements for power-to-gas plants/////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  connect(P_set_PtG, controlPowerToGasStorage.u2) annotation (Line(points={{-120,-26},{-94,-26},{-94,-21.6},{-80.8,-21.6}}, color={0,0,127}));
  connect(expression_pGas_pTG.y, controlPowerToGasStorage.p_gas_region) annotation (Line(points={{-87.5,-17},{-80.8,-16.8}}, color={0,0,127}));
  connect(expression_H2gasFrac.y, controlPowerToGasStorage.gasComposition) annotation (Line(points={{-87.5,-27},{-80.8,-26.4}}, color={0,0,127}));
  connect(controlPowerToGasStorage.controlBus, powerToGasSystem.controlBus) annotation (Line(
      points={{-64,-21.6},{-53.4,-21.6},{-53.4,-22},{-40.8,-22}},
      color={255,204,51},
      thickness=0.5));
  connect(powerToGasSystem.epp_OUT, epp) annotation (Line(
      points={{-28.4,-12},{-28.4,-6},{40,-6},{40,20},{120,20}},
      color={28,108,200},
      thickness=0.5));
  connect(powerToGasSystem.gasPortIn_CO2, cO2System.gasPortOut) annotation (Line(
      points={{-20,-14},{16,-14},{16,34},{10,34}},
      color={215,215,215},
      thickness=1.5));

  if useOneGasPortOnly then
    connect(powerToGasSystem.gasPortOut_1, junction1.gasPort[connectPowerToGas + 1]) annotation (Line(
        points={{-20,-24},{32,-24},{32,-20},{44,-20}},
        color={255,255,0},
        thickness=1.5));
  else
    connect(powerToGasSystem.gasPortOut_1, gasPortIn[connectPowerToGas]);
  end if;

  if PowerToGasPlantsInThisRegion and ptGTypeIsMethanation then
    if usageOfWasteHeatOfPtG == 2 then
      connect(powerToGasSystem.port_a, cO2System.port_a) annotation (Line(points={{-24,-32},{-24,48},{-6,48}}, color={191,0,0}));
    elseif usageOfWasteHeatOfPtG == 3 then
      connect(powerToGasSystem.fluidPortIn, heatingGridSystem_Storage.WaterPortOut_ExternalHeatSource) annotation (Line(
          points={{-34,-32},{-34,-40},{-52,-40},{-52,90},{4,90},{4,93.8}},
          color={175,0,0},
          thickness=0.5));
      connect(powerToGasSystem.fluidPortOut, heatingGridSystem_Storage.WaterPortIn_ExternalHeatSource) annotation (Line(
          points={{-36,-32},{-36,-36},{-50,-36},{-50,94},{-4,94},{-4,93.8}},
          color={175,0,0},
          thickness=0.5));
    end if;
  else
    if usageOfWasteHeatOfPtG == 3 then
      connect(powerToGasSystem.fluidPortIn, heatingGridSystem_Storage.WaterPortOut_ExternalHeatSource);
      connect(powerToGasSystem.fluidPortOut, heatingGridSystem_Storage.WaterPortIn_ExternalHeatSource);
    end if;
  end if;

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////connect statements for heating grid////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  connect(DataTable_HeatDemand.y1, gain_HeatingDemand_HeatingGrid.u) annotation (Line(points={{-85.5,-111},{-82,-111},{-82,-103},{-78.6,-103}}, color={0,0,127}));

  connect(heatingGridSystem_Storage.P_el_CHP, localSurplusPowerIntern.u[3]) annotation (Line(points={{11.4,110},{98,110},{98,-70},{106,-70}}, color={0,0,127}));
  connect(gain_HeatingDemand_HeatingGrid.y, heatingGridSystem_Storage.Q_demand) annotation (Line(points={{-71.7,-103},{-58,-103},{-58,108.2},{-12,108.2}}));
  connect(heatingGridSystem_Storage.epp, epp) annotation (Line(
      points={{9.5,98.6},{40,98.6},{40,20},{120,20}},
      color={28,108,200},
      thickness=0.5));
  if useOneGasPortOnly then
    connect(junction1.gasPort[integer(4 + TransiEnt.Basics.Functions.boolean2integer(PowerToGasPlantsInThisRegion) + nPowerPlants + TransiEnt.Basics.Functions.boolean2integer(GasStorageInThisRegion))], heatingGridSystem_Storage.gasPortIn) annotation (Line(
        points={{44,-20},{32,-20},{32,95},{10,95}},
        color={255,255,0},
        thickness=1.5));
  else
    connect(heatingGridSystem_Storage.gasPortIn, gasPortIn[3]);
  end if;

  connect(heatingGridSystem_Storage.P_set_ElectricalHeater, P_set_ElectricalHeater) annotation (Line(points={{-12,113},{-86,113},{-86,52},{-120,52}}));

  if DifferentTypesOfElectricHeater >= 1 then
    connect(heatingGridSystem_Storage.P_ElectricalHeater_max, P_ElectricalHeater_max) annotation (Line(points={{11.4,113},{100,113},{100,-50},{130,-50}}, color={0,0,127}));
  else
    connect(P_ElectricalHeater_max, Zero.y);
  end if;
  //connect(P_ElectricalHeater_max, heatingGridSystem_Storage.P_ElectricalHeater_max) annotation (Line(points={{112,-66},{92,-66},{92,113},{11.4,113}}, color={0,0,127}));

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////connect statements for CO2System/////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  connect(controlCO2.controlBus, cO2System.controlBus) annotation (Line(
      points={{-68,38.2222},{-30,38.2222},{-30,38},{-10,38}},
      color={255,204,51},
      thickness=0.5));
  connect(realExpression14.y, prescribedTemperature.T) annotation (Line(points={{-35.5,48},{-30.4,48}}, color={0,0,127}));
  connect(prescribedTemperature.port, cO2System.port_a) annotation (Line(points={{-26,48},{-6,48}}, color={191,0,0}));
  connect(cO2System.epp, powerToGasSystem.epp_IN) annotation (Line(
      points={{6,48.2},{6,52},{40,52},{40,-6},{-32,-6},{-32,-12}},
      color={28,108,200},
      thickness=0.5));

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////connect statements for other components/////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  connect(centralPhaseShifter.epp, epp) annotation (Line(
      points={{116,7},{110,7},{110,20},{120,20}},
      color={28,108,200},
      thickness=0.5));

  if useOneGasPortOnly and useImportExportBoundary then
    connect(junction1.gasPort[NeededGasPortsForJunction], boundaryImportExportInRegion.fluidPortIn);
  end if;

  connect(cO2System.P_el, P_DAC) annotation (Line(
      points={{-10.4,36},{-22,36},{-22,22},{104,22},{104,70},{130,70}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(controlPowerPlant.P_max_PowerPlant_out, P_PowerPlant_max) annotation (Line(points={{-63.76,24.6667},{106,24.6667},{106,90},{130,90}}, color={0,0,127}));

  connect(localRenewableProduction.P_RE_potential, P_renewable) annotation (Line(points={{11,-70.8},{96,-70.8},{96,-90},{130,-90}}, color={0,0,127}));
  connect(P_surplus_region, localSurplusPowerIntern.y) annotation (Line(points={{130,-70},{114.68,-70}}, color={0,0,127}));

  //sum

  connect(Zero.y, sum_P_heatingGrid_is.u[1]) annotation (Line(points={{56.6,117},{60,117},{60,103},{68,103}}, color={0,0,127}));
  connect(Zero.y, sum_m_flow_heatingGridGas_is.u[1]) annotation (Line(points={{56.6,117},{60,117},{60,95},{68,95}}, color={0,0,127}));
  connect(Zero.y, sum_m_flow_gasStorage_is.u[1]) annotation (Line(points={{56.6,117},{60,117},{60,67},{68,67}}, color={0,0,127}));
  connect(Zero.y, sum_m_gasStorage_is.u[1]) annotation (Line(points={{56.6,117},{60,117},{60,59},{68,59}}, color={0,0,127}));
  connect(Zero.y, sum_m_flow_CO2toPtG.u[1]) annotation (Line(points={{56.6,117},{60,117},{60,45},{68,45}}, color={0,0,127}));
  connect(Zero.y, sum_m_flow_CO2fromPowerplants.u[1]) annotation (Line(points={{56.6,117},{60,117},{60,37},{68,37}}, color={0,0,127}));
  connect(Zero.y, sum_P_CO2DAC_is.u[1]) annotation (Line(points={{56.6,117},{60,117},{60,22},{66,22},{66,26},{68,26},{68,29}}, color={0,0,127}));
  connect(Zero.y, sum_P_Powerplants_is.u[1]) annotation (Line(points={{56.6,117},{60,117},{60,13},{66,13}}, color={0,0,127}));
  connect(Zero.y, sum_m_flow_powerPlant_is.u[1]) annotation (Line(points={{56.6,117},{60,117},{60,5},{66,5}}, color={0,0,127}));
  connect(Zero.y, sum_P_PtG_is.u[1]) annotation (Line(points={{56.6,117},{60,117},{60,-25},{66,-25}}, color={0,0,127}));
  connect(Zero.y, sum_m_flow_PtG_is.u[1]) annotation (Line(points={{56.6,117},{60,117},{60,-33},{66,-33}}, color={0,0,127}));
  connect(Zero.y, sum_E_electricalStorage_is.u[1]) annotation (Line(points={{56.6,117},{60,117},{60,-47},{66,-47}}, color={0,0,127}));
  connect(Zero.y, sum_P_electricalStorage_is.u[1]) annotation (Line(points={{56.6,117},{60,117},{60,-55},{66,-55}}, color={0,0,127}));

  connect(heatingGridSystem_Storage.P_ElectricalHeater_max, sum_P_heatingGrid_is.u[1+(if (DifferentTypesOfElectricHeater + DifferentTypesOfGasBoiler + DifferentTypesOfCHPPlants) > 0 then 1 else 0)]) annotation (Line(points={{11.4,113},{60,113},{60,103},{68,103}}, color={0,0,127}));
  connect(heatingGridSystem_Storage.P_el_CHP, sum_P_heatingGrid_is.u[1+(if (DifferentTypesOfElectricHeater + DifferentTypesOfGasBoiler + DifferentTypesOfCHPPlants) > 0 then 2 else 0)]) annotation (Line(points={{11.4,110},{58,110},{58,103},{68,103}}, color={0,0,127}));
  connect(heatingGridSystem_Storage.m_flow_gas, sum_m_flow_heatingGridGas_is.u[1+(if (DifferentTypesOfElectricHeater + DifferentTypesOfGasBoiler + DifferentTypesOfCHPPlants) > 0 then 1 else 0)]) annotation (Line(points={{11.4,107},{56,107},{56,95},{68,95}}, color={0,0,127}));

  connect(gasStorageSystem.m_flow_storage, sum_m_flow_gasStorage_is.u[1 .+(1:DifferentTypesOfGasStorage)]) annotation (Line(points={{11,71},{60,71},{60,67},{68,67}}, color={0,0,127}));
  connect(gasStorageSystem.m_storage, sum_m_gasStorage_is.u[1 .+(1:DifferentTypesOfGasStorage)]) annotation (Line(points={{11,73},{56,73},{56,59},{68,59}}, color={0,0,127}));

  connect(cO2System.m_flow_toPtG, sum_m_flow_CO2toPtG.u[1 + (if (CO2StorageNeeded>0) then 1 else 0)]) annotation (Line(points={{11,29.2},{60,29.2},{60,45},{68,45}}, color={0,0,127}));
  connect(cO2System.m_flow_fromPowerplants, sum_m_flow_CO2fromPowerplants.u[1 + (if (CO2StorageNeeded>0) then 1 else 0)]) annotation (Line(points={{11,31.2},{56,31.2},{56,37},{68,37}}, color={0,0,127}));
  connect(cO2System.P_el, sum_P_CO2DAC_is.u[1 + (if (CO2StorageNeeded>0) then 1 else 0)]) annotation (Line(
      points={{-10.4,36},{-24,36},{-24,22},{66,22},{66,28},{68,28},{68,29}},
      color={0,135,135},
      pattern=LinePattern.Dash));

  connect(powerPlantSystem.P_Powerplant_is, sum_P_Powerplants_is.u[1 .+ (1:nPowerPlants)]) annotation (Line(
      points={{10.6,19},{48,19},{48,13},{66,13}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(powerPlantSystem.m_flow_Powerplant_is, sum_m_flow_powerPlant_is.u[1 .+ (1:nPowerPlants)]) annotation (Line(points={{10.6,17},{44,17},{44,5},{66,5}}, color={0,0,127}));

  connect(powerToGasSystem.P, sum_P_PtG_is.u[1 + (if (PowerToGasPlantsInThisRegion)  then 1 else 0)]) annotation (Line(
      points={{-40.4,-24.6},{-52,-24.6},{-52,-38},{56,-38},{56,-26},{66,-26},{66,-25}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(powerToGasSystem.m_flow_gas_out, sum_m_flow_PtG_is.u[1 + (if (PowerToGasPlantsInThisRegion)  then 1 else 0)]) annotation (Line(points={{-40.4,-27.6},{-40.4,-34},{60,-34},{60,-33},{66,-33}}, color={0,0,127}));

  connect(electricalStorageSystem.E_storage_is, sum_E_electricalStorage_is.u[1 .+(1:DifferentTypesOfElectricalStorages)]) annotation (Line(points={{11.6,-43},{60,-43},{60,-47},{66,-47}}, color={0,0,127}));
  connect(electricalStorageSystem.P_storage_is, sum_P_electricalStorage_is.u[1 .+(1:DifferentTypesOfElectricalStorages)]) annotation (Line(points={{11.6,-59},{60,-59},{60,-55},{66,-55}}, color={0,0,127}));

  connect(sum_m_flow_powerPlant_is.y, powerToGasSystem.PP_m_flowGas) annotation (Line(points={{72.51,5},{74,5},{74,-4},{-48,-4},{-48,-31},{-40,-31}}, color={0,0,127}));
  connect(sum_P_PtG_is.y, P_PowerToGasPlant_is) annotation (Line(points={{72.51,-25},{102,-25},{102,50},{130,50}}, color={0,0,127}));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>The superstructure component provides a representation of a certain region in terms of consumption and production of power and gas. This representation is comprised of multiple elements that connect with the central electric and gas ports and either consume or generate gas or electrical power. Superstructures are to be used as arrays enclosed in <a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Portfolios.Portfolio_Example.Superstructures_PortfolioMask\">superstructure portolio masks</a> for maximum utilization.</p>
<p>See <a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.SuperstructureUsageGuide\">usage guide</a> for more information.</p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span> </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span> </p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>Outputs:</p>
<ul>
<li>epp: complex electric power port</li>
<li>gasPort: gas port</li>
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
<li>P_set_PtG: input current power to gas setpoint power</li>
</ul>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
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
<p><br>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
<p>Model redesigned by Jon Babst (babst@xrg-simulation.de), 06.09.2021</p>
</html>"));
end Superstructure;
