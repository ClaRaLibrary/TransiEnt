within TransiEnt.Storage.Electrical.Check;
model TestPrimaryControlWithBattery "Example to evaluate self discharge time"

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

  inner TransiEnt.SimCenter simCenter
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid(useInputConnector=true) annotation (Placement(transformation(extent={{33,-10},{53,10}})));
  Modelica.Blocks.Sources.TimeTable DiscontiniousTestSchedule(table=[0,50; 3600,50; 43000,50.2; 53000,50.2; 100000,49.8; 110000,49.8])
    annotation (Placement(transformation(extent={{-16,32},{4,52}})));
  Modelica.Blocks.Continuous.FirstOrder f_grid(
    k=1,
    T=5,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=50) annotation (Placement(transformation(extent={{14,32},{34,52}})));
  PrimaryControlStorage primaryControlStorage(Storage(StorageModelParams=TransiEnt.Storage.Electrical.Specifications.LeadAcidBattery(), redeclare model CostModel =TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.ElectricStorageGeneral)) annotation (Placement(transformation(extent={{-20,-8},{0,12}})));
equation

public
function plotResult

  constant String resultFileName = "TestIdealStorageLoadSmoothing.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 817}, y={"Storage.loadSmoothingController.P_set_storage", "Storage.epp.P"}, range={0.0, 4000000.0, -1000000000.0, 200000000.0}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
createPlot(id=1, position={809, 0, 791, 269}, y={"Storage.Storage.storageModel.SOC"}, range={0.0, 4000000.0, -0.1, 0.4}, grid=true, subPlot=2, colors={{28,108,200}}, filename=resultFile);
createPlot(id=1, position={809, 0, 791, 269}, y={"P_residual.y", "P_residual_smoothed.y"}, range={0.0, 4000000.0, -4000000000.0, 2000000000.0}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}}, filename=resultFile);

  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
equation
  connect(f_grid.y,ElectricGrid. f_set) annotation (Line(points={{35,42},{38,42},{38,26},{37.6,26},{37.6,12}},color={0,0,127}));
  connect(DiscontiniousTestSchedule.y, f_grid.u) annotation (Line(points={{5,42},{8.5,42},{12,42}},   color={0,0,127}));
  connect(primaryControlStorage.epp, ElectricGrid.epp) annotation (Line(
      points={{0,2},{33,2},{33,0}},
      color={0,135,135},
      thickness=0.5));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(
      StopTime=4e+006,
      Interval=900,
      Tolerance=1e-006,
      __Dymola_Algorithm="Sdirk34hw"),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(info="<html>
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
</html>"));
end TestPrimaryControlWithBattery;
