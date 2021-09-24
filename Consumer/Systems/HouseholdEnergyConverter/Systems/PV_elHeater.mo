within TransiEnt.Consumer.Systems.HouseholdEnergyConverter.Systems;
model PV_elHeater "PV, gas boiler and electrical heater"


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

  extends Base.Systems(
    final DHN=false,
    final el_grid=true,
    final gas_grid=useGasPort);

  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________
  parameter Boolean useGasPort=true "True if gas port shall be used" annotation (Dialog(group="System setup"), choices(checkBox=true));
  parameter String waterHeating="gas" annotation (Dialog(group="System setup"), choices(choice="electrical" "Electrical water heating with flow heater", choice="gas" "Water is heated by the gas boiler"));

  parameter SI.Power P_el_n=3e3 "Nominal electric power of the electric heater" annotation (HideResult=true, Dialog(group="Heater"));
  parameter SI.Efficiency eta_Heater=0.95 "Efficiency of the electric heater" annotation (HideResult=true, Dialog(group="Heater"));

  parameter SI.Temperature T_s_max=323.15 "Maximum storage temperature" annotation (HideResult=true, Dialog(group="Storage"));
  parameter SI.Temperature T_s_min=303.15 "Minimum storage temperature" annotation (HideResult=true, Dialog(group="Storage"));
  parameter SI.Temperature T_start=60 + 273.15 "Start value of the storage temperature" annotation (HideResult=true, Dialog(group="Storage"));
  parameter SI.Volume V_Storage=0.2 "Volume of the Storage" annotation (HideResult=true, Dialog(group="Storage"));
  parameter SI.Height height=1.3 "Height of heat storage" annotation (HideResult=true, Dialog(group="Storage"));
  parameter SI.Diameter d=sqrt(V_Storage/heatStorage.height*4/Modelica.Constants.pi) "Diameter of heat storage" annotation (HideResult=true, Dialog(group="Storage"));
  parameter Modelica.Units.NonSI.Temperature_degC T_amb=15 "Assumed constant ambient temperature" annotation (HideResult=true, Dialog(group="Storage"));
  parameter SI.SurfaceCoefficientOfHeatTransfer k=0.08 "Coefficient of heat transfer through tank surface" annotation (HideResult=true, Dialog(group="Storage"));

  parameter SI.Power P_inst=5000 "combined installed power" annotation (HideResult=true, Dialog(group="PV Parameters"));
  parameter SI.Power Pmpp=200 "peak power of one module" annotation (HideResult=true, Dialog(group="PV Parameters"));
  parameter SI.Area Area=1.18 "area of one complete module" annotation (HideResult=true, Dialog(group="PV Parameters"));
  parameter Real Strings=1 "choose amount of strings" annotation (HideResult=true, Dialog(group="PV Parameters"));
  parameter Real GroundCoverageRatio=0.3 "ratio of covered ground of modules to area of modules" annotation (HideResult=true, Dialog(group="PV Parameters"));
  parameter Real LossesDC=4.44 "losses in % through connections, wiring, tracking error and mismatches" annotation (HideResult=true, Dialog(group="PV Parameters"));

  parameter SI.ActivePower P_n=5000 "Rated power of the inverter" annotation (Dialog(group="PV Parameters"));
  parameter SI.PowerFactor cosphi=1 "Operating power factor of the inverter" annotation (Dialog(group="PV Parameters"));
  parameter Real Threshold=0.7 "Percentage of peak power at which power is cut" annotation (Dialog(group="PV Parameters"));
  parameter Integer behavior=-1 annotation (
    Evaluate=true,
    HideResult=true,
    choices(
      __Dymola_radioButtons=true,
      choice=1 "inductive",
      choice=-1 "capacitive"),
    Dialog(group="PV Parameters"));
  parameter SI.Efficiency eta_Inverter=0.97 "Efficiency of the inverter" annotation (Dialog(group="PV Parameters"));

  parameter Real Soiling=5 "Average annual losses of radiation in % due to soiling" annotation (HideResult=true, Dialog(group="Radiation Parameters"));
  parameter Real Albedo=0.25 "Average annual losses of radiation in % due to soiling" annotation (HideResult=true, Dialog(group="Radiation Parameters"));

  parameter TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.Characteristics.Generic_Characteristics_PVModule PVModuleCharacteristics=TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.Characteristics.PVModule_Characteristics_Sanyo_HIT_200_BA3() "Characteristics of PV Module" annotation (
    HideResult=true,
    choicesAllMatching,
    Dialog(group="PV Parameters"));
  parameter SI.Angle longitude_local=Modelica.Units.Conversions.from_deg(10) "Longitude of the local position, east positive, 10 East for Hamburg" annotation (Dialog(group="Radiation Parameters"));
  parameter SI.Angle longitude_standard=Modelica.Units.Conversions.from_deg(15) "Needed for calculation of coordinated universal time (utc), 15 for central european time, 30 for central european summer time" annotation (Dialog(group="Radiation Parameters"));
  parameter Modelica.Units.NonSI.Time_day totaldays=365 "Total days of the year, standard=365, leap year=366" annotation (Dialog(group="Radiation Parameters"));
  parameter SI.Angle latitude=Modelica.Units.Conversions.from_deg(53.55) "Latitude of the local position, north posiive, 53,55 North for Hamburg" annotation (Dialog(group="Radiation Parameters"));

  parameter SI.Angle Tilt=Modelica.Units.Conversions.from_deg(0) "Inclination of surface" annotation (HideResult=true, Dialog(group="Radiation Parameters"));
  parameter SI.Angle Azimuth=Modelica.Units.Conversions.from_deg(0) "Gyration of surface; Orientation: +90=West, -90=East, 0=South" annotation (HideResult=true, Dialog(group="Radiation Parameters"));

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid FuelMedium=simCenter.gasModel1 "Medium to be used for fuel gas" annotation (HideResult=true, Dialog(group="Fluid Definition", enable=useGasPort));
  parameter SI.SpecificEnthalpy HoC_gas=40e6 "Heat of combustion of fuel, will be used if gasport is deactivated in model" annotation (Dialog(group="Fluid Definition", enable=not useGasPort));

  parameter SI.Efficiency eta_Boiler=1.05 "Boiler's overall efficiency" annotation (HideResult=true, Dialog(group="Boiler"));
  parameter SI.HeatFlowRate Q_flow_n_Boiler=20000 "Nominal heating power of the gas boiler" annotation (HideResult=true, Dialog(group="Boiler"));

  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________

  SI.Power P "consumed or produced electric power";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Storage.Heat.HotWaterStorage_constProp_L2.HotWaterStorage_constProp_L2 heatStorage(
    useFluidPorts=false,
    T_s_max=T_s_max,
    T_s_min=T_s_min,
    d=d,
    height=height,
    T_amb=T_amb,
    k=k,
    T_start=T_start) annotation (Placement(transformation(extent={{72,0},{92,20}})));

  Modelica.Blocks.Sources.RealExpression ambientTemperature(y=simCenter.ambientConditions.temperature.value) annotation (Placement(transformation(
        extent={{10,-6},{-10,6}},
        rotation=0,
        origin={-36,92})));
  Modelica.Blocks.Sources.RealExpression directSolarRadiation(y=simCenter.ambientConditions.directSolarRadiation.value) annotation (Placement(transformation(
        extent={{10,-6},{-10,6}},
        rotation=0,
        origin={-36,80})));
  Modelica.Blocks.Sources.RealExpression diffuseSolarRadiation(y=simCenter.ambientConditions.diffuseSolarRadiation.value) annotation (Placement(transformation(
        extent={{10,-6},{-10,6}},
        rotation=0,
        origin={-36,68})));
  Modelica.Blocks.Sources.RealExpression wind(y=simCenter.ambientConditions.wind.value) annotation (Placement(transformation(
        extent={{10,-7},{-10,7}},
        rotation=0,
        origin={-36,57})));
  TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.DNIDHI_Input.PVModule pVModule(
    P_inst=P_inst,
    Pmpp=Pmpp,
    Area=Area,
    Strings=Strings,
    GroundCoverageRatio=GroundCoverageRatio,
    LossesDC=LossesDC,
    Soiling=Soiling,
    longitude_local=longitude_local,
    longitude_standard=longitude_standard,
    totaldays=totaldays,
    latitude=latitude,
    slope=Tilt,
    surfaceAzimuthAngle=Azimuth,
    reflectance_ground=Albedo) annotation (Placement(transformation(extent={{-68,64},{-88,84}})));
  TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.SinglePhasePVInverter inverter(
    cosphi=cosphi,
    behavior=behavior,
    P_n=P_n,
    P_PV=P_inst,
    Threshold=Threshold,
    eta=eta_Inverter) annotation (Placement(transformation(
        extent={{10,-8},{-10,8}},
        rotation=90,
        origin={-90,32})));
  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower apparentPower1(useInputConnectorQ=false, useInputConnectorP=true) annotation (Placement(transformation(extent={{-70,-40},{-54,-24}})));

  Modelica.Blocks.Math.Add add if waterHeating=="gas" annotation (Placement(transformation(extent={{18,34},{34,50}})));
  Modelica.Blocks.Math.Add add1 if waterHeating=="electrical" annotation (Placement(transformation(extent={{-14,34},{-30,50}})));
  TransiEnt.Producer.Heat.Power2Heat.ElectricBoiler.ElectricBoiler electricHeater(
    change_sign=true,
    usePelset=true,
    Q_flow_n=P_el_n/eta_Heater,
    eta=eta_Heater,
    useFluidPorts=false,
    usePowerPort=true,
    redeclare TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp,
    redeclare TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower powerBoundary(useInputConnectorQ=false, cosphi_boundary=0.99) "PowerBoundary for ApparentPowerPort") annotation (Placement(transformation(extent={{4,-32},{24,-12}})));

  Modelica.Blocks.Math.Add add2 annotation (Placement(transformation(extent={{42,-24},{58,-8}})));
  replaceable Control_elHeater.ElectricHeater_PV_oriented controller(Threshold=P_el_n, P_elHeater=P_el_n) constrainedby TransiEnt.Consumer.Systems.HouseholdEnergyConverter.Systems.Control_elHeater.Base.Controller_elHeater annotation (
    Dialog(group="System setup"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-34,-14},{-14,6}})));
  Modelica.Blocks.Sources.RealExpression excessPV(y=pVModule.P_dc - apparentPower1.epp.P) annotation (Placement(transformation(
        extent={{8,-6},{-8,6}},
        rotation=0,
        origin={-18,16})));

  TransiEnt.Producer.Heat.Gas2Heat.SimpleGasBoiler.SimpleBoiler gasBoiler1(
    useFluidPorts=false,
    useHeatPort=false,
    eta=eta_Boiler,
    Q_flow_n=Q_flow_n_Boiler,
    useGasPort=useGasPort,
    change_sign=true,
    gasMedium=FuelMedium) annotation (Placement(transformation(extent={{48,-58},{68,-38}})));

