within TransiEnt.Basics.Icons;
model Boiler "gasboiler icon"


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

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
        Line(
          points={{48,62},{-42,62}},
          color={0,0,0},
          thickness=0),
        Line(
          points={{-42,62},{-42,12},{-42,10},{-38,10},{-38,-2},{-42,-2},{-42,-54},{48,-54}},
          color={0,0,0},
          thickness=0),
        Line(
          points={{50,-44},{-30,-44},{-30,-36},{48,-36},{48,42},{-30,42},{-30,50},{50,50}},
          color={0,0,0},
          thickness=0),
        Line(
          points={{-42,10},{-46,10}},
          color={0,0,0},
          thickness=0),
        Ellipse(
          extent={{-66,18},{-52,4}},
          lineColor={0,0,0},
          linethickness=0,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-62,-2},{-42,-2}},
          color={0,0,0},
          thickness=0),
        Ellipse(
          extent={{-20,44},{-24,48}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-10,44},{-14,48}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,44},{-4,48}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{10,44},{6,48}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,44},{16,48}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{30,44},{26,48}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{40,44},{36,48}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-30,26},{-34,30}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-20,26},{-24,30}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-10,26},{-14,30}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,26},{-4,30}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{10,26},{6,30}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,26},{16,30}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{30,26},{26,30}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-34,-22},{-38,-18}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-24,-22},{-28,-18}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-14,-22},{-18,-18}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-4,-22},{-8,-18}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{6,-22},{2,-18}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{26,-22},{22,-18}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{16,-22},{12,-18}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-8,-42},{-12,-38}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-18,-42},{-22,-38}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{2,-42},{-2,-38}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{12,-42},{8,-38}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{22,-42},{18,-38}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{32,-42},{28,-38}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{42,-42},{38,-38}},
          lineColor={0,0,0},
          linethickness=0,
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-38,-2},{-24,-6}},
          color={0,0,0},
          pattern=LinePattern.None,
          thickness=0,
          smooth=Smooth.Bezier),
        Line(
          points={{-42,32},{36,32},{36,24},{-42,24}},
          color={0,0,0},
          thickness=0),
        Line(
          points={{-42,-16},{36,-16}},
          color={0,0,0},
          thickness=0),
        Line(
          points={{-42,-26},{36,-26},{36,-16},{36,-16}},
          color={0,0,0},
          thickness=0),
        Line(
          points={{-16,10},{-18,12},{-16,10},{-18,12},{-16,10},{-18,16}},
          color={0,0,0},
          pattern=LinePattern.None,
          thickness=0,
          smooth=Smooth.Bezier),
        Line(
          points={{-16,10},{-18,14}},
          color={0,0,0},
          pattern=LinePattern.None,
          thickness=0,
          smooth=Smooth.Bezier),
        Polygon(
          points={{-38,-2},{-38,-2}},
          lineColor={0,0,0},
          linethickness=0,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-38,-2},{-26,-2},{-8,-8},{-12,-4},{-6,-4},{14,-10},{12,-8},{36,-8},{30,-2},{44,0},{30,8},{34,14},{28,16},{8,10},{10,14},{6,16},{-14,10},{-18,12},{-38,10},{-38,-2}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          linethickness=0,
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Line(
          points={{54,46},{74,46}},
          color={28,108,200},
          thickness=0),
        Line(
          points={{54,46},{62,52}},
          color={28,108,200},
          thickness=0),
        Line(
          points={{54,46},{62,40}},
          color={28,108,200},
          thickness=0),
        Line(
          points={{54,-40},{66,-40},{76,-40},{66,-46}},
          color={238,46,47},
          thickness=0),
        Line(
          points={{76,-40},{66,-34}},
          color={238,46,47},
          thickness=0,
          smooth=Smooth.Bezier),
        Line(
          points={{-46,10},{-46,20},{-54,26},{-66,26},{-74,18},{-74,4},{-66,-2},{-60,-2}},
          color={0,0,0},
          thickness=0,
          smooth=Smooth.Bezier),
      Polygon(
        points={{-42,6},{-42,6}},
        lineColor={0,0,0},
        linethickness=0,
        smooth=Smooth.Bezier,
        fillColor={135,135,135},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{-38,2},{-30,0},{-22,2},{-14,-2},{-6,0},{14,-4},{8,0},{18,4},{4,6},{6,12},{0,10},{-8,6},{-16,8},{-30,8},{-38,8},{-38,2}},
        pattern=LinePattern.None,
        linethickness=0,
        fillColor={238,46,47},
        fillPattern=FillPattern.Solid)}),
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
end Boiler;
