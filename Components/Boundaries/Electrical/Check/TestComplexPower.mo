within TransiEnt.Components.Boundaries.Electrical.Check;
model TestComplexPower "Simple Test Model for the ComplexPowerPort"
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
    Q_gen(start=200),
    v_gen(displayUnit="kV"),
    P_gen(start=10000000, displayUnit="kW")) annotation (Placement(transformation(extent={{-58,34},{-38,54}})));
  inner TransiEnt.SimCenter simCenter(v_n=25e3)
    annotation (Placement(transformation(extent={{-70,-78},{-50,-58}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-44,-80},{-24,-60}})));
  TransiEnt.Consumer.Electrical.ExponentialElectricConsumerComplex load(
    useCosPhi=false,
    redeclare TransiEnt.Consumer.Electrical.Characteristics.Constant variability,
    Q_el_set=200,
    P_el_set_const(displayUnit="MW") = 10000000)
                  annotation (Placement(transformation(extent={{36,34},{56,54}})));

  TransiEnt.Components.Electrical.Grid.PiModelComplex TransmissionLine(LVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K1, l=4000)
                                                                                                                                                                annotation (Placement(transformation(extent={{-14,34},{6,54}})));
  TransiEnt.Components.Boundaries.Electrical.ComplexPower.SlackBoundary slackMachine1(
    Q_gen(start=200),
    v_gen(displayUnit="kV"),
    P_gen(start=10000000, displayUnit="kW")) annotation (Placement(transformation(extent={{-60,6},{-40,26}})));
  TransiEnt.Consumer.Electrical.ExponentialElectricConsumerComplex load1(
    useCosPhi=false,
    redeclare TransiEnt.Consumer.Electrical.Characteristics.Constant variability,
    Q_el_set=200,
    P_el_set_const(displayUnit="MW") = 10000000)
                  annotation (Placement(transformation(extent={{34,6},{54,26}})));
  TransiEnt.Components.Electrical.Grid.PiModelComplex_advanced TransmissionLine1(LVCableType=TransiEnt.Components.Electrical.Grid.Characteristics.LVCabletypes.K1, l=4000) annotation (Placement(transformation(extent={{-16,6},{4,26}})));
// _____________________________________________
//
//           Functions
// _____________________________________________

public
function plotResult

  constant String resultFileName = "TestComplexPower.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={809, 0, 791, 733}, y={"slackMachine.epp.P", "load.epp.P"}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
createPlot(id=1, position={809, 0, 791, 364}, y={"slackMachine.epp.v", "load.epp.v"}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
createPlot(id=2, position={0, 0, 791, 733}, y={"slackMachine1.epp.P", "load1.epp.P"}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFile);
createPlot(id=2, position={0, 0, 791, 364}, y={"slackMachine1.epp.v", "load1.epp.v"}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFile);

    resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;

equation

// _____________________________________________
//
//               Connect Statements
// _____________________________________________

  connect(TransmissionLine.epp_n, load.epp) annotation (Line(
      points={{6,44},{36.2,44}},
      color={28,108,200},
      thickness=0.5));
  connect(TransmissionLine.epp_p, slackMachine.epp) annotation (Line(
      points={{-14,44},{-28,44},{-28,44},{-58,44}},
      color={28,108,200},
      thickness=0.5));
  connect(TransmissionLine1.epp_n, load1.epp) annotation (Line(
      points={{4,16},{34.2,16}},
      color={28,108,200},
      thickness=0.5));
  connect(TransmissionLine1.epp_p, slackMachine1.epp) annotation (Line(
      points={{-16,16},{-40,16},{-40,16},{-60,16}},
      color={28,108,200},
      thickness=0.5));

  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
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
    experiment,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end TestComplexPower;
