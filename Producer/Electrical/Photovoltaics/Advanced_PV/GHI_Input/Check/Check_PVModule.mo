within TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.GHI_Input.Check;
model Check_PVModule
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
  extends TransiEnt.Basics.Icons.Checkmodel;
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  TransiEnt.Basics.Tables.Ambient.GHI_Hamburg_3600s_2012_TMY gHI_Hamburg_3600s_0101_3112_IWECfile1 annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid1 annotation (Placement(transformation(extent={{44,-10},{64,10}})));
  TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_Fuhlsbuettel_3600s_2012 temperature_Hamburg_3600s_IWEC_from_SAM annotation (Placement(transformation(extent={{-64,40},{-44,60}})));
  TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_3600s_TMY wind_Hamburg_3600s_01012012_31122012_Wind_Hamburg_175m annotation (Placement(transformation(extent={{-64,-76},{-44,-56}})));
  PVModule pVModule(DiffuseModel="Skartveit and Olseth",
    PVModuleCharacteristics=Characteristics.PVModule_Characteristics_Sanyo_HIT_200_BA3(),
    redeclare model Skymodel = TransiEnt.Producer.Heat.SolarThermal.Base.Skymodel_HDKR,
    integratePowerDc=false,
    integratePowerOut=false)                             annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
equation
  connect(temperature_Hamburg_3600s_IWEC_from_SAM.y1, pVModule.T_in) annotation (Line(points={{-43,50},{-26,50},{-26,8},{-10,8}},   color={0,0,127}));
  connect(gHI_Hamburg_3600s_0101_3112_IWECfile1.y1, pVModule.GHI_in) annotation (Line(points={{-45,0},{-10,0}},                       color={0,0,127}));
  connect(wind_Hamburg_3600s_01012012_31122012_Wind_Hamburg_175m.y1, pVModule.WindSpeed_in) annotation (Line(points={{-43,-66},{-26,-66},{-26,-8},{-10,-8}},   color={0,0,127}));
  connect(pVModule.epp, ElectricGrid1.epp) annotation (Line(
      points={{11.3,-0.6},{24.65,-0.6},{24.65,0},{44,0}},
      color={0,135,135},
      thickness=0.5));
public
function plotResult

  constant String resultFileName = "Check_PVModule.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
createPlot(id=3, position={809, 0, 791, 695}, y={"pVModule.epp.P", "gHI_Hamburg_3600s_0101_3112_IWECfile1.y1"}, range={0.0, 1700000.0, -50.0, 250.0}, autoscale=false, grid=true, colors={{28,108,200}, {238,46,47}}, range2={0.15000000000000002, 0.4},filename=resultFile);
createPlot(id=3, position={809, 0, 791, 229}, y={"temperature_Hamburg_3600s_IWEC_from_SAM.y1"}, range={0.0, 1700000.0, -10.0, 15.0}, autoscale=false, grid=true, subPlot=2, colors={{28,108,200}},filename=resultFile);
createPlot(id=3, position={809, 0, 791, 228}, y={"wind_Hamburg_3600s_01012012_31122012_Wind_Hamburg_175m.y1"}, range={0.0, 1700000.0, 0.0, 20.0}, autoscale=false, grid=true, subPlot=3, colors={{28,108,200}},filename=resultFile);
  resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(StopTime=3.1536e+007, Interval=3600),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the pVModule model</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end Check_PVModule;
