within TransiEnt.Basics.Icons;
model RadiationModel
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

  annotation (Icon(graphics={      Ellipse(lineColor={0,125,125}, extent={{-100,-100},{100,100}}),
        Ellipse(
          extent={{-38,68},{-84,22}},
          lineColor={255,128,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Sphere),
        Polygon(
          points={{0,52},{-34,-28},{2,-50},{36,36},{0,52}},
          lineColor={28,108,200},
          fillPattern=FillPattern.Sphere,
          fillColor={28,108,200}),
        Line(points={{2,-50},{36,-22}}, color={28,108,200}),
        Line(points={{-44,28},{-6,6}},   color={255,0,0}),
        Line(points={{2,-50},{64,-32}}, color={0,0,0}),
        Text(
          extent={{66,-12},{94,-50}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.Sphere,
          fillColor={28,108,200},
          textString="N"),
        Line(points={{36,36},{36,-22}}, color={28,108,200}),
        Line(
          points={{36,-8},{30,-14},{28,-20},{28,-26},{28,-28}},
          color={28,108,200},
          smooth=Smooth.Bezier),
        Line(points={{32,-20},{32,-20},{32,-20},{32,-18},{32,-20}}, color={28,108,200}),
        Polygon(
          points={{60,-30},{62,-36},{68,-30},{60,-30}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model created for using the icon</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Purely technical component without physical modeling.)</p>
<h4><span style=\"color: #008000\">4.Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no elements)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
</html>"));
end RadiationModel;
