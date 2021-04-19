within TransiEnt.Basics.Icons;
model FeedInStation
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.3.1                             //
//                                                                                //
// Licensed by Hamburg University of Technology under the 3-Clause BSD License    //
// for the Modelica Association.                                                  //
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
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                       Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          lineThickness=0,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-38,144},{38,2}},
          lineColor={0,0,255},
          textString="H2O"),
        Text(
          extent={{-84,-46},{-30,-100}},
          lineColor={85,170,255},
          textString="O2"),
        Text(
          extent={{30,-48},{90,-98}},
          lineColor={162,210,255},
          lineThickness=0,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="H2"),
        Line(points={{-86,76}}, color={28,108,200}),
        Line(points={{-2,-46}}, color={28,108,200}),
        Polygon(
          points={{-42,-28},{-42,-28}},
          lineColor={238,46,47},
          lineThickness=0,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{4,48},{-10,20},{-4,20},{-18,-6},{-10,-6},{-32,-48},{10,4},{4,4},{22,28},{16,28},{32,48},{4,48}},
          lineColor={238,46,47},
          lineThickness=0,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid)}),
                              Diagram(graphics,
                                      coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
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
end FeedInStation;
