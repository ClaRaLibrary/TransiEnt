within TransiEnt.Producer.Heat.Power2Heat.Heatpump;
model HeatPumpSystem "Heat pump system with storage and controller, input: heat demand, output: electrical power"



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






  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

  //Controller
  parameter Boolean Modulating=true "True: modulating heat pump operation, false: static operation with P_n" annotation (choices(checkBox=true), Dialog(group="Control"));
  parameter Boolean MinTimes=true "If true, minimum operation and shutoff times are considered" annotation (Dialog(group="Control", enable=not Modulating), choices(checkBox=true));
  parameter Boolean CalculatePHeater=false "If true, electrical heater power output is calculated for bivalent heat pump operation" annotation (Dialog(group="Control"), choices(checkBox=true));
  parameter Boolean control_SoC=false "Choose controlled variable, 'true'=SoC, 'false'=Storage temperature" annotation (Dialog(group="Control"), choices(
      choice=true "SoC as controlled variable",
      choice=false "Storage temperature as controlled variable",
      checkBox=true));
  parameter TransiEnt.Basics.Types.OnOffRelaisStatus init_state=TransiEnt.Basics.Types.on_ready "State of relais at initialization" annotation (Dialog(group="Control"));
  parameter SI.TemperatureDifference Delta_T_db=2 "Deadband of hysteresis control" annotation (Dialog(group="Control"));

  //Storage
  parameter SI.Temperature T_s_min=303.15 "Minimum storage temperature" annotation (Dialog(group="Heat storage"));
  parameter SI.Volume V_Storage=0.5 "Volume of the Storage" annotation (Dialog(group="Heat storage"));
  parameter SI.Height height=1.3 "Height of heat storage" annotation (Dialog(group="Heat storage"));
  parameter Modelica.Units.NonSI.Temperature_degC T_amb=15 "Assumed constant temperature in tank installation room" annotation (Dialog(group="Heat storage"));
  parameter SI.SurfaceCoefficientOfHeatTransfer k=0.08 "Coefficient of heat transfer through tank surface" annotation (Dialog(group="Heat storage"));
  final parameter SI.Diameter d=sqrt(4*V_Storage/Modelica.Constants.pi/height) "Diameter of heat storage" annotation (Dialog(group="Storage parameters"));

  //Heatpump
  parameter Boolean usePowerPort=true "True if power port shall be used" annotation (Dialog(group="Heatpump"), choices(checkBox=true));
  parameter Boolean use_T_source_input_K=false "False, use outer ambient conditions" annotation (Dialog(group="Heatpump"), choices(checkBox=true));
  SI.Temperature T_set=323.15 "Output temperature of the heat pump" annotation (Dialog(group="Heatpump"));
  SI.Temperature T_source=simCenter.ambientConditions.temperature.value + 273.15 "Temperature of heat source" annotation (Dialog(group="Heatpump"));
  parameter SI.TemperatureDifference Delta_T_internal=5 "Temperature difference between refrigerant and source/sink temperature" annotation (Dialog(group="Heatpump"));
  parameter SI.HeatFlowRate Q_flow_n=3.5e3 "Nominal heat flow of heat pump at nominal conditions according to EN14511" annotation (Dialog(group="Heatpump"));
  parameter Real COP_n=3.7 "Coefficient of performance at nominal conditions according to EN14511" annotation (Dialog(group="Heatpump"));

  //Backup heater
  parameter SI.Power P_el_n=10e3 "Nominal electric power of the backup heater" annotation (Dialog(group="Heater"));
  parameter SI.Efficiency eta_Heater=0.95 "Efficiency of the backup heater" annotation (Dialog(group="Heater"));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Storage.Heat.HotWaterStorage_constProp_L2.HotWaterStorage_constProp_L2 heatStorage(
    useFluidPorts=false,
    T_s_max=T_set,
    T_s_min=T_s_min,
    height=height,
    d=d,
    T_start=T_s_min + 15,
    T_amb=T_amb,
    k=k) annotation (Placement(transformation(extent={{46,-2},{72,26}})));


  Modelica.Blocks.Sources.RealExpression realExpression(y=T_set) annotation (Placement(transformation(extent={{-94,-44},{-74,-24}})));

  TransiEnt.Producer.Heat.Power2Heat.Heatpump.BivalentHeatPumpWithControl heatPumpWithControl(
    control_SoC=control_SoC,
    CalculatePHeater=CalculatePHeater,
    Delta_T_db=Delta_T_db,
    init_state=init_state,
    useFluidPorts=false,
    Delta_T_internal=Delta_T_internal,
    Q_flow_n=Q_flow_n,
    COP_n=COP_n,
    P_el_n_heater=P_el_n,
    T_source=T_source,
    Modulating=Modulating,
    usePowerPort=usePowerPort,
    redeclare connector PowerPortModel = PowerPortModel,
    redeclare model PowerBoundaryModel = PowerBoundaryModel) annotation (Placement(transformation(extent={{-48,-32},{-12,6}})));

  replaceable model PowerBoundaryModel = Components.Boundaries.Electrical.ActivePower.Power constrainedby TransiEnt.Components.Boundaries.Electrical.Base.PartialModelPowerBoundary "Choice of power boundary model" annotation (__Dymola_choicesAllMatching=true, Dialog(group="Replaceable Components"));

  // _____________________________________________
  //
  //          Interfaces
  // _____________________________________________

  replaceable connector PowerPortModel = TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort constrainedby TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort "Choice of power port" annotation (choicesAllMatching=true, Dialog(group="Replaceable Components"));

  PowerPortModel epp if usePowerPort annotation (Placement(transformation(extent={{66,-110},{86,-90}})));

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_Demand annotation (Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=270,
        origin={0,100}), iconTransformation(extent={{-108,-14},{-82,12}})));


