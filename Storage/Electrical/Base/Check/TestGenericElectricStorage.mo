within TransiEnt.Storage.Electrical.Base.Check;
model TestGenericElectricStorage

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



  extends TransiEnt.Basics.Icons.Checkmodel;

  GenericElectricStorage
                 idealStorage(redeclare model StationaryLossModel = TransiEnt.Storage.Base.NoStationaryLoss,
                                                                                      StorageModelParams(
      E_start=baseparams.E_start,
      E_max=baseparams.E_max,
      E_min=baseparams.E_min,
      P_max_unload=baseparams.P_max_unload,
      P_max_load=baseparams.P_max_load,
      P_grad_max=baseparams.P_grad_max,
      eta_unload=baseparams.eta_unload,
      eta_load=baseparams.eta_load),
    redeclare model CostModel=TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.RedoxFlowBattery)
                                     annotation (Placement(transformation(extent={{-15,24},{15,54}})));

  GenericElectricStorage
                 inefficientStorage(redeclare model StationaryLossModel = TransiEnt.Storage.Base.NoStationaryLoss,
                                                                                            StorageModelParams(
      E_start=baseparams.E_start,
      E_max=baseparams.E_max,
      E_min=baseparams.E_min,
      P_max_unload=baseparams.P_max_unload,
      P_max_load=baseparams.P_max_load,
      P_grad_max=baseparams.P_grad_max,
      eta_unload=0.8,
      eta_load=0.7),
    redeclare model CostModel=TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.RedoxFlowBattery)
                                     annotation (Placement(transformation(extent={{-15,-68},{15,-38}})));

  GenericElectricStorage
                 lossyStorage(
    redeclare model CostModel=TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.RedoxFlowBattery,
    StorageModelParams(
      E_start=baseparams.E_start,
      E_max=baseparams.E_max,
      E_min=baseparams.E_min,
      P_max_unload=baseparams.P_max_unload,
      P_max_load=baseparams.P_max_load,
      P_grad_max=baseparams.P_grad_max,
      eta_unload=baseparams.eta_unload,
      eta_load=baseparams.eta_load,
      selfDischargeRate=1/36000),
    redeclare model StationaryLossModel = TransiEnt.Storage.Base.SelfDischargeRate)
                                     annotation (Placement(transformation(extent={{-15,-23},{15,7}})));
  TransiEnt.Storage.Base.GenericStorageParameters baseparams(
    E_start=baseparams.E_min,
    E_max=3600*baseparams.P_max_unload,
    E_min=0.1*baseparams.E_max,
    P_max_unload=100e3,
    P_grad_max=baseparams.P_max_unload/60) annotation (Placement(transformation(extent={{-12,72},{8,92}})));
  Modelica.Blocks.Math.Gain P_set(k=baseparams.P_max_unload)
                                  annotation (Placement(transformation(extent={{-56,4},{-36,24}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  Modelica.Blocks.Sources.TimeTable P_set_pu(
    offset=0,
    table=[0,1; 1,1; 1,-1; 2,-1; 2,1; 3,1; 3,0; 4,0],
    timeScale=3600)                       "Test schedule" annotation (Placement(transformation(extent={{-86,4},{-66,24}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid annotation (Placement(transformation(extent={{48,-18},{68,2}})));
equation
  connect(P_set.y, lossyStorage.P_set) annotation (Line(points={{-35,14},{-30,14},{0,14},{0,6.1}},
                                                                                                color={0,0,127}));
  connect(P_set.y, idealStorage.P_set) annotation (Line(points={{-35,14},{-30,14},{-30,58},{0,58},{0,53.1}},       color={0,0,127}));
  connect(P_set.y, inefficientStorage.P_set) annotation (Line(points={{-35,14},{-30,14},{-30,-32},{0,-32},{0,-38.9}},
                                                                                                                  color={0,0,127}));
  connect(P_set_pu.y, P_set.u) annotation (Line(points={{-65,14},{-58,14}},
                                                                          color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestGenericElectricStorage.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 817}, y={"P_set.y", "idealStorage.storageModel.P_is", "inefficientStorage.storageModel.P_is", "lossyStorage.storageModel.P_is"}, range={0.0, 5.0, -120000.0, 120000.0}, grid=true, colors={{0,0,0}, {0,140,72}, {238,46,47}, {244,125,35}}, patterns={LinePattern.Dot, LinePattern.Solid, LinePattern.Solid, LinePattern.DashDot}, thicknesses={0.5, 0.25, 0.25, 0.25}, filename=resultFile);
createPlot(id=1, position={809, 0, 791, 406}, y={"idealStorage.storageModel.SOC", "inefficientStorage.storageModel.SOC", "lossyStorage.storageModel.SOC"}, range={0.0, 18000.0, -0.1, 1.1}, grid=true, subPlot=2, colors={{0,140,72}, {238,46,47}, {244,125,35}}, patterns={LinePattern.Solid, LinePattern.Solid, LinePattern.DashDot}, filename=resultFile);

createPlot(id=2, position={15, 10, 865, 421}, y={"idealStorage.terminal.epp.P", "inefficientStorage.terminal.epp.P",
"lossyStorage.terminal.epp.P", "ElectricGrid.epp.P"}, range={0.0, 18000.0, -350000.0, 350000.0}, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}}, filename=resultFile);

  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
equation
  connect(idealStorage.epp, ElectricGrid.epp) annotation (Line(
      points={{15,39},{32,39},{32,-8},{48,-8}},
      color={0,135,135},
      thickness=0.5));
  connect(lossyStorage.epp, ElectricGrid.epp) annotation (Line(
      points={{15,-8},{48,-8},{48,-8}},
      color={0,135,135},
      thickness=0.5));
  connect(inefficientStorage.epp, ElectricGrid.epp) annotation (Line(
      points={{15,-53},{32,-53},{32,-8},{48,-8}},
      color={0,135,135},
      thickness=0.5));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),           Documentation(info="<html>
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
end TestGenericElectricStorage;
