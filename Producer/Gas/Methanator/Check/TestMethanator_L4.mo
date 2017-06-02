within TransiEnt.Producer.Gas.Methanator.Check;
model TestMethanator_L4
//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

extends TransiEnt.Basics.Icons.Checkmodel;

  import SI = Modelica.SIunits;

  parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var vle_sg4;
  parameter TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG4_var gas_sg4;

  parameter SI.MoleFraction x_const[3]={0,0.2,0};
  parameter SI.Pressure p=6e5;
  parameter SI.VolumeFlowRate V_flow_n=8.333e-7;

  parameter SI.Temperature T_max=273.15+330;
  parameter SI.Temperature T_min=273.15+235;

  parameter Integer N_cv=10;

  Real yield = (moleCompIn.fraction[2]-moleCompOut.fraction[2])/moleCompIn.fraction[2] "Mole fraction of decomposed CO2";

  TransiEnt.Producer.Gas.Methanator.Methanator_L4 methanator_L4(
    cp_cat=789.52,
    dia_part=0.000175,
    dia_tube_i=0.004,
    l=0.0141,
    eps_bed=0.4,
    lambda_p=30,
    N_cv=N_cv) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundaryRealGas_pTxi(medium=vle_sg4, p_const=p) annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor moleCompIn(medium=vle_sg4, compositionDefinedBy=2) annotation (Placement(transformation(extent={{-70,0},{-50,20}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor moleCompOut(medium=vle_sg4, compositionDefinedBy=2) annotation (Placement(transformation(extent={{50,0},{70,20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature[N_cv] annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-40,30})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=1e6,
    height=T_max - T_min,
    offset=T_min)        annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_TxV_flow_stp boundaryRealGas_Teps_nV_flow_n(
    medium=vle_sg4,
    variable_T=true,
    V_flow_n_const=-V_flow_n,
    x_const=x_const) annotation (Placement(transformation(extent={{-98,-10},{-78,10}})));
  Modelica.Blocks.Routing.Replicator replicator(nout=N_cv) annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
  TransiEnt.Basics.Adapters.Gas.Ideal_to_Real ideal_to_Real(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var real, redeclare TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG4_var ideal) annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  TransiEnt.Basics.Adapters.Gas.Real_to_Ideal real_to_Ideal(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_SG4_var real, redeclare TransiEnt.Basics.Media.Gases.Gas_VDIWA_SG4_var ideal) annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  inner ModelStatistics modelStatistics annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
equation
  connect(boundaryRealGas_Teps_nV_flow_n.T, ramp.y) annotation (Line(points={{-100,0},{-119,0}}, color={0,0,127}));
  connect(replicator.y, prescribedTemperature.T) annotation (Line(points={{-69,30},{-52,30}},          color={0,0,127}));
  connect(replicator.u, ramp.y) annotation (Line(points={{-92,30},{-110,30},{-110,0},{-119,0}}, color={0,0,127}));
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
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{100,100}})),
    experiment(StopTime=1e+006, Tolerance=1e-006),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-140,-100},{100,100}})));
end TestMethanator_L4;