equation

  connect(heatPumpWithControl.epp, epp) annotation (Line(
      points={{-19.56,-31.62},{-18,-31.62},{-18,-86},{76,-86},{76,-100}},
      color={0,135,135},
      thickness=0.5));
  connect(realExpression.y, heatPumpWithControl.T_set) annotation (Line(points={{-73,-34},{-64,-34},{-64,-26},{-48.54,-26},{-48.54,-26.87}}, color={0,0,127}));
  connect(heatStorage.Q_flow_store, heatPumpWithControl.Heat_output) annotation (Line(
      points={{46.78,12},{0,12},{0,6.38},{-10.2,6.38}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  connect(heatStorage.Q_flow_demand, Q_Demand) annotation (Line(
      points={{72,12},{94,12},{94,70},{0,70},{0,78},{1.77636e-15,78},{1.77636e-15,100}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  connect(heatStorage.SoC, heatPumpWithControl.SoC) annotation (Line(points={{61.34,25.44},{61.34,38},{-88,38},{-88,-5.4},{-47.28,-5.4}}, color={0,0,127}));
  connect(heatStorage.T_stor_out, heatPumpWithControl.T) annotation (Line(points={{56.66,25.44},{56.66,32},{-78,32},{-78,-5.4},{-47.28,-5.4}}, color={0,0,127}));
  annotation (Icon(graphics={
        Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Rectangle(
          extent={{-38,40},{42,-48}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-48,8},{-44,8},{-30,8},{-38,-4},{-30,-14},{-48,-14},{-38,-4},{-48,8}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,48},{20,32}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-16,-40},{22,-56}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{30,10},{56,-14}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{34,-10},{42,10},{52,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-20,22},{-20,-24},{28,-24}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-20,-22},{-16,-14},{-4,4},{-2,6},{6,12},{16,16},{24,16}},
          color={0,0,255},
          smooth=Smooth.None)}), Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>Combination of storage tank, heat pump, supplementary electric heater and controller.</p>
<p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">4. Interfaces</span></b></p>
<p>HeatFlowRateIn Q_Demand</p>
<p>Powerport epp</p>
<p><br><b><span style=\"color: #008000;\">5. Nomenclature</span></b></p>
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
<p>Model from TransiEnt 1.1.0 modified by Anne Hagemeier (anne.hagemeier@umsicht.fraunhofer.de), Nov 2019</p>
</html>"));
end HeatPumpSystem;
