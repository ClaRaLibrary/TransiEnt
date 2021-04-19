within TransiEnt.Producer.Electrical.Conventional.Check;
model CheckCCP_with_GasPort_MinimumDownTime
    import TransiEnt;
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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
  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=-1e9,
    width=50,
    period=36000) annotation (Placement(transformation(extent={{-78,12},{-58,32}})));
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Grid.Electrical.Base.ExampleGenerationPark generationPark)
                                      annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency constantPotentialVariableBoundary(useInputConnector=false) annotation (Placement(transformation(extent={{70,14},{90,34}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi annotation (Placement(transformation(extent={{90,-10},{70,10}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
  TransiEnt.Producer.Electrical.Conventional.CCP_with_Gasport cCP_with_Gasport(
    isSecondaryControlActive=false,
    P_el_n=1000e6,
    MinimumDownTime(displayUnit="s") = 19000,
    T_plant=50,
    CCS_Characteristics=TransiEnt.Producer.Electrical.Base.CCS.CCP_PCC()) annotation (Placement(transformation(extent={{-8,-6},{12,14}})));
  TransiEnt.Producer.Electrical.Conventional.Gasturbine_with_Gasport gasturbine_with_Gasport(
    P_el_n=1000e6,
    MinimumDownTime=0,
    isSecondaryControlActive=false,
    isExternalSecondaryController=false) annotation (Placement(transformation(extent={{-8,-40},{12,-20}})));
  TransiEnt.Producer.Electrical.Conventional.CCP_with_Gasport cCP_with_Gasport1(
    isSecondaryControlActive=false,
    P_el_n=1000e6,
    smoothShutDown=true,
    MinimumDownTime(displayUnit="s") = 19000,
    T_plant=50,
    CCS_Characteristics=TransiEnt.Producer.Electrical.Base.CCS.CCP_PCC()) annotation (Placement(transformation(extent={{-8,28},{12,48}})));
equation
  connect(cCP_with_Gasport.epp, constantPotentialVariableBoundary.epp) annotation (Line(
      points={{11,11},{34,11},{34,24},{70,24}},
      color={0,135,135},
      thickness=0.5));
  connect(cCP_with_Gasport.P_el_set, pulse.y) annotation (Line(points={{0.5,13.9},{0.5,22},{-57,22}},   color={0,127,127}));
  connect(gasturbine_with_Gasport.P_el_set, pulse.y) annotation (Line(points={{0.5,-20.1},{0.5,-14},{-20,-14},{-20,22},{-57,22}}, color={0,127,127}));
  connect(gasturbine_with_Gasport.epp, constantPotentialVariableBoundary.epp) annotation (Line(
      points={{11,-23},{34,-23},{34,24},{70,24}},
      color={0,135,135},
      thickness=0.5));
  connect(gasturbine_with_Gasport.gasPortIn, boundary_pTxi.gasPort) annotation (Line(
      points={{12,-35},{70,-35},{70,0}},
      color={255,255,0},
      thickness=1.5));
  connect(cCP_with_Gasport.gasPortIn, boundary_pTxi.gasPort) annotation (Line(
      points={{12,-1},{42,-1},{42,0},{70,0}},
      color={255,255,0},
      thickness=1.5));
  connect(cCP_with_Gasport1.epp, constantPotentialVariableBoundary.epp) annotation (Line(
      points={{11,45},{34,45},{34,24},{70,24}},
      color={0,135,135},
      thickness=0.5));
  connect(cCP_with_Gasport1.P_el_set, pulse.y) annotation (Line(points={{0.5,47.9},{0.5,22},{-57,22}}, color={0,127,127}));
  connect(cCP_with_Gasport1.gasPortIn, boundary_pTxi.gasPort) annotation (Line(
      points={{12,33},{42,33},{42,0},{70,0}},
      color={255,255,0},
      thickness=1.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=360000, Interval=60));
end CheckCCP_with_GasPort_MinimumDownTime;
