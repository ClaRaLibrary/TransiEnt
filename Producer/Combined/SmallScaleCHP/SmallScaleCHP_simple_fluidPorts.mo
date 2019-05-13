within TransiEnt.Producer.Combined.SmallScaleCHP;
model SmallScaleCHP_simple_fluidPorts "Small scale CHP model using a constant efficiency and fluid ports"

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
  replaceable model ProducerCosts =
      TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.Empty
    constrainedby TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PartialPowerPlantCostSpecs annotation (Dialog(group="Statistics"), __Dymola_choicesAllMatching=true);

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

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=mediumWater) annotation (Placement(transformation(extent={{90,-30},{110,-10}}), iconTransformation(extent={{90,-30},{110,-10}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut(Medium=mediumWater) annotation (Placement(transformation(extent={{90,10},{110,30}}), iconTransformation(extent={{90,10},{110,30}})));
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
    Q_flow_is=P_el,
    P_el_is=Q_flow_set,
    redeclare model PowerPlantCostModel = ProducerCosts,
    P_n=P_el_n) annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional, integrateHeatFlow=integrateHeatFlow)
                                                                                                                                                                        annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  replaceable TransiEnt.Components.Boundaries.Heat.Heatflow_L1 heatFlowBoundary(
    p_drop=p_drop,
    use_Q_flow_in=true,
    Medium=mediumWater,
    change_sign=false)  constrainedby TransiEnt.Components.Boundaries.Heat.Heatflow_L1 annotation (Dialog(group="Replaceable Components"),choicesAllMatching=true, Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,0})));
  TransiEnt.Components.Sensors.TemperatureSensor
                                       T_in_sensor annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,-40})));
  TransiEnt.Components.Sensors.TemperatureSensor
                                       T_out_sensor annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,40})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

  SI.Power P_el "Electric power";

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional, integrateElPower=integrateElPower)
                                                                                                                                                                        annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp annotation (Placement(transformation(extent={{90,-90},{110,-70}})));
  TransiEnt.Components.Boundaries.Electrical.Power Power annotation (Placement(transformation(extent={{62,-90},{42,-70}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  heatFlowBoundary.Q_flow_prescribed=Q_flow_set;
  P_el = Q_flow_set*eta_el/eta_th;
  H_flow=-(Q_flow_set + P_el)/(eta_el + eta_th);
  m_flow_gas=H_flow/vleNCVSensor.NCV;

  Power.P_el_set=P_el;

  collectElectricPower.powerCollector.P =-P_el;
  collectHeatingPower.heatFlowCollector.Q_flow =-Q_flow_set;

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(modelStatistics.powerCollector[collectElectricPower.typeOfResource], collectElectricPower.powerCollector);
  connect(modelStatistics.heatFlowCollector[collectHeatingPower.typeOfResource], collectHeatingPower.heatFlowCollector);
  connect(modelStatistics.costsCollector, collectCosts.costsCollector);

  connect(Power.epp, epp) annotation (Line(
      points={{62,-80},{100,-80}},
      color={0,135,135},
      thickness=0.5));
  connect(waterPortOut, waterPortOut) annotation (Line(
      points={{100,20},{100,20}},
      color={175,0,0},
      thickness=0.5));
  connect(heatFlowBoundary.fluidPortIn, waterPortIn) annotation (Line(
      points={{10,-6},{10,-20},{100,-20}},
      color={175,0,0},
      thickness=0.5));
  connect(heatFlowBoundary.fluidPortOut, waterPortOut) annotation (Line(
      points={{10,6},{10,20},{100,20}},
      color={175,0,0},
      thickness=0.5));
  connect(waterPortOut, T_out_sensor.port) annotation (Line(
      points={{100,20},{80,20},{80,40}},
      color={175,0,0},
      thickness=0.5));
  connect(waterPortIn, T_in_sensor.port) annotation (Line(
      points={{100,-20},{80,-20},{80,-40}},
      color={175,0,0},
      thickness=0.5));
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
</html>"));
end SmallScaleCHP_simple_fluidPorts;
