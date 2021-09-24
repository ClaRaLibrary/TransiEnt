within TransiEnt.SystemGeneration.Superstructure.Components.Controller;
model ElectricalPowerController_inner

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
  import Modelica.Units.SI;
  import Const = Modelica.Constants;
  extends TransiEnt.Basics.Icons.SystemOperator;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;
  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________
  //parameter Integer SimulationCounter=1 "Simulation Counter to define simulation";
  parameter Integer n_PowerPlant=NumberOfPowerplantsOverAllRegions "Number of plants";

  parameter Integer Region "amount of regions";
  parameter SI.Power P_min_const_PowerPlant[n_PowerPlant] "minimum power of power plants; is >=0";
  parameter SI.Power P_max_const_PowerPlant[n_PowerPlant]=P_nom_PowerPlant "minimum power of power plants; is >=0";
  parameter SI.Power P_nom_PowerPlant[n_PowerPlant] "nominal power of power plants";
  parameter Integer n_ElectricalStorage=max(NumberOfElectricalStoragesOverAllRegions, 1) "amount of electrical storages, =1 if no storages";
  parameter SI.Power P_nom_load_ElectricalStorage[n_ElectricalStorage] "nominal loading power of electrical storages";
  parameter SI.Power P_nom_unload_ElectricalStorage[n_ElectricalStorage] "nominal unloading power of electrical storages";

  parameter Integer n_PtG=max(NumberOfPowerToGasPlantsOverAllRegions, 1) "amount of PtG-plants";

  parameter SI.Power P_nom_load_PtG[n_PtG] "nominal power of PtG-plants";

  parameter Integer n_ElectricalHeater=Region "maximum amount of electrical heater";
  parameter Integer n_ElectricalHeater2=max(NumberOfElectricalHeatersOverAllRegions, 1) "actual amount of electrical heater";
  parameter Integer MeritOrderPositionElectricalStorage=1 "Electric Storages" annotation (Dialog(group="MeritOrder Position"), choices(
      __Dymola_radioButtons=true,
      choice=1 "1",
      choice=2 "2",
      choice=3 "3"));
  parameter Integer MeritOrderPositionPtG=4 "Power-to-Gas" annotation (Dialog(group="MeritOrder Position"), choices(
      __Dymola_radioButtons=true,
      choice=1 "1",
      choice=2 "2",
      choice=3 "3"));
  parameter Integer MeritOrderPositionElectricalHeater=2 "Electric Heater (District Heating)" annotation (Dialog(group="MeritOrder Position"), choices(
      __Dymola_radioButtons=true,
      choice=1 "1",
      choice=2 "2",
      choice=3 "3"));
  parameter SI.Power P_threshold_residual_ElectricalStorage=1e-3 "numerical value to avoid chattering";
  parameter SI.Power P_threshold_residual_ElectricalHeater=1e-3 "numerical value to avoid chattering";
  parameter SI.Power P_threshold_residual_PtG=P_nom_load_PtG[1]*1e-7 "numerical value to avoid chattering";
  parameter SI.Power P_threshold_residual_PowerPlant=1e3 "numerical value to avoid chattering";
  parameter Boolean useDecentralizedPowerControl=true "if 'false', regional residual loads are not considered for power control";
  parameter Modelica.Units.SI.Time startTime=0 "start time for simulation";
  parameter Modelica.Units.SI.Time MinimumSwitchTimePowerPlants=120 "Minimum time for power plants to be turned on or off (for numerical reasons)";

  parameter Integer MaximumDifferentTypesOfPowerPlants;
  parameter Integer NumberOfPowerplantsOverAllRegions;
  parameter Integer NumberOfPowerToGasPlantsOverAllRegions;
  parameter Integer NumberOfElectricalStoragesOverAllRegions;
  parameter Integer NumberOfElectricalHeatersOverAllRegions;

  //can not be the same as powerPlantMatrix[:,2]! 1s and 2s have to be switched or else the equations won't work
  parameter Integer powerPlantTypeDefinition[n_PowerPlant] "type of powerplant (supports only Gasturbine (1) and CCGT (2)); 1Dim; has to be the opposite as powerPlantMatrix[:,2]!";

  parameter Integer powerPlantMatrix[NumberOfPowerplantsOverAllRegions,2] "powerplant: Column 1=Region, Column 2= TypeNumber ; 2Dim";

  input Integer regionOfElectricalStorage[n_ElectricalStorage];
  input Integer regionOfPtGPlant[n_PtG];
  input Integer regionOfElectricalHeater[n_ElectricalHeater];
  input Integer regionOfPowerPlant[n_PowerPlant];
  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.Power P_max_sorted_sum_PowerPlant[n_PowerPlant];
  SI.Power P_max_mod_sorted_sum_PowerPlant[n_PowerPlant];
  SI.Power P_max_sorted_sum_ElectricalHeater[n_ElectricalHeater];
  SI.Power P_max_mod_sorted_sum_ElectricalHeater[n_ElectricalHeater];
  SI.Power P_max_mod_ElectricalHeater[n_ElectricalHeater];
  SI.Power P_residual_single_ElectricalHeater[n_ElectricalHeater];
  SI.Power P_residual_single_mod_ElectricalHeater[n_ElectricalHeater];
  SI.Power P_residual_single_decentral_ElectricalHeater[n_ElectricalHeater];
  Modelica.Units.SI.Power P_total;
  Modelica.Units.SI.Power P_total_set;
  Modelica.Units.SI.Power P_total_is;

  Modelica.Units.SI.Power P_total_PowerPlant;
  Modelica.Units.SI.Power P_total_PowerPlant_is;
  Modelica.Units.SI.Power P_total_ElectricalStorage;
  Modelica.Units.SI.Power P_total_ElectricalHeater;
  Modelica.Units.SI.Power P_total_PtG;
  Modelica.Units.SI.Power P_total_RE;
  Modelica.Units.SI.Power P_total_RE_curtailed;
  Modelica.Units.SI.Power P_curtailment;
  Modelica.Units.SI.Power P_excess;

  Modelica.Units.SI.Power P_max_PowerPlant[n_PowerPlant];
  Modelica.Units.SI.Power P_min_PowerPlant[n_PowerPlant];
  Modelica.Units.SI.Power P_set_decentral_PowerPlant_Type[n_PowerPlant,2];
  Modelica.Units.SI.Power P_max_PowerPlant_Type[n_PowerPlant,2];
  Modelica.Units.SI.Power P_set_mod_PowerPlant_type_sum[n_PowerPlant,2];

  SI.Power P_max_unload_sorted_ElectricalStorage[n_ElectricalStorage];
  SI.Power P_max_unload_sorted_sum_ElectricalStorage[n_ElectricalStorage];
  SI.Power P_max_load_sorted_ElectricalStorage[n_ElectricalStorage];
  SI.Power P_max_load_sorted_sum_ElectricalStorage[n_ElectricalStorage](start=P_nom_load_ElectricalStorage);
  SI.Power P_sum_sorted_ElectricalStorage[n_ElectricalStorage];

  Modelica.Units.SI.Power P_max_load_sorted_PtG[n_PtG];
  Modelica.Units.SI.Power P_max_load_sorted_sum_PtG[n_PtG];
  Modelica.Units.SI.Power P_residual_PtG;
  Modelica.Units.SI.Power P_residual_single[3];
  Modelica.Units.SI.Power P_is[3];
  Modelica.Units.SI.Power P_residual_ElectricalStorage;
  Modelica.Units.SI.Power P_residual_ElectricalHeater(start=0);

  Modelica.Units.SI.Power P_residual_PowerPlants;
  Modelica.Units.SI.Power P_is_sorted_sum_PowerToGasPlant[n_PtG];

  SI.Power P_residual_single_mod_PtG[n_PtG](start=zeros(n_PtG));
  SI.Power P_residual_single_decentral_PtG[n_PtG](start=zeros(n_PtG));
  SI.Power P_residual_single_mod_PowerPlant[n_PowerPlant];
  SI.Power P_residual_single_decentral_PowerPlant[n_PowerPlant];

  SI.Power P_residual_PowerPlants_type1;
  SI.Power P_residual_PowerPlants_type2;
  SI.Power P_residual_PowerPlants_mod_type1;
  SI.Power P_residual_PowerPlants_mod_type2;

  Modelica.Units.SI.Power P_residual_total_with_SRL;
  Modelica.Units.SI.Power P_threshold_residual[3];

  SI.Power P_excess_Region_PowerPlant[Region];
  SI.Power P_excess_Region_PowerPlant_[Region,max(1, MaximumDifferentTypesOfPowerPlants)] "2Dim";
  SI.Power P_decentral_ElectrialStorage_Region[Region](start=zeros(Region));
  SI.Power P_decentral_PtG_Region[Region](start=zeros(Region));
  SI.Power P_residual_Region_decentralControl[Region,3];
  SI.Power P_residual_Region_decentralControl_PowerPlant[Region];
  SI.Power P_residual_Region_decentralControl_potentialcurtailment[Region];
  SI.Power P_decentral_ElectricHeater_Region[Region];
  SI.Power P_decentral_Region[Region,3];

  SI.Power P_set_decentral_PowerPlant[n_PowerPlant];
  SI.Power P_set_mod_PowerPlant[n_PowerPlant];
  SI.Power P_set_decentral_sum_PowerPlant_type[n_PowerPlant,2];
  SI.Power P_min_mod_PowerPlant[n_PowerPlant];
  SI.Power P_max_mod_PowerPlant[n_PowerPlant];
  SI.Power P_set_decentral_powerPlant_Region[Region,max(1, MaximumDifferentTypesOfPowerPlants)];

  SI.Power P_set_decentral_PtG[n_PtG](start=zeros(n_PtG));
  SI.Power P_set_decentral_sum_PtG[n_PtG];
  SI.Power P_set_mod_PtG[n_PtG];

  SI.Power P_residual_single_mod_ElectricalStorage[n_ElectricalStorage](start=zeros(n_ElectricalStorage));
  SI.Power P_residual_single_decentral_ElectricalStorage[n_ElectricalStorage](start=zeros(n_ElectricalStorage));
  SI.Power P_set_decentral_sum_ElectricalStorage[n_ElectricalStorage];
  SI.Power P_set_decentral_ElectricalStorage[n_ElectricalStorage];
  SI.Power P_set_mod_ElectricalStorage[n_ElectricalStorage];
  SI.Power P_max_unload_sorted_mod_ElectricalStorage[n_ElectricalStorage];
  SI.Power P_max_load_sorted_mod_ElectricalStorage[n_ElectricalStorage];
  SI.Power P_set_decentral_ElectricalHeater[n_ElectricalHeater];
  SI.Power P_set_decentral_sum_ElectricalHeater[n_ElectricalHeater];
  SI.Power P_set_mod_ElectricalHeater[n_ElectricalHeater];
  SI.Power P_set_PowerPlant_[n_PowerPlant];
  Real Counter_P_residual_single[3](each start=20);
  Real Counter_PowerPlant_OnTime[n_PowerPlant](each start=MinimumSwitchTimePowerPlants);
  Real Counter_PowerPlant_OffTime[n_PowerPlant](each start=MinimumSwitchTimePowerPlants);

  Boolean hysteresis_ElectricalStorage[n_ElectricalStorage];
  Boolean hysteresis_PowerPlant1[n_PowerPlant];
  Boolean hysteresis_PowerPlant2[n_PowerPlant];
  Boolean hysteresis_PowerPlant3[n_PowerPlant];
  Boolean hysteresis_PowerPlant4[n_PowerPlant];

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealOutput P_set_PowerPlant[n_PowerPlant] annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput P_set_Storage[n_ElectricalStorage] annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput P_set_PtG[n_PtG] annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  SI.Power P_residual_total;
  Modelica.Blocks.Interfaces.RealInput P_is_ElectricalStorage[max(1, n_ElectricalStorage)](start=zeros(max(1, n_ElectricalStorage))) annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={40,-120})));
  Modelica.Blocks.Interfaces.RealInput P_max_load_ElectricalStorage[max(1, n_ElectricalStorage)](start=ones(n_ElectricalStorage)) annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={0,-120})));
  Modelica.Blocks.Interfaces.RealInput P_max_unload_ElectricalStorage[max(1, n_ElectricalStorage)] annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={-40,-120})));
  Modelica.Blocks.Interfaces.RealInput P_max_ElectricalHeater[n_ElectricalHeater] annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={-80,-120})));
  Modelica.Blocks.Interfaces.RealOutput P_set_ElectricalHeater[n_ElectricalHeater] annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Interfaces.RealInput P_is_PowerToGasPlant[max(1, n_PtG)] annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-120,-80})));
  Modelica.Blocks.Interfaces.RealInput P_renewable[Region] annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealOutput P_curtailment_Region[Region] annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealInput P_is_PowerPlant[Region] annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-120,-40})));
  Modelica.Blocks.Interfaces.RealInput P_max_input_PowerPlant[n_PowerPlant] annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput P_residual_Region[Region] annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={80,-120})));
  Modelica.Blocks.Interfaces.RealInput P_DAC[max(1, n_PtG)] annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=180,
        origin={-120,80})));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  //Secondary Frequency Regulation - Controller
  //can influence P_set of powerplants for up to 30% of P_max to stabilize frequency
  TransiEnt.Basics.Blocks.LimPID PI_SRL(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    y_max=if sum(P_nom_PowerPlant) > 0 then sum(P_nom_PowerPlant)*0.3 else 2e10,
    y_min=if sum(P_nom_PowerPlant) > 0 then -sum(P_nom_PowerPlant)*0.3 else -2e10,
    k=1e10,
    Tau_i=1e-6,
    Ni=1e6,
    initOption=503,
    y_start=2e9) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=50) annotation (Placement(transformation(extent={{-46,-10},{-26,10}})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  Modelica.Blocks.Interfaces.RealInput f_grid annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={-40,120})));
