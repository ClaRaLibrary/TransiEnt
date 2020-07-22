within TransiEnt.Storage.Gas.Check;
model TestGasStorageVesselHeatTransfer_L2
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2020, Hamburg University of Technology.                              //
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
  extends TransiEnt.Basics.Icons.Checkmodel;

  //values from Olmos, Fernando ; Manousiouthakis, Vasilios I.: Hydrogen car fill-up process modeling and simulation. In: International Journal of Hydrogen Energy 38 (2013), Nr. 8, S. 3401–3418.

  parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2 medium;

  parameter Modelica.SIunits.SpecificHeatCapacity cp_steel316=468 "Heat capacity of steel 316 (station tank and pipes)";

  parameter Modelica.SIunits.ThermodynamicTemperature T_start_1=300.15 "Start temperature in pipe_54, at outlet of pipe_32, pipe_32 and its wall, station_tank and its wall";
  parameter Modelica.SIunits.ThermodynamicTemperature T_start_2=286.64 "Start temperature in vehicle_tank and its wall";
  parameter Modelica.SIunits.Pressure p_start_1=415.41e5 "Start pressure in pipe_54, station_tank";
  parameter Modelica.SIunits.Pressure p_start_2=138.01e5 "Start pressure in vehicle_tank, pipe_32";

  parameter Modelica.SIunits.SpecificEnthalpy h_start_1=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(vleFluidType=medium, p=p_start_1, T=T_start_1) "Start enthalpy for pipe_54";
  parameter Modelica.SIunits.SpecificEnthalpy h_start_2=TILMedia.Internals.VLEFluidConfigurations.FullyMixtureCompatible.VLEFluidFunctions.specificEnthalpy_pTxi(vleFluidType=medium, p=p_start_2, T=T_start_1) "Start enthalpy for pipe_32 and its outlet";

  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple pipe_54(
    medium=medium,
    constantComposition=true,
    frictionAtInlet=true,
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

  TransiEnt.Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple pipe_32(
    medium=medium,
    constantComposition=true,
    frictionAtOutlet=true,
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

  TransiEnt.Storage.Gas.GasStorageVesselHeatTransfer_L2 station_tank(
    medium=medium,
    alpha_nom_outer=3,
    redeclare model MaterialWall = TILMedia.SolidTypes.TILMedia_Steel,
    includeWall=true,
    thickness_wall=0.3081,
    T_wall_start=T_start_1,
    storage(
      V_geo=0.6,
      redeclare model HeatTransfer = TransiEnt.Storage.Gas.Base.ConstantHTOuterTemperature_L2 (alpha_nom=4),
      p_gas_start=p_start_1,
      T_gas_start=T_start_1,
      Cspec_demAndRev_el=simCenter.Cspec_demAndRev_el_70_150_GWh,
      redeclare model CostSpecsStorage = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.HydrogenBufferStorage,
      p_max=60000000))      annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-86,0})));
  TransiEnt.Storage.Gas.GasStorageVesselHeatTransfer_L2 vehicle_tank(
    medium=medium,
    alpha_nom_outer=6,
    thickness_wall=0.2101,
    redeclare model MaterialWall = TILMedia.SolidTypes.TILMedia_Steel,
    T_wall_start=T_start_2,
    storage(
      V_geo=0.108,
      redeclare model HeatTransfer = TransiEnt.Storage.Gas.Base.ConstantHTOuterTemperature_L2 (alpha_nom=60),
      p_gas_start=p_start_2,
      T_gas_start=T_start_2,
      Cspec_demAndRev_el=simCenter.Cspec_demAndRev_el_70_150_GWh,
      redeclare model CostSpecsStorage = TransiEnt.Components.Statistics.ConfigurationData.GeneralCostSpecs.HydrogenBufferStorage,
      p_max=8200000))       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={86,0})));

                                                                                            // assumed to be spherical --> d_i=0.5232
                                                                                          // assumed to be spherical --> d_i=0.2954

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

  Modelica.Blocks.Sources.Constant T_amb(k=300.15)
                                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,86})));
  Modelica.Blocks.Sources.RealExpression targetMassFlow(y=-1.14202018176808e-9*time^3 + 3.4731974604687e-7*time^2 - 3.28191649003198e-5*time + 0.006168056759338) annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Components.Gas.VolumesValvesFittings.ValveDesiredMassFlow valve43(
    medium=medium,
    Delta_p_low=1,
    Delta_p_high=10) annotation (Placement(transformation(extent={{-10,5},{10,-7}})));
  Components.Sensors.RealGas.TemperatureSensor temp4(medium=medium) annotation (Placement(transformation(extent={{-36,0},{-16,20}})));
  Components.Sensors.RealGas.TemperatureSensor temp3(medium=medium) annotation (Placement(transformation(extent={{16,0},{36,20}})));
  inner ModelStatistics                                                   modelStatistics annotation (Placement(transformation(extent={{-70,-60},{-50,-40}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 wall_pipe_54(
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=1,
    diameter_i=pipe_54.diameter_i,
    length=pipe_54.length,
    diameter_o=0.0142,
    T_start=T_start_1*ones(wall_pipe_54.N_ax)) annotation (Placement(transformation(extent={{-66,18},{-46,28}})));
  ClaRa.Basics.ControlVolumes.SolidVolumes.CylindricalThinWall_L4 wall_pipe_32(
    redeclare model Material = TILMedia.SolidTypes.TILMedia_Steel,
    N_ax=1,
    diameter_i=pipe_32.diameter_i,
    length=pipe_32.length,
    diameter_o=0.0094,
    T_start=T_start_1*ones(wall_pipe_32.N_ax)) annotation (Placement(transformation(extent={{46,18},{66,28}})));
  Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow(medium=medium) annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Components.Boundaries.Gas.BoundaryRealGas_Txim_flow boundary_Txim_flow1(medium=medium) annotation (Placement(transformation(extent={{120,-10},{100,10}})));
equation

  connect(ht_pipe_32.T_outer, T_amb.y) annotation (Line(points={{56,60},{56,60},{56,68},{0,68},{0,72},{0,72},{0,75},{-2.22045e-015,75}},           color={0,0,127}));
  connect(ht_pipe_54.T_outer, T_amb.y) annotation (Line(points={{-56,60},{-56,60},{-56,68},{0,68},{0,75},{-1.9984e-015,75}},                    color={0,0,127}));
  connect(vehicle_tank.gasPortIn, pipe_32.gasPortOut) annotation (Line(
      points={{81.1,4.44089e-16},{81.1,0},{70,0}},
      color={255,255,0},
      thickness=0.75));
  connect(station_tank.gasPortOut, pipe_54.gasPortIn) annotation (Line(
      points={{-79.7,-1.77636e-15},{-79.7,0},{-70,0}},
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
  connect(wall_pipe_54.outerPhase[1], ht_pipe_54.heat) annotation (Line(
      points={{-56,28},{-56,40}},
      color={167,25,48},
      thickness=0.5));
  connect(wall_pipe_54.innerPhase, pipe_54.heat) annotation (Line(
      points={{-56,18},{-56,3.33333}},
      color={167,25,48},
      thickness=0.5));
  connect(wall_pipe_32.innerPhase, pipe_32.heat) annotation (Line(
      points={{56,18},{56,3.33333}},
      color={167,25,48},
      thickness=0.5));
  connect(wall_pipe_32.outerPhase[1], ht_pipe_32.heat) annotation (Line(
      points={{56,28},{56,40}},
      color={167,25,48},
      thickness=0.5));
  connect(boundary_Txim_flow.gasPort, station_tank.gasPortIn) annotation (Line(
      points={{-100,0},{-90.9,0}},
      color={255,255,0},
      thickness=1.5));
  connect(boundary_Txim_flow1.gasPort, vehicle_tank.gasPortOut) annotation (Line(
      points={{100,0},{92.3,0}},
      color={255,255,0},
      thickness=1.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-60},{120,100}})),  experiment(StopTime=216, Interval=0.008),
    Icon(graphics,
         coordinateSystem(extent={{-120,-60},{120,100}})),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #4b8a49\">1. Purpose of model</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #4b8a49\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #4b8a49\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #4b8a49\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #4b8a49\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #4b8a49\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #4b8a49\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #4b8a49\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #4b8a49\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #4b8a49\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) in Apr 2017</p>
<p>Model revised by Carsten Bode (c.bode@tuhh.de) in Apr 2018 (changes due to ClaRa changes: exchanged wall models)</p>
</html>"));
end TestGasStorageVesselHeatTransfer_L2;
