within TransiEnt.Consumer.Heat.Check;
model TestFirstOrderHeatingNetworkConsumer
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
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-130,80},{-110,100}})));

  FirstOrderHeatingNetworkConsumer ConsumerStation(
    T_return_const=50 + 273.15,
    m_flow_init=1000,
    T_massflow_ctrl=2) annotation (Placement(transformation(extent={{12,-10},{-8,10}})));
  Modelica.Blocks.Sources.Constant Q_th_demand(k=250e6) annotation (Placement(transformation(extent={{36,18},{16,38}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_phxi districtHeatingReturn(
    m_flow_nom=100,
    p_const=1000000,
    Delta_p=100000,
    variable_p=false,
    h_const=400e3) annotation (Placement(transformation(
        extent={{13,-11},{-13,11}},
        rotation=180,
        origin={-47,-6})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow districtHeatingSupply(
    m_flow_const=0.1,
    m_flow_nom=0,
    p_nom=1000,
    variable_m_flow=false,
    variable_T=true)
                   annotation (Placement(transformation(extent={{-62,16},{-30,42}})));
  Modelica.Blocks.Sources.Step     T_feed(
    height=20,
    offset=373.15,
    startTime=100)                                      annotation (Placement(transformation(extent={{-97,19},{-77,39}})));
equation
  connect(Q_th_demand.y, ConsumerStation.Q_demand) annotation (Line(points={{15,28},{2.4,28},{2.4,9.4}},
                                                                                                    color={0,0,127}));
  connect(districtHeatingSupply.T, T_feed.y) annotation (Line(points={{-65.2,29},{-76,29}},                   color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestFirstOrderHeatingNetworkConsumer.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 817}, y={"districtHeatingSupply.eye.T"}, range={0.0, 200.0, 98.0, 122.0}, grid=true, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 406}, y={"districtHeatingReturn.steam_a.m_flow"}, range={0.0, 200.0, 750.0, 1150.0}, grid=true, subPlot=2, colors={{28,108,200}}, filename=resultFileName);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
equation
  connect(ConsumerStation.fluidPortIn, districtHeatingSupply.steam_a) annotation (Line(
      points={{-8,-4},{-12,-4},{-12,-2},{-12,26},{-12,29},{-30,29}},
      color={175,0,0},
      thickness=0.5));
  connect(ConsumerStation.fluidPortOut, districtHeatingReturn.steam_a) annotation (Line(
      points={{-8,-8},{-22,-8},{-22,-6},{-34,-6}},
      color={175,0,0},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{100,100}})),
    experiment(StopTime=200),
    __Dymola_experimentSetupOutput(equidistant=false),
    Icon(coordinateSystem(extent={{-160,-100},{100,100}})));
end TestFirstOrderHeatingNetworkConsumer;
