within TransiEnt.Basics.Icons;
partial model PSA


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




  extends Model;
  annotation (Icon(graphics={
        Rectangle(
          extent={{-70,-10},{40,-50}},
          lineColor={0,0,255},
          fillColor={170,255,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-60,-10},{30,-50}},
          lineColor={0,0,0},
          fillColor={127,190,190},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-60,-14},{30,-46}},
          lineColor={0,0,255},
          fillColor={170,255,255},
          fillPattern=FillPattern.CrossDiag),
        Rectangle(
          extent={{-70,50},{40,10}},
          lineColor={0,0,255},
          fillColor={170,255,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-60,50},{30,10}},
          lineColor={0,0,0},
          fillColor={127,190,190},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-60,46},{30,14}},
          lineColor={0,0,255},
          fillColor={170,255,255},
          fillPattern=FillPattern.CrossDiag),
        Line(
          points={{40,30},{50,30},{50,0},{100,0},{50,0},{50,-30},{40,-30}},
          color={255,255,0},
          thickness=0.5),
        Line(
          points={{-70,30},{-80,30},{-80,0},{-100,0},{-80,0},{-80,-30},{-70,-30}},
          color={255,255,0},
          thickness=0.5),
        Line(
          points={{60,70},{60,40},{40,40},{60,40},{60,5},{65,5},{65,-5},{60,-5},{60,-40},{40,-40}},
          color={255,255,0},
          thickness=0.5)}), Documentation(info="<html>
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
end PSA;
