within TransiEnt.Basics.Icons;
partial class Electrolyser2 "Icon for electrolysers"


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




  extends TransiEnt.Basics.Icons.Model;

  annotation(Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Model created for using the icon</p>
<p>This is an icon for electrolysers.</p>
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
</html>",                                                                                                                                                                                                  revisions = "<html><ul><il>V1.0 Patrick Gttsch<br>first design</il></ul></html>"), Icon(coordinateSystem(extent={{-100,
            -100},{100,100}},                                                                                                    preserveAspectRatio=false,   initialScale = 0.1, grid = {2,2}), graphics={
        Ellipse(
          extent={{32,30},{88,-30}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-88,30},{-32,-30}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),                                                                                                    Rectangle(extent={{
              -60,30},{60,-30}},                                                                                                    fillColor=
              {215,215,215},
            fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Text(
          extent={{62,-2},{90,-20}},
          lineColor={255,226,2},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="2"),
        Rectangle(
          extent={{-60,24},{60,-24}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,18},{60,-18}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,12},{60,-12}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,6},{60,-6}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-98,18},{-44,-20}},
          lineColor={0,125,125},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="P"),
        Text(
          extent={{32,18},{86,-20}},
          lineColor={255,226,2},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="H"),
        Text(
          extent={{-78,0},{-46,-22}},
          lineColor={0,125,125},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="el")}));
end Electrolyser2;
