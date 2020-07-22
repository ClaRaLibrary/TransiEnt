within TransiEnt.Basics.Blocks.Sources;
block BooleanArrayConstant "Generate constant arrary of signals of type Boolean"
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
  extends TransiEnt.Basics.Icons.Block;

  parameter Boolean k[nout]=fill(true,nout) "Constant output value";
  parameter Integer nout=1;

  Modelica.Blocks.Interfaces.BooleanOutput y[nout] "Connector of Boolean output signal" annotation (Placement(transformation(extent={{100,-10},{120,10}}, rotation=0)));
equation
  y = k;
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
                                         Rectangle(
          extent={{-100,100},{102,-102}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),     Line(points={{-68,0},{92,0}}, color={0,0,0}),
                                  Polygon(
            points={{-68,92},{-74,70},{-62,70},{-68,92}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),Line(points={{-68,70},{-68,-88}},
          color={95,95,95}),Line(points={{-88,-70},{70,-70}}, color={95,95,95}),
          Polygon(
            points={{92,-70},{70,-64},{70,-76},{92,-70}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
                               Text(
            extent={{-62,92},{-44,74}},
            lineColor={0,0,0},
            textString="y"),
        Line(
          points={{-68,0},{82,0}},
          color={255,85,255},
          thickness=0.5),
        Text(
          extent={{-67,20},{-47,0}},
          lineColor={0,0,0},
          textString="k"),
        Text(
          extent={{-94,6},{-74,-4}},
          lineColor={0,0,0},
          textString="true"),
        Text(
          extent={{-96,-58},{-70,-68}},
          lineColor={0,0,0},
          textString="false")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(
          points={{-70,0},{80,0}},
          color={0,0,255},
          thickness=0.5),
        Text(
          extent={{-69,20},{-49,0}},
          lineColor={0,0,0},
          textString="k"),
        Text(
          extent={{-96,6},{-76,-4}},
          lineColor={0,0,0},
          textString="true"),
        Text(
          extent={{-98,-58},{-72,-68}},
          lineColor={0,0,0},
          textString="false"),    Polygon(
            points={{-70,92},{-76,70},{-64,70},{-70,92}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),Line(points={{-70,70},{-70,-88}},
          color={95,95,95}),Line(points={{-90,-70},{68,-70}}, color={95,95,95}),
          Polygon(
            points={{90,-70},{68,-64},{68,-76},{90,-70}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),Text(
            extent={{54,-80},{106,-92}},
            lineColor={0,0,0},
            textString="time"),Text(
            extent={{-64,92},{-46,74}},
            lineColor={0,0,0},
            textString="y"),
        Line(
          points={{-70,0},{80,0}},
          color={0,0,255},
          thickness=0.5),
        Text(
          extent={{-69,20},{-49,0}},
          lineColor={0,0,0},
          textString="k"),
        Text(
          extent={{-96,6},{-76,-4}},
          lineColor={0,0,0},
          textString="true"),
        Text(
          extent={{-98,-58},{-72,-68}},
          lineColor={0,0,0},
          textString="false")}),
      Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>The Boolean output y is a constant signal: </p>
<p><img src=\"modelica://Modelica/Resources/Images/Blocks/Sources/BooleanConstant.png\" alt=\"BooleanConstant.png\"/> </p>
<p><br><b><span style=\"color: #008000;\">2. Level of detail, physical effects considered, and physical insight</span></b></p>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end BooleanArrayConstant;
