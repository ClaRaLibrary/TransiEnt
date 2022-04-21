within TransiEnt.Consumer.Systems.PVBatteryPoolControl.Controller.Check;
model CheckBatteryPrimaryBalancingController "Tester for BatteryPrimaryBalancingController"


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

model Unit "Unit model just for this tester"
  extends TransiEnt.Basics.Icons.Model;
  Base.PoolControlBus bus annotation (Placement(transformation(extent={{-14,-14},{16,16}})));
  Modelica.Blocks.Interfaces.RealInput value=0.5+0.5*cos(2*3.14*time/3600);

equation
  connect(bus.SOC[1], value);
    annotation (Documentation(info="<html>
</html>"));
end Unit;

  inner Base.PoolParameter param(nSystems=1, SOC_min=0.2) annotation (Placement(transformation(extent={{52,68},{82,98}})));

function plotResult

  constant String resultFileName = "CheckBatteryPrimaryBalancingController.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
  createPlot(id=1, position={0, 0, 793, 817}, y={"delta_f_grid.y", "batteryPrimaryBalancingController.P_PBP_set.delta_f_db"}, range={0.0, 3600.0, -0.2, 0.2}, grid=true, colors={{28,108,200}, {238,46,47}},filename=resultFile);
  createPlot(id=1, position={0, 0, 793, 200}, y={"batteryPrimaryBalancingController.P_el_pbp_set", "P_PBP_bandwidth.y"}, range={0.0, 3600.0, -1000000.0, 1500000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}},filename=resultFile);
  createPlot(id=1, position={0, 0, 793, 201}, y={"SOC_is.y"}, range={0.0, 3600.0, -0.5, 1.5}, grid=true, subPlot=3, colors={{28,108,200}},filename=resultFile);
  createPlot(id=1, position={0, 0, 793, 200}, y={"batteryPrimaryBalancingController.loadRequestAndLowSOC.y"}, range={0.0, 3600.0, -0.5, 1.5}, grid=true, subPlot=4, colors={{28,108,200}},filename=resultFile);

  resultFile := "Successfully plotted results for file: " + resultFile;

    annotation (experiment(StopTime=7200, __Dymola_Algorithm="Dassl"), __Dymola_experimentSetupOutput(events=false));
end plotResult;
  BatteryPrimaryBalancingController batteryPrimaryBalancingController(k_loading=2.5, P_n=param.P_el_pbp_total) annotation (Placement(transformation(extent={{2,2},{52,46}})));
  Modelica.Blocks.Sources.Cosine f_grid_is(
    amplitude=0.1,
    phase=1.5707963267949,
    offset=50,
    f=1/1800) annotation (Placement(transformation(extent={{-80,32},{-60,52}})));
  Modelica.Blocks.Sources.Ramp SOC_is(
    height=-1,
    duration=3600,
    offset=1) annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Modelica.Blocks.Sources.Constant P_PBP_bandwidth(k=1e6) annotation (Placement(transformation(extent={{-80,-62},{-60,-42}})));
  Modelica.Blocks.Math.Feedback delta_f_grid annotation (Placement(transformation(extent={{-54,32},{-34,52}})));
  Modelica.Blocks.Sources.Constant f_grid_nom(k=50)  annotation (Placement(transformation(extent={{-80,2},{-60,22}})));
equation
  connect(SOC_is.y, batteryPrimaryBalancingController.SOC) annotation (Line(points={{-59,-20},{-28,-20},{-28,24},{2,24}}, color={0,0,127}));
  connect(P_PBP_bandwidth.y, batteryPrimaryBalancingController.P_el_pbp_band_set) annotation (Line(points={{-59,-52},{-20,-52},{-20,6.4},{2,6.4}}, color={0,0,127}));
  connect(f_grid_is.y, delta_f_grid.u1) annotation (Line(points={{-59,42},{-52,42}}, color={0,0,127}));
  connect(f_grid_nom.y, delta_f_grid.u2) annotation (Line(points={{-59,12},{-44,12},{-44,34}}, color={0,0,127}));
  connect(batteryPrimaryBalancingController.delta_f, delta_f_grid.y) annotation (Line(points={{2,41.6},{-35,41.6},{-35,42}}, color={0,0,127}));
annotation (Diagram(graphics,
                    coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                       Icon(graphics,
                                            coordinateSystem(extent={{-100,-100},{100,100}})),
  experiment(StopTime=3600, __Dymola_Algorithm="Dassl"),
  __Dymola_experimentSetupOutput(derivatives=false, events=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for BatteryPrimaryBalancingController</p>
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
end CheckBatteryPrimaryBalancingController;