equation

  // _____________________________________________
  //
  //            Characteristic equations
  // _____________________________________________

  P = epp.P;

  // _____________________________________________
  //
  //            Connect statements
  // _____________________________________________

  if waterHeating == "gas" then
    connect(add.y, heatStorage.Q_flow_demand) annotation (Line(points={{34.8,42},{44,42},{44,28},{98,28},{98,10},{92,10}}, color={0,0,127}));
    connect(demand.electricPowerDemand, apparentPower1.P_el_set) annotation (Line(points={{4.68,100.48},{4.68,30},{-66.8,30},{-66.8,-22.4}}, color={0,127,127}));
  else
    connect(demand.heatingPowerDemand, heatStorage.Q_flow_demand) annotation (Line(points={{0,100.48},{0,36},{8,36},{8,28},{98,28},{98,10},{92,10}}, color={0,127,127}));
    connect(add1.y, apparentPower1.P_el_set) annotation (Line(points={{-30.8,42},{-68,42},{-68,-22.4},{-66.8,-22.4}}, color={0,0,127}));
  end if;

  connect(ambientTemperature.y, pVModule.T_in) annotation (Line(points={{-47,92},{-50.55,92},{-50.55,82},{-66,82}}, color={0,0,127}));
  connect(directSolarRadiation.y, pVModule.DNI_in) annotation (Line(points={{-47,80},{-50.55,80},{-50.55,76.4},{-66,76.4}}, color={0,0,127}));
  connect(diffuseSolarRadiation.y, pVModule.DHI_in) annotation (Line(points={{-47,68},{-50.55,68},{-50.55,71.4},{-66,71.4}}, color={0,0,127}));
  connect(wind.y, pVModule.WindSpeed_in) annotation (Line(points={{-47,57},{-51.55,57},{-51.55,66},{-66,66}}, color={0,0,127}));
  connect(pVModule.epp, inverter.epp_DC) annotation (Line(
      points={{-87.3,73.4},{-87.3,74},{-90,74},{-90,41.8}},
      color={0,135,135},
      thickness=0.5));
  connect(inverter.epp_AC, epp) annotation (Line(
      points={{-90,22},{-90,22},{-90,-32},{-80,-32},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(apparentPower1.epp, epp) annotation (Line(
      points={{-70,-32},{-70,-32},{-70,-32},{-72,-32},{-80,-32},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(demand.heatingPowerDemand, add.u2) annotation (Line(points={{0,100.48},{0,100.48},{0,37.2},{16.4,37.2}}, color={0,127,127}));
  connect(demand.hotWaterPowerDemand, add.u1) annotation (Line(points={{-4.8,100.48},{-4.8,100.48},{-4.8,46.8},{16.4,46.8}}, color={0,127,127}));

  connect(demand.electricPowerDemand, add1.u1) annotation (Line(points={{4.68,100.48},{4.68,100.48},{4.68,46.8},{-12.4,46.8}}, color={0,127,127}));
  connect(demand.hotWaterPowerDemand, add1.u2) annotation (Line(points={{-4.8,100.48},{-4.8,100.48},{-4.8,37.2},{-12.4,37.2}}, color={0,127,127}));

  connect(electricHeater.epp, epp) annotation (Line(
      points={{14,-32.2},{14,-48},{12,-48},{12,-62},{-62,-62},{-62,-98},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(add2.y, heatStorage.Q_flow_store) annotation (Line(points={{58.8,-16},{72.6,-16},{72.6,10}}, color={0,0,127}));
  connect(heatStorage.SoC, controller.SoC) annotation (Line(points={{83.8,19.6},{82,19.6},{82,24},{-40,24},{-40,-4},{-34.4,-4}}, color={0,0,127}));
  connect(controller.Q_flow_set_boiler, add2.u1) annotation (Line(
      points={{-13.9,0.3},{10,0.3},{10,0},{34,0},{34,-11.2},{40.4,-11.2}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(excessPV.y, controller.PV_excess) annotation (Line(points={{-26.8,16},{-29,16},{-29,6.2}}, color={0,0,127}));
  connect(controller.Q_flow_set_boiler, gasBoiler1.Q_flow_set) annotation (Line(
      points={{-13.9,0.3},{10,0.3},{10,0},{28,0},{28,-34},{58,-34},{58,-38}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  connect(gasPortIn, gasBoiler1.gasIn) annotation (Line(
      points={{80,-96},{58,-96},{58,-78},{58.2,-78},{58.2,-58}},
      color={255,255,0},
      thickness=1.5));
  connect(electricHeater.Q_flow_gen, add2.u2) annotation (Line(
      points={{24.6,-13.8},{40.4,-13.8},{40.4,-20.8}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  connect(controller.P_set_electricHeater, electricHeater.P_el_set) annotation (Line(
      points={{-13.9,-8.3},{-4,-8.3},{-4,-24.4},{4.4,-24.4}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  annotation (Icon(graphics={
        Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,102},{100,-98}}),
        Ellipse(
          extent={{-52,56},{-86,24}},
          lineColor={255,128,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Sphere),
        Line(
          points={{-52,28},{-2,28}},
          color={255,255,255},
          smooth=Smooth.None),
        Polygon(
          points={{-38,48},{8,48},{-28,-22},{-74,-22},{-38,48}},
          smooth=Smooth.None,
          fillColor={0,96,141},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{-22,48},{-58,-22}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{-12,48},{-48,-22}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{0,52},{-40,-24}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{-50,38},{10,38}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-52,28},{-2,28}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-62,8},{-10,8}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-68,-2},{-12,-2}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-76,-12},{-20,-12}},
          color={255,255,255},
          smooth=Smooth.None),
        Line(
          points={{-26,58},{-66,-22}},
          smooth=Smooth.None,
          color={255,255,255}),
        Line(
          points={{-56,18},{-6,18}},
          color={255,255,255},
          smooth=Smooth.None),
        Ellipse(
          extent={{20,-40},{68,-60}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Rectangle(
          extent={{20,4},{68,-52}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder),
        Line(
          points={{34,-18},{62,-20},{32,-30},{56,-34},{44,-38},{44,-58}},
          thickness=0.5,
          smooth=Smooth.None,
          color={0,134,134}),
        Ellipse(
          extent={{20,16},{68,-6}},
          lineColor={0,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.VerticalCylinder)}), Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Combination of gas boiler, PV, electric heater and thermal storage models to be used in the energyConverter.</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(Purely technical component without physical modeling.)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p>TransiEnt.Basics.Interfaces.Combined.HouseholdDemandIn <b>demand</b></p>
<p>TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort <b>epp - connection to electrical grid</b></p><p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">The model contains models for an electric heater, a thermal storage tank, a PV module, an inverter, a gas boiler and a controller for the operation of the electrical heater. The heater will be switched on in case of PV power exceeding the electrical demand of the household and if the storage tank is not full.</span></p>
<p><br><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2017</span></p>
</html>"));
end PV_elHeater;
