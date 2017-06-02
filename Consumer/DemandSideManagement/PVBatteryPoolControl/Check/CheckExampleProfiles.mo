within TransiEnt.Consumer.DemandSideManagement.PVBatteryPoolControl.Check;
model CheckExampleProfiles
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

  Basics.Tables.GenericDataTable loadProfiles(
    relativepath="electricity/ElectricDemandSingleHouseTypicalProfiles.txt",
    multiple_outputs=true,
    columns=2:6) annotation (Placement(transformation(extent={{-12,24},{8,44}})));
  Basics.Tables.GenericDataTable pvProfiles(
    relativepath="electricity/PhotovoltaicSingleHouseTypicalProfiles.txt",
    multiple_outputs=true,
    columns=2:5) annotation (Placement(transformation(extent={{-12,-14},{8,6}})));
  Modelica.Blocks.Math.Gain P_Load[5](k=(2500:500:4500).*3.6e6) annotation (Placement(transformation(extent={{20,28},{32,40}})));
  Modelica.Blocks.Math.Gain P_PV[4](k=(1:0.5:2.5)*1e3) annotation (Placement(transformation(extent={{22,-10},{34,2}})));
equation
  connect(pvProfiles.y[1:4], P_PV[1:4].u) annotation (Line(points={{9,-4},{20.8,-4},{20.8,-4}}, color={0,0,127}));
  connect(loadProfiles.y[1:5], P_Load[1:5].u) annotation (Line(points={{9,34},{18.8,34},{18.8,34}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "CheckExampleProfiles.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
  createPlot(id=1, position={0, 0, 1371, 670}, y={"P_Load[1].y", "P_Load[2].y", "P_Load[3].y", "P_Load[4].y", "P_Load[5].y"}, range={0.0, 88000.0, 0.0, 3000.0}, grid=true, legends={"", "", "", "", "P_Load[5].y (in W)"}, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}, {0,0,0}},filename=resultFile);
  createPlot(id=1, position={0, 0, 1371, 332}, y={"P_PV[1].y", "P_PV[2].y", "P_PV[3].y", "P_PV[4].y"}, range={0.0, 88000.0, -20.0, 180.0}, grid=true, legends={"P_PV[1].y in kW", "P_PV[2].y in kW", "P_PV[3].y in kW", "P_PV[4].y in kW"}, subPlot=2, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}},filename=resultFile);

  resultFile := "Successfully plotted results for file: " + resultFile;

    annotation (experiment(StopTime=7200, __Dymola_Algorithm="Dassl"), __Dymola_experimentSetupOutput(events=false));
end plotResult;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
  experiment(StopTime=5.22547e+010, __Dymola_Algorithm="Dassl"),
  __Dymola_experimentSetupOutput);
end CheckExampleProfiles;
