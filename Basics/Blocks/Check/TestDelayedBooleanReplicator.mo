within TransiEnt.Basics.Blocks.Check;
model TestDelayedBooleanReplicator
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
extends Icons.Checkmodel;
  DelayedBooleanReplicator opstatus_4x15min_pred(samplePeriod=900, nout=opstatus_1h_pred.nout) annotation (Placement(transformation(extent={{-4,-4},{24,24}})));
  Sources.BooleanVectorExpression            opstatus_1h_pred(nout=2, y_set={true,time < 10000})
                                                                            annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
  Sources.BooleanVectorExpression            opstatus_now(nout=2, y_set={true,time < 10000 + 3600})
                                                                            annotation (Placement(transformation(extent={{-50,-38},{-30,-18}})));
equation
  connect(opstatus_1h_pred.y, opstatus_4x15min_pred.u) annotation (Line(points={{-29,10},{-6.8,10}}, color={255,0,255}));
public
function plotResult

  constant String resultFileName = "TestDelayedBooleanReplicator.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
    resultFile := TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
  createPlot(id=2, position={0, 0, 1396, 682}, y={"opstatus_now.y[1]", "opstatus_now.y[2]"}, range={0.0, 20000.0, -0.2, 1.2000000000000002}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
  createPlot(id=2, position={0, 0, 1396, 224}, y={"opstatus_1h_pred.y[2]"}, range={0.0, 20000.0, -0.2, 1.2000000000000002}, grid=true, subPlot=2, colors={{28,108,200}}, filename=resultFile);
  createPlot(id=2, position={0, 0, 1396, 223}, y={"opstatus_4x15min_pred.y[2, 1]", "opstatus_4x15min_pred.y[2, 2]",
  "opstatus_4x15min_pred.y[2, 3]", "opstatus_4x15min_pred.y[2, 4]",
  "opstatus_4x15min_pred.y[2, 5]"}, range={0.0, 20000.0, -0.5, 1.5}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}, {0,0,0}}, filename=resultFile);

    resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                                Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
    experiment(StopTime=20000, Interval=900),
    __Dymola_experimentSetupOutput);
end TestDelayedBooleanReplicator;
