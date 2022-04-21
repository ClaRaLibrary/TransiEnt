within TransiEnt.Storage.Heat.HotWaterStorage_L4;
model HotWaterStorage_L4 "Temperature and Heat flow rate based model of a stratified thermal storage with finite volume discretisation (1=top, n=bottom)"



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

  parameter TILMedia.VLEFluidTypes.BaseVLEFluid   medium= simCenter.fluid1 "Medium to be used"
                         annotation(choicesAllMatching, Dialog(group="Fluid Definition"));

  parameter Integer nSeg = 10 "Number of vertical storage segments";

  //limitations and conbstraints constraints
  constant Integer nSeg_min = 2 "Minimal allowed tank segments";
  parameter SI.Length Height=2 "Height of Tank";
  parameter SI.Volume Volume=1 "Volume of Tank";
  parameter SI.Length Height_port= if Add_ElectricHeater then Geometry.height else 1 "Height of HeatPorts";
  parameter SI.Temperature maxTemperature_allowed = 371.15 "maximal allowed temperature in tank in K";
  parameter SI.Temperature minTemperature_allowed = 283.15 "minimal allowed temperature in tank in K";
  parameter SI.Temperature refTemperature_max = 363.15 "Reference temperature for maximum filling level";
  parameter SI.Temperature refTemperature= 293.15 "Reference temperature for minimal filling level in K ";
  final parameter SI.SpecificEnthalpy h_ref=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(medium,1e5,refTemperature) "for calculation of stored energy";
   // Fluid ports for fluid from solar something else
   parameter Boolean Use_Solar =  true "Solar fluid in and outflow"
   annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true),Dialog(group="Ports"));
  final parameter Integer Use_Solar_Int= if Use_Solar then 1 else 0 "Has to be 1 if Use_Solar is true. Has to be 0 if Solar_Use is false";

  // Heat ports for electric heatings or something else
  parameter Boolean Use_HeatPorts = true "Tank gets a heat flow from elelctrode"
   annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true),Dialog(group="Ports"));
  parameter Integer nHeatPorts = 1 "Segment the heating electrode is connected to"
    annotation(Dialog(group="Ports", enable=Use_HeatPorts));
   parameter Boolean Add_ElectricHeater =  false "Add Electric Heater to Storage"
   annotation(Evaluate=true, HideResult=true, choices(__Dymola_checkBox=true),Dialog(group="Ports"));
  // Fluid ports for fluid from solar something else
  constant Boolean Add_FluidPorts = false "Add an arbitrary number of fluid ports"
    annotation(Evaluate=false, HideResult=true, choices(__Dymola_checkBox=true), Dialog(group="Ports"));
  final parameter Integer Add_FluidPorts_Int = if Add_FluidPorts then 10 else 0 "Add an arbitrary number of fluid ports";
  parameter Integer nAdditionalFluidPorts = 2 "Choose the number of additional fluid ports"
    annotation(Dialog(group="Ports", enable=false));

  replaceable model CostVariables = TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.SmallHotWaterStorage  constrainedby TransiEnt.Components.Statistics.ConfigurationData.StorageCostSpecs.PartialStorageCostSpecs
                                                                                                                                                                                                "Define storage type for cost calcualtions" annotation (choicesAllMatching=true, Dialog(group="Statistics"));

  parameter SI.Temperature T_init[nSeg] = ones(nSeg)*(80+273.15) annotation(Dialog(group="Initialization"));
  // _____________________________________________
  //
  //                   Final Parameter
  // _____________________________________________

  final parameter SI.SpecificEnthalpy h_start[nSeg]=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
      medium,
      p_nom,
      T_init) "Start value of sytsem specific enthalpy" annotation(Dialog(group="Heating condenser parameters"));

