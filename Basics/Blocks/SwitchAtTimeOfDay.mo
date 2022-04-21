within TransiEnt.Basics.Blocks;
block SwitchAtTimeOfDay "Swith boolean signal to true for a specific time of day"



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





  // _____________________________________________
  //
  //          Parameters
  // _____________________________________________

  parameter Modelica.Units.NonSI.Time_hour startTime=12 "Start of period where signal is switched on as hour of the day (out of 24)";
  parameter Modelica.Units.NonSI.Time_hour endTime=15 "End of period where signal is switched on as hour of the day (out of 24)";

  // _____________________________________________
  //
  //          Complex components
  // _____________________________________________

  Modelica.Blocks.Logical.Timer timer  annotation (Placement(transformation(extent={{-64,-10},{-44,10}})));

  Modelica.Blocks.Interfaces.BooleanOutput y annotation (Placement(transformation(extent={{98,-10},{118,10}})));

  Modelica.Blocks.Sources.BooleanPulse booleanPulse(period=86400, width=99.9999) annotation (Placement(transformation(extent={{-94,-10},{-74,10}})));

  Modelica.Blocks.Logical.LogicalSwitch logicalSwitch annotation (Placement(transformation(extent={{62,-10},{82,10}})));

  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold=startTime*3600) annotation (Placement(transformation(extent={{-12,20},{8,40}})));

  Modelica.Blocks.Logical.LessThreshold lessEqualThreshold(threshold=endTime*3600) annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));

  Modelica.Blocks.Logical.And and1 annotation (Placement(transformation(extent={{26,-10},{46,10}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=true) annotation (Placement(transformation(extent={{32,28},{52,48}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression1 annotation (Placement(transformation(extent={{28,-56},{48,-36}})));

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________
equation

  connect(timer.u, booleanPulse.y) annotation (Line(points={{-66,0},{-66,0},{-73,0}},
                                                 color={255,0,255}));
  connect(logicalSwitch.y, y) annotation (Line(points={{83,0},{108,0},{108,0}}, color={255,0,255}));
  connect(timer.y, greaterEqualThreshold.u) annotation (Line(points={{-43,0},{-43,0},{-28,0},{-28,30},{-14,30}}, color={0,0,127}));
  connect(timer.y, lessEqualThreshold.u) annotation (Line(points={{-43,0},{-28,0},{-28,-30},{-12,-30}}, color={0,0,127}));
  connect(and1.y, logicalSwitch.u2) annotation (Line(points={{47,0},{53.5,0},{60,0}}, color={255,0,255}));
  connect(greaterEqualThreshold.y, and1.u1) annotation (Line(points={{9,30},{12,30},{12,0},{24,0}}, color={255,0,255}));
  connect(lessEqualThreshold.y, and1.u2) annotation (Line(points={{11,-30},{16,-30},{16,-8},{24,-8}}, color={255,0,255}));
  connect(booleanExpression.y, logicalSwitch.u1) annotation (Line(points={{53,38},{56,38},{56,8},{60,8}}, color={255,0,255}));
  connect(booleanExpression1.y, logicalSwitch.u3) annotation (Line(points={{49,-46},{60,-46},{60,-8}}, color={255,0,255}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                             Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,134,134},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Line(points={{-92,-2},{-32,-2},{-32,56},{26,56},{26,-4},{68,-4}}, color={0,0,0}),
        Text(
          extent={{62,-28},{82,-46}},
          textColor={28,108,200},
          textString="24"),
        Line(
          points={{-96,-16},{78,-16}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{-92,-8},{-92,-24}},
                                        color={0,0,0}),
        Line(
          points={{70,-8},{78,-16},{72,-26}},
          color={0,0,0},
          thickness=0.5),
        Line(points={{-72,-8},{-72,-24}},
                                        color={0,0,0}),
        Line(points={{-52,-8},{-52,-24}},
                                        color={0,0,0}),
        Line(points={{-32,-8},{-32,-24}},
                                        color={0,0,0}),
        Line(points={{-12,-8},{-12,-24}},
                                    color={0,0,0}),
        Line(points={{8,-8},{8,-24}}, color={0,0,0}),
        Line(points={{28,-8},{28,-24}},
                                      color={0,0,0}),
        Line(points={{48,-8},{48,-24}},
                                      color={0,0,0})}),          Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Switch model that gives a positive value between two specified times of day.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>The parameters are given as real numbers from 0 to 24 as a time point. The output is as Boolean output, which is true if the time is between those two parameters else it gives false.</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Created by Yousef Omran, Fraunhofer UMSICHT, 2018</p>
<p>Modified by Anne Hagemeier (anne.hagemeier@umsicht.fraunhofer.de), July 2018</p>
</html>"),
    experiment(StopTime=172800, __Dymola_Algorithm="Dassl"),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end SwitchAtTimeOfDay;
