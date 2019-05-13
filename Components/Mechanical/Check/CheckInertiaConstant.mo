within TransiEnt.Components.Mechanical.Check;
model CheckInertiaConstant
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

//  parameter Integer n=10 "Number of Inertia components";
  Modelica.Blocks.Sources.Step     P_set(
    startTime=3600,
    height=75e6,
    offset=-75e6)                                 annotation (Placement(transformation(extent={{-76,50},{-56,70}})));
  TransiEnt.Consumer.Electrical.LinearElectricConsumer linearElectricConsumer annotation (Placement(transformation(extent={{42,-2},{62,18}})));
  Modelica.Blocks.Sources.Constant P_demand(k=10e7)
                                                   annotation (Placement(transformation(extent={{72,38},{52,58}})));
  TransiEnt.Producer.Electrical.Conventional.BlackCoal blackCoal(
    isSecondaryControlActive=false,
    isExternalSecondaryController=false,
    H=simCenter.generationPark.H_gen_ST*2,
    P_el_n=100e6,
    P_init_set=75e6) annotation (Placement(transformation(extent={{-24,14},{-4,34}})));
  TransiEnt.Producer.Electrical.Conventional.BlackCoal blackCoal1(
    isSecondaryControlActive=false,
    isExternalSecondaryController=false,
    nSubgrid=2,
    P_min_star=0.1,
    P_el_n=100e6,
    P_init_set=25e6) annotation (Placement(transformation(extent={{-22,-18},{-2,2}})));
  inner TransiEnt.SimCenter simCenter(generationPark(H_gen_ST=5))
                                      annotation (Placement(transformation(extent={{-46,78},{-26,98}})));
  Modelica.Blocks.Sources.Step     P_set1(
    startTime=3600,
    height=-75e6,
    offset=-25e6)                                 annotation (Placement(transformation(extent={{-76,-4},{-56,16}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency ElectricGrid annotation (Placement(transformation(extent={{46,70},{66,90}})));
equation

  connect(P_demand.y, linearElectricConsumer.P_el_set) annotation (Line(points={{51,48},{44,48},{44,30},{52,30},{52,19.6}},      color={0,0,127}));
  connect(P_set.y, blackCoal.P_el_set) annotation (Line(points={{-55,60},{-15.5,60},{-15.5,33.9}}, color={0,0,127}));
  connect(P_set1.y, blackCoal1.P_el_set) annotation (Line(points={{-55,6},{-13.5,6},{-13.5,1.9}}, color={0,0,127}));
  connect(blackCoal1.epp, linearElectricConsumer.epp) annotation (Line(
      points={{-3,-1},{-3,8},{42.2,8}},
      color={0,135,135},
      thickness=0.5));
  connect(blackCoal.epp, linearElectricConsumer.epp) annotation (Line(
      points={{-5,31},{8,31},{8,8},{42.2,8}},
      color={0,135,135},
      thickness=0.5));
  connect(ElectricGrid.epp, linearElectricConsumer.epp) annotation (Line(
      points={{46,80},{46,80},{20,80},{20,8},{42.2,8}},
      color={0,135,135},
      thickness=0.5));
public
function plotResult

  constant String resultFileName = "CheckInertiaConstant.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={0, 0, 1616, 850}, y={"modelStatistics.electricPower.T_tc_total"}, range={0.0, 7600.0, 2.0, 8.0}, grid=true, colors={{28,108,200}},filename=resultFile);
createPlot(id=1, position={0, 0, 1616, 280}, y={"modelStatistics.electricPower.P_gen_total", "modelStatistics.electricPower.P_demand"}, range={0.0, 7200.0, 20000000.0, 120000000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}},filename=resultFile);
createPlot(id=1, position={0, 0, 1616, 280}, y={"blackCoal.MechanicalConnection.isRunning", "blackCoal1.MechanicalConnection.isRunning"}, range={0.0, 7600.0, -0.5, 1.5}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}},filename=resultFile);
  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=7200),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the ConstantInertia model</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
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
end CheckInertiaConstant;
