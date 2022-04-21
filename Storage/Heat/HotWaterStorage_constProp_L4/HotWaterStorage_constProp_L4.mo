within TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4;
model HotWaterStorage_constProp_L4 "Temperature and heat flow rate based model of a stratified thermal storage with finite volume discretisation (1=top, n=bottom) and constant fluid properties, electric heating rods can be added"


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

  extends TransiEnt.Basics.Icons.ThermalStorageBasic;

  import      Modelica.Units.SI;
  // _____________________________________________
  //
  //                Outer models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;
  outer TransiEnt.ModelStatistics modelStatistics;

  // _____________________________________________
  //
  //                   Parameters
  // _____________________________________________

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid medium=simCenter.fluid1 "Medium to be used"
                         annotation(choicesAllMatching, Dialog(group="Fluid Definition", enable=useFluidPorts));

  parameter Integer N_cv=5 "Number of finite control volumes";

  // geometry

  parameter Boolean useFluidPorts=true annotation (Dialog(group="Geometry"),choices(checkBox=true));

  parameter SI.Volume V = 1e3 "Volume of tank" annotation(Dialog(group="Geometry"));
  parameter Real p_Volume[N_cv]=fill(1/N_cv, N_cv) "Proportion of the total volume for the parts of the tank" annotation (Dialog(group="Geometry"));
  parameter SI.Height h = 1 "Height of tank" annotation(Dialog(group="Geometry"));
  parameter Integer n_prodIn=1 "Number of inlet ports on producer side" annotation(Dialog(group="Geometry", enable=useFluidPorts));
  parameter Integer n_prodOut=n_prodIn "Number of outlet ports on producer side" annotation(Dialog(group="Geometry", enable=useFluidPorts));
  parameter Integer n_gridIn=1 "Number of inlet ports on grid side" annotation(Dialog(group="Geometry", enable=useFluidPorts));
  parameter Integer n_gridOut=n_gridIn "Number of outlet ports on grid side" annotation(Dialog(group="Geometry", enable=useFluidPorts));
  parameter SI.Height h_prodIn[n_prodIn]=fill(h,n_prodIn) "Height of inlet of primary heat source" annotation(Dialog(group="Heating Units", enable=useFluidPorts));
  parameter SI.Height h_prodOut[n_prodOut]=fill(0,n_prodOut) "Height of outlet of primary heat source" annotation(Dialog(group="Heating Units", enable=useFluidPorts));
  parameter SI.Height h_gridIn[n_gridIn]=fill(0,n_gridIn) "Height of inlet of grid side" annotation(Dialog(group="Heating Units", enable=useFluidPorts));
  parameter SI.Height h_gridOut[n_gridOut]=fill(h,n_gridOut) "Height of outlet of grid side" annotation(Dialog(group="Heating Units", enable=useFluidPorts));

  parameter SI.CoefficientOfHeatTransfer U_wall = 0.5 "Coefficient of heat transfer from wall to ambient " annotation(Dialog(group="Thermodynamics"));
  parameter SI.CoefficientOfHeatTransfer U_top = U_wall "Coefficient of heat transfer from top to ambient " annotation(Dialog(group="Thermodynamics"));
  parameter SI.CoefficientOfHeatTransfer U_bottom = U_wall "Coefficient of heat transfer from bottom to ambient " annotation(Dialog(group="Thermodynamics"));
  parameter SI.ThermalConductivity k = 0.6 "Thermal conductivity of fluid in storage" annotation(Dialog(group="Thermodynamics"));
  parameter SI.Density rho = 1e3 "Density of fluid in storage" annotation(Dialog(group="Thermodynamics"));
  parameter SI.SpecificHeatCapacity c_v = 4.185e3 "Heat capacity of fluid in storage" annotation(Dialog(group="Thermodynamics"));
  parameter SI.Temperature[N_cv] T_start=fill(273.15+60, N_cv) "Start temperatures of control volumes";
  parameter SI.Temperature T_max_ref = 90+273.15 "Maximum reference temperature (SOC=1)";
  parameter SI.Temperature T_min_ref = 60+273.15 "Minimum reference temperature (SOC=0)";
  parameter SI.Time tau_buoyancy = 1 "Time constant of buoyancy model";

  parameter Integer n_elHeater=0 "true if power port should be shown" annotation(Dialog(tab="Electric Heater"));
  parameter Boolean usePowerPort=false "true if power port should be shown"  annotation(Dialog(tab="Electric Heater",enable=useElHeater));
  parameter SI.Height h_elHeater[n_elHeater]=fill(h/2,n_elHeater) "Height of electric heater(s)" annotation(Dialog(tab="Electric Heater",enable=useElHeater));
  parameter SI.HeatFlowRate Q_flow_n_elHeater[n_elHeater]=fill(100e3,n_elHeater) "Nominal thermal power" annotation(Dialog(tab="Electric Heater",enable=useElHeater));
  parameter SI.Efficiency eta_elHeater=0.95 annotation(Dialog(tab="Electric Heater",enable=useElHeater));
  replaceable model ProducerCosts_elHeater = TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.Empty constrainedby TransiEnt.Components.Statistics.ConfigurationData.PowerProducerCostSpecs.PartialPowerPlantCostSpecs annotation(Dialog(tab="Electric Heater",enable=useElHeater), __Dymola_choicesAllMatching=true);

  replaceable model CostStatisticsModel = TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.SmallHotWaterStorage constrainedby TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.PartialStorageCostSpecs
   "Model for global cost calculation" annotation (choicesAllMatching=true, Dialog(group="Statistics"));
  replaceable connector ElectricPowerPort = TransiEnt.Basics.Interfaces.Electrical.ActivePowerPort constrainedby TransiEnt.Basics.Interfaces.Electrical.PartialPowerPort "Model for electric power port" annotation (Dialog(group="Replaceable Components",enable=usePowerPort),choicesAllMatching=true);
  replaceable model PowerBoundary = TransiEnt.Components.Boundaries.Electrical.ActivePower.Power
                                                                                     constrainedby TransiEnt.Components.Boundaries.Electrical.Base.PartialModelPowerBoundary "Model for boundary in electric boiler (has to fit to chosen power port)" annotation (Dialog(group="Replaceable Components",enable=usePowerPort),choicesAllMatching=true);

  // _____________________________________________
  //
  //               Final Parameters
  // _____________________________________________

  final parameter SI.Height dx = h/N_cv "Height of finite volumes";
  final parameter SI.Mass m=V*rho;
  final parameter SI.ThermalConductance[N_cv] G = cat(1,{A_top*U_top+A_wall/N_cv*U_wall}, fill(A_wall/N_cv*U_wall, N_cv-2), {A_bottom*U_bottom+A_wall/N_cv*U_wall});
  final parameter SI.Area A_top=V/h "top tank area" annotation(Dialog(group="Geometry"));
  final parameter SI.Area A_bottom=A_top "bottom tank area" annotation(Dialog(group="Geometry"));
  final parameter SI.Area A_wall=Modelica.Constants.pi*d*h "outside tank area" annotation(Dialog(group="Geometry"));
  final parameter SI.Diameter d = sqrt(4*V/h/Modelica.Constants.pi);
  final parameter Integer nPorts[N_cv]=Base.getPortCount(
      N_cv,
      i_prodIn,
      i_prodOut,
      i_gridIn,
      i_gridOut);
  final parameter Real G_diff = A_top*k/dx;

  final parameter Integer nPortSubIdx[4,max({n_prodIn,n_prodOut,n_gridIn,n_gridOut})]=Base.getPortSubIndex(
      N_cv,
      i_prodIn,
      i_prodOut,
      i_gridIn,
      i_gridOut);

  final parameter Integer i_prodIn[n_prodIn]=TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.Base.getIdxFromHeight(
      N_cv,
      h,
      h_prodIn) "Index of control volume containing heater(s) (1=top, n=bottom)" annotation (Dialog(group="Heating Units"));
  final parameter Integer i_prodOut[n_prodOut]=TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.Base.getIdxFromHeight(
      N_cv,
      h,
      h_prodOut) "Index of control volume containing heater(s) (1=top, n=bottom)" annotation (Dialog(group="Heating Units"));
  final parameter Integer i_gridIn[n_gridIn]=TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.Base.getIdxFromHeight(
      N_cv,
      h,
      h_gridIn) "Index of control volume containing grid side inflow(s) (1=top, n=bottom)" annotation (Dialog(group="Heating Units"));
  final parameter Integer i_gridOut[n_gridOut]=TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.Base.getIdxFromHeight(
      N_cv,
      h,
      h_gridOut) "Index of control volume containing grid side outflow(s) (1=top, n=bottom)" annotation (Dialog(group="Heating Units"));
  final parameter Integer i_elHeater[n_elHeater]=TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.Base.getIdxFromHeight(
      N_cv,
      h,
      h_elHeater) "Index of control volume containing electric heater(s) (1=top, n=bottom)" annotation (Dialog(group="Heating Units"));
  final parameter Boolean useElHeater=if n_elHeater>0 then true else false "true if electric heater should be included in the model";

  // _____________________________________________
  //
  //                  Components
  // _____________________________________________

  TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.Base.IncompressibleFluidVolume[N_cv] controlVolume(
    each d=rho,
    each c_v=c_v,
    nPorts=nPorts,
    T(start=T_start),
    V=p_Volume*V) if useFluidPorts annotation (Placement(transformation(extent={{-10,16},{10,36}})));

   Base.IncompressibleFluidVolume_noFluidPorts[N_cv] controlVolume1( each d=rho,
    each c_v=c_v,
    T(start=T_start),
    V=p_Volume*V) if not useFluidPorts annotation (Placement(transformation(extent={{22,-30},{42,-10}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor[N_cv] condAmbient(G=G) "Thermal conductance through side wall of storage" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,56})));

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.StorageCost collectStorageCosts(
    isThermalStorage=true,
    Delta_E_n=m*c_v*(T_max_ref - T_min_ref),
    redeclare model StorageCostModel = CostStatisticsModel,
    produces_P_el=false,
    consumes_P_el=false)     annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

  TransiEnt.Producer.Heat.Power2Heat.ElectricBoiler.ElectricBoiler electricHeater[n_elHeater](
    each useFluidPorts=false,
    each usePowerPort=usePowerPort,
    each medium=medium,
    Q_flow_n=Q_flow_n_elHeater,
    each eta=eta_elHeater,
    useHeatPort=true,
    redeclare model ProducerCosts = ProducerCosts_elHeater,
    redeclare connector PowerPortModel = ElectricPowerPort,
    redeclare model PowerBoundaryModel = PowerBoundary) if useElHeater annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-48})));

  TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.Base.Buoyancy buoyancy(
    V=V,
    N_cv=N_cv,
    tau=tau_buoyancy,
    rho=rho,
    c_v=c_v) "Models buoyancy in tank columes" annotation (Placement(transformation(extent={{20,20},{40,40}})));

  TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4.Base.Diffusion diffusion(
    A=A_top,
    N_cv=N_cv,
    dx=dx,
    k=k) annotation (Placement(transformation(extent={{-20,20},{-40,40}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector(final m=N_cv) "Collects the thermal lossen from top, sidewall and bottom"
         annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=180,
        origin={0,82})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor[N_cv] temperatureSensor annotation (Placement(transformation(extent={{-14,-32},{-34,-12}})));
  Modelica.Blocks.Sources.RealExpression[n_prodIn] realExpression3(y=waterPortIn_prod.m_flow.*(inStream(waterPortIn_prod.h_outflow) - waterPortOut_prod.h_outflow)) if
                                                                      useFluidPorts   annotation (Placement(transformation(extent={{66,-32},{86,-12}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=sum(waterPortIn_grid[i].m_flow*(inStream(waterPortIn_grid[i].h_outflow) - waterPortOut_grid[i].h_outflow) for i in 1:n_gridIn)) if
                                                                                                                                                                       useFluidPorts
                                                         annotation (Placement(transformation(extent={{68,-82},{88,-62}})));
  Modelica.Blocks.Sources.RealExpression realExpression4(y=sum(waterPortIn_prod[i].m_flow*(inStream(waterPortIn_prod[i].h_outflow) - waterPortOut_prod[i].h_outflow) for i in 1:n_prodIn) - sum(Q_flow_set_)) if
                                                                      useFluidPorts
                                                         annotation (Placement(transformation(extent={{68,-104},{88,-84}})));

  // _____________________________________________
  //
  //                  Variables
  // _____________________________________________

  SI.Temperature T[N_cv]=temperatureSensor.T;
  SI.Temperature T_mean = sum(temperatureSensor.T)/N_cv;
  Real SOC = (T_mean-T_min_ref)/(T_max_ref - T_min_ref);
  SI.Energy E = (sum(temperatureSensor.T)-T_min_ref)*c_v*m/N_cv;
  SI.HeatFlowRate Q_flow_loss2amb = -heatPortAmbient.Q_flow;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  // ==== Primary Heat Source conncetors

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn_prod[n_prodIn](each final Medium=medium) if useFluidPorts annotation (Placement(transformation(extent={{-110,50},{-90,70}}), iconTransformation(extent={{-110,30},{-90,50}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut_prod[n_prodOut](each final Medium=medium) if useFluidPorts annotation (Placement(transformation(extent={{-110,-70},{-90,-50}}), iconTransformation(extent={{-110,-50},{-90,-30}})));

  // Consumer Side connectors

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn_grid[n_gridIn](each final Medium=medium) if useFluidPorts annotation (Placement(transformation(extent={{92,-54},{112,-34}}), iconTransformation(extent={{90,-50},{110,-30}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut_grid[n_gridOut](each final Medium=medium) if useFluidPorts annotation (Placement(transformation(extent={{90,50},{110,70}}), iconTransformation(extent={{90,30},{110,50}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortAmbient "Heat port connecting control volumes with ambient temperature to model energy losses (connect ambient temperature)"
                                                                                                    annotation (Placement(transformation(extent={{-12,88},{12,112}}), iconTransformation(extent={{-10,75},{10,95}})));

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_set[n_elHeater] if useElHeater "Setpoint for thermal heat, should be negative" annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-100}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-90})));

  ElectricPowerPort epp if usePowerPort and useElHeater  "Choice of power port" annotation (Placement(transformation(extent={{-10,-90},{10,-110}}),                                                                     iconTransformation(extent={{-12,-110},{8,-90}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port[N_cv] if not useFluidPorts "Heat port connecting control volumes with ambient temperature to model energy losses (connect ambient temperature)" annotation (Placement(transformation(extent={{90,14},{114,38}}),  iconTransformation(extent={{82,53},{102,73}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut[n_gridIn] Q_flow_unload if useFluidPorts annotation (Placement(transformation(extent={{98,-14},{128,16}}), iconTransformation(extent={{98,-14},{128,16}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut[n_prodIn] Q_flow_load if useFluidPorts annotation (Placement(transformation(extent={{98,-38},{130,-6}}),  iconTransformation(extent={{98,-38},{130,-6}})));
  Modelica.Blocks.Sources.RealExpression[n_gridIn] realExpression1(y=waterPortIn_grid.m_flow.*(inStream(waterPortIn_grid.h_outflow) - waterPortOut_grid.h_outflow)) if useFluidPorts
                                                         annotation (Placement(transformation(extent={{66,-10},{86,10}})));

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_load_total if  useFluidPorts annotation (Placement(transformation(extent={{96,-110},{128,-78}}),  iconTransformation(extent={{96,-54},{128,-22}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_unload_total if  useFluidPorts annotation (Placement(transformation(extent={{96,-86},{124,-58}}),  iconTransformation(extent={{94,-30},{122,-2}})));

protected
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_set_[n_elHeater] "Internal value for setpoint for thermal heat"  annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-30}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-90})));

equation

  // _____________________________________________
  //
  //           Equations
  // _____________________________________________

  // ======== Heat port connections ===========

  // buoyancy model to control volume
  connect(buoyancy.heatPort, controlVolume.heatPort) annotation (Line(points={{19.8,30.4},{14,30.4},{14,40},{0,40},{0,35.6}},
                                                                                                                        color={191,0,0}));

  // heat loss: control volume to conductor
  connect(controlVolume.heatPort, condAmbient.port_a) annotation (Line(points={{0,35.6},{-5.55112e-16,46}},                            color={191,0,0}));



  // heat diffusion between elements
  connect(diffusion.heatPort, controlVolume.heatPort) annotation (Line(points={{-19.8,30.4},{-14,30.4},{-14,40},{0,40},{0,35.6}},
                                                                                                                color={191,0,0}));

  // ========= Fluid port connections ========

  // fluid flow between control volumes (first two ports of cv)
  connect(controlVolume[1].ports[1], controlVolume[2].ports[1]);
  for i in 2:N_cv-1 loop
      connect(controlVolume[i].ports[2], controlVolume[i+1].ports[1]);
  end for;

  // primary heat source in
  for i in 1:n_prodIn loop
    connect(waterPortIn_prod[i], controlVolume[i_prodIn[i]].ports[nPortSubIdx[1,i]]) annotation (Line(
      points={{-100,60},{-44,60},{-44,12},{-4,12},{-4,10},{0,10},{0,16.2}},
      color={175,0,0},
      thickness=0.5));
  end for;

  // primary heat source out
  for i in 1:n_prodOut loop
    connect(waterPortOut_prod[i], controlVolume[i_prodOut[i]].ports[nPortSubIdx[2,i]]) annotation (Line(
      points={{-100,-60},{-74,-60},{-74,12},{-4,12},{-4,10},{0,10},{0,16.2}},
      color={175,0,0},
      thickness=0.5));
  end for;

  // grid side water in
  for i in 1:n_gridIn loop
    connect(waterPortIn_grid[i], controlVolume[i_gridIn[i]].ports[nPortSubIdx[3,i]]) annotation (Line(
      points={{102,-44},{48,-44},{48,10},{16,10},{16,8},{0,8},{0,16.2}},
      color={175,0,0},
      thickness=0.5));
  end for;

  // grid side water out
  for i in 1:n_gridOut loop
    connect(waterPortOut_grid[i], controlVolume[i_gridOut[i]].ports[nPortSubIdx[4,i]]) annotation (Line(
      points={{100,60},{44,60},{44,8},{0,8},{0,16.2}},
      color={175,0,0},
      thickness=0.5));
  end for;

  // connection to ambient
  connect(thermalCollector.port_b, heatPortAmbient) annotation (Line(points={{0,90},{0,100}}, color={191,0,0}));
  connect(thermalCollector.port_a, condAmbient.port_b) annotation (Line(points={{0,74},{0,66}}, color={191,0,0}));

  // electric heater
  if useElHeater then
    connect(Q_flow_set,electricHeater. Q_flow_set) annotation (Line(
      points={{-60,-100},{-60,-58.4},{-41,-58.4}},
      color={175,0,0},
      pattern=LinePattern.Dash));
    connect(Q_flow_set, Q_flow_set_) annotation (Line(
      points={{-60,-100},{-60,-30}},
      color={175,0,0},
      pattern=LinePattern.Dash));
    for i in 1:n_elHeater loop
      connect(electricHeater[i].heat, controlVolume[i_elHeater[i]].heatPort) annotation (Line(points={{-43.8,-37.6},{-42,-37.6},{-42,16},{-16,16},{-16,24},{-14,24},{-14,40},{0,40},{0,35.6}},
                                                                                                                                          color={175,0,0}));
      connect(electricHeater[i].heat, controlVolume1[i_elHeater[i]].heatPort);
    end for;
    if usePowerPort then
      for i in 1:n_elHeater loop
        connect(electricHeater[i].epp, epp) annotation (Line(
          points={{-29.8,-48},{-20,-48},{-20,-100},{0,-100}},
          color={0,135,135},
          thickness=0.5));
      end for;
    end if;
  else
    Q_flow_set_=zeros(n_elHeater);
  end if;


  connect(diffusion.heatPort, controlVolume1.heatPort) annotation (Line(points={{-19.8,30.4},{-14,30.4},{-14,8},{2,8},{2,-4},{32,-4},{32,-10.4}}, color={191,0,0}));
  connect(condAmbient.port_a, controlVolume1.heatPort) annotation (Line(points={{-5.55112e-16,46},{-5.55112e-16,38},{16,38},{16,28},{14,28},{14,10},{2,10},{2,-4},{32,-4},{32,-10.4}}, color={191,0,0}));
  connect(buoyancy.heatPort, controlVolume1.heatPort) annotation (Line(points={{19.8,30.4},{16,30.4},{16,28},{14,28},{14,10},{2,10},{2,-4},{32,-4},{32,-10.4}}, color={191,0,0}));
  connect(temperatureSensor.port, controlVolume.heatPort) annotation (Line(points={{-14,-22},{-2,-22},{-2,-8},{-42,-8},{-42,16},{-16,16},{-16,24},{-14,24},{-14,40},{0,40},{0,35.6}},    color={191,0,0}));
  connect(temperatureSensor.port, controlVolume1.heatPort) annotation (Line(points={{-14,-22},{0,-22},{0,-4},{4,-4},{4,-6},{32,-6},{32,-10.4}},                      color={191,0,0}));

    for i in 1:N_cv loop
  connect(controlVolume1[i].heatPort, port[i]) annotation (Line(points={{32,-10.4},{32,-4},{2,-4},{2,10},{14,10},{14,12},{84,12},{84,26},{102,26}},
                                                                                                              color={191,0,0}));
  end for;
  connect(realExpression1.y, Q_flow_unload) annotation (Line(points={{87,0},{100,0},{100,1},{113,1}},                         color={0,0,127}));
  connect(realExpression3.y, Q_flow_load) annotation (Line(points={{87,-22},{114,-22}},                   color={0,0,127}));
  connect(realExpression2.y, Q_flow_unload_total) annotation (Line(points={{89,-72},{110,-72}}, color={0,0,127}));
  connect(realExpression4.y, Q_flow_load_total) annotation (Line(points={{89,-94},{112,-94}},                       color={0,0,127}));

  // ======== Statistics =====
  connect(modelStatistics.costsCollector, collectStorageCosts.costsCollector);

     annotation (Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b> </p>
<p>One dimensional fluid storage model with stratification. Intention of the model is to represent a hot water storage in a bigger system with more accurate outflow temperatures compared to a zero dimensional storage model. Several ports on the producer and grid side can be added as well as electric heating rods.</p>
<p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>L4: Storage is divided in layered volumes. Each volume is ideally stirred. Between the fluid volumes, heat conduction, heat diffusion, heat losses and boyancy are considered. </p>
<p>Heat losses to the ambient are simplified as heat conduction through top, side wall and bottom. </p>
<p><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>- The storage model includes just a vertical temperature distribution. No horizontal temperature distribution is modeled. Mixing effects due to the velocity of the fluid at inlets an outlets are not modeled. </p>
<p>- Losses to the ambient are modeled as linear dependent from temperature difference (no radiation or convection modeled)</p>
<p>- Thermodynamic properties of fluid are constant (no temperature dependency modeled)</p>
<p>- No pressure losses or levels modeled</p>
<p>- No change of gaseous state modeled</p>
<p>- Geometry is cylindric </p>
<p>- arbitrary fluid port numbers with individual heigths </p>
<p><b><span style=\"color: #008000;\">4. Interfaces</span></b></p>
<p>Heat</p>
<p>heatLosses: ambient temperature and the collected heat flow to the ambient through top, side wall and bottom</p>
<p>port: heat port connected to each layer of the storage tank if fluid ports are disabled.</p>
<p>Fluid</p>
<p>waterPortIn_prod: fluid connection from producer, fluid flows to the storage </p>
<p>waterPortOut_prod: fluid connection to producer, fluid flows from the storage </p>
<p>waterPortIn_grid: fluid connection from heating grid, fluid flows to the storage</p>
<p>waterPortOut_grid: fluid connection to heating Grid, fluid flows from the storage</p>
<p><b><span style=\"color: #008000;\">5. Nomenclature</span></b></p>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">6. Governing Equations</span></b></p>
<p>Energy and mass or volume balance inside every volume segment. Heat losses due to one dimensional thermal conductance through top, bottom and side wall. Thermal conductance between volume segments. Modeled boyancy introducing heat flow from lower to higher segment if the lower segemnt has a higher temperature. Direct fluid connection between the volumes. </p>
<p><b><span style=\"color: #008000;\">7. Remarks for Usage</span></b></p>
<p>The allowed minimum number of volume segements is two. The higher the number of segments the higher the number of equations. </p>
<p>If FluidPorts are disabled, the amount of heat that is transferred to each layer needs to be specified via the heat port &apos;port&apos;.</p>
<p><b><span style=\"color: #008000;\">8. Validation</span></b></p>
<p>The model is validated with hot water storage Vitocell 160E. The storage tank has a capacity of 1000 liters and an inner height of 1.88 metres (without insulation). The tank has multiple fluid inflow and outflow connections. The storage is used for climatisation and is installed at TUHH for research purposes. The model is validated against measurements and simulations from Harmsen. </p>
<p><b><span style=\"color: #008000;\">9. References</span></b></p>
<p>(no remarks) </p>
<p><b><span style=\"color: #008000;\">10. Version History</span></b></p>
<p>Model created by Tobias Ramm (tobias.ramm@tuhh.de) on Fri Mar 20 2015</p>
<p>Model revised by Lisa Andresen (andresen@tuhh.de), Jun 2015</p>
<p>Model revised and redesigned by Pascal Dubucq (dubucq@tuhh.de) on Wed August 24, 2016</p>
<p>- Switched order of control volumes to more intuitive counting (1=bottom, then counting up until N_cv=top)</p>
<p>- Renamed variables to Transient / ClaRa code conventions</p>
<p>- Changed diffusion modeling to second order finite difference approximation</p>
<p>- Removed TIL Media object that was used to calculate *some* of the thermodynamic properties (but not all of them). Now all properties are constant which reduces model complexity. Relevant properties (density, thermal conductivity, heat cacpacity) are mainly temperature dependent and storage operates in fairly narrow temperature range.</p>
<p>Added cost statistics on March 30, 2017</p>
<p>Model expanded to include several producer and grid ports on different heights and electric heating rods by Carsten Bode (c.bode@tuhh.de), Nov 2018</p>
<p>Modification by Anne Hagemeier (anne.hagemeier@umsicht.fraunhofer.de) in August 2021 (Enabled the model to be used without fluid ports)</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(graphics={
        Line(points={{-62,-22},{-14,-22},{-14,-50},{-14,2}}, color={0,135,135}, visible=useElHeater),
        Line(points={{-20,-24},{-8,-30}}, color={0,135,135}, visible=useElHeater),
        Line(points={{-20,-34},{-8,-40}}, color={0,135,135}, visible=useElHeater),
        Line(points={{-20,-14},{-8,-20}}, color={0,135,135}, visible=useElHeater),
        Line(points={{-20,-4},{-8,-10}}, color={0,135,135}, visible=useElHeater)}));
end HotWaterStorage_constProp_L4;
