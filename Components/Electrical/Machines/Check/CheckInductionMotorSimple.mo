within TransiEnt.Components.Electrical.Machines.Check;
model CheckInductionMotorSimple "Test for InductionMotorComplexAllElectric"


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
//             Variable Declarations
// _____________________________________________

// _____________________________________________
//
//           Instances of other Classes
// _____________________________________________

  TransiEnt.Components.Boundaries.Electrical.ComplexPower.SlackBoundary slackMachine(
    useInputConnectorv=true,
    useInputConnectorf=true,
    P_gen(start=1),
    Q_gen(start=0.5),
    v_gen(displayUnit="V")) annotation (Placement(transformation(extent={{38,16},{58,36}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-32,-42},{-12,-22}})));

  inner TransiEnt.SimCenter simCenter(v_n(displayUnit="V") = 6000)
    annotation (Placement(transformation(extent={{4,-42},{24,-22}})));
  TransiEnt.Components.Electrical.Machines.InductionMotorSimple asynchronousMotorComplex annotation (Placement(transformation(extent={{-30,-12},{-10,8}})));
  TransiEnt.Components.Boundaries.Mechanical.Power MechanicalBoundary1(tau_is(start=15.52))
                                                                      annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=0,
        origin={-73,-17})));
  Modelica.Blocks.Sources.Constant const1(k=727384)
                                              annotation (Placement(transformation(extent={{-128,38},{-118,48}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=10,
    startTime=1,
    height=-30000)
                 annotation (Placement(transformation(extent={{-130,8},{-110,28}})));
  Modelica.Blocks.Math.Add add annotation (Placement(transformation(extent={{-98,24},{-78,44}})));

// _____________________________________________
//
//           Functions
// _____________________________________________

public
function plotResult

  constant String resultFileName = "CheckAsynchronousMotor_L3E.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={809, 0, 791, 733}, y={"asynchronousMotorComplex.S.re", "asynchronousMotorComplex.S.im","asynchronousMotorComplex.P_mech"}, grid=true, colors={{28,108,200}, {238,46,47},{0,0,0}}, filename=resultFile);
createPlot(id=1, position={809, 0, 791, 364}, y={"asynchronousMotorComplex.slip", "asynchronousMotorComplex.f_rotor"}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}}, filename=resultFile);

    resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;

  TransiEnt.Components.Sensors.ElectricFrequencyComplex globalFrequency annotation (Placement(transformation(extent={{-56,-2},{-36,18}})));
  Modelica.Blocks.Sources.Step stepV(
    height=-600,
    offset=6000,
    startTime=20) annotation (Placement(transformation(extent={{-6,60},{14,80}})));
  Modelica.Blocks.Sources.Step stepf(
    height=-1,
    offset=50,
    startTime=30) annotation (Placement(transformation(extent={{24,76},{44,96}})));
equation
// _____________________________________________
//
//               Connect Statements
// _____________________________________________
  connect(asynchronousMotorComplex.mpp, MechanicalBoundary1.mpp) annotation (Line(points={{-30,-2},{-40,-2},{-40,-16},{-50,-16},{-50,-17},{-64,-17}},
                                                                                                                                      color={95,95,95}));
  connect(add.u2, ramp.y) annotation (Line(points={{-100,28},{-106,28},{-106,18},{-109,18}}, color={0,0,127}));
  connect(add.u1, const1.y) annotation (Line(points={{-100,40},{-109,40},{-109,43},{-117.5,43}}, color={0,0,127}));
  connect(add.y, MechanicalBoundary1.P_mech_set) annotation (Line(points={{-77,34},{-68,34},{-68,10},{-70,10},{-70,-6.38},{-73,-6.38}},
                                                                                                         color={0,0,127}));
  connect(globalFrequency.f, asynchronousMotorComplex.f_converter) annotation (Line(points={{-35.6,8},{-24,8},{-24,7.6},{-20,7.6}}, color={0,0,127}));
  connect(slackMachine.epp, globalFrequency.epp) annotation (Line(
      points={{38,26},{-56,26},{-56,8}},
      color={28,108,200},
      thickness=0.5));
  connect(asynchronousMotorComplex.epp, globalFrequency.epp) annotation (Line(
      points={{-9.9,-2.1},{10,-2.1},{10,26},{-56,26},{-56,8}},
      color={28,108,200},
      thickness=0.5));
  connect(stepV.y, slackMachine.v_gen_set) annotation (Line(points={{15,70},{42,70},{42,38}}, color={0,0,127}));
  connect(stepf.y, slackMachine.f_gen_set) annotation (Line(points={{45,86},{54,86},{54,38}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{100,100}})),
                                                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{100,100}})),
    experiment(StopTime=50),Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Test environment for AsynchronousMotor_L3E</p>
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
<p>(no validation or testing necessary)</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Jan-Peter Heckel (jan.heckel@tuhh.de) in July 2019</span></p>
</html>"),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=false,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end CheckInductionMotorSimple;
