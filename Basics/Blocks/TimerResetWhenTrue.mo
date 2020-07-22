within TransiEnt.Basics.Blocks;
block TimerResetWhenTrue "Timer measuring the time from the time instant where the Boolean input became true and only resetting when it becomes true again"
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
  discrete Modelica.SIunits.Time entryTime "Time instant when u became true";
  Boolean active;

  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

initial equation
  pre(entryTime) = 0;
  active = false;
equation
  when u then
    entryTime = time;
    active = true;
  end when;
  y = if active then time - entryTime else 0;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={Line(points={{-80,-20},{-60,-20},{40,60},{40,-20},{60,-8}}, color={0,0,255}), Line(points={{-80,-68},{-60,-68},{-60,-40},{-20,-40},{-20,-68},{40,-68},{40,-40},{60,-40}}, color={255,0,255})}),
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
        Line(points={{-80,-20},{-60,-20},{40,60},{40,-20},{60,-8}}, color={0,0,255}),
        Text(extent={{-88,6},{-54,-4}}, textString="y"),
        Text(extent={{48,-80},{84,-88}}, textString="time"),
        Text(extent={{-88,-36},{-54,-46}}, textString="u")}),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This model is a timer which starts when the input becomes true. It is only reset when the input becomes true again. It is a modified copy from Modelica.Blocks.Logical.Time.</p>
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
end TimerResetWhenTrue;
