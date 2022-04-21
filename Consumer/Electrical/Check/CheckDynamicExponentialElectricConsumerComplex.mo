within TransiEnt.Consumer.Electrical.Check;
model CheckDynamicExponentialElectricConsumerComplex


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





  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Checkmodel;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________


  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-78,-94},{-58,-74}})));
  TransiEnt.Components.Boundaries.Electrical.ComplexPower.SlackBoundary slackBoundary(useInputConnectorv=true, useInputConnectorf=true) annotation (Placement(transformation(extent={{26,-10},{46,10}})));
  TransiEnt.Consumer.Electrical.DynamicExponentialElectricConsumerComplex
                                                      load(
    Tp=10,
    Tq=5,
    kpf=1.2,
    kqf=0.05) annotation (Placement(transformation(extent={{-42,-10},{-62,10}})));
  Modelica.Blocks.Sources.Step step(
    height=-10000,
    offset=110000,
    startTime=1) annotation (Placement(transformation(extent={{-12,16},{8,36}})));
  Modelica.Blocks.Sources.Step step1(
    height=-2,
    offset=50,
    startTime=101) annotation (Placement(transformation(extent={{16,46},{36,66}})));
  TransiEnt.Consumer.Electrical.ExponentialElectricConsumerComplex load1(
    P_el_set_const=100e6,
    useCosPhi=false,
    Q_el_set=50e6,
    P_n=100e6,
    Q_n=50e6,
    variability(
      kpf=1.2,
      kpu=0.38,
      kqf=0.05,
      kqu=2)) annotation (Placement(transformation(extent={{-44,-50},{-64,-30}})));

// _____________________________________________
//
//           Functions
// _____________________________________________

public
function plotResult

  constant String resultFileName = "CheckDynamicExponentialElectricConsumerComplex.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={0, 0, 791, 733}, y={"load.epp.P","load1.epp.P"}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
createPlot(id=1, position={0, 0, 791, 364}, y={"load.epp.Q","load1.epp.Q"},  grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFile);

    resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;


equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(load.epp, slackBoundary.epp) annotation (Line(
      points={{-42,0},{26,0}},
      color={28,108,200},
      thickness=0.5));
  connect(step.y, slackBoundary.v_gen_set) annotation (Line(points={{9,26},{30,26},{30,12}}, color={0,0,127}));
  connect(step1.y, slackBoundary.f_gen_set) annotation (Line(points={{37,56},{46,56},{46,12},{42,12}}, color={0,0,127}));
  connect(load1.epp, slackBoundary.epp) annotation (Line(
      points={{-44.2,-40},{0,-40},{0,0},{26,0}},
      color={28,108,200},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Test environment for the dynamic electric consumer with a variable grid voltage and a variable grid frequency</p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in March 2021</span></p>
</html>"),
    experiment(StopTime=200, __Dymola_Algorithm="Dassl"));
end CheckDynamicExponentialElectricConsumerComplex;
