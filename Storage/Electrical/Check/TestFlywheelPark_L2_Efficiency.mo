within TransiEnt.Storage.Electrical.Check;
model TestFlywheelPark_L2_Efficiency "Example that keeps a flywheel's input and output at full power to check maximum efficiency"
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

  FlywheelPark_L2 flywheel_Park(
    params=Specifications.DetailedFlywheel.Rotokinetik1000(),
    nFlywheels=10,
    k=2e9) annotation (Placement(transformation(extent={{-44,-32},{-24,-12}})));
  inner TransiEnt.SimCenter simCenter
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency FrequencyBoundary(useInputConnector=true) annotation (Placement(transformation(extent={{30,-32},{50,-12}})));
  Modelica.Blocks.Logical.Switch switch "switches between low and high grid frequency"
    annotation (Placement(transformation(extent={{-2,32},{18,52}})));
  Modelica.Blocks.Sources.Constant lowFrequency(k=49) "low frequency"
    annotation (Placement(transformation(extent={{-46,60},{-26,80}})));
  Modelica.Blocks.Sources.Constant highFrequency(k=51) "high frequency"
    annotation (Placement(transformation(extent={{-46,6},{-26,26}})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(
    uLow=0,
    uHigh=1,
    pre_y_start=false)
    annotation (Placement(transformation(extent={{-74,32},{-54,52}})));
equation
  connect(switch.y, FrequencyBoundary.f_set) annotation (Line(
      points={{19,42},{34.6,42},{34.6,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hysteresis.y, switch.u2) annotation (Line(
      points={{-53,42},{-4,42}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(hysteresis.u, flywheel_Park.SOC) annotation (Line(
      points={{-76,42},{-86,42},{-86,-22},{-44,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch.u3, highFrequency.y) annotation (Line(
      points={{-4,34},{-14,34},{-14,16},{-25,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch.u1, lowFrequency.y) annotation (Line(
      points={{-4,50},{-16,50},{-16,70},{-25,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(FrequencyBoundary.epp, flywheel_Park.epp) annotation (Line(
      points={{30,-22},{-7.05,-22},{-7.05,-22},{-24,-22}},
      color={0,0,0},
      smooth=Smooth.None));

public
function plotResult

  constant String resultFileName = "TestFlywheelPark_L2_Efficiency.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={809, 0, 791, 695}, y={"flywheel_Park.epp.P", "flywheel_Park.flywheels[1].epp.P"}, range={0.0, 3600.0, -60000000.0, 60000000.0}, grid=true, colors={{28,108,200}, {238,46,47}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 229}, y={"flywheel_Park.epp.f"}, range={0.0, 3600.0, 48.5, 51.5}, grid=true, subPlot=2, colors={{28,108,200}}, filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 228}, y={"flywheel_Park.SOC"}, range={0.0, 3600.0, -0.5, 1.5}, grid=true, subPlot=3, colors={{28,108,200}}, filename=resultFileName);
   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=3600, Interval=5),
    __Dymola_experimentSetupOutput(events=false),
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
</html>"));
end TestFlywheelPark_L2_Efficiency;
