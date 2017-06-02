within TransiEnt.Consumer.DemandSideManagement.PVBatteryPoolControl.Controller.Check;
model CheckBatteryManagementSystem
//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//
extends TransiEnt.Basics.Icons.Checkmodel;

model System "Minimum pool unit (just for this tester)"
  extends TransiEnt.Basics.Icons.Model;
  Modelica.Blocks.Interfaces.RealInput P_PBP_set=param.P_el_max_bat*0.1;
  Modelica.Blocks.Interfaces.RealInput P_max_load_star=0.95;
  Modelica.Blocks.Interfaces.RealInput P_max_unload_star=0.9;
  Modelica.Blocks.Interfaces.RealInput P_is=param.P_el_max_bat*0.5;
    Modelica.Blocks.Interfaces.RealInput SOC=if time < 3600 then 0.9 else param.SOC_min;
  Base.PoolControlBus bus annotation (Placement(transformation(extent={{88,-14},{116,12}}), iconTransformation(
          extent={{-25.5,-21.5},{25.5,21.5}},
          rotation=90,
          origin={101.5,0.5})));
  outer Base.PoolParameter param;
equation
//  for i in 1:param.nSystems loop
    connect(bus.P_el_set_pbp[1], P_PBP_set);
    connect(bus.SOC[1], SOC);
    connect(bus.P_el_is[1], P_is);
    connect(bus.P_max_load_star[1], P_max_load_star);
    connect(bus.P_max_unload_star[1], P_max_unload_star);
//  end for;

end System;

  inner Base.PoolParameter param(SOC_min=0.2, final nSystems=1) annotation (Placement(transformation(extent={{6,42},{36,72}})));

  BatteryManagementSystem bms(index=1)            annotation (Placement(transformation(extent={{-4,-26},{16,-6}})));
  System system annotation (Placement(transformation(extent={{57,-23},{37,-3}})));

  Modelica.Blocks.Sources.Cosine   f_grid_is(
    amplitude=0.1,
    phase=1.5707963267949,
    offset=50,
    freqHz=1/1800)    annotation (Placement(transformation(extent={{-70,-32},{-50,-12}})));
  Modelica.Blocks.Math.Feedback delta_f_grid annotation (Placement(transformation(extent={{-40,-32},{-20,-12}})));
  Modelica.Blocks.Sources.Constant f_grid_nom(k=50)  annotation (Placement(transformation(extent={{-70,-74},{-50,-54}})));
  Modelica.Blocks.Sources.Cosine P_surplus(
    offset=0,
    freqHz=1/7200,
    amplitude=1.2*param.P_el_max_bat,
    phase=1.5707963267949)
                      annotation (Placement(transformation(extent={{-68,14},{-48,34}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner Components.Boundaries.Ambient.AmbientConditions ambientConditions annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  inner ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
equation
  connect(f_grid_nom.y,delta_f_grid. u2) annotation (Line(points={{-49,-64},{-30,-64},{-30,-30}},
                                                                                               color={0,0,127}));

    connect(delta_f_grid.y, bms.delta_f) annotation (Line(points={{-21,-22},{-3.2,-22},{-3.2,-22.8}}, color={0,0,127}));

  connect(bms.poolControlBus, system.bus) annotation (Line(
      points={{18,-14.2},{28,-14.2},{28,-12.95},{36.85,-12.95}},
      color={255,204,51},
      thickness=0.5));
  connect(P_surplus.y, bms.P_surplus) annotation (Line(points={{-47,24},{-26,24},{-26,18},{-3.8,18},{-3.8,-6}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "CheckBatteryManagementSystem.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={763, 0, 745, 641}, y={"bms.P_surplus", "bms.P_set_battery_base.y", "bms.P_set_battery.y"}, range={0.0, 7500.0, -5000.0, 5000.0}, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}},filename=resultFile);
createPlot(id=1, position={763, 0, 745, 156}, y={"delta_f_grid.y"}, range={0.0, 7500.0, -0.2, 0.2}, grid=true, subPlot=2, colors={{28,108,200}},filename=resultFile);
createPlot(id=1, position={763, 0, 745, 155}, y={"bms.PBPController.P_el_pbp_set"}, range={0.0, 7500.0, -100.0, 200.0}, grid=true, subPlot=3, colors={{28,108,200}},filename=resultFile);
createPlot(id=1, position={763, 0, 745, 156}, y={"bms.P_BatCond_set.isConditioiningActiveAndNeeded.y"}, range={0.0, 7500.0, -0.5, 1.5}, grid=true, subPlot=4, colors={{28,108,200}},filename=resultFile);

  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
equation
  connect(f_grid_is.y, delta_f_grid.u1) annotation (Line(points={{-49,-22},{-38,-22},{-38,-22}}, color={0,0,127}));
annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                       Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
  experiment(StopTime=7200, __Dymola_Algorithm="Dassl"),
  __Dymola_experimentSetupOutput(
      derivatives=false,
      events=false));
end CheckBatteryManagementSystem;
