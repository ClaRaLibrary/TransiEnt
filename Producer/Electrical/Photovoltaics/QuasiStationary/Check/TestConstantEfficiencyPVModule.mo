within TransiEnt.Producer.Electrical.Photovoltaics.QuasiStationary.Check;
model TestConstantEfficiencyPVModule
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

  parameter SI.Area A_module=1 "PV Module surface";
  parameter SI.Efficiency eta=0.2 "Total efficiency from radiation to power output";

  TransiEnt.Components.Boundaries.Electrical.ApparentPower.FrequencyVoltage Grid(
    Use_input_connector_f=false,
    f_boundary=50,
    v_boundary=230,
    Use_input_connector_v=true) annotation (Placement(transformation(extent={{-52,-2},{-72,18}})));
  TransiEnt.Basics.Adapters.EPP_to_QS Adapter annotation (Placement(transformation(rotation=0, extent={{-44,4},{-36,12}})));

  inner TransiEnt.SimCenter simCenter
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

  TransiEnt.Components.Electrical.Grid.PIModelQS Line(param=TransiEnt.Components.Electrical.Grid.Characteristics.LV_K1()) annotation (Placement(transformation(rotation=0, extent={{-32,2},{-12,22}})));

  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Resistor Load1(R_ref=50)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-4,-6})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground Ground
    annotation (Placement(transformation(extent={{-14,-38},{6,-18}})));

  Modelica.Blocks.Sources.RealExpression GlobalSolarRadiation(y=
        ambientConditions.globalSolarRadiation.value)
    annotation (Placement(transformation(extent={{-44,-74},{-28,-38}})));

  Modelica.Blocks.Sources.Step Step_20_pu(
    offset=230,
    startTime=4e4,
    height=46) annotation (Placement(transformation(extent={{-92,30},{-72,50}})));
  PhotovoltaicModuleQS pV_Module annotation (Placement(transformation(rotation=0, extent={{14,-66},{34,-46}})));
  inner TransiEnt.Components.Boundaries.Ambient.AmbientConditions ambientConditions(
    redeclare TransiEnt.Basics.Tables.Ambient.GHI_Hamburg_3600s_2012_TMY globalSolarRadiation,
    redeclare TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperature,
    redeclare TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_Fuhlsbuettel_3600s_2012 wind(relativepath="/ambient/Wind_Hamburg_3600s_TMY.txt")) annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
equation
  connect(Adapter.epp, Grid.epp) annotation (Line(points={{-44,8},{-50,8},{-50,7.9},{-51.9,7.9}},
                         color={0,127,0}));
  connect(Adapter.voltageP, Line.pin_p1) annotation (Line(points={{-36,8},{-36,12},{-32,12}},    color={85,170,255}));
  connect(Load1.pin_p, Line.pin_p2) annotation (Line(points={{-4,4},{-4,12},{-11.8,12}},  color={85,170,255}));
  connect(Load1.pin_n, Ground.pin)
    annotation (Line(points={{-4,-16},{-4,-18}},          color={85,170,255}));
  connect(GlobalSolarRadiation.y,pV_Module.u)
                                             annotation (Line(points={{-27.2,-56},{-27.2,-56},{13.6,-56}},color={0,0,127}));
  connect(Step_20_pu.y, Grid.v_set) annotation (Line(points={{-71,40},{-68,40},{-68,20}}, color={0,0,127}));
  connect(pV_Module.currentP,          Line.pin_p2) annotation (Line(points={{34,-56},{54,-56},{54,12},{-11.8,12}},         color={85,170,255}));
public
function plotResult

  constant String resultFileName = "TestConstantEfficiencyPVModule.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=1, position={809, 0, 791, 695}, y={"GlobalSolarRadiation.y"}, range={0.0, 90000.0, -20.0, 60.0}, grid=true, colors={{28,108,200}},filename=resultFile);
createPlot(id=1, position={809, 0, 791, 170}, y={"pV_Module.PVPower.y"}, range={0.0, 90000.0, -10.0, 5.0}, grid=true, subPlot=2, colors={{28,108,200}},filename=resultFile);
createPlot(id=1, position={809, 0, 791, 170}, y={"Grid.epp.v"}, range={0.0, 90000.0, 220.0, 280.0}, grid=true, subPlot=3, colors={{28,108,200}},filename=resultFile);
createPlot(id=1, position={809, 0, 791, 170}, y={"pV_Module.PowerSensorPVPanel.currentP.i.re"}, range={0.0, 90000.0, -0.04, 0.019999999999999997}, grid=true, subPlot=4, colors={{28,108,200}},filename=resultFile);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),                                                                     graphics={
        Text(
          extent={{6,92},{110,50}},
          lineColor={28,108,200},
          textString="Look at:

PVPower.y

Grid.epp.v

PowerSensorPPVPanel.currentP.i.re")}),
                                     Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Test environment for transmission line Pi-Modell with ohmic load and PV</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no validation or testing necessary)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Rebekka Denninger (rebekka.denninger@tuhh.de) on Mon Feb 29 2016</span></p>
</html>"),
    experiment(StopTime=86400, __Dymola_NumberOfIntervals=20),
    __Dymola_experimentSetupOutput(equidistant=false));
end TestConstantEfficiencyPVModule;
