within TransiEnt.Examples.GridTypology_Cologne.BlockDevelopment_DHN;
model GridTypology_DHN_2015

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



  inner SimCenter simCenter(
    redeclare TransiEnt.Components.Boundaries.Ambient.AmbientConditions_Cologne_TRY ambientConditions,
    p_nom={600000,1000000},
    redeclare model Ground_Temperature = TransiEnt.Basics.Tables.Ambient.UndergroundTemperature_Duesseldorf_1m_3600s_TMY,
    calc_initial_dstrb=false,
    T_supply=363.15,
    T_return=343.15,
    K(displayUnit="mm") = 2e-5) annotation (Placement(transformation(extent={{-438,290},{-404,320}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi Grid_Return_Out(p_const(displayUnit="bar") = simCenter.p_nom[1], T_const(displayUnit="degC") = 363.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-314,-108})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow Grid_Supply_In(m_flow_const=-10, T_const(displayUnit="degC") = 363.15) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-294,216})));
  TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.DoublePipePair_L2 HL_1(
    p_start_supply=simCenter.p_nom[2],
    T_start_supply=363.15,
    p_start_return=simCenter.p_nom[1],
    T_start_return=343.15,
    length=22,
    DN=150) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-298,-70})));
  TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.DoublePipePair_L2 HL_2(
    p_start_supply=simCenter.p_nom[2],
    T_start_supply=363.15,
    p_start_return=simCenter.p_nom[1],
    T_start_return=343.15,
    length=22,
    DN=150) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-300,18})));
  TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.DoublePipePair_L2 HL_3(
    p_start_supply=simCenter.p_nom[2],
    T_start_supply=363.15,
    p_start_return=simCenter.p_nom[1],
    T_start_return=343.15,
    length=22,
    DN=150) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-299,82})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi Grid_Supply_Out(p_const(displayUnit="bar") = simCenter.p_nom[2], T_const(displayUnit="degC") = 363.15) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-288,-108})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow Grid_Return_In(m_flow_const=10, T_const(displayUnit="degC") = 343.15) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-314,214})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature T_ground1 annotation (Placement(transformation(extent={{-422,204},{-402,224}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=simCenter.T_ground_var) annotation (Placement(transformation(extent={{-460,204},{-440,224}})));
  TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.DoublePipePair_L2 HL_4(
    p_start_supply=simCenter.p_nom[2],
    T_start_supply=363.15,
    p_start_return=simCenter.p_nom[1],
    T_start_return=343.15,
    length=22,
    DN=150) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-299,158})));
  Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage ElectricGrid(
    Use_input_connector_f=false,
    Use_input_connector_v=false,
    v_boundary=400) annotation (Placement(transformation(
        extent={{-14,-15},{14,15}},
        rotation=180,
        origin={-336,192})));
  TransiEnt.SystemGeneration.GridConstructor.GridConstructor GC_1(
    gas_in=false,
    gas_out=false,
    el_out=false,
    dhn_in_s=true,
    dhn_out_s=false,
    dhn_in_r=false,
    dhn_out_r=true,
    Technologies_1={TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix()},
    Technologies_2={TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix()},
    CablePipeParameters={TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.10,
        l_pipe=22,
        l_cable=22),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters()},
    redeclare model Systems_Consumer_1 = TransiEnt.SystemGeneration.GridConstructor.IndependentTechnologies,
    redeclare model Systems_Consumer_2 = TransiEnt.SystemGeneration.GridConstructor.IndependentTechnologies,
    redeclare model Demand_Consumer_1 = TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_3Tables (
        relativepath_el="combined/Typology_Cologne/2015/T_6/electricity/GC_1.csv",
        relativepath_heating="combined/Typology_Cologne/2015/T_6/heat/GC_1.csv",
        relativepath_dhw="combined/Typology_Cologne/2015/T_6/dhw/GC_1.csv"),
    redeclare model Demand_Consumer_2 = TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_3Tables (
        relativepath_el="combined/Typology_Cologne/2015/T_6/electricity/GC_1.csv",
        relativepath_heating="combined/Typology_Cologne/2015/T_6/heat/GC_1.csv",
        relativepath_dhw="combined/Typology_Cologne/2015/T_6/dhw/GC_1.csv"),
    start_c1=1,
    start_c2=3,
    second_Consumer={true,true},
    second_row=true,
    DHNParameters_Main={TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_1={TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_2={TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters()},
    redeclare model HeatTransfer = TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Base.HT_Single_Buried_L2,
    dhn_lambda_insulation={0.023,0.023},
    n_elements=2) annotation (Placement(transformation(extent={{-364,114},{-436,170}})));
  TransiEnt.SystemGeneration.GridConstructor.GridConstructor GC_4(
    gas_in=false,
    gas_out=false,
    el_out=false,
    dhn_in_s=true,
    dhn_out_s=false,
    dhn_in_r=false,
    dhn_out_r=true,
    Technologies_1={TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix()},
    Technologies_2={TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix()},
    CablePipeParameters={TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters()},
    redeclare model Systems_Consumer_1 = TransiEnt.SystemGeneration.GridConstructor.IndependentTechnologies,
    redeclare model Systems_Consumer_2 = TransiEnt.SystemGeneration.GridConstructor.IndependentTechnologies,
    redeclare model Demand_Consumer_1 = TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_3Tables (
        relativepath_el="combined/Typology_Cologne/2015/T_6/electricity/GC_4.csv",
        relativepath_heating="combined/Typology_Cologne/2015/T_6/heat/GC_4_noNSH.csv",
        relativepath_dhw="combined/Typology_Cologne/2015/T_6/dhw/GC_4.csv"),
    redeclare model Demand_Consumer_2 = TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_3Tables (
        relativepath_el="combined/Typology_Cologne/2015/T_6/electricity/GC_4.csv",
        relativepath_heating="combined/Typology_Cologne/2015/T_6/heat/GC_4_noNSH.csv",
        relativepath_dhw="combined/Typology_Cologne/2015/T_6/dhw/GC_4.csv"),
    start_c1=1,
    start_c2=5,
    second_Consumer={true,true,true,true},
    second_row=true,
    DHNParameters_Main={TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_1={TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_2={TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters()},
    redeclare model HeatTransfer = TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Base.HT_Single_Buried_L2,
    dhn_lambda_insulation={0.023,0.023,0.023,0.023},
    n_elements=4) annotation (Placement(transformation(extent={{-248,34},{-176,90}})));
  TransiEnt.SystemGeneration.GridConstructor.GridConstructor GC_6(
    gas_in=false,
    gas_out=false,
    el_out=false,
    dhn_in_s=true,
    dhn_out_s=false,
    dhn_in_r=false,
    dhn_out_r=true,
    Technologies_1={TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix()},
    Technologies_2={TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix()},
    CablePipeParameters={TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters()},
    redeclare model Systems_Consumer_1 = TransiEnt.SystemGeneration.GridConstructor.IndependentTechnologies,
    redeclare model Systems_Consumer_2 = TransiEnt.SystemGeneration.GridConstructor.IndependentTechnologies,
    redeclare model Demand_Consumer_1 = TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_3Tables (
        relativepath_el="combined/Typology_Cologne/2015/T_6/electricity/GC_6.csv",
        relativepath_heating="combined/Typology_Cologne/2015/T_6/heat/GC_6.csv",
        relativepath_dhw="combined/Typology_Cologne/2015/T_6/dhw/GC_6.csv"),
    redeclare model Demand_Consumer_2 = TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_3Tables (
        relativepath_el="combined/Typology_Cologne/2015/T_6/electricity/GC_6.csv",
        relativepath_heating="combined/Typology_Cologne/2015/T_6/heat/GC_6.csv",
        relativepath_dhw="combined/Typology_Cologne/2015/T_6/dhw/GC_6.csv"),
    start_c1=1,
    start_c2=3,
    second_Consumer={true,true},
    second_row=true,
    DHNParameters_Main={TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_1={TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_2={TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters()},
    redeclare model HeatTransfer = TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Base.HT_Single_Buried_L2,
    dhn_lambda_insulation={0.023,0.023},
    n_elements=2) annotation (Placement(transformation(
        extent={{36,-28},{-36,28}},
        rotation=0,
        origin={-402,-30})));
  TransiEnt.SystemGeneration.GridConstructor.GridConstructor GC_3(
    gas_in=false,
    gas_out=false,
    el_out=false,
    dhn_in_s=true,
    dhn_out_s=false,
    dhn_in_r=false,
    dhn_out_r=true,
    Technologies_1={TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix()},
    Technologies_2={TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix()},
    CablePipeParameters={TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters()},
    redeclare model Systems_Consumer_1 = TransiEnt.SystemGeneration.GridConstructor.IndependentTechnologies,
    redeclare model Systems_Consumer_2 = TransiEnt.SystemGeneration.GridConstructor.IndependentTechnologies,
    redeclare model Demand_Consumer_1 = TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_3Tables (
        relativepath_el="combined/Typology_Cologne/2015/T_6/electricity/GC_3.csv",
        relativepath_heating="combined/Typology_Cologne/2015/T_6/heat/GC_3.csv",
        relativepath_dhw="combined/Typology_Cologne/2015/T_6/dhw/GC_3.csv"),
    redeclare model Demand_Consumer_2 = TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_3Tables (
        relativepath_el="combined/Typology_Cologne/2015/T_6/electricity/GC_3.csv",
        relativepath_heating="combined/Typology_Cologne/2015/T_6/heat/GC_3.csv",
        relativepath_dhw="combined/Typology_Cologne/2015/T_6/dhw/GC_3.csv"),
    start_c1=1,
    start_c2=3,
    second_Consumer={true,true},
    second_row=true,
    DHNParameters_Main={TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_1={TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_2={TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters()},
    redeclare model HeatTransfer = TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Base.HT_Single_Buried_L2,
    dhn_lambda_insulation={0.023,0.023},
    n_elements=2) annotation (Placement(transformation(extent={{-366,33},{-438,89}})));
  TransiEnt.SystemGeneration.GridConstructor.GridConstructor GC_5(
    gas_in=false,
    gas_out=false,
    el_out=false,
    dhn_in_s=true,
    dhn_out_s=false,
    dhn_in_r=false,
    dhn_out_r=true,
    Technologies_1={TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix()},
    Technologies_2={TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix()},
    CablePipeParameters={TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters()},
    redeclare model Systems_Consumer_1 = TransiEnt.SystemGeneration.GridConstructor.IndependentTechnologies,
    redeclare model Systems_Consumer_2 = TransiEnt.SystemGeneration.GridConstructor.IndependentTechnologies,
    redeclare model Demand_Consumer_1 = TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_3Tables (
        relativepath_el="combined/Typology_Cologne/2015/T_6/electricity/GC_5.csv",
        relativepath_heating="combined/Typology_Cologne/2015/T_6/heat/GC_5.csv",
        relativepath_dhw="combined/Typology_Cologne/2015/T_6/dhw/GC_5.csv"),
    redeclare model Demand_Consumer_2 = TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_3Tables (
        relativepath_el="combined/Typology_Cologne/2015/T_6/electricity/GC_5.csv",
        relativepath_heating="combined/Typology_Cologne/2015/T_6/heat/GC_5.csv",
        relativepath_dhw="combined/Typology_Cologne/2015/T_6/dhw/GC_5.csv"),
    start_c1=1,
    start_c2=3,
    second_Consumer={true,true},
    second_row=true,
    DHNParameters_Main={TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_1={TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_2={TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters()},
    redeclare model HeatTransfer = TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Base.HT_Single_Buried_L2,
    dhn_lambda_insulation={0.023,0.023},
    n_elements=2) annotation (Placement(transformation(
        extent={{36,28},{-36,-28}},
        rotation=180,
        origin={-210,-32})));
  TransiEnt.SystemGeneration.GridConstructor.GridConstructor GC_2(
    gas_in=false,
    gas_out=false,
    el_out=false,
    dhn_in_s=true,
    dhn_out_s=false,
    dhn_in_r=false,
    dhn_out_r=true,
    Technologies_1={TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix()},
    Technologies_2={TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(
        Boiler=0,
        CHP=0,
        heatPump=0,
        PV=0,
        DHN=1,
        ST=0,
        NSH=0,
        Oil=0,
        Biomass=0),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.TechnologyMatrix()},
    CablePipeParameters={TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(
        diameter_i=0.1,
        l_pipe=22,
        l_cable=22),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.CablePipeParameters()},
    redeclare model Systems_Consumer_1 = TransiEnt.SystemGeneration.GridConstructor.IndependentTechnologies,
    redeclare model Systems_Consumer_2 = TransiEnt.SystemGeneration.GridConstructor.IndependentTechnologies,
    redeclare model Demand_Consumer_1 = TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_3Tables (
        relativepath_el="combined/Typology_Cologne/2015/T_6/electricity/GC_2.csv",
        relativepath_heating="combined/Typology_Cologne/2015/T_6/heat/GC_2.csv",
        relativepath_dhw="combined/Typology_Cologne/2015/T_6/dhw/GC_2.csv"),
    redeclare model Demand_Consumer_2 = TransiEnt.Basics.Tables.Combined.CombinedTables.Demand_3Tables (
        relativepath_el="combined/Typology_Cologne/2015/T_6/electricity/GC_2.csv",
        relativepath_heating="combined/Typology_Cologne/2015/T_6/heat/GC_2.csv",
        relativepath_dhw="combined/Typology_Cologne/2015/T_6/dhw/GC_2.csv"),
    start_c1=1,
    start_c2=5,
    second_Consumer={true,true,true,true},
    second_row=true,
    DHNParameters_Main={TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=22,
        DN=50,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_1={TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters()},
    DHNParameters_Consumer_2={TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(
        length=10,
        DN=20,
        lambda_insulation=0.024),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),
        TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters(),TransiEnt.SystemGeneration.GridConstructor.DataRecords.DHNParameters()},
    redeclare model HeatTransfer = TransiEnt.Components.Heat.VolumesValvesFittings.Pipes.Base.HT_Single_Buried_L2,
    dhn_lambda_insulation={0.023,0.023,0.023,0.023},
    n_elements=4) annotation (Placement(transformation(extent={{-248,116},{-176,172}})));
equation
  connect(HL_1.waterPortIn_return, HL_2.waterPortOut_return) annotation (Line(
      points={{-302,-59.8},{-302,8},{-304,8}},
      color={175,0,0},
      thickness=0.5));
  connect(HL_2.waterPortIn_return, HL_3.waterPortOut_return) annotation (Line(
      points={{-304,28.2},{-304,72},{-303,72}},
      color={175,0,0},
      thickness=0.5));
  connect(HL_2.waterPortOut_supply, HL_3.waterPortIn_supply) annotation (Line(
      points={{-296,28},{-296,72},{-295,72}},
      color={175,0,0},
      thickness=0.5));
  connect(HL_1.waterPortOut_supply, HL_2.waterPortIn_supply) annotation (Line(
      points={{-294,-60},{-296,-60},{-296,8}},
      color={175,0,0},
      thickness=0.5));

  connect(T_ground1.T, realExpression.y) annotation (Line(points={{-424,214},{-439,214}}, color={0,0,127}));
  connect(T_ground1.port, HL_3.heat_return);
  connect(T_ground1.port, HL_3.heat_supply);
  connect(T_ground1.port, HL_2.heat_return);
  connect(T_ground1.port, HL_2.heat_supply);
  connect(T_ground1.port, HL_1.heat_return);
  connect(T_ground1.port, HL_1.heat_supply);
  connect(HL_3.waterPortIn_return, HL_4.waterPortOut_return) annotation (Line(
      points={{-303,92.2},{-303,148}},
      color={175,0,0},
      thickness=0.5));
  connect(HL_3.waterPortOut_supply, HL_4.waterPortIn_supply) annotation (Line(
      points={{-295,92},{-295,148}},
      color={175,0,0},
      thickness=0.5));
  connect(Grid_Return_Out.steam_a, HL_1.waterPortOut_return) annotation (Line(
      points={{-314,-98},{-314,-80},{-302,-80}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Grid_Return_In.steam_a, HL_4.waterPortIn_return) annotation (Line(
      points={{-314,204},{-314,168.2},{-303,168.2}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(T_ground1.port, HL_4.heat_return);
  connect(T_ground1.port, HL_4.heat_supply);
  connect(GC_4.epp_p, ElectricGrid.epp) annotation (Line(
      points={{-248,48},{-296,48},{-296,192},{-322,192}},
      color={0,127,0},
      thickness=0.5));
  connect(GC_3.epp_p, ElectricGrid.epp) annotation (Line(
      points={{-366,47},{-296,47},{-296,192},{-322,192}},
      color={0,127,0},
      thickness=0.5));
  connect(GC_2.epp_p, ElectricGrid.epp) annotation (Line(
      points={{-248,130},{-296,130},{-296,192},{-322,192}},
      color={0,127,0},
      thickness=0.5));
  connect(GC_6.epp_p, ElectricGrid.epp) annotation (Line(
      points={{-366,-44},{-296,-44},{-296,192},{-322,192}},
      color={0,127,0},
      thickness=0.5));
  connect(GC_5.epp_p, ElectricGrid.epp) annotation (Line(
      points={{-246,-46},{-296,-46},{-296,192},{-322,192}},
      color={0,127,0},
      thickness=0.5));
  connect(GC_1.epp_p, ElectricGrid.epp) annotation (Line(
      points={{-364,128},{-296,128},{-296,192},{-322,192}},
      color={0,127,0},
      thickness=0.5));
  connect(HL_3.waterPortOut_supply, GC_1.waterPortIn_supply) annotation (Line(
      points={{-295,92},{-295,146.667},{-364,146.667}},
      color={175,0,0},
      thickness=0.5));
  connect(HL_3.waterPortOut_supply, GC_2.waterPortIn_supply) annotation (Line(
      points={{-295,92},{-298,92},{-298,148.667},{-248,148.667}},
      color={175,0,0},
      thickness=0.5));
  connect(GC_1.waterPortOut_return, HL_3.waterPortIn_return) annotation (Line(
      points={{-364,137.333},{-303,137.333},{-303,92.2}},
      color={175,0,0},
      thickness=0.5));
  connect(GC_2.waterPortOut_return, HL_3.waterPortIn_return) annotation (Line(
      points={{-248,139.333},{-256,139.333},{-256,137},{-303,137},{-303,92.2}},
      color={175,0,0},
      thickness=0.5));
  connect(GC_3.waterPortIn_supply, HL_2.waterPortOut_supply) annotation (Line(
      points={{-366,65.6667},{-356,65.6667},{-356,64},{-296,64},{-296,28}},
      color={175,0,0},
      thickness=0.5));
  connect(HL_2.waterPortIn_return, GC_3.waterPortOut_return) annotation (Line(
      points={{-304,28.2},{-304,56.3333},{-366,56.3333}},
      color={175,0,0},
      thickness=0.5));
  connect(GC_4.waterPortOut_return, HL_2.waterPortIn_return) annotation (Line(
      points={{-248,57.3333},{-304,57.3333},{-304,28.2}},
      color={175,0,0},
      thickness=0.5));
  connect(GC_4.waterPortIn_supply, HL_2.waterPortOut_supply) annotation (Line(
      points={{-248,66.6667},{-296,66.6667},{-296,28}},
      color={175,0,0},
      thickness=0.5));
  connect(GC_6.waterPortIn_supply, HL_1.waterPortOut_supply) annotation (Line(
      points={{-366,-25.3333},{-294,-25.3333},{-294,-60}},
      color={175,0,0},
      thickness=0.5));
  connect(GC_5.waterPortIn_supply, HL_1.waterPortOut_supply) annotation (Line(
      points={{-246,-27.3333},{-294,-27.3333},{-294,-60}},
      color={175,0,0},
      thickness=0.5));
  connect(GC_6.waterPortOut_return, HL_1.waterPortIn_return) annotation (Line(
      points={{-366,-34.6667},{-342,-34.6667},{-342,-38},{-302,-38},{-302,-59.8}},
      color={175,0,0},
      thickness=0.5));
  connect(HL_1.waterPortIn_return, GC_5.waterPortOut_return) annotation (Line(
      points={{-302,-59.8},{-302,-36.6667},{-246,-36.6667}},
      color={175,0,0},
      thickness=0.5));
  connect(HL_1.waterPortIn_supply, Grid_Supply_Out.steam_a) annotation (Line(
      points={{-294,-80},{-294,-98},{-288,-98}},
      color={175,0,0},
      thickness=0.5));
  connect(Grid_Supply_In.steam_a, HL_4.waterPortOut_supply) annotation (Line(
      points={{-294,206},{-296,206},{-296,168},{-295,168}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-480,-100},{100,320}}),
                                                                                    graphics={
        Rectangle(
          extent={{-470,124},{-192,110}},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-452,76},{-430,50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-452,106},{-410,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-452,48},{-430,22}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-452,-8},{-430,-50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-452,20},{-430,-6}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-424,-24},{-356,-50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-352,-24},{-330,-50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-232,76},{-210,50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-232,46},{-210,20}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-232,16},{-210,-22}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-406,106},{-380,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-376,106},{-350,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-348,106},{-306,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-302,106},{-260,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-256,106},{-210,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-470,-54},{-192,-68}},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-470,122},{-456,-62}},
          pattern=LinePattern.None,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-206,120},{-192,-64}},
          pattern=LinePattern.None,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-326,-24},{-258,-50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-252,-24},{-210,-50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-192,286},{-470,300}},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-430,226},{-452,252}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-410,256},{-452,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-430,198},{-452,224}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-430,126},{-452,168}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-430,170},{-452,196}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-358,126},{-426,152}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-330,126},{-352,152}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-210,226},{-232,252}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-210,196},{-232,222}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-210,154},{-232,192}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-380,256},{-406,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-350,256},{-376,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-306,256},{-348,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-260,256},{-302,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-210,256},{-256,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-192,108},{-470,122}},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-456,114},{-470,298}},
          pattern=LinePattern.None,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-192,112},{-206,296}},
          pattern=LinePattern.None,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-258,126},{-326,152}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-210,126},{-252,152}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-206,124},{72,110}},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-188,76},{-166,50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-188,106},{-146,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-188,48},{-166,22}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-188,-8},{-166,-50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-188,20},{-166,-6}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-162,-24},{-94,-50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-88,-24},{-66,-50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,76},{54,50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,46},{54,20}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,16},{54,-22}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-142,106},{-116,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-112,106},{-86,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-84,106},{-42,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-38,106},{4,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{8,106},{54,80}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-206,-54},{72,-68}},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-206,122},{-192,-62}},
          pattern=LinePattern.None,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{58,120},{72,-64}},
          pattern=LinePattern.None,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-62,-24},{6,-50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{12,-24},{54,-50}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{72,286},{-206,300}},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-166,226},{-188,252}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-146,256},{-188,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-166,198},{-188,224}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-166,126},{-188,168}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-166,170},{-188,196}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,126},{-162,152}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-66,126},{-88,152}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,226},{32,252}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,196},{32,222}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,154},{32,192}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-116,256},{-142,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-86,256},{-112,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-42,256},{-84,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{4,256},{-38,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,256},{8,282}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{72,108},{-206,122}},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-192,114},{-206,298}},
          pattern=LinePattern.None,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{72,112},{56,296}},
          pattern=LinePattern.None,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{6,126},{-62,152}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,126},{12,152}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-480,-100},{100,320}}),
                                                                                       graphics={
        Text(
          extent={{-416,180},{-384,170}},
          lineColor={0,0,0},
          lineThickness=0.5,
          textString="22 m"),
        Text(
          extent={{-418,-80},{-386,-90}},
          lineColor={0,0,0},
          lineThickness=0.5,
          textString="22 m"),
        Text(
          extent={{-226,-80},{-194,-90}},
          lineColor={0,0,0},
          lineThickness=0.5,
          textString="22 m"),
        Text(
          extent={{-214,162},{-182,152}},
          lineColor={0,0,0},
          lineThickness=0.5,
          textString="22 m"),
        Text(
          extent={{-364,308},{-42,274}},
          lineColor={28,108,200},
          textString="Inner City Typology with DHN for Cologne 2015
"),     Text(
          extent={{-234,274},{-52,194}},
          lineColor={0,0,0},
          lineThickness=0.5,
          horizontalAlignment=TextAlignment.Left,
          textString="Block development typology:
inner city development of apartment buildings which 
together form street blocks and
were mainly created around the turn of the century (1900). 
Mainly in the metropolitan inner area with 
direct distance to the city centre. 
Grid-shaped Development with identical orientation of 
opposite building rows.")}),
    experiment(
      StopTime=31536000,
      Interval=3600,
      Tolerance=1e-07,
      __Dymola_Algorithm="Cvode"),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model of Settlement Topology 6 - Block development with DHN</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>J. Benthin, A. Hagemeier, A. Heyer, P. Huismann, J. Krassowski, C. Settgast, B. Wortmann, K. G&ouml;rner (2020): Integrierte Betrachtung von Strom-, Gas- und W&auml;rmesystemen zur modellbasierten Optimierung des Energieausgleichs- und Transportbedarfs innerhalb der deutschen Energienetze. Gemeinsamer Abschlussbericht des Forschungsvorhabens IntegraNet</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created at GWI by Philipp Huismann (huismann@gwi-essen.de) on 26.03.2019</span></p>
</html>"),
    __Dymola_experimentSetupOutput(inputs=false, events=false));
end GridTypology_DHN_2015;
