within TransiEnt.Examples.Heat;
model ElectricThermalEnergyStorage



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
  //          Internal Model Declaration
  // _____________________________________________


inner model GeneralParameter "Model to contain repeatedly used air cycle parameters"
  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________
  extends ClaRa.Basics.Icons.RecordIcon;
  import SI = ClaRa.Basics.Units;
  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________
  parameter SI.Length t_insulation_pipes_cold = 0.2 "Isolation Thickness of pipes for cold air";
  parameter SI.Length t_insulation_pipes_hot = 0.2 "Isolation Thickness of pipes for hot air";
  parameter SI.Length t_wall_pipes = 0.005 "pipe wall thickness";
  parameter SI.MassFlowRate m_flow_air_nom = 10 "nominal air massflow";
  parameter SI.Temperature T_air_cold_nom = 273.15+350 "Nominal Temperature for cold side of air system";
  parameter SI.Temperature T_air_hot_nom = 273.15+750 "Nominal Temperature for hot side of air system";
end GeneralParameter;


model Summary "Model for performance evaluation"

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends ClaRa.Basics.Icons.RecordIcon;
  import SI = ClaRa.Basics.Units;


  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Real HeatEngineEfficiency = 0.4 "Factor to multiply with electric fan demand during discharge for account for less energy quality of heat compared to el. power";
  parameter Boolean P2H2PCase = true "True for Re-electrification (penalty for power consumption during discharge only in this case)";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  input SI.HeatFlowRate Q_flow_loss_system "transmission heat loss of air system" annotation (Dialog(group="Variables"));
  input SI.HeatFlowRate E_flow_loss_air2environment "convective heat loss of air system" annotation (Dialog(group="Variables"));
  input SI.Power P_loss_conv_fan "Conversion loss at fan" annotation (Dialog(group="Variables"));
  input SI.Power P_loss_conv_heater "Conversion loss at heater" annotation (Dialog(group="Variables"));
  input SI.Power P_loss_standby "Standby loss" annotation (Dialog(group="Variables"));
  input SI.HeatFlowRate E_flow_loss_hrsg "additional loss in hrsg via blow down" annotation (Dialog(group="Variables"));
  input SI.Power Q_flow_boiler "transferred heat in HRSG" annotation (Dialog(group="Variables"));
  input SI.Energy U_theo "Theoretical Thermal Storage Capacity" annotation (Dialog(group="Variables"));
  input SI.Energy U_start "Initial Thermal Storage Capacity" annotation (Dialog(group="Variables"));
  input SI.Power P_el "ETES electrical power" annotation (Dialog(group="Variables"));
  input Real charge "Operation Mode Charge" annotation (Dialog(group="Variables"),HideResult = true);
  input Real discharge "Operation Mode Disharge" annotation (Dialog(group="Variables"),HideResult = true);
  input Real hold "Operation Mode Hold" annotation (Dialog(group="Variables"),HideResult = true);

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.Energy W_el_c(final start = 0,fixed = true, stateSelect=StateSelect.never);
  SI.Energy W_el_d(final start = 0,fixed = true, stateSelect=StateSelect.never);
  SI.Energy W_el_h(final start = 0,fixed = true, stateSelect=StateSelect.never);
  SI.Energy W_el(final start = 0,fixed = true, stateSelect=StateSelect.never);

  SI.Energy Q_boiler(final start = 0,fixed = true, stateSelect=StateSelect.never);
  SI.Energy Q_boiler_d(final start = 0,fixed = true, stateSelect=StateSelect.never);

  SI.Energy Q_loss_system(final start = 0,fixed = true, stateSelect=StateSelect.never);
  SI.Energy E_loss_air2environment(final start = 0,fixed = true, stateSelect=StateSelect.never);
  SI.Energy E_loss_conv_fan( final start = 0,fixed = true, stateSelect=StateSelect.never);
  SI.Energy E_loss_conv_heater( final start = 0,fixed = true, stateSelect=StateSelect.never);
  SI.Energy E_loss_standby( final start = 0,fixed = true, stateSelect=StateSelect.never);
  SI.Energy E_loss_hrsg(final start = 0,fixed = true, stateSelect=StateSelect.never);

  SI.Energy InputEnergy "energy input";
  SI.Energy OutputEnergy "energy output";

  Real eta "energetic efficiency";

  Real standbyLoss "Standby Loss or electric Work demand during hold";
  Real systemTransmissionHeatLoss "relative Heat Loss of Total system";
  Real systemConvectionHeatLoss "relative Heat Loss of Total system";
  Real selfConsumption "self consumption at discharge, energy consumed at discharge as power ";
  Real conversionLoss "conversion Loss in Fan and electric Heater";
  Real addLossHrsg "losses of HRSG via blow down flow";

  Real equivalentFullCycles "full cycles of ETES System";

  Real selfDischargeRate "self discharge rate for energy storage system in % per day";


  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

equation

  der(W_el_c) = noEvent(if charge>0 then P_el else 0);
  der(W_el_d) = noEvent(if discharge>0 then P_el else 0);
  der(W_el_h) = noEvent(if hold>0 then P_el else 0);
  der(W_el) = P_el;

  der(Q_boiler_d) = noEvent(if discharge>0 then Q_flow_boiler else 0);
  der(Q_boiler) = Q_flow_boiler;

  der(Q_loss_system) = Q_flow_loss_system;
  der(E_loss_air2environment) = E_flow_loss_air2environment;
  der(E_loss_conv_fan) = P_loss_conv_fan;
  der(E_loss_conv_heater) = P_loss_conv_heater;
  der(E_loss_standby) = P_loss_standby;
  der(E_loss_hrsg) = E_flow_loss_hrsg;


