within TransiEnt.Producer.Heat.Power2Heat.ElectricBoiler.Check;
model TestElectricBoiler_L1
  import TransiEnt;

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



  extends TransiEnt.Basics.Icons.Checkmodel;
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency electricGrid(useInputConnector=false) annotation (Placement(transformation(extent={{8,20},{28,40}})));
  TransiEnt.Producer.Heat.Power2Heat.ElectricBoiler.ElectricBoiler simpleElectricBoiler(
    Q_flow_n=140e6,
    usePowerPort=true,
    useFluidPorts=false,
    useHeatPort=true)    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-50e6,
    offset=-100e6,
    startTime=3600,
    duration=900)
    annotation (Placement(transformation(extent={{-54,70},{-34,90}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink1(medium=simCenter.fluid1, p_const=17e5)
                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={46,-7})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source1(
    variable_m_flow=false,
    T_const=60 + 273,
    m_flow_const=400) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-16,-60})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency electricGrid1(useInputConnector=false) annotation (Placement(transformation(extent={{8,-62},{28,-42}})));
  TransiEnt.Producer.Heat.Power2Heat.ElectricBoiler.ElectricBoiler simpleElectricBoiler1(
    Q_flow_n=140e6,
    usePowerPort=true,
    useFluidPorts=true) annotation (Placement(transformation(extent={{-10,-32},{10,-12}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    height=-50e6,
    offset=-100e6,
    startTime=3600,
    duration=900)
    annotation (Placement(transformation(extent={{-54,-12},{-34,8}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=283.15) annotation (Placement(transformation(extent={{40,50},{20,70}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency electricGrid2(useInputConnector=false) annotation (Placement(transformation(extent={{28,-130},{48,-110}})));
  TransiEnt.Producer.Heat.Power2Heat.ElectricBoiler.ElectricBoiler simpleElectricBoiler2(
    usePelset=true,
    Q_flow_n=140e6,
    usePowerPort=true,
    useFluidPorts=false) annotation (Placement(transformation(extent={{-8,-122},{12,-102}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    height=-50e6,
    offset=-100e6,
    startTime=3600,
    duration=900)
    annotation (Placement(transformation(extent={{-50,-106},{-30,-86}})));
equation

  connect(ramp.y, simpleElectricBoiler.Q_flow_set) annotation (Line(
      points={{-33,80},{0,80},{0,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(electricGrid.epp, simpleElectricBoiler.epp) annotation (Line(
      points={{8,30},{0,30},{0,50}},
      color={0,135,135},
      thickness=0.5));
  connect(simpleElectricBoiler1.fluidPortIn, source1.steam_a) annotation (Line(
      points={{-9.8,-22},{-16,-22},{-16,-50}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(simpleElectricBoiler1.fluidPortOut, sink1.steam_a) annotation (Line(
      points={{10,-22},{46,-22},{46,-17}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(ramp1.y, simpleElectricBoiler1.Q_flow_set) annotation (Line(
      points={{-33,-2},{0,-2},{0,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(electricGrid1.epp, simpleElectricBoiler1.epp) annotation (Line(
      points={{8,-52},{0,-52},{0,-32}},
      color={0,135,135},
      thickness=0.5));
  connect(fixedTemperature.port, simpleElectricBoiler.heat) annotation (Line(points={{20,60},{10,60}}, color={191,0,0}));
  connect(electricGrid2.epp,simpleElectricBoiler2. epp) annotation (Line(
      points={{28,-120},{16,-120},{16,-126},{2,-126},{2,-122}},
      color={0,135,135},
      thickness=0.5));
  connect(ramp2.y, simpleElectricBoiler2.P_el_set) annotation (Line(points={{-29,-96},{-8.6,-96},{-8.6,-115.2}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{100,100}})),
                                experiment(StopTime=7200),
    Icon(coordinateSystem(extent={{-100,-140},{100,100}})));
end TestElectricBoiler_L1;
