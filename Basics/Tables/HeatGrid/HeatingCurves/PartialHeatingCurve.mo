within TransiEnt.Basics.Tables.HeatGrid.HeatingCurves;
partial model PartialHeatingCurve "partial model for heating curves, LA"
//________________________________________________________________________________//
// Component of the TransiEnt Library, version: 1.2.0                             //
//                                                                                //
// Licensed by Hamburg University of Technology under Modelica License 2.         //
// Copyright 2019, Hamburg University of Technology.                              //
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends Icons.Model;

  // _____________________________________________
  //
  //               Visible Parameters
  // _____________________________________________

parameter SI.Temperature T_supply_const=363.15;
parameter SI.Temperature T_return_const=323.15;

  // _____________________________________________
  //
  //                 Outer Models
  // _____________________________________________

outer SimCenter simCenter;

  // _____________________________________________
  //
  //             Variable Declarations
  // _____________________________________________

SI.Temperature T_supply;
SI.Temperature T_return;

equation

  annotation (Icon(graphics={
        Rectangle(
          extent={{-50,60},{0,-60}},
          lineColor={255,255,255},
          fillColor={0,134,134},
          fillPattern=FillPattern.Solid),
        Line(points={{-50,-60},{-50,60},{50,60},{50,-60},{-50,-60},{-50,-30},{
              50,-30},{50,0},{-50,0},{-50,30},{50,30},{50,60},{0,60},{0,-61}},
            color={0,0,0}),
        Polygon(
          points={{-70,90},{-78,68},{-62,68},{-70,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-70,68},{-70,-80}}, color={192,192,192}),
        Line(points={{-80,-70},{92,-70}}, color={192,192,192}),
        Polygon(
          points={{100,-70},{78,-62},{78,-78},{100,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,0},{40,60},{56,60},{68,60}},
          color={255,0,0},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Line(
          points={{-70,0},{0,0}},
          color={255,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-70,-30},{-2,-30},{26,-16},{68,0}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.Bezier),
        Text(
          extent={{54,12},{74,0}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="RW"),
        Text(
          extent={{50,74},{70,62}},
          lineColor={255,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="SW"),
        Text(
          extent={{-108,88},{-68,80}},
          lineColor={0,134,134},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="T_grid"),
        Text(
          extent={{66,-80},{106,-88}},
          lineColor={0,134,134},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="T_amb")}),            Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
    Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>A model created for heating curves</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(Description)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>T_supply is the supply temperature</p>
<p>T_return is the return temperature</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no equations)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no validation or testing necessary)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(none)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>(no remarks)</p>
</html>"));
end PartialHeatingCurve;
