within TransiEnt.Producer.Gas.Electrolyzer.Check;
model ComparisonOfElectrolyzer "Model for comparing the ElectrolyzerL1 with the ElectrolyzerL2"


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-BSD-clause.           //
// Copyright 2021, Hamburg University of Technology.                              //
//________________________________________________________________________________//
//                                                                                //
// TransiEnt.EE, ResiliEntEE, IntegraNet and IntegraNet II are research projects  //
// supported by the German Federal Ministry of Economics and Energy               //
// (FKZ 03ET4003, 03ET4048, 0324027 and 03EI1008).                                //
// The TransiEnt Library research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology),    //
// Institute of Energy Systems (Hamburg University of Technology),                //
// Institute of Electrical Power and Energy Technology                            //
// (Hamburg University of Technology)                                             //
// Fraunhofer Institute for Environmental, Safety, and Energy Technology UMSICHT, //
// Gas- und Wärme-Institut Essen						  //
// and                                                                            //
// XRG Simulation GmbH (Hamburg, Germany).                                        //
//________________________________________________________________________________//




  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Checkmodel;
  import      Modelica.Units.SI;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter SI.Pressure p_out=35e5 "Pressure of the produced hydrogen";
  parameter SI.Power P_el_n=4.5e4 "Nominal electrical power of the electrolyzer";
  parameter SI.Power P_el_min=0.05*P_el_n "Minimal electrical power of the electrolyzer";
  parameter SI.Power P_el_max=1.0*P_el_n "Maximal electrical power of the electrolyzer";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L2 electrolyzer(
    useFluidCoolantPort=false,
    whichInput=3,
    redeclare model electrolyzerMassFlow = TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.MassFlow.MassFlow1thOrderDynamics (tau=100)) annotation (Placement(transformation(extent={{10,100},{30,120}})));
  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L1 electrolyzer1(
    P_el_n=4.5e4,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics1stOrder (tau=100),                                                          redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer100)
                                                                       annotation (Placement(transformation(extent={{10,52},{30,72}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid annotation (Placement(transformation(extent={{-20,120},{-40,100}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid1 annotation (Placement(transformation(extent={{-20,72},{-40,52}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi(medium=simCenter.gasModel3) annotation (Placement(transformation(extent={{80,52},{60,72}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi1(medium=simCenter.gasModel3, p_const=p_out)
                                                                                                      annotation (Placement(transformation(extent={{80,100},{60,120}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=4.5e4)
                                                                annotation (Placement(transformation(extent={{150,90},{170,110}})));
  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L2 electrolyzer2(
    useFluidCoolantPort=true,
    whichInput=3,
    redeclare model electrolyzerMassFlow = TransiEnt.Producer.Gas.Electrolyzer.Base.Physics.MassFlow.MassFlow2thOrderDynamics) annotation (Placement(transformation(extent={{-42,0},{-22,20}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid2 annotation (Placement(transformation(extent={{-72,20},{-92,0}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi2(medium=simCenter.gasModel3) annotation (Placement(transformation(extent={{28,0},{8,20}})));
  inner TransiEnt.SimCenter simCenter annotation (Placement(transformation(extent={{148,118},{168,138}})));
  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L1 electrolyzer3(useFluidCoolantPort=true,
    P_el_n=4.5e4,
    calculateCost=false,
    redeclare model Dynamics = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerDynamics2ndOrder,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer100)
                                                                                                 annotation (Placement(transformation(extent={{-42,-60},{-22,-40}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid3 annotation (Placement(transformation(extent={{-72,-40},{-92,-60}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi3(medium=simCenter.gasModel3) annotation (Placement(transformation(extent={{46,-60},{26,-40}})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink8(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=20 + 273.15)  annotation (Placement(transformation(
        extent={{7.5,8.5},{-7.5,-8.5}},
        rotation=0,
        origin={57.5,-11.5})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink3(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{-7.5,-7.5},{7.5,7.5}},
        rotation=180,
        origin={57.5,12.5})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink1(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=20 + 273.15)  annotation (Placement(transformation(
        extent={{7.5,8.5},{-7.5,-8.5}},
        rotation=0,
        origin={75.5,-66.5})));
  ClaRa.Components.BoundaryConditions.BoundaryVLE_pTxi sink2(
    medium=simCenter.fluid1,
    p_const=17e5,
    T_const=130 + 273.15) annotation (Placement(transformation(
        extent={{9.5,8.5},{-9.5,-8.5}},
        rotation=0,
        origin={73.5,-38.5})));
  Modelica.Blocks.Sources.Pulse pulse(amplitude=4.5e4, period=3600)   annotation (Placement(transformation(extent={{-160,-16},{-140,4}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid4 annotation (Placement(transformation(extent={{-80,-94},{-100,-114}})));
  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L2 electrolyzer4(
    useFluidCoolantPort=false,
    useHeatPort=true,
    whichInput=3) annotation (Placement(transformation(extent={{-50,-114},{-30,-94}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi4(medium=simCenter.gasModel3) annotation (Placement(transformation(extent={{18,-114},{-2,-94}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=288.15) annotation (Placement(transformation(extent={{48,-132},{28,-112}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency ElectricGrid5 annotation (Placement(transformation(extent={{-82,-136},{-102,-156}})));
  TransiEnt.Producer.Gas.Electrolyzer.PEMElectrolyzer_L1 electrolyzer5(
    useFluidCoolantPort=false,
    useHeatPort=true,
    P_el_n=4.5e4,
    calculateCost=false,
    redeclare model Charline = TransiEnt.Producer.Gas.Electrolyzer.Base.ElectrolyzerEfficiencyCharlineSilyzer200)
                                                                                                 annotation (Placement(transformation(extent={{-50,-156},{-30,-136}})));
  TransiEnt.Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi5(medium=simCenter.gasModel3) annotation (Placement(transformation(extent={{18,-156},{-2,-136}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T=288.15) annotation (Placement(transformation(extent={{48,-178},{28,-158}})));
  Modelica.Blocks.Sources.Step step1(height=-(P_el_max - P_el_min),
    offset=0,
    startTime=21600)                 annotation (Placement(transformation(extent={{-128,72},{-108,92}})));
  Modelica.Blocks.Sources.Step step(
    offset=0,
    height=P_el_max - P_el_min,
    startTime=720)                  annotation (Placement(transformation(extent={{-128,110},{-108,130}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=2) annotation (Placement(transformation(extent={{-82,98},{-70,110}})));
  Modelica.Blocks.Sources.Ramp rampPower(
    height=P_el_max,
    offset=0,
    duration=36000,
    startTime=0)  annotation (Placement(transformation(extent={{-160,-114},{-140,-94}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureSensor(unitOption=2)
                                                                   annotation (Placement(transformation(extent={{8,26},{28,46}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureSensor1(unitOption=2)
                                                                    annotation (Placement(transformation(extent={{8,-26},{28,-6}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureSensor2(unitOption=2)
                                                                    annotation (Placement(transformation(extent={{-12,-44},{8,-24}})));
  TransiEnt.Components.Sensors.TemperatureSensor temperatureSensor3(unitOption=2)
                                                                    annotation (Placement(transformation(extent={{-6,-72},{14,-52}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=P_el_max - P_el_min,
    duration=3600,
    startTime=3600) annotation (Placement(transformation(extent={{-160,110},{-140,130}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    height=-(P_el_max - P_el_min),
    duration=3600,
    startTime=28800) annotation (Placement(transformation(extent={{-160,72},{-140,92}})));
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  connect(electrolyzer.epp, ElectricGrid.epp) annotation (Line(
      points={{10,110},{-20,110}},
      color={0,135,135},
      thickness=0.5));
  connect(electrolyzer1.epp, ElectricGrid1.epp) annotation (Line(
      points={{10,62},{-20,62}},
      color={0,135,135},
      thickness=0.5));
  connect(electrolyzer1.gasPortOut, boundary_pTxi.gasPort) annotation (Line(
      points={{30,62},{60,62}},
      color={255,255,0},
      thickness=1.5));
  connect(electrolyzer.gasPortOut, boundary_pTxi1.gasPort) annotation (Line(
      points={{30,110},{60,110}},
      color={255,255,0},
      thickness=1.5));
  connect(electrolyzer2.epp, ElectricGrid2.epp) annotation (Line(
      points={{-42,10},{-72,10}},
      color={0,135,135},
      thickness=0.5));
  connect(electrolyzer2.gasPortOut, boundary_pTxi2.gasPort) annotation (Line(
      points={{-22,10},{8,10}},
      color={255,255,0},
      thickness=1.5));
  connect(electrolyzer3.epp, ElectricGrid3.epp) annotation (Line(
      points={{-42,-50},{-72,-50}},
      color={0,135,135},
      thickness=0.5));
  connect(electrolyzer3.gasPortOut, boundary_pTxi3.gasPort) annotation (Line(
      points={{-22,-50},{26,-50}},
      color={255,255,0},
      thickness=1.5));
  connect(electrolyzer4.gasPortOut,boundary_pTxi4. gasPort) annotation (Line(
      points={{-30,-104},{-2,-104}},
      color={255,255,0},
      thickness=1.5));
  connect(ElectricGrid4.epp, electrolyzer4.epp) annotation (Line(
      points={{-80,-104},{-50,-104}},
      color={0,135,135},
      thickness=0.5));
  connect(electrolyzer4.heat, fixedTemperature.port) annotation (Line(points={{-30,-110.6},{-16,-110.6},{-16,-122},{28,-122}},
                                                                                                                           color={191,0,0}));
  connect(electrolyzer5.gasPortOut,boundary_pTxi5. gasPort) annotation (Line(
      points={{-30,-146},{-2,-146}},
      color={255,255,0},
      thickness=1.5));
  connect(ElectricGrid5.epp, electrolyzer5.epp) annotation (Line(
      points={{-82,-146},{-50,-146}},
      color={0,135,135},
      thickness=0.5));
  connect(electrolyzer5.heat, fixedTemperature1.port) annotation (Line(points={{-30,-152.6},{-14,-152.6},{-14,-168},{28,-168}},
                                                                                                                            color={191,0,0}));
  connect(multiSum.y, electrolyzer1.P_el_set) annotation (Line(points={{-68.98,104},{-54,104},{-54,80},{16,80},{16,74}},    color={0,0,127}));
  connect(multiSum.y, electrolyzer.P_el_set) annotation (Line(points={{-68.98,104},{-54,104},{-54,134},{16.2,134},{16.2,122}}, color={0,0,127}));
  connect(rampPower.y, electrolyzer4.P_el_set) annotation (Line(points={{-139,-104},{-118,-104},{-118,-80},{-43.8,-80},{-43.8,-92}},    color={0,0,127}));
  connect(rampPower.y, electrolyzer5.P_el_set) annotation (Line(points={{-139,-104},{-118,-104},{-118,-126},{-44,-126},{-44,-134}}, color={0,0,127}));
  connect(pulse.y, electrolyzer2.P_el_set) annotation (Line(points={{-139,-6},{-100,-6},{-100,36},{-35.8,36},{-35.8,22}},    color={0,0,127}));
  connect(electrolyzer2.fluidPortOut, temperatureSensor.port) annotation (Line(
      points={{-22,6},{-12,6},{-12,26},{18,26}},
      color={175,0,0},
      thickness=0.5));
  connect(temperatureSensor.port, sink3.steam_a) annotation (Line(
      points={{18,26},{34,26},{34,12.5},{50,12.5}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(electrolyzer2.fluidPortIn, temperatureSensor1.port) annotation (Line(
      points={{-22,1},{-12,1},{-12,-26},{18,-26}},
      color={175,0,0},
      thickness=0.5));
  connect(temperatureSensor1.port, sink8.steam_a) annotation (Line(
      points={{18,-26},{34,-26},{34,-11.5},{50,-11.5}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(pulse.y, electrolyzer3.P_el_set) annotation (Line(points={{-139,-6},{-100,-6},{-100,-26},{-36,-26},{-36,-38}},   color={0,0,127}));
  connect(electrolyzer3.fluidPortOut, temperatureSensor2.port) annotation (Line(
      points={{-22,-54},{-2,-54},{-2,-44}},
      color={175,0,0},
      thickness=0.5));
  connect(temperatureSensor2.port, sink2.steam_a) annotation (Line(
      points={{-2,-44},{20,-44},{20,-38.5},{64,-38.5}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(electrolyzer3.fluidPortIn, temperatureSensor3.port) annotation (Line(
      points={{-22,-59},{-12,-59},{-12,-72},{4,-72}},
      color={175,0,0},
      thickness=0.5));
  connect(temperatureSensor3.port, sink1.steam_a) annotation (Line(
      points={{4,-72},{36,-72},{36,-66.5},{68,-66.5}},
      color={0,131,169},
      pattern=LinePattern.Solid,
      thickness=0.5));
  connect(step.y, multiSum.u[1]) annotation (Line(points={{-107,120},{-94,120},{-94,106.1},{-82,106.1}}, color={0,0,127}));
  connect(step1.y, multiSum.u[2]) annotation (Line(points={{-107,82},{-94,82},{-94,101.9},{-82,101.9}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(extent={{-160,-180},{200,140}}), graphics={
        Text(
          extent={{88,-114},{194,-164}},
          lineColor={28,108,200},
          textString="heat port test 
comparision of the heat flow of the 
different electrolyzer models
comparison of the efficiency 
curve of the different electrolyzer models

"),     Text(
          extent={{88,-4},{194,-54}},
          lineColor={28,108,200},
          textString="test of the fluid ports 
with internal 
mass flow control of the cooling 
system of the electrolyzer

"),     Text(
          extent={{88,88},{194,38}},
          lineColor={28,108,200},
          textString="test and comparison of 
first order electrolyzer dynamics
with a high time constant 

")}),
    Icon(coordinateSystem(extent={{-160,-180},{200,140}})),
    experiment(StopTime=36000, __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<h4><span style=\"color: #008300\">1. Purpose of model</span></h4>
<p>Model for testing and comparing the L2 electrolyzer to the L1 electrolyzer. They can be compared in terms of dynamic behaviour, heat production and efficiency.</p>
<h4><span style=\"color: #008300\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008300\">3. Limits of validity </span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008300\">4. Interfaces</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008300\">5. Nomenclature</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008300\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008300\">7. Remarks for Usage</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008300\">8. Validation</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008300\">9. References</span></h4>
<p>(no remarks) </p>
<h4><span style=\"color: #008300\">10. Version History</span></h4>
<p>Created by Jan Westphal (j.westphal@tuhh.de) dec 2019.</p>
</html>"));
end ComparisonOfElectrolyzer;
