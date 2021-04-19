within TransiEnt.Components.Electrical.PowerTransformation.Check;
model TestTransformerPiModelComplex "Simple Test Model for TransformerPiModelComplex"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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

// _____________________________________________
//
//          Imports and Class Hierarchy
// _____________________________________________

  extends TransiEnt.Basics.Icons.Checkmodel;

// _____________________________________________
//
//             Variable Declarations
// _____________________________________________

// _____________________________________________
//
//           Instances of other Classes
// _____________________________________________

  TransiEnt.Components.Boundaries.Electrical.ComplexPower.SlackBoundary slackMachine(
    Q_gen(start=2e6),
    v_gen(displayUnit="kV") = 10000,
    P_gen(start=1e3, displayUnit="W"))       annotation (Placement(transformation(extent={{-64,34},{-84,54}})));
  inner TransiEnt.SimCenter simCenter(v_n=110e3)
    annotation (Placement(transformation(extent={{-70,-78},{-50,-58}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-44,-80},{-24,-60}})));
  TransiEnt.Consumer.Electrical.ExponentialElectricConsumerComplex load(
    useInputConnectorP=true,
    useCosPhi=true,
    cosphi_set=0.86,
    v_n=400,
    redeclare TransiEnt.Consumer.Electrical.Characteristics.Constant variability,
    Q_el_set=200,
    P_el_set_const(displayUnit="MW") = 10000000)
                  annotation (Placement(transformation(extent={{28,34},{48,54}})));

  TransiEnt.Components.Electrical.Grid.PiModelComplex TransmissionLine(
    ChooseVoltageLevel=1,
    LVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K15,
    MVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.MVCabletypes.L1,
    l=100)                                                                                                                                                      annotation (Placement(transformation(extent={{-14,34},{6,54}})));
                                                                                                                                                                 TransiEnt.Components.Electrical.PowerTransformation.TransformerPiModelComplex transformerPiModelComplex(U_P=10e3, U_S=400)   annotation (Placement(transformation(extent={{-52,34},{-32,54}})));
  Modelica.Blocks.Sources.Step step(
    height=20e3,
    offset=100e3,
    startTime(displayUnit="s") = 1)   annotation (Placement(transformation(extent={{6,68},{26,88}})));
// _____________________________________________
//
//           Functions
// _____________________________________________

public
function plotResult

  constant String resultFileName = "TestTransformerPiModelComplex.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={0, 0, 791, 733}, y={"slackMachine.epp.P", "load.epp.P"}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
createPlot(id=1, position={0, 0, 791, 364}, y={"slackMachine.epp.v", "load.epp.v"}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFile);

    resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;


  TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary pQBoundary(
    useInputConnectorP=false,
    useInputConnectorQ=false,
    useCosPhi=false,
    v_n=400)  annotation (Placement(transformation(extent={{-2,-2},{18,18}})));
equation

// _____________________________________________
//
//               Connect Statements
// _____________________________________________

  connect(TransmissionLine.epp_n, load.epp) annotation (Line(
      points={{6,44},{28.2,44}},
      color={28,108,200},
      thickness=0.5));

  connect(slackMachine.epp, transformerPiModelComplex.epp_p) annotation (Line(
      points={{-64,44},{-52,44}},
      color={28,108,200},
      thickness=0.5));
  connect(transformerPiModelComplex.epp_n, TransmissionLine.epp_p) annotation (Line(
      points={{-32,44},{-14,44}},
      color={28,108,200},
      thickness=0.5));
  connect(step.y, load.P_el_set) annotation (Line(points={{27,78},{38,78},{38,55.6}}, color={0,0,127}));
  connect(pQBoundary.epp, TransmissionLine.epp_p) annotation (Line(
      points={{-2,8},{-24,8},{-24,44},{-14,44}},
      color={28,108,200},
      thickness=0.5));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
                                      Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Test of the complex power port</p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in March 2018</span></p>
</html>"),
    experiment(StopTime=2),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end TestTransformerPiModelComplex;
