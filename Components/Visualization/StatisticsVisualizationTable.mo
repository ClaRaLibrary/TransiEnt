within TransiEnt.Components.Visualization;
model StatisticsVisualizationTable
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
  Modelica.SIunits.Energy E_cons;
  Modelica.SIunits.Energy E_prod;
  TransiEnt.Basics.Units.MonetaryUnit Costs;
  Modelica.SIunits.Mass m_CO2;
  parameter Real decimalSpaces=0;
  Real x1;
  outer TransiEnt.ModelStatistics modelStatistics;
  Modelica.SIunits.Heat Q_prod;
  Modelica.SIunits.Heat Q_cons;

equation
  E_cons=modelStatistics.electricPower.E_consumer;
  E_prod=modelStatistics.electricPower.E_gen_total;
  Costs=modelStatistics.totalIncurredCosts.TotalSystemCosts;
  x1=0;
  m_CO2=modelStatistics.gwpEmissions.m_CDE_total;
  Q_cons=  modelStatistics.heatingPower.E_consumed;
  Q_prod=modelStatistics.heatingPower.E_total;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-300},{500,100}}), graphics={
        Rectangle(
          extent={{-100,-100},{100,-200}},
          lineColor={209,211,212},
          fillColor={209,211,212},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-200},{100,-300}},
          lineColor={221,222,223},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-78,-108},{76,-192}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineColor={73,80,85},
          textString="E_cons [TWh]"),
        Text(
          extent={{-98,-200},{102,-300}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({118,124,127}, if E_cons > 0 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect(" E_cons ", String(E_cons,format = "1."+String(decimalSpaces)+"f"))),
        Rectangle(extent={{-100,-100},{100,-300}},lineColor={135,135,135}),
        Rectangle(
          extent={{-100,100},{100,0}},
          lineColor={209,211,212},
          fillColor={209,211,212},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,0},{100,-100}},
          lineColor={221,222,223},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-78,92},{76,8}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineColor={73,80,85},
          textString="E_prod [TWh]"),
        Text(
          extent={{-98,0},{102,-100}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({118,124,127}, if E_prod > 0 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect(" E_prod ", String(E_prod/3.6e15, format = "1."+String(decimalSpaces)+"f"))),
        Rectangle(extent={{-100,100},{100,-100}},lineColor={135,135,135}),
        Rectangle(
          extent={{100,-100},{300,-200}},
          lineColor={209,211,212},
          fillColor={209,211,212},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{100,-200},{300,-300}},
          lineColor={221,222,223},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{122,-108},{276,-192}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineColor={73,80,85},
          textString="Q_cons [TWh]"),
        Text(
          extent={{102,-200},{302,-300}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({118,124,127}, if x1 > 0 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect(" Q_cons ", String(Q_cons/3.6e15,format = "1."+String(decimalSpaces)+"f"))),
        Rectangle(extent={{100,-100},{300,-300}},lineColor={135,135,135}),
        Rectangle(
          extent={{100,100},{300,0}},
          lineColor={209,211,212},
          fillColor={209,211,212},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{100,0},{300,-100}},
          lineColor={221,222,223},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{122,92},{276,8}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineColor={73,80,85},
          textString="Q_prod [TWh]"),
        Text(
          extent={{102,0},{302,-100}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({118,124,127}, if x1 > 0 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect(" Q_prod ", String(Q_prod/3.6e15,format = "1."+String(decimalSpaces)+"f"))),
        Rectangle(extent={{100,100},{300,-100}}, lineColor={135,135,135}),
        Rectangle(
          extent={{300,-100},{500,-200}},
          lineColor={209,211,212},
          fillColor={209,211,212},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{300,-200},{500,-300}},
          lineColor={221,222,223},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{322,-108},{476,-192}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineColor={73,80,85},
          textString="Costs [MEUR]"),
        Text(
          extent={{302,-200},{502,-300}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({118,124,127}, if x1 > 0 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect(" Costs ", String(Costs/1e6,format = "1."+String(decimalSpaces)+"f"))),
        Rectangle(extent={{300,-100},{500,-300}}, lineColor={135,135,135}),
        Rectangle(
          extent={{300,100},{500,0}},
          lineColor={209,211,212},
          fillColor={209,211,212},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{300,0},{500,-100}},
          lineColor={221,222,223},
          fillColor={221,222,223},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{322,92},{476,8}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineColor={73,80,85},
          textString="CO2 Emissions [Mton]"),
        Text(
          extent={{302,0},{502,-100}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor=DynamicSelect({118,124,127}, if x1 > 0 then {0,131,169} else {167,25,48}),
          textString=DynamicSelect(" x ", String(m_CO2/1e9,format = "1."+String(decimalSpaces)+"f"))),
        Rectangle(extent={{300,100},{500,-100}},  lineColor={135,135,135})}),                                Diagram(graphics,
                                                                                                                     coordinateSystem(preserveAspectRatio=false, extent={{-100,-300},{500,100}})),
    Documentation(info="<html>
<p><b><span style=\"font-family: MS Shell Dlg 2; color: #008000;\">1. Purpose of model</span></b></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Model for visulization of consumed energy/heat, produced electric energy/heat</span></p>
</html>"));
end StatisticsVisualizationTable;
