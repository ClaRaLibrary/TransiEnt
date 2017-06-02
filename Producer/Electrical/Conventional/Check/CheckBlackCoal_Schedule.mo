within TransiEnt.Producer.Electrical.Conventional.Check;
model CheckBlackCoal_Schedule
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
  P_init=0,
  isSecondaryControlActive=false,
  isExternalSecondaryController=false,
  t_startup=2700,
  Turbine(T_plant=500, redeclare TransiEnt.Components.Turbogroups.OperatingStates.ThreeStateDynamic operationStatus),
  P_grad_max_star=0.04/60) annotation (Placement(transformation(extent={{-14,-38},{6,-18}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency constantFrequency_L1_1(useInputConnector=false) annotation (Placement(transformation(extent={{40,-32},{60,-12}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},
            {-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.TimeTable timeTable(table=[0,0; 0,-253e6; 10800,-253e6;
        10800,-506e6; 14400,-506e6; 14400,-379.5e6; 18000,-379.5e6; 18000,-253e6;
        21600,-253e6; 21600,-379.5e6; 25200,-379.5e6; 25200,-506e6; 28800,-506e6;
        28800,-187.22e6; 36000,-187.22e6; 36000,-506e6; 39600,-506e6; 39600,-253e6;
        43200,-253e6; 43200,-151.8e6; 50400,-151.8e6; 50400,-253e6; 54000,-253e6])
    annotation (Placement(transformation(extent={{-58,18},{-38,38}})));
equation
  connect(blackCoal.epp, constantFrequency_L1_1.epp) annotation (Line(
      points={{5.5,-22.4},{39.9,-22.4},{39.9,-22.1}},
      color={0,135,135},
      thickness=0.5));
  connect(timeTable.y, blackCoal.P_el_set) annotation (Line(points={{-37,28},{-22,
          28},{-5.5,28},{-5.5,-18.1}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "CheckBlackCoal_Schedule.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={809, 0, 791, 733}, y={"blackCoal.P_el_set", "blackCoal.epp.P"}, range={0.0, 56000.0, -550000000.0, 50000000.0}, grid=true, colors={{28,108,200}, {238,46,47}},filename=resultFile);
  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-30,94},{80,32}},
          lineColor={28,108,200},
          textString="Vergleich mit:
https://www.vgb.org/vgbmultimedia/333_Abschlussbericht-p-5968.pdf
Seite 220, Abbildung 19.3


Look at:
P_el_set
blackCoal.epp.P")}), experiment(StopTime=55000));
end CheckBlackCoal_Schedule;
