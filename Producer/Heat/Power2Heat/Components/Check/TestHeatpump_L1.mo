within TransiEnt.Producer.Heat.Power2Heat.Components.Check;
model TestHeatpump_L1 "Compares L1 heat pump models (static and dynami)"
  import TransiEnt;
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
  TransiEnt.Producer.Heat.Power2Heat.Components.StaticHeatpump OnOffCtrl_L0(Delta_T_db=1) annotation (Placement(transformation(extent={{-46,8},{-10,44}})));
  TransiEnt.Producer.Heat.Power2Heat.Components.Heatpump OnOffBivalentCtrl_Relais_L1(
    Delta_T_db=1,
    T_bivalent=273.15,
    T_heatingLimit=293.15) annotation (Placement(transformation(extent={{-44,-48},{-18,-22}})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor Room_1(T(start=19.6 + 273.15, fixed=true), C=3*3600*1e3)   annotation (Placement(transformation(extent={{8,26},{28,46}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor Room_3(T(start=19.6 + 273.15, fixed=true), C=3*3600*1e3)   annotation (Placement(transformation(extent={{8,-40},{28,-20}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor loss_1(G=50)    annotation (Placement(transformation(extent={{30,19},{44,33}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor loss_3(G=50)    annotation (Placement(transformation(extent={{30,-47},{44,-33}})));

  Modelica.Blocks.Sources.RealExpression T_amb_deg_C(y=simCenter.T_amb_var)       annotation (Placement(transformation(extent={{97,-10},{77,10}})));
  Modelica.Thermal.HeatTransfer.Celsius.PrescribedTemperature
                                                         T_amb_1 annotation (Placement(transformation(extent={{66,20},{52,34}})));
  Modelica.Thermal.HeatTransfer.Celsius.PrescribedTemperature
                                                         T_amb_3 annotation (Placement(transformation(extent={{64,-47},{50,-33}})));
  Modelica.Blocks.Sources.Constant       T_room_set_K(  k=20+273.15)       annotation (Placement(transformation(extent={{-93,-10},{-73,10}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor_1 annotation (Placement(transformation(extent={{8,-7},{-6,7}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor_3 annotation (Placement(transformation(extent={{10,-67},{-4,-53}})));
equation

  connect(Room_3.port, loss_3.port_a) annotation (Line(points={{18,-40},{26,-40},{30,-40}}, color={191,0,0}));
  connect(Room_1.port, loss_1.port_a) annotation (Line(points={{18,26},{30,26}}, color={191,0,0}));
  connect(loss_3.port_b, T_amb_3.port) annotation (Line(points={{44,-40},{47,-40},{50,-40}}, color={191,0,0}));
  connect(T_amb_3.T, T_amb_deg_C.y) annotation (Line(points={{65.4,-40},{72,-40},{72,0},{76,0}}, color={0,0,127}));
  connect(T_amb_1.T, T_amb_deg_C.y) annotation (Line(points={{67.4,27},{72,27},{72,0},{76,0}}, color={0,0,127}));
  connect(T_amb_1.port, loss_1.port_b) annotation (Line(points={{52,27},{50,27},{50,26},{44,26}}, color={191,0,0}));
  connect(OnOffCtrl_L0.heatPort, Room_1.port) annotation (Line(points={{-10,26},{4,26},{18,26}}, color={191,0,0}));
  connect(OnOffBivalentCtrl_Relais_L1.heatPort, Room_3.port) annotation (Line(points={{-18,-35},{-6,-35},{-6,-40},{18,-40}}, color={191,0,0}));
  connect(temperatureSensor_1.port, Room_1.port) annotation (Line(points={{8,0},{10,0},{18,0},{18,26}},    color={191,0,0}));
  connect(temperatureSensor_1.T, OnOffCtrl_L0.u_meas) annotation (Line(points={{-6,0},{-10,0},{-28,0},{-28,5.84}},     color={0,0,127}));
  connect(Room_3.port, temperatureSensor_3.port) annotation (Line(points={{18,-40},{18,-60},{10,-60}}, color={191,0,0}));
  connect(temperatureSensor_3.T, OnOffBivalentCtrl_Relais_L1.u_meas) annotation (Line(points={{-4,-60},{-31,-60},{-31,-49.56}}, color={0,0,127}));
  connect(T_room_set_K.y, OnOffCtrl_L0.u_set) annotation (Line(points={{-72,0},{-60,0},{-60,26},{-46.72,26}}, color={0,0,127}));
  connect(T_room_set_K.y, OnOffBivalentCtrl_Relais_L1.u_set) annotation (Line(points={{-72,0},{-60,0},{-60,-35},{-44.52,-35}}, color={0,0,127}));
public
function plotResult

  constant String resultFileName = "TestHeatpump_L1.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();
 createPlot(id=1, position={809, 0, 791, 817}, y={"Room_1.T",  "Room_3.T"}, range={0.0, 5000.0, 19.400000000000002, 20.6}, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}},filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 269}, y={"OnOffCtrl_L0.heatPort.Q_flow",
"OnOffBivalentCtrl_Relais_L1.heatPort.Q_flow"}, range={0.0, 5000.0, -5000.0, 1000.0}, grid=true, subPlot=2, colors={{28,108,200}, {238,46,47}, {0,140,72}},filename=resultFileName);
createPlot(id=1, position={809, 0, 791, 269}, y={"OnOffBivalentCtrl_Relais_L1.onOffRelais.u", "OnOffBivalentCtrl_Relais_L1.onOffRelais.y"}, range={0.0, 5000.0, -0.2, 1.2000000000000002}, grid=true, subPlot=3, colors={{28,108,200}, {238,46,47}},filename=resultFileName);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
                             experiment(StopTime=5000),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for Heatpump_L1</p>
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
end TestHeatpump_L1;
