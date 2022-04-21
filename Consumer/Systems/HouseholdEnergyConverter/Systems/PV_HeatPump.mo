within TransiEnt.Consumer.Systems.HouseholdEnergyConverter.Systems;
model PV_HeatPump "PV + Heatpump with thermal storage"



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

  extends Base.Systems(
    final DHN=false,
    final el_grid=true,
    final gas_grid=false);

  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

  parameter Boolean hotwater=true "Does the heat pump provide energy for the hot water? (if false: water is heated electrically)" annotation (
    HideResult=true,
    Dialog(group="System setup"),
    choices(checkBox=true));
  parameter Boolean heating=true "Does the heat pump provide energy for the space heating? (if false: space heating not accounted for)" annotation (
    HideResult=true,
    Dialog(group="System setup"),
    choices(checkBox=true));

  parameter SI.TemperatureDifference Delta_T_internal=5 "Temperature difference between refrigerant and source/sink temperature" annotation (HideResult=true, Dialog(group="Heatpump"));
  parameter SI.TemperatureDifference Delta_T_db=2 "Deadband of hysteresis control" annotation (HideResult=true, Dialog(group="Heatpump"));
  parameter SI.HeatFlowRate Q_flow_n=3.5e3 "Nominal heat flow of heat pump at nominal conditions according to EN14511" annotation (HideResult=true, Dialog(group="Heatpump"));
  parameter Real COP_n=3.7 "Coefficient of performance at nominal conditions according to EN14511" annotation (HideResult=true, Dialog(group="Heatpump"));
  parameter SI.Power P_el_n=10e3 "Nominal electric power of the backup heater" annotation (HideResult=true, Dialog(group="Heatpump"));
  parameter SI.Efficiency eta_Heater=0.95 "Efficiency of the backup heater" annotation (HideResult=true, Dialog(group="Heatpump"));
  parameter SI.Temperature T_set=65 + 273.25 "Heatpump supply temperature" annotation (Dialog(group="Heatpump"));

  parameter SI.Temperature T_s_max=343.15 "Maximum storage temperature" annotation (HideResult=true, Dialog(group="Storage"));
  parameter SI.Temperature T_s_min=323.15 "Minimum storage temperature" annotation (HideResult=true, Dialog(group="Storage"));
  parameter SI.Temperature T_start=60 + 273.15 "Start value of the storage temperature" annotation (HideResult=true, Dialog(group="Storage"));
  parameter SI.Volume V_Storage=0.5 "Volume of the Storage" annotation (Dialog(group="Storage"));
  parameter SI.Height height=1.3 "Height of heat storage" annotation (Dialog(group="Storage"));
  parameter SI.Diameter d=sqrt(V_Storage/height*4/Modelica.Constants.pi) "Diameter of heat storage" annotation (HideResult=true, Dialog(group="Storage"));
  parameter Modelica.Units.NonSI.Temperature_degC T_amb=15 "Assumed constant ambient temperature" annotation (HideResult=true, Dialog(group="Storage"));
  parameter SI.SurfaceCoefficientOfHeatTransfer k=0.08 "Coefficient of heat transfer through tank surface" annotation (HideResult=true, Dialog(group="Storage"));

  parameter SI.Power P_inst=5000 "Combined installed power" annotation (HideResult=true, Dialog(group="PV Parameters"));
  parameter SI.Power Pmpp=200 "Peak power of one module" annotation (HideResult=true, Dialog(group="PV Parameters"));
  parameter SI.Area Area=1.18 "Area of one complete module" annotation (HideResult=true, Dialog(group="PV Parameters"));
  parameter Real Strings=1 "Choose amount of strings" annotation (HideResult=true, Dialog(group="PV Parameters"));

  parameter Real GroundCoverageRatio=0.3 "ratio of covered ground of modules to area of modules" annotation (HideResult=true, Dialog(group="PV Parameters"));
  parameter Real LossesDC=4.44 "losses in % through connections, wiring, tracking error and mismatches" annotation (HideResult=true, Dialog(group="PV Parameters"));

  parameter Real Soiling=5 "Average annual losses of radiation in % due to soiling" annotation (HideResult=true, Dialog(group="Radiation Parameters"));
  parameter Real Albedo=0.25 "Average annual losses of radiation in % due to soiling" annotation (HideResult=true, Dialog(group="Radiation Parameters"));

  parameter SI.Angle longitude_local=Modelica.Units.Conversions.from_deg(10) "Longitude of the local position, east positive, 10 East for Hamburg" annotation (Dialog(group="Radiation Parameters"));
  parameter SI.Angle longitude_standard=Modelica.Units.Conversions.from_deg(15) "Needed for calculation of coordinated universal time (utc), 15 for central european time, 30 for central european summer time" annotation (Dialog(group="Radiation Parameters"));
  parameter Modelica.Units.NonSI.Time_day totaldays=365 "Total days of the year, standard=365, leap year=366" annotation (Dialog(group="Radiation Parameters"));
  parameter SI.Angle latitude=Modelica.Units.Conversions.from_deg(53.55) "Latitude of the local position, north posiive, 53,55 North for Hamburg" annotation (Dialog(group="Radiation Parameters"));

  parameter TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.Characteristics.Generic_Characteristics_PVModule PVModuleCharacteristics=TransiEnt.Producer.Electrical.Photovoltaics.Advanced_PV.Characteristics.PVModule_Characteristics_Sanyo_HIT_200_BA3() "Characteristics of PV Module" annotation (
    HideResult=true,
    choicesAllMatching,
    Dialog(group="PV Parameters"));

  parameter SI.Angle Tilt=Modelica.Units.Conversions.from_deg(0) "Inclination of surface" annotation (HideResult=true, Dialog(group="Radiation Parameters"));
  parameter SI.Angle Azimuth=Modelica.Units.Conversions.from_deg(0) "Gyration of surface; Orientation: +90=West, -90=East, 0=South" annotation (HideResult=true, Dialog(group="Radiation Parameters"));

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

  // _____________________________________________
  //
  //                   Variables
  // _____________________________________________

  SI.Power P "Consumed or produced electric power";
  SI.Temperature T_source=simCenter.ambientConditions.temperature.value + 273.15 "Temperature of heat source" annotation (Dialog(group="Heatpump"));

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Producer.Heat.Power2Heat.Heatpump.Heatpump heatPump(
    Delta_T_internal=Delta_T_internal,
    Delta_T_db=Delta_T_db,
    Q_flow_n=Q_flow_n,
    COP_n=COP_n,
    T_source=T_source,
    useFluidPorts=false,
    useHeatPort=false,
    T_set=T_s_max,
    redeclare connector PowerPortModel = TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort,
    redeclare model PowerBoundaryModel = TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower,
    Power(useInputConnectorQ=false, useCosPhi=false)) annotation (Placement(transformation(extent={{26,-24},{48,-2}})));

  TransiEnt.Storage.Heat.HotWaterStorage_constProp_L2.HotWaterStorage_constProp_L2 heatStorage1(
    useFluidPorts=false,
    T_s_max=T_s_max,
    T_s_min=T_s_min,
    d=d,
    height=height,
    T_amb=T_amb,
    k=k,
    T_start=T_start) annotation (Placement(transformation(extent={{66,36},{86,56}})));

  replaceable TransiEnt.Producer.Heat.Power2Heat.Heatpump.Controller.ControlHeatpump_PVoriented controller constrainedby TransiEnt.Producer.Heat.Power2Heat.Heatpump.Controller.Base.Controller_PV(P_elHeater=P_el_n, CalculatePHeater=true, Q_flow_n=heatPump.Q_flow_n, Delta_T_db=Delta_T_db) annotation (
    Dialog(group="System setup"),
    choicesAllMatching=true,
    Placement(transformation(extent={{-30,-24},{-10,-4}})));

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
    eta=eta_Inverter,
    cosphi=cosphi,
    behavior=behavior,
    P_n=P_n,
    P_PV=P_inst,
    Threshold=Threshold) annotation (Placement(transformation(
        extent={{9,-7},{-9,7}},
        rotation=90,
        origin={-91,31})));

  TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower apparentPower1(useInputConnectorQ=false, useInputConnectorP=true) annotation (Placement(transformation(extent={{-70,-40},{-54,-24}})));

  Modelica.Blocks.Sources.RealExpression excessPV(y=pVModule.P_dc - apparentPower1.epp.P) annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=90,
        origin={-31,15})));
  Modelica.Blocks.Math.Add add if heating and hotwater annotation (Placement(transformation(extent={{18,36},{32,50}})));
  Modelica.Blocks.Math.Add add1 if not hotwater annotation (Placement(transformation(extent={{-14,36},{-28,50}})));
  TransiEnt.Producer.Heat.Power2Heat.ElectricBoiler.ElectricBoiler electricHeater(
    usePelset=true,
    Q_flow_n=P_el_n*eta_Heater,
    eta=eta_Heater,
    useFluidPorts=false,
    usePowerPort=true,
    redeclare TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp,
    redeclare TransiEnt.Components.Boundaries.Electrical.ApparentPower.ApparentPower powerBoundary(
      useInputConnectorQ=false,
      useCosPhi=false,
      cosphi_boundary=0.99) "PowerBoundary for ApparentPowerPort") annotation (Placement(transformation(extent={{34,-76},{54,-56}})));
  Modelica.Blocks.Math.Add add3 annotation (Placement(transformation(extent={{64,-46},{78,-32}})));

  Modelica.Blocks.Sources.RealExpression Tset(y=T_set) annotation (Placement(transformation(extent={{-86,-20},{-70,-2}})));

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

  if heating and hotwater then
    connect(add.y, heatStorage1.Q_flow_demand) annotation (Line(points={{32.7,43},{52,43},{52,28},{92,28},{92,46},{86,46}}, color={0,0,127}));
  elseif heating then
    connect(demand.heatingPowerDemand, heatStorage1.Q_flow_demand) annotation (Line(points={{0,100.48},{0,14},{98,14},{98,46},{86,46}}, color={0,127,127}));
  else
    connect(demand.hotWaterPowerDemand, heatStorage1.Q_flow_demand) annotation (Line(points={{-4.8,100.48},{-4.8,14},{98,14},{98,46},{86,46}}, color={0,127,127}));
  end if;

  if not hotwater then
    connect(add1.y, apparentPower1.P_el_set) annotation (Line(points={{-28.7,43},{-66,43},{-66,-22.4},{-66.8,-22.4}}, color={0,0,127}));
  else
    connect(demand.electricPowerDemand, apparentPower1.P_el_set) annotation (Line(points={{4.68,100.48},{4.68,32},{-66.8,32},{-66.8,-22.4}}, color={0,127,127}));
  end if;

  connect(heatStorage1.SoC, controller.SoC) annotation (Line(points={{77.8,55.6},{77.8,70},{58,70},{58,24},{-62,24},{-62,-20.8},{-29.4,-20.8}}, color={0,0,127}));
  connect(ambientTemperature.y, pVModule.T_in) annotation (Line(points={{-47,92},{-50.55,92},{-50.55,82},{-66,82}}, color={0,0,127}));
  connect(directSolarRadiation.y, pVModule.DNI_in) annotation (Line(points={{-47,80},{-50.55,80},{-50.55,76.4},{-66,76.4}}, color={0,0,127}));
  connect(diffuseSolarRadiation.y, pVModule.DHI_in) annotation (Line(points={{-47,68},{-50.55,68},{-50.55,71.4},{-66,71.4}}, color={0,0,127}));
  connect(wind.y, pVModule.WindSpeed_in) annotation (Line(points={{-47,57},{-51.55,57},{-51.55,66},{-66,66}}, color={0,0,127}));
  connect(pVModule.epp, inverter.epp_DC) annotation (Line(
      points={{-87.3,73.4},{-87.3,72},{-90,72},{-90,39.82},{-91,39.82}},
      color={0,135,135},
      thickness=0.5));
  connect(inverter.epp_AC, epp) annotation (Line(
      points={{-91,22},{-90,22},{-90,-28},{-90,-62},{-80,-62},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(apparentPower1.epp, epp) annotation (Line(
      points={{-70,-32},{-70,-32},{-70,-32},{-72,-32},{-80,-32},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(demand.heatingPowerDemand, add.u2) annotation (Line(points={{0,100.48},{10,100.48},{10,38.8},{16.6,38.8}}, color={0,127,127}));
  connect(demand.hotWaterPowerDemand, add.u1) annotation (Line(points={{-4.8,100.48},{10,100.48},{10,47.2},{16.6,47.2}}, color={0,127,127}));

  connect(demand.electricPowerDemand, add1.u1) annotation (Line(points={{4.68,100.48},{4.68,100.48},{4.68,47.2},{-12.6,47.2}}, color={0,127,127}));
  connect(demand.hotWaterPowerDemand, add1.u2) annotation (Line(points={{-4.8,100.48},{-4.8,100.48},{-4.8,38.8},{-12.6,38.8}}, color={0,127,127}));

  connect(electricHeater.epp, epp) annotation (Line(
      points={{44,-76.2},{44,-76},{-62,-76},{-62,-98},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(heatPump.Heat_output, add3.u1) annotation (Line(
      points={{49.76,-6.62},{54,-6.62},{54,-34.8},{62.6,-34.8}},
      color={162,29,33},
      pattern=LinePattern.Dash));
  connect(add3.y, heatStorage1.Q_flow_store) annotation (Line(points={{78.7,-39},{88,-39},{88,-16},{64,-16},{64,46},{66.6,46}}, color={0,0,127}));
  connect(excessPV.y, controller.PV_excess) annotation (Line(points={{-31,7.3},{-31,-3.6},{-29,-3.6}},         color={0,0,127}));
  connect(heatStorage1.T_stor_out, controller.T) annotation (Line(points={{74.2,55.6},{74.2,56},{74,56},{74,68},{110,68},{110,26},{-44,26},{-44,-10},{-29.4,-10}}, color={0,0,127}));
  connect(electricHeater.Q_flow_gen, add3.u2) annotation (Line(
      points={{54.6,-57.8},{54.6,-43.2},{62.6,-43.2}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  connect(controller.P_set_electricHeater, electricHeater.P_el_set) annotation (Line(
      points={{-9.5,-21.7},{-9.5,-24},{8,-24},{8,-68},{34.4,-68},{34.4,-68.4}},
      color={0,135,135},
      pattern=LinePattern.Dash));
  connect(heatPump.epp, epp) annotation (Line(
      points={{45.36,-24},{44,-24},{44,-52},{-50,-52},{-50,-76},{-62,-76},{-62,-98},{-80,-98}},
      color={0,127,0},
      thickness=0.5));
  connect(Tset.y, controller.T_set) annotation (Line(points={{-69.2,-11},{-46,-11},{-46,-15.4},{-29.2,-15.4}}, color={0,0,127}));
  connect(controller.Q_flow_set_HP, heatPump.Q_flow_set) annotation (Line(
      points={{-9.5,-14.1},{16,-14.1},{16,-18.94},{25.34,-18.94}},
      color={175,0,0},
      pattern=LinePattern.Dash));
  annotation (
    HideResult=true,
    Dialog(tab="Tracking and Mounting"),
    choices(choice="Yes", choice="No"),
    Icon(graphics={
        Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,102},{100,-98}}),
        Rectangle(
          extent={{12,10},{78,-54}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{28,18},{68,2}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{28,-46},{68,-62}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{68,-14},{88,-34}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{6,-12},{18,-12},{12,-22},{18,-32},{6,-32},{12,-22},{6,-12}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{72,-32},{78,-14},{84,-32}},
          color={0,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{-52,56},{-86,24}},
          lineColor={255,128,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Sphere),
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
          points={{-108,-22},{-26,-22}},
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
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Combination of PV, heatpump, electric heater and thermal storage models to be used in the energyConverter.</p>
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
<p><span style=\"font-family: MS Shell Dlg 2;\">The model contains models for a heat pump, an electric heater, a thermal storage tank, a PV module, an inverter and a controller for the operation of the heat pump and the electrical heater. Different control modes can be selected. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model created by Anne Hagemeier, Fraunhofer UMSICHT in 2017</span></p>
</html>"));
end PV_HeatPump;
