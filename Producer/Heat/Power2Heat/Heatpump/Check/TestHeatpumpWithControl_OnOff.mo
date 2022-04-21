within TransiEnt.Producer.Heat.Power2Heat.Heatpump.Check;
model TestHeatpumpWithControl_OnOff "Compares L1 heat pump models (simple and with startup ramp)"
  import TransiEnt;


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




  extends TransiEnt.Basics.Icons.Checkmodel;
  inner SimCenter simCenter(redeclare TransiEnt.Components.Boundaries.Ambient.AmbientConditions_Hamburg_TMY ambientConditions)
                            annotation (Placement(transformation(extent={{-90,80},{-70,100}})));

  TransiEnt.Producer.Heat.Power2Heat.Heatpump.BivalentHeatPumpWithControl OnOffCtrl_L1(
    Modulating=false,
    MinTimes=false,
    Delta_T_db=1,
    usePowerPort=false,
    useFluidPorts=false,
    useHeatPort=true) annotation (Placement(transformation(extent={{-42,12},{-16,38}})));
  TransiEnt.Producer.Heat.Power2Heat.Heatpump.BivalentHeatPumpWithControl OnOffBivalentCtrl_Relais_L2(
    Modulating=false,
    Delta_T_db=1,
    usePowerPort=false,
    useFluidPorts=false,
    useHeatPort=true,
    controller(Startupramp=true)) annotation (Placement(transformation(extent={{-40,-46},{-14,-20}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor Room_2(T(start=19.6 + 273.15, fixed=true), C=3*3600*1e3)   annotation (Placement(transformation(extent={{10,24},{30,44}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor Room_4(T(start=19.6 + 273.15, fixed=true), C=3*3600*1e3)   annotation (Placement(transformation(extent={{8,-40},{28,-20}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor loss_2(G=50)    annotation (Placement(transformation(extent={{32,17},{46,31}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor loss_4(G=50)    annotation (Placement(transformation(extent={{32,-47},{46,-33}})));
  Modelica.Blocks.Sources.RealExpression T_amb_deg_C1(y=simCenter.T_amb_var)      annotation (Placement(transformation(extent={{99,-10},{79,10}})));
  Modelica.Thermal.HeatTransfer.Celsius.PrescribedTemperature
                                                         T_amb_2 annotation (Placement(transformation(extent={{68,18},{54,32}})));
  Modelica.Thermal.HeatTransfer.Celsius.PrescribedTemperature
                                                         T_amb_4 annotation (Placement(transformation(extent={{66,-47},{52,-33}})));
  Modelica.Blocks.Sources.Constant       T_room_set_K1(k=20 + 273.15)      annotation (Placement(transformation(extent={{-95,-10},{-75,10}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor_2 annotation (Placement(transformation(extent={{10,-9},{-4,5}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor_4 annotation (Placement(transformation(extent={{12,-67},{-2,-53}})));
equation

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
equation
  connect(Room_4.port,loss_4. port_a) annotation (Line(points={{18,-40},{32,-40}},          color={191,0,0}));
  connect(Room_2.port,loss_2. port_a) annotation (Line(points={{20,24},{24,24},{24,22},{26,22},{26,24},{32,24}},
                                                                                 color={191,0,0}));
  connect(loss_4.port_b,T_amb_4. port) annotation (Line(points={{46,-40},{52,-40}},          color={191,0,0}));
  connect(T_amb_4.T, T_amb_deg_C1.y) annotation (Line(points={{67.4,-40},{74,-40},{74,0},{78,0}}, color={0,0,127}));
  connect(T_amb_2.T, T_amb_deg_C1.y) annotation (Line(points={{69.4,25},{74,25},{74,0},{78,0}}, color={0,0,127}));
  connect(T_amb_2.port,loss_2. port_b) annotation (Line(points={{54,25},{52,25},{52,24},{46,24}}, color={191,0,0}));
  connect(OnOffCtrl_L1.heatPort,Room_2. port) annotation (Line(points={{-16.78,33.32},{6,33.32},{6,24},{20,24}},
                                                                                                 color={191,0,0}));
  connect(OnOffBivalentCtrl_Relais_L2.heatPort,Room_4. port) annotation (Line(points={{-14.78,-24.68},{-4,-24.68},{-4,-40},{18,-40}},
                                                                                                                             color={191,0,0}));
  connect(temperatureSensor_2.port,Room_2. port) annotation (Line(points={{10,-2},{20,-2},{20,24}},        color={191,0,0}));
  connect(Room_4.port,temperatureSensor_4. port) annotation (Line(points={{18,-40},{18,-60},{12,-60}}, color={191,0,0}));
  connect(OnOffCtrl_L1.T, temperatureSensor_2.T) annotation (Line(points={{-41.48,30.2},{-58,30.2},{-58,-2},{-4.7,-2}}, color={0,0,127}));
  connect(OnOffBivalentCtrl_Relais_L2.T, temperatureSensor_4.T) annotation (Line(points={{-39.48,-27.8},{-64,-27.8},{-64,-60},{-2.7,-60}}, color={0,0,127}));
  connect(T_room_set_K1.y, OnOffCtrl_L1.T_set) annotation (Line(points={{-74,0},{-60,0},{-60,15.51},{-42.39,15.51}}, color={0,0,127}));
  connect(T_room_set_K1.y, OnOffBivalentCtrl_Relais_L2.T_set) annotation (Line(points={{-74,0},{-74,-42.49},{-40.39,-42.49}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-84,76},{84,54}},
          textColor={28,108,200},
          textString="Look at: heatPump.Q_flow and Room_X.heatPort.T")}),
                             experiment(StopTime=864000, __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>Test environment for BivalentHeatpumpWithControl</p>
<p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">4.Interfaces</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">5. Nomenclature</span></b></p>
<p>(no elements)</p>
<p><b><span style=\"color: #008000;\">6. Governing Equations</span></b></p>
<p>(no equations)</p>
<p><b><span style=\"color: #008000;\">7. Remarks for Usage</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">8. Validation</span></b></p>
<p>(no validation or testing necessary)</p>
<p><b><span style=\"color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">10. Version History</span></b></p>
</html>"),
    Icon(coordinateSystem(extent={{-100,-80},{100,100}})));
end TestHeatpumpWithControl_OnOff;
