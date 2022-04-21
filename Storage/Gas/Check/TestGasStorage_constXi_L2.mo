within TransiEnt.Storage.Gas.Check;
model TestGasStorage_constXi_L2


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

  //values from Olmos, Fernando ; Manousiouthakis, Vasilios I.: Hydrogen car fill-up process modeling and simulation. In: International Journal of Hydrogen Energy 38 (2013), Nr. 8, S. 3401–3418.

  parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2 medium;

  parameter Modelica.Units.SI.SpecificHeatCapacity cp_steel316=468 "Heat capacity of steel 316 (station tank and pipes)";

  parameter Modelica.Units.SI.ThermodynamicTemperature T_start_1=300.15 "Start temperature in pipe_54, at outlet of pipe_32, pipe_32 and its wall, station_tank and its wall";
  parameter Modelica.Units.SI.ThermodynamicTemperature T_start_2=286.64 "Start temperature in vehicle_tank and its wall";
  parameter Modelica.Units.SI.Pressure p_start_1=415.41e5 "Start pressure in pipe_54, station_tank";
  parameter Modelica.Units.SI.Pressure p_start_2=138.01e5 "Start pressure in vehicle_tank, pipe_32";

  parameter Modelica.Units.SI.SpecificEnthalpy h_start_1=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
      vleFluidType=medium,
      p=p_start_1,
      T=T_start_1) "Start enthalpy for pipe_54";
  parameter Modelica.Units.SI.SpecificEnthalpy h_start_2=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(
      vleFluidType=medium,
      p=p_start_2,
      T=T_start_1) "Start enthalpy for pipe_32 and its outlet";

  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple pipe_54(
    medium=medium,
    constantComposition=true,
    frictionAtInlet=false,
    frictionAtOutlet=true,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4,
    diameter_i=0.008,
    length=15.24,
    p_start=p_start_1*ones(pipe_54.N_cv),
    h_start=h_start_1*ones(pipe_54.N_cv),
    heatTransfer(alpha_nom=6000),
    initOption=0,
    N_cv=1,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L4) annotation (Placement(transformation(extent={{-70,-5},{-42,5}})));
                                                                         //length like given in the paper, d_i scaled with 1/10

  TransiEnt.Components.Gas.VolumesValvesFittings.Pipes.PipeFlow_L4_Simple pipe_32(
    medium=medium,
    constantComposition=true,
    frictionAtInlet=true,
    frictionAtOutlet=false,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4,
    diameter_i=0.008,
    length=1.52,
    p_start=p_start_2*ones(pipe_32.N_cv),
    h_start=h_start_2*ones(pipe_32.N_cv),
    heatTransfer(alpha_nom=6000),
    initOption=0,
    N_cv=1,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L4) annotation (Placement(transformation(extent={{42,-5},{70,5}})));
                                                                      //length like given in the paper, d_i scaled with 1/10

  TransiEnt.Storage.Gas.GasStorage_constXi_L2 station_tank(
    medium=medium,
    V_geo=0.6,
    includeHeatTransfer=true,
    redeclare model HeatTransfer = Base.ConstantHTOuterTemperature_L2 (alpha_nom=4),
    p_gas_start=p_start_1,
    T_gas_start=T_start_1,
    Cspec_demAndRev_el=simCenter.Cspec_demAndRev_el_70_150_GWh,
    redeclare model CostSpecsStorage = Components.Statistics.ConfigurationData.GeneralCostSpecs.HydrogenBufferStorage,
    p_max=8200000) annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-90,0})));
  TransiEnt.Storage.Gas.GasStorage_constXi_L2 vehicle_tank(
    medium=medium,
    V_geo=0.108,
    includeHeatTransfer=true,
    redeclare model HeatTransfer = Base.ConstantHTOuterTemperature_L2 (alpha_nom=60),
    p_gas_start=p_start_2,
    T_gas_start=T_start_2,
    Cspec_demAndRev_el=simCenter.Cspec_demAndRev_el_70_150_GWh,
    redeclare model CostSpecsStorage = Components.Statistics.ConfigurationData.GeneralCostSpecs.HydrogenBufferStorage,
    p_max=8200000) annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={90,0})));

  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 wall_pipe_54(
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=1,
    diameter_i=pipe_54.diameter_i,
    length=pipe_54.length,
    diameter_o=0.0142,
    T_start=T_start_1*ones(wall_pipe_54.N_ax))
                          annotation (Placement(transformation(extent={{-66,18},{-46,28}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 wall_pipe_32(
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=1,
    diameter_i=pipe_32.diameter_i,
    length=pipe_32.length,
    diameter_o=0.0094,
    T_start=T_start_1*ones(wall_pipe_32.N_ax))                     annotation (Placement(transformation(extent={{46,18},{66,28}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 wall_station_tank(
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=1,
    diameter_i=0.5232,
    diameter_o=0.7173,
    length=2.494,
    T_start=T_start_1*ones(wall_station_tank.N_ax))
                 annotation (Placement(transformation(extent={{-100,18},{-80,28}})));       // assumed to be spherical --> d_i=0.5232
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 wall_vehicle_tank(
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=1,
    diameter_i=0.2954,
    diameter_o=0.3636,
    length=2.521,
    T_start=T_start_2*ones(wall_vehicle_tank.N_ax))
                 annotation (Placement(transformation(extent={{80,18},{100,28}})));       // assumed to be spherical --> d_i=0.2954

  Base.ConstantHTOuterTemperature_L2 ht_pipe_54(alpha_nom=8, A_heat=0.68)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-56,50}))); //area like given in the paper
  Base.ConstantHTOuterTemperature_L2 ht_pipe_32(alpha_nom=8, A_heat=0.045)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={56,50}))); //area like given in the paper
  Base.ConstantHTOuterTemperature_L2 ht_station_tank(alpha_nom=3, A_heat=5.62)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-90,50}))); //cylindrical wall
  Base.ConstantHTOuterTemperature_L2 ht_vehicle_tank(alpha_nom=6, A_heat=2.88)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,50}))); //cylindrical wall

  Modelica.Blocks.Sources.Constant T_amb(k=300.15)
                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,86})));
  Modelica.Blocks.Sources.RealExpression targetMassFlow(y=-1.14202018176808e-9*time^3 + 3.4731974604687e-7*time^2 - 3.28191649003198e-5*time + 0.006168056759338) annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Components.Gas.VolumesValvesFittings.Valves.ValveDesiredMassFlow valve43(
    medium=medium,
    Delta_p_low=1,
    Delta_p_high=10) annotation (Placement(transformation(extent={{-10,5},{10,-7}})));
  Components.Sensors.RealGas.TemperatureSensor temp4(medium=medium) annotation (Placement(transformation(extent={{-36,0},{-16,20}})));
  Components.Sensors.RealGas.TemperatureSensor temp3(medium=medium) annotation (Placement(transformation(extent={{16,0},{36,20}})));
  inner ModelStatistics                                                   modelStatistics annotation (Placement(transformation(extent={{-70,-60},{-50,-40}})));
  Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow(medium=medium) annotation (Placement(transformation(extent={{-124,-10},{-104,10}})));
  Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow1(medium=medium) annotation (Placement(transformation(extent={{126,-10},{106,10}})));
