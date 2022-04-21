within TransiEnt.Consumer.Systems.PVBatteryPoolControl.PVBatteryConsumer.Check;
model CheckPVBatteryHousehold


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

  inner parameter Real startTime = 0;

  PVBatteryHousehold
                PBBatteryPool(
  nSystems=1,
  nLoadProfiles=1,
  nPVProfiles=1)              annotation (Placement(transformation(extent={{0,-64},{42,-26}})));

  inner Base.PoolParameter param(
    P_el_PV_peak=5,
    P_pbp_increment=0.1,
    SOC_cond=0,
    P_el_cond=1760,
    eta_max=0.8,
    useBatteryConditioning=true,
    P_el_pbp_total=30,
    t_trading_intraday=900,
  nSystems=1,
  SOC_min=0.20,
  SOC_start=1)            annotation (Placement(transformation(extent={{-24,80},{2,104}})));
  Basics.Tables.GenericDataTable loadProfiles(
    relativepath="electricity/ElectricDemandSingleHouseTypicalProfiles.txt",
    columns=2:6,
    multiple_outputs=false) annotation (Placement(transformation(extent={{-78,34},{-58,54}})));
  Basics.Tables.GenericDataTable pvProfiles(
    relativepath="electricity/PhotovoltaicSingleHouseTypicalProfiles.txt",
    columns=2:5,
    multiple_outputs=false) annotation (Placement(transformation(extent={{-68,-4},{-48,16}})));
  Modelica.Blocks.Math.Gain P_Load(k=2500*3.6e6) annotation (Placement(transformation(extent={{-38,38},{-26,50}})));
  Modelica.Blocks.Math.Gain P_PV(k=2.5e3)
                                        annotation (Placement(transformation(extent={{-36,0},{-24,12}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
Controller controller annotation (Placement(transformation(extent={{82,-54},{62,-34}})));
  Grid.Electrical.LumpedPowerGrid.LumpedGrid lumpedGrid(redeclare Grid.Electrical.Noise.TypicalLumpedGridError genericGridError) annotation (Placement(transformation(extent={{-60,-62},{-40,-42}})));
equation

  connect(loadProfiles.y1, P_Load.u) annotation (Line(points={{-57,44},{-39.2,44}}, color={0,0,127}));
  connect(pvProfiles.y1, P_PV.u) annotation (Line(points={{-47,6},{-37.2,6}}, color={0,0,127}));
public
model Controller "Controller model just for this tester"
  extends TransiEnt.Basics.Icons.Controller;
  Modelica.Blocks.Interfaces.RealInput setpoint=100;
  Base.PoolControlBus bus annotation(Placement(transformation(extent={{62,-54},{82,-34}})));
  outer Base.PoolParameter param;
equation
  for i in 1:param.nSystems loop
    connect(bus.P_el_set_pbp[i], setpoint);
  end for;

end Controller;
equation
connect(P_Load.y, PBBatteryPool.P_el_load[1]) annotation (Line(points={{-25.4,44},{-22,44},{-22,42},{-12,42},{-12,-29.8},{-0.42,-29.8}}, color={0,0,127}));
connect(P_PV.y, PBBatteryPool.P_el_PV[1]) annotation (Line(points={{-23.4,6},{-18,6},{-18,-40},{-18,-37.4},{-0.42,-37.4}}, color={0,0,127}));
connect(controller.bus, PBBatteryPool.poolControlBus) annotation (Line(
    points={{64.8,-48.4},{58,-48.4},{58,-56.02},{42.42,-56.02}},
    color={255,204,51},
    thickness=0.5));
connect(lumpedGrid.epp, PBBatteryPool.epp) annotation (Line(
    points={{-40,-52},{-34,-52},{0,-52},{0,-52.6}},
    color={0,135,135},
    thickness=0.5));
public
function plotResult

  constant String resultFileName = "CheckPVBatteryHousehold.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={792, 0, 791, 695}, y={"PBBatteryPool.batteryManagement.P_set_battery_base.y"}, range={0.0, 90000.0, -600.0, 0.0}, grid=true, colors={{28,108,200}},filename=resultFile);
createPlot(id=1, position={792, 0, 791, 135}, y={"PBBatteryPool.batteryManagement.P_set_limit_cond.P_set_limit"}, range={0.0, 90000.0, -1000.0, 500.0}, grid=true, subPlot=2, colors={{28,108,200}},filename=resultFile);
createPlot(id=1, position={792, 0, 791, 135}, y={"PBBatteryPool.batteryManagement.P_BatCond_set.SOC_is[1]"}, range={0.0, 90000.0, 0.0, 1.5}, grid=true, subPlot=3, colors={{28,108,200}},filename=resultFile);
createPlot(id=1, position={792, 0, 791, 135}, y={"PBBatteryPool.epp.f"}, range={0.0, 90000.0, 49.995000000000005, 50.010000000000005}, grid=true, subPlot=4, colors={{28,108,200}},filename=resultFile);
createPlot(id=1, position={792, 0, 791, 135}, y={"PBBatteryPool.battery.extractP_el_set.y"}, range={0.0, 90000.0, -1000.0, 500.0}, grid=true, subPlot=5, colors={{28,108,200}},filename=resultFile);

  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
annotation (Diagram(graphics,
                    coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                       Icon(graphics,
                                            coordinateSystem(extent={{-100,-100},{100,100}})),
  experiment(
      StopTime=86400,
      Interval=900,
      __Dymola_Algorithm="Dassl"),
  __Dymola_experimentSetupOutput(
    textual=false,
    derivatives=false,
    events=false),
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
<p>Test environment for the PVBatteryHousehold model</p>
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
end CheckPVBatteryHousehold;
