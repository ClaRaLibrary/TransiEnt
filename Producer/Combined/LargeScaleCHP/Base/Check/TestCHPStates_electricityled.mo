within TransiEnt.Producer.Combined.LargeScaleCHP.Base.Check;
model TestCHPStates_electricityled "Example how the continuous plant model behaves when ramping up"
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

  CHPStates_electricityled CHP_initOffBlocked(
    t_startup=3600,
    init_state=TransiEnt.Basics.Types.off,
    P_el_min_operating=0.5e8,
    P_el_max_operating=1e8,
    t_MDT=1800) annotation (Placement(transformation(extent={{-12,28},{12,52}})));
  CHPStates_electricityled CHP_initOffReady(
    t_startup=3600,
    init_state=TransiEnt.Basics.Types.on2,
    P_el_min_operating=0.5e8,
    P_el_max_operating=1e8,
    t_MDT=1800) annotation (Placement(transformation(extent={{-12,-12},{12,12}})));
  CHPStates_electricityled CHP_initOn(
    t_startup=3600,
    init_state=TransiEnt.Basics.Types.on1,
    P_el_min_operating=0.5e8,
    P_el_max_operating=1e8,
    t_MDT=1800) annotation (Placement(transformation(extent={{-12,-52},{12,-28}})));

  Modelica.Blocks.Sources.Step step(          startTime=0, height=1e8)
                                                             annotation (Placement(transformation(extent={{-84,-10},{-64,10}})));
equation
  connect(step.y, CHP_initOffReady.P_el_set) annotation (Line(points={{-63,0},{-12,0}}, color={0,0,127}));
  connect(step.y, CHP_initOffBlocked.P_el_set) annotation (Line(points={{-63,0},{-42,0},{-42,40},{-12,40}}, color={0,0,127}));
  connect(step.y, CHP_initOn.P_el_set) annotation (Line(points={{-63,0},{-42,0},{-42,-40},{-12,-40}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestCHPStates_electricityled.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=2, position={809, 0, 791, 817}, y={"CHP_initOffBlocked.P_el_set", "CHP_initOffBlocked.P_el_set_lim"}, range={0.0, 7500.0, -50000000.0, 150000000.0}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=2, position={809, 0, 791, 200}, y={"CHP_initOffReady.P_el_set", "CHP_initOffReady.P_el_set_lim"}, range={0.0, 7500.0, -50000000.0, 150000000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=2, position={809, 0, 791, 201}, y={"CHP_initOn.P_el_set", "CHP_initOn.P_el_set_lim"}, range={0.0, 7500.0, 80000000.0, 120000000.0}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=2, position={809, 0, 791, 200}, y={"CHP_initOffBlocked.startup.active", "CHP_initOffReady.startup.active",
"CHP_initOn.startup.active"}, range={0.0, 7500.0, -0.5, 1.5}, grid=true, subPlot=4, colors={{28,108,200}, {238,46,47}, {0,140,72}}, filename=resultFileName);

  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (experiment(StopTime=7200));
end TestCHPStates_electricityled;
