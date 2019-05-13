within TransiEnt.Storage.Gas.Check;
model TestUndergroundGasStorageHeatTransfer_L2
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

  //values from Tietze, V., & Stolten, D. (2015). Comparison of hydrogen and methane storage by means of a thermodynamic analysis. International Journal of Hydrogen Energy, 40(35), 11530-11537.
  //diameter of cavern 46.07 m
  //salt properties from Kushnir, R., Dayan, A., & Ullmann, A. (2012). Temperature and pressure variations within compressed air energy storage caverns. International Journal of Heat and Mass Transfer, 55(21), 5616-5630.

  parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK vle_h2;
  parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_CH4_SRK vle_ch4;

  inner TransiEnt.SimCenter simCenter                                                                    annotation (Placement(transformation(extent={{-90,-100},{-70,-80}})));
  Modelica.Blocks.Sources.TimeTable timeTable_source(table=[0,-3; 691200,-3; 691201,0; 1e8,0]) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-2,82})));
  Modelica.Blocks.Sources.TimeTable timeTable_sink(table=[0,0; 2764800,0; 2764801,3; 3456000,3; 3456001,0; 1e8,0]) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-62})));
  UndergroundGasStorageHeatTransfer_L2 compressedGasStorage_H2(
    thickness_wall=2,
    medium=vle_h2,
    T_surrounding=317.15,
    T_wall_start=317.15,
    storage(
      V_geo=500000,
      alpha_nom=133,
      height=300,
      p_gas_start=6500000,
      T_gas_start=317.15)) annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
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
  UndergroundGasStorageHeatTransfer_L2 compressedGasStorage_CH4(
    medium=vle_ch4,
    thickness_wall=2,
    T_surrounding=317.15,
    T_wall_start=317.15,
    storage(
      V_geo=500000,
      alpha_nom=120,
      height=300,
      p_gas_start=6500000,
      T_gas_start=317.15)) annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source_CH4(
    variable_m_flow=true,
    medium=vle_ch4,
    T_const=313.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,30})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sink_CH4(variable_m_flow=true, medium=vle_ch4) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,-30})));
  Modelica.Blocks.Math.Gain gain(k=25/3) annotation (Placement(transformation(extent={{18,44},{26,52}})));
  Modelica.Blocks.Math.Gain gain1(k=25/3) annotation (Placement(transformation(extent={{12,-52},{20,-44}})));
  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=-3,
    startTime=60000,
    width=5,
    period=600000) annotation (Placement(transformation(extent={{-92,46},{-72,66}})));
  Modelica.Blocks.Sources.Pulse pulse1(
    amplitude=3,
    width=5,
    period=600000,
    startTime=180000) annotation (Placement(transformation(extent={{-96,-34},{-76,-14}})));
equation
  connect(source_H2.gasPort, compressedGasStorage_H2.gasPortIn) annotation (Line(
      points={{-30,20},{-30,4.9}},
      color={255,255,0},
      thickness=1.5));
  connect(compressedGasStorage_H2.gasPortOut, sink_H2.gasPort) annotation (Line(
      points={{-30,-6.3},{-30,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(source_CH4.gasPort,compressedGasStorage_CH4. gasPortIn) annotation (Line(
      points={{30,20},{30,4.9}},
      color={255,255,0},
      thickness=1.5));
  connect(compressedGasStorage_CH4.gasPortOut, sink_CH4.gasPort) annotation (Line(
      points={{30,-6.3},{30,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(source_CH4.m_flow, gain.y) annotation (Line(points={{36,42},{36,48},{26.4,48}}, color={0,0,127}));
  connect(sink_CH4.m_flow, gain1.y) annotation (Line(points={{24,-42},{24,-48},{20.4,-48}}, color={0,0,127}));
  connect(sink_H2.m_flow, pulse1.y) annotation (Line(points={{-36,-42},{-36,-46},{-75,-46},{-75,-24}}, color={0,0,127}));
  connect(pulse1.y, gain1.u) annotation (Line(points={{-75,-24},{-66,-24},{-66,-48},{11.2,-48}}, color={0,0,127}));
  connect(pulse.y, gain.u) annotation (Line(points={{-71,56},{-2,56},{-2,48},{17.2,48}}, color={0,0,127}));
  connect(source_H2.m_flow, pulse.y) annotation (Line(points={{-24,42},{-26,42},{-26,56},{-71,56}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={Text(
          extent={{-84,92},{-32,60}},
          lineColor={28,108,200},
          textString="look at:
-temperature inside the cavern
-pressure inside the cavern",
          horizontalAlignment=TextAlignment.Left)}),
    experiment(StopTime=5.5296e+006, __Dymola_NumberOfIntervals=6144),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
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
</html>"));
end TestUndergroundGasStorageHeatTransfer_L2;
