within TransiEnt.Producer.Heat.Gas2Heat.SimpleGasBoiler;
model SimpleBoiler "Simple gas boiler model with composition adaptive control"
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

  extends SimpleGasBoiler.Base.PartialBoiler;
  outer TransiEnt.SimCenter simCenter;

  // _____________________________________________
  //
  //                Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid gasMedium=simCenter.gasModel1 "Medium to be used for gas"
                                 annotation(choicesAllMatching, Dialog(group="Fundamental Definitions"));

  parameter SI.Pressure p_drop=simCenter.p_nom[2] - simCenter.p_nom[1] annotation (Dialog(group="Fundamental Definitions"));
  parameter SI.SpecificEnthalpy HoC_gas=40e6 "heat of combustion of natural gas" annotation (Dialog(group="Fundamental Definitions"));
  parameter TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.NaturalGas "Type of primary energy carrier for co2 emissions global statistics" annotation (Dialog(group="Statistics"), HideResult=true);
  parameter Boolean integrateHeatFlow=false "True if heat flow shall be integrated" annotation (Dialog(group="Statistics"));
  parameter Boolean useConstantHoC=true "True if constant heat of combustion shall be used" annotation (Dialog(group="Fundamental Definitions"));
  parameter Boolean useGasPort=true "True if gas port shall be used" annotation (Dialog(group="Fundamental Definitions"));
  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

  // (others inherited by Base.PartialBoiler)

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasIn(Medium=gasMedium) if useGasPort annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-8,-110},{12,-90}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=m_flow_gas_demand) if useConstantHoC annotation (Placement(transformation(extent={{-88,46},{-68,66}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatPort if not
                                                                     (useFluidPorts) annotation (Placement(transformation(extent={{90,76},{110,96}})));

protected
  Basics.Interfaces.General.MassFlowRateOut m_flow_gas_demand "Internal variable for mass flow rate of gas calculated with constant heat of combustion" annotation (Placement(transformation(extent={{-100,70},{-80,90}})));


  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

public
  replaceable model BoilerCostModel = Components.Statistics.ConfigurationData.PowerProducerCostSpecs.GasBoiler constrainedby Components.Statistics.ConfigurationData.PowerProducerCostSpecs.BoilerCost annotation(choicesAllMatching=true);
  replaceable
  TransiEnt.Components.Boundaries.Heat.Heatflow_L1 heatFlowBoundary(
    p_drop=p_drop,
    Medium=medium,
    change_sign=true,
    use_Q_flow_in=true) if useFluidPorts constrainedby Components.Boundaries.Heat.Base.PartialHeatBoundary
                                         annotation (choicesAllMatching=true,Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={18,6})));
  Modelica.Blocks.Math.Gain sign(k=-1)
    annotation (Placement(transformation(extent={{-40,-9},{-22,9}})));

  Modelica.Blocks.Sources.RealExpression
                            H_flow_set(y=H_flow_gas_demand) "just for visualisation on diagram layer"
    annotation (Placement(transformation(extent={{-92,18},{-62,38}})));

  TransiEnt.Components.Sensors.TemperatureSensor T_in_sensor if useFluidPorts annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={80,10})));
  TransiEnt.Components.Sensors.TemperatureSensor T_out_sensor if useFluidPorts annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={82,70})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional) annotation (Placement(transformation(extent={{80,-100},{100,-80}})));

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.HeatingPlantCost collectCosts(
    Q_flow_n=Q_flow_n,
    m_flow_CDE_is=-collectGwpEmissions.gwpCollector.m_flow_cde,
    Q_flow_is=Q_flow_set,
    Q_flow_fuel_is=H_flow_gas_demand,
    redeclare model HeatingPlantCostModel = BoilerCostModel) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={46,-90})));

  //Visualization
  TransiEnt.Basics.Interfaces.General.EyeOut eye annotation (Placement(transformation(extent={{100,-100},{120,-80}})));

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsElectric collectGwpEmissions(typeOfEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.NaturalGas) annotation (Placement(transformation(extent={{-26,-100},{-6,-80}})));
    TransiEnt.Components.Sensors.RealGas.MassFlowSensor massflowSensor(medium=gasMedium, xiNumber=massflowSensor.medium.nc) if useGasPort annotation (Placement(transformation(
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
  Consumer.Gas.Control.NCVController nCVController(controllerType=Modelica.Blocks.Types.SimpleController.P, k=1e6) if not (useConstantHoC) and (useGasPort) annotation (Placement(transformation(extent={{-56,18},{-36,38}})));
  TransiEnt.Components.Sensors.RealGas.NCVSensor vleNCVSensor(medium=gasMedium) if useGasPort annotation (Placement(transformation(
        extent={{8,-7},{-8,7}},
        rotation=90,
        origin={-7,78})));
  Components.Sensors.SpecificEnthalpySensorVLE specificEnthalpySensorVLE if useFluidPorts annotation (Placement(transformation(extent={{52,34},{72,54}})));
  ClaRa.Components.Sensors.SensorVLE_L1_m_flow massFlowSensorVLE if useFluidPorts annotation (Placement(transformation(extent={{28,34},{48,54}})));
  Components.Sensors.SpecificEnthalpySensorVLE specificEnthalpySensorVLE1 if useFluidPorts annotation (Placement(transformation(extent={{42,0},{62,20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow if not (useFluidPorts) annotation (Placement(transformation(extent={{46,76},{66,96}})));
  Modelica.Blocks.Math.Gain gain(k=-1) if useFluidPorts annotation (Placement(transformation(extent={{-4,-37},{16,-17}})));
  Modelica.Blocks.Math.Sum sum1(nin=2) if useFluidPorts annotation (Placement(transformation(extent={{26,-36},{46,-16}})));
  Modelica.Blocks.Math.Product product if useFluidPorts annotation (Placement(transformation(extent={{58,-42},{78,-22}})));
  Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_gen annotation (Placement(transformation(extent={{100,-42},{120,-22}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=outlet.p) if useFluidPorts annotation (Placement(transformation(extent={{6,-94},{26,-74}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=heatPort.Q_flow) if not (useFluidPorts) annotation (Placement(transformation(extent={{50,-64},{70,-44}})));

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

  SI.Energy E_total_generation(start=0);
  //SI.HeatFlowRate Q_flow_gen = inlet.m_flow * (outlet.h_outflow - inStream(inlet.h_outflow));
  Modelica.SIunits.EnthalpyFlowRate H_flow_gas_demand;

//_____________________________________________
// Equations
//_____________________________________________

protected
  TransiEnt.Components.Statistics.Functions.GetFuelSpecificCO2Emissions fuelSpecificCO2Emissions(typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Functions.getPrimaryEnergyCarrierFromHeat(typeOfPrimaryEnergyCarrier));
equation

  if integrateHeatFlow then
  der(E_total_generation) = Q_flow_gen;
  else
    E_total_generation=0;
  end if;

  // === energy balance ===
  H_flow_gas_demand * eta = -Q_flow_set;
  m_flow_gas_demand * HoC_gas * eta = -Q_flow_set;

  // === GWP Emissions ===

  collectGwpEmissions.gwpCollector.m_flow_cde=-fuelSpecificCO2Emissions.m_flow_CDE_per_Energy*H_flow_gas_demand;
  collectHeatingPower.heatFlowCollector.Q_flow = -Q_flow_gen;
  connect(modelStatistics.heatFlowCollector[TransiEnt.Basics.Types.TypeOfResource.Conventional],collectHeatingPower.heatFlowCollector);

  // == Economics

  //Eye values (Visualization)
  eye.P=0;
  eye.Q_flow=Q_flow_gen;
  //eye.T_supply=T_out_sensor.T_celsius;
  //eye.T_return=T_in_sensor.T_celsius;
  //eye.p = outlet.p/1e5;
  //eye.h_supply = outlet.h_outflow/1e3;
  //eye.h_return = inlet.h_outflow/1e3;
  //eye.m_flow = -outlet.m_flow;

  // _____________________________________________
  //
  //                Connect Statements
  // _____________________________________________
  connect(modelStatistics.gwpCollectorHeat[typeOfPrimaryEnergyCarrier],collectGwpEmissions.gwpCollector);
  connect(modelStatistics.costsCollector, collectCosts.costsCollector);

  connect(sign.y, heatFlowBoundary.Q_flow_prescribed) annotation (Line(
      points={{-21.1,0},{-6,0},{-6,8.88178e-16},{10,8.88178e-16}},
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
  connect(gasIn,vleNCVSensor. gasPortIn) annotation (Line(
      points={{0,100},{0,86}},
      color={255,255,0},
      thickness=1.5));
  connect(nCVController.H_flow_set, H_flow_set.y) annotation (Line(points={{-57,28},{-60.5,28}}, color={0,0,127}));
  connect(vleNCVSensor.NCV, nCVController.NCV_is) annotation (Line(points={{-7,69.2},{-7,68},{-50,68},{-50,38.4}}, color={0,0,127}));
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
      points={{28,12},{28,34}},
      color={175,0,0},
      thickness=0.5));
  connect(inlet, specificEnthalpySensorVLE1.outlet) annotation (Line(
      points={{100,0},{62,0}},
      color={175,0,0},
      thickness=0.5));
  connect(heatFlowBoundary.fluidPortIn, specificEnthalpySensorVLE1.inlet) annotation (Line(
      points={{28,-8.88178e-16},{36,-8.88178e-16},{36,0},{42,0}},
      color={175,0,0},
      thickness=0.5));
  connect(prescribedHeatFlow.port,heatPort)  annotation (Line(points={{66,86},{100,86}}, color={191,0,0}));
  connect(sign.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{-21.1,0},{-6,0},{-6,12},{6,12},{6,86},{46,86}}, color={0,0,127}));
  connect(gain.y, sum1.u[1]) annotation (Line(points={{17,-27},{24,-27}}, color={0,0,127}));
  connect(sum1.y, product.u1) annotation (Line(points={{47,-26},{56,-26}}, color={0,0,127}));
  connect(product.y, Q_flow_gen) annotation (Line(points={{79,-32},{110,-32}}, color={0,0,127}));
  connect(specificEnthalpySensorVLE1.h, gain.u);
  connect(massFlowSensorVLE.m_flow, product.u2);
  connect(specificEnthalpySensorVLE.h, sum1.u[2]);
  if useFluidPorts then
  connect(T_in_sensor.T, eye.T_return);
  connect(T_out_sensor.T, eye.T_supply);
  connect(massFlowSensorVLE.m_flow, eye.m_flow);
  connect(specificEnthalpySensorVLE.h, eye.h_supply);
  connect(specificEnthalpySensorVLE1.h, eye.h_return);
  connect(eye.p, realExpression.y);
  else
   eye.T_supply=-1;
   eye.T_return=-1;
   eye.p = -1;
   eye.h_supply = -1;
   eye.h_return = -1;
   eye.m_flow = -1;
  end if;
  connect(Q_flow_gen, realExpression1.y) annotation (Line(
      points={{110,-32},{90,-32},{90,-54},{71,-54}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  connect(boundaryRealGas.m_flow, realExpression2.y) annotation (Line(points={{-28,28},{-32,28},{-32,56},{-67,56}}, color={0,0,127}));
  annotation (defaultComponentName="gasBoiler",Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics={
        Polygon(
          points={{-10,-92},{-22,-72},{-12,-76},{-6,-58},{4,-74},{12,-62},{18,
              -76},{28,-66},{16,-92},{-10,-92}},
          lineColor={175,0,0},
          smooth=Smooth.None,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid)}),
                                  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
                                         Line(
          points={{-72,0},{-72,4},{-72,24}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Filled},
          pattern=LinePattern.Dash),                                            Line(
          points={{-16,22},{-16,-40},{-16,-40},{-16,-74}},
          pattern=LinePattern.Dash,
          smooth=Smooth.None,
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled})}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model of a gas boiler using TransiEnt interfaces and TransiEnt.Statistics. Gas Consumption is computed using a constant efficiency and constant heat of combustion.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Basics.Interfaces.Thermal.FluidPort In/Out - heat carrier ports (e.g. water)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica.Blocks.Interfaces.RealInput Q_flow_set - setpoint for thermal heat</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Basics.Interfaces.General.EyeOut</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Basics.Interfaces.Gas.RealGasPortIn - combustion gas inlet</span></p>
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
</html>"));
end SimpleBoiler;
