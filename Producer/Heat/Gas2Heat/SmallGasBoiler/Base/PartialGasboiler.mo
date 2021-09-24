within TransiEnt.Producer.Heat.Gas2Heat.SmallGasBoiler.Base;
partial model PartialGasboiler "Full modulating gasboiler, partial model with splitted combustion and heat-transfer"


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




  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  import TransiEnt;
  extends TransiEnt.Basics.Icons.Boiler;
  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //          Constants and Parameters
  // _____________________________________________
  parameter TILMedia.GasTypes.BaseGas FuelMedium=simCenter.gasModel2 "Fuel gas medium" annotation (Dialog(tab="General", group="Fundamental definitions"));
  parameter TILMedia.GasTypes.BaseGas ExhaustMedium=simCenter.exhaustGasModel "Exhaust gas medium" annotation (Dialog(tab="General", group="Fundamental definitions"));
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid WaterMedium=simCenter.fluid1 "Heat carrier medium" annotation (Dialog(tab="General", group="Fundamental definitions"));

  parameter Boolean holdTemperature=false "Boiler produces heat duty given by input. Set to true to only hold supply temperature." annotation (Dialog(tab="General", group="Operation mode"));
  parameter Boolean fixedSupplyTemperature=true "Boiler produces a supply temperature given by input. Set to false to leave it variable" annotation (Dialog(tab="General", group="Operation mode", enable = not holdTemperature));

  parameter SI.HeatFlowRate Q_flow_n=5e5 "Nominal heating power" annotation (Dialog(tab="General", group="Specification"));
  parameter SI.HeatFlowRate Q_flow_min=0.1*Q_flow_n "Minimum heat duty for min. efficiency" annotation (Dialog(tab="General", group="Specification"));
  parameter SI.Temperature T_supply_max(displayUnit="K")=273.15+120 "Maximum supply temperature" annotation (Dialog(tab="General", group="Specification"));
  parameter SI.TemperatureDifference dT_max_DH=
    if simCenter.heatingCurve.T_supply_const == 0
    then 41
    else simCenter.heatingCurve.T_supply_const - simCenter.heatingCurve.T_return_const "Maximum heat carrier temperature spread" annotation (Dialog(tab="General", group="Specification"));
  parameter SI.MassFlowRate m_flow_min= 0.15 "Mass flow rate to switch off. Non-zero mass flow leads to higher numerical stability" annotation (Dialog(tab="General", group="Specification"));
  parameter SI.Pressure Delta_p_nom=2000 "Nominal pressure loss" annotation (Dialog(tab="General", group="Specification"));
  final parameter SI.SpecificHeatCapacity cp_water=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificIsobaricHeatCapacity_pTxi(WaterMedium, 6*1e5, 273.15+60, {1});

  parameter Boolean condensing=true "Condensing operation, influence on emission calculation only." annotation (Dialog(tab="General", group="Combustion"));
  parameter Real lambda=1.2 "Combustion air ratio" annotation (Dialog(tab="General", group="Combustion"));
  parameter Boolean referenceNCV = true "true, if heat calculations shall be in respect to NCV, false will give GCV" annotation (Dialog(tab="General", group="Combustion"));

  //Statistics
  parameter TransiEnt.Basics.Types.TypeOfResource TypeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional "Type of resource" annotation (Dialog(tab="General", group="Statistics"));
  parameter TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat TypeOfEnergyCarrierHeat=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.NaturalGas "Type of energy carrier" annotation (Dialog(tab="General", group="Statistics"));
  replaceable model CostRecordBoiler = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PeakLoadBoiler
    constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs "Cost specification" annotation (Dialog(tab="General", group="Statistics"), choicesAllMatching=true);
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_gas_fuel=simCenter.Cfue_GasBoiler "Specific demand-related cost per gas energy" annotation (Dialog(tab="General", group="Statistics"));

  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________

  inner Boolean switch(start=true) "Boiler switch";
  SI.HeatFlowRate Q_flow_set_internal(start=0) "Heat set value";
  SI.HeatFlowRate Q_flow_out "Generated heat";
  SI.HeatFlowRate Q_flow_fuel=m_flow_fuel*CalorificValue "Consumed fuel (related to NCV or GCV as defined)";
  SI.SpecificEnthalpy CalorificValue=if referenceNCV then TransiEnt.Basics.Functions.GasProperties.getIdealGasNCV_xi(
      FuelMedium,
      xi_in=xi_fuel[1:FuelMedium.nc - 1],
      NCVIn=0) else TransiEnt.Basics.Functions.GasProperties.getIdealGasGCV_xi(
      FuelMedium,
      xi_in=xi_fuel[1:FuelMedium.nc - 1],
      GCVIn=0) "Calorific value of fuel";
  SI.Efficiency eta = product.y "Boiler's overall efficiency";
  SI.Temperature T_supply_set_internal "Internally set supply temperature";
  SI.Temperature T_supply = temperatureWaterOut.T "Supply temperature";
  SI.Temperature T_return = temperatureWaterIn.T "Return temperature";
  SI.TemperatureDifference dT = T_supply-T_return "Temperature difference";
  SI.MassFlowRate m_flow_fuel = gasPortIn.m_flow "Fuel mass flow rate";
  SI.MassFlowRate m_flow_CDE = gasPortOut.m_flow*gasPortOut.xi_outflow[2] "CDE mass flow rate";
  SI.MassFlowRate m_flow_air = combustion.m_flow_air "Air mass flow rate";
  SI.MassFlowRate m_flow_HC_req_internal(start=0) "Required heat carrier mass flow rate for heat-duty-controlled mode";
  SI.MassFlowRate m_flow_HC = waterPortIn.m_flow "Actual heat carrier mass flow rate";
   SI.MassFraction xi_fuel[FuelMedium.nc] "[CH4, C2H6, C3H8, C4H10, N2, CO2, H2] Fuel gas mass fractions";
   SI.MassFraction xi_exhaust[ExhaustMedium.nc] "[H2O, CO2, CO, H2, O2, NO, NO2, SO2, N2] Exhaust gas mass fractions";

  // _____________________________________________
  //
  //                   Interfaces
  // _____________________________________________
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_set=Q_flow_set_internal if (not holdTemperature) "Heat duty" annotation (Placement(transformation(extent={{-136,76},{-112,100}}),
        iconTransformation(extent={{-106,76},{-82,100}})));
  TransiEnt.Basics.Interfaces.General.TemperatureIn T_supply_set(min=273.15)=T_supply_set_internal if fixedSupplyTemperature "Supply temperature set value" annotation (Placement(transformation(extent={{-136,38},{-112,62}}), iconTransformation(extent={{-106,38},{-82,62}})));
  TransiEnt.Basics.Interfaces.General.MassFlowRateOut m_flow_HC_req=
       m_flow_HC_req_internal if fixedSupplyTemperature and (not holdTemperature) "Required heat carrier mass flow -> Usage not recommended, may lead to numerical instability!"  annotation (Placement(transformation(
        extent={{12,-12},{-12,12}},
        rotation=90,
        origin={-90,-124}), iconTransformation(
        extent={{12,-12},{-12,12}},
        rotation=90,
        origin={-88,-82})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut(Medium=WaterMedium) annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={40,-120}), iconTransformation(extent={{46,-92},{66,-72}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn(Medium=WaterMedium) annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-40,-120}), iconTransformation(extent={{-46,-92},{-66,-72}})));
  TransiEnt.Basics.Interfaces.Gas.IdealGasEnthPortIn gasPortIn(Medium=FuelMedium) annotation (Placement(transformation(extent={{-130,-10},{-110,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Gas.IdealGasEnthPortOut gasPortOut(Medium=ExhaustMedium) annotation (Placement(transformation(extent={{110,-10},{130,10}}), iconTransformation(extent={{90,-10},{110,10}})));

  // _____________________________________________
  //
  //                   Complex Components
  // _____________________________________________
protected
  Modelica.Blocks.Sources.RealExpression Q_flow_set_value(y=Q_flow_set_internal)  annotation (Placement(transformation(extent={{-102,80},{-82,100}})));
  Modelica.Blocks.Logical.Switch boilerswitch(u2=switch) annotation (Placement(transformation(extent={{-68,84},{-56,96}})));
  Modelica.Blocks.Sources.RealExpression offValue(y=0) annotation (Placement(transformation(extent={{-102,68},{-82,88}})));
  Modelica.Blocks.Math.Abs abs1 annotation (Placement(transformation(extent={{-20,84},{-8,96}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=Q_flow_n, uMin=0) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={8,90})));
  Utilities.RT2EfficiencyCharline rT2EfficiencyCharline(condensing=condensing, referenceNCV=referenceNCV) annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Utilities.Duty2EfficiencyCharline duty2EfficiencyCharline(
    Q_flow_n=Q_flow_n,
    condensing=condensing,
    referenceNCV=referenceNCV) annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Modelica.Blocks.Math.Product product  annotation (Placement(transformation(extent={{56,66},{64,74}})));
  TransiEnt.Components.Gas.Combustion.FullConversion_idealGas combustion(lambda=lambda) annotation (Placement(transformation(extent={{64,16},{96,48}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureWaterOut(medium=WaterMedium) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={68,-110})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureWaterIn(medium=WaterMedium) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-64,-110})));

public
 Modelica.Blocks.Logical.Switch boilerswitch2 "off-switch, when supply temperature is lower than return temperature"
                                                                annotation (Placement(transformation(extent={{-42,78},{-28,92}})));
  Modelica.Blocks.Logical.Greater greater annotation (Placement(transformation(extent={{-66,48},{-54,60}})));

  Modelica.Blocks.Sources.RealExpression t_return(y=T_return) annotation (Placement(transformation(extent={{-98,36},{-78,56}})));
  Modelica.Blocks.Sources.RealExpression t_max(y=T_supply_set_internal) annotation (Placement(transformation(extent={{-98,50},{-78,70}})));

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TypeOfResource, is_setter=true) annotation (Placement(transformation(extent={{80,100},{100,120}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsHeat collectGwpEmissions(typeOfEnergyCarrierHeat=TypeOfEnergyCarrierHeat) annotation (Placement(transformation(extent={{100,100},{120,120}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectCostsGeneral collectCosts(
    der_E_n=Q_flow_n,
    E_n=0,
    redeclare model CostRecordGeneral = CostRecordBoiler,
    Cspec_demAndRev_gas_fuel=Cspec_demAndRev_gas_fuel,
    Q_flow=-Q_flow_out,
    H_flow=Q_flow_fuel,
    m_flow_CDE=-m_flow_CDE,
    produces_P_el=false,
    consumes_P_el=false,
    consumes_Q_flow=false,
    produces_H_flow=false,
    produces_other_flow=false,
    consumes_other_flow=false,
    consumes_m_flow_CDE=false)
                            annotation (Placement(transformation(extent={{60,100},{80,120}})));

equation
  //Assertions
  assert(gasPortIn.m_flow >= 0, "Your boiler is a gas source.",
    AssertionLevel.warning);
  assert(abs(Q_flow_set_internal)-0.01 <= Q_flow_n,
  if (not holdTemperature) then "Boiler duty exceeds nominal output. Q_flow_set_internal = "
     + String(Q_flow_set_internal) + ", Q_flow_n = " + String(Q_flow_n) + "." else "Boiler duty exceeds nominal output. Q_flow_set_internal = "
     + String(Q_flow_set_internal) + ", Q_flow_n = " + String(Q_flow_n) + ". Supply temperature cannot be held!",
  AssertionLevel.warning);
  if abs(Q_flow_set_internal) > 0.0 then
    assert(
      abs(Q_flow_set_internal) >= Q_flow_min,
      "Boiler duty is below boiler minimum (Q_flow_set_internal = " + String(Q_flow_set_internal) + "). Efficiency is therefore not correctly calculated!",
      AssertionLevel.warning);
  end if;
  assert(
    temperatureWaterOut.T < T_supply_max,
    "Supply temperature exceeds maximum (T_supply = " + String(
    temperatureWaterOut.T) + "K)! Reduce heat input or increase HC (water) flow!",
    AssertionLevel.warning);

  // _____________________________________________
  //
  //            Characteristic equations
  // _____________________________________________
  Q_flow_out = waterPortOut.m_flow*(actualStream(waterPortOut.h_outflow)-actualStream(waterPortIn.h_outflow));

  gasPortIn.m_flow = if switch then abs(Q_flow_set_internal)/eta/CalorificValue else 0;
  m_flow_HC_req_internal * cp_water * (T_supply_set_internal - temperatureWaterIn.T) = abs(Q_flow_set_internal);
  if (not fixedSupplyTemperature) then
    T_supply_set_internal = 273.15 + 90 "dummy!";
  end if;

   xi_fuel[1:FuelMedium.nc - 1] = inStream(gasPortIn.xi_outflow);
   xi_fuel[end] = 1-sum(xi_fuel[1:FuelMedium.nc - 1]);
   xi_exhaust[1:ExhaustMedium.nc - 1] = -gasPortOut.xi_outflow;
   xi_exhaust[end] = 1-sum(xi_exhaust[1:ExhaustMedium.nc - 1]);

  //switch off when HC flow becomes zero
  if pre(switch) == true and waterPortIn.m_flow <= m_flow_min then
    switch = false;
  //switch on as soon as HC flow is up again
  elseif pre(switch) == false and waterPortIn.m_flow > m_flow_min then
    switch = true;
  else
    switch = pre(switch);
  end if;

  //Write generated heat and emissions to statistical collectors
  collectHeatingPower.heatFlowCollector.Q_flow=Q_flow_out;
  collectGwpEmissions.gwpCollector.m_flow_cde =m_flow_CDE;

  //Statistics
  connect(modelStatistics.heatFlowCollector[TypeOfResource],collectHeatingPower.heatFlowCollector);
  connect(modelStatistics.gwpCollectorHeat[TypeOfEnergyCarrierHeat],collectGwpEmissions.gwpCollector);
  connect(modelStatistics.costsCollector, collectCosts.costsCollector);

  connect(temperatureWaterIn.T, rT2EfficiencyCharline.T_return) annotation (Line(
      points={{-75,-110},{-82,-110},{-82,-48},{-20,-48},{-20,50},{19.6,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(abs1.y, limiter.u) annotation (Line(
      points={{-7.4,90},{0.8,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(waterPortIn, temperatureWaterIn.port) annotation (Line(
      points={{-40,-120},{-64,-120}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(waterPortOut, temperatureWaterOut.port) annotation (Line(
      points={{40,-120},{68,-120}},
      color={175,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(Q_flow_set_value.y, boilerswitch.u1) annotation (Line(
      points={{-81,90},{-76,90},{-76,94.8},{-69.2,94.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(offValue.y, boilerswitch.u3) annotation (Line(
      points={{-81,78},{-76,78},{-76,85.2},{-69.2,85.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gasPortIn, combustion.gasPortIn) annotation (Line(
      points={{-120,0},{52,0},{52,32},{64,32}},
      color={255,213,170},
      thickness=0.5,
      smooth=Smooth.None));
  connect(combustion.gasPortOut, gasPortOut) annotation (Line(
      points={{96,32},{110,32},{110,0},{120,0}},
      color={255,213,170},
      thickness=0.5,
      smooth=Smooth.None));
  connect(rT2EfficiencyCharline.eta, product.u2) annotation (Line(
      points={{40.2,50},{48,50},{48,67.6},{55.2,67.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(limiter.y, duty2EfficiencyCharline.Q_flow_set) annotation (Line(
      points={{14.6,90},{19.6,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(duty2EfficiencyCharline.eta, product.u1) annotation (Line(
      points={{40.6,90},{48,90},{48,72.4},{55.2,72.4}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(t_max.y, greater.u1) annotation (Line(points={{-77,60},{-76,60},{-76,54},{-67.2,54}}, color={0,0,127}));
  connect(t_return.y, greater.u2) annotation (Line(points={{-77,46},{-77,49.2},{-67.2,49.2}}, color={0,0,127}));
  connect(greater.y, boilerswitch2.u2) annotation (Line(points={{-53.4,54},{-48,54},{-48,85},{-43.4,85}}, color={255,0,255}));
  connect(offValue.y, boilerswitch2.u3) annotation (Line(points={{-81,78},{-48,78},{-48,79.4},{-43.4,79.4}}, color={0,0,127}));
  connect(boilerswitch.y, boilerswitch2.u1) annotation (Line(points={{-55.4,90},{-43.4,90},{-43.4,90.6}}, color={0,0,127}));
  connect(boilerswitch2.y, abs1.u) annotation (Line(points={{-27.3,85},{-24,85},{-24,90},{-21.2,90}}, color={0,0,127}));
  annotation (defaultComponentName="GasBoiler",
  Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-120,
            -120},{120,120}}),
                    graphics={Line(
          points={{70,70},{80,70},{80,46}},
          color={170,213,255},
          smooth=Smooth.None,
          arrow={Arrow.None,Arrow.Filled},
          thickness=0.5),            Text(
          extent={{110,48},{86,72}},
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="m_flow_fuel")}),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
        graphics),Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>Partial model for small gas boilers.</p>
<p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<p><b><span style=\"color: #008000;\">4. Interfaces</span></b></p>
<p>waterPortIn: fluidPortIn</p>
<p>waterPorOut: fluidPortOut</p>
<p>Q_flow_set: heat flow rate in [W]</p>
<p>gasPortIn: inlet for ideal gas</p>
<p>gasPortOut: outlet for ideal gas</p>
<p>T_supply_set: input for supply temperature in [K]</p>
<p>m_flow_HC_rec: output for mass flow rate in [kg/s] (Required heat carrier mass flow -&gt; Usage not recommended, may lead to numerical instability!)</p>
<p><b><span style=\"color: #008000;\">5. Nomenclature</span></b></p>
<p>(no elements)</p>
<p><b><span style=\"color: #008000;\">6. Governing Equations</span></b></p>
<p>(no equations)</p>
<p><b><span style=\"color: #008000;\">7. Remarks for Usage</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">8. Validation</span></b></p>
<p>(no validation or testing necessary)</p>
<p><b><span style=\"color: #008000;\">9. References</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">10. Version History</span></b></p>
<p>Model created by Paul Kernstock (paul.kernstock@tu-harburg.de) July 2015 </p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Aug 2015</p>
<p>Modified by Anne Hagemeier (anne.hagemeier@umsicht.fraunhofer.de), July 2021 (added switch to prevent that boiler generates heat when T_return &gt; T_max )</p>
</html>"));
end PartialGasboiler;
