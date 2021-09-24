within TransiEnt.SystemGeneration.Superstructure.Components.Records;
record ControllerInputGeneration "Record for the construction of controller parameter inputs using known InstanceRecords"

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
  //              Visible Parameters
  // _____________________________________________

  replaceable package Config = Portfolios.Base        constrainedby Portfolios.Base        annotation (Dialog(group="Portofolio"), choicesAllMatching=true);

  //Inputs
  parameter Integer nRegions=1 annotation (Dialog(group="Input"));

  parameter Integer MaximumDifferentTypesOfPowerPlants=max(DifferentTypesOfPowerPlants) annotation (Dialog(group="Input"));
  parameter Integer MaximumDifferentTypesOfElectricalStorages=max(DifferentTypesOfElectricalStorages) annotation (Dialog(group="Input"));
  parameter Integer MaximumDifferentTypesOfPtG=max(DifferentTypesOfPowerToGasPlants) annotation (Dialog(group="Input"));
  parameter Integer MaximumDifferentTypesOfElectricHeaters=max(DifferentTypesOfElectricHeater) annotation (Dialog(group="Input"));

  parameter Integer DifferentTypesOfPowerPlants[nRegions]={powerPlantInstancesRecord[i].nPowerPlants for i in 1:nRegions} "Amount of different power plant types" annotation (Dialog(group="Input"));
  parameter Integer DifferentTypesOfElectricalStorages[nRegions]={electricalStorageInstancesRecord[i].nElectricalStorages for i in 1:nRegions} " Amount of different electrical storage types" annotation (Dialog(group="Input"));
  parameter Integer DifferentTypesOfPowerToGasPlants[nRegions]={powerToGasInstancesRecord[i].nPowerToGasPlants for i in 1:nRegions} "Amount of different power to gas plant types" annotation (Dialog(group="Input"));
  parameter Integer DifferentTypesOfElectricHeater[nRegions]={heatingGridSystemStorageInstancesRecord[i].nHeatingGrid*heatingGridSystemStorageInstancesRecord[i].heatingGridSystemStorageRecord.ElHeater_quantity for i in 1:nRegions} "Amount of different electrical heater types" annotation (Dialog(group="Input"));

  parameter Config.Records.InstancesRecords.PowerPlantInstancesRecord powerPlantInstancesRecord[nRegions]=fill(Config.Records.InstancesRecords.PowerPlantInstancesRecord(), nRegions) "parametrization of all systems in SS, one per Region" annotation (Dialog(group="Input"));
  parameter Config.Records.InstancesRecords.ElectricalStorageInstancesRecord electricalStorageInstancesRecord[nRegions]=fill(Config.Records.InstancesRecords.ElectricalStorageInstancesRecord(), nRegions) annotation (Dialog(group="Input"));
  parameter Config.Records.InstancesRecords.PowerToGasInstancesRecord[nRegions] powerToGasInstancesRecord=fill(Config.Records.InstancesRecords.PowerToGasInstancesRecord(), nRegions) annotation (Dialog(group="Input"));
  parameter Config.Records.InstancesRecords.HeatingGridSystemStorageInstancesRecord[nRegions] heatingGridSystemStorageInstancesRecord=fill(Config.Records.InstancesRecords.HeatingGridSystemStorageInstancesRecord(), nRegions) annotation (Dialog(group="Input"));

  parameter Integer NumberOfPowerplantsOverAllRegions=sum(DifferentTypesOfPowerPlants) annotation (Dialog(group="Input"));
  parameter Integer NumberOfElectricalStoragesOverAllRegions=sum(DifferentTypesOfElectricalStorages) annotation (Dialog(group="Input"));
  parameter Integer NumberOfPowerToGasPlantsOverAllRegions=sum(DifferentTypesOfPowerToGasPlants) annotation (Dialog(group="Input"));
  parameter Integer NumberOfElectricalHeatersOverAllRegions=sum(DifferentTypesOfElectricHeater) annotation (Dialog(group="Input"));

  //Outputs and helper parameters

  //Powerplant Parameter
  parameter Integer sumOfPowerplantsUpToRegion[nRegions]={sum({powerPlantInstancesRecord[k].nPowerPlants for k in 1:(i)}) for i in 1:nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Integer MatrixToFullList_Indices_Powerplants[MaximumDifferentTypesOfPowerPlants*nRegions,2]={{integer(ceil(k/MaximumDifferentTypesOfPowerPlants)),mod(k - 1, MaximumDifferentTypesOfPowerPlants) + 1} for k in 1:MaximumDifferentTypesOfPowerPlants*nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));

  parameter Boolean NonEmptyIndexBooleanMatrix_Powerplants[nRegions,MaximumDifferentTypesOfPowerPlants]={{(if j <= DifferentTypesOfPowerPlants[i] then true else false) for j in 1:MaximumDifferentTypesOfPowerPlants} for i in 1:nRegions} "" annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Integer NonEmptyIndexList_Powerplants[max(1, NumberOfPowerplantsOverAllRegions)]=Modelica.Math.BooleanVectors.index({NonEmptyIndexBooleanMatrix_Powerplants[integer(ceil(k/MaximumDifferentTypesOfPowerPlants)), mod(k - 1, MaximumDifferentTypesOfPowerPlants) + 1] for k in 1:MaximumDifferentTypesOfPowerPlants*nRegions}) annotation (Dialog(tab="Helper Paramters", enable=false));

  parameter Integer regionOfPowerPlant_List[max(1, NumberOfPowerplantsOverAllRegions)]=if NumberOfPowerplantsOverAllRegions > 0 then {Modelica.Math.BooleanVectors.firstTrueIndex({sumOfPowerplantsUpToRegion[m] >= i for m in 1:nRegions}) for i in 1:NumberOfPowerplantsOverAllRegions} else {1} annotation (Dialog(group="Outputs", enable=false));

  parameter Integer typeOfPowerplant_Matrix[nRegions,MaximumDifferentTypesOfPowerPlants]={{(if j <= DifferentTypesOfPowerPlants[i] then j else 0) for j in 1:MaximumDifferentTypesOfPowerPlants} for i in 1:nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Integer typeOfPowerplant_ListFull[MaximumDifferentTypesOfPowerPlants*nRegions]={typeOfPowerplant_Matrix[MatrixToFullList_Indices_Powerplants[k, 1], MatrixToFullList_Indices_Powerplants[k, 2]] for k in 1:MaximumDifferentTypesOfPowerPlants*nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Integer typeOfPowerplant_List[max(1, NumberOfPowerplantsOverAllRegions)]=if NumberOfPowerplantsOverAllRegions > 0 then typeOfPowerplant_ListFull[NonEmptyIndexList_Powerplants] else {0} annotation (Dialog(group="Outputs", enable=false));

  parameter Real P_nom_Powerplants_Matrix[nRegions,MaximumDifferentTypesOfPowerPlants]={{(if j <= DifferentTypesOfPowerPlants[i] then powerPlantInstancesRecord[i].powerPlantRecord[j].P_el_n else 0) for j in 1:MaximumDifferentTypesOfPowerPlants} for i in 1:nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Real P_nom_Powerplants_ListFull[MaximumDifferentTypesOfPowerPlants*nRegions]={P_nom_Powerplants_Matrix[MatrixToFullList_Indices_Powerplants[k, 1], MatrixToFullList_Indices_Powerplants[k, 2]] for k in 1:MaximumDifferentTypesOfPowerPlants*nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Real P_nom_Powerplants_List[max(1, NumberOfPowerplantsOverAllRegions)]=if NumberOfPowerplantsOverAllRegions > 0 then P_nom_Powerplants_ListFull[NonEmptyIndexList_Powerplants] else {0} annotation (Dialog(group="Outputs", enable=false));

  parameter Real P_min_const_Powerplants_Matrix[nRegions,MaximumDifferentTypesOfPowerPlants]={{(if j <= DifferentTypesOfPowerPlants[i] then powerPlantInstancesRecord[i].powerPlantRecord[j].P_min_star*powerPlantInstancesRecord[i].powerPlantRecord[j].P_el_n else 0) for j in 1:MaximumDifferentTypesOfPowerPlants} for i in 1:nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Real P_min_const_Powerplants_ListFull[MaximumDifferentTypesOfPowerPlants*nRegions]={P_min_const_Powerplants_Matrix[MatrixToFullList_Indices_Powerplants[k, 1], MatrixToFullList_Indices_Powerplants[k, 2]] for k in 1:MaximumDifferentTypesOfPowerPlants*nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Real P_min_const_Powerplants_List[max(1, NumberOfPowerplantsOverAllRegions)]=if NumberOfPowerplantsOverAllRegions > 0 then P_min_const_Powerplants_ListFull[NonEmptyIndexList_Powerplants] else {0} annotation (Dialog(group="Outputs", enable=false));

  parameter Real P_max_const_Powerplants_List[max(1, NumberOfPowerplantsOverAllRegions)]=P_nom_Powerplants_List annotation (Dialog(group="Outputs", enable=false));

  parameter Real P_grad_max_star_Powerplants_Matrix[nRegions,MaximumDifferentTypesOfPowerPlants]={{(if j <= DifferentTypesOfPowerPlants[i] then powerPlantInstancesRecord[i].powerPlantRecord[j].P_grad_max_star else 0) for j in 1:MaximumDifferentTypesOfPowerPlants} for i in 1:nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Real P_grad_max_star_Powerplants_ListFull[MaximumDifferentTypesOfPowerPlants*nRegions]={P_grad_max_star_Powerplants_Matrix[MatrixToFullList_Indices_Powerplants[k, 1], MatrixToFullList_Indices_Powerplants[k, 2]] for k in 1:MaximumDifferentTypesOfPowerPlants*nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Real P_grad_max_star_Powerplants_List[max(1, NumberOfPowerplantsOverAllRegions)]=if NumberOfPowerplantsOverAllRegions > 0 then P_grad_max_star_Powerplants_ListFull[NonEmptyIndexList_Powerplants] else {0} annotation (Dialog(group="Outputs", enable=false));

  //PtG Parameter
  parameter Integer sumOfPtGUpToRegion[nRegions]={sum({powerToGasInstancesRecord[k].nPowerToGasPlants for k in 1:(i)}) for i in 1:nRegions} "" annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Integer MatrixToFullList_Indices_PtG[MaximumDifferentTypesOfPtG*nRegions,2]={{integer(ceil(k/MaximumDifferentTypesOfPtG)),mod(k - 1, MaximumDifferentTypesOfPtG) + 1} for k in 1:MaximumDifferentTypesOfPtG*nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));

  parameter Boolean NonEmptyIndexBooleanMatrix_PtG[nRegions,MaximumDifferentTypesOfPtG]={{(if j <= DifferentTypesOfPowerToGasPlants[i] then true else false) for j in 1:MaximumDifferentTypesOfPtG} for i in 1:nRegions} "" annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Integer NonEmptyIndexList_PtG[NumberOfPowerToGasPlantsOverAllRegions]=Modelica.Math.BooleanVectors.index({NonEmptyIndexBooleanMatrix_PtG[integer(ceil(k/MaximumDifferentTypesOfPtG)), mod(k - 1, MaximumDifferentTypesOfPtG) + 1] for k in 1:MaximumDifferentTypesOfPtG*nRegions}) annotation (Dialog(tab="Helper Paramters", enable=false));

  parameter Integer regionOfPtG_List[max(1, NumberOfPowerToGasPlantsOverAllRegions)]=if NumberOfPowerToGasPlantsOverAllRegions > 0 then {Modelica.Math.BooleanVectors.firstTrueIndex({sumOfPtGUpToRegion[m] >= i for m in 1:nRegions}) for i in 1:NumberOfPowerToGasPlantsOverAllRegions} else {1} annotation (Dialog(group="Outputs", enable=false));

  parameter Integer typeOfPtG_Matrix[nRegions,MaximumDifferentTypesOfPtG]={{(if j <= DifferentTypesOfPowerToGasPlants[i] then j else 0) for j in 1:MaximumDifferentTypesOfPtG} for i in 1:nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Integer typeOfPtG_ListFull[MaximumDifferentTypesOfPtG*nRegions]={typeOfPtG_Matrix[MatrixToFullList_Indices_PtG[k, 1], MatrixToFullList_Indices_PtG[k, 2]] for k in 1:MaximumDifferentTypesOfPtG*nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Integer typeOfPtG_List[max(1, NumberOfPowerToGasPlantsOverAllRegions)]=if NumberOfPowerToGasPlantsOverAllRegions > 0 then typeOfPtG_ListFull[NonEmptyIndexList_PtG] else {0} annotation (Dialog(group="Outputs", enable=false));

  parameter Real P_nom_load_PtG_Matrix[nRegions,MaximumDifferentTypesOfPtG]={{(if j <= DifferentTypesOfPowerToGasPlants[i] then powerToGasInstancesRecord[i].powerToGasRecord.P_el_n else 0) for j in 1:MaximumDifferentTypesOfPtG} for i in 1:nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Real P_nom_load_PtG_ListFull[MaximumDifferentTypesOfPtG*nRegions]={P_nom_load_PtG_Matrix[MatrixToFullList_Indices_PtG[k, 1], MatrixToFullList_Indices_PtG[k, 2]] for k in 1:MaximumDifferentTypesOfPtG*nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Real P_nom_load_PtG_List[max(1, NumberOfPowerToGasPlantsOverAllRegions)]=if NumberOfPowerToGasPlantsOverAllRegions > 0 then P_nom_load_PtG_ListFull[NonEmptyIndexList_PtG] else {0} annotation (Dialog(group="Outputs", enable=false));

  // Electrical Storage Parameter
  parameter Integer sumOfElectricStoragesUpToRegion[nRegions]={sum({electricalStorageInstancesRecord[k].nElectricalStorages for k in 1:(i)}) for i in 1:nRegions} "" annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Integer MatrixToFullList_Indices_ElectricStorages[MaximumDifferentTypesOfElectricalStorages*nRegions,2]={{integer(ceil(k/MaximumDifferentTypesOfElectricalStorages)),mod(k - 1, MaximumDifferentTypesOfElectricalStorages) + 1} for k in 1:MaximumDifferentTypesOfElectricalStorages*nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));

  parameter Boolean NonEmptyIndexBooleanMatrix_ElectricStorages[nRegions,MaximumDifferentTypesOfElectricalStorages]={{(if j <= DifferentTypesOfElectricalStorages[i] then true else false) for j in 1:MaximumDifferentTypesOfElectricalStorages} for i in 1:nRegions} "" annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Integer NonEmptyIndexList_ElectricStorages[NumberOfElectricalStoragesOverAllRegions]=Modelica.Math.BooleanVectors.index({NonEmptyIndexBooleanMatrix_ElectricStorages[integer(ceil(k/MaximumDifferentTypesOfElectricalStorages)), mod(k - 1, MaximumDifferentTypesOfElectricalStorages) + 1] for k in 1:MaximumDifferentTypesOfElectricalStorages*nRegions}) annotation (Dialog(tab="Helper Paramters", enable=false));

  parameter Integer regionOfElectricalStorages_List[max(1, NumberOfElectricalStoragesOverAllRegions)]=if NumberOfElectricalStoragesOverAllRegions > 0 then {Modelica.Math.BooleanVectors.firstTrueIndex({sumOfElectricStoragesUpToRegion[m] >= i for m in 1:nRegions}) for i in 1:NumberOfElectricalStoragesOverAllRegions} else {1} annotation (Dialog(group="Outputs", enable=false));

  parameter Integer typeOfElectricalStorage_Matrix[nRegions,MaximumDifferentTypesOfElectricalStorages]={{(if j <= DifferentTypesOfElectricalStorages[i] then j else 0) for j in 1:MaximumDifferentTypesOfElectricalStorages} for i in 1:nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Integer typeOfElectricalStorage_ListFull[MaximumDifferentTypesOfElectricalStorages*nRegions]={typeOfElectricalStorage_Matrix[MatrixToFullList_Indices_ElectricStorages[k, 1], MatrixToFullList_Indices_ElectricStorages[k, 2]] for k in 1:MaximumDifferentTypesOfElectricalStorages*nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Integer typeOfElectricalStorage_List[max(1, NumberOfElectricalStoragesOverAllRegions)]=if NumberOfElectricalStoragesOverAllRegions > 0 then typeOfElectricalStorage_ListFull[NonEmptyIndexList_ElectricStorages] else {0} annotation (Dialog(group="Outputs", enable=false));

  parameter Real P_nom_load_ElectricStorage_Matrix[nRegions,MaximumDifferentTypesOfElectricalStorages]={{(if j <= DifferentTypesOfElectricalStorages[i] then electricalStorageInstancesRecord[i].electricalStorageRecord[j].P_max_load else 0) for j in 1:MaximumDifferentTypesOfElectricalStorages} for i in 1:nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Real P_nom_load_ElectricStorage_ListFull[MaximumDifferentTypesOfElectricalStorages*nRegions]={P_nom_load_ElectricStorage_Matrix[MatrixToFullList_Indices_ElectricStorages[k, 1], MatrixToFullList_Indices_ElectricStorages[k, 2]] for k in 1:MaximumDifferentTypesOfElectricalStorages*nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Real P_nom_load_ElectricStorage_List[max(1, NumberOfElectricalStoragesOverAllRegions)]=if NumberOfElectricalStoragesOverAllRegions > 0 then P_nom_load_ElectricStorage_ListFull[NonEmptyIndexList_ElectricStorages] else {0} annotation (Dialog(group="Outputs", enable=false));

  parameter Real P_nom_unload_ElectricStorage_Matrix[nRegions,MaximumDifferentTypesOfElectricalStorages]={{(if j <= DifferentTypesOfElectricalStorages[i] then electricalStorageInstancesRecord[i].electricalStorageRecord[j].P_max_unload else 0) for j in 1:MaximumDifferentTypesOfElectricalStorages} for i in 1:nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Real P_nom_unload_ElectricStorage_ListFull[MaximumDifferentTypesOfElectricalStorages*nRegions]={P_nom_unload_ElectricStorage_Matrix[MatrixToFullList_Indices_ElectricStorages[k, 1], MatrixToFullList_Indices_ElectricStorages[k, 2]] for k in 1:MaximumDifferentTypesOfElectricalStorages*nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Real P_nom_unload_ElectricStorage_List[max(1, NumberOfElectricalStoragesOverAllRegions)]=if NumberOfElectricalStoragesOverAllRegions > 0 then P_nom_unload_ElectricStorage_ListFull[NonEmptyIndexList_ElectricStorages] else {0} annotation (Dialog(group="Outputs", enable=false));

  // Electrical Heater
  parameter Integer sumOfElectricHeatersUpToRegion[nRegions]={sum({heatingGridSystemStorageInstancesRecord[k].nHeatingGrid*heatingGridSystemStorageInstancesRecord[k].heatingGridSystemStorageRecord.ElHeater_quantity for k in 1:(i)}) for i in 1:nRegions} "" annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Integer MatrixToFullList_Indices_ElectricHeaters[MaximumDifferentTypesOfElectricHeaters*nRegions,2]={{integer(ceil(k/MaximumDifferentTypesOfElectricHeaters)),mod(k - 1, MaximumDifferentTypesOfElectricHeaters) + 1} for k in 1:MaximumDifferentTypesOfElectricHeaters*nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));

  parameter Boolean NonEmptyIndexBooleanMatrix_ElectricHeaters[nRegions,MaximumDifferentTypesOfElectricHeaters]={{(if j <= DifferentTypesOfElectricHeater[i] then true else false) for j in 1:MaximumDifferentTypesOfElectricHeaters} for i in 1:nRegions} "" annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Integer NonEmptyIndexList_ElectricHeaters[NumberOfElectricalHeatersOverAllRegions]=Modelica.Math.BooleanVectors.index({NonEmptyIndexBooleanMatrix_ElectricHeaters[integer(ceil(k/MaximumDifferentTypesOfElectricHeaters)), mod(k - 1, MaximumDifferentTypesOfElectricHeaters) + 1] for k in 1:MaximumDifferentTypesOfElectricHeaters*nRegions}) annotation (Dialog(tab="Helper Paramters", enable=false));

  parameter Integer regionOfElectricHeaters_List[max(1, NumberOfElectricalHeatersOverAllRegions)]=if NumberOfElectricalHeatersOverAllRegions > 0 then {Modelica.Math.BooleanVectors.firstTrueIndex({sumOfElectricHeatersUpToRegion[m] >= i for m in 1:nRegions}) for i in 1:NumberOfElectricalHeatersOverAllRegions} else {1} annotation (Dialog(group="Outputs", enable=false));

  parameter Integer typeOfElectricHeater_Matrix[nRegions,MaximumDifferentTypesOfElectricHeaters]={{(if j <= DifferentTypesOfElectricHeater[i] then j else 0) for j in 1:MaximumDifferentTypesOfElectricHeaters} for i in 1:nRegions} annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Integer typeOfElectricHeater_ListFull[max(1, MaximumDifferentTypesOfElectricHeaters*nRegions)]=if NumberOfElectricalHeatersOverAllRegions > 0 then {typeOfElectricHeater_Matrix[MatrixToFullList_Indices_ElectricHeaters[k, 1], MatrixToFullList_Indices_ElectricHeaters[k, 2]] for k in 1:MaximumDifferentTypesOfElectricHeaters*nRegions} else {0} annotation (Dialog(tab="Helper Paramters", enable=false));
  parameter Integer typeOfElectricHeater_List[max(1, NumberOfElectricalHeatersOverAllRegions)]=if NumberOfElectricalHeatersOverAllRegions > 0 then typeOfElectricHeater_ListFull[NonEmptyIndexList_ElectricHeaters] else {0} annotation (Dialog(group="Outputs", enable=false));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Record that transforms certain data from InstanceRecords in <a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Portfolios.Portfolio_Example.Superstructures_PortfolioMask\">Superstructures_PortfolioMask</a> into parameter arrays that are needed in the superstructure <a href=\"ResiliEntEE.Superstructure_JB_DELIVERY.Components.Controller.ElectricalPowerController_outer\">controller</a>.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
<p>Outputs needed:</p>
<ul>
<li><span style=\"font-family: Courier New;\">regionOfPowerPlant_List</span></li>
<li><span style=\"font-family: Courier New;\">typeOfPowerplant_List</span></li>
<li><span style=\"font-family: Courier New;\">P_nom_Powerplants_List</span></li>
<li><span style=\"font-family: Courier New;\">P_min_const_Powerplants_List</span></li>
<li><span style=\"font-family: Courier New;\">P_max_const_Powerplants_List</span></li>
<li><span style=\"font-family: Courier New;\">P_grad_max_star_Powerplants_List</span></li>
</ul>
<ul>
<li><span style=\"font-family: Courier New;\">regionOfPtG_List</span></li>
<li><span style=\"font-family: Courier New;\">typeOfPtG_List</span></li>
<li><span style=\"font-family: Courier New;\">P_nom_load_PtG_List</span></li>
<li><span style=\"font-family: Courier New;\">regionOfElectricalStorages_List</span></li>
<li><span style=\"font-family: Courier New;\">typeOfElectricalStorage_List</span></li>
<li><span style=\"font-family: Courier New;\">P_nom_load_ElectricStorage_List</span></li>
<li><span style=\"font-family: Courier New;\">P_nom_unload_ElectricStorage_List</span></li>
<li><span style=\"font-family: Courier New;\">regionOfElectricHeaters_List</span></li>
<li><span style=\"font-family: Courier New;\">typeOfElectricHeater_List</span></li>
</ul>
<p><br><br>Inputs to be set</p>
<ul>
<li><span style=\"font-family: Courier New;\">powerPlantInstancesRecord</span></li>
<li><span style=\"font-family: Courier New;\">electricalStorageInstancesRecord</span></li>
<li><span style=\"font-family: Courier New;\">powerToGasInstancesRecord</span></li>
<li><span style=\"font-family: Courier New;\">heatingGridSystemStorageInstancesRecord</span></li>
</ul>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Jon Babst (babst@xrg-simulation.de), 06.09.2021</p>
</html>"));
end ControllerInputGeneration;
