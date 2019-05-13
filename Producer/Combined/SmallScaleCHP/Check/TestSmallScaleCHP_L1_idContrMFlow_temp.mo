within TransiEnt.Producer.Combined.SmallScaleCHP.Check;
model TestSmallScaleCHP_L1_idContrMFlow_temp
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
  Modelica.Blocks.Sources.Sine sine(
    amplitude=1500,
    freqHz=1/86400,
    offset=2000) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-10,0})));
  SmallScaleCHP_L1_idContrMFlow_temp  smallScaleCHP_L1_idContrMFlow_temp(use_varTemp=true, m_flow_max=40)    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Math.Gain gain1(k=-1)
                                       annotation (Placement(transformation(extent={{-26,-4},{-34,4}})));
  Modelica.Blocks.Sources.Sine sine1(
    freqHz=1/86400,
    amplitude=15,
    phase=2.0943951023932,
    offset=60 + 273.15)
                 annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-70,-60})));
  Components.Boundaries.FluidFlow.BoundaryVLE_pTxi           source(boundaryConditions(p_const(displayUnit="bar") = 100000), variable_T=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,-30})));
  Components.Boundaries.FluidFlow.BoundaryVLE_pTxi           sink(boundaryConditions(p_const(displayUnit="bar") = 200000)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-30})));
  Modelica.Blocks.Sources.Sine sine2(
    freqHz=1/86400,
    amplitude=15,
    phase=1.5707963267949,
    offset=60 + 273.15)
                 annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-70,30})));
equation
  connect(gain1.y, smallScaleCHP_L1_idContrMFlow_temp.Q_flow_set) annotation (Line(points={{-34.4,0},{-40,0}}, color={0,0,127}));
  connect(sine.y,gain1. u) annotation (Line(points={{-21,0},{-25.2,0}}, color={0,0,127}));
  connect(source.fluidPortIn, smallScaleCHP_L1_idContrMFlow_temp.fluidPortIn) annotation (Line(
      points={{-70,-20},{-70,-10},{-54,-10}},
      color={175,0,0},
      thickness=0.5));
  connect(smallScaleCHP_L1_idContrMFlow_temp.fluidPortOut, sink.fluidPortIn) annotation (Line(
      points={{-46,-10},{-30,-10},{-30,-20}},
      color={175,0,0},
      thickness=0.5));
  connect(sine1.y,source. T) annotation (Line(points={{-70,-49},{-70,-40}}, color={0,0,127}));
  connect(sine2.y, smallScaleCHP_L1_idContrMFlow_temp.T_out_set) annotation (Line(points={{-59,30},{-50,30},{-50,10}}, color={0,0,127}));
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
<p>Test environment for HeatPumpGasCharline</p>
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
end TestSmallScaleCHP_L1_idContrMFlow_temp;