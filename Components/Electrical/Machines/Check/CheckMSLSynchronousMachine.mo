within TransiEnt.Components.Electrical.Machines.Check;
model CheckMSLSynchronousMachine

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
  TransiEnt.Components.Electrical.Machines.MSLSynchronousMachine synchronousGenerator annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  TransiEnt.Components.Boundaries.Mechanical.Frequency mechanicalFrequencyBoundary annotation (Placement(transformation(extent={{-42,-10},{-22,10}})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage electricGrid(
    Use_input_connector_f=false,
    Use_input_connector_v=false,
    f_boundary=50,
    v_boundary=100) annotation (Placement(transformation(extent={{28,-10},{48,10}})));
  Modelica.Blocks.Sources.Constant f_grid(k=simCenter.f_n)
    annotation (Placement(transformation(extent={{-64,16},{-44,36}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  Modelica.Blocks.Sources.Ramp     i_excitation(
    height=19 - 10,
    duration=0.1,
    offset=10,
    startTime=0)
    annotation (Placement(transformation(extent={{-36,38},{-16,58}})));
equation
  connect(mechanicalFrequencyBoundary.mpp, synchronousGenerator.mpp) annotation (
      Line(
      points={{-22,0},{-18,0},{-18,-0.5},{-8.5,-0.5}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(electricGrid.epp, synchronousGenerator.epp) annotation (Line(
      points={{27.9,-0.1},{12.1,-0.1}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(f_grid.y, mechanicalFrequencyBoundary.f_set) annotation (Line(
      points={{-43,26},{-32,26},{-32,11.8}},
      color={0,0,127},
      smooth=Smooth.None));
public
function plotResult

  constant String resultFileName = "CheckMSLSynchronousMachine.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={0, 0, 1616, 851}, y={"electricGrid.epp.P", "synchronousGenerator.smeeData.SNominal"}, range={0.0, 0.2, -100000.0, 200000.0}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
plotSignalOperator("CheckMSLSynchronousMachine[end].electricGrid.epp.P", SignalOperator.RMS, 0, 0.2, 0, 1);
createPlot(id=1, position={0, 0, 1616, 281}, y={"synchronousGenerator.terminalBox.plug_sp.pin[1].v", "synchronousGenerator.terminalBox.plug_sp.pin[2].v",
 "synchronousGenerator.terminalBox.plug_sp.pin[3].v"}, range={0.0, 0.2, -150.0, 150.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}, {0,140,72}}, filename=resultFile);
createPlot(id=1, position={0, 0, 1616, 280}, y={"synchronousGenerator.smee.powerBalance.powerStator", "synchronousGenerator.smee.powerBalance.powerMechanical",
 "synchronousGenerator.smee.powerBalance.lossPowerTotal", "synchronousGenerator.smee.powerBalance.powerExcitation"}, range={0.0, 0.2, -400000.0, 200000.0}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}}, filename=resultFile);

    resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
equation
  connect(i_excitation.y, synchronousGenerator.i_e) annotation (Line(points={{-15,48},{2.1,48},{2.1,9.3}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), experiment(StopTime=0.5));
end CheckMSLSynchronousMachine;
