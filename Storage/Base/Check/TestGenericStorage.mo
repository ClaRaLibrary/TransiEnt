within TransiEnt.Storage.Base.Check;
model TestGenericStorage
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
  extends TransiEnt.Basics.Icons.Checkmodel;

  TransiEnt.Storage.Base.GenericStorage idealStorage(redeclare model StationaryLossModel = NoStationaryLoss, params(
      E_start=baseparams.E_start,
      E_max=baseparams.E_max,
      E_min=baseparams.E_min,
      P_max_unload=baseparams.P_max_unload,
      P_max_load=baseparams.P_max_load,
      P_grad_max=baseparams.P_grad_max,
      eta_unload=baseparams.eta_unload,
      eta_load=baseparams.eta_load)) annotation (Placement(transformation(extent={{-16,34},{14,64}})));

  TransiEnt.Storage.Base.GenericStorage inefficientStorage(redeclare model StationaryLossModel = NoStationaryLoss, params(
      E_start=baseparams.E_start,
      E_max=baseparams.E_max,
      E_min=baseparams.E_min,
      P_max_unload=baseparams.P_max_unload,
      P_max_load=baseparams.P_max_load,
      P_grad_max=baseparams.P_grad_max,
      eta_unload=0.8,
      eta_load=0.7)) annotation (Placement(transformation(extent={{-14,-60},{16,-30}})));

  TransiEnt.Storage.Base.GenericStorage lossyStorage(params(
      E_start=baseparams.E_start,
      E_max=baseparams.E_max,
      E_min=baseparams.E_min,
      P_max_unload=baseparams.P_max_unload,
      P_max_load=baseparams.P_max_load,
      P_grad_max=baseparams.P_grad_max,
      eta_unload=baseparams.eta_unload,
      eta_load=baseparams.eta_load), redeclare model StationaryLossModel = LinearStationaryLoss (a=1e-4)) annotation (Placement(transformation(extent={{-16,-12},{14,18}})));
  GenericStorageParameters baseparams(
    E_start=baseparams.E_min,
    E_max=3600*baseparams.P_max_unload,
    E_min=0.1*baseparams.E_max,
    P_max_unload=100e3,
    P_grad_max=baseparams.P_max_unload/60) annotation (Placement(transformation(extent={{-12,72},{8,92}})));
  Modelica.Blocks.Math.Gain P_set(k=baseparams.P_max_unload)
                                  annotation (Placement(transformation(extent={{-52,-10},{-32,10}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  Modelica.Blocks.Sources.TimeTable P_set_pu(
    offset=0,
    timeScale=3600,
    table=[0,1; 1,1; 1,-1; 2,-1; 2,1; 3,1; 3,0; 4,0])
                                          "Test schedule" annotation (Placement(transformation(extent={{-86,-10},{-66,10}})));
equation
  connect(P_set.y, lossyStorage.P_set) annotation (Line(points={{-31,0},{-15.4,0},{-15.4,2.4}}, color={0,0,127}));
  connect(P_set.y, idealStorage.P_set) annotation (Line(points={{-31,0},{-32,0},{-32,20},{-32,48.4},{-15.4,48.4}}, color={0,0,127}));
  connect(P_set.y, inefficientStorage.P_set) annotation (Line(points={{-31,0},{-30,0},{-30,-45.6},{-13.4,-45.6}}, color={0,0,127}));
  connect(P_set_pu.y, P_set.u) annotation (Line(points={{-65,0},{-54,0}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestGenericStorage.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 817}, y={"P_set.y", "idealStorage.P_is", "inefficientStorage.P_is", "lossyStorage.P_is"}, range={0.0, 5.0, -120000.0, 120000.0}, grid=true, colors={{0,0,0}, {0,140,72}, {238,46,47}, {244,125,35}}, patterns={LinePattern.Dot, LinePattern.Solid, LinePattern.Solid, LinePattern.DashDot}, thicknesses={0.5, 0.25, 0.25, 0.25}, filename=resultFile);
createPlot(id=1, position={809, 0, 791, 406}, y={"idealStorage.SOC", "inefficientStorage.SOC", "lossyStorage.SOC"}, range={0.0, 18000.0, -0.1, 1.1}, grid=true, subPlot=2, colors={{0,140,72}, {238,46,47}, {244,125,35}}, patterns={LinePattern.Solid, LinePattern.Solid, LinePattern.DashDot}, filename=resultFile);
   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),           Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"),
    experiment(StopTime=18000));
end TestGenericStorage;
