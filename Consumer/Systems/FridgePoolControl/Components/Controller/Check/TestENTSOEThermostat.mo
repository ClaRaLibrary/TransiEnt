within TransiEnt.Consumer.Systems.FridgePoolControl.Components.Controller.Check;
model TestENTSOEThermostat
  import TransiEnt;


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

  ENTSOEThermostat thermostat(T_set=Tset, delta=Delta_T) annotation (Placement(transformation(extent={{-4,20},{16,40}})));
  ENTSOEThermostat thermostat_gridDist(T_set=Tset, delta=Delta_T) annotation (Placement(transformation(extent={{-6,-46},{14,-26}})));

  Modelica.Blocks.Math.BooleanToReal cooler(realTrue=p, realFalse=0)
                                            annotation (Placement(transformation(extent={{26,20},{46,40}})));
  Modelica.Blocks.Math.BooleanToReal cooler_gridDist(
                                            realTrue=p, realFalse=0)
                                            annotation (Placement(transformation(extent={{24,-46},{44,-26}})));
  // state
  SI.Temperature T(start=Tset, fixed=true)  annotation (Dialog(group="Initialization", showStartAttribute=true));
  SI.Temperature T_gridDist(start=Tset, fixed=true)  annotation (Dialog(group="Initialization", showStartAttribute=true));

  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid(useInputConnector=false) annotation (Placement(transformation(extent={{-8,42},{-28,62}})));

  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid_gridDist(useInputConnector=true) annotation (Placement(transformation(extent={{-10,-24},{-30,-4}})));
  Modelica.Blocks.Sources.TimeTable f_grid1(table=[0,49.8; 2890,49.8; 2920,50.0; 3820,50.0])                                                                                                                                                                                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-42,6})));
equation
  // plant equation
  der(T) = 1/tau * (Tamb - T) - cooler.y;
  thermostat.T_is = T;

  der(T_gridDist) = 1/tau * (Tamb - T) - cooler_gridDist.y;
  thermostat_gridDist.T_is = T;

  connect(ElectricGrid.epp, thermostat.epp) annotation (Line(
      points={{-8,52},{6.25,52},{6.25,39.8}},
      color={0,135,135},
      thickness=0.5));
  connect(ElectricGrid_gridDist.epp, thermostat_gridDist.epp) annotation (Line(
      points={{-10,-14},{4.25,-14},{4.25,-26.2}},
      color={0,135,135},
      thickness=0.5));
  connect(thermostat_gridDist.q, cooler_gridDist.u) annotation (Line(points={{14.2,-36},{22,-36},{22,-36}}, color={255,0,255}));
  connect(thermostat.q, cooler.u) annotation (Line(points={{16.2,30},{20.1,30},{24,30}}, color={255,0,255}));
connect(f_grid1.y, ElectricGrid_gridDist.f_set) annotation (Line(points={{-31,6},{-14.6,6},{-14.6,-2}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestENTSOEThermostat.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
  createPlot(id=1, position={273, 41, 823, 729}, y={"T", "T_gridDist"}, range={0.0, 7500.0, 3.0, 10.0}, grid=true, colors={{28,108,200}, {238,46,47}},filename=resultFile);
  createPlot(id=1, position={273, 41, 823, 239}, y={"thermostat.q", "thermostat_gridDist.q"}, range={0.0, 7500.0, -0.2, 1.2000000000000002}, grid=true, subPlot=2, colors={{28,108,200}, {28,108,200}},filename=resultFile);
  createPlot(id=1, position={273, 41, 823, 240}, y={"f_grid1.y"}, range={0.0, 7500.0, 49.75, 50.1}, grid=true, subPlot=3, colors={{28,108,200}},filename=resultFile);
  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the ENTOSOETThermostat</p>
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
end TestENTSOEThermostat;
