within TransiEnt.Storage.Electrical.Base.Check;
model TestBatteryEfficiency
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

  BatterySystemEfficiency calcCellVariables annotation (Placement(transformation(extent={{-2,-12},{40,26}})));
  inner TransiEnt.Consumer.DemandSideManagement.PVBatteryPoolControl.Base.PoolParameter param(E_max_bat=1760*0.5*3600, SOC_start=0) annotation (Placement(transformation(extent={{-100,64},{-64,100}})));
  Modelica.Blocks.Sources.Ramp P_el_set(duration=1000, height=1.2*param.P_el_max_bat)
                  annotation (Placement(transformation(extent={{-58,-4},{-38,16}})));
public
function plotResult

  constant String resultFileName = "TestBatteryEfficiency.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

  createPlot(id=1, position={0, 0, 1376, 660}, x="P_el_set.y", y={"calcCellVariables.eta", "calcCellVariables.eta_max", "calcCellVariables.eta_min"}, range={0.0, 0.6, -0.05, 1.05}, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}},filename=resultFile);

  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
equation
  connect(P_el_set.y, calcCellVariables.P_is) annotation (Line(points={{-37,6},{-2,6},{-2,7}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=2500));
end TestBatteryEfficiency;
