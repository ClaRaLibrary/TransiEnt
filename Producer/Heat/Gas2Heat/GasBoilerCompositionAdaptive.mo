within TransiEnt.Producer.Heat.Gas2Heat;
model GasBoilerCompositionAdaptive "Advanced gas boiler model with composition adaptive control"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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

  extends Gas2Heat.Base.PartialBoiler;

  // _____________________________________________
  //
  //                Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   gasMedium= simCenter.gasModel1 "Medium to be used for gas"
                                 annotation(choicesAllMatching, Dialog(group="Fluid Definition"));

  parameter SI.Pressure p_drop=heatFlowBoundary.simCenter.p_n[2] -
      heatFlowBoundary.simCenter.p_n[1];

  parameter TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.NaturalGas "Type of primary energy carrier for co2 emissions global statistics" annotation (Dialog(group="Statistics"), HideResult=true);

  // _____________________________________________
  //
  //                Interfaces
  // _____________________________________________

  // (others inherited by Base.PartialBoiler)

  TransiEnt.Basics.Interfaces.Gas.RealGasPortIn gasIn(Medium=gasMedium) annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-8,-110},{12,-90}})));

  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

  TransiEnt.Components.Boundaries.Heat.Heatflow_L1 heatFlowBoundary(
    p_drop=p_drop,
    Medium=medium,
    change_sign=true,
    use_Q_flow_in=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={36,7})));
  Modelica.Blocks.Math.Gain sign(k=-1)
    annotation (Placement(transformation(extent={{-40,-9},{-22,9}})));

  Modelica.Blocks.Sources.RealExpression
                            H_flow_set(y=H_flow_gas_demand) "just for visualisation on diagram layer"
    annotation (Placement(transformation(extent={{-92,18},{-62,38}})));

  TransiEnt.Components.Sensors.TemperatureSensor T_in_sensor annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={82,-30})));
  TransiEnt.Components.Sensors.TemperatureSensor T_out_sensor annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={82,70})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional) annotation (Placement(transformation(extent={{80,-100},{100,-80}})));

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.HeatingPlantCost collectCosts(
    Q_flow_n=Q_flow_n,
    Q_flow_is=-Q_flow_set,
    Q_flow_fuel_is=H_flow_gas_demand,
    redeclare model HeatingPlantCostModel = Components.Statistics.ConfigurationData.PowerProducerCostSpecs.GasBoiler) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={46,-90})));

  //Visualization
  TransiEnt.Basics.Interfaces.General.EyeOut eye annotation (Placement(transformation(extent={{100,-100},{120,-80}})));

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsElectric collectGwpEmissions(typeOfEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrier.NaturalGas) annotation (Placement(transformation(extent={{-26,-100},{-6,-80}})));

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

  SI.Energy E_total_generation(start=0);
  SI.HeatFlowRate Q_flow_gen = inlet.m_flow * (outlet.h_outflow - inStream(inlet.h_outflow));
  Modelica.SIunits.EnthalpyFlowRate H_flow_gas_demand;

//_____________________________________________
// Equations
//_____________________________________________

  TransiEnt.Components.Sensors.RealGas.MassFlowSensor massflowSensor(medium=gasMedium, xiNumber=massflowSensor.medium.nc) annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=90,
        origin={-7,57})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundaryRealGas(
    variable_m_flow=true,
    medium=gasMedium,
    p_nom=1600000) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-16,34})));
  Consumer.Gas.Control.NCVController nCVController(controllerType=Modelica.Blocks.Types.SimpleController.P, k=1e6) annotation (Placement(transformation(extent={{-54,18},{-34,38}})));
  TransiEnt.Components.Sensors.RealGas.NCVSensor vleNCVSensor(medium=gasMedium) annotation (Placement(transformation(
        extent={{8,-7},{-8,7}},
        rotation=90,
        origin={-7,78})));

