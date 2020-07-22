within TransiEnt.Components.Gas.VolumesValvesFittings.Check;
model TestValves
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

  TransiEnt.Components.Gas.VolumesValvesFittings.ValveDesiredMassFlow valveDesiredMassFlow(
    hysteresisWithDelta_p=true,
    Delta_p_low=40000,
    Delta_p_high=80000) annotation (Placement(transformation(extent={{-10,24},{10,36}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=1,
    duration=0.8,
    offset=1,
    startTime=0.1) annotation (Placement(transformation(extent={{-100,56},{-80,76}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi source2(variable_p=true) annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink2(p_const=100000) annotation (Placement(transformation(extent={{60,20},{40,40}})));
  Modelica.Blocks.Sources.TimeTable timeTable(table=[0,2e5; 0.1,2e5; 0.5,1e5; 0.9,2e5; 1,2e5]) annotation (Placement(transformation(extent={{-100,26},{-80,46}})));
  TransiEnt.Components.Gas.VolumesValvesFittings.ValveDesiredPressureBefore simpleValveDesiredPressureBefore(p_BeforeValveDes=20000000)
                                                                                                             annotation (Placement(transformation(extent={{-10,74},{10,86}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_Txim_flow source1(m_flow_const=-1, T_const(displayUnit="K") = 283.15)
                                                                                                         annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink1(variable_p=true) annotation (Placement(transformation(extent={{60,70},{40,90}})));
  inner SimCenter simCenter(redeclare Basics.Media.Gases.VLE_VDIWA_H2_SRK gasModel1)
    annotation (Placement(transformation(extent={{-90,-100},{-70,-80}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    duration=0.8,
    startTime=0.1,
    offset=1e5,
    height=16e5)   annotation (Placement(transformation(extent={{90,76},{70,96}})));
  ValveDesiredDp valve_p annotation (Placement(transformation(extent={{-10,-26},{10,-14}})));
  Boundaries.Gas.BoundaryRealGas_Txim_flow                 source3(variable_m_flow=true)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink3(p_const=100000) annotation (Placement(transformation(extent={{58,-30},{38,-10}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    startTime=0.1,
    height=-1,
    duration=0.3,
    offset=-1)     annotation (Placement(transformation(extent={{-100,-36},{-80,-16}})));
  Modelica.Blocks.Sources.Ramp ramp3(
    height=15e5,
    duration=0.3,
    offset=15e5,
    startTime=0.6) annotation (Placement(transformation(extent={{-100,-6},{-80,14}})));
  Boundaries.Gas.BoundaryRealGas_pTxi                      source4(p_const=500000)
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi sink4(p_const=100000) annotation (Placement(transformation(extent={{58,-80},{38,-60}})));
  ValveRealGas_L1 valve(openingInputIsActive=true) annotation (Placement(transformation(extent={{-10,-76},{10,-64}})));
  Modelica.Blocks.Sources.Ramp ramp4(
    startTime=0.1,
    height=1,
    duration=0.8,
    offset=0)      annotation (Placement(transformation(extent={{-100,-66},{-80,-46}})));
equation
  connect(ramp.y, valveDesiredMassFlow.m_flowDes) annotation (Line(points={{-79,66},{-34,66},{-34,34.2857},{-10,34.2857}},
                                                  color={0,0,127}));
  connect(timeTable.y, source2.p) annotation (Line(points={{-79,36},{-62,36}},
                           color={0,0,127}));
  connect(valveDesiredMassFlow.gasPortOut, sink2.gasPort) annotation (Line(
      points={{10,29.1429},{26,29.1429},{26,30},{40,30}},
      color={255,255,0},
      thickness=1.5));
  connect(valveDesiredMassFlow.gasPortIn, source2.gasPort) annotation (Line(
      points={{-10,29.1429},{-25,30},{-40,30}},
      color={255,255,0},
      thickness=1.5));
  connect(source1.gasPort, simpleValveDesiredPressureBefore.gasPortIn)
    annotation (Line(
      points={{-40,80},{-10,80},{-10,79.1429}},
      color={255,255,0},
      thickness=1.5));
  connect(simpleValveDesiredPressureBefore.gasPortOut, sink1.gasPort)
    annotation (Line(
      points={{10,79.1429},{25,80},{40,80}},
      color={255,255,0},
      thickness=1.5));
  connect(sink1.p, ramp1.y) annotation (Line(points={{62,86},{69,86}}, color={0,0,127}));
  connect(source3.gasPort, valve_p.gasPortIn) annotation (Line(
      points={{-40,-20},{-10,-20},{-10,-20.8571}},
      color={255,255,0},
      thickness=1.5));
  connect(valve_p.gasPortOut, sink3.gasPort) annotation (Line(
      points={{10,-20.8571},{18,-20},{38,-20}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp3.y, valve_p.dp_desired) annotation (Line(points={{-79,4},{-26,4},{-26,-15.2857},{-10,-15.2857}},
                                                                                                          color={0,0,127}));
  connect(ramp2.y, source3.m_flow) annotation (Line(points={{-79,-26},{-70,-26},{-70,-14},{-62,-14}}, color={0,0,127}));
  connect(source4.gasPort, valve.gasPortIn) annotation (Line(
      points={{-40,-70},{-10,-70},{-10,-70.8571}},
      color={255,255,0},
      thickness=1.5));
  connect(valve.gasPortOut, sink4.gasPort) annotation (Line(
      points={{10,-70.8571},{18,-70},{38,-70}},
      color={255,255,0},
      thickness=1.5));
  connect(ramp4.y, valve.opening_in) annotation (Line(points={{-79,-56},{0,-56},{0,-63.1429}},
                                                                                          color={0,0,127}));
  annotation (Diagram(graphics,
                      coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for different valves</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
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
</html>"));
end TestValves;
