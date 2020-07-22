within TransiEnt.Producer.Heat.Base;
partial model PartialHeatPumpCharline "Partial heat pump model that produces a given heat flow with a charline"

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.HeatPump;

  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter Boolean use_Q_flow_input=true "true for Q_flow input, false for P_el input" annotation (Dialog(group="Fundamental Definitions"));
  parameter Boolean use_T_source_input_K=false "False, use outer ambient conditions" annotation (Dialog(group="Fundamental Definitions"));
  parameter SI.HeatFlowRate Q_flow_n=3.5e3 "Nominal heat flow of heat pump at nominal conditions according to EN14511" annotation (Dialog(group="Technical Specifications"));
  parameter Real COP_n=3.7 "Coefficient of performance at nominal conditions A2/W35 according to EN14511" annotation (Dialog(group="Technical Specifications"));

  replaceable model ProducerCosts = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.Empty constrainedby TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PartialPowerPlantCostSpecs annotation (Dialog(group="Statistics"), __Dymola_choicesAllMatching=true);
  parameter Boolean useFluidPorts=true "True if fluid ports shall be used" annotation (Dialog(group="Technical Specifications"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid mediumWater=simCenter.fluid1 "Medium to be used" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter SI.Pressure p_drop=heatFlowBoundary.simCenter.p_nom[2] - heatFlowBoundary.simCenter.p_nom[1] annotation (Dialog(group="Fundamental Definitions"));


  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_set if use_Q_flow_input "Setpoint value of the heat flow, should be negative" annotation (Placement(transformation(extent={{-120,-20},{-80,20}}), iconTransformation(extent={{-120,-20},{-80,20}})));
  TransiEnt.Basics.Interfaces.General.TemperatureIn T_source_input_K if
                                                        use_T_source_input_K "Input ambient temperature in Kelvin" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-100,-40}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100})));
  Modelica.Blocks.Interfaces.RealOutput DeltaT "Temperature difference between water and air" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,50}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,200})));

protected
  TransiEnt.Basics.Interfaces.General.TemperatureIn T_source_internal;

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

public
  SI.HeatFlowRate Q_flow;
  Real COP;


  TransiEnt.Components.Statistics.Collectors.LocalCollectors.HeatingPlantCost collectCosts_HeatProducer(
    redeclare model HeatingPlantCostModel = ProducerCosts,
    Q_flow_fuel_is=0,
    m_flow_CDE_is=0,
    Q_flow_n=Q_flow_n,
    Q_flow_is=Q_flow,
    consumes_H_flow=false,
    produces_m_flow_CDE=false) annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional) annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Math.Gain Q_flow_set_(k=1) annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.Constant const(k=1) annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Components.Sensors.TemperatureSensor T_in_sensor if useFluidPorts annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-40})));
