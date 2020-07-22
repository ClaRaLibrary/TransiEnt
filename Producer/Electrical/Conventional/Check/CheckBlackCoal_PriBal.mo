within TransiEnt.Producer.Electrical.Conventional.Check;
model CheckBlackCoal_PriBal
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2020, Hamburg University of Technology.                              //
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
  BlackCoal blackCoal_pribal(
    eta_total=0.432,
    T_plant=200,
    isSecondaryControlActive=false,
    isExternalSecondaryController=false,
    P_el_n=1e9,
    P_init_set=1e9,
    P_min_star=0.2,
    isPrimaryControlActive=true,
    primaryBalancingController(k_part=1, plantType=TransiEnt.Basics.Types.ControlPlantType.PeakLoad)) annotation (Placement(transformation(extent={{-32,-20},{-12,0}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency constantFrequency_L1_1(useInputConnector=true) annotation (Placement(transformation(extent={{24,-14},{44,6}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},
            {-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.Pulse     timeTable(
    amplitude=-0.8e9,
    width=50,
    period=43200,
    offset=0,
    startTime=0)
    annotation (Placement(transformation(extent={{-62,6},{-42,26}})));
  BlackCoal blackCoal(
    isPrimaryControlActive=false,
    eta_total=0.432,
    T_plant=200,
    isSecondaryControlActive=false,
    isExternalSecondaryController=false,
    P_el_n=1e9,
    P_init_set=1e9,
    P_min_star=0.2) annotation (Placement(transformation(extent={{-32,-58},{-12,-38}})));
  BlackCoal blackCoal1(
    isSecondaryControlActive=false,
    P_el_n=1e9,
    primaryBalancingController(
      k_part=1,
      maxGradientPrCtrl=0.05/30,
      maxValuePrCtrl=0.05,
      providedDroop=0.4/5)) annotation (Placement(transformation(extent={{-32,-94},{-12,-74}})));
  Modelica.Blocks.Sources.Constant  timeTable2(k=-1e9 + 50e6)
    annotation (Placement(transformation(extent={{-72,-78},{-52,-58}})));
  Modelica.Blocks.Sources.TimeTable DiscontiniousTestSchedule(table=[0,50; 3600,50; 43000,50.2; 53000,50.2; 100000,49.8; 110000,49.8])
    annotation (Placement(transformation(extent={{-28,28},{-8,48}})));
  Modelica.Blocks.Continuous.FirstOrder f_grid(
    k=1,
    T=5,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=50) annotation (Placement(transformation(extent={{2,28},{22,48}})));
equation
  connect(blackCoal_pribal.epp, constantFrequency_L1_1.epp) annotation (Line(
      points={{-13,-3},{24,-3},{24,-4}},
      color={0,135,135},
      thickness=0.5));
  connect(timeTable.y, blackCoal_pribal.P_el_set) annotation (Line(points={{-41,16},{-23.5,16},{-23.5,-0.1}}, color={0,0,127}));
  connect(blackCoal.epp, constantFrequency_L1_1.epp) annotation (Line(
      points={{-13,-41},{2,-41},{2,-4},{24,-4}},
      color={0,135,135},
      thickness=0.5));
  connect(timeTable.y, blackCoal.P_el_set) annotation (Line(points={{-41,16},{-40,16},{-40,18},{-40,-34},{-40,-36},{-23.5,-36},{-23.5,-38.1}}, color={0,0,127}));
  connect(blackCoal1.epp, constantFrequency_L1_1.epp) annotation (Line(
      points={{-13,-77},{2,-77},{2,-4},{24,-4}},
      color={0,135,135},
      thickness=0.5));
  connect(timeTable2.y, blackCoal1.P_el_set) annotation (Line(points={{-51,-68},{-51,-68},{-48,-68},{-23.5,-68},{-23.5,-74.1}},                     color={0,0,127}));
  connect(DiscontiniousTestSchedule.y,f_grid. u) annotation (Line(points={{-7,38},{-3.5,38},{0,38}},  color={0,0,127}));
  connect(f_grid.y, constantFrequency_L1_1.f_set) annotation (Line(points={{23,38},{28.6,38},{28.6,8}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "CheckBlackCoal_PriBal.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={809, 0, 791, 733}, y={"blackCoal.epp.P", "blackCoal.P_el_set"}, range={0.0, 110000.0, -1200000000.0, 200000000.0}, grid=true, colors={{28,108,200}, {238,46,47}},filename=resultFile);
createPlot(id=1, position={809, 0, 791, 241}, y={"blackCoal_pribal.epp.P", "blackCoal_pribal.P_el_set"}, range={0.0, 110000.0, -1200000000.0, 200000000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}},filename=resultFile);
createPlot(id=1, position={809, 0, 791, 241}, y={"blackCoal1.epp.P", "blackCoal1.P_el_set"}, range={0.0, 110000.0, -1200000000.0, 200000000.0}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}},filename=resultFile);
  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;

  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(
      StopTime=110000,
      Interval=450,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for a black coal power plant model</p>
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
end CheckBlackCoal_PriBal;
