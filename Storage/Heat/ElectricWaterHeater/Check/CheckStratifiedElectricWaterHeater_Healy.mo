within TransiEnt.Storage.Heat.ElectricWaterHeater.Check;
model CheckStratifiedElectricWaterHeater_Healy
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
    A_wall=0.0097*stor.n,
    rho=1000,
    U=0.5,
    h=1.2,
    m=190,
    T_max=273.15 + 63,
    P_0=4.5e3,
    N_heaters=2,
    eta=1,
    v_cf=0.05,
    d=0.46,
    A_top=0.17,
    A_bottom=0.17,
    N_mix=4,
    n=20,
    isTambConst=false,
    T_inflow=273.15 + 22.6,
    i_heater={4,16},
    T_start=vector((273.15 + 64.46)*ones(stor.n, 1)))
          annotation (Placement(transformation(extent={{-8,-10},{12,10}})));

  Modelica.Blocks.Sources.Pulse    WaterDrawn(
    offset=0,
    amplitude=11.36/60,
    period=3600,
    startTime=0,
    width=3.562/60*100)                            annotation (Placement(transformation(extent={{-94,-52},{-74,-32}})));
  Modelica.Blocks.Sources.BooleanConstant HeaterSwitch2(k=false) annotation (Placement(transformation(extent={{-62,33},{-42,53}})));
  Modelica.Blocks.Sources.Constant Tamb(k=273.15 + 19.7)
                                                  annotation (Placement(transformation(extent={{-74,-5},{-54,15}})));
  TransiEnt.Components.Boundaries.Electrical.Frequency ElectricGrid annotation (Placement(transformation(extent={{30,-12},{50,8}})));
  Modelica.Blocks.Math.Product TestSchedule annotation (Placement(transformation(extent={{-46,-58},{-26,-38}})));
  Modelica.Blocks.Sources.Step drawend(
    height=-1,
    offset=1,
    startTime=5.5*3600) annotation (Placement(transformation(extent={{-84,-86},{-64,-66}})));
  Modelica.Blocks.Sources.BooleanPulse HeaterSwitch1(period=3600, startTime=0)
    annotation (Placement(transformation(extent={{-38,60},{-18,80}})));
equation
  connect(Tamb.y, stor.Tamb_input) annotation (Line(points={{-53,5},{-8,5},{-8,6.8}},   color={0,0,127}));
  connect(ElectricGrid.epp, stor.epp) annotation (Line(
      points={{29.9,-2.1},{24,-2.1},{24,14},{2,14},{2,9.6}},
      color={0,135,135},
      thickness=0.5));
  connect(drawend.y, TestSchedule.u2) annotation (Line(points={{-63,-76},{-56,-76},{-56,-54},{-48,-54}}, color={0,0,127}));
  connect(WaterDrawn.y, TestSchedule.u1) annotation (Line(points={{-73,-42},{-60,-42},{-54,-42},{-48,-42}}, color={0,0,127}));
  connect(stor.m_flow, TestSchedule.y) annotation (Line(points={{-8.2,0},{-20,0},{-20,-2},{-20,-48},{-25,-48}}, color={0,0,127}));
  connect(HeaterSwitch1.y, stor.u[1]) annotation (Line(points={{-17,70},{-1.4,70},{-1.4,9.5}}, color={255,0,255}));
  connect(HeaterSwitch2.y, stor.u[2]) annotation (Line(points={{-41,43},{-34,43},{-34,44},{-1.4,44},{-1.4,8.5}}, color={255,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=25200, Interval=60),
    __Dymola_experimentSetupOutput(events=false));
end CheckStratifiedElectricWaterHeater_Healy;