equation

  connect(wall_pipe_54.innerPhase[1], pipe_54.heat[1]) annotation (Line(
      points={{-56,18},{-56,3.33333}},
      color={167,25,48},
      thickness=0.5));
  connect(wall_pipe_32.innerPhase[1], pipe_32.heat[1]) annotation (Line(
      points={{56,18},{56,3.33333}},
      color={167,25,48},
      thickness=0.5));
  connect(wall_pipe_32.outerPhase[1], ht_pipe_32.heat) annotation (Line(
      points={{56,28},{56,28},{56,40}},
      color={167,25,48},
      thickness=0.5));
  connect(wall_station_tank.outerPhase[1], ht_station_tank.heat) annotation (Line(
      points={{-90,28},{-90,28},{-90,40}},
      color={167,25,48},
      thickness=0.5));
  connect(wall_station_tank.innerPhase[1], station_tank.heat) annotation (Line(
      points={{-90,18},{-90,4}},
      color={167,25,48},
      thickness=0.5));
  connect(wall_vehicle_tank.outerPhase[1], ht_vehicle_tank.heat) annotation (Line(
      points={{90,28},{90,40}},
      color={167,25,48},
      thickness=0.5));
  connect(ht_pipe_54.heat, wall_pipe_54.outerPhase[1]) annotation (Line(
      points={{-56,40},{-56,40},{-56,28}},
      color={167,25,48},
      thickness=0.5));
  connect(wall_vehicle_tank.innerPhase[1], vehicle_tank.heat) annotation (Line(
      points={{90,18},{90,4}},
      color={167,25,48},
      thickness=0.5));
  connect(T_amb.y, ht_station_tank.T_outer) annotation (Line(points={{-1.9984e-015,75},{-1.9984e-015,78},{-1.9984e-015,68},{-90,68},{-90,60}},
                                                                                              color={0,0,127}));
  connect(ht_pipe_32.T_outer, T_amb.y) annotation (Line(points={{56,60},{56,60},{56,68},{0,68},{0,72},{0,72},{0,75},{-2.22045e-015,75}},           color={0,0,127}));
  connect(ht_vehicle_tank.T_outer, T_amb.y) annotation (Line(points={{90,60},{90,60},{90,68},{0,68},{0,75},{-2.22045e-015,75}},
                                                                                              color={0,0,127}));
  connect(ht_pipe_54.T_outer, T_amb.y) annotation (Line(points={{-56,60},{-56,60},{-56,68},{0,68},{0,75},{-1.9984e-015,75}},                    color={0,0,127}));
  connect(vehicle_tank.gasPortIn, pipe_32.gasPortOut) annotation (Line(
      points={{85.1,4.44089e-16},{85.1,0},{70,0}},
      color={255,255,0},
      thickness=0.75));
  connect(station_tank.gasPortOut, pipe_54.gasPortIn) annotation (Line(
      points={{-83.7,-1.11022e-15},{-83.7,0},{-70,0}},
      color={255,255,0},
      thickness=0.5));
  connect(targetMassFlow.y, valve43.m_flowDes) annotation (Line(points={{-29,-20},{-20,-20},{-20,-5.28571},{-10,-5.28571}},
                                                                                                                color={0,0,127}));
  connect(temp4.gasPortIn, pipe_54.gasPortOut) annotation (Line(
      points={{-36,0},{-42,0}},
      color={255,255,0},
      thickness=1.5));
  connect(temp4.gasPortOut, valve43.gasPortIn) annotation (Line(
      points={{-16,0},{-10,0},{-10,-0.142857}},
      color={255,255,0},
      thickness=1.5));
  connect(valve43.gasPortOut, temp3.gasPortIn) annotation (Line(
      points={{10,-0.142857},{13,0},{16,0}},
      color={255,255,0},
      thickness=1.5));
  connect(temp3.gasPortOut, pipe_32.gasPortIn) annotation (Line(
      points={{36,0},{42,0}},
      color={255,255,0},
      thickness=1.5));
  connect(boundary_Txim_flow.gasPort, station_tank.gasPortIn) annotation (Line(
      points={{-104,0},{-94.9,0}},
      color={255,255,0},
      thickness=1.5));
  connect(boundary_Txim_flow1.gasPort, vehicle_tank.gasPortOut) annotation (Line(
      points={{106,0},{96.3,0}},
      color={255,255,0},
      thickness=1.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-60},{140,100}})),  experiment(
      StopTime=216,
      Interval=0.008,
      __Dymola_Algorithm="Sdirk34hw"),
    Icon(graphics,
         coordinateSystem(extent={{-140,-60},{140,100}})),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<p><b><span style=\"color: #008000;\">3. Limits of validity</span></b> </p>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #4b8a49\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) in Sep 2016</p>
<p>Model revised by Carsten Bode (c.bode@tuhh.de) in Apr 2018 (changes due to ClaRa changes: exchanged wall models)</p>
</html>"));
end TestGasStorage_constXi_L2;
