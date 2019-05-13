within TransiEnt.Producer.Heat.Gas2Heat.Check;
model Test_idContrMFlow_temp
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
  Modelica.Blocks.Sources.Sine sine3(
    amplitude=1500,
    freqHz=1/86400,
    offset=2000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={90,0})));
  GHP_L1_idContrMFlow_temp gHP_L1_idContrMFlow_temp(
    use_varTemp=true,
    m_flow_max=40,
    use_T_source_input_K=true) annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Math.Gain gain2(k=-1)
                                       annotation (Placement(transformation(extent={{74,-4},{66,4}})));
  Modelica.Blocks.Sources.Sine sine4(
    freqHz=1/86400,
    amplitude=15,
    phase=2.0943951023932,
    offset=60 + 273.15)
                 annotation (Placement(transformation(
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
    freqHz=1/86400,
    amplitude=15,
    phase=1.5707963267949,
    offset=60 + 273.15)
                 annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={30,30})));
  Modelica.Blocks.Sources.Sine sine6(
    freqHz=1/86400,
    amplitude=15,
    offset=5 + 273.15,
    phase=3.3161255787892)
                 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={90,30})));
equation
  connect(gain2.y,gHP_L1_idContrMFlow_temp. Q_flow_set) annotation (Line(points={{65.6,0},{60,0}}, color={0,0,127}));
  connect(sine3.y, gain2.u) annotation (Line(points={{79,0},{74.8,0}}, color={0,0,127}));
  connect(source1.fluidPortIn,gHP_L1_idContrMFlow_temp. fluidPortIn) annotation (Line(
      points={{30,-20},{30,-10},{46,-10}},
      color={175,0,0},
      thickness=0.5));
  connect(gHP_L1_idContrMFlow_temp.fluidPortOut, sink1.fluidPortIn) annotation (Line(
      points={{54,-10},{70,-10},{70,-20}},
      color={175,0,0},
      thickness=0.5));
  connect(sine4.y, source1.T) annotation (Line(points={{30,-49},{30,-40}}, color={0,0,127}));
  connect(sine5.y,gHP_L1_idContrMFlow_temp. T_out_set) annotation (Line(points={{41,30},{50,30},{50,10}}, color={0,0,127}));
  connect(sine6.y,gHP_L1_idContrMFlow_temp. T_source_input_K) annotation (Line(points={{79,30},{70,30},{70,6},{60,6}},                color={0,0,127}));
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
