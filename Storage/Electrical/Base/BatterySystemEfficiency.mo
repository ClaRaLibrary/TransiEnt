within TransiEnt.Storage.Electrical.Base;
model BatterySystemEfficiency "Typical characteristic line of battery system efficiency (including inverter efficiency)"
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

  // _____________________________________________
  //
  //          Imports and Class Hierarchy
  // _____________________________________________

  extends TransiEnt.Basics.Icons.Block;

  // _____________________________________________
  //
  //                Parameters
  // _____________________________________________

  parameter SI.Power P_el_n=1e3 "Storage rated power";
  parameter SI.Efficiency eta_max = 1 "Upper limit of efficiency";
  parameter SI.Efficiency eta_min = 0 "Upper limit of efficiency";

  parameter Real a = 0.1123 "Approximation parameter (determined experimentally)";
  parameter Real b = 1.329 "Approximation parameter (determined experimentally)";
  parameter Real c = 1.284 "Approximation parameter (determined experimentally)";
  parameter Real d = 0.7666 "Approximation parameter (determined experimentally)";

  // _____________________________________________
  //
  //           Instances of other Classes
  // _____________________________________________

   Modelica.Blocks.Interfaces.RealInput P_is "Storage power in W" annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
   Modelica.Blocks.Interfaces.RealOutput eta "Efficiency while charging / discharging"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  // _____________________________________________
  //
  //           Variables
  // _____________________________________________

  Modelica.SIunits.Efficiency eta_cycle "Total cycle efficiency (eta_cycle = eta^2)";
  Real P_star_abs = abs(P_is/P_el_n) "Absolute Storage power in p.u.";
equation
  // _____________________________________________
  //
  //           Characteristic Equations
  // _____________________________________________

  eta_cycle =max(eta_min, min(eta_max, eta_max/d*P_star_abs/(a + b*((P_star_abs))^c)));

  eta = sqrt(eta_cycle);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
                           Text(
          extent={{28,30},{88,-30}},
          lineColor={0,0,0},
          textString=""),
  Line(points={{-88,-82},{84,-82}},
    color={192,192,192}),
  Polygon(lineColor={192,192,192},
    fillColor={192,192,192},
    fillPattern=FillPattern.Solid,
    points={{92,-82},{70,-74},{70,-90},{92,-82}}),
  Line(points={{-70,76},{-70,-92}},
    color={192,192,192}),
  Polygon(lineColor={192,192,192},
    fillColor={192,192,192},
    fillPattern=FillPattern.Solid,
    points={{-78,88},{-86,66},{-70,66},{-78,88}}),
        Line(
          points={{-70,-34},{-64,-34},{-58,-24},{-42,38},{-36,42},{-30,42},{-24,40},{36,14},{78,0}},
          color={0,0,0},
          smooth=Smooth.Bezier)}),
                Documentation(info="<html>
<h4><span style=\"color: #008000\">1. Purpose of model</span></h4>
<p>Typical&nbsp;characteristic&nbsp;line&nbsp;of&nbsp;battery&nbsp;system&nbsp;efficiency&nbsp;(including&nbsp;inverter&nbsp;efficiency.</p>
<h4><span style=\"color: #008000\">2. Level of detail, physical effects considered, and physical insight</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">3. Limits of validity </span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">4. Interfaces</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">5. Nomenclature</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">6. Governing Equations</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">7. Remarks for Usage</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">8. Validation</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">9. References</span></h4>
<p>(no remarks)</p>
<h4><span style=\"color: #008000\">10. Version History</span></h4>
<p>Model created by Pascal Dubucq (dubucq@tuhh.de) <span style=\"font-family: MS Shell Dlg 2;\">on 01.10.2014</span></p>
<p><span style=\"font-family: MS Shell Dlg 2;\">Quality check (Code conventions) by Rebekka Denninger on 01.10.2016</span></p>
</html>"));
end BatterySystemEfficiency;
