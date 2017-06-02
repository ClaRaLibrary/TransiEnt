within TransiEnt.Storage.Heat.ElectricWaterHeater.Check;
model CheckStratifiedElectricWaterHeater_CoolDown
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

  StratifiedElectricWaterHeater_L3                                                   stor(
    A_wall=4.85,
    A_bottom=0.5281,
    d=0.82,
    h=1.886,
    m=1000,
    T_start=linspace(
        273.15 + 44.4271,
        273.15 + 80.98,
        stor.n),
    n=50,
    U=0.04*0.1/stor.A_top,
    A_top=0.530223,
    T_inflow=293.15)
          annotation (Placement(transformation(extent={{-10,-12},{10,8}})));
  Modelica.Blocks.Sources.RealExpression T_sim1(y=stor.T[1] - 273.15)             annotation (Placement(transformation(extent={{64,75},{84,95}})));
  Modelica.Blocks.Sources.RealExpression T_sim2(y=stor.T[17] - 273.15)            annotation (Placement(transformation(extent={{64,59},{84,79}})));
  Modelica.Blocks.Sources.RealExpression T_sim3(y=stor.T[34] - 273.15)            annotation (Placement(transformation(extent={{64,45},{84,65}})));
  Modelica.Blocks.Sources.RealExpression T_sim4(y=stor.T[50] - 273.15)            annotation (Placement(transformation(extent={{64,29},{84,49}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency ElectricGrid annotation (Placement(transformation(extent={{30,-12},{50,8}})));
  Modelica.Blocks.Sources.Constant WaterDrawn(k=0) annotation (Placement(transformation(extent={{-60,-16},{-40,4}})));
  TransiEnt.Basics.Blocks.Sources.BooleanArrayConstant HeaterSwitch(k=fill(false, stor.N_heaters), nout=stor.N_heaters) annotation (Placement(transformation(extent={{-52,36},{-32,56}})));
  Modelica.Blocks.Sources.RealExpression Tamb_meas_K(y=293)                    annotation (Placement(transformation(extent={{-56,7},{-36,27}})));
equation
  connect(ElectricGrid.epp, stor.epp) annotation (Line(
      points={{29.9,-2.1},{24,-2.1},{24,14},{0,14},{0,7.6}},
      color={0,135,135},
      thickness=0.5));
  connect(HeaterSwitch.y, stor.u) annotation (Line(points={{-31,46},{-28,46},{-28,42},{-3.4,42},{-3.4,7}}, color={255,0,255}));
  connect(Tamb_meas_K.y, stor.Tamb_input) annotation (Line(points={{-35,17},{-10,17},{-10,4.8}}, color={0,0,127}));
  connect(WaterDrawn.y, stor.m_flow) annotation (Line(points={{-39,-6},{-26,-6},{-26,-4},{-10.2,-4},{-10.2,-2}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=14400),
    __Dymola_experimentSetupOutput);
end CheckStratifiedElectricWaterHeater_CoolDown;
