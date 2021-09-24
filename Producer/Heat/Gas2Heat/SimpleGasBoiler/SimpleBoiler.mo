within TransiEnt.Producer.Heat.Gas2Heat.SimpleGasBoiler;
model SimpleBoiler "Simple gas boiler model with composition adaptive control"

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




  extends SimpleGasBoiler.Base.PartialBoiler;
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                Parameters
  // _____________________________________________

  parameter Boolean useHeatPort=true "True if heat port shall be used" annotation (Dialog(group="Configuration", enable=not useFluidPorts), choices(checkBox=true));
  parameter Boolean useGasPort=true "True if gas port shall be used" annotation (Dialog(group="Configuration"), choices(checkBox=true));

  parameter Boolean change_sign=false "If false, setpoint value needs to be negative" annotation (Dialog(group="Configuration"), choices(checkBox=true));

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid gasMedium=simCenter.gasModel1 "Fuel gas medium to be used" annotation (choicesAllMatching, Dialog(group="Fundamental Definitions", enable=useGasPort));
  parameter SI.Pressure p_drop=simCenter.p_nom[2] - simCenter.p_nom[1] "Pressure drop of the heat carrier" annotation (Dialog(group="Fundamental Definitions", enable=useFluidPorts));

  parameter SI.SpecificEnthalpy HoC_fuel=40e6 "Heat of combustion of fuel, will be used if gasport is deactivated in model" annotation (Dialog(group="Fundamental Definitions", enable=not usGasPort), choices(
      choice=simCenter.HeatingValue_natGas "Natural gas",
      choice=simCenter.HeatingValue_LightOil "Oil",
      choice=simCenter.HeatingValue_Wood "Wood pellets"));
  parameter TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.NaturalGas "Type of primary energy carrier for co2 emissions global statistics" annotation (Dialog(group="Statistics"));
  parameter Boolean integrateHeatFlow=false "True if heat flow shall be integrated" annotation (Dialog(group="Statistics"));

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

  // (others inherited by Base.PartialBoiler)

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasIn(Medium=gasMedium) if useGasPort annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-8,-110},{12,-90}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=m_flow_fuel_demand) if not useGasPort annotation (Placement(transformation(extent={{-88,46},{-68,66}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatPort if (useHeatPort) and not
                                                                                       (useFluidPorts) annotation (Placement(transformation(extent={{90,76},{110,96}})));

protected
  Basics.Interfaces.General.MassFlowRateOut m_flow_fuel_demand "Internal variable for mass flow rate of fuel calculated with constant heat of combustion" annotation (Placement(transformation(extent={{-100,70},{-80,90}})));


  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

public
  replaceable model BoilerCostModel = Components.Statistics.ConfigurationData.PowerProducerCostSpecs.GasBoiler constrainedby Components.Statistics.ConfigurationData.PowerProducerCostSpecs.BoilerCost annotation (Dialog(group="Statistics"), choicesAllMatching=true);
  replaceable Components.Boundaries.Heat.Heatflow_L1 heatFlowBoundary(
    p_drop=p_drop,
    Medium=medium,
    change_sign=true,
    use_Q_flow_in=true) if useFluidPorts  constrainedby Components.Boundaries.Heat.Base.PartialHeatBoundary  annotation (
    choicesAllMatching=true,
    Dialog(group="Fundamental Definitions"),
    Placement(transformation(extent={{-10,-10},{10,10}}, rotation=90)));
  Modelica.Blocks.Math.Gain sign(k=if change_sign then 1 else -1) annotation (Placement(transformation(extent={{-40,-9},{-22,9}})));

  Modelica.Blocks.Sources.RealExpression H_flow_set(y=H_flow_fuel_demand) "just for visualisation on diagram layer" annotation (Placement(transformation(extent={{-92,18},{-62,38}})));

  TransiEnt.Components.Sensors.TemperatureSensor T_in_sensor if useFluidPorts annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={80,10})));
  TransiEnt.Components.Sensors.TemperatureSensor T_out_sensor if useFluidPorts annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={82,70})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional) annotation (Placement(transformation(extent={{80,-100},{100,-80}})));

  Components.Statistics.Collectors.LocalCollectors.HeatingPlantCost collectCosts(
    Q_flow_n=Q_flow_n,
    m_flow_CDE_is=-collectGwpEmissions.gwpCollector.m_flow_cde,
    Q_flow_is=Q_flow_set,
    Q_flow_fuel_is=H_flow_fuel_demand,
    redeclare model HeatingPlantCostModel = BoilerCostModel) annotation (Placement(transformation(extent={{-6,-100},{14,-80}}, rotation=0)));

  //Visualization
  TransiEnt.Basics.Interfaces.General.EyeOut eye if useFluidPorts annotation (Placement(transformation(extent={{100,-100},{120,-80}})));

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsElectric collectGwpEmissions(typeOfEnergyCarrier=TransiEnt.Basics.Functions.getPrimaryEnergyCarrierFromHeat(typeOfPrimaryEnergyCarrier)) annotation (Placement(transformation(extent={{-26,-100},{-6,-80}})));
  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massflowSensor(medium=gasMedium, xiNumber=massflowSensor.medium.nc) if   useGasPort annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=90,
        origin={-7,57})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundaryRealGas(
    variable_m_flow=true,
    medium=gasMedium,
    p_nom=1600000) if useGasPort annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-16,34})));
  Consumer.Gas.Control.NCVController nCVController(controllerType=Modelica.Blocks.Types.SimpleController.P, k=1e6) if (useGasPort) annotation (Placement(transformation(extent={{-56,18},{-36,38}})));
  TransiEnt.Components.Sensors.RealGas.NCVSensor vleNCVSensor(medium=gasMedium) if useGasPort annotation (Placement(transformation(
        extent={{8,-7},{-8,7}},
        rotation=90,
        origin={-7,78})));
  Components.Sensors.SpecificEnthalpySensorVLE specificEnthalpySensorVLE if useFluidPorts annotation (Placement(transformation(extent={{52,34},{72,54}})));
  ClaRa.Components.Sensors.SensorVLE_L1_m_flow massFlowSensorVLE if useFluidPorts annotation (Placement(transformation(extent={{28,34},{48,54}})));
  Components.Sensors.SpecificEnthalpySensorVLE specificEnthalpySensorVLE1 if useFluidPorts annotation (Placement(transformation(extent={{42,0},{62,20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow if not (useFluidPorts) and (useHeatPort) annotation (Placement(transformation(extent={{46,76},{66,96}})));
  Modelica.Blocks.Math.Gain gain(k=-1) if useFluidPorts annotation (Placement(transformation(extent={{-4,-37},{16,-17}})));
  Modelica.Blocks.Math.Sum sum1(nin=2) if useFluidPorts annotation (Placement(transformation(extent={{26,-36},{46,-16}})));
  Modelica.Blocks.Math.Product product if useFluidPorts annotation (Placement(transformation(extent={{58,-42},{78,-22}})));
  Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_gen annotation (Placement(transformation(extent={{100,-42},{120,-22}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=outlet.p) if useFluidPorts annotation (Placement(transformation(extent={{-74,-102},{-54,-82}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=-heatPort.Q_flow) if
                                                                               not (useFluidPorts) and (useHeatPort) annotation (Placement(transformation(extent={{52,-64},{72,-44}})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y=sign.y) if not (useHeatPort) and not (useFluidPorts) annotation (Placement(transformation(extent={{52,-80},{72,-60}})));
  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

  SI.Energy E_total_generation(start=0);
  Modelica.Units.SI.EnthalpyFlowRate H_flow_fuel_demand;


  Modelica.Blocks.Sources.RealExpression P(y=0) "just for visualisation on diagram layer" annotation (Placement(transformation(extent={{-96,-86},{-78,-64}})));
  Basics.Interfaces.General.MassFlowRateOut m_flow_fuel "Internal variable for mass flow rate of fuel calculated with constant heat of combustion" annotation (Placement(transformation(extent={{100,-62},{120,-42}})));
  Modelica.Blocks.Sources.RealExpression realExpression4(y=HoC_fuel) if not useGasPort annotation (Placement(transformation(extent={{12,-92},{32,-72}})));
  Basics.Interfaces.General.SpecificEnthalpyOut CalorificValue "Internal variable for mass flow rate of fuel calculated with constant heat of combustion" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={48,-100})));
protected
  TransiEnt.Components.Statistics.Functions.GetFuelSpecificCO2Emissions fuelSpecificCO2Emissions(typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Functions.getPrimaryEnergyCarrierFromHeat(typeOfPrimaryEnergyCarrier));

  //_____________________________________________
  // Equations
  //_____________________________________________


equation

  if integrateHeatFlow then
    der(E_total_generation) = Q_flow_gen;
  else
    E_total_generation = 0;
  end if;

  // === energy balance ===
  H_flow_fuel_demand*eta = Q_flow_set*sign.k;
  m_flow_fuel_demand*HoC_fuel*eta = Q_flow_set*sign.k;

  // === GWP Emissions ===

  collectGwpEmissions.gwpCollector.m_flow_cde = -fuelSpecificCO2Emissions.m_flow_CDE_per_Energy*H_flow_fuel_demand;
  collectHeatingPower.heatFlowCollector.Q_flow = -Q_flow_gen;
  connect(modelStatistics.heatFlowCollector[TransiEnt.Basics.Types.TypeOfResource.Conventional], collectHeatingPower.heatFlowCollector);


  // _____________________________________________
  //
  //                Connect Statements
  // _____________________________________________

  connect(modelStatistics.gwpCollectorHeat[typeOfPrimaryEnergyCarrier], collectGwpEmissions.gwpCollector);
  connect(modelStatistics.costsCollector, collectCosts.costsCollector);

  connect(sign.y, heatFlowBoundary.Q_flow_prescribed) annotation (Line(
      points={{-21.1,0},{-6,0},{-6,-6},{-8,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sign.u, Q_flow_set) annotation (Line(
      points={{-41.8,0},{-104,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_in_sensor.port, inlet) annotation (Line(
      points={{80,0},{100,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(outlet, T_out_sensor.port) annotation (Line(
      points={{100,50},{82,50},{82,60}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(nCVController.m_flow_desired, boundaryRealGas.m_flow) annotation (Line(points={{-35,28},{-28,28}}, color={0,0,127}));
  connect(massflowSensor.m_flow, nCVController.m_flow_is) annotation (Line(points={{-7,49.3},{-42,49.3},{-42,38.6}}, color={0,0,127}));
  connect(vleNCVSensor.gasPortOut, massflowSensor.gasPortIn) annotation (Line(
      points={{0,70},{0,64}},
      color={255,255,0},
      thickness=1.5));
  connect(massflowSensor.gasPortOut, boundaryRealGas.gasPort) annotation (Line(
      points={{0,50},{0,34},{-6,34}},
      color={255,255,0},
      thickness=1.5));
  connect(gasIn, vleNCVSensor.gasPortIn) annotation (Line(
      points={{0,100},{0,86}},
      color={255,255,0},
      thickness=1.5));
  connect(nCVController.H_flow_set, H_flow_set.y) annotation (Line(points={{-57,28},{-60.5,28}}, color={0,0,127}));
  connect(vleNCVSensor.NCV, nCVController.NCV_is_sink) annotation (Line(points={{-7,69.2},{-7,68},{-50,68},{-50,38.6}}, color={0,0,127}));
  connect(outlet, specificEnthalpySensorVLE.outlet) annotation (Line(
      points={{100,50},{86,50},{86,34},{72,34}},
      color={175,0,0},
      thickness=0.5));
  connect(specificEnthalpySensorVLE.inlet, massFlowSensorVLE.outlet) annotation (Line(
      points={{52,34},{48,34}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(heatFlowBoundary.fluidPortOut, massFlowSensorVLE.inlet) annotation (Line(
      points={{10,6},{10,20},{28,20},{28,34}},
      color={175,0,0},
      thickness=0.5));
  connect(inlet, specificEnthalpySensorVLE1.outlet) annotation (Line(
      points={{100,0},{62,0}},
      color={175,0,0},
      thickness=0.5));
  connect(heatFlowBoundary.fluidPortIn, specificEnthalpySensorVLE1.inlet) annotation (Line(
      points={{10,-6},{36,-6},{36,0},{42,0}},
      color={175,0,0},
      thickness=0.5));
  connect(prescribedHeatFlow.port, heatPort) annotation (Line(points={{66,86},{100,86}}, color={191,0,0}));
  connect(sign.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{-21.1,0},{-6,0},{-6,12},{6,12},{6,86},{46,86}}, color={0,0,127}));
  connect(gain.y, sum1.u[1]) annotation (Line(points={{17,-27},{24,-27}}, color={0,0,127}));
  connect(sum1.y, product.u1) annotation (Line(points={{47,-26},{56,-26}}, color={0,0,127}));
  connect(product.y, Q_flow_gen) annotation (Line(points={{79,-32},{110,-32}}, color={0,0,127}));
  connect(specificEnthalpySensorVLE1.h, gain.u);
  connect(massFlowSensorVLE.m_flow, product.u2);
  connect(specificEnthalpySensorVLE.h, sum1.u[2]);
  connect(T_in_sensor.T, eye.T_return);
  connect(T_out_sensor.T, eye.T_supply);
  connect(massFlowSensorVLE.m_flow, eye.m_flow);
  connect(specificEnthalpySensorVLE.h, eye.h_supply);
  connect(specificEnthalpySensorVLE1.h, eye.h_return);
  connect(eye.p, realExpression.y);
  connect(eye.P, P.y);
  connect(eye.Q_flow, Q_flow_gen);

  connect(Q_flow_gen, realExpression1.y) annotation (Line(
      points={{110,-32},{90,-32},{90,-54},{73,-54}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  connect(Q_flow_gen, realExpression3.y) annotation (Line(
      points={{110,-32},{90,-32},{90,-54},{82,-54},{82,-70},{73,-70}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  connect(boundaryRealGas.m_flow, realExpression2.y) annotation (Line(points={{-28,28},{-32,28},{-32,56},{-67,56}}, color={0,0,127}));
  connect(nCVController.m_flow_desired, m_flow_fuel) annotation (Line(points={{-35,28},{86,28},{86,-52},{110,-52}}, color={0,0,127}));
  connect(realExpression2.y, m_flow_fuel) annotation (Line(points={{-67,56},{20,56},{20,-52},{110,-52}}, color={0,0,127}));
  connect(realExpression4.y, CalorificValue) annotation (Line(points={{33,-82},{48,-82},{48,-100}}, color={0,0,127}));
  connect(nCVController.NCV_is_sink, CalorificValue) annotation (Line(points={{-50,38.6},{-50,68},{-8,68},{-8,66},{12,66},{12,30},{18,30},{18,-24},{20,-24},{20,-32},{22,-32},{22,-68},{48,-68},{48,-100}}, color={0,0,127}));
  connect(nCVController.NCV_is_source, vleNCVSensor.NCV) annotation (Line(points={{-46,38.6},{-46,69.2},{-7,69.2}}, color={0,0,127}));
  annotation (
    defaultComponentName="gasBoiler",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Polygon(
          points={{-10,-92},{-22,-72},{-12,-76},{-6,-58},{4,-74},{12,-62},{18,-76},{28,-66},{16,-92},{-10,-92}},
          lineColor={175,0,0},
          smooth=Smooth.None,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Line(
          points={{-72,0},{-72,4},{-72,24}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Filled},
          pattern=LinePattern.Dash), Line(
          points={{-16,22},{-16,-40},{-16,-40},{-16,-74}},
          pattern=LinePattern.Dash,
          smooth=Smooth.None,
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled})}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model of a gas boiler using TransiEnt interfaces and TransiEnt.Statistics. Gas Consumption is computed using a constant efficiency and constant heat of combustion.</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Other fuels can be used by changeing the calorific value of the fuel as well as the type of energy carrier for the model statistics.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Basics.Interfaces.Thermal.FluidPort In/Out - heat carrier ports (e.g. water) or Modelica.Thermal.HeatTransfer.Interfaces.HeatPort </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica.Blocks.Interfaces.RealInput Q_flow_set - setpoint for thermal heat</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Basics.Interfaces.General.EyeOut</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Basics.Interfaces.Gas.RealGasPortIn - combustion gas inlet</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Basics.Interfaces.Thermal.HeatFlowRateOut</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Basics.Interfaces.Thermal.MassFlowRateOut</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p>H_flow_gas_demand * eta = -Q_flow_set</p>
<p>Q_flow_gen = inlet.m_flow * (outlet.h_outflow - inStream(inlet.h_outflow))</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified by Lisa Andresen (andresen@tuhh.de), Jan 2017</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified by Emil Dierkes (Fraunhofer UMSICHT), June 2021</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified by Anne Hagemeier (Fraunhofer UMSICHT), June 2021</span></p>
</html>"));
end SimpleBoiler;
