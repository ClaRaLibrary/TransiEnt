within TransiEnt.Consumer.Heat.Check;
model TestThermalHeatConsumer_L3



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




  extends TransiEnt.Basics.Icons.Checkmodel;
  TransiEnt.Components.Heat.PumpVLE_L1_simple pumpVLE_L1_simple(
    presetVariableType="dp",
    Delta_p_fixed=10000,
    m_flow_fixed=0.2)    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-86,-26})));
  TransiEnt.Producer.Heat.Gas2Heat.SimpleGasBoiler.SimpleBoiler boiler(
    Q_flow_n=6e3,
    p_drop=0,
    useGasPort=false,
    redeclare TransiEnt.Components.Boundaries.Heat.Heatflow_L1 heatFlowBoundary(p_drop=0)) annotation (Placement(transformation(extent={{-10,28},{10,48}})));
  ClaRa.Basics.ControlVolumes.FluidVolumes.VolumeVLE_2 volumeVLE_2_1(
    m_flow_nom=0.04,
    h_nom=4200*60,
    initOption=0,
    h_start=4200*30,
    redeclare model HeatTransfer = ThermalHeatConsumer_L3.HeatTransfer_EN442 (
                                                       Q_flow_nom=6e3))
                               annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=180,
        origin={0,-78})));
  TransiEnt.Components.Sensors.TemperatureSensor tempBeforeConsumer(unitOption=1)
                                                                   annotation (Placement(transformation(extent={{70,38},{50,18}})));
  ThermalHeatConsumer_L3.ThermalHeatConsumer_L3 thermalHeatConsumer(
    T_start=295.15,
    redeclare ThermalHeatConsumer_L3.Base.ConstructionData.EnEV_Flo matLayFlo,
    redeclare ThermalHeatConsumer_L3.Base.ConstructionData.EnEV_Roof matLayRoof,
    redeclare ThermalHeatConsumer_L3.Base.ConstructionData.EnEV_Ext matLayExt,
    k_Win=3) annotation (Placement(transformation(extent={{18,-46},{40,-62}})));
  Modelica.Blocks.Sources.RealExpression setRoomTemperature(y=273.15 + 22) annotation (Placement(transformation(extent={{-24,-28},{-4,-8}})));
  TransiEnt.Components.Sensors.TemperatureSensor tempAfterConsumer1(unitOption=1) annotation (Placement(transformation(extent={{-72,-78},{-52,-58}})));
  inner TransiEnt.SimCenter simCenter(
    redeclare TILMedia.VLEFluidTypes.TILMedia_SplineWater fluid1,
    tableInterpolationSmoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative2,
    ambientConditions(
      redeclare TransiEnt.Basics.Tables.Ambient.Wind_Hamburg_Fuhlsbuettel_3600s_2012 wind,
      redeclare TransiEnt.Basics.Tables.Ambient.GHI_Hamburg_3600s_2012_TMY globalSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DNI_Hamburg_3600s_2012_TMY directSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.DHI_Hamburg_3600s_2012_TMY diffuseSolarRadiation,
      redeclare TransiEnt.Basics.Tables.Ambient.Temperature_Hamburg_900s_2012 temperature),
    integrateHeatFlow=true)                                                                         annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
TransiEnt.Components.Heat.Grid.IdealizedExpansionVessel idealizedExpansionVessel(p=100000)                                                     annotation (Placement(transformation(extent={{-58,-54},{-38,-34}})));
TransiEnt.Basics.Tables.HeatGrid.HeatingCurves.HeatingCurve_FromDataPath heatingCurve_60_40 annotation (Placement(transformation(extent={{-62,14},{-48,28}})));
  ClaRa.Components.VolumesValvesFittings.Valves.GenericValveVLE_L1 thermostat(redeclare model PressureLoss = ClaRa.Components.VolumesValvesFittings.Valves.Fundamentals.LinearNominalPoint (Delta_p_nom=1e4, m_flow_nom=0.04), openingInputIsActive=true) annotation (Placement(transformation(
        extent={{10,-6},{-10,6}},
        rotation=90,
        origin={78,-18})));
  TransiEnt.Basics.Blocks.LimPID PID_Boiler(
    u_ref=50 + 273.15,
    y_ref=6e3,
    Tau_d=0,
    y_max=6e3,
    y_min=0,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    k=100,
    Tau_i=1000,
    y_start=0,
    y_inactive=0) annotation (Placement(transformation(extent={{-36,18},{-24,30}})));
  TransiEnt.Basics.Blocks.LimPID PID_Valve(
    u_ref=22 + 273.15,
    y_ref=1,
    Tau_d=0,
    y_max=1,
    y_min=1e-5,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    k=500,
    Tau_i=1000,
    y_start=0.5,
    y_inactive=0) annotation (Placement(transformation(extent={{8,-24},{20,-12}})));