protected
  TransiEnt.Components.Statistics.Functions.GetFuelSpecificCO2Emissions fuelSpecificCO2Emissions(typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Functions.getPrimaryEnergyCarrierFromHeat(typeOfPrimaryEnergyCarrier));
equation
  der(E_total_generation) = Q_flow_gen;

  // === energy balance ===
  H_flow_gas_demand * eta = -Q_flow_set;

  // === GWP Emissions ===

  collectGwpEmissions.gwpCollector.m_flow_cde=-fuelSpecificCO2Emissions.m_flow_CDE_per_Energy*H_flow_gas_demand;
  collectHeatingPower.heatFlowCollector.Q_flow = -Q_flow_gen;
  connect(modelStatistics.heatFlowCollector[TransiEnt.Basics.Types.TypeOfResource.Cogeneration],collectHeatingPower.heatFlowCollector);

  // == Economics

  //Eye values (Visualization)
  eye.P=0;
  eye.Q_flow=Q_flow_gen;
  eye.T_supply=T_out_sensor.T_celsius;
  eye.T_return=T_in_sensor.T_celsius;
  eye.p = outlet.p/1e5;
  eye.h_supply = outlet.h_outflow/1e3;
  eye.h_return = inlet.h_outflow/1e3;
  eye.m_flow = -outlet.m_flow;

  // _____________________________________________
  //
  //                Connect Statements
  // _____________________________________________
  connect(modelStatistics.gwpCollectorHeat[typeOfPrimaryEnergyCarrier],collectGwpEmissions.gwpCollector);
  connect(modelStatistics.costsCollector, collectCosts.costsCollector);

  connect(inlet, heatFlowBoundary.fluidPortIn) annotation (Line(
      points={{100,0},{68,0},{68,-0.4},{45.8,-0.4}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(heatFlowBoundary.fluidPortOut, outlet) annotation (Line(
      points={{45.8,15.6},{68,15.6},{68,50},{100,50}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(sign.y, heatFlowBoundary.Q_flow_prescribed) annotation (Line(
      points={{-21.1,0},{12.45,0},{12.45,8.88178e-016},{26.8,8.88178e-016}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sign.u, Q_flow_set) annotation (Line(
      points={{-41.8,0},{-104,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_in_sensor.port, inlet) annotation (Line(
      points={{82,-40},{82,0},{100,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(outlet, T_out_sensor.port) annotation (Line(
      points={{100,50},{82,50},{82,60}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(nCVController.m_flow_desired, boundaryRealGas.m_flow) annotation (Line(points={{-33,28},{-28,28}}, color={0,0,127}));
  connect(massflowSensor.m_flow, nCVController.m_flow_is) annotation (Line(points={{-7,49.3},{-40,49.3},{-40,38.6}}, color={0,0,127}));
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
  connect(nCVController.H_flow_set, H_flow_set.y) annotation (Line(points={{-55,28},{-60.5,28}}, color={0,0,127}));
  connect(vleNCVSensor.NCV, nCVController.NCV_is) annotation (Line(points={{-7,69.2},{-7,68},{-48,68},{-48,38.4}}, color={0,0,127}));
  annotation (defaultComponentName="gasBoiler",Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics={
        Polygon(
          points={{-10,-92},{-22,-72},{-12,-76},{-6,-58},{4,-74},{12,-62},{18,
              -76},{28,-66},{16,-92},{-10,-92}},
          lineColor={175,0,0},
          smooth=Smooth.None,
          fillColor={255,128,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-44,26},{48,-22}},
          lineColor={28,108,200},
          textString="Var
NCV")}),                          Diagram(coordinateSystem(preserveAspectRatio=false,
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model of a gas boiler using TransiEnt interfaces and TransiEnt.Statistics. Gas Consumption is computed using a constand efficiency and constant heat of combustion.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modified by Lisa Andresen (andresen@tuhh.de), Jan 2017</span></p>
</html>"));
end GasBoilerCompositionAdaptive;
