within TransiEnt.Components.Electrical.Machines.Check;
model CheckMSLSynchronousMachine



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
  TransiEnt.Components.Electrical.Machines.MSLSynchronousMachine synchronousGenerator annotation (Placement(transformation(extent={{-4,-10},{16,10}})));
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
  TransiEnt.Components.Electrical.Machines.ExcitationSystemsVoltageController.DummyExcitationSystem_ApparentPowerPort dummyExcitationSystem_ApparentPowerPort annotation (Placement(transformation(extent={{26,30},{6,50}})));
equation
  connect(mechanicalFrequencyBoundary.mpp, synchronousGenerator.mpp) annotation (
      Line(
      points={{-22,0},{-18,0},{-18,0},{-4,0}},
      color={95,95,95},
      smooth=Smooth.None));
  connect(electricGrid.epp, synchronousGenerator.epp) annotation (Line(
      points={{28,0},{22,0},{22,-0.1},{16.1,-0.1}},
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
  connect(i_excitation.y, synchronousGenerator.i_e) annotation (Line(points={{-15,48},{-14,48},{-14,-6},{-2.1,-6},{-2.1,-6.5}},
                                                                                                           color={0,0,127}));
  connect(dummyExcitationSystem_ApparentPowerPort.y, synchronousGenerator.E_input) annotation (Line(points={{5.4,40},{4,40},{4,9.9},{5.7,9.9}}, color={0,0,127}));
  connect(dummyExcitationSystem_ApparentPowerPort.epp1, synchronousGenerator.epp) annotation (Line(
      points={{26,40},{26,-0.1},{16.1,-0.1}},
      color={0,127,0},
      thickness=0.5));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), experiment(StopTime=0.5),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Test environment for MSLSynchronousMachine</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
</html>"));
end CheckMSLSynchronousMachine;
