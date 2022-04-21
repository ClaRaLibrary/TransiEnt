within TransiEnt.Consumer.Systems.HouseholdEnergyConverter.Systems;
model solarThermal_Boiler "Solar heating and gas boiler"



//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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

  extends TransiEnt.Consumer.Systems.HouseholdEnergyConverter.Systems.Base.Systems(
    final DHN=false,
    final gas_grid=useGasPort,
    final el_grid=true,
    medium1=FuelMedium);

  // _____________________________________________
  //
  //           Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid FuelMedium=simCenter.gasModel1 "Fuel gas medium" annotation (Dialog(group="Fluid Definition", enable=useGasPort));
  parameter Boolean useGasPort=true "True if gas port shall be used" annotation (Dialog(group="System setup"), choices(checkBox=true));
  parameter SI.SpecificEnthalpy HoC_fuel=40e6 "Heat of combustion of fuel, will be used if gasport is deactivated in model" annotation (Dialog(group="Fluid Definition", enable=not useGasPort));
  parameter Boolean SpaceHeating=true "Does the solar heating system provide energy for space heating?" annotation (
    HideResult=true,
    choices(checkBox=true),
    Dialog(group="System setup"));
  parameter SI.Temperature T_room=288 "Temperature of the installation room" annotation (HideResult=true, Dialog(group="Storage"));
  parameter SI.Temperature T_return=308.15 "Return temperature of the heating system" annotation (HideResult=true, Dialog(group="System setup"));
  parameter SI.Temperature T_boiler=60 + 273.15 "Temperature setpoint of the boiler" annotation (HideResult=true, Dialog(group="System setup"));
  parameter SI.HeatFlowRate Q_flow_n_boiler=20000 "Nominal heating power of the gas boiler" annotation (HideResult=true, Dialog(group="Boiler"));
  parameter SI.Efficiency eta=1.05 "Boiler's overall efficiency" annotation (HideResult=true, Dialog(group="Boiler"));
  parameter TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat typeOfPrimaryEnergyCarrier=TransiEnt.Basics.Types.TypeOfPrimaryEnergyCarrierHeat.NaturalGas "Type of primary energy carrier for co2 emissions global statistics" annotation (Dialog(group="Boiler"));
  replaceable model BoilerCostModel = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.GasBoiler annotation (__Dymola_choicesAllMatching=true, Dialog(group="Boiler"));

  parameter SI.Irradiance G_min=150 "Minimum Irradiance before collector is working" annotation (HideResult=true, Dialog(group="Collector"));
  parameter SI.Temperature T_set=348.15 "Temperature set point for controller" annotation (HideResult=true, Dialog(group="Collector"));
  parameter SI.Temperature T_max=273.15 + 95 "Maximum input temperature for collector switch-off" annotation (HideResult=true, Dialog(group="Collector"));
  parameter SI.HeatFlowRate Q_flow_n=100e3 "Nominal heat flow rate of the collector (for cost calculation)" annotation (HideResult=true, Dialog(group="Collector"));
  parameter SI.Area area=5 "Aperture area" annotation (HideResult=true, Dialog(group="Collector"));
  parameter Real c_eff(unit="J/(m2.K)") = 5000 "Effective thermal capacity of the collector" annotation (HideResult=true, Dialog(group="Collector"));
  parameter Real eta_0=0.793 "Zero-loss collector efficiency" annotation (HideResult=true, Dialog(group="Collector"));
  parameter Real a1(unit="W/(m2.K)") = 4.04 "Heat loss coefficient at (T_m - T_amb) = 0" annotation (HideResult=true, Dialog(group="Collector"));
  parameter Real a2(unit="W/(m2.K)") = 0.0182 "Temperature dependent heat loss coefficient" annotation (HideResult=true, Dialog(group="Collector"));
  parameter SI.Angle longitude_standard=Modelica.Units.Conversions.from_deg(15) "Needed for calculation of coordinated universal time (utc), 15 for central european time, 30 for central european summer time" annotation (HideResult=true, Dialog(group="Collector"));
  parameter Modelica.Units.NonSI.Time_day totaldays=365 "Total days of the year, standard=365, leap year=366" annotation (HideResult=true, Dialog(group="Collector"));
  parameter SI.Angle latitude=Modelica.Units.Conversions.from_deg(53.55) "Latitude of the local position, north posiive, 53,55 North for Hamburg" annotation (HideResult=true, Dialog(group="Collector"));
  parameter SI.Angle slope=Modelica.Units.Conversions.from_deg(53.55) "Slope of the tilted surface, assumption" annotation (HideResult=true, Dialog(group="Collector"));
  parameter SI.Angle surfaceAzimuthAngle=0 "Surface azimuth angle" annotation (HideResult=true, Dialog(group="Collector"));
  replaceable model Skymodel = TransiEnt.Producer.Heat.SolarThermal.Base.Skymodel_HDKR constrainedby TransiEnt.Producer.Heat.SolarThermal.Base.SkymodelBase "|Collector|choose between HDKR and isotropic sky model" annotation (choicesAllMatching=true, Dialog(tab="Irradiance", group="Skymodel"));
  parameter Real reflectance_ground=0.2 "Reflectance of the ground" annotation (HideResult=true, Dialog(group="Collector"));
  parameter Boolean direct_normal=true "Is the direct irradiance measured on a surface normal to irradiance?" annotation (HideResult=true, Dialog(group="Collector"));
  parameter SI.Angle longitude_local=Modelica.Units.Conversions.from_deg(10) "Longitude of the local position, east positive, 10 East for Hamburg" annotation (HideResult=true, Dialog(group="Collector"));
  parameter SI.Volume Volume_tank=2 "Volume of the storage tank" annotation (HideResult=true, Dialog(group="Storage"));
  parameter Real p_Volume[3]={0.2,0.3,0.5} "Proportion of the total volume for the three parts of the tank" annotation (HideResult=true, Dialog(group="Storage"));

  parameter SI.Temperature T_start[storage.N_cv]=fill(273.15 + 60, storage.N_cv) "Temperatures at initalization" annotation (HideResult=true, Dialog(group="Storage"));
  parameter SI.Length h_tank=1 "Height of tank" annotation (HideResult=true, Dialog(group="Storage"));
  parameter SI.CoefficientOfHeatTransfer U_wall=0.5 "Coefficient of heat transfer from wall to ambient " annotation (HideResult=true, Dialog(group="Storage"));
  parameter SI.ThermalConductivity k=0.6 "Thermal conductivity of fluid in storage" annotation (HideResult=true, Dialog(group="Storage"));
  parameter SI.Density rho=1e3 "Density of fluid in storage" annotation (HideResult=true, Dialog(group="Storage"));
  parameter SI.SpecificHeatCapacity c_v=4.185e3 "Heat capacity of fluid in storage" annotation (HideResult=true, Dialog(group="Storage"));

  replaceable model CostStatisticsModel = TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.SmallHotWaterStorage "Model for global cost calculation of the storage" annotation (
    choicesAllMatching=true,
    Dialog(group="Statistics"),
    HideResult=true);
  replaceable model CostRecordSolarThermal = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.SolarThermal "Solar thermal cost specification" annotation (
    choicesAllMatching=true,
    HideResult=true,
    Dialog(group="Statistics"));

  // _____________________________________________
  //
  //           Variables
  // _____________________________________________

  SI.Energy E_heating;
  SI.Energy E_hotwater;
  SI.Energy E_solar;
  SI.Energy E_boiler;

  Real SolarFraction=E_solar/(E_hotwater + E_heating + 0.001);

  SI.MassFlowRate m_flow_consumer;
  SI.MassFlowRate m_flow_hotwater;
  SI.Power Q_flow_boiler;

  SI.HeatFlowRate HeatingSolar;
  SI.MassFlowRate m_flow_fuel "Fuel mass flow rate";

  Real solarCoverage;
  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Sources.RealExpression heatFlowRate_boiler(y=Q_flow_boiler) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-48,-50})));

  TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.HotWaterStorage_constProp_L4 storage(
    N_cv=3,
    useFluidPorts=false,
    V=Volume_tank,
    p_Volume=p_Volume,
    h=h_tank,
    T_start=T_start,
    U_wall=U_wall,
    k=k,
    rho=rho,
    c_v=c_v,
    redeclare model CostStatisticsModel = CostStatisticsModel) annotation (Placement(transformation(extent={{-82,-14},{-60,8}})));

  TransiEnt.Producer.Heat.SolarThermal.SolarCollector_L1_constProp solarCollector(
    G_min=controller.G_min,
    Q_flow_n=Q_flow_n,
    area=area,
    eta_0=eta_0,
    a1=a1,
    a2=a2,
    c_eff=c_eff,
    useFluidPorts=false,
    longitude_local=longitude_local,
    longitude_standard=longitude_standard,
    totaldays=totaldays,
    latitude=latitude,
    slope=slope,
    surfaceAzimuthAngle=surfaceAzimuthAngle,
    redeclare model Skymodel = Skymodel,
    reflectance_ground=reflectance_ground,
    direct_normal=direct_normal,
    redeclare model CostRecordSolarThermal = CostRecordSolarThermal) annotation (Placement(transformation(extent={{62,-24},{80,-6}})));
  Modelica.Blocks.Sources.RealExpression T_in1(y=storage.port[3].T) annotation (Placement(transformation(
        extent={{-6.5,-4.5},{6.5,4.5}},
        rotation=0,
        origin={54.5,16.5})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow2 annotation (Placement(transformation(extent={{-30,28},{-44,42}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_boiler1(y=min(Q_flow_n_boiler, max(0, 0.5*4190*(T_boiler - storage.port[1].T)))) annotation (Placement(transformation(extent={{30,40},{14,52}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_heating1(y=-HeatingSolar - Q_flow_heating2.y) annotation (Placement(transformation(extent={{30,30},{14,42}})));
  Modelica.Blocks.Math.Add3 add annotation (Placement(transformation(extent={{-12,30},{-22,40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow annotation (Placement(transformation(extent={{-30,-2},{-44,12}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_solar1(y=controller.P_drive*4185*(solarCollector.T_out - storage.port[2].T)) annotation (Placement(transformation(extent={{30,8},{14,20}})));
  Modelica.Blocks.Math.Add3 add1 annotation (Placement(transformation(extent={{-12,0},{-22,10}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_heating2(y=max(-HeatingSolar, min(0, -m_flow_consumer*4185*(storage.port[2].T - T_return)))) annotation (Placement(transformation(extent={{30,-2},{14,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow1 annotation (Placement(transformation(extent={{-28,-30},{-42,-16}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_solar2(y=controller.P_drive*4185*(storage.port[2].T - storage.port[3].T)) annotation (Placement(transformation(extent={{30,-24},{14,-12}})));
  Modelica.Blocks.Math.Add add2 annotation (Placement(transformation(extent={{-12,-28},{-22,-18}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_DHW3(y=max(-demand.hotWaterPowerDemand, min(0, -m_flow_hotwater*4185*(storage.port[3].T - 12 - 273.15)))) annotation (Placement(transformation(extent={{30,-34},{14,-22}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_DHW2(y=max(-demand.hotWaterPowerDemand - Q_flow_DHW3.y, min(0, -m_flow_hotwater*4185*(storage.port[2].T - storage.port[3].T)))) annotation (Placement(transformation(extent={{30,-12},{14,0}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_DHW1(y=-(demand.hotWaterPowerDemand + Q_flow_DHW2.y + Q_flow_DHW3.y)) annotation (Placement(transformation(extent={{30,20},{14,32}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=T_room) annotation (Placement(transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={-70,22})));

  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower apparentPower(useInputConnectorQ=false) annotation (Placement(transformation(extent={{-92,-60},{-72,-40}})));

  TransiEnt.Producer.Heat.SolarThermal.Control.ControllerPumpSolarCollectorTandG controller(P_drive_min(k=controller.m_flow_min))
                                                                                            annotation (Placement(transformation(extent={{74,34},{100,54}})));
  TransiEnt.Producer.Heat.Gas2Heat.SimpleGasBoiler.SimpleBoiler boiler(
    useFluidPorts=false,
    useHeatPort=false,
    change_sign=true,
    HoC_fuel=HoC_fuel,
    gasMedium=FuelMedium,
    eta=eta,
    useGasPort=useGasPort,
    Q_flow_n=Q_flow_n_boiler,
    typeOfPrimaryEnergyCarrier=typeOfPrimaryEnergyCarrier,
    redeclare model BoilerCostModel = BoilerCostModel) annotation (Placement(transformation(extent={{22,-74},{42,-54}})));

equation

  // _____________________________________________
  //
  //            Characteristic equations
  // _____________________________________________

  Q_flow_solar1.y + Q_flow_solar2.y = der(E_solar);
  Q_flow_boiler = der(E_boiler);
  demand.heatingPowerDemand = der(E_heating);
  -Q_flow_DHW1.y - Q_flow_DHW2.y - Q_flow_DHW3.y = der(E_hotwater);

  solarCoverage = if SpaceHeating then E_solar/(E_heating + E_hotwater + 0.001) else E_solar/(E_hotwater + 0.001);

  m_flow_hotwater = demand.hotWaterPowerDemand/(4185*(storage.port[1].T - (12 + 273.15)));
  m_flow_fuel = if SpaceHeating then Q_flow_boiler1.y/boiler.CalorificValue*1/eta else (Q_flow_boiler1.y + demand.heatingPowerDemand)/boiler.CalorificValue*1/eta;

  if SpaceHeating == true then
    HeatingSolar = demand.heatingPowerDemand;
    m_flow_consumer = demand.heatingPowerDemand/(4185*(storage.port[1].T - T_return));
    Q_flow_boiler = Q_flow_boiler1.y;
  else
    HeatingSolar = 0;
    m_flow_consumer = 0;
    Q_flow_boiler = Q_flow_boiler1.y + demand.heatingPowerDemand;
  end if;

  // _____________________________________________
  //
  //            Connect statements
  // _____________________________________________

  connect(storage.heatPortAmbient, fixedTemperature.port) annotation (Line(points={{-71,6.35},{-70,6.35},{-70,18}}, color={191,0,0}));
  connect(prescribedHeatFlow2.Q_flow, add.y) annotation (Line(points={{-30,35},{-30,35},{-22.5,35}}, color={0,0,127}));
  connect(prescribedHeatFlow.Q_flow, add1.y) annotation (Line(points={{-30,5},{-22.5,5}}, color={0,0,127}));
  connect(prescribedHeatFlow1.Q_flow, add2.y) annotation (Line(points={{-28,-23},{-22.5,-23}}, color={0,0,127}));
  connect(Q_flow_boiler1.y, add.u1) annotation (Line(points={{13.2,46},{6,46},{6,39},{-11,39}}, color={0,0,127}));
  connect(Q_flow_heating1.y, add.u2) annotation (Line(points={{13.2,36},{6,36},{6,35},{-11,35}}, color={0,0,127}));
  connect(Q_flow_DHW1.y, add.u3) annotation (Line(points={{13.2,26},{6,26},{6,31},{-11,31}}, color={0,0,127}));
  connect(Q_flow_solar1.y, add1.u1) annotation (Line(points={{13.2,14},{6,14},{6,9},{-11,9}}, color={0,0,127}));
  connect(Q_flow_heating2.y, add1.u2) annotation (Line(points={{13.2,4},{-11,4},{-11,5}}, color={0,0,127}));
  connect(Q_flow_DHW2.y, add1.u3) annotation (Line(points={{13.2,-6},{5.6,-6},{5.6,1},{-11,1}}, color={0,0,127}));
  connect(Q_flow_solar2.y, add2.u1) annotation (Line(points={{13.2,-18},{2,-18},{2,-20},{-11,-20}}, color={0,0,127}));
  connect(Q_flow_DHW3.y, add2.u2) annotation (Line(points={{13.2,-28},{14,-28},{4,-28},{2,-28},{2,-26},{-11,-26}}, color={0,0,127}));
  connect(apparentPower.epp, epp) annotation (Line(
      points={{-92,-50},{-92,-74.05},{-80,-74.05},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(demand.electricPowerDemand, apparentPower.P_el_set) annotation (Line(points={{4.68,100.48},{4,100.48},{4,50},{-88,50},{-88,-38}}, color={0,127,127}));

  connect(prescribedHeatFlow1.port, storage.port[3]) annotation (Line(points={{-42,-23},{-56,-23},{-56,4.66333},{-60.88,4.66333}}, color={191,0,0}));
  connect(prescribedHeatFlow.port, storage.port[2]) annotation (Line(points={{-44,5},{-50,5},{-50,3.93},{-60.88,3.93}}, color={191,0,0}));
  connect(prescribedHeatFlow2.port, storage.port[1]) annotation (Line(points={{-44,35},{-54,35},{-54,3.19667},{-60.88,3.19667}}, color={191,0,0}));
  connect(T_in1.y, controller.T_in) annotation (Line(points={{61.65,16.5},{64,16.5},{64,46},{75.7333,46}}, color={0,0,127}));
  connect(T_in1.y, controller.T_stor) annotation (Line(points={{61.65,16.5},{64,16.5},{64,34},{75.7333,34}}, color={0,0,127}));
  connect(controller.G_total, solarCollector.G) annotation (Line(points={{75.7333,38.1667},{70,38.1667},{70,0},{78.2,0},{78.2,-6.9}}, color={0,0,127}));
  connect(solarCollector.T_out, controller.T_out) annotation (Line(points={{76.4,-6.9},{76.4,-8},{78,-8},{76,-8},{76,-2},{68,-2},{68,42.3333},{75.7333,42.3333}}, color={0,0,127}));
  connect(heatFlowRate_boiler.y, boiler.Q_flow_set) annotation (Line(points={{-37,-50},{32,-50},{32,-54}}, color={0,0,127}));
  connect(gasPortIn, boiler.gasIn) annotation (Line(
      points={{80,-96},{64,-96},{64,-84},{32.2,-84},{32.2,-74}},
      color={255,255,0},
      thickness=1.5));
  connect(T_in1.y, solarCollector.T_inflow) annotation (Line(points={{61.65,16.5},{64.79,16.5},{64.79,-5.91}}, color={0,0,127}));
  connect(controller.P_drive, solarCollector.m_flow) annotation (Line(
      points={{75.7333,49},{46,49},{46,-6.81},{62.63,-6.81}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  annotation (Icon(graphics={
        Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,100},{100,-100}}),
        Bitmap(extent={{-6,30},{84,-88}}, imageSource="iVBORw0KGgoAAAANSUhEUgAAATkAAAE5CAMAAADcP6fDAAAACXBIWXMAABcSAAAXEgFnn9JSAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAYZQTFRFAAAAAAD/Dw//Hx//Ly//Pz8/Pz//T0//X19fX1//b2//f39/j4//n5+fn5//v7+/v7//z8//39//7+//////////////////////////////////////////////////////////////////AAAAAAD/DAwMDgECDwsDDw8PDw//GRkZHQMEHxYHHx8fHx//JiYmLAUGLyELLy8vLy//MzMzOwcJPiwOPz8/Pz//SggLTExMTjcST09PT0//WAoNWVlZXkIWX19fX1//ZmZmZwwPbU0Zb29vb2//cnJydg4SfVgdf39/f3//hQ8UjIyMjWMhj4+Pj4//lBEWmZmZnG4kn5+fn5//ohMYpaWlrHkor6+vr6//sRUbsrKyvIQsv7+/v7//wBYdy48vzMzMzxgfz8/Pz8//25oz3hoh39/f39//66U37Rwk7+/v7+//+7A7/wAA/w8P/x8f/y8v/z8//09P/19f/29v/39//4+P/5+f/6+v/7+//8/P/9/f/+/v////kIefhAAAACR0Uk5TAAAAAAAAAAAAAAAAAAAAAAAAAAAADx8vP09fb3+Pn6+/z9/v4vdPWQAAFjRJREFUeNrtnftf20a2wJvu3b13d7t72638fiBbYxeb2KaAsZ0ACTYFUuwGSLALgdguKaQ2wdA23d32blv951fyQxppJFmPkayHzw/99COTwfpyzpzHnJn54APbSCAYikbjJElStFgSzNNoNBIM+j6YCyQMsbgELmlJkAxBv+eZ+UPRhSStR8hYJOhRaL5gVLWeyepfPBzwGLVQLEFjEmoh4hV6wSg2ahy9eNjtM58vHKdocyQRDbgY2wJtqiRjgTm2ObyxhCzBNoYXdc2c549RtLVCht3ALUzSMxAq5nDF80UpelZCOjjH8MfpmUrSoUYbJOmZCxX1zbl5hJ1duDmNnZ24OYldwGbcRuzm/tStfnaW8Zuj47tQkrazxO063flJ2uZCRWwJLko7QBL2K0IFk7QzJGYvk/XFaMdIMjhXOMernZMUzlZqF0jQzhM75BQR2pGSmHXN2EfSDhVqtulYkKKd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"),
        Polygon(
          points={{-92,4},{-18,-42},{24,50},{-34,84},{-92,4}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95},
          lineThickness=0.5),
        Line(
          points={{-96,14},{-22,-34},{-16,-20},{-76,14},{-68,28},{-8,-6},{0,8},{-60,40},{-52,52},{6,20},{12,34},{-44,64},{-36,76},{52,24}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{24,44},{28,38},{22,38}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-94,18},{-92,12},{-98,12}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(points={{18,44},{28,38}}, color={0,0,0}),
        Line(points={{-98,16},{-86,8}}, color={0,0,0})}), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Combination of solarthermal panel, thermal storage tank and boiler models to be used in the energyConverter.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>TransiEnt.Basics.Interfaces.Combined.HouseholdDemandIn <b>demand</b></p>
<p>TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort <b>epp - connection to electrical grid</b></p>
<p>TransiEnt.Basics.Interfaces.Gas.RealGasPortIn <b>gasPortIn - connection to gas grid</b></p><p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model contains models for a solarthermal panel, a stratified storage tank, a gas boiler and a controller for the operation of the solar thermal panel. Different control modes can be selected. </span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">No fluid flow into the storage tank is considered, therefore the energy input into each layer into the storage tank is defined by energy balances.</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2017</span></p>
</html>"));
end solarThermal_Boiler;
