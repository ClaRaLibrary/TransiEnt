within TransiEnt.Producer.Electrical.Conventional.Check;
model CheckBlackCoal
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
BlackCoal blackCoal(
  isPrimaryControlActive=false,
  P_el_n=506e6,
  eta_total=0.432,
  T_plant=200,
  P_init=0,
  isSecondaryControlActive=false,
  isExternalSecondaryController=false) annotation (Placement(transformation(extent={{-24,-64},{-4,-44}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency constantFrequency_L1_1(useInputConnector=false) annotation (Placement(transformation(extent={{32,-58},{52,-38}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},
            {-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.TimeTable timeTable(table=[0,0; 0,-202.4e6; 4800,-202.4e6;
        4800,-253e6; 8700,-253e6; 8700,-328.9e6; 13200,-328.9e6; 13200,-480.7e6;
        15000,-480.7e6])
    annotation (Placement(transformation(extent={{-56,-38},{-36,-18}})));
equation
  connect(blackCoal.epp, constantFrequency_L1_1.epp) annotation (Line(
      points={{-4.5,-48.4},{31.9,-48.4},{31.9,-48.1}},
      color={0,135,135},
      thickness=0.5));
  connect(timeTable.y, blackCoal.P_el_set) annotation (Line(points={{-35,-28},{-15.5,
          -28},{-15.5,-44.1}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "CheckBlackCoal.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={809, 0, 791, 733}, y={"blackCoal.epp.P", "blackCoal.P_el_set"}, range={0.0, 100.0, -220000000.0, 20000000.0}, grid=true, colors={{28,108,200}, {238,46,47}},filename=resultFile);
  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), experiment(StopTime=55000));
end CheckBlackCoal;