within TransiEnt.Producer.Electrical.Base.Check;
model TestPowerPlant
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
  TransiEnt.Components.Boundaries.Electrical.Frequency constantFrequency_L1_1(useInputConnector=false) annotation (Placement(transformation(extent={{20,12},{40,32}})));
  Modelica.Blocks.Sources.Constant const(k=-1e7)
    annotation (Placement(transformation(extent={{-92,42},{-72,62}})));
  TransiEnt.Producer.Electrical.Conventional.Components.SimplePowerPlant inertContinuousPBPlant annotation (Placement(transformation(extent={{-40,16},{-20,36}})));
equation

  connect(const.y, inertContinuousPBPlant.P_el_set) annotation (Line(points={{
          -71,52},{-31.5,52},{-31.5,35.9}}, color={0,0,127}));
  connect(inertContinuousPBPlant.epp, constantFrequency_L1_1.epp) annotation (
      Line(
      points={{-20.5,31.6},{8,31.6},{8,21.9},{19.9,21.9}},
      color={0,135,135},
      thickness=0.5));
public
function plotResult

  constant String resultFileName = "TestPowerPlant.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={809, 0, 791, 733}, y={"inertContinuousPBPlant.epp.P"}, range={0.0, 100.0, -11200000.0, -8800000.0}, grid=true, colors={{28,108,200}}, filename=resultFile);
createPlot(id=1, position={809, 0, 791, 364}, y={"inertContinuousPBPlant.epp.f"}, range={0.0, 100.0, 44.0, 56.0}, grid=true, subPlot=2, colors={{28,108,200}}, filename=resultFile);

    resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end TestPowerPlant;
