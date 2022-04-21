within TransiEnt;
model SimCenter "SimCenter for global parameters, ambient conditions and collecting statistics"



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

  extends ClaRa.SimCenter;
  extends TransiEnt.Basics.Icons.Grids;

  // _____________________________________________
  //
  //                   Components
  // _____________________________________________

  inner replaceable Components.Boundaries.Ambient.AmbientConditions ambientConditions constrainedby Components.Boundaries.Ambient.AmbientConditions "Click book icon, to edit" annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{-8,-8},{12,12}})),
    Dialog(tab="Ambience", group="Varying ambient conditions"));

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  // ===== General ====

  parameter Boolean isExpertmode = true "False, show only basic parameters and variables" annotation (choices(__Dymola_checkBox=true));
  parameter Real k_H2_fraction=0.10 "Fuel fraction of hydrogen mixed with natural gas in gas turbine (Q_flow_H2/Q_flow_methane)";
  parameter Boolean isLeapYear = false "true if the observed year is a leap year" annotation (choices(__Dymola_checkBox=true));
  final parameter Modelica.Units.SI.Time lengthOfAYear=if isLeapYear then 31622400 else 31536000 "Length of one year";

  // ===== Ambience ====
  parameter Modelica.Units.SI.Pressure p_amb_const=1.013e5 "Ambient pressure" annotation (Dialog(tab="Ambience", group="Ambience parameters"));//Hamburg average 2012 (DWD, monthly average data, 11m)
  parameter Modelica.Units.SI.Temperature T_amb_const=282.48 "Ambient temperature" annotation (Dialog(tab="Ambience", group="Ambience parameters"));//Hamburg average 2012 (DWD, monthly average data, 11m)
  parameter SI.Temperature T_ground = 282.48 "|Ambience|Ambience parameters|Ground temperature"; //same as T_amb_const in average
  parameter Boolean variable_T_ground = false "Use variable temperature profile"
                                                                                annotation (choicesAllMatching=true,Dialog(tab="Ambience",group="Ambience parameters"));
  replaceable model Ground_Temperature =
     TransiEnt.Basics.Tables.Ambient.UndergroundTemperature_Duesseldorf_1m_3600s_TMY  constrainedby TransiEnt.Components.Boundaries.Ambient.Base.PartialTemperature
                                               "Profile for the ground temperature" annotation (choicesAllMatching=true,Dialog(tab="Ambience",group="Ambience parameters"));
  Ground_Temperature Variable_Ground_Temperature;

  parameter Real lambda=10 "degree of longitude of location" annotation(Dialog(tab="Ambience", group="Location parameters"));
  parameter Real phi=53.63 "degree of latitude of location" annotation(Dialog(tab="Ambience", group="Location parameters"));
  parameter Real timezone=1 "timezone of location (UTC+) (for Hamburg timezone=1)" annotation(Dialog(tab="Ambience", group="Location parameters"));


  // ==== Media ===

  parameter SI.SpecificEnthalpy HeatingValue_natGas=40e6 "Heating value of natural gas"  annotation (Dialog(tab="Media and Materials", group="Constant heating values"),
   choices( choice=40e6 "Heating value of natural gas"));

  parameter SI.SpecificEnthalpy HeatingValue_LightOil=43e6 "Heating value of heating oil"  annotation (Dialog(tab="Media and Materials", group="Constant heating values"),
   choices( choice=43e6 "Upper heating value of heating oil",
            choice=42.8e6 "Lower heating valie of heating oil"));

  parameter Modelica.Units.SI.SpecificEnthalpy HeatingValue_Wood=17.03e6 "Heating value of wood pellets" annotation (Dialog(tab="Media and Materials", group="Constant heating values"), choices(choice=9.42e6 "Heating value of wood with a moisture content of 45%", choice=17.03e6 "Heating value of wood pellets with a moisture content of 10%"));



  // ==== Electric grid ====

  parameter Boolean integrateElPower=false "true if electric powers shall be integrated" annotation (Dialog(tab="Electric Grid", group="General"));
  parameter Modelica.Units.SI.Frequency f_n=50 annotation (Dialog(tab="Electric Grid", group="Nominal values (Top Level)"));
  parameter Modelica.Units.SI.Frequency delta_f_max=0.2 annotation (Dialog(tab="Electric Grid", group="Nominal values (Top Level)"));
  parameter Modelica.Units.SI.Frequency delta_f_deadband=0.01 annotation (Dialog(tab="Electric Grid", group="Nominal values (Top Level)"));
  parameter Modelica.Units.SI.Time t_SB_act=5*60 "Activation time for secondary balancing" annotation (Dialog(tab="Electric Grid", group="Nominal values (Top Level)"));
  parameter Modelica.Units.SI.Voltage v_n=110e3 annotation (Dialog(tab="Electric Grid", group="Nominal values (Top Level)"));
  parameter Modelica.Units.SI.Power P_n_low=150e9 "Nominal power of total grid at low-load" annotation (Dialog(tab="Electric Grid", group="Nominal values (Top Level)"));
  parameter Modelica.Units.SI.Power P_n_high=300e9 "Nominal power of total grid at high-load" annotation (Dialog(tab="Electric Grid", group="Nominal values (Top Level)"));
  parameter Modelica.Units.SI.Time T_grid=12 "Mechanical time constant of rotating masses in the grid" annotation (Dialog(tab="Electric Grid", group="Nominal values (Top Level)"));
  parameter Integer n_consumers=10 "Number of globaly parameterized consumers" annotation(Dialog(tab="Electric Grid", group="Optional"));
  parameter Modelica.Units.SI.ActivePower P_consumer[n_consumers]=zeros(n_consumers) "Globaly defined consumer data" annotation (Dialog(tab="Electric Grid", group="Optional"));

  replaceable TransiEnt.Grid.Electrical.Base.ExampleGenerationPark generationPark constrainedby TransiEnt.Grid.Electrical.Base.PartialGenerationPark "Properties of generaton park" annotation (Dialog(tab="Electric Grid", group="Optional"), choicesAllMatching=true);
  parameter Modelica.Units.SI.Power P_n_ref_1=generationPark.P_total "Reference power of subgrid 1, i.e. detailed grid  (for inertia constant calculation)" annotation (Dialog(tab="Electric Grid", group="Optional"));
  parameter Modelica.Units.SI.Power P_n_ref_2=P_n_high "Reference power of subgrid 2, i.e. surrounding grid  (for inertia constant calculation)" annotation (Dialog(tab="Electric Grid", group="Optional"));

  constant Integer iDetailedGrid = 1 "Index of detailed grid (convention)";
  constant Integer iSurroundingGrid = 2 "Index of detailed grid (convention)";
  parameter Modelica.Units.SI.Power P_peak_1=2.2e9 "Peak load of subgrid 1, i.e. detailed grid (used for stochastic grid error models)" annotation (Dialog(tab="Electric Grid", group="Optional"));
  parameter Modelica.Units.SI.Power P_peak_2=P_n_high "Peak load of subgrid 2, i.e. surrounding grid (used for stochastic grid error models)" annotation (Dialog(tab="Electric Grid", group="Optional"));
  //parameter Modelica.SIunits.Time T_A=5 "Time constant of all rotating masses" annotation (Dialog(tab="Electric Grid", group="Nominal values (Top Level)"));

  parameter Boolean use_reference_polar_wheel = false "If true, polar wheel angle is used as voltage angle refernce. Set true when using more than one frequency." annotation (Dialog(tab="Electric Grid", group="Optional"));

  parameter Boolean idealSuperstructLocalGrid = false "Enable to centralize ideal voltage control in each superstructure" annotation(Dialog(tab="Electric Grid", group="Optional"));
  parameter Real cosphi=1 "Reactive power factor"  annotation(Dialog(tab="Electric Grid", group="Optional"));

  //Modelica.SIunits.Frequency f_global(start=50) "global Frequency in the electric grid" annotation (Dialog(tab="Electric Grid", group="Nominal values (Top Level)"));

  // ==== District heating network ====


  parameter Boolean integrateHeatFlow=false "true if heat flows shall be integrated" annotation (Dialog(tab="District Heating Grid", group="General"));
  parameter Integer no_cells_per_pipe=3 "Number of discretisation cells per pipe" annotation (Dialog(tab="District Heating Grid", group="Nominal Values"));
  parameter SI.Power Q_flow_n=100e9 "Nominal transmitted power" annotation (Dialog(tab="District Heating Grid", group="Nominal Values"));
  parameter SI.Pressure p_nom[2]={6e5,8e5} "Nominal pressure levels"
                                                                   annotation (Dialog(tab="District Heating Grid", group="Nominal Values"));
  parameter SI.MassFlowRate m_flow_nom=30 "Nominal mass flow in grid" annotation (Dialog(tab="District Heating Grid", group="Nominal Values"));
  replaceable parameter TILMedia.VLEFluidTypes.TILMedia_SplineWater fluid1
   constrainedby TILMedia.VLEFluidTypes.BaseVLEFluid(final ID=1) "Medium name of working fluid in district heating grid" annotation(choicesAllMatching, Dialog(tab="District Heating Grid"));
  replaceable Basics.Tables.HeatGrid.HeatingCurves.ConstantSupplyTemperature heatingCurve constrainedby Basics.Tables.HeatGrid.HeatingCurves.PartialHeatingCurve "Heating curve defining supply and return water temperatures" annotation (Dialog(tab="District Heating Grid"), choicesAllMatching);
  replaceable parameter TILMedia.VLEFluidTypes.TILMedia_SplineWater refrigerantFluid1
   constrainedby TILMedia.VLEFluidTypes.BaseVLEFluid(final ID=1) "Medium name of working fluid for refrigerant based cycles, e.g. heat pumps"
                                                                                              annotation(choicesAllMatching, Dialog(tab="District Heating Grid"));
  // == DHN - PlugFlow specific parameters ==:
  parameter Integer activate_consumer_pipes= 0 "Activate / Deactivate house pipes for faster simulation. 1 = house pipes activated | Only used in GridConstructors" annotation (Dialog(tab="District Heating Grid", group="Simulation"));
  parameter Boolean activate_volumes= false "Activate / Deactivate volumes to better represent delayed temperatrue changes due to heat capacity effects" annotation (Dialog(tab="District Heating Grid", group="Simulation"));
  parameter Boolean calc_initial_dstrb = true "Activates the calculation of a initial temperature distribution inside the pipes" annotation (Dialog(tab="District Heating Grid", group="Simulation"));

  parameter SI.Temperature T_supply= 90 + 273.15 "Temperature of the fluid at start in supply"
                                                                                              annotation (Dialog(tab="District Heating Grid", group="Initialisation"));
  parameter SI.Temperature T_return= 70 + 273.15 "Temperature of the fluid at start in return"
                                                                                              annotation (Dialog(tab="District Heating Grid", group="Initialisation"));
  parameter Real dT = 20 "Target temperature difference"
                                                        annotation (Dialog(tab="District Heating Grid", group="Operation"));
  parameter SI.MassFlowRate m_flow_min = 0.0001 "Minimum mass flow rate in substations"
                                                                                       annotation (Dialog(tab="District Heating Grid", group="Operation"));
  parameter SI.Velocity v_nom = 1 "Design Velocity of the pipes used."
                                                                      annotation (Dialog(tab="District Heating Grid", group="Operation"));
  parameter SI.ThermalConductivity lambda_ground = 1.2 "Heat-Transfer Coefficient of the ground surrounding the pipes" annotation (Dialog(tab="District Heating Grid", group="Pipe Data"));
  parameter SI.Length K = 0.000045 "average height of surface asperities" annotation (Dialog(tab="District Heating Grid", group="Pipe Data"));
  parameter SI.SpecificHeatCapacity pipe_wall_capacity = 450 "HeatCapacity of the pipe wall material" annotation (Dialog(tab="District Heating Grid", group="Pipe Data"));
  parameter SI.Density pipe_wall_d = 7850 "Density of the pipe wall material" annotation (Dialog(tab="District Heating Grid", group="Pipe Data"));

  replaceable model DHN_Pipe_Manufacturer = TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Base.DHN_Pipes.DN_IsoPlus
    constrainedby TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Base.DHN_Pipes.DN_table_base
                                                                                                "Type of DN-Data to be used" annotation(choicesAllMatching=true,Dialog(tab="District Heating Grid", group="Pipe Data"));
 final parameter Real DNmat[:,:] = DHN_Pipe_Manufacturer.DNmat;

  // ==== Gas grid ====

  replaceable parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_SRK_var gasModel1 constrainedby TILMedia.VLEFluidTypes.BaseVLEFluid "Medium name of real gas model" annotation (Dialog(tab="Media and Materials", group="TransiEnt-based models: Gas Grid"), choicesAllMatching);
  replaceable parameter TransiEnt.Basics.Media.Gases.Gas_VDIWA_NG7_H2_var gasModel2 constrainedby TILMedia.GasTypes.BaseGas "Medium name of ideal gas model" annotation (Dialog(tab="Media and Materials", group="TransiEnt-based models: Gas Grid"), choicesAllMatching);
  replaceable parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel3 constrainedby TILMedia.VLEFluidTypes.BaseVLEFluid "Medium name of real gas model" annotation (Dialog(tab="Media and Materials", group="TransiEnt-based models: Gas Grid"), choicesAllMatching);
  replaceable parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var gasModel4 constrainedby TILMedia.VLEFluidTypes.BaseVLEFluid "Medium name of real gas model" annotation (Dialog(tab="Media and Materials", group="TransiEnt-based models: Gas Grid"), choicesAllMatching);
  replaceable parameter TransiEnt.Basics.Media.Gases.Gas_ExhaustGas exhaustGasModel constrainedby TILMedia.GasTypes.BaseGas "Medium name of ideal exhaust gas model" annotation (Dialog(tab="Media and Materials", group="TransiEnt-based models: Gas Grid"), choicesAllMatching);

  //replaceable parameter TransiEnt.Producer.Combined.CHPPackage.Records.ExhaustGas_VLEType exhaustVLEModel
  // constrainedby TILMedia.VLEFluidTypes.BaseVLEFluid "Medium name of real exhaust gas model" annotation(Dialog(tab="Media and Materials", group="TransiEnt-based models: Gas Grid"),choicesAllMatching);

  parameter Modelica.Units.SI.Pressure p_eff_1=25e2 "|Gas Grid|Nominal Values|Effective gauge pressure at distribution level";
  parameter SI.Pressure p_eff_2=16e5 "|Gas Grid|Nominal Values|Effective gauge pressure at distribution level";
  parameter SI.Pressure p_eff_3=25e5 "|Gas Grid|Nominal Values|Effective gauge pressure at distribution level";

  parameter SI.VolumeFraction phi_H2max=0.1 "|Gas Grid|Parameters|Maximum admissible volume fraction of H2 in NGH2 at STP";
  parameter Real f_gasDemand=2.7097280217 "|Gas Grid|Parameters|Scaling factor gas demand"; //3.0104424893;//

  parameter Boolean useConstCompInGasComp=false "true if equations for constant gas composition should be used in gas components" annotation (Dialog(tab="Gas Grid", group="Parameters"));
  parameter Integer initOptionGasPipes=0 "Type of initialization" annotation (Dialog(tab="Gas Grid", group="Parameters"), choices(
      choice=0 "Use guess values",
      choice=208 "Steady pressure and enthalpy",
      choice=201 "Steady pressure",
      choice=202 "Steady enthalpy",
      choice=210 "Steady density"));
  parameter Integer massBalanceGasPipes=1 "Mass balance and species balance fomulation" annotation (Dialog(tab="Gas Grid", group="Parameters"), choices(
      choice=1 "ClaRa formulation",
      choice=2 "TransiEnt formulation 1a",
      choice=3 "TransiEnt formulation 1b"));
  parameter Integer variableCompositionEntriesGasPipes[:](min=0)={0} "Entries of medium vector in gas pipes which are supposed to be completely variable" annotation(Dialog(tab="Gas Grid",group="Parameters",enable=not useConstCompInGasComp));

  parameter SI.Height roughnessGasPipes=0.1e-3 "Absolute roughness of gas pipes" annotation (Dialog(tab="Gas Grid", group="Parameters"));

  // ===== Expert Settings ====

  parameter Real Td = 1e-3 "Time constant of derivative calculation" annotation (Dialog(tab="Expert Settings", group="Numerical Properties"));
  parameter Boolean useThresh = false "Use threshold in gradient limiters" annotation (Dialog(tab="Expert Settings", group="Numerical Properties"));
  parameter Real thres = 1e-7 "If abs(u-y)< thres, y becomes a simple pass through of u. Increasing thres can improve simulation speed. However to large values can make the simulation unstable. 
     A good starting point is the choice thres = tolerance/1000." annotation (Dialog(tab="Expert Settings", group="Numerical Properties"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_small(min=0) = 1e-2 "Default small mass flow rate for regularization of laminar and zero flow" annotation (Dialog(tab="Expert Settings", group="Numerical Properties"));

  parameter Modelica.Units.SI.Pressure p_small(min=0) = 1e3 "Default small pressure e.g. used for error handling in compressors" annotation (Dialog(tab="Expert Settings", group="Numerical Properties"));

  parameter Modelica.Units.SI.Velocity v_wind_small(min=0) = 0.1 "Default small wind velocity for startup of wind turbines (neglectable wind power)" annotation (Dialog(tab="Expert Settings", group="Numerical Properties"));

  // ==== Table Interpolation ====

  parameter Modelica.Blocks.Types.Smoothness tableInterpolationSmoothness=Modelica.Blocks.Types.Smoothness.LinearSegments "Smoothness of table interpolation"
      annotation(Dialog(tab="Expert Settings", group="table data interpretation"));

  parameter Modelica.Units.SI.Power P_el_small=1 "Small power flow considered as zero" annotation (Dialog(tab="Expert Settings", group="Singularities"));
  parameter Modelica.Units.SI.Energy E_small=3600 "Small energy quantity, considered as zero" annotation (Dialog(tab="Expert Settings", group="Singularities"));
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_small=1 "Small power flow considered as zero" annotation (Dialog(tab="Expert Settings", group="Singularities"));

  // ==== Economics and Emissions ====

  // Parameter table with economics and emissions-related assumptions
  parameter Boolean calculateCost=false "true if cost shall be calculated"  annotation (Dialog(tab="Costs", group="General"));
  parameter Real InterestRate=0.07 "Interest Rate in percent"  annotation (Dialog(tab="Costs", group="Annuity Inputs"));
  parameter Real priceChangeRateInv=0 "Price change rate of the invest cost" annotation (Dialog(tab="Costs", group="Annuity Inputs"));
  parameter Real priceChangeRateDemand=0 "Price change rate of the demand-related cost" annotation (Dialog(tab="Costs", group="Annuity Inputs"));
  parameter Real priceChangeRateOM=0 "Price change rate of the operation-related cost" annotation (Dialog(tab="Costs", group="Annuity Inputs"));
  parameter Real priceChangeRateOther=0 "Price change rate of other cost" annotation (Dialog(tab="Costs", group="Annuity Inputs"));
  parameter Real priceChangeRateRevenue=0 "Price change rate of the revenue" annotation (Dialog(tab="Costs", group="Annuity Inputs"));
  parameter Real Duration=20 "in Years, observation period for cost calculation"  annotation (Dialog(tab="Costs", group="Annuity Inputs"));
  parameter Real C_CO2 = 6e-3 "EUR/kg" annotation (Dialog(tab="Costs", group="CO2 certificates"));

  //Costs Hard Coal fired power Plant
  parameter TransiEnt.Basics.Units.MonetaryUnitPerPower Cinv_HardCoal(displayUnit="EUR/W") = 1.500 annotation (Dialog(tab="Costs", group="Investment costs in EUR/W"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerPower CfixOM_HardCoal(displayUnit="EUR/W") = 0.0225 annotation (Dialog(tab="Costs", group="Fix O&M costs in EUR/W"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cvar_HardCoal(displayUnit="EUR/J") = 1.3/3.6e9 annotation (Dialog(tab="Costs", group="Variable costs in EUR/J_el"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cfue_HardCoal(displayUnit="EUR/J") = 10.19/3.6e9 annotation (Dialog(tab="Costs", group="Fuel costs in EUR/J_fuel"));
  parameter TransiEnt.Basics.Units.Time_year lifeTime_HardCoal=30 annotation (Dialog(tab="Costs", group="Plant life for annuitiy"));

  //Costs Brown Coal fired power Plant
  parameter TransiEnt.Basics.Units.MonetaryUnitPerPower Cinv_BrownCoal(displayUnit="EUR/W") = 1.600 annotation (Dialog(tab="Costs", group="Investment costs in EUR/W"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerPower CfixOM_BrownCoal(displayUnit="EUR/W") = 0.0256 annotation (Dialog(tab="Costs", group="Fix O&M costs in EUR/W"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cvar_BrownCoal(displayUnit="EUR/J") = 1.65/3.6e9 annotation (Dialog(tab="Costs", group="Variable costs in EUR/J_el"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cfue_BrownCoal(displayUnit="EUR/J") = 5.4/3.6e9 annotation (Dialog(tab="Costs", group="Fuel costs in EUR/J_fuel"));
  parameter TransiEnt.Basics.Units.Time_year lifeTime_BrownCoal=30 annotation (Dialog(tab="Costs", group="Plant life for annuitiy"));

  //Costs GuD
  parameter TransiEnt.Basics.Units.MonetaryUnitPerPower Cinv_GasCCGT(displayUnit="EUR/W") = 0.650 annotation (Dialog(tab="Costs", group="Investment costs in EUR/W"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerPower CfixOM_GasCCGT(displayUnit="EUR/W") = 0.0046 annotation (Dialog(tab="Costs", group="Fix O&M costs in EUR/W"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cvar_GasCCGT(displayUnit="EUR/J") = 3.5/3.6e9 annotation (Dialog(tab="Costs", group="Variable costs in EUR/J_el"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cfue_GasCCGT(displayUnit="EUR/J") = 25/3.6e9 annotation (Dialog(tab="Costs", group="Fuel costs in EUR/J_fuel"));
  parameter TransiEnt.Basics.Units.Time_year lifeTime_GasCCGT=20 annotation (Dialog(tab="Costs", group="Plant life for annuitiy"));

  //Costs Gas Turbine
  parameter TransiEnt.Basics.Units.MonetaryUnitPerPower Cinv_GT(displayUnit="EUR/W") = 0.500 annotation (Dialog(tab="Costs", group="Investment costs in EUR/W"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerPower CfixOM_GT(displayUnit="EUR/W") = 0.0025 annotation (Dialog(tab="Costs", group="Fix O&M costs in EUR/W"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cvar_GT(displayUnit="EUR/J") = 5/3.6e9 annotation (Dialog(tab="Costs", group="Variable costs in EUR/J_el"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cfue_GT(displayUnit="EUR/J") = 25/3.6e9 annotation (Dialog(tab="Costs", group="Fuel costs in EUR/J_fuel"));
  parameter TransiEnt.Basics.Units.Time_year lifeTime_GT=20 annotation (Dialog(tab="Costs", group="Plant life for annuitiy"));

  //Costs Wind Onshore Power Plant
  parameter TransiEnt.Basics.Units.MonetaryUnitPerPower Cinv_Wind_On(displayUnit="EUR/W") = 1.170 annotation (Dialog(tab="Costs", group="Investment costs in EUR/W"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerPower CfixOM_Wind_On(displayUnit="EUR/W") = 0 annotation (Dialog(tab="Costs", group="Fix O&M costs in EUR/W"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cvar_Wind_On(displayUnit="EUR/J") = 18/3.6e9 annotation (Dialog(tab="Costs", group="Variable costs in EUR/J_el"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cfue_Wind_On(displayUnit="EUR/J") = 0 annotation (Dialog(tab="Costs", group="Fuel costs in EUR/J_fuel"));
  parameter TransiEnt.Basics.Units.Time_year lifeTime_Wind_On=20 annotation (Dialog(tab="Costs", group="Plant life for annuitiy"));

  //Costs Wind Offshore Power Plant
  parameter TransiEnt.Basics.Units.MonetaryUnitPerPower Cinv_Wind_Off(displayUnit="EUR/W") = 3.000 annotation (Dialog(tab="Costs", group="Investment costs in EUR/W"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerPower CfixOM_Wind_Off(displayUnit="EUR/W") = 0 annotation (Dialog(tab="Costs", group="Fix O&M costs in EUR/W"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cvar_Wind_Off(displayUnit="EUR/J") = 35/3.6e9 annotation (Dialog(tab="Costs", group="Variable costs in EUR/J_el"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cfue_Wind_Off(displayUnit="EUR/J") = 0 annotation (Dialog(tab="Costs", group="Fuel costs in EUR/J_fuel"));
  parameter TransiEnt.Basics.Units.Time_year lifeTime_Wind_Off=20 annotation (Dialog(tab="Costs", group="Plant life for annuitiy"));

  //Costs PV Power Plant
  parameter TransiEnt.Basics.Units.MonetaryUnitPerPower Cinv_PV(displayUnit="EUR/W") = 1.300 annotation (Dialog(tab="Costs", group="Investment costs in EUR/W"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerPower CfixOM_PV(displayUnit="EUR/W") = 0.035 annotation (Dialog(tab="Costs", group="Fix O&M costs in EUR/W"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cvar_PV(displayUnit="EUR/J") = 0 annotation (Dialog(tab="Costs", group="Variable costs in EUR/J_el"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cfue_PV(displayUnit="EUR/J") = 0 annotation (Dialog(tab="Costs", group="Fuel costs in EUR/J_fuel"));
  parameter TransiEnt.Basics.Units.Time_year lifeTime_PV=20 annotation (Dialog(tab="Costs", group="Plant life for annuitiy"));

  //Costs Central Gas Boiler
  parameter TransiEnt.Basics.Units.MonetaryUnitPerPower Cinv_GasBoiler(displayUnit="EUR/W") = 0.24 annotation (Dialog(tab="Costs", group="Investment costs in EUR/W"));
                                                                                                                                                                      //Haferweg: .  https://www.dtad.de/details/Neubau_eines_Heizwerkes_40_Mio_Euro_22769_Hamburg-8065848_10
  parameter TransiEnt.Basics.Units.MonetaryUnitPerPower CfixOM_GasBoiler(displayUnit="EUR/W") = 0.0046 annotation (Dialog(tab="Costs", group="Fix O&M costs in EUR/W"));//idem GuD (temporal solution)
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cvar_GasBoiler(displayUnit="EUR/J") = 0 annotation (Dialog(tab="Costs", group="Variable costs in EUR/J_th"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cfue_GasBoiler(displayUnit="EUR/J") = 25/3.6e9 annotation (Dialog(tab="Costs", group="Fuel costs in EUR/J_fuel"));
  parameter TransiEnt.Basics.Units.Time_year lifeTime_GasBoiler=20 annotation (Dialog(tab="Costs", group="Plant life for annuitiy"));

  //Costs Central Garbage Boiler
  parameter TransiEnt.Basics.Units.MonetaryUnitPerPower Cinv_GarbageBoiler(displayUnit="EUR/W") = 0.24 annotation (Dialog(tab="Costs", group="Investment costs in EUR/W"));
                                                                                                                                                                          //idem Haferweg (temporal solution): .  https://www.dtad.de/details/Neubau_eines_Heizwerkes_40_Mio_Euro_22769_Hamburg-8065848_10
  parameter TransiEnt.Basics.Units.MonetaryUnitPerPower CfixOM_GarbageBoiler(displayUnit="EUR/W") = 0.0046 annotation (Dialog(tab="Costs", group="Fix O&M costs in EUR/W"));//idem GuD (temporal solution)
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cvar_GarbageBoiler(displayUnit="EUR/J") = 0 annotation (Dialog(tab="Costs", group="Variable costs in EUR/J_th"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cfue_GarbageBoiler(displayUnit="EUR/J") = 0 annotation (Dialog(tab="Costs", group="Fuel costs in EUR/J_fuel"));
                                                                                                                                                                       //Supposing that the city does not pay for the burned garbage
  parameter TransiEnt.Basics.Units.Time_year lifeTime_GarbageBoiler=30 annotation (Dialog(tab="Costs", group="Plant life for annuitiy"));

  //Costs Nuclear Power Plant; Source: Panos Konstantin: Praxisbuch Energiewirtschaft - ISBN:978-3-642-37264-3
  parameter TransiEnt.Basics.Units.MonetaryUnitPerPower Cinv_Nuclear(displayUnit="EUR/W") = 5.15 annotation (Dialog(tab="Costs", group="Investment costs in EUR/W"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerPower CfixOM_Nuclear(displayUnit="EUR/W") = 0 annotation (Dialog(tab="Costs", group="Fix O&M costs in EUR/W"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cvar_Nuclear(displayUnit="EUR/J") = 19.92/3.6e9 annotation (Dialog(tab="Costs", group="Variable costs in EUR/J_el"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cfue_Nuclear(displayUnit="EUR/J") = 11.3/3.6e9 annotation (Dialog(tab="Costs", group="Fuel costs in EUR/J_fuel"));
  parameter TransiEnt.Basics.Units.Time_year lifeTime_Nuclear=30 annotation (Dialog(tab="Costs", group="Plant life for annuitiy"));

  //Costs generic Biomass unit
  parameter TransiEnt.Basics.Units.MonetaryUnitPerPower Cinv_Biomass(displayUnit="EUR/W") = 2.5 annotation (Dialog(tab="Costs", group="Investment costs in EUR/W"));
                                                                                                                                                                   //P.Konstantin, 2013. pp. 419
  parameter TransiEnt.Basics.Units.MonetaryUnitPerPower CfixOM_Biomass(displayUnit="EUR/W") = 0.0046 annotation (Dialog(tab="Costs", group="Fix O&M costs in EUR/W"));//idem GuD (temporal solution)
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cvar_Biomass(displayUnit="EUR/J") = 19.92/3.6e9 annotation (Dialog(tab="Costs", group="Variable costs in EUR/J_el"));
                                                                                                                                                                             //idem GuD (temporal solution)
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cfue_Biomass(displayUnit="EUR/J") = 3.8/3.6e9 annotation (Dialog(tab="Costs", group="Fuel costs in EUR/J_fuel"));
                                                                                                                                                                         //P.Konstantin, 2013. pp. 419
  parameter TransiEnt.Basics.Units.Time_year lifeTime_Biomass=20 annotation (Dialog(tab="Costs", group="Plant life for annuitiy"));

  //Costs Cavern
  parameter TransiEnt.Basics.Units.Time_year lifeTime_Cavern=100 annotation (Dialog(tab="Costs", group="Plant life for annuitiy"));
  parameter TransiEnt.Basics.Units.Time_year lifeTime_Electrolyzer=20 annotation (Dialog(tab="Costs", group="Plant life for annuitiy"));
  //Costs Oil
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cfue_Oil(displayUnit="EUR/J") = 45*1/159*1/36e6 annotation (Dialog(tab="Costs", group="Fuel costs in EUR/J_fuel"));
                                                                                                                                                                            //X [EUR/barrel]*1/159[barrel/liter]*1/36[liter/MJ]*3.6e9[J/MWh]

  //Costs pipelines in EUR/m
  parameter Real Cinv_DHN_pipe(displayUnit="EUR/m")=3000 annotation (Dialog(tab="Costs", group="Specific pipeline costs in EUR/m")); //EUR/m, DN700, KRM. includes material, mounting and civil engineering (Source: [1]MVV Energie AG: Wärmetransport im Wettbewerb zu dislozierter Wärmeerzeugung, 2013)
  parameter Real Cinv_H2_pipe(displayUnit="EUR/m")=300 annotation (Dialog(tab="Costs", group="Specific pipeline costs in EUR/m"));   //EUR/m,DN100, Includes material and mounting costs. (Source: [1]Krieg, Dennis: Konzept und Kosten eines Pipelinesystems zur Versorgung des deutschen Straßenverkehrs mit Wasserstoff, 2010 — ISBN 9783893368006)

  //Fuel specific Emissions, excluding supply chain related emissions (Source: FfE 2010, Basisdaten von Energietraegern. https://www.ffe.de/download/wissen/186_Basisdaten_Energietraeger/Basisdaten_von_Energietraegern_2010.pdf. page 3)
  parameter Boolean integrateCDE=false "true if CDE should be integrated" annotation (Dialog(tab="Emissions", group="General Settings"));
  parameter TransiEnt.Basics.Units.MassOfCDEperEnergy FuelSpecEmis_BrownCoal=403/3.6e9 annotation (Dialog(tab="Emissions", group="Fuel specific CO2 emissions in kg/J (Source: FfE 2010)"));
  parameter TransiEnt.Basics.Units.MassOfCDEperEnergy FuelSpecEmis_HardCoal=337/3.6e9 annotation (Dialog(tab="Emissions", group="Fuel specific CO2 emissions in kg/J (Source: FfE 2010)"));
  parameter TransiEnt.Basics.Units.MassOfCDEperEnergy FuelSpecEmis_NaturalGas=202/3.6e9 annotation (Dialog(tab="Emissions", group="Fuel specific CO2 emissions in kg/J (Source: FfE 2010)"));
  parameter TransiEnt.Basics.Units.MassOfCDEperEnergy FuelSpecEmis_LightFuelOil=266/3.6e9 annotation (Dialog(tab="Emissions", group="Fuel specific CO2 emissions in kg/J (Source: FfE 2010)"));
  parameter TransiEnt.Basics.Units.MassOfCDEperEnergy FuelSpecEmis_HeavyFuelOil=281/3.6e9 annotation (Dialog(tab="Emissions", group="Fuel specific CO2 emissions in kg/J (Source: FfE 2010)"));
  parameter TransiEnt.Basics.Units.MassOfCDEperEnergy FuelSpecEmis_Nuclear=0/3.6e9 annotation (Dialog(tab="Emissions", group="Fuel specific CO2 emissions in kg/J (Source: FfE 2010)"));
  parameter TransiEnt.Basics.Units.MassOfCDEperEnergy FuelSpecEmis_Biomass=0/3.6e9 annotation (Dialog(tab="Emissions", group="Fuel specific CO2 emissions in kg/J (Source: FfE 2010)"));       //because CO2 produced during production is captured again by plant growth
  parameter TransiEnt.Basics.Units.MassOfCDEperEnergy FuelSpecEmis_Garbage=162/3.6e9 annotation (Dialog(tab="Emissions", group="Fuel specific CO2 emissions in kg/J (Source: FfE 2010)"));
  parameter TransiEnt.Basics.Units.MassOfCDEperEnergy FuelSpecEmis_Diesel=266/3.6e9 annotation (Dialog(tab="Emissions", group="Fuel specific CO2 emissions in kg/J (Source: FfE 2010)"));

  parameter TransiEnt.Basics.Units.MassOfCDEperEnergy FuelSpecEmis_WindOnshore=0/3.6e9 annotation (Dialog(tab="Emissions", group="Fuel specific CO2 emissions in kg/J (Source: FfE 2010)"));
  parameter TransiEnt.Basics.Units.MassOfCDEperEnergy FuelSpecEmis_WindOffshore=0/3.6e9 annotation (Dialog(tab="Emissions", group="Fuel specific CO2 emissions in kg/J (Source: FfE 2010)"));
  parameter TransiEnt.Basics.Units.MassOfCDEperEnergy FuelSpecEmis_Photovoltaic=0/3.6e9 annotation (Dialog(tab="Emissions", group="Fuel specific CO2 emissions in kg/J (Source: FfE 2010)"));
  parameter TransiEnt.Basics.Units.MassOfCDEperEnergy FuelSpecEmis_Hydro=0/3.6e9 annotation (Dialog(tab="Emissions", group="Fuel specific CO2 emissions in kg/J (Source: FfE 2010)"));

  // //Subsidies, Feed in Tariffs and selling prices

  //CHP subsidy, Sources: BDEW, 2013 "Umsetzungshilfe zum KWKG";
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy CHPelectricityLarger20_new(displayUnit="EUR/J") = 28/3.6e9 "CHP subisidy for new plants over 2 MWe, in EUR/J" annotation (Dialog(tab="PricesAndSubsidies", group="KWKG"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy CHPelectricityLarger20_old(displayUnit="EUR/J") = 18/3.6e9 "CHP subisidy for old plants over 2 MWe, in EUR/J" annotation (Dialog(tab="PricesAndSubsidies", group="KWKG"));

  //FIT RE, Source: BDEW, "Erneuerbare Energien und das EEG 2014"
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy FIT_Wind_On(displayUnit="EUR/J") = 91.6/3.6e9 "Average wind onshore feed in tariff in EUR/J" annotation (Dialog(tab="PricesAndSubsidies", group="EEG"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy FIT_Wind_Off(displayUnit="EUR/J") = 152.6/3.6e9 "Average wind onshore feed in tariff in EUR/J" annotation (Dialog(tab="PricesAndSubsidies", group="EEG"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy FIT_PV(displayUnit="EUR/J") = 365.3/3.6e9 "Average photovoltaic feed in tariff in EUR/J" annotation (Dialog(tab="PricesAndSubsidies", group="EEG"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy FIT_Biomass(displayUnit="EUR/J") = 200.1/3.6e9 "Average biomass feed in tariff in EUR/J" annotation (Dialog(tab="PricesAndSubsidies", group="EEG"));

  //Selling prices in EUR/J
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy sellPriceElEnergy(displayUnit="EUR/J") = 210/3.6e9 "EUR/J_el" annotation (Dialog(tab="PricesAndSubsidies", group="Sale prices"));
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy sellPriceDHNHeat(displayUnit="EUR/J") = 81/3.6e9 "EUR/J_th" annotation (Dialog(tab="PricesAndSubsidies", group="Sale prices"));
                                                                                                                                                                                       //Source: Bundeskartellamt, 2012: Sektoruntersuchung Fernwärme
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy PhelixBaseYearFuture(displayUnit="EUR/J") = 29/3.6e9 "EUR/J_el" annotation (Dialog(tab="PricesAndSubsidies", group="Sale prices"));

                                                                                                                                                                                           //Source: https://www.eex.com/en/market-data/power/futures/phelix-futures oder http://www.finanzen.net/rohstoffe/eex-strom-phelix-baseload-year-future
  //Electricity selling prices time series in EUR/kWh
  replaceable TransiEnt.Basics.Tables.ElectricGrid.ElectricityPrices.SpotPriceElectricity_Phelix_DayAhead_3600s_2011 electricityPrice constrainedby TransiEnt.Basics.Tables.ElectricGrid.ElectricityPrices.GenericElectricityPriceTable "Electricity market prices in EUR per kWh" annotation (Dialog(tab="PricesAndSubsidies"), choicesAllMatching);


  //Demand-related cost
  //Free Energy
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_free=0 "Free energy" annotation (Dialog(tab="PricesAndSubsidies", group="Demand-related costs"));
  //Electricity
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_el_70_150_GWh=103.3/3.6e9 "Second half of 2014 for electricity usage of 70-150 GWh/a from Eurostat http://ec.europa.eu/eurostat/web/energy/data/database" annotation (Dialog(tab="PricesAndSubsidies", group="Demand-related costs"));
  //Heat

  //Gas and Fuel
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_gas_diesel=0.8365/(0.840*43e6) "(=83.37 EUR/MWh) 0.8365 EUR/l_diesel in 2016 (Statistisches Bundesamt https://www.destatis.de/DE/Publikationen/Thematisch/Preise/Energiepreise/EnergiepreisentwicklungPDF_5619001.pdf?__blob=publicationFile), calorific value 43 MJ/kg, density 0.840 kg/l (Forschungsstelle fuer Energiewirtschaft e.V., 2010. Basisdaten zur Bereitstellung elektrischer Energie)" annotation (Dialog(tab="PricesAndSubsidies", group="Demand-related costs"));
  //Other
  parameter Real Cspec_demAndRev_other_free=0 "Free other resource" annotation (Dialog(tab="PricesAndSubsidies", group="Demand-related costs"));
  parameter Real Cspec_demAndRev_other_water=0.00185 "EUR/m3 water, 1000kg/m3, including taxes, without waste water cost, https://www.hamburgwasser.de/privatkunden/service/gebuehren-abgaben-preise/" annotation (Dialog(tab="PricesAndSubsidies", group="Demand-related costs"));

  // _____________________________________________
  //
  //             Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.General.TemperatureCelsiusOut T_amb_var=ambientConditions.temperature.value "Temperature in degC (from component ambientConditions)";
  TransiEnt.Basics.Interfaces.Ambient.VelocityOut v_wind=ambientConditions.wind.value "Wind speed (from component ambientConditions)";
  TransiEnt.Basics.Interfaces.Ambient.IrradianceOut i_global=ambientConditions.globalSolarRadiation.value "Global solar radiation (from component ambientConditions)";
  TransiEnt.Basics.Interfaces.Ambient.IrradianceOut i_direct=ambientConditions.directSolarRadiation.value "Direct solar radiation (from component ambientConditions)";
  TransiEnt.Basics.Interfaces.Ambient.IrradianceOut i_diffuse=ambientConditions.diffuseSolarRadiation.value "Diffuse solar radiation (from component ambientConditions)";
  Modelica.Blocks.Interfaces.RealOutput T_ground_var(value=if variable_T_ground then Variable_Ground_Temperature.value else T_ground)  "Diffuse solar radiation (from component ambientConditions)";

   annotation ( defaultComponentName="simCenter",
    defaultComponentPrefixes="inner",
    missingInnerMessage=
        "Your model is using an outer \"simCenter\" but it does not contain an inner \"simCenter\" component. Drag model TransiEnt.SimCenter into your model to make it work.", Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    Documentation(info="<html>
<h4><span style=\"color:#008000\">1. Purpose of model</span></h4>
<p>Global parameters for all models depending TransiEnt core library and Clara library.</p>
<h4><span style=\"color:#008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color:#008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color:#008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color:#008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color:#008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color:#008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color:#008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color:#008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color:#008000\">10. Version History</span></h4>
<p>Model created by Lisa Andresen (andresen@tuhh.de) on Mon Aug 18 2014</p>
</html>"));
end SimCenter;
