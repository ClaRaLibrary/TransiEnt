within TransiEnt.Producer.Heat.SmallGasBoiler.Base;
partial model PartialGasboiler "Full modulating gasboiler, partial model with splitted combustion and heat-transfer"

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

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
  parameter TILMedia.GasTypes.BaseGas FuelMedium=simCenter.gasModel2 "|Fundamental definitions|Fuel gas medium";
  parameter TILMedia.GasTypes.BaseGas ExhaustMedium=simCenter.exhaustGasModel "|Fundamental definitions|Exhaust gas medium";
  parameter TILMedia.VLEFluidTypes.BaseVLEFluid WaterMedium=simCenter.fluid1 "|Fundamental definitions|Heat carrier medium";

  parameter Boolean holdTemperature=false "|Operation mode|Boiler produces heat duty given by input. Set to true to only hold supply temperature.";
  parameter Boolean fixedSupplyTemperature=true "|Operation mode|Boiler produces a supply temperature given by input. Set to false to leave it variable" annotation (Dialog(enable = not holdTemperature));

  parameter SI.HeatFlowRate Q_flow_n=5e5 "|Specification|Nominal heating power";
  parameter SI.HeatFlowRate Q_flow_min=0.1*Q_flow_n "|Specification|Minimum heat duty for min. efficiency";
  parameter SI.Temperature T_supply_max(displayUnit="K")=273.15+120 "|Specification|Maximum supply temperature";
  parameter SI.TemperatureDifference dT_max_DH=
    if simCenter.heatingCurve.T_supply_const == 0
    then 41
    else simCenter.heatingCurve.T_supply_const - simCenter.heatingCurve.T_return_const "|Specification|Maximum heat carrier temperature spread";
  parameter SI.MassFlowRate m_flow_min= 0.15 "|Specification|Mass flow rate to switch off. Non-zero mass flow leads to higher numerical stability";
  parameter SI.Pressure Delta_p_nom=2000 "|Specification|Nominal pressure loss";
  final parameter SI.SpecificHeatCapacity cp_water=TILMedia.VLEFluidFunctions.specificIsobaricHeatCapacity_pTxi(WaterMedium, 6*1e5, 273.15+60, {1});

  parameter Boolean condensing=true "|Combustion|Condensing operation, influence on emission calculation only.";
  parameter Real lambda=1.2 "|Combustion|Combustion air ratio";
  parameter Boolean referenceNCV = true "|Combustion|true, if heat calculations shall be in respect to NCV, false will give GCV";

  //Statistics
  parameter TransiEnt.Basics.Types.TypeOfResource TypeOfResource=TransiEnt.Basics.Types.TypeOfResource.Conventional "|Statistics|Type of resource";
  parameter TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat TypeOfEnergyCarrierHeat=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.NaturalGas "|Statistics|Type of energy carrier";
  replaceable model CostRecordBoiler = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PeakLoadBoiler
    constrainedby TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.PartialCostSpecs "|Statistics|Cost specification" annotation (choicesAllMatching=true);
  parameter TransiEnt.Basics.Units.MonetaryUnitPerEnergy Cspec_demAndRev_gas_fuel=simCenter.Cfue_GasBoiler "|Statistics|Specific demand-related cost per gas energy";

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
  Modelica.Blocks.Interfaces.RealInput Q_flow_set(unit="W", value=Q_flow_set_internal) if (not holdTemperature) "Heat duty" annotation (Placement(transformation(extent={{-136,76},{-112,100}}),
        iconTransformation(extent={{-106,76},{-82,100}})));
  Modelica.Blocks.Interfaces.RealInput T_supply_set(
    unit="K",
    value=T_supply_set_internal,
    min=273.15) if fixedSupplyTemperature "Supply temperature set value" annotation (Placement(transformation(extent={{-136,38},{-112,62}}), iconTransformation(extent={{-106,38},{-82,62}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow_HC_req(unit="kg/s", value=
       m_flow_HC_req_internal) if fixedSupplyTemperature and (not holdTemperature) "Required heat carrier mass flow -> Usage not recommended, may lead to numerical instability!"  annotation (Placement(transformation(
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
  Modelica.Blocks.Logical.Switch boilerswitch(u2(value=switch)) annotation (Placement(transformation(extent={{-68,84},{-56,96}})));
  Modelica.Blocks.Sources.RealExpression offValue(y=0) annotation (Placement(transformation(extent={{-102,68},{-82,88}})));
  Modelica.Blocks.Math.Abs abs1 annotation (Placement(transformation(extent={{-48,84},{-36,96}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=Q_flow_n, uMin=0,
    limitsAtInit=true)  annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-24,90})));
  Utilities.RT2EfficiencyCharline rT2EfficiencyCharline(condensing=condensing, referenceNCV=referenceNCV) annotation (Placement(transformation(extent={{10,40},{30,60}})));
  Utilities.Duty2EfficiencyCharline duty2EfficiencyCharline(
    Q_flow_n=Q_flow_n,
    condensing=condensing,
    referenceNCV=referenceNCV) annotation (Placement(transformation(extent={{10,80},{30,100}})));
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
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectHeatingPower collectHeatingPower(typeOfResource=TypeOfResource, is_setter=true) annotation (Placement(transformation(extent={{80,100},{100,120}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectGwpEmissionsHeat collectGwpEmissions(typeOfEnergyCarrierHeat=TypeOfEnergyCarrierHeat) annotation (Placement(transformation(extent={{100,100},{120,120}})));
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.CollectCostsGeneral collectCosts(
    der_E_n=Q_flow_n,
    E_n=0,
    redeclare model CostRecordGeneral = CostRecordBoiler,
    Cspec_demAndRev_gas_fuel=Cspec_demAndRev_gas_fuel,
    Q_flow=-Q_flow_out,
    H_flow=Q_flow_fuel,
    m_flow_CDE=-m_flow_CDE) annotation (Placement(transformation(extent={{60,100},{80,120}})));

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
      points={{-75,-110},{-80,-110},{-80,50},{9.6,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(abs1.y, limiter.u) annotation (Line(
      points={{-35.4,90},{-31.2,90}},
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
  connect(boilerswitch.y, abs1.u) annotation (Line(
      points={{-55.4,90},{-49.2,90}},
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
      points={{30.2,50},{40,50},{40,67.6},{55.2,67.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(limiter.y, duty2EfficiencyCharline.Q_flow_set) annotation (Line(
      points={{-17.4,90},{9.6,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(duty2EfficiencyCharline.eta, product.u1) annotation (Line(
      points={{30.6,90},{40,90},{40,72.4},{55.2,72.4}},
      color={0,0,127},
      smooth=Smooth.None));

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
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Partial model for small gas boilers.</p>
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
<p>Model created by Paul Kernstock (paul.kernstock@tu-harburg.de) July 2015 </p>
<p>Revised by Lisa Andresen (andresen@tuhh.de), Aug 2015</p>
</html>"));
end PartialGasboiler;
