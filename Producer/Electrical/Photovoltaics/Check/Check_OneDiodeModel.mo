within TransiEnt.Producer.Electrical.Photovoltaics.Check;
model Check_OneDiodeModel


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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




  extends TransiEnt.Basics.Icons.Checkmodel;
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
public
function plotResult

  constant String resultFileName = "Check_OneDiodeModel.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={809, 0, 791, 695}, y={"powerSensor.power"}, range={0.0, 300.0, 50.0, 64.0}, grid=true, colors={{28,108,200}},filename=resultFile);
createPlot(id=1, position={809, 0, 791, 345}, y={"oneDiodeModel.pin_p.v"}, range={0.0, 300.0, 15.0, 19.0}, grid=true, subPlot=2, colors={{28,108,200}},filename=resultFile);
  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  Modelica.Blocks.Sources.Constant step(k=1e5) annotation (Placement(transformation(extent={{-76,22},{-56,42}})));
  OneDiodeModel oneDiodeModel annotation (Placement(transformation(extent={{-22,-10},{-2,10}})));
  Modelica.Electrical.Analog.Basic.Resistor resistor(R=5) annotation (Placement(transformation(extent={{56,-2},{76,18}})));
  Modelica.Electrical.Analog.Sensors.PowerSensor powerSensor annotation (Placement(transformation(extent={{24,-2},{44,18}})));
equation
  connect(step.y, oneDiodeModel.u) annotation (Line(points={{-55,32},{-40,32},{-40,0},{-22,0}}, color={0,0,127}));
  connect(resistor.n, oneDiodeModel.pin_n) annotation (Line(points={{76,8},{76,-4.6},{-2,-4.6}}, color={0,0,255}));
  connect(powerSensor.nc, resistor.p) annotation (Line(points={{44,8},{50,8},{56,8}}, color={0,0,255}));
  connect(powerSensor.pc, oneDiodeModel.pin_p) annotation (Line(points={{24,8},{-2,8},{-2,5}}, color={0,0,255}));
  connect(powerSensor.pv, resistor.p) annotation (Line(points={{34,18},{56,18},{56,8}}, color={0,0,255}));
  connect(powerSensor.nv, resistor.n) annotation (Line(points={{34,-2},{76,-2},{76,8}}, color={0,0,255}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=300, Interval=3600),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the OneDiodeModel</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
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
end Check_OneDiodeModel;
