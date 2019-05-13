within TransiEnt.Producer.Heat.Gas2Heat.SimpleGasBoiler;
model SimpleBoiler "Simple generic boiler model (without gas ports)"
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

  extends Base.PartialBoiler;
  outer TransiEnt.SimCenter simCenter;
  // _____________________________________________
  //
  //                Parameters
  // _____________________________________________
    parameter TILMedia.VLEFluidTypes.BaseVLEFluid   gasMedium= simCenter.gasModel1 if Add_GasPort "Medium to be used for gas"
                                 annotation(choicesAllMatching, Dialog(group="Fluid Definition"));
  parameter Real k= if Add_GasPort then -1 else 1;
  parameter Modelica.SIunits.SpecificEnthalpy HoC_gas=40e6 "heat of combustion of natural gas";
  parameter Boolean Add_GasPort=false;
  parameter SI.Pressure p_drop=simCenter.p_nom[2] -simCenter.p_nom[1];

  parameter TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.NaturalGas "Type of primary energy carrier for co2 emissions global statistics" annotation (Dialog(group="Statistics"), HideResult=true);
  parameter Boolean integrateHeatFlow=false "True if heat flow shall be integrated";
  // _____________________________________________
  //
  //                Complex Components
  // _____________________________________________

Basics.Interfaces.Gas.RealGasPortIn gasIn(Medium=gasMedium) if Add_GasPort annotation (Placement(transformation(extent={{-10,90},{10,110}}), iconTransformation(extent={{-8,-110},{12,-90}})));
 Components.Boundaries.Gas.BoundaryRealGas_hxim_flow massFlowSink(
    p_nom=1000,
    variable_h=false,
    m_flow_const=1,
    variable_m_flow=true,
    medium=gasMedium,
    h_const=785686) if Add_GasPort annotation (Placement(transformation(extent={{-30,62},{-10,82}})));
  replaceable model BoilerCostModel = Components.Statistics.ConfigurationData.PowerProducerCostSpecs.GasBoiler constrainedby Components.Statistics.ConfigurationData.PowerProducerCostSpecs.BoilerCost annotation(choicesAllMatching=true);

  replaceable TransiEnt.Components.Boundaries.Heat.Heatflow_L1 heatFlowBoundary(
    p_drop=p_drop,
    Medium=medium,
    change_sign=true,
    use_Q_flow_in=true) constrainedby TransiEnt.Components.Boundaries.Heat.Base.PartialHeatBoundary annotation (choicesAllMatching=true, Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={36,7})));
  Modelica.Blocks.Math.Gain sign(k=-1)
    annotation (Placement(transformation(extent={{-40,-9},{-22,9}})));

  Modelica.Blocks.Sources.RealExpression
                            m_flow_set(y=m_flow_gas_demand) "just for visualisation on diagram layer"
    annotation (Placement(transformation(extent={{-74,68},{-44,88}})));

  Components.Sensors.TemperatureSensor T_in_sensor annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,-42})));
  Components.Sensors.TemperatureSensor T_out_sensor annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={44,60})));
  Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional) annotation (Placement(transformation(extent={{80,-100},{100,-80}})));

  Components.Statistics.Collectors.LocalCollectors.HeatingPlantCost collectCosts(
    Q_flow_n=Q_flow_n,
    m_flow_CDE_is=-collectGwpEmissions.gwpCollector.m_flow_cde,
    Q_flow_is=Q_flow_gen,
    Q_flow_fuel_is=Q_flow_gen/eta,
    redeclare model HeatingPlantCostModel = BoilerCostModel) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={46,-90})));

  //Visualization
  Basics.Interfaces.General.EyeOut eye annotation (Placement(transformation(extent={{100,-100},{120,-80}})));

  Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsElectric collectGwpEmissions annotation (Placement(transformation(extent={{-10,-100},{10,-80}})));

  // _____________________________________________
  //
  //                    Variables
  // _____________________________________________

  SI.Energy E_total_generation(start=0);
  SI.HeatFlowRate Q_flow_gen = k*inlet.m_flow * (outlet.h_outflow - inStream(inlet.h_outflow));
  Modelica.SIunits.MassFlowRate m_flow_gas_demand;


protected
  TransiEnt.Components.Statistics.Functions.GetFuelSpecificCO2Emissions fuelSpecificCO2Emissions(typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Functions.getPrimaryEnergyCarrierFromHeat(typeOfPrimaryEnergyCarrier));
