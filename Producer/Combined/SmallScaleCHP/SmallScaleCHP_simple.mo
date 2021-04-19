within TransiEnt.Producer.Combined.SmallScaleCHP;
model SmallScaleCHP_simple "Small scale CHP model using a constant efficiency and fluid ports"

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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Producer.Electrical.Base.PartialNaturalGasUnit;
  extends TransiEnt.Basics.Icons.CHP;

  import SI = Modelica.SIunits;

  // _____________________________________________
  //
  //        Constants and Hidden Parameters
  // _____________________________________________

  final parameter SI.HeatFlowRate Q_flow_n=P_el_n/eta_el*eta_th "Nominal heat flow rate";

  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid mediumWater= simCenter.fluid1 "Medium to be used"
                         annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  parameter SI.Pressure p_drop=heatFlowBoundary.simCenter.p_nom[2] -
      heatFlowBoundary.simCenter.p_nom[1] "Pressure drop" annotation (Dialog(group="Fundamental Definitions"));
  parameter SI.Power P_el_n = 3.5e3 "Nominal electric power" annotation (Dialog(group="Fundamental Definitions"));
  parameter SI.Efficiency eta_el = 0.3 "Constant electric efficiency" annotation (Dialog(group="Fundamental Definitions"));
  parameter SI.Efficiency eta_th = 0.6 "Constant thermal efficiency" annotation (Dialog(group="Fundamental Definitions"));

  parameter Boolean integrateElPower=simCenter.integrateElPower "true if electric powers shall be integrated" annotation (Dialog(group="Statistics"));
  parameter Boolean integrateHeatFlow=simCenter.integrateHeatFlow "true if heat flows shall be integrated" annotation (Dialog(group="Statistics"));
  parameter Boolean calculateCost=simCenter.calculateCost "true if cost shall be calculated" annotation (Dialog(group="Statistics"));
  parameter Boolean usePowerPort=true "True if power port shall be used" annotation (Dialog(group="Fundamental Definitions"));
  replaceable model ProducerCosts =
      TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.Empty
    constrainedby TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PartialPowerPlantCostSpecs annotation (Dialog(group="Statistics"), __Dymola_choicesAllMatching=true);
  parameter Boolean useFluidPorts=true "True if fluid ports shall be used" annotation (Dialog(group="Fundamental Definitions"));

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

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=mediumWater) if useFluidPorts annotation (Placement(transformation(extent={{90,-30},{110,-10}}), iconTransformation(extent={{90,-30},{110,-10}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut(Medium=mediumWater) if useFluidPorts annotation (Placement(transformation(extent={{90,30},{110,50}}), iconTransformation(extent={{90,30},{110,50}})));
  Modelica.Blocks.Interfaces.RealInput Q_flow_set "Setpoint value of the heat flow rate, should be negative" annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Blocks.Interfaces.RealOutput H_flow "Consumed gas enthalpy flow" annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-110}), iconTransformation(extent={{100,-10},{120,10}}, rotation=0)));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CogenerationPlantCost collectCosts(
    Q_flow_fuel_is=0,
    m_flow_CDE_is=0,
    produces_m_flow_CDE=false,
    calculateCost=calculateCost,
    Q_flow_is=Q_flow_set,
    P_el_is=P_el,
    redeclare model PowerPlantCostModel = ProducerCosts,
    P_n=P_el_n) annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional, integrateHeatFlow=integrateHeatFlow)
                                                                                                                                                                        annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  replaceable TransiEnt.Components.Boundaries.Heat.Heatflow_L1 heatFlowBoundary(
    p_drop=p_drop,
    use_Q_flow_in=true,
    Medium=mediumWater,
    change_sign=false) if useFluidPorts constrainedby TransiEnt.Components.Boundaries.Heat.Heatflow_L1 annotation (Dialog(group="Replaceable Components"),choicesAllMatching=true, Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,6})));
  TransiEnt.Components.Sensors.TemperatureSensor
                                       T_in_sensor if useFluidPorts annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,-40})));
  TransiEnt.Components.Sensors.TemperatureSensor
                                       T_out_sensor if useFluidPorts annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,20})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.Power P_el "Electric power";

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional, integrateElPower=integrateElPower)
                                                                                                                                                                        annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  replaceable TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp if usePowerPort constrainedby TransiEnt.Basics.Interfaces.Electrical.PartialPowerPort "Choice of power port" annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
  replaceable TransiEnt.Components.Boundaries.Electrical.ActivePower.Power Power if
                                                                        usePowerPort constrainedby TransiEnt.Components.Boundaries.Electrical.Base.PartialModelPowerBoundary "Choice of power boundary model. The power boundary model must match the power port." annotation (Placement(transformation(extent={{62,-90},{42,-70}})));

  Modelica.Blocks.Sources.RealExpression P_el_set(y=P_el) if usePowerPort annotation (Placement(transformation(extent={{22,-66},{42,-46}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatPort if not
                                                                     (useFluidPorts) annotation (Placement(transformation(extent={{90,52},{110,72}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow if not (useFluidPorts) annotation (Placement(transformation(extent={{-28,52},{-8,72}})));
  Modelica.Blocks.Math.Gain sign1(k=-1) if not
                                              (useFluidPorts) annotation (Placement(transformation(extent={{-64,53},{-46,71}})));

  Modelica.Blocks.Math.Division division if useGasPort annotation (Placement(transformation(extent={{-68,78},{-48,98}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=H_flow) annotation (Placement(transformation(extent={{-96,84},{-76,104}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  //heatFlowBoundary.Q_flow_prescribed=Q_flow_set;
  P_el = Q_flow_set*eta_el/eta_th;
  H_flow=-(Q_flow_set + P_el)/(eta_el + eta_th);
  //m_flow_gas=H_flow/vleNCVSensor.NCV;

  //Power.P_el_set=P_el;

  collectElectricPower.powerCollector.P =-P_el;
  collectHeatingPower.heatFlowCollector.Q_flow =-Q_flow_set;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(modelStatistics.powerCollector[collectElectricPower.typeOfResource], collectElectricPower.powerCollector);
  connect(modelStatistics.heatFlowCollector[collectHeatingPower.typeOfResource], collectHeatingPower.heatFlowCollector);
  connect(modelStatistics.costsCollector, collectCosts.costsCollector);

  if usePowerPort then
  connect(Power.epp, epp) annotation (Line(
      points={{62,-80},{100,-80}},
      color={0,135,135},
      thickness=0.5));
  connect(P_el_set.y, Power.P_el_set) annotation (Line(points={{43,-56},{58,-56},{58,-68}}, color={0,0,127}));
  end if;
  if useFluidPorts then
  connect(heatFlowBoundary.fluidPortIn, waterPortIn) annotation (Line(
      points={{10,-8.88178e-16},{10,-20},{100,-20}},
      color={175,0,0},
      thickness=0.5));
  connect(heatFlowBoundary.fluidPortOut, waterPortOut) annotation (Line(
      points={{10,12},{10,40},{100,40}},
      color={175,0,0},
      thickness=0.5));
  connect(waterPortOut, T_out_sensor.port) annotation (Line(
      points={{100,40},{80,40},{80,20}},
      color={175,0,0},
      thickness=0.5));
  connect(waterPortIn, T_in_sensor.port) annotation (Line(
      points={{100,-20},{80,-20},{80,-40}},
      color={175,0,0},
      thickness=0.5));
  connect(Q_flow_set, heatFlowBoundary.Q_flow_prescribed) annotation (Line(points={{-100,0},{-32,0},{-32,8.88178e-16},{-8,8.88178e-16}}, color={0,0,127}));
  end if;
  if not (useFluidPorts) then
    connect(prescribedHeatFlow.port, heatPort) annotation (Line(points={{-8,62},{100,62}}, color={191,0,0}));
  connect(prescribedHeatFlow.Q_flow, sign1.y) annotation (Line(points={{-28,62},{-45.1,62}},   color={0,0,127}));
  connect(Q_flow_set, sign1.u) annotation (Line(points={{-100,0},{-72,0},{-72,62},{-65.8,62}},   color={0,0,127}));
  end if;

  if useGasPort then
  connect(m_flow_gas, division.y) annotation (Line(points={{8,88},{-47,88}},   color={0,0,127}));
  connect(vleNCVSensor.NCV, division.u2) annotation (Line(points={{53,92},{44,92},{44,110},{-100,110},{-100,82},{-70,82}}, color={0,0,127}));
  end if;
  connect(division.u1, realExpression1.y) annotation (Line(points={{-70,94},{-75,94}}, color={0,0,127}));
annotation (Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Simple small scale CHP model with constant efficiencies.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Q_flow_set: set value for the heat flow</p>
<p>T_source_input_K: source temperature (ambient temperature) in K</p>
<p>waterPortIn: inlet port for heating water</p>
<p>waterPortOut: outlet port for heating water</p>
<p>P_el: needed electric power</p>
<p>epp: electric power port</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Aug 2018</p>
<p>Model modified by Jan Westphal (j.westphal@tuhh.de), Jul 2019 (added boolean for power port, added boolean for using gas port)</p>
</html>"));
end SmallScaleCHP_simple;
