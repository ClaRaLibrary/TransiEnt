within TransiEnt.Producer.Combined.LargeScaleCHP.Base;
model HeatInputTable "Table based model which delivers the amount of heat input required by a Large Scale CHP plant to produce a given el. and th. output"

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
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn P annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-70,120})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateIn Q_flow annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={70,120})));
  TransiEnt.Basics.Interfaces.Thermal.HeatFlowRateOut Q_flow_input annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-110})));
  // _____________________________________________
  //
  //             Visible Parameters
  // _____________________________________________

  parameter TransiEnt.Producer.Combined.LargeScaleCHP.Base.Characteristics.Generic_PQ_Characteristics PQCharacteristics=Characteristics.PQ_Characteristics_WW1() annotation (choicesAllMatching);
  parameter SI.HeatFlowRate Q_flow_n=Q_flow_n_PQCharacteristics;
  parameter SI.Power P_el_n=P_el_n_PQCharacteristics;
  final parameter SI.HeatFlowRate Q_flow_n_PQCharacteristics=max(PQCharacteristics.PQboundaries[:, 1]);
  final parameter SI.Power P_el_n_PQCharacteristics=max(PQCharacteristics.PQboundaries[:, 2:3]);
  // ______________________________________________
  //
  //             Components
  // ______________________________________________

  TransiEnt.Basics.Tables.GenericCombiTable2D genericCombiTable2D(combiTable2D(tableOnFile=false, table=PQCharacteristics.PQ_HeatInput_Matrix)) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Math.Gain gain_Q_flow(k=PQCharacteristics.k_Q_flow*Q_flow_n_PQCharacteristics/Q_flow_n) annotation (Placement(transformation(extent={{38,46},{18,66}})));
  Modelica.Blocks.Math.Gain gain_P_max(k=1/PQCharacteristics.k_P_el*P_el_n_PQCharacteristics/P_el_n) annotation (Placement(transformation(extent={{-48,-2},{-28,18}})));
  Modelica.Blocks.Math.Division division annotation (Placement(transformation(extent={{-70,-60},{-50,-40}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=gain_P_max.u + gain_Q_flow.u) annotation (Placement(transformation(extent={{-100,-54},{-80,-34}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=max(1e-3, gain_P_max.y + gain_Q_flow.y)) annotation (Placement(transformation(extent={{-100,-66},{-80,-46}})));
  Modelica.Blocks.Math.Product product annotation (Placement(transformation(extent={{-38,-54},{-18,-34}})));
equation

  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________
  connect(Q_flow, gain_Q_flow.u) annotation (Line(points={{70,120},{70,56},{40,56}}, color={0,0,127}));
  connect(genericCombiTable2D.u1, gain_P_max.y) annotation (Line(points={{-12,7},{-27,7},{-27,8}}, color={0,0,127}));
  connect(gain_P_max.u, P) annotation (Line(points={{-50,8},{-70,8},{-70,120}}, color={0,0,127}));
  connect(gain_Q_flow.y, genericCombiTable2D.u2) annotation (Line(points={{17,56},{-90,56},{-90,-7},{-12,-7}}, color={0,0,127}));
  connect(division.u1, realExpression.y) annotation (Line(points={{-72,-44},{-79,-44}}, color={0,0,127}));
  connect(division.u2, realExpression1.y) annotation (Line(points={{-72,-56},{-79,-56}}, color={0,0,127}));
  connect(division.y, product.u2) annotation (Line(points={{-49,-50},{-40,-50}}, color={0,0,127}));
  connect(product.u1, genericCombiTable2D.y) annotation (Line(points={{-40,-38},{-44,-38},{-44,-20},{11,-20},{11,0}}, color={0,0,127}));
  connect(Q_flow_input, product.y) annotation (Line(
      points={{0,-110},{0,-84},{-10,-84},{-10,-44},{-17,-44}},
      color={175,0,0},
      pattern=LinePattern.Dash));
   annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                 Icon(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{120,100}}), graphics={
                                   Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Rectangle(
          extent={{-50,60},{0,-60}},
          lineColor={255,255,255},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Line(points={{-50,-60},{-50,60},{50,60},{50,-60},{-50,-60},{-50,-30},{
              50,-30},{50,0},{-50,0},{-50,30},{50,30},{50,60},{0,60},{0,-61}},
            color={0,0,0}),                     Text(
          extent={{-94,-56},{-44,-104}},
          lineColor={0,128,0},
          textStyle={TextStyle.Bold},
          textString="S4"),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-76,94},{-84,72},{-68,72},{-76,94}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-76,72},{-76,-76}}, color={192,192,192}),
        Line(points={{-86,-66},{86,-66}}, color={192,192,192}),
        Polygon(
          points={{94,-66},{72,-58},{72,-74},{94,-66}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-76,62},{-60,62},{62,14}},
          color={255,128,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-76,-24},{-24,-44},{62,-10}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{62,14},{62,-10}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Text(
          extent={{-100,100},{-78,68}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="P"),
        Text(
          extent={{72,-70},{94,-104}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Q"),
        Line(
          points={{-60,62},{62,14}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-76,58},{62,4}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-76,48},{62,-6}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-76,36},{54,-14}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-76,24},{38,-20}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-76,12},{22,-26}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-76,0},{5,-32}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-76,-12},{-12,-38}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-76,-24},{-24,-44}},
          color={255,0,0},
          smooth=Smooth.None,
          thickness=0.5),
        Text(
          extent={{-58,48},{22,-22}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Q_flow_in"),
        Text(
          extent={{-150,-111},{150,-151}},
          lineColor={0,134,134},
          textString="%name")}),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Table based model which delivers the amount of heat flow input required by a Large Scale CHP plant to produce a given el. and th. output</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">3. Limits of validity </span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">4. Interfaces</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">RealInput - electrical power setpoint input</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">RealInput - thermal energy setpoint input</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">HeatFlowRateOut - required heat flow output</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">5. Nomenclature</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">6. Governing Equations</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">7. Remarks for Usage</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">8. Validation</span></b></p>
<p>Tested in check model &quot;TransiEnt.Producer.Combined.LargeScaleCHP.Base.Check.TestHeatInputTable&quot;</p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">9. References</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">(no remarks)</span></p>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">10. Version History</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model modified by Oliver Schülting (oliver.schuelting@tuhh.de), Jun 2018: Scaling, depending on P_n and Q_flow_nom added</span></p>
</html>"));
end HeatInputTable;
