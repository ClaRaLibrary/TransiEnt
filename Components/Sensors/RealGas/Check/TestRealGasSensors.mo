within TransiEnt.Components.Sensors.RealGas.Check;
model TestRealGasSensors "Test model for real gas sensors"

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

  extends TransiEnt.Basics.Icons.Checkmodel;
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-130,80},{-110,100}})));

  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sourceNGH2(variable_xi=true, m_flow_const=-4) annotation (Placement(transformation(extent={{-106,-16},{-86,4}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sinkNGH2 annotation (Placement(transformation(extent={{138,-16},{118,4}})));
  TransiEnt.Components.Boundaries.Gas.RealGasCompositionByWtFractions_stepVariation realGasCompositionByWtFractions_stepVariation(
    xiNumber=7,
    period=10,
    stepsize=0.01) annotation (Placement(transformation(extent={{-134,-22},{-114,-2}})));
  TransiEnt.Components.Sensors.RealGas.GCVSensor gCVSensorNGH2 annotation (Placement(transformation(extent={{50,-6},{70,14}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensorNGH2(compositionDefinedBy=1) annotation (Placement(transformation(extent={{-56,-6},{-36,14}})));
  TransiEnt.Components.Sensors.RealGas.WobbeGCVSensor wobbeGCVSensorNGH2 annotation (Placement(transformation(extent={{-2,-6},{18,14}})));
  TransiEnt.Components.Sensors.RealGas.NCVSensor nCVSensorNGH2 annotation (Placement(transformation(extent={{24,-6},{44,14}})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massflowSensorNGH2(xiNumber=7) annotation (Placement(transformation(extent={{-80,-6},{-60,14}})));
  TransiEnt.Components.Sensors.RealGas.EnthalpyFlowSensor enthalpyFlowSensorNGH2 annotation (Placement(transformation(extent={{-30,-6},{-10,14}})));
  TransiEnt.Components.Sensors.RealGas.SpecificEnthalpySensor specificEnthalpySensorNGH2 annotation (Placement(transformation(extent={{98,-6},{118,14}})));

  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sourceH2(
    m_flow_const=-4,
    variable_xi=false,
    xi_const=zeros(sourceH2.medium.nc - 1)) annotation (Placement(transformation(extent={{-106,-60},{-86,-40}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sinkH2 annotation (Placement(transformation(extent={{138,-60},{118,-40}})));
  TransiEnt.Components.Sensors.RealGas.GCVSensor gCVSensorH2 annotation (Placement(transformation(extent={{50,-50},{70,-30}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor compositionSensorH2(compositionDefinedBy=1) annotation (Placement(transformation(extent={{-56,-50},{-36,-30}})));
  TransiEnt.Components.Sensors.RealGas.WobbeGCVSensor wobbeGCVSensorH2 annotation (Placement(transformation(extent={{-4,-50},{16,-30}})));
  TransiEnt.Components.Sensors.RealGas.NCVSensor nCVSensorH2 annotation (Placement(transformation(extent={{24,-50},{44,-30}})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massflowSensorH2(xiNumber=7) annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  TransiEnt.Components.Sensors.RealGas.EnthalpyFlowSensor enthalpyFlowSensorH2 annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  TransiEnt.Components.Sensors.RealGas.SpecificEnthalpySensor specificEnthalpySensorH2 annotation (Placement(transformation(extent={{96,-50},{116,-30}})));

  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sourceNG(
    m_flow_const=-4,
    variable_m_flow=true,
    variable_T=true) annotation (Placement(transformation(extent={{-106,24},{-86,44}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sinkNG(variable_p=true) annotation (Placement(transformation(extent={{112,24},{92,44}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor vleTemperatureSensorNG annotation (Placement(transformation(extent={{-48,34},{-28,54}})));
  TransiEnt.Components.Sensors.RealGas.PressureSensor pressureSensorNG annotation (Placement(transformation(extent={{30,34},{50,54}})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massflowSensorNG annotation (Placement(transformation(extent={{-22,34},{-2,54}})));
  TransiEnt.Components.Sensors.RealGas.EnthalpyFlowSensor enthalpyFlowSensorNG annotation (Placement(transformation(extent={{4,34},{24,54}})));
  TransiEnt.Components.Sensors.RealGas.SpecificEnthalpySensor specificEnthalpySensorNG annotation (Placement(transformation(extent={{58,34},{78,54}})));

  Modelica.Blocks.Sources.Ramp mFlow(
    height=-9,
    duration=500,
    offset=-1,
    startTime=100) annotation (Placement(transformation(extent={{-132,42},{-120,54}})));
  Modelica.Blocks.Sources.Ramp Temp(
    height=20,
    duration=0,
    offset=283,
    startTime=700) annotation (Placement(transformation(extent={{-132,22},{-120,34}})));
  Modelica.Blocks.Sources.Ramp Pressure(
    height=10e5,
    duration=100,
    offset=15e5,
    startTime=800) annotation (Placement(transformation(extent={{136,34},{124,46}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sourceH2_2(
    m_flow_const=-4,
    variable_xi=false,
    medium=TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK()) annotation (Placement(transformation(extent={{-106,-90},{-86,-70}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sinkH2_2(medium=TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK()) annotation (Placement(transformation(extent={{138,-90},{118,-70}})));
  TransiEnt.Components.Sensors.RealGas.GCVSensor gCVSensorH2_2(medium=TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK()) annotation (Placement(transformation(extent={{52,-80},{72,-60}})));
  TransiEnt.Components.Sensors.RealGas.NCVSensor nCVSensorH2_2(medium=TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK()) annotation (Placement(transformation(extent={{28,-80},{48,-60}})));
equation
  connect(sourceNGH2.xi, realGasCompositionByWtFractions_stepVariation.xi) annotation (Line(points={{-108,-12},{-111,-12},{-114,-12}},
                                                                                                                                    color={0,0,127}));
  connect(wobbeGCVSensorNGH2.gasPortOut, nCVSensorNGH2.gasPortIn) annotation (Line(
      points={{18,-6},{24,-6}},
      color={255,255,0},
      thickness=1.5));
  connect(nCVSensorNGH2.gasPortOut, gCVSensorNGH2.gasPortIn) annotation (Line(
      points={{44,-6},{50,-6}},
      color={255,255,0},
      thickness=1.5));
  connect(nCVSensorH2.gasPortOut, gCVSensorH2.gasPortIn) annotation (Line(
      points={{44,-50},{44,-50},{50,-50}},
      color={255,255,0},
      thickness=1.5));
  connect(sourceNG.gasPort, vleTemperatureSensorNG.gasPortIn) annotation (Line(
      points={{-86,34},{-48,34}},
      color={255,255,0},
      thickness=1.5));
  connect(vleTemperatureSensorNG.gasPortOut, massflowSensorNG.gasPortIn) annotation (Line(
      points={{-28,34},{-26,34},{-22,34}},
      color={255,255,0},
      thickness=1.5));
  connect(massflowSensorNG.gasPortOut, enthalpyFlowSensorNG.gasPortIn) annotation (Line(
      points={{-2,34},{1,34},{4,34}},
      color={255,255,0},
      thickness=1.5));
  connect(enthalpyFlowSensorNG.gasPortOut, pressureSensorNG.gasPortIn) annotation (Line(
      points={{24,34},{27,34},{30,34}},
      color={255,255,0},
      thickness=1.5));
  connect(mFlow.y, sourceNG.m_flow) annotation (Line(points={{-119.4,48},{-116,48},{-116,40},{-108,40}},
                                                                                                     color={0,0,127}));
  connect(Temp.y, sourceNG.T) annotation (Line(points={{-119.4,28},{-116,28},{-116,34},{-108,34}},
                                                                                               color={0,0,127}));
  connect(Pressure.y, sinkNG.p) annotation (Line(points={{123.4,40},{114,40}},
                                                                             color={0,0,127}));
  connect(sourceH2.gasPort, massflowSensorH2.gasPortIn) annotation (Line(
      points={{-86,-50},{-80,-50}},
      color={255,255,0},
      thickness=1.5));
  connect(sourceNGH2.gasPort, massflowSensorNGH2.gasPortIn) annotation (Line(
      points={{-86,-6},{-83,-6},{-80,-6}},
      color={255,255,0},
      thickness=1.5));
  connect(massflowSensorNGH2.gasPortOut, compositionSensorNGH2.gasPortIn) annotation (Line(
      points={{-60,-6},{-56,-6}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensorNGH2.gasPortOut, enthalpyFlowSensorNGH2.gasPortIn) annotation (Line(
      points={{-36,-6},{-33,-6},{-30,-6}},
      color={255,255,0},
      thickness=1.5));
  connect(enthalpyFlowSensorNGH2.gasPortOut, wobbeGCVSensorNGH2.gasPortIn) annotation (Line(
      points={{-10,-6},{-6,-6},{-2,-6}},
      color={255,255,0},
      thickness=1.5));
  connect(massflowSensorH2.gasPortOut, compositionSensorH2.gasPortIn) annotation (Line(
      points={{-60,-50},{-60,-50},{-56,-50}},
      color={255,255,0},
      thickness=1.5));
  connect(compositionSensorH2.gasPortOut, enthalpyFlowSensorH2.gasPortIn) annotation (Line(
      points={{-36,-50},{-33,-50},{-30,-50}},
      color={255,255,0},
      thickness=1.5));
  connect(enthalpyFlowSensorH2.gasPortOut, wobbeGCVSensorH2.gasPortIn) annotation (Line(
      points={{-10,-50},{-7,-50},{-4,-50}},
      color={255,255,0},
      thickness=1.5));
  connect(wobbeGCVSensorH2.gasPortOut, nCVSensorH2.gasPortIn) annotation (Line(
      points={{16,-50},{20,-50},{24,-50}},
      color={255,255,0},
      thickness=1.5));
  connect(pressureSensorNG.gasPortOut, specificEnthalpySensorNG.gasPortIn) annotation (Line(
      points={{50,34},{54,34},{58,34}},
      color={255,255,0},
      thickness=1.5));
  connect(specificEnthalpySensorNG.gasPortOut, sinkNG.gasPort) annotation (Line(
      points={{78,34},{92,34}},
      color={255,255,0},
      thickness=1.5));
  connect(sinkNGH2.gasPort, specificEnthalpySensorNGH2.gasPortOut) annotation (Line(
      points={{118,-6},{118,-6}},
      color={255,255,0},
      thickness=1.5));
  connect(sinkH2.gasPort, specificEnthalpySensorH2.gasPortOut) annotation (Line(
      points={{118,-50},{116,-50}},
      color={255,255,0},
      thickness=1.5));
  connect(gCVSensorH2.gasPortOut, specificEnthalpySensorH2.gasPortIn) annotation (Line(
      points={{70,-50},{84,-50},{96,-50}},
      color={255,255,0},
      thickness=1.5));
  connect(gCVSensorNGH2.gasPortOut, specificEnthalpySensorNGH2.gasPortIn) annotation (Line(
      points={{70,-6},{98,-6},{98,-6}},
      color={255,255,0},
      thickness=1.5));
  connect(gCVSensorH2_2.gasPortOut, sinkH2_2.gasPort) annotation (Line(
      points={{72,-80},{96,-80},{118,-80}},
      color={255,255,0},
      thickness=1.5));
  connect(gCVSensorH2_2.gasPortIn, nCVSensorH2_2.gasPortOut) annotation (Line(
      points={{52,-80},{50,-80},{48,-80}},
      color={255,255,0},
      thickness=1.5));
  connect(sourceH2_2.gasPort, nCVSensorH2_2.gasPortIn) annotation (Line(
      points={{-86,-80},{28,-80}},
      color={255,255,0},
      thickness=1.5));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{140,100}})),
                                                                 Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{140,100}})),
    experiment(StopTime=1000, Interval=1),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for real gas sensors used for VLEFluid types. This model contains sources and sinks of different real gases for checking the function of the different sensors</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
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
end TestRealGasSensors;
