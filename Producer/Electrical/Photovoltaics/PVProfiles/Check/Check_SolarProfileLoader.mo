within TransiEnt.Producer.Electrical.Photovoltaics.PVProfiles.Check;
model Check_SolarProfileLoader
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
  TransiEnt.Components.Boundaries.Electrical.Power SolarGenerationPark annotation (choicesAllMatching=true, Placement(transformation(extent={{-19,-2},{-39,18}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency ElectricGrid annotation (Placement(transformation(extent={{22,-2},{42,18}})));
  SolarProfileLoader solarProfileLoader(
    change_of_sign=true,
    REProfile=TransiEnt.Producer.Electrical.Photovoltaics.PVProfiles.SolarData.Solar2011_Gesamt_900s,
    P_el_n=1e6) annotation (Placement(transformation(extent={{-72,36},{-52,56}})));
equation
  connect(ElectricGrid.epp, SolarGenerationPark.epp) annotation (Line(
      points={{21.9,7.9},{21.9,7.9},{-18.9,7.9}},
      color={0,135,135},
      thickness=0.5));
  connect(solarProfileLoader.y1, SolarGenerationPark.P_el_set) annotation (Line(points={{-51,46},{-23,46},{-23,20}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "Check_SolarProfileLoader.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=3, position={809, 0, 791, 695}, y={"SolarGenerationPark.P_el_set", "SolarGenerationPark.epp.P"}, range={0.0, 2000000.0, -300000.0, 20000.0}, autoscale=false, grid=true, colors={{28,108,200}, {238,46,47}}, range2={0.46, 0.92},filename=resultFile);
  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=3.154e+007, Interval=900),
    __Dymola_experimentSetupOutput);
end Check_SolarProfileLoader;
