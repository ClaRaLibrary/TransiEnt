within TransiEnt.Storage.Electrical.Check;
model TestFlywheelDischarge "Example to evaluate self discharge time"
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

  TransiEnt.Storage.Electrical.FlywheelStorage_L2 flywheelElectricStorage(K=2000000000, params=Specifications.DetailedFlywheel.Rotokinetik1000()) annotation (Placement(transformation(extent={{-50,-40},{-14,-4}})));
  inner TransiEnt.SimCenter simCenter
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  TransiEnt.Components.Boundaries.Electrical.Power constantPowerBoundary(useInputConnectorP=false) annotation (Placement(transformation(extent={{28,-38},{58,-6}})));
equation
  connect(constantPowerBoundary.epp, flywheelElectricStorage.epp) annotation (
      Line(
      points={{28,-22},{-7.05,-22},{-7.05,-22},{-14,-22}},
      color={0,0,0},
      smooth=Smooth.None));

public
function plotResult

  constant String resultFileName = "TestFlywheelDischarge.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 695}, y={"flywheelElectricStorage.epp.P"}, range={0.0, 3600.0, -1.5, 1.5}, grid=true, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 345}, y={"flywheelElectricStorage.SOC"}, range={0.0, 3600.0, 0.9550000000000001, 1.0050000000000001}, grid=true, subPlot=2, colors={{28,108,200}}, filename=resultFileName);
   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=3600, Interval=5),
    __Dymola_experimentSetupOutput(events=false));
end TestFlywheelDischarge;
