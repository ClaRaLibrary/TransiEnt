within TransiEnt.Storage.Gas.Check;
model TestUndergroundGasStorageIdealHTInPipes_L2
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

  inner TransiEnt.SimCenter simCenter(redeclare TransiEnt.Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel1)     annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,-90})));
  Modelica.Blocks.Sources.TimeTable timeTable_source(table=[0,-100; 10000,0; 20000,0])
                                                                                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={6,60})));
  Modelica.Blocks.Sources.TimeTable timeTable_sink(table=[0,0; 10000,0; 20000,100])
                                                                                  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-6,-80})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source1(variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,30})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sink1(variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-50})));
public
  TransiEnt.Storage.Gas.UndergroundGasStorageHeatTransfer_L2 storage1(calculateCost=simCenter.calculateCost) annotation (
    Dialog(group="Fundamental Definitions"),
    choicesAllMatching,
    Placement(transformation(extent={{-10,-10},{10,10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source2(variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={36,30})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow sink2(variable_m_flow=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={36,-50})));
public
  TransiEnt.Storage.Gas.UndergroundGasStorageIdealHTInPipes_L2 storage2(calculateCost=simCenter.calculateCost) annotation (
    Dialog(group="Fundamental Definitions"),
    choicesAllMatching,
    Placement(transformation(extent={{26,-10},{46,10}})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor temperatureSensor2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={46,-22})));
  TransiEnt.Components.Sensors.RealGas.TemperatureSensor temperatureSensor1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,-22})));
equation
  connect(timeTable_source.y, source1.m_flow) annotation (Line(points={{6,49},{6,42}},                        color={0,0,127}));
  connect(sink1.m_flow, timeTable_sink.y) annotation (Line(points={{-6,-62},{-6,-69}},                   color={0,0,127}));
  connect(storage1.gasPortIn, source1.gasPort) annotation (Line(
      points={{0,4.9},{0,20}},
      color={255,255,0},
      thickness=1.5));
  connect(storage2.gasPortIn, source2.gasPort) annotation (Line(
      points={{36,4.9},{36,20}},
      color={255,255,0},
      thickness=1.5));
  connect(source2.m_flow, timeTable_source.y) annotation (Line(points={{42,42},{42,46},{6,46},{6,49}}, color={0,0,127}));
  connect(timeTable_sink.y, sink2.m_flow) annotation (Line(points={{-6,-69},{-6,-66},{30,-66},{30,-62}}, color={0,0,127}));
  connect(storage2.gasPortOut, temperatureSensor2.gasPortIn) annotation (Line(
      points={{36,-6.3},{36,-12}},
      color={255,255,0},
      thickness=1.5));
  connect(temperatureSensor2.gasPortOut, sink2.gasPort) annotation (Line(
      points={{36,-32},{36,-40}},
      color={255,255,0},
      thickness=1.5));
  connect(storage1.gasPortOut, temperatureSensor1.gasPortIn) annotation (Line(
      points={{0,-6.3},{0,-9.15},{3.55271e-15,-9.15},{3.55271e-15,-12}},
      color={255,255,0},
      thickness=1.5));
  connect(temperatureSensor1.gasPortOut, sink1.gasPort) annotation (Line(
      points={{0,-32},{0,-40}},
      color={255,255,0},
      thickness=1.5));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                                                                graphics={Text(
          extent={{-56,66},{-28,56}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="look at:
-storage pressure
-pipe inlet pressure
-pipe outlet pressure")}),
    experiment(StopTime=20000, __Dymola_Algorithm="Sdirk34hw"),
    __Dymola_experimentSetupOutput,
    Icon(graphics,
         coordinateSystem(extent={{-100,-100},{120,100}})),
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
<p>Model created by Carsten Bode (c.bode@tuhh.de) in Sep 2016</p>
</html>"));
end TestUndergroundGasStorageIdealHTInPipes_L2;
