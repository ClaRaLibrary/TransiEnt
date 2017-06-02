within TransiEnt.Producer.Electrical.Conventional.Components.Check;
model CheckNonlinearThreeStatePlant_Loadstep "Example of the component NonlinearThreeStatePlant"

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

  Components.NonlinearThreeStatePlant Gen_1(
    P_el_n=500e6,
    P_min_star=0.2,
    P_grad_max_star=0.1/60,
    nSubgrid=2,
    fixedStartValue_w=false,
    isSecondaryControlActive=false,
    isExternalSecondaryController=false,
    isPrimaryControlActive=true)         annotation (Placement(transformation(extent={{-52,-26},{-16,8}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency constantPotentialVariableBoundary(useInputConnector=false) annotation (Placement(transformation(extent={{48,-12},{68,8}})));
  inner TransiEnt.SimCenter simCenter(useThresh=false)
                                      annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Sources.Step P_step(
    offset=-500e6,
    startTime=900,
    height=50e6)   annotation (Placement(transformation(extent={{-89,14},{-69,34}})));
  Components.NonlinearThreeStatePlant Gen_2(
    P_el_n=500e6,
    P_min_star=0.2,
    P_grad_max_star=0.1/60,
    nSubgrid=2,
    fixedStartValue_w=false,
    isSecondaryControlActive=false,
    isExternalSecondaryController=false,
    isPrimaryControlActive=true)         annotation (Placement(transformation(extent={{-54,-112},{-18,-78}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency constantPotentialVariableBoundary1(useInputConnector=false) annotation (Placement(transformation(extent={{48,-98},{68,-78}})));
  Modelica.Blocks.Sources.Step P_step1(
    offset=-500e6,
    startTime=900,
    height=50e6)   annotation (Placement(transformation(extent={{-90,-72},{-70,-52}})));
equation

  connect(Gen_1.epp, constantPotentialVariableBoundary.epp) annotation (Line(
      points={{-16.9,0.52},{47.9,0.52},{47.9,-2.1}},
      color={0,135,135},
      thickness=0.5));
  connect(P_step.y, Gen_1.P_el_set) annotation (Line(points={{-68,24},{-52,24},{-36.7,24},{-36.7,7.83}},                   color={0,0,127}));
  connect(Gen_2.epp, constantPotentialVariableBoundary1.epp) annotation (Line(
      points={{-18.9,-85.48},{47.9,-85.48},{47.9,-88.1}},
      color={0,135,135},
      thickness=0.5));
  connect(P_step1.y, Gen_2.P_el_set) annotation (Line(points={{-69,-62},{-52,-62},{-38.7,-62},{-38.7,-78.17}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "CheckNonlinearThreeStatePlant_Loadstep.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=2, position={809, 0, 791, 733}, y={"P_step.y", "Gen_1.epp.P"}, range={0.0, 7500.0, -520000000.0, -280000000.0}, grid=true, colors={{28,108,200}, {238,46,47}},filename=resultFile);
createPlot(id=2, position={809, 0, 791, 364}, y={"P_step1.y", "Gen_2.epp.P"}, range={0.0, 7500.0, -550000000.0, -250000000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}},filename=resultFile);
  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},{100,100}})),
    experiment(StopTime=7200),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-160},{100,100}})),
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
end CheckNonlinearThreeStatePlant_Loadstep;
