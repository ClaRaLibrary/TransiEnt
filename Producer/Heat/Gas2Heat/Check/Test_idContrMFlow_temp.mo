within TransiEnt.Producer.Heat.Gas2Heat.Check;
model Test_idContrMFlow_temp


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.1                             //
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




  extends TransiEnt.Basics.Icons.Checkmodel;
  Modelica.Blocks.Sources.Sine sine3(
    amplitude=1500,
    f=1/86400,
    offset=2000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={90,0})));
  GHP_L1_idContrMFlow_temp gHP_L1_idContrMFlow_temp(
    use_varTemp=true,
    m_flow_max=40,
    useGasPort=true,
    use_T_source_input_K=true) annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Math.Gain gain2(k=-1)
                                       annotation (Placement(transformation(extent={{74,-4},{66,4}})));
  Modelica.Blocks.Sources.Sine sine4(
    f=1/86400,
    amplitude=15,
    phase=2.0943951023932,
    offset=60 + 273.15) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={34,-62})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_pTxi source1(boundaryConditions(p_const(displayUnit="bar") = 100000), variable_T=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={34,-30})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_pTxi sink1(boundaryConditions(p_const(displayUnit="bar") = 200000)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={64,-30})));
  Modelica.Blocks.Sources.Sine sine5(
    f=1/86400,
    amplitude=15,
    phase=1.5707963267949,
    offset=60 + 273.15) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={30,30})));
  Modelica.Blocks.Sources.Sine sine6(
    f=1/86400,
    amplitude=15,
    offset=5 + 273.15,
    phase=3.3161255787892) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={90,30})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={80,-54})));
  GB_L1_idContrMFlow_temp gB_L1_idContrMFlow_temp(use_varTemp=true) annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Math.Gain gain1(k=-1)
                                       annotation (Placement(transformation(extent={{-24,-4},{-32,4}})));
  Modelica.Blocks.Sources.Sine sine1(
    amplitude=1500,
    f=1/86400,
    offset=2000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-6,0})));
  Modelica.Blocks.Sources.Sine sine2(
    f=1/86400,
    amplitude=15,
    phase=1.5707963267949,
    offset=60 + 273.15) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-76,32})));
  Components.Boundaries.Gas.BoundaryRealGas_pTxi boundary_pTxi1 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,-52})));
  Components.Boundaries.FluidFlow.BoundaryVLE_pTxi           source2(boundaryConditions(p_const(displayUnit="bar") = 100000), variable_T=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-66,-28})));
  Components.Boundaries.FluidFlow.BoundaryVLE_pTxi           sink2(boundaryConditions(p_const(displayUnit="bar") = 200000)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-36,-28})));
  Modelica.Blocks.Sources.Sine sine7(
    f=1/86400,
    amplitude=15,
    phase=2.0943951023932,
    offset=60 + 273.15) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-66,-54})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{70,80},{90,100}})));
equation
  connect(gain2.y,gHP_L1_idContrMFlow_temp. Q_flow_set) annotation (Line(points={{65.6,0},{60,0}}, color={0,0,127}));
  connect(sine3.y, gain2.u) annotation (Line(points={{79,0},{74.8,0}}, color={0,0,127}));
  connect(source1.fluidPortIn,gHP_L1_idContrMFlow_temp. fluidPortIn) annotation (Line(
      points={{34,-20},{34,-10},{46,-10}},
      color={175,0,0},
      thickness=0.5));
  connect(gHP_L1_idContrMFlow_temp.fluidPortOut, sink1.fluidPortIn) annotation (Line(
      points={{54,-10},{64,-10},{64,-20}},
      color={175,0,0},
      thickness=0.5));
  connect(sine4.y, source1.T) annotation (Line(points={{34,-51},{34,-40}}, color={0,0,127}));
  connect(sine5.y,gHP_L1_idContrMFlow_temp. T_out_set) annotation (Line(points={{41,30},{45,30},{45,10}}, color={0,0,127}));
  connect(sine6.y,gHP_L1_idContrMFlow_temp. T_source_input_K) annotation (Line(points={{79,30},{64,30},{64,6},{60,6}},                color={0,0,127}));
  connect(gHP_L1_idContrMFlow_temp.gasPortIn, boundary_pTxi.gasPort) annotation (Line(
      points={{60,-4},{66,-4},{66,-18},{80,-18},{80,-44}},
      color={255,255,0},
      thickness=1.5));
  connect(gain1.y, gB_L1_idContrMFlow_temp.Q_flow_set) annotation (Line(points={{-32.4,0},{-40,0}}, color={0,0,127}));
  connect(gain1.u, sine1.y) annotation (Line(points={{-23.2,0},{-20,0},{-20,8.88178e-16},{-17,8.88178e-16}}, color={0,0,127}));
  connect(sine2.y, gB_L1_idContrMFlow_temp.T_out_set) annotation (Line(points={{-65,32},{-55,32},{-55,10}}, color={0,0,127}));
  connect(gB_L1_idContrMFlow_temp.gasPortIn, boundary_pTxi1.gasPort) annotation (Line(
      points={{-40,-4},{-34,-4},{-34,-16},{-20,-16},{-20,-42}},
      color={255,255,0},
      thickness=1.5));
  connect(gB_L1_idContrMFlow_temp.fluidPortIn, source2.fluidPortIn) annotation (Line(
      points={{-54,-10},{-66,-10},{-66,-18}},
      color={175,0,0},
      thickness=0.5));
  connect(gB_L1_idContrMFlow_temp.fluidPortOut, sink2.fluidPortIn) annotation (Line(
      points={{-46,-10},{-36,-10},{-36,-18}},
      color={175,0,0},
      thickness=0.5));
  connect(source2.T, sine7.y) annotation (Line(points={{-66,-38},{-66,-43}}, color={0,0,127}));
  annotation (
    Icon(graphics,
         coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-80,86},{-24,66}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="look at 
-mass flow rate
-Q_flow_set and Q_flow")}),
    experiment(StopTime=432000, Interval=900),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Test environment for HeatPumpElectricCharline</p>
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
</html>"));
end Test_idContrMFlow_temp;
