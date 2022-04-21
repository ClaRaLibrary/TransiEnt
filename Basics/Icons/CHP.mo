within TransiEnt.Basics.Icons;
model CHP


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




//extends Model;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={255,255,255}),
        Rectangle(
          extent={{20,62},{68,22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,62},{-32,22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-84,6},{20,-88}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-48,22},{-40,0}},
          fillColor={215,215,215},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-52,4},{6,0}},
          fillColor={215,215,215},
          fillPattern=FillPattern.HorizontalCylinder,
          lineColor={0,0,0}),
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0}),
      Rectangle(
        extent={{-3,2.47101},{3,-1.5297}},
        lineColor={0,0,0},
        fillColor={175,175,175},
        fillPattern=FillPattern.VerticalCylinder,
        origin={91.529,-69},
        rotation=-90),
        Rectangle(
          extent={{-50,0},{-46,-10}},
          fillColor={215,215,215},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-24,0},{-20,-10}},
          fillColor={215,215,215},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{2,0},{6,-10}},
          fillColor={215,215,215},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-94,102},{-86,48}},
          fillColor={215,215,215},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-86,56},{-80,48}},
          fillColor={215,215,215},
          fillPattern=FillPattern.HorizontalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{54,72},{96,66}},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,0,255},
          lineColor={0,0,0}),
        Rectangle(
          extent={{52,72},{58,62}},
          fillColor={0,0,255},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-70,98},{-64,62}},
          fillColor={255,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-64,98},{96,92}},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,0,0},
          lineColor={0,0,0}),
        Rectangle(
          extent={{20,-28},{62,-34}},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,0,255},
          lineColor={0,0,0}),
        Rectangle(
          extent={{56,22},{62,-34}},
          fillColor={0,0,255},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{34,22},{40,-20}},
          fillColor={255,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          lineColor={0,0,0}),
        Rectangle(
          extent={{20,-14},{34,-20}},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,0,0},
          lineColor={0,0,0}),
        Rectangle(
          extent={{-96,-4},{-4,-8}},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,0},
          lineColor={0,0,0}),
        Line(
          points={{-80,62},{-32,22}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{20,22},{68,62}},
          color={0,0,0},
          smooth=Smooth.None),
      Line(
        points={{-27,-69},{-8,-46}},
        color={0,0,0}),
      Line(
        points={{-1,-69},{12,-46}},
        color={0,0,0}),
      Rectangle(
        extent={{-2.5,21},{2.5,-13}},
        lineColor={0,0,0},
        fillColor={175,175,175},
        fillPattern=FillPattern.VerticalCylinder,
        origin={15,-69.5},
        rotation=-90),
      Ellipse(extent={{-24,-72},{-30,-66}}, lineColor={0,0,0}),
      Rectangle(
        extent={{-2.5,12.3529},{2.5,-7.64708}},
        lineColor={0,0,0},
        fillColor={175,175,175},
        fillPattern=FillPattern.VerticalCylinder,
        origin={-16.3529,-69.5},
        rotation=-90),
      Ellipse(extent={{2,-72},{-4,-66}},    lineColor={0,0,0}),
      Rectangle(
        extent={{-2.5,12.3529},{2.5,-7.64708}},
        lineColor={0,0,0},
        fillColor={175,175,175},
        fillPattern=FillPattern.VerticalCylinder,
        origin={-42.3529,-69.5},
        rotation=-90),
      Ellipse(extent={{-50,-72},{-56,-66}}, lineColor={0,0,0}),
      Rectangle(
        extent={{-2.5,12.3529},{2.5,-7.64708}},
        lineColor={0,0,0},
        fillColor={175,175,175},
        fillPattern=FillPattern.VerticalCylinder,
        origin={-68.3529,-69.5},
        rotation=-90),
      Line(
        points={{-53,-69},{-46,-46}},
        color={0,0,0}),
      Line(
        points={{-46,-46},{-52,-18}},
        color={0,0,0}),
      Line(
        points={{-8,-46},{-26,-28}},
        color={0,0,0}),
      Line(
        points={{12,-46},{-2,-20}},
        color={0,0,0}),
      Ellipse(extent={{14,-49},{8,-43}},    lineColor={0,0,0}),
      Ellipse(extent={{-6,-49},{-12,-43}},  lineColor={0,0,0}),
      Ellipse(extent={{-44,-49},{-50,-43}}, lineColor={0,0,0}),
      Rectangle(
        extent={{14,16},{14,16}},
        lineColor={0,0,0},
        fillColor={175,175,175},
        fillPattern=FillPattern.VerticalCylinder),
      Rectangle(
        extent={{-45,-21},{-61,-12}},
        lineColor={0,0,0},
        fillPattern=FillPattern.VerticalCylinder,
        fillColor={192,192,192}),
      Ellipse(
        extent={{-50,-20},{-56,-14}},
        lineColor={0,0,0},
        fillColor={0,0,0},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-19,-31},{-35,-22}},
        lineColor={0,0,0},
        fillPattern=FillPattern.VerticalCylinder,
        fillColor={192,192,192}),
      Ellipse(
        extent={{-24,-30},{-30,-24}},
        lineColor={0,0,0},
        fillColor={0,0,0},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{7,-25},{-9,-16}},
        lineColor={0,0,0},
        fillPattern=FillPattern.VerticalCylinder,
        fillColor={192,192,192}),
      Ellipse(
        extent={{2,-24},{-4,-18}},
        lineColor={0,0,0},
        fillColor={0,0,0},
        fillPattern=FillPattern.Solid),
        Line(
          points={{-62,-34},{-62,-10},{-60,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-56,-10},{-50,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-46,-10},{-44,-10},{-44,-34}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-36,-34},{-36,-10},{-34,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-30,-10},{-24,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-20,-10},{-18,-10},{-18,-34}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-10,-34},{-10,-10},{-8,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-4,-10},{2,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{6,-10},{8,-10},{8,-34}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-50,-10},{-50,-8}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-46,-10},{-46,-8}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-24,-8},{-24,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-20,-8},{-20,-10}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-18,27},{18,-27}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={175,175,175},
          origin={63,-70},
          rotation=90),
        Rectangle(
          extent={{-32,36},{20,30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,128,0}),
        Line(
          points={{-44,8},{-44,18},{-46,16},{-44,18},{-42,16}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{37,4},{37,14},{35,12},{37,14},{39,12}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{59,-12},{59,-22},{57,-20},{59,-22},{61,-20}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,-5},{0,5},{-2,3},{0,5},{2,3}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-6,33},
          rotation=90),
        Line(
          points={{0,-5},{0,5},{-2,3},{0,5},{2,3}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={8,95},
          rotation=-90),
        Line(
          points={{0,-5},{0,5},{-2,3},{0,5},{2,3}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={76,69},
          rotation=90),
        Line(
          points={{0,-5},{0,5},{-2,3},{0,5},{2,3}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-70,-6},
          rotation=-90),
        Line(
          points={{-90,72},{-90,82},{-92,80},{-90,82},{-88,80}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{74,-52},{74,-24}},
          color={0,127,0},
          smooth=Smooth.None),
        Line(
          points={{64,-36},{82,-22}},
          color={0,127,0},
          smooth=Smooth.None),
        Line(
          points={{64,-42},{82,-28}},
          color={0,127,0},
          smooth=Smooth.None),
        Line(
          points={{64,-48},{84,-32}},
          color={0,127,0},
          smooth=Smooth.None),
        Line(
          points={{96,-40},{74,-40}},
          smooth=Smooth.None,
          color={0,127,0}),
        Text(
          extent={{50,-62},{78,-78}},
          lineColor={0,0,0},
          fillColor={19,202,77},
          fillPattern=FillPattern.Solid,
          textString="G"),
        Ellipse(
          extent={{50,10},{68,-8}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{59,-8},{50,4},{68,4},{59,-8}},
          lineColor={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-74,-88},{-56,-94}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,0,0}),
        Rectangle(
          extent={{-8,-88},{10,-94}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,0,0}),
        Rectangle(
          extent={{40,-88},{54,-94}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,0,0}),
        Rectangle(
          extent={{72,-88},{86,-94}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,0,0}),
        Rectangle(
          extent={{-94,-94},{96,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,0,0}),
        Rectangle(
          extent={{68,-48},{80,-52}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={0,0,0}),
        Rectangle(
          extent={{-60,-8},{-56,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,255,0}),
        Rectangle(
          extent={{-34,-8},{-30,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,255,0}),
        Rectangle(
          extent={{-8,-8},{-4,-10}},
          lineColor={0,0,0},
          fillPattern=FillPattern.VerticalCylinder,
          fillColor={255,255,0})}), Documentation(info="<html>
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

end CHP;
