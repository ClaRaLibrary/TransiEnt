within TransiEnt.Storage.Heat.HotWaterStorage_constProp_L4;
model HotWaterStorage_constProp_L4 "Temperature and heat flow rate based model of a stratified thermal storage with finite volume discretisation (1=top, n=bottom) and constant fluid properties, electric heating rods can be added"
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.ThermalStorageBasic;

  import SI = Modelica.SIunits;
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

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium= simCenter.fluid1 "Medium to be used"
                         annotation(choicesAllMatching, Dialog(group="Fluid Definition"));

  parameter Integer N_cv=5 "Number of finite control volumes";

  // geometry

  parameter SI.Volume V = 1e3 "Volume of tank" annotation(Dialog(group="Geometry"));
  parameter SI.Height h = 1 "Height of tank" annotation(Dialog(group="Geometry"));
  parameter Integer n_prodIn=1 "Number of inlet ports on producer side" annotation(Dialog(group="Geometry"));
  parameter Integer n_prodOut=n_prodIn "Number of outlet ports on producer side" annotation(Dialog(group="Geometry"));
  parameter Integer n_gridIn=1 "Number of inlet ports on grid side" annotation(Dialog(group="Geometry"));
  parameter Integer n_gridOut=n_gridIn "Number of outlet ports on grid side" annotation(Dialog(group="Geometry"));
  parameter SI.Height h_prodIn[n_prodIn]=fill(h,n_prodIn) "Height of inlet of primary heat source" annotation(Dialog(group="Heating Units"));
  parameter SI.Height h_prodOut[n_prodOut]=fill(0,n_prodOut) "Height of outlet of primary heat source" annotation(Dialog(group="Heating Units"));
  parameter SI.Height h_gridIn[n_gridIn]=fill(0,n_gridIn) "Height of inlet of grid side" annotation(Dialog(group="Heating Units"));
  parameter SI.Height h_gridOut[n_gridOut]=fill(h,n_gridOut) "Height of outlet of grid side" annotation(Dialog(group="Heating Units"));

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
  replaceable model PowerBoundary = TransiEnt.Components.Boundaries.Electrical.Power constrainedby TransiEnt.Components.Boundaries.Electrical.Base.PartialModelPowerBoundary "Model for boundary in electric boiler (has to fit to chosen power port)" annotation (Dialog(group="Replaceable Components",enable=usePowerPort),choicesAllMatching=true);

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
    each V=V/N_cv) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor[N_cv] condAmbient(G=G) "Thermal conductance through side wall of storage" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,56})));

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.StorageCost collectStorageCosts(
    isThermalStorage=true,
    Delta_E_n=m*c_v*(T_max_ref - T_min_ref),
    redeclare model StorageCostModel = CostStatisticsModel,
    Q_flow_is=Q_flow_unload_total,
    produces_P_el=false,
    consumes_P_el=false)     annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  TransiEnt.Producer.Heat.Power2Heat.ElectricBoiler electricHeater[n_elHeater](
    each useFluidPorts=false,
    each usePowerPort=usePowerPort,
    each medium=medium,
    Q_flow_n=Q_flow_n_elHeater,
    each eta=eta_elHeater,
    redeclare model ProducerCosts = ProducerCosts_elHeater,
    redeclare ElectricPowerPort epp,
    redeclare PowerBoundary powerBoundary) if useElHeater annotation (Placement(transformation(
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

  // _____________________________________________
  //
  //                  Variables
  // _____________________________________________

  SI.Temperature T_mean = sum(controlVolume.T)/N_cv;
  Real SOC = (T_mean-T_min_ref)/(T_max_ref - T_min_ref);
  SI.Energy E = (sum(controlVolume.T)-T_min_ref)*c_v*m/N_cv;
  SI.HeatFlowRate Q_flow_load[n_prodIn];
  SI.HeatFlowRate Q_flow_load_total=sum(waterPortIn_prod[i].m_flow*(inStream(waterPortIn_prod[i].h_outflow) - waterPortOut_prod[i].h_outflow) for i in 1:n_prodIn)-sum(Q_flow_set_);
  SI.HeatFlowRate Q_flow_unload[n_gridIn];
  SI.HeatFlowRate Q_flow_unload_total=sum(waterPortIn_grid[i].m_flow*(inStream(waterPortIn_grid[i].h_outflow) - waterPortOut_grid[i].h_outflow) for i in 1:n_gridIn);
  SI.HeatFlowRate Q_flow_loss2amb = -heatPortAmbient.Q_flow;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  // ==== Primary Heat Source conncetors

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn_prod[n_prodIn](each final Medium=medium) annotation (Placement(transformation(extent={{-110,50},{-90,70}}), iconTransformation(extent={{-110,30},{-90,50}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut_prod[n_prodOut](each final Medium=medium) annotation (Placement(transformation(extent={{-110,-70},{-90,-50}}), iconTransformation(extent={{-110,-50},{-90,-30}})));

  // Consumer Side connectors

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn_grid[n_gridIn](each final Medium=medium) annotation (Placement(transformation(extent={{90,-70},{110,-50}}), iconTransformation(extent={{90,-50},{110,-30}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut_grid[n_gridOut](each final Medium=medium) annotation (Placement(transformation(extent={{90,50},{110,70}}), iconTransformation(extent={{90,30},{110,50}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortAmbient "Heat port connecting control volumes with ambient temperature to model energy losses (connect ambient temperature)"
                                                                                                    annotation (Placement(transformation(extent={{-12,88},{12,112}}), iconTransformation(extent={{-10,75},{10,95}})));

  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow_set[n_elHeater] if useElHeater "Setpoint for thermal heat, should be negative" annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-100}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-90})));
  ElectricPowerPort epp if usePowerPort and useElHeater  "Choice of power port" annotation (Placement(transformation(extent={{-10,-90},{10,-110}}),                                                                     iconTransformation(extent={{-12,-110},{8,-90}})));
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

  // load/unload Q_flows
  Q_flow_load=waterPortIn_prod.m_flow.*(inStream(waterPortIn_prod.h_outflow) - waterPortOut_prod.h_outflow);
  Q_flow_unload=waterPortIn_grid.m_flow.*(inStream(waterPortIn_grid.h_outflow) - waterPortOut_grid.h_outflow);

  // ======== Heat port connections ===========

  // buoyancy model to control volume
  connect(buoyancy.heatPort, controlVolume.heatPort) annotation (Line(points={{19.8,30.4},{0,30.4},{0,9.6}},            color={191,0,0}));

  // heat loss: control volume to conductor
  connect(controlVolume.heatPort, condAmbient.port_a) annotation (Line(points={{0,9.6},{0,42},{-6.66134e-16,42},{-6.66134e-16,46}},    color={191,0,0}));

  // heat loss: conductor to ambient

  // heat diffusion between elements
  connect(diffusion.heatPort, controlVolume.heatPort) annotation (Line(points={{-19.8,30.4},{0,30.4},{0,9.6}},  color={191,0,0}));

  // ========= Fluid port connections ========

  // fluid flow between control volumes (first two ports of cv)
  connect(controlVolume[1].ports[1], controlVolume[2].ports[1]);
  for i in 2:N_cv-1 loop
      connect(controlVolume[i].ports[2], controlVolume[i+1].ports[1]);
  end for;

  // primary heat source in
  for i in 1:n_prodIn loop
    connect(waterPortIn_prod[i], controlVolume[i_prodIn[i]].ports[nPortSubIdx[1,i]]) annotation (Line(
      points={{-100,60},{-80,60},{-80,-20},{0,-20},{0,-9.8}},
      color={175,0,0},
      thickness=0.5));
  end for;

  // primary heat source out
  for i in 1:n_prodOut loop
    connect(waterPortOut_prod[i], controlVolume[i_prodOut[i]].ports[nPortSubIdx[2,i]]) annotation (Line(
      points={{-100,-60},{-80,-60},{-80,-20},{0,-20},{0,-9.8}},
      color={175,0,0},
      thickness=0.5));
  end for;

  // grid side water in
  for i in 1:n_gridIn loop
    connect(waterPortIn_grid[i], controlVolume[i_gridIn[i]].ports[nPortSubIdx[3,i]]) annotation (Line(
      points={{100,-60},{0,-60},{0,-9.8}},
      color={175,0,0},
      thickness=0.5));
  end for;

  // grid side water out
  for i in 1:n_gridOut loop
    connect(waterPortOut_grid[i], controlVolume[i_gridOut[i]].ports[nPortSubIdx[4,i]]) annotation (Line(
      points={{100,60},{100,-20},{0,-20},{0,-9.8}},
      color={175,0,0},
      thickness=0.5));
  end for;

  // connection to ambient
  connect(thermalCollector.port_b, heatPortAmbient) annotation (Line(points={{0,90},{0,100}}, color={191,0,0}));
  connect(thermalCollector.port_a, condAmbient.port_b) annotation (Line(points={{0,74},{0,66}}, color={191,0,0}));

  // electric heater
  if useElHeater then
    connect(Q_flow_set,electricHeater. Q_flow_set) annotation (Line(
      points={{-60,-100},{-60,-48},{-50,-48}},
      color={175,0,0},
      pattern=LinePattern.Dash));
    connect(Q_flow_set, Q_flow_set_) annotation (Line(
      points={{-60,-100},{-60,-30}},
      color={175,0,0},
      pattern=LinePattern.Dash));
    for i in 1:n_elHeater loop
      connect(electricHeater[i].heat, controlVolume[i_elHeater[i]].heatPort) annotation (Line(points={{-40,-38},{-40,14},{0,14},{0,9.6}}, color={175,0,0}));
    end for;
    if usePowerPort then
      for i in 1:n_elHeater loop
        connect(electricHeater[i].epp, epp) annotation (Line(
          points={{-30,-48},{-20,-48},{-20,-100},{0,-100}},
          color={0,135,135},
          thickness=0.5));
      end for;
    end if;
  else
    Q_flow_set_=zeros(n_elHeater);
  end if;

  // ======== Statistics =====
  connect(modelStatistics.costsCollector, collectStorageCosts.costsCollector);

// _____________________________________________
//
//               Documentation
// _____________________________________________
    annotation (Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b> </p>
<p>One dimensional fluid storage model with stratification. Intention of the model is to represent a hot water storage in a bigger system with more accurate outflow temperatures compared to a zero dimensional storage model. Several ports on the producer and grid side can be added as well as electric heating rods.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>L4: Storage is divided in layered volumes. Each volume is ideally stirred. Between the fluid volumes, heat conduction, heat diffusion, heat losses and boyancy are considered. </p>
<p>Heat losses to the ambient are simplified as heat conduction through top, side wall and bottom. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>- The storage model includes just a vertical temperature distribution. No horizontal temperature distribution is modeled. Mixing effects due to the velocity of the fluid at inlets an outlets are not modeled. </p>
<p>- Losses to the ambient are modeled as linear dependent from temperature difference (no radiation or convection modeled)</p>
<p>- Thermodynamic properties of fluid are constant (no temperature dependency modeled)</p>
<p>- No pressure losses or levels modeled</p>
<p>- No change of gaseous state modeled</p>
<p>- Geometry is cylindric </p>
<p>- arbitrary fluid port numbers with individual heigths </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Heat</p>
<p>heatLosses: ambient temperature and the collected heat flow to the ambient through top, side wall and bottom</p>
<p>Fluid</p>
<p>waterPortIn_prod: fluid connection from producer, fluid flows to the storage </p>
<p>waterPortOut_prod: fluid connection to producer, fluid flows from the storage </p>
<p>waterPortIn_grid: fluid connection from heating grid, fluid flows to the storage</p>
<p>waterPortOut_grid: fluid connection to heating Grid, fluid flows from the storage</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Energy and mass or volume balance inside every volume segment. Heat losses due to one dimensional thermal conductance through top, bottom and side wall. Thermal conductance between volume segments. Modeled boyancy introducing heat flow from lower to higher segment if the lower segemnt has a higher temperature. Direct fluid connection between the volumes. </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>The allowed minimum number of volume segements is two. The higher the number of segments the higher the number of equations. </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>The model is validated with hot water storage Vitocell 160E. The storage tank has a capacity of 1000 liters and an inner height of 1.88 metres (without insulation). The tank has multiple fluid inflow and outflow connections. The storage is used for climatisation and is installed at TUHH for research purposes. The model is validated against measurements and simulations from Harmsen. </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Tobias Ramm (tobias.ramm@tuhh.de) on Fri Mar 20 2015</p>
<p>Model revised by Lisa Andresen (andresen@tuhh.de), Jun 2015</p>
<p>Model revised and redesigned by Pascal Dubucq (dubucq@tuhh.de) on Wed August 24, 2016</p>
<p>- Switched order of control volumes to more intuitive counting (1=bottom, then counting up until N_cv=top)</p>
<p>- Renamed variables to Transient / ClaRa code conventions</p>
<p>- Changed diffusion modeling to second order finite difference approximation</p>
<p>- Removed TIL Media object that was used to calculate *some* of the thermodynamic properties (but not all of them). Now all properties are constant which reduces model complexity. Relevant properties (density, thermal conductivity, heat cacpacity) are mainly temperature dependent and storage operates in fairly narrow temperature range.</p>
<p>Added cost statistics on March 30, 2017</p>
<p>Model expanded to include several producer and grid ports on different heights and electric heating rods by Carsten Bode (c.bode@tuhh.de), Nov 2018</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Icon(graphics={
        Line(points={{-62,-22},{-14,-22},{-14,-50},{-14,2}}, color={0,135,135}, visible=useElHeater),
        Line(points={{-20,-24},{-8,-30}}, color={0,135,135}, visible=useElHeater),
        Line(points={{-20,-34},{-8,-40}}, color={0,135,135}, visible=useElHeater),
        Line(points={{-20,-14},{-8,-20}}, color={0,135,135}, visible=useElHeater),
        Line(points={{-20,-4},{-8,-10}}, color={0,135,135}, visible=useElHeater)}));
end HotWaterStorage_constProp_L4;
