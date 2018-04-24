within TransiEnt.Grid.Electrical.Noise.Base;
partial model PartialStochasticGridErrorModel "Base model for prediction errors based on stochastic distributions"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.1.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2018, Hamburg University of Technology.                              //
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
  extends Modelica.Blocks.Interfaces.MO;
annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                             Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,134,134},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),       Text(
          extent={{-84,-46},{-34,-94}},
          lineColor={3,186,0},
          textStyle={TextStyle.Bold},
          textString="S3"),
    Polygon(
      points={{4,96},{-4,74},{12,74},{4,96}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{4,-84},{4,74}}, color={192,192,192}),
    Line(points={{-76,-28},{82,-28}},
                                  color={192,192,192}),
    Polygon(
      points={{104,-28},{82,-36},{82,-20},{104,-28}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
        Polygon(
          points={{4,-28},{-64,-28},{-44,-24},{-28,-18},{-14,2},{-2,34},{4,54},{4,-28}},
          lineColor={0,134,134},
          smooth=Smooth.None,
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{4,-28},{72,-28},{52,-24},{36,-18},{22,2},{10,34},{4,54},{4,-28}},
          lineColor={0,134,134},
          smooth=Smooth.None,
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{4,-28},{-64,-28},{-44,-24},{-28,-18},{-14,2},{-2,34},{4,54},{4,-28}},
          lineColor={0,134,134},
          smooth=Smooth.Bezier,
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{4,-28},{72,-28},{52,-24},{36,-18},{22,2},{10,34},{4,54},{4,-28}},
          lineColor={0,134,134},
          smooth=Smooth.Bezier,
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-6,60},{12,44}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
    Line(points={{4,44},{4,62}},  color={192,192,192})}),
                              Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end PartialStochasticGridErrorModel;
