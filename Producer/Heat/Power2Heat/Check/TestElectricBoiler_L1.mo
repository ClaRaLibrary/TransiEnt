within TransiEnt.Producer.Heat.Power2Heat.Check;
model TestElectricBoiler_L1
  import TransiEnt;
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2020, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE and ResiliEntEE are research projects supported by the German     //
// Federal Ministry of Economics and Energy (FKZ 03ET4003 and 03ET4048).          //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Institute of Electrical Power Systems and Automation                           //
// (Hamburg University of Technology)                                             //
// and is supported by                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//
  extends TransiEnt.Basics.Icons.Checkmodel;
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency electricGrid(useInputConnector=false) annotation (Placement(transformation(extent={{8,20},{28,40}})));
  TransiEnt.Producer.Heat.Power2Heat.ElectricBoiler simpleElectricBoiler(
    Q_flow_n=140e6,
    usePowerPort=true,
    useFluidPorts=false) annotation (Placement(transformation(extent={{-10,50},{10,70}})));
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
        origin={46,-13})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source1(
    variable_m_flow=false,
    T_const=60 + 273,
    m_flow_const=400) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-16,-78})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency electricGrid1(useInputConnector=false) annotation (Placement(transformation(extent={{8,-80},{28,-60}})));
  TransiEnt.Producer.Heat.Power2Heat.ElectricBoiler simpleElectricBoiler1(
    Q_flow_n=140e6,
    usePowerPort=true,
    useFluidPorts=true) annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    height=-50e6,
    offset=-100e6,
    startTime=3600,
    duration=900)
    annotation (Placement(transformation(extent={{-54,-30},{-34,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=283.15) annotation (Placement(transformation(extent={{40,50},{20,70}})));
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
      points={{-9.8,-40},{-16,-40},{-16,-68}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(simpleElectricBoiler1.fluidPortOut, sink1.steam_a) annotation (Line(
      points={{10,-40},{46,-40},{46,-23}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(ramp1.y, simpleElectricBoiler1.Q_flow_set) annotation (Line(
      points={{-33,-20},{0,-20},{0,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(electricGrid1.epp, simpleElectricBoiler1.epp) annotation (Line(
      points={{8,-70},{0,-70},{0,-50}},
      color={0,135,135},
      thickness=0.5));
  connect(fixedTemperature.port, simpleElectricBoiler.heat) annotation (Line(points={{20,60},{10,60}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), experiment(StopTime=7200));
end TestElectricBoiler_L1;
