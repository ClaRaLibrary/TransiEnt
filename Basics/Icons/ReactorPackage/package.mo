within TransiEnt.Basics.Icons;
partial package ReactorPackage
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

extends TransiEnt.Basics.Icons.Package;

annotation (Icon(graphics={
        Rectangle(
          extent={{-100,30},{100,-30}},
          lineColor={0,0,255},
          fillColor={170,255,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-70,30},{70,-30}},
          lineColor={0,0,0},
          fillColor={127,190,190},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-70,20},{70,-20}},
          lineColor={0,0,255},
          fillColor={170,255,255},
          fillPattern=FillPattern.CrossDiag),
        Line(points={{-23,20},{-23,-20}}, color={28,108,200}),
        Line(points={{23,20},{23,-20}}, color={28,108,200})}), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Package created for using the icon</p>
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
end ReactorPackage;
