within TransiEnt.Producer.Heat.Power2Heat.Check;
model TestBivalentHeatpumpSystem_L0 "Model for testing the BivalentHeatPumpSystem_L0"
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
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-150,80},{-130,100}})));
  parameter Components.HeatpumpSystemProperties                                        params(HPInitStatus=2)
                                                                                              annotation (Placement(transformation(extent={{-112,80},{-92,100}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor Room(C=params.C_room, T(start=params.T_room_start, fixed=true))
                                                                                              annotation (Placement(transformation(extent={{126,-8},{146,12}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor T_stor_is annotation (Placement(transformation(extent={{2,-44},{-18,-24}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor wall_a(G=params.G_loss)
                                                                            annotation (Placement(transformation(extent={{120,42},{140,62}})));
  Modelica.Thermal.HeatTransfer.Celsius.PrescribedTemperature
                                                         T_amb annotation (Placement(transformation(extent={{94,42},{114,62}})));
  TransiEnt.Components.Visualization.PowerSystemBasics.Energy E_Heatpump(
    E_start=0,
    unit="kWh",
    decimalSpaces=3,
    P=-Heatpump.heatPort.Q_flow/1e3) annotation (Placement(transformation(extent={{-94,-86},{-74,-66}})));
  TransiEnt.Components.Visualization.PowerSystemBasics.Energy E_heatingdemand(
    E_start=0,
    unit="kWh",
    decimalSpaces=3,
    P=T_amb.port.Q_flow/1e3) annotation (Placement(transformation(extent={{4,-88},{24,-68}})));
  Modelica.Blocks.Sources.RealExpression T_amb_deg_C(y=simCenter.ambientConditions.temperature.value)       annotation (Placement(transformation(extent={{63,42},{83,62}})));
  Modelica.Blocks.Sources.Constant zero(k=0) annotation (Placement(transformation(extent={{-70,7},{-60,17}})));
  Modelica.Blocks.Logical.Switch Q_flow_peakload annotation (Placement(transformation(extent={{-40,17},{-26,31}})));
  Modelica.Blocks.Continuous.LimPID ctrlPeakload(
    yMin=0,
    Td=0.01,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
      yMax=params.Q_flow_n_peakunit,
    Ti=60,
      k=1e4)                  annotation (Placement(transformation(extent={{-96,42},{-76,62}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatBdryPeakloadFH annotation (Placement(transformation(extent={{-18,14},{2,34}})));
  TransiEnt.Components.Visualization.PowerSystemBasics.Energy E_Peakload(
    E_start=0,
    unit="kWh",
    decimalSpaces=3,
    P=-Q_flow_peakload.y/1e3) annotation (Placement(transformation(extent={{-66,-88},{-46,-68}})));
  Modelica.Blocks.Sources.RealExpression x_PeakLoad_per_Cent(y=E_Peakload.E/(E_Heatpump.E + E_Peakload.E + 0.0001)*100) annotation (Placement(transformation(extent={{58,-90},{78,-70}})));
  TransiEnt.Producer.Heat.Power2Heat.Components.Heatpump Heatpump(
    Delta_T_db=params.DTdb_heatpump,
    Q_flow_n=params.Q_flow_n_heatpump,
    COP_n=params.COP_n_heatpump,
    t_min_on=params.t_min_on_heatpump,
    t_min_off=params.t_min_off_heatpump,
    T_bivalent=params.T_bivalent,
    T_heatingLimit=params.T_room_set,
    init_state=params.HPInitStatus) annotation (Placement(transformation(extent={{-52,-21},{-26,5}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow FloorHeatingBdry annotation (Placement(transformation(extent={{104,-18},{124,2}})));
  Modelica.Blocks.Continuous.LimPID  ctrlFloorHeating(
    k=params.G_loss*(params.T_room_set - (273.15 - 12)),
    yMax=50e3,
    yMin=0,
    Ti=900,
    initType=Modelica.Blocks.Types.InitPID.InitialOutput)                                                       annotation (Placement(transformation(extent={{74,-42},{94,-22}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor T_room_is annotation (Placement(transformation(extent={{136,-76},{116,-56}})));
  Modelica.Blocks.Sources.Constant T_room_set(k=params.T_room_set) annotation (Placement(transformation(extent={{39,-42},{59,-22}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor Storage(C=params.V_stor_fh*1e3*4.2e3, T(start=params.T_stor_fh_start, fixed=true)) annotation (Placement(transformation(extent={{16,6},{36,26}})));
   Modelica.Blocks.Tables.CombiTable1D T_stor_set(tableOnFile=false,
    table=[params.T_ref_degC - 20,params.T_feed_ref_degC + 273.15; params.T_ref_degC,params.T_feed_ref_degC + 273.15; params.T_lim_degC,params.T_feed_lim_degC + 273.15; params.T_lim_degC + 20,params.T_feed_lim_degC + 273.15],
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)                                                                                               annotation (Placement(transformation(extent={{-128,-18},{-108,2}})));
  Modelica.Blocks.Sources.RealExpression T_amb1(
                                               y=simCenter.ambientConditions.temperature.value) annotation (Placement(transformation(extent={{-156,-18},{-136,2}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatBdryFloorHeatingDeload annotation (Placement(transformation(extent={{58,-18},{38,2}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(extent={{84,14},{70,28}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor wall_stor(G=4.58) "Taken from Knop page 48, Viessmann Vitocell 100-W (200l, 2,2kWh loss per 24h at Delta T 45K)"
                                                                                                    annotation (Placement(transformation(extent={{8,44},{28,64}})));
  TransiEnt.Components.Visualization.PowerSystemBasics.Energy E_storageloss(
    E_start=0,
    unit="kWh",
    decimalSpaces=3,
    P=wall_stor.port_b.Q_flow/1e3) annotation (Placement(transformation(extent={{-30,-88},{-10,-68}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
                                                           heatBdryPeakloadFH1
                                                                              annotation (Placement(transformation(extent={{-22,44},{-2,64}})));
  Modelica.Blocks.Sources.BooleanExpression isPeakload(y=(273.15 + simCenter.ambientConditions.temperature.value) < params.T_bivalent) annotation (Placement(transformation(extent={{-75,14},{-55,34}})));
equation

    connect(T_amb.port,wall_a. port_a) annotation (Line(points={{114,52},{114,52},{120,52}},
                                                                                          color={191,0,0}));
    connect(wall_a.port_b,Room. port) annotation (Line(points={{140,52},{146,52},{146,-8},{136,-8}},
                                                                                                   color={191,0,0}));
    connect(T_amb_deg_C.y,T_amb. T) annotation (Line(points={{84,52},{84,52},{92,52}},  color={0,0,127}));
  connect(ctrlPeakload.y,Q_flow_peakload. u1) annotation (Line(points={{-75,52},{-48,52},{-48,29},{-44,29},{-44,29.6},{-41.4,29.6}},
                                                                                                    color={0,0,127}));
  connect(zero.y,Q_flow_peakload. u3) annotation (Line(points={{-59.5,12},{-59.5,12},{-46,12},{-46,18.4},{-41.4,18.4}},
                                                                                              color={0,0,127}));
  connect(T_stor_is.T,ctrlPeakload. u_m) annotation (Line(points={{-18,-34},{-18,-34},{-86,-34},{-86,40}},
                                                                                                         color={0,0,127}));
  connect(T_stor_is.T, Heatpump.u_meas) annotation (Line(points={{-18,-34},{-39,-34},{-39,-22.56}}, color={0,0,127}));
    connect(Q_flow_peakload.y,heatBdryPeakloadFH. Q_flow) annotation (Line(points={{-25.3,24},{-25.3,24},{-18,24}},
                                                                                                                 color={0,0,127}));
  connect(FloorHeatingBdry.port,Room. port) annotation (Line(points={{124,-8},{136,-8}},   color={191,0,0}));
  connect(T_room_is.port,Room. port) annotation (Line(points={{136,-66},{146,-66},{146,-8},{136,-8}},
                                                                                              color={191,0,0}));
  connect(Heatpump.heatPort,Storage. port) annotation (Line(points={{-26,-8},{-14,-8},{26,-8},{26,6}},   color={191,0,0}));
  connect(heatBdryPeakloadFH.port,Storage. port) annotation (Line(points={{2,24},{8,24},{8,-8},{26,-8},{26,6}},       color={191,0,0}));
  connect(T_stor_is.port,Storage. port) annotation (Line(points={{2,-34},{10,-34},{26,-34},{26,6}},   color={191,0,0}));
  connect(T_amb1.y,T_stor_set. u[1]) annotation (Line(points={{-135,-8},{-135,-8},{-130,-8}},      color={0,0,127}));
  connect(T_stor_set.y[1],ctrlPeakload. u_s) annotation (Line(points={{-107,-8},{-104,-8},{-104,52},{-98,52}},
                                                                                                    color={0,0,127}));
  connect(T_stor_set.y[1], Heatpump.u_set) annotation (Line(points={{-107,-8},{-52.52,-8}}, color={0,0,127}));
  connect(heatBdryFloorHeatingDeload.port,Storage. port) annotation (Line(points={{38,-8},{32,-8},{26,-8},{26,6}},
                                                                                                    color={191,0,0}));
  connect(gain.y,heatBdryFloorHeatingDeload. Q_flow) annotation (Line(points={{69.3,21},{64,21},{64,8},{64,-8},{58,-8}},          color={0,0,127}));
  connect(ctrlFloorHeating.y,FloorHeatingBdry. Q_flow) annotation (Line(points={{95,-32},{95,-32},{98,-32},{98,-8},{100,-8},{104,-8}},    color={0,0,127}));
  connect(ctrlFloorHeating.y,gain. u) annotation (Line(points={{95,-32},{98,-32},{98,21},{85.4,21}},           color={0,0,127}));
  connect(ctrlFloorHeating.u_m,T_room_is. T) annotation (Line(points={{84,-44},{84,-66},{116,-66}}, color={0,0,127}));
  connect(T_room_set.y,ctrlFloorHeating. u_s) annotation (Line(points={{60,-32},{60,-32},{68,-32},{72,-32}},          color={0,0,127}));
  connect(Storage.port,wall_stor. port_b) annotation (Line(points={{26,6},{30,6},{36,6},{36,54},{28,54}},            color={191,0,0}));
    connect(heatBdryPeakloadFH1.port,wall_stor. port_a) annotation (Line(points={{-2,54},{8,54}},  color={191,0,0}));
    connect(T_room_is.T,heatBdryPeakloadFH1. T) annotation (Line(points={{116,-66},{116,-66},{108,-66},{108,-82},{156,-82},{156,82},{-38,82},{-38,54},{-24,54}},
                                                                                                                                                              color={0,0,127}));
  connect(isPeakload.y, Q_flow_peakload.u2) annotation (Line(points={{-54,24},{-41.4,24}}, color={255,0,255}));
public
function plotResult

  constant String resultFileName = "TestBivalentHeatpumpSystem_L0.mat";

  output String resultFile;

algorithm
  clearlog();
    assert(cd(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR)), "Error changing directory: Working directory must be set as environment variable with name 'workingdir' for this script to work.");
  resultFile :=TransiEnt.Basics.Functions.fullPathName(Modelica.Utilities.System.getEnvironmentVariable(TransiEnt.Basics.Types.WORKINGDIR) + "/" + resultFileName);
  removePlots();

createPlot(id=1, position={0, 0, 1600, 817}, y={"Storage.port.Q_flow"}, range={0.0, 88000.0, -5000.0, 10000.0}, grid=true, colors={{28,108,200}},filename=resultFileName);
createPlot(id=1, position={0, 0, 1600, 200}, y={"Heatpump.Q_flow.y"}, range={0.0, 88000.0, -5000.0, 10000.0}, grid=true, subPlot=3, colors={{28,108,200}},filename=resultFileName);
createPlot(id=1, position={0, 0, 1600, 201}, y={"Room.T"}, range={0.0, 88000.0, 19.85, 20.1}, grid=true, subPlot=4, colors={{28,108,200}},filename=resultFileName);
createPlot(id=1, position={0, 0, 1600, 200}, y={"Storage.T"}, range={0.0, 88000.0, 20.0, 40.0}, grid=true, subPlot=2, colors={{28,108,200}},filename=resultFileName);

   resultFile := "Successfully plotted results for file: " + resultFile;

end plotResult;
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{160,100}})),
                             experiment(StopTime=86400, __Dymola_Algorithm="Dassl"),
    Icon(graphics,
         coordinateSystem(extent={{-160,-100},{160,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for BivalentHeatPumpSystem_L0</p>
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
end TestBivalentHeatpumpSystem_L0;
