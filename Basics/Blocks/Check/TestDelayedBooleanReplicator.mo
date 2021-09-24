within TransiEnt.Basics.Blocks.Check;
model TestDelayedBooleanReplicator "Model for testing the model BooleanReplicator"

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-BSD-clause.           //
// Copyright 2021, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE, ResiliEntEE, IntegraNet and IntegraNet II are research projects  //
// supported by the German Federal Ministry of Economics and Energy               //
// (FKZ 03ET4003, 03ET4048, 0324027 and 03EI1008).                                //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Fraunhofer Institute for Environmental, Safety, and Energy Technology UMSICHT, //
// Gas- und Wärme-Institut Essen						  //
// and                                                                            //
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
function plotResult "Function for plotting the result of the test"

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

    annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Funktion for the plot result</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end plotResult;
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                                Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
    experiment(StopTime=20000, Interval=900),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Test environment for WeekendPulse</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
</html>"));
end TestDelayedBooleanReplicator;
