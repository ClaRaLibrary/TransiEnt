within TransiEnt.Producer.Electrical.Others.Check;
model TestPumpedStoragePlant
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE and ResiliEntEE are research projects supported by the German     //
// Federal Ministry of Economics and Energy (FKZ 03ET4003 and 03ET4048).          //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Institute of Electrical Power Systems and Automation                           //
// (Hamburg University of Technology)                                             //
// and is supported by                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//
  extends TransiEnt.Basics.Icons.Checkmodel;

  PumpedStoragePlant PS_1(
    isSecondaryControlActive=false,
    isExternalSecondaryController=false,
    t_startup=200,
    P_el_n=80e6,
    P_init=40e6) annotation (Placement(transformation(extent={{-14,15},{6,35}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency Grid(useInputConnector=false) annotation (Placement(transformation(extent={{40,-33},{60,-13}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},
            {-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-60,80},
            {-40,100}})));
  Modelica.Blocks.Sources.TimeTable sched(table=[0,0.5; 350,0.5; 350,0.5; 720,0.5; 720,0.5; 3e3,0.5; 3000,0.5; 3001,0.5; 3002,0.5; 4e3,0.5; 4e3,0.2; 4500,0.2; 4500,0.2; 6000,0.2; 6000,0.7; 10e3,0.7; 10e3,0; 1.2e4,0; 1.2e4,-0.8; 2e4,-0.8; 2e4,-0.2; 2.5e4,-0.2]) annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Math.Gain P_set_plant_2(k=-PS_2.P_el_n) annotation (Placement(transformation(extent={{-52,-60},{-32,-40}})));
  PumpedStoragePlant PS_2(
    isSecondaryControlActive=false,
    isExternalSecondaryController=false,
    P_el_n=120e6,
    P_init=-60e6,
    t_startup=900) annotation (Placement(transformation(extent={{-12,-39},{8,-19}})));
  Modelica.Blocks.Math.Gain P_set_plant_1(k=PS_1.P_el_n) annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
equation

  connect(PS_1.epp, Grid.epp) annotation (Line(
      points={{5.5,30.6},{20,30.6},{20,-23.1},{39.9,-23.1}},
      color={0,135,135},
      thickness=0.5));
  connect(sched.y, P_set_plant_2.u) annotation (Line(points={{-79,30},{-58,30},{-58,-50},{-54,-50}}, color={0,0,127}));
  connect(PS_2.epp, Grid.epp) annotation (Line(
      points={{7.5,-23.4},{39.9,-23.4},{39.9,-23.1}},
      color={0,135,135},
      thickness=0.5));
  connect(P_set_plant_2.y, PS_2.P_el_set) annotation (Line(points={{-31,-50},{-28,-50},{-28,-14},{-3.5,-14},{-3.5,-19.1}}, color={0,0,127}));
  connect(sched.y, P_set_plant_1.u) annotation (Line(points={{-79,30},{-52,30},{-52,30}}, color={0,0,127}));
  connect(P_set_plant_1.y, PS_1.P_el_set) annotation (Line(points={{-29,30},{-24,30},{-24,46},{-5.5,46},{-5.5,34.9}}, color={0,0,127}));
public
    function plotResult

    constant String resultFileName = "TestPumpedStoragePlant.mat";

    output String resultFile;

    algorithm
    clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
    resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
    removePlots();
    createPlot(id=3, position={733, 0, 715, 842}, y={"PS_1.epp.P", "PS_1.P_el_set"}, range={0.0, 30000.0, -80000000.0, 60000000.0}, grid=true, filename=resultFileName, colors={{28,108,200}, {238,46,47}},filename=resultFile);
    createPlot(id=3, position={733, 0, 715, 418}, y={"PS_2.P_el_set", "PS_2.epp.P"}, range={0.0, 30000.0, -100000000.0, 100000000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}},filename=resultFile);
    resultFile := "Successfully plotted results for file: " + resultFile;

    end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{42,86},{90,22}},
          lineColor={0,0,0},
          textString="Look at:

P_set_plant_1.y
PS_1.epp.P

P_set_plant_2.y
PS_2.epp.P")}),
    experiment(StopTime=30000, Interval=60),
    __Dymola_experimentSetupOutput,
              __Dymola_Commands(executeCall = TransiEnt.Producer.Electrical.Others.Check.TestPumpedStoragePlant.plotResult() "Plot example results"));
end TestPumpedStoragePlant;