public
  replaceable Components.Boundaries.Heat.Heatflow_L1 heatFlowBoundary(
    p_drop=p_drop,
    use_Q_flow_in=true,
    Medium=mediumWater,
    change_sign=false) if useFluidPorts constrainedby Components.Boundaries.Heat.Heatflow_L1 annotation (
    Dialog(group="Replaceable Components"),
    choicesAllMatching=true,
    Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={0,0})));
  Modelica.Blocks.Sources.RealExpression PrescribedHeatFlow(y=Q_flow) annotation (Placement(transformation(extent={{-34,54},{-14,74}})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={48,40})));
  Modelica.Blocks.Sources.RealExpression T_source(y=T_source_internal) annotation (Placement(transformation(extent={{6,30},{26,50}})));
  Modelica.Blocks.Math.Sum sum1(nin=2) if useFluidPorts annotation (Placement(transformation(extent={{70,46},{90,66}})));
  Modelica.Blocks.Sources.RealExpression Temperature(y=heat.T) if     not (useFluidPorts) annotation (Placement(transformation(extent={{102,-18},{82,2}})));
  Basics.Interfaces.Thermal.FluidPortOut waterPortOut(Medium=mediumWater) if           useFluidPorts annotation (Placement(transformation(extent={{30,-110},{50,-90}}), iconTransformation(extent={{30,-110},{50,-90}})));
  Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=mediumWater) if           useFluidPorts annotation (Placement(transformation(extent={{-50,-110},{-30,-90}}), iconTransformation(extent={{-50,-110},{-30,-90}})));
  Components.Sensors.TemperatureSensor T_out_sensor if useFluidPorts annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-40})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatFlowBoundary1 if not (useFluidPorts) annotation (Placement(transformation(extent={{34,-10},{54,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heat if not (useFluidPorts) annotation (Placement(transformation(extent={{-10,-110},{10,-90}}, rotation=0), iconTransformation(extent={{-10,-110},{10,-90}})));
  Modelica.Blocks.Math.Sum sum2(nin=2) if not (useFluidPorts) annotation (Placement(transformation(extent={{70,20},{90,40}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  if not use_T_source_input_K then
    T_source_internal = SI.Conversions.from_degC(simCenter.T_amb_var);
  end if;

  collectHeatingPower.heatFlowCollector.Q_flow = -Q_flow;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(modelStatistics.heatFlowCollector[collectHeatingPower.typeOfResource], collectHeatingPower.heatFlowCollector);
  connect(modelStatistics.costsCollector, collectCosts_HeatProducer.costsCollector);

  connect(T_source_internal, T_source_input_K);
  if use_Q_flow_input then
    connect(Q_flow_set, Q_flow_set_.u) annotation (Line(
        points={{-100,0},{-62,0}},
        color={175,0,0},
        pattern=LinePattern.Dash));
  else
    connect(const.y, Q_flow_set_.u) annotation (Line(points={{-79,30},{-72,30},{-72,0},{-62,0}}, color={0,0,127}));
  end if;

  if useFluidPorts then
    connect(T_in_sensor.T, sum1.u[1]) annotation (Line(points={{-50,-29},{-50,-20},{60,-20},{60,16},{32,16},{32,55},{68,55}}, color={0,0,127}));
    connect(waterPortIn, heatFlowBoundary.fluidPortIn) annotation (Line(
        points={{-40,-100},{-40,-10},{-6,-10}},
        color={175,0,0},
        smooth=Smooth.None));
    connect(waterPortIn, T_in_sensor.port) annotation (Line(
        points={{-40,-100},{-40,-40}},
        color={175,0,0},
        thickness=0.5));
    connect(PrescribedHeatFlow.y, heatFlowBoundary.Q_flow_prescribed) annotation (Line(points={{-13,64},{-6,64},{-6,8}}, color={0,0,127}));
    connect(waterPortOut, T_out_sensor.port) annotation (Line(
        points={{40,-100},{40,-40},{30,-40}},
        color={175,0,0},
        thickness=0.5,
        smooth=Smooth.None));
    connect(heatFlowBoundary.fluidPortOut, waterPortOut) annotation (Line(
        points={{6,-10},{40,-10},{40,-100}},
        color={175,0,0},
        smooth=Smooth.None));
    connect(sum1.y, DeltaT) annotation (Line(points={{91,56},{106,56},{106,50},{120,50}}, color={0,0,127}));
    connect(gain.y, sum1.u[2]) annotation (Line(points={{59,40},{59,57},{68,57}}, color={0,0,127}));
  end if;




  if not (useFluidPorts) then
    connect(heatFlowBoundary1.port, heat) annotation (Line(points={{54,0},{74,0},{74,-100},{0,-100}}, color={191,0,0}));
    connect(PrescribedHeatFlow.y, heatFlowBoundary1.Q_flow) annotation (Line(points={{-13,64},{2,64},{2,20},{18,20},{18,0},{34,0}}, color={0,0,127}));
    connect(Temperature.y, sum2.u[1]) annotation (Line(points={{81,-8},{78,-8},{78,12},{62,12},{62,29},{68,29}}, color={0,0,127}));
    connect(sum2.y, DeltaT) annotation (Line(points={{91,30},{96,30},{96,50},{120,50}}, color={0,0,127}));
    connect(gain.y, sum2.u[2]) annotation (Line(points={{59,40},{59,31},{68,31}}, color={0,0,127}));

  end if;
   connect(T_source.y, gain.u) annotation (Line(points={{27,40},{36,40}}, color={0,0,127}));

  annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Base class for simple heat pump models that produce a given heat flow and use a charline.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>Changing ambient temperature can be considered as well as varying COP.</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Q_flow_set: set value for the heat flow</p>
<p>T_source_input_K: source temperature (ambient temperature) in K</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>DeltaT is the temperature difference between water and air</p>
<p>Q_flow is the heat flow rate</p>
<p>COP is the coefficient of performance</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Feb 2018</p>
</html>"));
end PartialHeatPumpCharline;