equation
  connect(pumpVLE_L1_simple.fluidPortOut, boiler.inlet) annotation (Line(
      points={{-86,-16},{-86,38},{-9.8,38}},
      color={175,0,0},
      thickness=0.5));
  connect(volumeVLE_2_1.outlet,pumpVLE_L1_simple. fluidPortIn) annotation (Line(
      points={{-10,-78},{-86,-78},{-86,-36}},
      color={162,29,33},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(thermalHeatConsumer.port_HeatDemand, volumeVLE_2_1.heat) annotation (Line(points={{18.4,-61.6},{18.4,-62},{0,-62},{0,-68},{-8.88178e-16,-68}}, color={191,0,0}));
  connect(volumeVLE_2_1.outlet,tempAfterConsumer1. port) annotation (Line(
      points={{-10,-78},{-62,-78}},
      color={162,29,33},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(tempBeforeConsumer.port, boiler.outlet) annotation (Line(
      points={{60,38},{10,38}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(idealizedExpansionVessel.waterPort,pumpVLE_L1_simple. fluidPortIn) annotation (Line(
      points={{-48,-54},{-86,-54},{-86,-36}},
      color={175,0,0},
      thickness=0.5));
  connect(boiler.outlet, thermostat.inlet) annotation (Line(
      points={{10,38},{78,38},{78,-8}},
      color={175,0,0},
      thickness=0.5));
  connect(thermostat.outlet, volumeVLE_2_1.inlet) annotation (Line(
      points={{78,-28},{78,-78},{10,-78}},
      color={162,29,33},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(PID_Boiler.u_m, tempBeforeConsumer.T) annotation (Line(points={{-29.94,16.8},{-29.94,14},{50,14},{50,28},{49,28}}, color={0,0,127}));
  connect(PID_Boiler.u_s, heatingCurve_60_40.T_Supply) annotation (Line(points={{-37.2,24},{-47.44,24},{-47.44,23.52}}, color={0,0,127}));
  connect(setRoomTemperature.y, PID_Valve.u_s) annotation (Line(points={{-3,-18},{6.8,-18}}, color={0,0,127}));
  connect(PID_Valve.u_m, thermalHeatConsumer.T_room) annotation (Line(points={{14.06,-25.2},{14.06,-40},{14,-40},{14,-56},{17.4,-56},{17.4,-55.2}}, color={0,0,127}));
  connect(PID_Valve.y, thermostat.opening_in) annotation (Line(points={{20.6,-18},{69,-18}}, color={0,0,127}));
  connect(PID_Boiler.y, boiler.Q_flow_set) annotation (Line(points={{-23.4,24},{-18,24},{-18,48},{0,48}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-60,116},{-14,66}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          fontSize=10,
          textString="Mass Flow controlled according to room temperature (thermostat)
Boiler Heat Ouput controlled according to outside temperature (heating curve)"), Text(
          extent={{-60,96},{-2,38}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Look at:
- thermalHeatConsumer.T_amb
- thermalHeatConsumer.T_room
- thermostat.inlet.m_flow
- boiler.Q_flow_set")}),
    experiment(
      StartTime=3456000,
      StopTime=5184000,
      Interval=900.00288,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p>Test environment for ThermalHeatConsumer_L3</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">This model uses instances of models from the<u><b> Buildings Library</b></u> developed by the Lawrence Berkeley National Laboratory. The library can be downloaded at https://simulationresearch.lbl.gov/modelica/download.html. </span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p>Model created by Anne Senkel (anne.senkel@tuhh.de) June 2020</p>
</html>"));
end TestThermalHeatConsumer_L3;