// overall efficiency
  InputEnergy = if P2H2PCase then max(1,W_el_c + W_el_h) else max(1,W_el);
  OutputEnergy = if P2H2PCase then Q_boiler_d - W_el_d/HeatEngineEfficiency else Q_boiler; //only "free heat" for P2P operation
  eta = min(1,max(0,OutputEnergy/InputEnergy));

// energy losses relative to input
  systemTransmissionHeatLoss = min(1,max(0,Q_loss_system/InputEnergy));
  systemConvectionHeatLoss = min(1,max(0,E_loss_air2environment/InputEnergy));
  selfConsumption = if P2H2PCase then min(1,max(0,((1/HeatEngineEfficiency-1)*W_el_d)/InputEnergy)) else 0;
  addLossHrsg = min(1,max(0,E_loss_hrsg/InputEnergy));
  standbyLoss = min(1,max(0,E_loss_standby/InputEnergy));
  conversionLoss = min(1,max(0,(E_loss_conv_fan+E_loss_conv_heater)/InputEnergy));

// equivalent Full Cycles
  equivalentFullCycles = InputEnergy/U_theo;

// self discharge rate
  selfDischargeRate = (Q_loss_system)/max(1,(U_theo*time/(24*3600)));

end Summary;




  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  inner TransiEnt.SimCenter simCenter(
    useHomotopy=true,
    T_amb=273.15 + 20,
    calculateCost=false) annotation (Placement(transformation(extent={{120,140},{140,160}})));

  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveGas_L1 valve_discharge(
    medium=simCenter.airModel,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=25, m_flow_nom=generalParameter.m_flow_air_nom),
                                                                              openingInputIsActive=true, final checkValve=false,
    showData=false,
    opening_leak_=1e-5) annotation (Placement(transformation(
        extent={{-7,-4},{7,4}},
        rotation=-90,
        origin={-28,39})));

  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveGas_L1 valve_charge(
    medium=simCenter.airModel,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=25, m_flow_nom=generalParameter.m_flow_air_nom),
                                                                              openingInputIsActive=true, final checkValve=false,
    showData=false,
    opening_leak_=1e-5) annotation (Placement(transformation(
        extent={{-7,6},{7,-6}},
        rotation=180,
        origin={-53,18})));

  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveGas_L1 valve_EH_out(
    medium=simCenter.airModel,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=25, m_flow_nom=generalParameter.m_flow_air_nom),
                                                                              openingInputIsActive=true, final checkValve=false,
    showData=false,
    opening_leak_=1e-5) annotation (Placement(transformation(extent={{78,82},{92,94}})));

  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveGas_L1 valve_SG_in(
    medium=simCenter.airModel,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=25, m_flow_nom=generalParameter.m_flow_air_nom),
                                                                              openingInputIsActive=true, final checkValve=false,
    showData=false,
    opening_leak_=1e-5) annotation (Placement(transformation(extent={{64,-58},{50,-46}})));

  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveGas_L1 valve_vent(
    medium=simCenter.airModel,
    redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=25, m_flow_nom=generalParameter.m_flow_air_nom),
                                                                              openingInputIsActive=true, final checkValve=false,
    showData=false,
    opening_leak_=1e-5)                                                                                                          annotation (Placement(transformation(
        extent={{-7,10},{7,-10}},
        rotation=180,
        origin={-129,70})));




  ClaRa.Components.VolumesValvesFittings.Fittings.FlueGasJunction_L2 junc_fan_out(
    medium=simCenter.airModel,
    volume=1,
    showData=false,
    p_start=simCenter.p_amb_start,
    T_start=simCenter.T_amb_start) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-28,88})));

  ClaRa.Components.VolumesValvesFittings.Fittings.FlueGasJunction_L2 junc_hs_hot(
    medium=simCenter.airModel,
    volume=1,
    showData=false,
    p_start=simCenter.p_amb_start,
    T_start=simCenter.T_amb_start)                                   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={112,18})));

  ClaRa.Components.VolumesValvesFittings.Fittings.FlueGasJunction_L2 junc_fan_in(
    medium=simCenter.airModel,
    volume=1,
    showData=false,
    p_start=simCenter.p_amb_start,
    T_start=simCenter.T_amb_start) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-104,18})));

  ClaRa.Components.VolumesValvesFittings.Fittings.FlueGasJunction_L2 junc_hs_cold(
    medium=simCenter.airModel,
    volume=1,
    showData=false,
    p_start=simCenter.p_amb_start,
    T_start=simCenter.T_amb_start) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-28,18})));

          ClaRa.Components.VolumesValvesFittings.Fittings.FlueGasJunction_L2 junc_vent(
    medium=simCenter.airModel,
    volume=1,
    showData=false,
    p_start=simCenter.p_amb_start,
    T_start=simCenter.T_amb_start) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-104,70})));



  TransiEnt.Components.Heat.PipeGasAdvanced_L4 pipe_h_3(
    final frictionAtInlet=true,
    final frictionAtOutlet=true,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Gas_PL.QuadraticNominalPoint_L4,
    redeclare model Insulation = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer (redeclare model medium = TransiEnt.Basics.Media.Solids.RockWool, thickness=generalParameter.t_insulation_pipes_hot),
      length=10,
      diameter=1.5,
      N_pipes=1,
      Delta_p_nom=50,
    final p_start=fill(simCenter.p_amb_start, pipe_h_3.N_cv),
    final T_start=fill(simCenter.T_amb_start, pipe_h_3.N_cv),
    final xi_start=simCenter.airModel.xi_default,
    final useHomotopy=simCenter.useHomotopy,
    final medium_fluid=simCenter.airModel,
    final showExpertSummary=simCenter.showExpertSummary,
    final N_cv=3,
    final initOption=0,
    final showData=false,
    wall_thickness=generalParameter.t_wall_pipes,
    final m_flow_nom=generalParameter.m_flow_air_nom,
    final p_nom=simCenter.p_amb_start,
    final T_nom=generalParameter.T_air_hot_nom) annotation (Placement(transformation(extent={{-10,-4},{10,4}},
        rotation=90,
        origin={112,-10})));

  TransiEnt.Components.Heat.PipeGasAdvanced_L4 pipe_c_7(
    final frictionAtOutlet=true,
    final frictionAtInlet=true,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Gas_PL.QuadraticNominalPoint_L4,
    redeclare model Insulation = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer (redeclare model medium = TransiEnt.Basics.Media.Solids.RockWool, thickness=generalParameter.t_insulation_pipes_hot),
      length=10,
      diameter=1.5,
      N_pipes=1,
      Delta_p_nom=50,
    final p_start=fill(simCenter.p_amb_start, pipe_c_7.N_cv),
    final T_start=fill(simCenter.T_amb_start, pipe_c_7.N_cv),
    final xi_start=simCenter.airModel.xi_default,
    final medium_fluid=simCenter.airModel,
    final useHomotopy=simCenter.useHomotopy,
    final showExpertSummary=simCenter.showExpertSummary,
    final N_cv=3,
    final initOption=0,
    final showData=false,
    wall_thickness=generalParameter.t_wall_pipes,
    final m_flow_nom=generalParameter.m_flow_air_nom,
    final p_nom=simCenter.p_amb_start,
    final T_nom=generalParameter.T_air_cold_nom) annotation (Placement(transformation(extent={{-88,-56},{-68,-48}})));

  TransiEnt.Components.Heat.PipeGasAdvanced_L4 pipe_h_1(
    final frictionAtInlet=false,
    final frictionAtOutlet=true,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Gas_PL.QuadraticNominalPoint_L4,
        redeclare model Insulation = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer (redeclare model medium = TransiEnt.Basics.Media.Solids.RockWool, thickness=generalParameter.t_insulation_pipes_hot),
      length=10,
      diameter=1.5,
      N_pipes=1,
      Delta_p_nom=50,
    final p_start=fill(simCenter.p_amb_start, pipe_h_1.N_cv),
    final T_start=fill(simCenter.T_amb_start, pipe_h_1.N_cv),
    final xi_start=simCenter.airModel.xi_default,
    final useHomotopy=simCenter.useHomotopy,
    final medium_fluid=simCenter.airModel,
    final showExpertSummary=simCenter.showExpertSummary,
    final N_cv=3,
    final initOption=0,
    final showData=false,
    wall_thickness=generalParameter.t_wall_pipes,
    final m_flow_nom=generalParameter.m_flow_air_nom,
    final p_nom=simCenter.p_amb_start,
    final T_nom=generalParameter.T_air_hot_nom) annotation (Placement(transformation(
        extent={{10,-4},{-10,4}},
        rotation=-90,
        origin={112,48})));

  TransiEnt.Components.Heat.PipeGasAdvanced_L4 pipe_c_2(
    final frictionAtInlet=true,
    final frictionAtOutlet=true,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Gas_PL.QuadraticNominalPoint_L4,
        redeclare model Insulation = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer (redeclare model medium = TransiEnt.Basics.Media.Solids.RockWool, thickness=generalParameter.t_insulation_pipes_hot),
      length=10,
      diameter=1.5,
      N_pipes=1,
      Delta_p_nom=50,
    final p_start=fill(simCenter.p_amb_start, pipe_c_2.N_cv),
    final T_start=fill(simCenter.T_amb_start, pipe_c_2.N_cv),
    final xi_start=simCenter.airModel.xi_default,
    final useHomotopy=simCenter.useHomotopy,
    final medium_fluid=simCenter.airModel,
    final showExpertSummary=simCenter.showExpertSummary,
    final N_cv=3,
    final initOption=0,
    final showData=false,
    wall_thickness=generalParameter.t_wall_pipes,
    final m_flow_nom=generalParameter.m_flow_air_nom,
    final p_nom=simCenter.p_amb_start,
    final T_nom=generalParameter.T_air_cold_nom) annotation (Placement(transformation(extent={{12,84},{-8,92}})));

  TransiEnt.Components.Heat.PipeGasAdvanced_L4 pipe_c_3(
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Gas_PL.QuadraticNominalPoint_L4,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
        redeclare model Insulation = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer (redeclare model medium = TransiEnt.Basics.Media.Solids.RockWool, thickness=generalParameter.t_insulation_pipes_hot),
      length=10,
      diameter=1.5,
      N_pipes=1,
      Delta_p_nom=50,
    final frictionAtInlet=true,
    final frictionAtOutlet=false,
    final p_start=fill(simCenter.p_amb_start, pipe_c_3.N_cv),
    final T_start=fill(simCenter.T_amb_start, pipe_c_3.N_cv),
    final xi_start=simCenter.airModel.xi_default,
    final useHomotopy=simCenter.useHomotopy,
    final medium_fluid=simCenter.airModel,
    final showExpertSummary=simCenter.showExpertSummary,
    final N_cv=3,
    final initOption=0,
    final showData=false,
    wall_thickness=generalParameter.t_wall_pipes,
    final m_flow_nom=generalParameter.m_flow_air_nom,
    final p_nom=simCenter.p_amb_start,
    final T_nom=generalParameter.T_air_cold_nom) annotation (Placement(transformation(
        extent={{10,-4},{-10,4}},
        rotation=-90,
        origin={-28,60})));

  TransiEnt.Components.Heat.PipeGasAdvanced_L4 pipe_c_6(
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Gas_PL.QuadraticNominalPoint_L4,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
        redeclare model Insulation = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer (redeclare model medium = TransiEnt.Basics.Media.Solids.RockWool, thickness=generalParameter.t_insulation_pipes_hot),
      length=10,
      diameter=1.5,
      N_pipes=1,
      Delta_p_nom=50,
    final frictionAtInlet=false,
    final frictionAtOutlet=true,
    final p_start=fill(simCenter.p_amb_start, pipe_c_6.N_cv),
    final T_start=fill(simCenter.T_amb_start, pipe_c_6.N_cv),
    final xi_start=simCenter.airModel.xi_default,
    final useHomotopy=simCenter.useHomotopy,
    final medium_fluid=simCenter.airModel,
    final showExpertSummary=simCenter.showExpertSummary,
    final N_cv=3,
    final initOption=0,
    final showData=false,
    wall_thickness=generalParameter.t_wall_pipes,
    final m_flow_nom=generalParameter.m_flow_air_nom,
    final p_nom=simCenter.p_amb_start,
    final T_nom=generalParameter.T_air_cold_nom) annotation (Placement(transformation(extent={{-8,14},{12,22}})));

  TransiEnt.Components.Heat.PipeGasAdvanced_L4 pipe_h_2(
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Gas_PL.QuadraticNominalPoint_L4,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
        redeclare model Insulation = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer (redeclare model medium = TransiEnt.Basics.Media.Solids.RockWool, thickness=generalParameter.t_insulation_pipes_hot),
      length=10,
      diameter=1.5,
      N_pipes=1,
      Delta_p_nom=50,
    final frictionAtInlet=true,
    final frictionAtOutlet=false,
    final p_start=fill(simCenter.p_amb_start, pipe_h_2.N_cv),
    final T_start=fill(simCenter.T_amb_start, pipe_h_2.N_cv),
    final xi_start=simCenter.airModel.xi_default,
    final useHomotopy=simCenter.useHomotopy,
    final medium_fluid=simCenter.airModel,
    final showExpertSummary=simCenter.showExpertSummary,
    final N_cv=3,
    final initOption=0,
    final showData=false,
    wall_thickness=generalParameter.t_wall_pipes,
    final m_flow_nom=generalParameter.m_flow_air_nom,
    final p_nom=simCenter.p_amb_start,
    final T_nom=generalParameter.T_air_hot_nom) annotation (Placement(transformation(extent={{72,14},{92,22}})));

  TransiEnt.Components.Heat.PipeGasAdvanced_L4 pipe_c_1(
    final frictionAtOutlet=true,
    final frictionAtInlet=false,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Gas_PL.QuadraticNominalPoint_L4,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
        redeclare model Insulation = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer (redeclare model medium = TransiEnt.Basics.Media.Solids.RockWool, thickness=generalParameter.t_insulation_pipes_hot),
      length=10,
      diameter=1.5,
      N_pipes=1,
      Delta_p_nom=50,
    final p_start=fill(simCenter.p_amb_start, pipe_c_1.N_cv),
    final T_start=fill(simCenter.T_amb_start, pipe_c_1.N_cv),
    final xi_start=simCenter.airModel.xi_default,
    final useHomotopy=simCenter.useHomotopy,
    final medium_fluid=simCenter.airModel,
    final showExpertSummary=simCenter.showExpertSummary,
    final N_cv=3,
    final initOption=0,
    final showData=false,
    wall_thickness=generalParameter.t_wall_pipes,
    final m_flow_nom=generalParameter.m_flow_air_nom,
    final p_nom=simCenter.p_amb_start,
    final T_nom=generalParameter.T_air_cold_nom) annotation (Placement(transformation(extent={{-50,84},{-70,92}})));

  TransiEnt.Components.Heat.PipeGasAdvanced_L4 pipe_c_5(
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Gas_PL.QuadraticNominalPoint_L4,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
        redeclare model Insulation = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer (redeclare model medium = TransiEnt.Basics.Media.Solids.RockWool, thickness=generalParameter.t_insulation_pipes_hot),
      length=10,
      diameter=1.5,
      N_pipes=1,
      Delta_p_nom=50,
    final frictionAtInlet=true,
    final frictionAtOutlet=true,
    final p_start=fill(simCenter.p_amb_start, pipe_c_5.N_cv),
    final T_start=fill(simCenter.T_amb_start, pipe_c_5.N_cv),
    final xi_start=simCenter.airModel.xi_default,
    final useHomotopy=simCenter.useHomotopy,
    final medium_fluid=simCenter.airModel,
    final showExpertSummary=simCenter.showExpertSummary,
    final N_cv=3,
    final initOption=0,
    final showData=false,
    wall_thickness=generalParameter.t_wall_pipes,
    final m_flow_nom=generalParameter.m_flow_air_nom,
    final p_nom=simCenter.p_amb_start,
    final T_nom=generalParameter.T_air_cold_nom) annotation (Placement(transformation(
        extent={{-10,-4},{10,4}},
        rotation=-90,
        origin={-104,44})));

  TransiEnt.Components.Heat.PipeGasAdvanced_L4 pipe_c_4(
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Gas_PL.QuadraticNominalPoint_L4,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
        redeclare model Insulation = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer (redeclare model medium = TransiEnt.Basics.Media.Solids.RockWool, thickness=generalParameter.t_insulation_pipes_hot),
      length=10,
      diameter=1.5,
      N_pipes=1,
      Delta_p_nom=50,
    final frictionAtOutlet=true,
    final frictionAtInlet=false,
    final p_start=fill(simCenter.p_amb_start, pipe_c_4.N_cv),
    final T_start=fill(simCenter.T_amb_start, pipe_c_4.N_cv),
    final xi_start=simCenter.airModel.xi_default,
    final useHomotopy=simCenter.useHomotopy,
    final medium_fluid=simCenter.airModel,
    final showExpertSummary=simCenter.showExpertSummary,
    final N_cv=3,
    final initOption=0,
    final showData=false,
    wall_thickness=generalParameter.t_wall_pipes,
    final m_flow_nom=generalParameter.m_flow_air_nom,
    final p_nom=simCenter.p_amb_start,
    final T_nom=generalParameter.T_air_cold_nom) annotation (Placement(transformation(extent={{-88,14},{-68,22}})));


  TransiEnt.Components.Heat.Fan.Fan_L1 fan(m_flow_max=20) annotation (Placement(transformation(extent={{-100,78},{-80,98}})));


  TransiEnt.Components.Heat.ElectricAirHeater.ElectricAirHeater_L4 electricAirHeater(
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Gas_PL.QuadraticNominalPoint_L4,
    redeclare model HeatTransferExternal = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
    redeclare model Insulation = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer (redeclare model medium = TransiEnt.Basics.Media.Solids.RockWool, thickness=0.2),
    length=6,
    height=1.5,
    width=1.5,
    wall_thickness=0.005,
    timeConstant_air=180,
    P_el_max=7.5e6,
    m_flow_nom=generalParameter.m_flow_air_nom,
    T_nom=273.15 + 750,
    Delta_p_nom=500) annotation (Placement(transformation(extent={{48,78},{68,98}})));

  TransiEnt.Components.Heat.HeatRecoverySteamGenerator.HeatRecoverySteamGenerator_L1 heatRecoverySteamGenerator(
    timeConstant_air=600,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Gas_PL.QuadraticNominalPoint_L4,
    redeclare model HeatTransferExternal = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Ideal_L4,
   redeclare model Insulation = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer (redeclare model medium = TransiEnt.Basics.Media.Solids.RockWool, thickness=0.2),
    T_set_steam=273.15 + 500,
    Delta_T_PP=10,
    Delta_T_AP=5,
    Q_flow_nom=5e6,
    m_flow_water_evap_min=0.5,
    length=3,
    height=8,
    width=3,
    m_flow_nom=generalParameter.m_flow_air_nom,
    Delta_p_nom=500,
    T_nom=273.15 + 600) annotation (Placement(transformation(extent={{0,-62},{20,-42}})));

  TransiEnt.Storage.Heat.PackedBedStorage_L4.PackedBedStorage_L4 packedBedStorage(
    d_v_m=0.02,
    redeclare model PackedBedGeometry = TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.PackedBedGeometry.BlockShapedUnit (
        length=10,
        height=7.5,
        width=7.5),
    redeclare model ColdAirGeometry = TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.StorageAirVolumeGeometry.TruncatedPyramid (
        height=2,
        width_2=2,
        length_2=2,
        width_1=7.5,
        length_1=7.5),
    redeclare model HotAirGeometry = TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.StorageAirVolumeGeometry.TruncatedPyramid (
        height=2,
        width_2=2,
        length_2=2,
        width_1=7.5,
        length_1=7.5),
    linearInit=true,
    T_start_bed=cat(
        1,
        ones(integer(0.3*packedBedStorage.N_cv))*packedBedStorage.T_c,
        linspace(
          packedBedStorage.T_c,
          packedBedStorage.T_d,
          integer(0.3*packedBedStorage.N_cv)),
        ones(packedBedStorage.N_cv - 2*integer(0.3*packedBedStorage.N_cv))*packedBedStorage.T_d),
    T_start_hot=simCenter.T_amb_start,
    T_start_cold=simCenter.T_amb_start,
    T_ref=273.15 + 20,
    T_c=273.15 + 750,
    T_d=273.15 + 200,
    T_stop_c=273.15 + 350,
    T_stop_d=273.15 + 550,
    redeclare model Insulation_bed = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer (
        N_cv=300,
        length=10,
        circumference=4*7.5,
        thickness=0.5),
    redeclare model Insulation_hot = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer (
        N_cv=1,
        length=2,
        circumference=4*4.75,
        thickness=0.5),
    redeclare model Insulation_cold = TransiEnt.Components.Heat.ThermalInsulation.ThermalInsulation_static_1way_1layer (
        N_cv=1,
        length=2,
        circumference=4*4.75,
        thickness=0.5),
    redeclare model PressureLossPB = TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.PackedBedPressureLoss.Ergun,
    redeclare model PressureLossHotAir = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Gas_PL.QuadraticNominalPoint_L2 (Delta_p_nom=500),
    redeclare model PressureLossColdAir = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Gas_PL.QuadraticNominalPoint_L2 (Delta_p_nom=500),
    redeclare model ThermalConductivityPB = TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.EffectiveThermalConductivity.VDIHeatAtlas,
    redeclare model HeatTransferPB2Wall = TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.HeatTransfer.PackedBedToWall.PB2Wall_Ideal,
    redeclare model HeatTransferPB2Air = TransiEnt.Storage.Heat.PackedBedStorage_L4.Basics.HeatTransfer.PackedBedToAir.PB2Air_Adiabat,
    redeclare model HeatTransferAir2Wall = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2,
    redeclare model HeatTransferAir2PB = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.IdealHeatTransfer_L2,
    T_nom=generalParameter.T_air_hot_nom,
    m_flow_nom=generalParameter.m_flow_air_nom,
    Delta_p_nom_bed=2500,
    N_cv=300) annotation (Placement(transformation(extent={{64,-2},{24,38}})));

  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency electricGrid annotation (Placement(transformation(extent={{140,62},{160,82}})));

  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi(p_const(displayUnit="Pa") = 5e5, T_const(displayUnit="degC") = 393.15)
                                                                        annotation (Placement(transformation(extent={{160,-120},{140,-100}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi boundaryVLE_pTxi1(p_const=65e5, T_const(displayUnit="degC") = TILMedia.VLEFluidFunctions.dewTemperature_pxi(
      simCenter.fluid1,
      65e5,
      simCenter.fluid1.xi_default))                                                 annotation (Placement(transformation(extent={{160,-80},{140,-60}})));
  ClaRa.Components.BoundaryConditions.BoundaryGas_pTxi environment(
    medium=simCenter.airModel,
    variable_p=true,
    variable_T=true) annotation (Placement(transformation(extent={{-160,60},{-140,80}})));

  Modelica.Blocks.Routing.RealPassThrough Plug[10] "|y1: m_flow_set |y2: P_heater| y3: valve open vent  |y4: valve open heater |y5: valve open hrsg |y6: valve open charge |y7: valve open discharge  |y8: charge |y9: discharge |y10: hold" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-110,130})));

  Modelica.Blocks.Sources.CombiTimeTable OperationCycle(
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    table=[0,0,0,1,1,0,1,0,0,0,1; 1000,0,0,1,1,0,1,0,0,0,1; 1300,10,6500000,1,1,0,1,0,1,0,0; 87700,10,6500000,1,1,0,1,0,1,0,0; 88300,10,0,1,1,0,1,0,1,0,0; 88600,0,0,1,1,0,1,0,0,0,1; 175000,0,0,1,1,0,1,0,0,0,1; 175300,10,0,1,0,1,0,1,0,0,1; 261700,10,0,1,0,1,0,1,0,1,0; 262000,0,0,1,0,1,0,1,0,1,0; 263000,0,0,1,0,1,0,1,0,0,1]) "|y1: m_flow_set |y2: P_heater| y3: valve open vent  |y4: valve open heater |y5: valve open hrsg |y6: valve open charge |y7: valve open discharge  |y8: charge |y9: discharge |y10: hold"                                                                                                annotation (Placement(transformation(extent={{-160,140},{-140,120}})));

  GeneralParameter generalParameter annotation (Placement(transformation(extent={{-150,-146},{-120,-114}})));

  Summary summary(
      HeatEngineEfficiency=0.45,
      P2H2PCase=true,
    Q_flow_loss_system=
    packedBedStorage.summary.outline.Q_flow_loss_Iso_tot+
    electricAirHeater.summary.outline.Q_flow_loss +  heatRecoverySteamGenerator.summary.outline.Q_flow_loss+
    pipe_h_1.summary.outline.Q_flow_loss +  pipe_h_2.summary.outline.Q_flow_loss +  pipe_h_3.summary.outline.Q_flow_loss +
    pipe_c_1.summary.outline.Q_flow_loss +  pipe_c_2.summary.outline.Q_flow_loss +  pipe_c_3.summary.outline.Q_flow_loss + pipe_c_4.summary.outline.Q_flow_loss +  pipe_c_5.summary.outline.Q_flow_loss +  pipe_c_6.summary.outline.Q_flow_loss +  pipe_c_7.summary.outline.Q_flow_loss,
    E_flow_loss_air2environment=valve_vent.summary.outlet.H_flow,
      P_loss_conv_fan=fan.summary.outline.P_el_loss,
    P_loss_conv_heater=electricAirHeater.summary.outline.P_el_loss,
    P_loss_standby=standbyConsumer.epp.P,
    E_flow_loss_hrsg=heatRecoverySteamGenerator.summary.outline.E_flow_loss_blowDown,
    Q_flow_boiler=heatRecoverySteamGenerator.summary.outline.E_flow_steam,
      U_theo=packedBedStorage.summary.outline.U_theo,
      U_start=packedBedStorage.summary.outline.U_start,
    P_el=-electricGrid.epp.P,
    hold=Plug[10].y,
    discharge=Plug[9].y,
    charge=Plug[8].y)              annotation (Placement(transformation(extent={{-100,-146},{-68,-114}})));


  Modelica.Blocks.Sources.RealExpression p_amb(y=simCenter.p_amb) annotation (Placement(transformation(extent={{-190,68},{-170,88}})));
  Modelica.Blocks.Sources.RealExpression T_amb(y=simCenter.T_amb) annotation (Placement(transformation(extent={{-190,52},{-170,72}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Power standbyConsumer(useInputConnectorP=false, P_el_set_const=50e3) annotation (Placement(transformation(extent={{80,40},{100,60}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(junc_hs_cold.portC, valve_discharge.outlet) annotation (Line(
      points={{-28,28},{-28,32}},
      color={118,106,98},
      thickness=0.5));
  connect(valve_charge.inlet, junc_hs_cold.portA) annotation (Line(
      points={{-46,18},{-38,18}},
      color={118,106,98},
      thickness=0.5));
  connect(valve_EH_out.outlet, pipe_h_1.inlet) annotation (Line(
      points={{92,88},{112,88},{112,58}},
      color={118,106,98},
      thickness=0.5));
  connect(pipe_h_1.outlet, junc_hs_hot.portA) annotation (Line(
      points={{112,38.1429},{112,28}},
      color={118,106,98},
      thickness=0.5));
  connect(junc_fan_out.portB, pipe_c_2.inlet) annotation (Line(
      points={{-18,88},{-8,88}},
      color={118,106,98},
      thickness=0.5));
  connect(pipe_c_7.outlet, junc_fan_in.portB) annotation (Line(
      points={{-87.8571,-52},{-104,-52},{-104,8}},
      color={118,106,98},
      thickness=0.5));
  connect(valve_discharge.inlet, pipe_c_3.outlet) annotation (Line(
      points={{-28,46},{-28,50.1429}},
      color={118,106,98},
      thickness=0.5));
  connect(pipe_c_3.inlet, junc_fan_out.portC) annotation (Line(
      points={{-28,70},{-28,78}},
      color={118,106,98},
      thickness=0.5));
  connect(junc_fan_in.portA, pipe_c_5.inlet) annotation (Line(
      points={{-104,28},{-104,34}},
      color={118,106,98},
      thickness=0.5));
  connect(pipe_c_1.outlet, junc_fan_out.portA) annotation (Line(
      points={{-50.1429,88},{-38,88}},
      color={118,106,98},
      thickness=0.5));
  connect(junc_fan_in.portC, pipe_c_4.outlet) annotation (Line(
      points={{-94,18},{-87.8571,18}},
      color={118,106,98},
      thickness=0.5));
  connect(pipe_c_4.inlet, valve_charge.outlet) annotation (Line(
      points={{-68,18},{-60,18}},
      color={118,106,98},
      thickness=0.5));
  connect(junc_hs_cold.portB, pipe_c_6.outlet) annotation (Line(
      points={{-18,18},{-7.85714,18}},
      color={118,106,98},
      thickness=0.5));
  connect(pipe_h_2.inlet, junc_hs_hot.portC) annotation (Line(
      points={{92,18},{102,18}},
      color={118,106,98},
      thickness=0.5));
  connect(junc_hs_hot.portB, pipe_h_3.inlet) annotation (Line(
      points={{112,8},{112,0}},
      color={118,106,98},
      thickness=0.5));


  connect(pipe_c_2.outlet, electricAirHeater.inlet) annotation (Line(
      points={{11.8571,88},{48,88}},
      color={118,106,98},
      thickness=0.5));
  connect(electricAirHeater.outlet, valve_EH_out.inlet) annotation (Line(
      points={{68,88},{78,88}},
      color={118,106,98},
      thickness=0.5));
  connect(heatRecoverySteamGenerator.gasInlet, valve_SG_in.outlet) annotation (Line(
      points={{19.8,-52},{50,-52}},
      color={118,106,98},
      thickness=0.5));
  connect(pipe_c_7.inlet, heatRecoverySteamGenerator.gasOutlet) annotation (Line(
      points={{-68,-52},{0.2,-52}},
      color={118,106,98},
      thickness=0.5));
  connect(fan.outlet, pipe_c_1.inlet) annotation (Line(
      points={{-80,88},{-70,88}},
      color={118,106,98},
      thickness=0.5));
  connect(pipe_h_3.outlet, valve_SG_in.inlet) annotation (Line(
      points={{112,-19.8571},{112,-52},{64,-52}},
      color={118,106,98},
      thickness=0.5));
  connect(fan.epp,electricGrid. epp) annotation (Line(
      points={{-90,78.2},{-90,72},{140,72}},
      color={0,135,135},
      thickness=0.5));
  connect(electricGrid.epp, electricAirHeater.epp) annotation (Line(
      points={{140,72},{58,72},{58,78}},
      color={0,135,135},
      thickness=0.5));
  connect(heatRecoverySteamGenerator.livesteam, boundaryVLE_pTxi1.steam_a) annotation (Line(
      points={{16,-62},{16,-70},{140,-70}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(heatRecoverySteamGenerator.feedwater, boundaryVLE_pTxi.steam_a) annotation (Line(
      points={{4,-62},{4,-110},{140,-110}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pipe_c_5.outlet, junc_vent.portB) annotation (Line(
      points={{-104,53.8571},{-104,60}},
      color={118,106,98},
      thickness=0.5));
  connect(packedBedStorage.HotAirPort, pipe_h_2.outlet) annotation (Line(
      points={{64,18},{72.1429,18}},
      color={118,106,98},
      thickness=0.5));
  connect(pipe_c_6.inlet, packedBedStorage.ColdAirPort) annotation (Line(
      points={{12,18},{24,18}},
      color={118,106,98},
      thickness=0.5));
  connect(Plug[1].y, fan.m_flow_set) annotation (Line(points={{-99,130},{-90,130},{-90,98.6}}, color={0,0,127}));
  connect(Plug[2].y, electricAirHeater.P_el_set) annotation (Line(points={{-99,130},{58,130},{58,98.2}}, color={0,0,127}));
  connect(Plug[3].y, valve_vent.opening_in) annotation (Line(points={{-99,130},{-88,130},{-88,108},{-129,108},{-129,85}}, color={0,0,127}));
  connect(Plug[4].y, valve_EH_out.opening_in) annotation (Line(points={{-99,130},{85,130},{85,97}}, color={0,0,127}));
  connect(Plug[5].y, valve_SG_in.opening_in) annotation (Line(points={{-99,130},{128,130},{128,-32},{57,-32},{57,-43}}, color={0,0,127}));
  connect(Plug[6].y, valve_charge.opening_in) annotation (Line(points={{-99,130},{-72,130},{-72,104},{-44,104},{-44,66},{-53,66},{-53,27}},
                                                                                                      color={0,0,127}));
  connect(Plug[7].y, valve_discharge.opening_in) annotation (Line(points={{-99,130},{28,130},{28,40},{0,40},{0,39},{-22,39}},     color={0,0,127}));
  connect(valve_vent.inlet, junc_vent.portC) annotation (Line(
      points={{-122,70},{-114,70}},
      color={118,106,98},
      thickness=0.5));
  connect(valve_vent.outlet, environment.gas_a) annotation (Line(
      points={{-136,70},{-140,70}},
      color={118,106,98},
      thickness=0.5));
  connect(fan.inlet, junc_vent.portA) annotation (Line(
      points={{-100,88},{-104,88},{-104,80}},
      color={118,106,98},
      thickness=0.5));
  connect(environment.p, p_amb.y) annotation (Line(points={{-160,76},{-160,84},{-169,84},{-169,78}}, color={0,0,127}));
  connect(T_amb.y, environment.T) annotation (Line(points={{-169,62},{-169,66},{-166,66},{-166,70},{-160,70}}, color={0,0,127}));
  connect(standbyConsumer.epp,electricGrid. epp) annotation (Line(
      points={{80,50},{74,50},{74,72},{140,72}},
      color={0,135,135},
      thickness=0.5));
  connect(OperationCycle.y, Plug.u) annotation (Line(points={{-139,130},{-122,130}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,160}}), graphics={
        Text(
          extent={{-160,-160},{160,-220}},
          lineColor={0,134,134},
          textString="%name"),     Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-160,-160},{160,160}}), Polygon(
          origin={28,16},
          lineColor={78,138,73},
          fillColor={0,124,124},
          fillPattern=FillPattern.Solid,
          points={{-58.0,46.0},{42.0,-14.0},{-58.0,-74.0},{-58.0,46.0}})}),
                                Diagram(coordinateSystem(
                   extent={{-160,-160},{160,160}}, initialScale=1)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>The model determines the efficiency of a Electric Thermal Energy Storage System, accounting for self discharge via heat losses to the environment, thermal destratification in the packed bed and fan work. In an Electric Thermal Energy Storage, energy is stored as thermal energy in a horizontal-flow packed bed of natural rocks. At the charge process, a fan moves air through a resistance heater. The air then flows through the packed bed pores and heats the storage material. The thermal gradient or thermocline inside the packed bed moves in air flow direction at a lower speed. At discharge, the fan moves air through the storage in reverse direction. The air heated from the packed bed is used to produce steam in a heat recovery steam generator.</p>
<p>See the references for more information.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>It has to be noted, that this model does not include any means of control. Thus, the temperatures at several positions in the cycle, the air mass flow and the charge and discharge power are not kept in an reasonable operating range, as required for a sustained ETES operation.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>The sparse solver should be activated (<b><span style=\"font-family: Courier New;\">Advanced.SparseActivate&nbsp;=&nbsp;true;</span></b>) , according to the many control volumes inside the packed bed, which are only connected to neighbouring cells.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>All component models have been validated during the research project Future Energy Solution (FES).</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>[1] M. von der Heyde, Abschlussbericht zum Teilprojekt der TUHH im Verbundforschungsprojekt Future Energy Solution (FES), BMWI 03ET6072C, 2021</p>
<p>[2] M. von der Heyde, Electric Thermal Energy Storage based on Packed Beds for Renewable Energy Integration, Dissertation, Hamburg University of Technology, 2021</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Michael von der Heyde (heyde@tuhh.de), Apr 2021, for the FES research project</p>
</html>"),
    experiment(
      StopTime=263000,
      __Dymola_NumberOfIntervals=1000,
      Tolerance=1e-05,
      __Dymola_Algorithm="Sdirk34hw"),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(
        EvaluateAlsoTop=true,
        GenerateVariableDependencies=false,
        OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=true));
end ElectricThermalEnergyStorage;
