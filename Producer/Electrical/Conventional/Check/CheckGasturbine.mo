within TransiEnt.Producer.Electrical.Conventional.Check;
model CheckGasturbine "Example of the component PowerPlant_PoutGrad_L1"

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

  TransiEnt.Components.Boundaries.Electrical.Frequency Grid(useInputConnector=false, f_set_const=simCenter.f_n) annotation (Placement(transformation(extent={{42,-60},{62,-40}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-70,60},{-50,80}})));
  Modelica.Blocks.Sources.Step NomalStartup(
    offset=0,
    height=-120e6,
    startTime=100) annotation (Placement(transformation(extent={{-76,22},{-56,42}})));
Gasturbine gasturbine(
  eta_total=0.45,
  P_init=0,
  P_el_n=120000000)
            annotation (Placement(transformation(extent={{-30,-66},{-10,-46}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.Step P_SB_neg_end(
    offset=0,
    height=-20e6,
    startTime=1900) annotation (Placement(transformation(extent={{-6,24},{14,44}})));
  Modelica.Blocks.Math.Sum sum1(nin=3)
                                annotation (Placement(transformation(extent={{36,10},{56,30}})));
  Modelica.Blocks.Sources.Step P_SB_neg_set_from_On(
    offset=0,
    height=20e6,
    startTime=1000) annotation (Placement(transformation(extent={{-6,-8},{14,12}})));
  Modelica.Blocks.Math.Sum sum2(nin=2)
                                annotation (Placement(transformation(extent={{-44,-2},{-24,18}})));
  Modelica.Blocks.Sources.Step Shutdown(
    offset=0,
    height=120e6,
    startTime=3600) annotation (Placement(transformation(extent={{-76,-26},{-56,-6}})));
  Modelica.Blocks.Sources.Step P_SB_neg_set_from_Off(
    offset=0,
    startTime(displayUnit="h") = 5400,
    height=-80e6) annotation (Placement(transformation(extent={{-6,56},{14,76}})));
equation

  connect(gasturbine.epp, Grid.epp) annotation (Line(
      points={{-10.5,-50.4},{41.9,-50.4},{41.9,-50.1}},
      color={0,135,135},
      thickness=0.5));
  connect(P_SB_neg_set_from_On.y, sum1.u[1]) annotation (Line(points={{15,2},{26,2},{26,18.6667},{34,18.6667}}, color={0,0,127}));
  connect(P_SB_neg_end.y, sum1.u[2]) annotation (Line(points={{15,34},{24,34},{24,20},{34,20}}, color={0,0,127}));
  connect(sum1.y, gasturbine.P_SB_set) annotation (Line(points={{57,20},{66,20},{66,24},{74,24},{74,-20},{-28.9,-20},{-28.9,-47.1}}, color={0,0,127}));
  connect(sum2.y, gasturbine.P_el_set) annotation (Line(points={{-23,8},{-21.5,8},{-21.5,-46.1}}, color={0,0,127}));
  connect(NomalStartup.y, sum2.u[1]) annotation (Line(points={{-55,32},{-52,32},{-52,7},{-46,7}}, color={0,0,127}));
  connect(Shutdown.y, sum2.u[2]) annotation (Line(points={{-55,-16},{-50,-16},{-50,9},{-46,9}}, color={0,0,127}));
  connect(P_SB_neg_set_from_Off.y, sum1.u[3]) annotation (Line(points={{15,66},{30,66},{30,54},{30,21.3333},{34,21.3333}},         color={0,0,127}));
public
function plotResult

  constant String resultFileName = "CheckGasturbine.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={809, 0, 791, 733}, y={"gasturbine.epp.P", "gasturbine.P_el_set", "gasturbine.P_SB_set"}, range={0.0, 7500.0, -140000000.0, 40000000.0}, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}},filename=resultFile);
  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-80,-80},{80,80}})),
    experiment(StopTime=7200),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-120},{100,100}})),
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
</html>"));
end CheckGasturbine;