equation

  if integrateHeatFlow then
  der(E_total_generation) =Q_flow_gen;
  else
    E_total_generation=0;
  end if;

  // === energy balance ===
  m_flow_gas_demand * HoC_gas * eta = k*Q_flow_set;

  // === GWP Emissions ===

  collectGwpEmissions.gwpCollector.m_flow_cde=-fuelSpecificCO2Emissions.m_flow_CDE_per_Energy*Q_flow_gen/eta;
  collectHeatingPower.heatFlowCollector.Q_flow =Q_flow_gen;
  connect(modelStatistics.heatFlowCollector[TransiEnt.Basics.Types.TypeOfResource.Conventional],collectHeatingPower.heatFlowCollector);

  // == Economics
  connect(modelStatistics.costsCollector, collectCosts.costsCollector);

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
  connect(inlet, heatFlowBoundary.fluidPortIn) annotation (Line(
      points={{100,0},{100,1},{46,1}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(heatFlowBoundary.fluidPortOut, outlet) annotation (Line(
      points={{46,13},{68,13},{68,50},{100,50}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(sign.y, heatFlowBoundary.Q_flow_prescribed) annotation (Line(
      points={{-21.1,0},{12.45,0},{12.45,1},{28,1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sign.u, Q_flow_set) annotation (Line(
      points={{-41.8,0},{-104,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_in_sensor.port, inlet) annotation (Line(
      points={{50,-32},{67.6,-32},{67.6,0},{100,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(outlet, T_out_sensor.port) annotation (Line(
      points={{100,50},{76,50},{76,70},{44,70}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  if Add_GasPort then
      connect(m_flow_set.y, massFlowSink.m_flow) annotation (Line(
      points={{-42.5,78},{-32,78}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(massFlowSink.gasPort, gasIn) annotation (Line(
      points={{-10,72},{0,72},{0,100}},
      color={255,255,0},
      thickness=1.5));
  end if
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics={
                                         Line(
          points={{-60,0},{-60,4},{-60,70}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Filled},
          pattern=LinePattern.Dash),                                            Line(
          points={{-30,78},{0,78},{0,78},{0,-74}},
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
<p><span style=\"font-family: MS Shell Dlg 2;\">Basics.Interfaces.Thermal.FluidPort In/Out - heat carrier ports (e.g. water)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica.Blocks.Interfaces.RealInput&nbsp;Q_flow_set - setpoint for thermal heat</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Basics.Interfaces.General.EyeOut</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: Courier New;\">m_flow_gas_demand * HoC_gas * eta = Q_flow_set</span></p>
<p><span style=\"font-family: Courier New;\">Q_flow_gen&nbsp;=&nbsp;inlet.m_flow&nbsp;*&nbsp;(outlet.h_outflow&nbsp;-<span style=\"color: #ff0000;\">&nbsp;inStream</span>(inlet.h_outflow))</p>
<p><span style=\"font-family: Courier New;\">m_flow_set(y=m_flow_gas_demand)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarsk for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
<p>Modified by Anne Senkel (anne.senkel@tuhh.de), Dec 2017</p>
</html>"));

  annotation (Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model of a gas boiler using TransiEnt interfaces and TransiEnt.Statistics. Gas Consumption is computed using a constand efficiency and constant heat of combustion.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Basics.Interfaces.Thermal.FluidPort In/Out - heat carrier ports (e.g. water)</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Modelica.Blocks.Interfaces.RealInput&nbsp;Q_flow_set - setpoint for thermal heat</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Basics.Interfaces.General.EyeOut</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no elements)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: Courier New;\">m_flow_gas_demand * HoC_gas * eta = Q_flow_set</span></p>
<p><span style=\"font-family: Courier New;\">Q_flow_gen&nbsp;=&nbsp;inlet.m_flow&nbsp;*&nbsp;(outlet.h_outflow&nbsp;-<span style=\"color: #ff0000;\">&nbsp;inStream</span>(inlet.h_outflow))</p>
<p><span style=\"font-family: Courier New;\">m_flow_set(y=m_flow_gas_demand)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Pascal Dubucq (dubucq@tuhh.de) on 01.10.2014</span></p>
<p>Modified by Anne Senkel (anne.senkel@tuhh.de), Dec 2017</p>
</html>"));
end SimpleBoiler;
