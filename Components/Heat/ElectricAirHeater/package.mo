within TransiEnt.Components.Heat;
package ElectricAirHeater


//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 2.0.0                             //
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



extends TransiEnt.Basics.Icons.Package;

  annotation (Icon(graphics={
        Ellipse(
          extent={{36,-42},{60,0}},
          lineColor={0,0,0},
          fillColor={247,247,247},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5,
          startAngle=0,
          endAngle=360),
        Ellipse(
          extent={{20,-42},{44,0}},
          lineColor={0,0,0},
          fillColor={247,247,247},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5,
          startAngle=0,
          endAngle=360),
        Ellipse(
          extent={{4,-42},{28,0}},
          lineColor={0,0,0},
          fillColor={247,247,247},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5,
          startAngle=0,
          endAngle=360),
        Ellipse(
          extent={{-12,-42},{12,0}},
          lineColor={0,0,0},
          fillColor={247,247,247},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5,
          startAngle=0,
          endAngle=360),
        Line(
          points={{-60,100},{-60,-20}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{60,100},{60,-20}},
          color={0,0,0},
          thickness=0.5),
        Ellipse(
          extent={{-28,-42},{-4,0}},
          lineColor={0,0,0},
          fillColor={247,247,247},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5,
          startAngle=0,
          endAngle=360),
        Ellipse(
          extent={{-44,-42},{-20,0}},
          lineColor={0,0,0},
          fillColor={247,247,247},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5,
          startAngle=0,
          endAngle=360),
        Ellipse(
          extent={{-60,-42},{-36,0}},
          lineColor={0,0,0},
          fillColor={247,247,247},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5)}), Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>This package includes models to describe an electric air heater</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(none)</p>
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
<p>Model created by Michael von der Heyde (heyde@tuhh.de) for the Research Project &quot;Future Energy Solution&quot; (FES), 2020</p>
</html>"));
end ElectricAirHeater;
