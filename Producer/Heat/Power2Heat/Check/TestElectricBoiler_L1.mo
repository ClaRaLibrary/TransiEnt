within TransiEnt.Producer.Heat.Power2Heat.Check;
model TestElectricBoiler_L1
  import TransiEnt;
//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
  extends TransiEnt.Basics.Icons.Checkmodel;
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={44,31})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source(
    variable_m_flow=false,
    m_flow_const=100,
    T_const=60 + 273) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-18,-34})));
  TransiEnt.Components.Boundaries.Electrical.Frequency electricGrid(useInputConnector=false) annotation (Placement(transformation(extent={{6,-36},{26,-16}})));
  TransiEnt.Producer.Heat.Power2Heat.ElectricBoiler simpleElectricBoiler annotation (Placement(transformation(extent={{-12,-6},{8,14}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-50e6,
    offset=-100e6,
    startTime=3600,
    duration=900)
    annotation (Placement(transformation(extent={{-56,14},{-36,34}})));
equation
  connect(simpleElectricBoiler.inlet, source.steam_a) annotation (Line(
      points={{-11.8,4},{-18,4},{-18,-24}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(simpleElectricBoiler.outlet, sink.steam_a) annotation (Line(
      points={{8,4},{44,4},{44,21}},
      color={175,0,0},
      smooth=Smooth.None));

  connect(ramp.y, simpleElectricBoiler.Q_flow_set) annotation (Line(
      points={{-35,24},{-2,24},{-2,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(electricGrid.epp, simpleElectricBoiler.epp) annotation (Line(
      points={{5.9,-26.1},{-2,-26.1},{-2,-6}},
      color={0,135,135},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end TestElectricBoiler_L1;
