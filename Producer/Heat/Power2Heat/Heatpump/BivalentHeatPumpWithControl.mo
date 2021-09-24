within TransiEnt.Producer.Heat.Power2Heat.Heatpump;
model BivalentHeatPumpWithControl "Heatpump with selectable Controller and electric heater for bivalent operation if selected"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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



  outer TransiEnt.SimCenter simCenter;
  extends TransiEnt.Basics.Icons.HeatPump;

   //___________________________________________________________________________
   //
   //                      Parameters
   //___________________________________________________________________________

   //Controller
  parameter Boolean control_SoC=false "Choose controlled variable, 'true'=SoC, 'false'=Storage temperature" annotation (Dialog(group="Control"),
  choices(choice=true "SoC as controlled variable", choice=false "Storage temperature as controlled variable",checkBox=true));
  parameter Boolean Modulating=true "True: modulating heat pump operation, false: static operation with P_n" annotation(choices(checkBox=true), Dialog(group="Control"));
  parameter Boolean T_External=true "True: Actual temperature is read externally into the model. False: Temperature from fluid port is used." annotation (Dialog(group="Control"), choices(checkBox=true));
  parameter Boolean MinTimes=true "If true, minimum operation and shutoff times are considered" annotation (Dialog(group="Control",       enable=not Modulating),choices(checkBox=true));

  parameter Boolean CalculatePHeater=false "If true, electrical heater power output is calculated for bivalent heat pump operation" annotation (Dialog(group="Control"),choices(checkBox=true));
  final parameter SI.Power P_el_n=Q_flow_n/COP_n "Nominal electric power of Heatpump" annotation(choices(checkBox=true));
  parameter SI.TemperatureDifference Delta_T_db=2 "Deadband of hysteresis control" annotation (Dialog(group="Control"));
  parameter Basics.Types.OnOffRelaisStatus init_state=TransiEnt.Basics.Types.on_ready "State of relais at initialization" annotation (Dialog(group="Control"));

  parameter SI.Time t_min_on=3600 "Minimum on time" annotation (Dialog(group="Control"));
  parameter SI.Time t_min_off=600 "Minimum off time" annotation (Dialog(group="Control"));

  //Heatpump
  parameter Boolean usePowerPort=true "True if power port shall be used" annotation (Dialog(group="Heatpump"),choices(checkBox=true));
  parameter Boolean useFluidPorts=true "True if fluid ports shall be used" annotation (Dialog(group="Heatpump"),choices(checkBox=true));
  parameter Boolean useHeatPort=false "True if heat port shall be used" annotation (Dialog(group="Heatpump", enable=not useFluidPorts),
                                                                                                             choices(checkBox=true));
  parameter Boolean use_T_source_input_K=false "False, use outer ambient conditions" annotation (Dialog(group="Heatpump"),choices(checkBox=true));
  parameter SI.TemperatureDifference Delta_T_internal=5 "Temperature difference between refrigerant and source/sink temperature" annotation (Dialog(group="Heatpump"));
  parameter SI.HeatFlowRate Q_flow_n=3.5e3 "Nominal heat flow of heat pump at nominal conditions according to EN14511" annotation (Dialog(group="Heatpump"));
  parameter Real COP_n=3.7 "Coefficient of performance at nominal conditions according to EN14511" annotation (Dialog(group="Heatpump"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=heatPump.simCenter.fluid1 "Medium to be used" annotation (Dialog(group="Heatpump"));

  parameter SI.Pressure p_drop=heatPump.simCenter.p_nom[2] - heatPump.simCenter.p_nom[1] annotation (Dialog(group="Heatpump"));

   //___________________________________________________________________________
   //
   //                      Variables
   //___________________________________________________________________________

  Modelica.Units.SI.Temperature T_source=simCenter.ambientConditions.temperature.value + 273.15 "Temperature of heat source" annotation (Dialog(group="Heatpump",enable= not use_T_source_input_K),choices(
  choice=simCenter.ambientConditions.temperature.value + 273.15 "Ambient Temperature",
      choice=IntegraNet.SimCenter.Ground_Temperature + 273.15 "Ground Temperature"));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatPort if (useHeatPort) and not
                                                                                       (useFluidPorts) annotation (Placement(transformation(extent={{84,54},{104,74}})));
  Basics.Interfaces.Thermal.HeatFlowRateOut Heat_output "Setpoint value, e.g. Storage setpoint temperature" annotation (Placement(transformation(extent={{90,24},{130,64}}), iconTransformation(extent={{90,82},{130,122}})));
  Basics.Interfaces.Thermal.FluidPortOut outlet(Medium=medium) if useFluidPorts annotation (Placement(transformation(extent={{86,6},{106,26}}), iconTransformation(extent={{92,20},{112,40}})));
  Basics.Interfaces.Thermal.FluidPortIn inlet(Medium=medium) if useFluidPorts annotation (Placement(transformation(extent={{88,-82},{108,-62}}), iconTransformation(extent={{90,-48},{110,-28}})));
  Basics.Interfaces.General.TemperatureIn T_set "Setpoint value, e.g. Storage setpoint temperature" annotation (Placement(transformation(extent={{-120,-90},{-86,-56}}), iconTransformation(extent={{-120,-90},{-86,-56}})));
  Modelica.Blocks.Sources.RealExpression COP(y=T_source_internal) annotation (Placement(transformation(extent={{-68,18},{-48,38}})));

  Heatpump heatPump(
    use_T_source_input_K=use_T_source_input_K,
    usePowerPort=usePowerPort,
    Delta_T_internal=Delta_T_internal,
    Delta_T_db=Delta_T_db,
    Q_flow_n=Q_flow_n,
    COP_n=COP_n,
    T_source=T_source,
    medium=medium,
    useFluidPorts=useFluidPorts,
    p_drop=p_drop,
    useHeatPort=useHeatPort,
    T_set=T_set,
    redeclare connector PowerPortModel = PowerPortModel,
    redeclare model heatFlowBoundaryModel = heatFlowBoundaryModel,
    redeclare model PowerBoundaryModel = PowerBoundaryModel) annotation (Placement(transformation(extent={{2,-28},{44,12}})));

  replaceable TransiEnt.Producer.Heat.Power2Heat.Heatpump.Controller.ControlHeatpump_heatdriven_BVTemp controller(
    control_SoC=control_SoC,
    t_min_on=t_min_on,
    t_min_off=t_min_off) constrainedby Controller.Base.Controller(
    init_state=init_state,
    Q_flow_n=Q_flow_n,
    control_SoC=false,
    Modulating=Modulating,
    Delta_T_db=Delta_T_db,
    CalculatePHeater=CalculatePHeater,
    MinTimes=MinTimes) "Choose controller model" annotation (
    Dialog(group="Control"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-66,-40},{-24,2}})));

  replaceable connector PowerPortModel = Basics.Interfaces.Electrical.ActivePowerPort constrainedby Basics.Interfaces.Electrical.ActivePowerPort "Choice of power port" annotation (choicesAllMatching=true, Dialog(group="Replaceable Components"));

  PowerPortModel epp if  usePowerPort annotation (Placement(transformation(extent={{48,-108},{68,-88}})));

  ElectricBoiler.ElectricBoiler electricBoiler(
    change_sign=true,
    usePelset=true,
    useFluidPorts=useFluidPorts,
    useHeatPort=useHeatPort,
    usePowerPort=usePowerPort) if                                                       CalculatePHeater annotation (Placement(transformation(extent={{2,-78},{34,-46}})));

   //___________________________________________________________________________
   //
   //                      Interfaces
   //___________________________________________________________________________

  Basics.Interfaces.General.TemperatureIn T if control_SoC==false and T_External annotation (Placement(transformation(extent={{-118,-18},{-90,10}}), iconTransformation(extent={{-116,20},{-76,60}})));

  Modelica.Blocks.Interfaces.RealInput SoC if control_SoC annotation (Placement(transformation(extent={{-118,-48},{-90,-20}}), iconTransformation(extent={{-116,20},{-76,60}})));

