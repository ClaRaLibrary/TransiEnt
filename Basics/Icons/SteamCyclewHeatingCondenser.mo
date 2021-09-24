within TransiEnt.Basics.Icons;
model SteamCyclewHeatingCondenser

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



  extends Model;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Polygon(
          points={{34,56},{34,18},{44,14},{44,60},{34,56}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Rectangle(
          extent={{38,-4},{72,-40}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Rectangle(
          extent={{50,-40},{62,-48}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Rectangle(
          extent={{-80,46},{-44,-34}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Ellipse(
          extent={{-56,-52},{-18,-88}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Line(
          points={{-18,-70},{-56,-70},{-40,-52}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{-56,-70},{-40,-88}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{44,14},{44,4},{12,4},{12,-4}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{56,-48},{56,-70},{12,-70}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{-46,-70},{-62,-70},{-62,-34}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Ellipse(
          extent={{68,47},{88,27}},
          lineColor={0,0,0},
          lineThickness=0.2,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(
          points={{78,46},{78,60},{100,60}},
          color={0,127,127},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{84,56},{90,64}},
          color={0,127,127},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{86,56},{92,64}},
          color={0,127,127},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{88,56},{94,64}},
          color={0,127,127},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{100,-10},{48,-10},{60,-20},{48,-32},{100,-32}},
          color={175,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Polygon(
          points={{-18,44},{-18,30},{0,24},{0,50},{-18,44}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Rectangle(
          extent={{-6,-4},{28,-40}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Rectangle(
          extent={{6,-40},{18,-48}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Line(
          points={{24,18},{24,0},{52,0},{52,-4}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{12,-48},{12,-70},{-34,-70}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{28,-10},{4,-10},{16,-20},{4,-32},{28,-32}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{68,36},{0,36}},
          color={0,0,0},
          thickness=0.2,
          smooth=Smooth.None),
        Line(
          points={{-62,46},{-62,96},{-18,96},{-18,44}},
          color={0,0,0}),
        Line(
          points={{0,50},{0,74},{-36,74},{-36,26},{-44,26}},
          color={0,0,0}),
        Line(
          points={{-50,46},{-50,84},{24,84},{24,54}},
          color={0,0,0}),
        Polygon(
          points={{8,50},{8,24},{24,18},{24,56},{8,50}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineThickness=0.2),
        Line(points={{-44,26},{-40,30}}, color={0,0,0}),
        Line(points={{-44,26},{-40,22}}, color={0,0,0}),
        Line(points={{-22,48},{-18,44},{-14,48}}, color={0,0,0}),
        Line(points={{20,60},{24,56},{28,60}}, color={0,0,0})}), Documentation(info="<html>
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
end SteamCyclewHeatingCondenser;
