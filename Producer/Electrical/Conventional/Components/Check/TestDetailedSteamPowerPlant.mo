within TransiEnt.Producer.Electrical.Conventional.Components.Check;
model TestDetailedSteamPowerPlant
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

  Components.DetailedSteamPowerPlant SteamPowerPlant2(P_n=900000000, SetValueMinimumLoad=true)
                                                                     annotation (Placement(transformation(extent={{30,-44},{50,-24}})));
  Components.DetailedSteamPowerPlant SteamPowerPlant1(P_n=800000000) annotation (Placement(transformation(extent={{-26,0},{-8,18}})));
  Modelica.Blocks.Sources.Ramp PTarget2(
    duration=1,
    startTime=10000,
    offset=-900e6,
    height=0.8*900e6) annotation (Placement(transformation(extent={{-98,-74},{-78,-54}})));
  Modelica.Blocks.Sources.Ramp PTarget1(
    duration=1,
    startTime=10000,
    offset=-800e6,
    height=0.8*800e6)
    annotation (Placement(transformation(extent={{-100,-6},{-80,14}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency constantFrequency_L1_1(useInputConnector=false) annotation (Placement(transformation(extent={{56,36},{76,56}})));

function plotResult

  constant String resultFileName = "TestDetailedSteamPowerPlant.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
  createPlot(id=1, position={0, 0, 1275, 889}, y={"SteamPowerPlant1.P_out.y", "SteamPowerPlant2.P_out.y"}, range={0.0, 50000.0, 720000000.0, 1100000000.0}, grid=true, filename="TestDetailedSteamPowerPlant.mat", legends={"Plant 1 power output [W]", "Plant 2 power output [W]"}, colors={{28,108,200}, {0,140,72}});
  plotExpression(apply(-1*TestDetailedSteamPowerPlant[end].PTarget1.y), false, "Set Value Plant 1", 1);
  plotExpression(apply(-1*TestDetailedSteamPowerPlant[end].PTarget2.y), false, "Set Value Plant 2", 1);
  plotText(id=1, extent={{14000,1.068e+009}, {27200,9.18e+008}}, textString="Two plants with nominal power of 800 and 900MW react \n to a change in the set value of from 100 to 90 percent", horizontalAlignment=TextAlignment.Left);
  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;

  Modelica.Blocks.Sources.Ramp PTarget3(
    duration=1,
    height=0.2*900e6,
    offset=0,
    startTime=18000)  annotation (Placement(transformation(extent={{-98,-42},{-78,-22}})));
  Modelica.Blocks.Math.Add add annotation (Placement(transformation(extent={{-66,-54},{-46,-34}})));
  Modelica.Blocks.Sources.Ramp PTarget4(
    duration=1,
    offset=0,
    startTime=18000,
    height=0.2*800e6) annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Modelica.Blocks.Math.Add add1 annotation (Placement(transformation(extent={{-66,14},{-46,34}})));
  Modelica.Blocks.Sources.Ramp PTarget5(
    duration=1,
    height=-0.8*900e6,
    offset=0,
    startTime=22000)  annotation (Placement(transformation(extent={{-100,-108},{-80,-88}})));
  Modelica.Blocks.Math.Add add2 annotation (Placement(transformation(extent={{-16,-80},{4,-60}})));
equation
  connect(SteamPowerPlant1.epp, constantFrequency_L1_1.epp) annotation (Line(
      points={{-8.45,14.04},{-8.45,26.02},{55.9,26.02},{55.9,45.9}},
      color={0,135,135},
      thickness=0.5));
  connect(SteamPowerPlant2.epp, constantFrequency_L1_1.epp) annotation (Line(
      points={{49.5,-28.4},{49.5,-28.2},{55.9,-28.2},{55.9,45.9}},
      color={0,135,135},
      thickness=0.5));
  connect(PTarget2.y, add.u2) annotation (Line(points={{-77,-64},{-68,-64},{-68,-50}}, color={0,0,127}));
  connect(PTarget3.y, add.u1) annotation (Line(points={{-77,-32},{-68,-32},{-68,-38}}, color={0,0,127}));
  connect(add1.u1, PTarget4.y) annotation (Line(points={{-68,30},{-79,30},{-79,40}}, color={0,0,127}));
  connect(add1.u2, PTarget1.y) annotation (Line(points={{-68,18},{-79,18},{-79,4}}, color={0,0,127}));
  connect(add.y, add2.u1) annotation (Line(points={{-45,-44},{-45,-44},{-18,-44},{-18,-64}}, color={0,0,127}));
  connect(PTarget5.y, add2.u2) annotation (Line(points={{-79,-98},{-72,-98},{-72,-76},{-18,-76}}, color={0,0,127}));
  connect(add1.y, SteamPowerPlant1.P_set) annotation (Line(points={{-45,24},{-24.38,24},{-24.38,20.52}}, color={0,0,127}));
  connect(add2.y, SteamPowerPlant2.P_set) annotation (Line(points={{5,-70},{22,-70},{22,-14},{31.8,-14},{31.8,-21.2}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})), experiment(StopTime=50000),
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
end TestDetailedSteamPowerPlant;
