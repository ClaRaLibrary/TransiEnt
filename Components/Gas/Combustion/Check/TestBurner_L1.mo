within TransiEnt.Components.Gas.Combustion.Check;
model TestBurner_L1 "Model for testing the Burner_L1 model"
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

  parameter TransiEnt.Basics.Media.Gases.VLE_VDIWA_NG7_SG_O2_var vle_ng7_sg_o2;

  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source(
    medium=vle_ng7_sg_o2,
    variable_m_flow=true,
    variable_T=true,
    variable_xi=true) annotation (Placement(transformation(extent={{-88,-30},{-68,-10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink(
    medium=vle_ng7_sg_o2,
    variable_p=true,
    p_const=100000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={78,-20})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-1,
    offset=-1,
    duration=1000,
    startTime=1000)
                  annotation (Placement(transformation(extent={{-120,24},{-100,44}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=1000,
    startTime=3000,
    height=50,
    offset=273.15) annotation (Placement(transformation(extent={{-120,-6},{-100,14}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(table=[0,0.025,0.005,0.003,0.002,0.75,0.02,0.0,0.0,0.19; 5000,0.025,0.005,0.003,0.002,0.75,0.02,0.0,0.0,0.19; 6000,0,0,0,0,0.59,0.1,0.1,0.05,0.15; 11000,0,0,0,0,0.59,0.1,0.1,0.05,0.15; 12000,0.015,0.0,0.0,0.0,0.43,0.2,0.2,0.05,0.1; 14000,0.015,0.0,0.0,0.0,0.43,0.2,0.2,0.05,0.1])
                                                                                              annotation (Placement(transformation(extent={{-120,-36},{-100,-16}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    duration=1000,
    startTime=7000,
    height=4e5,
    offset=1e5)    annotation (Placement(transformation(extent={{120,-24},{100,-4}})));

  TransiEnt.Components.Gas.Combustion.Burner_L1 burner(Delta_p=50000) annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,6})));
  Modelica.Blocks.Sources.Ramp ramp3(
    duration=1000,
    startTime=7000,
    offset=-1e6,
    height=-1e6)  annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-20,22})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor moleCompIn(medium=vle_ng7_sg_o2, compositionDefinedBy=2) annotation (Placement(transformation(extent={{-36,-20},{-16,0}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor temperatureIn(medium=vle_ng7_sg_o2) annotation (Placement(transformation(extent={{-62,-20},{-42,0}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor temperatureOut(medium=vle_ng7_sg_o2) annotation (Placement(transformation(extent={{16,-20},{36,0}})));
  TransiEnt.Components.Sensors.RealGas.CompositionSensor moleCompOut(medium=vle_ng7_sg_o2, compositionDefinedBy=2) annotation (Placement(transformation(extent={{42,-20},{62,0}})));

equation
  connect(combiTimeTable.y, source.xi) annotation (Line(points={{-99,-26},{-96,-26},{-90,-26}}, color={0,0,127}));
  connect(ramp2.y, sink.p) annotation (Line(points={{99,-14},{90,-14}}, color={0,0,127}));
  connect(ramp3.y, prescribedHeatFlow.Q_flow) annotation (Line(points={{-9,22},{0,22},{0,16}},  color={0,0,127}));
  connect(moleCompOut.gasPortOut, sink.gasPort) annotation (Line(
      points={{62,-20},{68,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(temperatureOut.gasPortOut, moleCompOut.gasPortIn) annotation (Line(
      points={{36,-20},{40,-20},{40,-20},{42,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(burner.gasPortOut, temperatureOut.gasPortIn) annotation (Line(
      points={{10,-20},{13,-20},{16,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(moleCompIn.gasPortOut, burner.gasPortIn) annotation (Line(
      points={{-16,-20},{-10,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(temperatureIn.gasPortOut, moleCompIn.gasPortIn) annotation (Line(
      points={{-42,-20},{-36,-20},{-36,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(source.gasPort, temperatureIn.gasPortIn) annotation (Line(
      points={{-68,-20},{-65,-20},{-62,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp.y, source.m_flow) annotation (Line(points={{-99,34},{-94,34},{-94,-14},{-90,-14}}, color={0,0,127}));
  connect(ramp1.y, source.T) annotation (Line(points={{-99,4},{-96,4},{-96,-20},{-90,-20}}, color={0,0,127}));
  connect(prescribedHeatFlow.port, burner.heat) annotation (Line(points={{0,-4},{0,-10.2},{0,-10.2}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-40},{120,100}}),  graphics={Text(
          extent={{-56,92},{60,74}},
          lineColor={0,140,72},
          textString="1000-2000 s mass flow from 1 to 2 kg/s
3000-4000 s temperature from 0 to 50 C
5000-6000 s composition changes
7000-8000 s Q_flow changes from 1 to 2 MW
9000-10000 s pressure at exhaust output from 1 to 5 bar
11000-12000 s insufficient oxygen suppy"),
                                 Text(
          extent={{-36,62},{28,46}},
          lineColor={0,140,72},
          textString="check mass flows
check temperature curve plausibility
check pressure loss in correct direction")}),
    experiment(StopTime=14000, __Dymola_NumberOfIntervals=700),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-120,-40},{120,100}})),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for the Burner_L1 model</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de) on Tue Apr 05 2016</p>
</html>"));
end TestBurner_L1;
