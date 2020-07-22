within TransiEnt.Basics.Blocks;
model FilterPosNeg "Filter for only positive or negative values"
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

  extends Modelica.Blocks.Interfaces.SISO;

  // _____________________________________________
  //
  //              Visible Parameters
  // _____________________________________________

  parameter Boolean onlyPositive=true "true if output should only contain positive values";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=onlyPositive) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Logical.Switch switch1 annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Blocks.Math.Max max annotation (Placement(transformation(extent={{-10,26},{10,46}})));
  Modelica.Blocks.Math.Min min annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=0) annotation (Placement(transformation(extent={{-46,-10},{-26,10}})));
equation
  // _____________________________________________
  //
  //               Connect Statements
  // _____________________________________________

  connect(booleanExpression.y, switch1.u2) annotation (Line(points={{11,0},{28,0}}, color={255,0,255}));
  connect(realExpression.y, min.u1) annotation (Line(points={{-25,0},{-20,0},{-20,-24},{-12,-24}}, color={0,0,127}));
  connect(realExpression.y, max.u2) annotation (Line(points={{-25,0},{-20,0},{-20,30},{-12,30}}, color={0,0,127}));
  connect(min.u2, u) annotation (Line(points={{-12,-36},{-60,-36},{-60,0},{-120,0}}, color={0,0,127}));
  connect(max.u1, u) annotation (Line(points={{-12,42},{-60,42},{-60,0},{-120,0}}, color={0,0,127}));
  connect(min.y, switch1.u3) annotation (Line(points={{11,-30},{20,-30},{20,-8},{28,-8}}, color={0,0,127}));
  connect(max.y, switch1.u1) annotation (Line(points={{11,36},{20,36},{20,8},{28,8}}, color={0,0,127}));
  connect(switch1.y, y) annotation (Line(points={{51,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true), graphics={Text(
          extent={{-100,40},{100,-40}},
          lineColor={0,0,0},
          textString=DynamicSelect(">0", if onlyPositive then ">0" else "<0"))}),                             Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Block that can pass through only positive or negative values.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>u: input</p>
<p>y: output</p>
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
<p>Model created by Carsten Bode (c.bode@tuhh.de), Nov 2018</p>
</html>"));
end FilterPosNeg;
