within TransiEnt.Components.Electrical.Machines.Check;
model CheckMotorComplex "Test for MotorComplex"
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
    v_gen=1,
    P_gen(start=1),
    Q_gen(start=0.5)) annotation (Placement(transformation(extent={{-68,54},{-48,74}})));
  TransiEnt.Components.Boundaries.Electrical.ComplexPower.PVBoundary pUMachine(v_gen=1, P_gen=1.5) annotation (Placement(transformation(extent={{70,54},{50,74}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-32,-42},{-12,-22}})));
  TransiEnt.Components.Electrical.Grid.Components.ReactanceComplex reactanceComplex(l=1, x=0.1) annotation (Placement(transformation(extent={{-12,54},{8,74}})));
  TransiEnt.Components.Electrical.Grid.Components.ReactanceComplex reactanceComplex1(l=1, x=0.1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-32,30})));
  TransiEnt.Components.Electrical.Grid.Components.ReactanceComplex reactanceComplex2(l=1, x=0.1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={36,32})));


  inner TransiEnt.SimCenter simCenter(v_n=1)
    annotation (Placement(transformation(extent={{4,-42},{24,-22}})));
  TransiEnt.Components.Electrical.Machines.MotorComplex motorComplex(eta=0.9)
                                                                     annotation (Placement(transformation(extent={{-30,-12},{-10,8}})));
  TransiEnt.Components.Boundaries.Mechanical.Power MechanicalBoundary1
                                                                      annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=0,
        origin={-59,-3})));
  Modelica.Blocks.Sources.Constant const1(k=2)
                                              annotation (Placement(transformation(extent={{-84,14},{-74,24}})));


// _____________________________________________
//
//           Functions
// _____________________________________________

public
function plotResult

  constant String resultFileName = "CheckMotorComplex.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={809, 0, 791, 733}, y={"motorComplex.S.re", "motorComplex.S.im","motorComplex.P_mech"}, grid=true, colors={{28,108,200}, {238,46,47},{0,0,0}}, filename=resultFile);
createPlot(id=1, position={809, 0, 791, 364}, y={"motorComplex.V_is", "motorComplex.delta_is"}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFile);

    resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;

equation

// _____________________________________________
//
//               Connect Statements
// _____________________________________________

  connect(slackMachine.epp, reactanceComplex.epp_p) annotation (Line(
      points={{-68,64},{-29.95,64},{-29.95,64},{-12,64}},
      color={28,108,200},
      thickness=0.5));
  connect(reactanceComplex.epp_n, pUMachine.epp) annotation (Line(
      points={{8,64},{34,64},{34,64},{70,64}},
      color={28,108,200},
      thickness=0.5));
  connect(reactanceComplex1.epp_n, reactanceComplex.epp_p) annotation (Line(
      points={{-32,40},{-32,64},{-30,64},{-29.95,63.9},{-29.95,64},{-12,64}},
      color={28,108,200},
      thickness=0.5));
  connect(reactanceComplex2.epp_p, pUMachine.epp) annotation (Line(
      points={{36,42},{36,42},{36,64},{70,64},{70,64}},
      color={28,108,200},
      thickness=0.5));
  connect(motorComplex.epp, reactanceComplex2.epp_n) annotation (Line(
      points={{-9.9,-2.1},{36,-2.1},{36,20},{36,20},{36,22},{36,22}},
      color={28,108,200},
      thickness=0.5));
  connect(reactanceComplex1.epp_p, reactanceComplex2.epp_n) annotation (Line(
      points={{-32,20},{-10,20},{-10,20},{36,20},{36,20},{36,20},{36,22},{36,22}},
      color={28,108,200},
      thickness=0.5));
  connect(motorComplex.mpp, MechanicalBoundary1.mpp) annotation (Line(points={{-30,-2},{-50,-2},{-50,-3}},                color={95,95,95}));
  connect(const1.y, MechanicalBoundary1.P_mech_set) annotation (Line(points={{-73.5,19},{-73.5,18.5},{-59,18.5},{-59,7.62}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Test environment for MotorComplex</p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in Apr 2018</span></p>
</html>"),
    experiment,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end CheckMotorComplex;
