within TransiEnt.Basics.Blocks;
block TimerConstWhenFalse "Timer measuring the time from the time instant where the Boolean input became true and staying constant when it becomes false"


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
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Block;

  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  Modelica.Blocks.Interfaces.BooleanInput u "Connector of Boolean input signal" annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal" annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

protected
  discrete Modelica.Units.SI.Time entryTime "Time instant when u became true";
  discrete Real pre_y "Previous value of y before u became false";

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

initial equation
  pre(entryTime) = 0;
  pre_y = 0;
equation
  when u then
    entryTime = time;
  end when;
  when not u then
    pre_y = pre(y);
  end when;
  y = if u then time - entryTime else pre_y;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={Line(points={{-80,-68},{-60,-68},{-60,-40},{-20,-40},{-20,-68},{40,-68},{40,-40},{60,-40}}, color={255,0,255}), Line(points={{-80,-20},{-60,-20},{-20,12},{40,12},{40,-20},{60,-8}}, color={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-90,-70},{82,-70}}),
        Line(points={{-80,68},{-80,-80}}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-68},{-60,-68},{-60,-40},{-20,-40},{-20,-68},{40,-68},{40,-40},{60,-40}}, color={255,0,255}),
        Line(points={{-80,-20},{-60,-20},{-20,12},{40,12},{40,-20},{60,-8}}, color={0,0,255}),
        Text(extent={{-88,6},{-54,-4}}, textString="y"),
        Text(extent={{48,-80},{84,-88}}, textString="time"),
        Text(extent={{-88,-36},{-54,-46}}, textString="u")}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is a timer which starts when the input becomes true. It stays constant when the input becomes false and is reset when the input becomes true again. It is a modified copy from Modelica.Blocks.Logical.Time.</p>
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
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Carsten Bode (c.bode@tuhh.de), Sep 2019</p>
</html>"));
end TimerConstWhenFalse;
