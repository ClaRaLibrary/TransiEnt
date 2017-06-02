within TransiEnt.Producer.Heat.Power2Heat.Base;
partial model PartialHeatPumpSystemModel "Partial model of a controlled heat pump model useable for large pool simulations in demand side management scenarios"

//___________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.0.1                        //
//                                                                           //
// Licensed by Hamburg University of Technology under Modelica License 2.    //
// Copyright 2017, Hamburg University of Technology.                         //
//___________________________________________________________________________//
//                                                                           //
// TransiEnt.EE is a research project supported by the German Federal        //
// Ministry of Economics and Energy (FKZ 03ET4003).                          //
// The TransiEnt.EE research team consists of the following project partners://
// Institute of Engineering Thermodynamics (Hamburg University of Technology)//
// Institute of Energy Systems (Hamburg University of Technology),           //
// Institute of Electrical Power Systems and Automation                      //
// (Hamburg University of Technology),                                       //
// and is supported by                                                       //
// XRG Simulation GmbH (Hamburg, Germany).                                   //
//___________________________________________________________________________//

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

  outer TransiEnt.SimCenter simCenter;

  replaceable TransiEnt.Producer.Heat.Power2Heat.Components.HeatpumpSystemProperties params constrainedby TransiEnt.Producer.Heat.Power2Heat.Components.HeatpumpSystemProperties annotation (Placement(transformation(extent={{-94,76},{-74,96}})), choicesAllMatching=true);

  parameter Integer nStor=1;
  parameter SI.Energy E_stor[nStor]=fill(0,nStor);
  final parameter SI.Energy E_stor_total=sum(E_stor);

  // To be defined by child classes
  SI.Power P_el;
  SI.Power P_el_n;
  SI.HeatFlowRate Q_flow_demand;
  SI.HeatFlowRate Q_flow_max "Time dependent maximum heat generation capacity (ambient temperature dependent)";
  SI.HeatFlowRate Q_flow_gen;

  // Dependent variables
  SI.Power P_pot_pos = P_el;
  SI.Power P_pot_neg = P_el_n - P_el;
  SI.Power P_el_star = P_el / P_el_n;
  Real SOC[nStor];
  Real SOC_tot = sum(SOC*E_stor)/max(sum(E_stor),simCenter.E_small);

  Real COP = Q_flow_max / P_el_n "COP if both producer would be turned on. P_el_n is fix, but Q_flow_max changes with ambient temperature";
  SI.Time t_pos_max = E_stor_total*SOC_tot / Q_flow_demand;
  SI.Time t_neg_max = E_stor_total*(1-SOC_tot) / Q_flow_max;

  annotation (defaultComponentName="HeatPumpSystem", Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                   Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-98,-100},{102,100}}),
        Text(
          extent={{-150,-103},{150,-143}},
          lineColor={0,134,134},
          textString="%name"),
        Rectangle(
          extent={{-40,44},{40,-44}},
          lineColor={0,0,0}),
        Polygon(
          points={{-50,12},{-46,12},{-32,12},{-40,0},{-32,-10},{-50,-10},{-40,0},{-50,12}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,52},{18,36}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-18,-36},{20,-52}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{28,14},{54,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{32,-6},{40,14},{50,-6}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-22,26},{-22,-20},{26,-20}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-22,-18},{-18,-10},{-6,8},{-4,10},{4,16},{14,20},{22,20}},
          color={0,0,255},
          smooth=Smooth.None)}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end PartialHeatPumpSystemModel;
