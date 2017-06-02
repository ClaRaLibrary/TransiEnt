within TransiEnt.Components.Boundaries.Heat.Check;
model Test_Heatflow_L2

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Checkmodel;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi pressureSink(
    m_flow_nom=1,
    Delta_p=1000,
    p_const=simCenter.p_n[1],
    T_const(displayUnit="degC") = 323.15)
                              annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={72,-28})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_Txim_flow massFlowSource(
    m_flow_nom=0,
    m_flow_const=1,
    p_nom=simCenter.p_n[2],
    T_const(displayUnit="degC") = 343.15)
                     annotation (Placement(transformation(extent={{-70,-38},{-50,-18}})));
  TransiEnt.Components.Boundaries.Heat.Heatflow_L2 heatflow(
    use_Q_flow_in=false,
    Q_flow_const=80e3,
    initOption=1,
    T_start=323.15) annotation (Placement(transformation(extent={{-23,-28},{36,28}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_out(unitOption=2)
                                                                annotation (Placement(transformation(extent={{60,-66},{80,-46}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_in(unitOption=2)
                                                               annotation (Placement(transformation(extent={{-70,-66},{-50,-46}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(massFlowSource.steam_a, heatflow.fluidPortIn) annotation (Line(
      points={{-50,-28},{-12,-28},{-12,-27.44},{-15.33,-27.44}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pressureSink.steam_a, heatflow.fluidPortOut) annotation (Line(
      points={{62,-28},{62,-27.44},{31.87,-27.44}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(temperatureSensor_in.port, heatflow.fluidPortIn) annotation (Line(
      points={{-60,-66},{-15.33,-66},{-15.33,-27.44}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  connect(temperatureSensor_out.port, heatflow.fluidPortOut) annotation (Line(
      points={{70,-66},{31.87,-66},{31.87,-27.44}},
      color={0,131,169},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=10),
    __Dymola_experimentSetupOutput);
end Test_Heatflow_L2;
