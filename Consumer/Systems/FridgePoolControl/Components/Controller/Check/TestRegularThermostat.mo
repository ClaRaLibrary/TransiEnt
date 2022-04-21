within TransiEnt.Consumer.Systems.FridgePoolControl.Components.Controller.Check;
model TestRegularThermostat


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

  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

  parameter SI.Time tau = 2e4 "Time constant of plant (e.g. fridge)";
  parameter Real p = 50/tau "Power (e.g. cooling unit)";
  parameter SI.Temperature Tset = 273.15+5;
  parameter SI.Temperature Tamb = 300;
  parameter Real Delta_T = 2 "Temperature deadband";

  RegularThermostat regularThermostat(T_set=Tset, delta=Delta_T)
                                      annotation (Placement(transformation(extent={{-4,20},{16,40}})));
  Modelica.Blocks.Math.BooleanToReal cooler(realTrue=p, realFalse=0)
                                            annotation (Placement(transformation(extent={{26,20},{46,40}})));

  // state
  SI.Temperature T(start=Tset, fixed=true)  annotation (Dialog(group="Initialization", showStartAttribute=true));

equation
  // plant equation
  der(T) = 1/tau * (Tamb - T) - cooler.y;
  regularThermostat.T_is = T;
  connect(regularThermostat.q, cooler.u) annotation (Line(points={{16.2,30},{20.1,30},{24,30}}, color={255,0,255}));

public
function plotResult

  constant String resultFileName = "TestRegularThermostat.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
  createPlot(id=1, position={273, 41, 823, 729}, y={"T"}, range={0.0, 7500.0, 3.8000000000000003, 6.200000000000001}, grid=true, colors={{28,108,200}},filename=resultFile);
  createPlot(id=1, position={273, 41, 823, 362}, y={"regularThermostat.q"}, range={0.0, 7500.0, -0.1, 1.1}, grid=true, subPlot=2, colors={{28,108,200}},filename=resultFile);
  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the RegularThermostat model</p>
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
end TestRegularThermostat;
