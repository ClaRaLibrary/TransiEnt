within TransiEnt.Consumer.Heat.Check;
model TestFirstOrderHeatingNetworkConsumer_withPlant
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
  Modelica.Blocks.Sources.RealExpression P_set(y=-100e6)
                                                        annotation (Placement(
        transformation(
        extent={{-11,-9.5},{11,9.5}},
        rotation=0,
        origin={-117,-16.5})));
  TransiEnt.Components.Boundaries.Electrical.Frequency Grid(useInputConnector=false) annotation (Placement(transformation(extent={{-58,-8},{-44,4}})));
  TransiEnt.Producer.Combined.LargeScaleCHP.ContinuousCHP Plant(
    typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.BlackCoal,
    typeOfCO2AllocationMethod=2,
    useConstantEfficiencies=false,
    PQCharacteristics=TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.PQ_Characteristics_WT(),
    eta_th_const=0.696296,
    p_nom=16e5,
    P_el_init=100e6,
    Q_flow_init=250e6,
    P_el_n=Plant.PQCharacteristics.PQboundaries[1, 2],
    Q_flow_n_CHP=Plant.PQCharacteristics.PQboundaries[end, 1],
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.HardCoal,
    m_flow_nom=1500,
    h_nom=4.2e3*90,
    T_feed_init=363.15) annotation (Placement(transformation(extent={{-112,-62},{-66,-18}})));

  FirstOrderHeatingNetworkConsumer
                              ConsumerStation(
    m_flow_init=1900,
    T_return_const=65 + 273.15,
    p_return_const=1600000)                                               annotation (Placement(transformation(extent={{48,-48},{28,-28}})));
  Modelica.Blocks.Sources.RealExpression T_feed_is(y=Plant.T_out_sensor.T) annotation (Placement(transformation(
        extent={{-9,-10.5},{9,10.5}},
        rotation=0,
        origin={-127,12.5})));
  Modelica.Blocks.Continuous.LimPID Ctrl_T_feed(
    yMax=Plant.Q_flow_n_CHP,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    xi_start=3.92,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    y_start=250e6,
    yMin=0.10*Plant.Q_flow_n_CHP,
    k=Plant.Q_flow_n_CHP*10,
    Ti=450)                       annotation (Placement(transformation(
        extent={{-12,-12},{12,12}},
        rotation=0,
        origin={-112,38})));
  Modelica.Blocks.Math.Gain Q_flow_set(k=-1) annotation (Placement(transformation(
      extent={{-6,-6},{6,6}},
      rotation=0,
      origin={-88,38})));
  Modelica.Blocks.Sources.Constant Q_th_demand(k=250e6) annotation (Placement(transformation(extent={{72,-20},{52,0}})));
  Modelica.Blocks.Sources.Step     T_feed_set(
    offset=90 + 273.15,
    startTime=2e4,
    height=10)                                               annotation (Placement(transformation(extent={{-158,30},{-138,50}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple pipe_feed(
    showExpertSummary=false,
    showData=false,
    frictionAtInlet=false,
    frictionAtOutlet=false,
    diameter_i=0.8,
    z_in=0,
    z_out=0,
    N_tubes=1,
    length=10e3,
    N_cv=10,
    Delta_x=ones(pipe_feed.N_cv)*pipe_feed.length/pipe_feed.N_cv,
  p_start=ones(pipe_feed.N_cv)*12e5,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (final temperatureDifference="Outlet"),
    h_start=ones(pipe_feed.N_cv)*4.2e3*90,
    p_nom=ones(pipe_feed.geo.N_cv)*12e5,
    h_nom=ones(pipe_feed.geo.N_cv)*4.2e3*90,
    m_flow_nom=1900,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4)
                                                                  annotation (Placement(transformation(extent={{-37,-27},{-10,-17}})));
  ClaRa.Components.VolumesValvesFittings.Pipes.PipeFlowVLE_L4_Simple pipe_return(
    showExpertSummary=false,
    showData=false,
    frictionAtInlet=false,
    frictionAtOutlet=false,
    diameter_i=0.8,
    z_in=0,
    z_out=0,
    N_tubes=1,
    length=10e3,
    N_cv=10,
    Delta_x=ones(pipe_return.N_cv)*pipe_return.length/pipe_return.N_cv,
  p_start=ones(pipe_return.N_cv)*16e5,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.CharLine_L4 (final temperatureDifference="Outlet"),
    h_start=ones(pipe_return.N_cv)*4.2e3*65,
    p_nom=ones(pipe_return.geo.N_cv)*16e5,
    h_nom=ones(pipe_return.geo.N_cv)*4.2e3*65,
    m_flow_nom=1900,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.LinearPressureLoss_L4)
                                                                        annotation (Placement(transformation(extent={{-10,-73},{-37,-63}})));
equation
  connect(Plant.epp, Grid.epp) annotation (Line(
      points={{-67.15,-33.4},{-62,-33.4},{-62,-2.06},{-58.07,-2.06}},
      color={0,135,135},
      thickness=0.5));
  connect(Plant.P_set, P_set.y) annotation (Line(points={{-103.03,-23.1333},{-103.03,-16.5},{-104.9,-16.5}},
                                                                                           color={0,0,127}));
  connect(Q_th_demand.y, ConsumerStation.Q_demand) annotation (Line(points={{51,-10},{38.4,-10},{38.4,-28.6}},
                                                                                                    color={0,0,127}));
  connect(pipe_return.outlet, Plant.inlet) annotation (Line(
      points={{-37,-68},{-46,-68},{-52,-68},{-52,-49.9},{-65.54,-49.9}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(Plant.outlet, pipe_feed.inlet) annotation (Line(
      points={{-65.54,-44.7667},{-50,-44.7667},{-50,-22},{-37,-22}},
      color={175,0,0},
      thickness=0.5));
connect(Ctrl_T_feed.y, Q_flow_set.u) annotation (Line(points={{-98.8,38},{-98.8,38},{-95.2,38}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestFirstOrderHeatingNetworkConsumer_withPlant.mat";

  output String resultFile;
algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
  createPlot(id=1, position={0, 0, 1616, 785}, y={"T_feed_set.y", "T_feed_is.y"}, range={0.0, 50000.0, 358.0, 374.0}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
  createPlot(id=1, position={0, 0, 1616, 259}, y={"ConsumerStation.m_flow.y"}, range={0.0, 50000.0, 1650.0, 2050.0}, grid=true, subPlot=2, colors={{28,108,200}}, filename=resultFileName);
  createPlot(id=1, position={0, 0, 1616, 258}, y={"Plant.Q_flow_is", "Q_th_demand.y"}, range={0.0, 50000.0, 0.0, 300000000.0}, autoscale=false, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}}, range2={0.201, 0.20350000000000001}, filename=resultFileName);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
equation
  connect(ConsumerStation.fluidPortIn, pipe_feed.outlet) annotation (Line(
      points={{28,-42},{10,-42},{10,-22},{-10,-22}},
      color={175,0,0},
      thickness=0.5));
  connect(ConsumerStation.fluidPortOut, pipe_return.inlet) annotation (Line(
      points={{28,-46},{10,-46},{10,-68},{-10,-68}},
      color={175,0,0},
      thickness=0.5));
  connect(Q_flow_set.y, Plant.Q_flow_set) annotation (Line(points={{-81.4,38},{-76,38},{-76,40},{-74,40},{-74,18},{-80.49,18},{-80.49,-23.1333}}, color={0,0,127}));
  connect(T_feed_is.y, Ctrl_T_feed.u_m) annotation (Line(points={{-117.1,12.5},{-112,12.5},{-112,23.6}}, color={0,0,127}));
  connect(T_feed_set.y, Ctrl_T_feed.u_s) annotation (Line(points={{-137,40},{-126.4,40},{-126.4,38}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{100,100}}), graphics={Text(
          extent={{-38,88},{50,26}},
          lineColor={0,140,72},
          textString="Consumer reduces Massflow 
when Feedline Temperature 
is raised. Look at:
T_feed_set
T_feed_is
ConsumerStation.T_in

Plant.inlet.m_flow

Plant.Q_flow_gen")}),
    experiment(StopTime=50000, Interval=20),
    __Dymola_experimentSetupOutput(equidistant=false),
    Icon(coordinateSystem(extent={{-160,-100},{100,100}})));
end TestFirstOrderHeatingNetworkConsumer_withPlant;
