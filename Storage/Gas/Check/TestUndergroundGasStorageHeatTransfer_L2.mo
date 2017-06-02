within TransiEnt.Storage.Gas.Check;
model TestUndergroundGasStorageHeatTransfer_L2
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

  //values from Tietze, V., & Stolten, D. (2015). Comparison of hydrogen and methane storage by means of a thermodynamic analysis. International Journal of Hydrogen Energy, 40(35), 11530-11537.
  //diameter of cavern 46.07 m
  //salt properties from Kushnir, R., Dayan, A., & Ullmann, A. (2012). Temperature and pressure variations within compressed air energy storage caverns. International Journal of Heat and Mass Transfer, 55(21), 5616-5630.

  parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK vle_h2;
  parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_H2_var vle_ng;

  inner TransiEnt.SimCenter simCenter                                                                    annotation (Placement(transformation(extent={{-90,-100},{-70,-80}})));
  Modelica.Blocks.Sources.TimeTable timeTable_source(table=[0,-3; 691200,-3; 691201,0; 1e8,0]) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,62})));
  Modelica.Blocks.Sources.TimeTable timeTable_sink(table=[0,0; 2764800,0; 2764801,3; 3456000,3; 3456001,0; 1e8,0]) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-62})));
  UndergroundGasStorageHeatTransfer_L2 compressedGasStorage_H2(
    thickness_material=2,
    mass=3295*46754*2,
    medium=vle_h2,
    T_material=317.15,
    T_material_start=317.15,
    storage(
      V_geo=500000,
      alpha_nom=133,
      A_heat=46754,
      p_gas_start=6500000,
      T_gas_start=317.15))
                        annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source_H2(
    medium=vle_h2,
    variable_m_flow=true,
    T_const=313.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,30})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sink_H2(variable_m_flow=true, medium=vle_h2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-30})));
  UndergroundGasStorageHeatTransfer_L2 compressedGasStorage_NG(storage(
    V_geo=500000,
    alpha_nom=133,
    A_heat=46754,
    p_gas_start=6500000,
    T_gas_start=317.15),
    medium=vle_ng,
    thickness_material=2,
    mass=3295*46754*2,
    T_material=317.15,
    T_material_start=317.15)
                        annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source_NG(
    variable_m_flow=true,
    medium=vle_ng,
    T_const=313.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,30})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sink_NG(variable_m_flow=true, medium=vle_ng) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,-30})));
  Modelica.Blocks.Math.Gain gain(k=25/3) annotation (Placement(transformation(extent={{18,44},{26,52}})));
  Modelica.Blocks.Math.Gain gain1(k=25/3) annotation (Placement(transformation(extent={{12,-52},{20,-44}})));
equation
  connect(source_H2.gasPort, compressedGasStorage_H2.gasPortIn) annotation (Line(
      points={{-30,20},{-30,4.9}},
      color={255,255,0},
      thickness=1.5));
  connect(compressedGasStorage_H2.gasPortOut, sink_H2.gasPort) annotation (Line(
      points={{-30,-6.3},{-30,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(timeTable_source.y, source_H2.m_flow) annotation (Line(points={{0,51},{0,48},{-24,48},{-24,42}}, color={0,0,127}));
  connect(sink_H2.m_flow, timeTable_sink.y) annotation (Line(points={{-36,-42},{-36,-48},{0,-48},{0,-51}}, color={0,0,127}));
  connect(source_NG.gasPort,compressedGasStorage_NG. gasPortIn) annotation (Line(
      points={{30,20},{30,4.9}},
      color={255,255,0},
      thickness=1.5));
  connect(compressedGasStorage_NG.gasPortOut, sink_NG.gasPort) annotation (Line(
      points={{30,-6.3},{30,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(source_NG.m_flow, gain.y) annotation (Line(points={{36,42},{36,48},{26.4,48}}, color={0,0,127}));
  connect(gain.u, timeTable_source.y) annotation (Line(points={{17.2,48},{0,48},{0,51}}, color={0,0,127}));
  connect(sink_NG.m_flow, gain1.y) annotation (Line(points={{24,-42},{24,-48},{20.4,-48}}, color={0,0,127}));
  connect(gain1.u, timeTable_sink.y) annotation (Line(points={{11.2,-48},{0,-48},{0,-51}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-84,92},{-32,60}},
          lineColor={28,108,200},
          textString="look at:
-temperature inside the cavern
-pressure inside the cavern",
          horizontalAlignment=TextAlignment.Left)}),
    experiment(StopTime=5.5296e+006, __Dymola_NumberOfIntervals=6144),
    __Dymola_experimentSetupOutput);
end TestUndergroundGasStorageHeatTransfer_L2;
