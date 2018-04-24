within TransiEnt.Producer.Electrical.Conventional.Components.Check;
model CheckFourthOrderPlant

//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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

  Modelica.Blocks.Sources.Ramp P_el_set(
    duration=16*60,
    offset=1600e6/2,
    startTime=3000,
    height=1600e6*0.9 - 1600e6/2)
    annotation (Placement(transformation(extent={{-64,30},{-44,50}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency grid1(useInputConnector=false, f_set_const=simCenter.f_n) annotation (Placement(transformation(extent={{40,12},{60,32}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  TransiEnt.Producer.Electrical.Conventional.Components.FourthOrderPlant powerPlant_3508_L0_s2_1(P_n=1600e6, Ts=90) annotation (Placement(transformation(extent={{-18,-10},{2,10}})));
  inner TransiEnt.ModelStatistics modelStatistics
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.Ramp P_el_set_2(
    duration=16*60,
    offset=1600e6/2,
    startTime=3000,
    height=1600e6*0.9 - 1600e6/2)
    annotation (Placement(transformation(extent={{-54,-40},{-34,-20}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency grid2(useInputConnector=false, f_set_const=simCenter.f_n) annotation (Placement(transformation(extent={{50,-58},{70,-38}})));
  TransiEnt.Producer.Electrical.Conventional.Components.FourthOrderPlant powerPlant_3508_L0_s2_2(
    P_n=1600e6,
    Ts=90,
    redeclare model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.BrownCoal) annotation (Placement(transformation(extent={{-8,-80},{12,-60}})));
equation
  connect(P_el_set_2.y, powerPlant_3508_L0_s2_2.P_el_set) annotation (Line(
      points={{-33,-30},{-16,-30},{-16,-60.1},{0.5,-60.1}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(P_el_set.y, powerPlant_3508_L0_s2_1.P_el_set) annotation (Line(
      points={{-43,40},{-26.5,40},{-26.5,9.9},{-9.5,9.9}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(powerPlant_3508_L0_s2_1.epp, grid1.epp)
    annotation (Line(
      points={{1.5,5.6},{19.8,5.6},{19.8,21.9},{39.9,21.9}},
      color={0,0,0},
      smooth=Smooth.Bezier));
  connect(powerPlant_3508_L0_s2_2.epp, grid2.epp)
    annotation (Line(
      points={{11.5,-64.4},{30.8,-64.4},{30.8,-48.1},{49.9,-48.1}},
      color={0,0,0},
      smooth=Smooth.Bezier));
public
function plotResult

  constant String resultFileName = "CheckFourthOrderPlant.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
  createPlot(id=1, position={0, 0, 1616, 851}, y={"P_el_set.y", "grid1.epp.P"}, range={0.0, 9000.0, -200000000.0, 1600000000.0}, grid=true, colors={{28,108,200}, {238,46,47}},filename=resultFile);
  createPlot(id=1, position={0, 0, 1616, 423}, y={"grid2.epp.P", "P_el_set_2.y"}, range={0.0, 9000.0, -200000000.0, 1600000000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}},filename=resultFile);
  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
    experiment(StopTime=9000),
    __Dymola_experimentSetupOutput,
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
end CheckFourthOrderPlant;