final parameter Integer used_Ports_Int = Use_Solar_Int + Add_FluidPorts_Int "Describes which ports are in use";

  final parameter Integer nPorts= if used_Ports_Int == 0 then 4
  elseif used_Ports_Int == 1 then 5 + solarInPortGeometry.nSolar
  elseif used_Ports_Int == 10 then 4 + nAdditionalFluidPorts
  else 5 + solarInPortGeometry.nSolar + nAdditionalFluidPorts "Number of external fluid ports";

  final parameter Integer[nSeg] PortCountVector=if used_Ports_Int == 0 then
      Utilities.get_PortCountVector_noSolar(
      nSeg,
      Geo_inletCHP.segment,
      Geo_outletCHP.segment,
      Geo_inletGrid.segment,
      Geo_outletGrid.segment) elseif used_Ports_Int == 1 then
      Utilities.get_PortCountVector(
      nSeg,
      Geo_inletCHP.segment,
      Geo_outletCHP.segment,
      Geo_inletGrid.segment,
      Geo_outletGrid.segment,
      solarInPortGeometry.nSolar,
      solarInPortGeometry.segment,
      Geo_outletSolar.segment) elseif used_Ports_Int == 10 then
      Utilities.get_PortCountVector_noSolar_addPorts(
      nSeg,
      Geo_inletCHP.segment,
      Geo_outletCHP.segment,
      Geo_inletGrid.segment,
      Geo_outletGrid.segment,
      nAdditionalFluidPorts,
      Geo_addPorts[:].segment) else Utilities.get_PortCountVector_addPorts(
      nSeg,
      Geo_inletCHP.segment,
      Geo_outletCHP.segment,
      Geo_inletGrid.segment,
      Geo_outletGrid.segment,
      solarInPortGeometry.nSolar,
      solarInPortGeometry.segment,
      Geo_outletSolar.segment,
      nAdditionalFluidPorts,
      Geo_addPorts[:].segment) "Vector contains the number of ports for each segement";

 final parameter Integer ports[nPorts]=
