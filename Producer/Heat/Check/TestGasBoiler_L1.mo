within TransiEnt.Producer.Heat.Check;
model TestGasBoiler_L1
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
  extends Basics.Icons.Checkmodel;
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={42,5})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow source(
    variable_m_flow=false,
    m_flow_const=100,
    T_const=60 + 273) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-56,4})));
  SimpleGasboilerGasport gasBoiler annotation (Placement(transformation(extent={{-12,-6},{8,14}})));
  Modelica.Blocks.Sources.Ramp ramp(
    startTime=3600,
    duration=900,
    height=-40e6,
    offset=-50e6)
    annotation (Placement(transformation(extent={{-58,38},{-38,58}})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi gasSource annotation (Placement(transformation(extent={{-22,-56},{-2,-36}})));
  inner ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
equation
  connect(ramp.y, gasBoiler.Q_flow_set) annotation (Line(
      points={{-37,48},{-2,48},{-2,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasSource.gasPort, gasBoiler.gasIn) annotation (Line(
      points={{-2,-46},{-2,-46},{-2,-6},{-1.8,-6}},
      color={255,255,0},
      thickness=0.75));
  connect(gasBoiler.outlet, sink.steam_a) annotation (Line(
      points={{8,4},{28,4},{32,4},{32,5}},
      color={175,0,0},
      thickness=0.5));
  connect(gasBoiler.inlet, source.steam_a) annotation (Line(
      points={{-11.8,4},{-46,4}},
      color={175,0,0},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end TestGasBoiler_L1;
