within TransiEnt.Components.Boundaries.Electrical.ComplexPowerAdvanced.Characteristics;
partial model Qcurve_empty "Partial model for Q(v)-curves"

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




  // _____________________________________________
  //
  //                  Interfaces
  // _____________________________________________

  TransiEnt.Basics.Interfaces.Electrical.VoltageIn voltageIn annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ReactivePowerOut reactivePowerOut annotation (Placement(transformation(extent={{88,-10},{108,10}})));
  TransiEnt.Basics.Interfaces.Electrical.ElectricPowerIn electricPowerIn annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,104})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                   Ellipse(
          lineColor={0,125,125},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Text(
          extent={{-150,-101},{150,-141}},
          lineColor={0,134,134},
          textString="%name"),
        Rectangle(
          extent={{-50,60},{0,-60}},
          lineColor={255,255,255},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Line(points={{-50,-60},{-50,60},{50,60},{50,-60},{-50,-60},{-50,-30},{50,-30},{50,0},{-50,0},{-50,30},{50,30},{50,60},{0,60},{0,-61}},
            color={0,0,0}),                     Text(
          extent={{-94,-56},{-44,-104}},
          lineColor={0,128,0},
          textStyle={TextStyle.Bold},
          textString="S4"),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-76,94},{-84,72},{-68,72},{-76,94}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-76,72},{-76,-76}}, color={192,192,192}),
        Line(points={{-86,-66},{86,-66}}, color={192,192,192}),
        Polygon(
          points={{94,-66},{72,-58},{72,-74},{94,-66}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-76,62},{-60,62},{62,14}},
          color={255,128,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-76,-28},{-24,-44},{62,-10}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{62,14},{62,-10}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Text(
          extent={{-100,102},{-78,68}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          fontSize=12,
          textString="%V"),
        Text(
          extent={{72,-70},{94,-104}},
          lineColor={135,135,135},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          fontSize=12,
          textString="%Q")}),                                    Diagram(coordinateSystem(preserveAspectRatio=false)),
          Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Partial model/Base class for Q(v)-curves with definiton of input and output ports, but no more insight</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>L1E</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>Input for v and P; output for Q</p>
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
<p>Model created by Jan-Peter Heckel (jan.heckel@tuhh.de), Feb 2019</p>
</html>"));
end Qcurve_empty;