if used_Ports_Int == 0 then Utilities.get_Ports_noSolar(
     nSeg,
     Geo_inletCHP.segment,
     Geo_outletCHP.segment,
     Geo_inletGrid.segment,
     Geo_outletGrid.segment)
 elseif used_Ports_Int == 1 then Utilities.get_Ports(
     nSeg,
     Geo_inletCHP.segment,
     Geo_outletCHP.segment,
     Geo_inletGrid.segment,
     Geo_outletGrid.segment,
     solarInPortGeometry.nSolar,
     solarInPortGeometry.segment,
     Geo_outletSolar.segment)
 elseif used_Ports_Int == 10 then Utilities.get_Ports_noSolar_addPorts(
     nSeg,
     Geo_inletCHP.segment,
     Geo_outletCHP.segment,
     Geo_inletGrid.segment,
     Geo_outletGrid.segment,
     nAdditionalFluidPorts,
  Geo_addPorts[:].segment)
 else Utilities.get_Ports_addPorts(
     nSeg,
     Geo_inletCHP.segment,
     Geo_outletCHP.segment,
     Geo_inletGrid.segment,
     Geo_outletGrid.segment,
     solarInPortGeometry.nSolar,
     solarInPortGeometry.segment,
     Geo_outletSolar.segment,
     nAdditionalFluidPorts,
  Geo_addPorts[:].segment) "Vector contains for each in and outlet the port number to connect";

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  // Fluid
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn inletGrid(final Medium=medium) annotation (Placement(transformation(extent={{90,-70},{110,-50}}), iconTransformation(extent={{90,-60},{110,-40}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut outletGrid(final Medium=medium) annotation (Placement(transformation(extent={{90,-30},{110,-10}}), iconTransformation(extent={{90,30},{110,50}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn inletCHP(final Medium=medium) annotation (Placement(transformation(extent={{-110,46},{-90,66}}), iconTransformation(extent={{-110,50},{-90,70}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut outletCHP(final Medium=medium) annotation (Placement(transformation(extent={{-110,-50},{-90,-30}}), iconTransformation(extent={{-110,-20},{-90,0}})));
  // Fluid if Use_Solar
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn inletSolar(final Medium=medium) if
                            Use_Solar annotation (Placement(transformation(extent={{-110,0},{-90,20}}), iconTransformation(extent={{-110,20},{-90,40}})));
  TransiEnt.Basics.Interfaces.Thermal.FluidPortOut outletSolar(final Medium=medium) if
                            Use_Solar annotation (Placement(transformation(extent={{-110,-90},{-90,-70}}), iconTransformation(extent={{-110,-50},{-90,-30}})));
    //Fluid if add_FluidPorts
  TransiEnt.Basics.Interfaces.Thermal.FluidPortIn[nAdditionalFluidPorts] AdditionalFluidPorts(each final Medium=medium) if
                                     Add_FluidPorts annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

  // Thermal
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatLosses "Heat losses to ambient (Connect with ambient temperature)"
    annotation (Placement(transformation(extent={{14,74},{38,98}}),iconTransformation(extent={{50,75},{70,95}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPorts[nHeatPorts] if
       Use_HeatPorts "Heat ports to connect storage with externals heat sources/sinks"
    annotation (Placement(transformation(extent={{-26,74},{-2,98}}),iconTransformation(extent={{-10,75},{10,95}})));
  //Electrical
   TransiEnt.Basics.Interfaces.Electrical.ApparentPowerPort epp if
       Add_ElectricHeater annotation (Placement(transformation(extent={{-94,90},{-74,110}})));
  // Outputs
  TransiEnt.Basics.Interfaces.General.TemperatureOut maxTemperature "Maximum temperature in tank"
                                  annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={-56,90})));
  TransiEnt.Basics.Interfaces.General.TemperatureOut minTemperature "Minimum Temperature in the storage"
                                         annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={-56,76})));
  Modelica.Blocks.Interfaces.RealOutput storedEnergie(  final quantity= "Energy in the storage", final unit="J", displayUnit="J")
    annotation (Placement(transformation(extent={{-48,52},{-64,68}})));
  TransiEnt.Basics.Interfaces.General.TemperatureOut averageTemperature "Temperature average based on the mass"
                                            annotation (Placement(
        transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={-56,44})));

  Modelica.Blocks.Interfaces.RealOutput relativeStorageFilling "values between zero and one" annotation (Placement(transformation(extent={{96,82},{112,98}})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut heatOutFlow annotation (Placement(transformation(extent={{96,60},{112,76}})));

  // Statistics (TODO: Nominal capacity has to be defined properly)
  TransiEnt.Components.Statistics.Collectors.LocalCollectors.StorageCost collectCosts_Storage(
    redeclare model StorageCostModel = CostVariables,
    isThermalStorage=true,
    Q_flow_is=heatOutFlow,
    Delta_E_n=(maxTemperature_allowed - refTemperature)*Geometry.volume*1e3*4.2e3,
    produces_P_el=false,
    consumes_P_el=false)                                                           annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

  // _____________________________________________
  //
  //                  Complex Models
  // _____________________________________________
  // replaceable models
  Base.Cylindric_Geometry Geometry(
    height=Height,
    volume=Volume,
    final nSeg=nSeg) annotation (choicesAllMatching=true, Placement(transformation(extent={{-38,-78},{-22,-62}})));

  replaceable TransiEnt.Storage.Heat.HotWaterStorage_L4.Base.FlatWall_HeatConduction ConductanceTop(final A_heat=Geometry.A_top, width=if Add_ElectricHeater then 0.2 else 0.1) constrainedby TransiEnt.Storage.Heat.HotWaterStorage_L4.Base.Partial_HeatTransfer "Defines the heat conductance at the top of the storage" annotation (
    Dialog(group="Heat Losses"),
    choicesAllMatching=true,
    Placement(transformation(extent={{74,60},{90,76}})));

  replaceable Base.CylindricWall_HeatTransfer[nSeg] ConductanceWall(each final height=Geometry.height_Seg, each radius=Geometry.diameter/2) constrainedby TransiEnt.Storage.Heat.HotWaterStorage_L4.Base.Partial_HeatTransfer
                                                                                                                                                                                                "Defines the heat conductance at the side walls of the storage" annotation (
    Dialog(group="Heat Losses"),
    choicesAllMatching=true,
    Placement(transformation(extent={{74,36},{90,52}})));

  replaceable Base.FlatWall_HeatConduction ConductanceBottom(final A_heat=Geometry.A_bottom) constrainedby TransiEnt.Storage.Heat.HotWaterStorage_L4.Base.Partial_HeatTransfer
                                                                                                                                                                           "Defines the heat conductance at the bottom of the storage" annotation (
    Dialog(group="Heat Losses"),
    choicesAllMatching=true,
    Placement(transformation(extent={{74,12},{90,28}})));

 // not replaceable models

 // Volumes
  Base.Fluid_Volume[nSeg] Tank_Volume(
    final nPorts=PortCountVector,
    final V_const=Geometry.volume_Seg,
    each final medium=medium,
    each p_nom=p_nom,
    each h_nom=h_nom,
    h_start=h_start) "Fluid Volumes the storage is divided in" annotation (Placement(transformation(
        extent={{-15,-16},{15,16}},
        rotation=-90,
        origin={-22,-7})));

  Base.Buoyancy Buo(
    tau=1,
    final nSeg=nSeg,
    final V=Geometry.volume,
    final medium=medium) "Models buoyancy due adding heat flows" annotation (Placement(transformation(extent={{56,-20},{32,4}})));

  Base.ThermalConductor_Fluid[nSeg - 1] ConFluid(
    final A_heat=Geometry.A_cross,
    each final height_Seg=Geometry.height_Seg,
    each k=0.67) "Thermal conductance between fluid segments" annotation (Placement(transformation(extent={{0,42},{-20,62}})));

    Modelica.Thermal.HeatTransfer.Components.ThermalConductor ConTop(
      final G= ConductanceTop.lambda) "Thermal conductance at top of storage"
    annotation (Placement(transformation(extent={{30,58},{50,78}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor[nSeg] ConWall(
      final G= ConductanceWall[1:nSeg].lambda) "Thermal conductance through side wall of storage"
    annotation (Placement(transformation(extent={{30,34},{50,54}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor ConBottom(
      final G= ConductanceBottom.lambda) "Thermal conductance at bottom of storage"
    annotation (Placement(transformation(extent={{30,10},{50,30}})));

    Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector(
    final m= nSeg+2) "Collects the thermal losses from top, sidewall and bottom"
         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={60,78})));

  TransiEnt.Storage.Heat.HotWaterStorage_L4.Base.PortGeometry HeaPortsGeometry[nHeatPorts](
    each final nSeg=nSeg,
    each final height_segment=Geometry.height_Seg,
    height_port={Height_port}) "Heights the heatPorts are connected to the storage" annotation (Placement(transformation(extent={{-36,80},{-24,92}})));
                                        //if Use_HeatPorts

    //if Use_Solar
  Base.FlowSplit flowSplit(
    final nOutPorts=solarInPortGeometry.nSolar,
    final layerTemperatures=Tank_Volume[solarInPortGeometry.segment - solarInPortGeometry.nSolar + 1:solarInPortGeometry.segment].T,
    final medium=medium) if
    Use_Solar "distributes the fluid flow from the solar heating to the storage segments " annotation (Placement(transformation(extent={{-70,20},{-48,-2}})));

    // Port geometries
  Base.PortGeometry Geo_outletCHP(
    final nSeg=nSeg,
    final height_segment=Geometry.height_Seg,
    height_port=0.2) annotation (Placement(transformation(extent={{-88,-28},{-76,-16}})));
  Base.PortGeometry Geo_inletCHP(
    final nSeg=nSeg,
    final height_segment=Geometry.height_Seg,
    height_port=1.6) annotation (Placement(transformation(extent={{-92,68},{-80,80}})));
  Base.PortGeometry Geo_inletGrid(
    final nSeg=nSeg,
    final height_segment=Geometry.height_Seg,
    height_port=0.2) annotation (Placement(transformation(extent={{80,-86},{94,-72}})));
  Base.PortGeometry Geo_outletGrid(
    final nSeg=nSeg,
    final height_segment=Geometry.height_Seg,
    height_port=1.6) annotation (Placement(transformation(extent={{80,-10},{94,4}})));
  Base.PortGeometry Geo_outletSolar(
    final nSeg=nSeg,
    final height_segment=Geometry.height_Seg,
    height_port=0.2) annotation (Placement(transformation(extent={{-92,-72},{-80,-60}})));

    // Port geometry solar in
  Base.SolarInPortGeometry solarInPortGeometry(
    final nSeg=nSeg,
    final height_segment=Geometry.height_Seg,
    height_port=1,
    length_port=0.3) annotation (Placement(transformation(extent={{-88,-8},{-76,4}})));

    // Port geometries if Add_Ports
  Base.PortGeometry[nAdditionalFluidPorts] Geo_addPorts(
    each final nSeg=nSeg,
    each final height_segment=Geometry.height_Seg,
    height_port={1,1}) annotation (Placement(transformation(extent={{-32,-100},{-16,-84}})));
    // Electric Heater if Add_ElectricHeater

  Base.HeatingElectrode heatingElectrode if       Add_ElectricHeater annotation (Placement(transformation(extent={{-28,58},{-48,78}})));
  // _____________________________________________
  //
  //                Algorithms
  // _____________________________________________
  parameter SI.Pressure p_nom=1e5 "Nominal pressure of fluid in tank";
  parameter SI.SpecificEnthalpy h_nom=1e5 "Nominal specific enthalpy of fluid in tank";
algorithm
   storedEnergie := sum(Tank_Volume.h*Tank_Volume.m)-h_ref*sum(Tank_Volume.m);
   maxTemperature := max(Tank_Volume.T);
   minTemperature := min(Tank_Volume.T);
   averageTemperature := (Tank_Volume.T*Tank_Volume.m)/sum(Tank_Volume.m);
   relativeStorageFilling:= (averageTemperature-refTemperature)/(maxTemperature_allowed-refTemperature);

  // _____________________________________________
  //
  //           Equations
  // _____________________________________________
equation
  // Conditions to terminate simulation
  assert(maxTemperature<maxTemperature_allowed,"Heat storage too hot. Adjust your control!");
  assert(minTemperature_allowed<minTemperature,"Heat storage too cold. Danger of freezing. Adjust your control!");
  assert(nSeg>nSeg_min-1,"Use more tank segments. The allowed minimum is " +String(nSeg_min)+ " segments");

  heatOutFlow= outletGrid.m_flow*(outletGrid.h_outflow-inletGrid.h_outflow);

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
       for i in 1:nSeg-2 loop
 //Fluid connection of Volumes
    connect(Tank_Volume[i].ports[1], Tank_Volume[i + 1].ports[2]);
       end for;

  //Fluid connection of Volumes (between last two volumes)
    connect(Tank_Volume[nSeg-1].ports[1], Tank_Volume[nSeg].ports[1]);

     for i in 1:nSeg-1 loop
 // Thermal connection of volumes
    connect(ConFluid[i].port_b, Tank_Volume[i + 1].heatPort) annotation (Line(
        points={{-20,52},{-26,52},{-26,40},{-6.64,40},{-6.64,-7}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(ConFluid[i].port_a, Tank_Volume[i].heatPort) annotation (Line(
        points={{0,52},{4,52},{4,-7},{-6.64,-7}},
        color={191,0,0},
        smooth=Smooth.None));
     end for;

  // Connection between fluid ports and volume
   connect(inletCHP, Tank_Volume[Geo_inletCHP.segment].ports[ports[1]]) annotation (Line(
      points={{-100,56},{-84,56},{-84,36},{-38,36},{-38,-6}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(outletCHP, Tank_Volume[Geo_outletCHP.segment].ports[ports[2]]) annotation (Line(
      points={{-100,-40},{-66,-40},{-66,-16},{-46,-16},{-46,-8},{-38,-8}},
      color={175,0,0},
      smooth=Smooth.None));

  connect(inletGrid, Tank_Volume[Geo_inletGrid.segment].ports[ports[3]]) annotation (Line(
      points={{100,-60},{38,-60},{38,-42},{-38,-42},{-38,-8},{-36,-8}},
      color={175,0,0},
      smooth=Smooth.None));
  connect(outletGrid, Tank_Volume[Geo_outletGrid.segment].ports[ports[4]]) annotation (Line(
      points={{100,-20},{60,-20},{60,-28},{-38,-28},{-38,-6}},
      color={175,0,0},
      smooth=Smooth.None));
if Use_Solar then
  connect(inletSolar, flowSplit.port_in) annotation (Line(
      points={{-100,10},{-80,10},{-80,20},{-59,20}},
      color={175,0,0},
      smooth=Smooth.None));
  for i in 1:solarInPortGeometry.nSolar loop
  connect(flowSplit.ports_out[i], Tank_Volume[solarInPortGeometry.segment-solarInPortGeometry.nSolar+i].ports[ports[4+i]]) annotation (Line(
      points={{-59.22,1.52},{-38,1.52},{-38,-22}},
      color={175,0,0},
      smooth=Smooth.None));
  end for;
  connect(outletSolar,
    Tank_Volume[Geo_outletSolar.segment].ports[ports[4+solarInPortGeometry.nSolar+1]]) annotation (Line(
      points={{-100,-80},{-62,-80},{-62,-20},{-38,-20},{-38,-8},{-34,-8},{-34,-6}},
      color={175,0,0},
      smooth=Smooth.None));
end if;

  // Connection between Buo and volume
  connect(Buo.heatPort, Tank_Volume.heatPort) annotation (Line(
      points={{33.2,-7.28},{30,-7.28},{30,-7},{-6.64,-7}},
      color={191,0,0},
      smooth=Smooth.None));
  // Connection between volume.heatPort and heat conduction models
  connect(ConTop.port_a, Tank_Volume[1].heatPort) annotation (Line(
      points={{30,68},{14,68},{14,-7},{-6.64,-7}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ConWall[1:nSeg].port_a, Tank_Volume[1:nSeg].heatPort) annotation (Line(
      points={{30,44},{20,44},{20,-7},{-6.64,-7}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Tank_Volume[nSeg].heatPort,ConBottom. port_a) annotation (Line(
      points={{-6.64,-7},{26,-7},{26,20},{30,20}},
      color={191,0,0},
      smooth=Smooth.None));
  // Connection between heat conduction models and thermal collector
  connect(ConTop.port_b, thermalCollector.port_a[1]) annotation (Line(
      points={{50,68},{60,68}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ConWall.port_b, thermalCollector.port_a[2:nSeg+1]) annotation (Line(
      points={{50,44},{60,44},{60,68}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ConBottom.port_b, thermalCollector.port_a[nSeg+2]) annotation (Line(
      points={{50,20},{60,20},{60,68}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(thermalCollector.port_b, heatLosses) annotation (Line(
      points={{60,88},{44,88},{44,86},{26,86}},
      color={191,0,0},
      smooth=Smooth.None));
  // Connection between Tank volume and heat ports
  if Use_HeatPorts then
    for i in  1:nHeatPorts loop
    connect(heatPorts[i], Tank_Volume[HeaPortsGeometry[i].segment].heatPort) annotation (Line(
      points={{-14,86},{4,86},{4,-8},{-7.2,-8}},
      color={191,0,0},
      smooth=Smooth.None));
    end for;
  end if;

   //Connection if Add_Ports
 if used_Ports_Int == 10 then
 for i in 1:nAdditionalFluidPorts loop
       connect(AdditionalFluidPorts[i], Tank_Volume[Geo_addPorts[i].segment].ports[ports[4+i]]);
 end for;
 elseif used_Ports_Int == 11 then
 for i in 1:nAdditionalFluidPorts loop
       connect(AdditionalFluidPorts[i], Tank_Volume[Geo_addPorts[i].segment].ports[ports[5 + solarInPortGeometry.nSolar + i]]);
 end for;
 end if;

 connect(modelStatistics.costsCollector, collectCosts_Storage.costsCollector);
 if Add_ElectricHeater then
     connect(heatingElectrode.heat, heatPorts[1]) annotation (Line(
      points={{-29.4,68},{-14,68},{-14,86}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatingElectrode.epp, epp) annotation (Line(
      points={{-38,76.8},{-38,88},{-84,88},{-84,100}},
      color={0,127,0},
      smooth=Smooth.None));
  end if;
// _____________________________________________
//
//               Documentation
// _____________________________________________

  annotation (Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b> </p>
<p>One dimensional fluid storage model with stratification. Intention of the model is to represent a hot water storage in a bigger system with more accurate outflow temperatures compared to a zero dimensional storage model. </p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>L4: Storage is diveded in layered volumes. Each volume is ideally stirred. Between the fluid volumes heat conduction and boyancy are considered. </p>
<p>Heat losses to the ambient are simplified as heat conduction through top, side wall and bottom. </p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>The storage model includes just a vertical temperature distribution. No horizontal temperature distribution is modeled. Mixing effects due to the velocity of the fluid at inlets an outlets are not modelled. </p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<h5>Heat</h5>
<p>heatLosses: ambient temperature and the collected heat flow to the ambient through top, side wall and bottom</p>
<p>heatPorts(optinal): temperature of connected fluid volume and heat flow to or from the fluid volume </p>
<h5>Fluid</h5>
<p>inletCHP: fluid connection from CHP, fluid flows to the storage </p>
<p>outletCHP: fluid connection to CHP, fluid flows from the storage </p>
<p>inletGrid: fluid connection from heating grid, fluid flows to the storage</p>
<p>outletGrid: fluid connection to heating Grid, fluid flows from the storage</p>
<p>inletSolar (optional): fluid connection from solar thermie, fluid flows depending on the temperature to different storage layers </p>
<p>outletSolar (optional): fluid connection to Solar thermie system, fluid flows from solar thermie to the storage</p>
<p>addPorts (optional): a various number of fluid connections to other components for example chiler. </p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p><br>Just parameters and of the main model are described. Further explanations are in the sub models. medium: medium in the hot water storage. Has to be one phase fluid from the TILMedia library</p>
<p><br>nSeg: number of vertical layered fluid segments</p>
<p><br>maxTemperature_allowed: maximum allowed temperatur inside the storage</p>
<p><br>minTemperature_allowed: minimum allowed temperatur inside the storage</p>
<p><br>Use_Solar(Boolean): if true the ports inletSolar and outletSolar are active</p>
<p><br>Use_HeatPorts(Boolean): if true heatPorts is active</p>
<p><br>nHeatPorts: number of heat ports</p>
<p><br>nAdditionalFluidPorts: number of additional fluid ports </p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>Energy and mass or volume balance inside every volume segment. Heat losses due to one dimensional thermal conductance through top, bottom and side wall. Thermal conductance between volume segments. Modeled boyancy introducing heat flow from lower to higher segment if the lower segemnt has a higher temperature. Direct fluid connection between the volumes. <img src=\"modelica://TransiEnt/Images/waermespeicher_modell_eng.png\"/> </p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>The allowed minimum number of volume segements is two. The higher the number of segments the higher the number of equations. </p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>The model is validated with hot water storage Vitocell 160E. The storage tank has a capacity of 1000 liters and an inner height of 1.88 metres (without insulation). The tank has multiple fluid inflow and outflow connections. The storage is used for climatisation and is installted at TUHH for research purposes. The model is validated against measurements and simulations from Harmsen. Parts of the Validation are shown in the figures below. The temperatures in the storage have been measured in four different heights (red: 1.592m, blue: 1.044m, green: 0.618m, black: 0.293m). The dotted lines show the measured temperatures, the dashed lines the temperatures from a reference simulation and the solid lines the temperatures of this model. The following picture shows the overnight cooling while no fluid flows entered or left the storage. The simulation was done with disretizing the storage in ten segemnts. <img src=\"modelica://TransiEnt/Images/validation_night.png\"/> </p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Tobias Ramm (tobias.ramm@tuhh.de), Mar 2015</p>
<p>Revised and edited by Lisa Andresen (andresen@tuhh.de), Jun 2015</p>
</html>"),
    Diagram(graphics,
            coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end HotWaterStorage_L4;
