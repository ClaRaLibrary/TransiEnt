within TransiEnt.Storage.Heat.HeatStorageStratified_constProp;
model StratifiedHotWaterStorage_L4 "Model of one dimensional hot water storage, constant media properties"
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

  parameter Integer N_cv(min=3)=5 "Number of finite control volumes";

  // geometry

  parameter SI.Volume V = 1e3 "Volume of tank" annotation(Dialog(group="Geometry"));
  parameter SI.Length h = 1 "height of tank" annotation(Dialog(group="Geometry"));
  parameter SI.Length h_primaryHeatSourceWaterIn = h "Height of inlet of primary heat source" annotation(Dialog(group="Heating Units"));
  parameter SI.Length h_primaryHeatSourceWaterOut = 0 "Height of outlet of primary heat source" annotation(Dialog(group="Heating Units"));
  parameter SI.Length h_gridSideWaterIn = 0 "Height of inlet of grid side" annotation(Dialog(group="Heating Units"));
  parameter SI.Length h_gridSideWaterOut = h "Height of outlet of grid side" annotation(Dialog(group="Heating Units"));

  parameter SI.CoefficientOfHeatTransfer U_wall = 0.5 "Coefficient of heat transfer from wall to ambient " annotation(Dialog(group="Thermodynamics"));
  parameter SI.CoefficientOfHeatTransfer U_top = U_wall "Coefficient of heat transfer from top to ambient " annotation(Dialog(group="Thermodynamics"));
  parameter SI.CoefficientOfHeatTransfer U_bottom = U_wall "Coefficient of heat transfer from bottom to ambient " annotation(Dialog(group="Thermodynamics"));
  parameter SI.ThermalConductivity k = 0.6 "Thermal conductivity of fluid in storage" annotation(Dialog(group="Thermodynamics"));
  parameter SI.Density rho = 1e3 "Density of fluid in storage" annotation(Dialog(group="Thermodynamics"));
  parameter SI.SpecificHeatCapacity c_v = 4.185e3 "Heat capacity of fluid in storage" annotation(Dialog(group="Thermodynamics"));
  parameter SI.Temperature[N_cv] T_start=fill(273.15+60, N_cv) "Time constant of buoyancy model";
  parameter SI.Temperature T_max_ref = 90+273.15 "Maximum reference temperature (SOC=1)";
  parameter SI.Temperature T_min_ref = 60+273.15 "Minimm reference temperature (SOC=0)";
  parameter SI.Time tau_buoyancy = 1 "Time constant of buoyancy model";

  replaceable model CostStatisticsModel = TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.SmallHotWaterStorage constrainedby TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.PartialStorageCostSpecs
   "Model for global cost calculation" annotation (choicesAllMatching=true, Dialog(group="Statistics"));

  // _____________________________________________
  //
  //               Final Parameters
  // _____________________________________________

  final parameter SI.Length dx = h/N_cv "Height of finite volumes";
  final parameter SI.Mass m=V*rho;
  final parameter SI.ThermalConductance[N_cv] G = cat(1,{A_top*U_top+A_wall/N_cv*U_wall}, fill(A_wall/N_cv*U_wall, N_cv-2), {A_bottom*U_bottom+A_wall/N_cv*U_wall});
  final parameter SI.Area A_top=V/h "top tank area" annotation(Dialog(group="Geometry"));
  final parameter SI.Area A_bottom=A_top "bottom tank area" annotation(Dialog(group="Geometry"));
  final parameter SI.Area A_wall=Modelica.Constants.pi*d*h "outside tank area" annotation(Dialog(group="Geometry"));
  final parameter SI.Length d = sqrt(4*V/h/Modelica.Constants.pi);
  final parameter Integer nPorts[N_cv]=Base.getPortCount(
      N_cv,
      i_primaryHeatSourceWaterIn,
      i_primaryHeatSourceWaterOut,
      i_gridSideWaterIn,
      i_gridSideWaterOut);
  final parameter Real G_diff = A_top*k/dx;

  final parameter Integer nPortSubIdx[4]=Base.getPortSubIndex(
      N_cv,
      i_primaryHeatSourceWaterIn,
      i_primaryHeatSourceWaterOut,
      i_gridSideWaterIn,
      i_gridSideWaterOut);

  final parameter Integer i_primaryHeatSourceWaterIn=Base.getIdxFromHeight(
      N_cv,
      h,
      h_primaryHeatSourceWaterIn) "Index of control volume containing heater (1=top, n=bottom)" annotation (Dialog(group="Heating Units"));
  final parameter Integer i_primaryHeatSourceWaterOut=Base.getIdxFromHeight(
      N_cv,
      h,
      h_primaryHeatSourceWaterOut) "Index of control volume containing heater (1=top, n=bottom)" annotation (Dialog(group="Heating Units"));
  final parameter Integer i_gridSideWaterIn=Base.getIdxFromHeight(
      N_cv,
      h,
      h_gridSideWaterIn) "Index of control volume containing grid side inflow (1=top, n=bottom)" annotation (Dialog(group="Heating Units"));
  final parameter Integer i_gridSideWaterOut=Base.getIdxFromHeight(
      N_cv,
      h,
      h_gridSideWaterOut) "Index of control volume containing grid side outflow (1=top, n=bottom)" annotation (Dialog(group="Heating Units"));

  // _____________________________________________
  //
  //                  Components
  // _____________________________________________

  Base.IncompressibleFluidVolume[N_cv] controlVolume(
    each d=rho,
    each c_v=c_v,
    nPorts=nPorts,
    T_start=T_start,
    each V=V/N_cv) annotation (Placement(transformation(extent={{-10,-6},{10,14}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor[N_cv] condAmbient(G=G) "Thermal conductance through side wall of storage" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,56})));

  TransiEnt.Components.Statistics.Collectors.LocalCollectors.StorageCost collectStorageCosts(
    isThermalStorage=true,
    Delta_E_n=m*c_v*(T_max_ref - T_min_ref),
    redeclare model StorageCostModel = CostStatisticsModel,
    Q_flow_is=Q_flow_unload,
    produces_P_el=false,
    consumes_P_el=false)     annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

  // _____________________________________________
  //
  //                  Variables
  // _____________________________________________

  SI.Temperature T_mean = sum(controlVolume.T)/N_cv;
  Real SOC = (T_mean-T_min_ref)/(T_max_ref - T_min_ref);
  SI.Energy E = (sum(controlVolume.T)-T_min_ref)*c_v*m/N_cv;
  SI.HeatFlowRate Q_flow_load = waterPortIn_primaryHeatSource.m_flow * (inStream(waterPortIn_primaryHeatSource.h_outflow)-waterPortOut_primaryHeatSource.h_outflow);
  SI.HeatFlowRate Q_flow_unload = waterPortIn_Grid.m_flow * (inStream(waterPortIn_Grid.h_outflow)-waterPortOut_primaryHeatSource.h_outflow);
  SI.HeatFlowRate Q_flow_loss2amb = -heatPortAmbient.Q_flow;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  // ==== Primary Heat Source conncetors

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn_primaryHeatSource(final Medium=medium) annotation (Placement(transformation(extent={{-110,50},{-90,70}}), iconTransformation(extent={{-110,30},{-90,50}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut_primaryHeatSource(final Medium=medium) annotation (Placement(transformation(extent={{-110,-70},{-90,-50}}), iconTransformation(extent={{-110,-50},{-90,-30}})));

  // Consumer Side connectors

  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn waterPortIn_Grid(final Medium=medium) annotation (Placement(transformation(extent={{90,-70},{110,-50}}), iconTransformation(extent={{90,-50},{110,-30}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut waterPortOut_Grid(final Medium=medium) annotation (Placement(transformation(extent={{90,50},{110,70}}), iconTransformation(extent={{90,30},{110,50}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPortAmbient "Heat port connecting control volumes with ambient temperature to model energy losses (connect ambient temperature)"
                                                                                                    annotation (Placement(transformation(extent={{-12,88},{12,112}}), iconTransformation(extent={{-10,75},{10,95}})));

  Base.Buoyancy buoyancy(
    V=V,
    N_cv=N_cv,
    tau=tau_buoyancy,
    rho=rho,
    c_v=c_v) "Models buoyancy in tank columes" annotation (Placement(transformation(extent={{36,19},{56,39}})));
  Base.Diffusion diffusion(
    A=A_top,
    N_cv=N_cv,
    dx=dx,
    k=k) annotation (Placement(transformation(extent={{-26,20},{-46,40}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector(final m=N_cv) "Collects the thermal lossen from top, sidewall and bottom"
         annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=180,
        origin={0,82})));
equation

  // _____________________________________________
  //
  //           Equations
  // _____________________________________________

  // ======== Heat port connections ===========

  // buoyancy model to control volume
  connect(buoyancy.heatPort, controlVolume.heatPort) annotation (Line(points={{35.8,29.4},{20,29.4},{0,29.4},{0,13.6}}, color={191,0,0}));

  // heat loss: control volume to conductor
  connect(controlVolume.heatPort, condAmbient.port_a) annotation (Line(points={{0,13.6},{0,20},{-6.66134e-016,20},{-6.66134e-016,46}}, color={191,0,0}));

  // heat loss: conductor to ambient

  // heat diffusion between elements
  connect(diffusion.heatPort, controlVolume.heatPort) annotation (Line(points={{-25.8,30.4},{0,30.4},{0,13.6}}, color={191,0,0}));

  // ========= Fluid port connections ========

  // fluid flow between control volumes (first two ports of cv)
  connect(controlVolume[1].ports[1], controlVolume[2].ports[1]);
  for i in 2:N_cv-1 loop
      connect(controlVolume[i].ports[2], controlVolume[i+1].ports[1]);
  end for;

   // primary heat source in
   connect(waterPortIn_primaryHeatSource, controlVolume[i_primaryHeatSourceWaterIn].ports[nPortSubIdx[1]]) annotation (Line(
           points={{-100,60},{-80,60},{-80,-20},{0,-20},{0,-5.8}},
           color={175,0,0},
           thickness=0.5));

   // primary heat source out
   connect(waterPortOut_primaryHeatSource, controlVolume[i_primaryHeatSourceWaterOut].ports[nPortSubIdx[2]]) annotation (Line(
           points={{-100,-60},{-80,-60},{-80,-20},{0,-20},{0,-5.8}},
           color={175,0,0},
           thickness=0.5));

  // grid side water in
  connect(waterPortIn_Grid, controlVolume[i_gridSideWaterIn].ports[nPortSubIdx[3]]) annotation (Line(
      points={{100,-60},{0,-60},{0,-5.8}},
      color={175,0,0},
      thickness=0.5));

  // grid side water out
  connect(waterPortOut_Grid, controlVolume[i_gridSideWaterOut].ports[nPortSubIdx[4]]) annotation (Line(
      points={{100,60},{100,60},{100,28},{100,-14},{100,-20},{0,-20},{0,-5.8}},
      color={175,0,0},
      thickness=0.5));

  // ======== Statistics =====
  connect(modelStatistics.costsCollector, collectStorageCosts.costsCollector);

// _____________________________________________
//
//               Documentation
// _____________________________________________

  connect(thermalCollector.port_b, heatPortAmbient) annotation (Line(points={{0,90},{0,100}}, color={191,0,0}));
  connect(thermalCollector.port_a, condAmbient.port_b) annotation (Line(points={{0,74},{0,66}}, color={191,0,0}));
    annotation (Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b> </p>
<p>One dimensional fluid storage model with stratification. Intention of the model is to represent a hot water storage in a bigger system with more accurate outflow temperatures compared to a zero dimensional storage model. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>L3: Storage is diveded in layered volumes. Each volume is ideally stirred. Between the fluid volumes heat conduction, heat diffusion, heat losses and boyancy are considered. </p>
<p>Heat losses to the ambient are simplified as heat conduction through top, side wall and bottom. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>- The storage model includes just a vertical temperature distribution. No horizontal temperature distribution is modeled. Mixing effects due to the velocity of the fluid at inlets an outlets are not modelled. </p>
<p>- Losses to the ambient are modeled as linear dependent from temperature difference (no radiation or convection modeled)</p>
<p>- Thermodynamic properties of fluid are constant (no temperature dependency modeled)</p>
<p>- No pressure losses or levels modeled</p>
<p>- No change of gaseous state modeled</p>
<p>- Geometry is cylindric </p>
<p>- four fluid port locations with individual heigths </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<h5>Heat</h5>
<p>heatLosses: ambient temperature and the collected heat flow to the ambient through top, side wall and bottom</p>
<h5>Fluid</h5>
<p>waterPortIn_PrimaryHeatSource: fluid connection from CHP, fluid flows to the storage </p>
<p>waterPortOut_PrimaryHeatSource: fluid connection to CHP, fluid flows from the storage </p>
<p>waterPortIn_Grid: fluid connection from heating grid, fluid flows to the storage</p>
<p>waterPortOut_Grid: fluid connection to heating Grid, fluid flows from the storage</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p><br>Just parameters and of the main model are described. Further explanations are in the sub models. medium: medium in the hot water storage. Has to be one phase fluid from the TILMedia library</p>
<p><br>nSeg: number of vertical layered fluid segments</p>
<p><br>T_max: maximum allowed temperatur inside the storage</p>
<p><br>T_min: minimum allowed temperatur inside the storage</p>
<p><br>useSecondaryHeatSource(Boolean): if true the ports waterPortIn_SecondaryHeatSource and waterPortOut_SecondaryHeatSource are active</p>
<p><br>useHeatPorts(Boolean): if true heatPorts is active</p>
<p><br>nHeatPorts: number of heat ports</p>
<p><br>nAdditionalFluidPorts: number of additional fluid ports </p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Energy and mass or volume balance inside every volume segment. Heat losses due to one dimensional thermal conductance through top, bottom and side wall. Thermal conductance between volume segments. Modeled boyancy introducing heat flow from lower to higher segment if the lower segemnt has a higher temperature. Direct fluid connection between the volumes. </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>The allowed minimum number of volume segements is two. The higher the number of segments the higher the number of equations. </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>The model is validated with hot water storage Vitocell 160E. The storage tank has a capacity of 1000 liters and an inner height of 1.88 metres (without insulation). The tank has multiple fluid inflow and outflow connections. The storage is used for climatisation and is installted at TUHH for research purposes. The model is validated against measurements and simulations from Harmsen. Parts of the Validation are shown in the figures below. The temperatures in the storage have been measured in four different heights (red: 1.592m, blue: 1.044m, green: 0.618m, black: 0.293m). The dotted lines show the measured temperatures, the dashed lines the temperatures from a reference simulation and the solid lines the temperatures of this model. The following picture shows the overnight cooling while no fluid flows entered or left the storage. The simulation was done with disretizing the storage in ten segemnts. </p>
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
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end StratifiedHotWaterStorage_L4;
