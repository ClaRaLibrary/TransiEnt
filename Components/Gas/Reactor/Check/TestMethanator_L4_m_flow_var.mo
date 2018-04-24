within TransiEnt.Components.Gas.Reactor.Check;
model TestMethanator_L4_m_flow_var
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

extends TransiEnt.Basics.Icons.Checkmodel;

  import SI = Modelica.SIunits;

  parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var vle_sg4;
  parameter TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG4_var gas_sg4;

  parameter Integer N_cv=10;

  TransiEnt.Components.Gas.Reactor.Methanator_L4 methanator_L4(
    cp_cat=789.52,
    eps_bed=0.4,
    N_cv=N_cv,
    lambda_p=50,
    H_flow_n_Methane=1e6,
    dia_tube_i=0.02,
    l=6.94,
    dia_part=0.003,
    ScalingOfReactor=3) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi(medium=vle_sg4, p_const=2000000)
                                                                                                           annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor moleCompIn(medium=vle_sg4, compositionDefinedBy=2) annotation (Placement(transformation(extent={{-70,0},{-50,20}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor moleCompOut(medium=vle_sg4, compositionDefinedBy=2) annotation (Placement(transformation(extent={{50,0},{70,20}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature      prescribedTemperature[N_cv](each T=558.15)
                                                                                          annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-40,30})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=0.5e6,
    startTime=0.5e6,
    height=1,
    offset=-1)           annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow    boundaryRealGas_Teps_nV_flow_n(
    medium=vle_sg4,
    variable_m_flow=true,
    xi_const={0,0.844884,0},
    T_const=558.15)  annotation (Placement(transformation(extent={{-98,-10},{-78,10}})));
  TransiEnt.Basics.Adapters.Gas.Ideal_to_Real ideal_to_Real(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var real, redeclare TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG4_var ideal) annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  TransiEnt.Basics.Adapters.Gas.Real_to_Ideal real_to_Ideal(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var real, redeclare TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG4_var ideal) annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  inner TransiEnt.ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
equation
  connect(real_to_Ideal.gasPortOut, methanator_L4.gasPortIn) annotation (Line(
      points={{-20,0},{-20,0},{-10,0}},
      color={255,213,170},
      thickness=1.5));
  connect(methanator_L4.gasPortOut, ideal_to_Real.gasPortIn) annotation (Line(
      points={{10,0},{20,0}},
      color={255,213,170},
      thickness=1.5));
  connect(methanator_L4.heat, prescribedTemperature.port) annotation (Line(points={{0,10},{0,30},{-30,30}}, color={191,0,0}));
  connect(boundaryRealGas_Teps_nV_flow_n.gasPort, moleCompIn.gasPortIn) annotation (Line(
      points={{-78,0},{-74,0},{-70,0}},
      color={255,255,0},
      thickness=1.5));
  connect(moleCompIn.gasPortOut, real_to_Ideal.gasPortIn) annotation (Line(
      points={{-50,0},{-40,0}},
      color={255,255,0},
      thickness=1.5));
  connect(ideal_to_Real.gasPortOut, moleCompOut.gasPortIn) annotation (Line(
      points={{40,0},{46,0},{50,0}},
      color={255,255,0},
      thickness=1.5));
  connect(moleCompOut.gasPortOut, boundaryRealGas_pTxi.gasPort) annotation (Line(
      points={{70,0},{75,0},{80,0}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp.y, boundaryRealGas_Teps_nV_flow_n.m_flow) annotation (Line(points={{-119,0},{-110,0},{-110,6},{-100,6}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{100,100}})),
    experiment(StopTime=1e+006, Tolerance=1e-006),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-140,-100},{100,100}})));
end TestMethanator_L4_m_flow_var;
