within TransiEnt.Producer.Heat.Power2Heat.ElectricBoiler.Check;
model Test_idContrMFlow_temp

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



  extends TransiEnt.Basics.Icons.Checkmodel;
  Modelica.Blocks.Sources.Sine sine(
    amplitude=1500,
    f=1/86400,
    offset=2000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-10,0})));
  ElectricBoiler_L1_idContrMFlow_temp electricBoiler_L1_idContrMFlow_temp(
    use_varTemp=true,
    m_flow_max=40,
    usePowerPort=true) annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Math.Gain gain1(k=-1)
                                       annotation (Placement(transformation(extent={{-26,-4},{-34,4}})));
  Modelica.Blocks.Sources.Sine sine1(
    f=1/86400,
    amplitude=15,
    phase=2.0943951023932,
    offset=60 + 273.15) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-70,-60})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_pTxi source(boundaryConditions(p_const(displayUnit="bar") = 100000), variable_T=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,-30})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_pTxi sink(boundaryConditions(p_const(displayUnit="bar") = 200000)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-30})));
  Modelica.Blocks.Sources.Sine sine2(
    f=1/86400,
    amplitude=15,
    phase=1.5707963267949,
    offset=60 + 273.15) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-70,30})));
  Modelica.Blocks.Sources.Sine sine3(
    amplitude=1500,
    f=1/86400,
    offset=2000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={90,0})));
  Producer.Heat.Power2Heat.Heatpump.EHP_L1_idContrMFlow_temp            eHP_L1_idContrMFlow_temp(
    use_varTemp=true,
    m_flow_max=40,
    use_T_source_input_K=true,
    usePowerPort=true)                                                                                       annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Math.Gain gain2(k=-1)
                                       annotation (Placement(transformation(extent={{74,-4},{66,4}})));
  Modelica.Blocks.Sources.Sine sine4(
    f=1/86400,
    amplitude=15,
    phase=2.0943951023932,
    offset=60 + 273.15) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={30,-60})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_pTxi source1(boundaryConditions(p_const(displayUnit="bar") = 100000), variable_T=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,-30})));
  TransiEnt.Components.Boundaries.FluidFlow.BoundaryVLE_pTxi sink1(boundaryConditions(p_const(displayUnit="bar") = 200000)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,-30})));
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
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency electricGrid(useInputConnector=false) annotation (Placement(transformation(extent={{-78,-10},{-98,10}})));
  TransiEnt.Components.Boundaries.Electrical.ActivePower.Frequency electricGrid1(useInputConnector=false) annotation (Placement(transformation(extent={{26,-10},{6,10}})));
  inner SimCenter simCenter annotation (Placement(transformation(extent={{70,80},{90,100}})));
equation
  connect(gain1.y, electricBoiler_L1_idContrMFlow_temp.Q_flow_set) annotation (Line(points={{-34.4,0},{-40,0}},     color={0,0,127}));
  connect(sine.y, gain1.u) annotation (Line(points={{-21,0},{-25.2,0}}, color={0,0,127}));
  connect(source.fluidPortIn, electricBoiler_L1_idContrMFlow_temp.fluidPortIn) annotation (Line(
      points={{-70,-20},{-70,-10},{-54,-10}},
      color={175,0,0},
      thickness=0.5));
  connect(electricBoiler_L1_idContrMFlow_temp.fluidPortOut, sink.fluidPortIn) annotation (Line(
      points={{-46,-10},{-30,-10},{-30,-20}},
      color={175,0,0},
      thickness=0.5));
  connect(sine1.y, source.T) annotation (Line(points={{-70,-49},{-70,-40}}, color={0,0,127}));
  connect(sine2.y, electricBoiler_L1_idContrMFlow_temp.T_out_set) annotation (Line(points={{-59,30},{-55,30},{-55,10}}, color={0,0,127}));
  connect(gain2.y, eHP_L1_idContrMFlow_temp.Q_flow_set) annotation (Line(points={{65.6,0},{60,0}}, color={0,0,127}));
  connect(sine3.y, gain2.u) annotation (Line(points={{79,0},{74.8,0}}, color={0,0,127}));
  connect(source1.fluidPortIn, eHP_L1_idContrMFlow_temp.fluidPortIn) annotation (Line(
      points={{30,-20},{30,-10},{46,-10}},
      color={175,0,0},
      thickness=0.5));
  connect(eHP_L1_idContrMFlow_temp.fluidPortOut, sink1.fluidPortIn) annotation (Line(
      points={{54,-10},{70,-10},{70,-20}},
      color={175,0,0},
      thickness=0.5));
  connect(sine4.y, source1.T) annotation (Line(points={{30,-49},{30,-40}}, color={0,0,127}));
  connect(sine5.y, eHP_L1_idContrMFlow_temp.T_out_set) annotation (Line(points={{41,30},{45,30},{45,10}}, color={0,0,127}));
  connect(sine6.y, eHP_L1_idContrMFlow_temp.T_source_input_K) annotation (Line(points={{79,30},{70,30},{70,5.9638},{60.0363,5.9638}}, color={0,0,127}));
  connect(electricBoiler_L1_idContrMFlow_temp.epp, electricGrid.epp) annotation (Line(
      points={{-60,0},{-78,0}},
      color={0,135,135},
      thickness=0.5));
  connect(eHP_L1_idContrMFlow_temp.epp, electricGrid1.epp) annotation (Line(
      points={{40,0},{26,0}},
      color={0,135,135},
      thickness=0.5));
  annotation (
    Icon(graphics,
         coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-80,86},{-24,66}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          textString="look at 
-mass flow rates
-Q_flow_set and Q_flow",
          horizontalAlignment=TextAlignment.Left)}),
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
