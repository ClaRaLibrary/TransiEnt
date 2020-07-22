within TransiEnt.Producer.Electrical.Conventional.Components.Check;
model CheckNonlinearThreeStatePlant_PrimaryControl "Example of the component NonlinearThreeStatePlant in primary control operation"

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

  Components.NonlinearThreeStatePlant aSlewRateLimited2StatePBPlant(
    P_el_n=500e6,
    P_grad_max_star=0.1/60,
    fixedStartValue_w=false,
    isSecondaryControlActive=false,
    isExternalSecondaryController=true,
    redeclare Base.ControlPower.PrimarySecondaryAndSchedule controlPowerModel) annotation (Placement(transformation(extent={{-20,-54},{16,-20}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Thermal.FluidHeatFlow.Examples.Utilities.DoubleRamp doubleRamp(
    offset=-500e6,
    interval=3600,
    height_2=-250e6,
    duration_2=300,
    height_1=+450e6,
    duration_1=1,
    startTime=500)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency constantPotentialVariableBoundary1(useInputConnector=true) annotation (Placement(transformation(extent={{70,-24},{90,-4}})));
  Modelica.Blocks.Sources.Sine schedule1(
    offset=50,
    amplitude=0.1,
    startTime=0,
    freqHz=1/3600)
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
equation
  connect(schedule1.y, constantPotentialVariableBoundary1.f_set)
    annotation (Line(
      points={{61,30},{74.6,30},{74.6,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(aSlewRateLimited2StatePBPlant.epp, constantPotentialVariableBoundary1.epp)
    annotation (Line(
      points={{14.2,-25.1},{42.55,-25.1},{42.55,-14},{70,-14}},
      color={0,135,135},
      thickness=0.5,
      smooth=Smooth.None));

  connect(doubleRamp.y, aSlewRateLimited2StatePBPlant.P_el_set) annotation (Line(points={{-39,-10},{-39,-10},{-4.7,-10},{-4.7,-20.17}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "CheckNonlinearThreeStatePlant_PrimaryControl.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={809, 0, 791, 733}, y={"aSlewRateLimited2StatePBPlant.epp.P", "aSlewRateLimited2StatePBPlant.P_el_set"}, range={0.0, 5000.0, -550000000.0, 50000000.0}, grid=true, colors={{28,108,200}, {238,46,47}},filename=resultFile);
  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},{100,100}})),
    experiment(StopTime=5000),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-100,-160},{100,100}})),
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
end CheckNonlinearThreeStatePlant_PrimaryControl;
