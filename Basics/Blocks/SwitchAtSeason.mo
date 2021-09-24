within TransiEnt.Basics.Blocks;
block SwitchAtSeason "Swith boolean signal to true between two distinct days of the year"


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
  //               Visible Parameters
  // _____________________________________________

 parameter Real summer_start = 121 "Day of the year for the start of summer operation";
  parameter Real winter_start = 274 "Day of the year for the end of summer operation";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Logical.Greater          greaterThreshold1
    annotation (Placement(transformation(extent={{-22,-40},{-6,-22}})));
  Modelica.Blocks.Sources.RealExpression time_1(y=time) annotation (Placement(transformation(extent={{-70,-28},{-54,-8}})));
  Modelica.Blocks.Sources.RealExpression summer(y=summer_start*24*3600) annotation (Placement(transformation(extent={{-70,-58},{-54,-38}})));
  Modelica.Blocks.Logical.Less             greaterThreshold2
    annotation (Placement(transformation(extent={{-22,44},{-6,62}})));
  Modelica.Blocks.Sources.RealExpression time_2(y=time) annotation (Placement(transformation(extent={{-70,56},{-54,76}})));
  Modelica.Blocks.Sources.RealExpression winter(y=winter_start*24*3600) annotation (Placement(transformation(extent={{-70,18},{-54,38}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{14,4},{30,20}})));
  Modelica.Blocks.Interfaces.BooleanOutput summer_operation "Connector of Boolean output signal" annotation (Placement(transformation(extent={{96,-10},{116,10}}), iconTransformation(extent={{96,-10},{116,10}})));
equation
  connect(time_1.y, greaterThreshold1.u1) annotation (Line(points={{-53.2,-18},{-42,-18},{-42,-31},{-23.6,-31}}, color={0,0,127}));
  connect(summer.y, greaterThreshold1.u2) annotation (Line(points={{-53.2,-48},{-35.6,-48},{-35.6,-38.2},{-23.6,-38.2}}, color={0,0,127}));
  connect(time_2.y, greaterThreshold2.u1) annotation (Line(points={{-53.2,66},{-52,66},{-52,53},{-23.6,53}}, color={0,0,127}));
  connect(winter.y, greaterThreshold2.u2) annotation (Line(points={{-53.2,28},{-45.6,28},{-45.6,45.8},{-23.6,45.8}}, color={0,0,127}));
  connect(greaterThreshold2.y, and1.u1) annotation (Line(points={{-5.2,53},{-5.2,32.5},{12.4,32.5},{12.4,12}}, color={255,0,255}));
  connect(greaterThreshold1.y, and1.u2) annotation (Line(points={{-5.2,-31},{-5.2,6.5},{12.4,6.5},{12.4,5.6}}, color={255,0,255}));
  connect(and1.y, summer_operation) annotation (Line(points={{30.8,12},{62,12},{62,0},{106,0}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                             Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,134,134},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-82,0},{92,0}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{-78,8},{-78,-8}}, color={0,0,0}),
        Line(
          points={{84,8},{92,0},{86,-10}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{-58,8},{-58,-8}}, color={0,0,0}),
        Line(points={{-38,8},{-38,-8}}, color={0,0,0}),
        Line(points={{-18,8},{-18,-8}}, color={0,0,0}),
        Line(points={{2,8},{2,-8}}, color={0,0,0}),
        Line(points={{22,8},{22,-8}}, color={0,0,0}),
        Line(points={{42,8},{42,-8}}, color={0,0,0}),
        Line(points={{62,8},{62,-8}}, color={0,0,0}),
        Line(
          points={{-82,2},{-38,2},{-38,60},{42,60},{42,2},{82,2}},
          color={0,0,255},
          thickness=0.5),
        Text(
          extent={{70,-16},{92,-34}},
          textColor={28,108,200},
          textString="365")}),                                   Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><b><span style=\"color: #008000;\">1. Purpose of model</span></b></p>
<p>Switch model that gives a positive value between two specified times of the year.</p>
<p><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(Description)</p>
<p><b><span style=\"color: #008000;\">3. Limits of validity </span></b></p>
<p>(Description)</p>
<p><b><span style=\"color: #008000;\">4. Interfaces</span></b></p>
<p>(none)</p>
<p><b><span style=\"color: #008000;\">5. Nomenclature</span></b></p>
<p>(no elements)</p>
<p><b><span style=\"color: #008000;\">6. Governing Equations</span></b></p>
<p>(no equations)</p>
<p><b><span style=\"color: #008000;\">7. Remarks for Usage</span></b></p>
<p>The parameters are given as real numbers from 0 to 365 as a day of the year. The output is a Boolean output, which is true if the time is between those two parameters else it gives false.</p>
<p><b><span style=\"color: #008000;\">8. Validation</span></b></p>
<p>(no validation or testing necessary)</p>
<p><b><span style=\"color: #008000;\">9. References</span></b></p>
<p>(none)</p>
<p><b><span style=\"color: #008000;\">10. Version History</span></b></p>
<p>Created by Yousef Omran, Fraunhofer UMSICHT, 2018</p>
<p>Modified by Anne Hagemeier (anne.hagemeier@umsicht.fraunhofer.de), July 2018</p>
</html>"));
end SwitchAtSeason;
