within TransiEnt.Producer.Electrical.Photovoltaics.Check;
model Check_DataSheetBasedPV
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
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency ElectricGrid1 annotation (Placement(transformation(extent={{42,-10},{62,10}})));
public
function plotResult

  constant String resultFileName = "Check_DataSheetBasedPV.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={809, 0, 791, 695}, y={"step.y", "photovoltaicPlant.epp.P"}, range={0.0, 300.0, 9995000.0, 10105000.0}, grid=true, colors={{28,108,200}, {238,46,47}},filename=resultFile);
  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  Modelica.Blocks.Sources.Step step(
    offset=1e7,
    startTime=100,
    height=1e5) annotation (Placement(transformation(extent={{-76,22},{-56,42}})));
  DataSheetBasedPV dataSheetBasedPV annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
equation
  connect(dataSheetBasedPV.epp, ElectricGrid1.epp) annotation (Line(
      points={{0,0},{41.9,0},{41.9,-0.1}},
      color={0,135,135},
      thickness=0.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=300, Interval=3600),
    __Dymola_experimentSetupOutput(events=false));
end Check_DataSheetBasedPV;
