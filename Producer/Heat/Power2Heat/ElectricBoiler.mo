within TransiEnt.Producer.Heat.Power2Heat;
model ElectricBoiler "Electric Boiler with constant efficiency, spatial resolution can be chosen to be 0d or 1d"

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
  extends TransiEnt.Basics.Icons.Model;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;
  // _____________________________________________
  //
  //                Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.fluid1 "Medium to be used"
                         annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));
  final parameter Modelica.SIunits.Power P_el_n = Q_flow_n/eta "Nominal electric power";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_n = 100e3 "Nominal thermal power" annotation(Dialog(group="Technical Specification"));
  parameter Modelica.SIunits.Efficiency eta=0.95 annotation(Dialog(group="Technical Specification"));
  parameter Boolean useFluidPorts=true annotation(Dialog(group="Fundamental Definitions"));
  parameter Boolean usePowerPort=false  annotation(Dialog(group="Fundamental Definitions"));
  replaceable model ProducerCosts =
      TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.P2H
    constrainedby TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PartialPowerPlantCostSpecs annotation (Dialog(group="Statistics"), __Dymola_choicesAllMatching=true);

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

  replaceable TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort epp if usePowerPort  constrainedby TransiEnt.Basics.Interfaces.Electrical.PartialPowerPort "Choice of power port" annotation (Dialog(group="Replaceable Components",enable=usePowerPort),choicesAllMatching=true, Placement(transformation(extent={{-10,88},{10,108}}), iconTransformation(extent={{-10,-110},{10,-90}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn fluidPortIn(Medium=medium) if
                                                                          useFluidPorts annotation (Placement(transformation(extent={{90,-50},{110,-30}}), iconTransformation(extent={{-108,-10},{-88,10}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut fluidPortOut(Medium=medium) if
                                                                            useFluidPorts annotation (Placement(transformation(extent={{90,30},{110,50}}), iconTransformation(extent={{90,-10},{110,10}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_set "Setpoint for thermal heat, should be negative"
    annotation (Placement(transformation(extent={{-114,-10},{-94,10}}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,100})));

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

public
  replaceable TransiEnt.Components.Boundaries.Electrical.ActivePower.Power powerBoundary if
                                                                                usePowerPort constrainedby TransiEnt.Components.Boundaries.Electrical.Base.PartialModelPowerBoundary "Choice of power boundary model. The power boundary model must match the power port." annotation (
    Dialog(group="Replaceable Components", enable=usePowerPort),
    choices(choice(redeclare TransiEnt.Components.Boundaries.Electrical.ActivePower.Power powerBoundary "PowerBoundary for ActivePowerPort"), choice(redeclare TransiEnt.Components.Boundaries.Electrical.ComplexPower.PQBoundary powerBoundary(useInputConnectorQ=false, cosphi_boundary=0.99) "Power Boundary for ComplexPowerPort")),
    Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-18,30})));

  replaceable TransiEnt.Components.Boundaries.Heat.Heatflow_L1 heatFlowBoundary(change_sign=true) if useFluidPorts constrainedby TransiEnt.Components.Boundaries.Heat.Base.PartialHeatBoundary "Choice of heat boundary model" annotation (Dialog(group="Replaceable Components"),choicesAllMatching=true, Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={36,6})));

  Modelica.Blocks.Math.Gain efficiency(k=-1/eta)
    annotation (Placement(transformation(extent={{-36,54},{-18,72}})));
  Modelica.Blocks.Math.Gain sign(k=if heatFlowBoundary.change_sign==true then -1 else 1) if useFluidPorts
    annotation (Placement(transformation(extent={{-20,-9},{-2,9}})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_hex_coolant_in(medium=medium) if useFluidPorts annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=180,
        origin={46,-31})));
  ClaRa.Components.Sensors.SensorVLE_L1_T temperatureSensor_hex_coolant_out(medium=medium) if useFluidPorts annotation (Placement(transformation(extent={{53,39},{39,53}})));
  Modelica.Blocks.Nonlinear.Limiter Q_flow_set_limit(uMax=0, uMin=-Q_flow_n)
                                                     annotation (Placement(transformation(extent={{-72,-10},{-52,10}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.HeatingPlantCost collectCosts_HeatProducer(
    redeclare model HeatingPlantCostModel = ProducerCosts,
    Q_flow_fuel_is=0,
    m_flow_CDE_is=0,
    Q_flow_n=Q_flow_n,
    Q_flow_is=-Q_flow_is,
    consumes_H_flow=false,
    produces_m_flow_CDE=false)
                         annotation (Placement(transformation(extent={{10,-100},{30,-80}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional) annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Modelica.SIunits.HeatFlowRate Q_flow_is = -Q_flow_set_limit.y;
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow if not
                                                                                    (useFluidPorts) annotation (Placement(transformation(extent={{26,-80},{46,-60}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heat if not
                                                                 (useFluidPorts) annotation (Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Math.Gain sign1(k=-1) if not
                                              (useFluidPorts) annotation (Placement(transformation(extent={{-20,-79},{-2,-61}})));
protected
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectElectricPower collectElectricPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Consumer)
                                                                                                                                      annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

public
  SI.Power P_el "Consumed electric power";
equation

  P_el=efficiency.y;
  collectElectricPower.powerCollector.P=P_el;
  collectHeatingPower.heatFlowCollector.Q_flow = -Q_flow_is;

  // _____________________________________________
  //
  //                Connect Equations
  // _____________________________________________

  connect(modelStatistics.powerCollector[collectElectricPower.typeOfResource],collectElectricPower.powerCollector);
  connect(modelStatistics.heatFlowCollector[collectHeatingPower.typeOfResource],collectHeatingPower.heatFlowCollector);
  connect(modelStatistics.costsCollector, collectCosts_HeatProducer.costsCollector);

  if useFluidPorts then
    connect(fluidPortIn, heatFlowBoundary.fluidPortIn) annotation (Line(points={{100,-40},{70,-40},{70,-8.88178e-16},{46,-8.88178e-16}},
                                                                                                                   color={175,0,0}));
    connect(heatFlowBoundary.fluidPortOut, fluidPortOut) annotation (Line(points={{46,12},{70,12},{70,40},{100,40}},                 color={175,0,0}));
    connect(sign.y, heatFlowBoundary.Q_flow_prescribed) annotation (Line(
      points={{-1.1,0},{12.45,0},{12.45,8.88178e-16},{28,8.88178e-16}},
      color={0,0,127}));
    connect(heatFlowBoundary.fluidPortOut, temperatureSensor_hex_coolant_out.port)
      annotation (Line(
        points={{46,12},{46,39}},
        color={175,0,0},
        thickness=0.5));
    connect(heatFlowBoundary.fluidPortIn, temperatureSensor_hex_coolant_in.port)
      annotation (Line(
        points={{46,-8.88178e-16},{46,-24}},
        color={175,0,0},
        thickness=0.5));
    connect(Q_flow_set_limit.y, sign.u) annotation (Line(points={{-51,0},{-21.8,0}}, color={0,0,127}));
  else
    connect(sign1.u, Q_flow_set_limit.y) annotation (Line(points={{-21.8,-70},{-36,-70},{-36,0},{-51,0}}, color={0,0,127}));
    connect(prescribedHeatFlow.Q_flow, sign1.y) annotation (Line(points={{26,-70},{-1.1,-70}}, color={0,0,127}));
    connect(prescribedHeatFlow.port, heat) annotation (Line(points={{46,-70},{74,-70},{74,0},{100,0}}, color={191,0,0}));
  end if;
  if usePowerPort then
    connect(powerBoundary.epp, epp) annotation (Line(
      points={{-8,30},{0,30},{0,98}},
      color={0,0,0}));
    connect(efficiency.y, powerBoundary.P_el_set) annotation (Line(
      points={{-17.1,63},{-12,63},{-12,42}},
      color={0,0,127}));
  end if;
  connect(Q_flow_set_limit.y, efficiency.u) annotation (Line(points={{-51,0},{-44,0},{-44,42},{-44,63},{-37.8,63}}, color={0,0,127}));

  connect(Q_flow_set, Q_flow_set_limit.u) annotation (Line(points={{-104,0},{-74,0}}, color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Ellipse(
          extent={{-42,-50},{40,-92}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{-42,52},{40,-74}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Ellipse(
          extent={{-42,74},{40,32}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Line(
          points={{0,-48},{0,-102}},
          color={0,134,134},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{0,0},{20,-8},{-18,-22},{18,-36},{0,-40},{0,-50}},
          thickness=0.5,
          smooth=Smooth.None,
          color={0,134,134})}),   Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model of an electrode boiler using TransiEnt interfaces and TransiEnt.Statistics. Heat transfer is ideal, thermal losses are modeled using a constant efficiency. Heat port or fluid ports are choosable.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">epp: electric power port</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">fluidPortIn: fluid inlet (if selected)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">fluidPortOut: fluid outlet (if selected)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">heat: heat port (if selected)</span></p>
<p>Q_flow_set: set value for heat flow rate</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no equations)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarsk for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) in October 2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model generalized for different electrical power ports by Jan-Peter Heckel (jan.heckel@tuhh.de) in July 2018 </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified (added selectable heat port) by Carsten Bode (c.bode@tuhh.de), Nov 2018</span></p>
</html>"));
end ElectricBoiler;
