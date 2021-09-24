within TransiEnt.Producer.Electrical.Conventional.Check;
model CheckCCP_with_SecondGasPort
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
  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Grid.Electrical.Base.ExampleGenerationPark generationPark)
                                      annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency constantPotentialVariableBoundary(useInputConnector=false) annotation (Placement(transformation(extent={{54,42},{74,62}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi annotation (Placement(transformation(extent={{74,10},{54,30}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
  TransiEnt.Producer.Electrical.Conventional.CCP_with_Gasport cCP_with_Gasport(
    isSecondaryControlActive=false,
    P_el_n=1000e6,
    MinimumDownTime(displayUnit="s") = 19000,
    eta_total=0.615,
    EfficiencyCharLine=TransiEnt.Producer.Electrical.Base.PartloadEfficiency.CCGTButtler(),
    useSecondGasPort=true)                                              annotation (Placement(transformation(extent={{-8,14},{12,34}})));
  Modelica.Blocks.Sources.Ramp ramp(
    startTime=1.5e4,
    duration=20e4,
    height=0,
    offset=-1e9)            annotation (Placement(transformation(extent={{-70,26},{-50,46}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow
                                                           boundary_Txim_flow(variable_m_flow=true, xi_const={0,0,0,0,0,0})
                                                                         annotation (Placement(transformation(extent={{44,68},{24,88}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    startTime=1.5e4,
    duration=20e4,
    height=-10,
    offset=0)               annotation (Placement(transformation(extent={{84,94},{64,114}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency constantPotentialVariableBoundary1(useInputConnector=false) annotation (Placement(transformation(extent={{44,-72},{64,-52}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi1
                                                                         annotation (Placement(transformation(extent={{64,-104},{44,-84}})));
  TransiEnt.Producer.Electrical.Conventional.Gasturbine_with_Gasport
                                                              gasturbine_with_Gasport(
    isSecondaryControlActive=false,
    P_el_n=1000e6,
    MinimumDownTime(displayUnit="s") = 19000,
    eta_total=0.42,
    EfficiencyCharLine=TransiEnt.Producer.Electrical.Base.PartloadEfficiency.GasTurbineButtler(),
    useSecondGasPort=true)                                              annotation (Placement(transformation(extent={{-14,-100},{6,-80}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    startTime=1.5e4,
    duration=20e4,
    height=0,
    offset=-1e9)            annotation (Placement(transformation(extent={{-68,-88},{-48,-68}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow
                                                           boundary_Txim_flow1(variable_m_flow=true, xi_const={0,0,0,0,0,0})
                                                                         annotation (Placement(transformation(extent={{34,-46},{14,-26}})));
  Modelica.Blocks.Sources.Ramp ramp3(
    startTime=1.5e4,
    duration=20e4,
    height=-10,
    offset=0)               annotation (Placement(transformation(extent={{74,-20},{54,0}})));
equation
  connect(cCP_with_Gasport.epp, constantPotentialVariableBoundary.epp) annotation (Line(
      points={{11,31},{34,31},{34,52},{54,52}},
      color={0,135,135},
      thickness=0.5));
  connect(cCP_with_Gasport.gasPortIn, boundary_pTxi.gasPort) annotation (Line(
      points={{12,20},{48,20},{48,20},{54,20}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp.y, cCP_with_Gasport.P_el_set) annotation (Line(points={{-49,36},{0.5,36},{0.5,33.9}},                    color={0,0,127}));
  connect(cCP_with_Gasport.gasPortIn_2, boundary_Txim_flow.gasPort) annotation (Line(
      points={{12,24},{24,24},{24,78}},
      color={255,255,0},
      thickness=1.5));
  connect(boundary_Txim_flow.m_flow, ramp1.y) annotation (Line(points={{46,84},{58,84},{58,104},{63,104}}, color={0,0,127}));
  connect(gasturbine_with_Gasport.epp, constantPotentialVariableBoundary1.epp) annotation (Line(
      points={{5,-83},{24,-83},{24,-62},{44,-62}},
      color={0,135,135},
      thickness=0.5));
  connect(gasturbine_with_Gasport.gasPortIn, boundary_pTxi1.gasPort) annotation (Line(
      points={{6,-94},{38,-94},{38,-94},{44,-94}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp2.y, gasturbine_with_Gasport.P_el_set) annotation (Line(points={{-47,-78},{-5.5,-78},{-5.5,-80.1}}, color={0,0,127}));
  connect(gasturbine_with_Gasport.gasPortIn_2, boundary_Txim_flow1.gasPort) annotation (Line(
      points={{6,-90},{14,-90},{14,-36}},
      color={255,255,0},
      thickness=1.5));
  connect(boundary_Txim_flow1.m_flow, ramp3.y) annotation (Line(points={{36,-30},{48,-30},{48,-10},{53,-10}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false), graphics={
                                         Text(
          extent={{-96,8},{14,-54}},
          lineColor={28,108,200},
          textString="Usage of second gas port to model a 
mixed gas feed for
 power plants by natural gas (gasPortIn)
 and hydrogen (gasPortIn_2)")}),
    experiment(StopTime=250000, Interval=600));
end CheckCCP_with_SecondGasPort;
