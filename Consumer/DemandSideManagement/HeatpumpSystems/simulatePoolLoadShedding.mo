within TransiEnt.Consumer.DemandSideManagement.HeatpumpSystems;
model simulatePoolLoadShedding
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
  import TransiEnt;
  extends TransiEnt.Basics.Icons.Example;

  TransiEnt.Consumer.DemandSideManagement.HeatpumpSystems.Base.HeatpumpSystemPool heatpumpSystemPool(N=20) annotation (Placement(transformation(extent={{-14,-16},{16,14}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency ElectricGrid annotation (Placement(transformation(extent={{52,-12},{72,8}})));
  Modelica.Blocks.Sources.BooleanStep booleanStep(startTime=86400) annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
  inner TransiEnt.SimCenter simCenter(tableInterpolationSmoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
                                      annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-50,100},{-70,80}})));
equation
  connect(heatpumpSystemPool.epp, ElectricGrid.epp) annotation (Line(
      points={{16,-1},{51.9,-1},{51.9,-2.1}},
      color={0,135,135},
      thickness=0.5));
  connect(booleanStep.y, heatpumpSystemPool.isLoadShedding) annotation (Line(points={{-37,0},{-14.3,0},{-14.3,-1}}, color={255,0,255}));
public
function plotResult

  constant String resultFileName = "simulatePoolLoadShedding.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

  createPlot(id=1, position={0, 0, 1600, 817}, y={"heatpumpSystemPool.P_el_star", "heatpumpSystemPool.HeatPumpSystem[1].P_el_star"}, range={0.0, 2.0, -0.5, 1.5}, grid=true, colors={{0,0,0}, {238,46,47}}, thicknesses={0.5, 0.25},filename=resultFileName);
  createPlot(id=2, position={0, 0, 1600, 200}, y={"heatpumpSystemPool.HeatPumpSystem[1].Room.T", "heatpumpSystemPool.HeatPumpSystem[2].Room.T",
   "heatpumpSystemPool.HeatPumpSystem[5].Room.T"}, range={0.0, 2.0, 12.0, 22.0}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}, {0,140,72}},filename=resultFileName);
  createPlot(id=2, position={0, 0, 1600, 201}, y={"heatpumpSystemPool.HeatPumpSystem[3].isLoadShedding"}, range={0.0, 2.0, -0.5, 1.5}, grid=true, subPlot=2, colors={{28,108,200}},filename=resultFileName);
  createPlot(id=2, position={0, 0, 1600, 200}, y={"heatpumpSystemPool.HeatPumpSystem[1].SOC_tot", "heatpumpSystemPool.HeatPumpSystem[2].SOC_tot",
   "heatpumpSystemPool.SOC"}, range={0.0, 2.0, -0.2, 0.8}, grid=true, subPlot=4, colors={{28,108,200},  {0,0,0}, {0,0,0}}, thicknesses={0.25, 0.25, 0.5}, filename=resultFileName);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (experiment(StopTime=172800));
end simulatePoolLoadShedding;
