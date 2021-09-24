within TransiEnt.Basics.Icons;
model SystemOperator

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




  extends TransiEnt.Basics.Icons.Model;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(extent={{-58,52},{60,-22}}, lineColor={95,95,95}),
        Rectangle(
          extent={{-16,46},{56,-16}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-53,40},{-47,34}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-27,40},{-21,34}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-40,40},{-34,34}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-40,26},{-34,20}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-53,26},{-47,20}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-27,26},{-21,20}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-52,13},{-48,-9}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-39,13},{-35,-9}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-26,13},{-22,-9}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-58,-22},{60,-47}}, lineColor={95,95,95}),
        Rectangle(
          extent={{-7,51},{7,-51}},
          lineColor={95,95,95},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid,
          origin={1,-35},
          rotation=90)}), Documentation(info="<html>
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
end SystemOperator;
