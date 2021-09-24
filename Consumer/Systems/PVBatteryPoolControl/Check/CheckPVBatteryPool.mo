within TransiEnt.Consumer.Systems.PVBatteryPoolControl.Check;
model CheckPVBatteryPool "Tester for PVBatteryPool"

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

  PVBatteryPool PBBatteryPool(
    nSystems=20,
    nLoadProfiles=5,
    nPVProfiles=4,
    house(
      iLoadProfile={1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5},
      iPVProfile={1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4},
      battery(batterySystem(StorageModelParams=Storage.Electrical.Specifications.LithiumIon(E_start=E_bat_start_dist.k))))) annotation (Placement(transformation(extent={{34,-72},{76,-34}})));

  inner Base.PoolParameter param(
    P_el_PV_peak=5,
    P_pbp_increment=0.1,
    SOC_cond=0,
    P_el_cond=1760,
    eta_max=0.8,
    useBatteryConditioning=true,
    SOC_min=0.30,
    P_el_pbp_total=30,
    t_trading_intraday=900,
    nSystems=20,
    SOC_start=1) annotation (Placement(transformation(extent={{-24,80},{2,104}})));
  Basics.Tables.GenericDataTable loadProfiles(
    relativepath="electricity/ElectricDemandSingleHouseTypicalProfiles.txt",
    multiple_outputs=true,
    columns=2:6) annotation (Placement(transformation(extent={{-34,26},{-14,46}})));
  Basics.Tables.GenericDataTable pvProfiles(
    relativepath="electricity/PhotovoltaicSingleHouseTypicalProfiles.txt",
    multiple_outputs=true,
    columns=2:5) annotation (Placement(transformation(extent={{-34,-12},{-14,8}})));
  Modelica.Blocks.Math.Gain P_Load[5](k=(2500:500:4500).*3.6e6) annotation (Placement(transformation(extent={{-4,30},{8,42}})));
  Modelica.Blocks.Math.Gain P_PV[4](k=(1:0.5:2.5)*1e3) annotation (Placement(transformation(extent={{-2,-8},{10,4}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
  Grid.Electrical.LumpedPowerGrid.LumpedGrid lumpedGrid(LumpedGrid(PowerPlants(fixedStartValue_w=true))) annotation (Placement(transformation(extent={{-26,-62},{-6,-42}})));
  Basics.Blocks.Sources.ConstantVectorSource E_bat_start_dist(k=fill(param.E_min_bat, PBBatteryPool.nSystems) + SOC_start_dist.k .* (param.E_max_bat - param.E_min_bat), nout=PBBatteryPool.nSystems) "Start distribution of battery storage state of charge" annotation (Placement(transformation(extent={{-84,-2},{-64,18}})));
  Basics.Blocks.Sources.ConstantVectorSource SOC_start_dist(k=linspace(
        0,
        1,
        PBBatteryPool.nSystems), nout=PBBatteryPool.nSystems) "Start distribution of battery storage state of charge (equally distributed)" annotation (Placement(transformation(extent={{-84,28},{-64,48}})));
equation

  connect(pvProfiles.y[1:4],P_PV [1:4].u) annotation (Line(points={{-13,-2},{-3.2,-2}},         color={0,0,127}));
  connect(loadProfiles.y[1:5],P_Load [1:5].u) annotation (Line(points={{-13,36},{-5.2,36}},         color={0,0,127}));
  connect(PBBatteryPool.P_el_load, P_Load.y) annotation (Line(points={{33.16,-38.18},{18,-38.18},{18,36},{8.6,36}}, color={0,0,127}));
  connect(PBBatteryPool.P_el_PV, P_PV.y) annotation (Line(points={{33.16,-45.78},{14,-45.78},{14,-2},{10.6,-2}},
                                                                                                              color={0,0,127}));
  connect(lumpedGrid.epp, PBBatteryPool.epp) annotation (Line(
      points={{-6,-52},{34.21,-52},{34.21,-52.905}},
      color={0,135,135},
      thickness=0.5));
public
function plotResult

  constant String resultFileName = "CheckPVBatteryPool.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

  createPlot(id=1, position={0, 0, 1616, 851}, y={"P_PV[1].y", "P_PV[2].y", "P_PV[3].y", "P_PV[4].y"}, range={0.0, 90000.0, -50.0, 200.0}, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}},filename=resultFile);
  createPlot(id=1, position={0, 0, 1616, 209}, y={"P_Load[1].y", "P_Load[2].y", "P_Load[3].y", "P_Load[4].y", "P_Load[5].y"}, range={0.0, 90000.0, 0.0, 3000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}, {0,0,0}},filename=resultFile);
  createPlot(id=1, position={0, 0, 1616, 209}, y={"PBBatteryPool.epp.P"}, range={0.0, 90000.0, 10000.0, 35000.0}, grid=true, subPlot=3, colors={{28,108,200}},filename=resultFile);
  createPlot(id=1, position={0, 0, 1616, 209}, y={"PBBatteryPool.house[1].battery.batterySystem.storageModel.E"}, range={0.0, 90000.0, 5000000.0, 20000000.0}, grid=true, subPlot=4, colors={{28,108,200}},filename=resultFile);
  plotExpression(apply(CheckPVBatteryPool[end].PBBatteryPool.house[2].battery.batterySystem.storageModel.E), false, "CheckPVBatteryPool[end].PBBatteryPool.house[2].battery.batterySystem.storageModel.E", 1);
  plotExpression(apply(CheckPVBatteryPool[end].PBBatteryPool.house[4].battery.batterySystem.storageModel.E), false, "CheckPVBatteryPool[end].PBBatteryPool.house[4].battery.batterySystem.storageModel.E", 1);
  plotExpression(apply(CheckPVBatteryPool[end].PBBatteryPool.house[6].battery.batterySystem.storageModel.E), false, "CheckPVBatteryPool[end].PBBatteryPool.house[6].battery.batterySystem.storageModel.E", 1);
  plotExpression(apply(CheckPVBatteryPool[end].PBBatteryPool.house[8].battery.batterySystem.storageModel.E), false, "CheckPVBatteryPool[end].PBBatteryPool.house[8].battery.batterySystem.storageModel.E", 1);
  plotExpression(apply(CheckPVBatteryPool[end].PBBatteryPool.house[10].battery.batterySystem.storageModel.E), false, "CheckPVBatteryPool[end].PBBatteryPool.house[10].battery.batterySystem.storageModel.E", 1);
  plotExpression(apply(CheckPVBatteryPool[end].PBBatteryPool.house[12].battery.batterySystem.storageModel.E), false, "CheckPVBatteryPool[end].PBBatteryPool.house[12].battery.batterySystem.storageModel.E", 1);
  plotExpression(apply(CheckPVBatteryPool[end].PBBatteryPool.house[14].battery.batterySystem.storageModel.E), false, "CheckPVBatteryPool[end].PBBatteryPool.house[14].battery.batterySystem.storageModel.E", 1);
  plotExpression(apply(CheckPVBatteryPool[end].PBBatteryPool.house[16].battery.batterySystem.storageModel.E), false, "CheckPVBatteryPool[end].PBBatteryPool.house[16].battery.batterySystem.storageModel.E", 1);
  plotExpression(apply(CheckPVBatteryPool[end].PBBatteryPool.house[18].battery.batterySystem.storageModel.E), false, "CheckPVBatteryPool[end].PBBatteryPool.house[18].battery.batterySystem.storageModel.E", 1);
  plotExpression(apply(CheckPVBatteryPool[end].PBBatteryPool.house[20].battery.batterySystem.storageModel.E), false, "CheckPVBatteryPool[end].PBBatteryPool.house[20].battery.batterySystem.storageModel.E", 1);

  resultFile := "Successfully plotted results for file: " + resultFile;

    annotation (experiment(StopTime=7200, __Dymola_Algorithm="Dassl"), __Dymola_experimentSetupOutput(events=false));
end plotResult;
annotation (Diagram(graphics,
                    coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                       Icon(graphics,
                                            coordinateSystem(extent={{-100,-100},{100,100}})),
  experiment(
      StopTime=86400,
      Interval=30,
      Tolerance=1e-05,
      __Dymola_fixedstepsize=30,
      __Dymola_Algorithm="Radau"),
  __Dymola_experimentSetupOutput(derivatives=false, events=false),
    __Dymola_experimentFlags(
      Advanced(
        EvaluateAlsoTop=false,
        GenerateVariableDependencies=false,
        OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the PVBatteryPool model</p>
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
end CheckPVBatteryPool;
