within TransiEnt.Consumer.DemandSideManagement.PVBatteryPoolControl.Controller.Check;
model CheckPBPDispatcher
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

  PBPDispatcher pBPDispatcher(nout=4)
                              annotation (Placement(transformation(extent={{-8,52},{12,72}})));
  Modelica.Blocks.Sources.Step P_PBP_pool_set(
    height=1e6,
    offset=1e6,
    startTime=3*24*3600)
                      "A little bit earlier than after a week" annotation (Placement(transformation(extent={{-76,59},{-56,79}})));
  Modelica.Blocks.Sources.Clock clock
    annotation (Placement(transformation(extent={{-94,-54},{-74,-34}})));
  Modelica.Blocks.Discrete.ZeroOrderHold holdTradingDuration(samplePeriod=7.5*24*3600)
    annotation (Placement(transformation(extent={{-58,-54},{-38,-34}})));
  Modelica.Blocks.Math.RealToInteger realToInteger1
    annotation (Placement(transformation(extent={{-28,-54},{-8,-34}})));
  Modelica.Blocks.Sources.Cosine P_unit_offer1(
    amplitude=500e3,
    offset=500e3,
    freqHz=1/86400/2) annotation (Placement(transformation(extent={{-94,18},{-74,38}})));
  Modelica.Blocks.Sources.Cosine P_unit_offer2(
    offset=500e3,
    amplitude=300e3,
    freqHz=1/86400/2,
    phase=1.5707963267949) annotation (Placement(transformation(extent={{-54,18},{-34,38}})));
  Modelica.Blocks.Sources.Cosine P_unit_offer3(
    offset=500e3,
    amplitude=200e3,
    freqHz=1/86400/2) annotation (Placement(transformation(extent={{-94,-14},{-74,6}})));
  Modelica.Blocks.Sources.Cosine P_unit_offer4(
    offset=500e3,
    amplitude=600e3,
    freqHz=1/86400/2,
    phase=3.1415926535898) annotation (Placement(transformation(extent={{-54,-14},{-34,6}})));
equation

  connect(P_PBP_pool_set.y, pBPDispatcher.P_el_pbp_set) annotation (Line(points={{-55,69},{-55,69},{-8,69}},         color={0,0,127}));
  connect(clock.y, holdTradingDuration.u) annotation (Line(points={{-73,-44},{-60,-44}}, color={0,0,127}));
  connect(holdTradingDuration.y, realToInteger1.u) annotation (Line(points={{-37,-44},{-30,-44}}, color={0,0,127}));
  connect(realToInteger1.y, pBPDispatcher.communicationTrigger) annotation (Line(points={{-7,-44},{2,-44},{2,-40},{2,51.4}}, color={255,127,0}));
  connect(P_unit_offer1.y, pBPDispatcher.P_el_PBP_offer[1]) annotation (Line(points={{-73,28},{-66,28},{-66,48},{-38,48},{-38,59.5},{-8,59.5}}, color={0,0,127}));
  connect(P_unit_offer2.y, pBPDispatcher.P_el_PBP_offer[2]) annotation (Line(points={{-33,28},{-26,28},{-26,60.5},{-8,60.5}}, color={0,0,127}));
  connect(P_unit_offer3.y, pBPDispatcher.P_el_PBP_offer[3]) annotation (Line(points={{-73,-4},{-66,-4},{-66,48},{-38,48},{-38,61.5},{-8,61.5}}, color={0,0,127}));
  connect(P_unit_offer4.y, pBPDispatcher.P_el_PBP_offer[4]) annotation (Line(points={{-33,-4},{-26,-4},{-26,62.5},{-8,62.5}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "CheckPBPDispatcher.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={0, 0, 1616, 851}, y={"P_unit_offer1.y", "P_unit_offer2.y", "P_unit_offer3.y", "P_unit_offer4.y"}, range={0.0, 14.5, -200000.0, 1200000.0}, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}},filename=resultFile);
createPlot(id=1, position={0, 0, 1616, 281}, y={"P_PBP_pool_set.y", "pBPDispatcher.P_el_PBP_setpoints[1]", "pBPDispatcher.P_el_PBP_setpoints[2]",
 "pBPDispatcher.P_el_PBP_setpoints[3]", "pBPDispatcher.P_el_PBP_setpoints[4]"}, range={0.0, 14.5, -500000.0, 2500000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}, {0,0,0}}, patterns={LinePattern.Solid, LinePattern.Dash, LinePattern.Solid, LinePattern.Solid,
LinePattern.Solid}, thicknesses={0.25, 0.5, 0.5, 0.5, 0.25},filename=resultFile);
createPlot(id=1, position={0, 0, 1616, 280}, y={"pBPDispatcher.merit_order[1]", "pBPDispatcher.merit_order[2]"}, range={0.0, 14.5, 0.5, 3.5}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}},filename=resultFile);

  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                       Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
  experiment(StopTime=1.2096e+006, __Dymola_Algorithm="Dassl"),
  __Dymola_experimentSetupOutput(
    events=false));
end CheckPBPDispatcher;
