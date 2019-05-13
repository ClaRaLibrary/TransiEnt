within TransiEnt.Storage.Gas.Check;
model TestGasStorage_constXi_L2
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
  extends TransiEnt.Basics.Icons.Checkmodel;

  //values from Olmos, Fernando ; Manousiouthakis, Vasilios I.: Hydrogen car fill-up process modeling and simulation. In: International Journal of Hydrogen Energy 38 (2013), Nr. 8, S. 3401–3418.

  parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2 medium;

  parameter Modelica.SIunits.SpecificHeatCapacity cp_steel316=468 "Heat capacity of steel 316 (station tank and pipes)";

  parameter Modelica.SIunits.ThermodynamicTemperature T_start_1=300.15 "Start temperature in pipe_54, at outlet of pipe_32, pipe_32 and its wall, station_tank and its wall";
  parameter Modelica.SIunits.ThermodynamicTemperature T_start_2=286.64 "Start temperature in vehicle_tank and its wall";
  parameter Modelica.SIunits.Pressure p_start_1=415.41e5 "Start pressure in pipe_54, station_tank";
  parameter Modelica.SIunits.Pressure p_start_2=138.01e5 "Start pressure in vehicle_tank, pipe_32";

  parameter Modelica.SIunits.SpecificEnthalpy h_start_1=TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(vleFluidType=medium, p=p_start_1, T=T_start_1) "Start enthalpy for pipe_54";
  parameter Modelica.SIunits.SpecificEnthalpy h_start_2=TILMedia.VLEFluidFunctions.specificEnthalpy_pTxi(vleFluidType=medium, p=p_start_2, T=T_start_1) "Start enthalpy for pipe_32 and its outlet";

  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));
  Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_constXi pipe_54(
    medium=medium,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4,
    diameter_i=0.008,
    length=15.24,
    p_start=p_start_1*ones(pipe_54.N_cv),
    h_start=h_start_1*ones(pipe_54.N_cv),
    heatTransfer(alpha_nom=6000),
    initOption=0,
    N_cv=1,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L4) annotation (Placement(transformation(extent={{-70,-4},{-42,6}})));
                                                                         //length like given in the paper, d_i scaled with 1/10

  Components.Gas.VolumesValvesFittings.PipeFlow_L4_Simple_constXi pipe_32(
    medium=medium,
    redeclare model HeatTransfer = ClaRa.Basics.ControlVolumes.Fundamentals.HeatTransport.Generic_HT.Constant_L4,
    diameter_i=0.008,
    length=1.52,
    p_start=p_start_2*ones(pipe_32.N_cv),
    h_start=h_start_2*ones(pipe_32.N_cv),
    heatTransfer(alpha_nom=6000),
    initOption=0,
    N_cv=1,
    redeclare model PressureLoss = ClaRa.Basics.ControlVolumes.Fundamentals.PressureLoss.Generic_PL.NoFriction_L4) annotation (Placement(transformation(extent={{42,-4},{70,6}})));
                                                                      //length like given in the paper, d_i scaled with 1/10

  TransiEnt.Storage.Gas.GasStorage_constXi_L2 station_tank(
    medium=medium,
    V_geo=0.6,
    alpha_nom=4,
    p_gas_start=p_start_1,
    T_gas_start=T_start_1,
    Cspec_demAndRev_el=simCenter.Cspec_demAndRev_el_70_150_GWh,
    redeclare model CostSpecsStorage = Components.Statistics.ConfigurationData.GeneralCostSpecs.HydrogenBufferStorage,
    p_max=8200000) annotation (Placement(transformation(extent={{-70,-4},{-90,-24}})));
  TransiEnt.Storage.Gas.GasStorage_constXi_L2 vehicle_tank(
    medium=medium,
    V_geo=0.108,
    alpha_nom=60,
    p_gas_start=p_start_2,
    T_gas_start=T_start_2,
    Cspec_demAndRev_el=simCenter.Cspec_demAndRev_el_70_150_GWh,
    redeclare model CostSpecsStorage = Components.Statistics.ConfigurationData.GeneralCostSpecs.HydrogenBufferStorage,
    p_max=8200000) annotation (Placement(transformation(extent={{70,-24},{90,-4}})));

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
  Components.Gas.VolumesValvesFittings.ValveDesiredMassFlow valve43(
    medium=medium,
    Delta_p_low=1,
    Delta_p_high=10) annotation (Placement(transformation(extent={{-10,6},{10,-6}})));
  Components.Sensors.RealGas.TemperatureSensor temp4(medium=medium) annotation (Placement(transformation(extent={{-36,0},{-16,20}})));
  Components.Sensors.RealGas.TemperatureSensor temp3(medium=medium) annotation (Placement(transformation(extent={{16,0},{36,20}})));
  inner ModelStatistics                                                   modelStatistics annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation

  connect(wall_pipe_54.innerPhase[1], pipe_54.heat[1]) annotation (Line(
      points={{-56,18},{-56,12},{-56,5}},
      color={167,25,48},
      thickness=0.5));
  connect(wall_pipe_32.innerPhase[1], pipe_32.heat[1]) annotation (Line(
      points={{56,18},{56,5}},
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
      points={{-90,18},{-90,18},{-90,-14},{-84,-14}},
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
      points={{90,18},{90,18},{90,-14},{84,-14}},
      color={167,25,48},
      thickness=0.5));
  connect(T_amb.y, ht_station_tank.T_outer) annotation (Line(points={{-1.9984e-015,75},{-1.9984e-015,78},{-1.9984e-015,68},{-90,68},{-90,60}},
                                                                                              color={0,0,127}));
  connect(ht_pipe_32.T_outer, T_amb.y) annotation (Line(points={{56,60},{56,60},{56,68},{0,68},{0,72},{0,72},{0,75},{-2.22045e-015,75}},           color={0,0,127}));
  connect(ht_vehicle_tank.T_outer, T_amb.y) annotation (Line(points={{90,60},{90,60},{90,68},{0,68},{0,75},{-2.22045e-015,75}},
                                                                                              color={0,0,127}));
  connect(ht_pipe_54.T_outer, T_amb.y) annotation (Line(points={{-56,60},{-56,60},{-56,68},{0,68},{0,75},{-1.9984e-015,75}},                    color={0,0,127}));
  connect(vehicle_tank.gasPortIn, pipe_32.gasPortOut) annotation (Line(
      points={{80,-9.1},{80,1},{70,1}},
      color={255,255,0},
      thickness=0.75));
  connect(station_tank.gasPortOut, pipe_54.gasPortIn) annotation (Line(
      points={{-80,-7.7},{-80,1},{-70,1}},
      color={255,255,0},
      thickness=0.5));
  connect(targetMassFlow.y, valve43.m_flowDes) annotation (Line(points={{-29,-20},{-20,-20},{-20,-4.28571},{-10,-4.28571}},
                                                                                                                color={0,0,127}));
  connect(temp4.gasPortIn, pipe_54.gasPortOut) annotation (Line(
      points={{-36,0},{-40,0},{-40,1},{-42,1}},
      color={255,255,0},
      thickness=1.5));
  connect(temp4.gasPortOut, valve43.gasPortIn) annotation (Line(
      points={{-16,0},{-10,0},{-10,0.857143}},
      color={255,255,0},
      thickness=1.5));
  connect(valve43.gasPortOut, temp3.gasPortIn) annotation (Line(
      points={{10,0.857143},{13,0},{16,0}},
      color={255,255,0},
      thickness=1.5));
  connect(temp3.gasPortOut, pipe_32.gasPortIn) annotation (Line(
      points={{36,0},{40,0},{40,1},{42,1}},
      color={255,255,0},
      thickness=1.5));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,-60},{100,100}})),  experiment(StopTime=216, Interval=0.008),
    Icon(graphics,
         coordinateSystem(extent={{-100,-60},{100,100}})),
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
