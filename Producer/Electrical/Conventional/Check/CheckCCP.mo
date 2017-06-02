within TransiEnt.Producer.Electrical.Conventional.Check;
model CheckCCP
  import TransiEnt;
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
  TransiEnt.Producer.Electrical.Conventional.Gasturbine gasturbine(
    isSecondaryControlActive=false,
    isExternalSecondaryController=false,
    P_init=0,
    Turbine(redeclare TransiEnt.Components.Turbogroups.OperatingStates.ThreeStateDynamic operationStatus, T_plant=300),
    P_el_n=280e6,
    t_startup=300) annotation (Placement(transformation(extent={{-24,0},{-4,20}})));
  Modelica.Blocks.Sources.TimeTable timeTable(table=[0,0; 0,-219.24e6; 10800,-219.24e6;
        10800,-406e6; 14400,-406e6; 14400,-304.5e6; 18000,-304.5e6; 18000,-219.24e6;
        21600,-219.24e6; 21600,-304.5e6; 25200,-304.5e6; 25200,-406e6; 28800,-406e6;
        28800,-182.7e6; 32400,-182.7e6; 32400,-406e6; 36000,-406e6; 36000,-162.4e6;
        39600,-162.4e6; 39600,-406e6; 43200,-406e6; 43200,-121.8e6; 46800,-121.8e6;
        46800,-406e6; 50400,-406e6])
    annotation (Placement(transformation(extent={{-90,32},{-70,52}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency constantFrequency_L1_1(useInputConnector=false) annotation (Placement(transformation(extent={{38,6},{58,26}})));
  TransiEnt.Producer.Electrical.Conventional.CCP CCP(
    isPrimaryControlActive=false,
    isSecondaryControlActive=false,
    isExternalSecondaryController=false,
    P_init=0,
    P_el_n=406e6,
    Turbine(redeclare TransiEnt.Components.Turbogroups.OperatingStates.ThreeStateDynamic operationStatus, T_plant=300),
    eta_total=0.603,
    t_startup=300) annotation (Placement(transformation(extent={{-22,-40},{-2,-20}})));
  Modelica.Blocks.Math.Gain gain(k=0.63)
    annotation (Placement(transformation(extent={{-40,32},{-20,52}})));
equation
  connect(gasturbine.epp, constantFrequency_L1_1.epp) annotation (Line(
      points={{-4.5,15.6},{37.9,15.6},{37.9,15.9}},
      color={0,135,135},
      thickness=0.5));
  connect(timeTable.y, CCP.P_el_set) annotation (Line(points={{-69,42},{-56,42},
          {-56,-14},{-13.5,-14},{-13.5,-20.1}}, color={0,0,127}));
  connect(CCP.epp, constantFrequency_L1_1.epp) annotation (Line(
      points={{-2.5,-24.4},{10,-24.4},{10,16},{37.9,15.6},{37.9,15.9}},
      color={0,135,135},
      thickness=0.5));
  connect(gain.u, CCP.P_el_set) annotation (Line(points={{-42,42},{-56,42},{-56,
          -14},{-13.5,-14},{-13.5,-20.1}}, color={0,0,127}));
  connect(gain.y, gasturbine.P_el_set) annotation (Line(points={{-19,42},{-15.5,
          42},{-15.5,19.9}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "CheckCCP.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={809, 0, 791, 733}, y={"gasturbine.epp.P", "gasturbine.P_el_set"}, range={0.0, 100.0, -160000000.0, 20000000.0}, grid=true, colors={{28,108,200}, {238,46,47}},filename=resultFile);
createPlot(id=1, position={809, 0, 791, 364}, y={"CCP.epp.P", "CCP.P_el_set"}, range={0.0, 100.0, -250000000.0, 50000000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}},filename=resultFile);
  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-20,104},{90,42}},
          lineColor={28,108,200},
          textString="Comparison with
https://www.vgb.org/vgbmultimedia/333_Abschlussbericht-p-5968.pdf
Seite 228, Abbildung 19.14

Look at:
P_el_set
CCP.epp.P
gasturbine.epp.P")}), experiment(StopTime=55000));
end CheckCCP;