equation

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //residual load including residual load from regional tables from P_residual_total and compensation from controller; <0 if more pruduced than used + controldirection, >0 if more used than produced +controldirection
  P_residual_total_with_SRL = P_residual_total + PI_SRL.y;
  //residual load results from some of all regional residual loads; is >0 or <0,
  //<0 if more pruduced than used, then setValues have to reduce->rise more to 0
  //>0 if more used than produced, then setValues have to increase->decrease more to -Pmax
  P_residual_total = sum(P_residual_Region);

  //_________________________________________________________________________________________________________________________________________________
  // The following block is used to define the residual loads of the components PtG+Electrical Storages+Electrical Heater
  // with a variable order defined by MeritOrderPositionElectricalStorage, MeritOrderPositionPtG and MeritOrderPositionElectricalHeater
  //_________________________________________________________________________________________________________________________________________________

  // calculation of residual load of components PtG+Electrical Storages+Electrical Heater
  for i in 1:3 loop
    if i == 1 then
      //first order - Technology is scheduled to compensate grid
      P_residual_single[i] = P_residual_total_with_SRL;
    elseif (abs(P_residual_single[i - 1] + P_is[i - 1]) > P_threshold_residual[i - 1]) and Counter_P_residual_single[i] > 15 then
      //if first order - technology can not achive this: the second order(or even 3rd) - technology gets scheduled to compensate this deficit
      P_residual_single[i] = P_residual_single[i - 1] + P_is[i - 1];
    else
      //if previous orders can compensate the next one is left idle
      P_residual_single[i] = 0;
    end if;
  end for;

  // usage of Counter_P_residual_single prevents chattering since P_residual_single will only switch if power is available for more than 15 sec
  for i in 1:3 loop
    if i == 1 then
      if P_residual_total_with_SRL > 0 then
        der(Counter_P_residual_single[i]) = 1;
      elseif Counter_P_residual_single[i] > 0 then
        der(Counter_P_residual_single[i]) = -Counter_P_residual_single[i];
      else
        der(Counter_P_residual_single[i]) = 0;
      end if;
    else
      if (abs(P_residual_single[i - 1] + P_is[i - 1]) > P_threshold_residual[i - 1]) then
        der(Counter_P_residual_single[i]) = 1;
      elseif Counter_P_residual_single[i] > 0 and abs(P_residual_single[i - 1] + P_is[i - 1]) <= P_threshold_residual[i - 1] then
        der(Counter_P_residual_single[i]) = -Counter_P_residual_single[i];
      else
        der(Counter_P_residual_single[i]) = 0;
      end if;
    end if;
  end for;

  //assignemnt of P_residual_single to the specific components defined by MeritOrderPosition-variables
  P_residual_ElectricalStorage = if (abs(P_residual_single[MeritOrderPositionElectricalStorage]) < P_threshold_residual_ElectricalStorage) then 0 else P_residual_single[MeritOrderPositionElectricalStorage];
  P_residual_ElectricalHeater = if (P_residual_single[MeritOrderPositionElectricalHeater] < -P_threshold_residual_ElectricalHeater) and time > 2 then P_residual_single[MeritOrderPositionElectricalHeater] else 0;
  P_residual_PtG = if P_residual_single[MeritOrderPositionPtG] <= -P_threshold_residual_PtG then P_residual_single[MeritOrderPositionPtG] else 0;
  //if there is more production than needed (P_residual_total_with_SRL<=0) OR if the deficit (P_residual_total_with_SRL>0) can be offset by ElStor unloading
  if P_residual_total_with_SRL <= 0 or P_residual_total_with_SRL <= sum(P_max_unload_sorted_ElectricalStorage) then
    //the powerplants are scheduled to stay idle
    P_residual_PowerPlants = 0;
  else
    //otherwise(P_residual_total_with_SRL>0 AND difficit can not be offset by ElSto)
    P_residual_PowerPlants = P_residual_total_with_SRL + P_total_ElectricalStorage + P_total_PtG + P_total_ElectricalHeater;
  end if;

  //assignment of specific P_threshold_residual-variables to P_threshold_residual defined by MeritOrderPosition-variables
  P_threshold_residual[MeritOrderPositionElectricalStorage] = P_threshold_residual_ElectricalStorage;
  P_threshold_residual[MeritOrderPositionElectricalHeater] = P_threshold_residual_ElectricalHeater;
  P_threshold_residual[MeritOrderPositionPtG] = P_threshold_residual_PtG;

  //assignment of specific P_is/P_set-variables to P_is defined by MeritOrderPosition-variables
  P_is[MeritOrderPositionElectricalStorage] = sum(P_set_Storage);
  P_is[MeritOrderPositionElectricalHeater] = -sum(P_set_ElectricalHeater);
  P_is[MeritOrderPositionPtG] = sum(P_is_PowerToGasPlant);

  //_________________________________________________________________________________________________________________________________________________
  // The following block is used to define the power, that is defined via the decentral control to the single component-types PtG+Electrical Storages+
  // Electrical Heater as well as the residual load that is available for the components
  //_________________________________________________________________________________________________________________________________________________

  //defintion of components-specific decentral power P_decentral_XYZ_Region. P_decentral_XYZ_Region[i] is the power that is assign to a component XYZ in Region i
  for i in 1:Region loop
    if Modelica.Math.Vectors.find(i, regionOfElectricalStorage) > 0 then
      P_decentral_ElectrialStorage_Region[i] = homotopy(P_residual_single_decentral_ElectricalStorage[Modelica.Math.Vectors.find(i, regionOfElectricalStorage)], 0);
    else
      P_decentral_ElectrialStorage_Region[i] = 0;
    end if;
    if Modelica.Math.Vectors.find(i, regionOfPtGPlant) > 0 then
      P_decentral_PtG_Region[i] = homotopy(P_residual_single_decentral_PtG[Modelica.Math.Vectors.find(i, regionOfPtGPlant)], 0);
    else
      P_decentral_PtG_Region[i] = 0;
    end if;
    if Modelica.Math.Vectors.find(i, regionOfElectricalHeater) > 0 then
      //Possible bug fix
      // P_decentral_ElectricHeater_Region[i]=homotopy(P_residual_single_decentral_ElectricalHeater[Modelica.Math.Vectors.find(i,regionOfPtGPlant)],0);
      P_decentral_ElectricHeater_Region[i] = homotopy(P_residual_single_decentral_ElectricalHeater[Modelica.Math.Vectors.find(i, regionOfElectricalHeater)], 0);
    else
      P_decentral_ElectricHeater_Region[i] = 0;
    end if;
  end for;

  //assignment of P_decentral_XYZ_Region to correct position in P_decentral_Region defined by MeritOrderPositionElectricalStorage, MeritOrderPositionPtG and MeritOrderPositionElectricalHeater
  P_decentral_Region[:, MeritOrderPositionElectricalStorage] = P_decentral_ElectrialStorage_Region;
  P_decentral_Region[:, MeritOrderPositionPtG] = P_decentral_PtG_Region;
  P_decentral_Region[:, MeritOrderPositionElectricalHeater] = P_decentral_ElectricHeater_Region;

  //definition of P_residual_Region_decentralControl. P_residual_Region_decentralControl[j,i] is the power, that is available for component i (defined by MeritOrderPosition-variables) in region i
  for i in 1:3 loop
    for j in 1:Region loop
      if i == 1 then
        P_residual_Region_decentralControl[j, i] = homotopy(P_residual_Region[j], 0);
      else
        if (abs(P_residual_Region_decentralControl[j, i - 1] - (P_decentral_Region[j, i - 1])) <= P_threshold_residual[i - 1]) then
          P_residual_Region_decentralControl[j, i] = 0;
        else
          P_residual_Region_decentralControl[j, i] = homotopy(P_residual_Region_decentralControl[j, i - 1] - (P_decentral_Region[j, i - 1]), 0);
        end if;
      end if;
    end for;
  end for;
  for i in 1:Region loop
    P_residual_Region_decentralControl_PowerPlant[i] = homotopy(P_residual_Region_decentralControl[i, 3] - P_decentral_Region[i, 3], 0);
    P_residual_Region_decentralControl_potentialcurtailment[i] = min(0, P_residual_Region_decentralControl_PowerPlant[i]);
  end for;

  //_________________________________________________________________________________________________________________________________________________
  // The following block is used to define the power for the electrical storages
  //_________________________________________________________________________________________________________________________________________________

  for i in 1:n_ElectricalStorage loop
    //maximum possible loading and unloading power
    P_max_unload_sorted_ElectricalStorage[i] = P_nom_unload_ElectricalStorage[i]*P_max_unload_ElectricalStorage[i];
    P_max_load_sorted_ElectricalStorage[i] = P_nom_load_ElectricalStorage[i]*P_max_load_ElectricalStorage[i];

    //region of electrical storage
    //regionOfElectricalStorage[i]=max(1,TransiEnt.Basics.Functions.real2integer(ElectricalStorages_allPlants[i, 1])); //declaration moved to outer controller

    //summation of maximum loading and unloading power and summation of assigned power in order of internal merit order of electrical storages
    if i == 1 then
      P_max_unload_sorted_sum_ElectricalStorage[i] = P_max_unload_sorted_ElectricalStorage[i];
      P_max_load_sorted_sum_ElectricalStorage[i] = P_max_load_sorted_ElectricalStorage[i];
      P_sum_sorted_ElectricalStorage[i] = P_is_ElectricalStorage[i];
    else
      P_max_unload_sorted_sum_ElectricalStorage[i] = P_max_unload_sorted_sum_ElectricalStorage[i - 1] + P_max_unload_sorted_ElectricalStorage[i];
      P_max_load_sorted_sum_ElectricalStorage[i] = P_max_load_sorted_sum_ElectricalStorage[i - 1] + P_max_load_sorted_ElectricalStorage[i];
      P_sum_sorted_ElectricalStorage[i] = P_is_ElectricalStorage[i] + P_sum_sorted_ElectricalStorage[i - 1];
    end if;

    //residual load for single electrical storage for assignment with central (mod) - control
    if i == 1 then
      P_residual_single_mod_ElectricalStorage[i] = P_residual_ElectricalStorage + sum(P_set_decentral_ElectricalStorage);
    elseif P_residual_ElectricalStorage > 0 then
      P_residual_single_mod_ElectricalStorage[i] = max(0, P_residual_ElectricalStorage + sum(P_set_decentral_ElectricalStorage) + sum(P_set_mod_ElectricalStorage[1:i - 1]));
    else
      P_residual_single_mod_ElectricalStorage[i] = min(0, P_residual_ElectricalStorage + sum(P_set_decentral_ElectricalStorage) + sum(P_set_mod_ElectricalStorage[1:i - 1]));
    end if;

    //residual load for single electrical storage for assignment with decentral - control
    if useDecentralizedPowerControl then
      if P_residual_Region_decentralControl[regionOfElectricalStorage[i], MeritOrderPositionElectricalStorage] > P_threshold_residual_ElectricalStorage and P_residual_ElectricalStorage > P_threshold_residual_ElectricalStorage then
        P_residual_single_decentral_ElectricalStorage[i] = min(P_max_unload_sorted_ElectricalStorage[i], min(P_residual_ElectricalStorage, P_residual_Region_decentralControl[regionOfElectricalStorage[i], MeritOrderPositionElectricalStorage]));
      elseif P_residual_Region_decentralControl[regionOfElectricalStorage[i], MeritOrderPositionElectricalStorage] < -P_threshold_residual_ElectricalStorage and P_residual_ElectricalStorage < -P_threshold_residual_ElectricalStorage then
        P_residual_single_decentral_ElectricalStorage[i] = max(-P_max_load_sorted_ElectricalStorage[i], max(P_residual_ElectricalStorage, P_residual_Region_decentralControl[regionOfElectricalStorage[i], MeritOrderPositionElectricalStorage]));
      else
        P_residual_single_decentral_ElectricalStorage[i] = 0;
      end if;
    else
      P_residual_single_decentral_ElectricalStorage[i] = 0;
    end if;

    //power of electrical storages, defined by decentral control
    if i == 1 then
      P_set_decentral_sum_ElectricalStorage[i] = P_set_decentral_ElectricalStorage[i];
    else
      P_set_decentral_sum_ElectricalStorage[i] = P_set_decentral_sum_ElectricalStorage[i - 1] + P_set_decentral_ElectricalStorage[i];
    end if;
    if i == 1 then
      P_set_decentral_ElectricalStorage[i] = -P_residual_single_decentral_ElectricalStorage[i];
    else
      if P_residual_ElectricalStorage < 0 then
        if P_residual_ElectricalStorage + P_set_decentral_sum_ElectricalStorage[i - 1] < -P_threshold_residual_ElectricalStorage then
          //only part of decentral residual load can be used
          P_set_decentral_ElectricalStorage[i] = -max((P_residual_ElectricalStorage + P_set_decentral_sum_ElectricalStorage[i - 1]), P_residual_single_decentral_ElectricalStorage[i]);
        else
          P_set_decentral_ElectricalStorage[i] = 0;
        end if;
      else
        if P_residual_ElectricalStorage + P_set_decentral_sum_ElectricalStorage[i - 1] > P_threshold_residual_ElectricalStorage then
          //only part of decentral residual load can be used
          P_set_decentral_ElectricalStorage[i] = -min((P_residual_ElectricalStorage + P_set_decentral_sum_ElectricalStorage[i - 1]), P_residual_single_decentral_ElectricalStorage[i]);
        else
          P_set_decentral_ElectricalStorage[i] = 0;
        end if;
      end if;
    end if;

    //maximum loading and unloading power availabe per storage after decentral power assignment
    P_max_unload_sorted_mod_ElectricalStorage[i] = if P_set_decentral_ElectricalStorage[i] < 0 then P_max_unload_sorted_ElectricalStorage[i] + P_set_decentral_ElectricalStorage[i] else P_max_unload_sorted_ElectricalStorage[i];
    P_max_load_sorted_mod_ElectricalStorage[i] = if P_set_decentral_ElectricalStorage[i] > 0 then P_max_load_sorted_ElectricalStorage[i] - P_set_decentral_ElectricalStorage[i] else P_max_load_sorted_ElectricalStorage[i];

    //power of electrical storages, defined by centralized (mod-) control
    if P_residual_single_mod_ElectricalStorage[i] >= P_threshold_residual_ElectricalStorage and P_max_unload_sorted_ElectricalStorage[i] >= P_threshold_residual_ElectricalStorage then
      P_set_mod_ElectricalStorage[i] = -min(P_max_unload_sorted_mod_ElectricalStorage[i], P_residual_single_mod_ElectricalStorage[i]);
    elseif P_residual_single_mod_ElectricalStorage[i] <= -P_threshold_residual_ElectricalStorage then
      P_set_mod_ElectricalStorage[i] = -max(-P_max_load_sorted_mod_ElectricalStorage[i], P_residual_single_mod_ElectricalStorage[i]);
    else
      P_set_mod_ElectricalStorage[i] = 0;
    end if;

    //power of electrical storages y = not pre(y) and u > uHigh or pre(y) and u >= uLow;
    hysteresis_ElectricalStorage[i] = not pre(hysteresis_ElectricalStorage[i]) and abs(P_set_decentral_ElectricalStorage[i] + P_set_mod_ElectricalStorage[i]) > P_threshold_residual_ElectricalStorage*1.01 or pre(hysteresis_ElectricalStorage[i]) and abs(P_set_decentral_ElectricalStorage[i] + P_set_mod_ElectricalStorage[i]) >= P_threshold_residual_ElectricalStorage;
    if hysteresis_ElectricalStorage[i] then
      P_set_Storage[i] = P_set_decentral_ElectricalStorage[i] + P_set_mod_ElectricalStorage[i];
    else
      P_set_Storage[i] = 0;
    end if;
  end for;

  //_________________________________________________________________________________________________________________________________________________
  // The following block is used to define the power for the power-to-gas plants
  //_________________________________________________________________________________________________________________________________________________

  for i in 1:n_PtG loop
    //maximum possible power assignable to PtG plant including DAC
    P_max_load_sorted_PtG[i] = P_nom_load_PtG[i] + P_DAC[i];

    //region of PtG
    //regionOfPtGPlant[i]=max(1,TransiEnt.Basics.Functions.real2integer(PtG_allPlants[i, 1])); //declaration moved to outer controller

    //summation of maximum loading power and summation of assigned power in order of internal merit order of PtG-plants
    if i == 1 then
      P_max_load_sorted_sum_PtG[i] = P_max_load_sorted_PtG[i];
      P_is_sorted_sum_PowerToGasPlant[i] = P_is_PowerToGasPlant[i];
    else
      P_max_load_sorted_sum_PtG[i] = P_max_load_sorted_sum_PtG[i - 1] + P_max_load_sorted_PtG[i];
      P_is_sorted_sum_PowerToGasPlant[i] = P_is_sorted_sum_PowerToGasPlant[i - 1] + P_is_PowerToGasPlant[i];
    end if;

    //residual load available per PtG-plants for centralized (mod) - control
    if i == 1 then
      P_residual_single_mod_PtG[i] = min(0, P_residual_PtG + sum(P_set_decentral_PtG));
    else
      P_residual_single_mod_PtG[i] = min(0, P_residual_PtG + P_is_sorted_sum_PowerToGasPlant[i - 1] + sum(P_set_decentral_PtG[i:n_PtG]));
    end if;

    //power, assigned to PtG-plants via centralized (mod) - control
    P_set_mod_PtG[i] = max(0, -P_residual_single_mod_PtG[i]);

    //residual load available per PtG-plants for decentralized - control
    if useDecentralizedPowerControl then
      P_residual_single_decentral_PtG[i] = min(0, max(-P_max_load_sorted_PtG[i], max(P_residual_PtG, P_residual_Region_decentralControl[regionOfPtGPlant[i], MeritOrderPositionPtG])));
    else
      P_residual_single_decentral_PtG[i] = 0;
    end if;
    if useDecentralizedPowerControl then

      //summation of decentralized assigned power of PtG
      if i == 1 then
        P_set_decentral_sum_PtG[i] = P_set_decentral_PtG[i];
      else
        P_set_decentral_sum_PtG[i] = P_set_decentral_sum_PtG[i - 1] + P_set_decentral_PtG[i]*min(max(0, -1 + time), 1);
      end if;

      //power, assigned to PtG-plants via decentralized control
      if (i == 1) then
        P_set_decentral_PtG[i] = homotopy(-max(P_residual_single_decentral_PtG[i], P_residual_PtG), 0);
      else
        P_set_decentral_PtG[i] = homotopy(max(0, min(-(P_residual_PtG + P_set_decentral_sum_PtG[i - 1]), -P_residual_single_decentral_PtG[i])), 0);
      end if;
    else
      P_set_decentral_PtG[i] = 0;
      P_set_decentral_sum_PtG[i] = 0;
    end if;

    // power, assigned to PtG-plants
    if P_set_mod_PtG[i] + P_set_decentral_PtG[i] >= P_threshold_residual_PtG then
      P_set_PtG[i] = P_set_mod_PtG[i] + P_set_decentral_PtG[i];
    else
      P_set_PtG[i] = 0;
    end if;
  end for;

  //_________________________________________________________________________________________________________________________________________________
  // The following block is used to define the power for the power-to-gas plants
  //_________________________________________________________________________________________________________________________________________________

  //residual load for gasturbines (type1) CCGT (type2)
  //type2 get priority for balancing if they can do it
  P_residual_PowerPlants_type2 = min(P_residual_PowerPlants, sum(P_max_PowerPlant_Type[:, 2]));
  //type1 gets rest of residual P
  P_residual_PowerPlants_type1 = P_residual_PowerPlants - sum(P_max_PowerPlant_Type[:, 2]);

  //residual load for gasturbines (type1) CCGT (type2) for centralized (mod) - control
  P_residual_PowerPlants_mod_type1 = P_residual_PowerPlants_type1 - sum(P_set_decentral_PowerPlant_Type[:, 1]);
  P_residual_PowerPlants_mod_type2 = P_residual_PowerPlants_type2 - sum(P_set_decentral_PowerPlant_Type[:, 2]);

  //assignment of default values if no power plant is used in simulation
  //   if PowerPlants_allPlants[1,1]<1 then
  if MaximumDifferentTypesOfPowerPlants < 1 then
    for i in 1:n_PowerPlant loop
      P_max_PowerPlant[i] = 0;
      P_min_PowerPlant[i] = 0;
      P_set_decentral_PowerPlant_Type[i, 1] = 0;
      P_set_decentral_PowerPlant_Type[i, 2] = 0;
      P_max_PowerPlant_Type[i, 1] = 0;
      P_max_PowerPlant_Type[i, 2] = 0;
      P_max_sorted_sum_PowerPlant[i] = 0;
      P_max_mod_sorted_sum_PowerPlant[i] = 0;
      P_set_mod_PowerPlant_type_sum[i, 1] = 0;
      P_set_mod_PowerPlant_type_sum[i, 2] = 0;
      P_residual_single_mod_PowerPlant[i] = 0;
      //regionOfPowerPlant[i]=0; //declaration moved to outer controller
      P_residual_single_decentral_PowerPlant[i] = 0;
      P_set_decentral_PowerPlant[i] = 0;
      P_set_decentral_sum_PowerPlant_type[i, 1] = 0;
      P_set_decentral_sum_PowerPlant_type[i, 2] = 0;
      P_max_mod_PowerPlant[i] = 0;
      P_min_mod_PowerPlant[i] = 0;
      P_set_mod_PowerPlant[i] = 0;
      P_set_PowerPlant_[i] = 0;
      Counter_PowerPlant_OnTime[i] = -2;
      Counter_PowerPlant_OffTime[i] = -2;
      P_set_PowerPlant[i] = 0;
      hysteresis_PowerPlant1[i] = false;
      hysteresis_PowerPlant2[i] = false;
      hysteresis_PowerPlant3[i] = false;
      hysteresis_PowerPlant4[i] = false;
      for j in 1:Region loop
        P_excess_Region_PowerPlant_[j, i] = 0;
        P_excess_Region_PowerPlant[j] = 0;
        P_set_decentral_powerPlant_Region[j, 1] = 0;
      end for;
    end for;
  end if;
  //else
  if MaximumDifferentTypesOfPowerPlants >= 1 then
    //if power is needed from power plants, power plants start with minimum load such that too much power is supplied and excess power needs to be curtailed.
    //P_excess_Region_PowerPlant_[i,j] defines the excess power per powerplant type j (GT or CCGT) and region i.
    //P_excess_Region_PowerPlant[i] defines excess power from power plants per region i

    for i in 1:Region loop
      for j in 1:MaximumDifferentTypesOfPowerPlants loop
        if min((abs(powerPlantMatrix - fill({i,j}, NumberOfPowerplantsOverAllRegions)))*[1; 1]) == 0 then
          P_excess_Region_PowerPlant_[i, j] = min(0, P_set_PowerPlant[Modelica.Math.Vectors.find(0, vector(((abs(powerPlantMatrix - fill({i,j}, NumberOfPowerplantsOverAllRegions)))*[1; 1])))] + max(0, P_residual_single_mod_PowerPlant[Modelica.Math.Vectors.find(0, vector(((abs(powerPlantMatrix - fill({i,j}, NumberOfPowerplantsOverAllRegions)))*[1; 1])))]) + max(0, P_residual_single_decentral_PowerPlant[Modelica.Math.Vectors.find(0, vector(((abs(powerPlantMatrix - fill({i,j}, NumberOfPowerplantsOverAllRegions)))*[1; 1])))]));
        else
          P_excess_Region_PowerPlant_[i, j] = 0;
        end if;
      end for;
      P_excess_Region_PowerPlant[i] = sum(P_excess_Region_PowerPlant_[i, :]);
    end for;

    //power, assigned to power plants via decentralized control in region i to Gasturbines (j=1) and CCGT (j=2)
    for i in 1:Region loop
      for j in 1:MaximumDifferentTypesOfPowerPlants loop
        //if this i,j combination is/has a powerplant
        if min((abs(powerPlantMatrix - fill({i,j}, NumberOfPowerplantsOverAllRegions)))*[1; 1]) == 0 then
          //it is assigned the value it gets further down in list-format
          P_set_decentral_powerPlant_Region[i, j] = P_set_decentral_PowerPlant[Modelica.Math.Vectors.find(0, vector(((abs(powerPlantMatrix - fill({i,j}, NumberOfPowerplantsOverAllRegions)))*[1; 1])))];
        else
          P_set_decentral_powerPlant_Region[i, j] = 0;
        end if;
      end for;
    end for;
  end if;
  if MaximumDifferentTypesOfPowerPlants >= 1 then
    for i in 1:n_PowerPlant loop
      //maximum and minimum possible power of power plants
      //  >=0             =      >0                  * -((-1)-0)
      P_max_PowerPlant[i] = P_max_const_PowerPlant[i]*(-P_max_input_PowerPlant[i]);
      //  >=0
      P_min_PowerPlant[i] = P_min_const_PowerPlant[i];
      // is >=0
      //power, assigned to power plant in region i to power plant type Gasturbine (j=1) and CCGT (type=2) and maximum power per type and region
      if powerPlantTypeDefinition[i] == 1 then
        P_set_decentral_PowerPlant_Type[i, 1] = P_set_decentral_PowerPlant[i];
        P_set_decentral_PowerPlant_Type[i, 2] = 0;
        P_max_PowerPlant_Type[i, 1] = P_max_PowerPlant[i];
        P_max_PowerPlant_Type[i, 2] = 0;
      elseif powerPlantTypeDefinition[i] == 2 then
        P_set_decentral_PowerPlant_Type[i, 1] = 0;
        P_set_decentral_PowerPlant_Type[i, 2] = P_set_decentral_PowerPlant[i];
        P_max_PowerPlant_Type[i, 1] = 0;
        P_max_PowerPlant_Type[i, 2] = P_max_PowerPlant[i];
      end if;

      //summation of maximum possible power (P_max_sorted_sum_PowerPlant), maximum possible power for centralized (mod) - control (P_max_mod_sorted_sum_PowerPlant)
      //and assigned power via centralized (mod) - split up into values for gasturbines ([i,1]) and CCGT ([i,2])
      if i == 1 then
        P_max_sorted_sum_PowerPlant[i] = P_max_PowerPlant[i];
        P_max_mod_sorted_sum_PowerPlant[i] = P_max_mod_PowerPlant[i];
        if powerPlantTypeDefinition[i] == 1 then
          P_set_mod_PowerPlant_type_sum[i, 1] = P_set_mod_PowerPlant[i];
          P_set_mod_PowerPlant_type_sum[i, 2] = 0;
        elseif powerPlantTypeDefinition[i] == 2 then
          P_set_mod_PowerPlant_type_sum[i, 2] = P_set_mod_PowerPlant[i];
          P_set_mod_PowerPlant_type_sum[i, 1] = 0;
        end if;
      else
        P_max_sorted_sum_PowerPlant[i] = P_max_sorted_sum_PowerPlant[i - 1] + P_max_PowerPlant[i];
        P_max_mod_sorted_sum_PowerPlant[i] = P_max_mod_sorted_sum_PowerPlant[i - 1] + P_max_mod_PowerPlant[i];
        if powerPlantTypeDefinition[i] == 1 then
          P_set_mod_PowerPlant_type_sum[i, 1] = P_set_mod_PowerPlant_type_sum[i - 1, 1] + P_set_mod_PowerPlant[i];
          P_set_mod_PowerPlant_type_sum[i, 2] = P_set_mod_PowerPlant_type_sum[i - 1, 2];
        elseif powerPlantTypeDefinition[i] == 2 then
          P_set_mod_PowerPlant_type_sum[i, 2] = P_set_mod_PowerPlant_type_sum[i - 1, 2] + P_set_mod_PowerPlant[i];
          P_set_mod_PowerPlant_type_sum[i, 1] = P_set_mod_PowerPlant_type_sum[i - 1, 1];
        end if;
      end if;
    end for;
  end if;
  if MaximumDifferentTypesOfPowerPlants >= 1 then
    for i in 1:n_PowerPlant loop
      //residual power available for power plants in centralized (mod)- control
      if i == 1 then
        if powerPlantTypeDefinition[i] == 1 then
          P_residual_single_mod_PowerPlant[i] = P_residual_PowerPlants_type1 + sum(P_set_decentral_PowerPlant_Type[:, 1]);
        else
          P_residual_single_mod_PowerPlant[i] = P_residual_PowerPlants_type2 + sum(P_set_decentral_PowerPlant_Type[:, 2]);
        end if;
      else
        if powerPlantTypeDefinition[i] == 1 then
          P_residual_single_mod_PowerPlant[i] = min(P_max_mod_PowerPlant[i], P_residual_PowerPlants_type1 + sum(P_set_decentral_PowerPlant_Type[:, 1]) + P_set_mod_PowerPlant_type_sum[i - 1, 1]);
        else
          P_residual_single_mod_PowerPlant[i] = min(P_max_mod_PowerPlant[i], P_residual_PowerPlants_type2 + sum(P_set_decentral_PowerPlant_Type[:, 2]) + P_set_mod_PowerPlant_type_sum[i - 1, 2]);
        end if;
      end if;
    end for;
  end if;
  if MaximumDifferentTypesOfPowerPlants >= 1 then
    for i in 1:n_PowerPlant loop

      //region of power plant
      //regionOfPowerPlant[i]=TransiEnt.Basics.Functions.real2integer(PowerPlants_allPlants[i, 1]); //declaration moved to outer controller

      //residual power available for power plants in decentralized control
      if useDecentralizedPowerControl then
        //if there is nothing left to balance(?)
        if P_residual_PowerPlants < 0 then
          P_residual_single_decentral_PowerPlant[i] = 0;
          //if there is a deficit though
          //and it's type 1
        elseif powerPlantTypeDefinition[i] == 1 then
          //          1                    >              1                  and             [nRegions][regionOfPowerPlant[i]->1] -> 1                + sum(             [nRegions,nTypes][regionOfPowerPlant[i]->1 , 1:         nType-1 -> (0|1) ]   >                  1
          if P_residual_PowerPlants_type1 > P_threshold_residual_PowerPlant and P_residual_Region_decentralControl_PowerPlant[regionOfPowerPlant[i]] + sum(P_set_decentral_powerPlant_Region[regionOfPowerPlant[i], 1:(powerPlantMatrix[i, 2] - 1)]) > P_threshold_residual_PowerPlant then
            //              >0                       = min    >0              ,min(   >0   , >0  +sum(  <0[]!  )          )
            P_residual_single_decentral_PowerPlant[i] = min(P_max_PowerPlant[i], min(P_residual_PowerPlants_type1, P_residual_Region_decentralControl_PowerPlant[regionOfPowerPlant[i]] + sum(P_set_decentral_powerPlant_Region[regionOfPowerPlant[i], 1:(powerPlantMatrix[i, 2] - 1)])));
            //P, das von einem spez. Kraftwerk gefordert wird = was von der Region gefordert wird,
          else
            P_residual_single_decentral_PowerPlant[i] = 0;
          end if;
          //or if it's type 2
        elseif powerPlantTypeDefinition[i] == 2 then
          if P_residual_PowerPlants_type2 > P_threshold_residual_PowerPlant and P_residual_Region_decentralControl_PowerPlant[regionOfPowerPlant[i]] > 0 then
            P_residual_single_decentral_PowerPlant[i] = min(P_max_PowerPlant[i], min(P_residual_PowerPlants_type2, P_residual_Region_decentralControl_PowerPlant[regionOfPowerPlant[i]]));
          else
            P_residual_single_decentral_PowerPlant[i] = 0;
          end if;
        end if;
      else
        P_residual_single_decentral_PowerPlant[i] = 0;
      end if;

    end for;
  end if;
  if MaximumDifferentTypesOfPowerPlants >= 1 then
    for i in 1:n_PowerPlant loop

      if P_residual_PowerPlants < P_threshold_residual_PowerPlant or not (useDecentralizedPowerControl) then
        P_set_decentral_PowerPlant[i] = 0;
        P_set_decentral_sum_PowerPlant_type[i, 1] = 0;
        P_set_decentral_sum_PowerPlant_type[i, 2] = 0;
        hysteresis_PowerPlant1[i] = false;
        hysteresis_PowerPlant2[i] = false;
      else
        //summation of decentrally assigned power of power plants
        if i == 1 then
          if powerPlantTypeDefinition[i] == 1 then
            P_set_decentral_sum_PowerPlant_type[i, 1] = P_set_decentral_PowerPlant[i];
            P_set_decentral_sum_PowerPlant_type[i, 2] = 0;
          elseif powerPlantTypeDefinition[i] == 2 then
            P_set_decentral_sum_PowerPlant_type[i, 1] = 0;
            P_set_decentral_sum_PowerPlant_type[i, 2] = P_set_decentral_PowerPlant[i];
          end if;
        else
          if powerPlantTypeDefinition[i] == 1 then
            P_set_decentral_sum_PowerPlant_type[i, 1] = P_set_decentral_sum_PowerPlant_type[i - 1, 1] + P_set_decentral_PowerPlant[i];
            P_set_decentral_sum_PowerPlant_type[i, 2] = P_set_decentral_sum_PowerPlant_type[i - 1, 2];
          elseif powerPlantTypeDefinition[i] == 2 then
            P_set_decentral_sum_PowerPlant_type[i, 2] = P_set_decentral_sum_PowerPlant_type[i - 1, 2] + P_set_decentral_PowerPlant[i];
            P_set_decentral_sum_PowerPlant_type[i, 1] = P_set_decentral_sum_PowerPlant_type[i - 1, 1];
          end if;
        end if;
        //power, assigned to power plants via decentralized control
        if powerPlantTypeDefinition[i] == 1 then
          if i == 1 then
            hysteresis_PowerPlant1[i] = true;
            hysteresis_PowerPlant2[i] = true;
            if P_residual_single_decentral_PowerPlant[i] >= P_threshold_residual_PowerPlant and P_residual_PowerPlants_type1 >= P_threshold_residual_PowerPlant then
              //soll >=0                     = machePositiv(größererBetrag(   <=0,                    <=0                  ))
              P_set_decentral_PowerPlant[i] = -min(P_residual_single_decentral_PowerPlant[i], P_residual_PowerPlants_type1);
            else
              P_set_decentral_PowerPlant[i] = 0;
            end if;
          else
            hysteresis_PowerPlant1[i] = not pre(hysteresis_PowerPlant1[i]) and P_residual_PowerPlants_type1 + P_set_decentral_sum_PowerPlant_type[i - 1, 1] - P_residual_single_decentral_PowerPlant[i] >= P_threshold_residual_PowerPlant*100 or pre(hysteresis_PowerPlant1[i]) and P_residual_PowerPlants_type1 + P_set_decentral_sum_PowerPlant_type[i - 1, 1] - P_residual_single_decentral_PowerPlant[i] >= P_threshold_residual_PowerPlant;
            hysteresis_PowerPlant2[i] = not pre(hysteresis_PowerPlant2[i]) and P_residual_PowerPlants_type1 + P_set_decentral_sum_PowerPlant_type[i - 1, 1] >= P_threshold_residual_PowerPlant*100 or pre(hysteresis_PowerPlant2[i]) and P_residual_PowerPlants_type1 + P_set_decentral_sum_PowerPlant_type[i - 1, 1] >= P_threshold_residual_PowerPlant;
            if hysteresis_PowerPlant1[i] then
              P_set_decentral_PowerPlant[i] = -P_residual_single_decentral_PowerPlant[i];
            elseif hysteresis_PowerPlant2[i] then
              P_set_decentral_PowerPlant[i] = -(P_residual_PowerPlants_type1 + P_set_decentral_sum_PowerPlant_type[i - 1, 1]);
            else
              P_set_decentral_PowerPlant[i] = 0;
            end if;
          end if;
        elseif powerPlantTypeDefinition[i] == 2 then
          if i == 1 then
            hysteresis_PowerPlant1[i] = true;
            hysteresis_PowerPlant2[i] = true;
            if P_residual_single_decentral_PowerPlant[i] >= P_threshold_residual_PowerPlant and P_residual_PowerPlants_type2 >= P_threshold_residual_PowerPlant then
              P_set_decentral_PowerPlant[i] = -min(P_residual_single_decentral_PowerPlant[i], P_residual_PowerPlants_type2);
            else
              P_set_decentral_PowerPlant[i] = 0;
            end if;
          else
            hysteresis_PowerPlant1[i] = not pre(hysteresis_PowerPlant1[i]) and P_residual_PowerPlants_type2 + P_set_decentral_sum_PowerPlant_type[i - 1, 2] - P_residual_single_decentral_PowerPlant[i] >= P_threshold_residual_PowerPlant*100 or pre(hysteresis_PowerPlant1[i]) and P_residual_PowerPlants_type2 + P_set_decentral_sum_PowerPlant_type[i - 1, 2] - P_residual_single_decentral_PowerPlant[i] >= P_threshold_residual_PowerPlant;
            hysteresis_PowerPlant2[i] = not pre(hysteresis_PowerPlant2[i]) and P_residual_PowerPlants_type2 + P_set_decentral_sum_PowerPlant_type[i - 1, 2] >= P_threshold_residual_PowerPlant*100 or pre(hysteresis_PowerPlant2[i]) and P_residual_PowerPlants_type2 + P_set_decentral_sum_PowerPlant_type[i - 1, 2] >= P_threshold_residual_PowerPlant;
            if hysteresis_PowerPlant1[i] then
              P_set_decentral_PowerPlant[i] = -P_residual_single_decentral_PowerPlant[i];
            elseif hysteresis_PowerPlant2[i] then
              P_set_decentral_PowerPlant[i] = -(P_residual_PowerPlants_type2 + P_set_decentral_sum_PowerPlant_type[i - 1, 2]);
            else
              P_set_decentral_PowerPlant[i] = 0;
            end if;
          end if;
        end if;
      end if;
    end for;
  end if;
  if MaximumDifferentTypesOfPowerPlants >= 1 then
    for i in 1:n_PowerPlant loop
      //maximum and minimum power plants for centralized (mod) - control
      P_max_mod_PowerPlant[i] = P_max_PowerPlant[i] + P_set_decentral_PowerPlant[i];
      P_min_mod_PowerPlant[i] = if P_set_decentral_PowerPlant[i] < 0 then max(0, P_min_PowerPlant[i] + P_set_decentral_PowerPlant[i]) else P_min_PowerPlant[i];

      //power for power plants assigned by centralized (mod) - control
      hysteresis_PowerPlant4[i] = not pre(hysteresis_PowerPlant4[i]) and P_residual_single_mod_PowerPlant[i] > P_threshold_residual_PowerPlant*100 or pre(hysteresis_PowerPlant4[i]) and P_residual_single_mod_PowerPlant[i] > P_threshold_residual_PowerPlant;
      if hysteresis_PowerPlant4[i] then
        P_set_mod_PowerPlant[i] = -max(P_min_mod_PowerPlant[i], min(P_max_mod_PowerPlant[i], P_residual_single_mod_PowerPlant[i]));
      else
        P_set_mod_PowerPlant[i] = 0;
      end if;

      //calculation of desired power from power plant
      hysteresis_PowerPlant3[i] = not pre(hysteresis_PowerPlant3[i]) and P_set_mod_PowerPlant[i] + P_set_decentral_PowerPlant[i] < -P_threshold_residual_PowerPlant*100 or pre(hysteresis_PowerPlant3[i]) and P_set_mod_PowerPlant[i] + P_set_decentral_PowerPlant[i] < -P_threshold_residual_PowerPlant;
      if hysteresis_PowerPlant3[i] then
        P_set_PowerPlant_[i] = min(-P_min_PowerPlant[i], P_set_mod_PowerPlant[i] + P_set_decentral_PowerPlant[i]);
      else
        P_set_PowerPlant_[i] = 0;
      end if;
    end for;
  end if;
  if MaximumDifferentTypesOfPowerPlants >= 1 then
    for i in 1:n_PowerPlant loop
      //calculation of Counters to avoid chattering while turning off or on.
      //If power plant is turned on, it will only be shut down again after time defined by 'MinimumSwitchTimePowerPlants'
      //If power plant is shut down, it will only be turned on again after time defined by 'MinimumSwitchTimePowerPlants'
      //calculation of power from power plants (P_set_PowerPlant) which is equal to P_set_PowerPlant_, but limited by MinimumSwitchTimePowerPlants-control
      //if 'MinimumSwitchTimePowerPlants' is =0, P_set_PowerPlant is equal to P_set_PowerPlant_
      if MinimumSwitchTimePowerPlants > 0 then
        if noEvent((P_set_PowerPlant_[i] < 0 and der(Counter_PowerPlant_OnTime[i]) >= 0 and Counter_PowerPlant_OnTime[i] < MinimumSwitchTimePowerPlants) or (P_set_PowerPlant_[i] >= 0 and der(Counter_PowerPlant_OnTime[i]) >= 0 and P_set_PowerPlant[i] < 0 and Counter_PowerPlant_OnTime[i] < MinimumSwitchTimePowerPlants and Counter_PowerPlant_OnTime[i] > 0)) then
          der(Counter_PowerPlant_OnTime[i]) = 1;
        elseif noEvent(P_set_PowerPlant_[i] < 0 and der(Counter_PowerPlant_OnTime[i]) >= 0 and Counter_PowerPlant_OnTime[i] < MinimumSwitchTimePowerPlants) then
          der(Counter_PowerPlant_OnTime[i]) = 1;
        else
          der(Counter_PowerPlant_OnTime[i]) = 0;
        end if;

        when P_set_PowerPlant_[i] >= 0 and P_set_PowerPlant[i] >= 0 then
          reinit(Counter_PowerPlant_OnTime[i], 0);
        end when;

        if noEvent((P_set_PowerPlant_[i] >= 0 and P_set_PowerPlant[i] >= 0 and Counter_PowerPlant_OffTime[i] < MinimumSwitchTimePowerPlants) or (P_set_PowerPlant_[i] <= 0 and P_set_PowerPlant[i] >= 0 and Counter_PowerPlant_OffTime[i] < MinimumSwitchTimePowerPlants and Counter_PowerPlant_OffTime[i] > 0)) then
          der(Counter_PowerPlant_OffTime[i]) = 1;
        elseif noEvent((P_set_PowerPlant_[i] >= 0 and P_set_PowerPlant[i] >= 0 and Counter_PowerPlant_OffTime[i] < MinimumSwitchTimePowerPlants)) then
          der(Counter_PowerPlant_OffTime[i]) = 1;
        else
          der(Counter_PowerPlant_OffTime[i]) = 0;
        end if;

        when P_set_PowerPlant_[i] < 0 and P_set_PowerPlant[i] < 0 then
          reinit(Counter_PowerPlant_OffTime[i], 0);
        end when;

        if Counter_PowerPlant_OnTime[i] >= MinimumSwitchTimePowerPlants or Counter_PowerPlant_OffTime[i] >= MinimumSwitchTimePowerPlants then
          P_set_PowerPlant[i] = P_set_PowerPlant_[i];
        elseif Counter_PowerPlant_OnTime[i] > 0 and der(Counter_PowerPlant_OnTime[i]) > 0 then
          //      <0        =    (         <0       ,    <0              )
          P_set_PowerPlant[i] = min(P_set_PowerPlant_[i], -P_min_PowerPlant[i]);
        elseif Counter_PowerPlant_OffTime[i] > 0 and P_set_PowerPlant_[i] <= 0 then
          P_set_PowerPlant[i] = 0;
        else
          P_set_PowerPlant[i] = P_set_PowerPlant_[i];
        end if;
      else
        P_set_PowerPlant[i] = P_set_PowerPlant_[i];
        Counter_PowerPlant_OffTime[i] = -1;
        Counter_PowerPlant_OnTime[i] = -1;
      end if;
    end for;
  end if;

  //_________________________________________________________________________________________________________________________________________________
  // The following block is used to define the power for the electrical heater
  //_________________________________________________________________________________________________________________________________________________

  for i in 1:n_ElectricalHeater loop
    //if no electrical heater exists or no electrical power can be taken up
    if P_max_ElectricalHeater[i] <= 0 then
      P_set_ElectricalHeater[i] = 0;
      P_residual_single_decentral_ElectricalHeater[i] = 0;
      P_residual_single_mod_ElectricalHeater[i] = 0;
      P_residual_single_ElectricalHeater[i] = 0;
      //regionOfElectricalHeater[i]=0; //declaration moved to outer controller
      P_set_decentral_ElectricalHeater[i] = 0;
      if i == 1 then
        P_set_decentral_sum_ElectricalHeater[i] = 0;
        P_max_mod_sorted_sum_ElectricalHeater[i] = 0;
        P_max_sorted_sum_ElectricalHeater[i] = 0;
      else
        P_set_decentral_sum_ElectricalHeater[i] = P_set_decentral_sum_ElectricalHeater[i - 1];
        P_max_mod_sorted_sum_ElectricalHeater[i] = P_max_mod_sorted_sum_ElectricalHeater[i - 1];
        P_max_sorted_sum_ElectricalHeater[i] = P_max_sorted_sum_ElectricalHeater[i - 1] + P_max_ElectricalHeater[i];
      end if;
      P_max_mod_ElectricalHeater[i] = 0;
      P_set_mod_ElectricalHeater[i] = 0;
    else
      //region of electrical heater
      //regionOfElectricalHeater[i]=TransiEnt.Basics.Functions.real2integer(ElectricalHeater_allPlants[min(n_ElectricalHeater2, i), 1]); //declaration moved to outer controller

      //residual power available for electrical heater in decentraliced control
      if useDecentralizedPowerControl then
        if i == 1 then
          if max(P_residual_ElectricalHeater, P_residual_Region_decentralControl[regionOfElectricalHeater[i], MeritOrderPositionElectricalHeater]) <= -P_threshold_residual_ElectricalHeater then
            P_residual_single_decentral_ElectricalHeater[i] = max(P_residual_ElectricalHeater, P_residual_Region_decentralControl[regionOfElectricalHeater[i], MeritOrderPositionElectricalHeater]);
          else
            P_residual_single_decentral_ElectricalHeater[i] = 0;
          end if;
        else
          if i > 1 and P_residual_ElectricalHeater - P_set_decentral_sum_ElectricalHeater[i - 1] <= -P_threshold_residual_ElectricalHeater and P_residual_Region_decentralControl[regionOfElectricalHeater[i], MeritOrderPositionElectricalHeater] <= -P_threshold_residual_ElectricalHeater then
            P_residual_single_decentral_ElectricalHeater[i] = max(P_residual_ElectricalHeater - P_set_decentral_sum_ElectricalHeater[i - 1], P_residual_Region_decentralControl[regionOfElectricalHeater[i], MeritOrderPositionElectricalHeater]);
          else
            P_residual_single_decentral_ElectricalHeater[i] = 0;
          end if;
        end if;
      else
        P_residual_single_decentral_ElectricalHeater[i] = 0;
      end if;
      P_residual_single_ElectricalHeater[i] = P_residual_single_mod_ElectricalHeater[i] + P_residual_single_decentral_ElectricalHeater[i];
      P_set_decentral_ElectricalHeater[i] = max(P_residual_single_decentral_ElectricalHeater[i], -P_max_ElectricalHeater[i]);
      //   P_set_decentral_ElectricalHeater  [i]=0;
      P_set_decentral_sum_ElectricalHeater[i] = 0;
      P_max_mod_ElectricalHeater[i] = if noEvent(P_max_ElectricalHeater[i] + P_set_decentral_ElectricalHeater[i] >= P_threshold_residual_ElectricalHeater) then P_max_ElectricalHeater[i] + P_set_decentral_ElectricalHeater[i] else 0;
      if i == 1 then
        P_max_sorted_sum_ElectricalHeater[i] = P_max_ElectricalHeater[i];
        P_max_mod_sorted_sum_ElectricalHeater[i] = P_max_mod_ElectricalHeater[i];
        if P_residual_ElectricalHeater - sum(P_set_decentral_ElectricalHeater) < -P_threshold_residual_ElectricalHeater then
          P_residual_single_mod_ElectricalHeater[i] = P_residual_ElectricalHeater - sum(P_set_decentral_ElectricalHeater);
        else
          P_residual_single_mod_ElectricalHeater[i] = 0;
        end if;
        if noEvent(P_residual_ElectricalHeater >= -P_threshold_residual_ElectricalHeater or P_max_mod_ElectricalHeater[i] <= P_threshold_residual_ElectricalHeater) then
          P_set_mod_ElectricalHeater[i] = 0;
        else
          if noEvent(max(P_residual_ElectricalHeater - sum(P_set_decentral_ElectricalHeater), -P_max_mod_ElectricalHeater[i]) <= -P_threshold_residual_ElectricalHeater) then
            P_set_mod_ElectricalHeater[i] = max(P_residual_ElectricalHeater - sum(P_set_decentral_ElectricalHeater), -P_max_mod_ElectricalHeater[i]);
          else
            P_set_mod_ElectricalHeater[i] = 0;
          end if;
        end if;
      else
        if P_residual_ElectricalHeater - sum(P_set_decentral_ElectricalHeater) + P_max_mod_sorted_sum_ElectricalHeater[i - 1] < -P_threshold_residual_ElectricalHeater then
          P_residual_single_mod_ElectricalHeater[i] = P_residual_ElectricalHeater - sum(P_set_decentral_ElectricalHeater) + P_max_mod_sorted_sum_ElectricalHeater[i - 1];
        else
          P_residual_single_mod_ElectricalHeater[i] = 0;
        end if;
        P_max_mod_sorted_sum_ElectricalHeater[i] = P_max_mod_sorted_sum_ElectricalHeater[i - 1] + P_max_mod_ElectricalHeater[i];
        P_max_sorted_sum_ElectricalHeater[i] = P_max_sorted_sum_ElectricalHeater[i - 1] + P_max_ElectricalHeater[i];
        if noEvent(max(P_residual_ElectricalHeater - sum(P_set_decentral_ElectricalHeater) + P_max_mod_sorted_sum_ElectricalHeater[i - 1], -P_max_mod_ElectricalHeater[i]) <= -P_threshold_residual_ElectricalHeater) then
          P_set_mod_ElectricalHeater[i] = max(P_residual_ElectricalHeater - sum(P_set_decentral_ElectricalHeater) + P_max_mod_sorted_sum_ElectricalHeater[i - 1], -P_max_mod_ElectricalHeater[i]);
        else
          P_set_mod_ElectricalHeater[i] = 0;
        end if;
      end if;
      P_set_ElectricalHeater[i] = P_set_decentral_ElectricalHeater[i] + P_set_mod_ElectricalHeater[i];
    end if;
  end for;
  // <=0            =        <=0
  P_total_PowerPlant = sum(P_set_PowerPlant);
  P_total_PowerPlant_is = if noEvent(sum(P_is_PowerPlant) > -1e-10) then 0 else sum(P_is_PowerPlant);
  P_total_PtG = if sum(P_is_PowerToGasPlant) < P_threshold_residual_PtG then 0 else sum(P_is_PowerToGasPlant);
  P_total_ElectricalStorage = sum(P_is_ElectricalStorage);
  P_total_ElectricalHeater = -sum(P_set_ElectricalHeater);
  P_total_RE = sum(P_renewable);
  P_total_RE_curtailed = P_total_RE - P_curtailment;
  if P_total_PowerPlant >= 0 then
    //     =      <0           +
    P_total = P_total_PowerPlant + P_total_PtG + P_total_ElectricalStorage + P_total_ElectricalHeater;
  else
    P_total = P_total_PowerPlant_is + P_total_PtG + P_total_ElectricalStorage + P_total_ElectricalHeater;
  end if;
  P_total_set = P_total_PowerPlant + P_total_PtG + P_total_ElectricalStorage + P_total_ElectricalHeater;
  P_total_is = homotopy(P_total_PowerPlant_is + P_total_PtG + P_total_ElectricalStorage + P_total_ElectricalHeater, P_total_set);

  P_excess = if noEvent(P_residual_total_with_SRL + P_total_set > -1e-4) then 0 else P_residual_total_with_SRL + P_total_set;
  P_curtailment = min(0, P_excess)*min(1, (time - startTime)/0.1);

  if useDecentralizedPowerControl then
    for i in 1:Region loop
      if noEvent(P_curtailment < 0) then
        if noEvent(P_residual_Region_decentralControl_potentialcurtailment[i] < 0 or P_excess_Region_PowerPlant[i] < 0) then
          P_curtailment_Region[i] = -(P_curtailment - sum(P_excess_Region_PowerPlant))*P_residual_Region_decentralControl_potentialcurtailment[i]/(sum(P_residual_Region_decentralControl_potentialcurtailment) + Modelica.Constants.eps) - P_excess_Region_PowerPlant[i];
        else
          P_curtailment_Region[i] = 0;
        end if;
      else
        P_curtailment_Region[i] = 0;
      end if;
    end for;
  else
    for i in 1:Region loop
      if noEvent(P_curtailment < 0) then
        if Region == 1 then
          P_curtailment_Region[i] = -max(P_renewable[i], P_curtailment);
        else
          P_curtailment_Region[i] = -max(P_renewable[i], P_curtailment + sum(P_curtailment_Region[1:i - 1]));
        end if;
      else
        P_curtailment_Region[i] = 0;
      end if;
    end for;
  end if;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(realExpression1.y, PI_SRL.u_s) annotation (Line(points={{-25,0},{-12,0}}, color={0,0,127}));
  connect(f_grid, PI_SRL.u_m) annotation (Line(points={{-40,120},{-40,20},{-60,20},{-60,-20},{0.1,-20},{0.1,-12}}, color={0,0,127}));
  annotation (
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is used for the control of the electrical power. Via the parameters <span style=\"font-family: Courier New;\">MeritOrderPositionPtG </span>etc. the merit order for the assignment of electrical surplus can be changed. A more detailed documentation can be find in the word document.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Oliver Sch&uuml;lting (oliver.schuelting@tuhh.de), Nov 2020</p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end ElectricalPowerController_inner;
