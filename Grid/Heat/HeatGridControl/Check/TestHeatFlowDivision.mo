within TransiEnt.Grid.Heat.HeatGridControl.Check;
model TestHeatFlowDivision
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

  Modelica.Blocks.Sources.Ramp Q_flow_total_2(
    duration=3600,
    offset=0,
    height=360e6) annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

  function plotResult

  algorithm

  createPlot(id=1, position={759, 0, 741, 837}, x="heatFlowDivision_4.Q_flow_total", y={"heatFlowDivision_4.Q_flow_i[1]", "heatFlowDivision_4.Q_flow_i[2]",
  "heatFlowDivision_4.Q_flow_i[3]", "heatFlowDivision_4.Q_flow_i[4]",
  "heatFlowDivision_4.Q_flow_total"}, range={0.0, 900000000.0, -50000000.0, 950000000.0}, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}, {217,67,180}, {0,0,0}});
  createPlot(id=2, position={0, 0, 743, 837}, x="heatFlowDivision_2.Q_flow_total", y={"heatFlowDivision_2.Q_flow_i[1]", "heatFlowDivision_2.Q_flow_i[2]",
  "heatFlowDivision_2.Q_flow_total"}, range={0.0, 360000000.0, -20000000.0, 380000000.0}, grid=true, colors={{28,108,200}, {238,46,47}, {0,140,72}});
  end plotResult;

  HeatFlowDivision heatFlowDivision_2(HeatFlowCL=Base.DHGHeatFlowDivisionCharacteristicLines.SampleHeatFlowCharacteristicLines2Units()) annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Modelica.Blocks.Sources.Ramp Q_flow_total_4(
    duration=3600,
    height=900e6,
    offset=0) annotation (Placement(transformation(extent={{-50,-62},{-30,-42}})));
  HeatFlowDivision heatFlowDivision_4(HeatFlowCL=Base.DHGHeatFlowDivisionCharacteristicLines.SampleHeatFlowCharacteristicLines4Units()) annotation (Placement(transformation(extent={{-8,-62},{12,-42}})));
equation
  connect(Q_flow_total_2.y, heatFlowDivision_2.Q_flow_total) annotation (Line(points={{-29,0},{-22,0},{-14,0}}, color={0,0,127}));
  connect(Q_flow_total_4.y, heatFlowDivision_4.Q_flow_total) annotation (Line(points={{-29,-52},{-10,-52}}, color={0,0,127}));
  annotation (Icon(graphics,
                   coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
                                                                         coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=3600),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Tester for HeatFlowDivision model</p>
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
<p><span style=\"color: #008000;\">(no remarks)</span></p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end TestHeatFlowDivision;