protected
  TransiEnt.Basics.Interfaces.General.TemperatureIn T_source_internal "Temperature of heat source used for calculation";

public
  TransiEnt.Basics.Interfaces.General.TemperatureIn T_source_input_K if   use_T_source_input_K "Input ambient temperature in Kelvin" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,106})));

  replaceable model PowerBoundaryModel = TransiEnt.Components.Boundaries.Electrical.ActivePower.Power constrainedby TransiEnt.Components.Boundaries.Electrical.Base.PartialModelPowerBoundary "Choice of power boundary model. The power boundary model must match the power port." annotation (choicesAllMatching=true, Dialog(group="Replaceable Components"));
  replaceable model heatFlowBoundaryModel = TransiEnt.Components.Boundaries.Heat.Heatflow_L1 annotation (__Dymola_choicesAllMatching=true, Dialog(group="Replaceable Components"));
  ClaRa.Components.Sensors.SensorVLE_L1_T T_out(medium=medium) if useFluidPorts annotation (Placement(transformation(extent={{32,42},{12,62}})));
  Modelica.Blocks.Math.Add add if CalculatePHeater annotation (Placement(transformation(extent={{60,34},{74,48}})));

equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  if not use_T_source_input_K then
    T_source_internal = T_source;
  end if;

  connect(T_source_internal, T_source_input_K);
  connect(controller.Q_flow_set_HP, heatPump.Q_flow_set) annotation (Line(
      points={{-22.95,-19.21},{-10,-19.21},{-10,-18.8},{0.74,-18.8}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(SoC, controller.SoC) annotation (Line(points={{-104,-34},{-74,-34},{-74,-33.28},{-64.74,-33.28}}, color={0,0,127}));
  connect(T, controller.T) annotation (Line(points={{-104,-4},{-84,-4},{-84,-10.6},{-64.74,-10.6}}, color={0,0,127}));
  if not CalculatePHeater then
    connect(heatPump.Heat_output, Heat_output) annotation (Line(
        points={{47.36,3.6},{80,3.6},{80,44},{110,44}},
        color={175,0,0},
        pattern=LinePattern.Dash));
  end if;
  connect(heatPump.heatPort, heatPort) annotation (Line(points={{44,7.6},{44,64},{94,64}}, color={191,0,0}));
  connect(controller.T_source, COP.y) annotation (Line(points={{-36.81,0.53},{-36.81,28},{-47,28}}, color={0,0,127}));
  connect(heatPump.epp, epp) annotation (Line(
      points={{38.96,-28},{38.96,-82},{58,-82},{58,-98}},
      color={0,135,135},
      thickness=0.5));
  connect(T_set, controller.T_set) annotation (Line(points={{-103,-73},{-88,-73},{-88,-74},{-72,-74},{-72,-21.94},{-64.32,-21.94}}, color={0,0,127}));
  connect(controller.P_set_electricHeater, electricBoiler.P_el_set) annotation (Line(
      points={{-22.95,-35.17},{-4,-35.17},{-4,-38},{2.64,-38},{2.64,-65.84}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(electricBoiler.heat, heatPort) annotation (Line(points={{34.64,-55.92},{54,-55.92},{54,-44},{94,-44},{94,64}}, color={191,0,0}));
  connect(electricBoiler.epp, epp) annotation (Line(
      points={{18,-78.32},{18,-82},{58,-82},{58,-98}},
      color={0,135,135},
      thickness=0.5));
  connect(inlet, heatPump.inlet) annotation (Line(
      points={{98,-72},{82,-72},{82,-16},{64,-16},{64,-15.6},{44,-15.6}},
      color={175,0,0},
      thickness=0.5));
  connect(heatPump.outlet, electricBoiler.fluidPortIn) annotation (Line(
      points={{44.42,-2},{50,-2},{50,-36},{-6,-36},{-6,-62},{1.36,-62}},
      color={175,0,0},
      thickness=0.5));
  connect(electricBoiler.fluidPortOut, outlet) annotation (Line(
      points={{34.32,-62},{84,-62},{84,16},{96,16}},
      color={175,0,0},
      thickness=0.5));
  if not CalculatePHeater and useFluidPorts then
    connect(heatPump.outlet, outlet) annotation (Line(
        points={{44.42,-2},{50,-2},{50,-4},{84,-4},{84,16},{96,16}},
        color={175,0,0},
        thickness=0.5));
  end if;
  connect(outlet, T_out.port) annotation (Line(
      points={{96,16},{22,16},{22,42}},
      color={175,0,0},
      thickness=0.5));

  if not T_External then
    connect(T_out.T, controller.T) annotation (Line(points={{11,52},{-84,52},{-84,-10.6},{-64.74,-10.6}}, color={0,0,127}));
  end if;

  connect(add.y, Heat_output) annotation (Line(points={{74.7,41},{80,41},{80,44},{110,44}}, color={0,0,127}));
  connect(heatPump.Heat_output, add.u1) annotation (Line(
      points={{47.36,3.6},{48,3.6},{48,45.2},{58.6,45.2}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  connect(electricBoiler.Q_flow_gen, add.u2) annotation (Line(
      points={{34.96,-48.88},{48,-48.88},{48,36.8},{58.6,36.8}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>Combination of heatpump model with controller model and heater for bivalent operation.</p>
<p><br><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">4. Interfaces</span></b></p>
<p>T/SoC as input for the controlled variable</p>
<p>T_set for the setpoint of the controlled variable</p>
<p>Powerport epp</p>
<p>Fluidports inlet/outlet or heatport</p>
<p><br><b><span style=\"color: #008000;\">5. Nomenclature</span></b></p>
<p>(no elements)</p>
<p><b><span style=\"color: #008000;\">6. Governing Equations</span></b></p>
<p>(no equations)</p>
<p><b><span style=\"color: #008000;\">7. Remarks for Usage</span></b></p>
<p><br><b><span style=\"color: #008000;\">8. Validation</span></b></p>
<p>(no validation or testing necessary)</p>
<p><b><span style=\"color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">10. Version History</span></b></p>
<p>Model from TransiEnt 1.1.0 modified by Anne Hagemeier (anne.hagemeier@umsicht.fraunhofer.de), Nov 2019</p>
</html>"));
end BivalentHeatPumpWithControl;
